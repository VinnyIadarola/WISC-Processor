module Decode_Execute_FF (
   //Basic inputs
   input wire clk,
   input wire rst,
   input wire insert_NOP,
   
   //Flop inputs
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


   //outputs
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




// Wires for modified inputs
wire [15:0] inc_PC_DE_in_modified;
wire [15:0] imm_1_DE_in_modified;
wire [15:0] imm_2_DE_in_modified;
wire [15:0] disp_DE_in_modified;
wire [15:0] A_DE_in_modified;
wire [15:0] read_data_2_DE_in_modified;

wire [1:0] reg_src_DE_in_modified;
wire [2:0] branch_DE_in_modified;
wire [3:0] ALU_control_DE_in_modified;
wire [1:0] B_src_DE_in_modified;
wire [2:0] write_reg_sel_DE_in_modified;

wire dump_DE_in_modified;
wire imm_src_DE_in_modified;
wire inv_A_DE_in_modified;
wire inv_B_DE_in_modified;
wire shift_A_DE_in_modified;
wire B_to_zero_DE_in_modified;
wire c_in_DE_in_modified;
wire sign_DE_in_modified;
wire mem_write_en_DE_in_modified;
wire ALU_jmp_src_DE_in_modified;
wire mem_enable_DE_in_modified;
wire less_than_DE_in_modified;
wire equal_to_DE_in_modified;
wire set_CO_DE_in_modified;
wire reg_write_en_DE_in_modified;

// Assign modified inputs based on insert_NOP signal
assign inc_PC_DE_in_modified       = insert_NOP ? 16'b0 : inc_PC_DE_in;
assign imm_1_DE_in_modified        = insert_NOP ? 16'b0 : imm_1_DE_in;
assign imm_2_DE_in_modified        = insert_NOP ? 16'b0 : imm_2_DE_in;
assign disp_DE_in_modified         = insert_NOP ? 16'b0 : disp_DE_in;
assign A_DE_in_modified            = insert_NOP ? 16'b0 : A_DE_in;
assign read_data_2_DE_in_modified  = insert_NOP ? 16'b0 : read_data_2_DE_in;

assign reg_src_DE_in_modified      = insert_NOP ? 2'b0  : reg_src_DE_in;
assign branch_DE_in_modified       = insert_NOP ? 3'b0  : branch_DE_in;
assign ALU_control_DE_in_modified  = insert_NOP ? 4'b0  : ALU_control_DE_in;
assign B_src_DE_in_modified        = insert_NOP ? 2'b0  : B_src_DE_in;
assign write_reg_sel_DE_in_modified= insert_NOP ? 3'bXXX  : write_reg_sel_DE_in;

assign dump_DE_in_modified         = insert_NOP ? 1'b0 : dump_DE_in;
assign imm_src_DE_in_modified      = insert_NOP ? 1'b0 : imm_src_DE_in;
assign inv_A_DE_in_modified        = insert_NOP ? 1'b0 : inv_A_DE_in;
assign inv_B_DE_in_modified        = insert_NOP ? 1'b0 : inv_B_DE_in;
assign shift_A_DE_in_modified      = insert_NOP ? 1'b0 : shift_A_DE_in;
assign B_to_zero_DE_in_modified    = insert_NOP ? 1'b0 : B_to_zero_DE_in;
assign c_in_DE_in_modified         = insert_NOP ? 1'b0 : c_in_DE_in;
assign sign_DE_in_modified         = insert_NOP ? 1'b0 : sign_DE_in;
assign mem_write_en_DE_in_modified = insert_NOP ? 1'b0 : mem_write_en_DE_in;
assign ALU_jmp_src_DE_in_modified  = insert_NOP ? 1'b0 : ALU_jmp_src_DE_in;
assign mem_enable_DE_in_modified   = insert_NOP ? 1'b0 : mem_enable_DE_in;
assign less_than_DE_in_modified    = insert_NOP ? 1'b0 : less_than_DE_in;
assign equal_to_DE_in_modified     = insert_NOP ? 1'b0 : equal_to_DE_in;
assign set_CO_DE_in_modified       = insert_NOP ? 1'b0 : set_CO_DE_in;
assign reg_write_en_DE_in_modified = insert_NOP ? 1'b0 : reg_write_en_DE_in;

/*********************************************************
**                   16-bit Data Flops                  **
*********************************************************/
// PC and Data Path Flops
dff inc_PC_Flops[15:0]        (.clk(clk), .rst(rst), .d(inc_PC_DE_in_modified),      .q(inc_PC_DE_out));
dff imm_1_Flops[15:0]         (.clk(clk), .rst(rst), .d(imm_1_DE_in_modified),       .q(imm_1_DE_out));
dff imm_2_Flops[15:0]         (.clk(clk), .rst(rst), .d(imm_2_DE_in_modified),       .q(imm_2_DE_out));
dff disp_Flops[15:0]          (.clk(clk), .rst(rst), .d(disp_DE_in_modified),        .q(disp_DE_out));
dff A_Flops[15:0]             (.clk(clk), .rst(rst), .d(A_DE_in_modified),           .q(A_DE_out));
dff read_data_2_Flops[15:0]   (.clk(clk), .rst(rst), .d(read_data_2_DE_in_modified), .q(read_data_2_DE_out));

/*********************************************************
**                   Multi-bit Control Flops            **
*********************************************************/
// Control signals wider than 1 bit
dff reg_src_Flops[1:0]        (.clk(clk), .rst(rst), .d(reg_src_DE_in_modified),      .q(reg_src_DE_out));
dff branch_Flops[2:0]         (.clk(clk), .rst(rst), .d(branch_DE_in_modified),       .q(branch_DE_out));
dff ALU_control_Flops[3:0]    (.clk(clk), .rst(rst), .d(ALU_control_DE_in_modified),  .q(ALU_control_DE_out));
dff B_src_Flop[1:0]           (.clk(clk), .rst(rst), .d(B_src_DE_in_modified),        .q(B_src_DE_out));
dff write_reg_sel_Flops[2:0]  (.clk(clk), .rst(rst), .d(write_reg_sel_DE_in_modified),.q(write_reg_sel_DE_out));

/*********************************************************
**                   Single-bit Control Flops           **
*********************************************************/
// Single bit control signals
dff dump_Flop                 (.clk(clk), .rst(rst), .d(dump_DE_in_modified),         .q(dump_DE_out));
dff imm_src_Flop              (.clk(clk), .rst(rst), .d(imm_src_DE_in_modified),      .q(imm_src_DE_out));
dff inv_A_Flop                (.clk(clk), .rst(rst), .d(inv_A_DE_in_modified),        .q(inv_A_DE_out));
dff inv_B_Flop                (.clk(clk), .rst(rst), .d(inv_B_DE_in_modified),        .q(inv_B_DE_out));
dff shift_A_Flop              (.clk(clk), .rst(rst), .d(shift_A_DE_in_modified),      .q(shift_A_DE_out));
dff B_to_zero_Flop            (.clk(clk), .rst(rst), .d(B_to_zero_DE_in_modified),    .q(B_to_zero_DE_out));
dff c_in_Flop                 (.clk(clk), .rst(rst), .d(c_in_DE_in_modified),         .q(c_in_DE_out));
dff sign_Flop                 (.clk(clk), .rst(rst), .d(sign_DE_in_modified),         .q(sign_DE_out));
dff mem_write_en_Flop         (.clk(clk), .rst(rst), .d(mem_write_en_DE_in_modified), .q(mem_write_en_DE_out));
dff ALU_jmp_src_Flop          (.clk(clk), .rst(rst), .d(ALU_jmp_src_DE_in_modified),  .q(ALU_jmp_src_DE_out));
dff mem_enable_Flop           (.clk(clk), .rst(rst), .d(mem_enable_DE_in_modified),   .q(mem_enable_DE_out));
dff less_than_Flop            (.clk(clk), .rst(rst), .d(less_than_DE_in_modified),    .q(less_than_DE_out));
dff equal_to_Flop             (.clk(clk), .rst(rst), .d(equal_to_DE_in_modified),     .q(equal_to_DE_out));
dff set_CO_Flop               (.clk(clk), .rst(rst), .d(set_CO_DE_in_modified),       .q(set_CO_DE_out));
dff reg_write_en              (.clk(clk), .rst(rst), .d(reg_write_en_DE_in_modified), .q(reg_write_en_DE_out));
endmodule