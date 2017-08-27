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


module reg_file(IN,OUT1,OUT2,clk,RESET,INaddr,OUT1addr,OUT2addr);
	reg [(8*8)-1:0] memory;
	input [7:0] IN;
	output [7:0] OUT1;
	output [7:0] OUT2;
	reg [7:0] outReg1;
	reg [7:0] outReg2;
	input clk;
	input RESET;
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

	always @(posedge RESET) begin
		for(i=0;i<64;i++)
			memory[i]=0;
		end
	end
endmodule



module programCounter(OUT,NEXT,clk);
	output [8:0] OUT;
	input [8:0] NEXT;
	input clk;
	reg [8:0] pc;
	assign OUT = pc;
	always @(posedge clk) begin
		pc=NEXT;
	end
endmodule


module instructionRegister(instruction,clk)



module instructionMemory(OUT,address,clk);

endmodule
	



module testbed;

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

endmodule