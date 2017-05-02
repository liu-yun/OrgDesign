module dm_4k(addr, din, we, clk, dout, lbsel, lb);
    input [11:2] addr;           // address bus
    input [31:0] din;            // 32-bit input data
    input we;                    // memory write enable
    input clk;                   // clock
    input [1:0] lbsel;
    input lb;
    output reg [31:0] dout;      // 32-bit memory output

    reg [31:0] dm[1023:0];
    reg [31:0] tmp;
    reg [31:0] b, e;

    integer i;
    initial begin
      for (i = 0; i < 1024 ; i = i + 1) begin
          dm[i] <= 0;
      end
    end

    always @(posedge clk) begin
        if(we) begin
            dm[addr] <= din;
        end
    end
    
    always @(*) begin 
        if (lb) begin
          tmp = dm[addr];
          case (lbsel)
            0: begin dout[7:0] = tmp[7:0]; end
            1: begin dout[7:0] = tmp[15:8]; end
            2: begin dout[7:0} = tmp[23:16]; end
            3: begin dout[7:0] = tmp[31:24]; end
          endcase
          dout={{24{dout[7]}}, dout[7:0]};
        end
        else dout <= dm[addr];
    end
endmodule
