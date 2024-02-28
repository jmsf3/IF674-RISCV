# **Infraestrutura de Hardware - Projeto RISC-V Pipeline 🚀**

Este repositório contém os arquivos do projeto da disciplina Infraestrutura de Hardware (IF674) do CIn-UFPE. O objetivo do projeto é implementar instruções em um processador RISC-V usando SystemVerilog.

## **📁 Estrutura do Repositório**
O repositório está organizado da seguinte forma:
- [`design`](/design): Contém o código-fonte do projeto do processador RISC-V.
- [`sim`](/sim): Contém exemplos de arquivos de simulação e seus resultados esperados.
- [`verif`](/verif): Contém os arquivos de testbench e as instruções de como testar o projeto.

## 📝 **Instruções RV32I**
| #  | Instrução | Implementada | Testada | Funcionando |
|----|-----------|:------------:|:-------:|:-----------:|
| 1  | `LUI`     |     ✅      |    ✅   |     ✅     |
| 2  | `AUPIC`   |     ✅      |    ✅   |     ✅     |
| 3  | `JAL`     |     ✅      |    ✅   |     ✅     |
| 4  | `JALR`    |     ✅      |    ✅   |     ✅     |
| 5  | `BEQ`     |     ✅      |    ✅   |     ✅     |
| 1  | `BNE`     |     ✅      |    ✅   |     ✅     |
| 2  | `BLT`     |     ✅      |    ✅   |     ✅     |
| 3  | `BGE`     |     ✅      |    ✅   |     ✅     |
| 4  | `BLTU`    |     ✅      |    ✅   |     ✅     |
| 5  | `BGEU`    |     ✅      |    ✅   |     ✅     |
| 6  | `LB`      |     ✅      |    ✅   |     ✅     |
| 7  | `LH`      |     ✅      |    ✅   |     ✅     |
| 8  | `LW`      |     ✅      |    ✅   |     ✅     |
| 9  | `LBU`     |     ✅      |    ✅   |     ✅     |
| 10 | `LHU`     |     ✅      |    ✅   |     ✅     |
| 11 | `SB`      |     ✅      |    ✅   |     ✅     |
| 12 | `SH`      |     ✅      |    ✅   |     ✅     |
| 13 | `SW`      |     ✅      |    ✅   |     ✅     |
| 14 | `ADDI`    |     ✅      |    ✅   |     ✅     |
| 15 | `SLTI`    |     ✅      |    ✅   |     ✅     |
| 16 | `SLTIU`   |     ✅      |    ✅   |     ✅     |
| 17 | `XORI`    |     ✅      |    ✅   |     ✅     |
| 18 | `ORI`     |     ✅      |    ✅   |     ✅     |
| 19 | `ANDI`    |     ✅      |    ✅   |     ✅     |
| 20 | `SLLI`    |     ✅      |    ✅   |     ✅     |
| 21 | `SRLI`    |     ✅      |    ✅   |     ✅     |
| 22 | `SRAI`    |     ✅      |    ✅   |     ✅     |
| 23 | `ADD`     |     ✅      |    ✅   |     ✅     |
| 24 | `SUB`     |     ✅      |    ✅   |     ✅     |
| 25 | `SLL`     |     ✅      |    ✅   |     ✅     |
| 26 | `SLT`     |     ✅      |    ✅   |     ✅     |
| 27 | `SLTU`    |     ✅      |    ✅   |     ✅     |
| 28 | `XOR`     |     ✅      |    ✅   |     ✅     |
| 29 | `SRL`     |     ✅      |    ✅   |     ✅     |
| 30 | `SRA`     |     ✅      |    ✅   |     ✅     |
| 31 | `OR`      |     ✅      |    ✅   |     ✅     |
| 32 | `AND`     |     ✅      |    ✅   |     ✅     |
| 33 | `HALT`    |     ✅      |    ✅   |     ✅     |
