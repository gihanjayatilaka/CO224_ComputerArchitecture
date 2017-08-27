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

 

module regfile8x8a(clk,INaddr,IN,OUT1addr,OUT1,OUT2addr,OUT2);
	reg [(8*8)-1:0] memory;
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

	assign OUT1=outReg1;
	assign OUT2=outReg2;

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
	reg [31:0] Read_addr;
	// The counter doesn't have any delay since the
	// output is latched when the negedge of the clock happens.
	
	always @(negedge clk)begin
		Read_addr=Read_addr+4;
	end
	

endmodule


module Instruction_reg (clk, Read_Addr, instruction);
	reg [8*8 -1:0] instructionMemory;
	initial
	begin
		instructionMemory[8*0+ 7: 8*0+  0]= 8'b00000000;
		instructionMemory[8*1+ 7: 8*1+  0]= 8'b00000000;
		instructionMemory[8*2+ 7: 8*2+  0]= 8'b00000000;
		instructionMemory[8*3+ 7: 8*3+  0]= 8'b00000000;
		instructionMemory[8*4+ 7: 8*4+  0]= 8'b00000000;
		instructionMemory[8*5+ 7: 8*5+  0]= 8'b00000000;
		instructionMemory[8*6+ 7: 8*6+  0]= 8'b00000000;
		instructionMemory[8*7+ 7: 8*7+  0]= 8'b00000000;	
	end
	input clk;
	input [31:0] Read_Addr;
	output [31:0] instruction;
	reg [31:0] instruction;
	integer i;
	always @(negedge clk) begin
		for(i=0;i<8;i++)begin
			instruction[i]=instructionMemory[Read_Addr+i];
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
	reg [2:0] imValue;
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


module processor(clk,reset);
	input clk;
	input reset;

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

	regfile8x8a myregfile8x8a(clk,INaddr,IN,OUT1addr,OUT1,OUT2addr,OUT2);

	wire [7:0] DATA1;
	wire [7:0] DATA2;
	wire [7:0] TwosComplementOutput;

	TwosComplement myTwosComplement(TwosComplementOutput,OUT2);

	MUX myMUX_intermediateValue(DATA1,OUT1,imValue,imValueMUXControlSignal);
	MUX myMUX_addSub(DATA2,OUT2,TwosComplementOutput,addSumMUXControlSignal)

	alu myAlu(IN,DATA1,OUT2,SELECT);//myAlu(Result,DATA1,DATA2,Select)




endmodule



module testbed;
/*
	reg [7:0] DATA1,DATA2;
	reg [2:0] Select;
	wire [7:0] Result;
	alu MyAlu(Result,DATA1,DATA2,Select);


	initial
	begin

		//$dumpfile("wavedata.vcd");
	    //$dumpvars(0,testbed);

		assign DATA1=5;
		assign DATA2=10;

		#5 Select=3'b000;
		#5 $display("Assigned %d to  %d",DATA1,Result);

		#5 Select=3'b001;
		#5 $display("%d + %d = %d",DATA1,DATA2,Result);

		#5 Select=3'b010;
		#5 $display("%d & %d = %d",DATA1,DATA2,Result);

		#5 Select=3'b011;
		#5 $display("%d | %d = %d",DATA1,DATA2,Result);

		
		$finish;	
		
	end
*/
endmodule