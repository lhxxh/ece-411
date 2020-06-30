module four_way_cache_control
(
input  logic clk,
input  logic rst,
input  logic mem_read,
input  logic mem_write,
output logic pmem_read,
output logic pmem_write,
//valid
output logic load_valid_one,
input  logic valid_one_output,
output logic load_valid_two,
input  logic valid_two_output,
output logic load_valid_three,
input  logic valid_three_output,
output logic load_valid_four,
input  logic valid_four_output,
output logic load_valid_five,
input  logic valid_five_output,
output logic load_valid_six,
input  logic valid_six_output,
output logic load_valid_seven,
input  logic valid_seven_output,
output logic load_valid_eight,
input  logic valid_eight_output,
//dirty
output logic load_dirty_one,
output logic dirty_one_input,
input  logic dirty_one_output,
output logic load_dirty_two,
output logic dirty_two_input,
input  logic dirty_two_output,
output logic load_dirty_three,
output logic dirty_three_input,
input  logic dirty_three_output,
output logic load_dirty_four,
output logic dirty_four_input,
input  logic dirty_four_output,
output logic load_dirty_five,
output logic dirty_five_input,
input  logic dirty_five_output,
output logic load_dirty_six,
output logic dirty_six_input,
input  logic dirty_six_output,
output logic load_dirty_seven,
output logic dirty_seven_input,
input  logic dirty_seven_output,
output logic load_dirty_eight,
output logic dirty_eight_input,
input  logic dirty_eight_output,
//tag
output logic load_tag_one,
output logic load_tag_two,
output logic load_tag_three,
output logic load_tag_four,
output logic load_tag_five,
output logic load_tag_six,
output logic load_tag_seven,
output logic load_tag_eight,
//lru
output logic load_lru,
output logic put_one_top_of_stack,
output logic put_two_top_of_stack,
output logic put_three_top_of_stack,
output logic put_four_top_of_stack,
output logic put_five_top_of_stack,
output logic put_six_top_of_stack,
output logic put_seven_top_of_stack,
output logic put_eight_top_of_stack,
input logic [2:0] lru_output,
//hit signal
input  logic hit_one_signal,
input  logic hit_two_signal,
input  logic hit_three_signal,
input  logic hit_four_signal,
input  logic hit_five_signal,
input  logic hit_six_signal,
input  logic hit_seven_signal,
input  logic hit_eight_signal,
//muxsel
output logic data_one_input_mux_sel,
output logic data_two_input_mux_sel,
output logic data_three_input_mux_sel,
output logic data_four_input_mux_sel,
output logic data_five_input_mux_sel,
output logic data_six_input_mux_sel,
output logic data_seven_input_mux_sel,
output logic data_eight_input_mux_sel,
output logic load_cMAR,
output logic load_cMDR,
output logic mem_resp,
input  logic pmem_resp,
//write_enable
output  logic [31:0]write_enable_one,
output  logic [31:0]write_enable_two,
output  logic [31:0]write_enable_three,
output  logic [31:0]write_enable_four,
output  logic [31:0]write_enable_five,
output  logic [31:0]write_enable_six,
output  logic [31:0]write_enable_seven,
output  logic [31:0]write_enable_eight,
//counter 
output logic cache_hit_counter_increment,
output logic cache_miss_counter_increment
);


enum int unsigned {judge_hit_or_miss, check_dirty, write_back_one,write_back_two,clean_dirty,get_new_cache_one,
						 get_new_cache_two, new_cache_line_into_array, set_valid_and_tag} state, next_state;
						 
						 

