`define BAD_MUX_SEL $fatal("%0t %s %0d: Illegal mux select", $time, `__FILE__, `__LINE__)

import rv32i_types::*;

module datapath
(
    input clk,
    input rst,
    input load_mdr,
	 input load_ir,
	 input load_regfile,
	 input load_pc,
	 input load_mar,
    input rv32i_word mem_rdata,
	 input pcmux::pcmux_sel_t pcmux_sel,
	 input regfilemux::regfilemux_sel_t regfilemux_sel,
	 input alumux::alumux1_sel_t alumux1_sel,
	 input alumux::alumux2_sel_t alumux2_sel,
	 input marmux::marmux_sel_t marmux_sel,
	 input cmpmux::cmpmux_sel_t cmpmux_sel,
	 input alu_ops aluop,
	 input branch_funct3_t cmpop,
	 input load_data_out,
	 input logic [3:0] read_mask,
	 input logic [3:0] write_mask,
    output rv32i_word mem_wdata, // signal used by RVFI Monitor
    output rv32i_word mem_address,
	 output logic br_en,
	 output logic [2:0] funct3,
	 output logic [6:0] funct7,
	 output rv32i_opcode opcode,
	 output rv32i_reg rs1,
	 output rv32i_reg rs2,
	 output rv32i_word mem_addr_unaligned
);

/******************* Signals Needed for RVFI Monitor *************************/
rv32i_word pcmux_out;
rv32i_word mdrreg_out;
rv32i_word regfilemux_out;
rv32i_word alu_out;
rv32i_word rs1_out;
rv32i_word rs2_out;
rv32i_word pc_out;
rv32i_word marmux_out;
rv32i_word alumux1_out;
rv32i_word alumux2_out;
rv32i_word cmp_mux_out;
rv32i_word i_imm;
rv32i_word u_imm;
rv32i_word b_imm;
rv32i_word s_imm;
rv32i_word j_imm;
rv32i_reg rd;
rv32i_word load_shift;
rv32i_word mem_write_unshift;
rv32i_word mem_addr;
assign mem_addr = mem_address;
/*****************************************************************************/


/***************************** Registers *************************************/
// Keep Instruction register named `IR` for RVFI Monitor
ir IR( 
	 .clk (clk),
    .rst (rst),
    .load (load_ir),
    .in (mdrreg_out),
    .funct3 (funct3),
    .funct7 (funct7),
    .opcode (opcode),
    .i_imm (i_imm),
    .s_imm (s_imm),
    .b_imm (b_imm),
    .u_imm (u_imm),
    .j_imm (j_imm),
    .rs1 (rs1),
    .rs2 (rs2),
    .rd (rd)
);

register MDR(
    .clk  (clk),
    .rst (rst),
    .load (load_mdr),
    .in   (mem_rdata),
    .out  (mdrreg_out)
);

register MAR(
	 .clk (clk),
	 .rst (rst),
	 .load (load_mar),
	 .in (marmux_out),
	 .out (mem_addr_unaligned)
);

regfile regfile(    
	 .clk (clk),
    .rst (rst),
    .load (load_regfile),
    .in (regfilemux_out),
    .src_a (rs1), 
	 .src_b (rs2),
	 .dest (rd),
    .reg_a (rs1_out), 
	 .reg_b (rs2_out)
);

pc_register PC (
    .clk (clk),
    .rst (rst),
    .load (load_pc),
    .in (pcmux_out),
    .out (pc_out)
);

register mem_data_out(
	 .clk (clk),
	 .rst (rst),
	 .load (load_data_out),
	 .in (rs2_out),
	 .out (mem_write_unshift)
);

assign mem_address = {mem_addr_unaligned [31:2],2'b00};
always_comb begin
	casex (write_mask)
		4'bxxx1: mem_wdata = mem_write_unshift;
		4'bxx10: mem_wdata = mem_write_unshift << 8;
		4'bx100: mem_wdata = mem_write_unshift << 16;
		4'b1000: mem_wdata = mem_write_unshift << 24;
		default: mem_wdata = 'x;
	endcase
end
/*****************************************************************************/

/******************************* ALU and CMP *********************************/
alu ALU(
    .aluop (aluop),
    .a (alumux1_out),
	 .b (alumux2_out),
    .f (alu_out)	 
);

cmp CMP(
    .cmpop (cmpop),
    .a (rs1_out),
	 .b (cmp_mux_out),
    .f (br_en)
);
/*****************************************************************************/

/******************************** Muxes **************************************/
always_comb begin : MUXES
    // We provide one (incomplete) example of a mux instantiated using
    // a case statement.  Using enumerated types rather than bit vectors
    // provides compile time type safety.  Defensive programming is extremely
    // useful in SystemVerilog.  In this case, we actually use 
    // Offensive programming --- making simulation halt with a fatal message
    // warning when an unexpected mux select value occurs
    unique case (pcmux_sel)
        pcmux::pc_plus4: pcmux_out = pc_out + 4;
        pcmux::alu_out: pcmux_out = alu_out;
		  pcmux::alu_mod2: pcmux_out = {alu_out[31:1],1'b0};
        default: `BAD_MUX_SEL;
    endcase
	 
	 unique case (regfilemux_sel)
			regfilemux::alu_out: regfilemux_out = alu_out;
			regfilemux::br_en: regfilemux_out = {{31{1'b0}},br_en};
			regfilemux::u_imm: regfilemux_out = u_imm;
			regfilemux::lw: regfilemux_out = mdrreg_out[31:0];
			regfilemux::pc_plus4: regfilemux_out = pc_out + 4;                      
			regfilemux::lb: regfilemux_out = {{24{load_shift[7]}},load_shift[7:0]};
			regfilemux::lbu: regfilemux_out = {24'h000000,load_shift[7:0]};
			regfilemux::lh: regfilemux_out = {{16{load_shift[15]}},load_shift[15:0]};
			regfilemux::lhu: regfilemux_out = {16'h0000,load_shift[15:0]};
			default:`BAD_MUX_SEL;
	 endcase
	 
	 unique case (marmux_sel)
			marmux::pc_out: marmux_out = pc_out;
			marmux::alu_out: marmux_out = alu_out;
			default: `BAD_MUX_SEL;
	 endcase
	 
	 unique case (alumux1_sel)
			alumux::rs1_out: alumux1_out = rs1_out;         
			alumux::pc_out: alumux1_out = pc_out;
			default: `BAD_MUX_SEL;
	 endcase
	 
	 unique case (alumux2_sel)
			alumux::i_imm: alumux2_out = i_imm;
			alumux::u_imm:	alumux2_out = u_imm;
			alumux::b_imm: alumux2_out = b_imm;
			alumux::s_imm: alumux2_out = s_imm;
			alumux::j_imm: alumux2_out = j_imm;
			alumux::rs2_out: alumux2_out = rs2_out;       // need confirm
			default: `BAD_MUX_SEL;
	 endcase
	 
	 unique case (cmpmux_sel)
			cmpmux::rs2_out: cmp_mux_out = rs2_out; 
			cmpmux::i_imm: cmp_mux_out = i_imm;
			default: `BAD_MUX_SEL;
	 endcase
	 
end

always_comb begin	
	casex (read_mask)
		4'bxxx1: load_shift = mdrreg_out;
		4'bxx10: load_shift = mdrreg_out >> 8;
		4'bx100: load_shift = mdrreg_out >> 16;
		4'b1000: load_shift = mdrreg_out >> 24;
		default: load_shift = 'x;
	endcase
end
/*****************************************************************************/
endmodule : datapath

module cmp
(
	input branch_funct3_t cmpop,
	input [31:0] a,b,
	output logic f
);

always_comb
begin
	case (cmpop)
		beq: f = a == b ? '1 : '0;
		bne: f = a != b ? '1 : '0;
		blt: f = $signed(a) < $signed(b) ? '1 : '0;
		bge: f = ($signed(a) > $signed(b) || $signed(a) == $signed(b))? '1 : '0;
		bltu: f = a < b ? '1 : '0;
		bgeu: f = (a > b || a ==b) ? '1 : '0;
		default:;
	endcase
end

endmodule
