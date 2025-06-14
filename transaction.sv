typedef enum bit[1:0] {read_data=0,write_data=1,rst=2} oper_mode;

class transaction extends uvm_sequence_item;
  
  //input signals to dut
  rand oper_mode op;
  rand logic PWRITE;
  rand logic [31:0] PWDATA;
  rand logic [31:0] PADDR;
  
  //output signals from dut
  logic PREADY;
  logic PSLVERR;
  logic [31:0] PRDATA;
  
  //field macros to use uvm_inbuilt functions
  
        `uvm_object_utils_begin(transaction)
        `uvm_field_int (PWRITE,UVM_ALL_ON)
        `uvm_field_int (PWDATA,UVM_ALL_ON)
        `uvm_field_int (PADDR,UVM_ALL_ON)
        `uvm_field_int (PREADY,UVM_ALL_ON)
        `uvm_field_int (PSLVERR,UVM_ALL_ON)
        `uvm_field_int (PRDATA,UVM_ALL_ON)
        `uvm_field_enum(oper_mode, op, UVM_DEFAULT)
        `uvm_object_utils_end
  
  constraint valid_addr_range {PADDR<=31;}
  constraint error_addr_range {PADDR>31;}
  
  function new(string name = "transaction");
    super.new(name);
  endfunction
 
endclass : transaction