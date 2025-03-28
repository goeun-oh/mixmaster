`timescale 1ns / 1ps

module time_to_data#(
    parameter DATA_WIDTH=8,
    parameter ADDR_WIDTH=4,    
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)(
    input clk,
    input rst,
    input tick_100hz,
    input [3:0] sec0,
    input [3:0] sec1,
    input [3:0] min0,
    input [3:0] min1,
    input [3:0] hour0,
    input [3:0] hour1,
    output[DATA_WIDTH-1:0] time_data
    );

    wire [DATA_WIDTH-1:0] pc_to_sec0, pc_to_sec1, pc_to_min0, pc_to_min1, pc_to_hour0, pc_to_hour1;
    wire [3:0] sel_out;
    reg [3:0] sel_reg, sel_next;
    assign sel_out = sel_reg;

    
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
            if(sel_reg == 10-1) begin
                sel_next = 0;
            end else begin
                sel_next= sel_reg +1;
            end
        end
    end


    t_mux_10X1 U_MUX_t(
        .sel(sel_out),
        .x0(pc_to_hour1),
        .x1(pc_to_hour0),
        .x2(8'h3a), 
        .x3(pc_to_min1),
        .x4(pc_to_min0),
        .x5(8'h3a),
        .x6(pc_to_sec1),
        .x7(pc_to_sec0),
        .x8(8'h0d),
        .x9(8'h0a),
        .y(time_data)
    );

    timeTOascii sec0_to_ascii(
        .i_time(sec0),
        .ascii(pc_to_sec0)
    );
    timeTOascii sec1_to_ascii(
        .i_time(sec1),
        .ascii(pc_to_sec1)
    );
    timeTOascii min0_to_ascii(
        .i_time(min0),
        .ascii(pc_to_min0)
    );    
    timeTOascii min1_to_ascii(
        .i_time(min1),
        .ascii(pc_to_min1)
    );    
    timeTOascii hour0_to_ascii(
        .i_time(hour0),
        .ascii(pc_to_hour0)
    );    
    timeTOascii hour1_to_ascii(
        .i_time(hour1),
        .ascii(pc_to_hour1)
    );    
endmodule
