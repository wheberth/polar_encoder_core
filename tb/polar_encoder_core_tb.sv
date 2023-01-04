`default_nettype none
`timescale 1ns/100ps

module polar_encoder_core_tb;

localparam N = 32;

// Signals
logic [N-1:0] polar_input;
logic [N-1:0] polar_output;

// Transaction queues
logic [N-1:0] golden_stimulus [] = {'hAAAA, 'hBBBB, 'hCCCC, 'hDDDD}; 
logic [N-1:0] golden_response [] = {'hC000, 'hD000, 'hA000, 'hB000}; 
logic [N-1:0] dut_response [$];


logic clk = 1, reset = 1;
always  #1  clk = ~clk;
initial #10 reset = 0;


polar_encoder_core #(.N(N)) dut
(
    .in (polar_input ),   // N-bit Input 
    .out(polar_output)  // N-bit Output
);

initial begin : simulation
    wait(reset==0);
    drive_stimulus(golden_stimulus, polar_input);
    show_summary();
    $stop();
end


// Driver task
task automatic drive_stimulus(
        input [N-1:0] data [$],
        ref   [N-1:0] polar_input
    );
    foreach(data[i]) begin
        polar_input = data[i];
        // $display("Wrote: 0x%0h", data[i]);           
        @(posedge clk);
    end
endtask

// Scoreboard
task show_summary;
    foreach(golden_stimulus[i]) begin
        assert(dut_response[i]==golden_response[i])
            $display("Input %0d: 0x%0H -> 0x%0H", i, golden_stimulus[i], dut_response[i]);
        else
            $error  ("Input %0d: 0x%0H -> 0x%0H (expected: 0x%0H) <--- ERROR", i, golden_stimulus[i], dut_response[i], golden_response[i]);
    end
endtask

// Monitor
always @(polar_output) begin
    dut_response.push_back(polar_output);
    // $display("Read: 0x%0h", response);
end


endmodule
