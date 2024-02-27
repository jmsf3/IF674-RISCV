`timescale 1ns / 1ps

import PipelineBufferRegisters::*;

module DataPath #(
        // Parameters
        parameter PC_WIDTH = 9,                       // Width of the program counter.
        parameter DATA_WIDTH = 32,                    // Width of the data bus.
        parameter REG_ADDRESS_WIDTH = 5,              // Number of registers = 2^REG_ADDRESS_WIDTH.
        parameter MEM_ADDRESS_WIDTH = 9,              // Number of memory locations = 2^MEM_ADDRESS_WIDTH.
        parameter INSTRUCTION_WIDTH = 32,             // Width of the instruction.
        parameter ALU_CC_WIDTH = 4                    // Width of the ALU control code.
        )
        (
        // Inputs
        input  logic clk,
        input  logic rst,

        input  logic [1:0] ALUOp,                     // ALU operation selector.
        input  logic ALUSrc,                          // ALU source selector.

        input  logic MemRead,                         // Memory reading enable.
        input  logic MemWrite,                        // Register file or immediate MUX // Memory writing enable.
      
        input  logic MemToReg,                        // Memory or ALU MUX selector.
        input  logic RegWrite,                        // Register file writing enable.
      
        input  logic Branch,                          // Branch enable.
        input  logic [1:0] RWSel,                     // WriteBackData MUX selector.
        input  logic Halt,                            // Halt signal.
      
        input  logic [ALU_CC_WIDTH-1:0] ALUCC,        // ALU control code.

        // Outputs
        output logic [6:0] Opcode,                    // Opcode of the current instruction.
        output logic [6:0] Funct7,                    // Funct7 of the current instruction.
        output logic [2:0] Funct3,                    // Funct3 of the current instruction.
        output logic [1:0] CurrALUOp,                 // ALUOp of the current instruction.
        output logic [DATA_WIDTH-1:0] WriteBackData,  // Result of the last stage of the pipeline.

        // Debugging
        output logic [4:0] RegNum,                    // Register number.
        output logic [DATA_WIDTH-1:0] RegData,        // Register data.
        output logic RegWriteSignal,                  // Register writing signal.

        output logic WriteEnable,                     // Memory writing enable.
        output logic ReadEnable,                      // Memory reading enable.
        output logic [MEM_ADDRESS_WIDTH-1:0] Address, // Memory address.
        output logic [DATA_WIDTH-1:0] WRData,         // Memory writing data.
        output logic [DATA_WIDTH-1:0] RDData          // Memory reading data.
        );

        logic [INSTRUCTION_WIDTH-1:0] Instruction;                          // Instruction register.
        logic [PC_WIDTH-1:0] PC, PCFour, NextPC;                            // Program counter values.
        logic PCSel;                                                        // MUX selector for the next PC / Flush signal.

        logic [DATA_WIDTH-1:0] ReadRegister1, ReadRegister2;                // Register file read data.
        logic [DATA_WIDTH-1:0] ReadData;                                    // Data memory read data.

        logic [DATA_WIDTH-1:0] ExtendedImm, BranchImm, OldPCFour, PCBranch; // Immediate values.
        logic [DATA_WIDTH-1:0] SrcB, ALUResult;                             // ALU inputs and outputs.
        logic [DATA_WIDTH-1:0] WriteBackMUXSrc;                             // WriteBackData MUX input.
        logic [DATA_WIDTH-1:0] WriteBackMUXResult;                          // WriteBackData MUX output.     

        logic [DATA_WIDTH-1:0] FAMUXResult;                                 // Forwarding A MUX output.
        logic [1:0] FAMUXSel;                                               // Forwarding A MUX selector.

        logic [DATA_WIDTH-1:0] FBMUXResult;                                 // Forwarding B MUX output.
        logic [1:0] FBMUXSel;                                               // Forwarding B MUX selector.

        logic RegStall;                                                     // 1: PC fetches the same instruction, register does not update.
        
        IFID A;                                                             // IF/ID register.
        IDEX B;                                                             // ID/EX register.
        EXMEM C;                                                            // EX/MEM register.
        MEMWB D;                                                            // MEM/WB register.

        // Calculate the next PC value.
        Adder #(9) PCAdder (
                PC,
                9'b100,
                PCFour
        );

        // Select the next PC value.
        MUX2 #(9) PCMUX (
                PCFour,
                PCBranch[PC_WIDTH-1:0],
                PCSel,
                NextPC
        );
        
        // Stall the PC if the register file is not updated.
        Stall #(9) StallUnit (
                clk,
                rst,
                NextPC,
                RegStall,
                PC
        );
        
        // Instruction memory.
        InstructionMemory InstructionMemoryModule (
                clk,
                PC,
                Instruction
        );

        // IF/ID Register (A)
        always @(posedge clk) begin
                if ((rst) || (PCSel)) begin    // Initialization | Flush.
                        A.CurrPC <= 0;
                        A.CurrInstr <= 0;
                end else if (!RegStall) begin  // Stall.
                        A.CurrPC <= PC;
                        A.CurrInstr <= Instruction;
                end
        end

        // Hazard detection unit.
        HazardDetection HazardDetectionUnit (
                A.CurrInstr[19:15],
                A.CurrInstr[24:20],
                B.WriteRegister,
                B.MemRead,
                RegStall
        );

        // Register file.
        assign Opcode = A.CurrInstr[6:0];

        RegFile RF (
                clk,
                rst,
                D.RegWrite,
                A.CurrInstr[19:15],
                A.CurrInstr[24:20],
                D.WriteRegister,
                WriteBackMUXSrc,
                ReadRegister1,
                ReadRegister2
        );

        assign RegNum = D.WriteRegister;
        assign RegData = WriteBackMUXResult;
        assign RegWriteSignal = D.RegWrite;

        // Sign extension.
        ImmGen EImm (
                A.CurrInstr,
                ExtendedImm
        );

        // ID/EX Register (B)
        always @(posedge clk) begin
                if ((rst) || (RegStall) || (PCSel)) begin  // Initialization | Flush | NOP.
                        B.ALUOp <= 0;
                        B.ALUSrc <= 0;
                        B.MemRead <= 0;
                        B.MemWrite <= 0;
                        B.MemToReg <= 0;
                        B.RegWrite <= 0;
                        B.Branch <= 0;
                        B.RWSel <= 0;
                        B.Halt <= 0;
                        B.CurrPC <= 0;
                        B.CurrInstr <= A.CurrInstr;  // Debug.
                        B.Funct7 <= 0;
                        B.Funct3 <= 0;
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
                        B.Halt <= Halt;
                        B.CurrPC <= A.CurrPC;
                        B.CurrInstr <= A.CurrInstr;  // Debug.
                        B.Funct7 <= A.CurrInstr[31:25];
                        B.Funct3 <= A.CurrInstr[14:12];
                        B.ReadData1 <= ReadRegister1;
                        B.ReadData2 <= ReadRegister2;
                        B.ReadRegister1 <= A.CurrInstr[19:15];
                        B.ReadRegister2 <= A.CurrInstr[24:20];
                        B.WriteRegister <= A.CurrInstr[11:7];
                        B.ImmOut <= ExtendedImm;
                end
        end

        // Forwarding unit.
        Forwarding ForwardingUnit (
                B.ReadRegister1,
                B.ReadRegister2,
                C.WriteRegister,
                D.WriteRegister,
                C.RegWrite,
                D.RegWrite,
                FAMUXSel,
                FBMUXSel
        );

        // ALU unit.
        assign Funct7 = B.Funct7;
        assign Funct3 = B.Funct3;
        assign CurrALUOp = B.ALUOp;

        MUX4 #(32) FAMUX (
                B.ReadData1,
                WriteBackMUXSrc,
                C.ALUResult,
                B.ReadData1,
                FAMUXSel,
                FAMUXResult
        );

        MUX4 #(32) FBMUX (
                B.ReadData2,
                WriteBackMUXSrc,
                C.ALUResult,
                B.ReadData2,
                FBMUXSel,
                FBMUXResult
        );

        MUX2 #(32) SrcBMUX (
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

        BranchController #(9) BranchControllerUnit (
                B.CurrPC,
                ALUResult,
                B.ImmOut,
                B.Branch,
                B.RWSel,
                B.Halt,
                OldPCFour,
                BranchImm,
                PCBranch,
                PCSel
        );

        // EX/MEM Register (C)
        always @(posedge clk) begin
                if (rst) begin // Initialization.
                        C.MemRead <= 0;
                        C.MemWrite <= 0;
                        C.MemToReg <= 0;
                        C.RegWrite <= 0;
                        C.RWSel <= 0;
                        C.PCFour <= 0;
                        C.PCImm <= 0;
                        C.Funct7 <= 0;
                        C.Funct3 <= 0;
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
                        C.CurrInstr <= B.CurrInstr;  // Debug.
                        C.Funct7 <= B.Funct7;
                        C.Funct3 <= B.Funct3;
                        C.WriteRegister <= B.WriteRegister;
                        C.ReadData2 <= FBMUXResult;
                        C.ALUResult <= ALUResult;
                        C.ImmOut <= B.ImmOut;
                end
        end

        // Data memory.
        DataMemory DataMemoryModule (
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

        // Define the WriteBackData result.
        MUX2 #(32) ResMUX (
                D.ALUResult,
                D.ReadData,
                D.MemToReg,
                WriteBackMUXSrc
        );

        MUX4 #(32) WrsMUX (
                WriteBackMUXSrc,
                D.PCFour,
                D.ImmOut,
                D.PCImm,
                D.RWSel,
                WriteBackMUXResult
        );

        assign WriteBackData = WriteBackMUXResult;
endmodule
