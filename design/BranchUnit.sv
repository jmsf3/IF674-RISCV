`timescale 1ns / 1ps

module BranchUnit #(
        // Parameters
        parameter PC_WIDTH = 9
        )
        (
        // Inputs
        input logic [PC_WIDTH-1:0] PC,
        input logic [31:0] ALUResult,
        input logic [31:0] Imm,
        input logic Branch,
        input logic [1:0] RWSel,

        // Outputs
        output logic [31:0] PCFour,
        output logic [31:0] PCImm,
        output logic [31:0] PCBranch,
        output logic PCSel
        );

        // Full PC (32-bit)
        logic [31:0] PCFull;
        assign PCFull = {23'b0, PC};

        // Calculate PC + 4 and PC + Imm
        assign PCFour = PCFull + 32'b100;
        assign PCImm = PCFull + Imm;

        // Check if branch is taken
        logic BranchSel;
        assign BranchSel = (Branch && ALUResult[0]) || (RWSel == 2'b01);  // 1: branch is taken; 0: branch is not taken

        // Calculate PCBranch value
        assign PCBranch = (BranchSel) ? PCImm : 32'b0;                    // PCBranch = PCFull + Imm  //  Otherwise, PCBranch value is not important
        assign PCSel = BranchSel;                                         // 1: branch is taken; 0: branch is not taken, choose PC + 4
endmodule
