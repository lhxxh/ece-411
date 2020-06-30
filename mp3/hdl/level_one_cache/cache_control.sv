module cache_control (
input  logic clk,
input  logic rst,
input  logic mem_read,
input  logic mem_write,
output logic pmem_read,
output logic pmem_write,
//write byte enable (control data write enable)
input  logic [31:0]  write_data_byte_enable_cache,
//data
output logic [31:0]write_enable_one,
output logic [31:0]write_enable_two,
//valid
output logic load_valid_one,
input  logic valid_one_output,
output logic load_valid_two,
input  logic valid_two_output,
//dirty
output logic load_dirty_one,
output logic dirty_one_input,
input  logic dirty_one_output,
output logic load_dirty_two,
output logic dirty_two_input,
input  logic dirty_two_output,
//tag
output logic load_tag_one,
output logic load_tag_two,
//lru
output logic load_lru,
output logic lru_input,
input  logic lru_output,
//hit signal
input  logic hit_one_signal,
input  logic hit_two_signal,
//muxsel
output logic data_one_input_mux_sel,
output logic data_two_input_mux_sel,
output logic load_cMAR,
output logic load_cMDR,
output logic mem_resp,
input  logic pmem_resp,
//to counter 
output logic cache_hit_counter_increment,
output logic cache_miss_counter_increment
);

enum int unsigned {judge_hit_or_miss, check_dirty, write_back_one,write_back_two,clean_dirty,get_new_cache_one,
						 get_new_cache_two, new_cache_line_into_array, set_valid_and_tag} state, next_state;

function void set_defaults(); 
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	write_enable_one = '0;
	write_enable_two = '0;	
	load_valid_one = 1'b0;
	load_valid_two = 1'b0;
	load_dirty_one = 1'b0;
	dirty_one_input = 1'bx;
	load_dirty_two = 1'b0;
	dirty_two_input = 1'bx;
	load_tag_one = 1'b0;
	load_tag_two = 1'b0;
	load_lru = 1'b0;
	lru_input = 1'bx;
	data_one_input_mux_sel = 1'b0;
	data_two_input_mux_sel  = 1'b0;
	load_cMAR = 1'b0;
	load_cMDR = 1'b0;
	mem_resp = 1'b0;
	cache_hit_counter_increment = 1'b0;
	cache_miss_counter_increment = 1'b0;
endfunction

function void hit_or_miss();
	if (mem_read && (hit_one_signal || hit_two_signal))
		begin
			if (hit_one_signal)
				lru_input = 1'b1;
			else if (hit_two_signal)
				lru_input = 1'b0;
			else									// should never enter this situation
				lru_input = 1'bx;
			load_lru = 1'b1;	
			mem_resp = 1'b1;		
			cache_hit_counter_increment = 1'b1;
		end
	else if (mem_write && (hit_one_signal || hit_two_signal))   // for final checkpoint
		begin
			// set lru and dirty
			if (hit_one_signal) 
				begin
					lru_input = 1'b1;
					dirty_one_input = 1'b1;
					load_dirty_one = 1'b1;
					dirty_two_input = 1'bx;
					load_dirty_two = 1'b0;
				end
			else if (hit_two_signal)
				begin
					lru_input = 1'b0;
					dirty_two_input = 1'b1;
					load_dirty_two = 1'b1;
					dirty_one_input = 1'bx;
					load_dirty_one = 1'b0;
				end
			else								 // should never enter this situation
				begin
					lru_input = 1'bx;
					dirty_two_input = 1'bx;
					load_dirty_two = 1'b0;
					dirty_one_input = 1'bx;
					load_dirty_one = 1'b0;					
				end
			load_lru = 1'b1;
			// by default data_one and data_two input sel are both 0, which are mem_wdata
			if (hit_one_signal)
				begin
					write_enable_one = write_data_byte_enable_cache;
					write_enable_two = '0;
				end
			else if (hit_two_signal)
				begin
					write_enable_two = write_data_byte_enable_cache;
					write_enable_one = '0;
				end
			else                       // should never happen
				begin
					write_enable_one = 'x;
					write_enable_two = 'x;
				end
			mem_resp = 1'b1;
			cache_hit_counter_increment = 1'b1;	
		end				
	else
		begin
		// do nothing 
		end	
