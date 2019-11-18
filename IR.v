`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:43 03/25/2015 
// Design Name: 
// Module Name:    IR 
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
module IR(IR_in,IR_out,IR_we,IR_clk
    );
	 input[7:0] IR_in;
	 output[7:0] IR_out;
	 input IR_we,IR_clk;
	 reg[7:0] IR_out = 8'h00;
	 
	 always @(posedge IR_clk)
	 begin
		IR_out <= IR_we ? IR_in : IR_out;
	 end
		 
	 


endmodule
