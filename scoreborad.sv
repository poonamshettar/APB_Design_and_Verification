class mon extends uvm_monitor;
  `uvm_component_utils(mon)
  
  uvm_analysis_port#(transaction) send;
  transaction tr;
  virtual apb_if vif;
  
    function new(input string inst = "mon", uvm_component parent = null);
    super.new(inst,parent);
    endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=transaction::type_id::create("tr");
    send=new("send",this); //tlm analysis port
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
      `uvm_error("MONITOR","Unable to access interface");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.pclk);
      if(!vif.presetn)
        begin
          tr.op=rst;
          `uvm_info("MONITOR","RESET",UVM_NONE);
          send.write(tr);
        end
      else if(vif.presetn && vif.pwrite)
        begin
          @(negedge vif.pready);
          tr.op=write_data;
          tr.PWDATA=vif.pwdata;
          tr.PADDR=vif.paddr;
          tr.PSLVERR=vif.pslverr;
          `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d slverr:%0d",tr.PADDR,tr.PWDATA,tr.PSLVERR), UVM_NONE); 
          send.write(tr); //write to scoreboard
        end
      else if(vif.presetn && !vif.pwrite)
          begin
            @(negedge vif.pready)
            tr.op=read_data;
            tr.PRDATA=vif.prdata;
            tr.PADDR=vif.paddr;
            tr.PSLVERR=vif.pslverr;
            `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d slverr:%0d",tr.PADDR, tr.PRDATA,tr.PSLVERR), UVM_NONE); 
          send.write(tr);
         end
    end
  endtask
endclass
      