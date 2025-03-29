`timescale 1ns / 1ps

module DSTtoFND(
    input clk,
    input rst,
    input [8:0] distance,
    output [4:0] o_dst
    );


    wire [2:0] sel;
    wire o_clk;
    wire [3:0] dst_1 ;
    wire [3:0] dst_10 ;
    wire [3:0] dst_100 ;
    
    digitSplitter_4 #(.DATAWIDTH (9)) U_digitsplitter_3 
(
        .i_digit(distance),
        .o_digit_1(dst_1),
        .o_digit_10(dst_10),
        .o_digit_100(dst_100),
        .o_digit_1000()  
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
    
    ////////////dst//////////////
    mux5_8X1 U_Mux_DST(
        .sel(sel),
        .x0(dst_1),
        .x1(dst_10),
        .x2(dst_100),
        .x3(5'h1_7), //d
        .x4(5'h0_f),
        .x5(5'h0_f), 
        .x6(5'h0_f),
        .x7(5'h0_a), //dot
        .y(o_dst)
    );



endmodule
