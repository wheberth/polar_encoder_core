`default_nettype none
`timescale 1ns/100ps

module polar_encoder_core_tb;

localparam N = 32;

logic [N-1:0] in = 0;
logic [N-1:0] out;

polar_encoder_core #(.N(N)) dut
(
    .in(in),   // N-bit Input 
    .out(out)  // N-bit Output
);

initial begin
    #0
    $stop();
end

endmodule
