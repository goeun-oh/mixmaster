`timescale 1ns / 1ps


module top_DHT(
    input clk,
    input rst,
    input [2:0] sw,
    input i_btn,
    inout io_dht,
    output [7:0] temp_integral,
    output [7:0] temp_decimal,
    output [7:0] humi_integral,
    output [7:0] humi_decimal,
    output [7:0] parity,
    output o_tOut,
    output o_error
    );
    ////////////tick///////////
    wire w_tick_1us;
    wire w_tick_1ms;
    wire [$clog2(40)-1:0] dht_index;
    wire done;
    wire [40-1:0] dht_out;
    reg [40-1:0] dht_out_reg, dht_out_next;

    wire [7:0] dht_data;
    
    assign humi_integral=dht_out_reg[39:32];
    assign humi_decimal = dht_out_reg[31:24];
    assign temp_integral=dht_out_reg[23:16];
    assign temp_decimal = dht_out_reg[15:8];
    assign parity = dht_out_reg[7:0];
    reg char_sel;

    wire [7:0] humi_sum;
    wire [7:0] temp_sum;
    wire [7:0] sum_all;

/*    btn_debounce U_BTN(
        .clk(clk),
        .reset(rst),
        .i_btn(i_btn),
        .o_btn(w_btn)
    );*/
    //charsel이 0이면 tout, 1이면 error
/*    always @(*) begin
        case({w_tOut, w_error})
            2'b01: char_sel=1'b1;
            2'b10: char_sel=1'b0;
            default: char_sel=1'b0;
        endcase
    end
*/

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            dht_out_reg <=0;
        end else begin
            dht_out_reg <=dht_out_next;
        end
    end
    always @(*) begin
        dht_out_next= dht_out_reg;
        if(done) begin
            dht_out_next=dht_out;
        end
    end

    assign o_error = (parity == sum_all) ? 1'b0:1'b1;
/* 
    fndController  U_FND(
        .clk(clk),
        .reset(rst),
        .char_num_mode(!w_tOut), //1이면 num, 0이면 char
        .char_sel(char_sel),
        .i_num(dht_data),
        .fndFont(fndFont),
        .fndCom(fndCom)
    );*/
/*    
    mux_4X1_8bit U_MUX_4X1(
        .sel(sw),
        .x0(humi_integral),
        .x1(humi_decimal),
        .x2(temp_integral),
        .x3(temp_decimal),
        .x4(parity),
        .y(dht_data)
    );
*/

    ////////led controller////////
    wire [2:0] led_mode;


    led_indicator U_LED(
        .sw_mode(led_mode),
        .led(led)
    );
    

    tick_gen #(
        .TICK(1_000_000)
    )tick_1us(
        .clk(clk),
        .rst(rst),
        .o_tick(w_tick_1us)   
    );

    tick_gen #(
        .TICK(1_000)
    )tick_1ms(
        .clk(clk),
        .rst(rst),
        .o_tick(w_tick_1ms)   
    );

    cu_DHT U_CU(
        .clk(clk),
        .rst(rst),
        .i_start(i_btn),
        .tick_1ms(w_tick_1ms),
        .tick_1us(w_tick_1us),
        .io_dht(io_dht),
//        .led_mode(led_mode),
        .dht_out(dht_out),
        .done(done),
        .o_tOut(o_tOut)
    );
    assign sum_all = humi_integral+humi_decimal+temp_decimal+temp_integral;
endmodule
