`default_nettype none

module rot_left
(
    input wire [15:0] in,
    input wire [3:0] shift_amnt,
    output wire [15:0] out
);

    /*********************************************************
    **                   Shift Rows                         **
    **********************************************************/
    wire [15:0] rotate_row [0:2];
    
    /*********************************************************
    **                   Shift Logic                        **
    **********************************************************/
    assign rotate_row[0] = (shift_amnt[0]) ? {in[14:0], in[15]} : in;
    assign rotate_row[1] = (shift_amnt[1]) ? {rotate_row[0][13:0], rotate_row[0][15:14]} : rotate_row[0];
    assign rotate_row[2] = (shift_amnt[2]) ? {rotate_row[1][11:0], rotate_row[1][15:12]} : rotate_row[1];
    assign out = (shift_amnt[3]) ? {rotate_row[2][7:0], rotate_row[2][15:8]} : rotate_row[2];



endmodule
`default_nettype wire
