`timescale 1ns / 1ps

module ForwardingUnit (
    input logic [4:0] RS1,
    input logic [4:0] RS2,
    input logic [4:0] EXMEMRD,
    input logic [4:0] MEMWBRD,
    input logic EXMEMRegWrite,
    input logic MEMWBRegWrite,
    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

  assign ForwardA = ((EXMEMRegWrite) && (EXMEMRD != 0) && (EXMEMRD == RS1)) ? 2'b10 :
                       ((MEMWBRegWrite) && (MEMWBRD != 0) && (MEMWBRD == RS1)) ? 2'b01 : 2'b00;

  assign ForwardB = ((EXMEMRegWrite) && (EXMEMRD != 0) && (EXMEMRD == RS2)) ? 2'b10 :
                       ((MEMWBRegWrite) && (MEMWBRD != 0) && (MEMWBRD == RS2)) ? 2'b01 : 2'b00;

endmodule
