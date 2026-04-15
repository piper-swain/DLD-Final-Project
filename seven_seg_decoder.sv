// ssegout[7:0] = [a b c d e f g dp]  (active-LOW)

module sevenseg_hex (
    input  logic [3:0] hex,
    output logic [7:0] ssegout
);
    logic [6:0] seg; // [ L r H b ] active-low

    always_comb begin
        case (hex)
            4'hL: seg = 7'b0000110; // L
            4'hr: seg = 7'b0001110; // r
            4'hH: seg = 7'b0000110; // H
            4'hb: seg = 7'b0000000; // b
            default: seg = 7'b1111111;
        endcase
    end

    // Pack as [ L r H b ] active-low
    always_comb begin
        ssegout[7:4] = seg[6:3];
        ssegout[3:0] = seg[2:0];
        ssegout[0]   = dp_in;
    end
endmodule
