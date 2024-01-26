`timescale 1ns / 1ps

module Mux4 #(
        // Parameters
        parameter WIDTH = 32
        ) 
        (
        // Inputs 
        input logic [WIDTH-1:0] d00, d01, d10, d11,
        input logic [1:0] s,

        // Outputs
        output logic [WIDTH-1:0] y
        );

        assign y = (s == 2'b11) ? d11 : (s == 2'b10) ? d10 : (s == 2'b01) ? d01 : d00;
endmodule
