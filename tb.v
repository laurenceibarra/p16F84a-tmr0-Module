`include "tmr0.v"

module tb;
    reg oscIn;
    reg t0cki;
    reg t0cs;
    reg t0se;
    reg reset;
    reg psa;
    reg [2:0] ps;
    wire tmr0out;
    wire t0if;

tmr0 uut(
    .oscIn(oscIn),
    .t0cki(t0cki),
    .t0cs(t0cs),
    .t0se(t0se),
    .reset(reset),
    .ps(ps),
    .psa(psa),
    .tmr0out(tmr0out),
    .t0if(t0if)
);

always #5 oscIn = ~oscIn;

initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    reset = 0;
    oscIn = 0;
    t0cki = 0;
    t0cs = 0;
    t0se = 0;
    psa = 0;
    ps = 1;

    #10 reset = 1;

    repeat(100) @(posedge oscIn);
    $finish;
end
endmodule