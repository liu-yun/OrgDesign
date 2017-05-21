module timer(clk, rst, addr, we, DEV_WD, DEVTimer_RD, IRQ);
    input clk, rst, we;
    input [3:2] addr;
    input [31:0] DEV_WD;
    output [31:0] DEVTimer_RD;
    output reg IRQ;

    reg [31:0] ctrl, preset, count;
    wire IM = ctrl[3];
    wire [2:1] mode = ctrl[2:1];
    wire enable = ctrl[0];

    assign DEVTimer_RD = (addr === 2'b00) ? ctrl :
                         (addr === 2'b01) ? preset :
                         (addr === 2'b10) ? count : 32'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ctrl <= 32'b0;
            preset <= 32'b0;
            count <= 32'b0;
            IRQ <= 0;
        end
        else if (we) begin
            case (addr)
                2'd0 : ctrl <= DEV_WD;
                2'd1 : preset <= DEV_WD;
            endcase
            if (mode == 0) begin
                count <= preset;
                IRQ <= 0;
            end
        end
        else begin
            if (mode == 0) begin
                if (count == 0) begin
                    if (IM)
                        IRQ <= 1;
                end
                else if(enable)
                    count <= count - 1;
            end
            if (mode == 1) begin
                if (count == 0) begin
                    count <= preset;
                end
                else if(enable)
                    count <= count - 1;
            end
        end
    end
    
endmodule
