module gpr(clk, rst, ra, rb, rw, wd, RegWrite, rd1, rd2, NpcSel);
    input clk, rst;
    input [4:0] ra, rb, rw;
    input [31:0] wd;
    input [2:0] NpcSel;
    input RegWrite;
    output [31:0] rd1, rd2;

    reg [31:0] register[31:0];
    integer i;

    assign rd1 = register[ra];
    assign rd2 = register[rb];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i = 0; i < 31; i = i + 1) begin
            register[i] <= 0;
            end
        end
        else begin
            if (RegWrite) begin
                if(NpcSel == 3'b010) begin         //jal
                    register[30] <= wd;
                end
                else begin
                    if(rw)
                        register[rw] <= wd;
                end
            end
        end
    end
endmodule
