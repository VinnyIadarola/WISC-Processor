`default_nettype none
module ADD_unit 
(
    input wire [15:0]  A,   // Input operand A
    input wire [15:0]  B,   // Input operand B
    input wire                      c_in,   // Carry in
    input wire                      sign,  // Signal for signed operation

    output wire                     c_out, // Carry out
    output wire                     OF,   // Signal if overflow occurred
    output wire [15:0]              out    // Result of shift/rotate
);

    /*********************************************************
    **                   Opcode definitions                 **
    **********************************************************/
     cla_16b CLA16 (
        .sum(out), 
        .c_out(c_out),
        .a(A), 
        .b(B), 
        .c_in(c_in)
    );



    /*********************************************************
    **                   Overflow Detection Logic           **
    **********************************************************/
    wire signed_of;
    assign signed_of = ~(A[15] ^ B[15]) & (out[15] ^ A[15]);

    assign OF = (sign) ? signed_of : c_out;  // If signed, check overflow; if unsigned, use carry-out







endmodule
`default_nettype wire