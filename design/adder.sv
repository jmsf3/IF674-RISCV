`timescale 1ns / 1ps

module Adder #(
        // Parameters
        parameter WIDTH = 8
        ) 
        (
        // Inputs
        input  logic [WIDTH-1:0] a, b,

        // Outputs
        output logic [WIDTH-1:0] y
        );

        assign y = a + b;
endmodule
