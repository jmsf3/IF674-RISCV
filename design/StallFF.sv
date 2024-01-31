`timescale 1ns / 1ps

module StallFF #(
        // Parameters
        parameter WIDTH = 8
        )
        (
        // Inputs
        input logic clk, rst,
        input logic [WIDTH-1:0] D,
        input logic Stall,

        // Outputs
        output logic [WIDTH-1:0] Q
        );

        always_ff @(posedge clk, posedge rst) begin
                if (rst)
                        Q <= 0;
                else if (!Stall)
                        Q <= D;
        end
endmodule
