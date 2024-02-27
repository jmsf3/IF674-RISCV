`timescale 1ns / 1ps

module InstructionMemory #(
        // Parameters
        parameter ADDRESS_WIDTH = 9,                      // Number of memory locations = 2^MEM_ADDRESS_WIDTH.
        parameter INSTRUCTION_WIDTH = 32                  // Width of the instruction.
        )
        (
        // Inputs
        input logic clk,                                  // Clock.
        input logic [ADDRESS_WIDTH-1:0] Address,          // Instruction address that comes from the PC.

        // Outputs
        output logic [INSTRUCTION_WIDTH-1:0] Instruction  // 32-bit instruction.
        );

        logic [INSTRUCTION_WIDTH-1:0] InstructionWire;    // Wire to store the instruction.

        Memory32 Memory32Unit (
                .clk(~clk),
                .DataIn(32'b0),                           // Unused
                .DataOut(InstructionWire),
                .WriteAddress(32'b0),                     // Unused
                .ReadAddress(32'(Address)),
                .WriteEnable(1'b0)                        // Unused
        );

        assign Instruction = InstructionWire;
endmodule
