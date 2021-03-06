//   Ordt 180327.01 autogenerated file 
//   Date: Tue Mar 27 14:56:53 EDT 2018
//


// ordt_uvm_reg_lite1_pkg
`ifndef ORDT_UVM_REG_LITE1_PKG_SV
  `define ORDT_UVM_REG_LITE1_PKG_SV
  `include "uvm_macros.svh"
  package ordt_uvm_reg_lite1_pkg;
    import uvm_pkg::*;
    
    // uvm_reg_lite class
    class uvm_reg_lite extends uvm_reg;
      rand uvm_reg_field m_REG_FIELD = new();
      
      function new(string name = "uvm_reg_lite", int unsigned n_bits = 0, int has_coverage = UVM_NO_COVERAGE);
        super.new(name, n_bits, has_coverage);
      endfunction: new
      
      function uvm_reg_data_t get_slice(int loidx = 0, int width = 0);
        uvm_reg_data_t gvalue;
        gvalue = m_REG_FIELD.get();
        return (gvalue & (((1<<width)-1) << loidx)) >> loidx;
      endfunction: get_slice
      
      function void set_slice(uvm_reg_data_t value, int loidx = 0, int width = 0);
        uvm_reg_data_t svalue;
        if (value >> width) begin
          $display("ERROR in UVM reg lite1 model: atempting to set a slice value greater than field width");
          value &= ((1<<width)-1);
        end
        svalue = m_REG_FIELD.get();
        svalue |= (((1<<width)-1) << loidx);
        svalue ^= (((1<<width)-1) << loidx);
        svalue |= (value << loidx);
        m_REG_FIELD.set(svalue);
      endfunction: set_slice
      
    endclass : uvm_reg_lite
    
    // uvm_field_lite class
    class uvm_field_lite;
      protected uvm_reg_lite m_parent;
      protected int m_loidx;
      protected int m_width;
      
      function new(uvm_reg_lite parent, int loidx, int width);
        m_parent = parent;
        m_loidx = loidx;
        m_width = width;
      endfunction: new
      
      virtual function uvm_reg_data_t get();
        return m_parent.get_slice(m_loidx, m_width);
      endfunction: get
      
      virtual function set(uvm_reg_data_t value);
        m_parent.set_slice(value, m_loidx, m_width);
      endfunction: set
      
    endclass : uvm_field_lite
    
  endpackage
`endif
