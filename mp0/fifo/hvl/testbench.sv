`ifndef testbench
`define testbench

import fifo_types::*;

module testbench(fifo_itf itf);

fifo_synch_1r1w dut (
    .clk_i     ( itf.clk     ),
    .reset_n_i ( itf.reset_n ),

    // valid-ready enqueue protocol
    .data_i    ( itf.data_i  ),
    .valid_i   ( itf.valid_i ),
    .ready_o   ( itf.rdy     ),

    // valid-yumi deqeueue protocol
    .valid_o   ( itf.valid_o ),
    .data_o    ( itf.data_o  ),
    .yumi_i    ( itf.yumi    )
);

// Clock Synchronizer for Student Use
default clocking tb_clk @(negedge itf.clk); endclocking

task reset();
    itf.reset_n <= 1'b0;
    ##(10);
    itf.reset_n <= 1'b1;
    ##(1);
endtask : reset

function automatic void report_error(error_e err); 
    itf.tb_report_dut_error(err);
endfunction : report_error

// DO NOT MODIFY CODE ABOVE THIS LINE

initial begin
    reset();
    /************************ Your Code Here ***********************/
    // Feel free to make helper tasks / functions, initial / always blocks, etc.

    problem: assert (itf.rdy == 1'b1)
             else 
                begin
                    $error ("%0d: %0t: RESET_DOES_NOT_CAUSE_READY_O error detected", `__LINE__, $time);
                    report_error (RESET_DOES_NOT_CAUSE_READY_O);
                end

    for(int i = 0; i < cap_p; i++) begin

        @ (tb_clk iff itf.rdy == 1'b1);
        itf.data_i = i;
        itf.yumi = 1'b0;
        itf.valid_i = 1'b1;

    end

    for(int i = 0; i < cap_p; i++) begin
        
        @ (tb_clk iff itf.valid_o == 1'b1);
        itf.yumi = 1'b1;
        itf.valid_i = 1'b0;

        INCORRECT_DATA_O_ON_YUMI_I_dq:assert (i == itf.data_o)
        else 
            begin
            $error ("%0d: %0t: INCORRECT_DATA_O_ON_YUMI_I error detected", `__LINE__, $time);
            report_error(INCORRECT_DATA_O_ON_YUMI_I);            
            end

    end



    for(int i = 1; i < cap_p; i++) begin

        reset();
        
        problem_two: assert (itf.rdy == 1'b1)
            else 
                begin
                    $error ("%0d: %0t: RESET_DOES_NOT_CAUSE_READY_O error detected", `__LINE__, $time);
                    report_error (RESET_DOES_NOT_CAUSE_READY_O);
                end

        // $display("When i == %0d", i);

        for(int j = i; j > 0; j--) begin
            @ (tb_clk iff itf.rdy == 1'b1);
            itf.data_i = i; 
            itf.yumi = 1'b0;
            itf.valid_i = 1'b1;
            // $display("the number %0d is inserted into queue", j);
        end

        // $display("before dut read_ptr_next is %0d and read_ptr is %0d",dut.read_ptr_next[ptr_width_p-1:0],dut.read_ptr[ptr_width_p-1:0]);
        // $display("before dut write_ptr_next is %0d and write_ptr is %0d",dut.write_ptr_next[ptr_width_p-1:0],dut.write_ptr[ptr_width_p-1:0]);
        @ (tb_clk iff (itf.rdy == 1'b1 && itf.valid_o == 1'b1));
        itf.data_i = 0;
        itf.yumi = 1'b1;
        itf.valid_i = 1'b1;
        // $display("0 is inserted");


        // $display("after dut read_ptr_next is %0d and read_ptr is %0d",dut.read_ptr_next[ptr_width_p-1:0],dut.read_ptr[ptr_width_p-1:0]);
        // $display("after dut write_ptr_next is %0d and write_ptr is %0d",dut.write_ptr_next[ptr_width_p-1:0],dut.write_ptr[ptr_width_p-1:0]);

        @ (tb_clk iff (itf.rdy == 1'b1 && itf.valid_o == 1'b1));      

        if (dut.read_ptr_next[ptr_width_p-1:0] != dut.write_ptr[ptr_width_p-1:0]) begin
            INCORRECT_DATA_O_ON_YUMI_I_dq_eq_greater_than_one:assert (i == itf.data_o)
            else begin
                $error ("%0d: %0t INCORRECT_DATA_O_ON_YUMI_I error detected at i == %0d and itf.data_o == %0d", `__LINE__, $time, i, itf.data_o);
                report_error(INCORRECT_DATA_O_ON_YUMI_I);            
            end 
        end
        else begin
            INCORRECT_DATA_O_ON_YUMI_I_dq_eq_equal_to_one:assert (0 == itf.data_o)
            else begin
                $error ("%0d: %0t INCORRECT_DATA_O_ON_YUMI_I error detected at i == %0d and itf.data_o == %0d", `__LINE__, $time, i, itf.data_o);
                report_error(INCORRECT_DATA_O_ON_YUMI_I);            
            end            
        end      

        ##5;

    end

    /***************************************************************/
    // Make sure your test bench exits by calling itf.finish();
    itf.finish();
    $error("TB: Illegal Exit ocurred");


end

endmodule : testbench
`endif

