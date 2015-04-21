`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:29 03/21/2015 
// Design Name: 
// Module Name:    MBR 
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
module MBR(MBR_in,MBR_out,MBR_we,MBR_clk
    );
	 input[7:0] MBR_in;
	 output[7:0] MBR_out;
	 input MBR_we,MBR_clk;
	 
	 
	 reg[7:0] MBR_out = 8'h02;
	 wire[7:0] MBR_next;
	 
	always @(posedge MBR_clk)
	begin
			MBR_out <= MBR_next;
	end
		
	assign MBR_next = MBR_we ? MBR_in : MBR_out;

endmodule
