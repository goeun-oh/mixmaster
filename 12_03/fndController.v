`timescale 1ns / 1ps

module fndController(
    input clk,
    input reset,
    input sw_mode,
    input [6:0] msec,
    input [5:0] sec,
    input [5:0] min,
    input [4:0] hour,
    output [7:0] fndFont,
    output [3:0] fndCom,
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
    
    


    wire [4:0] w_digit;
    wire o_clk;
 
    wire [2:0] sel;

    clk_divider U_Clk_Divider(
        .clk(clk),
        .reset(reset),
        .o_clk(o_clk)
    );

    counter_8 U_Counter_8(
        .clk(o_clk),
        .reset(reset),
        .o_sel(sel)
    );


    decoder U_Decoder(
        .x(sel),
        .y(fndCom)
    );

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

wire [3:0] w_msec_sec;
wire [3:0] w_min_hour;

mux4_2X1 U_mux_2X1(
    .sel(sw_mode),
    .x0(w_msec_sec),
    .x1(w_min_hour),
    .y(w_digit)
);

wire [3:0] dot;

mux_8X1 U_Mux_Msec_Sec(
    .sel(sel),
    .x0(w_digit_msec_1),
    .x1(w_digit_msec_10),
    .x2(w_digit_sec_1),
    .x3(w_digit_sec_10),
    .x4(4'hf),
    .x5(4'hf),
    .x6(dot),
    .x7(4'hf),
    .y(w_msec_sec)
);
mux_8X1 U_Mux_Min_Hour(
    .sel(sel),
    .x0(w_digit_min_1),
    .x1(w_digit_min_10),
    .x2(w_digit_hour_1),
    .x3(w_digit_hour_10),
    .x4(4'hf),
    .x5(4'hf),
    .x6(dot),
    .x7(4'hf),
    .y(w_min_hour)
);
BCDtoSEG U_BcdToSeg(
    .bcd(w_digit),
    .seg(fndFont)
);

detect_dot U_detect_dot(
    .msec(msec),
    .dot(dot)
);
endmodule