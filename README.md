# Multi Cycle Processor
Implementation of 8-bit multi cycle processor using verilog on FPGA

##Requirements
- Xilinx ISE Design suite
- Spartan 6 FPGA board
- A connection must be established between host computer and FPGA board using USB

##Issues
- Design of the processor is not optimized in any way.
- Synthesis takes too long because FPGA board RAM is not accesed instead aray of registers is used.
