/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (
   //Basic Inputs
   input wire clk,
   input wire rst,

   //Inputs
   input wire [15:0] instr,
   input wire [15:0] write_data,
   input wire [2:0] write_reg_sel_in,
   input wire        reg_write_en_in,

   //Immediate Value Outputs
   output wire [15:0] imm_1,
   output wire [15:0] imm_2,
   output wire [15:0] disp,


   //Control Outputs
   output wire dump,
   output wire imm_src,
   output wire inv_A,
   output wire inv_B,
   output wire shift_A,
   output wire B_to_zero,
   output wire c_in,
   output wire sign,
   output wire mem_write_en,
   output wire ALU_jmp_src,
   output wire mem_enable,
   output wire less_than,
   output wire equal_to,
   output wire set_CO,
   output wire [1:0] B_src,
   output wire [1:0] reg_src,
   output wire [2:0] branch,
   output wire [3:0] ALU_control,
   output reg [2:0] write_reg_sel_out,
   output wire        reg_write_en_out,


   //Data Outputs
   output wire [15:0] A,
   output wire [15:0] read_data_2,
   output wire err
);


   /*********************************************************
   **                  Module Wire Instants                **
   *********************************************************/
   wire ZExt_src;
   wire reg_err;
   wire [1:0] reg_write_dst;
   wire [4:0] ALU_op;


   /*********************************************************
   **                    Extender Module                   **
   *********************************************************/
   extender I_Type_Extender (
      //Inputs
      .instr(instr), //Used to determine the immediate values
      .ZExt_src(ZExt_src), //Used to determine Zero Extension or Sign Extension

      //Outputs
      .imm_1(imm_1), //For I type 1: uses the first 5 bits
      .imm_2(imm_2), //For I type 2: uses the first 8 bits
      .disp(disp) //For Jump: uses the first 11 bits
   );


   /*********************************************************
   **                Write Register Selection              **
   *********************************************************/
   always @(*) begin
      case(reg_write_dst)
         2'b00 : write_reg_sel_out = instr[7:5]; //I-Type 1 Destination
         2'b01 : write_reg_sel_out = instr[10:8]; //I-Type 2 Destination
         2'b10 : write_reg_sel_out = instr[4:2]; //R-Type Destination //TODO On Diagram says 5 but i think it should be 4
         2'b11 : write_reg_sel_out = 3'h7; //J-Type Destination
         default : write_reg_sel_out = 3'hX; 
      endcase
   end


   /*********************************************************
   **                     Register File                    **
   *********************************************************/     
   // regFile iRegFile (
   //    //Basic Inputs
   //    .clk(clk),
   //    .rst(rst),

   //    //Inputs
   //    .read1RegSel(instr[10:8]), //Source Register for all Instructions
   //    .read2RegSel(instr[7:5]), //Target Register for R-Type Instructions only
   //    .writeEn(reg_write_en_in), 
   //    .writeRegSel(write_reg_sel_in), 
   //    .writeData(write_data), 

   //    //Outputs
   //    .read1Data(A),
   //    .read2Data(read_data_2),

   //    //Error 
   //    .err(reg_err)
   // );

   regFile_bypass reg_pass(
            //Basic Inputs
      .clk(clk),
      .rst(rst),

      //Inputs
      .read1RegSel(instr[10:8]), //Source Register for all Instructions
      .read2RegSel(instr[7:5]), //Target Register for R-Type Instructions only
      .writeEn(reg_write_en_in), 
      .writeRegSel(write_reg_sel_in), 
      .writeData(write_data), 

      //Outputs
      .read1Data(A),
      .read2Data(read_data_2),

      //Error 
      .err(reg_err)

   );


   /*********************************************************
   **                   Instruction Decoder                **
   *********************************************************/
   wire inst_err;
   instruction_decoder ID(
      //Inputs
      .opcode(instr[15:11]),

      //Source Control Outputs
      .dump(dump),
      .B_src(B_src),
      .imm_src(imm_src),
      .ZExt_src(ZExt_src),
      .ALU_jmp_src(ALU_jmp_src),
      .reg_src(reg_src),
      .reg_write_dst(reg_write_dst),
      .mem_enable(mem_enable),

      //Enable Outputs
      .reg_write_en(reg_write_en_out),
      .mem_write_en(mem_write_en),

      //Complex Control Outputs
      .ALU_op(ALU_op),
      .branch(branch),

      //Error 
      .err(inst_err)
   );


   /*********************************************************
   **                     ALU op Control                   **
   *********************************************************/
   wire ALU_op_err;
   ALU_op_control ALU_op_control (
      //Inputs
      .funct(instr[1:0]), 
      .ALU_op(ALU_op), 

      //Control Outputs
      .ALU_control(ALU_control), 
      .inv_A(inv_A), 
      .inv_B(inv_B), 
      .B_to_zero(B_to_zero), 
      .c_in(c_in), 
      .shift_A(shift_A), 
      .sign(sign),
      .less_than(less_than),
      .equal_to(equal_to),
      .set_CO(set_CO),

      //Error
      .err(ALU_op_err)
   );
    

   // Error Detecton
   assign err = inst_err | reg_err | ALU_op_err;

endmodule
`default_nettype wire
