`default_nettype none
`include "regDataMux_config.v"
module regDataMux #(
    parameter width = 16
)(
    // Inputs
    input wire [width*8-1:0] regData,    // Packed array in the port declaration
    input wire [2:0] read1RegSel, 
    input wire [2:0] read2RegSel,

    // Outputs
    output reg [width-1:0] out1Data,
    output reg [width-1:0] out2Data
);


    /*********************************************************
    **                     Read 1 Selection                 **
    *********************************************************/
    always @(read1RegSel or out1Data or regData) begin
        case (read1RegSel)
            `REG0_SELECT: out1Data = regData[width*1-1:width*0];
            `REG1_SELECT: out1Data = regData[width*2-1:width*1];
            `REG2_SELECT: out1Data = regData[width*3-1:width*2];
            `REG3_SELECT: out1Data = regData[width*4-1:width*3];
            `REG4_SELECT: out1Data = regData[width*5-1:width*4];
            `REG5_SELECT: out1Data = regData[width*6-1:width*5];
            `REG6_SELECT: out1Data = regData[width*7-1:width*6];
            `REG7_SELECT: out1Data = regData[width*8-1:width*7];
            default: out1Data = {width{1'bx}}; 
        endcase
    end


    /*********************************************************
    **                     Read 2 Selection                 **
    *********************************************************/
    always @(read2RegSel or out2Data or regData) begin
        case (read2RegSel)
            `REG0_SELECT: out2Data = regData[width*1-1:width*0];
            `REG1_SELECT: out2Data = regData[width*2-1:width*1];
            `REG2_SELECT: out2Data = regData[width*3-1:width*2];
            `REG3_SELECT: out2Data = regData[width*4-1:width*3];
            `REG4_SELECT: out2Data = regData[width*5-1:width*4];
            `REG5_SELECT: out2Data = regData[width*6-1:width*5];
            `REG6_SELECT: out2Data = regData[width*7-1:width*6];
            `REG7_SELECT: out2Data = regData[width*8-1:width*7];
            default: out2Data = {width{1'bx}}; 
        endcase
    end



endmodule
`default_nettype wire