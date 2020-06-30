module lru_register
(
	input logic clk,
	input logic rst,
	input logic put_one_top_of_stack,
	input logic put_two_top_of_stack,
	input logic put_three_top_of_stack,
	input logic put_four_top_of_stack,
	input logic put_five_top_of_stack,
	input logic put_six_top_of_stack,
	input logic put_seven_top_of_stack,
	input logic put_eight_top_of_stack,
	input logic load_lru,
	output logic [2:0] lru_output
);

logic [2:0] set_one_pos, set_two_pos, set_three_pos, set_four_pos,
set_five_pos, set_six_pos, set_seven_pos, set_eight_pos; // pos 3 means the most recently used and 0 means least recently used

always_ff @ (posedge clk)
begin
	if(rst)
		begin
			set_one_pos <= 3'd0;
			set_two_pos <= 3'd1;
			set_three_pos <= 3'd2;
			set_four_pos <= 3'd3;
			set_five_pos <= 3'd4;
			set_six_pos <= 3'd5;
			set_seven_pos <= 3'd6;
			set_eight_pos <= 3'd7;			
		end
	else if(put_one_top_of_stack && set_one_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= 3'd7;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;	
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;				
		end
	else if(put_two_top_of_stack && set_two_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= 3'd7;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;	
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;			
		end
	else if(put_three_top_of_stack && set_three_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= 3'd7;
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;	
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;				
		end
	else if(put_four_top_of_stack && set_four_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;		
			set_four_pos <= 3'd7;
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;				
		end 
	else if (put_five_top_of_stack && set_five_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;		
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;
			set_five_pos <= 3'd7;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;					
		end
	else if (put_six_top_of_stack && set_six_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;		
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= 3'd7;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;				
		end
	else if (put_seven_top_of_stack && set_seven_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;		
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= 3'd7;
			set_eight_pos <= (set_eight_pos == 3'd0)? 3'd0 : set_eight_pos - 3'd1;		
		end
	else if (put_eight_top_of_stack && set_eight_pos != 3'd7 && load_lru)
		begin
			set_one_pos <= (set_one_pos == 3'd0) ? 3'd0 : set_one_pos - 3'd1;
			set_two_pos <= (set_two_pos == 3'd0) ? 3'd0 : set_two_pos - 3'd1;
			set_three_pos <= (set_three_pos == 3'd0)? 3'd0 : set_three_pos - 3'd1;		
			set_four_pos <= (set_four_pos == 3'd0)? 3'd0 : set_four_pos - 3'd1;
			set_five_pos <= (set_five_pos == 3'd0) ? 3'd0 : set_five_pos - 3'd1;
			set_six_pos <= (set_six_pos == 3'd0) ? 3'd0 : set_six_pos - 3'd1;
			set_seven_pos <= (set_seven_pos == 3'd0)? 3'd0 : set_seven_pos - 3'd1;
			set_eight_pos <= 3'd7;				
		end
	else
		begin
			set_one_pos <= set_one_pos;
			set_two_pos <= set_two_pos;
			set_three_pos <= set_three_pos;
			set_four_pos <= set_four_pos;		
			set_five_pos <= set_five_pos;
			set_six_pos <= set_six_pos;
			set_seven_pos <= set_seven_pos;
			set_eight_pos <= set_eight_pos;				
		end
end

always_comb 
begin
	if(set_one_pos == 3'd0)
		lru_output = 3'd0;
	else if(set_two_pos == 3'd0)
		lru_output = 3'd1;
	else if(set_three_pos == 3'd0)
		lru_output = 3'd2;
	else if(set_four_pos == 3'd0)
		lru_output = 3'd3;
	else if(set_five_pos == 3'd0)
		lru_output = 3'd4;
	else if(set_six_pos == 3'd0)
		lru_output = 3'd5;
	else if(set_seven_pos == 3'd0)
		lru_output = 3'd6;
	else if(set_eight_pos == 3'd0)
		lru_output = 3'd7;		
	else
		lru_output = 'x;
end

endmodule 