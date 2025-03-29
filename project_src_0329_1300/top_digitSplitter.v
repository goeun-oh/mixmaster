`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/28 12:09:42
// Design Name: 
// Module Name: top_digitSplitter
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


module watch_digitSplitter(
    input [6:0] msec,
    input [5:0] sec,
    input [5:0] min,
    input [4:0] hour,
    output [3:0] digit_msec_1, 
    output [3:0] digit_msec_10,
    output [3:0] digit_sec_1, 
    output [3:0] digit_sec_10,
    output [3:0] digit_min_1, 
    output [3:0] digit_min_10,
    output [3:0] digit_hour_1, 
    output [3:0] digit_hour_10
    );

    wire [3:0] w_digit_msec_1, w_digit_msec_10;
    wire [3:0] w_digit_sec_1, w_digit_sec_10;
    wire [3:0] w_digit_min_1, w_digit_min_10;
    wire [3:0] w_digit_hour_1, w_digit_hour_10;

    assign digit_msec_1 = w_digit_msec_1;
    assign digit_msec_10 = w_digit_msec_10;
    assign digit_sec_1 = w_digit_sec_1;
    assign digit_sec_10 = w_digit_sec_10;
    assign digit_min_1 = w_digit_min_1;
    assign digit_min_10 = w_digit_min_10;
    assign digit_hour_1 = w_digit_hour_1;
    assign digit_hour_10 = w_digit_hour_10;

    digitSplitter #(
        .BIT_WIDTH(6)
    ) ms(
        .i_digit(msec),
        .o_digit_1(w_digit_msec_1),
        .o_digit_10(w_digit_msec_10)
    );

    digitSplitter #(
        .BIT_WIDTH(5)
    ) second(
        .i_digit(sec),
        .o_digit_1(w_digit_sec_1),
        .o_digit_10(w_digit_sec_10)
    );
    
    
    digitSplitter  #(
        .BIT_WIDTH(5)
    )u_min(
        .i_digit(min),
        .o_digit_1(w_digit_min_1),
        .o_digit_10(w_digit_min_10)
    );

    
    digitSplitter  #(
        .BIT_WIDTH(4)
    ) u_hour(
        .i_digit(hour),
        .o_digit_1(w_digit_hour_1),
        .o_digit_10(w_digit_hour_10)
    );
endmodule
