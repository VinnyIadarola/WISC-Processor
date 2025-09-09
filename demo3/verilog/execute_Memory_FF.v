`default_nettype none
module execute_Memory_FF (
   // Basic inputs
   input wire clk,
   input wire global_rst,
   input wire local_clr,
   input wire freeze, // Freeze signal

   // Flop inputs
   input wire [15:0] inc_PC_EM_in,
   input wire [15:0] imm_2_EM_in,
   input wire dump_EM_in,
   input wire mem_write_en_EM_in,
   input wire [1:0] reg_src_EM_in,
   input wire mem_enable_EM_in,
   input wire [15:0] read_data_2_EM_in,
   input wire [15:0] ALU_result_EM_in,
   input wire reg_write_en_EM_in,
   input wire [2:0] write_reg_sel_EM_in,

   // Outputs
   output wire [15:0] inc_PC_EM_out,
   output wire [15:0] imm_2_EM_out,
   output wire dump_EM_out,
   output wire mem_write_en_EM_out,
   output wire [1:0] reg_src_EM_out,
   output wire mem_enable_EM_out,
   output wire [15:0] read_data_2_EM_out,
   output wire [15:0] ALU_result_EM_out,
   output wire reg_write_en_EM_out,
   output wire [2:0] write_reg_sel_EM_out
);

   wire rst;
   assign rst = global_rst | local_clr;

   // 16-bit Data Flops
   dff_freeze inc_PC_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(inc_PC_EM_in), .q(inc_PC_EM_out));
   dff_freeze imm_2_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(imm_2_EM_in), .q(imm_2_EM_out));
   dff_freeze read_data_2_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(read_data_2_EM_in), .q(read_data_2_EM_out));
   dff_freeze ALU_result_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(ALU_result_EM_in), .q(ALU_result_EM_out));

   // Multi-bit Control Flops
   dff_freeze reg_src_Flops[1:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(reg_src_EM_in), .q(reg_src_EM_out));
   dff_freeze write_reg_sel_Flops[2:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(write_reg_sel_EM_in), .q(write_reg_sel_EM_out));

   // Single-bit Control Flops
   dff_freeze dump_Flop (.clk(clk), .rst(rst), .freeze(freeze), .d(dump_EM_in), .q(dump_EM_out));
   dff_freeze mem_write_en_Flop (.clk(clk), .rst(rst), .freeze(freeze), .d(mem_write_en_EM_in), .q(mem_write_en_EM_out));
   dff_freeze mem_enable_Flop (.clk(clk), .rst(rst), .freeze(freeze), .d(mem_enable_EM_in), .q(mem_enable_EM_out));
   dff_freeze reg_write_en_Flop (.clk(clk), .rst(rst), .freeze(freeze), .d(reg_write_en_EM_in), .q(reg_write_en_EM_out));

endmodule
`default_nettype wire