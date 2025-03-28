`timescale 1ns / 1ps

module cu_DHT #(
    parameter DHT_OUT=40
)(
    input clk,
    input rst,
    input i_start,
    input tick_1ms,
    input tick_1us,
    inout io_dht,
    output reg [2:0] led_mode,
    output [DHT_OUT-1:0] dht_out,
    output done,
    output o_tOut
);
    parameter MCU_LOW_CNT=18, SYNC_CNT=8, DATA_LOW=40, 
                MCU_HIGH_CNT=30, TIME_OUT=150, RECEIVED_TIME=40, TIME_OUT_ms=30;
    parameter MAX_BIT=100;
    parameter CNT_10s=10_000;
    /////////FSM STATE////////////
    parameter IDLE=0, MCU_LOW=1, MCU_HIGH=2, WAIT=3,SYNC_LOW=4, SYNC_HIGH=5, DATA_SYNC=6, DATA_L=7, DATA_H=8, DONE=9, STOP=10;
    reg [3:0] state, next;
    reg [1:0] time_state, time_next;
    parameter WAIT_10s=1, DONE_10s=2;
    //////////dht_out////////////
    reg [DHT_OUT -1:0] dht_reg, dht_next;
    reg o_tOut_reg, o_tOut_next;
    reg done_reg, done_next;

    assign dht_out=dht_reg;
    assign done=done_reg;
    assign o_tOut=o_tOut_reg;

    //////////counter////////////////
    reg [$clog2(MAX_BIT)-1:0] counter_reg, counter_next;
    reg [$clog2(RECEIVED_TIME)-1:0] recivedTimes_reg, recivedTimes_next;
    reg [$clog2(TIME_OUT)-1:0] timeOut_reg, timeOut_next;
    reg [$clog2(CNT_10s)-1:0] time_10s_reg, time_10s_next;

    //////////   MCU   //////////
    //mcu enable
    reg io_oe_reg, io_oe_next; 
    //mcu out
    reg r_mcu, n_mcu;

    assign io_dht=io_oe_reg? r_mcu:1'bz;

    ///////// is mcu out Low or High ///////
    reg start_DHT, start_DHT_next;
    reg go_IDLE_reg, go_IDLE_next;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            o_tOut_reg <=0;
            done_reg <=0;
            time_state <=0;
            start_DHT<=0;
            time_10s_reg <=0;
            go_IDLE_reg <=0;
        end else begin
            o_tOut_reg <= o_tOut_next;
            done_reg <= done_next;
            time_state <= time_next;
            start_DHT <=start_DHT_next;
            time_10s_reg <= time_10s_next;
            go_IDLE_reg <= go_IDLE_next;
        end
    end


    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <=0;
            r_mcu <=1'b1; //idle일때 항상 high (pull up 이라서)
            io_oe_reg <= 1'b0;
            counter_reg <=0;
            dht_reg <= 0;
            recivedTimes_reg <=0;
            timeOut_reg <=0;
        end else begin
            state <= next;
            r_mcu <= n_mcu;
            io_oe_reg <= io_oe_next;
            counter_reg <=counter_next;
            dht_reg <= dht_next;
            recivedTimes_reg <= recivedTimes_next;
            timeOut_reg <= timeOut_next;
        end
    end


    always @(*) begin
        next = state;
        n_mcu=r_mcu;
        counter_next = counter_reg;
        io_oe_next = io_oe_reg;
        dht_next=dht_reg;
        recivedTimes_next =recivedTimes_reg;
        done_next=1'b0;
        timeOut_next = timeOut_reg;
        o_tOut_next=o_tOut_reg;
        start_DHT_next=start_DHT;

        case (state)
            IDLE: begin
                led_mode=3'b000;
                n_mcu=1'b1;
                done_next=1'b0;
                timeOut_next=0;
                start_DHT_next=1'b0;
                counter_next=0;
                recivedTimes_next=0;

                if(i_start) begin
                    next=MCU_LOW;
                    o_tOut_next=0;
                    start_DHT_next=1;
                end        
            end

            MCU_LOW: begin
                //18ms 동안 o_mcu LOW 유지
                led_mode=3'b001;
                start_DHT_next=1'b0;
                io_oe_next=1'b1;
                n_mcu=1'b0;
                if(tick_1ms) begin
                    if(counter_reg == MCU_LOW_CNT -1) begin
                        counter_next=0;
                        next= MCU_HIGH;
                    end else begin
                        counter_next=counter_reg+1;
                    end
                end
            end 
                //30us 동안 o_mcu HIGH 유지
            MCU_HIGH: begin    
                n_mcu=1'b1;
                led_mode=3'b010;
                if(tick_1us) begin
                    if(counter_reg == MCU_HIGH_CNT -1) begin
                        io_oe_next = 1'b0;
                        next=WAIT;
                        counter_next=0;
                    end else begin
                        counter_next = counter_reg +1;
                    end
                end
            end

            WAIT: begin
                led_mode=3'b100;
                if(tick_1us &!io_dht) begin
                    next=SYNC_LOW;
                end
            end
            
            SYNC_LOW: begin
                led_mode=3'b101;
                if(tick_1us &io_dht) begin
                    next=SYNC_HIGH;
                end
            end

            SYNC_HIGH: begin
                led_mode=3'b110;
                if(tick_1us & !io_dht) begin
                    next=DATA_SYNC;
                end
            end

            DATA_SYNC: begin
                led_mode=3'b111;
                counter_next=0;
                if(tick_1us) begin
                    if(io_dht) begin
                        next = DATA_H; 
                        timeOut_next=0;
                    end else begin
                        if(timeOut_reg == TIME_OUT-1) begin
                            next=IDLE;
                            timeOut_next=0;
                            o_tOut_next=1'b1;
                        end else begin
                            timeOut_next=timeOut_reg+1;
                        end
                    end
                end
            end

            
            DATA_H: begin
                if(tick_1us) begin
                    if(!io_dht) begin
                        next=DATA_L;
                    end else begin
                        counter_next=counter_reg+1;
                        if(timeOut_next ==TIME_OUT-1) begin
                            next=IDLE;
                            timeOut_next=0;
                            counter_next=0;
                            o_tOut_next=1'b1;
                        end else begin
                            timeOut_next=timeOut_reg+1;
                        end
                    end
                end
            end
//if 는 mux, 다중 if 문은 delay가 생길수 있음
            DATA_L: begin
                if(counter_reg > DATA_LOW) begin
                    dht_next[DHT_OUT-recivedTimes_reg-1]=1'b1;
                end else begin
                    dht_next[DHT_OUT- recivedTimes_reg-1]=1'b0;
                end

                if(recivedTimes_reg == RECEIVED_TIME-1) begin
                    recivedTimes_next=0;
                    next=DONE;
                    counter_next=0;
                    timeOut_next=0;
                end else begin
                    next=DATA_SYNC;
                    counter_next=0;
                    recivedTimes_next=recivedTimes_reg+1;
                    timeOut_next=0;
                end                
            end

            DONE: begin
                led_mode=3'b110;
                if(!io_dht & tick_1us) begin
                    next=STOP;
                    done_next=1'b1;
                end
            end

            STOP: begin
                led_mode=3'b111;
                done_next=1'b0;
                if(go_IDLE_reg) begin
                    next=IDLE;
                end
            end
            
        endcase
    end


    always @(*) begin
        time_next=time_state;
        time_10s_next=time_10s_reg;
        go_IDLE_next=go_IDLE_reg;
        case(time_state)
            IDLE: begin
                go_IDLE_next=1'b0;
                if(start_DHT) begin
                    time_next=WAIT_10s;
                end
            end
            WAIT_10s: begin
                if(tick_1ms) begin
                    if(time_10s_reg == CNT_10s-1) begin
                        time_10s_next=0;
                        time_next=DONE_10s;
                    end else begin
                        time_10s_next=time_10s_reg+1;
                    end
                end
                if(o_tOut_reg) begin
                    time_next=IDLE;
                end
            end
            DONE_10s: begin
                go_IDLE_next=1'b1;
                time_next=IDLE;
            end
        endcase
    end
endmodule
