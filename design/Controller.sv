`timescale 1ns / 1ps

module Controller (
        // Inputs
        input logic [6:0] Opcode,    // 7-bit opcode field from the instruction.

        // Outputs
        output logic [1:0] ALUOp,    // 2-bit opcode field from the instruction:
                                     // - 00: LOAD/STORE/AUIPC;
                                     // - 01: BRANCH;
                                     // - 10: R_TYPE/I_TYPE;
                                     // - 11: U_TYPE/JAL/JALR.

        output logic ALUSrc,         // 0: The second ALU operand comes from the second register file output (ReadData2);
                                     // 1: The second ALU operand is the sign-extended lower 16 bits of the instruction.

        output logic MemRead,        // Data memory contents designated by the address input are put on the ReadData output.
        output logic MemWrite,       // Data memory contents designated by the address input are replaced by the value on the WriteData input.

        output logic MemToReg,       // 0: The value fed to the memory WriteData input comes from the ALU;
                                     // 1: The value fed to the memory WriteData input comes from the data memory.

        output logic RegWrite,       // The register on the WriteRegister input is written with the value on the WriteData input.
        output logic Branch,         // 0: branch is not taken; 1: branch is taken.

        output JALSel,               // 1: Indicates that the jump instruction is a JAL.
        output JALRSel,              // 1: Indicates that the jump instruction is a JALR.
        
        output logic [1:0] RWSel,    // Defines the value of WriteBackData:
                                     // - 00: WriteBackMUXSrc
                                     // - 01: D.PCFour
                                     // - 10: D.ImmOut
                                     // - 11: PCImm
        
        output logic Halt            // 0: continue; 1: halt.
        );

        logic [6:0] LOAD, STORE, R_TYPE, I_TYPE, U_TYPE, BRANCH, JAL, JALR, HALT;

        assign LOAD = 7'b0000011;    // LW, LH, LHU, LB, LBU
        assign STORE = 7'b0100011;   // SW, SH, SB
        assign R_TYPE = 7'b0110011;  // AND, OR, XOR, ADD, SUB, SRL, SRA, SLL, SLT, SLTU
        assign I_TYPE = 7'b0010011;  // ANDI, ORI, XORI, ADDI, SRLI, SRLA, SLLI, SLTI, SLTIU
        assign U_TYPE = 7'b0110111;  // LUI
        assign BRANCH = 7'b1100011;  // BEQ, BNE, BLT, BGE, BLTU, BGEU
        assign JAL = 7'b1101111;     // JAL
        assign JALR = 7'b1100111;    // JALR
        assign HALT = 7'b1110101;    // HALT

        assign ALUOp[0] = (Opcode == U_TYPE || Opcode == BRANCH || Opcode == JAL || Opcode == JALR);
        assign ALUOp[1] = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == U_TYPE || Opcode == JAL || Opcode == JALR);
        assign ALUSrc = (Opcode == LOAD || Opcode == STORE || Opcode == I_TYPE || Opcode == U_TYPE);

        assign MemRead = (Opcode == LOAD);
        assign MemWrite = (Opcode == STORE);

        assign MemToReg = (Opcode == LOAD);
        assign RegWrite = (Opcode == LOAD || Opcode == R_TYPE || Opcode == I_TYPE || Opcode == U_TYPE || Opcode == JAL || Opcode == JALR);
        assign Branch = (Opcode == BRANCH);

        assign JALSel = (Opcode == JAL);
        assign JALRSel = (Opcode == JALR);
        
        assign RWSel[0] = (Opcode == JAL || Opcode == JALR);
        assign RWSel[1] = 0;

        assign Halt = (Opcode == HALT);
endmodule
