module four_way_cache_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 3,   // 8 set 
    parameter s_tag    = 32 - s_offset - s_index,
	 parameter s_mask   = 2**s_offset,  // not used since write_enable is always '1
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
// interface between bus adaptor and cache
	input  logic clk,
	input  logic rst,
	input  logic [31:0] mem_address,   
	output logic [s_line-1:0] mem_rdata,
	input  logic [s_line-1:0] mem_wdata,
// interface between cache and cache adaptor
	output logic [31:0] pmem_address,   
	input  logic [s_line-1:0] pmem_rdata,
	output logic [s_line-1:0] pmem_wdata,
// interface between cache control and datapath
	//valid
	input  logic load_valid_one,
	output logic valid_one_output,
	input  logic load_valid_two,
	output logic valid_two_output,
	input  logic load_valid_three,
	output logic valid_three_output,
	input  logic load_valid_four,
	output logic valid_four_output,
	input  logic load_valid_five,
	output logic valid_five_output,
	input  logic load_valid_six,
	output logic valid_six_output,
	input  logic load_valid_seven,
	output logic valid_seven_output,
	input  logic load_valid_eight,
	output logic valid_eight_output,	
//dirty
	input  logic load_dirty_one,
	input  logic dirty_one_input,
	output logic dirty_one_output,
	input  logic load_dirty_two,
	input  logic dirty_two_input,
	output logic dirty_two_output,
	input  logic load_dirty_three,
	input  logic dirty_three_input,
	output logic dirty_three_output,
	input  logic load_dirty_four,
	input  logic dirty_four_input,
	output logic dirty_four_output,	
	input  logic load_dirty_five,
	input  logic dirty_five_input,
	output logic dirty_five_output,
	input  logic load_dirty_six,
	input  logic dirty_six_input,
	output logic dirty_six_output,
	input  logic load_dirty_seven,
	input  logic dirty_seven_input,
	output logic dirty_seven_output,
	input  logic load_dirty_eight,
	input  logic dirty_eight_input,
	output logic dirty_eight_output,		
//tag
	input  logic load_tag_one,
	output logic [s_tag-1:0] tag_one_output,
	input  logic load_tag_two,
	output logic [s_tag-1:0] tag_two_output,
	input  logic load_tag_three,
	output logic [s_tag-1:0] tag_three_output,
	input  logic load_tag_four,
	output logic [s_tag-1:0] tag_four_output,
	input  logic load_tag_five,
	output logic [s_tag-1:0] tag_five_output,
	input  logic load_tag_six,
	output logic [s_tag-1:0] tag_six_output,
	input  logic load_tag_seven,
	output logic [s_tag-1:0] tag_seven_output,
	input  logic load_tag_eight,
	output logic [s_tag-1:0] tag_eight_output,	
//lru
	input  logic load_lru,
	input  logic put_one_top_of_stack,
	input  logic put_two_top_of_stack,
	input  logic put_three_top_of_stack,
	input  logic put_four_top_of_stack,
	input  logic put_five_top_of_stack,
	input  logic put_six_top_of_stack,
	input  logic put_seven_top_of_stack,
	input  logic put_eight_top_of_stack,
	output logic [2:0] lru_output,
//compare
	output logic tag_one_equal,
	output logic tag_two_equal,
	output logic tag_three_equal,
	output logic tag_four_equal,
	output logic tag_five_equal,
	output logic tag_six_equal,
	output logic tag_seven_equal,
	output logic tag_eight_equal,	
//muxsel
	input logic data_one_input_mux_sel,
	input logic data_two_input_mux_sel,
	input logic data_three_input_mux_sel,
	input logic data_four_input_mux_sel,	
	input logic data_five_input_mux_sel,
	input logic data_six_input_mux_sel,
	input logic data_seven_input_mux_sel,
	input logic data_eight_input_mux_sel,	
//hit signal
	output logic hit_one_signal,
	output logic hit_two_signal,
	output logic hit_three_signal,
	output logic hit_four_signal,	
	output logic hit_five_signal,
	output logic hit_six_signal,
	output logic hit_seven_signal,
	output logic hit_eight_signal,		
//load register signal
	input logic load_cMAR,
	input logic load_cMDR,	
