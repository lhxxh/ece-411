import rv32i_types::*;

module if_id_reg
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [31:0] instruction_in,
    input logic [31:0] pc_in, pc_plus4_in,
    output RVFI_monitor_packet monitor_out,
    output RVFI_control_packet control_out,
    output logic direct_jump
);

logic [31:0] instruction;
logic [31:0] pc;
logic [31:0] pc_plus4;

logic [31:0] i_imm, s_imm, b_imm, u_imm, j_imm, r_imm;

arith_funct3_t arith_funct3;
load_funct3_t load_funct3;
assign arith_funct3 = arith_funct3_t'(instruction[14:12]);
assign load_funct3 = load_funct3_t'(instruction[14:12]);

assign i_imm = {{21{instruction[31]}}, instruction[30:20]};
assign s_imm = {{21{instruction[31]}}, instruction[30:25], instruction[11:7]};
assign b_imm = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
assign u_imm = {instruction[31:12], 12'h000};
assign j_imm = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
assign r_imm = '0;

function void set_defaults();
    monitor_out.instruction = instruction;
    monitor_out.rs1 = instruction[19:15];
    monitor_out.rs2 = instruction[24:20];
    monitor_out.rd = instruction[11:7];
    monitor_out.rs1_rdata = 'x;
    monitor_out.rs2_rdata = 'x;
    monitor_out.rd_wdata = 'x;
    monitor_out.pc_rdata = pc;
    monitor_out.pc_wdata = 'x;
    monitor_out.mem_addr = 'x;
    monitor_out.mem_rmask = '0;
    monitor_out.mem_wmask = '0;
    monitor_out.mem_rdata = 'x;
    monitor_out.mem_wdata = 'x;
    monitor_out.br_en = 'x;
    monitor_out.pc_plus4 = pc_plus4;
    monitor_out.br_predict = 0;

    control_out.instruction = instruction;
    control_out.opcode = rv32i_opcode'(instruction[6:0]);
    control_out.funct3 = instruction[14:12];
    control_out.funct7 = instruction[31:25];
    control_out.imm = r_imm;
    control_out.alumux1_sel = alumux::rs1_out;
    control_out.alumux2_sel = alumux::imm;
    control_out.cmpmux_sel = cmpmux::rs2_out;
    control_out.alu_op = alu_ops'(control_out.funct3);
    control_out.cmp_op = branch_funct3_t'(control_out.funct3);
    control_out.pcmux_sel = pcmux::pc_plus4;
    control_out.mem_read = '0;
    control_out.mem_write = '0;
    control_out.regfile_write = '0;
    control_out.regfilemux_sel = regfilemux::alu_out;
    control_out.is_valid_instruction = 1;

    direct_jump = 0;
endfunction


always_ff @(posedge clk)
begin
    if (rst)
    begin
        instruction <= '0;
        pc <= '0;
        pc_plus4 <= '0;
    end
    else if (load)
    begin
        instruction <= instruction_in;
        pc <= pc_in;
        pc_plus4 <= pc_plus4_in;
    end
    else
    begin
        instruction <= instruction;
        pc <= pc;
        pc_plus4 <= pc_plus4;
    end
end

always_comb 
begin
    set_defaults();
    unique case (control_out.opcode)
        op_lui   : begin
            monitor_out.rs1 = '0;
            monitor_out.rs2 = '0;
            control_out.imm = u_imm;
            control_out.regfile_write = 1'b1; 
            control_out.regfilemux_sel = regfilemux::imm;
        end

        op_auipc : begin
            monitor_out.rs1 = '0;
            monitor_out.rs2 = '0;
            control_out.imm = u_imm;
            control_out.alumux1_sel = alumux::pc_out; 
            control_out.alu_op = alu_add;
            control_out.regfile_write = 1'b1;
        end

        op_jal   : begin
            monitor_out.rs1 = '0;
            monitor_out.rs2 = '0;
            control_out.imm = j_imm;
            direct_jump = 1;
            control_out.alumux1_sel = alumux::pc_out; 
            control_out.alu_op = alu_add;
            control_out.regfile_write = 1'b1; 
            control_out.regfilemux_sel = regfilemux::pc_plus4;
            monitor_out.pc_wdata = j_imm + pc;
        end

        op_jalr  : begin
            monitor_out.rs2 = '0;
            control_out.imm = i_imm;
            control_out.alu_op = alu_add;
            control_out.pcmux_sel = pcmux::alu_mod2;
            control_out.regfile_write = 1'b1; 
            control_out.regfilemux_sel = regfilemux::pc_plus4;
        end

        op_br    : begin
            monitor_out.rd = '0;
            control_out.imm = b_imm;
            control_out.alumux1_sel = alumux::pc_out; 
            control_out.alu_op = alu_add;
            monitor_out.pc_wdata = b_imm + pc;
        end

        op_load  : begin
            monitor_out.rs2 = '0;
            control_out.imm = i_imm;
            control_out.alu_op = alu_add;
            control_out.mem_read = 1'b1;
            case (load_funct3)
                lb  : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::lb; end
                lh  : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::lh; end
                lw  : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::lw; end
                lbu : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::lbu; end
                lhu : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::lhu; end
            endcase
        end

        op_store : begin
            monitor_out.rd = '0;
            control_out.imm = s_imm;
            control_out.alu_op = alu_add;
            control_out.mem_write = 1'b1;
        end

        op_imm   : begin
            monitor_out.rs2 = '0;
            control_out.imm = i_imm;
            case (arith_funct3)
                slt  :  begin control_out.cmpmux_sel = cmpmux::imm; control_out.cmp_op = blt; end
                sltu :  begin control_out.cmpmux_sel = cmpmux::imm; control_out.cmp_op = bltu; end
                sr   :  if (control_out.funct7[5] == 1'b1) control_out.alu_op = alu_sra;
                default : ;
            endcase
            case (arith_funct3)
                slt : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::br_en; end
                sltu: begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::br_en; end
                sr  : begin control_out.regfile_write = 1'b1; end
                default : begin control_out.regfile_write = 1'b1; end
            endcase
        end

        op_reg   : begin
            control_out.imm = r_imm;
            case (arith_funct3)
                add  :  if (control_out.funct7[5] == 1'b1) begin control_out.alumux2_sel = alumux::rs2_out; control_out.alu_op = alu_sub; end
                        else control_out.alumux2_sel = alumux::rs2_out;
                slt  :  control_out.cmp_op = blt;
                sltu :  control_out.cmp_op = bltu;
                sr   :  if (control_out.funct7[5] == 1'b1) begin control_out.alumux2_sel = alumux::rs2_out; control_out.alu_op = alu_sra; end
                        else control_out.alumux2_sel = alumux::rs2_out;
                default : control_out.alumux2_sel = alumux::rs2_out;
            endcase
            case (arith_funct3)
                add : begin control_out.regfile_write = 1'b1; end
                slt : begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::br_en; end
                sltu: begin control_out.regfile_write = 1'b1; control_out.regfilemux_sel = regfilemux::br_en; end
                sr  : begin control_out.regfile_write = 1'b1; end
                default : begin control_out.regfile_write = 1'b1; end
					 
            endcase
        end

        op_csr   : begin
            monitor_out.rs2 = '0;
            control_out.imm = i_imm;
        end

        op_nil   : begin
            monitor_out.rs1 = '0;
            monitor_out.rs2 = '0;
            monitor_out.rd = '0;
            control_out.is_valid_instruction = 0;
        end
    endcase
end

endmodule : if_id_reg
