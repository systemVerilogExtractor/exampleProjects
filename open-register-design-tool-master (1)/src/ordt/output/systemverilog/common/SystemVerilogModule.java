/*
 * Copyright (c) 2016 Juniper Networks, Inc. All rights reserved.
 */
package ordt.output.systemverilog.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import ordt.extract.Ordt;
import ordt.output.OutputWriterIntf;
import ordt.output.systemverilog.io.SystemVerilogIOElement;
import ordt.output.systemverilog.io.SystemVerilogIOSignalList;
import ordt.output.systemverilog.io.SystemVerilogIOSignalSet;

/** system verilog module generation class
 *  
 * */
public class SystemVerilogModule {
	
	protected OutputWriterIntf writer;
	protected String name;  // module name
	private Integer terminalInsideLocs; // ORed value of (binary) locations that terminate at top level of this module
	protected boolean useInterfaces = false;  // will interfaces be used in module io
	protected List<SystemVerilogParameter> parameterList = new ArrayList<SystemVerilogParameter>(); // list of parameters for this module
	
	
	protected List<SystemVerilogInstance> instanceList = new ArrayList<SystemVerilogInstance>();  // list of child instances
	protected HashMap<String, Integer> childModuleCounts = new HashMap<String, Integer>(); // maintain count of instances by module name
	
	protected List<SystemVerilogIOSignalList> ioList = new ArrayList<SystemVerilogIOSignalList>();  // list of IO lists in this module
	protected HashMap<Integer, SystemVerilogIOSignalList> ioHash = new HashMap<Integer, SystemVerilogIOSignalList>();  // set of writable IO lists in this module

	protected String defaultClkName; // default clock name for this module
	protected HashSet<String> otherClocks; // TODO - need to define this
	protected SystemVerilogSignalList wireDefList;    // list of wires   
	protected SystemVerilogSignalList regDefList;    // list of reg definitions	
	protected List<String> wireAssignList = new ArrayList<String>();    // list of wire assign statements
	protected SystemVerilogRegisters registers;   // set of register info for module
	protected HashSet<String> definedSignals = new HashSet<String>();   // set of all user defined reg/wire names for this module (to check for duplicates/resolve as valid)
	protected List<String> statements = new ArrayList<String>();    // list of free form verilog statements
    protected boolean showDuplicateSignalErrors = true;
    
	protected SystemVerilogCoverGroups coverGroups;   // set of cover group info for module
	protected boolean inhibitCoverageOutput = false;  // inhibit generation of coverage statements within current module (true if an external bind module will be generated)
	static boolean isLegacyVerilog = false;
	    
	/** create a module
	 * @param writer - OutputWriterIntf to be used for output generation 
	 * @param insideLocs - ORed Integer of locations in top level in this module (not including children) 
	 * @param defaultClkName - default clock name used for generated registers
	 */
	public SystemVerilogModule(OutputWriterIntf writer, int insideLocs, String defaultClkName, String coverageResetName) {
		this.writer = writer;  // save reference to calling writer
		setTerminalInsideLocs(insideLocs);  // locations inside this module
		this.defaultClkName = defaultClkName;
		registers = new SystemVerilogRegisters(writer, defaultClkName);
		wireDefList = new SystemVerilogSignalList();
		regDefList = new SystemVerilogSignalList();
		coverGroups = new SystemVerilogCoverGroups(writer, defaultClkName, coverageResetName);  // TODO - need to change cover reset if separate logic reset is being used
	}

	// ------------------- get/set -----------------------
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static boolean isLegacyVerilog() {
		return isLegacyVerilog;
	}

	public static void setLegacyVerilog(boolean isLegacyVerilog) {
		SystemVerilogModule.isLegacyVerilog = isLegacyVerilog;
	}

	public void setShowDuplicateSignalErrors(boolean showDuplicateSignalErrors) {
		this.showDuplicateSignalErrors = showDuplicateSignalErrors;
	}

	public boolean useInterfaces() {
		return useInterfaces;
	}

	/** return encoded integer of locations that terminate at top level of current module */
	protected Integer getTerminalInsideLocs() {
		return terminalInsideLocs;
	}

