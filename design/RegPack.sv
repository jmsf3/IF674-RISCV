package PipelineBufferRegisters;
        // Register A
        typedef struct packed {
                logic [8:0]  CurrPC;
                logic [31:0] CurrInstr;
        } IFID;

        // Register B
        typedef struct packed {
                logic [1:0]  ALUOp;
                logic        ALUSrc;
                logic        MemRead;
                logic        MemWrite;
                logic        MemToReg;
                logic        RegWrite;
                logic        Branch;
                logic [1:0]  RWSel;
                logic [8:0]  CurrPC;
                logic [31:0] CurrInstr;
                logic [6:0]  Funct7;
                logic [2:0]  Funct3;
                logic [31:0] ReadData1;
                logic [31:0] ReadData2;
                logic [4:0]  ReadRegister1;
                logic [4:0]  ReadRegister2;
                logic [4:0]  WriteRegister;
                logic [31:0] ImmOut;
        } IDEX;

        // Register C
        typedef struct packed {
                logic        MemRead;
                logic        MemWrite;
                logic        MemToReg;
                logic        RegWrite;
                logic [1:0]  RWSel;
                logic [31:0] PCFour;
                logic [31:0] PCImm;
                logic [31:0] CurrInstr;
                logic [6:0]  Funct7;
                logic [2:0]  Funct3;
                logic [4:0]  WriteRegister;
                logic [31:0] ReadData2;
                logic [31:0] ALUResult;
                logic [31:0] ImmOut;
        } EXMEM;

        // Register D
        typedef struct packed {
                logic        MemToReg;
                logic        RegWrite;
                logic [1:0]  RWSel;
                logic [31:0] CurrInstr;
                logic [31:0] PCFour;
                logic [31:0] PCImm;
                logic [4:0]  WriteRegister;
                logic [31:0] ReadData;
                logic [31:0] ALUResult;
                logic [31:0] ImmOut;
        } MEMWB;
endpackage
