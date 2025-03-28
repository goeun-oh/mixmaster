`timescale 1ns / 1ps


module digitSplitter #(
    parameter BIT_WIDTH = 6
)(
    input [BIT_WIDTH:0] i_digit,
    output [3:0] o_digit_1,
    output [3:0] o_digit_10  
    );
    assign o_digit_1=i_digit%10;
    assign o_digit_10=i_digit/10%10;

endmodule