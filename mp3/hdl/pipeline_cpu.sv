`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;

module pipeline_cpu
(
    input logic clk,
    input logic rst,
    input logic inst_resp,
    input logic [31:0] inst_rdata,
    input logic data_resp,
    input logic [31:0] data_rdata,
    output logic inst_read,
    output logic [31:0] inst_addr,
    output logic data_read,
    output logic data_write,
    output logic [3:0] data_mbe,
    output logic [31:0] data_addr,
    output logic [31:0] data_wdata
);

// IF Stage

logic [31:0] if_pc;
logic [31:0] if_instruction;
logic [31:0] if_pc_plus4;
logic [31:0] if_pcmux_out;
logic if_load_pc;
logic if_id_load;
logic if_id_rst;
pcmux::pcmux_sel_t if_pcmux_sel;

assign if_instruction = (inst_resp && inst_read) ? inst_rdata : 'x;
assign inst_read = 1'b1 & (~rst);
assign inst_addr = if_pc;
assign if_pc_plus4 = if_pc + 32'd4;

// ID Stage

logic [31:0] id_rs1_rdata, id_rs2_rdata;
logic id_ex_load;
logic id_ex_rst;
logic id_direct_jump;
RVFI_monitor_packet id_monitor;
RVFI_control_packet id_control;

// EX Stage

logic [31:0] ex_alu_result;
logic ex_br_en;
logic [31:0] ex_alumux1_out;
logic [31:0] ex_alumux2_out;
logic [31:0] ex_cmpmux_out;
logic ex_mem_load;
logic ex_mem_rst;
RVFI_monitor_packet ex_monitor;
RVFI_control_packet ex_control;

// MEM Stage

logic [31:0] mem_mem_rdata;
logic mem_wb_load;
logic mem_wb_rst;
logic [31:0] pc_wdata_in;
RVFI_monitor_packet mem_monitor;
RVFI_control_packet mem_control;

logic data_cache_miss;
logic inst_cache_miss;

assign data_wdata = (data_write)? mem_monitor.mem_wdata : 'x;
assign data_addr = (data_write | data_read) ? mem_monitor.mem_addr & 32'hFFFFFFFC : 'x;
assign data_read = (inst_cache_miss) ?  '0 : mem_control.mem_read;
assign data_write = (inst_cache_miss) ? '0 : mem_control.mem_write;
assign data_mbe = (inst_cache_miss) ? '0 : mem_monitor.mem_wmask;
assign mem_mem_rdata = (data_resp && data_read) ? data_rdata : 'x;

// WB Stage

logic [31:0] wb_regfilemux_out;

RVFI_monitor_packet wb_monitor;
RVFI_control_packet wb_control;

// finish Signal

logic finish_load;

// Branch predictor signals

logic mem_predict_correct;
logic id_br_predict;

assign mem_predict_correct = (mem_monitor.br_predict == mem_monitor.br_en);

// forwarding signals

logic [31:0] wb_forward;
logic [31:0] mem_forward;

logic ex_rs1_mem_hazard;
logic ex_rs2_mem_hazard;
logic ex_rs1_wb_hazard;
logic ex_rs2_wb_hazard;
logic mem_rs2_wb_hazard;
logic hazard_stall;
logic hazard_stall_complete;
logic branch_mistake;

assign branch_mistake = ((mem_control.opcode == op_br) & ~mem_predict_correct) | (mem_control.opcode == op_jalr);

assign hazard_stall_complete = (mem_monitor.pc_rdata == wb_monitor.pc_rdata) & (mem_monitor.pc_rdata != '0);

logic [31:0] ex_rs1_rdata;
logic [31:0] ex_rs2_rdata;

assign ex_rs1_rdata = 
	(ex_rs1_mem_hazard & ~hazard_stall_complete) ? mem_forward :
	((ex_rs1_wb_hazard | (ex_rs1_mem_hazard & hazard_stall_complete)) ? wb_forward : ex_monitor.rs1_rdata);
assign ex_rs2_rdata = 
	(ex_rs2_mem_hazard & ~hazard_stall_complete) ? mem_forward :
	((ex_rs2_wb_hazard | (ex_rs2_mem_hazard & hazard_stall_complete)) ? wb_forward : ex_monitor.rs2_rdata);

assign pc_wdata_in = branch_mistake ? if_pcmux_out : 
    ((mem_predict_correct & (mem_control.opcode == op_br) & mem_monitor.br_en) ? mem_monitor.pc_wdata : mem_monitor.pc_plus4);

logic id_regfile_load;
assign id_regfile_load = wb_control.regfile_write & mem_wb_load;


// IF Stage
     
pc_register PC(
    .clk (clk),
    .rst (rst),
    .load (if_load_pc),
    .in (if_pcmux_out),
    .out (if_pc)
);

if_id_reg IF_ID(
    .clk (clk),
    .rst (if_id_rst),
    .load (if_id_load),
    .instruction_in (if_instruction),
    .pc_in (if_pc),
    .pc_plus4_in (if_pc_plus4),
    .monitor_out (id_monitor),
    .control_out (id_control),
    .direct_jump (id_direct_jump)
);

// ID Stage

regfile regfile(
    .clk (clk),
    .rst (rst),
    .load (id_regfile_load),
    .in (wb_regfilemux_out),
    .src_a (id_monitor.rs1),
    .src_b (id_monitor.rs2),
    .dest (wb_monitor.rd),
    .reg_a (id_rs1_rdata),
    .reg_b (id_rs2_rdata)
);

id_ex_reg ID_EX(
    .clk (clk),
    .rst (id_ex_rst),
    .load (id_ex_load),
    .rs1_rdata_in (id_rs1_rdata), 
    .rs2_rdata_in (id_rs2_rdata),
    .br_predict_in (id_br_predict),
    .monitor_in (id_monitor),
    .control_in (id_control),
    .monitor_out (ex_monitor),
    .control_out (ex_control)
);

// EX Stage

alu ALU(
    .aluop (ex_control.alu_op),
    .a (ex_alumux1_out),
    .b (ex_alumux2_out),
    .f (ex_alu_result)
);

cmp CMP(
    .cmpop (ex_control.cmp_op),
    .a (ex_rs1_rdata),
    .b (ex_cmpmux_out),
    .br_en (ex_br_en)
);

ex_mem_reg EX_MEM(
    .clk (clk),
    .rst (ex_mem_rst),
    .load (ex_mem_load),
    .alu_result_in (ex_alu_result),
    .br_en_in (ex_br_en),
    .ex_rs1_rdata_in (ex_rs1_rdata),
    .ex_rs2_rdata_in (ex_rs2_rdata),
    .monitor_in (ex_monitor),
    .control_in (ex_control),
    .monitor_out (mem_monitor),
    .control_out (mem_control)
);

// MEM Stage

mem_wb_reg MEM_WB(
    .clk (clk),
    .rst (mem_wb_rst),
    .load (mem_wb_load),
    .mem_rdata_in (mem_mem_rdata),
    .pc_wdata_in (pc_wdata_in),
    .monitor_in (mem_monitor),
    .control_in (mem_control),
    .monitor_out (wb_monitor),
    .control_out (wb_control)
);

// halt control

halt HALT (
	.rst (rst),
    .inst_resp (inst_resp),
    .data_resp (data_resp),
    .memory_read (mem_control.mem_read),
    .memory_write (mem_control.mem_write),
    .branch_mistake (branch_mistake),
    .mem_br_en (mem_monitor.br_en),
    .mem_opcode (mem_control.opcode),
    .hazard_stall (hazard_stall),
    .hazard_stall_complete (hazard_stall_complete),
    .id_direct_jump (id_direct_jump),
    .id_br_predict (id_br_predict),
    .mem_pcmux_sel (mem_control.pcmux_sel),
    .if_id_load (if_id_load),
    .id_ex_load (id_ex_load),
    .ex_mem_load (ex_mem_load),
    .mem_wb_load (mem_wb_load),
    .finish_load (finish_load),
    .if_id_rst (if_id_rst),
    .id_ex_rst (id_ex_rst),
    .ex_mem_rst (ex_mem_rst),
    .mem_wb_rst (mem_wb_rst),
    .if_load_pc(if_load_pc),
    .data_cache_miss(data_cache_miss),
    .inst_cache_miss(inst_cache_miss),
    .if_pcmux_sel (if_pcmux_sel)
);

// forwarding

forwarding FORWARDING (
	.ex_control (ex_control),
	.mem_control (mem_control),
	.wb_control (wb_control),
	.ex_monitor (ex_monitor),
	.mem_monitor (mem_monitor),
	.wb_monitor (wb_monitor),
	.wb_regfilemux_out (wb_regfilemux_out),
	.mem_forward (mem_forward),
	.wb_forward (wb_forward),
	.ex_rs1_mem_hazard (ex_rs1_mem_hazard),
	.ex_rs2_mem_hazard (ex_rs2_mem_hazard),
	.ex_rs1_wb_hazard (ex_rs1_wb_hazard),
	.ex_rs2_wb_hazard (ex_rs2_wb_hazard),
	.mem_rs2_wb_hazard (mem_rs2_wb_hazard),
	.hazard_stall (hazard_stall)
);

// branch predictor

branch_predictor PREDICTOR (
    .clk (clk),
    .rst (rst),
    .halt (~ex_mem_load),
    .id_pc (id_monitor.pc_rdata),
    .mem_pc (mem_monitor.pc_rdata),
    .mem_predict_correct (mem_predict_correct),
    .mem_br_en (mem_monitor.br_en),
    .id_opcode (id_control.opcode),
    .mem_opcode (mem_control.opcode),
    .id_br_predict (id_br_predict)
);

// MUXES

always_comb begin : MUXES
    unique case (if_pcmux_sel)
        pcmux::pc_plus4: if_pcmux_out = if_pc_plus4;
        pcmux::alu_out: if_pcmux_out = mem_monitor.mem_addr;
        pcmux::alu_mod2: if_pcmux_out = {mem_monitor.mem_addr[31:1], 1'b0};
        pcmux::pc_jmp: if_pcmux_out = id_monitor.pc_wdata;
        pcmux::mem_pc_plus4: if_pcmux_out = mem_monitor.pc_plus4;
        default: `BAD_MUX_SEL;
    endcase
    
    unique case (wb_control.regfilemux_sel)
        regfilemux::alu_out: wb_regfilemux_out = wb_monitor.mem_addr;
        regfilemux::br_en: wb_regfilemux_out = {31'b0, wb_monitor.br_en};
        regfilemux::imm: wb_regfilemux_out = wb_control.imm;
        regfilemux::lw: wb_regfilemux_out = wb_monitor.mem_rdata;
        regfilemux::pc_plus4: wb_regfilemux_out = wb_monitor.pc_plus4;
        regfilemux::lb: 
            case (wb_monitor.mem_rmask)
                4'b0001: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[7:0]);
                4'b0010: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[15:8]);
                4'b0100: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[23:16]);
                4'b1000: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[31:24]);
                default: wb_regfilemux_out = 'x;
            endcase            
        regfilemux::lbu: 
            case (wb_monitor.mem_rmask)
                4'b0001: wb_regfilemux_out = wb_monitor.mem_rdata[7:0];
                4'b0010: wb_regfilemux_out = wb_monitor.mem_rdata[15:8];
                4'b0100: wb_regfilemux_out = wb_monitor.mem_rdata[23:16];
                4'b1000: wb_regfilemux_out = wb_monitor.mem_rdata[31:24];
                default: wb_regfilemux_out = 'x;
            endcase  
        regfilemux::lh: 
            case (wb_monitor.mem_rmask)
                4'b0011: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[15:0]);
                4'b0110: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[23:8]);
                4'b1100: wb_regfilemux_out = $signed(wb_monitor.mem_rdata[31:16]);
                default: wb_regfilemux_out = 'x;
            endcase  
        regfilemux::lhu: 
            case (wb_monitor.mem_rmask)
                4'b0011: wb_regfilemux_out = wb_monitor.mem_rdata[15:0];
                4'b0110: wb_regfilemux_out = wb_monitor.mem_rdata[23:8];
                4'b1100: wb_regfilemux_out = wb_monitor.mem_rdata[31:16];
                default: wb_regfilemux_out = 'x;
            endcase  
        default: `BAD_MUX_SEL;
    endcase
    
    unique case (ex_control.alumux1_sel)
        alumux::rs1_out: ex_alumux1_out = ex_rs1_rdata;
        alumux::pc_out: ex_alumux1_out = ex_monitor.pc_rdata;
        default: `BAD_MUX_SEL;
    endcase
    
    unique case (ex_control.alumux2_sel)
        alumux::imm: ex_alumux2_out = ex_control.imm;
        alumux::rs2_out: ex_alumux2_out = ex_rs2_rdata;
        default: `BAD_MUX_SEL;
    endcase
     
    unique case (ex_control.cmpmux_sel)
        cmpmux::rs2_out: ex_cmpmux_out = ex_rs2_rdata;
        cmpmux::imm: ex_cmpmux_out = ex_control.imm;
        default: `BAD_MUX_SEL;
    endcase
end

endmodule : pipeline_cpu
