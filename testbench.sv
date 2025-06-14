`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "transaction.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"
// `include "config.sv"

module tb;
  
  apb_if vif();
  apb_ram dut (.presetn(vif.presetn),
               .pclk(vif.pclk),
               .psel(vif.psel),
               .pwrite(vif.pwrite),
               .paddr(vif.paddr),
               .penable(vif.penable),
               .pwdata(vif.pwdata),
               .prdata(vif.prdata),
               .pslverr(vif.pslverr),
               .pready(vif.pready));
  
  initial begin
    vif.pclk<=0;
  end
  
  always #10 vif.pclk<=~vif.pclk;
  
  initial begin
    uvm_config_db#(virtual apb_if)::set(null,"*","vif",vif);
    run_test("test");
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,tb.dut);
  end
  
endmodule
