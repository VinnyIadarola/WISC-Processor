/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (
   //Basic Inputs
   input wire           clk,
   input wire           rst,

   //Data Inputs
   input wire [15:0]    write_data,
   input wire [15:0]    addr,

   //Control Inputs
   input wire           mem_enable,
   input wire           mem_write,
   input wire           dump,


   //Data Outputs
   output wire [15:0]   read_data
);


   /*********************************************************
   **                     Data Memory                      **
   *********************************************************/ 
   memory2c dataMEM (
      //Basic Inputs
      .clk(clk), 
      .rst(rst),

      //Data Inputs
      .data_in(write_data), 
      .addr(addr), 

      //Control Inputs
      .enable(mem_enable), 
      .createdump(dump),
      .wr(mem_write), 

      //Data outputs
      .data_out(read_data)
);
   
endmodule
`default_nettype wire
