/*-----------------------------------------------------------------------------
-- Title        : Memória da CPU
-- Project      : CPU 
--------------------------------------------------------------------------------
-- File	        : Memoria32.sv
-- Author       : Lucas Fernando da Silva Cambuim <lfsc@cin.ufpe.br>
-- Organization : Universidade Federal de Pernambuco
-- Created      : 20/09/2018
-- Last update  : 20/09/2018
-- Plataform    : DE2
-- Simulators   : ModelSim
-- Synthesizers	: 
-- Targets      : 
-- Dependency   : 
--------------------------------------------------------------------------------
-- Description	: Entidade responsável pela leitura e escrita em memória (dados de 32 bits).
--------------------------------------------------------------------------------
-- Copyright (c) notice
-- Universidade Federal de Pernambuco (UFPE).
-- CIn - Centro de Informatica.
-- Developed by computer science researchers.
-- This code may be used for educational and non-educational purposes as 
-- long as its copyright notice remains unchanged. 
------------------------------------------------------------------------------*/

module Memory32 (
        input wire [31:0] ReadAddress,
        input wire [31:0] WriteAddress,
        input wire clk,
        input wire [31:0] DataIn,
        output wire [31:0] DataOut,
        input wire WR
        );

        wire [15:0] ReadUsefullAddress = ReadAddress[15:0];

        wire [15:0] AddS0 = ReadUsefullAddress + 0;
        wire [15:0] AddS1 = ReadUsefullAddress + 1;
        wire [15:0] AddS2 = ReadUsefullAddress + 2;
        wire [15:0] AddS3 = ReadUsefullAddress + 3;

        wire [15:0] WriteUsefullAddress = WriteAddress[15:0];

        wire [15:0] WAddS0 = WriteUsefullAddress + 0;
        wire [15:0] WAddS1 = WriteUsefullAddress + 1;
        wire [15:0] WAddS2 = WriteUsefullAddress + 2;
        wire [15:0] WAddS3 = WriteUsefullAddress + 3;

        wire [7:0] InS0;
        wire [7:0] InS1;
        wire [7:0] InS2;
        wire [7:0] InS3;

        wire [7:0] OutS0;
        wire [7:0] OutS1;
        wire [7:0] OutS2;
        wire [7:0] OutS3;

        assign DataOut[31:24] = OutS3;
        assign DataOut[23:16] = OutS2;
        assign DataOut[15:8] = OutS1;
        assign DataOut[7:0] = OutS0;

        assign InS3 = DataIn[31:24];
        assign InS2 = DataIn[23:16];
        assign InS1 = DataIn[15:8];
        assign InS0 = DataIn[7:0];

        // Bancos de Memória (65536 bytes)
  
        // 0
        ramOnChip32 #(
                .ramSize(65536),
                .ramWide(8)
                ) memBlock0 (
                        .clk(clk),
                        .data(InS0),
                        .radd(AddS0),
                        .wadd(WAddS0),
                        .wren(WR),
                        .q(OutS0)
                );

        //1
        ramOnChip32 #(
                .ramSize(65536),
                .ramWide(8)
                ) memBlock1 (
                        .clk(clk),
                        .data(InS1),
                        .radd(AddS1),
                        .wadd(WAddS1),
                        .wren(WR),
                        .q(OutS1)
                );

        // 2
        ramOnChip32 #(
                .ramSize(65536),
                .ramWide(8)
                ) memBlock2 (
                        .clk(clk),
                        .data(InS2),
                        .radd(AddS2),
                        .wadd(WAddS2),
                        .wren(WR),
                        .q(OutS2)
                );

        // 3
        ramOnChip32 #(
                .ramSize(65536),
                .ramWide(8)
                ) memBlock3 (
                        .clk(clk),
                        .data(InS3),
                        .radd(AddS3),
                        .wadd(WAddS3),
                        .wren(WR),
                        .q(OutS3)
                );
endmodule
