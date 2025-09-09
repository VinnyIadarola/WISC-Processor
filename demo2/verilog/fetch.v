/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (
    // Basic Inputs
    input wire        clk,
    input wire        rst,

    // Data Inputs
    input wire  [15:0] hazard_PC,
    input wire  [15:0] disp_PC,
    input wire  [15:0] ALU_result,

    // Control Inputs
    input wire        hazard_detected,
    input wire        PC_src,
    input wire        ALU_jmp_src,
    input wire        branch_hazard,
    input wire        raw_hazard,
    input wire        JR_sig,

    // Outputs
    output wire [15:0] instr,
    output wire [15:0] curr_PC,
    output wire [15:0] inc_PC,
    output wire        err
);

   wire [15:0] next_PC;
   wire [15:0] to_next_PC;


   /*********************************************************
   **                     PC Register                      **
   *********************************************************/  
   reg1 PCReg (
      //Basic Inputs
      .clk(clk), 
      .rst(rst), 
      
      //Hard Coded Inputs
      .writeEn(1'b1), 

      //Input
      .writeData(next_PC),

      //Outputs 
      .regOut(curr_PC), 

      //Error
      .err(err)
   );

   /*********************************************************
   **                     PC Decider                      **
   *********************************************************/  
   assign next_PC = ((ALU_jmp_src) ? ALU_result :
                         (PC_src) ?    disp_PC :
                (hazard_detected) ?    curr_PC :    //curr PC vs Hazard here?? 
                                        inc_PC );

   
   //assign next_PC = to_next_PC[0] ? to_next_PC << 1 : to_next_PC;
   //assign next_PC = {to_next_PC[15:1], 1'b0};
   //assign next_PC = to_next_PC[0] ? (to_next_PC + 1'b1) : to_next_PC;





   /*********************************************************
   **                     PC Incrementer                   **
   *********************************************************/ 
   cla_16b addToPC (
      // Inputs
      .a(curr_PC), 
      .b(16'h0002), //Add 2 to the PC
      .c_in(1'b0), 

      // Outputs
      .sum(inc_PC), 
      .c_out()
   );


   /*********************************************************
   **                     INST Memory                      **
   *********************************************************/ 
   // Only need to be able to read here, memory2c loads the instr from a text file
   memory2c instrMEM (
      //Basic Inputs
      .clk(clk), 
      .rst(rst),

      //Hard Coded Inputs
      .enable(1'b1),
      .wr(1'b0), 
      .createdump(1'b0),
      .data_in(), 

      //Inputs
      .addr(curr_PC), 

      //Outputs
      .data_out(instr)
   );


endmodule
`default_nettype wire
