`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2024 10:49:14
// Design Name: 
// Module Name: xyz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench;
    reg I0, I1, x, reset;
    reg sync_clk;          // Synchronous clock for cooling logic
    wire asn_clk;          // Asynchronous clock derived from I0 and I1
    wire cooling, Z;       // Outputs

    // Instantiate the refrigerator controller
    RefrigeratorController uut (
        .I0(I0),
        .I1(I1),
        .x(x),
        .sync_clk(sync_clk),
        .reset(reset),
        .cooling(cooling),
        .Z(Z)
    );

    // Generate the synchronous clock (sync_clk)
    always begin
        #10 sync_clk = ~sync_clk;  // 50% duty cycle clock (20 time units period)
    end

    // Generate the asynchronous clock (asn_clk)
    assign asn_clk = I0 | I1; // Logical OR of I0 and I1 pulses

    // Random behavior of x (temperature condition)
    always begin
        #25 x = $random % 2; // Randomly toggle x every 25 time units
    end

    // Test sequence
    initial begin
        // Initialize inputs
        I0 = 0; I1 = 0; reset = 0;
        sync_clk = 0; x = 0;

        // Apply reset
        #20 reset = 1; // Assert reset
        #20 reset = 0; // Deassert reset

        // Door opens (I1 pulse), Z = 1, cooling off
        #30 I1 = 1; #5 I1 = 0; // Short pulse on I1

        // Door closes (I0 pulse), Z = 0, cooling on (if x = 1)
        #50 I0 = 1; #5 I0 = 0; // Short pulse on I0

        // Random toggling of x
        #40 x = 1; // Cooling should turn on (Z = 0)
        #40 x = 0; // Cooling should turn off
        #60 x = 1;
        #30 x = 0;

        // Door opens again (I1 pulse), cooling off
        #50 I1 = 1; #5 I1 = 0;

        // Door closes again (I0 pulse), cooling resumes
        #50 I0 = 1; #5 I0 = 0;

        // More toggling of x for extended testing
        #30 x = 1;
        #20 x = 0;
        #40 x = 1;

        // End simulation
        #200 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | I0=%b | I1=%b | x=%b | reset=%b | asn_clk=%b | Z=%b | cooling=%b", 
                 $time, I0, I1, x, reset, asn_clk, Z, cooling);
    end
endmodule



