`timescale 1ns / 1ps


module decoder(
    input [2:0] x,
    output reg [3:0] y
    );
    always @(x) begin
        case(x)
            3'b000: y=4'b1110;
            3'b001: y=4'b1101;
            3'b010: y=4'b1011;
            3'b011: y=4'b0111;
            3'b100: y=4'b1110;
            3'b101: y=4'b1101;
            3'b110: y=4'b1011;
            3'b111: y=4'b0111;
            default: y=4'b1111;
        endcase
    end
endmodule