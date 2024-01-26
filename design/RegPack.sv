package PipelineBufferRegisters;
  // Reg A
  typedef struct packed {
    logic [8:0]  CurrPC;
    logic [31:0] CurrInstr;
  } IFID;

  // Reg B
  typedef struct packed {
    logic        ALUSrc;
    logic        MemToReg;
    logic        RegWrite;
    logic        MemRead;
    logic        MemWrite;
    logic [1:0]  ALUOp;
    logic        Branch;
    logic [8:0]  CurrPC;
    logic [31:0] RDOne;
    logic [31:0] RDTwo;
    logic [4:0]  RSOne;
    logic [4:0]  RSTwo;
    logic [4:0]  RD;
    logic [31:0] ImmG;
    logic [2:0]  Func3;
    logic [6:0]  Func7;
    logic [31:0] CurrInstr;
  } IDEX;

  // Reg C
  typedef struct packed {
    logic        RegWrite;
    logic        MemToReg;
    logic        MemRead;
    logic        MemWrite;
    logic [31:0] PCImm;
    logic [31:0] PCFour;
    logic [31:0] ImmOut;
    logic [31:0] ALUResult;
    logic [31:0] RDTwo;
    logic [4:0]  RD;
    logic [2:0]  Func3;
    logic [6:0]  Func7;
    logic [31:0] CurrInstr;
  } EXMEM;

  // Reg D
  typedef struct packed {
    logic        RegWrite;
    logic        MemToReg;
    logic [31:0] PCImm;
    logic [31:0] PCFour;
    logic [31:0] ImmOut;
    logic [31:0] ALUResult;
    logic [31:0] MemReadData;
    logic [4:0]  RD;
    logic [31:0] CurrInstr;
  } MEMWB;
endpackage
