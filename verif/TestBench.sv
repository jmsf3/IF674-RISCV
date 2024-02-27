`timescale 1ns / 1ps

module TestBench;
        logic clk, rst;

        logic RegWriteSignal;
        logic [4:0] RegNum;
        logic [31:0] RegData;

        logic WriteEnable;
        logic ReadEnable;
        logic [8:0] Address;

        logic [31:0] WriteData;
        logic [31:0] ReadData;
        logic [31:0] WriteBackData;

        localparam CLK_PERIOD = 10;
        localparam CLK_DELAY = CLK_PERIOD / 2;
        localparam NUM_CYCLES = 50;

        RISCV RISCV (
                .clk(clk),
                .rst(rst),
                .RegWriteSignal(RegWriteSignal),
                .RegNum(RegNum),
                .RegData(RegData),
                .WriteEnable(WriteEnable),
                .ReadEnable(ReadEnable),
                .Address(Address),
                .WriteData(WriteData),
                .ReadData(ReadData),
                .WriteBackData(WriteBackData)
        );

        initial begin
                clk = 0;
                rst  = 1;
                #(CLK_PERIOD);
                rst = 0;
                #(CLK_PERIOD * NUM_CYCLES);
                $stop;
        end
        
        always @(posedge clk) begin : REGISTER
                if (RegWriteSignal)
                        $display($time, ": Register [ %d] written with value: [%X] | [%d]\n", RegNum, RegData, $signed(RegData));
        end : REGISTER

        always @(posedge clk) begin : MEMORY
                if (WriteEnable && ~ReadEnable)
                        $display($time, ": Memory   [%d] written with value: [%X] | [%d]\n", Address, WriteData, $signed(WriteData));
                else if (ReadEnable && ~WriteEnable)
                        $display($time, ": Memory   [%d] read with value:    [%X] | [%d]\n", Address, ReadData, $signed(ReadData));
        end : MEMORY

        // Clock generator
        always #(CLK_DELAY) clk = ~clk;
endmodule
