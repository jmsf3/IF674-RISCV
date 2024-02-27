`timescale 1ns / 1ps

module BranchController #(
        // Parameters
        parameter PC_WIDTH = 9
        )
        (
        // Inputs
        input logic [PC_WIDTH-1:0] PC,
        input logic [31:0] ALUResult,
        input logic [31:0] Imm,
        input logic Branch,
        input logic JALSel,
        input logic JALRSel,
        input logic [1:0] RWSel,
        input logic Halt,

        // Outputs
        output logic [31:0] PCFour,
        output logic [31:0] PCImm,
        output logic [31:0] PCJALR,
        output logic [31:0] PCBranch,
        output logic PCSel
        );

        // Full PC (32-bit)
        logic [31:0] PCFull;
        assign PCFull = {23'b0, PC};

        // Calculate PC + 4, PC + Imm and ALUResult + Imm
        assign PCFour = PCFull + 32'b100;
        assign PCImm = PCFull + Imm;
        assign PCJALR = ALUResult + Imm;

        // Check if branch is taken
        logic BranchResult;
        assign BranchResult = (Branch && ALUResult[0]);

        logic BranchSel;
        assign BranchSel = BranchResult || JALSel || JALRSel || Halt;                          // 1: branch is taken; 0: branch is not taken

        // Calculate PCBranch value
        assign PCBranch = (BranchSel) ? (JALRSel ? PCJALR : PCImm) : (Halt ? PCFull : 32'b0);  // If branch is taken, choose PCImm or PCJALR; 
                                                                                               // If branch is not taken, choose 0;
                                                                                               // If halt, choose PCFull. 
        assign PCSel = BranchSel;                                                              // 1: branch is taken; 0: branch is not taken, choose PC + 4
endmodule
