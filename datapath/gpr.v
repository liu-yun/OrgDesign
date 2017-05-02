module gpr(clk, rst, ra, rb, rw, wd, RegWrite, overflow, rd1, rd2);
    input clk, rst;
    input [4:0] ra, rb, rw;
    input [31:0] wd;
    input RegWrite, overflow;
    output [31:0] rd1, rd2;

    reg [31:0] register[31:0];
    reg [31:0] overFlag = 0;
    integer i;

    initial begin
      for (i = 0; i < 32 ; i = i + 1) begin
          register[i] <= 0;
      end
    end

    assign rd1 = register[ra];
    assign rd2 = register[rb];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i = 0; i < 32; i = i + 1) begin
            register[i] <= 0;
            end
            overFlag <= 0;
        end
        else begin
            if (RegWrite) begin
                if(rw && !overflow)
                    register[rw] <= wd;
                if(overflow)
                    overFlag <= 1;
            end
        end
    end
endmodule
