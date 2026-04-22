module top (
    input  logic       sysclk_125mhz,
    input  logic [7:0] sw,
    input  logic [3:0] btn,
    input  logic       haz_sw,
    output logic [5:0] led,
    output logic [3:0] sseg_an,
    output logic [7:0] ssegout
);

    logic slow_clk;
    logic debounce_clk;

    logic left;
    logic right;
    logic brake;
    logic reset;

    logic [5:0] lights;
    logic [7:0] seven_seg;

    // Button assignments
    assign left  = btn[0];
    assign right = btn[1];
    assign brake = btn[2];
    assign reset = btn[3];

    // Clock divider
    clock_divider u_clock_divider (
        .clk          (sysclk_125mhz),
        .div_clk      (slow_clk),
        .debounce_clk (debounce_clk)
    );

    // Thunderbird FSM
    thunderbird_fsm u_thunderbird_fsm (
        .clk       (slow_clk),
        .reset     (reset),
        .left      (left),
        .right     (right),
        .brake     (brake),
        .hazard    (haz_sw),
        .lights    (lights),
        .seven_seg (seven_seg)
    );

    // Drive outputs
    assign led[5:0] = lights;

    assign ssegout = seven_seg;

    // Enable only one 7-seg digit (active low)
    assign sseg_an = 4'b1110;

endmodule