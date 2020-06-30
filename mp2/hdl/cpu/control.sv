import rv32i_types::*; /* Import types defined in rv32i_types.sv */

module control
(
    input clk,
    input rst,
    input rv32i_opcode opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic br_en,
    input logic [4:0] rs1,
    input logic [4:0] rs2,
	 input logic mem_resp,
	 input rv32i_word mem_addr_unaligned,
    output pcmux::pcmux_sel_t pcmux_sel,
    output alumux::alumux1_sel_t alumux1_sel,
    output alumux::alumux2_sel_t alumux2_sel,
    output regfilemux::regfilemux_sel_t regfilemux_sel,
    output marmux::marmux_sel_t marmux_sel,
    output cmpmux::cmpmux_sel_t cmpmux_sel,
    output alu_ops aluop,
	 output branch_funct3_t cmpop,
    output logic load_pc,
    output logic load_ir,
    output logic load_regfile,
    output logic load_mar,
    output logic load_mdr,
    output logic load_data_out,
	 output logic mem_read,
	 output logic mem_write,
	 output logic [3:0] mem_byte_enable,
	 output logic [3:0] read_mask,
	 output logic [3:0] write_mask
);


parameter SRLI = 7'b0000000;
parameter ADD = 7'b0000000;
/***************** USED BY RVFIMON --- ONLY MODIFY WHEN TOLD *****************/
logic trap;
logic [4:0] rs1_addr, rs2_addr;
logic [3:0] rmask, wmask;

branch_funct3_t branch_funct3;
store_funct3_t store_funct3;
load_funct3_t load_funct3;
arith_funct3_t arith_funct3;

assign arith_funct3 = arith_funct3_t'(funct3);
assign branch_funct3 = branch_funct3_t'(funct3);
assign load_funct3 = load_funct3_t'(funct3);
assign store_funct3 = store_funct3_t'(funct3);
assign rs1_addr = rs1;
assign rs2_addr = rs2;
assign read_mask = rmask;
assign write_mask = wmask;

always_comb
begin : trap_check
    trap = 0;
    rmask = '0;
    wmask = '0;

    case (opcode)
        op_lui, op_auipc, op_imm, op_reg, op_jal, op_jalr:;

        op_br: begin
            case (branch_funct3)
                beq, bne, blt, bge, bltu, bgeu:;
                default: trap = 1;
            endcase
        end

        op_load: begin
            case (load_funct3)
                lw: rmask = 4'b1111;
                lh, lhu:
						begin 
							case (mem_addr_unaligned[1:0])
								2'b00: rmask = 4'b0011 /* Modify for MP1 Final */ ;
								2'b01: rmask = 4'b0110;
								2'b10: rmask = 4'b1100;
								default: rmask = 4'bxxxx;
							endcase	
						end
                lb, lbu:
						begin
							case (mem_addr_unaligned[1:0])
								2'b00: rmask = 4'b0001 /* Modify for MP1 Final */ ;
								2'b01: rmask = 4'b0010;
								2'b10: rmask = 4'b0100;
								2'b11: rmask = 4'b1000;
							endcase
						end
                default: trap = 1;
            endcase
        end

        op_store: begin
            case (store_funct3)
                sw: wmask = 4'b1111;
                sh:
						begin
							case (mem_addr_unaligned[1:0])
								2'b00: wmask = 4'b0011 /* Modify for MP1 Final */ ;
								2'b01: wmask = 4'b0110;
								2'b10: wmask = 4'b1100;
								default: wmask = 4'bxxxx;
							endcase
						end
                sb: 
						begin 
							case (mem_addr_unaligned[1:0])
								2'b00: wmask = 4'b0001 /* Modify for MP1 Final */ ;
								2'b01: wmask = 4'b0010; 
								2'b10: wmask = 4'b0100;
								2'b11: wmask = 4'b1000;
							endcase
						end
                default: trap = 1;
            endcase
        end

        default: trap = 1;
    endcase
end
/*****************************************************************************/

