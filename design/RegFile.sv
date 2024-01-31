`timescale 1ns / 1ps

module RegFile #(
        // Parameters
        parameter DATA_WIDTH = 32,    // Number of bits in each register
        parameter ADDRESS_WIDTH = 5,  // Number of registers = 2^ADDRESS_WIDTH
        parameter NUM_REGS = 32
        )
        (
        // Inputs
        input clk,                                // Clock
        input rst,                                // Synchronous reset; If it is asserted (rst=1), all registers are reseted to 0
        input RegWrite,                           // Write signal
        input [ADDRESS_WIDTH-1:0] ReadRegister1,  // First register to be read from
        input [ADDRESS_WIDTH-1:0] ReadRegister2,  // Second register to be read from
        input [ADDRESS_WIDTH-1:0] WriteRegister,  // Address of the register that's supposed to written into
        input [DATA_WIDTH-1:0] WriteData,         // Data that's supposed to be written into the register file

        // Outputs
        output logic [DATA_WIDTH-1:0] ReadData1,  // Contents of RegisterFile[ReadRegister1]
        output logic [DATA_WIDTH-1:0] ReadData2   // Contents of RegisterFile[ReadRegister2]
        );

        integer i;

        logic [DATA_WIDTH-1:0] RegisterFile[NUM_REGS-1:0];

        always @(negedge clk) begin
                if (rst == 1'b1)
                        for (i = 0; i < NUM_REGS; i = i + 1) RegisterFile[i] <= 0;
                else if (rst == 1'b0 && RegWrite == 1'b1) begin
                        RegisterFile[WriteRegister] <= WriteData;
                end
        end

        assign ReadData1 = RegisterFile[ReadRegister1];
        assign ReadData2 = RegisterFile[ReadRegister2];
endmodule
