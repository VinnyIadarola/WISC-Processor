`default_nettype none
module Decode_Execute_FF (
   // Basic inputs
   input wire clk,
   input wire global_rst,
   input wire local_clr,
   input wire freeze,

   // Flop inputs
   input wire [15:0] inc_PC_DE_in,
   input wire [15:0] imm_1_DE_in,
   input wire [15:0] imm_2_DE_in,
   input wire [15:0] disp_DE_in,
   input wire dump_DE_in,
   input wire imm_src_DE_in,
   input wire inv_A_DE_in,
   input wire inv_B_DE_in,
   input wire shift_A_DE_in,
   input wire B_to_zero_DE_in,
   input wire c_in_DE_in,
   input wire sign_DE_in,
   input wire mem_write_en_DE_in,
   input wire ALU_jmp_src_DE_in,
   input wire [1:0] reg_src_DE_in,
   input wire [1:0] B_src_DE_in,
   input wire [2:0] branch_DE_in,
   input wire [3:0] ALU_control_DE_in,
   input wire mem_enable_DE_in,
   input wire less_than_DE_in,
   input wire equal_to_DE_in,
   input wire set_CO_DE_in,
   input wire [15:0] A_DE_in,
   input wire [15:0] read_data_2_DE_in,
   input wire reg_write_en_DE_in,
   input wire [2:0] write_reg_sel_DE_in,

   // Outputs
   output wire [15:0] inc_PC_DE_out,
   output wire [15:0] imm_1_DE_out,
   output wire [15:0] imm_2_DE_out,
   output wire [15:0] disp_DE_out,
   output wire dump_DE_out,
   output wire imm_src_DE_out,
   output wire inv_A_DE_out,
   output wire inv_B_DE_out,
   output wire shift_A_DE_out,
   output wire B_to_zero_DE_out,
   output wire c_in_DE_out,
   output wire sign_DE_out,
   output wire mem_write_en_DE_out,
   output wire ALU_jmp_src_DE_out,
   output wire [1:0] reg_src_DE_out,
   output wire [1:0] B_src_DE_out,
   output wire [2:0] branch_DE_out,
   output wire [3:0] ALU_control_DE_out,
   output wire mem_enable_DE_out,
   output wire less_than_DE_out,
   output wire equal_to_DE_out,
   output wire set_CO_DE_out,
   output wire [15:0] A_DE_out,
   output wire [15:0] read_data_2_DE_out,
   output wire reg_write_en_DE_out,
   output wire [2:0] write_reg_sel_DE_out
);

   wire mem_write_en_DE_out_before_freeze;
   wire reg_write_en_DE_out_before_freeze;

   wire rst;

   assign rst = global_rst | local_clr;

   /*********************************************************
   **                   16-bit Data Flops                  **
   *********************************************************/
   dff_freeze inc_PC_Flops[15:0]        (.clk(clk), .rst(rst), .freeze(freeze), .d(inc_PC_DE_in),      .q(inc_PC_DE_out));
   dff_freeze imm_1_Flops[15:0]         (.clk(clk), .rst(rst), .freeze(freeze), .d(imm_1_DE_in),       .q(imm_1_DE_out));
   dff_freeze imm_2_Flops[15:0]         (.clk(clk), .rst(rst), .freeze(freeze), .d(imm_2_DE_in),       .q(imm_2_DE_out));
   dff_freeze disp_Flops[15:0]          (.clk(clk), .rst(rst), .freeze(freeze), .d(disp_DE_in),        .q(disp_DE_out));
   dff_freeze A_Flops[15:0]             (.clk(clk), .rst(rst), .freeze(freeze), .d(A_DE_in),           .q(A_DE_out));
   dff_freeze read_data_2_Flops[15:0]   (.clk(clk), .rst(rst), .freeze(freeze), .d(read_data_2_DE_in), .q(read_data_2_DE_out));

   /*********************************************************
   **                   Multi-bit Control Flops            **
   *********************************************************/
   dff_freeze reg_src_Flops[1:0]        (.clk(clk), .rst(rst), .freeze(freeze), .d(reg_src_DE_in),      .q(reg_src_DE_out));
   dff_freeze branch_Flops[2:0]         (.clk(clk), .rst(rst), .freeze(freeze), .d(branch_DE_in),       .q(branch_DE_out));
   dff_freeze ALU_control_Flops[3:0]    (.clk(clk), .rst(rst), .freeze(freeze), .d(ALU_control_DE_in),  .q(ALU_control_DE_out));
   dff_freeze B_src_Flop[1:0]           (.clk(clk), .rst(rst), .freeze(freeze), .d(B_src_DE_in),        .q(B_src_DE_out));
   dff_freeze write_reg_sel_Flops[2:0]  (.clk(clk), .rst(rst), .freeze(freeze), .d(write_reg_sel_DE_in),.q(write_reg_sel_DE_out));

   /*********************************************************
   **                   Single-bit Control Flops           **
   *********************************************************/
   dff_freeze dump_Flop                 (.clk(clk), .rst(rst), .freeze(freeze), .d(dump_DE_in),         .q(dump_DE_out));
   dff_freeze imm_src_Flop              (.clk(clk), .rst(rst), .freeze(freeze), .d(imm_src_DE_in),      .q(imm_src_DE_out));
   dff_freeze inv_A_Flop                (.clk(clk), .rst(rst), .freeze(freeze), .d(inv_A_DE_in),        .q(inv_A_DE_out));
   dff_freeze inv_B_Flop                (.clk(clk), .rst(rst), .freeze(freeze), .d(inv_B_DE_in),        .q(inv_B_DE_out));
   dff_freeze shift_A_Flop              (.clk(clk), .rst(rst), .freeze(freeze), .d(shift_A_DE_in),      .q(shift_A_DE_out));
   dff_freeze B_to_zero_Flop            (.clk(clk), .rst(rst), .freeze(freeze), .d(B_to_zero_DE_in),    .q(B_to_zero_DE_out));
   dff_freeze c_in_Flop                 (.clk(clk), .rst(rst), .freeze(freeze), .d(c_in_DE_in),         .q(c_in_DE_out));
   dff_freeze sign_Flop                 (.clk(clk), .rst(rst), .freeze(freeze), .d(sign_DE_in),         .q(sign_DE_out));
   dff_freeze mem_write_en_Flop         (.clk(clk), .rst(rst), .freeze(freeze), .d(mem_write_en_DE_in), .q(mem_write_en_DE_out_before_freeze));
   dff_freeze ALU_jmp_src_Flop          (.clk(clk), .rst(rst), .freeze(freeze), .d(ALU_jmp_src_DE_in),  .q(ALU_jmp_src_DE_out));
   dff_freeze mem_enable_Flop           (.clk(clk), .rst(rst), .freeze(freeze), .d(mem_enable_DE_in),   .q(mem_enable_DE_out));
   dff_freeze less_than_Flop            (.clk(clk), .rst(rst), .freeze(freeze), .d(less_than_DE_in),    .q(less_than_DE_out));
   dff_freeze equal_to_Flop             (.clk(clk), .rst(rst), .freeze(freeze), .d(equal_to_DE_in),     .q(equal_to_DE_out));
   dff_freeze set_CO_Flop               (.clk(clk), .rst(rst), .freeze(freeze), .d(set_CO_DE_in),       .q(set_CO_DE_out));
   dff_freeze reg_write_en              (.clk(clk), .rst(rst), .freeze(freeze), .d(reg_write_en_DE_in), .q(reg_write_en_DE_out_before_freeze));




   assign mem_write_en_DE_out = freeze ? 1'b0 : mem_write_en_DE_out_before_freeze;
   assign reg_write_en_DE_out = freeze ? 1'b0 : reg_write_en_DE_out_before_freeze;

endmodule
`default_nettype wire