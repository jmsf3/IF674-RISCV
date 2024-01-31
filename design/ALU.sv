`timescale 1ns / 1ps

module ALU #(
        // Parameters
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        // Inputs
        input logic [DATA_WIDTH-1:0] SrcA,
        input logic [DATA_WIDTH-1:0] SrcB,
        input logic [OPCODE_LENGTH-1:0] Operation,

        // Outputs
        output logic[DATA_WIDTH-1:0] ALUResult
        );

        always_comb
        begin
                case(Operation)
                4'b0000:        // AND, ANDI
                        ALUResult = SrcA & SrcB;
                4'b0001:        // OR, ORI
                        ALUResult = SrcA | SrcB;
                4'b0010:        // XOR, XORI
                        ALUResult = SrcA ^ SrcB;
                4'b0011:        // LOAD, STORE, ADD, ADDI
                        ALUResult = $signed(SrcA) + $signed(SrcB);
                4'b0100:        // SUB
                        ALUResult = $signed(SrcA) - $signed(SrcB);
                4'b0101:        // SRL, SRLI
                        ALUResult = SrcA >> SrcB;
                4'b0110:        // SRA, SRAI
                        ALUResult = $signed(SrcA) >>> $signed(SrcB);
                4'b0111:        // SLL, SLLI
                        ALUResult = SrcA << SrcB;
                4'b1000:        // BEQ
                        ALUResult = (SrcA == SrcB) ? 1 : 0;
                4'b1001:        // BNE
                        ALUResult = (SrcA != SrcB) ? 1 : 0;
                4'b1010:        // SLT, SLTI, BLT
                        ALUResult = (SrcA < SrcB) ? 1 : 0;
                4'b1011:        // BGE
                        ALUResult = (SrcA >= SrcB) ? 1 : 0;
                4'b1100:        // LUI
                        ALUResult = SrcB;
                default:
                        ALUResult = 0;
                endcase
        end
endmodule
