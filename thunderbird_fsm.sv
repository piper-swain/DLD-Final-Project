module thunderbird_fsm (
input logic reset,   //all lights OFF
input logic left,    //Activates left turn signal
input logic right,   //Activates right turn signal
input logic brake,   //Activates brake lights (all lights ON)

output logic lights[5:0], //lights[5:0] = [L3 L2 L1 R1 R2 R3]
output logic seven_seg[7:0] 
//seven_seg[7:0] = [a b c d e f g dp]
);

//PRIORITY HANDLING: brake > hazard > turn signals
    typedef enum logic [1:0] {
        S0, S1, S2, S3
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S0;
        else if (btn_pulse)
            current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            S0: next_state = (din == 0) ? S1 : S0;
            S1: next_state = (din == 1) ? S2 : S1;
            S2: next_state = (din == 1) ? S3 : S1;
            S3: next_state = (din == 0) ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    assign detected = (current_state == S3);



endmodule