endfunction

function void write_back_setup();
	load_cMAR = 1'b1;
	load_cMDR = 1'b1;
endfunction

function void write_back_processing();    
	pmem_write = 1'b1;
endfunction

function void set_dirty_zero();
	if(lru_output) 
		begin
			dirty_two_input = 1'b0;	
			load_dirty_two = 1'b1;
			dirty_one_input = 1'bx; 
			load_dirty_one = 1'b0;
		end
	else 
		begin
			dirty_one_input = 1'b0;	
			load_dirty_one = 1'b1;
			dirty_two_input = 1'bx;	
			load_dirty_two = 1'b0;			
		end
endfunction

function void set_new_cache_line_address();
	load_cMAR = 1'b1;
endfunction

function void read_new_cache_line_one();
	pmem_read = 1'b1;
endfunction

function void load_new_cache();
	if(lru_output)
		begin
			data_two_input_mux_sel = 1'b1; 
			write_enable_two = '1;
			data_one_input_mux_sel = 1'b0;
			write_enable_one = '0;
		end
	else 
		begin
			data_one_input_mux_sel = 1'b1;
			write_enable_one = '1;
			data_two_input_mux_sel = 1'b0;
			write_enable_two = '0;
		end
endfunction 

function void valid_to_one_tag_refresh();
	if(lru_output)
		begin
			load_valid_two = 1'b1;
			load_tag_two = 1'b1;
			load_valid_one = 1'b0;
			load_tag_one = 1'b0;
		end
	else
		begin
			load_valid_one = 1'b1;
			load_tag_one = 1'b1;
			load_valid_two = 1'b0;
			load_tag_two = 1'b0;
		end
	cache_miss_counter_increment = 1'b1;
endfunction

always_comb 
begin
	
	set_defaults();
	
	case(state)
		judge_hit_or_miss: hit_or_miss();
		check_dirty:;
		write_back_one: write_back_setup();
		write_back_two: write_back_processing();
		clean_dirty: set_dirty_zero();
		get_new_cache_one: set_new_cache_line_address();
		get_new_cache_two: read_new_cache_line_one();
		new_cache_line_into_array: load_new_cache();
		set_valid_and_tag: valid_to_one_tag_refresh();
	endcase
	
end

always_comb 
begin
	case (state)
		judge_hit_or_miss:
			begin
				if (mem_read && (hit_one_signal || hit_two_signal))
					next_state = judge_hit_or_miss;
				else if (mem_write && (hit_one_signal || hit_two_signal))
					next_state = judge_hit_or_miss;
				else if ((mem_read || mem_write) && !hit_one_signal && !hit_two_signal)
					next_state = check_dirty;
				else
					next_state = judge_hit_or_miss;		
			end
		check_dirty: 
			begin
				if	((lru_output && dirty_two_output) || (!lru_output && dirty_one_output))
					next_state = write_back_one;
				else if ((lru_output && !dirty_two_output) || (!lru_output && !dirty_one_output))
					next_state = get_new_cache_one;
				else                            // should never enter this situation
					next_state = judge_hit_or_miss;
			end
		write_back_one: next_state = write_back_two;
		write_back_two:
			begin
				if (pmem_resp)
					next_state = clean_dirty;
				else
					next_state = write_back_two;
			end
		clean_dirty:	next_state = get_new_cache_one;
		get_new_cache_one: next_state = get_new_cache_two;
		get_new_cache_two: 
			begin
				if (pmem_resp)
					next_state = new_cache_line_into_array;
				else
					next_state = get_new_cache_two;
			end
		new_cache_line_into_array: next_state = set_valid_and_tag;
		set_valid_and_tag: next_state = judge_hit_or_miss;
	endcase		
end

always_ff @(posedge clk) 
begin

	if (rst)
		state <= judge_hit_or_miss;
	else 
		state <= next_state;
		
end

endmodule : cache_control