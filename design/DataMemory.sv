`timescale 1ns / 1ps

module DataMemory #(
        // Parameters
        parameter ADDRESS_WIDTH = 9,
        parameter DATA_WIDTH = 32
        )
        (
        // Inputs
        input logic clk,
        input logic [ADDRESS_WIDTH-1:0] Address,  // Read / Write address - 9 LSB bits of the ALU output
        input logic [DATA_WIDTH-1:0] WriteData,   // Write data
        input logic MemRead,                      // Comes from the control unit
        input logic MemWrite,                     // Comes from the control unit
        input logic [2:0] Funct3,                 // Bits 12 through 14 of the instruction

        // Outputs
        output logic [DATA_WIDTH-1:0] ReadData    // Read data
        );

        logic [31:0] ReadAddress;
        logic [31:0] WriteAddress;
        logic [31:0] DataIn;
        logic [31:0] DataOut;
        logic [ 3:0] WriteEnable;

        Memory32Data Mem32 (
                .clk(~clk),
                .DataIn(DataIn),
                .DataOut(DataOut),
                .WriteAddress(WriteAddress),
                .ReadAddress(ReadAddress),
                .WriteEnable(WriteEnable)
        );

        always_ff @(*) begin
                ReadAddress = {23'b0, Address};
                WriteAddress = {23'b0, Address[8:2], 2'b0};
                DataIn = WriteData;
                WriteEnable = 4'b0000;

                if (MemRead) begin
                        case (Funct3)
                        3'b010:  // LW
                                ReadData <= DataOut;
                        3'b001:  // LH
                                ReadData <= {DataOut[15] ? 16'hFFFF : 16'b0, DataOut[15:0]};
                        3'b101:  // LHU
                                ReadData <= {16'b0, DataOut[15:0]};
                        3'b000:  // LB
                                ReadData <= {DataOut[7] ? 24'hFFFFFF : 24'b0, DataOut[7:0]};
                        3'b100:  // LBU
                                ReadData <= {24'b0, DataOut[7:0]};
                        default:
                                ReadData <= DataOut;
                        endcase
                end else if (MemWrite) begin
                        case (Funct3)
                        3'b010: begin  // SW
                                WriteEnable <= 4'b1111;
                                DataIn <= WriteData;
                        end default: begin
                                WriteEnable <= 4'b1111;
                                DataIn <= WriteData;
                        end
                        endcase
                end
        end
endmodule
