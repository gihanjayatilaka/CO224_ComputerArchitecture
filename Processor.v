//gihanchanaka@gmail.com

module alu(Result,DATA1,DATA2,Select);
	input [7:0]DATA1,DATA2;
	input [2:0] Select;
	reg [7:0] out;
	output [7:0] Result;

	always@(DATA1,DATA2,Select)
	begin
	case(Select)
		3'b000:  out = DATA1;
		3'b001:  out = DATA1+DATA2;
		3'b010:  out = DATA1&DATA2;
		3'b011:  out = DATA1|DATA2;

	endcase
	end
	assign Result = out;

	
endmodule

 

module regfile8x8a(debugPin,clk,INaddr,IN,OUT1addr,OUT1,OUT2addr,OUT2);
	output [63:0] debugPin;
	reg [(8*8)-1:0] memory=0;
	input [7:0] IN;
	output [7:0] OUT1;
	output [7:0] OUT2;
	reg [7:0] outReg1;
	reg [7:0] outReg2;
	input clk;
	input [2:0] INaddr;
	input [2:0] OUT1addr;
	input [2:0] OUT2addr;
	integer i;

	assign OUT1=outReg1[7:0];
	assign OUT2=outReg2[7:0];
	assign debugPin = memory[63:0];

	always @(posedge clk) begin
		for(i=0;i<8;i++)begin
			outReg1[i]=memory[OUT1addr*8 + i];
			outReg2[i]=memory[OUT2addr*8 + i];
		end
	end

	always @(negedge clk) begin
		for(i=0;i<8;i++)begin
			memory[INaddr*8 + i]=IN[i];
		end
		
	end

	


endmodule



module counter (clk, reset,Read_addr);
	input clk;
	input reset;
	output [31:0] Read_addr;
	 // The outputs are defined as registers too
	reg [31:0] Read_addr=0;
	// The counter doesn't have any delay since the
	// output is latched when the negedge of the clock happens.
	
	always @(negedge clk)begin
		Read_addr=Read_addr+3'b100;
	end
	

endmodule


module Instruction_reg (clk, Read_Addr, instruction);
	reg [8*32 -1:0] instructionMemory;
	integer ins;
	input clk;
	input [31:0] Read_Addr;
	output [31:0] instruction;
	reg [31:0] instruction;
	integer i;
	initial
	begin
		for(ins=0;ins<8;ins++)begin
			instructionMemory[ins]=0;
		end
		//Instruction 0
		instructionMemory[32*0+27 : 32*0+24] =4'b0000;//oppcode
		instructionMemory[32*0+18 : 32*0+16] =3'b001;//Dest
		instructionMemory[32*0+10 : 32*0+08] =3'b011;//Source 2
		instructionMemory[32*0+ 2 : 32*0+ 0] =3'b011;//Source 1
		//Instruction 1;
		instructionMemory[32*1 +27 : 32*1+24] =4'b0000;//oppcode
		instructionMemory[32*1+18 : 32*1+16] =3'b001;//Dest
		instructionMemory[32*1+10 : 32*1+08] =3'b011;//Source 2
		instructionMemory[32*1+ 2 : 32*1+ 0] =3'b011;//Source 1
		//Instruction 2;
		instructionMemory[32*2 +27 : 32*2+24] =4'b0000;//oppcode
		instructionMemory[32*2+18 : 32*2+16] =3'b000;//Dest
		instructionMemory[32*2+10 : 32*2+08] =3'b000;//Source 2
		instructionMemory[32*2+ 2 : 32*2+ 0] =3'b000;//Source 1
		//Instruction 3;
		instructionMemory[32*3 +27 : 32*3+24] =4'b0000;//oppcode
		instructionMemory[32*3+18 : 32*3+16] =3'b000;//Dest
		instructionMemory[32*3+10 : 32*3+08] =3'b000;//Source 2
		instructionMemory[32*3+ 2 : 32*3+ 0] =3'b000;//Source 1
		//Instruction 4;
		instructionMemory[32*4 +27 : 32*4+24] =4'b0000;//oppcode
		instructionMemory[32*4+18 : 32*4+16] =3'b000;//Dest
		instructionMemory[32*4+10 : 32*4+08] =3'b000;//Source 2
		instructionMemory[32*4+ 2 : 32*4+ 0] =3'b000;//Source 1
		//Instruction 5;
		instructionMemory[32*5 +27 : 32*5+24] =4'b0000;//oppcode
		instructionMemory[32*5+18 : 32*5+16] =3'b000;//Dest
		instructionMemory[32*5+10 : 32*5+08] =3'b000;//Source 2
		instructionMemory[32*5+ 2 : 32*5+ 0] =3'b000;//Source 1
		//Instruction 6;
		instructionMemory[32*6 +27 : 32*6+24] =4'b0000;//oppcode
		instructionMemory[32*6+18 : 32*6+16] =3'b000;//Dest
		instructionMemory[32*6+10 : 32*6+08] =3'b000;//Source 2
		instructionMemory[32*6+ 2 : 32*6+ 0] =3'b000;//Source 1
		//Instruction 7;
		instructionMemory[32*7 +27 : 32*7+24] =4'b0000;//oppcode
		instructionMemory[32*7+18 : 32*7+16] =3'b000;//Dest
		instructionMemory[32*7+10 : 32*7+08] =3'b000;//Source 2
		instructionMemory[32*7+ 2 : 32*7+ 0] =3'b000;//Source 1

	end
	always @(negedge clk) begin
		for(i=0;i<8;i++)begin
			instruction[i]=instructionMemory[Read_Addr*8+i];
		end
	end
