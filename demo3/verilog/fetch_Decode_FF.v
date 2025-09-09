`default_nettype none
module fetch_Decode_FF (
   // Basic inputs
   input wire clk,
   input wire global_rst,
   input wire local_clr,
   input wire freeze,  // Freeze signal

   // Flop inputs
   input wire [15:0] instr_FD_in, 
   input wire [15:0] inc_PC_FD_in,

   // Outputs
   output wire [15:0] instr_FD_out, 
   output wire [15:0] inc_PC_FD_out
);
   wire rst;
   assign rst = global_rst | local_clr;

   /*********************************************************
   **                     instr Flop                       **
   *********************************************************/
   // Instantiate 16 dff_freeze flip-flops for instruction
   dff_freeze instr_Flops[15:0] (
      // Inputs
      .clk(clk),
      .rst(rst),
      .freeze(freeze),  // Freeze signal connected here
      .d(instr_FD_in),
      // Outputs
      .q(instr_FD_out)
   );

   /*********************************************************
   **                     inc_PC Flop                      **
   *********************************************************/
   // Instantiate 16 dff_freeze flip-flops for incremented PC
   dff_freeze inc_PC_Flops[15:0] (
      // Inputs
      .clk(clk),
      .rst(rst),
      .freeze(freeze),  // Freeze signal connected here
      .d(inc_PC_FD_in),
      // Outputs
      .q(inc_PC_FD_out)
   );

endmodule
`default_nettype wire