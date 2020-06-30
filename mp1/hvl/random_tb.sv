import rv32i_types::*;

/**
 * Generates constrained random vectors with which to drive the DUT.
 * Recommended usage is to test arithmetic and comparator functionality,
 * as well as branches.
 *
 * Randomly testing load/stores will require building a memory model,
 * which you can do using a SystemVerilog associative array:
 *     logic[7:0] byte_addressable_mem [logic[31:0]]
 *   is an associative array with value type logic[7:0] and
 *   key type logic[31:0].
 * See IEEE 1800-2017 Clause 7.8
**/
module random_tb(
    tb_itf.tb itf,
    tb_itf.mem mem_itf
);

/**
 * SystemVerilog classes can be defined inside modules, in which case
 *   their usage scope is constrained to that module
 * RandomInst generates constrained random test vectors for your
 * rv32i DUT.
 * As is, RandomInst only supports generation of op_imm opcode instructions.
 * You are highly encouraged to expand its functionality.
**/
class RandomInst;
    rv32i_reg reg_range[$];
    arith_funct3_t arith3_range[$];
    store_funct3_t store3_range[$];

    /** Constructor **/
    function new();
        arith_funct3_t af3;
        store_funct3_t sf3;
        af3 = af3.first;
        sf3 = sf3.first;

        for (int i = 0; i < 32; ++i)
            reg_range.push_back(i);
        do begin
            arith3_range.push_back(af3);
            af3 = af3.next;
        end while (af3 != af3.last);
        do begin
            store3_range.push_back(sf3);
            sf3 = sf3.next;
        end while (sf3 != sf3.last);

    endfunction

    function rv32i_word immediate(
        const ref rv32i_reg rd_range[$] = reg_range,
        const ref arith_funct3_t funct3_range[$] = arith3_range,
        const ref rv32i_reg rs1_range[$] = reg_range
    );
        union {
            rv32i_word rvword;
            struct packed {
                logic [31:20] i_imm;
                rv32i_reg rs1;
                logic [2:0] funct3;
                logic [4:0] rd;
                rv32i_opcode opcode;
            } i_word;
        } word;

        word.rvword = '0;
        word.i_word.opcode = op_imm;

        // Set rd register
        do begin
            word.i_word.rd = $urandom();
        end while (!(word.i_word.rd inside {rd_range}));

        // set funct3
        do begin
            word.i_word.funct3 = $urandom();
        end while (!(word.i_word.funct3 inside {funct3_range}));

        // set rs1
        do begin
            word.i_word.rs1 = $urandom();
        end while (!(word.i_word.rs1 inside {rs1_range}));

        // set immediate value
        word.i_word.i_imm = $urandom();

        return word.rvword;
    endfunction

    function rv32i_word register(
        const ref rv32i_reg rd_range[$] = reg_range,
        const ref arith_funct3_t funct3_range[$] = arith3_range,
        const ref rv32i_reg rs1_range[$] = reg_range,
        const ref rv32i_reg rs2_range[$] = reg_range
    );
        union {
            rv32i_word rvword;
            struct packed {
                logic [31:26] zero_or_spec;
                rv32i_reg rs2;
                rv32i_reg rs1;
                logic [2:0] funct3;
                logic [4:0] rd;
                rv32i_opcode opcode;
            } i_word;
        } word;

        word.rvword = '0;
        word.i_word.opcode = op_reg;

        // Set rd register
        do begin
            word.i_word.rd = $urandom();
        end while (!(word.i_word.rd inside {rd_range}));

        // set funct3
        do begin
            word.i_word.funct3 = $urandom();
        end while (!(word.i_word.funct3 inside {funct3_range}));

        // set rs1
        do begin
            word.i_word.rs1 = $urandom();
        end while (!(word.i_word.rs1 inside {rs1_range}));

        // set rs2
        do begin
            word.i_word.rs1 = $urandom();
        end while(!(word.i_word.rs2 inside {rs2_range}));

        // set zero_or_spec (no sub and sar)
          word.i_word.zero_or_spec = '0;

        return word.rvword;
    endfunction

    // function rv32i_word store_b(
    //     const ref rv32i_reg rd_range[$] = reg_range,
    //     const ref rv32i_reg rs1_range[$] = reg_range,
    //     const ref rv32i_reg rs2_range[$] = reg_range
    // );
    //     union {
    //         rv32i_word rvword;
    //         struct packed {
    //             logic [31:26] imm;
    //             rv32i_reg rs2;
    //             rv32i_reg rs1;
    //             logic [2:0] funct3;
    //             logic [4:0] rd;
    //             rv32i_opcode opcode;
    //         } i_word;
    //     } word;
    //
    //     word.rvword = '0;
    //     word.i_word.opcode = op_store;
    //
    //     // Set rd register
    //     do begin
    //         word.i_word.rd = $urandom();
    //     end while (!(word.i_word.rd inside {rd_range}));
    //
    //     // set funct3
    //         word.i_word.funct3 = 3'b000;
    //
    //     // set rs1
    //     do begin
    //         word.i_word.rs1 = $urandom();
    //     end while (!(word.i_word.rs1 inside {rs1_range}));
    // 
    //     // set rs2
    //     do begin
    //         word.i_word.rs1 = $urandom();
    //     end while(!(word.i_word.rs2 inside {rs2_range}));
    //
    //     // set zero_or_spec
    //     do begin
    //       word.i_word.imm = $urandom();
    //     end while(word.i_word.imm);
    //
    //     return word.rvword;
    // endfunction

endclass

RandomInst generator = new();

task immediate_tests(input int count, input logic verbose = 1'b0);
    @(posedge itf.clk iff itf.rst == 1'b0)
    $display("Starting Immediate Tests");
    repeat (count) begin
      // immediate
        $display("start imm");
        @(mem_itf.mcb iff itf.mcb.read);
        mem_itf.mcb.rdata <= generator.immediate();
        if (verbose)
            $display("Testing stimulus: %32b", mem_itf.mcb.rdata);
        mem_itf.mcb.resp <= 1;
        @(mem_itf.mcb) mem_itf.mcb.resp <= 1'b0;
        $display("end imm");
     // register to register
        $display("start reg");
        @(mem_itf.mcb iff itf.mcb.read);
        mem_itf.mcb.rdata <= generator.register();
        if (verbose)
            $display("Testing stimulus: %32b", mem_itf.mcb.rdata);
        mem_itf.mcb.resp <= 1;
        @(mem_itf.mcb) mem_itf.mcb.resp <= 1'b0;
        $display("end reg");
    // store
        // $display("start store");
        // @(mem_itf.mcb iff itf.mcb.read);
        // mem_itf.mcb.rdata <= generator.store();
        // if (verbose)
        //   $display("Testing stimulus: %32b", mem_itf.mcb.rdata);
        // mem_itf.mcb.resp <= 1;
        // @(mem_itf.mcb) mem_itf.mcb.resp <= 1'b0;
        // @(mem_itf.mcb iff itf.mcb.write);
        // $display("data has been stored");
        // mem_itf.mcb.resp <= 1;
        // @(mem_itf.mcb) mem_itf.mcb.resp <= 1'b0;
        // $display("end store");
    end
    $display("Finishing Immediate Tests");
endtask

initial begin
    immediate_tests(10000, 1'b1);
    $finish;
end

endmodule : random_tb
