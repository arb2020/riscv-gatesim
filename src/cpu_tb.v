`timescale 1ns / 1ps
`default_nettype none // Prevent silent declartion of undeclared wires

module cpu_tb;

    // DUT signals
    reg clk;
    reg rst;
    wire [31:0] memAddrOut;
    wire [31:0] memDataOut;
    wire memWriteEnable;

    // Test bench memory models
    reg [31:0] instruction_memory [0:7];

    // Instruction inputs into the cpu
    wire [31:0] instruction;
    wire [31:0] aluResultOut;
    wire [31:0] pcOut;

    // Connect the CPU to the test bench
    cpu dut (
        .clk(clk),
        .rst(rst),
        .instruction(instruction),
        .memAddrOut(memAddrOut),
        .memDataOut(memDataOut),
        .aluResultOut(aluResultOut),
        .pcOut(pcOut),
        .memWriteEnable(memWriteEnable)
    );

    // Link the instruction memory from tb to cpu
    assign instruction = instruction_memory[dut.pcOut / 4];

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end

    // Test program by testing every operation
    // - Add, Subtract, divide, multiple, store, and load
    initial begin
        // ADDI x1, x0, 10        @ PC = 0
        instruction_memory[0] = 32'h00A00093; // x1 = 10
        // ADDI x2, x0, 20        @ PC = 4
        instruction_memory[1] = 32'h01400113; // x2 = 20
        // ADD x3, x1, x2         @ PC = 8
        instruction_memory[2] = 32'h002081B3; // x3 = x1 + x2
        // SW x3, 0(x0)           @ PC = 12
        instruction_memory[3] = 32'h00302023; // store x3 at mem[0]
        // LW x4, 0(x0)           @ PC = 16
        instruction_memory[4] = 32'h00002283; // load x4 from mem[0]
        // MUL x5, x1, x2         @ PC = 20
        instruction_memory[5] = 32'h022082B3; // x5 = x1 * x2
        // DIV x6, x2, x1         @ PC = 24
        instruction_memory[6] = 32'h02114333; // x6 = x2 / x1

        // Apply reset
        rst = 1;
        #10 rst = 0;

        // Monitor the simulation and we will see each instruction executed line by line
        $monitor("Time=%0t, PC=%h, Instruction=%h, ALU_Result=%h", $time, dut.pcOut, dut.instruction, dut.aluResultOut);

        // Run simulation for a while
        #70 $finish;
    end

endmodule
