module gpr(clk, rst, ra, rb, rw, wd, GPRWr, rda, rdb);
    input clk, rst;
    input [4:0] ra, rb, rw;
    input [31:0] wd;
    input GPRWr;
    output [31:0] rda, rdb;

    reg [31:0] register[31:0];
    integer i;

    initial begin
      for (i = 0; i < 32 ; i = i + 1) begin
          register[i] <= 0;
      end
    end

    assign rda = register[ra];
    assign rdb = register[rb];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for(i = 0; i < 32; i = i + 1) begin
                register[i] <= 0;
            end
        end
        else begin
            if (GPRWr) begin
                if(rw) begin
                    register[rw] <= wd;
                    $display("Register[%2D]=%8X", rw, wd);
                end
            end
        end
    end
endmodule
