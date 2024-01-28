`timescale 1ns / 1ps

module Adder #(
        // Parameters
        parameter WIDTH = 8
        ) 
        (
        // Inputs
        input  logic [WIDTH-1:0] A, B,

        // Outputs
        output logic [WIDTH-1:0] C
        );

        assign C = A + B;
endmodule
