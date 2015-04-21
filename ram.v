`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:46 03/18/2015 
// Design Name: 
// Module Name:    ram 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ram (addr, clk, din, dout, we, test_mem);

	input [7 : 0] din;
	input [15: 0] addr;
	input clk, we;
	output [7 : 0] dout;
	output[7:0] test_mem;
	
	reg [7:0] memory[65535:0];
	
	initial
	begin
	
//		//DATA MOVEMENT CODE IN COURSE WEBSITE
//		memory[16'h0000] <= 8'hbd;
//		memory[16'h0001] <= 8'h02;
//		memory[16'h0002] <= 8'hbe;
//		memory[16'h0003] <= 8'h00;
//		memory[16'h0004] <= 8'h07;
//		memory[16'h0005] <= 8'hbd;
//		memory[16'h0006] <= 8'h02;
//		memory[16'h0007] <= 8'hbe;
//		memory[16'h0008] <= 8'h01;
//		memory[16'h0009] <= 8'h47;
//		memory[16'h000a] <= 8'hbd;
//		memory[16'h000b] <= 8'h02;
//		memory[16'h000c] <= 8'hbe;
//		memory[16'h000d] <= 8'h02;
//		memory[16'h000e] <= 8'h4f;
//		memory[16'h000f] <= 8'hbd;
//		memory[16'h0010] <= 8'h02;
//		memory[16'h0011] <= 8'hbe;
//		memory[16'h0012] <= 8'h03;
//		memory[16'h0013] <= 8'h67;
//		memory[16'h0014] <= 8'h08;
//		memory[16'h0015] <= 8'hbd;
//		memory[16'h0016] <= 8'h02;
//		memory[16'h0017] <= 8'hbe;
//		memory[16'h0018] <= 8'h04;
//		memory[16'h0019] <= 8'h39;
//		memory[16'h001a] <= 8'hff;
//		memory[16'h0200] <= 8'h02;
//		memory[16'h0201] <= 8'h04;
//		memory[16'h0202] <= 8'h01;
//		memory[16'h0203] <= 8'hf4;
//		memory[16'h0204] <= 8'h00;
//


//    //JUMP CONDITIONAL
//		memory[16'h0000] <= 8'h01;
//		memory[16'h0001] <= 8'h4a;
//		memory[16'h0002] <= 8'he0;
//		memory[16'h0003] <= 8'h02;
//		memory[16'h0004] <= 8'h00;
//		memory[16'h0005] <= 8'hff;
//		memory[16'h0200] <= 8'hb9;
//		memory[16'h0201] <= 8'h28;
//		memory[16'h0202] <= 8'hff;

//		//FACTORIAL CODE FOR N=5
//		memory[16'h0000] <= 8'hb9;
//		memory[16'h0001] <= 8'h01;
//		memory[16'h0002] <= 8'hba;
//		memory[16'h0003] <= 8'h01;
//		memory[16'h0004] <= 8'hbb;
//		memory[16'h0005] <= 8'h06;
//		memory[16'h0006] <= 8'h01;
//		memory[16'h0007] <= 8'h52;
//		memory[16'h0008] <= 8'h08;
//		memory[16'h0009] <= 8'h82;
//		memory[16'h000a] <= 8'h01;
//		memory[16'h000b] <= 8'h02;
//		memory[16'h000c] <= 8'h4b;
//		memory[16'h000d] <= 8'he8;
//		memory[16'h000e] <= 8'h00;
//		memory[16'h000f] <= 8'h06;
//		memory[16'h0010] <= 8'hff;
	
//		//CALL AND RETURN		
//		memory[16'h0000] <= 8'hf9;
//		memory[16'h0001] <= 8'h02;
//		memory[16'h0002] <= 8'h00;
//		memory[16'h0003] <= 8'hff;
//		memory[16'h0200] <= 8'hb9;
//		memory[16'h0201] <= 8'h49;
//		memory[16'h0202] <= 8'h49;
//		memory[16'h0203] <= 8'hfb;


//		//FACTORIAL CODE FOR N=5

//    //Main
		memory[16'h0000] <= 8'hbb; //MOVI D
		memory[16'h0001] <= 8'h05;// CONSTANT 5
		memory[16'h0002] <= 8'hf9; // CALL 
		memory[16'h0003] <= 8'hfc; // NOP
		memory[16'h0004] <= 8'h02; // MSB OF ADDRESS
		memory[16'h0005] <= 8'h00; // LSB OF ADDRESS
		memory[16'h0006] <= 8'hff; // HALT

//    //Function		
		memory[16'h0200] <= 8'hb9;	// MOVI B 	
		memory[16'h0201] <= 8'h01;	// CONSTANT 1
		memory[16'h0202] <= 8'hba;	// MOVI C
		memory[16'h0203] <= 8'h01;	// CONSTANT 1
		memory[16'h0204] <= 8'h01;	// MOV A B
		memory[16'h0205] <= 8'h52;	// MULT C
		memory[16'h0206] <= 8'h08;	// MOV B A
		memory[16'h0207] <= 8'h82;	// ADDI C
		memory[16'h0208] <= 8'h01;	// CONSTANT 1
		memory[16'h0209] <= 8'h02;	// MOV A C
		memory[16'h020a] <= 8'h4b; // SUB D
		memory[16'h020b] <= 8'he8;	//	JUMP IF C < D
		memory[16'h020c] <= 8'h02; // MSB OF ADDRESS
		memory[16'h020d] <= 8'h04;	// LSB OF ADDRESS
		memory[16'h020e] <= 8'hfb;	// RETURN	 	

	
	end
	always @(posedge clk)
	begin
		if (we)
			memory[addr] <= din;
	end
	
	assign dout = memory[addr];
	assign test_mem = memory[16'hfffe];
endmodule
