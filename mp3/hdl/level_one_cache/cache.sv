module cache #(
    parameter s_offset = 5,
    parameter s_index  = 3,
    parameter s_tag    = 32 - s_offset - s_index,
    parameter s_mask   = 2**s_offset,
    parameter s_line   = 8*s_mask,
    parameter num_sets = 2**s_index
)
(
input logic clk,
input logic rst,
input logic [31:0] mem_address,   
output logic [31:0] mem_rdata,
input logic [31:0] mem_wdata,
input logic mem_read,
input logic mem_write,
input logic [3:0] mem_byte_enable,
output logic mem_resp,
output logic [31:0] pmem_address,   
input logic	[255:0] pmem_rdata,
output logic [255:0] pmem_wdata,
output logic pmem_read,
output logic pmem_write,
input logic pmem_resp	
);
// internel logic
logic [255:0] data_write_to_cache;
logic [255:0] data_read_from_cache;
logic [31:0]  write_data_byte_enable_cache;
//data
logic [s_mask-1:0]write_enable_one;
logic [s_mask-1:0]write_enable_two;
//valid
logic load_valid_one;
logic valid_one_output;
logic load_valid_two;
logic valid_two_output;
//dirty
logic load_dirty_one;
logic dirty_one_input;
logic dirty_one_output;
logic load_dirty_two;
logic dirty_two_input;
logic dirty_two_output;
//tag
logic load_tag_one;
logic [s_tag-1:0] tag_one_output;
logic load_tag_two;
logic [s_tag-1:0] tag_two_output;
//lru
logic load_lru;
logic lru_input;
logic lru_output;
//compare
logic tag_one_equal;
logic tag_two_equal;
//muxsel
logic data_one_input_mux_sel;
logic data_two_input_mux_sel;
//hit signal
logic hit_one_signal;
logic hit_two_signal;
//load register signal
logic load_cMAR;
logic load_cMDR;
//counter
logic cache_hit_counter_increment;
logic cache_miss_counter_increment;
//to counter 
logic [31:0] cache_hit_counter_output;
logic [31:0] cache_miss_counter_output;
cache_control control
(
.*
);

cache_datapath datapath
(
.mem_rdata(data_read_from_cache), .mem_wdata(data_write_to_cache),
.*
);

bus_adapter bus_adapter
(
. mem_wdata256(data_write_to_cache),
. mem_rdata256(data_read_from_cache),
. mem_wdata(mem_wdata),
. mem_rdata(mem_rdata),
. mem_byte_enable(mem_byte_enable),
. mem_byte_enable256(write_data_byte_enable_cache),
. address(mem_address)
);

hit_and_miss_counter cache_counter
(
	.clk(clk),
	.rst(rst),
	.cache_hit_counter_increment(cache_hit_counter_increment),
	.cache_miss_counter_increment(cache_miss_counter_increment),
	.cache_hit_counter_output(cache_hit_counter_output),
	.cache_miss_counter_output(cache_miss_counter_output)
);

endmodule : cache
