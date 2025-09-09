/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (

   input wire [15:0]   inc_PC,
   input wire [15:0]   read_data,
   input wire [15:0]   ALU_result,
   input wire [15:0]   imm_2,
   input wire [1:0]    reg_src,

   output reg [15:0]  write_data,
   output reg err
);

   

   /*********************************************************
   **                  Write Back Mux                      **
   *********************************************************/
   always @ (*) begin
      case(reg_src)
         2'b00 : begin
            write_data = inc_PC;
            err = 1'b0;
         end

         2'b01 : begin
            write_data = read_data;
            err = 1'b0;
         end

         2'b10 : begin
            write_data = ALU_result;
            err = 1'b0;
         end

         2'b11 : begin
            write_data = imm_2;
            err = 1'b0;
         end
         
         default : begin
            write_data = 16'hXXXX;
            err = 1'b1;
         end 
      endcase
   end


endmodule
`default_nettype wire
