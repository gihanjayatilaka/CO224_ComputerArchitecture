//gihanchanaka@gmail.com
//dddd
module alu(Result,DATA1,DATA2,Select);
	input [7:0] DATA1;
	input [7:0] DATA2;
	input [2:0] Select;
	output [7:0] Result;
	reg [7:0] Result;

	always@(DATA1,DATA2,Select)
	begin
	case(Select)
		3'b000:  Result = DATA1;
		3'b001:  Result = DATA1+DATA2;
		3'b010:  Result = DATA1&DATA2;
		3'b011:  Result = DATA1|DATA2;

	endcase
	end


	
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
		for(i=0;i<8;i=i+1) begin
			outReg1[i]<=memory[OUT1addr*8 + i];
			outReg2[i]<=memory[OUT2addr*8 + i];
		end
	end

	always @(negedge clk) begin
		for(i=0;i<8;i=i+1)begin
			memory[INaddr*8 + i]=IN[i];
		end
		
	end

	


endmodule



module counter (debugPin_PC,clk, reset,Read_addr);
	input clk;
	input reset;
	output [31:0] Read_addr;
	output [31:0] debugPin_PC;
	 // The outputs are defined as registers too
	reg [31:0] Read_addr=0;
	assign debugPin_PC = Read_addr;
	// The counter doesn't have any delay since the
	// output is latched when the negedge of the clock happens.
	
	always @(negedge clk)begin
		Read_addr=Read_addr+3'b100;
	end
	

endmodule


module Instruction_reg (debugPin_InstructionRegister,clk, Read_Addr, instruction);
	output [31:0] debugPin_InstructionRegister;
	reg [8*32 -1:0] instructionMemory;
	integer ins;
	input clk;
	input [31:0] Read_Addr;
	output [31:0] instruction;
	reg [31:0] instruction;
	integer i;

	assign debugPin_InstructionRegister[31:0]=instruction[31:0];
	//assign  debugPin_InstructionRegister[31:24] =Read_Addr[7:0] ;
	initial
	begin
		for(ins=0;ins<8*32;ins=ins+1)begin
			instructionMemory[ins]=1'b0;
		end
		//Instruction 0
		instructionMemory[32*0+27 : 32*0+24] =4'b0000;//oppcode
		instructionMemory[32*0+18 : 32*0+16] =3'b100;//Dest
		instructionMemory[32*0+10 : 32*0+08] =3'b000;//Source 2
		instructionMemory[32*0+ 7 : 32*0+ 0] =8'hFF;//Source 1
		//Instruction 1;
		instructionMemory[32*1 +27 : 32*1+24] =4'b0000;//oppcode
		instructionMemory[32*1+18 : 32*1+16] =3'b110;//Dest
		instructionMemory[32*1+10 : 32*1+08] =3'b000;//Source 2
		instructionMemory[32*1+ 7 : 32*1+ 0] =8'hAA;//Source 1
		//Instruction 2;
		instructionMemory[32*2 +27 : 32*2+24] =4'b0000;//oppcode
		instructionMemory[32*2+18 : 32*2+16] =3'b011;//Dest
		instructionMemory[32*2+10 : 32*2+08] =3'b000;//Source 2
		instructionMemory[32*2+ 7 : 32*2+ 0] =8'hBB;//Source 1
		//Instruction 3;
		instructionMemory[32*3 +27 : 32*3+24] =4'b0010;//oppcode ERROR
		instructionMemory[32*3+18 : 32*3+16] =3'b101;//Dest
		instructionMemory[32*3+10 : 32*3+08] =3'b110;//Source 2
		instructionMemory[32*3+ 2 : 32*3+ 0] =3'b011;//Source 1
		//Instruction 4;
		instructionMemory[32*4 +27 : 32*4+24] =4'b0100;//oppcode
		instructionMemory[32*4+18 : 32*4+16] =3'b001;//Dest
		instructionMemory[32*4+10 : 32*4+08] =3'b100;//Source 2
		instructionMemory[32*4+ 2 : 32*4+ 0] =3'b101;//Source 1
		//Instruction 5;
		instructionMemory[32*5 +27 : 32*5+24] =4'b0110;//oppcode
		instructionMemory[32*5+18 : 32*5+16] =3'b010;//Dest
		instructionMemory[32*5+10 : 32*5+08] =3'b001;//Source 2
		instructionMemory[32*5+ 2 : 32*5+ 0] =3'b110;//Source 1
		//Instruction 6;
		instructionMemory[32*6 +27 : 32*6+24] =4'b0001;//oppcode
		instructionMemory[32*6+18 : 32*6+16] =3'b111;//Dest
		instructionMemory[32*6+10 : 32*6+08] =3'b000;//Source 2
		instructionMemory[32*6+ 2 : 32*6+ 0] =3'b010;//Source 1
		//Instruction 7;
		instructionMemory[32*7 +27 : 32*7+24] =4'b0011;//oppcode
		instructionMemory[32*7+18 : 32*7+16] =3'b100;//Dest
		instructionMemory[32*7+10 : 32*7+08] =3'b011;//Source 2
		instructionMemory[32*7+ 2 : 32*7+ 0] =3'b111;//Source 1

	end
	always @(posedge clk) begin
		for(i=0;i<32;i=i+1)begin
			instruction[i]=instructionMemory[Read_Addr*8+i];
		end
	end