//write_enable
	input  logic [s_mask-1:0]write_enable_one,
	input  logic [s_mask-1:0]write_enable_two,
	input  logic [s_mask-1:0]write_enable_three,
	input  logic [s_mask-1:0]write_enable_four,
	input  logic [s_mask-1:0]write_enable_five,
	input  logic [s_mask-1:0]write_enable_six,
	input  logic [s_mask-1:0]write_enable_seven,
	input  logic [s_mask-1:0]write_enable_eight
);
// signals
logic [31:0] write_back_address;
logic [s_tag-1:0] tag_mux_out;
logic [31:0] address_mux_out;
logic [s_line-1:0] write_back_data;
logic [s_line-1:0] data_one_input;
logic [s_line-1:0] data_two_input;
logic [s_line-1:0] data_one_output;
logic [s_line-1:0] data_two_output;
logic [s_line-1:0] data_three_input;
logic [s_line-1:0] data_four_input;
logic [s_line-1:0] data_three_output;
logic [s_line-1:0] data_four_output;
logic [s_line-1:0] data_five_input;
logic [s_line-1:0] data_six_input;
logic [s_line-1:0] data_five_output;
logic [s_line-1:0] data_six_output;
logic [s_line-1:0] data_seven_input;
logic [s_line-1:0] data_eight_input;
logic [s_line-1:0] data_seven_output;
logic [s_line-1:0] data_eight_output;

assign hit_one_signal = valid_one_output & tag_one_equal;
assign hit_two_signal = valid_two_output & tag_two_equal;
assign hit_three_signal = valid_three_output & tag_three_equal;
assign hit_four_signal = valid_four_output & tag_four_equal;
assign hit_five_signal = valid_five_output & tag_five_equal;
assign hit_six_signal = valid_six_output & tag_six_equal;
assign hit_seven_signal = valid_seven_output & tag_seven_equal;
assign hit_eight_signal = valid_eight_output & tag_eight_equal;

// write_back aligner module
assign write_back_address = {tag_mux_out[s_tag-1:0],mem_address[(s_index + 4):5],5'b00000};

// array register 
data_array #(.s_offset(s_offset), .s_index(s_index)) data_one  ( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_one),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_one_input),.dataout(data_one_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_two  ( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_two),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_two_input),.dataout(data_two_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_three( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_three),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_three_input),.dataout(data_three_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_four ( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_four),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_four_input),.dataout(data_four_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_five  ( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_five),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_five_input),.dataout(data_five_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_six  ( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_six),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_six_input),.dataout(data_six_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_seven( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_seven),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_seven_input),.dataout(data_seven_output));
data_array #(.s_offset(s_offset), .s_index(s_index)) data_eight ( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_eight),
																					  .rindex(mem_address[(s_index + 4):5]), .windex(mem_address[(s_index + 4):5]), 
																					  .datain(data_eight_input),.dataout(data_eight_output));																					  
																					
array #(.s_index(s_index), .width(1)) valid_one  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_one),.rindex(mem_address[(s_index + 4):5]),
																   .windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_one_output));
array #(.s_index(s_index), .width(1)) valid_two  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_two),.rindex(mem_address[(s_index + 4):5]),
																   .windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_two_output));
array #(.s_index(s_index), .width(1)) valid_three( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_three),.rindex(mem_address[(s_index + 4):5]),
																	.windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_three_output));
array #(.s_index(s_index), .width(1)) valid_four ( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_four),.rindex(mem_address[(s_index + 4):5]),
																	.windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_four_output));					  
array #(.s_index(s_index), .width(1)) valid_five  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_five),.rindex(mem_address[(s_index + 4):5]),
																   .windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_five_output));
array #(.s_index(s_index), .width(1)) valid_six  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_six),.rindex(mem_address[(s_index + 4):5]),
																   .windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_six_output));
array #(.s_index(s_index), .width(1)) valid_seven( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_seven),.rindex(mem_address[(s_index + 4):5]),
																	.windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_seven_output));
array #(.s_index(s_index), .width(1)) valid_eight ( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_eight),.rindex(mem_address[(s_index + 4):5]),
																	.windex(mem_address[(s_index + 4):5]), .datain(1'b1), .dataout(valid_eight_output));	
										
										
array #(.s_index(s_index), .width(1)) dirty_one  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_one),.rindex(mem_address[(s_index + 4):5]),
																   .windex(mem_address[(s_index + 4):5]), .datain(dirty_one_input), .dataout(dirty_one_output));
array #(.s_index(s_index), .width(1)) dirty_two  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_two),.rindex(mem_address[(s_index + 4):5]), 
																   .windex(mem_address[(s_index + 4):5]), .datain(dirty_two_input), .dataout(dirty_two_output));
array #(.s_index(s_index), .width(1)) dirty_three( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_three),.rindex(mem_address[(s_index + 4):5]),
																	.windex(mem_address[(s_index + 4):5]), .datain(dirty_three_input), .dataout(dirty_three_output));
array #(.s_index(s_index), .width(1)) dirty_four ( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_four), .rindex(mem_address[(s_index + 4):5]), 
																   .windex(mem_address[(s_index + 4):5]), .datain(dirty_four_input), .dataout(dirty_four_output));
array #(.s_index(s_index), .width(1)) dirty_five  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_five),.rindex(mem_address[(s_index + 4):5]),
																   .windex(mem_address[(s_index + 4):5]), .datain(dirty_five_input), .dataout(dirty_five_output));
array #(.s_index(s_index), .width(1)) dirty_six  ( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_six),.rindex(mem_address[(s_index + 4):5]), 
																   .windex(mem_address[(s_index + 4):5]), .datain(dirty_six_input), .dataout(dirty_six_output));
array #(.s_index(s_index), .width(1)) dirty_seven( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_seven),.rindex(mem_address[(s_index + 4):5]),
																	.windex(mem_address[(s_index + 4):5]), .datain(dirty_seven_input), .dataout(dirty_seven_output));
array #(.s_index(s_index), .width(1)) dirty_eight ( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_eight), .rindex(mem_address[(s_index + 4):5]), 
																   .windex(mem_address[(s_index + 4):5]), .datain(dirty_eight_input), .dataout(dirty_eight_output));
										
										
array #(.s_index(s_index), .width(s_tag)) tag_one 	( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_one),.rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_one_output));
array #(.s_index(s_index), .width(s_tag)) tag_two 	( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_two), .rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_two_output));
array #(.s_index(s_index), .width(s_tag)) tag_three( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_three),.rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_three_output));
array #(.s_index(s_index), .width(s_tag)) tag_four ( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_four), .rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_four_output));											 
array #(.s_index(s_index), .width(s_tag)) tag_five 	( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_five),.rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_five_output));
array #(.s_index(s_index), .width(s_tag)) tag_six 	( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_six), .rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_six_output));
array #(.s_index(s_index), .width(s_tag)) tag_seven( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_seven),.rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_seven_output));
array #(.s_index(s_index), .width(s_tag)) tag_eight ( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_eight), .rindex(mem_address[(s_index + 4):5]),
																	  .windex(mem_address[(s_index + 4):5]), .datain(mem_address[31:(s_index + s_offset)]), .dataout(tag_eight_output));											 
										  
lru_array lru (.clk(clk), .rst(rst), .read(1'b1), .load(load_lru),.rindex(mem_address[(s_index + 4):5]),
			  .windex(mem_address[(s_index + 4):5]), .put_one_top_of_stack(put_one_top_of_stack),
			  .put_two_top_of_stack(put_two_top_of_stack), .put_three_top_of_stack(put_three_top_of_stack), 
			  .put_four_top_of_stack(put_four_top_of_stack), .put_five_top_of_stack(put_five_top_of_stack),
			  .put_six_top_of_stack(put_six_top_of_stack) , .put_seven_top_of_stack(put_seven_top_of_stack),
			  .put_eight_top_of_stack(put_eight_top_of_stack), .dataout(lru_output));
									 
// register to memory
register cMAR( .clk(clk), .rst(rst), .load(load_cMAR),
					.in(address_mux_out), .out(pmem_address));
register # (.width(s_line)) cMDR( .clk(clk), .rst(rst),
				.load(load_cMDR), .in(write_back_data), .out(pmem_wdata));
				
always_comb begin
// for purpose of hitting check 
////////////////////////////////////////////////////////////////////////
if (tag_one_output == mem_address[31:(s_index + s_offset)])
	tag_one_equal = 1'b1;
else
	tag_one_equal = 1'b0;
	
if(tag_two_output == mem_address[31:(s_index + s_offset)])
	tag_two_equal = 1'b1;
else
	tag_two_equal = 1'b0;
	
if(tag_three_output == mem_address[31:(s_index + s_offset)])
	tag_three_equal = 1'b1;
else
	tag_three_equal = 1'b0;
	
if(tag_four_output == mem_address[31:(s_index + s_offset)])
	tag_four_equal = 1'b1;
else
	tag_four_equal = 1'b0;
	
if (tag_five_output == mem_address[31:(s_index + s_offset)])
	tag_five_equal = 1'b1;
else
	tag_five_equal = 1'b0;
	
if(tag_six_output == mem_address[31:(s_index + s_offset)])
	tag_six_equal = 1'b1;
else
	tag_six_equal = 1'b0;
	
if(tag_seven_output == mem_address[31:(s_index + s_offset)])
	tag_seven_equal = 1'b1;
else
	tag_seven_equal = 1'b0;
	
if(tag_eight_output == mem_address[31:(s_index + s_offset)])
	tag_eight_equal = 1'b1;
else
	tag_eight_equal = 1'b0;	
	
if (hit_one_signal)
	mem_rdata = data_one_output;
else if(hit_two_signal)
	mem_rdata = data_two_output;
else if(hit_three_signal)
	mem_rdata = data_three_output;
else if(hit_four_signal)
	mem_rdata = data_four_output;
else if (hit_five_signal)
	mem_rdata = data_five_output;
else if(hit_six_signal)
	mem_rdata = data_six_output;
else if(hit_seven_signal)
	mem_rdata = data_seven_output;
else if(hit_eight_signal)
	mem_rdata = data_eight_output;	
else
	mem_rdata = '0;	
///////////////////////////////////////////////////////////////////////
	
// for purpose of wrting back address + data	
//////////////////////////////////////////////////////////////////////
if(lru_output == 3'd7)
	tag_mux_out = tag_eight_output;
else if(lru_output == 3'd6)
	tag_mux_out = tag_seven_output;
else if(lru_output == 3'd5)
	tag_mux_out = tag_six_output;
else if(lru_output == 3'd4)
	tag_mux_out = tag_five_output;
else if(lru_output == 2'd3)
	tag_mux_out = tag_four_output;
else if(lru_output == 2'd2)
	tag_mux_out = tag_three_output;
else if(lru_output == 2'd1)
	tag_mux_out = tag_two_output;
else
	tag_mux_out = tag_one_output;
	
// write_back data mux
if(lru_output == 3'd7)
	write_back_data = data_eight_output;
else if(lru_output == 3'd6)
	write_back_data = data_seven_output;
else if(lru_output == 3'd5)
	write_back_data = data_six_output;
else if(lru_output == 3'd4)
	write_back_data = data_five_output;
else if(lru_output == 2'd3)
	write_back_data = data_four_output;
else if(lru_output == 2'd2)
	write_back_data = data_three_output;
else if(lru_output == 2'd1)
	write_back_data = data_two_output;
else  
	write_back_data = data_one_output;
//////////////////////////////////////////////////////////////////////

// for purpose of checking writing back or loading new cache line
//////////////////////////////////////////////////////////////////////
//in case of hit,no matter we choose, just do not load into register cMAR
if	((lru_output == 3'd3 && dirty_four_output) || (lru_output == 3'd2 && dirty_three_output) || (lru_output == 3'd1 && dirty_two_output) || (lru_output == 3'd0 && dirty_one_output) ||
					(lru_output == 3'd7 && dirty_eight_output) || (lru_output == 3'd6 && dirty_seven_output) || (lru_output == 3'd5 && dirty_six_output) || (lru_output == 3'd4 && dirty_five_output))
	address_mux_out = write_back_address;
else if((lru_output == 3'd3 && !dirty_four_output) || (lru_output == 3'd2 && !dirty_three_output) || (lru_output == 3'd1 && !dirty_two_output) || (lru_output == 3'd0 && !dirty_one_output) 
							|| (lru_output == 3'd7 && !dirty_eight_output) || (lru_output == 3'd6 && !dirty_seven_output) || (lru_output == 3'd5 && !dirty_six_output) || (lru_output == 3'd4 && !dirty_five_output))
	address_mux_out = {mem_address[31:(s_offset)],5'b00000};
else 
	address_mux_out = '0;
//////////////////////////////////////////////////////////////////////

// for purpose of writing into cache or read new cache line
//////////////////////////////////////////////////////////////////////
if (data_one_input_mux_sel)
	data_one_input = pmem_rdata;
else
	data_one_input = mem_wdata;
	
if (data_two_input_mux_sel)
	data_two_input = pmem_rdata;
else
	data_two_input = mem_wdata;
	
if (data_three_input_mux_sel)
	data_three_input = pmem_rdata;
else
	data_three_input = mem_wdata;
	
if (data_four_input_mux_sel)
	data_four_input = pmem_rdata;
else
	data_four_input = mem_wdata;
	
if (data_five_input_mux_sel)
	data_five_input = pmem_rdata;
else
	data_five_input = mem_wdata;
	
if (data_six_input_mux_sel)
	data_six_input = pmem_rdata;
else
	data_six_input = mem_wdata;
	
if (data_seven_input_mux_sel)
	data_seven_input = pmem_rdata;
else
	data_seven_input = mem_wdata;
	
if (data_eight_input_mux_sel)
	data_eight_input = pmem_rdata;
else
	data_eight_input = mem_wdata;	
//////////////////////////////////////////////////////////////////////	
end				

endmodule 
