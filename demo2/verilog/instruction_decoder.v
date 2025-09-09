/*
  
   Filename        : instruction_decoder.v
   Description     : WAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
*/
`default_nettype none
`include "instruction_decoder_config.v"
module instruction_decoder (
    //Input
    input wire [4:0] opcode,

    //Source Control Outputs
    output reg imm_src,
    output reg ZExt_src,
    output reg ALU_jmp_src,
    output reg [1:0] B_src,
    output reg [1:0] reg_src,
    output reg [1:0] reg_write_dst,
 
    //Enable Outputs
    output reg reg_write_en,
    output reg mem_write_en,
    output reg mem_enable,


    //Complex Control Outputs
    output reg dump,
    output reg [4:0] ALU_op,
    output reg [2:0] branch,
    
    //Error Signal
    output reg    err
);



    always @(*) begin
        casex(opcode) 
            /*********************************************************
            **                     One-Off Opcodes                  **
            *********************************************************/
            `HALT: begin
                //Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b00;
                reg_write_dst = 2'b00;

                //Enable Controls
                reg_write_en  = 1'b0;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                //Complex Controls
                dump          = 1'b1;
                ALU_op        = 5'b00000;
                branch        = 3'b000;


                //Error 
                err           = 1'b0;
            end

            `NOP: begin
                //Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b00;
                reg_write_dst = 2'b00;

                //Enable Controls
                reg_write_en  = 1'b0;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                //Complex Controls
                dump          = 1'b0;
                ALU_op        = 5'b00000;
                branch        = 3'b000;
            end

            `SIIC_ILLEGAL_OP: begin
                // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b00;
                reg_write_dst = 2'b00;

                // Enable Controls
                reg_write_en  = 1'b0;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump          = 1'b0;
                ALU_op        = 5'b00000;
                branch        = 3'b000;

                // Error Signal
                err           = 1'b0;
            end

            `SIIC_PC_EPC: begin
                // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b00;
                reg_write_dst = 2'b00;

                // Enable Controls
                reg_write_en  = 1'b0;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump          = 1'b0;
                ALU_op        = 5'b0000;
                branch        = 3'b000;

                // Error Signal
                err           = 1'b0;  
            end

            
            /*********************************************************
            **                 Function Code Opcodes                **
            *********************************************************/
            `LOGICAL_R_INSTR: begin
                // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b10;
                reg_write_dst = 2'b10;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = 5'b00000;
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end

  
            `SHIFT_R_INSTR: begin
                // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b10;
                reg_write_dst = 2'b10;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = 5'b00001; 
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end

            /*********************************************************
            **                  I-Type Logical Opcodes              **
            *********************************************************/
            `ADDi, `SUBi, `XORi, `ANDNi: begin
                // Mux Selection Controls
                B_src         = 2'b01;
                imm_src       = 1'b0;
                ZExt_src      = (opcode == `XORi | opcode == `ANDNi);
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b10;
                reg_write_dst = 2'b00;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = (opcode == `ADDi)  ? 5'b00111 :
                            (opcode == `SUBi)  ? 5'b01000 :
                            (opcode == `XORi)  ? 5'b01001 :
                           /*opcode == `ANDNi*/  5'b01010 ;
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end



            /*********************************************************
            **                   I-Type Shift Opcodes               **
            *********************************************************/
             `ROLi, `RORi, `SLLi, `SRLi: begin
                // Mux Selection Controls
                B_src         = 2'b01;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b10;
                reg_write_dst = 2'b00;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = (opcode == `ROLi) ? 5'b01011 :
                            (opcode == `RORi) ? 5'b01101 :
                            (opcode == `SLLi) ? 5'b01100 :
                           /*opcode == `SRLi*/  5'b01110 ;
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end

            /*********************************************************
            **                 Comparison Type Opcodes              **
            *********************************************************/
            `SEQ, `SLT, `SLE, `SCO: begin
                // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b10;
                reg_write_dst = 2'b10;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = (opcode == `SEQ) ? 5'b00010 :
                            (opcode == `SLT) ? 5'b00011 :
                            (opcode == `SLE) ? 5'b00100 :
                           /*opcode == `SCO*/  5'b00101 ; 
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end


        
           
            
            /*********************************************************
            **                     Memory Opcodes                   **
            *********************************************************/
            `ST, `LD, `STU: begin
                // Mux Selection Controls
                B_src         = 2'b01;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = (opcode == `LD)  ? 2'b01 :
                                (opcode == `STU) ? 2'b10 :
                               /*opcode == `ST*/   2'b00 ;

                 reg_write_dst = (opcode == `LD) ? 2'b00 :
                                (opcode == `STU) ? 2'b01 :
                               /*opcode == `ST*/   2'b00 ;

                // Enable Controls
                reg_write_en  = (opcode == `LD | opcode == `STU);
                mem_write_en  = (opcode == `ST | opcode == `STU);
                mem_enable    = 1'b1;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = 5'b00111;
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end


            /*********************************************************
            **                    Load Reg Opcodes                  **
            *********************************************************/
            `LBI, `SLBI: begin
                // Mux Selection Controls
                B_src         = (opcode == `LBI) ? 2'b00 : 2'b10;
                imm_src       = 1'b0;
                ZExt_src      = (opcode == `SLBI);
                ALU_jmp_src   = 1'b0;
                reg_src       = (opcode == `LBI) ? 2'b11 : 2'b10;
                reg_write_dst = 2'b01;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = (opcode == `LBI)  ? 5'b00000 : //make blank statement?
                            /*opcode == `SLBI*/ 5'b01111 ; 
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end

            `BTR: begin
               // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b10;
                reg_write_dst = 2'b10;

                // Enable Controls
                reg_write_en  = 1'b1;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = 5'b00110;
                branch    = 3'b000;

                // Error Signal
                err       = 1'b0;
            end

            

            /*********************************************************
            **                      Branch Opcodes                  **
            *********************************************************/
            `BEQZ, `BNEZ, `BLTZ, `BGEZ: begin
                // Mux Selection Controls
                B_src         = 2'b00;
                imm_src       = 1'b1;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = 1'b0;
                reg_src       = 2'b00;
                reg_write_dst = 2'b00;

                // Enable Controls
                reg_write_en  = 1'b0;
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = 5'b10000;
                branch    = (opcode == `BEQZ) ? 3'b001 :
                            (opcode == `BNEZ) ? 3'b010 :
                            (opcode == `BLTZ) ? 3'b011 :
                           /*opcode == `BGEZ*/  3'b100 ;

                // Error Signal
                err       = 1'b0;
            end

             /*********************************************************
            **                       Jump Opcodes                   **
            *********************************************************/
            `J, `JR, `JAL, `JALR: begin
                // Mux Selection Controls
                B_src         = (opcode == `JALR | opcode == `JR) ? 2'b10 : 2'b00;
                imm_src       = 1'b0;
                ZExt_src      = 1'b0;
                ALU_jmp_src   = (opcode == `JR | opcode == `JALR);
                reg_src       = 2'b00;
                reg_write_dst = (opcode == `JAL | opcode == `JALR) ? 2'b11 : 2'b00;

                // Enable Controls
                reg_write_en  = (opcode == `JAL | opcode == `JALR);
                mem_write_en  = 1'b0;
                mem_enable    = 1'b0;

                // Complex Controls
                dump      = 1'b0;
                ALU_op    = (opcode == `J | opcode == `JAL) ? 5'b00000 : 5'b00111;
                branch    = (opcode == `J | opcode == `JAL) ? 3'b111 : 3'b000;

                // Error Signal
                err       = 1'b0;
                end

            

            default: begin
                // Mux Selection Controls
                B_src         = 2'bxx;
                imm_src       = 1'bx;
                ZExt_src      = 1'bx;
                ALU_jmp_src   = 1'bx;
                reg_src       = 2'bxx;
                reg_write_dst = 2'bxx;

                // Enable Controls
                reg_write_en  = 1'bx;
                mem_write_en  = 1'bx;
                mem_enable    = 1'bx;

                // Complex Controls
                dump      = 1'bx;
                ALU_op    = 5'bXXXXX;
                branch    = 3'bxxx;

                // Error Signal
                err       = 1'b1; 
            end
        endcase
    end
endmodule
`default_nettype wire