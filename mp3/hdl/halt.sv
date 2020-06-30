import rv32i_types::*;

module halt (
    input rst,
    input inst_resp,
    input data_resp,
    input memory_read,
    input memory_write,
    input branch_mistake,
    input mem_br_en,
    input rv32i_opcode mem_opcode,
    input hazard_stall,
    input hazard_stall_complete,
    input id_direct_jump,
    input id_br_predict,
    input pcmux::pcmux_sel_t mem_pcmux_sel,
    output if_id_load,
    output id_ex_load,
    output ex_mem_load,
    output mem_wb_load,
    output finish_load,
    output if_id_rst,
    output id_ex_rst,
    output ex_mem_rst,
    output mem_wb_rst,
    output if_load_pc,
    output data_cache_miss,
    output inst_cache_miss,
    output pcmux::pcmux_sel_t if_pcmux_sel
);

logic cache_halt;
logic direct_jump;

assign cache_halt = (~inst_resp) | ((memory_read | memory_write) & (~data_resp));
assign data_cache_miss = ((memory_read | memory_write) & (~data_resp));
assign inst_cache_miss = (~inst_resp);

assign direct_jump = (~branch_mistake) & (id_direct_jump | id_br_predict) & ~cache_halt & ~rst;
assign if_pcmux_sel = direct_jump ? pcmux::pc_jmp : 
    ((~branch_mistake) ? pcmux::pc_plus4 : 
    ((mem_opcode == op_jalr) ? pcmux::alu_mod2 : (mem_br_en ? mem_pcmux_sel : pcmux::mem_pc_plus4)));

assign if_id_load = ~(cache_halt | hazard_stall);
assign id_ex_load = ~(cache_halt | hazard_stall);
assign ex_mem_load = ~(cache_halt | hazard_stall);
assign mem_wb_load = ~cache_halt;
assign finish_load = ~cache_halt;
assign if_load_pc = ~(cache_halt | hazard_stall);

assign if_id_rst = ((branch_mistake | direct_jump) & ~cache_halt) | rst;
assign id_ex_rst = (branch_mistake & ~cache_halt) | rst;
assign ex_mem_rst = (branch_mistake & ~cache_halt) | rst;
assign mem_wb_rst = rst | hazard_stall_complete;

endmodule