enum int unsigned {
    /* List of states */
fetch_one, fetch_two, fetch_three, decode, judge_imm_state, judge_lr_ar_i, slti, sltiu, slli, srli,
srai, addi, ori, xori, andi, judge_reg_state, slt_r, sltru, sll_r, srl_r, sra_r, add_r, or_r, xor_r, and_r,
judge_br_state, beq_b, bne_b, blt_b, bge_b, bltu_b, bgeu_b, judge_load_type, judge_store_type,
judge_lr_ar_r, judge_add_sub, sub_r, load_w_one, load_w_two, load_w_three, store_w_one, store_w_two,
lui, auipc, store_w_three, jal, jalr, load_h_one, load_h_two, load_h_three, load_hu_one, load_hu_two, load_hu_three
, load_b_one, load_b_two, load_b_three, load_bu_one, load_bu_two, load_bu_three, store_h_one, store_h_two, store_h_three,
store_b_one, store_b_two, store_b_three
} state, next_state;

/************************* Function Definitions *******************************/
/**
 *  You do not need to use these functions, but it can be nice to encapsulate
 *  behavior in such a way.  For example, if you use the `loadRegfile`
 *  function, then you only need to ensure that you set the load_regfile bit
 *  to 1'b1 in one place, rather than in many.
 *
 *  SystemVerilog functions must take zero "simulation time" (as opposed to 
 *  tasks).  Thus, they are generally synthesizable, and appropraite
 *  for design code.  Arguments to functions are, by default, input.  But
 *  may be passed as outputs, inouts, or by reference using the `ref` keyword.
**/

/**
 *  Rather than filling up an always_block with a whole bunch of default values,
 *  set the default values for controller output signals in this function,
 *   and then call it at the beginning of your always_comb block.
**/
function void set_defaults();
    pcmux_sel = pcmux::pc_plus4;
    alumux1_sel = alumux::rs1_out;
    alumux2_sel = alumux::i_imm;
    regfilemux_sel = regfilemux::alu_out;
    marmux_sel = marmux::pc_out;
    cmpmux_sel = cmpmux::rs2_out;
    aluop = alu_ops'(funct3);
	 cmpop = branch_funct3_t'(funct3);
    load_pc = 1'b0;
    load_ir = 1'b0;
    load_regfile = 1'b0;
    load_mar = 1'b0;
    load_mdr = 1'b0;
    load_data_out = 1'b0;
	 mem_read = 1'b0;
	 mem_write = 1'b0;
	 mem_byte_enable = 4'b1111;
endfunction

/**
 *  Use the next several functions to set the signals needed to
 *  load various registers
**/
function void loadPC(pcmux::pcmux_sel_t sel);
    load_pc = 1'b1;
    pcmux_sel = sel;
endfunction

function void loadRegfile(regfilemux::regfilemux_sel_t sel);
	load_regfile = 1'b1;
	regfilemux_sel = sel;
endfunction

function void loadMAR(marmux::marmux_sel_t sel);
	load_mar = 1'b1;
	marmux_sel = sel;
endfunction

function void loadMDR();
	mem_read = 1'b1;
	load_mdr = 1'b1;
endfunction

function void loadIR();
	load_ir = 1'd1;
