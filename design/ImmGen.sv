`timescale 1ns / 1ps

module ImmGen (
        // Inputs
        input  logic [31:0] InstrCode,

        // Outputs
        output logic [31:0] ImmOut
        );


        always_comb
                case (InstrCode[6:0])
                7'b0010011:  /*I-type arithmetic part*/
                        case(InstrCode[14:12])
                        3'b001:   // SLLI
                                ImmOut = InstrCode[24:20];
                        3'b101:   // SRLI, SRAI
                                ImmOut = InstrCode[24:20];
                        default:  // ANDI, ORI, XORI, ADDI, SLTI
                                ImmOut = {InstrCode[31] ? 20'hFFFFF : 20'b0, InstrCode[31:20]};
                        endcase
                7'b0000011:  /*I-type load part*/
                        ImmOut = {InstrCode[31] ? 20'hFFFFF : 20'b0, InstrCode[31:20]};
                7'b0100011:  /*S-type*/
                        ImmOut = {InstrCode[31] ? 20'hFFFFF : 20'b0, InstrCode[31:25], InstrCode[11:7]};
                7'b1100011:  /*B-type*/
                        ImmOut = {
                                InstrCode[31] ? 19'h7FFFF : 19'b0,
                                InstrCode[31],
                                InstrCode[7],
                                InstrCode[30:25],
                                InstrCode[11:8],
                                1'b0
                        };
                default: 
                        ImmOut = {32'b0};
                endcase
endmodule