function void set_defaults(); 
	pmem_read = 1'b0;
	pmem_write = 1'b0;
	load_valid_one = 1'b0;
	load_valid_two = 1'b0;
	load_valid_three = 1'b0;
	load_valid_four = 1'b0;
	load_valid_five = 1'b0;
	load_valid_six = 1'b0;
	load_valid_seven = 1'b0;
	load_valid_eight = 1'b0;
	load_dirty_one = 1'b0;
	dirty_one_input = 1'bx;
	load_dirty_two = 1'b0;
	dirty_two_input = 1'bx;
	load_dirty_three = 1'b0;
	dirty_three_input = 1'bx;
	load_dirty_four = 1'b0;
	dirty_four_input = 1'bx;	
	load_dirty_five = 1'b0;
	dirty_five_input = 1'bx;
	load_dirty_six = 1'b0;
	dirty_six_input = 1'bx;
	load_dirty_seven = 1'b0;
	dirty_seven_input = 1'bx;
	load_dirty_eight = 1'b0;
	dirty_eight_input = 1'bx;		
	load_tag_one = 1'b0;
	load_tag_two = 1'b0;
	load_tag_three = 1'b0;
	load_tag_four = 1'b0;	
	load_tag_five = 1'b0;
	load_tag_six = 1'b0;
	load_tag_seven = 1'b0;
	load_tag_eight = 1'b0;	
	load_lru = 1'b0;
	data_one_input_mux_sel = 1'b0;
	data_two_input_mux_sel  = 1'b0;
	data_three_input_mux_sel = 1'b0;
	data_four_input_mux_sel  = 1'b0;	
	data_five_input_mux_sel = 1'b0;
	data_six_input_mux_sel  = 1'b0;
	data_seven_input_mux_sel = 1'b0;
	data_eight_input_mux_sel  = 1'b0;		
	load_cMAR = 1'b0;
	load_cMDR = 1'b0;
	mem_resp = 1'b0;
	put_one_top_of_stack = 1'd0;
	put_two_top_of_stack = 1'd0;
	put_three_top_of_stack = 1'd0;
	put_four_top_of_stack = 1'd0;
	put_five_top_of_stack = 1'd0;
	put_six_top_of_stack = 1'd0;
	put_seven_top_of_stack = 1'd0;
	put_eight_top_of_stack = 1'd0;	
	write_enable_one = '0;
	write_enable_two = '0;
	write_enable_three = '0;
	write_enable_four = '0;
	write_enable_five = '0;
	write_enable_six = '0;
	write_enable_seven = '0;
	write_enable_eight = '0;	
	cache_hit_counter_increment = 1'b0;
	cache_miss_counter_increment = 1'b0;
endfunction
						 
