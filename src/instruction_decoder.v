module instruction_decode_register(
    input clk,
    input rst, 
    input [31:0] instruction,
    input [31:0] writeData,
    input writeEnable,
    output[31:0] readData1,
    output[31:0] readData2
);
    // 8 general purpose registers
    reg [31:0] registers [0:7];

    assign readData1 = registers[instruction[19:15]];
    assign readData2 = registers[instruction[24:20]];


    integer i;
    always @(posedge clk) begin
        if (rst) begin 
            // Reset all registers to 0 
            for (i = 0; i < 8; i = i + 1)
                registers[i] <= 32'b0;
        end else if (writeEnable && instruction[11:7] != 5'b0) begin // IMPORTANT: do not write to x0, which is always 0 b/c that register is always 0
                registers[instruction[11:7]] <= writeData;
                $display("Writing %h to x%0d", writeData, instruction[11:7]);
        end
    end

endmodule
