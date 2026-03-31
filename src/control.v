// Control block inside the cpu
module controlUnit(
    input [31:0] instruction,
    output reg regWrite,
    output reg ALUSrc,
    output reg memToReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg memRead
);

    wire [6:0] operation; // Determine the alu operation like sw, lw, etc 
    wire [2:0] alu_func_code; // Determine if we divide or the other three 
    wire [6:0] func_operation; // Determine if we should add, sub, or multiply

    assign operation      = instruction[6:0];
    assign alu_func_code  = instruction[14:12];
    assign func_operation = instruction[31:25];

    always @(*) begin
        // Set all output values to their default values (no-op)
        regWrite  = 1'b0;
        ALUSrc    = 1'b0;
        ALUOp= 2'b00;
        memWrite  = 1'b0;
        memToReg = 1'b0;
        memRead   = 1'b0; // default to memory read

        case (operation)
            7'b0110011: begin
                // register instruction type
                regWrite = 1'b1;
                ALUSrc   = 1'b0;

                if (alu_func_code == 3'b000) begin 
                    case (func_operation) 
                        7'b0000000: ALUOp = 2'b00; // ADD
                        7'b0100000: ALUOp = 2'b01; // SUBTRACT
                        7'b0000001: ALUOp = 2'b10; // MULTIPLY
                    endcase
                end else if (alu_func_code == 3'b100) begin 
                        if (func_operation == 7'b0000001) begin
                            ALUOp = 2'b11; // DIVIDE
                        end
                    end
                // end else begin
                        // Bad should not happen. Display to help with debugging     
                        //$display("Debug: Could not map alu_func_code to an ALUOp: alu_func_code=%b, func_operation=%b", alu_func_code, func_operation);
                //     end
                end
            7'b0010011: begin
                // intermediate instruction type 
                regWrite = 1'b1;
                ALUSrc   = 1'b1;
                ALUOp = 2'b00; // ADDI
            end
            7'b0000011: begin // LW (Load Word)
                regWrite     = 1'b1; // very important because cpu still needs to write the loaded memory into a register!!!
                ALUSrc       = 1'b1;
                memRead      = 1'b1;
                memToReg    = 1'b1;
                ALUOp = 2'b00; // Use ADD for address calculation
            end
            7'b0100011: begin // SW (Store Word)
                ALUSrc       = 1'b1;
                memWrite     = 1'b1;
                ALUOp = 2'b00; // Use ADD for address calculation
            end
            default: begin
                // invalid instruction - ignore 
                // Add display to help with debugging
                //$display("Debug: Could not map alu operation: operation=%b", operation);
            end
        endcase
    end
endmodule 
