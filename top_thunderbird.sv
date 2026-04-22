module top (
    input logic sysclk_125mhz,
    input logic [7:0] sw,
    input logic [3:0] btn
    output logic [7:0] led
    output logic [3:0] sseg_an
    output logic [7:0] ssegout
);
    logic slow_clk
    logic [2:0] mode;

    clock_divider #(
        .COUNT_MAX(50_000_000)
    ) u_clock_divider (
        .clk_in(sysclk),
        .reset(reset),
        .clk_out(slow_clk)
    );

    thunderbird_fsm u_thunderbird_fsm (
        .clk (slow_clk),
        .reset (reset),
        .left (left),
        .right (right),
        .brake (brake),
        .lights (lights),
        .mode (mode)
    );

    seven_seg_decoder u_seven_seg_decoder (
        .mode (mode),
        .seg (seg)
    );
    
endmodule
