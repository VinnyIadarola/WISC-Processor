/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (

   //Inputs
   input wire [15:0] inc_PC,
   input wire [15:0] A,
   input wire [15:0] B,
   input wire [15:0] imm_1,
   input wire [15:0] imm_2,
   input wire [15:0] disp,

   //Opcode Inputs
   input wire [2:0] branch,
   input wire [3:0] ALU_control,

   //Control Inputs
   input wire [1:0] B_src,
   input wire imm_src,
   input wire ALU_jmp,
   input wire inv_A,
   input wire inv_B,
   input wire B_to_zero,
   input wire shift_A,
   input wire c_in,
   input wire sign,
   input wire less_than,
   input wire equal_to,
   input wire set_CO,

   //Outputs
   output wire [15:0] ALU_result,
   output wire PC_src,

     // Out of PC adder
   output wire [15:0]  disp_PC,
   
   //Error
   output wire err
);




   /*********************************************************
   **                     Instantiations                   **
   *********************************************************/  
   // ALU Flags
   wire         SF, 
                ZF,
                OF,
                CF;

   // B into the ALU
   reg [15:0]   true_B;

   // Add Mux to adder
   wire [15:0]  add_2_PC;

 

   // branch Control Output


   /*********************************************************
   **                     ALU SRC MUX                      **
   *********************************************************/  

   always @ (*) begin

      true_B = B;

      case(B_src)
         2'b00 : begin
         true_B = B;
         end

         2'b01 : begin
         true_B = imm_1;
         end

         2'b10 : begin
         true_B = imm_2;
         end

         2'b11 : begin
         true_B = disp;
         end
      endcase
   end



   /*********************************************************
   **                  Thee   A   L   U                    **
   *********************************************************/
   wire ALU_err;
   
   ALU alu_instance (
      // Inputs
      .A(A),
      .B(true_B),
      .oper(ALU_control),

      //Control Inputs 
      .inv_A(inv_A), // Wire for inv_A
      .inv_B(inv_B), // Wire for inv_B
      .c_in(c_in), //For subtraction
      .B_to_zero(B_to_zero), // Wire for B_to_zero
      .shift_A(shift_A), // Wire for shift_A
      .sign(sign),
      .less_than(less_than),
      .equal_to(equal_to),
      .set_CO(set_CO),

      //Outputs
      .out(ALU_result),
      .ZF(ZF),
      .CF(CF),
      .SF(SF),
      .OF(OF),
      .err(ALU_err)
   );

   /*********************************************************
   **                     branch Control                   **
   *********************************************************/
   wire branch_ctrl_err;

   branch_control branch_ctrl (
      //Inputs
      .branch(branch),
      .ZF(ZF),
      .SF(SF),
      .OF(OF),
      .CF(CF),

      //Outputs
      .PC_src(PC_src),
      .err(branch_ctrl_err)
   );

   /*********************************************************
   **                    PC Addition Mux                   **
   *********************************************************/
   assign add_2_PC = imm_src ? imm_2 : disp;
   


   /*********************************************************
   **                     Add PC and IMM                   **
   *********************************************************/
   cla_16b addImmToPC(
      //Inputs
      .a(inc_PC), 
      .b(add_2_PC), 
      .c_in(1'b0),

      //Outputs
      .sum(disp_PC), 
      .c_out()
   );




   /*********************************************************
   **                   Error Detection                    **
   *********************************************************/
   assign err = ALU_err | branch_ctrl_err;

   




endmodule
`default_nettype wire


