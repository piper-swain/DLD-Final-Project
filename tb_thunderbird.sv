`timescale 1ns/1ps

module tb;

    logic clk;
    logic reset;   //all lights OFF
    logic left;    //Activates left turn signal (flashing L1, L2, L3 as a wave)
    logic right;   //Activates right turn signal (flashing R1, R2, R3 as a wave)
    logic brake;   //Activates brake lights (all lights ON)
    logic hazard;   //Activates hazard lights (all lights ON and flashing)


    logic [5:0] lights; //lights[5:0] = [L3 L2 L1 R1 R2 R3]
    logic [7:0] seven_seg; //seven_seg[7:0] = [a b c d e f g dp]

    // Instantiate the DUT (Device Under Test)
thunderbird_fsm dut (
    .clk(clk),
    .reset(reset),
    .left(left),
    .right(right),
    .hazard(hazard),
    .brake(brake),
    .lights(lights),
    .seven_seg(seven_seg)
);

    // Clock
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
    // Initialize
    clk = 0;
    reset = 0;
    left = 0;
    right = 0;
    brake = 0;
    hazard = 0;
    
    // Apply reset
    #10 reset = 1;
    
    // Test 1: No input (idle state)
    #20;
    $display("Test 1: Idle state - left=%b, right=%b, hazard=%b", left, right, hazard);
    
    // Test 2: Left turn signal
    #20 left = 1;
    #20;
    $display("Test 2: Left input - left=%b, right=%b, hazard=%b", left, right, hazard);
    #20;
    $display("Step 2 - out=%b", lights);
    #20;
    $display("Step 3 - out=%b", lights);
    
    // Test 3: Release left, apply right turn signal
    #20 left = 0;
    #20 right = 1;
    #20;
    $display("Test 3: Right input - left=%b, right=%b, hazard=%b", left, right, hazard);
    #20;
    $display("Step 2 - out=%b", lights);
    #20;
    $display("Step 3 - out=%b", lights);
    
    // Test 4: Both signals (hazard)
    #20 left = 1;
    #20;
    $display("Test 4: Both inputs - left=%b, right=%b, hazard=%b", left, right, hazard);
    #20;
    $display("Step 2 - out=%b", lights);
    
    // Test 5: Return to idle
    #20 left = 0;
    #20 right = 0;
    #20;
    $display("Test 5: Back to idle - left=%b, right=%b, hazard=%b", left, right, hazard);
    
    // Test 6: Reset during operation
    #20 left = 1;
    #10 reset = 0;
    #10 reset = 1;
    #20;
    $display("Test 6: Reset applied - out=%b", lights);
    
    #50 $finish;
end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | left=%b | right=%b | hazard=%b", 
            $time, clk, reset, left, right, hazard);
    end

endmodule
