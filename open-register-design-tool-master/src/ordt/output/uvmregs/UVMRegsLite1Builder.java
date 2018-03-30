package ordt.output.uvmregs;

import java.util.Iterator;
import java.util.List;

import ordt.extract.Ordt;
import ordt.extract.RegModelIntf;
import ordt.extract.RegNumber;

import ordt.output.FieldProperties;
import ordt.output.OutputLine;

import ordt.parameters.ExtParameters;

/** lightweight uvm regs model -
 * 
 * - uses only a single uvm_reg_field for expect data storage (width of register)
 * - assumes all fields in a reg have a single access mode
 * - no field subclasses and associated info (interrupts, counters, etc)
 * - no register interaction callbacks supported ()
 * - no backdoor access/path defines
 * - no user-defined properties/test related reg info
 *
 */
public class UVMRegsLite1Builder extends UVMRegsBuilder {

	public UVMRegsLite1Builder(RegModelIntf model) {
		super(model);
	}

	// --------------------------- package setup methods ------------------------
	
	/** generate package import statements */
	@Override
	protected void generatePkgImports() {
		outputList.add(new OutputLine(indentLvl, "import uvm_pkg::*;"));
		outputList.add(new OutputLine(indentLvl, "import ordt_uvm_reg_lite1_pkg::*;"));
	}

    //---------------------------- helper methods saving child info for parent build --------------------------------------

	/** save register info for use in parent uvm_reg_block class - no callbacks,coverage */
	@Override
	protected void saveRegInfo(String uvmRegClassName) {
		// get parent name
		String parentID = this.getParentInstancePath().replace('.', '_');
		// escape id and alias names
		String regId = escapeReservedString(regProperties.getId());
		//String aliasedId = escapeReservedString(regProperties.getAliasedId());
		// save register define statements
		String repStr = (regProperties.isReplicated()) ? "[" + regProperties.getRepCount() + "]" : "";
		subcompDefList.addStatement(parentID, "rand " + uvmRegClassName + " " + regId + repStr + ";");
		
		// save register build statements
		addRegToBuildList(uvmRegClassName, parentID, regId);
		//System.out.println("UVMBuild saveRegInfo: " + regProperties.getBaseName() + ", parent=" + parentID + ", rel addr=" + regProperties.getRelativeBaseAddress());
	}

	/** create block build statements adding current register - no hdl_path/rdl_tag/external/defined property setup */
	@Override
	protected void addRegToBuildList(String uvmRegClassName, String parentID, String regId) {
		String addr = "`UVM_REG_ADDR_WIDTH" + regProperties.getRelativeBaseAddress().toFormat(RegNumber.NumBase.Hex, RegNumber.NumFormat.NoLengthVerilog);
		if (regProperties.isReplicated()) {
			subcompBuildList.addStatement(parentID, "foreach (this." + regId + "[i]) begin");
			if (ExtParameters.uvmregsRegsUseFactory()) subcompBuildList.addStatement(parentID, "  this." + regId + "[i] = " + uvmRegClassName + "::type_id::create($psprintf(\"" + regId + " [%0d]\",i));");
			else subcompBuildList.addStatement(parentID, "  this." + regId + "[i] = new($psprintf(\"" + regProperties.getId() + " [%0d]\",i));");  
			subcompBuildList.addStatement(parentID, "  this." + regId + "[i].configure(this, null, \"\");");  
			subcompBuildList.addStatement(parentID, "  this." + regId + "[i].build();");
			subcompBuildList.addStatement(parentID, "  this.default_map.add_reg(this." + regId + "[i], " + addr + "+i*" + getRegAddrIncr() + ", \"" + getRegAccessType() + "\", 0);");						
			subcompBuildList.addStatement(parentID, "end");
		}
		else {
			if (ExtParameters.uvmregsRegsUseFactory()) subcompBuildList.addStatement(parentID, "this." + regId + " = " + uvmRegClassName + "::type_id::create(\"" + regId + "\");");
			else subcompBuildList.addStatement(parentID, "this." + regId + " = new(\"" + regProperties.getId() + "\");");  
			subcompBuildList.addStatement(parentID, "this." + regId + ".configure(this, null, \"\");"); 
			subcompBuildList.addStatement(parentID, "this." + regId + ".build();");
			subcompBuildList.addStatement(parentID, "this.default_map.add_reg(this." + regId + ", " + addr + ", \"" + getRegAccessType() + "\", 0);");			
		}	
	}

