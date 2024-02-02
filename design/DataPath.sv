`timescale 1ns / 1ps

import PipelineBufferRegisters::*;

module DataPath #(
        // Parameters
        parameter PC_WIDTH = 9,
        parameter DATA_WIDTH = 32,
        parameter REG_ADDRESS_WIDTH = 5,        // Number of registers = 2^REG_ADDRESS_WIDTH
        parameter MEM_ADDRESS_WIDTH = 9,
        parameter INSTRUCTION_WIDTH = 32,
        parameter ALU_CC_WIDTH = 4
        )
        (
        // Inputs
        input  logic clk,
        input  logic rst,
        input  logic ALUSrc,
        input  logic [1:0] ALUOp,
        input  logic MemRead,                   // Memory Reading Enable
        input  logic MemWrite,                  // Register File or Immediate MUX // Memory Writing Enable
        input  logic MemToReg,                  // Register File Writing Enable   // Memory or ALU MUX
        input  logic RegWrite,
        input  logic Branch,                    // Branch Enable
        input  logic [1:0] RWSel,
        input  logic [ALU_CC_WIDTH-1:0] ALUCC,  // ALU Control Code

        // Outputs
        output logic [6:0] Opcode,
        output logic [2:0] Funct3,
        output logic [6:0] Funct7,
        output logic [1:0] CurrALUOp,
        output logic [DATA_WIDTH-1:0] WBData,  // Result After the Last MUX

        // Debugging
        output logic [4:0] RegNum,
        output logic [DATA_WIDTH-1:0] RegData,
        output logic RegWriteSignal,

        output logic WriteEnable,
        output logic ReadEnable,
        output logic [MEM_ADDRESS_WIDTH-1:0] Address,
        output logic [DATA_WIDTH-1:0] WRData,
        output logic [DATA_WIDTH-1:0] RDData
        );

        logic [INSTRUCTION_WIDTH-1:0] Instruction;
        logic [PC_WIDTH-1:0] PC, PCFour, NextPC;
        logic PCSel;                                            // MUX Select / Flush Signal

        logic [DATA_WIDTH-1:0] ReadRegister1, ReadRegister2;
        logic [DATA_WIDTH-1:0] ReadData;

        logic [DATA_WIDTH-1:0] ExtendedImm, BranchImm, OldPCFour, PCBranch;
        logic [DATA_WIDTH-1:0] SrcB, ALUResult;
        logic [DATA_WIDTH-1:0] WriteMUXSrc;
        logic [DATA_WIDTH-1:0] WriteMUXResult;

        logic [DATA_WIDTH-1:0] FAMUXResult;
        logic [1:0] FAMUXSel;

        logic [DATA_WIDTH-1:0] FBMUXResult;
        logic [1:0] FBMUXSel;

        logic RegStall;                                         // 1: PC fetches the same instruction, register does not update

        IFID A;
        IDEX B;
        EXMEM C;
        MEMWB D;

        // Next PC
        Adder #(9) PCAdder (
                PC,
                9'b100,
                PCFour
        );

        Mux2 #(9) PCMUX (
                PCFour,
                PCBranch[PC_WIDTH-1:0],
                PCSel,
                NextPC
        );

        StallFF #(9) PCReg (
                clk,
                rst,
                NextPC,
                RegStall,
                PC
        );

        InstructionMemory InstrMem (
                clk,
                PC,
                Instruction
        );

        // IF/ID Register (A)
        always @(posedge clk) begin
                if ((rst) || (PCSel)) begin    // Initialization | Flush
                        A.CurrPC <= 0;
                        A.CurrInstr <= 0;
                end else if (!RegStall) begin  // Stall
                        A.CurrPC <= PC;
                        A.CurrInstr <= Instruction;
                end
        end

        //--// The Hazard Detection Unit
        HazardDetection HDetection (
                A.CurrInstr[19:15],
                A.CurrInstr[24:20],
                B.WriteRegister,
                B.MemRead,
                RegStall
        );

        // Register File
        assign Opcode = A.CurrInstr[6:0];

        RegFile RF (
                clk,
                rst,
                D.RegWrite,
                A.CurrInstr[19:15],
                A.CurrInstr[24:20],
                D.WriteRegister,
                WriteMUXSrc,
                ReadRegister1,
                ReadRegister2
        );

        assign RegNum = D.WriteRegister;
        assign RegData = WriteMUXResult;
        assign RegWriteSignal = D.RegWrite;

        // Sign extend
        ImmGen EImm (
                A.CurrInstr,
                ExtendedImm
        );

        // ID/EX Register (B)
        always @(posedge clk) begin
                if ((rst) || (RegStall) || (PCSel)) begin  // Initialization | Flush | NOP
                        B.ALUSrc <= 0;
                        B.ALUOp <= 0;
                        B.MemRead <= 0;
                        B.MemWrite <= 0;
                        B.MemToReg <= 0;
                        B.RegWrite <= 0;
                        B.Branch <= 0;
                        B.RWSel <= 0;
                        B.CurrPC <= 0;
                        B.CurrInstr <= A.CurrInstr;  // Debug
                        B.Funct3 <= 0;
                        B.Funct7 <= 0;
                        B.ReadData1 <= 0;
                        B.ReadData2 <= 0;
                        B.ReadRegister1 <= 0;
                        B.ReadRegister2 <= 0;
                        B.WriteRegister <= 0;
                        B.ImmOut <= 0;
                end else begin
                        B.ALUSrc <= ALUSrc;
                        B.ALUOp <= ALUOp;
                        B.MemRead <= MemRead;
                        B.MemWrite <= MemWrite;
                        B.MemToReg <= MemToReg;
                        B.RegWrite <= RegWrite;
                        B.Branch <= Branch;
                        B.RWSel <= RWSel;
                        B.CurrPC <= A.CurrPC;
                        B.CurrInstr <= A.CurrInstr;  // Debug
                        B.Funct3 <= A.CurrInstr[14:12];
                        B.Funct7 <= A.CurrInstr[31:25];
                        B.ReadData1 <= ReadRegister1;
                        B.ReadData2 <= ReadRegister2;
                        B.ReadRegister1 <= A.CurrInstr[19:15];
                        B.ReadRegister2 <= A.CurrInstr[24:20];
                        B.WriteRegister <= A.CurrInstr[11:7];
                        B.ImmOut <= ExtendedImm;
                end
        end

        //--// The Forwarding Unit
        ForwardingUnit ForUnit (
                B.ReadRegister1,
                B.ReadRegister2,
                C.WriteRegister,
                D.WriteRegister,
                C.RegWrite,
                D.RegWrite,
                FAMUXSel,
                FBMUXSel
        );

        // ALU
        assign Funct7 = B.Funct7;
        assign Funct3 = B.Funct3;
        assign CurrALUOp = B.ALUOp;

        Mux4 #(32) FAMUX (
                B.ReadData1,
                WriteMUXSrc,
                C.ALUResult,
                B.ReadData1,
                FAMUXSel,
                FAMUXResult
        );

        Mux4 #(32) FBMUX (
                B.ReadData2,
                WriteMUXSrc,
                C.ALUResult,
                B.ReadData2,
                FBMUXSel,
                FBMUXResult
        );

        Mux2 #(32) SrcBMUX (
                FBMUXResult,
                B.ImmOut,
                B.ALUSrc,
                SrcB
        );

        ALU ALUModule (
                FAMUXResult,
                SrcB,
                ALUCC,
                ALUResult
        );


        BranchUnit #(9) BrUnit (
                B.CurrPC,
                ALUResult,
                B.ImmOut,
                B.Branch,
                B.RWSel,
                OldPCFour,
                BranchImm,
                PCBranch,
                PCSel
        );

        // EX/MEM Register (C)
        always @(posedge clk) begin
                if (rst) begin // Initialization
                        C.MemRead <= 0;
                        C.MemWrite <= 0;
                        C.MemToReg <= 0;
                        C.RegWrite <= 0;
                        C.RWSel <= 0;
                        C.PCFour <= 0;
                        C.PCImm <= 0;
                        C.Funct3 <= 0;
                        C.Funct7 <= 0;
                        C.WriteRegister <= 0;
                        C.ReadData2 <= 0;
                        C.ALUResult <= 0;
                        C.ImmOut <= 0;
                end else begin
                        C.MemRead <= B.MemRead;
                        C.MemWrite <= B.MemWrite;
                        C.MemToReg <= B.MemToReg;
                        C.RegWrite <= B.RegWrite;
                        C.RWSel <= B.RWSel;
                        C.PCFour <= OldPCFour;
                        C.PCImm <= BranchImm;
                        C.CurrInstr <= B.CurrInstr;  // Debug
                        C.Funct3 <= B.Funct3;
                        C.Funct7 <= B.Funct7;
                        C.WriteRegister <= B.WriteRegister;
                        C.ReadData2 <= FBMUXResult;
                        C.ALUResult <= ALUResult;
                        C.ImmOut <= B.ImmOut;
                end
        end

        // Data memory
        DataMemory DataMem (
                clk,
                C.ALUResult[8:0],
                C.ReadData2,
                C.MemRead,
                C.MemWrite,
                C.Funct3,
                ReadData
        );

        assign WriteEnable = C.MemWrite;
        assign ReadEnable = C.MemRead;
        assign Address = C.ALUResult[8:0];
        assign WRData = C.ReadData2;
        assign RDData = ReadData;

        // MEM/WB Register (D)
        always @(posedge clk) begin
                if (rst) begin  // Initialization
                        D.MemToReg <= 0;
                        D.RegWrite <= 0;
                        D.RWSel <= 0;
                        D.PCFour <= 0;
                        D.PCImm <= 0;
                        D.WriteRegister <= 0;
                        D.ReadData <= 0;
                        D.ALUResult <= 0;
                        D.ImmOut <= 0;
                end else begin
                        D.MemToReg <= C.MemToReg;
                        D.RegWrite <= C.RegWrite;
                        D.RWSel <= C.RWSel;
                        D.CurrInstr <= C.CurrInstr;  // Debug
                        D.PCFour <= C.PCFour;
                        D.PCImm <= C.PCImm;
                        D.WriteRegister <= C.WriteRegister;
                        D.ReadData <= ReadData;
                        D.ALUResult <= C.ALUResult;
                        D.ImmOut <= C.ImmOut;
                end
        end

        //--// The LAST Block
        Mux2 #(32) ResMUX (
                D.ALUResult,
                D.ReadData,
                D.MemToReg,
                WriteMUXSrc
        );

        Mux4 #(32) WrsMUX (
                WriteMUXSrc,
                D.PCFour,
                D.ImmOut,
                D.PCImm,
                D.RWSel,
                WriteMUXResult
        );

        assign WBData = WriteMUXResult;
endmodule