	/** return encoded integer of all locations in this module's children */
	protected Integer getChildLocs() {
		Integer childLocs = 0;
		for(SystemVerilogInstance inst: instanceList) {
			//System.out.println("SystemVerilogModule getChildLocs: child=" + inst.getName() + " of " + inst.getMod().getName() /*+ ", insideLocs=" + inst.getMod().getInsideLocs() */);
			childLocs = childLocs | inst.getMod().getInsideLocs();
		}
		return childLocs;
	}

	/** return encoded integer of all locations inside this module and its children */
	public Integer getInsideLocs() {
		Integer myInsideLocs = terminalInsideLocs | getChildLocs();
		//if (terminalInsideLocs==0) System.out.println("SystemVerilogModule getInsideLocs: name=" + getName() + ", insideLocs=" + myInsideLocs + ", terminalInsideLocs=" + terminalInsideLocs + ", children=" + instanceList.size());
		return myInsideLocs;
	}

	protected void setTerminalInsideLocs(Integer terminalInsideLocs) {
		this.terminalInsideLocs = terminalInsideLocs;
		//System.out.println("SystemVerilogModule setTerminalInsideLocs: name=" + getName() + ", insideLocs=" + terminalInsideLocs + ", children=" + instanceList.size());
	}

	/** return encoded integer of all locations outside this module and its children */
	public Integer getOutsideLocs() {
		return ~getInsideLocs();
	}

	public void setUseInterfaces(boolean useInterfaces) {
		this.useInterfaces = useInterfaces;
	}

	// ------------------- wire/reg assign methods -----------------------

	/** add a wire assign statement */
	public void addWireAssign(String assignString) {
		wireAssignList.add(assignString);
	}

	/** add a list of wire assign statements */
	public void addWireAssigns(List<String> assignList) {
		wireAssignList.addAll(assignList);		
	}

	/** return the list of wire assigns */
	public List<String> getWireAssignList() {
		return wireAssignList;
	}

	/** add a combinatorial reg assign */
	public void addCombinAssign(String groupName, String assign) {
		registers.get(groupName).addCombinAssign(assign);  
	}

	/** add a list of combinatorial reg assigns */
	public void addCombinAssign(String groupName, List<String> assignList) {
		registers.get(groupName).addCombinAssign(assignList);  
	}

	/** add a combinatorial reg assign with specified precedence */
	public void addPrecCombinAssign(String groupName, boolean hiPrecedence, String assign) {
		registers.get(groupName).addPrecCombinAssign(hiPrecedence, assign);		
	}

	/** add a sequential reg assign */
	public void addRegAssign(String groupName, String assign) {
		 registers.get(groupName).addRegAssign(assign);
	}

	public SystemVerilogRegisters getRegisters() {
		return registers;
	}

	/** add a reset to this modules reg group */
	public void addReset(String resetName, boolean activeLow) {
		registers.addReset(resetName, activeLow);
	}

	/** add a reset assign to this modules reg group */
	public void addResetAssign(String groupName, String resetName, String assign) {
		registers.get(groupName).addResetAssign(resetName, assign);
	}

	/** add a wire define */
	public void addVectorWire(String name, int idx, Integer width) {
		if (addDefinedSignal(name)) wireDefList.addVector(name, idx, width);	
	}

	/** add a scalar wire define */
	public void addScalarWire(String name) {
		if (addDefinedSignal(name)) wireDefList.addScalar(name);	
	}

    /** add a list of signals to the wire def list - unroll the loop for uniqueness check */
	public void addWireDefs(List<SystemVerilogSignal> wireList) {
		for (SystemVerilogSignal sig : wireList) addVectorWire(sig.getName(), sig.getLowIndex(), sig.getSize());
	}
	
	/** return the list of defined wires */
	public SystemVerilogSignalList getWireDefList() {
		return wireDefList;
	}

	/** add a reg define */
	public void addVectorReg(String name, int idx, Integer width) {
		if (addDefinedSignal(name)) regDefList.addVector(name, idx, width);	
	}

	/** add a scalar reg define */
	public void addScalarReg(String name) {
		if (addDefinedSignal(name)) regDefList.addScalar(name);	
	}

	public void addRegDefs(SystemVerilogSignalList regList) {
		addRegDefs(regList.getSignalList());		
	}

