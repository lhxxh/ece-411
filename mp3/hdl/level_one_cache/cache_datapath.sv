module cache_datapath #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
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
//data
input  logic [s_mask-1:0]write_enable_one,
input  logic [s_mask-1:0]write_enable_two,
//valid
input  logic load_valid_one,
output logic valid_one_output,
input  logic load_valid_two,
output logic valid_two_output,
//dirty
input  logic load_dirty_one,
input  logic dirty_one_input,
output logic dirty_one_output,
input  logic load_dirty_two,
input  logic dirty_two_input,
output logic dirty_two_output,
//tag
input  logic load_tag_one,
output logic [s_tag-1:0] tag_one_output,
input  logic load_tag_two,
output logic [s_tag-1:0] tag_two_output,
//lru
input  logic load_lru,
input  logic lru_input,
output logic lru_output,
//compare
output logic tag_one_equal,
output logic tag_two_equal,
//muxsel
input logic data_one_input_mux_sel,
input logic data_two_input_mux_sel,
//hit signal
output logic hit_one_signal,
output logic hit_two_signal,
//load register signal
input logic load_cMAR,
input logic load_cMDR
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

assign hit_one_signal = valid_one_output & tag_one_equal;
assign hit_two_signal = valid_two_output & tag_two_equal;
// write_back aligner module
assign write_back_address = {tag_mux_out[s_tag-1:0],mem_address[7:5],5'b00000};

// array register 
data_array data_one( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_one),
							.rindex(mem_address[7:5]), .windex(mem_address[7:5]), 
							.datain(data_one_input),.dataout(data_one_output));
data_array data_two( .clk(clk) , .rst(rst), .read(1'b1), .write_en(write_enable_two),
							.rindex(mem_address[7:5]), .windex(mem_address[7:5]), 
							.datain(data_two_input),.dataout(data_two_output));
							
array valid_one( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_one),
					  .rindex(mem_address[7:5]), .windex(mem_address[7:5]), .datain(1'b1), .dataout(valid_one_output));
array valid_two( .clk(clk), .rst(rst), .read(1'b1), .load(load_valid_two),
					  .rindex(mem_address[7:5]), .windex(mem_address[7:5]), .datain(1'b1), .dataout(valid_two_output));
					  
array dirty_one( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_one),
					  .rindex(mem_address[7:5]), .windex(mem_address[7:5]), .datain(dirty_one_input), .dataout(dirty_one_output));
array dirty_two( .clk(clk), .rst(rst), .read(1'b1), .load(load_dirty_two),
					  .rindex(mem_address[7:5]), .windex(mem_address[7:5]), .datain(dirty_two_input), .dataout(dirty_two_output));
					  
array # (.width(s_tag)) tag_one ( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_one),.rindex(mem_address[7:5]),
											 .windex(mem_address[7:5]), .datain(mem_address[31:8]), .dataout(tag_one_output));
array # (.width(s_tag)) tag_two ( .clk(clk), .rst(rst), .read(1'b1), .load(load_tag_two), .rindex(mem_address[7:5]),
											 .windex(mem_address[7:5]), .datain(mem_address[31:8]), .dataout(tag_two_output));

array lru( .clk(clk), .rst(rst), .read(1'b1), .load(load_lru),.rindex(mem_address[7:5]),
			  .windex(mem_address[7:5]), .datain(lru_input), .dataout(lru_output));              // output 1 means tag two, 0 means tag one

// register to memory
register cMAR( .clk(clk), .rst(rst), .load(load_cMAR),
					.in(address_mux_out), .out(pmem_address));
register # (.width(s_line)) cMDR( .clk(clk), .rst(rst),
				.load(load_cMDR), .in(write_back_data), .out(pmem_wdata));
				
always_comb begin
// compare module
if (tag_one_output == mem_address[31:8])
	tag_one_equal = 1'b1;
else
	tag_one_equal = 1'b0;
	
if(tag_two_output == mem_address[31:8])
	tag_two_equal = 1'b1;
else
	tag_two_equal = 1'b0;
// tag mux
if(lru_output)
	tag_mux_out = tag_two_output;
else
	tag_mux_out = tag_one_output;
// write_back data mux
if(lru_output)
	write_back_data = data_two_output;
else 
	write_back_data = data_one_output;
// address mux                            in case of hit,no matter we choose, just do not load into register cMAR
if (lru_output && dirty_two_output)
	address_mux_out = write_back_address;
else if (lru_output && !dirty_two_output)
	address_mux_out = {mem_address[31:5],5'b00000};
else if (!lru_output && dirty_one_output)
	address_mux_out = write_back_address;
else if (!lru_output && !dirty_one_output)
	address_mux_out = {mem_address[31:5],5'b00000};
else 
	address_mux_out = '0;
// data array input mux
if (data_one_input_mux_sel)
	data_one_input = pmem_rdata;
else
	data_one_input = mem_wdata;
	
if (data_two_input_mux_sel)
	data_two_input = pmem_rdata;
else
	data_two_input = mem_wdata;
// mem_rdata mux	
if (hit_one_signal)
	mem_rdata = data_one_output;
else if(hit_two_signal)
	mem_rdata = data_two_output;
else
	mem_rdata = '0;
	
end

endmodule : cache_datapath
