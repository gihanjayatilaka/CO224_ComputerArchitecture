// Author : Sanoj Punchihewa

module testbed;

	// == TESTBED FOR CPU ==

	reg clk, reset,rst;
	wire [31:0] instruction;
	wire [2:0] out_addr1, out_addr2, in_addr, select;
	wire [3:0] ReadAddr;
	wire data2_compli_control, immediate_control,busy_wait,memRead,memWrite,regWrite;
	wire [7:0] dataIN, dataSRC1, dataSRC2, dataSRC2_COMPLI, data2, data1, immediate_value,toReg,address,read_data,write_data;

	PC myPC(clk, reset,busy_wait, ReadAddr);
	regInstructions myRegInstr(clk, ReadAddr, instruction);
	CU myCU(busy_wait,instruction, out_addr1, out_addr2, in_addr, select, data2_compli_control, immediate_control, immediate_value, memRead,memWrite,regWrite,address);



	regFile8x8a mREG(clk,busy_wait, in_addr, toReg, out_addr1, dataSRC1, out_addr2, dataSRC2);
	CMPL myCMPL(dataSRC2, dataSRC2_COMPLI);
	MUX mMUX_C(dataSRC2, dataSRC2_COMPLI, data2_compli_control, data2);
	MUX mMUX_I(dataSRC1, immediate_value, immediate_control, data1);
	MUX mMUX_regWrite(write_data, read_data, regWrite, toReg);
	alu mALU(write_data, data1, data2, select);
	data_mem mdata_mem(clk,rst,memRead,memWrite,address,write_data,read_data,busy_wait);
	initial
	begin

		$dumpfile("wavedata.vcd");
	    $dumpvars(0,testbed);
		
		clk = 1'b0;
		reset = 1'b0;
		rst = 1'b0;
		rst = 1'b1;
		$monitor("DataIn = %d", write_data);
		
	end

	always #50 clk = ~clk;
	
	initial
	begin
		#5000 $finish;
	end

endmodule

module PC (

	input clk,    // Clock
	input reset,
	input busy_wait,
	output [3:0] Read_addr
	
);

reg [3:0] Read_addr = 4'b0000;

always @(posedge clk)
begin
	if(~reset && !busy_wait)
		begin
			Read_addr <= Read_addr + 1'b1;	
		end
		
	else if (busy_wait) begin
		Read_addr <= Read_addr;
	end
	else begin
		Read_addr <= 4'b0000;
	end
		
end

endmodule

module regInstructions (
	input clk,    
	input [3:0] Read_Addr, 
	output [31:0] instruction
	
);

reg [31:0] instruction;

				   //  00000000							op_code
				   // 		   00000000					destination
				   //   			   00000000			source 2
				   //  			     	       00000000	source 1
reg [31:0] step1 = 32'b00001000000001000000000000010001;		// loadi 4, X, 17
reg [31:0] step2 = 32'b00000101000000000000000000000100;		// store 0, X, 4
reg [31:0] step3 = 32'b00000100000001010000000000000000;		// load 5, X, 0
reg [31:0] step4 = 32'b00000001000001100000010100000100;		// add   5, 5, 4
// reg [31:0] step5 = 32'b00000010000000010000010000000101;		// and   1, 4, 5
// reg [31:0] step6 = 32'b00000011000000100000000100000110;		// or    2, 1, 6 
// reg [31:0] step7 = 32'b00000000000001110000000000000010;		// mov   7, x, 2
// reg [31:0] step8 = 32'b00001001000001000000011100000011;		// sub   4, 7, 3

always @(negedge clk) 
begin
	case (Read_Addr)
		4'd0:instruction = step1;
		4'd1:instruction = step2;
		4'd2:instruction = step3;
		4'd3:instruction = step4;
		// 4'd4:instruction = step5;
		// 4'd5:instruction = step6;
		// 4'd6:instruction = step7;
		// 4'd7:instruction = step8;
		default : /* default */;
	endcase
end

endmodule

module CU (

	input busy_wait, //new
	input [31:0] instruction,
	output [2:0] OUT1addr,
	output [2:0] OUT2addr,
	output [2:0] INaddr,	
	output [2:0] select,
	output data2_compli_control,
	output immediate_control,
	output [7:0] immediate_value,
	output memRead, //new
	output memWrite, //new
	output regWrite, //new
	output [7:0] address

);

reg select, OUT1addr, OUT2addr, INaddr, data2_compli_control, immediate_control, immediate_value,memWrite,memRead,regWrite,address;

