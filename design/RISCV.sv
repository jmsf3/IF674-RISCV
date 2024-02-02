`timescale 1ns / 1ps

module RISCV #(
        // Parameters
        parameter DATA_WIDTH = 32
        )
        (
        // Inputs
        input logic clk, rst,        // Clock and reset signals
        output logic [31:0] WBData,  // The ALU Result

        // Outputs
        output logic [4:0] RegNum,
        output logic [31:0] RegData,
        output logic RegWriteSignal,

        output logic WriteEnable,
        output logic ReadEnable,
        output logic [8:0] Address,
        output logic [DATA_WIDTH-1:0] WRData,
        output logic [DATA_WIDTH-1:0] RDData
        );

        logic [6:0] Opcode;
        logic ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch;
        logic [1:0] ALUOp, RWSel;
        logic [1:0] ALUOpReg;
        logic [6:0] Funct7;
        logic [2:0] Funct3;
        logic [3:0] Operation;

        Controller Ctrl (
                Opcode,
                ALUOp,
                ALUSrc,
                MemRead,
                MemWrite,
                MemToReg,
                RegWrite,
                Branch,
                RWSel
        );

        ALUController ALUCtrl (
                ALUOpReg,
                Funct7,
                Funct3,
                Operation
        );

        DataPath DP (
                clk,
                rst,
                ALUSrc,
                ALUOp,
                MemRead,
                MemWrite,
                MemToReg,
                RegWrite,
                Branch,
                RWSel,
                Operation,
                Opcode,
                Funct3,
                Funct7,
                ALUOpReg,
                WBData,
                RegNum,
                RegData,
                RegWriteSignal,
                WriteEnable,
                ReadEnable,
                Address,
                WRData,
                RDData
        );
endmodule