	/** save memory info for use in parent uvm_reg_block class - no category, coverage
	 * @param parentIsWrapper - if true, info will be saved to a wrapper block and reg/mem instance names will be changed
	 */
	@Override
	protected void saveMemInfo(boolean parentIsWrapper) {
		// get parent block name (use reg name if a wrapper is being used)
		String parentID = parentIsWrapper? regProperties.getInstancePath().replace('.', '_') : this.getParentInstancePath().replace('.', '_'); 
		// set vreg instance id
		String regId = parentIsWrapper? "vregs" : regProperties.getId();
		// escape id name
		String escapedRegId = escapeReservedString(regId);
		// build the memory Id
		String memId = parentIsWrapper? "mem" : "MEM_" + regProperties.getId();
		// save memory and vreg define statements
		subcompDefList.addStatement(parentID, "rand uvm_mem " + memId + ";");   // the memory 
		subcompDefList.addStatement(parentID, "rand " + getUVMVRegID() + " " + escapedRegId + ";");   // virtual regs
		//System.out.println("UVMRegsBuilder saveMemInfo: saving statements into wrapper parentID=" + parentID);
		// save virtual register and mem build statements
		addMemToBuildList(parentID, memId, escapedRegId);

		// add the memory to the address map  (no offset if in a wrapper block)
		String addrString = parentIsWrapper? "`UVM_REG_ADDR_WIDTH'h0" :
		                                     "`UVM_REG_ADDR_WIDTH" + regProperties.getRelativeBaseAddress().toFormat(RegNumber.NumBase.Hex, RegNumber.NumFormat.NoLengthVerilog);
		subcompBuildList.addStatement(parentID, "this.default_map.add_mem(this." + memId + ", " + addrString + ");");						
	}
	
	/** create block build statements adding current register - no reset */
	@Override
	protected void addMemToBuildList(String parentID, String memId, String escapedRegId) {
		// save mem build statements for uvm_reg_block
		subcompBuildList.addStatement(parentID, "this." + memId + " = new(\"" + memId + "\", " + regProperties.getRepCount() + ", " + regProperties.getRegWidth() + ");");  
		subcompBuildList.addStatement(parentID, "this." + memId + ".configure(this);");  
		
		// save vreg build statements for uvm_reg_block  
		subcompBuildList.addStatement(parentID, "this." + escapedRegId + " = new;");  
		subcompBuildList.addStatement(parentID, "this." + escapedRegId + ".configure(this, " + memId + ", " + regProperties.getRepCount() + ");"); 
		
		//System.out.println("UVMRegsBuilder saveMemInfo: regid=" + regId + ", memid=" + memId + ", reg reps=" + regProperties.getRepCount() + ", inst reps=" + getVRegReps());
		subcompBuildList.addStatement(parentID, "this." + escapedRegId + ".build();");		
	}

