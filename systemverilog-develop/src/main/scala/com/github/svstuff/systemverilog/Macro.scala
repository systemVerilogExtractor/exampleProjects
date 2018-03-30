package com.github.svstuff.systemverilog

import collection.mutable.Map
import collection.mutable.ListBuffer

sealed class Defines extends com.typesafe.scalalogging.StrictLogging {

  // map from macro name to define
  val defines = Map[String, Define]()

  def expand(d: Define, actuals: List[ActualParam]) : String = {
    expand0(0, d, actuals)
  }
  def expand0(indent: Int, d: Define, actuals: List[ActualParam]) : String = {
    logger.trace(s"${logIndent(indent)}Expanding define: ${d.id}")
    expandTokens(indent, d.ptokens, actuals)
  }
  def expandTokens(indent: Int, ptokens: List[PToken], actuals: List[ActualParam]) : String = {
    val sb = new StringBuilder
    for ( ptok <- ptokens ) {
      sb ++= expandToken(indent, ptok, actuals)
    }
    sb.toString
  }
  def expandToken(indent: Int, ptoken: PToken, actuals: List[ActualParam]) : String = {
    logger.trace(s"${logIndent(indent)}Expanding token: ${ptoken}")
    ptoken match {
      case PTokenText(text) =>  {
        // simple text token, simply add the text
        text
      }
      case PTokenParam(formal) =>  {
        // formal parameter, expand to actual param
        expandTokens(indent + 1, actuals(formal.index).ptokens, List.empty[ActualParam])
      }
      case PTokenCall(call_parts, call_actuals) =>  {
        // there are two sets of actual parameters here, one is the parameters to the define we
        // are currently expanding and the other is the parameters in the embedded macro call.

        // we need to replace any FormalParam's in the inner call actuals with the ActualParam's
        // of the current define.

        // we also need to assemble the macro id, which could include stuff like
        // `start_of_call_``WAT, where "WAT" is actually a formal parameter to the outer macro.
        val call_name = new StringBuilder
        for ( a <- call_parts ){
          a match {
            case PTokenText(text) => {
              // Ok, so this is the "start_of_call_" part.
              call_name ++= text
            }
            case PTokenParam(formal) => {
              // This would be the "WAT".
              // NOTE: for now just assume there is only one level to this madness.
              call_name ++= expandTokens(indent+1, actuals(formal.index).ptokens, List.empty[ActualParam])
            }
            case _ => assert(false)
          }
        }

        // Ok, we have the full name now, look it up in the macro dictionary.
        val (callee, rest) = defines.get(call_name.toString) match {
          case Some(d) => (d, "")
          case None => macroCallFallback(call_name.toString)
        }

        // recursively expand the callee
        expand0(
          indent + 1,
          callee,
          call_actuals.map(a => propagateOuterActual(indent, a, actuals))) + rest
      }
    }
  }
  def macroCallFallback(fullName: String) : (Define, String) = {
    // Did not find macro for the fully expanded name. See issue #11.
    // Try to find a shorter name for which we do have a macro.
    // FIXME this is a terrible hack, but it's difficult to spend time on a proper solution
    // when the LRM is so vague that I'm not sure what the right behavior should be. For now
    // I will just await more example code that breaks (but works in other parsers).
    val name = fullName.takeWhile( (c) => { c.isLetterOrDigit || c == '_' } )
    return defines.get(name) match {
      case Some(d) => (d, fullName.substring(name.length))
      case None => throw new ExpandError(s"Macro not found: ${name.toString}")
    }
  }
  def propagateOuterActual(indent: Int, inner: ActualParam, outerActuals: List[ActualParam]): ActualParam = {
    val tokens = new ListBuffer[PToken]
    for( tok <- inner.ptokens ){
      tok match {
        case PTokenParam(param) => {
          logger.trace(s"${logIndent(indent)}Inner call, propagating ${param.id}")
          tokens ++= outerActuals(param.index).ptokens
        }
        case PTokenCall(callee, call_actuals) => {
          logger.trace(s"${logIndent(indent)}Inner call, propagating nested call ${callee}")
          val nestedActuals = call_actuals.map(a => propagateOuterActual(indent, a, outerActuals))
          val nestedCall = new PTokenCall(callee, nestedActuals)
          tokens += nestedCall
        }
        case _ => tokens += tok
      }
    }
    new ActualParam(tokens.toList)
  }
  def logIndent(indent: Int) = ".." * indent
}

sealed class ExpandError(val msg: String) extends RuntimeException(msg) {}

sealed class Define(
  val ctx: Context, val line: Int, val col: Int,
  val id: String, val params: List[FormalParam], val ptokens: List[PToken]) {}

sealed class FormalParam(val index: Int, val id: String, val defvalue: Option[String]){}
sealed class ActualParam(val ptokens: List[PToken]){}

// Preprocessor tokens
sealed abstract class PToken { }
case class PTokenText(val text : String) extends PToken {
  override def toString = s"txt: <${text}>"
}
case class PTokenParam(val param : FormalParam) extends PToken {
  override def toString = s"par: ${param.id}"
}
case class PTokenCall(val macroid : Seq[PToken], val actuals : List[ActualParam]) extends PToken {
  override def toString = {
    val sb = new StringBuilder
    sb ++= s"call: id=${macroid}, actuals:"
    for ( a <- actuals ){
      sb ++= "("
      for ( ptok <- a.ptokens ){
        sb ++= ptok.toString
        sb ++= ","
      }
      sb ++= ")"
    }
    sb.toString
  }
}
