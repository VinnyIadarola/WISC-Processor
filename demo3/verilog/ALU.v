/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals ZF and Overflow
    (OFL).
*/
`default_nettype none
module ALU 
(
    input wire [15:0] A,   // Input operand A
    input wire [15:0] B,   // Input operand B
    input wire                     c_in,   // Carry in
    input wire [3:0] oper, // operation type
    input wire                     inv_A,  // Signal to invert A
    input wire                     inv_B,  // Signal to invert B
    input wire                     B_to_zero,  // Signal to set B to 0
    input wire                     shift_A,  // Signal to shift A by 8
    input wire                     sign,    // Signal for signed operation

   
    input wire                     less_than,
    input wire                     equal_to,
    input wire                     set_CO,

    output reg [15:0] out,   // Result of computation

    //Flags
    output reg                     ZF,   // Signal if out is 0
    output reg                     CF,   // Signal if carry occurred
    output reg                     SF,     // Signal if out is negative
    output reg                     OF,   // Signal if overflow occurred
    output wire                    err   // Signal if error occurred

);





    /*********************************************************
    **                Selecting Proper Inputs               **
    **********************************************************/
    wire [15:0] true_A, true_B;
    
    //will use A or inverse A for operations or uses a shifted verison of A
    assign true_A = shift_A ? (A << 8) : (A ^ {16{inv_A}});

    //will use B or inverse B for operations and set B to 0 if B_to_zero is true
    assign true_B = ( (inv_B) ? ~B : B ) & {16{~B_to_zero}};



// true_B: Inverted or Original B, then masked to zero if B_to_zero is true

    /*********************************************************
    **              Barrel Shifter Instantiation            **
    **********************************************************/
    wire shifter_err;
    wire [15:0] barrel_out;

    shifter BARREL_SHIFTER (
        //Inputs
        .in(true_A),    
        .shift_amnt(true_B[3:0]), 
        .oper(oper[1:0]), 

        //outputs
        .out(barrel_out),
        .err(shifter_err)
    );


    /*********************************************************
    **                    Logical Block                     **
    **********************************************************/
    wire logical_err;
    wire [15:0] logical_out;
    wire logical_OF;
    wire logical_c_out;


    logical_unit LOGIC_UNIT (
        // Inputs
        .A(true_A),        
        .B(true_B),         
        .c_in(c_in),        
        .oper(oper[1:0]),      
        .sign(sign),     

        // outputs
        .out(logical_out),   
        .OF(logical_OF),
        .c_out(logical_c_out),
        .err(logical_err)
    
        );
    

    /*********************************************************
    **                      Set outputs                     **
    **********************************************************/
    reg output_err;
    always @(*) begin
        case(oper[3:2])
            //LOGICAL
            2'h0: begin
                //Flags
                OF = logical_OF;
                CF = logical_c_out;
                SF = logical_out[15];
                ZF = ~|logical_out;

                //output
                out = (less_than & equal_to) ? {15'h0000, ((ZF & ~OF) | (~SF ^ OF))} :
                                 (less_than) ?          {15'h0000, (~SF ^ OF) & ~ZF} :
                                  (equal_to) ?                  {15'h0000, ZF & ~OF} :
                                    (set_CO) ?                        {15'h0000, CF} :
                                                                         logical_out ;

                //Error
                output_err = 1'b0;

            end

            //SHIFTER
            2'h1: begin
                //Flags
                OF = 1'b0;
                CF = 1'b0;
                SF = barrel_out[15];
                ZF = ~|barrel_out;

                //output
                out = barrel_out;

                //Error
                output_err = 1'b0;
            end

            //BTR
            2'h2: begin
                //Flags
                CF = 1'b0;
                OF = 1'b0;
                SF = A[0];
                ZF = ~|A;

                //output
                out = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], 
                    A[9], A[10], A[11], A[12], A[13], A[14], A[15]};

                //Error
                output_err = 1'b0;

            end

            default: begin
                output_err = 1'b1;
                out = 16'hXXXX;
                CF = 1'bx;
                OF = 1'bx;
                SF = 1'bx;
                ZF = 1'bx;
                
            end
            
           
        endcase
    end

   /*********************************************************
   **                   Error Detection                    **
   *********************************************************/
    assign err = output_err | shifter_err | logical_err;

endmodule
`default_nettype wire

