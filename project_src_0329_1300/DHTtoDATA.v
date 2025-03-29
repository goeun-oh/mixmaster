`timescale 1ns / 1ps

module dht_to_data#(
    parameter DATA_WIDTH=8,
    parameter ADDR_WIDTH=4    
)(
    input clk,
    input rst,
    input tick_100hz,
    input i_error,
    input [3:0] humi0,
    input [3:0] humi10,
    input [3:0] humi_minority,
    input [3:0] temp0,
    input [3:0] temp10,
    input [3:0] temp_minority,
    output[DATA_WIDTH-1:0] o_data
    );

    wire [DATA_WIDTH-1:0] pc_to_humi0, pc_to_humi10, pc_to_humi_minority, 
        pc_to_temp0, pc_to_temp10, pc_to_temp_minority;
    
    wire [4:0] sel_out;
    reg [4:0] sel_reg, sel_next;
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
            if(sel_reg == 25-1) begin
                sel_next = 0;
            end else begin
                sel_next= sel_reg +1;
            end
        end
    end

    ////////temp//////////
    t_mux_25X1 U_MUX25X1_t(
        .sel(sel_out),
        .x0(8'h74), //t
        .x1(8'h65), //e
        .x2(8'h6d), //m
        .x3(8'h70), //p
        .x4(8'h3a), //:
        .x5(8'h20), // space bar
        .x6(pc_to_temp10), 
        .x7(pc_to_temp0),
        .x8(8'h2e), //.
        .x9(pc_to_temp_minority),
        .x10(8'h20),
        .x11(8'h68), //h
        .x12(8'h75), //u
        .x13(8'h6d), //m
        .x14(8'h69), //i
        .x15(8'h3a), //:
        .x16(8'h20), //space bar
        .x17(pc_to_humi10),
        .x18(pc_to_humi0),
        .x19(8'h2e),
        .x20(pc_to_humi_minority),
        .x21(8'h09),
        .x22((i_error)?8'h58:8'h4f),
        .x23((i_error)? 8'h58:8'h4b),
        .x24(8'h0a),
        .y(o_data)
    );

    //OK, Miss

    timeTOascii humi0_to_ascii(
        .i_time(humi0),
        .ascii(pc_to_humi0)
    );
    timeTOascii humi10_to_ascii(
        .i_time(humi10),
        .ascii(pc_to_humi10)
    );
    timeTOascii humi_minority_to_ascii(
        .i_time(humi_minority),
        .ascii(pc_to_humi_minority)
    );    
    timeTOascii temp0_to_ascii(
        .i_time(temp0),
        .ascii(pc_to_temp0)
    );    
    timeTOascii temp10_to_ascii(
        .i_time(temp10),
        .ascii(pc_to_temp10)
    );    
    timeTOascii temp_minority_to_ascii(
        .i_time(temp_minority),
        .ascii(pc_to_temp_minority)
    );    
endmodule