    /** add a list of signals to the reg def list - unroll the loop for uniqueness check */
	public void addRegDefs(List<SystemVerilogSignal> regList) {
		for (SystemVerilogSignal sig : regList) addVectorReg(sig.getName(), sig.getLowIndex(), sig.getSize());
	}

	/** return the list of defined regs */
	public SystemVerilogSignalList getRegDefList() {
		return regDefList;
	}

	/** add a signal to list and check for uniqueness
	 *  returns true on success                          */
	public boolean addDefinedSignal(String name) {
		if (definedSignals.contains(name)) {
			if (showDuplicateSignalErrors) Ordt.errorMessage("Duplicate SystemVerilog signal " + name + " detected (possibly due to a repeated instance name)");
			//if (name.startsWith("leaf_dec")) System.out.println("SystemVerilogModule addDefinedSignal: not adding " + name + " to module " + getName() + " signal list");
		}
		else {
			definedSignals.add(name);
			/* if (name.startsWith("leaf_dec"))*/ //System.out.println("SystemVerilogModule addDefinedSignal: adding " + name + " to module " + getName() + " signal list");
			return true;
		}
		//System.out.println("SystemVerilogModule addDefinedSignal: adding " + name + " to module signal list");
		return false;
	}
	
	/** return true if specified signal name is in the definedSignal set */
	public boolean hasDefinedSignal(String name) {
		return definedSignals.contains(name);
	}
	
	public SystemVerilogCoverGroups getCoverGroups() {
		return coverGroups;
	}

	public void setCoverGroups(SystemVerilogCoverGroups coverGroups) {
		this.coverGroups = coverGroups;
	}

	public void setInhibitCoverageOutput(boolean inhibitCoverageOutput) {
		this.inhibitCoverageOutput = inhibitCoverageOutput;
	}

	/** create a coverpoint and add it to specified covergroup in this module
	 *  @param group - name of covergroup
	 *  @param name - name of new coverpoint
	 *  @param signal - signal to be sampled
	 */
	public void addCoverPoint(String group, String name, String signal, int size, String condition) {
		coverGroups.addCoverPoint(group, name, signal, size, condition);
	}
	// ------------------- parameter classes/methods  -----------------------
	
	// nested parameter class
	private class SystemVerilogParameter {
		private String name;
		private String defaultValue;
		
		private SystemVerilogParameter(String name, String defaultValue) {
			super();
			this.name = name;
			this.defaultValue = defaultValue;
		}
		
		/** return define string for this parameter */
		public String toString() {
			String defaultStr = (defaultValue != null)? " = " + defaultValue : "";
			return "parameter " + name + defaultStr + ";";
		}
		
		/** return the name of this parameter */
		public String getName() {
			return name;
		}
	}

	/** add a parameter to this module
	 * 
	 * @param name - parameter name
	 * @param defaultValue - default value of this parameter or null if none
	 */
	public void addParameter(String name, String defaultValue) {
		parameterList.add(new SystemVerilogParameter(name, defaultValue));
	}

	protected List<SystemVerilogParameter> getParameterList() {
		return parameterList;
	}

	/** return parameter instance string for this module (assumes parms are passed up to parent level) */
	private String getParameterInstanceString() {
		String retStr = (!parameterList.isEmpty())? "#(" : "";
		Iterator<SystemVerilogParameter> iter = parameterList.iterator();
		while(iter.hasNext()) {
			String parmName = iter.next().getName();
			String suffix = iter.hasNext()? ", " : ") ";
			retStr += parmName + suffix;
		}
		return retStr;
	}
	
	/** inherit unique parameters from this module's children */
	public void inheritChildParameters() {
		HashSet<String> uniqueParms = new HashSet<String>(); 
		// add unique child parameters to this module
		for (SystemVerilogInstance inst: instanceList) {
			for (SystemVerilogParameter parm: inst.getMod().getParameterList()) {
				if (!uniqueParms.contains(parm.getName())) {
					uniqueParms.add(parm.getName());  // save parameter in unique list
					parameterList.add(parm); // add parm to the list
				}
			}
		}
	}

	// ------------------- IO methods  -----------------------

