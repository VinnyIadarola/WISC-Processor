/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
`default_nettype none

module cla_16b 
#(
    parameter N = 16
) (
    output wire [N-1:0] sum, 
    output wire c_out,
    input wire [N-1:0] a, b, 
    input wire c_in
);


    /*********************************************************
    **                 Carry Initializations                **
    **********************************************************/
    wire [N:0] carries; 
    assign c_out = carries[N];
    assign carries[0] = c_in;


    /*********************************************************
    **                 Generates and Propagates             **
    **********************************************************/
    wire [N-1:0] g; // Carry generate
    wire [N-1:0] p; // Carry propagate

    assign g = a & b; 
    assign p = a | b; 


    /*********************************************************
    **                     CarryOut Output                  **
    **********************************************************/
    assign carries[N:1] = g | (p & carries[N-1:0]);


    /*********************************************************
    **                        Full Adder                   **
    **********************************************************/
    assign sum = (a ^ b) ^ carries[N-1:0];

    

endmodule

`default_nettype wire
