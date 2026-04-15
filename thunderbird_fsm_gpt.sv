module thunderbird_fsm(
    input  logic       clk,
    input  logic       reset,
    input  logic       left,
    input  logic       right,
    input  logic       brake,
    output logic [5:0] lights,
    output logic [2:0] mode
);

    // lights[5:0] mapping:
    // [5] = LA
    // [4] = LB
    // [3] = LC
    // [2] = RA
    // [1] = RB
    // [0] = RC

    typedef enum logic [3:0] {
        IDLE,
        LEFT1, LEFT2, LEFT3,
        RIGHT1, RIGHT2, RIGHT3,
        HAZ1, HAZ2, HAZ3,
        BRAKE
    } state_t;

    state_t state, next_state;

    // State register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always_comb begin
        next_state = state;

        case (state)
            IDLE: begin
                if (brake)
                    next_state = BRAKE;
                else if (left && right)
                    next_state = HAZ1;
                else if (left)
                    next_state = LEFT1;
                else if (right)
                    next_state = RIGHT1;
                else
                    next_state = IDLE;
            end

            // LEFT sequence
            LEFT1: begin
                if (brake)
                    next_state = BRAKE;
                else
                    next_state = LEFT2;
            end

            LEFT2: begin
                if (brake)
                    next_state = BRAKE;
                else
                    next_state = LEFT3;
            end

            LEFT3: begin
                if (brake)
                    next_state = BRAKE;
                else if (left && right)
                    next_state = HAZ1;
                else if (left)
                    next_state = LEFT1;
                else if (right)
                    next_state = RIGHT1;
                else
                    next_state = IDLE;
            end

            // RIGHT sequence
            RIGHT1: begin
                if (brake)
                    next_state = BRAKE;
                else
                    next_state = RIGHT2;
            end

            RIGHT2: begin
                if (brake)
                    next_state = BRAKE;
                else
                    next_state = RIGHT3;
            end

            RIGHT3: begin
                if (brake)
                    next_state = BRAKE;
                else if (left && right)
                    next_state = HAZ1;
                else if (right)
                    next_state = RIGHT1;
                else if (left)
                    next_state = LEFT1;
                else
                    next_state = IDLE;
            end

            // HAZARD sequence
            HAZ1: begin
                if (brake)
                    next_state = BRAKE;
                else
                    next_state = HAZ2;
            end

            HAZ2: begin
                if (brake)
                    next_state = BRAKE;
                else
                    next_state = HAZ3;
            end

            HAZ3: begin
                if (brake)
                    next_state = BRAKE;
                else if (left && right)
                    next_state = HAZ1;
                else if (left)
                    next_state = LEFT1;
                else if (right)
                    next_state = RIGHT1;
                else
                    next_state = IDLE;
            end

            // BRAKE mode
            BRAKE: begin
                if (brake)
                    next_state = BRAKE;
                else if (left && right)
                    next_state = HAZ1;
                else if (left)
                    next_state = LEFT1;
                else if (right)
                    next_state = RIGHT1;
                else
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore FSM)
    always_comb begin
        lights = 6'b000000;
        mode   = 3'd0;

        case (state)
            IDLE: begin
                lights = 6'b000000;
                mode   = 3'd0;
            end

            LEFT1: begin
                lights = 6'b100000; // LA
                mode   = 3'd1;
            end

            LEFT2: begin
                lights = 6'b110000; // LA LB
                mode   = 3'd1;
            end

            LEFT3: begin
                lights = 6'b111000; // LA LB LC
                mode   = 3'd1;
            end

            RIGHT1: begin
                lights = 6'b000100; // RA
                mode   = 3'd2;
            end

            RIGHT2: begin
                lights = 6'b000110; // RA RB
                mode   = 3'd2;
            end

            RIGHT3: begin
                lights = 6'b000111; // RA RB RC
                mode   = 3'd2;
            end

            HAZ1: begin
                lights = 6'b100100; // LA RA
                mode   = 3'd3;
            end

            HAZ2: begin
                lights = 6'b110110; // LA LB RA RB
                mode   = 3'd3;
            end

            HAZ3: begin
                lights = 6'b111111; // all six
                mode   = 3'd3;
            end

            BRAKE: begin
                lights = 6'b111111; // all six
                mode   = 3'd4;
            end

            default: begin
                lights = 6'b000000;
                mode   = 3'd0;
            end
        endcase
    end

endmodule
