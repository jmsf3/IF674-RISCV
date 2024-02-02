`timescale 1ns / 1ps

module ImmGen (
        // Inputs
        input  logic [31:0] Instruction,

        // Outputs
        output logic [31:0] ImmOut
        );

        always_comb
                case (Instruction[6:0])
                7'b0010011:  /*I-type arithmetic part*/
                        case(Instruction[14:12])
                        3'b001:   // SLLI
                                ImmOut = Instruction[24:20];
                        3'b101:   // SRLI, SRAI
                                ImmOut = Instruction[24:20];
                        default:  // ANDI, ORI, XORI, ADDI, SLTI
                                ImmOut = {Instruction[31] ? 20'hFFFFF : 20'b0, Instruction[31:20]};
                        endcase
                7'b0000011:  /*I-type load part*/
                        ImmOut = {Instruction[31] ? 20'hFFFFF : 20'b0, Instruction[31:20]};
                7'b0100011:  /*S-type*/
                        ImmOut = {Instruction[31] ? 20'hFFFFF : 20'b0, Instruction[31:25], Instruction[11:7]};
                7'b1100011:  /*B-type*/
                        ImmOut = {
                                Instruction[31] ? 19'h7FFFF : 19'b0,
                                Instruction[31],
                                Instruction[7],
                                Instruction[30:25],
                                Instruction[11:8],
                                1'b0
                        };
                7'b0110111: /*LUI*/
                        ImmOut = {Instruction[31:12], 12'b0};
                7'b1101111: /*JAL*/
                        ImmOut = {
                                Instruction[31] ? 11'h7FF : 11'b0,
                                Instruction[31],
                                Instruction[19:12],
                                Instruction[20],
                                Instruction[30:21],
                                1'b0
                        };
                default:
                        ImmOut = {32'b0};
                endcase
endmodule
