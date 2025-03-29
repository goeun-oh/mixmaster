`timescale 1ns / 1ps

module distance_to_data#(
    parameter DATA_WIDTH=8,
    parameter ADDR_WIDTH=4,    
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)(
    input clk,
    input rst,
    input tick_100hz,
    input [8:0] distance,
    output[DATA_WIDTH-1:0] dst_data
    );

    wire [DATA_WIDTH-1:0] pc_to_dst100, pc_to_dst10, pc_to_dst1;
    wire [3:0] sel_out;
    reg [3:0] sel_reg, sel_next;
    assign sel_out = sel_reg;
    wire [3:0] dst_100 ;
    wire [3:0] dst_10 ;
    wire [3:0] dst_1 ;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            sel_reg <= 0;
        end else begin
            sel_reg <= sel_next;
        end
    end

    always @(*) begin
        sel_next = sel_reg;
        if(tick_100hz) begin
            if(sel_reg == 11 -1) begin
                sel_next = 0;
            end else begin
                sel_next= sel_reg +1;
            end
        end
    end


    t_mux_11X1 U_MUX_t(
        .sel(sel_out),
        .x0("D"), 
        .x1("S"),
        .x2("T"), 
        .x3(":"),
        .x4(" "),
        .x5(pc_to_dst100),
        .x6(pc_to_dst10),
        .x7(pc_to_dst1),
        .x8("c"),
        .x9("m"),
        .x10(8'h0a),
        .y(dst_data)
    );

    digitSplitter_4 u_digitsplitter_3(
    .i_digit(distance),
    .o_digit_1(dst_1),
    .o_digit_10(dst_10),
    .o_digit_100(dst_100),
    .o_digit_1000 () 
    );


    timeTOascii dst100_to_ascii(
        .i_time(dst_100),
        .ascii(pc_to_dst100)
    );
    timeTOascii dst10_to_ascii(
        .i_time(dst_10),
        .ascii(pc_to_dst10)
    );
    timeTOascii dst1_to_ascii(
        .i_time(dst_1),
        .ascii(pc_to_dst1)
    );    

endmodule
