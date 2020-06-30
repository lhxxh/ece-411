import rv32i_types::*;

module forwarding (
    input RVFI_control_packet ex_control,
    input RVFI_control_packet mem_control,
    input RVFI_control_packet wb_control,
    input RVFI_monitor_packet ex_monitor,
    input RVFI_monitor_packet mem_monitor,
    input RVFI_monitor_packet wb_monitor,
    input logic [31:0] wb_regfilemux_out,
    output logic [31:0] mem_forward,
    output logic [31:0] wb_forward,
    output logic ex_rs1_mem_hazard,
    output logic ex_rs2_mem_hazard,
    output logic ex_rs1_wb_hazard,
    output logic ex_rs2_wb_hazard,
    output logic mem_rs2_wb_hazard,
    output logic hazard_stall
);

assign mem_forward = ((mem_control.opcode == op_reg) | (mem_control.opcode == op_imm)) & ((mem_control.funct3 == slt) | (mem_control.funct3 == sltu)) ?
    {31'b0, mem_monitor.br_en} : mem_monitor.mem_addr;

assign wb_forward = wb_regfilemux_out;

assign ex_rs1_mem_hazard = 
    mem_control.regfile_write & (mem_monitor.rd != 4'b0) &
    (mem_monitor.rd == ex_monitor.rs1);

assign ex_rs2_mem_hazard = 
    mem_control.regfile_write & (mem_monitor.rd != 4'b0) &
    (mem_monitor.rd == ex_monitor.rs2);

assign ex_rs1_wb_hazard = 
    wb_control.regfile_write & (wb_monitor.rd != 4'b0) &
    (wb_monitor.rd == ex_monitor.rs1) & (~ex_rs1_mem_hazard);

assign ex_rs2_wb_hazard = 
    wb_control.regfile_write & (wb_monitor.rd != 4'b0) &
    (wb_monitor.rd == ex_monitor.rs2) & (~ex_rs2_mem_hazard);

assign mem_rs2_wb_hazard = 
    wb_control.regfile_write & (wb_monitor.rd != 4'b0) &
    (wb_monitor.rd == mem_monitor.rs2);

assign hazard_stall = 
    (ex_rs1_mem_hazard | ex_rs2_mem_hazard) & (mem_control.opcode == op_load) & 
    ~((mem_monitor.pc_rdata == wb_monitor.pc_rdata) & (mem_monitor.pc_rdata != '0));

endmodule : forwarding