	/** add an IO list to be used by this module
	 * 
	 * @param sigList - list to be added
	 * @param remoteLocation - optional location, created signals to/from this loc will be added to this list
	 */
	public void useIOList(SystemVerilogIOSignalList sigList, Integer remoteLocation) {
		//System.out.println("SystemVerilogModule useIOList: adding io siglist with " + sigList.size());
		ioList.add(sigList);
		if (remoteLocation != null) ioHash.put(remoteLocation, sigList);
	}

	/** return a single combined IO List for the module */
	public SystemVerilogIOSignalList getFullIOSignalList() {
		SystemVerilogIOSignalList retList = new SystemVerilogIOSignalList("full");	
		// add io lists
		for (SystemVerilogIOSignalList list : ioList)
		   retList.addList(list);
		return retList;
	}
	
	/** return inputs for this module (signal sets are included) */ 
	public List<SystemVerilogIOElement> getInputList() {
		SystemVerilogIOSignalList fullList = getFullIOSignalList();	// start with the full list
		return useInterfaces ? fullList.getDescendentIOElementList(null, getInsideLocs(), false) :
			                     fullList.getIOElementList(getOutsideLocs(), getInsideLocs());
	}
	
	/** return inputs for this module (signal sets are not included) */ 
	public List<SystemVerilogIOElement> getOutputList() {
		SystemVerilogIOSignalList fullList = getFullIOSignalList();	// start with the full list
		return useInterfaces ? fullList.getDescendentIOElementList(getInsideLocs(), null, true) : 
                                 fullList.getIOElementList(getInsideLocs(), getOutsideLocs());
	}
	
	/** return inputs for this module */ 
	public List<SystemVerilogIOElement> getInputOutputList() {
		List<SystemVerilogIOElement> retList = new ArrayList<SystemVerilogIOElement>();
		retList.addAll(getInputList());
		retList.addAll(getOutputList());
		return retList;
	}

	/** return a list of non-interface signals in this module matching the from/to constraint
	 * @param from location
	 * @param to location
	 * @return - list of SystemVerilogSignals
	 */
	public List<SystemVerilogSignal> getSignalList(Integer from, Integer to) {
		SystemVerilogIOSignalList fullList = getFullIOSignalList();	// start with the full list
		return fullList.getSignalList(from, to);
	}
	
	/** return a list of strings defining this module's IO (systemverilog format) */ 
	public List<String> getIODefStrList() {
		List<String> outList = new ArrayList<String>();
		List<SystemVerilogIOElement> inputList = getInputList();
		List<SystemVerilogIOElement> outputList = getOutputList();
		Boolean hasOutputs = (outputList.size() > 0);
		outList.add("(");
		// generate input def list
		Iterator<SystemVerilogIOElement> it = inputList.iterator();
		while (it.hasNext()) {
			SystemVerilogIOElement elem = it.next();
			String suffix = (it.hasNext() || hasOutputs) ? "," : " );";
			outList.add("  " + elem.getIODefString(true, "input   ") + suffix);
		}		   	
		// generate output def list
		outList.add("");
		it = outputList.iterator();
		while (it.hasNext()) {
			SystemVerilogIOElement elem = it.next();
			String suffix = (it.hasNext()) ? "," : " );";
			outList.add("  " + elem.getIODefString(true, "output   ") + suffix);
		}		   	
		return outList;
	}
	
	/** return a list of strings listing this module's IO (verilog compatible module IO format) */ 
	public List<String> getLegacyIOStrList() {
		List<String> outList = new ArrayList<String>();
		List<SystemVerilogIOElement> inputList = getInputList();
		List<SystemVerilogIOElement> outputList = getOutputList();
		Boolean hasOutputs = (outputList.size() > 0);
		outList.add("(");
		// generate input sig list
		Iterator<SystemVerilogIOElement> it = inputList.iterator();
		while (it.hasNext()) {
			SystemVerilogIOElement elem = it.next();
			String suffix = (it.hasNext() || hasOutputs) ? "," : " );";
			if (!elem.isSignalSet())  outList.add("  " + elem.getFullName() + suffix);				
		}		   	
		// generate output sig list
		outList.add("");
		it = outputList.iterator();
		while (it.hasNext()) {
			SystemVerilogIOElement elem = it.next();
			String suffix = (it.hasNext()) ? "," : " );";
			if (!elem.isSignalSet())   outList.add("  " + elem.getFullName() + suffix);		
		}		   	
		return outList;
	}
	
