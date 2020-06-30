module four_way_cache #(
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
	output logic [255:0] mem_rdata,
	input logic [255:0] mem_wdata,
	input logic mem_read,
	input logic mem_write,
	output logic mem_resp,
	output logic [31:0] pmem_address,   
	input logic	[255:0] pmem_rdata,
	output logic [255:0] pmem_wdata,
	output logic pmem_read,
	output logic pmem_write,
	input logic pmem_resp
);

//data
logic [s_mask-1:0]write_enable_one;
logic [s_mask-1:0]write_enable_two;
logic [s_mask-1:0]write_enable_three;
logic [s_mask-1:0]write_enable_four;
logic [s_mask-1:0]write_enable_five;
logic [s_mask-1:0]write_enable_six;
logic [s_mask-1:0]write_enable_seven;
logic [s_mask-1:0]write_enable_eight;
//valid
logic load_valid_one;
logic valid_one_output;
logic load_valid_two;
logic valid_two_output;
logic load_valid_three;
logic valid_three_output;
logic load_valid_four;
logic valid_four_output;
logic load_valid_five;
logic valid_five_output;
logic load_valid_six;
logic valid_six_output;
logic load_valid_seven;
logic valid_seven_output;
logic load_valid_eight;
logic valid_eight_output;
//dirty
logic load_dirty_one;
logic dirty_one_input;
logic dirty_one_output;
logic load_dirty_two;
logic dirty_two_input;
logic dirty_two_output;
logic load_dirty_three;
logic dirty_three_input;
logic dirty_three_output;
logic load_dirty_four;
logic dirty_four_input;
logic dirty_four_output;
logic load_dirty_five;
logic dirty_five_input;
logic dirty_five_output;
logic load_dirty_six;
logic dirty_six_input;
logic dirty_six_output;
logic load_dirty_seven;
logic dirty_seven_input;
logic dirty_seven_output;
logic load_dirty_eight;
logic dirty_eight_input;
logic dirty_eight_output;
//tag
logic load_tag_one;
logic [s_tag-1:0] tag_one_output;
logic load_tag_two;
logic [s_tag-1:0] tag_two_output;
logic load_tag_three;
logic [s_tag-1:0] tag_three_output;
logic load_tag_four;
logic [s_tag-1:0] tag_four_output;
logic load_tag_five;
logic [s_tag-1:0] tag_five_output;
logic load_tag_six;
logic [s_tag-1:0] tag_six_output;
logic load_tag_seven;
logic [s_tag-1:0] tag_seven_output;
logic load_tag_eight;
logic [s_tag-1:0] tag_eight_output;
//lru
logic load_lru;
logic put_one_top_of_stack;
logic put_two_top_of_stack;
logic put_three_top_of_stack;
logic put_four_top_of_stack;
logic put_five_top_of_stack;
logic put_six_top_of_stack;
logic put_seven_top_of_stack;
logic put_eight_top_of_stack;
logic [2:0] lru_output;
//compare
logic tag_one_equal;
logic tag_two_equal;
logic tag_three_equal;
logic tag_four_equal;
logic tag_five_equal;
logic tag_six_equal;
logic tag_seven_equal;
logic tag_eight_equal;
//muxsel
logic data_one_input_mux_sel;
logic data_two_input_mux_sel;
logic data_three_input_mux_sel;
logic data_four_input_mux_sel;
logic data_five_input_mux_sel;
logic data_six_input_mux_sel;
logic data_seven_input_mux_sel;
logic data_eight_input_mux_sel;
//hit signal
logic hit_one_signal;
logic hit_two_signal;
logic hit_three_signal;
logic hit_four_signal;
logic hit_five_signal;
logic hit_six_signal;
logic hit_seven_signal;
logic hit_eight_signal;
//load register signal
logic load_cMAR;
logic load_cMDR;
//counter
logic cache_hit_counter_increment;
logic cache_miss_counter_increment;
logic [31:0] cache_hit_counter_output;
logic [31:0] cache_miss_counter_output;

four_way_cache_control cache_control_f
(
.*	
);

four_way_cache_datapath cache_datapath_f
(
.*
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

endmodule 