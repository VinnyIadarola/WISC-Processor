module dff_freeze (
    output wire q,
    input wire d,
    input wire clk,
    input wire rst,
    input wire freeze
);

    wire real_d;

    // Logic to control the frozen state
    assign real_d = freeze ? q : d;

    // Instantiate a single D flip-flop
    dff freeze_ff (
        .clk(clk),
        .rst(rst),
        .d(real_d),
        .q(q)
    );

endmodule
