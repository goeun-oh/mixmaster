`timescale 1ns / 1ps


module mux5_5X1(
    input [2:0] sel,
    input [4:0] x0,
    input [4:0] x1,
    input [4:0] x2,
    input [4:0] x3,
    input [4:0] x4,
    output reg [4:0] y
    );

    always @(*) begin
        case(sel)
            3'b000: y=x0; //스탑워치-초
            3'b001: y=x1; //스탑워치-시간
            3'b010: y=x2; //거리센서
            3'b100: y=x3; //온습도 temp
            3'b101: y=x4; // 온습도 humi
            default: y=x0; 
        endcase
    end
endmodule