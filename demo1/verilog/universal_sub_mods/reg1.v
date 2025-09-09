`default_nettype none
module reg1 #(
   parameter width = 16
)(
   //Basic Inputs
   input wire clk, 
   input wire rst,

   //Data Inputs
   input wire writeEn, 
   input wire [width-1:0] writeData,

   //Outputs
   output wire [width-1:0] regOut,
   output wire err
);


    /*********************************************************
    **               Selecting New Reg Data                 **
    **********************************************************/
    wire [width-1 :0] regIn;
    assign regIn = (writeEn) ? writeData : regOut;

    /*********************************************************
    **                   Flip Flop Instant                  **
    **********************************************************/
    dff reg1 [width-1:0] (
        //Inputs
        .clk(clk),
        .rst(rst),
        .d(regIn),

        //Outputs
        .q(regOut)
    );


    /*********************************************************
    **                    Reg Error Detect                  **
    **********************************************************/
    wire err_writeEn, err_writeData;
    assign err_writeEn = (writeEn === 1'bx);
    assign err_writeData = (writeData === {width{1'bx}});
    assign err = err_writeEn | err_writeData;


endmodule
`default_nettype wire