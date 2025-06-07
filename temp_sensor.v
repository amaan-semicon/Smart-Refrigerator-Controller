`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2024 21:46:14
// Design Name: 
// Module Name: temp_sensor
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


// Asynchronous Circuit (T Flip-Flop Implementation with Reset)
// Asynchronous Circuit (T Flip-Flop Implementation with Reset)
// Asynchronous Circuit (Door Control with T Flip-Flop)
// Asynchronous Circuit (Door Control with T Flip-Flop)
// Asynchronous Circuit (Door Control with T Flip-Flop and Alarm)
module AsynchronousCircuit (
    input wire I0,      // Door close pulse
    input wire I1,      // Door open pulse
    input wire reset,   // Active-high reset signal
    output reg Z        // Door state (0: closed, 1: open)
);
    reg Q; // T flip-flop state

    always @(posedge I0 or posedge I1 or posedge reset) begin
        if (reset) begin
            Q <= 0;  // Reset state
            Z <= 0;  // Ensure door is initially closed
        end else if (I1) begin
            Q <= ~Q; // Toggle state on I1 (open pulse)
            Z <= 1;  // Door open
        end else if (I0) begin
            Q <= ~Q; // Toggle state on I0 (close pulse)
            Z <= 0;  // Door closed
        end
    end
endmodule





// Synchronous Circuit (Cooling Control with D Flip-Flop)
// Synchronous Circuit (Cooling Control with D Flip-Flop)
module SynchronousCircuit (
    input wire x,      // Temperature condition
    input wire Z,      // Door state (from asynchronous circuit)
    input wire clk,    // Global clock
    output reg Qd      // Cooling state (1: on, 0: off)
);
    always @(posedge clk) begin
        Qd <= x & ~Z; // Cooling is active when x=1 and Z=0 (door closed)
    end
endmodule



// Top-Level Module Integrating Both Circuits
// Top-Level Module Integrating Both Circuits
module RefrigeratorController (
    input wire I0,        // Door close pulse
    input wire I1,        // Door open pulse
    input wire x,         // Temperature condition
    input wire sync_clk,  // Global clock for synchronous system
    input wire reset,     // Reset signal for asynchronous circuit
    output wire cooling,  // Cooling state
    output wire Z         // Door state
);
    // Instantiate the asynchronous circuit
    AsynchronousCircuit async (
        .I0(I0),
        .I1(I1),
        .reset(reset),
        .Z(Z) // Door state output
    );

    // Instantiate the synchronous circuit
    SynchronousCircuit sync (
        .x(x),
        .Z(Z),
        .clk(sync_clk),
        .Qd(cooling) // Cooling state output
    );
endmodule






