module fetch_Decode_FF (
   //Basic inputs
   input wire clk,
   input wire rst,
   
   //Flop inputs
   input wire [15:0] instr_FD_in, 
   input wire [15:0] inc_PC_FD_in,

   //outputs
   output wire [15:0] instr_FD_out, 
   output wire [15:0] inc_PC_FD_out
);

   /*********************************************************
   **                     instr Flop                       **
   *********************************************************/
   // instantiate 16 D flip-flops for instruction
   dff instr_Flops[15:0] (
      // inputs
      .clk(clk),
      .rst(rst),
      .d(instr_FD_in),
      // outputs
      .q(instr_FD_out)
   );

   /*********************************************************
   **                     inc_PC Flop                      **
   *********************************************************/
   // instantiate 16 D flip-flops for incremented PC
   dff inc_PC_Flops[15:0] (
      // inputs
      .clk(clk),
      .rst(rst),
      .d(inc_PC_FD_in),
      // outputs
      .q(inc_PC_FD_out)
   );

endmodule