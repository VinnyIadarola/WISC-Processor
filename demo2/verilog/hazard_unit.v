/*********************************************************
**                    Hazard Unit                       **
*********************************************************/

 `include "hazard_unit_config.v"
 `default_nettype none
 
module hazard_unit (
   //Inputs
   input wire [15:0] instruction_ID,
   input wire [2:0]  write_reg_sel_EX,
   input wire [2:0]  write_reg_sel_MEM,
   input wire        PC_src_EX,
   input wire        ALU_jmp_EX,
   input wire        PC_src_MEM,
   input wire        ALU_jmp_MEM,

   //Outputs
   output wire       hazard_detected,
   output wire       branch_hazard,
   output wire       raw_hazard,
   output reg       JR_sig
);

   reg [2:0] source_reg;
   reg [2:0] target_reg;
   reg R_type_opcode;
   reg J_type_opcode;
   reg potential_hazard;

   wire source_reg_hazard;
   wire target_reg_hazard;
 

 
 

   /*********************************************************
   **               Check Incoming Operands                **        
   *********************************************************/
   always @(*) begin
      casex(instruction_ID[15:11])
         `ADDi, `SUBi, `XORi, `ANDNi, `ROLi, `SLLi, `RORi, `SRLi, `LD, `BTR, `SLBI: begin
               //Operands
               source_reg = instruction_ID[10:8];
               target_reg = 3'bXXX;

               // Type of Instruction
               potential_hazard = 1'b1;
               R_type_opcode = 1'b0;
               J_type_opcode = 1'b0;

               JR_sig = 1'b0;
         end

         `LOGICAL_R_INSTR, `SHIFT_R_INSTR, `ST, `STU, `SCO, `SEQ, `SLT, `SLE: begin
               //Operands
               source_reg = instruction_ID[10:8];
               target_reg = instruction_ID[7:5];

               // Type of Instruction
               potential_hazard = 1'b1;
               R_type_opcode = 1'b1;
               J_type_opcode = 1'b0;

               JR_sig = 1'b0;
         end


         `BEQZ, `BNEZ, `BLTZ, `BGEZ: begin
               //Operands
               source_reg = instruction_ID[10:8];
               target_reg = 3'bXXX;

               // Type of Instruction
               potential_hazard = 1'b1;
               R_type_opcode = 1'b0;
               J_type_opcode = 1'b1;
               JR_sig = 1'b0;
         end

        `JR, `JALR : begin                                                    // Just JAL need to be defined so that J type goes high?
               //Operands
               source_reg = instruction_ID[10:8];
               target_reg = 3'bXXX;

               // Type of Instruction
               potential_hazard = 1'b1;
               R_type_opcode = 1'b0;
               J_type_opcode = 1'b1;
               JR_sig = 1'b1;
         end

         `JAL, `J: begin                                                    // Just JAL need to be defined so that J type goes high?
               //Operands
               source_reg = 3'bXXX;
               target_reg = 3'bXXX;

               // Type of Instruction
               potential_hazard = 1'b0;
               R_type_opcode = 1'b0;
               J_type_opcode = 1'b1;
               JR_sig = 1'b0;
         end

         default: begin 
               //Operands
               source_reg = 3'bXXX;
               target_reg = 3'bXXX;

               // Type of Instruction
               potential_hazard = 1'b0;
               R_type_opcode = 1'bX;
               J_type_opcode = 1'b0;
               JR_sig = 1'b0;
         end
      endcase
   end



   /*********************************************************
   **Check Incoming Operands For Match With Further Down FF**        
   *********************************************************/
   assign source_reg_hazard = (source_reg === write_reg_sel_EX) | (source_reg === write_reg_sel_MEM);
   assign target_reg_hazard = R_type_opcode & ((target_reg === write_reg_sel_EX) | (target_reg === write_reg_sel_MEM));


   /*********************************************************
   **                    Setting Outputs                   **        
   *********************************************************/
   assign branch_hazard = J_type_opcode | PC_src_EX | PC_src_MEM | ALU_jmp_EX | ALU_jmp_MEM; //NO POTENTIAL HAZARD NEEDS TO GO HIGH WHEN BRANCH IS STILL MOVING THROUGH THE SYSTEM
   assign raw_hazard = potential_hazard & (source_reg_hazard | target_reg_hazard);
   assign hazard_detected = branch_hazard | raw_hazard;



endmodule

`default_nettype wire