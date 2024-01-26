`timescale 1ns / 1ps

module RegFile #(
    // Parameters
    parameter DATA_WIDTH = 32,  // number of bits in each register
    parameter ADDRESS_WIDTH = 5,  //number of registers = 2^ADDRESS_WIDTH
    parameter NUM_REGS = 32
) (
    // Inputs 
    input clk,  //clock
    input rst,  //synchronous reset; if it is asserted (rst=1), all registers are reseted to 0
    input RegWrite,  //write signal
    input  [ADDRESS_WIDTH-1:0] RegWriteAddress, //address of the register that supposed to written into
    input [ADDRESS_WIDTH-1:0] RegReadAddress1,  //first address to be read from
    input [ADDRESS_WIDTH-1:0] RegReadAddress2,  //second address to be read from
    input  [DATA_WIDTH-1:0] RegWriteData, // data that supposed to be written into the register file

    // Outputs
    output logic [DATA_WIDTH-1:0] RegReadData1,  //content of reg_file[RegReadAddress1] is loaded into
    output logic [DATA_WIDTH-1:0] RegReadData2   //content of reg_file[RegReadAddress2] is loaded into
);

  integer i;

  logic [DATA_WIDTH-1:0] RegisterFile[NUM_REGS-1:0];

  always @(negedge clk) begin
    if (rst == 1'b1) for (i = 0; i < NUM_REGS; i = i + 1) RegisterFile[i] <= 0;
    else if (rst == 1'b0 && RegWrite == 1'b1) begin
      RegisterFile[RegWriteAddress] <= RegWriteData;
    end
  end

  assign RegReadData1 = RegisterFile[RegReadAddress1];
  assign RegReadData2 = RegisterFile[RegReadAddress2];

endmodule
