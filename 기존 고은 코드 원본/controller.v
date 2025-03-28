`timescale 1ns / 1ps


module controller(
    input clk,
    input reset,
    input i_run,
    input i_clear,
    output o_run,
    output o_clear
    );

    parameter [1:0] STOP = 2'b00;
    parameter [1:0] RUN = 2'b01;
    parameter [1:0] CLEAR = 2'b10;

    reg [1:0] p_state;
    reg [1:0] n_state;
    reg r_o_run;
    reg r_o_clear;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p_state <=STOP;
        end else begin
            p_state <= n_state;
        end
    end
    //button 으로 바꾸고 edge detection을 하자자
    always @(*) begin
        case(p_state)
            STOP: begin
                if(i_run) n_state <= RUN;
                else if (i_clear) n_state <= CLEAR;
                else n_state <= STOP;
            end
            RUN: begin
                if(i_run) n_state <=STOP;
                else n_state <= RUN;
            end
            CLEAR: begin
                if(i_clear) n_state <= STOP;
                else n_state <= CLEAR;
            end
            default: begin
                n_state <= p_state;
            end
        endcase
    end

    always @(*) begin
        case(p_state)
            STOP: begin
                r_o_run = 1'b0;
                r_o_clear=1'b0;
            end
            RUN: begin
                r_o_run = 1'b1;
                r_o_clear=1'b0;
            end
            CLEAR: begin
                r_o_run=1'b0;
                r_o_clear=1'b1;
            end
            default: begin
                r_o_run = 1'b0;
                r_o_clear=1'b0;
            end
        endcase
    end

    assign o_run= r_o_run;
    assign o_clear = r_o_clear;
    

endmodule