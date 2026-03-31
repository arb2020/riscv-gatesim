module program_counter(
    input clk, 
    input rst, 
    input [31:0] pcNext,
    output reg [31:0] out
);
    // increment by 4 unless rst is active
    always @(posedge clk or posedge rst) begin 
        if (rst) begin 
            // reset is active so reset the program counter to 0
            out <= 32'h00000000;
        end 
        else begin 
            // increment program counter to the next value
            out <= pcNext;
        end
    end 

endmodule 