always @(instruction) 
begin
	memRead = 1'b0;
	memWrite = 1'b0;
	select = instruction[26:24];
	INaddr = instruction[18:16];
	OUT1addr = instruction[2:0];
	OUT2addr = instruction[10:8];
	immediate_control = 1'b0;
	immediate_value = instruction[7:0];
	data2_compli_control = 1'b0;
		case (instruction[27:24])				//new
		4'b0100:
			// load	from memory 
			begin
				memWrite = 1'b0;
				memRead = 1'b1;
				address = instruction[7:0];
				$display("oper = load");	
			end
			
		4'b0101:
			begin
				memRead = 1'b0;
				memWrite = 1'b1;
	 			address = instruction[23:16];
				$display("oper = store");
			end						
			// store to memory
		4'b1000:
			// load
			begin
				immediate_control = 1'b1;
				$display("oper = loadImmediate");		
			end	
			
		4'b1001:						
			// sub
			// use the 2's comp
			data2_compli_control = 1'b1;
			//$display("oper = SUB");
		default : 
		;

	endcase
	
end

endmodule

module regFile8x8a (
	input clk,  
	input busy_wait,		//new
	input [2:0] INaddr, 
	input [7:0] IN,
	input [2:0] OUT1addr,
	output [7:0] OUT1,
	input [2:0] OUT2addr,
	output [7:0] OUT2
);

reg [7:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

assign OUT1 = OUT1addr == 0 ? reg0 :
			  OUT1addr == 1 ? reg1 :
			  OUT1addr == 2 ? reg2 :
			  OUT1addr == 3 ? reg3 :
			  OUT1addr == 4 ? reg4 :
			  OUT1addr == 5 ? reg5 :
			  OUT1addr == 6 ? reg6 :
			  OUT1addr == 7 ? reg7 :
			  0;

assign OUT2 = OUT2addr == 0 ? reg0 :
			  OUT2addr == 1 ? reg1 :
			  OUT2addr == 2 ? reg2 :
			  OUT2addr == 3 ? reg3 :
			  OUT2addr == 4 ? reg4 :
			  OUT2addr == 5 ? reg5 :
			  OUT2addr == 6 ? reg6 :
			  OUT2addr == 7 ? reg7 :
			  0;

always @(negedge clk) //new
begin
	if (!busy_wait) begin
		case (INaddr)
		3'b000:reg0 = IN;
		3'b001:reg1 = IN;
		3'b010:reg2 = IN;
		3'b011:reg3 = IN;
		3'b100:reg4 = IN;
		3'b101:reg5 = IN;
		3'b110:reg6 = IN;
		3'b111:reg7 = IN;
	endcase	
	end
	
end

endmodule

module CMPL (
	input [7:0] Data,    
	output [7:0] out	
);

reg out;

always @(Data)
begin
	out = ~Data + 8'b00000001;
end

endmodule

module MUX (
	input [7:0] Data1,    
	input [7:0] Data2, 
	input control,
	output [7:0] out	
);

reg out;

always @(Data1, Data2, control)
begin
	case (control)
		1'b1:out = Data2;
		default :out = Data1;
	endcase

end

endmodule

module alu(out, DATA1, DATA2, Select);

input [7:0] DATA1, DATA2;
input [2:0] Select;
output [7:0] out;
reg out;

always @(DATA1, DATA2, Select)
	begin
	//$display("opcode = %b" ,Select);
	case(Select)
	3'b000:out = DATA1;
	3'b100:out = DATA1;	//new
	3'b101:out = DATA1;	//new
	3'b001:out = DATA1+DATA2;
	3'b010:out = DATA1 & DATA2;
	3'b011:out = DATA1 | DATA2;
	default:$display("Err in OpCode");
	endcase
	//$display("op = %b => %b %b = %b",Select, DATA1, DATA2, out);
end
endmodule

module data_mem(
    clk,
    rst,
    read,
    write,
    address,
    write_data,
    read_data,
	busy_wait
);
input           clk;
input           rst;
input           read;
input           write;
input[7:0]      address;
input[7:0]      write_data;
output[7:0]     read_data;
output			busy_wait;

reg[7:0]     read_data;
reg busy_wait=1'b0,clkMem=1'b0;
integer  i;

// Declare memory 256x8 bits 
reg [7:0] memory_array [255:0];
//reg [7:0] memory_ram_q [255:0];



always @(posedge rst)
begin
    if (rst)
    begin
        for (i=0;i<256; i=i+1)
            memory_array[i] <= 0;
    end
end

always #1 clkMem = ~clkMem;

always @(posedge clkMem)
begin
    if (write && !read && !busy_wait)
	begin
		busy_wait <= 1;
		// artificially delay 100 cycles
		repeat(10)
		begin
		@(posedge clk);
        end
        $display("writing to memory");
        memory_array[address] = write_data;
		busy_wait <= 0;
	end
    if (!write && read && !busy_wait)
	begin
		busy_wait <= 1;
		// artificially delay 100 cycles
        repeat(10)
		begin
		@(posedge clk);
        end
        $display("reading from memory");
        read_data = memory_array[address];
		busy_wait <= 0;
	end
end
 
endmodule
