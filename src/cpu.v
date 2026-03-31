// Main cpu module that instantiates the other modules for the cpu
module cpu(
	// Inputs for the PC
	input clk,
	input rst,

	// Inputs from test bench
	input [31:0] instruction,

	// Output from data memory block
	output [31:0] memAddrOut,
	output [31:0] memDataOut,

	// Outputs to help with debugging
	output [31:0] pcOut,
	output [31:0] aluResultOut,
	output memWriteEnable
);

	wire [31:0] pcNext; // Next Program counter
	wire [31:0] readData1, readData2; // Register block
	wire [31:0] result; // output from the alu
	wire [31:0] writeData;
	wire [31:0] aluBdata_t;

	wire regWrite, ALUSrc, memWrite, memRead, memToReg; // wire for control block

	wire [1:0] ALUOp;
	wire [31:0] readData;


	// immediate values
	wire [31:0] imm_i;
	wire [31:0] imm_s;
	wire [31:0] imm_value;

	wire is_store = (instruction[6:0] == 7'b0100011);

	assign imm_i = {{20{instruction[31]}}, instruction[31:20]}; // I-type immediate
	assign imm_s = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
	assign imm_value     = (is_store) ? imm_s : imm_i;

	// Alu second input
	assign aluBdata_t = ALUSrc ? imm_value : readData2;


	// Instantiate the Program Counter module
	program_counter pc (
		.clk(clk),
		.rst(rst),
		.pcNext(pcNext),
		.out(memAddrOut) // PC output drives the memory address
	);

	// Instantiate the Instruction Decode and Register File module
	instruction_decode_register decode_reg (
		.clk(clk),
		.rst(rst),
		.instruction(instruction),
		.writeData(writeData),
		.writeEnable(regWrite),
		.readData1(readData1),
		.readData2(readData2)
	);

	// Instantiate the ALU module
	alu alu_block (
		.A(readData1),
		.B(aluBdata_t),
		.ALUOp(ALUOp),
		.result(result)
	);

	// Instantiate the Control Unit module
	controlUnit control_block (
		.instruction(instruction),
		.regWrite(regWrite),
		.ALUSrc(ALUSrc),
		.ALUOp(ALUOp),
		.memWrite(memWrite),
		.memRead(memRead),
		.memToReg(memToReg)
	);

	memory memory_block(
		.clk(clk),
		.memRead(memRead),
		.memWrite(memWrite),
		.address(result),
		.writeData(memDataOut),
		.readData(readData)
	);



	assign writeData = memToReg ? readData : result;

	// Data path logic and assignments
	assign pcNext = memAddrOut + 32'h4; // always increment by 4

	assign memDataOut = readData2;
	assign memWriteEnable = memWrite;

	// Debugging outputs
	assign pcOut = memAddrOut;
	assign aluResultOut = result;

endmodule
