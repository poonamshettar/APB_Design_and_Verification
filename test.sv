class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string inst="test",uvm_component c);
    super.new(inst,c);
  endfunction
  
  env e;
  write_read wrrd;
  writeb_readb wrrdb;
  write_data_ wdata;
  read_data_ rdata;
  write_error werr;
  read_error rerr;
  reset_dut rstdut;
  
  //create all sequences
  
  virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  e      = env::type_id::create("env",this);
  wrrd   = write_read::type_id::create("wrrd");
  wdata  = write_data_::type_id::create("wdata");
  rdata  = read_data_::type_id::create("rdata");
  wrrdb  = writeb_readb::type_id::create("wrrdb");
  werr   = write_error::type_id::create("werr");
  rerr   = read_error::type_id::create("rerr");
  rstdut = reset_dut::type_id::create("rstdut");
endfunction
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wrrd.start(e.a.seqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass
