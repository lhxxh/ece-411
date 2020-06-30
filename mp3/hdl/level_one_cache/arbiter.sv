module arbiter
(
	input clk,
	input rst,
// inst to arbiter
	input logic [31:0] inst_addr_to_arbiter,
	output logic [255:0] inst_rdata_from_arbiter,
	input logic [255:0] inst_wdata_to_arbiter,
	input logic inst_read_to_arbiter,
	input logic inst_write_to_arbiter,
	output logic inst_resp_from_arbiter,
// data to arbiter
	input logic [31:0] data_addr_to_arbiter,
	output logic [255:0] data_rdata_from_arbiter,
	input logic [255:0] data_wdata_to_arbiter,
	input logic data_read_to_arbiter,
	input logic data_write_to_arbiter,
	output logic data_resp_from_arbiter,
// to level two cache
	output logic [31:0] addr_to_level_two_cache,
	input logic [255:0] rdata_from_level_two_cache,
	output logic [255:0] wdata_to_level_two_cache,
	output logic read_to_level_two_cache,
	output logic write_to_level_two_cache,
	input logic resp_from_level_two_cache
);
 
//	enum int unsigned {waiting, data_serving, inst_serving} state, next_state;	
//	logic data_request,inst_request;
//	logic [31:0] inst_addr_reg, data_addr_reg;
//	logic [255:0] inst_wdata_reg, data_wdata_reg;
//	logic inst_read_reg, data_read_reg;
//	logic inst_write_reg, data_write_reg;
//	logic resp_from_level_two_cache_reg;
//	logic load_new_value;
//	logic data_rdata_register_load, inst_rdata_register_load;
	 
//	assign data_request = data_read_reg || data_write_reg;
//	assign inst_request = inst_read_reg || inst_write_reg;
//	assign load_new_value = ((!resp_from_level_two_cache) & resp_from_level_two_cache_reg) ? 1'd1 : 1'd0;
	
//	function void serve_data();
//		addr_to_level_two_cache = data_addr_reg;
//		wdata_to_level_two_cache = data_wdata_reg;
//		read_to_level_two_cache = data_read_reg;
//		write_to_level_two_cache = data_write_reg;
//		if(load_new_value) 
//			begin
//				data_resp_from_arbiter = 1'd1;
////				data_rdata_from_arbiter = rdata_from_level_two_cache;
//				/////////////////////////////
//				data_rdata_register_load = 1'd1;
//			end
//	endfunction
//	
//	function void serve_inst();
//		addr_to_level_two_cache = inst_addr_reg;
//		wdata_to_level_two_cache = inst_wdata_reg;
//		read_to_level_two_cache = inst_read_reg;
//		write_to_level_two_cache = inst_write_reg;
//		if(load_new_value) 
//			begin
//				inst_resp_from_arbiter = 1'd1;
////				inst_rdata_from_arbiter = rdata_from_level_two_cache;
//				////////////////////////////
//				inst_rdata_register_load = 1'd1;
//			end	
//	endfunction
//	
//	function void default_value();
//		addr_to_level_two_cache = 'x;
//		wdata_to_level_two_cache = 'x;
//		read_to_level_two_cache = 1'b0;
//		write_to_level_two_cache = 1'b0;
//		data_resp_from_arbiter = 1'd0;
//		inst_resp_from_arbiter = 1'd0;
//		////////////////////////////
//		inst_rdata_register_load = 1'd0;	
//		data_rdata_register_load = 1'd0;
//	endfunction
//	
//	always_ff @ (posedge clk) 
//		begin
//			if(rst)
//				state <= waiting;
//			else
//				state <= next_state;
//		end
//		
//	always_ff @ (posedge clk)
//		begin
//			next_state <= state;
//			case (state)
//				waiting: begin if(data_request) next_state <= data_serving; else if(inst_request) next_state <= inst_serving; end
//				data_serving: 
//					begin 
//						if(load_new_value)
//							begin 
//								if(inst_request) next_state <= inst_serving;
//								else next_state <= waiting;
//							end
//					end
//				inst_serving: 
//					begin
//						if(load_new_value)
//							begin
//								if(data_request) next_state <= data_serving;
//								else next_state <= waiting;
//							end
//					end
//			endcase	
//		end
//		
//	always_comb
//		begin
//			default_value();
//			case(state)		
//				waiting: ;
//				data_serving: serve_data();
//				inst_serving: serve_inst();
//			endcase
//		end
//
//	register_posedge #(1) inst_read_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(inst_read_to_arbiter),
//		.out(inst_read_reg)
//	);
//
//	register_posedge #(1) inst_write_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(inst_write_to_arbiter),
//		.out(inst_write_reg)
//	);
//	
//	register_posedge #(32) inst_addr_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(inst_addr_to_arbiter),
//		.out(inst_addr_reg)
//	);	
//	
//	register_posedge #(256) inst_wdata_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(inst_wdata_to_arbiter),
//		.out(inst_wdata_reg)
//	);
//	
//	register_posedge #(1) data_read_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(data_read_to_arbiter),
//		.out(data_read_reg)
//	);
//
//	register_posedge #(1) data_write_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(data_write_to_arbiter),
//		.out(data_write_reg)
//	);
//	
//	register_posedge #(32) data_addr_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(data_addr_to_arbiter),
//		.out(data_addr_reg)
//	);	
//	
//	register_posedge #(256) data_wdata_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(data_wdata_to_arbiter),
//		.out(data_wdata_reg)
//	);	
//	
//	
//	// for purpose of read value from physical memory
//	register_posedge #(1) resp_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(1'd1),
//		.in(resp_from_level_two_cache),
//		.out(resp_from_level_two_cache_reg)
//	);	
//	
//	register_posedge #(256) data_rdata_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(data_rdata_register_load),
//		.in(rdata_from_level_two_cache),
//		.out(data_rdata_from_arbiter)	
//	);
//	
//	register_posedge #(256) inst_rdat_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(inst_rdata_register_load),
//		.in(rdata_from_level_two_cache),
//		.out(inst_rdata_from_arbiter)	
//	);


	logic data_request, inst_request;
	logic load_data, load_inst;
	logic served_data_or_inst;
	assign data_request = data_read_to_arbiter || data_write_to_arbiter;
	assign inst_request = inst_read_to_arbiter || inst_write_to_arbiter;
	
	always_comb 
		begin
			if(inst_request)
				begin
					addr_to_level_two_cache = inst_addr_to_arbiter; 
					wdata_to_level_two_cache = inst_wdata_to_arbiter;
					read_to_level_two_cache = inst_read_to_arbiter;
					write_to_level_two_cache = inst_write_to_arbiter;
					inst_resp_from_arbiter = resp_from_level_two_cache;
					data_resp_from_arbiter = 1'd0;	
//					data_rdata_from_arbiter = 'x;
//					inst_rdata_from_arbiter = rdata_from_level_two_cache;			
				end		
			else if(data_request)
				begin
					addr_to_level_two_cache = data_addr_to_arbiter; 
					wdata_to_level_two_cache = data_wdata_to_arbiter;
					read_to_level_two_cache = data_read_to_arbiter;
					write_to_level_two_cache = data_write_to_arbiter;
					data_resp_from_arbiter = resp_from_level_two_cache;
					inst_resp_from_arbiter = 1'd0;
//					data_rdata_from_arbiter = rdata_from_level_two_cache;					
//					inst_rdata_from_arbiter = 'x;
				end
			else
				begin
					addr_to_level_two_cache = 'x; 
					wdata_to_level_two_cache = 'x;
					read_to_level_two_cache = 1'd0;
					write_to_level_two_cache = 1'd0;
					data_resp_from_arbiter = 1'd0;
					inst_resp_from_arbiter = 1'd0;	
//					data_rdata_from_arbiter = 'x;
//					inst_rdata_from_arbiter = 'x;							
				end
		end
	
	always_ff @ (negedge clk)
		begin
			if (resp_from_level_two_cache && inst_request)
				served_data_or_inst <= 1'd1;			
			else if (resp_from_level_two_cache && data_request)
				served_data_or_inst <= 1'd0;  
			else
				served_data_or_inst <= served_data_or_inst;
		end
	
	always_comb 
		begin 
			if (served_data_or_inst)
				begin
					data_rdata_from_arbiter = 'x;
					inst_rdata_from_arbiter = rdata_from_level_two_cache;
				end
			else 
				begin
					data_rdata_from_arbiter = rdata_from_level_two_cache;
					inst_rdata_from_arbiter = 'x;
				end
		end
//	register_posedge #(256) data_rdata_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(data_resp_from_arbiter),
//		.in(rdata_from_level_two_cache),
//		.out(data_rdata_from_arbiter)	
//	);
//	
//	register_posedge #(256) inst_rdat_register
//	(
//		.clk(clk),
//		.rst(rst),
//		.load(inst_resp_from_arbiter),
//		.in(rdata_from_level_two_cache),
//		.out(inst_rdata_from_arbiter)	
//	);		
	
	endmodule
	