	/** save register set info for use in parent uvm_reg_block class - no extensions/addrmap/hdl_path/user-defined props  
	 * @param uvmBlockClassName - name of uvm block class
	 * @param blockIdOverride - if non null, specified name will be used as the block instance rather then regset id
	 *        - regSetProperties (replication, is addrmap) will be ignored if a name override is specified
	 *        (this is used for uvm_mem wrapper block gen)
	 * @param addrOffsetOverride - if non null, specified address offset will be used rather than current regset offset
	 */
	@Override
	protected void saveRegSetInfo(String uvmBlockClassName, String blockIdOverride, RegNumber addrOffsetOverride) {
		// get parent name
		String parentID = this.getParentInstancePath().replace('.', '_');
		// block id
		boolean hasInstanceNameOverride = (blockIdOverride != null);
		String blockId = hasInstanceNameOverride? blockIdOverride : regSetProperties.getId();
		// escaped block id 
		String escapedBlockId = escapeReservedString(blockId);
		// save block define statements
		String repStr = (!hasInstanceNameOverride && regSetProperties.isReplicated()) ? "[" + regSetProperties.getRepCount() + "]" : "";
		subcompDefList.addStatement(parentID, "rand " + uvmBlockClassName + " " + escapedBlockId + repStr + ";");
		// set address offset for new block
		RegNumber addr = (addrOffsetOverride != null)? addrOffsetOverride : regSetProperties.getRelativeBaseAddress();
		String addrStr = "`UVM_REG_ADDR_WIDTH" + addr.toFormat(RegNumber.NumBase.Hex, RegNumber.NumFormat.NoLengthVerilog);
		// save register build statements
		if (!hasInstanceNameOverride && regSetProperties.isReplicated()) {  
			subcompBuildList.addStatement(parentID, "foreach (this." + escapedBlockId + "[i]) begin");
			if (ExtParameters.uvmregsRegsUseFactory()) subcompBuildList.addStatement(parentID, "  this." + escapedBlockId + "[i] = " + uvmBlockClassName + "::type_id::create($psprintf(\"" + blockId + " [%0d]\",i),, get_full_name());");
			else subcompBuildList.addStatement(parentID, "  this." + escapedBlockId + "[i] = " + "new($psprintf(\"" + blockId + " [%0d]\",i));");
			subcompBuildList.addStatement(parentID, "  this." + escapedBlockId + "[i].configure(this, \"\");");  
			subcompBuildList.addStatement(parentID, "  this." + escapedBlockId + "[i].build();");
			subcompBuildList.addStatement(parentID, "  this.default_map.add_submap(this." + escapedBlockId + "[i].default_map, " + addrStr + "+i*" + getRegSetAddrIncrString() + ");");						
			subcompBuildList.addStatement(parentID, "end");
		}
		else {
			if (ExtParameters.uvmregsRegsUseFactory()) subcompBuildList.addStatement(parentID, "this." + escapedBlockId + " = " + uvmBlockClassName + "::type_id::create(\"" + blockId + "\",, get_full_name());");
			else subcompBuildList.addStatement(parentID, "this." + escapedBlockId + " = " + "new(\"" + blockId + "\");");
		   subcompBuildList.addStatement(parentID, "this." + escapedBlockId + ".configure(this, \"\");"); 
		   subcompBuildList.addStatement(parentID, "this." + escapedBlockId + ".build();");
		   subcompBuildList.addStatement(parentID, "this.default_map.add_submap(this." + escapedBlockId + ".default_map, " + addrStr + ");");			
		}		
		//System.out.println("UVMBuild saveRegSetInfo: " + regSetProperties.getBaseName() + ", parent=" + parentID + ", rel addr=" + regSetProperties.getRelativeBaseAddress());
	}
	
	// ----------------------- lite1 class builder methods -------------------------

	/** generate package info (overridden by child uvm builder classes) */
	@Override
	protected void buildRdlPackage() {
		UVMRdlLite1Classes.buildRdlPackage(pkgOutputList, 0);		
	}

