module dm_4k(addr, din, we, clk, dout, bmode, bsel);
    input [11:2] addr;           // address bus
    input [31:0] din;            // 32-bit input data
    input we;                    // memory write enable
    input clk;                   // clock
    input [1:0] bsel;
    input bmode;
    output reg [31:0] dout;      // 32-bit memory output

    reg [31:0] dm[1023:0];

    integer i;
    initial begin
      for (i = 0; i < 1024 ; i = i + 1) begin
          dm[i] <= 0;
      end
    end

    always @(posedge clk) begin
        if(we) begin
            if(bmode) begin
                case (bsel)
                    0: begin dm[addr][7:0] = din[7:0]; end
                    1: begin dm[addr][15:8] = din[7:0]; end
                    2: begin dm[addr][23:16] = din[7:0]; end
                    3: begin dm[addr][31:24] = din[7:0]; end
                endcase
            end
            else begin
                dm[addr] = din;
            end
            $display("dm[%3X]=%8X", addr, dm[addr]);
        end
    end
    
    always @(*) begin 
        if (bmode) begin
          case (bsel)
            0: begin dout[7:0] <= dm[addr][7:0]; end
            1: begin dout[7:0] <= dm[addr][15:8]; end
            2: begin dout[7:0] <= dm[addr][23:16]; end
            3: begin dout[7:0] <= dm[addr][31:24]; end
          endcase
          dout={{24{dout[7]}}, dout[7:0]};
        end
        else dout <= dm[addr];
    end
endmodule
