`timescale 1ns / 1ps

module Controller (
        //Inputs
        input logic [6:0] Opcode,  // 7-bit opcode field from the instruction

        //Outputs
        output logic ALUSrc,       // 0: The second ALU operand comes from the second register file output (Read data 2); 
                                   // 1: The second ALU operand is the sign-extended lower 16 bits of the instruction.
        
        output logic MemToReg,     // 0: The value fed to the register Write data input comes from the ALU;
                                   // 1: The value fed to the register Write data input comes from the data memory.
        
        output logic RegWrite,     // The register on the Write register input is written with the value on the Write data input 
        output logic MemRead,      // Data memory contents designated by the address input are put on the Read data output
        output logic MemWrite,     // Data memory contents designated by the address input are replaced by the value on the Write data input.
        output logic [1:0] ALUOp,  // 00: LW/SW; 01:Branch; 10: Rtype/Itype
        output logic Branch        // 0: branch is not taken; 1: branch is taken
        );

        logic [6:0] R_TYPE, I_TYPE, LW, SW, BR;

        assign R_TYPE = 7'b0110011;  // AND, OR, XOR, ADD, SUB, SRL, SRA, SLL, SLT
        assign I_TYPE = 7'b0010011;  // ANDI, ORI, XORI, ADDI, SRLI, SRLA, SLLI, SLTI
        assign LW = 7'b0000011;      // LW
        assign SW = 7'b0100011;      // SW
        assign BR = 7'b1100011;      // BEQ

        assign ALUSrc = (Opcode == I_TYPE || Opcode == LW || Opcode == SW);
        assign MemToReg = (Opcode == LW);
        assign RegWrite = (Opcode == R_TYPE || Opcode == I_TYPE || Opcode == LW);
        assign MemRead = (Opcode == LW);
        assign MemWrite = (Opcode == SW);
        assign ALUOp[0] = (Opcode == BR);
        assign ALUOp[1] = (Opcode == R_TYPE || I_TYPE);
        assign Branch = (Opcode == BR);
endmodule
