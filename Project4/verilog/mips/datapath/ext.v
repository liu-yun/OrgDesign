module ext(imm16, ExtOp, extout);
    input [15:0] imm16;
    input [1:0] ExtOp;
    output [31:0] extout;
    
    wire [31:0] extout;
    assign extout = (ExtOp == 2'b00) ? {16'b0, imm16} :              //0 high
                    (ExtOp == 2'b01) ? {{16{imm16[15]}}, imm16} :    //sign
                                       {imm16, 16'b0};               //0 low   2'b10
endmodule
