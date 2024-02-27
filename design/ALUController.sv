`timescale 1ns / 1ps

// -------------------------------------------------------- //
// OP   | CODE | INSTRUCTIONS           | STATUS            //
// -----|------|----------------------- |------------------ //
// &    | 0000 | AND, ANDI              | OK, OK            //
// |    | 0001 | OR, ORI                | OK, OK            //
// ^    | 0010 | XOR, XORI              | OK, OK            //
// +    | 0011 | LOAD, STORE, ADD, ADDI | OK, (1/3), OK, OK //
// -    | 0100 | SUB                    | OK                //
// >>   | 0101 | SRL, SRLI              | OK, OK            //
// >>>  | 0110 | SRA, SRAI              | OK, OK            //
// <<   | 0111 | SLL, SLLI              | OK, OK            //
// ==   | 1000 | BEQ                    | OK                //
// !=   | 1001 | BNE                    | OK                //
// <    | 1010 | SLT, SLTI, BLT         | OK, OK, OK        //
// >=   | 1011 | BGE                    | OK                //
// SrcA | 1100 | JALR                   | OK                //
// SrcB | 1101 | LUI                    | OK                //
// -------------------------------------------------------- //

module ALUController (
        // Inputs
        input logic [1:0] ALUOp,      // 2-bit opcode field from the instruction:
                                      // - 00: LOAD/STORE/AUIPC;
                                      // - 01: BRANCH;
                                      // - 10: R_TYPE/I_TYPE;
                                      // - 11: U_TYPE/JAL/JALR.
        
        input logic [6:0] Funct7,     // Bits 25 to 31 of the instruction.
        input logic [2:0] Funct3,     // Bits 12 to 14 of the instruction.

        // Outputs
        output logic [3:0] Operation  // Selected ALU operation.
        );

        assign Operation[0] = (ALUOp == 2'b00) ||                                                    // LOAD, STORE
                              ((ALUOp == 2'b10) && (Funct3 == 3'b110)) ||                            // OR, ORI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||  // ADD
                              ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 != 7'b0100000)) ||  // ADDI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // SRL, SRLI
                              ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||  // SLL, SLLI
                              ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||                            // BNE
                              ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||                            // BLT
                              ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||                            // BGE
                              (ALUOp == 2'b11);                                                      // LUI

        assign Operation[1] = (ALUOp == 2'b00) ||                                                    // LOAD, STORE
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
                              (ALUOp == 2'b11) ||                                                    // LUI
                              ((ALUOp == 2'b11) && (Funct3 == 3'b000));                              // JALR

        assign Operation[3] = ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||                            // BEQ
                              ((ALUOp == 2'b01) && (Funct3 == 3'b001)) ||                            // BNE
                              ((ALUOp == 2'b01) && (Funct3 == 3'b100)) ||                            // BLT
                              ((ALUOp == 2'b01) && (Funct3 == 3'b101)) ||                            // BGE
                              ((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000)) ||  // SLT, SLTI
                              (ALUOp == 2'b11) ||                                                    // LUI
                              ((ALUOp == 2'b11) && (Funct3 == 3'b000));                              // JALR
endmodule
