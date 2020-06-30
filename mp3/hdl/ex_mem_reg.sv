import rv32i_types::*;

module ex_mem_reg
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [31:0] alu_result_in,
    input logic br_en_in,
    input logic [31:0] ex_rs1_rdata_in,
    input logic [31:0] ex_rs2_rdata_in,
    input RVFI_monitor_packet monitor_in,
    input RVFI_control_packet control_in,
    output RVFI_monitor_packet monitor_out,
    output RVFI_control_packet control_out
);

RVFI_monitor_packet monitor;
RVFI_control_packet control;

logic [31:0] alu_result;
logic br_en;
logic [31:0] ex_rs1_rdata;
logic [31:0] ex_rs2_rdata;

store_funct3_t store_funct3;
load_funct3_t load_funct3;
assign store_funct3 = store_funct3_t'(control.funct3);
assign load_funct3 = load_funct3_t'(control.funct3);

logic [1:0] mem_addr_unaligned;
assign mem_addr_unaligned = alu_result[1:0];

always_ff @(posedge clk)
begin
    if (rst)
    begin
        monitor <= '0;
        control <= '0;
        alu_result <= '0;
        br_en <= '0;
        ex_rs1_rdata <= '0;
        ex_rs2_rdata <= '0;
    end
    else if (load)
    begin
        monitor <= monitor_in;
        control <= control_in;
        alu_result <= alu_result_in;
        br_en <= br_en_in;
        ex_rs1_rdata <= ex_rs1_rdata_in;
        ex_rs2_rdata <= ex_rs2_rdata_in;
    end
    else
    begin
        monitor <= monitor;
        control <= control;
        alu_result <= alu_result;
        br_en <= br_en;
        ex_rs1_rdata <= ex_rs1_rdata;
        ex_rs2_rdata <= ex_rs2_rdata;
    end
end


always_comb 
begin
    monitor_out = monitor;
    control_out = control;
    monitor_out.br_en = br_en;
    monitor_out.mem_addr = alu_result;
    monitor_out.rs1_rdata = ex_rs1_rdata;
    monitor_out.rs2_rdata = ex_rs2_rdata;
    unique case (control_out.opcode)
        op_lui   : ;
        op_auipc : ;
        op_jal   : monitor_out.br_en = 1;
        op_jalr  : begin monitor_out.br_en = 1; control_out.pcmux_sel = pcmux::alu_mod2; end
        op_br    : control_out.pcmux_sel = pcmux::pcmux_sel_t'(br_en);
        op_load  : begin
            case(load_funct3)
                lb: 
                    case(mem_addr_unaligned)
                        2'b00: begin monitor_out.mem_rmask = 4'b0001; end
                        2'b01: begin monitor_out.mem_rmask = 4'b0010; end
                        2'b10: begin monitor_out.mem_rmask = 4'b0100; end
                        2'b11: begin monitor_out.mem_rmask = 4'b1000; end
                        default: monitor_out.mem_rmask = 4'bxxxx;
                    endcase
                lbu: 
                    case(mem_addr_unaligned)
                        2'b00: begin monitor_out.mem_rmask = 4'b0001; end
                        2'b01: begin monitor_out.mem_rmask = 4'b0010; end
                        2'b10: begin monitor_out.mem_rmask = 4'b0100; end
                        2'b11: begin monitor_out.mem_rmask = 4'b1000; end
                        default: monitor_out.mem_rmask = 4'bxxxx;
                    endcase
                lh:
                    case(mem_addr_unaligned)
                        2'b00: begin monitor_out.mem_rmask = 4'b0011; end
                        2'b01: begin monitor_out.mem_rmask = 4'b0110; end
                        2'b10: begin monitor_out.mem_rmask = 4'b1100; end
                        default: monitor_out.mem_rmask = 4'bxxxx;
                    endcase
                lhu:
                    case(mem_addr_unaligned)
                        2'b00: begin monitor_out.mem_rmask = 4'b0011; end
                        2'b01: begin monitor_out.mem_rmask = 4'b0110; end
                        2'b10: begin monitor_out.mem_rmask = 4'b1100; end
                        default: monitor_out.mem_rmask = 4'bxxxx;
                    endcase
                lw: begin monitor_out.mem_rmask = 4'b1111; end
            endcase
        end
        op_store : begin
            case(store_funct3)
                sb: 
                    case(mem_addr_unaligned)
                        2'b00: begin monitor_out.mem_wmask = 4'b0001; monitor_out.mem_wdata = monitor_out.rs2_rdata << 0; end
                        2'b01: begin monitor_out.mem_wmask = 4'b0010; monitor_out.mem_wdata = monitor_out.rs2_rdata << 8; end
                        2'b10: begin monitor_out.mem_wmask = 4'b0100; monitor_out.mem_wdata = monitor_out.rs2_rdata << 16; end
                        2'b11: begin monitor_out.mem_wmask = 4'b1000; monitor_out.mem_wdata = monitor_out.rs2_rdata << 24; end
                        default: monitor_out.mem_wmask = 4'bxxxx;
                    endcase
                sh:
                    case(mem_addr_unaligned)
                        2'b00: begin monitor_out.mem_wmask = 4'b0011; monitor_out.mem_wdata = monitor_out.rs2_rdata << 0; end
                        2'b01: begin monitor_out.mem_wmask = 4'b0110; monitor_out.mem_wdata = monitor_out.rs2_rdata << 8; end
                        2'b10: begin monitor_out.mem_wmask = 4'b1100; monitor_out.mem_wdata = monitor_out.rs2_rdata << 16; end
                        default: monitor_out.mem_wmask = 4'bxxxx;
                    endcase
                sw: begin monitor_out.mem_wmask = 4'b1111; monitor_out.mem_wdata = monitor_out.rs2_rdata; end
            endcase
        end
        op_imm   : ;
        op_reg   : ;
        op_csr   : ;
        op_nil   : ;
    endcase
end

endmodule : ex_mem_reg
