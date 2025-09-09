`default_nettype none
module memory_WriteBack_FF (
   // Basic inputs
   input wire clk,
   input wire global_rst,
   input wire local_clr,
   input wire freeze,

   // Flop inputs
   input wire [15:0] inc_PC_MWB_in,
   input wire [15:0] imm_2_MWB_in,
   input wire [1:0] reg_src_MWB_in,
   input wire [15:0] ALU_result_MWB_in,
   input wire [15:0] read_data_MWB_in,
   input wire reg_write_en_MWB_in,
   input wire [2:0] write_reg_sel_MWB_in,

   // Outputs
   output wire [15:0] inc_PC_MWB_out,
   output wire [15:0] imm_2_MWB_out,
   output wire [1:0] reg_src_MWB_out,
   output wire [15:0] ALU_result_MWB_out,
   output wire [15:0] read_data_MWB_out,
   output wire reg_write_en_MWB_out,
   output wire [2:0] write_reg_sel_MWB_out
);
   wire rst;
   assign rst = global_rst | local_clr;

   // 16-bit Data Flops
   dff_freeze inc_PC_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(inc_PC_MWB_in), .q(inc_PC_MWB_out));
   dff_freeze imm_2_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(imm_2_MWB_in), .q(imm_2_MWB_out));
   dff_freeze ALU_result_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(ALU_result_MWB_in), .q(ALU_result_MWB_out));
   dff_freeze read_data_Flops[15:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(read_data_MWB_in), .q(read_data_MWB_out));

   // Multi-bit Control Flops
   dff_freeze reg_src_Flops[1:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(reg_src_MWB_in), .q(reg_src_MWB_out));
   dff_freeze write_reg_sel_Flops[2:0] (.clk(clk), .rst(rst), .freeze(freeze), .d(write_reg_sel_MWB_in), .q(write_reg_sel_MWB_out));

   // Single-bit Control Flops
   dff_freeze reg_write_en_Flop (.clk(clk), .rst(rst), .freeze(freeze), .d(reg_write_en_MWB_in), .q(reg_write_en_MWB_out));

endmodule
`default_nettype wire