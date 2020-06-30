import mult_types::*;

`ifndef testbench
`define testbench
module testbench(multiplier_itf.testbench itf);

add_shift_multiplier dut (
    .clk_i          ( itf.clk          ),
    .reset_n_i      ( itf.reset_n      ),
    .multiplicand_i ( itf.multiplicand ),
    .multiplier_i   ( itf.multiplier   ),
    .start_i        ( itf.start        ),
    .ready_o        ( itf.rdy          ),
    .product_o      ( itf.product      ),
    .done_o         ( itf.done         )
);

assign itf.mult_op = dut.ms.op;
default clocking tb_clk @(negedge itf.clk); endclocking

// DO NOT MODIFY CODE ABOVE THIS LINE

/* Uncomment to "monitor" changes to adder operational state over time */
//initial $monitor("dut-op: time: %0t op: %s", $time, dut.ms.op.name);


// Resets the multiplier
task reset();
    itf.reset_n <= 1'b0;
    ##5;
    itf.reset_n <= 1'b1;
    ##1;
endtask : reset

// error_e defined in package mult_types in file ../include/types.sv
// Asynchronously reports error in DUT to grading harness
function void report_error(error_e error);
    itf.tb_report_dut_error(error);
endfunction : report_error


initial itf.reset_n = 1'b0;
initial begin
    reset();
    /********************** Your Code Here *****************************/
    for ( int i = 0 ; i < 256 ; i++) begin

        for ( int j = 0; j < 256 ; j++) begin       

           ##5;
           itf.reset_n = '0;
           ##5;
           itf.reset_n = '1;

           not_ready_before: assert (itf.rdy == 1'b1) 
           else   
                begin
                $error ("%0d: %0t: NOT_READY_BEFORE error detected", `__LINE__, $time);
                itf.tb_report_dut_error(NOT_READY);
                end


           itf.multiplier = i;
           itf.multiplicand = j;
           
           ##5;
           
           itf.start = 1'b1;
           @(tb_clk iff itf.done == 1'b1);
           bad_product : assert (i * j == itf.product) 
           else   
                begin
                $error ("%0d: %0t: BAD_PRODUCT error detected", `__LINE__, $time);
                itf.tb_report_dut_error(BAD_PRODUCT);
                end

           not_ready_after: assert (itf.rdy == 1'b1) 
           else   
                begin
                $error ("%0d: %0t: NOT_READY_AFTER error detected", `__LINE__, $time);
                itf.tb_report_dut_error(NOT_READY);
                end
            
          
        end

    end

    ##5;
    itf.reset_n = '0;
    ##5;
    itf.reset_n = '1;
    

    not_ready_before: assert (itf.rdy == 1'b1) 
    else   
        begin
            $error ("%0d: %0t: NOT_READY_BEFORE error detected", `__LINE__, $time);
            itf.tb_report_dut_error(NOT_READY);
        end

    itf.multiplier = 1;
    itf.multiplicand = 1;

    ##5; 

    itf.start = 1'b1;
    @(tb_clk iff dut.ms.op == SHIFT);
    itf.reset_n = '0;
    ##5;
    itf.reset_n = '1;


    /*******************************************************************/
    itf.finish(); // Use this finish task in order to let grading harness
                  // complete in process and/or scheduled operations
    $error("Improper Simulation Exit");
end


endmodule : testbench
`endif
