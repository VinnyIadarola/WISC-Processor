/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
`default_nettype none
module regFile_bypass # (
   //remove this probably
   parameter width = 16
)(
   //Basic Inputs
   input wire clk,
   input wire rst,

   //Selection Inputs
   input wire [2:0] read1RegSel,
   input wire [2:0] read2RegSel,
   input wire [2:0] writeRegSel,

   //Write Data
   input wire             writeEn,
   input wire [width-1:0] writeData,
   
   //General Outputs
   output wire [width-1:0] read1Data,
   output wire [width-1:0] read2Data,
   output wire             err
);





   /*********************************************************
   **                    Register System                   **
   *********************************************************/
   wire [width-1:0] stored_read1Data, stored_read2Data;
   regFile #(
      .width(width)
   ) Register_System (
      //Inputs
      .clk(clk), 
      .rst(rst),
      .read1RegSel(read1RegSel), 
      .read2RegSel(read2RegSel),  
      .writeRegSel(writeRegSel),
      .writeEn(writeEn), 
      .writeData(writeData),

      //Outputs
      .read1Data(stored_read1Data),
      .read2Data(stored_read2Data),
      .err(err)
   );

   /*********************************************************
   **                   Data Bypass System                 **
   *********************************************************/
   assign read1Data = (writeEn & (read1RegSel == writeRegSel)) 
                                ? writeData : stored_read1Data;
   assign read2Data = (writeEn & (read2RegSel == writeRegSel)) 
                                ? writeData : stored_read2Data;




endmodule
`default_nettype wire
