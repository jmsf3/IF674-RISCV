`timescale 1ns / 1ps

// -------------------------------------------------------- //
// OP  | CODE | INSTRUCTIONS         | STATUS               //
// ----|------|----------------------|--------------------- //
// &   | 0000 | AND, ANDI            | OK, OK               //
// |   | 0001 | OR, ORI              | OK, OK               //
// ^   | 0010 | XOR, XORI            | OK, OK               //
// +   | 0011 | LW, LH, LHU, LB, LBU | OK, OK, OK, OK, OK   //
//     |      | SW, SH, SB           | OK, PENDING, PENDING //
//     |      | ADD, ADDI            | OK, OK               //
// -   | 0100 | SUB                  | OK                   //
// >>  | 0101 | SRL, SRLI            | OK, OK               //
// >>> | 0110 | SRA, SRAI            | OK, OK               //
// <<  | 0111 | SLL, SLLI            | OK, OK               //
// ==  | 1000 | BEQ                  | OK                   //
// !=  | 1001 | BNE                  | OK                   //
// <   | 1010 | SLT, SLTI, BLT       | OK, OK, OK           //
// >=  | 1011 | BGE                  | OK                   //
// --- | 1100 | LUI                  | OK                   //
// -------------------------------------------------------- //

module ALUController (
        // Inputs
        input logic [1:0] ALUOp,      // 2-bit opcode field from the Controller -- 00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
        input logic [6:0] Funct7,     // Bits 25 to 31 of the instruction
        input logic [2:0] Funct3,     // Bits 12 to 14 of the instruction

        // Outputs
        output logic [3:0] Operation  // Operation selection for ALU
        );

        assign Operation[0] = (ALUOp == 2'b00) ||                                                    // LW, SW
                              ((ALUOp == 2'b10) && (Funct3 == 3'b110)) ||                            // OR, ORI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||  // ADD
                              ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 != 7'b0100000)) ||  // ADDI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // SRL, SRLI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||  // SLL, SLLI
                              ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||                            // BNE
                              ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||                            // BLT
                              ((ALUOp == 2'b01) && (Funct3 == 3'b101));                              // BGE

        assign Operation[1] = (ALUOp == 2'b00) ||                                                    // LW, SW
                              ((ALUOp == 2'b10) && (Funct3 == 3'b100)) ||                            // XOR, XORI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||  // ADD
                              ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 != 7'b0100000)) ||  // ADDI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||  // SRA, SRAI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||  // SLL, SLLI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000)) ||  // SLT, SLTI
                              ((ALUOp == 2'b01) && (Funct3 == 3'b101));                              // BGE

        assign Operation[2] = ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) ||  // SUB
                              ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // SRL, SRLI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||  // SRA, SRAI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||  // SLL, SLLI
                              (ALUOp == 2'b11);                                                      // LUI

        assign Operation[3] = ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||                            // BEQ
                              ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||                            // BNE
                              ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||                            // BLT
                              ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||                            // BGE
                              ((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000)) ||  // SLT, SLTI
                              (ALUOp == 2'b11);                                                      // LUI
endmodule