endfunction
/**
 * SystemVerilog allows for default argument values in a way similar to
 *   C++.
**/
function void setALU(alumux::alumux1_sel_t sel1,
                               alumux::alumux2_sel_t sel2,
                               logic setop = 1'b0, alu_ops op = alu_add);
    /* Student code here */
	 alumux1_sel = sel1;
	 alumux2_sel = sel2;
    if (setop)
        aluop = op; // else default value
endfunction

function automatic void setCMP(cmpmux::cmpmux_sel_t sel, branch_funct3_t op);
	 cmpmux_sel = sel;
	 cmpop = op;
endfunction

/*****************************************************************************/

    /* Remember to deal with rst signal */

always_comb
begin : state_actions
    /* Default output assignments */
    set_defaults();
    /* Actions for each state */
	 case (state)
			fetch_one: loadMAR(marmux::pc_out);
			fetch_two: loadMDR();
			fetch_three: loadIR();
			decode: ;                  // do nothing	
			
			// arithemetic instruction imm
			judge_imm_state: ;
			judge_lr_ar_i: ;
			slti: 
				begin
					setCMP(cmpmux::i_imm,blt);
					loadRegfile(regfilemux::br_en);
					loadPC(pcmux::pc_plus4);
				end
			sltiu:
				begin
					setCMP(cmpmux::i_imm,bltu);
					loadRegfile(regfilemux::br_en);
					loadPC(pcmux::pc_plus4);
				end
			slli:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_sll);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			srli:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_srl);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			srai:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_sra);					
					loadRegfile(regfilemux::alu_out);	
					loadPC(pcmux::pc_plus4);				
				end
			addi:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			ori:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_or);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);                                 // for test
				end
			xori:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_xor);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			andi:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_and);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			//arithemetic instruction reg
			judge_reg_state:;
			judge_add_sub:;
			slt_r:
				begin
					setCMP(cmpmux::rs2_out,blt);
					loadRegfile(regfilemux::br_en);	
					loadPC(pcmux::pc_plus4);
				end
			sltru:
				begin
					setCMP(cmpmux::rs2_out,bltu);
					loadRegfile(regfilemux::br_en);	
					loadPC(pcmux::pc_plus4);
				end
			sll_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_sll);
					loadRegfile(regfilemux::alu_out);	
					loadPC(pcmux::pc_plus4);			
				end
			srl_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_srl);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			sra_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_sra);					
					loadRegfile(regfilemux::alu_out);	
					loadPC(pcmux::pc_plus4);
				end
			add_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_add);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end	
			sub_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_sub);
					loadRegfile(regfilemux::alu_out);	
					loadPC(pcmux::pc_plus4);				
				end
			or_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_or);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end				
			xor_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_xor);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end		
			and_r:
				begin
					setALU(alumux::rs1_out,alumux::rs2_out,1'b1,alu_and);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end			
			// control instruction
			judge_br_state:;
			beq_b:                                                           // test 
				begin 
					setCMP(cmpmux::rs2_out,beq);
					if(br_en)
						begin
							setALU(alumux::pc_out,alumux::b_imm,1'b1,alu_add);
							loadPC(pcmux::alu_out);
						end
					else
						loadPC(pcmux::pc_plus4);
				end
			bne_b: 
				begin
					setCMP(cmpmux::rs2_out,bne);	
					if(br_en)
						begin
							setALU(alumux::pc_out,alumux::b_imm,1'b1,alu_add);
							loadPC(pcmux::alu_out);
						end
					else
						loadPC(pcmux::pc_plus4);
				end
			blt_b: 
				begin
					setCMP(cmpmux::rs2_out,blt);
					if(br_en)
						begin
							setALU(alumux::pc_out,alumux::b_imm,1'b1,alu_add);
							loadPC(pcmux::alu_out);
						end
					else
						loadPC(pcmux::pc_plus4);
				end
			bge_b: 
				begin
					setCMP(cmpmux::rs2_out,bge);
					if(br_en)
						begin
							setALU(alumux::pc_out,alumux::b_imm,1'b1,alu_add);
							loadPC(pcmux::alu_out);
						end
					else
						loadPC(pcmux::pc_plus4);
				end
			bltu_b: 
				begin
					setCMP(cmpmux::rs2_out,bltu);
					if(br_en)
						begin
							setALU(alumux::pc_out,alumux::b_imm,1'b1,alu_add);
							loadPC(pcmux::alu_out);
						end
					else
						loadPC(pcmux::pc_plus4);
				end
			bgeu_b: 
				begin
					setCMP(cmpmux::rs2_out,bgeu);
					if(br_en)
						begin
							setALU(alumux::pc_out,alumux::b_imm,1'b1,alu_add);
							loadPC(pcmux::alu_out);
						end
					else
						loadPC(pcmux::pc_plus4);

				end
			// load
			judge_load_type:;
			load_w_one:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);
					loadMAR(marmux::alu_out);
				end
			load_w_two: loadMDR();
			load_w_three:
				begin
					loadRegfile(regfilemux::lw);
					loadPC(pcmux::pc_plus4);
				end
				
			load_h_one:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);					
					loadMAR(marmux::alu_out);
				end
			load_h_two: loadMDR();
			load_h_three:
				begin
					loadRegfile(regfilemux::lh);
					loadPC(pcmux::pc_plus4);
				end

			load_hu_one:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);					
					loadMAR(marmux::alu_out);
				end
			load_hu_two: loadMDR();
			load_hu_three:
				begin
					loadRegfile(regfilemux::lhu);
					loadPC(pcmux::pc_plus4);
				end			
				
			load_b_one:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);					
					loadMAR(marmux::alu_out);
				end
			load_b_two: loadMDR();
			load_b_three:
				begin
					loadRegfile(regfilemux::lb);
					loadPC(pcmux::pc_plus4);
				end	
		
			load_bu_one:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);					
					loadMAR(marmux::alu_out);
				end
			load_bu_two: loadMDR();
			load_bu_three:
				begin
					loadRegfile(regfilemux::lbu);
					loadPC(pcmux::pc_plus4);
				end			
			// store
			judge_store_type:;
			// w
			store_w_one:
				begin
					setALU(alumux::rs1_out,alumux::s_imm,1'b1,alu_add);
					loadMAR(marmux::alu_out);
					load_data_out = 1'b1;
				end
			store_w_two: 
				begin
					mem_byte_enable = wmask;
					mem_write = 1'b1;
				end
			store_w_three:
				loadPC(pcmux::pc_plus4);
			// h
			store_h_one:
				begin
					setALU(alumux::rs1_out,alumux::s_imm,1'b1,alu_add);
					loadMAR(marmux::alu_out);
					load_data_out = 1'b1;
				end
			store_h_two: 
				begin
					mem_byte_enable = wmask;
					mem_write = 1'b1;
				end
			store_h_three:
				loadPC(pcmux::pc_plus4);			
			// b
			store_b_one:
				begin
					setALU(alumux::rs1_out,alumux::s_imm,1'b1,alu_add);
					loadMAR(marmux::alu_out);
					load_data_out = 1'b1;
				end
			store_b_two: 
				begin
					mem_byte_enable = wmask;
					mem_write = 1'b1;
				end
			store_b_three:
				loadPC(pcmux::pc_plus4);				
			// u type
			lui:
				begin
					loadRegfile(regfilemux::u_imm);
					loadPC(pcmux::pc_plus4);
				end
			auipc:
				begin
					setALU(alumux::pc_out,alumux::u_imm,1'b1,alu_add);
					loadRegfile(regfilemux::alu_out);
					loadPC(pcmux::pc_plus4);
				end
			// unconditional jump
			jal:
				begin
					setALU(alumux::pc_out,alumux::j_imm,1'b1,alu_add);
					loadPC(pcmux::alu_out);
					loadRegfile(regfilemux::pc_plus4);
				end
			jalr:
				begin
					setALU(alumux::rs1_out,alumux::i_imm,1'b1,alu_add);
					loadPC(pcmux::alu_mod2);
					loadRegfile(regfilemux::pc_plus4);
				end
			default:;
	 endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
	  
	 case (state)
			fetch_one: next_state = fetch_two;
			fetch_two: 
				begin
					if(mem_resp)
						next_state = fetch_three;
					else
						next_state = fetch_two;
				end
			fetch_three: next_state = decode;
			decode: 
				begin
					case (opcode)
						op_imm: next_state = judge_imm_state;
						op_br: next_state = judge_br_state;
						op_reg: next_state = judge_reg_state;
						op_load: next_state = judge_load_type;
						op_store: next_state = judge_store_type;
						op_lui: next_state = lui;
						op_auipc: next_state = auipc;
						op_jal: next_state = jal;
						op_jalr: next_state = jalr;
						default: next_state = fetch_one;
					endcase
				end
				
			// arithemetic instruction	imm
			judge_imm_state:
				begin 
					case(arith_funct3)
						add: next_state = addi;
						sll: next_state = slli;
						slt: next_state = slti;
						sltu: next_state = sltiu;
						axor: next_state = xori;
						sr: next_state = judge_lr_ar_i;
						aor: next_state = ori;
						aand: next_state = andi;
						default: next_state = fetch_one;
					endcase
				end		
			judge_lr_ar_i:
				begin
					if (funct7 == SRLI)
						next_state = srli;
					else
						next_state = srai;
				end
			slti: next_state = fetch_one;
			sltiu: next_state = fetch_one;
			slli: next_state = fetch_one;
			srli: next_state = fetch_one;
			srai: next_state = fetch_one;
			addi: next_state = fetch_one;
			ori: next_state = fetch_one;          // for test
 			xori: next_state = fetch_one;
			andi: next_state = fetch_one;
			
			//arithemetic instruction reg
			judge_reg_state:
				begin
					case(arith_funct3)
						add: next_state = judge_add_sub;
						sll: next_state = sll_r;
						slt: next_state = slt_r;
						sltu: next_state = sltru;
						axor: next_state = xor_r;
						sr: next_state = judge_lr_ar_r;
						aor: next_state = or_r;
						aand: next_state = and_r;
						default: next_state = fetch_one;
					endcase
				end
			judge_lr_ar_r:
				begin
					if (funct7 == SRLI)
						next_state = srl_r;
					else
						next_state = sra_r;
				end		
			judge_add_sub:
				begin
					if (funct7 == ADD)
						next_state = add_r;
					else
						next_state = sub_r;
				end
			slt_r: next_state = fetch_one;
			sltru: next_state = fetch_one;
			sll_r: next_state = fetch_one;
			srl_r: next_state = fetch_one;
			sra_r: next_state = fetch_one;
			add_r: next_state = fetch_one;
			sub_r: next_state = fetch_one;
			or_r: next_state = fetch_one;
			xor_r: next_state = fetch_one;
			and_r: next_state = fetch_one;
			
			// control instruction	
			judge_br_state:
				begin
					case(branch_funct3)
						beq: next_state = beq_b;
						bne: next_state = bne_b;
						blt: next_state = blt_b;
						bge: next_state = bge_b;
						bltu: next_state = bltu_b;
						bgeu: next_state = bgeu_b;
						default: next_state = fetch_one;
					endcase
				end
			beq_b: next_state = fetch_one;
			bne_b: next_state = fetch_one;
			blt_b: next_state = fetch_one;					
			bge_b: next_state = fetch_one;				
			bltu_b: next_state = fetch_one;
			bgeu_b: next_state = fetch_one;

			// load
			judge_load_type:                   // currently only load word 
				begin
					case(load_funct3)
						lw: next_state = load_w_one;
						lh: next_state = load_h_one;
						lhu: next_state = load_hu_one;
						lb: next_state = load_b_one;
						lbu: next_state = load_bu_one;
						default: next_state = fetch_one;
					endcase
				end
			// w
			load_w_one:
				next_state = load_w_two;
			load_w_two:
				begin
					if (mem_resp)
						next_state = load_w_three;
					else
						next_state = load_w_two;
				end
			load_w_three:
				next_state = fetch_one;
			// h	
			load_h_one:
				next_state = load_h_two;
			load_h_two:
				begin
					if (mem_resp)
						next_state = load_h_three;
					else
						next_state = load_h_two;
				end
			load_h_three:
				next_state = fetch_one;
			// hu
			load_hu_one:
				next_state = load_hu_two;
			load_hu_two:
				begin
					if (mem_resp)
						next_state = load_hu_three;
					else
						next_state = load_hu_two;
				end
			load_hu_three:
				next_state = fetch_one;			
			// b
			load_b_one:
				next_state = load_b_two;
			load_b_two:
				begin
					if (mem_resp)
						next_state = load_b_three;
					else
						next_state = load_b_two;
				end
			load_b_three:
				next_state = fetch_one;				
			// bu
			load_bu_one:
				next_state = load_bu_two;
			load_bu_two:
				begin
					if (mem_resp)
						next_state = load_bu_three;
					else
						next_state = load_bu_two;
				end
			load_bu_three:
				next_state = fetch_one;					
		
			// store                      
			judge_store_type:                 // currently only store word
				begin
					case (store_funct3)
						sw: next_state = store_w_one;
						sh: next_state = store_h_one;
						sb: next_state = store_b_one;
						default: next_state = fetch_one;
					endcase
				end 
			// w
			store_w_one:
				next_state = store_w_two;
			store_w_two:
				begin
					if (mem_resp)
						next_state = store_w_three;
					else
						next_state = store_w_two;
				end	
			store_w_three:
				next_state = fetch_one;
			// h
			store_h_one:
				next_state = store_h_two;
			store_h_two:
				begin
					if (mem_resp)
						next_state = store_h_three;
					else
						next_state = store_h_two;
				end	
			store_h_three:
				next_state = fetch_one;					
			// b
			store_b_one:
				next_state = store_b_two;
			store_b_two:
				begin
					if (mem_resp)
						next_state = store_b_three;
					else
						next_state = store_b_two;
				end	
			store_b_three:
				next_state = fetch_one;			
			// u type
			lui: next_state = fetch_one;
			auipc: next_state = fetch_one;
			// unconditional jump
			jal: next_state = fetch_one;
			jalr: next_state = fetch_one;
			default: next_state = fetch_one;
	 endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    /* Assignment of next state on clock edge */
	 if (rst) 
		begin
			state <= fetch_one;
		end
	 else
		begin
			state <= next_state;
		end
end

endmodule : control
