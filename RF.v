`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:05 03/25/2015 
// Design Name: 
// Module Name:    RF 
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
module RF(Data_in,Select,Acc_in,Data_out,Acc_out,RF_we,Acc_we,RF_clk,FG_pair,b_out,a_out,dat_out
    );
	input[7:0] Data_in;
	input[2:0] Select;
	input[7:0] Acc_in;
	output[7:0] Data_out;
	output[7:0] Acc_out;
	output[15:0] FG_pair;
	input RF_we;
	input Acc_we;
	input RF_clk;
	output[7:0] b_out,a_out,dat_out;
	
	reg[7:0] Data_out;
	reg[7:0] Acc,B,C,D,E,F,G;
	initial 
		begin
			Acc <= 8'h49;
			B <= 8'h06;
			C <= 8'h06;
		end	
	always @(posedge RF_clk)
	begin
		case(Select)
		3'b000: Acc <= (RF_we ? Data_in: Acc); 
		3'b001: B <= (RF_we ? Data_in: B);
		3'b010: C <= (RF_we ? Data_in: C);
		3'b011: D <= (RF_we ? Data_in: D);
		3'b100: E <= (RF_we ? Data_in: E);
		3'b101: F <= (RF_we ? Data_in: F);
		3'b110: G <= (RF_we ? Data_in: G);
		
		endcase
		if (Select != 3'b000)
			Acc <= Acc_we ? Acc_in : Acc;
	end
	
	
	always @(Select or Acc or B or C or D or E or F or G)
	begin
		case (Select)
		3'b000: Data_out <= Acc;
		3'b001: Data_out <= B;
		3'b010: Data_out <= C;
		3'b011: Data_out <= D;
		3'b100: Data_out <= E;
		3'b101: Data_out <= F;
		3'b110: Data_out <= G;
		endcase
	end
	
	assign Acc_out = Acc;
	assign FG_pair = {F,G};
	assign b_out = B;
	assign a_out = Acc;
	assign dat_out = Data_out;
endmodule
