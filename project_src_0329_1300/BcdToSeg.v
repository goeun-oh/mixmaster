`timescale 1ns / 1ps

module BCDtoSEG(
    input [4:0] bcd,
    output reg[7:0] seg
    );

    always @(bcd) begin
        case(bcd)
        5'h0_0: seg= 8'hc0;
        5'h0_1: seg= 8'hf9;
        5'h0_2: seg = 8'ha4;
        5'h0_3: seg=8'hb0;
        5'h0_4: seg=8'h99;
        5'h0_5: seg=8'h92;
        5'h0_6: seg=8'h82;
        5'h0_7: seg=8'hf8;
        5'h0_8: seg=8'h80;
        5'h0_9: seg=8'h90;
        5'h0_a: seg=8'h7f;
        5'h0_b: seg=8'h83;
        5'h0_c: seg=8'hc6;
        5'h0_d: seg=8'ha1;
        5'h0_e: seg=8'h86;
        5'h0_f: seg=8'hff;
        5'h1_0: seg=8'h86; //E
        5'h1_1: seg=8'h8f; //r
        5'h1_2: seg = 8'h0f; //r.
        5'h1_3: seg=8'h87; //t
        5'h1_4: seg=8'ha3; //o
        5'h1_5: seg=8'he3; //u
        5'h1_6: seg=8'h89; // H
        5'h1_7: seg=8'ha1; //d
        default:seg=8'hff;
        endcase
    end
endmodule