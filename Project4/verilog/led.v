module led(clk, rst, addr, we, DEV_WD, DEVLed_RD, led1_sel, led2_sel, led1_signal, led2_signal);
    input clk, rst, we;
    input [3:2] addr;
    input [31:0] DEV_WD;
    output [31:0] DEVLed_RD;
    output [3:0] led1_sel, led2_sel;
    output reg [7:0] led1_signal, led2_signal;

    reg [31:0] preset, current;
    reg [3:0] sel;
    reg [3:0] num1, num2;
    assign led1_sel = sel;
    assign led2_sel = sel;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
        begin
            preset <= 32'b0;
            current <= 32'b0;
            sel <= 4'b0001;
        end
        else if(we)
            case (addr)
            2'd0 : preset <= DEV_WD;
            2'd1 : current <= DEV_WD;
            endcase
    end

    assign DEVLed_RD = addr == 2'd0 ? preset :
                       addr == 2'd1 ? current : 32'b0;

    always @(posedge clk) begin
        if (sel == 4'b1000)
            sel <= 4'b0001;
        else 
            sel <= sel << 1;
        case (sel)
            4'b0001 : begin num1 <= current[3:0]; num2 <= current[19:16]; end
            4'b0010 : begin num1 <= current[7:4]; num2 <= current[23:20]; end
            4'b0100 : begin num1 <= current[11:8]; num2 <= current[27:24]; end
            4'b1000 : begin num1 <= current[15:12]; num2 <= current[31:28]; end
        endcase
    end

    always @(num1) begin
        case (num1)
            4'h0 : led1_signal <= 8'b11111100;
            4'h1 : led1_signal <= 8'b01100000;
            4'h2 : led1_signal <= 8'b11011010;
            4'h3 : led1_signal <= 8'b11110010;
            4'h4 : led1_signal <= 8'b01100110;
            4'h5 : led1_signal <= 8'b10110110;
            4'h6 : led1_signal <= 8'b10111110;
            4'h7 : led1_signal <= 8'b11100000;
            4'h8 : led1_signal <= 8'b11111110;
            4'h9 : led1_signal <= 8'b11110110;
            4'ha : led1_signal <= 8'b11101110;
            4'hb : led1_signal <= 8'b00111110;
            4'hc : led1_signal <= 8'b10011100;
            4'hd : led1_signal <= 8'b01111010;
            4'he : led1_signal <= 8'b10011110;
            4'hf : led1_signal <= 8'b10001110;
        endcase
    end

    always @(num2) begin
        case (num2)
            4'h0 : led2_signal <= 8'b11111100;
            4'h1 : led2_signal <= 8'b01100000;
            4'h2 : led2_signal <= 8'b11011010;
            4'h3 : led2_signal <= 8'b11110010;
            4'h4 : led2_signal <= 8'b01100110;
            4'h5 : led2_signal <= 8'b10110110;
            4'h6 : led2_signal <= 8'b10111110;
            4'h7 : led2_signal <= 8'b11100000;
            4'h8 : led2_signal <= 8'b11111110;
            4'h9 : led2_signal <= 8'b11110110;
            4'ha : led2_signal <= 8'b11101110;
            4'hb : led2_signal <= 8'b00111110;
            4'hc : led2_signal <= 8'b10011100;
            4'hd : led2_signal <= 8'b01111010;
            4'he : led2_signal <= 8'b10011110;
            4'hf : led2_signal <= 8'b10001110;
        endcase
    end
endmodule
