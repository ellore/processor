# Multi Cycle Processor
Implementation of 8-bit multi cycle processor using verilog on FPGA.

For notes on processor and instruction set design, refer [the wiki](https://github.com/ellore/processor/wiki).

###Requirements
- Xilinx ISE Design suite
- Spartan 6 FPGA board
- A connection must be established between host computer and FPGA board using USB

####Issues
It might take a while for synthesis because array of registers is used instead of FPGA board RAM. The simulation works well with test bench written in top level.
