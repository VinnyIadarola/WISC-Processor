/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */  

//I made a flop table on the google doc 

/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output wire err;

   // None of the above lines can be modified

    /*********************************************************
    **                     Wire instants                    **
    *********************************************************/
    /*  EXPLANATION OF THE WIRE ARRAY
        signal_name[x][y] 

        Stage Select
        [0][y] = Fetch/Decode
        [1][y] = Decode/Execute
        [2][y] = Execute/Memory
        [3][y] = Memory/WriteBack

        Input/Output Select
        [x][0] = Input to the stage
        [x][1] = Output to the stage
    */
    // errs
    wire fetch_err, decode_err, exec_err, wb_err;
    wire held_rst;
    

    // Hazard Unit
    wire hazard_detected;
    wire branch_hazard;
    wire raw_hazard;

    // Not Flopped
    wire [15:0] write_data;


    wire [15:0] instr[0:3][0:1];
    wire [15:0] inc_PC[0:3][0:1];
    wire [15:0] imm_1[0:3][0:1];
    wire [15:0] imm_2[0:3][0:1];
    wire [15:0] disp[0:3][0:1];
    wire        dump[0:3][0:1];
    wire        imm_src[0:3][0:1];
    wire        inv_A[0:3][0:1];
    wire        inv_B[0:3][0:1];
    wire        shift_A[0:3][0:1];
    wire        B_to_zero[0:3][0:1];
    wire        c_in[0:3][0:1];
    wire        sign[0:3][0:1];
    wire        mem_write_en[0:3][0:1];
    wire        ALU_jmp_src[0:3][0:1];
    wire [1:0]  reg_src[0:3][0:1];
    wire [1:0]  B_src[0:3][0:1];
    wire [2:0]  branch[0:3][0:1];
    wire [3:0]  ALU_control[0:3][0:1];
    wire        mem_enable[0:3][0:1];
    wire        less_than[0:3][0:1];
    wire        equal_to[0:3][0:1];
    wire        set_CO[0:3][0:1];
    wire [15:0] A[0:3][0:1];
    wire [15:0] read_data_2[0:3][0:1];
    wire [2:0]  write_reg_sel[0:3][0:1];
    wire        reg_write_en[0:3][0:1];
    wire [15:0] ALU_result[0:3][0:1];
    wire [15:0] read_data[0:3][0:1];
    wire [15:0] disp_PC[0:3][0:1];
    wire [15:0] hazard_PC[0:3][0:1];


    wire        PC_src[0:3][0:1];
    wire        true_dump;
    wire        JR_sig;



    // New Phase 3 Signals 
    wire        freeze[0:3][0:1];
    wire        local_clr[0:3][0:1];


      

    /*********************************************************
    **                    Hazard Unit                       **
    *********************************************************/
    hazard_unit hazard_unit(
        //Inputs
        .instruction_ID(instr[0][1]),
        
        .PC_src_EX(PC_src[2][0]),
        .PC_src_MEM(PC_src[2][1]),
        .ALU_jmp_EX(ALU_jmp_src[2][0]),
        .ALU_jmp_MEM(ALU_jmp_src[2][1]),
        .write_reg_sel_EX(write_reg_sel[1][1]),
        .write_reg_sel_MEM(write_reg_sel[2][1]),

        //Outputs
        .hazard_detected(hazard_detected),
        .branch_hazard(branch_hazard),
        .raw_hazard(raw_hazard),
        .JR_sig(JR_sig)
    );

    assign freeze[0][0] = hazard_detected;
    assign freeze[1][0] = branch_hazard;
    assign freeze[2][0] = 1'b0;
    assign freeze[3][0] = 1'b0;

    assign local_clr[0][0] = 1'b0;
    assign local_clr[1][0] = 1'b0;
    assign local_clr[2][0] = 1'b0;
    assign local_clr[3][0] = 1'b0;


    /*********************************************************
    **                          Fetch                       **
    *********************************************************/

    wire [15:0] curr_PC;
    fetch fetch (
        //Basic Inputs  
        .clk(clk), 
        .rst(rst), 

        //Data Inputs 
        .disp_PC(disp_PC[2][1]),
        .ALU_result(ALU_result[2][1]),

        //Control Inputs
        .hazard_detected(hazard_detected),
        .PC_src(PC_src[2][1]),
        .ALU_jmp_src(ALU_jmp_src[2][1]),
        .branch_hazard(branch_hazard),
        .raw_hazard(raw_hazard),

        //Outputs
        .curr_PC(curr_PC),
        .instr(instr[0][0]), 
        .inc_PC(inc_PC[0][0]), 
        .err(fetch_err)
    );

    
    // *****Commented out for phase 3 there should be no more looping of instructions we freeze now
    ////If hazard is detected then instruction will cycle back if raw_hazard or will be a NOP if branch_hazard
    //assign instr[0][0] = (raw_hazard) ? instr[0][1] : 
    //                  (branch_hazard) ?    16'h0800 : 
    //                                    instr_fetch ;
    


    
    // *****Commented out for phase 3 there should be no more looping of PC we freeeeeeze now
    //If hazard is detected then inc_PC will cycle back if raw_hazard or will be a NOP if branch_hazard
    //assign inc_PC[0][0] = (raw_hazard) ? curr_PC : 
    //                   (branch_hazard) ? curr_PC : //was fresh before 
     //                                    fresh_inc_PC ;

    


    /*********************************************************
    **                  Fetch / Decode FF                   **
    *********************************************************/
    fetch_Decode_FF fetch_DEcode_FF (
        //Basic Inputs
        .clk(clk),
        .global_rst(rst),
        .local_clr(local_clr[0][0]),
        .freeze(freeze[0][0]),

        //Flop Inputs
        .instr_FD_in(instr[0][0]), 
        .inc_PC_FD_in(inc_PC[0][0]),

        //Outputsg
        .instr_FD_out(instr[0][1]), 
        .inc_PC_FD_out(inc_PC[0][1])
    );

    
    
    // *****Commented out for phase 3 there should be no more looping of PC we freeeeeeze now
    //assign hazard_PC[0][0] = curr_PC;
    //
    //dff hazard_FF [15:0] (
    //    .clk(clk), 
    //    .rst(rst),
    //    .d(hazard_PC[0][0]), 
    //    .q(hazard_PC[0][1])
    //);



   /*********************************************************
   **                         Decode                       **
   *********************************************************/
    decode decode (
        //Inputs 
        .clk(clk),
        .rst(rst),
        .instr(instr[0][1]), 
        .write_data(write_data),
        .write_reg_sel_in(write_reg_sel[3][1]),
        .reg_write_en_in(reg_write_en[3][1]),

        //Immediate Value Outputs
        .imm_1(imm_1[1][0]), 
        .imm_2(imm_2[1][0]), 
        .disp(disp[1][0]), 
        
        //Control Outputs
        .dump(true_dump),
        .imm_src(imm_src[1][0]), 
        .inv_A(inv_A[1][0]), 
        .inv_B(inv_B[1][0]), 
        .shift_A(shift_A[1][0]), 
        .B_to_zero(B_to_zero[1][0]), 
        .c_in(c_in[1][0]), 
        .sign(sign[1][0]), 
        .mem_write_en(mem_write_en[1][0]), 
        .ALU_jmp_src(ALU_jmp_src[1][0]),
        .reg_src(reg_src[1][0]),
        .B_src(B_src[1][0]), 
        .branch(branch[1][0]), 
        .ALU_control(ALU_control[1][0]), 
        .mem_enable(mem_enable[1][0]),
        .less_than(less_than[1][0]),
        .equal_to(equal_to[1][0]),
        .set_CO(set_CO[1][0]),
        .write_reg_sel_out(write_reg_sel[1][0]),
        .reg_write_en_out(reg_write_en[1][0]),

        //Data Outputs
        .A(A[1][0]), 
        .read_data_2(read_data_2[1][0]),
        .err(decode_err)
    );

    //Signals that remain unchanged in the Decode stage
    assign inc_PC[1][0] = inc_PC[0][1];


   /*********************************************************
   **                  Decode / Execute FF                 **
   *********************************************************/
   Decode_Execute_FF Decode_Execute_FF (

      //Basic Inputs
      .clk(clk),
      .global_rst(rst),
      .local_clr(local_clr[1][0]),
      .freeze(freeze[1][0]),

      // Flop Inputs
      .inc_PC_DE_in(inc_PC[1][0]),
      .imm_1_DE_in(imm_1[1][0]),
      .imm_2_DE_in(imm_2[1][0]),
      .disp_DE_in(disp[1][0]),
      .dump_DE_in(dump[1][0]),
      .imm_src_DE_in(imm_src[1][0]),
      .inv_A_DE_in(inv_A[1][0]),
      .inv_B_DE_in(inv_B[1][0]),
      .shift_A_DE_in(shift_A[1][0]),
      .B_to_zero_DE_in(B_to_zero[1][0]),
      .c_in_DE_in(c_in[1][0]),
      .sign_DE_in(sign[1][0]),
      .mem_write_en_DE_in(mem_write_en[1][0]),
      .ALU_jmp_src_DE_in(ALU_jmp_src[1][0]),
      .reg_src_DE_in(reg_src[1][0]),
      .B_src_DE_in(B_src[1][0]),
      .branch_DE_in(branch[1][0]),
      .ALU_control_DE_in(ALU_control[1][0]),
      .mem_enable_DE_in(mem_enable[1][0]),
      .less_than_DE_in(less_than[1][0]),
      .equal_to_DE_in(equal_to[1][0]),
      .set_CO_DE_in(set_CO[1][0]),
      .A_DE_in(A[1][0]),
      .read_data_2_DE_in(read_data_2[1][0]),
      .reg_write_en_DE_in(reg_write_en[1][0]),
      .write_reg_sel_DE_in(write_reg_sel[1][0]),


      // Outputs
      .inc_PC_DE_out(inc_PC[1][1]),
      .imm_1_DE_out(imm_1[1][1]),
      .imm_2_DE_out(imm_2[1][1]),
      .disp_DE_out(disp[1][1]),
      .dump_DE_out(dump[1][1]),
      .imm_src_DE_out(imm_src[1][1]),
      .inv_A_DE_out(inv_A[1][1]),
      .inv_B_DE_out(inv_B[1][1]),
      .shift_A_DE_out(shift_A[1][1]),
      .B_to_zero_DE_out(B_to_zero[1][1]),
      .c_in_DE_out(c_in[1][1]),
      .sign_DE_out(sign[1][1]),
      .mem_write_en_DE_out(mem_write_en[1][1]),
      .ALU_jmp_src_DE_out(ALU_jmp_src[1][1]),
      .reg_src_DE_out(reg_src[1][1]),
      .B_src_DE_out(B_src[1][1]),
      .branch_DE_out(branch[1][1]),
      .ALU_control_DE_out(ALU_control[1][1]),
      .mem_enable_DE_out(mem_enable[1][1]),
      .less_than_DE_out(less_than[1][1]),
      .equal_to_DE_out(equal_to[1][1]),
      .set_CO_DE_out(set_CO[1][1]),
      .A_DE_out(A[1][1]),
      .read_data_2_DE_out(read_data_2[1][1]),
      .reg_write_en_DE_out(reg_write_en[1][1]),
      .write_reg_sel_DE_out(write_reg_sel[1][1])
   );

    //Ensures that the dump signal is only true if its not coming of a reset
    assign dump[1][0] = true_dump & ~held_rst;


   /*********************************************************
   **                        Execute                       **
   *********************************************************/
   execute execute (
      //Data Inputs 
      .inc_PC(inc_PC[1][1]), 
      .A(A[1][1]), 
      .B(read_data_2[1][1]), 
      .disp(disp[1][1]), 
      .imm_1(imm_1[1][1]), 
      .imm_2(imm_2[1][1]), 

      //Opcode Inputs
      .ALU_control(ALU_control[1][1]), 
      .branch(branch[1][1]), 
 
      //Control Inputs
      .ALU_jmp(ALU_jmp_src[1][1]), 
      .imm_src(imm_src[1][1]), 
      .B_src(B_src[1][1]), 
      .inv_A(inv_A[1][1]), 
      .inv_B(inv_B[1][1]), 
      .B_to_zero(B_to_zero[1][1]), 
      .shift_A(shift_A[1][1]), 
      .c_in(c_in[1][1]), 
      .sign(sign[1][1]), 
      .less_than(less_than[1][1]),
      .equal_to(equal_to[1][1]),
      .set_CO(set_CO[1][1]),

      //Outputs
      .ALU_result(ALU_result[2][0]),

      .disp_PC(disp_PC[2][0]),
      .PC_src(PC_src[2][0]),
      //Error
      .err(exec_err)
   );

    //Signals that remain unchanged in the Execute stage
    assign inc_PC[2][0]         = inc_PC[1][1];
    assign imm_2[2][0]          = imm_2[1][1];
    assign dump[2][0]           = dump[1][1];
    assign mem_write_en[2][0]   = mem_write_en[1][1];
    assign reg_src[2][0]        = reg_src[1][1];
    assign mem_enable[2][0]     = mem_enable[1][1];
    assign read_data_2[2][0]    = read_data_2[1][1];
    assign reg_write_en[2][0]   = reg_write_en[1][1];
    assign write_reg_sel[2][0]  = write_reg_sel[1][1];
    assign ALU_jmp_src[2][0]    = ALU_jmp_src[1][1];




    /*********************************************************
    **                  Execute / Memory FF                 **
    *********************************************************/
    execute_Memory_FF execute_Memory_FF (
        //Basic Inputs
        .clk(clk),
        .local_clr(local_clr[2][0]),
        .global_rst(rst),
        .freeze(freeze[2][0]),

        // Flop Inputs 
        .inc_PC_EM_in(inc_PC[2][0]),
        .imm_2_EM_in(imm_2[2][0]),
        .dump_EM_in(dump[2][0]),
        .mem_write_en_EM_in(mem_write_en[2][0]),
        .reg_src_EM_in(reg_src[2][0]),
        .mem_enable_EM_in(mem_enable[2][0]),
        .read_data_2_EM_in(read_data_2[2][0]),
        .reg_write_en_EM_in(reg_write_en[2][0]),
        .write_reg_sel_EM_in(write_reg_sel[2][0]),
        .ALU_result_EM_in(ALU_result[2][0]),


        // Outputs 
        .inc_PC_EM_out(inc_PC[2][1]),
        .imm_2_EM_out(imm_2[2][1]),
        .dump_EM_out(dump[2][1]),
        .mem_write_en_EM_out(mem_write_en[2][1]),
        .reg_src_EM_out(reg_src[2][1]),
        .mem_enable_EM_out(mem_enable[2][1]),
        .read_data_2_EM_out(read_data_2[2][1]),
        .reg_write_en_EM_out(reg_write_en[2][1]),
        .write_reg_sel_EM_out(write_reg_sel[2][1]),
        .ALU_result_EM_out(ALU_result[2][1])      
    );

    dff inc_PC_EM_FF [17:0] (
        .clk(clk), 
        .rst(rst),
        .d({disp_PC[2][0], PC_src[2][0], ALU_jmp_src[2][0]}), 
        .q({disp_PC[2][1], PC_src[2][1], ALU_jmp_src[2][1]})
    );


    /*********************************************************
    **                         Memory                       **
    *********************************************************/
    memory memory (
        //Basic Inputs
        .clk(clk), 
        .rst(rst), 

        //Data Inputs
        .write_data(read_data_2[2][1]), 
        .addr(ALU_result[2][1]), 

        //Control Inputs
        .mem_enable(mem_enable[2][1]), // Changed to double en time 
        .mem_write(mem_write_en[2][1]), // Changed to double en time 
        .dump(dump[2][1]), 

        //Data Outputs
        .read_data(read_data[3][0])
    );

    //Signals that remain unchanged in the Memory stage
    assign inc_PC[3][0]         = inc_PC[2][1];
    assign imm_2[3][0]          = imm_2[2][1];
    assign reg_src[3][0]        = reg_src[2][1];
    assign reg_write_en[3][0]   = reg_write_en[2][1];
    assign write_reg_sel[3][0]  = write_reg_sel[2][1];
    assign ALU_result[3][0]     = ALU_result[2][1];

   
    /*********************************************************
    **                  Memory / WriteBack FF               **
    *********************************************************/
    memory_WriteBack_FF memory_WriteBack_FF (
        //Basic Inputs
        .clk(clk),
        .local_clr(local_clr[3][0]),
        .global_rst(rst),
        .freeze(freeze[3][0]),

        // Flop Inputs
        .inc_PC_MWB_in(inc_PC[3][0]),
        .imm_2_MWB_in(imm_2[3][0]),
        .reg_src_MWB_in(reg_src[3][0]),
        .reg_write_en_MWB_in(reg_write_en[3][0]),
        .write_reg_sel_MWB_in(write_reg_sel[3][0]),
        .ALU_result_MWB_in(ALU_result[3][0]),
        .read_data_MWB_in(read_data[3][0]),


        // Outputs
        .inc_PC_MWB_out(inc_PC[3][1]),
        .imm_2_MWB_out(imm_2[3][1]),
        .reg_src_MWB_out(reg_src[3][1]),
        .reg_write_en_MWB_out(reg_write_en[3][1]),
        .write_reg_sel_MWB_out(write_reg_sel[3][1]),
        .ALU_result_MWB_out(ALU_result[3][1]),
        .read_data_MWB_out(read_data[3][1])
    );




   /*********************************************************
   **                       Write Back                     **
   *********************************************************/
   wb wb (
      //Data Inputs
      .inc_PC(inc_PC[3][1]), 
      .read_data(read_data[3][1]), 
      .ALU_result(ALU_result[3][1]), 
      .imm_2(imm_2[3][1]),
      .reg_src(reg_src[3][1]),

      //Outputs 
      .write_data(write_data),

      //Error
      .err(wb_err)
   );


   /*********************************************************
   **                   Error Detection                    **
   *********************************************************/
   assign err = (fetch_err | decode_err | exec_err | wb_err) & ~rst;


    dff meow  (
        .clk(clk), 
        .rst(1'b0),
        .d(rst), 
        .q(held_rst)
    );


   



endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
