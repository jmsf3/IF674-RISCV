`timescale 1ns / 1ps

module DataMemory #(
        parameter DM_ADDRESS = 9,
        parameter DATA_W = 32
        ) 
        (
        // Inputs 
        input logic clk,
        input logic MemRead,                     // Comes from the control unit
        input logic MemWrite,                    // Comes from the control unit
        input logic [DM_ADDRESS - 1:0] Address,  // Read / Write address - 9 LSB bits of the ALU output
        input logic [DATA_W - 1:0] WD,           // Write Data
        input logic [2:0] Funct3,                // Bits 12 through 14 of the instruction

        // Outputs
        output logic [DATA_W - 1:0] RD           // Read Data
        );

        logic [31:0] ReadAddress;
        logic [31:0] WriteAddress;
        logic [31:0] DataIn;
        logic [31:0] DataOut;
        logic [ 3:0] WR;

        Memory32Data Mem32 (
                .ReadAddress(ReadAddress),
                .WriteAddress(WriteAddress),
                .clk(~clk),
                .DataIn(DataIn),
                .DataOut(DataOut),
                .WR(WR)
        );

        always_ff @(*) begin
                ReadAddress = {{22{1'b0}}, Address};
                WriteAddress = {{22{1'b0}}, Address[8:2], {2{1'b0}}};
                DataIn = WD;
                WR = 4'b0000;

                if (MemRead) begin
                        case (Funct3)
                        3'b010:  // LW
                                RD <= DataOut;
                        3'b001:  // LH
                                RD <= {DataOut[15] ? 16'hFFFF : 16'b0, DataOut[15:0]};
                        3'b000:  // LB
                                RD <= {DataOut[7] ? 24'hFFFFFF : 24'b0, DataOut[7:0]};
                        default: 
                                RD <= DataOut;
                        endcase
                end else if (MemWrite) begin
                        case (Funct3)
                        3'b010: begin  //SW
                                WR <= 4'b1111;
                                DataIn <= WD;
                        end default: begin
                                WR <= 4'b1111;
                                DataIn <= WD;
                        end
                        endcase
                end
        end
endmodule