	/** return a list of strings defining this module's IO (verilog compatible module IO format) */
	public List<String> getLegacyIODefStrList() {
		List<String> outList = new ArrayList<String>();
		List<SystemVerilogIOElement> inputList = getInputList();
		List<SystemVerilogIOElement> outputList = getOutputList();
		outList.add("  //------- inputs");
		// generate input def list
		Iterator<SystemVerilogIOElement> it = inputList.iterator();
		while (it.hasNext()) {
			SystemVerilogIOElement elem = it.next();
			if (!elem.isSignalSet())   outList.add("  " + elem.getIODefString(true, "input   ") + ";");
		}		   	
		outList.add("");
		// generate output def list
		outList.add("  //------- outputs");
		it = outputList.iterator();
		while (it.hasNext()) {
			SystemVerilogIOElement elem = it.next();
			if (!elem.isSignalSet())   outList.add("  " + elem.getIODefString(true, "output   ") + ";");
		}		   	
		outList.add("");
		return outList;
	}
	
	// simple non-hierarchical IO adds
	
	/** add a new simple scalar IO signal to the specified external location list */
	public void addSimpleScalarTo(Integer to, String name) {
		this.addSimpleVectorTo(to, name, 0, 1);
	}

	/** add a new simple scalar IO signal from the specified external location list */
	public void addSimpleScalarFrom(Integer from, String name) {
		this.addSimpleVectorFrom(from, name, 0, 1);
	}

	/** add a new simple vector IO signal to the specified external location list */
	public void addSimpleVectorTo(Integer to, String name, int lowIndex, int size) {
		SystemVerilogIOSignalList sigList = ioHash.get(to);  // get the siglist
		if (sigList == null) return;
		sigList.addSimpleVector(getInsideLocs(), to, name, lowIndex, size); 
	}

	/** add a new simple vector IO signal from the specified external location list */
	public void addSimpleVectorFrom(Integer from, String name, int lowIndex, int size) {
		SystemVerilogIOSignalList sigList = ioHash.get(from);  // get the siglist
		if (sigList == null) return;
		if (addDefinedSignal(name)) sigList.addSimpleVector(from, getInsideLocs(), name, lowIndex, size); 
	}
	
	// hierarchical IO adds
	
	/** add a new scalar IO signal to the specified external location list */
	public void addScalarTo(Integer to, String prefix, String name) {
		this.addVectorTo(to, prefix, name, 0, 1);
	}

	/** add a new scalar IO signal from the specified external location list */
	public void addScalarFrom(Integer from, String prefix, String name) {
		this.addVectorFrom(from, prefix, name, 0, 1);
	}
	
	/** add a new vector IO signal to the specified external location list */
	public void addVectorTo(Integer to, String prefix, String name, int lowIndex, int size) {
		SystemVerilogIOSignalList sigList = ioHash.get(to);  // get the siglist
		if (sigList == null) return;
		sigList.addVector(getInsideLocs(), to, prefix, name, lowIndex, size);
	}
	
	/** add a new vector IO signal from the specified external location list */
	public void addVectorFrom(Integer from, String prefix, String name, int lowIndex, int size) {
		SystemVerilogIOSignalList sigList = ioHash.get(from);  // get the siglist
		if (sigList == null) return;
		sigList.addVector(from, getInsideLocs(), prefix, name, lowIndex, size);
	}
	
	/** push IO hierarchy to active stack in specified list
	 *   @param useFrom - if true the from location will be used to look up signal list to be updated, otherwise to location is used
	 */
	public SystemVerilogIOSignalSet pushIOSignalSet(boolean useFrom, Integer from, Integer to, String namePrefix, String name, int reps, boolean isFirstRep, boolean isIntf, boolean isStruct, String extType, String compId) {
		Integer locidx = useFrom? from : to;
		SystemVerilogIOSignalList sigList = ioHash.get(locidx);  // get the siglist
		if (sigList == null) return null;
		return sigList.pushIOSignalSet(from, to, namePrefix, name,  reps,  isFirstRep,  isIntf, isStruct, extType, compId); 
	}
	
