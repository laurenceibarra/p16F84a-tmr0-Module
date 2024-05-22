module tmr0(
    input wire oscIn,
    input wire t0cki,
    input wire t0cs,
    input wire t0se,
    input wire psa,
    input wire [2:0] ps,
    input wire [7:0] tmr0in, // for preloading or preset 
    output reg [7:0] tmr0out,
    output reg t0if
);
    reg [7:0] ps_cntr; // for frequency divider and prescaler
    reg [7:0] tmr0; // for timer0 register and overflow
    reg clk;
    reg ps_clkOut; 

    always @ * begin
        // clock selection and edge selection
        if(t0cs) clk <= t0cki ^ t0se; 
        else clk <= oscIn;
    end

    always @(posedge clk) begin

        tmr0 <= tmr0in; // for preloading or preset
        
        if(psa) begin // reference clock
            ps_clkOut <= clk;
        end
        else begin //prescaler
            ps_cntr <= ps_cntr + 1;
            case(ps)
            3'b000: ps_clkOut <= ps_cntr[0]; // Division factor 1:2
            3'b001: ps_clkOut <= ps_cntr[1]; // Division factor 1:4
            3'b010: ps_clkOut <= ps_cntr[2]; // Division factor 1:8
            3'b011: ps_clkOut <= ps_cntr[3]; // Division factor 1:16
            3'b100: ps_clkOut <= ps_cntr[4]; // Division factor 1:32
            3'b101: ps_clkOut <= ps_cntr[5]; // Division factor 1:64
            3'b110: ps_clkOut <= ps_cntr[6]; // Division factor 1:128
            3'b111: ps_clkOut <= ps_cntr[7]; // Division factor 1:256
            default: ps_clkOut <= clk;       // Default output
            endcase
        end
    end 

    always @(posedge ps_clkOut) begin
        if(tmr0 == 8'hFF) begin
            tmr0 <= tmr0in;
            t0if <= 1'b1;
        end
        else begin
            tmr0 <= tmr0 + 1;
            t0if <= 1'b0;
        end
    end

    always @ * begin
        tmr0out = tmr0;
    end

endmodule