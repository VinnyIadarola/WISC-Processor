`default_nettype none
module branch_control (

    input wire [2:0] branch,
    //Flags
    input wire  ZF,   // Signal if Out is 0
    input wire  CF,   // Signal if carry occurred
    input wire  SF,     // Signal if Out is negative
    input wire  OF,     // Signal if overflow occurred
    output reg PC_src, // Signal to select the next PC
    output reg err // Error signal
);




    always @(*) begin
        case(branch)
            3'b000: begin
                PC_src = 1'b0; // no branch
                err = 1'b0;
            end
            3'b001: begin
                PC_src = ZF; // equal
                err = 1'b0;
            end
            3'b010: begin
                PC_src = ~ZF; // not zero
                err = 1'b0;
            end
    
            3'b011: begin
                PC_src = SF; // less than
                err = 1'b0;
            end
            3'b100: begin 
                PC_src = ZF | ~SF; // greater than or eq
                err = 1'b0;
            end

            3'b111: begin
                PC_src = 1'b1; // unconditional
                err = 1'b0;
            end
            default begin 
                err = 1'b1;
                PC_src = 1'bx;
            end
        endcase
    end

endmodule
`default_nettype wire