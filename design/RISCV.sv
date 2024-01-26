`timescale 1ns / 1ps

module RISCV #(
        // Parameters
        parameter DATA_W = 32
        ) 
        (
        // Inputs
        input logic clk, rst,        // Clock and reset signals
        output logic [31:0] WBData,  // The ALU Result

        // Outputs
        output logic [4:0] RegNum,
        output logic [31:0] RegData,
        output logic RegWriteSignal,

        output logic WR,
        output logic RD,
        output logic [8:0] Address,
        output logic [DATA_W-1:0] WRData,
        output logic [DATA_W-1:0] RDData
        );

        logic [6:0] Opcode;
        logic ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch;
        logic [1:0] ALUop;
        logic [1:0] ALUOpReg;
        logic [6:0] Funct7;
        logic [2:0] Funct3;
        logic [3:0] Operation;

        Controller Ctrl (
                Opcode,
                ALUSrc,
                MemToReg,
                RegWrite,
                MemRead,
                MemWrite,
                ALUop,
                Branch
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
                RegWrite,
                MemToReg,
                ALUSrc,
                MemWrite,
                MemRead,
                Branch,
                ALUop,
                Operation,
                Opcode,
                Funct7,
                Funct3,
                ALUOpReg,
                WBData,
                RegNum,
                RegData,
                RegWriteSignal,
                WR,
                RD,
                Address,
                WRData,
                RDData
        );
endmodule
