/*
      
   Filename        : ALU_op_control.v
   Description     : ALU Operation Control Module
                    Manages ALU control signals based on function and ALU operation codes.
*/
`default_nettype none
`include "ALU_op_control_config.v"

module ALU_op_control (
    input wire [1:0] funct,
    input wire [4:0] ALU_op,
    output reg [3:0] ALU_control,
    output reg inv_A,
    output reg inv_B,
    output reg B_to_zero,
    output reg c_in,
    output reg shift_A,
    output reg sign,

    output reg less_than,
    output reg equal_to,
    output reg set_CO,

    output reg err
    );

    always @ (*) begin
        casex({funct, ALU_op})
        
            /*********************************************************
            **                     ADD Operations                   **
            *********************************************************/
            7'b0000000,        
            7'bXX00111:
             begin  
                // Opcode Control
                ALU_control  = `ADD; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b0;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end
                


            /*********************************************************
            **                      SUB Operations                  **
            *********************************************************/
            7'b0100000,
            7'bXX01000: begin 
                // Opcode Control
                ALU_control  = `ADD;

                // Input Control
                inv_A        = 1'b1;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b1;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end

            /*********************************************************
            **                       XOR Operations                 **
            *********************************************************/
            7'b1000000,        
            7'bXX01001: begin   
                // Opcode Control
                ALU_control  = `XOR;

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'bX; 
                shift_A      = 1'b0;
                sign         = 1'b0;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end

            /*********************************************************
            **                     AND Operations                   **
            *********************************************************/
            7'b1100000,        
            7'bXX01010: begin   
                // Opcode Control
                ALU_control  = `AND; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b1;
                B_to_zero    = 1'b0;
                c_in         = 1'bX;
                shift_A      = 1'b0;
                sign         = 1'b0;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                      Left Rotate                     **
            *********************************************************/
            7'b0000001,        
            7'bXX01011: begin   
                // Opcode Control
                ALU_control  = `ROL; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'bX; 
                shift_A      = 1'b0;
                sign         = 1'bX; 

                // Output Control
                less_than    = 1'bx;
                equal_to     = 1'bx;
                set_CO       = 1'bx;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                        Left Shift                    **
            *********************************************************/
            7'b0100001,        
            7'bXX01100: begin   
                // Opcode Control
                ALU_control  = `SLL; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'bX; 
                shift_A      = 1'b0;
                sign         = 1'bX; 

                // Output Control
                less_than    = 1'bx;
                equal_to     = 1'bx;
                set_CO       = 1'bx;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                       Right Rotate                   **
            *********************************************************/
            7'b1000001,      
            7'bXX01101: begin  
                // Opcode Control
                ALU_control  = `ROR; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'bX; 
                shift_A      = 1'b0;
                sign         = 1'bX; 

                // Output Control
                less_than    = 1'bx;
                equal_to     = 1'bx;
                set_CO       = 1'bx;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                       Right Shift                    **
            *********************************************************/
            7'b1100001,       
            7'bXX01110: begin   
                // Opcode Control
                ALU_control  = `SRL; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'bX; 
                shift_A      = 1'b0;
                sign         = 1'bX; 

                // Output Control
                less_than    = 1'bx;
                equal_to     = 1'bx;
                set_CO       = 1'bx;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                      Set on Equal                    **
            *********************************************************/
            7'bXX00010: begin 
                // Opcode Control
                ALU_control  = `ADD; 

                // Input Control
                inv_A        = 1'b1;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b1;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b1;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                     Set on Less Than                 **
            *********************************************************/
            7'bXX00011: begin 
                // Opcode Control
                ALU_control  = `ADD; 

                // Input Control
                inv_A        = 1'b1;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b1;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b1;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                Set on Less Than or Equal             **
            *********************************************************/
            7'bXX00100: begin 
                // Opcode Control
                ALU_control  = `ADD;

                // Input Control
                inv_A        = 1'b1;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b1;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b1;
                equal_to     = 1'b1;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                     Set on Carry Out                 **
            *********************************************************/
            7'bXX00101: begin 
                // Opcode Control
                ALU_control  = `ADD; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b0;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b1;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                      SLBI Operation                  **
            *********************************************************/
            7'bXX01111: begin
                // Opcode Control
                ALU_control  = `OR; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'b0;
                B_to_zero    = 1'b0;
                c_in         = 1'b0;
                shift_A      = 1'b1;
                sign         = 1'b0;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                      BTR Operation                   **
            *********************************************************/
            7'bXX00110: begin
                // Opcode Control
                ALU_control  = `BTR; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'bX;
                B_to_zero    = 1'bX;
                c_in         = 1'bX;
                shift_A      = 1'b0;
                sign         = 1'bX;

                // Output Control
                less_than    = 1'bx;
                equal_to     = 1'bx;
                set_CO       = 1'bx;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                    Branch Operation                  **
            *********************************************************/
            7'bXX10000: begin 
                // Opcode Control
                ALU_control  = `ADD; 

                // Input Control
                inv_A        = 1'b0;
                inv_B        = 1'bX;
                B_to_zero    = 1'b1;
                c_in         = 1'b0;
                shift_A      = 1'b0;
                sign         = 1'b1;

                // Output Control
                less_than    = 1'b0;
                equal_to     = 1'b0;
                set_CO       = 1'b0;

                // Error Signal
                err          = 1'b0;
            end


            /*********************************************************
            **                      Default Case                    **
            *********************************************************/
            default: begin
                // Opcode Control
                ALU_control  = 4'bXXXX; 

                // Input Control
                inv_A        = 1'bX;
                inv_B        = 1'bX;
                B_to_zero    = 1'bX;
                c_in         = 1'bX;
                shift_A      = 1'bX;
                sign         = 1'bX;

                // Output Control
                less_than    = 1'bx;
                equal_to     = 1'bx;
                set_CO       = 1'bx;

                // Error Signal
                err          = 1'b1;
            end
        endcase
    end

endmodule
`default_nettype wire