function void lru_update();
	if (mem_read && (hit_one_signal || hit_two_signal || hit_three_signal || hit_four_signal || hit_five_signal || hit_six_signal || hit_seven_signal || hit_eight_signal))
		begin
			if (hit_one_signal)
				put_one_top_of_stack = 1'b1;
			else if (hit_two_signal)
				put_two_top_of_stack = 1'b1;
			else if (hit_three_signal)
				put_three_top_of_stack = 1'd1;
			else if (hit_four_signal)
				put_four_top_of_stack = 1'd1;
			else if (hit_five_signal)
				put_five_top_of_stack = 1'b1;
			else if (hit_six_signal)
				put_six_top_of_stack = 1'b1;
			else if (hit_seven_signal)
				put_seven_top_of_stack = 1'd1;
			else if (hit_eight_signal)
				put_eight_top_of_stack = 1'd1;				
			else									
				;// do nothing		
			load_lru = 1'b1;	
			mem_resp = 1'b1;
			cache_hit_counter_increment = 1'b1;
		end
	else if (mem_write && (hit_one_signal || hit_two_signal|| hit_three_signal || hit_four_signal|| hit_five_signal || hit_six_signal || hit_seven_signal || hit_eight_signal))   // for final checkpoint
		begin
			// set lru and dirty
			if (hit_one_signal) 
				begin
					put_one_top_of_stack = 1'b1;
					dirty_one_input = 1'b1;
					load_dirty_one = 1'b1;		
					write_enable_one = '1;
				end
			else if (hit_two_signal)
				begin
					put_two_top_of_stack = 1'b1;
					dirty_two_input = 1'b1;
					load_dirty_two = 1'b1;
					write_enable_two = '1;
				end
			else if (hit_three_signal)	
				begin
					put_three_top_of_stack = 1'b1;
					dirty_three_input = 1'b1;
					load_dirty_three = 1'b1;
					write_enable_three = '1;
				end
			else if (hit_four_signal)
				begin
					put_four_top_of_stack = 1'b1;
					dirty_four_input = 1'b1;
					load_dirty_four = 1'b1;
					write_enable_four = '1;
				end
			else if (hit_five_signal) 
				begin
					put_five_top_of_stack = 1'b1;
					dirty_five_input = 1'b1;
					load_dirty_five = 1'b1;		
					write_enable_five = '1;
				end
			else if (hit_six_signal)
				begin
					put_six_top_of_stack = 1'b1;
					dirty_six_input = 1'b1;
					load_dirty_six = 1'b1;
					write_enable_six = '1;
				end
			else if (hit_seven_signal)	
				begin
					put_seven_top_of_stack = 1'b1;
					dirty_seven_input = 1'b1;
					load_dirty_seven = 1'b1;
					write_enable_seven = '1;
				end
			else if (hit_eight_signal)
				begin
					put_eight_top_of_stack = 1'b1;
					dirty_eight_input = 1'b1;
					load_dirty_eight = 1'b1;
					write_enable_eight = '1;		
				end
			else								 
				;// do nothing
			load_lru = 1'b1;	
			mem_resp = 1'b1;
			cache_hit_counter_increment = 1'b1;
		end				
	else
		;// do nothing 
endfunction


function void write_back_setup();
	load_cMAR = 1'b1;
	load_cMDR = 1'b1;
endfunction

function void write_back_processing();    
	pmem_write = 1'b1;
endfunction

