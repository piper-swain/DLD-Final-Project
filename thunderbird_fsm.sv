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
    
    // Left turn signal active
    LEFT_S1, // L1 ON
    LEFT_S2, // L1  L2 ON
    LEFT_S3, // L1  L2  L3 ON

    // Right turn signal active
    RIGHT_R1, // R1 ON
    RIGHT_R2, // R1  R2 ON
    RIGHT_R3, // R1  R2  R3 ON
    IDLE      // No signals active
} state_t;

state_t current_state, next_state;

// State transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

always_comb begin
    //Default values / idle
    next_state = current_state; //Default to stay in the same state
    seven_seg = 8'b11111111; //All segments OFF (active LOW)
    lights = 6'b000000; //All lights OFF

    case (current_state)
        IDLE: begin
            if (brake)
                next_state = BRAKE_ON;
            else if (hazard)
                next_state = HAZARD_ON;
            else if (left)
                next_state = LEFT_S1;
            else if (right)
                next_state = RIGHT_R1;
        end
        
        BRAKE_ON: begin
            lights = 6'b111111;
            seven_seg = 8'b0111110; //Display "b" for brake
            next_state = brake ? BRAKE_ON : IDLE; //Stay in BRAKE_ON as long as brake is active
        end

        HAZARD_ON: begin
            //All lights ON and flashing
            lights = 6'b111111;
            seven_seg = 8'b0110111; //Display "H" for hazard
            //stay in hazard as long as hazard is active, if brake is pressed, go to brake
            if (brake)
                next_state = BRAKE_ON;
            else
                next_state = hazard ? HAZARD_ON : IDLE;
        end

        // Left turn signal sequence
        // on each clock signal, L1 lights up, then L2, then L3, then back to IDLE and repeats as long as left is active
        LEFT_S1: begin
            lights = 6'b100000; // L1 ON
            seven_seg = 8'b001110; //Display "L"
            next_state = left ? LEFT_S2 : IDLE;
        end
        LEFT_S2: begin
            lights = 6'b110000; // L1 L2 ON
            seven_seg = 8'b001110; //Display "L"
            next_state = left ? LEFT_S3 : IDLE;
        end
        LEFT_S3: begin
            lights = 6'b111000; // L1 L2 L3 ON
            seven_seg = 8'b001110; //Display "L"
            next_state = left ? LEFT_S1 : IDLE;
        end

        // Right turn signal sequence
        // on each clock signal, R1 lights up, then R2, then R3, then back to IDLE and repeats as long as right is active
        RIGHT_R1: begin
            lights = 6'b000100; // R1 ON
            seven_seg = 8'b000111; //Display "r"
            next_state = right ? RIGHT_R2 : IDLE;
        end
        RIGHT_R2: begin
            lights = 6'b000110; // R1 R2 ON
            seven_seg = 8'b000111; //Display "r"
            next_state = right ? RIGHT_R3 : IDLE;
        end
        RIGHT_R3: begin
            lights = 6'b000111; // R1 R2 R3 ON
            seven_seg = 8'b000111; //Display "r"
            next_state = right ? RIGHT_R1 : IDLE;
        end

        default: next_state = IDLE;
    endcase
end

endmodule
