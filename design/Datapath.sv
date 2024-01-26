`timescale 1ns / 1ps

import PipelineBufferRegisters::*;

module DataPath #(
    parameter PC_W = 9,  // Program Counter
    parameter INS_W = 32,  // Instruction Width
    parameter RF_ADDRESS = 5,  // Register File Address
    parameter DATA_W = 32,  // Data WriteData
    parameter DM_ADDRESS = 9,  // Data Memory Address
    parameter ALU_CC_W = 4  // ALU Control Code Width
) (
    input  logic                 clk,
    rst,
    RegWrite,
    MemToReg,  // Register file writing enable   // Memory or ALU MUX
    ALUSrc,
    MemWrite,  // Register file or Immediate MUX // Memroy Writing Enable
    MemRead,  // Memroy Reading Enable
    Branch,  // Branch Enable
    input  logic [          1:0] ALUOp,
    input  logic [ALU_CC_W -1:0] ALUCC,      // ALU Control Code ( input of the ALU )
    output logic [          6:0] Opcode,
    output logic [          6:0] Funct7,
    output logic [          2:0] Funct3,
    output logic [          1:0] ALUOpCurr,
    output logic [   DATA_W-1:0] WBData,     //Result After the last MUX

    // Para depuração no tesbench:
    output logic [4:0] RegNum,  //número do registrador que foi escrito
    output logic [DATA_W-1:0] RegData,  //valor que foi escrito no registrador
    output logic RegWriteSignal,  //sinal de escrita no registrador

    output logic WR,  // write enable
    output logic ReadEnable,  // read enable
    output logic [DM_ADDRESS-1:0] Address,  // address
    output logic [DATA_W-1:0] WRData,  // write data
    output logic [DATA_W-1:0] RDData  // read data
);

  logic [PC_W-1:0] PC, PCPlus4, NextPC;
  logic [INS_W-1:0] Instr;
  logic [DATA_W-1:0] Reg1, Reg2;
  logic [DATA_W-1:0] ReadData;
  logic [DATA_W-1:0] SrcB, ALUResult;
  logic [DATA_W-1:0] ExtImm, BrImm, OldPCFour, BrPC;
  logic [DATA_W-1:0] WriteMUXSrc;
  logic PCSel;  // mux select / flush signal
  logic [1:0] FAMUXSel;
  logic [1:0] FBMUXSel;
  logic [DATA_W-1:0] FAMUXResult;
  logic [DATA_W-1:0] FBMUXResult;
  logic RegStall;  //1: PC fetch same, Register not update

  IFID A;
  IDEX B;
  EXMEM C;
  MEMWB D;

  // next PC
  Adder #(9) PCAdder (
      PC,
      9'b100,
      PCPlus4
  );
  Mux2 #(9) PCMUX (
      PCPlus4,
      BrPC[PC_W-1:0],
      PCSel,
      NextPC
  );
  FlopR #(9) PCReg (
      clk,
      rst,
      NextPC,
      RegStall,
      PC
  );
  InstructionMemory InstrMem (
      clk,
      PC,
      Instr
  );

  // IF_ID_Reg A;
  always @(posedge clk) begin
    if ((rst) || (PCSel))   // initialization or flush
        begin
      A.CurrPC <= 0;
      A.CurrInstr <= 0;
    end
        else if (!RegStall)    // Stall
        begin
      A.CurrPC <= PC;
      A.CurrInstr <= Instr;
    end
  end

  //--// The Hazard Detection Unit
  HazardDetection HDetection (
      A.CurrInstr[19:15],
      A.CurrInstr[24:20],
      B.RD,
      B.MemRead,
      RegStall
  );

  // //Register File
  assign Opcode = A.CurrInstr[6:0];

  RegFile RF (
      clk,
      rst,
      D.RegWrite,
      D.RD,
      A.CurrInstr[19:15],
      A.CurrInstr[24:20],
      WriteMUXSrc,
      Reg1,
      Reg2
  );

  assign RegNum = D.RD;
  assign RegData = WriteMUXSrc;
  assign RegWriteSignal = D.RegWrite;

  // //sign extend
  ImmGen EImm (
      A.CurrInstr,
      ExtImm
  );

  // ID_EX_Reg B;
  always @(posedge clk) begin
    if ((rst) || (RegStall) || (PCSel))   // initialization or flush or generate a NOP if hazard
        begin
      B.ALUSrc <= 0;
      B.MemToReg <= 0;
      B.RegWrite <= 0;
      B.MemRead <= 0;
      B.MemWrite <= 0;
      B.ALUOp <= 0;
      B.Branch <= 0;
      B.CurrPC <= 0;
      B.RDOne <= 0;
      B.RDTwo <= 0;
      B.RSOne <= 0;
      B.RSTwo <= 0;
      B.RD <= 0;
      B.ImmG <= 0;
      B.Func3 <= 0;
      B.Func7 <= 0;
      B.CurrInstr <= A.CurrInstr;  //debug tmp
    end else begin
      B.ALUSrc <= ALUSrc;
      B.MemToReg <= MemToReg;
      B.RegWrite <= RegWrite;
      B.MemRead <= MemRead;
      B.MemWrite <= MemWrite;
      B.ALUOp <= ALUOp;
      B.Branch <= Branch;
      B.CurrPC <= A.CurrPC;
      B.RDOne <= Reg1;
      B.RDTwo <= Reg2;
      B.RSOne <= A.CurrInstr[19:15];
      B.RSTwo <= A.CurrInstr[24:20];
      B.RD <= A.CurrInstr[11:7];
      B.ImmG <= ExtImm;
      B.Func3 <= A.CurrInstr[14:12];
      B.Func7 <= A.CurrInstr[31:25];
      B.CurrInstr <= A.CurrInstr;  //debug tmp
    end
  end

  //--// The Forwarding Unit
  ForwardingUnit ForUnit (
      B.RSOne,
      B.RSTwo,
      C.RD,
      D.RD,
      C.RegWrite,
      D.RegWrite,
      FAMUXSel,
      FBMUXSel
  );

  // // //ALU
  assign Funct7 = B.Func7;
  assign Funct3 = B.Func3;
  assign ALUOpCurr = B.ALUOp;

  Mux4 #(32) FAMUX (
      B.RDOne,
      WriteMUXSrc,
      C.ALUResult,
      B.RDOne,
      FAMUXSel,
      FAMUXResult
  );
  Mux4 #(32) FBMUX (
      B.RDTwo,
      WriteMUXSrc,
      C.ALUResult,
      B.RDTwo,
      FBMUXSel,
      FBMUXResult
  );
  Mux2 #(32) SrcBMUX (
      FBMUXResult,
      B.ImmG,
      B.ALUSrc,
      SrcB
  );
  ALU ALUModule (
      FAMUXResult,
      SrcB,
      ALUCC,
      ALUResult
  );
  BranchUnit #(9) BrUnit (
      B.CurrPC,
      B.ImmG,
      B.Branch,
      ALUResult,
      BrImm,
      OldPCFour,
      BrPC,
      PCSel
  );

  // EX_MEM_Reg C;
  always @(posedge clk) begin
    if (rst)   // initialization
        begin
      C.RegWrite <= 0;
      C.MemToReg <= 0;
      C.MemRead <= 0;
      C.MemWrite <= 0;
      C.PCImm <= 0;
      C.PCFour <= 0;
      C.ImmOut <= 0;
      C.ALUResult <= 0;
      C.RDTwo <= 0;
      C.RD <= 0;
      C.Func3 <= 0;
      C.Func7 <= 0;
    end else begin
      C.RegWrite <= B.RegWrite;
      C.MemToReg <= B.MemToReg;
      C.MemRead <= B.MemRead;
      C.MemWrite <= B.MemWrite;
      C.PCImm <= BrImm;
      C.PCFour <= OldPCFour;
      C.ImmOut <= B.ImmG;
      C.ALUResult <= ALUResult;
      C.RDTwo <= FBMUXResult;
      C.RD <= B.RD;
      C.Func3 <= B.Func3;
      C.Func7 <= B.Func7;
      C.CurrInstr <= B.CurrInstr;  // debug tmp
    end
  end

  // // // // Data memory 
  DataMemory DataMem (
      clk,
      C.MemRead,
      C.MemWrite,
      C.ALUResult[8:0],
      C.RDTwo,
      C.Func3,
      ReadData
  );

  assign WR = C.MemWrite;
  assign ReadEnable = C.MemRead;
  assign Address = C.ALUResult[8:0];
  assign WRData = C.RDTwo;
  assign RDData = ReadData;

  // MEM_WB_Reg D;
  always @(posedge clk) begin
    if (rst)   // initialization
        begin
      D.RegWrite <= 0;
      D.MemToReg <= 0;
      D.PCImm <= 0;
      D.PCFour <= 0;
      D.ImmOut <= 0;
      D.ALUResult <= 0;
      D.MemReadData <= 0;
      D.RD <= 0;
    end else begin
      D.RegWrite <= C.RegWrite;
      D.MemToReg <= C.MemToReg;
      D.PCImm <= C.PCImm;
      D.PCFour <= C.PCFour;
      D.ImmOut <= C.ImmOut;
      D.ALUResult <= C.ALUResult;
      D.MemReadData <= ReadData;
      D.RD <= C.RD;
      D.CurrInstr <= C.CurrInstr;  //Debug Tmp
    end
  end

  //--// The LAST Block
  Mux2 #(32) ResMUX (
      D.ALUResult,
      D.MemReadData,
      D.MemToReg,
      WriteMUXSrc
  );

  assign WBData = WriteMUXSrc;

endmodule
