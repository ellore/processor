`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:41:30 03/29/2015 
// Design Name: 
// Module Name:    SP 
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
module SP(SP_out,SP_inc,SP_dec,SP_clk
    );
	output[15:0] SP_out;
	input SP_inc,SP_dec;
	input SP_clk;
	
	reg[15:0] SP_out=16'hffff;
	wire[15:0] SP_next;
	
	
	always @(posedge SP_clk)
	begin
		SP_out <= SP_next;
	end
	
	assign SP_next = 
				SP_inc ? SP_out - 1 :
				SP_dec ? SP_out + 1 :
				SP_out;
				
endmodule
