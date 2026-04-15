module thunderbird_fsm (
input logic clk,
input logic reset,   //all lights OFF
input logic left,    //Activates left turn signal (flashing L1, L2, L3 as a wave)
input logic right,   //Activates right turn signal (flashing R1, R2, R3 as a wave)
input logic brake,   //Activates brake lights (all lights ON)
input logic hazard   //Activates hazard lights (all lights ON and flashing)

output logic lights[5:0], //lights[5:0] = [L3 L2 L1 R1 R2 R3]
output logic seven_seg[7:0] 
//seven_seg[7:0] = [a b c d e f g dp]
);


//PRIORITY HANDLING: brake > hazard > turn signals
//  Finite State Machine (Moore FSM) for controlling the lights based on input signals
typedef enum logic [2:0] { //2:0 because we have 5 states, we need at least 3 bits to encode them
    BRAKE_ON,   // Brake signal active (overrides all)
    HAZARD_ON,  // Both turn signals active (hazard)
    LEFT_ON,    // Left turn signal active
    RIGHT_ON,   // Right turn signal active
    IDLE       // No signals active
} state_t;

state_t current_state, next_state;

// State transition logic
always_ff @(posedge reset or posedge left or posedge right or posedge brake) begin
    if (reset) begin
        current_state <= IDLE;
    end else if (brake) begin
        current_state <= BRAKE_ON;
    end else if (left && right) begin
        current_state <= HAZARD_ON;
    end else if (left) begin
        current_state <= LEFT_ON;
    end else if (right) begin
        current_state <= RIGHT_ON;
    end else begin
        current_state <= IDLE;
    end


endmodule