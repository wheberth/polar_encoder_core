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
initial n_is_power_of_two: assert (N == (2**$clog2(N))) else $error("[%m]: N is not power of 2");
localparam NSTAGES = $clog2(N);

// Bit storage for the stages
genvar stage, bitn;
wire [NSTAGES-1:0][N-1:0] data;

// Initialize polar encoding mask
logic [NSTAGES-1:0][N-1:0] mask;
integer current_bit, current_stage;

initial begin
    for (current_bit=0; current_bit < N; current_bit++)
        for (current_stage = 0; current_stage < NSTAGES; current_stage++) 
            mask[current_stage][current_bit] = ~current_bit[current_stage];
end

for (stage = 0; stage < NSTAGES-1; stage++) begin
    for (bitn = 0; bitn < N; bitn++)
        assign data[stage+1][bitn] = (mask[stage][bitn]) ? 
            (data[stage][bitn] ^ data[stage][bitn + (1<<stage)]) :
            (data[stage][bitn]) ;
end

assign data[0] = in;
assign out = data[NSTAGES-1];



endmodule
