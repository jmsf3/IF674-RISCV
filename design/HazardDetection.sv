`timescale 1ns / 1ps

module HazardDetection (
    input logic [4:0] IFIDRS1,
    input logic [4:0] IFIDRS2,
    input logic [4:0] IDEXRD,
    input logic IDEXMemRead,
    output logic Stall
);

  assign Stall = (IDEXMemRead) ? ((IDEXRD == IFIDRS1) || (IDEXRD == IFIDRS2)) : 0;

endmodule
