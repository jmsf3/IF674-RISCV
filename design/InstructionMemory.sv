`timescale 1ns / 1ps

module InstructionMemory #(
        // Parameters
        parameter INS_ADDRESS = 9,
        parameter INS_W = 32
        ) 
        (
        // Inputs
        input logic clk,                             // Clock
        input logic [INS_ADDRESS -1:0] ReadAddress,  // Read address of the instruction memory, comes from PC

        // Outputs
        output logic [INS_W -1:0] ReadData           // Read Data
        );

        logic [INS_W-1 : 0] GetDataOut;              // Data output from the memory

        Memory32 MemInstr (
                .ReadAddress(32'(ReadAddress)),
                .WriteAddress(32'b0),               // Unused
                .clk(~clk),
                .DataIn(32'b0),                     // Unused
                .DataOut(GetDataOut),
                .WR(1'b0)                           // Unused
        );

        assign ReadData = GetDataOut;
endmodule
