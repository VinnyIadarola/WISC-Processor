/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 2
    
 */
`default_nettype none
`include "shifter_config.v"
module shifter 
(
    input wire [15:0] in,    // input operand
    input wire [3:0]  shift_amnt, // Amount to shift/rotate
    input wire [1:0]  oper, // operation type
    output reg [15:0] out,    // Result of shift/rotate
    output reg err
);

    /*********************************************************
    **                  Rotate Left Module                  **
    **********************************************************/
    wire [15:0] ROL_out;

    rot_left ROTATELEFT (
        .in(in),
        .shift_amnt(shift_amnt),
        .out(ROL_out)
    );

    /*********************************************************
    **                  Rotate Right Module                  **
    **********************************************************/
    wire [15:0] ROR_out;

    rot_right ROTRIGHT (
        .in(in),
        .shift_amnt(shift_amnt),
        .out(ROR_out)
    );

    /*********************************************************
    **                   Shift Left Module                  **
    **********************************************************/
    wire [15:0] SLL_out;

    shift_left SHIFTLEFT (
        .in(in),
        .shift_amnt(shift_amnt),
        .out(SLL_out)
    );


    /*********************************************************
    **              Shift Right Logical Module              **
    **********************************************************/
    wire [15:0] SRL_out;

    shift_right_logic SHIFTRIGHTLOGIC (
        .in(in),
        .shift_amnt(shift_amnt),
        .out(SRL_out)
    );

    /*********************************************************
    **                   operand Selection                  **
    **********************************************************/
    always @(*) begin
        case(oper) 
            `ROL: begin
                out = ROL_out;
                err = 1'b0;
            end
            `SLL: begin
               out = SLL_out; 
               err = 1'b0;
            end
            `ROR: begin
               out = ROR_out; 
               err = 1'b0;
            end
            `SRL: begin
               out = SRL_out; 
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