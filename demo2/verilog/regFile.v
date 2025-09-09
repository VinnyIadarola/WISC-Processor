/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1
  
   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
`default_nettype none
module regFile #(
   parameter width = 16
)(
   //Basic Inputs
   input wire clk, 
   input wire rst,

   //Select signals
   input wire [2:0] read1RegSel, 
   input wire [2:0] read2RegSel,  
   input wire [2:0] writeRegSel,

   //Write data
   input wire writeEn, 
   input wire [width-1:0] writeData,

   //Outputs
   output wire [width-1:0] read1Data,
   output wire [width-1:0] read2Data,
   output wire err
);

   /*********************************************************
   **                Write Enable Selection                **
   **********************************************************/
   wire [15:0] vWriteEn;
   
   shift_left Shifter (
      //Inputs
      .in({15'h0000, writeEn}),         
      .shift_amnt({1'b0, writeRegSel}),   

      //Outputs
      //CHECK IF THIS IS ALLOWED
      .out(vWriteEn)     
   );


   /*********************************************************
   **                   8 Long Registers                   **
   **********************************************************/
   wire [width-1:0] regData [0:7];
   wire data_err;
   reg1 #(
      .width(width)
   ) register_system [7:0] (
      //Inputs
      .clk(clk),
      .rst(rst),
      .writeEn(vWriteEn[7:0]),
      .writeData(writeData),
      
      //Outputs
      .regOut({regData[7], regData[6], regData[5], regData[4], 
                  regData[3], regData[2], regData[1], regData[0]}),

      //Error
      .err(data_err)
   );


   /*********************************************************
   **                 Output Data Selection                **
   **********************************************************/
   regDataMux #(
      .width(width)
   ) output_selection (
      //Inputs
      .regData({regData[7], regData[6], regData[5], regData[4], 
                  regData[3], regData[2], regData[1], regData[0]}),        
      .read1RegSel(read1RegSel), 
      .read2RegSel(read2RegSel),

      //Outputs
      .out1Data(read1Data),    
      .out2Data(read2Data)
   );


   /*********************************************************
   **                  Error Detection Sum                 **
   **********************************************************/
 
   assign err = data_err | (read1RegSel === 3'bxxx) 
               | (read1RegSel === 3'bxxx) | (read1RegSel === 3'bxxx);



endmodule
`default_nettype wire