/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output wire err;

   // None of the above lines can be modified

   /*********************************************************
   **                     Wire instants                    **
   *********************************************************/
      wire [15:0] true_PC;
      wire [15:0] instr;
      wire [15:0] inc_PC;
      wire [15:0] write_data;
      wire [15:0] imm_1;
      wire [15:0] imm_2;
      wire [15:0] disp;
      wire dump;
      wire imm_src;
      wire inv_A;
      wire inv_B;
      wire shift_A;
      wire B_to_zero;
      wire c_in;
      wire sign;
      wire mem_write_en;
      wire ALU_jmp_src;
      wire [1:0] B_src;
      wire [2:0] branch;
      wire [3:0] ALU_control;
      wire [15:0] A;
      wire [15:0] read_data_2;
      wire [15:0] ALU_result;
      wire [15:0] read_data;
      wire [1:0] reg_src;
      wire mem_enable;
      wire less_than;
      wire equal_to;
      wire set_CO;

      wire fetch_err, decode_err, exec_err, wb_err;
      

   /*********************************************************
   **                          Fetch                       **
   *********************************************************/
   fetch fetch (
      //Basic Inputs  
      .clk(clk), 
      .rst(rst), 

      //Data Inputs 
      .true_PC(true_PC), 

      //Outputs
      .instr(instr), 
      .inc_PC(inc_PC), 
      .err(fetch_err)
   );

   /*********************************************************
   **                         Decode                       **
   *********************************************************/
   decode decode (
      //Inputs 
      .clk(clk),
      .rst(rst),
      .instr(instr), 
      .write_data(write_data), 

      //Immediate Value Outputs
      .imm_1(imm_1), 
      .imm_2(imm_2), 
      .disp(disp), 
      
      //Control Outputs
      .dump(dump),
      .imm_src(imm_src), 
      .inv_A(inv_A), 
      .inv_B(inv_B), 
      .shift_A(shift_A), 
      .B_to_zero(B_to_zero), 
      .c_in(c_in), 
      .sign(sign), 
      .mem_write_en(mem_write_en), 
      .ALU_jmp_src(ALU_jmp_src),
      .reg_src(reg_src),
      .B_src(B_src), 
      .branch(branch), 
      .ALU_control(ALU_control), 
      .mem_enable(mem_enable),
      .less_than(less_than),
      .equal_to(equal_to),
      .set_CO(set_CO),

      //Data Outputs
      .A(A), 
      .read_data_2(read_data_2),
      .err(decode_err)

      );


   /*********************************************************
   **                        Execute                       **
   *********************************************************/
   execute execute (
      //Data Inputs 
      .inc_PC(inc_PC), 
      .A(A), 
      .B(read_data_2), 
      .disp(disp), 
      .imm_1(imm_1), 
      .imm_2(imm_2), 

      //Opcode Inputs
      .ALU_control(ALU_control), 
      .branch(branch), 
 
      //Control Inputs
      .ALU_jmp(ALU_jmp_src), 
      .imm_src(imm_src), 
      .B_src(B_src), 
      .inv_A(inv_A), 
      .inv_B(inv_B), 
      .B_to_zero(B_to_zero), 
      .shift_A(shift_A), 
      .c_in(c_in), 
      .sign(sign), 
      .less_than(less_than),
      .equal_to(equal_to),
      .set_CO(set_CO),

      //Outputs
      .true_PC(true_PC), 
      .ALU_result(ALU_result),

      //Error
      .err(exec_err)
   );


   /*********************************************************
   **                         Memory                       **
   *********************************************************/
   memory memory (
      //Basic Inputs
      .clk(clk), 
      .rst(rst), 

      //Data Inputs
      .write_data(read_data_2), 
      .addr(ALU_result), 

      //Control Inputs
      .mem_enable(mem_enable),
      .mem_write(mem_write_en), 
      .dump(dump), 

      //Data Outputs
      .read_data(read_data)
   );


   /*********************************************************
   **                       Write Back                     **
   *********************************************************/
   wb wb (
      //Data Inputs
      .inc_PC(inc_PC), 
      .read_data(read_data), 
      .ALU_result(ALU_result), 
      .imm_2(imm_2),
      .reg_src(reg_src),

      //Outputs 
      .write_data(write_data),

      //Error
      .err(wb_err)
   );


   /*********************************************************
   **                   Error Detection                    **
   *********************************************************/
   assign err = (fetch_err | decode_err | exec_err | wb_err) & ~rst;
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
