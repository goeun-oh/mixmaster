`timescale 1ns / 1ps

module counter_8(
    input clk,
    input reset,
    output [2:0] o_sel
    );
    reg [2:0] r_counter;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            r_counter <=3'b000;
        end else begin
            r_counter <= r_counter +1;
        end
    end
    //overflow가 발생해도 0,1,2,3 안에서 반복된다. (순환)
    assign o_sel=r_counter;
endmodule