// Handles all arithmetic and logical operations 
module alu(
    input[31:0] A,
    input[31:0] B,
    input [1:0] ALUOp,
    output reg [31:0] result
);

    always @(*) begin // For combinational logic - output updates whenever inputs change
        // alu alu_op to a certain operation 
        case (ALUOp)
            2'b00: result = A + B; // ADD
            2'b01: result = A - B; // SUBTRACT
            2'b10: result = A * B; // MULTIPLY
            2'b11: result = A / B; // DIVIDE
            default: result = 32'hx; // Undefined state
        endcase
    end


endmodule
