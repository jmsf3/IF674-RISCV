`timescale 1ns / 1ps

module RegFile #(
    	// Parameters
    	parameter DATA_WIDTH = 32,    // Number of bits in each register
    	parameter ADDRESS_WIDTH = 5,  // Number of registers = 2^ADDRESS_WIDTH
    	parameter NUM_REGS = 32
	) 
	(
    	// Inputs 
    	input clk,                                  // Clock
    	input rst,                                  // Synchronous reset; if it is asserted (rst=1), all registers are reseted to 0
    	input RegWrite,                             //write signal
    	input  [ADDRESS_WIDTH-1:0] RegWriteAddress, // Address of the register that supposed to written into
    	input [ADDRESS_WIDTH-1:0] RegReadAddress1,  // First address to be read from
    	input [ADDRESS_WIDTH-1:0] RegReadAddress2,  // Second address to be read from
    	input  [DATA_WIDTH-1:0] RegWriteData,       // Data that's supposed to be written into the register file
	
    	// Outputs
    	output logic [DATA_WIDTH-1:0] RegReadData1,  // Content of RegisterFile[RegReadAddress1] is loaded into
    	output logic [DATA_WIDTH-1:0] RegReadData2   // Content of RegisterFile[RegReadAddress2] is loaded into
	);

  	integer i;

  	logic [DATA_WIDTH-1:0] RegisterFile[NUM_REGS-1:0];

  	always @(negedge clk) begin
  	  	if (rst == 1'b1) 
			for (i = 0; i < NUM_REGS; i = i + 1) RegisterFile[i] <= 0;
  	  	else if (rst == 1'b0 && RegWrite == 1'b1) begin
  	  	  	RegisterFile[RegWriteAddress] <= RegWriteData;
  	  	end
  	end

  	assign RegReadData1 = RegisterFile[RegReadAddress1];
  	assign RegReadData2 = RegisterFile[RegReadAddress2];
endmodule
