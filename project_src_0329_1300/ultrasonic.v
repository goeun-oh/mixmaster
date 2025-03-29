`timescale 1ns / 1ps

module ultrasonic(
    input clk,
    input reset,
    input start, //start_btn 
    input echo, // HC-SR04 Echo Pulse 
    output trig, 
    output [8:0] distance, // test_distance to fnd
    output done,
    output [2:0]o_state
    );


    localparam IDLE = 3'b000, SEND_WAIT =3'b001, SEND = 3'b010, RECEIVE = 3'b011, COUNT = 3'b100, RESULT = 3'b101, IDLE_WAIT = 3'b110; 
    reg [2:0]state, next;

    reg [14:0]e_count, e_count_next; //echo count (0 ~ 23.529msec) = (0 ~ 23529us) /log2(23529) = 14.52
    reg [18:0]w_count, w_count_next; //wait count under 300msec  /log2(300_000) = 18.x
    reg [4:0]s_count, s_count_next; //echo count (0 ~ 20usec) /log2(20) = 4.xx

    reg done_reg, done_next;
    reg trig_reg, trig_next;

    //output
    assign distance = (e_count > 24000)? 9'b111111111:(e_count)/(58);  // cm (0 ~ 400cm)
    //assign distance = (w_count > 49_998)? 9'b111111111:(e_count > 24000)? 9'b111111111:(e_count)/(58);  // cm (0 ~ 400cm)
    assign done = done_reg;
    assign o_state = state;
    assign trig = trig_reg;


    wire tick;


    us_tick_gen #(.FCOUNT(100))U_tick_gen( //1usec
    .clk(clk),
    .rst(reset),
    .tick(tick)
    );

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= 0;
            trig_reg <= 0;
            e_count <= 0; 
            w_count <= 0; 
            s_count <= 0; 
            done_reg <= 0;
        end else begin
            state <= next;
            trig_reg <= trig_next;
            e_count <= e_count_next;
            w_count <= w_count_next;
            s_count <= s_count_next;
            done_reg <= done_next;
            
        end
    end

    always @(*) begin
        next = state;
        trig_next = trig_reg;
        e_count_next = e_count;
        w_count_next = w_count;
        s_count_next = s_count;
        done_next = done_reg;
        case (state)
            IDLE: begin
                next = 0;
                done_next = 1'b0;
                w_count_next = 0;    
                s_count_next = 0;    
                if (start) begin
                    next = SEND_WAIT; 
                end
            end
            SEND_WAIT: begin  //첫번째 틱을 잡기 위함 SEND 가기 전
                if (tick == 1'b1) begin
                    next = SEND;
                end
            end
            SEND: begin
                trig_next = 1'b1;
                if(s_count == 20 - 1) begin //20us 1tick
                        next = RECEIVE;
                        s_count_next = 0;
                end else begin
                        if(tick == 1'b1) begin
                            s_count_next = s_count +1;
                        end
                end
            end
            RECEIVE: begin
                trig_next = 1'b0;
                if (echo) begin
                    e_count_next =0;
                    next = COUNT;
                end else begin
                    if(w_count == 50_000 - 1) begin
                        next = IDLE;
                        w_count_next = 0;
                        e_count_next =0;
                    end else begin
                        if(tick == 1'b1) begin
                            w_count_next = w_count_next +1;
                        end
                    end
                end
            end
            COUNT : begin
                if(echo == 1'b0) begin
                    next = RESULT;
                    end
                else begin
                    if(tick == 1'b1) begin
                        next = COUNT;
                        e_count_next = e_count_next +1; 
                    end
                end
            end
            RESULT: begin
                if(tick ==1'b1) begin
                    done_next = 1'b1;
                    next = IDLE_WAIT;
                end
            end
            IDLE_WAIT: begin
                if(w_count == 300_000 - 1) begin //400ms
                    next = IDLE;
                end else begin
                    if(tick == 1'b1) begin
                        w_count_next = w_count_next +1;
                    end
                end
            end
        endcase
    end
endmodule


module us_tick_gen (
    input  clk,
    input  rst,
    output tick
);
    parameter FCOUNT = 1_000; //10usec
    reg [$clog2(FCOUNT)-1:0] count_reg, count_next;

    reg tick_reg, tick_next;

    //output
    assign tick = tick_reg;

    //state
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            count_reg <= 0;
            tick_reg  <= 0;
        end else begin
            count_reg <= count_next;
            tick_reg  <= tick_next;
        end
    end

    //next
    always @(*) begin
        count_next = count_reg;
        tick_next  = tick_reg;
        if (count_reg ==  FCOUNT- 1) begin
            count_next = 1'b0;
            tick_next  = 1'b1;
        end else begin
            count_next = count_reg + 1;
            tick_next  = 1'b0;
        end
    end
endmodule