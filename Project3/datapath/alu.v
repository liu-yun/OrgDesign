//AluOp
`define Addu   4'b0000
`define Subu   4'b0001
`define Or     4'b0010
`define Bb     4'b0011
`define Aa     4'b0100
`define Add    4'b0101
`define Lt     4'b0110

module alu(A, B, AluOp, dout, zero, overflow);
    input signed [31:0] A, B;
    input [3:0] AluOp;
    output reg [31:0] dout;
    output zero, overflow;
    reg sign = 0;

    always @(A or B or AluOp) begin
      case (AluOp)
        `Addu : dout <= A + B;
        `Subu : dout <= A - B;
        `Or   : dout <= A | B;
        `Bb   : dout <= B;
        `Aa   : dout <= A;
        `Add  : {sign, dout} <= {A[31], A} + {B[31], B};
        `Lt   : dout <= {31'b0, A < B};
        default : dout <= 32'b0;
      endcase
    end
    assign zero = (dout == 32'b0);
    assign overflow = (AluOp == `Add && (sign ^ dout[31]));
endmodule