	/** pop IO hierarchy from active stack in specified list */
	public void popIOSignalSet(Integer loc) {
		SystemVerilogIOSignalList sigList = ioHash.get(loc);  // get the siglist
		if (sigList == null) return;
		sigList.popIOSignalSet(); 
	}
	
    /** add a freeform statement to this module */
	public void addStatement(String stmt) { 
		statements.add(stmt);
	}

	// ------------------- child instance methods/classes  -----------------------

	public SystemVerilogInstance addInstance(SystemVerilogModule mod, String name) {
		return addInstance(mod, name, null);
		//System.out.println("SystemVerilogModule addInstance: adding instance " + name + " of " + mod.getName() + " to " + getName() + ", child #=" + instanceList.size());
	}
	
	public SystemVerilogInstance addInstance(SystemVerilogModule mod, String name, RemapRuleList rules) {
        SystemVerilogInstance newInst = (rules==null)? new SystemVerilogInstance(mod, name) :
        	new SystemVerilogInstance(mod, name, rules);
		// add the instance 
		instanceList.add(newInst);
		// update count by module
		String modName=mod.getName();
		if (!childModuleCounts.containsKey(modName))
			childModuleCounts.put(modName, 1);  // add new module
		else
			childModuleCounts.put(modName, childModuleCounts.get(modName) + 1);  // bump module count
		//System.out.println("SystemVerilogModule addInstance: adding rules instance " + name + " of " + mod.getName() + " to " + getName() + ", child #=" + instanceList.size());
        return newInst;
	}
	
	/** return the number of child modules having specified name */
	public int getChildModuleCount(String modName) {
		if (!childModuleCounts.containsKey(modName)) return 0;
		else return childModuleCounts.get(modName);
	}
	
	/** return true if more than one child modules having specified name */
	public boolean childModuleHasMultipleInstances(String modName) {
		return getChildModuleCount(modName) > 1;
	}
		
	// ------------------- output write methods  -----------------------

	/** write module stmt */
	public  void writeModuleBegin(int indentLevel) {
		writer.writeStmt(indentLevel, "//");
		writer.writeStmt(indentLevel, "//---------- module " + getName());
		writer.writeStmt(indentLevel, "//");
		writer.writeStmt(indentLevel, "module " + getName());		
	}

	/** write module stmt w no io */
	public  void writeNullModuleBegin(int indentLevel) {
		writer.writeStmt(indentLevel, "//");
		writer.writeStmt(indentLevel, "//---------- module " + getName());
		writer.writeStmt(indentLevel, "//");
		writer.writeStmt(indentLevel, "module " + getName() + " ( );");		
	}
	
	/** write module end */
	public  void writeModuleEnd(int indentLevel) {
		writer.writeStmt(indentLevel, "endmodule\n");	
	}

	/** write wire define stmts */
	public  void writeWireDefs(int indentLevel) {
		List<String> defList = wireDefList.getDefNameList();
		if (defList.isEmpty()) return;
		writer.writeStmt(indentLevel, "//------- wire defines");
		Iterator<String> it = defList.iterator();
		while (it.hasNext()) {
			String elem = it.next();
			    if (isLegacyVerilog) writer.writeStmt(indentLevel, "wire  " + elem + ";");  
			    else writer.writeStmt(indentLevel, "logic  " + elem + ";");  
		}		   	
		writer.writeStmt(indentLevel, "");  		
	}

	/** write reg define stmts */
	public  void writeRegDefs(int indentLevel) {
		List<String> defList = regDefList.getDefNameList();
		if (defList.isEmpty()) return;
		writer.writeStmt(indentLevel, "//------- reg defines");
		Iterator<String> it = defList.iterator();
		while (it.hasNext()) {
			String elem = it.next();
			if (isLegacyVerilog) writer.writeStmt(indentLevel, "reg  " + elem + ";");
			else writer.writeStmt(indentLevel, "logic  " + elem + ";");  
		}		   	
		writer.writeStmt(indentLevel, "");  		
	}

	/** write assign stmts  */
	public  void writeWireAssigns(int indentLevel) {
		if (wireAssignList.isEmpty()) return;
		writer.writeStmt(indentLevel, "//------- assigns");
		Iterator<String> it = wireAssignList.iterator();
		while (it.hasNext()) {
			String elem = it.next();
			writer.writeStmt(indentLevel, "assign  " + elem);  
		}		   	
		writer.writeStmt(indentLevel, "");  		
	}
	
