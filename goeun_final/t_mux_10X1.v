`timescale 1ns / 1ps


module t_mux_12X1(
    input [3:0] sel,
    input [7:0] x0,
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    input [7:0] x4,
    input [7:0] x5,
    input [7:0] x6,
    input [7:0] x7,
    input [7:0] x8,
    input [7:0] x9,
    input [7:0] x10,
    input [7:0] x11,
    input [7:0] x12,

    output reg [7:0] y
    );

    always @(*) begin
        case(sel)
            4'h0: y=x0;
            4'h1: y=x1;
            4'h2: y=x2;
            4'h3: y=x3;
            4'h4: y=x4;
            4'h5: y=x5;            
            4'h6: y=x6;
            4'h7: y=x7;
            4'h8: y=x8;
            4'h9: y=x9;
            4'ha: y=x10;
            4'hb: y=x11;
            4'hc: y=x12;
            default: y=x0;
        endcase
    end
endmodule