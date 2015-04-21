`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:12 03/30/2015 
// Design Name: 
// Module Name:    CU 
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
module CU(CU_in,MBR_we,IR_we,PC_inc,PC_jump,RF_we,Acc_we,MAR_we,RAM_we,
		ALU_mux,RF_mux,ALU_out_mux,MAR_mux,MBR_mux,Select,Func,CU_clk,State,
		Zero, Sign, Overflow, Carry,Update,SP_en,RAM_in,SP_inc,SP_dec,Condition_update
    );
	
	input[7:0] CU_in;
	output MBR_we,IR_we,PC_inc,PC_jump,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux,ALU_out_mux,MAR_mux,MBR_mux,Update,SP_en,SP_inc,SP_dec,Condition_update;
	output[2:0] Select,Func;
	output[1:0] RAM_in;
	input CU_clk;
	output[7:0] State;
	input Zero, Sign, Overflow, Carry;
	
	reg  MBR_we,IR_we,PC_inc,PC_jump,RF_we,Acc_we,MAR_we,RAM_we,ALU_mux,RF_mux,ALU_out_mux,MAR_mux,MBR_mux,Update,SP_en,SP_inc,SP_dec,Condition_update;
	reg[2:0] Select,Func;
	reg[1:0] RAM_in;
	reg[7:0] State=0,nextstate;
	
	
	parameter s0=0, s1=1, s2=2, s3=3, s4=4, s5=5, s6=6, s7=7, s8=8, s9=9, s10=10, s11=11, s12=12, s13=13, s14=14, s15=15,
					s16=16, s17=17, s18=18, s19=19, s20=20, s21=21, s22=22, s23=23, s24=24, s25=25, s26=26, s27=27, s28=28,
					s29=29, s30=30, s31=31, s32=32, s33=33, s34=34, s35=35, s36=36, s37=37, s38=38, s39=39, s40=40;
	
	always @(posedge CU_clk)
	begin
		State <= nextstate;	
	end

	always @(State)
	begin
	 case(State)
		s0: 
			begin
				RAM_we=0;
				MBR_we=0;
				IR_we=0;
				PC_inc=0;
				PC_jump=0;
				RF_we=0;
				Acc_we=0;
				MAR_we=1;
				ALU_mux=0;
				RF_mux=0;
				ALU_out_mux=0;
				MAR_mux=0;
				MBR_mux=0;
				Update=0;
				RAM_in=2'b00;
				SP_en=0;
				SP_inc=0;
				SP_dec=0;
				Condition_update = 0;
				nextstate = s1; //PAPAM
			end
		s1:
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				nextstate = s2;
			end
		s2:
			begin
				MBR_we=0;
				IR_we=1;
				PC_inc=0;
				nextstate=s3;
			end	
		s3: //Decoder
			begin
				IR_we=0;
			if( CU_in[7:6] == 2'b00)
				begin
					if( (CU_in[5:3]==3'b111) || (CU_in[2:0] == 3'b111) )
						nextstate = s6; // MOV M REG || MOV REG M
					else
						nextstate = s4; // MOV REG REG
				end
			else if(CU_in[7:6] == 2'b01)
				begin
					if(CU_in[2:0] == 3'b111)
						nextstate = s13; // ADD M
					else 	
						nextstate = s12;// ADD REG
				end
			else if(CU_in[7:6] == 2'b10)
				begin
					if(CU_in[5:3] == 3'b111)
						nextstate = s16; //MVI
					else
						nextstate =s19; // ADDI
				end
			else
				begin
				if(CU_in[5] == 0)
					nextstate = s24;  // JUMP UNCONDITIONAL
				if(CU_in[5:0] == 6'b111111)
					nextstate = s11; // HALT
				else if(CU_in[5:0] == 6'b111001)  //CALL 
					nextstate = s24;
				else if(CU_in[5:0] == 6'b111000) // PUSH
					nextstate = s9;
				else if(CU_in[5:0] == 6'b111010) // POP
					begin
					nextstate = s7;
					SP_dec=1;
					end
				else if(CU_in[5:0] == 6'b111100)//NOP
					begin
						nextstate = s0;
					end	
				else if(CU_in[5:0] == 6'b111011)//RETURN
					begin
					nextstate = s36;
					SP_dec=1;
					end
				else 
					begin
						if(CU_in[4:3] == 2'b00)
							 nextstate = Zero ? s24: s31; // JUMP ON EQUAL
						else if(CU_in[4:3] == 2'b01)	
							 nextstate = Zero ? s31: (Sign ? s24: s31); // JUMP ON LESS THAN
						else if(CU_in[4:3] == 2'b10)	 
							nextstate = Zero ? s31: (Sign ? s31: s24); // JUMP ON GREATER THAN
						
					end
				end
			end
		s4:
			begin
				Acc_we=1;
				ALU_out_mux=1;
				Select = CU_in[2:0];
				nextstate = s5;
			end
		s5:
			begin
				RF_we=1;
				Acc_we=0;
				RF_mux= 1;
				ALU_out_mux=0;
				Select = CU_in[5:3];
				nextstate = s0;
			end	

		s6: 			//MAR <= FG
			begin
				MAR_we=1;
				MAR_mux=1;
				if(CU_in[2:0] == 3'b111)
					nextstate = s7;
				else
					nextstate = s9;
			end
		s7:			//MBR <= RAM[MAR]
			begin
				MBR_we=1;
				MAR_we=0;
				MAR_mux=0;
				if(CU_in[7:0] == 8'b11111010)
					begin
						SP_en=1;
						SP_dec=0;
					end
				nextstate = s8;
			end
		s8:				//REG <= MBR
			begin
				MBR_we=0;
				RF_we=1;
				Select = CU_in[5:3];
				if(CU_in[7:0] == 8'b11111010)
					begin
						Select = 3'b000;
					end
				SP_en=0;
				nextstate = s0;
			end
		
		s9:			//MBR <= REG
			begin
				MBR_we=1;
				MAR_we=0;
				MAR_mux=0;
				MBR_mux=1;
				Select = CU_in[2:0];
				nextstate = s10;
			end
		s10:		//RAM[MAR] <= MBR
			begin
				RAM_we=1;
				MBR_we=0;
				MBR_mux=0;
				if(CU_in[7:0] == 8'b11111000)
					begin
					SP_en=1;
					SP_inc=1;
					end
				nextstate = s0;
			end			
		s11: //halt
			begin
				nextstate = s11;
			end
		s12: // Alu reg 
			begin
				Acc_we=1;
				ALU_mux=1;
				Select = CU_in[2:0];
				Func = CU_in[5:3];
				Update = 1;
				nextstate = s0;
			end
		s13:  
			begin
				MAR_we=1;
				MAR_mux=1;
				nextstate = s14;
			end
		s14:  
			begin
				MBR_we=1;
				MAR_we=0;
				MAR_mux=0;
				nextstate = s15;
			end
		s15:  
			begin
				MBR_we=0;
				Acc_we=1;
				Func = CU_in[5:3];
				Update = 1;
				nextstate = s0;
			end
		s16: //MAR <= PC
			begin
				MAR_we=1;
				Select = CU_in[2:0];
				nextstate = s17;				
			end
		s17:  //MBR <= RAM[MAR] , PC++
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				nextstate = s18;				
			end
		s18:
			begin
				MBR_we=0;
				PC_inc=0;
				RF_we=1;
				nextstate = s0;				
			end
		s19: // ACC <= REG
			begin
				Acc_we=1;
				ALU_out_mux=1;
				Select = CU_in[2:0];
				nextstate = s20;				
			end			
		s20:  //MAR <=PC
			begin
				Acc_we=0;
				MAR_we=1;
				ALU_out_mux=0;
				Func = CU_in[5:3];	
				nextstate = s21;
			end		
		s21:
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				nextstate = s22;				
			end			
		s22:
			begin
				MBR_we=0;
				PC_inc=0;
				Acc_we=1;
				nextstate = s23;				
			end
		s23:
			begin
				RF_we=1;
				Acc_we=0;
				RF_mux=1;
				nextstate = s0;				
			end
		s24: //MAR = PC
			begin
				MAR_we=1;
				RAM_in=2'b00;
				SP_en=0;
				SP_inc=0;
				nextstate = s25;
			end
		s25: // MBR = RAM
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				nextstate = s26;				
			end
		s26: 		//F = MBR
			begin
				MBR_we=0;
				PC_inc=0;
				RF_we=1;
				Select = 3'b101;
				nextstate = s27;				
			end
		s27:		
			begin
				RF_we=0;
				MAR_we=1;
				nextstate = s28;				
			end			
		s28:
			begin
				MBR_we=1;
				PC_inc=1;
				MAR_we=0;
				nextstate = s29;				
			end
		s29:
			begin
				MBR_we=0;
				PC_inc=0;
				RF_we=1;
				Select = 3'b110;
				if(CU_in[5:0] == 6'b111001)
					nextstate = s33;
				else	
					nextstate = s30;				
			end
		s30:
			begin
				RAM_we=0;
				PC_jump=1;
				RF_we=0;
				RAM_in=2'b00;
				SP_en=0;
				SP_inc=0;
				nextstate = s0;				
			end
		s31: // PC++
			begin
				PC_inc=1;
				nextstate = s32;				
			end
		s32:	//PC++
			begin
				nextstate = s0;				
			end
		s33:	
			begin
				RAM_we=1;
				RF_we=0;
				RAM_in=2'b01;
				SP_en=1;
				SP_inc=1;
				nextstate = s34;
			end
		s34:	
			begin
				RAM_in=2'b10;
				nextstate = s35;
			end
		s35:	
			begin
				RAM_in=2'b11;
				nextstate = s30;
			end
		s36:	
			begin
				SP_en = 1;
				SP_dec =1;
				Condition_update = 1;
				nextstate = s37;
			end			
		s37:	
			begin
				MBR_we=1;
				Condition_update = 0;
				nextstate = s38;
			end
		s38:	
			begin
				RF_we=1;
				SP_dec = 0;
				Select = 3'b101;
				nextstate = s39;
			end	
		s39:	
			begin
				MBR_we=0;
				SP_en = 0;
				Select = 3'b110;
				nextstate = s40;
			end
		s40:	
			begin
				PC_jump=1;
				RF_we=0;
				nextstate = s0;
			end			
		endcase	
	end

endmodule

