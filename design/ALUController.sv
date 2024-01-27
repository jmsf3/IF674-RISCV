`timescale 1ns / 1ps

// -------------------------------- //
// OP     CODE    INSTRUCTIONS      //
// -------------------------------- //
// &   -- 0000 -- AND, ANDI         //
// |   -- 0001 -- OR, ORI           //
// ^   -- 0010 -- XOR, XORI         //
// +   -- 0011 -- LW, SW, ADD, ADDI //
// -   -- 0100 -- SUB               //
// >>  -- 0101 -- SRL, SRLI         //
// >>> -- 0110 -- SRA, SRAI         //
// <<  -- 0111 -- SLL, SLLI         //
// <<< -- 1000 -- SLA, SLAI         // -> (Unused)
// ==  -- 1001 -- BEQ               //
// !=  -- 1010 -- BNE               //
// <   -- 1011 -- SLT, SLTI, BLT    //
// >=  -- 1100 -- BGE               //
// --- -- 1101 -- LUI               //
// -------------------------------- //

module ALUController (
        //Inputs
        input logic [1:0] ALUOp,      // 2-bit opcode field from the Controller -- 00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
        input logic [6:0] Funct7,     // Bits 25 to 31 of the instruction
        input logic [2:0] Funct3,     // Bits 12 to 14 of the instruction

        //Outputs
        output logic [3:0] Operation  // Operation selection for ALU
        );

        assign Operation[0] = (ALUOp == 2'b00) ||                                                    // LW, SW
                ((ALUOp == 2'b10) && (Funct3 == 3'b110) && (Funct7 == 7'b0000000)) ||                // OR
                ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||                // ADD
                ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||                // SRL
                ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||                // SLL
                ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||                                          // BEQ
                ((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000));                  // SLT

        assign Operation[1] = (ALUOp == 2'b00) ||                                                    // LW, SW
                ((ALUOp == 2'b10) && (Funct3 == 3'b100) && (Funct7 == 7'b0000000)) ||                // XOR
                ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) ||                // ADD
                ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||                // SRA
                ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) ||                // SLL
                ((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000));                  // SLT

        assign Operation[2] = ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0100000)) ||  // SUB;
                ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||                // SRL
                ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) ||                // SRA
                ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000));                  // SLL

        assign Operation[3] = ((ALUOp == 2'b01) && (Funct3 == 3'b000)) ||                            // BEQ
                ((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000));                  // SLT
endmodule