endmodule

module CU(debugPinCU,instruction, OUT1addr, OUT2addr, INaddr,SELECT,imValue,imValueMUXControlSignal,addSumMUXControlSignal);
	//In out here does not make sense for th control unit
	//They are named in the register file perspective
	output [15:0] debugPinCU;
	input [31:0] instruction;
	output [2:0] OUT1addr;
	output [2:0] OUT2addr;
	output [2:0] INaddr;
	output [2:0] SELECT;
	output [7:0] imValue;
	output imValueMUXControlSignal;
	output addSumMUXControlSignal;
//	reg [2:0] OUT1addr;
//	reg [2:0] OUT2addr;
//	reg [2:0] INaddr;
//	reg [2:0] SELECT;
//	reg [7:0] imValue;
//	reg imValueMUXControlSignal;
//	reg addSumMUXControlSignal;

	assign debugPinCU[2:0]=SELECT[2:0];
	assign debugPinCU[5:3]=OUT1addr;
	assign debugPinCU[8:6]=OUT2addr ;


	assign OUT1addr=instruction[2:0];
	assign OUT2addr=instruction[10:8];
	assign INaddr=instruction[18:16];
	assign imValue=instruction[7:0];
	assign SELECT=instruction[27:25];
	assign imValueMUXControlSignal = ~instruction[24];
	assign addSumMUXControlSignal = instruction[24];





	
endmodule

module MUX(out,a,b,control);
	input [7:0] a;
	input [7:0] b;
	output [7:0] out;
	input control;
	reg [7:0] out;

	always@(a,b,control)begin
		case(control)
			1'b0 : out=a[7:0];
			1'b1 : out=b[7:0];
		endcase
	end

endmodule

module TwosComplement(out,in);
	input [7:0] in;
	output [7:0] out;
	reg [7:0] out;

	always @(in)begin
		out= ~in + 8'b00000001;
	end
endmodule


module processor(debugPin,debugPinCU,debugPin_InstructionRegister,debugPin_PC,clk,reset);
	input clk;
	input reset;
	output [63:0] debugPin;
	output [15:0] debugPinCU;
	output [31:0] debugPin_InstructionRegister;
	output [31:0] debugPin_PC;

	wire [31:0] instructionAddress;
	wire [31:0] instruction;

	counter myCounter(debugPin_PC,clk,reset,instructionAddress);
	Instruction_reg myInstruction_reg(debugPin_InstructionRegister,clk, instructionAddress, instruction);


	wire [2:0] OUT1addr;
	wire [2:0] OUT2addr;
	wire [2:0] INaddr;
	wire [2:0] SELECT;
	wire [7:0] imValue;
	wire imValueMUXControlSignal;
	wire addSumMUXControlSignal;

	CU myCU(debugPinCU,instruction,OUT1addr,OUT2addr,INaddr,SELECT,imValue,imValueMUXControlSignal,addSumMUXControlSignal);

	wire [7:0] IN;
	wire [7:0] OUT1;
	wire [7:0] OUT2;

	regfile8x8a myregfile8x8a(debugPin,clk,INaddr,IN,OUT1addr,OUT1,OUT2addr,OUT2);

	wire [7:0] DATA1;
	wire [7:0] DATA2;
	wire [7:0] TwosComplementOutput;

	TwosComplement myTwosComplement(TwosComplementOutput,OUT2);

	MUX myMUX_intermediateValue(DATA1,OUT1,imValue,imValueMUXControlSignal);
	MUX myMUX_addSub(DATA2,TwosComplementOutput,OUT2,addSumMUXControlSignal);

	alu myAlu(IN,DATA1,OUT2,SELECT);//myAlu(Result,DATA1,DATA2,Select)




endmodule



module testbed;

	reg reset;
	reg clk;
	wire [63:0] debugPin;
	wire [15:0] debugPinCU;
	wire [31:0] debugPin_InstructionRegister;
	wire [31:0] debugPin_PC;

	processor myProcessor(debugPin,debugPinCU,debugPin_InstructionRegister,debugPin_PC,clk,reset);


	initial
	begin
		$monitor("reg0 =%d, reg1 =%d, reg2 =%d, reg3 =%d, reg4 =%d, reg5 =%d, reg6 =%d, reg7 =%d,",debugPin[7:0],debugPin[15:8],debugPin[23:16],debugPin[31:24],debugPin[39:32],debugPin[47:40],debugPin[55:48],debugPin[63:56]);

		//$monitor("SELECT=%d Add1=%d Add2=%d",debugPinCU[2:0],debugPinCU[5:3],debugPinCU[8:6]);
		//$monitor("The instruction:  %8b %8b %8b %8b ",debugPin_InstructionRegister[31:24],debugPin_InstructionRegister[23:16],debugPin_InstructionRegister[15:8],debugPin_InstructionRegister[7:0]);
		//$monitor("PC =%d",debugPin_PC);
		//$monitor("Clc=%d",clk);
		//$dumpfile("wavedata.vcd");
	    //$dumpvars(0,testbed);

		reset =1'b0;

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
		#5 clk=1'b0;
		#5 clk=1'b1;
		
		$finish;	
		
	end

endmodule