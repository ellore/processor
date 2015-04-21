`timescale 1ns / 1ps
module
	top_level(
		// FX2 interface -----------------------------------------------------------------------------
		input  wire      fx2Clk_in,     // 48MHz clock from FX2
		output wire[1:0] fx2Addr_out,   // select FIFO: "10" for EP6OUT, "11" for EP8IN
		inout  wire[7:0] fx2Data_io,    // 8-bit data to/from FX2

		// When EP6OUT selected:
		output wire      fx2Read_out,   // asserted (active-low) when reading from FX2
		output wire      fx2OE_out,     // asserted (active-low) to tell FX2 to drive bus
		input  wire      fx2GotData_in, // asserted (active-high) when FX2 has data for us

		// When EP8IN selected:
		output wire      fx2Write_out,  // asserted (active-low) when writing to FX2
		input  wire      fx2GotRoom_in, // asserted (active-high) when FX2 has room for more data from us
		output wire      fx2PktEnd_out, // asserted (active-low) when a host read needs to be committed early

		// Onboard peripherals -----------------------------------------------------------------------
		output wire[7:0] led_out        // eight LED
		
	);

	// Channel read/write interface -----------------------------------------------------------------
	wire[6:0]  chanAddr;  // the selected channel (0-127)

	// Host >> FPGA pipe:
	wire[7:0]  h2fData;   // data lines used when the host writes to a channel
	wire       h2fValid;  // '1' means "on the next clock rising edge, please accept the data on h2fData_out"
	wire       h2fReady;  // channel logic can drive this low to say "I'm not ready for more data yet"

	// Host << FPGA pipe:
	wire[7:0]  f2hData;   // data lines used when the host reads from a channel
	wire       f2hValid;  // channel logic can drive this low to say "I don't have data ready for you"
	wire       f2hReady;  // '1' means "on the next clock rising edge, put your next byte of data on f2hData_in"
	// ----------------------------------------------------------------------------------------------

	// Needed so that the comm_fpga_fx2 module can drive both fx2Read_out and fx2OE_out
	wire       fx2Read;
	wire[15:0] RAM_addr;
	wire[7:0] RAM_out; 
	wire[7:0] RAM_data;
	wire Ram_we,Zero,Sign;
	wire[7:0] Test_ir;
	wire[7:0] Test_state;
	wire[7:0] Test_pc;
	wire[7:0] Test_b,Test_a,Test_dat;
	wire[15:0] Test_MAR_in;
	wire[7:0] Test_mem;
	
//	 ----------------------------------------------------------------------------------------------
	reg clock=0;
	
	always begin
		#1 clock<=~clock;
	end
	
	initial begin
		#8500 $stop;
	end
	
	
//	 ----------------------------------------------------------------------------------------------
//	
	
	ram my_ram (
		.addr(RAM_addr),
//		.clk(fx2Clk_in),
		.clk(clock),
		.din(RAM_data),
		.dout(RAM_out),
		.we(Ram_we),
		.test_mem(Test_mem)
	); 
	
	microprocessor cpu(
	.ram_out(RAM_out),
//	.clk(fx2Clk_in),
	.clk(clock),
	.ram_data(RAM_data),
	.ram_addr(RAM_addr),
	.ram_we(Ram_we),
	.test_ir(Test_ir),
	.test_state(Test_state),
	.test_pc(Test_pc),
	.test_b(Test_b),
	.test_a(Test_a),
	.test_dat(Test_dat),
	.test_mar_in(Test_MAR_in),
	.test_zero(Zero),
	.test_sign(Sign)
	);
	
	
//	assign f2hData =
//		(chanAddr == 7'b0000000) ? Test_ir:
//		(chanAddr == 7'b0000001) ? Test_state:
//		(chanAddr == 7'b0000010) ? Test_pc:
//		(chanAddr == 7'b0000011) ? Test_b:
//		(chanAddr == 7'b0000100) ? Test_mem:
//		(chanAddr == 7'b0000100) ? Test_a:
//		8'h00;
//	
	
	// Assert that there's always data for reading, and always room for writing
	assign f2hValid = 1'b1;
	assign h2fReady = 1'b1;
	
	// CommFPGA module
	assign fx2Read_out = fx2Read;
	assign fx2OE_out = fx2Read;
	assign fx2Addr_out[1] = 1'b1;  // Use EP6OUT/EP8IN, not EP2OUT/EP4IN.
	comm_fpga_fx2 comm_fpga_fx2(
		// FX2 interface
		.fx2Clk_in(fx2Clk_in),
		.fx2FifoSel_out(fx2Addr_out[0]),
		.fx2Data_io(fx2Data_io),
		.fx2Read_out(fx2Read),
		.fx2GotData_in(fx2GotData_in),
		.fx2Write_out(fx2Write_out),
		.fx2GotRoom_in(fx2GotRoom_in),
		.fx2PktEnd_out(fx2PktEnd_out),

		// Channel read/write interface
		.chanAddr_out(chanAddr),
		.h2fData_out(h2fData),
		.h2fValid_out(h2fValid),
		.h2fReady_in(h2fReady),
		.f2hData_in(f2hData),
		.f2hValid_in(f2hValid),
		.f2hReady_out(f2hReady)
	);

	// LEDs and 7-seg display
	assign led_out = Test_ir;
endmodule
