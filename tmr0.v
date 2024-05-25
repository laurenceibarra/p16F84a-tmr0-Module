module tmr0(
    input wire oscIn,
    input wire t0cki,
    input wire t0cs,
    input wire t0se,
    input wire reset,
    input wire [2:0] ps,
    input wire psa,
    output reg tmr0out,
    output reg t0if,
    output reg clkout
);
    reg [7:0] prescaler;
    reg clk;

    always @ * begin
        if (t0cs) begin
            clk = t0cki ^ t0se;
        end else begin
            clk = oscIn;
        end
        
    end

    always @(posedge clk) begin
        if(!reset) begin
            prescaler <= 8'b0;
        end else if (prescaler == 8'b11111111) begin
            prescaler <= 8'b0;
        end else begin
            prescaler <= prescaler + 1;
        end
    end

    always @ * begin
        if(psa) begin
            clkout = clk;
        end else begin
            clkout = prescaler[ps];
        end
    end

endmodule