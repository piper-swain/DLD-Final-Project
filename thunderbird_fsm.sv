module thunderbird_fsm (
input logic clk,
input logic reset,   //all lights OFF
input logic left,    //Activates left turn signal (flashing L1, L2, L3 as a wave)
input logic right,   //Activates right turn signal (flashing R1, R2, R3 as a wave)
input logic brake,   //Activates brake lights (all lights ON)
input logic hazard,   //Activates hazard lights (all lights ON and flashing)

output logic [5:0] lights, //lights[5:0] = [L3 L2 L1 R1 R2 R3]
output logic [7:0] seven_seg 
//seven_seg[7:0] = [a b c d e f g dp]
);

//PRIORITY HANDLING: brake > hazard > turn signals
//  Finite State Machine (Moore FSM) for controlling the lights based on input signals
typedef enum logic [3:0] { 
    BRAKE_ON,   // Brake signal active (overrides all)
    
    HAZARD_S1,  // L1 R1 ON
    HAZARD_S2,  // L1 R1 L2 R2 ON
    HAZARD_S3,  // L1 R1 L2 R2 L3 R3 ON
    
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
    always_ff @(posedge clk or posedge reset) begin //Synchronous reset
        if (reset)                                  //On reset, go to IDLE state
            current_state <= IDLE;
        else                                       //On each clock cycle, transition to the next state if reset is not active
            current_state <= next_state;           //Transition to next state on each clock cycle
    end

always_comb begin
    //Default values / idle
    next_state = current_state; //Default to stay in the same state

    case (current_state)  //State transition logic based on input signals
        IDLE: begin   //From IDLE, check inputs in order of priority: brake > hazard > left > right
            if (brake)  //If brake is active, go to BRAKE_ON state
                next_state = BRAKE_ON;
            else if (left && right) //If both left and right turn signals are active, go to HAZARD_S1 state
                next_state = HAZARD_S1;
            else if (left) //If left turn signal is active, go to LEFT_S1 state
                next_state = LEFT_S1;
            else if (right) //If right turn signal is active, go to RIGHT_R1 state
                next_state = RIGHT_R1;
        end
        
        BRAKE_ON: begin  //All lights ON 
            if (brake)
                next_state = BRAKE_ON; //Stay in BRAKE_ON state as long as brake is active
            else if (left && right)
                next_state = HAZARD_S1;
            else if (left)
                next_state = LEFT_S1;
            else if (right)
                next_state = RIGHT_R1;
            else
                next_state = IDLE;
            end

        HAZARD_S1: begin  //L1 R1 ON
            //stay in hazard as long as hazard is active, if brake is pressed, go to brake
            if (brake) //If brake is active, override hazard and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else
                next_state = HAZARD_S2;
        end

        HAZARD_S2: begin  //L1 R1 L2 R2 ON
            if (brake) //If brake is active, override hazard and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else
                next_state = HAZARD_S3;
        end

        HAZARD_S3: begin  //L1 R1 L2 R2 L3 R3 ON
            if (brake)
                next_state = BRAKE_ON;
            else if (left && right)
                next_state = HAZARD_S1;
            else if (left)
                next_state = LEFT_S1;
            else if (right)
                next_state = RIGHT_R1;
            else
                next_state = IDLE;
            end

        // Left turn signal sequence
        // on each clock signal, L1 lights up, then L2, then L3, then back to IDLE and repeats as long as left is active
        LEFT_S1: begin
            if (brake) //If brake is active, override turn signal and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else
                next_state = LEFT_S2;
        end

        LEFT_S2: begin
            if (brake) //If brake is active, override turn signal and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else
                next_state =LEFT_S3;
        end

        LEFT_S3: begin
            if (brake) //If brake is active, override turn signal and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else if (left && right)
                next_state = HAZARD_S1;
            else if (left)
                next_state = LEFT_S1;
            else if (right)
                next_state = RIGHT_R1;
            else
                next_state = IDLE;
            end

        // Right turn signal sequence
        // on each clock signal, R1 lights up, then R2, then R3, then back to IDLE and repeats as long as right is active
        RIGHT_R1: begin
            if (brake) //If brake is active, override turn signal and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else
                next_state = RIGHT_R2;
        end
        RIGHT_R2: begin
            if (brake) //If brake is active, override turn signal and go to BRAKE_ON state
                next_state = BRAKE_ON;
            else
                next_state = RIGHT_R3;
        end
        RIGHT_R3: begin
            if (brake)
                next_state = BRAKE_ON;
            else if (left && right)
                next_state = HAZARD_S1;
            else if (right)
                next_state = RIGHT_R1;
            else if (left)
                next_state = LEFT_S1;
            else
                next_state = IDLE;
        end

        default: next_state = IDLE;
    endcase
end

//Output Logic
always_comb begin
    lights = 6'b000000; //Default all lights OFF
    seven_seg = 8'b11111111; //Default all segments OFF (active LOW

    case (current_state)
        IDLE: begin
            seven_seg = 8'b11111111; //All segments OFF
            lights = 6'b000000; //All lights OFF
        end

        BRAKE_ON: begin
            seven_seg = 8'b11000001; //Display 'b' for brake (active LOW)
            lights = 6'b111111; //All lights ON
        end

        HAZARD_S1: begin
            seven_seg = 8'b10010001; //Display 'H' for hazard (active LOW)
            lights = 6'b001100; //L1 R1 ON
        end

        HAZARD_S2: begin
            seven_seg = 8'b10010001; //Display 'H' for hazard (active LOW)
            lights = 6'b011110; // L1 L2 R1 R2 ON
        end

        HAZARD_S3: begin
            seven_seg = 8'b10010001; //Display 'H' for hazard (active LOW)
            lights = 6'b111111; //All lights ON
        end

        LEFT_S1: begin
            seven_seg = 8'b11100011; //Display 'L' for left turn (active LOW)
            lights = 6'b001000; //L1 ON
        end

        LEFT_S2: begin
            seven_seg = 8'b11100011; //Display 'L' for left turn (active LOW)
            lights = 6'b011000; //L1 L2 ON
        end

        LEFT_S3: begin
            seven_seg = 8'b11100011; //Display 'L' for left turn (active LOW)
            lights = 6'b111000; //L1 L2 L3 ON
        end

        RIGHT_R1: begin
            seven_seg = 8'b11110101; //Display 'r' for right turn (active LOW)
            lights = 6'b000100; //R1 ON
        end

        RIGHT_R2: begin
            seven_seg = 8'b11110101; //Display 'r' for right turn (active LOW)
            lights = 6'b000110; //R1 R2 ON
        end

        RIGHT_R3: begin
            seven_seg = 8'b11110101; //Display 'r' for right turn (active LOW)
            lights = 6'b000111; //R1 R2 R3 ON  
        end

        default: begin
            seven_seg = 8'b11111111; //All segments OFF
            lights = 6'b000000; //All lights OFF
        end

    endcase
end

endmodule