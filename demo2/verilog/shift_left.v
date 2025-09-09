`default_nettype none

module shift_left
(
    input wire [15:0] in,
    input wire [3:0] shift_amnt,
    output wire [15:0] out
);

    /*********************************************************
    **                   Shift Rows                         **
    **********************************************************/
    wire [15:0] shift_row [0:2];


    /*********************************************************
    **                   Shift Logic                        **
    **********************************************************/

    // Shift by 1
    assign shift_row[0] = (shift_amnt[0]) ? {in[14:0], 1'h0} : in;
    
    // Shift by 2
    assign shift_row[1] = (shift_amnt[1]) ? {shift_row[0][13:0], 2'h0} : shift_row[0];
    
    // Shift by 4
    assign shift_row[2] = (shift_amnt[2]) ? {shift_row[1][11:0], 4'h0} : shift_row[1];
    
    // Shift by 8
    assign out = (shift_amnt[3]) ? {shift_row[2][7:0], 8'h00} : shift_row[2];  


endmodule
`default_nettype wire
