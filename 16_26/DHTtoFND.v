`timescale 1ns / 1ps

module DHTtoFND(
    input clk,
    input rst,
    input [7:0] temp_integral,
    input [7:0] temp_decimal,
    input [7:0] humi_integral,
    input [7:0] humi_decimal,
    input [7:0] parity,
    output [4:0] o_temp,
    output [4:0] o_humi
    );

    wire [3:0] temp0, temp10, temp_minority;
    wire [3:0] humi0, humi10, humi_minority;
    wire o_clk;

    digitSplitter_4 temp_inte(
        .i_digit(temp_integral),
        .o_digit_1(temp0),
        .o_digit_10(temp10),
        .o_digit_100(),
        .o_digit_1000()  
    );

    digitSplitter_4 temp_deci(
        .i_digit(temp_decimal),
        .o_digit_1(),
        .o_digit_10(),
        .o_digit_100(temp_minority),
        .o_digit_1000()  
    );


    digitSplitter_4 humi_inte(
        .i_digit(humi_integral),
        .o_digit_1(humi0),
        .o_digit_10(humi10),
        .o_digit_100(),
        .o_digit_1000()  
    );
    digitSplitter_4 humi_deci(
        .i_digit(humi_decimal),
        .o_digit_1(),
        .o_digit_10(),
        .o_digit_100(humi_minority),
        .o_digit_1000()  
    );


    detect_dot U_detect_dot(
        .msec(msec),
        .dot(dot)
    );

    clk_divider U_Clk_Divider(
        .clk(clk),
        .reset(rst),
        .o_clk(o_clk)
    );

    counter_8 U_Counter_8(
        .clk(o_clk),
        .reset(rst),
        .o_sel(sel)
    );
    
    ////////////temp//////////////
    mux_8X1 U_Mux_Temp(
        .sel(sel),
        .x0(temp_minority),
        .x1(temp0),
        .x2(temp10),
        .x3(5'h1_3), //t
        .x4(5'h0_f),
        .x5(dot),
        .x6(5'h0_f),
        .x7(5'h0_f),
        .y(o_temp)
    );


    /////////humi/////////////
    mux_8X1 U_Mux_Humi(
        .sel(sel),
        .x0(humi_minority),
        .x1(humi0),
        .x2(humi10),
        .x3(5'h1_6), //H
        .x4(5'h0_f),
        .x5(dot),
        .x6(5'h0_f),
        .x7(5'h0_f),
        .y(o_humi)
    );

endmodule
