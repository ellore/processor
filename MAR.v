`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:31:56 03/25/2015 
// Design Name: 
// Module Name:    MAR 
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
module MAR(MAR_in,MAR_out,MAR_we,MAR_clk 
    );
	 input[15:0] MAR_in;
	 output[15:0] MAR_out;
	 input MAR_we;
	 input MAR_clk;
	 
	 reg[15:0] MAR_out;
	 wire[15:0] MAR_next;
	 always @(posedge MAR_clk)
	 begin
		
				MAR_out <= MAR_next;
	 end
	 
		assign MAR_next = MAR_we ? MAR_in : MAR_out; 


endmodule
