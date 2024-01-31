`timescale 1ns / 1ps

module Mux4 #(
        // Parameters
        parameter WIDTH = 32
        )
        (
        // Inputs
        input logic [WIDTH-1:0] D00, D01, D10, D11,
        input logic [1:0] S,

        // Outputs
        output logic [WIDTH-1:0] Y
        );

        assign Y = (S == 2'b11) ? D11 : (S == 2'b10) ? D10 : (S == 2'b01) ? D01 : D00;
endmodule
