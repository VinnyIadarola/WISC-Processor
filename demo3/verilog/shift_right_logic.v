`default_nettype none

module shift_right_logic
(
    input wire [15:0] in,
    input wire [3:0] shift_amnt,
    output wire [15:0] out
);

    /*********************************************************
    **                     Shift Rows                       **
    **********************************************************/
    wire [15:0] shift_row [0:2];


    /*********************************************************
    **                     Shift Logic                      **
    **********************************************************/
    assign shift_row[0] = (shift_amnt[0]) ? {1'h0, in[15:1]} : in;
    assign shift_row[1] = (shift_amnt[1]) ? {2'h0, shift_row[0][15:2]} : shift_row[0];
    assign shift_row[2] = (shift_amnt[2]) ? {4'h0, shift_row[1][15:4]} : shift_row[1];
    assign out = (shift_amnt[3]) ? {8'h00, shift_row[2][15:8]} : shift_row[2];



endmodule
`default_nettype wire
