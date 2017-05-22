module im_4k(addr, dout);
    input [15:2] addr;  // address bus
    output [31:0] dout; // 32-bit memory output

    reg [31:0] im[2047:0];
    wire [15:2] offset = addr - 14'h0c00;
    integer i;

    initial begin
      for (i = 0; i < 2048 ; i = i + 1) begin
          im[i] = 0;
      end
      $readmemh("code.txt", im, 'h0, 'h400);
      $readmemh("except.txt", im, 'h460, 'h7ff);
    end
    
    assign dout = im[offset];
endmodule
