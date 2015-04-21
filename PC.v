`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:36:25 03/25/2015 
// Design Name: 
// Module Name:    PC 
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
module PC(PC_out,PC_clk,PC_in,PC_inc,PC_jump
    );
	
	output[15:0] PC_out;
	input PC_clk;
	input[15:0] PC_in;
	input PC_inc,PC_jump;

	
	wire[15:0] PC_next;
	reg[15:0] PC_out = 16'h0000;
	
	always @(posedge PC_clk)
	begin
		PC_out <= PC_next;
	end
	
	assign PC_next = PC_jump ? PC_in: (PC_inc ? PC_out + 1 : PC_out) ;
	
endmodule
