module sevenseg_hex (
    input  logic [10:0] current_state,
    output logic [7:0] ssegout
);
    logic [6:0] seg; 
    // ssegout[7:0] = [a b c d e f g dp]  (active-LOW)
    // L r H b 

    localparam IDLE  = 4'd0;
    localparam LEFT  = 4'd1;
    localparam RIGHT = 4'd2;
    localparam HAZARD= 4'd3;
    localparam BRAKE = 4'd4;

    always_comb begin
        case (current_state)
            IDLE: seg = 7'b1111111; // OFF
            LEFT: seg = 7'b0000110; // L
            RIGHT: seg = 7'b0001110; // r
            HAZARD: seg = 7'b0000110; // H
            BRAKE: seg = 7'b0000000; // b
            default: seg = 7'b1111111;
        endcase
    end

    // Pack as [ L r H b ] active-low
    always_comb begin
        ssegout[7:1] = seg;
        ssegout[0]   = 1'b1; // decimal point OFF
    end

endmodule