function void set_dirty_zero();
	if(lru_output == 3'd0) 
		begin
			dirty_one_input = 1'b0;	
			load_dirty_one = 1'b1;
		end
	else if(lru_output == 3'd1)
		begin
			dirty_two_input = 1'b0;	
			load_dirty_two = 1'b1;
		end
	else if(lru_output == 3'd2)
		begin
			dirty_three_input = 1'b0;	
			load_dirty_three = 1'b1;					
		end
	else if(lru_output == 3'd3)
		begin
			dirty_four_input = 1'b0;	
			load_dirty_four = 1'b1;				
		end
	else if(lru_output == 3'd4) 
		begin
			dirty_five_input = 1'b0;	
			load_dirty_five = 1'b1;
		end
	else if(lru_output == 3'd5)
		begin
			dirty_six_input = 1'b0;	
			load_dirty_six = 1'b1;
		end
	else if(lru_output == 3'd6)
		begin
			dirty_seven_input = 1'b0;	
			load_dirty_seven = 1'b1;					
		end
	else if(lru_output == 3'd7)
		begin
			dirty_eight_input = 1'b0;	
			load_dirty_eight = 1'b1;				
		end		
	else
		;// do nothing
		
endfunction

function void set_new_cache_line_address();
	
	load_cMAR = 1'b1;
endfunction

function void read_new_cache_line_one();
	pmem_read = 1'b1;
endfunction

function void load_new_cache();
	if(lru_output == 3'd0)
		begin
			data_one_input_mux_sel = 1'b1;
			write_enable_one = '1;
		end
	else if (lru_output == 3'd1)
		begin
			data_two_input_mux_sel = 1'b1;
			write_enable_two = '1;
		end
	else if (lru_output == 3'd2)
		begin
			data_three_input_mux_sel = 1'b1;
			write_enable_three = '1;
		end	
	else if (lru_output == 3'd3)
		begin
			data_four_input_mux_sel = 1'b1;
			write_enable_four = '1;
		end		
	else if(lru_output == 3'd4)
		begin
			data_five_input_mux_sel = 1'b1;
			write_enable_five = '1;
		end
	else if (lru_output == 3'd5)
		begin
			data_six_input_mux_sel = 1'b1;
			write_enable_six = '1;
		end
	else if (lru_output == 3'd6)
		begin
			data_seven_input_mux_sel = 1'b1;
			write_enable_seven = '1;
		end	
	else if (lru_output == 3'd7)
		begin
			data_eight_input_mux_sel = 1'b1;
			write_enable_eight = '1;
		end		
	else
		;// do nothing 
endfunction 

function void valid_to_one_tag_refresh();
	if(lru_output == 3'd0)
		begin
			load_valid_one = 1'b1;
			load_tag_one = 1'b1;
		end
	else if (lru_output == 3'd1)
		begin
			load_valid_two = 1'b1;
			load_tag_two = 1'b1;
		end
	else if (lru_output == 3'd2)
		begin
			load_valid_three = 1'b1;
			load_tag_three = 1'b1;
		end
	else if (lru_output == 3'd3)
		begin
			load_valid_four = 1'b1;
			load_tag_four = 1'b1;			
		end
	else if(lru_output == 3'd4)
		begin
			load_valid_five = 1'b1;
			load_tag_five = 1'b1;
		end
	else if (lru_output == 3'd5)
		begin
			load_valid_six = 1'b1;
			load_tag_six = 1'b1;
		end
	else if (lru_output == 3'd6)
		begin
			load_valid_seven = 1'b1;
			load_tag_seven = 1'b1;
		end
	else if (lru_output == 3'd7)
		begin
			load_valid_eight = 1'b1;
			load_tag_eight = 1'b1;			
		end		
	else
		;// do nothing
	cache_miss_counter_increment = 1'b1;
endfunction

always_comb 
begin
	
	set_defaults();
	
	case(state)
		judge_hit_or_miss:lru_update();
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
				if (mem_read && (hit_one_signal || hit_two_signal|| hit_three_signal || hit_four_signal|| hit_five_signal || hit_six_signal || hit_seven_signal || hit_eight_signal))
					next_state = judge_hit_or_miss;
				else if (mem_write && (hit_one_signal || hit_two_signal|| hit_three_signal || hit_four_signal|| hit_five_signal || hit_six_signal || hit_seven_signal || hit_eight_signal))
					next_state = judge_hit_or_miss;
				else if ((mem_read || mem_write) && !hit_one_signal && !hit_two_signal && !hit_three_signal && !hit_four_signal&& !hit_five_signal && !hit_six_signal && !hit_seven_signal && !hit_eight_signal)
					next_state = check_dirty;
				else
					next_state = judge_hit_or_miss;		
			end
		check_dirty: 
			begin
				if	((lru_output == 3'd3 && dirty_four_output) || (lru_output == 3'd2 && dirty_three_output) || (lru_output == 3'd1 && dirty_two_output) || (lru_output == 3'd0 && dirty_one_output) ||
					(lru_output == 3'd7 && dirty_eight_output) || (lru_output == 3'd6 && dirty_seven_output) || (lru_output == 3'd5 && dirty_six_output) || (lru_output == 3'd4 && dirty_five_output))
					next_state = write_back_one;
				else if ((lru_output == 3'd3 && !dirty_four_output) || (lru_output == 3'd2 && !dirty_three_output) || (lru_output == 3'd1 && !dirty_two_output) || (lru_output == 3'd0 && !dirty_one_output) 
							|| (lru_output == 3'd7 && !dirty_eight_output) || (lru_output == 3'd6 && !dirty_seven_output) || (lru_output == 3'd5 && !dirty_six_output) || (lru_output == 3'd4 && !dirty_five_output))
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
		begin
			state <= judge_hit_or_miss;
		end
	else 
		begin
			state <= next_state;		
		end
end

endmodule
