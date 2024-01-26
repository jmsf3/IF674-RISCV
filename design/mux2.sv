`timescale 1ns / 1ps

module Mux2 #(
        // Parameters
        parameter WIDTH = 32
        ) 
        (
        // Inputs 
        input logic [WIDTH-1:0] d0, d1,
        input logic s,

        // Outputs
        output logic [WIDTH-1:0] y
        );

        assign y = s ? d1 : d0;
endmodule
