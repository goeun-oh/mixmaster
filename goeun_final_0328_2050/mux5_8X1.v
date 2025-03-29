
`timescale 1ns / 1ps



module mux5_8X1(
    input [2:0] sel,
    input [4:0] x1,
    input [4:0] x0,
    input [4:0] x2,
    input [4:0] x3,
    input [4:0] x4,
    input [4:0] x5,
    input [4:0] x6,
    input [4:0] x7,
    output reg [4:0] y
    );

    always @(*) begin
        case(sel)
            3'b000: y=x0;
            3'b001: y=x1;
            3'b010: y=x2;
            3'b011: y=x3;
            3'b100: y=x4;
            3'b101: y=x5;
            3'b110: y=x6;
            3'b111: y=x7;
            default: y=x0;
        endcase
    end
endmodule
