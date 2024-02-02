`timescale 1ns / 1ps

module testbench;
        // Clock and reset signals declaration
        logic clk, rst;
        logic [31:0] TestbenchWBData;

        logic [4:0] RegNum;
        logic [31:0] RegData;
        logic RegWriteSignal;

        logic WriteEnable;
        logic ReadEnable;
        logic [8:0] Address;

        logic [31:0] WRData;
        logic [31:0] RDData;

        localparam CLK_PERIOD = 10;
        localparam CLK_DELAY = CLK_PERIOD / 2;
        localparam NUM_CYCLES = 60;

        RISCV RV (
                .clk(clk),
                .rst(rst),
                .WBData(TestbenchWBData),
                .RegNum(RegNum),
                .RegData(RegData),
                .RegWriteSignal(RegWriteSignal),
                .WriteEnable(WriteEnable),
                .ReadEnable(ReadEnable),
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
                if (WriteEnable && ~ReadEnable)
                        $display($time, ": Memory   [%d] written with value: [%X] | [%d]\n", Address, WRData, $signed(WRData));
                else if (ReadEnable && ~WriteEnable)
                        $display($time, ": Memory   [%d] read with value:    [%X] | [%d]\n", Address, RDData, $signed(RDData));
        end : MEMORY

        // Clock generator
        always #(CLK_DELAY) clk = ~clk;
endmodule
