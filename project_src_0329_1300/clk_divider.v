`timescale 1ns / 1ps


module clk_divider(
    input clk,
    input reset,
    output o_clk
    );
    parameter FCOUNT = 100_000 ;
    reg r_clk;
    reg [$clog2(FCOUNT)-1:0] r_counter;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk <=1'b0;
        end else begin
            if (r_counter == FCOUNT -1) begin
                r_counter <=0;
                r_clk <= 1'b1;
            end else begin
                r_clk <= 1'b0;
                r_counter <= r_counter+1;
            end
        end 
    end
    assign o_clk = r_clk;

endmodule