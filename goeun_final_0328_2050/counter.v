`timescale 1ns / 1ps

module counter #(
    parameter COUNT =100,
    parameter INIT=0
)(
    input clk,
    input tick,
    input reset,
    input clear,
    input i_btn,
    input sw_mode,
    output [$clog2(COUNT)-1:0] o_counter,
    output o_tick
    );
    parameter BIT_WIDTH= $clog2(COUNT);

    reg [BIT_WIDTH-1:0] count_bit;
    
    reg [BIT_WIDTH-1:0] count_next;
    
    reg tick_reg, tick_next;
    reg delay_tick;
    reg delay;

    always @(posedge clk, posedge reset) begin
        if(reset) begin
            count_bit <=0;
            tick_reg <=0;
            delay_tick <=0;
            delay <=0;
        end else if(!delay_tick) begin
            delay_tick <=1;
            delay <= 1;
        end else begin 
            count_bit <= count_next;
            tick_reg <= tick_next;
            delay <=0;
        end
    end
    
    assign o_counter = count_bit;

    always @(*) begin
        count_next = count_bit;
        tick_next = 1'b0;
        if (delay) begin
            count_next = sw_mode ? INIT : 0;  // Reset이 걸릴 때 count_next에도 적용
            tick_next = 0;
        end else if (tick) begin
            if (count_bit == COUNT-1) begin
                count_next =0;
                tick_next =1'b1;
            end else begin
                count_next = count_bit+1;
                tick_next =1'b0;
            end
        end else if (clear) begin
            count_next = 0;
            tick_next = tick_next;
        end else if (i_btn) begin
            if(count_bit == COUNT-1) begin
                count_next=0;
                tick_next=1'b1;
            end else begin
                count_next= count_bit +1;
            end
        end
    end

    assign o_tick = tick_reg;
endmodule