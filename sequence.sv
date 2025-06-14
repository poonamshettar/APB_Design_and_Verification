class write_data_ extends uvm_sequence#(transaction);
  `uvm_object_utils(write_data_)
  
  transaction tr;
 
  function new(string name = "write_data_");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=write_data;
        finish_item(tr);
      end
  endtask
endclass

class read_data_ extends uvm_sequence#(transaction);
  `uvm_object_utils(read_data_)
  
  transaction tr;
 
  function new(string name = "read_data_");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=read_data;
        finish_item(tr);
      end
  endtask
endclass

class write_read extends uvm_sequence#(transaction);
  `uvm_object_utils(write_read)
  
  transaction tr;
 
  function new(string name = "write_read");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=write_data;
        finish_item(tr);
        
        start_item(tr);
        assert(tr.randomize);
        tr.op=read_data;
        finish_item(tr);
      end
  endtask
endclass


class writeb_readb extends uvm_sequence#(transaction);
  `uvm_object_utils(writeb_readb)
  
  transaction tr;
 
  function new(string name = "writeb_readb");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=write_data;
        finish_item(tr);
      end
        repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=read_data;
        finish_item(tr);
      end
  endtask
endclass

class write_error extends uvm_sequence#(transaction);
  `uvm_object_utils(write_error)
  
  transaction tr;
 
  function new(string name = "write_error");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(0);//enable
        tr.error_addr_range.constraint_mode(1);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=write_data;
        finish_item(tr);
      end
  endtask
endclass

class read_error extends uvm_sequence#(transaction);
  `uvm_object_utils(read_error)
  
  transaction tr;
 
  function new(string name = "read_error");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=write_data;
        finish_item(tr);
      end
  endtask
endclass

class reset_dut extends uvm_sequence#(transaction);
  `uvm_object_utils(reset_dut)
  
  transaction tr;
 
  function new(string name = "reset_dut");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr=transaction::type_id::create("tr");
        tr.valid_addr_range.constraint_mode(1);//enable
        tr.error_addr_range.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op=rst;
        finish_item(tr);
      end
  endtask
endclass