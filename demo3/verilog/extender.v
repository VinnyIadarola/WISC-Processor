/*
  
   Filename        : extender.v
   Description     : Uses the first 12 bits of the instruction and extends them according
                        to the instruction type to produce the immediate values and the 
                        displacement
*/
`default_nettype none
module extender (
    //Inputs
    input wire [15:0] instr,
    input wire ZExt_src,

    //Immediate Value Outputs
    output wire [15:0] imm_1,
    output wire [15:0] imm_2,
    output wire [15:0] disp
);

    /*********************************************************
    **                   Immediate Value 1                  **
    *********************************************************/
    assign imm_1 = (ZExt_src) ? {11'h000, instr[4:0]} : {{11{instr[4]}}, instr[4:0]};
    
    
    /*********************************************************
    **                   Immediate Value 2                  **
    *********************************************************/
    assign imm_2 = (ZExt_src) ? {8'h00, instr[7:0]} : {{8{instr[7]}}, instr[7:0]};


    /*********************************************************
    **                   Immediate Value 2                  **
    *********************************************************/
    assign disp = {{5{instr[10]}}, instr[10:0]};




endmodule
`default_nettype wire