module apb_ram(
  input presetn,
  input pclk,
  input psel,
  input penable,
  input pwrite,
  input [31:0] paddr,pwdata,
  output reg [31:0] prdata,
  output reg pready,pslverr
);
  
  reg [31:0] mem[32]; //32 bits
  
  typedef enum {idle_phase=0, setup_phase=1,
                access_phase=2, transfer_phase=3} state_type;
  
  state_type state=idle_phase;
  
  always @(posedge pclk)
    begin
      if(presetn==1'b0) //active low
        begin
          state<=idle_phase;
          prdata<=32'h00000000;
          pready<=1'b0;
          pslverr<=1'b0;
          
          for(int i=0;i<32;i++)
            begin
              mem[i]=0;
            end
        end
      else
        begin
          case(state)
            idle_phase:
              begin
                prdata<=32'h00000000;
          		pready<=1'b0;
          		pslverr<=1'b0;
                state<=setup_phase;
              end
            setup_phase:
              begin
                if(psel==1'b1)
                  state<=access_phase;
                else
                  state<=setup_phase;
              end
            access_phase:
              begin
                if(pwrite && penable)
                  begin
                    if(paddr<32)    
                      begin
                        mem[paddr]<=pwdata;
                        state<=transfer_phase;
                        pslverr<=1'b0;
                        pready<=1'b1;
                      end
                    else
                      begin
                        state<=transfer_phase;
                        pslverr<=1'b1;
                        pready<=1'b1;
                      end
                  end
                else if(!pwrite && penable)
                  begin
                    if(paddr<32)    
                      begin
                        prdata<=mem[paddr];
                        state<=transfer_phase;
                        pslverr<=1'b0;
                        pready<=1'b1;
                      end
                    else
                      begin
                        state<=transfer_phase;
                        pslverr<=1'b1;
                        pready<=1'b1;
                        prdata<=32'hxxxxxxxx;
                      end 
                  end
                else
                  state<=setup_phase;
              end
            transfer_phase:
            begin
              state<=setup_phase;
              pready<=1'b0;
              pslverr<=1'b0;
            end
            
            default:state<=idle_phase;
          endcase
        end
    end
endmodule

//interaface for verification

interface apb_if ();
  // Signals
  logic              pclk;
  logic              presetn;
  logic       [31:0] paddr;
  logic              pwrite;
  logic       [31:0] pwdata;
  logic              penable;
  logic              psel;
  logic       [31:0] prdata;
  logic              pslverr;
  logic              pready;
 
 
endinterface : apb_if
                        
                