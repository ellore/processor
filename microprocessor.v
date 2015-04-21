`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:23:11 03/21/2015 
// Design Name: 
// Module Name:    microprocessor 
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
module microprocessor(ram_out,clk,ram_data,ram_addr,ram_we,test_ir,test_state,
							 test_pc,test_b,test_mar_in,test_a,test_dat,test_zero,test_sign
    );
	 
	input[7:0] ram_out;
	input clk;
	output[7:0] ram_data;
	output[15:0] ram_addr;	 
	output ram_we;
	output[7:0] test_ir;
	output[7:0] test_state;
	output[7:0] test_pc;
	output[7:0] test_b,test_a,test_dat;
	output[15:0] test_mar_in;
	output test_zero,test_sign;
	
		 
//------------------------------------- control signals---------------------------------------------------------------------------
	wire 	mbr_we,ir_we,pc_inc,pc_jump,rf_we,acc_we,mar_we,
			alu_mux,rf_mux,alu_out_mux,mar_mux,mbr_mux,ram_we,update,sp_en,sp_inc,sp_dec,condition_update;
	wire[2:0] select,func;
	wire[1:0] ram_in;
//--------------------------------------------------------------------------------------------------------------------------------	

//-------------------------------------interconnecting wires----------------------------------------------------------------------
	wire[7:0] ir_out; //IR
	wire[15:0] pc_out; //PC
	wire[7:0] data_in,acc_in,data_out,acc_out; //RF
	wire[15:0] fg_pair; //RF
	wire[7:0] y,z; //ALU
	wire[15:0] mar_in,mar_out; //MAR
	wire[7:0] mbr_in,mbr_out; //MBR
	wire[15:0] sp_out; //SP
	wire sign, zero, overflow, carry; //Condition Code Registers
	wire[7:0] condition;
//-----------------------------------------------------------------------------------------------------------------------------
	

//------------------------------------ Instantiations-----------------------------------------------------------------------------
	MBR mbr(.MBR_in(mbr_in), .MBR_out(mbr_out), .MBR_we(mbr_we), .MBR_clk(clk));
	IR ir(.IR_in(mbr_out), .IR_out(ir_out), .IR_we(ir_we), .IR_clk(clk));
	PC pc(.PC_out(pc_out), .PC_clk(clk), .PC_in(fg_pair), .PC_inc(pc_inc), .PC_jump(pc_jump));
	RF rf(.Data_in(data_in), .Select(select), .Acc_in(acc_in), .Data_out(data_out),
			.Acc_out(acc_out), .RF_we(rf_we), .Acc_we(acc_we), .RF_clk(clk), .FG_pair(fg_pair),
			.b_out(test_b), .a_out(test_a), .dat_out(test_dat));
	ALU alu(.X(acc_out),.Y(y),.Z(z),.Func(func),.Sign(sign),.Zero(zero),.Overflow(overflow),
			  .Carry(carry),.ALU_clk(clk),.Update(update),.Zsoc(ram_out),.Condition_update(condition_update));
	MAR mar(.MAR_in(mar_in),.MAR_out(mar_out),.MAR_we(mar_we),.MAR_clk(clk));
	CU cu(.CU_in(ir_out),.MBR_we(mbr_we),.IR_we(ir_we),.PC_inc(pc_inc),.PC_jump(pc_jump),.RF_we(rf_we),.Acc_we(acc_we),
		   .MAR_we(mar_we),.RAM_we(ram_we),.ALU_mux(alu_mux),.RF_mux(rf_mux),.ALU_out_mux(alu_out_mux),.MAR_mux(mar_mux),
			.MBR_mux(mbr_mux),.Select(select),.Func(func),.CU_clk(clk),.State(test_state),.Sign(sign),.Zero(zero),.Overflow(overflow),
			.Carry(carry),.Update(update),.SP_en(sp_en),.SP_inc(sp_inc),.RAM_in(ram_in),.SP_dec(sp_dec),.Condition_update(condition_update));
	SP sp(.SP_out(sp_out),.SP_inc(sp_inc),.SP_dec(sp_dec),.SP_clk(clk));
//---------------------------------------------------------------------------------------------------------------------------------
	
	assign y = alu_mux ? data_out : mbr_out;
	assign data_in = rf_mux ? acc_out : mbr_out;
	assign acc_in = alu_out_mux ? data_out : z;  
	assign mar_in = mar_mux ? fg_pair : pc_out;
	assign mbr_in = mbr_mux ? data_out : ram_out;
	assign ram_addr = sp_en ? sp_out : mar_out;
	assign ram_data = 
				(ram_in == 2'b00) ? mbr_out      :
				(ram_in == 2'b01) ? pc_out[7:0]  :
				(ram_in == 2'b10) ? pc_out[15:8] :
				condition;
	assign test_ir = ir_out;
	assign test_pc = pc_out[7:0];
	assign test_mar_in = fg_pair;
	assign test_sign = sign;
	assign test_zero = zero;
	assign condition = {0,0,0,0,zero,sign,overflow,carry};

endmodule
