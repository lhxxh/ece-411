import cam_types::*;

module testbench(cam_itf itf);

cam dut (
    .clk_i     ( itf.clk     ),
    .reset_n_i ( itf.reset_n ),
    .rw_n_i    ( itf.rw_n    ),
    .valid_i   ( itf.valid_i ),
    .key_i     ( itf.key     ),
    .val_i     ( itf.val_i   ),
    .val_o     ( itf.val_o   ),
    .valid_o   ( itf.valid_o )
);

default clocking tb_clk @(negedge itf.clk); endclocking

task reset();
    itf.reset_n <= 1'b0;
    repeat (5) @(tb_clk);
    itf.reset_n <= 1'b1;
    repeat (5) @(tb_clk);
endtask

// DO NOT MODIFY CODE ABOVE THIS LINE

task write(input key_t key, input val_t val);
endtask

task read(input key_t key, output val_t val);
endtask

initial begin
    $display("Starting CAM Tests");

    reset();
    /************************** Your Code Here ****************************/
    // Feel free to make helper tasks / functions, initial / always blocks, etc.
    // Consider using the task skeltons above
    // To report errors, call itf.tb_report_dut_error in cam/include/cam_itf.sv
    
    for(int i = 1; i < camsize_p + 1; i++) begin

        ##1;
        
        itf.rw_n = 1'b0;
        itf.valid_i = 1'b1;
        itf.key = i;
        itf.val_i = i * 10;

        ##1;
        
        itf.valid_i = 1'b0;

    end


    for(int i = 1; i < camsize_p + 1; i++) begin
        
        ##1;                                     // write 

        itf.rw_n = 1'b0;
        itf.valid_i = 1'b1;
        itf.key = i + camsize_p;
        itf.val_i = 0;
        
        ##1;                                    // read to check value

        itf.rw_n = 1'b1;
        itf.valid_i = 1'b1;
        itf.key = i;

        ## 1;

        itf.valid_i = 1'b0;

        assert (itf.valid_o == 1'b0) 
        else  begin
            $error("Did not eject key %0d",i);
        end

    end



    reset();

    for(int i = 1; i < 10 ; i++) begin
        
        ##1;                                     // write 

        itf.rw_n = 1'b0;
        itf.valid_i = 1'b1;
        itf.key = 0;
        itf.val_i = i;
        
        ##1;                                    // read to check value

        itf.rw_n = 1'b1;
        itf.valid_i = 1'b1;
        itf.key = 0;

        ## 1;       

        itf.valid_i = 1'b0;

        assert (itf.val_o == i) 
        else  begin
            itf.tb_report_dut_error(READ_ERROR);
            $error("%0t TB: Read %0d, expected %0d", $time, itf.val_o, i);
        end

    end

    reset();

        for(int i = 1; i < camsize_p + 1; i++) begin                          // make it full

        ##1;
        
        itf.rw_n = 1'b0;
        itf.valid_i = 1'b1;
        itf.key = i;
        itf.val_i = i * 10;

        ##1;
        
        itf.valid_i = 1'b0;

    end

        for(int i = 1; i < camsize_p + 1; i++) begin                       // make a read-hit
            
        ##1;

        itf.rw_n = 1'b1;
        itf.valid_i = 1'b1;
        itf.key = i;

        ##1;

        itf.valid_i = 1'b0;

        assert (i*10 == itf.val_o) 
        else  begin
            itf.tb_report_dut_error(READ_ERROR);
            $error("%0t TB: Read %0d, expected %0d", $time, itf.val_o, i);
        end

    end

    reset();

    for(int i = 1; i < 10 ; i++) begin
        
        ##1;                                     // write - write

        itf.rw_n = 1'b0;
        itf.valid_i = 1'b1;
        itf.key = 0;
        itf.val_i = i;

        ## 1;       

        itf.valid_i = 1'b0;

    end

        ##1;                                    // read to check value

        itf.rw_n = 1'b1;
        itf.valid_i = 1'b1;
        itf.key = 0;

        ## 1;       

        itf.valid_i = 1'b0;

        assert (itf.val_o == 9) 
        else  begin
            itf.tb_report_dut_error(READ_ERROR);
            $error("%0t TB: Read %0d, expected %0d", $time, itf.val_o, 9);
        end

    /**********************************************************************/

    itf.finish();
end

endmodule : testbench
