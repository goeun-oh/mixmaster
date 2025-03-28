`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/28 12:23:37
// Design Name: 
// Module Name: WATCHtoFND
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WATCHtoFND(
    input clk,
    input rst,
    input [6:0] msec,
    input [3:0] digit_msec_1, 
    input [3:0] digit_msec_10,
    input [3:0] digit_sec_1, 
    input [3:0] digit_sec_10,
    input [3:0] digit_min_1, 
    input [3:0] digit_min_10,
    input [3:0] digit_hour_1, 
    input [3:0] digit_hour_10,
    output [3:0] msec_sec,
    output [3:0] min_hour
    );

    wire [3:0] w_msec_sec;
    wire [3:0] w_min_hour;
    wire [2:0] sel;
    wire [3:0] dot;

    assign msec_sec=w_msec_sec;
    assign min_hour = w_min_hour;

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
    
    mux_8X1 U_Mux_Msec_Sec(
        .sel(sel),
        .x0(digit_msec_1),
        .x1(digit_msec_10),
        .x2(digit_sec_1),
        .x3(digit_sec_10),
        .x4(4'hf),
        .x5(4'hf),
        .x6(dot),
        .x7(4'hf),
        .y(w_msec_sec)
    );
    mux_8X1 U_Mux_Min_Hour(
        .sel(sel),
        .x0(digit_min_1),
        .x1(digit_min_10),
        .x2(digit_hour_1),
        .x3(digit_hour_10),
        .x4(4'hf),
        .x5(4'hf),
        .x6(dot),
        .x7(4'hf),
        .y(w_min_hour)
    );
endmodule
