class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver);
  
  virtual apb_if vif;
  transaction tr;
  
  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr=transaction::type_id::create("tr");
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
       `uvm_error("DRIVER","unable to access interface");
   endfunction
       
       task reset_dut();
         
         repeat(5)
           begin
             vif.presetn<=1'b0;
             vif.paddr<='h0;
             vif.pwdata<='h0;
             vif.pwrite<='b0;
             vif.psel<='b0;
             vif.penable<='b0;
             `uvm_info("DRIVER","RESET: START OF SIMULATION",UVM_MEDIUM);
             @(posedge vif.pclk);
           end
       endtask
       
       task drive();
         reset_dut();
         forever begin
           
           seq_item_port.get_next_item(tr);
           
           if(tr.op==rst)
             begin
               vif.presetn<=1'b0; //active low
               vif.paddr<='h0;
               vif.pwdata<='h0;
               vif.pwrite<='b0;
               vif.psel<='b0;
               vif.penable<='b0;
               @(posedge vif.pclk);
             end
           
           else if(tr.op ==write_data)
             begin
               vif.psel<=1'b1;
               vif.paddr<=tr.PADDR;
               vif.pwdata<=tr.PWDATA;
               vif.presetn<=1'b1;
               vif.pwrite<=1'b1;
               @(posedge vif.pclk);
               vif.penable<=1'b1; //assert penable in the next clock cycle -- access phase
               `uvm_info("DRIVER", $sformatf("mode:%0s, addr:%0d, wdata:%0d, rdata:%0d, slverr:%0d",tr.op.name(),tr.PADDR,tr.PWDATA,tr.PRDATA,tr.PSLVERR), UVM_NONE);
               
               @(negedge vif.pready);
               vif.penable<=1'b0;
               tr.PSLVERR = vif.pslverr;
             end
           
           else if(tr.op==read_data)
             begin
               vif.presetn<=1'b1;
               vif.psel<=1'b1;
               vif.paddr<=tr.PADDR;
               vif.pwrite<=1'b0;
               
               @(posedge vif.pclk)
               vif.penable<=1'b1;
               `uvm_info("DRIVER", $sformatf("mode:%0s, addr:%0d, wdata:%0d, rdata:%0d, slverr:%0d",tr.op.name(),tr.PADDR,tr.PWDATA,tr.PRDATA,tr.PSLVERR), UVM_NONE);
           
               @(negedge vif.pready)
               vif.penable<=1'b0;
               tr.PRDATA=vif.prdata;
               tr.PSLVERR=vif.pslverr;
             end
           seq_item_port.item_done();
         end
       endtask
       
       
       virtual task run_phase(uvm_phase phase);
         drive();
       endtask
endclass
       
        
               
             
       