endmodule

module CU(instruction, OUT1addr, OUT2addr, INaddr,SELECT,imValue,imValueMUXControlSignal,addSumMUXControlSignal);
	//In out here does not make sense for th control unit
	//They are named in the register file perspective
	input [31:0] instruction;
	output [2:0] OUT1addr;
	output [2:0] OUT2addr;
	output [2:0] INaddr;
	output [2:0] SELECT;
	output [7:0] imValue;
	output imValueMUXControlSignal;
	output addSumMUXControlSignal;
	reg [2:0] OUT1addr;
	reg [2:0] OUT2addr;
	reg [2:0] INaddr;
	reg [2:0] SELECT;
	reg [7:0] imValue;
	reg imValueMUXControlSignal;
	reg addSumMUXControlSignal;

	always @(instruction) begin
		case(instruction[3:1])
			3'b000: imValueMUXControlSignal = ~instruction[24];
			3'b001: addSumMUXControlSignal = instruction[24];
		endcase



		OUT1addr=instruction[2:0];
		OUT2addr=instruction[10:8];
		INaddr=instruction[18:16];
		imValue=instruction[7:0];
		SELECT=instruction[27:25];

	end
endmodule

module MUX(out,a,b,control);
	input [7:0] a;
	input [7:0] b;
	output [7:0] out;
	input control;
	reg [7:0] out;

	always@(a,b,control)begin
		case(control)
			1'b0 : out=a;
			1'b1 : out=b;
		endcase
	end

endmodule

module TwosComplement(out,in);
	input [7:0] in;
	output [7:0] out;
	reg [7:0] out;

	always @(in)begin
		out= -1*in;
	end
endmodule


module processor(debugPin,clk,reset);
	input clk;
	input reset;
	output [63:0] debugPin;

	wire [31:0] instructionAddress;
	wire [31:0] instruction;

	counter myCounter(clk,reset,instructionAddress);
	Instruction_reg myInstruction_reg(clk, instructionAddress, instruction);


	wire [2:0] OUT1addr;
	wire [2:0] OUT2addr;
	wire [2:0] INaddr;
	wire [2:0] SELECT;
	wire [7:0] imValue;
	wire imValueMUXControlSignal;
	wire addSumMUXControlSignal;

	CU myCU(instruction,OUT1addr,OUT2addr,INaddr,SELECT,imValue,imValueMUXControlSignal,addSumMUXControlSignal);

	wire [7:0] IN;
	wire [7:0] OUT1;
	wire [7:0] OUT2;

	regfile8x8a myregfile8x8a(debugPin,clk,INaddr,IN,OUT1addr,OUT1,OUT2addr,OUT2);

	wire [7:0] DATA1;
	wire [7:0] DATA2;
	wire [7:0] TwosComplementOutput;

	TwosComplement myTwosComplement(TwosComplementOutput,OUT2);

	MUX myMUX_intermediateValue(DATA1,OUT1,imValue,imValueMUXControlSignal);
	MUX myMUX_addSub(DATA2,OUT2,TwosComplementOutput,addSumMUXControlSignal);

	alu myAlu(IN,DATA1,OUT2,SELECT);//myAlu(Result,DATA1,DATA2,Select)




endmodule



module testbed;

	reg reset;
	reg clk;
	wire [63:0] debugPin;

	processor myProcessor(debugPin,clk,reset);


	initial
	begin
		$monitor("reg0 = %7b",debugPin[7:0]);
		$monitor("reg1 = %7b",debugPin[15:8]);
		$monitor("reg2 = %7b",debugPin[23:16]);
		//$dumpfile("wavedata.vcd");
	    //$dumpvars(0,testbed);

		reset =1'b0;


		#5 clk=1'b0;
		#5 clk=1'b1;
		#5 clk=1'b0;
		#5 clk=1'b1;
		#5 clk=1'b0;
		#5 clk=1'b1;
		#5 clk=1'b0;
		#5 clk=1'b1;
		#5 clk=1'b0;
		#5 clk=1'b1;
		#5 clk=1'b0;
		#5 clk=1'b1;


		
		$finish;	
		
	end

endmodule