module memory(
    input clk,
    input memRead,
    input memWrite,
    input [31:0] address,
    input [31:0] writeData,
    output reg [31:0] readData
);
    // 4 words of 32-bit memory
    reg [31:0] mem_array [0:3];

    // Synchronous write: only write on the rising edge of clk
    always @(posedge clk) begin
        if (memWrite) begin
            // Write data to memory at addressess (NOTE word-aligned)
            mem_array[address[9:2]] <= writeData;
            $display("MEMORY: Write %h to address %h (index %0d)", writeData, address, address[9:2]);
        end
    end

    // Read logic 
    always @(*) begin
        if (memRead) begin
            // Read data from memory at addressess (NOTE word-aligned)
            readData = mem_array[address[9:2]];
            $display("MEMORY: Read %h from address %h (index %0d)", readData, address, address[9:2]);
        end else begin
            readData = 32'b0;
        end
    end

endmodule
