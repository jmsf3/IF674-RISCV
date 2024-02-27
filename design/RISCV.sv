`timescale 1ns / 1ps

module RISCV #(
        // Parameters
        parameter DATA_WIDTH = 32
        )
        (
        // Inputs
        input logic clk, rst,

        // Outputs
        output logic RegWriteSignal,
        output logic [4:0] RegNum,
        output logic [31:0] RegData,

        output logic WriteEnable,
        output logic ReadEnable,
        output logic [8:0] Address,
        
        output logic [DATA_WIDTH-1:0] WriteData,
        output logic [DATA_WIDTH-1:0] ReadData,
        output logic [31:0] WriteBackData
        );

        logic [6:0] Opcode;
        logic [1:0] ALUOp, CurrALUOp;
        logic ALUSrc, MemRead, MemWrite, MemToReg, RegWrite, Branch;
        logic [1:0] RWSel;
        logic Halt;

        logic [6:0] Funct7;
        logic [2:0] Funct3;
        logic [3:0] Operation;

        Controller ControllerUnit (
                Opcode,
                ALUOp,
                ALUSrc,
                MemRead,
                MemWrite,
                MemToReg,
                RegWrite,
                Branch,
                RWSel,
                Halt
        );

        ALUController ALUControllerUnit (
                CurrALUOp,
                Funct7,
                Funct3,
                Operation
        );

        DataPath DataPathUnit (
                clk,
                rst,
                ALUOp,
                ALUSrc,
                MemRead,
                MemWrite,
                MemToReg,
                RegWrite,
                Branch,
                RWSel,
                Halt,
                Operation,
                Opcode,
                Funct7,
                Funct3,
                CurrALUOp,
                WriteBackData,
                RegNum,
                RegData,
                RegWriteSignal,
                WriteEnable,
                ReadEnable,
                Address,
                WriteData,
                ReadData
        );
endmodule
