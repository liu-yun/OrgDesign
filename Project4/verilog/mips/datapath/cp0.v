module cp0(clk, rst, Wen, EXLSet, EXLClr, pc, DIn, HWInt, sel, IntReq, epc, DOut);
    input clk, rst, Wen, EXLSet, EXLClr;
    input [31:2] pc;
    input [31:0] DIn;
    input [7:2] HWInt;
    input [4:0] sel;
    output IntReq;
    output reg [31:2] epc;
    output [31:0] DOut;

    //SR allow exceptions
    reg [15:10] im;
    reg exl, ie; //flag, global
    wire [31:0] SR = {16'b0, im, 8'b0, exl, ie};

    //CAUSE current exceptions
    reg [15:10] hwint_pend;
    wire [31:0] CAUSE = {16'b0, hwint_pend, 10'b0};

    reg [31:0] PRId = 32'h0059756e; // Yun

    always @(posedge clk or posedge rst) begin
        if (rst) begin
           im <= 6'b0;
           exl <= 1'b0;
           ie <= 1'b0;
        end
        else if (Wen) begin
            if (sel == 5'd12)
                {im, exl, ie} <= {DIn[15:10], DIn[1], DIn[0]};
            if (EXLSet)
                exl <= 1'b1;
            if (EXLClr)
                exl <= 1'b0;
            hwint_pend <= HWInt;
            epc <= pc;
        end
    end
    
    assign IntReq = |HWInt[7:2] & |im[15:10] & ie & !exl;
    assign DOut = (sel == 5'd12) ? SR :
                  (sel == 5'd13) ? CAUSE :
                  (sel == 5'd14) ? epc :
                  (sel == 5'd15) ? PRId : 32'b0;

    initial begin
        im <= 6'b0;
        exl <= 1'b0;
        ie <= 1'b0;
        hwint_pend <= 6'b0;
        epc <= 30'b0;
    end
endmodule