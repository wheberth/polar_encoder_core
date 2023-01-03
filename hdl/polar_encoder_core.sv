`default_nettype none
`timescale 1ns/100ps

module polar_encoder_core #(
    parameter N = 32    // Polar codeword length N
)
(
    input  wire [N-1:0] in,   // N-bit Input 
    output reg  [N-1:0] out   // N-bit Output
);

// Make sure N is power of 2
n_is_power_of_two: assert #0 (N == (2**$clog2(N))) else $error("[%m]: N is not power of 2");


endmodule