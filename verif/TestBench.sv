`timescale 1ns / 1ps

module TestBench;

        // Clock and reset signals declaration
        logic clk, rst;
        logic [31:0] TestBenchWBData;

        logic [4:0] RegNum;
        logic [31:0] RegData;
        logic RegWriteSignal;
        logic WR;
        logic RD;
        logic [8:0] Address;
        logic [31:0] WRData;
        logic [31:0] RDData;

        localparam CLK_PERIOD = 10;
        localparam CLK_DELAY = CLK_PERIOD / 2;
        localparam NUM_CYCLES = 50;

        RISCV RV (
                .clk(clk),
                .rst(rst),
                .WBData(TestBenchWBData),
                .RegNum(RegNum),
                .RegData(RegData),
                .RegWriteSignal(RegWriteSignal),
                .WR(WR),
                .RD(RD),
                .Address(Address),
                .WRData(WRData),
                .RDData(RDData)
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
                if (WR && ~RD)
                        $display($time, ": Memory   [%d] written with value: [%X] | [%d]\n", Address, WRData, $signed(WRData));
                else if (RD && ~WR)
                        $display($time, ": Memory   [%d] read with value:    [%X] | [%d]\n", Address, RDData, $signed(RDData));
        end : MEMORY

        // Clock generator
        always #(CLK_DELAY) clk = ~clk;
endmodule
