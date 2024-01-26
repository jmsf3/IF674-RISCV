`timescale 1ns / 1ps

module BranchUnit #(
    parameter PC_W = 9
) (
    input logic [PC_W-1:0] CurrPC,
    input logic [31:0] Imm,
    input logic Branch,
    input logic [31:0] ALUResult,
    output logic [31:0] PCImm,
    output logic [31:0] PCFour,
    output logic [31:0] BrPC,
    output logic PCSel
);

  logic BranchSel;
  logic [31:0] PCFull;

  assign PCFull = {23'b0, CurrPC};

  assign PCImm = PCFull + Imm;
  assign PCFour = PCFull + 32'b100;
  assign BranchSel = Branch && ALUResult[0];  // 0:Branch is taken; 1:Branch is not taken

  assign BrPC = (BranchSel) ? PCImm : 32'b0;  // Branch -> PC+Imm   // Otherwise, BrPC value is not important
  assign PCSel = BranchSel;  // 1:branch is taken; 0:branch is not taken(choose pc+4)

endmodule
