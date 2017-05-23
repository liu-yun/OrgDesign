module mux2_32(a, b, sel, out);
    input [31:0] a, b;
    input sel;
    output [31:0] out;
    assign out = sel ? b : a;
endmodule

module mux3_32(a, b, c, sel, out);
    input [31:0] a, b, c;
    input [1:0] sel;
    output [31:0] out;
    assign out = (sel == 2'b00) ? a :
                 (sel == 2'b01) ? b : c;
endmodule

module mux3_5(a, b, c, sel, out);
    input [4:0] a, b, c;
    input [1:0] sel;
    output [4:0] out;
    assign out = (sel == 2'b00) ? a :
                 (sel == 2'b01) ? b : c;
endmodule

module mux5_32(a, b, c, d, e, sel, out);
    input [31:0] a, b, c, d, e;
    input [2:0] sel;
    output [31:0] out;
    assign out = (sel == 3'b000) ? a :
                 (sel == 3'b001) ? b :
                 (sel == 3'b010) ? c : 
                 (sel == 3'b011) ? d :
                 (sel == 3'b100) ? e : 32'b0;
endmodule

module decoder_4(in, out, en);
    input en;
    input [1:0] in;
    output [3:0] out;
    assign out = !en ? 0000 :
         in == 2'b00 ? 0001 :
         in == 2'b01 ? 0010 :
         in == 2'b10 ? 0100 : 1000;
endmodule