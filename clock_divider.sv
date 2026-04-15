module clock_div (
    input logic clk,   //125MHz
    output logic div_clk, //divided clock for counter
    output logic debounce_clk //divided clock for debounce
) ;


    logic [32:0] div;  //counter for clock division
    always_ff @ ( posedge clk ) begin //increment counter on each clock cycle
        div <= div + 1; //increment counter on each clock cycle
    end


    assign div_clk = div[24]; //divided clock for counter (125MHz / 2^25 = ~3.73Hz)
    assign debounce_clk = div[4]; //divided clock for debounce (125MHz / 2^5 = ~3.91MHz)


endmodule