	/** write always block assign stmts  */
	public  void writeBlockAssigns(int indentLevel) {
		registers.writeVerilog(indentLevel);  // write always blocks for each group
	}
	
	/** write cover group stmts  */
	public  void writeCoverGroups(int indentLevel) {
		if (!(isLegacyVerilog || inhibitCoverageOutput)) {
			coverGroups.write(indentLevel);  // write for each covergroup
		}
	}
	
	/** write write IO definitions for this module
	 * @param indentLevel
	 * @param showInterfaces - if true include interfaces in output, else output encapsulated logic signals
	 */
	public void writeIOs(int indentLevel) {
		// add the IO list
		if (useInterfaces) writer.writeStmts(indentLevel+1, getIODefStrList());   // sv format
		else writer.writeStmts(0, getLegacyIOStrList()); // legacy vlog io format
		writer.writeStmt(0, "");

		// write IO definitions - legacy form
		if (!useInterfaces) {
			writer.writeStmts(0, getLegacyIODefStrList());  // legacy vlog io format
			writer.writeStmt(0, "");
		}
		
		// add parameter defines if specified
		if (!parameterList.isEmpty()) {
			writer.writeStmt(indentLevel, "//------- parameters");
			for (SystemVerilogParameter parm: parameterList) writer.writeStmt(indentLevel, parm.toString());
			writer.writeStmt(0, "");
		}
	}

	/** write each child instance in this module */
	public void writeChildInstances(int indentLevel) {
		for (SystemVerilogInstance inst : instanceList) {
			//System.out.println("SystemVerilogModule writeChildInstances: inst=" + inst.getName());
			inst.getMod().writeInstance(indentLevel, inst);
		}		
	}

	/** write an instance of this module */
	public void writeInstance(int indentLevel, SystemVerilogInstance inst) {
		List<SystemVerilogIOElement> childList = this.getInputOutputList();
		if (childList.isEmpty()) return;
	    if (isLegacyVerilog || inst.hasRemapRules()) {
			writer.writeStmt(indentLevel++, this.getName() + " " + getParameterInstanceString() + inst.getName() + " (");   // more elements so use comma
			Iterator<SystemVerilogIOElement> it = childList.iterator();
			while (it.hasNext()) {
				SystemVerilogIOElement elem = it.next();
				String suffix = it.hasNext()? ")," : ") );";
				String remappedSignal = inst.getRemappedSignal(elem.getFullName(), elem.getFrom(), elem.getTo());
				writer.writeStmt(indentLevel, "." + elem.getFullName() + "(" + remappedSignal + suffix); 
			}		   		    	
	    }
	    else {
			writer.writeStmt(indentLevel++, this.getName() + " " + getParameterInstanceString() + inst.getName() + " ( .* );");   // more elements so use comma	    	
	    }
		writer.writeStmt(indentLevel--, "");   
	}

	/** write any free form statements */
	public void writeStatements(int indentLevel) {
		for (String stmt : statements) writer.writeStmt(indentLevel, stmt);
		writer.writeStmt(indentLevel, "");	
	}

	/** write this module */
	public void write() {
		// start the module
		int indentLevel = 0;
		writeModuleBegin(indentLevel);
		indentLevel++;
		
		// write internal structures
		writeModuleInternals(indentLevel);

		indentLevel--;
		writeModuleEnd(indentLevel);
	}

	/** write module internal structures */
	protected void writeModuleInternals(int indentLevel) {
		
		// write inputs, outputs
		writeIOs(indentLevel);
		
		// write wire define stmts
		writeWireDefs(indentLevel);
		
		// write ff define stmts
		writeRegDefs(indentLevel);
		
		// write free form statements
		writeStatements(indentLevel);
		
		// write assign stmts
		writeWireAssigns(indentLevel);  
		
		// write block assign stmts
		writeBlockAssigns(indentLevel);  
		
		// write the child instances
		writeChildInstances(indentLevel);
		
		// write the coverage groups
		writeCoverGroups(indentLevel);
	}

}
