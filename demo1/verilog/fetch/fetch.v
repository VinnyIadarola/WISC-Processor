/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (
   
   //Basic Inputs
   input wire        clk,
   input wire        rst,

   //Inputs
   input wire [15:0] true_PC,

   //Outputs
   output wire [15:0] instr,
   output wire [15:0] inc_PC,
   output wire        err                          
);

   // From PC Reg to PC INC
   wire [15:0] curr_PC;


   /*********************************************************
   **                     PC Register                      **
   *********************************************************/  
   reg1 PCReg (
      //Basic Inputs
      .clk(clk), 
      .rst(rst), 
      
      //Hard Coded Inputs
      .writeEn(1'b1), 

      //Outputs
      .writeData(true_PC), 
      .regOut(curr_PC), 

      //Error
      .err(err)
   );


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
