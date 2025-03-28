`timescale 1ns / 1ps


module t_mux_26X1(
    input [4:0] sel,
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
    input [7:0] x13,
    input [7:0] x14,
    input [7:0] x15,
    input [7:0] x16,
    input [7:0] x17,
    input [7:0] x18,
    input [7:0] x19,
    input [7:0] x20,
    input [7:0] x21,
    input [7:0] x22,
    input [7:0] x23,
    input [7:0] x24,
    input [7:0] x25,
    output reg [7:0] y
    );

    always @(*) begin
        case(sel)
            5'h0_0: y=x0;
            5'h0_1: y=x1;
            5'h0_2: y=x2;
            5'h0_3: y=x3;
            5'h0_4: y=x4;
            5'h0_5: y=x5;            
            5'h0_6: y=x6;
            5'h0_7: y=x7;
            5'h0_8: y=x8;
            5'h0_9: y=x9;
            5'h0_a: y=x10;
            5'h0_b: y=x11;
            5'h0_c: y=x12;
            5'h0_d: y=x13;
            5'h0_e: y=x14;
            5'h0_f: y=x15;
            5'h1_0: y=x16;
            5'h1_1: y=x17;
            5'h1_2: y=x18;
            5'h1_3: y=x19;
            5'h1_4: y=x20;
            5'h1_5: y=x21;
            5'h1_6: y=x22;
            5'h1_7: y=x23;
            5'h1_8: y=x24;
            5'h1_9: y=x25;

            default: y=x0;
        endcase
    end
endmodule