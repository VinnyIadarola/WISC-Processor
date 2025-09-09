`default_nettype none
`include "logical_unit_config.v"
module logical_unit 
(
    input wire [15:0]  A,      // Input operand A
    input wire [15:0]  B,      // Input operand B
    input wire         c_in,   // Carry in
    input wire [1:0]   oper,   // Operation type
    input wire         sign,   // Signal for signed operation
    output reg [15:0]  out,    // Result of shift/rotate
    output wire        OF,     // Signal if overflow occurred
    output wire        c_out,  // Signal for carry out
    output reg         err
);

    /*********************************************************
    **                    ADD_unit Module                   **
    **********************************************************/
    wire [15:0] ADD_out;

    ADD_unit ADDER (
        // Inputs
        .A(A),         
        .B(B),          
        .c_in(c_in),      
        .sign(sign),    

        // outputs
        .OF(OF), //High if Overflow occurs
        .out(ADD_out),   
        .c_out(c_out) 
    );

    /*********************************************************
    **                        AND Module                    **
    **********************************************************/
    wire [15:0] AND_out;

    assign AND_out = (A & B);

    /*********************************************************
    **                        OR Module                     **
    **********************************************************/
    wire [15:0] OR_out;
    
    assign OR_out = A | B;

    /*********************************************************
    **                        XOR Module                    **
    **********************************************************/
    wire [15:0] XOR_out;

    assign  XOR_out = A ^ B;

    /*********************************************************
    **                   operand Selection                  **
    **********************************************************/
    always @(*) begin
        case(oper) 
            `ADD: begin
                out = ADD_out;
                err = 1'b0;
            end
            `AND: begin
                out = AND_out; 
                err = 1'b0;
            end
            `OR: begin
                out = OR_out; 
                err = 1'b0;
            end
            `XOR: begin
                out = XOR_out; 
                err = 1'b0;
            end
            default : begin
                out = 16'hXXXX;
                err = 1'b1;
            end
        endcase
    end




endmodule
`default_nettype wire