	/** build reg class definition for current register instance */   
	@Override
	protected void buildRegClass(String uvmRegClassName) {
		// create text name and description if null
		String id = regProperties.getId();
		String textName = regProperties.getTextName();
		if (textName == null) textName = "Register " + id;
		else textName = textName.replace('\n', ' ');
		
		// generate register header 
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl, "// " + textName));
		outputList.add(new OutputLine(indentLvl++, "class " + uvmRegClassName + " extends uvm_reg_lite;")); 
		
		// create field definitions
		buildRegFieldDefines();
		
		// create new function
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl++, "function new(string name = \"" + uvmRegClassName + "\");"));
		outputList.add(new OutputLine(indentLvl, "super.new(name, " + regProperties.getRegWidth() + ", UVM_NO_COVERAGE);"));
		outputList.add(new OutputLine(--indentLvl, "endfunction: new"));

		// create build function
		buildRegBuildFunction();
						
		// close out the register definition
		outputList.add(new OutputLine(indentLvl, ""));	
		if (ExtParameters.uvmregsRegsUseFactory()) outputList.add(new OutputLine(indentLvl, "`uvm_object_utils(" + uvmRegClassName + ")"));
		outputList.add(new OutputLine(--indentLvl, "endclass : " + uvmRegClassName));
	}

	/** build vreg class definition for current register instance */   
	@Override
	protected void buildVRegClass() {   
		// create text name and description if null
		String id = regProperties.getId();
		String fullId = getUVMVRegID();
		String textName = regProperties.getTextName();
		if (textName == null) textName = "Virtual Register " + id;
		else textName = textName.replace('\n', ' ');
		
		// generate register header 
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl, "// " + textName));
		outputList.add(new OutputLine(indentLvl++, "class " + fullId + " extends uvm_vreg;")); 
						
		// create field definitions
		buildVRegFieldDefines();   
		
		// create new function
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl++, "function new(string name = \"" + fullId + "\");"));
		outputList.add(new OutputLine(indentLvl,     "super.new(name, " + regProperties.getRegWidth() + ");"));
		outputList.add(new OutputLine(--indentLvl, "endfunction: new"));

		// create build function
		buildVRegBuildFunction();
				
		// close out the register definition
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(--indentLvl, "endclass : " + fullId));
	}

	/** build block class definition for current regset instance 
	 * @param hasCallback - indicates block children have callbacks */   
	protected void buildBlockClass(String uvmBlockClassName, Boolean hasCallback) {
		// create text name and description if null
		String id = regSetProperties.getId();
		String refId = regSetProperties.getBaseName();  // ref used for block structure lookup
		
		String textName = regSetProperties.getTextName();
		if (textName == null) textName = "Block " + id;
		
		// generate register header 
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl, "// " + textName));
		outputList.add(new OutputLine(indentLvl++, "class " + uvmBlockClassName + " extends uvm_reg_block;")); 

		// create field definitions  
		buildBlockDefines(refId);
		
		// create new function
		buildBlockNewDefine(uvmBlockClassName, false);
		
		// create build function  
		Integer mapWidthOverride = (ExtParameters.hasDebugMode("uvmregs_maps_use_max_width"))?  regSetProperties.getMaxRegByteWidth()  : null; // if debug mode 1 use regset property width
		buildBlockBuildFunction(uvmBlockClassName, refId, mapWidthOverride, false);
		
		// close out the class definition
		outputList.add(new OutputLine(indentLvl, ""));	
		if (ExtParameters.uvmregsRegsUseFactory()) outputList.add(new OutputLine(indentLvl, "`uvm_object_utils(" + uvmBlockClassName + ")"));
		outputList.add(new OutputLine(--indentLvl, "endclass : " + uvmBlockClassName));
	}

	/** build uvm_mem/uvm_vreg wrapper block class definition as child of current regset block 
	 *  callbacks, aliases not allowed in this block type 
	 * @param b */   
	protected void buildMemWrapperBlockClass(String uvmBlockClassName, String nameSuffix, Integer mapWidthOverride) {
		// create block name + id with suffix
		String refId = ((regSetProperties == null) || regSetProperties.getBaseName().isEmpty()) ? nameSuffix : regSetProperties.getBaseName() + "_" + nameSuffix;  // id used for structure lookup
		//System.out.println("UVMRegsBuilder buildMemWrapperBlockClass: fullId=" + uvmBlockClassName + ", refId=" + refId);
		
		// generate register header 
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl, "// Uvm_mem wrapper block " + refId));
		outputList.add(new OutputLine(indentLvl++, "class " + uvmBlockClassName + " extends uvm_reg_block;")); 

		// create field definitions  
		buildBlockDefines(refId);
		
		// create new function
		buildBlockNewDefine(uvmBlockClassName, false);
		
		// create build function ising width of underlying virtual regs/mem
		buildBlockBuildFunction(uvmBlockClassName, refId, mapWidthOverride, true);
		
		// close out the class definition
		outputList.add(new OutputLine(indentLvl, ""));	
		if (ExtParameters.uvmregsRegsUseFactory()) outputList.add(new OutputLine(indentLvl, "`uvm_object_utils(" + uvmBlockClassName + ")"));
		outputList.add(new OutputLine(--indentLvl, "endclass : " + uvmBlockClassName));
	}

	/** build block class definition for current regset instance 
	 * @param hasCallback  - indicates block children have callbacks*/ 
	protected void buildBaseBlockClass(String uvmBlockClassName, Boolean hasCallback) {
		//System.out.println("UVMRegsBuilder buildBaseBlockClass: fullId=" + uvmBlockClassName + ", getUVMBlockID()=" + getUVMBlockID());
		String refId = "";  // ref used for base block structure lookup
		
		// generate register header 
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl, "// Base block"));
		outputList.add(new OutputLine(indentLvl++, "class " + uvmBlockClassName + " extends uvm_reg_block;")); 
		
		//String uvmBlockClassName, 
		// create field definitions  
		buildBlockDefines(refId);
				
		// create new function
		buildBlockNewDefine(uvmBlockClassName, false);
		
		// create build function (no width override) 
		buildBlockBuildFunction(uvmBlockClassName, refId, null, false);
		
		// close out the class definition
		outputList.add(new OutputLine(indentLvl, ""));	
		if (ExtParameters.uvmregsRegsUseFactory()) outputList.add(new OutputLine(indentLvl, "`uvm_object_utils(" + uvmBlockClassName + ")"));
		outputList.add(new OutputLine(--indentLvl, "endclass : " + uvmBlockClassName));
	}

	// ---------


	/** build field definitions for current register */
	@Override
	protected void buildRegFieldDefines() {
		Iterator<FieldProperties> iter = fieldList.iterator();
		// traverse field list
		while (iter.hasNext()) {
			FieldProperties field = iter.next();
			String fieldId = escapeReservedString(field.getPrefixedId());  
			outputList.add(new OutputLine(indentLvl, "uvm_field_lite " + fieldId + " = new(this, " + field.getLowIndex() + ", " + field.getFieldWidth() + ");"));
		}
	}

	
	/** build the build function for current register */
	@Override
	protected void buildRegBuildFunction() {
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl++, "virtual function void build();"));
		
		// traverse field list and create single field configure statement
		String accessType = null;
		String isVolatile = "0";
		String isRand = "0";  
		Iterator<FieldProperties> iter = fieldList.iterator();
		while (iter.hasNext()) {
			FieldProperties field = iter.next();
			// warn if field access differences
			if (accessType == null) accessType = getFieldAccessType(field); // save first field access type
			else if (!accessType.equals(getFieldAccessType(field))) {
				if (getFieldAccessType(field).contains("W")) accessType = getFieldAccessType(field);
				Ordt.warnMessage("Multiple field access types found in register=" + regProperties.getInstancePath() + ", lite model assumes a single type per register.");
			}
			if  (field.hwChangesValue() || field.isDontCompare()) isVolatile = "1";
			if (field.isSwWriteable()) isRand = "1";  
			
							
		} // while
		
		// add single field configure
		outputList.add(new OutputLine(indentLvl, "this.m_REG_FIELD.configure(this, " + regProperties.getRegWidth() + 
				", 0, \"" + accessType + "\", " + isVolatile + ", " + getFieldResetParameters() + 
				", " + isRand + ", 1);"));		
		
		// remove reset for uninitialized field if db update is being skipped
		if (fieldNeedsResetRemoval()) outputList.add(new OutputLine(indentLvl, "void'(this.m_REG_FIELD.has_reset(.delete(1)));"));
						
		outputList.add(new OutputLine(--indentLvl, "endfunction: build"));
	}
	
	/** generate field reset string and has_reset indication 
	 * @param field */
	protected String getFieldResetParameters() {
		String retStr = ExtParameters.uvmregsSkipNoResetDbUpdate()? "0, 1" : "0, 0";  // if skip db update then config with a reset and remove after, else default to no reset
			RegNumber resetVal = getFullRegReset();
			if ((resetVal != null) && resetVal.isDefined()) {
				retStr = resetVal.toFormat(RegNumber.NumBase.Hex, RegNumber.NumFormat.Verilog) + ", 1";
			}
		return retStr;
	}

	/** return true if field has no reset and skip db update is specified  
	 * @param field */
	protected boolean fieldNeedsResetRemoval() {
		if (!ExtParameters.uvmregsSkipNoResetDbUpdate()) return false;
		RegNumber resetVal = getFullRegReset();
		if ((resetVal != null) && resetVal.isDefined()) return false;
		return true;
	}

	/** build the build function for current virtual register - no user properties */
	@Override
	protected void buildVRegBuildFunction() {
		outputList.add(new OutputLine(indentLvl, ""));	
		outputList.add(new OutputLine(indentLvl++, "virtual function void build();"));
		Iterator<FieldProperties> iter = fieldList.iterator();
		// traverse field list
		while (iter.hasNext()) {
			FieldProperties field = iter.next();
			String fieldId = escapeReservedString(field.getPrefixedId());  
			// create appropriate uvm_reg_vfield class   
			outputList.add(new OutputLine(indentLvl, "this." + fieldId +  " = new(\"" + field.getPrefixedId() + "\");"));  
			outputList.add(new OutputLine(indentLvl, "this." + fieldId + ".configure(this, " + field.getFieldWidth() + 
					", " + field.getLowIndex() + ");")); 
		} // while		
		outputList.add(new OutputLine(--indentLvl, "endfunction: build"));
	}
	
	
	/** build the virtual build function for current block
	 * @param uvmBlockClassName - name of current uvm block class
	 * @param block - block id used for structure lookup
	 * @param mapWidthOverrride - if non-null, the created default map for this block will use specified value
	 * @param isMemWrapper - if true, created block is a wrapper so will avoid regSetProperty references
	 */
	protected void buildBlockBuildFunction(String uvmBlockClassName, String block, Integer mapWidthOverride, boolean isMemWrapper) {
		outputList.add(new OutputLine(indentLvl, "")); 	
		outputList.add(new OutputLine(indentLvl++, "virtual function void build();"));
		// set access width of block to max of full addrmap by default (<MAX_REG_BYTE_WIDTH> will be replaced with final max value)
		String byteWidthString = "<MAX_REG_BYTE_WIDTH>"; 
		if (mapWidthOverride != null) byteWidthString = mapWidthOverride.toString();
		
		// if base block then include in base address offset
		Boolean isBaseBlock = block.equals("");
		String endianness = "UVM_LITTLE_ENDIAN";
		if (isBaseBlock) {
			String addr = "`UVM_REG_ADDR_WIDTH" + ExtParameters.getPrimaryBaseAddress().toFormat(RegNumber.NumBase.Hex, RegNumber.NumFormat.NoLengthVerilog);
			OutputLine oLine = new OutputLine(indentLvl, "this.default_map = create_map(\"\", " + addr + ", " + byteWidthString + ", " + endianness + ", 1);");
			oLine.setHasTextReplacements(true);
			outputList.add(oLine);
		}
		else {
			OutputLine oLine = new OutputLine(indentLvl, "this.default_map = create_map(\"\", 0, " + byteWidthString + ", " + endianness + ", 1);");
			oLine.setHasTextReplacements(true);
			outputList.add(oLine);
		}
		
		// add subcomponent build statements
		List<SpecialLine> buildList = subcompBuildList.getStatements(block);
		if (buildList != null) {
			Iterator<SpecialLine> iter = buildList.iterator();
			// traverse subcomponent list
			while (iter.hasNext()) {
				SpecialLine line = iter.next();
				line.setIndent(indentLvl);
				outputList.add(line);
			}  
		}
						
		outputList.add(new OutputLine(--indentLvl, "endfunction: build"));
	}
	

}
