`timescale 1ns / 1ps

module MUX2 #(
        // Parameters
        parameter WIDTH = 32
        )
        (
        // Inputs
        input logic [WIDTH-1:0] D0, D1,
        input logic S,

        // Outputs
        output logic [WIDTH-1:0] Y
        );

        assign Y = S ? D1 : D0;
endmodule
