module lru_array #(
    parameter s_index = 3,
    parameter width = 3
)
(
	input logic clk,
	input logic rst,
	input logic read,
	input logic load,
	input logic [s_index-1:0] rindex,
	input logic [s_index-1:0] windex,
	input logic put_one_top_of_stack,
	input logic put_two_top_of_stack,
	input logic put_three_top_of_stack,
	input logic put_four_top_of_stack,	
	input logic put_five_top_of_stack,
	input logic put_six_top_of_stack,
	input logic put_seven_top_of_stack,
	input logic put_eight_top_of_stack,
	output logic [width-1:0] dataout
);

logic load_lru_index_one;
logic load_lru_index_two;
logic load_lru_index_three;
logic load_lru_index_four;
logic load_lru_index_five;
logic load_lru_index_six;
logic load_lru_index_seven;
logic load_lru_index_eight;
logic put_one_top_of_stack_index_one;
logic put_two_top_of_stack_index_one;
logic put_three_top_of_stack_index_one;
logic put_four_top_of_stack_index_one;
logic put_five_top_of_stack_index_one;
logic put_six_top_of_stack_index_one;
logic put_seven_top_of_stack_index_one;
logic put_eight_top_of_stack_index_one;
logic put_one_top_of_stack_index_two;
logic put_two_top_of_stack_index_two;
logic put_three_top_of_stack_index_two;
logic put_four_top_of_stack_index_two;
logic put_five_top_of_stack_index_two;
logic put_six_top_of_stack_index_two;
logic put_seven_top_of_stack_index_two;
logic put_eight_top_of_stack_index_two;	
logic put_one_top_of_stack_index_three;
logic put_two_top_of_stack_index_three;
logic put_three_top_of_stack_index_three;
logic put_four_top_of_stack_index_three;
logic put_five_top_of_stack_index_three;
logic put_six_top_of_stack_index_three;
logic put_seven_top_of_stack_index_three;
logic put_eight_top_of_stack_index_three;
logic put_one_top_of_stack_index_four;
logic put_two_top_of_stack_index_four;
logic put_three_top_of_stack_index_four;
logic put_four_top_of_stack_index_four;
logic put_five_top_of_stack_index_four;
logic put_six_top_of_stack_index_four;
logic put_seven_top_of_stack_index_four;
logic put_eight_top_of_stack_index_four;
logic put_one_top_of_stack_index_five;
logic put_two_top_of_stack_index_five;
logic put_three_top_of_stack_index_five;
logic put_four_top_of_stack_index_five;
logic put_five_top_of_stack_index_five;
logic put_six_top_of_stack_index_five;
logic put_seven_top_of_stack_index_five;
logic put_eight_top_of_stack_index_five;
logic put_one_top_of_stack_index_six;
logic put_two_top_of_stack_index_six;
logic put_three_top_of_stack_index_six;
logic put_four_top_of_stack_index_six;
logic put_five_top_of_stack_index_six;
logic put_six_top_of_stack_index_six;
logic put_seven_top_of_stack_index_six;
logic put_eight_top_of_stack_index_six;
logic put_one_top_of_stack_index_seven;
logic put_two_top_of_stack_index_seven;
logic put_three_top_of_stack_index_seven;
logic put_four_top_of_stack_index_seven;
logic put_five_top_of_stack_index_seven;
logic put_six_top_of_stack_index_seven;
logic put_seven_top_of_stack_index_seven;
logic put_eight_top_of_stack_index_seven;
logic put_one_top_of_stack_index_eight;
logic put_two_top_of_stack_index_eight;
logic put_three_top_of_stack_index_eight;
logic put_four_top_of_stack_index_eight;
logic put_five_top_of_stack_index_eight;
logic put_six_top_of_stack_index_eight;
logic put_seven_top_of_stack_index_eight;
logic put_eight_top_of_stack_index_eight;
logic [2:0] lru_output_index_one;
logic [2:0] lru_output_index_two;
logic [2:0] lru_output_index_three;
logic [2:0] lru_output_index_four;
logic [2:0] lru_output_index_five;
logic [2:0] lru_output_index_six;
logic [2:0] lru_output_index_seven;
logic [2:0] lru_output_index_eight;

always_comb begin
   load_lru_index_one = 1'b0;
   load_lru_index_two = 1'b0;
   load_lru_index_three = 1'b0;
   load_lru_index_four = 1'b0;
   load_lru_index_five = 1'b0;
   load_lru_index_six = 1'b0;
   load_lru_index_seven = 1'b0;
   load_lru_index_eight = 1'b0;
   put_one_top_of_stack_index_one = 1'bx;
   put_two_top_of_stack_index_one = 1'bx;
   put_three_top_of_stack_index_one = 1'bx;
   put_four_top_of_stack_index_one = 1'bx;
   put_five_top_of_stack_index_one = 1'bx;
   put_six_top_of_stack_index_one = 1'bx;
   put_seven_top_of_stack_index_one = 1'bx;
   put_eight_top_of_stack_index_one = 1'bx;
   put_one_top_of_stack_index_two = 1'bx;
   put_two_top_of_stack_index_two = 1'bx;
   put_three_top_of_stack_index_two = 1'bx;
   put_four_top_of_stack_index_two = 1'bx;
   put_five_top_of_stack_index_two = 1'bx;
   put_six_top_of_stack_index_two = 1'bx;
   put_seven_top_of_stack_index_two = 1'bx;
   put_eight_top_of_stack_index_two = 1'bx;	
   put_one_top_of_stack_index_three = 1'bx;
   put_two_top_of_stack_index_three = 1'bx;
   put_three_top_of_stack_index_three = 1'bx;
   put_four_top_of_stack_index_three = 1'bx;
   put_five_top_of_stack_index_three = 1'bx;
   put_six_top_of_stack_index_three = 1'bx;
   put_seven_top_of_stack_index_three = 1'bx;
   put_eight_top_of_stack_index_three = 1'bx;
   put_one_top_of_stack_index_four = 1'bx;
   put_two_top_of_stack_index_four = 1'bx;
   put_three_top_of_stack_index_four = 1'bx;
   put_four_top_of_stack_index_four = 1'bx;
   put_five_top_of_stack_index_four = 1'bx;
   put_six_top_of_stack_index_four = 1'bx;
   put_seven_top_of_stack_index_four = 1'bx;
   put_eight_top_of_stack_index_four= 1'bx;
   put_one_top_of_stack_index_five = 1'bx;
   put_two_top_of_stack_index_five = 1'bx;
   put_three_top_of_stack_index_five = 1'bx;
   put_four_top_of_stack_index_five = 1'bx;
   put_five_top_of_stack_index_five = 1'bx;
   put_six_top_of_stack_index_five = 1'bx;
   put_seven_top_of_stack_index_five = 1'bx;
   put_eight_top_of_stack_index_five = 1'bx;
   put_one_top_of_stack_index_six = 1'bx;
   put_two_top_of_stack_index_six = 1'bx;
   put_three_top_of_stack_index_six = 1'bx;
   put_four_top_of_stack_index_six = 1'bx;
   put_five_top_of_stack_index_six = 1'bx;
   put_six_top_of_stack_index_six = 1'bx;
   put_seven_top_of_stack_index_six = 1'bx;
   put_eight_top_of_stack_index_six = 1'bx;
   put_one_top_of_stack_index_seven = 1'bx;
   put_two_top_of_stack_index_seven = 1'bx;
   put_three_top_of_stack_index_seven = 1'bx;
   put_four_top_of_stack_index_seven = 1'bx;
   put_five_top_of_stack_index_seven = 1'bx;
   put_six_top_of_stack_index_seven = 1'bx;
   put_seven_top_of_stack_index_seven = 1'bx;
   put_eight_top_of_stack_index_seven = 1'bx;
   put_one_top_of_stack_index_eight = 1'bx;
   put_two_top_of_stack_index_eight = 1'bx;
   put_three_top_of_stack_index_eight = 1'bx;
   put_four_top_of_stack_index_eight = 1'bx;
   put_five_top_of_stack_index_eight = 1'bx;
   put_six_top_of_stack_index_eight = 1'bx;
   put_seven_top_of_stack_index_eight = 1'bx;
   put_eight_top_of_stack_index_eight = 1'bx;
	if(windex == 3'd0)
		begin
			load_lru_index_one = load;
			put_one_top_of_stack_index_one = put_one_top_of_stack;
			put_two_top_of_stack_index_one = put_two_top_of_stack;
			put_three_top_of_stack_index_one = put_three_top_of_stack;
			put_four_top_of_stack_index_one = put_four_top_of_stack;
			put_five_top_of_stack_index_one = put_five_top_of_stack;
			put_six_top_of_stack_index_one = put_six_top_of_stack;
			put_seven_top_of_stack_index_one = put_seven_top_of_stack;
			put_eight_top_of_stack_index_one = put_eight_top_of_stack;			
		end
	else if(windex == 3'd1)
		begin
			load_lru_index_two = load;
			put_one_top_of_stack_index_two = put_one_top_of_stack;
			put_two_top_of_stack_index_two = put_two_top_of_stack;
			put_three_top_of_stack_index_two = put_three_top_of_stack;
			put_four_top_of_stack_index_two = put_four_top_of_stack;
			put_five_top_of_stack_index_two = put_five_top_of_stack;
			put_six_top_of_stack_index_two = put_six_top_of_stack;
			put_seven_top_of_stack_index_two = put_seven_top_of_stack;
			put_eight_top_of_stack_index_two = put_eight_top_of_stack;			
		end
	else if(windex == 3'd2)
		begin
			load_lru_index_three = load;
			put_one_top_of_stack_index_three = put_one_top_of_stack;
			put_two_top_of_stack_index_three = put_two_top_of_stack;
			put_three_top_of_stack_index_three = put_three_top_of_stack;
			put_four_top_of_stack_index_three = put_four_top_of_stack;
			put_five_top_of_stack_index_three = put_five_top_of_stack;
			put_six_top_of_stack_index_three = put_six_top_of_stack;
			put_seven_top_of_stack_index_three = put_seven_top_of_stack;
			put_eight_top_of_stack_index_three = put_eight_top_of_stack;			
		end
	else if(windex == 3'd3)
		begin
			load_lru_index_four = load;
			put_one_top_of_stack_index_four = put_one_top_of_stack;
			put_two_top_of_stack_index_four = put_two_top_of_stack;
			put_three_top_of_stack_index_four = put_three_top_of_stack;
			put_four_top_of_stack_index_four = put_four_top_of_stack;
			put_five_top_of_stack_index_four = put_five_top_of_stack;
			put_six_top_of_stack_index_four = put_six_top_of_stack;
			put_seven_top_of_stack_index_four = put_seven_top_of_stack;
			put_eight_top_of_stack_index_four = put_eight_top_of_stack;			
		end
	else if(windex == 3'd4)
		begin
			load_lru_index_five = load;
			put_one_top_of_stack_index_five = put_one_top_of_stack;
			put_two_top_of_stack_index_five = put_two_top_of_stack;
			put_three_top_of_stack_index_five = put_three_top_of_stack;
			put_four_top_of_stack_index_five = put_four_top_of_stack;
			put_five_top_of_stack_index_five = put_five_top_of_stack;
			put_six_top_of_stack_index_five = put_six_top_of_stack;
			put_seven_top_of_stack_index_five = put_seven_top_of_stack;
			put_eight_top_of_stack_index_five = put_eight_top_of_stack;					
		end
	else if(windex == 3'd5)
		begin
			load_lru_index_six = load;
			put_one_top_of_stack_index_six = put_one_top_of_stack;
			put_two_top_of_stack_index_six = put_two_top_of_stack;
			put_three_top_of_stack_index_six = put_three_top_of_stack;
			put_four_top_of_stack_index_six = put_four_top_of_stack;
			put_five_top_of_stack_index_six = put_five_top_of_stack;
			put_six_top_of_stack_index_six = put_six_top_of_stack;
			put_seven_top_of_stack_index_six = put_seven_top_of_stack;
			put_eight_top_of_stack_index_six = put_eight_top_of_stack;				
		end
	else if(windex == 3'd6)
		begin
			load_lru_index_seven = load;
			put_one_top_of_stack_index_seven = put_one_top_of_stack;
			put_two_top_of_stack_index_seven = put_two_top_of_stack;
			put_three_top_of_stack_index_seven = put_three_top_of_stack;
			put_four_top_of_stack_index_seven = put_four_top_of_stack;
			put_five_top_of_stack_index_seven = put_five_top_of_stack;
			put_six_top_of_stack_index_seven = put_six_top_of_stack;
			put_seven_top_of_stack_index_seven = put_seven_top_of_stack;
			put_eight_top_of_stack_index_seven = put_eight_top_of_stack;				
		end
	else if(windex == 3'd7)
		begin
			load_lru_index_eight = load;
			put_one_top_of_stack_index_eight = put_one_top_of_stack;
			put_two_top_of_stack_index_eight = put_two_top_of_stack;
			put_three_top_of_stack_index_eight = put_three_top_of_stack;
			put_four_top_of_stack_index_eight = put_four_top_of_stack;
			put_five_top_of_stack_index_eight = put_five_top_of_stack;
			put_six_top_of_stack_index_eight = put_six_top_of_stack;
			put_seven_top_of_stack_index_eight = put_seven_top_of_stack;
			put_eight_top_of_stack_index_eight = put_eight_top_of_stack;				
		end
		
	dataout = 'x;
	if (rindex == 3'd0)
		dataout = lru_output_index_one; 
	else if (rindex == 3'd1)
		dataout = lru_output_index_two;
	else if (rindex == 3'd2)
		dataout = lru_output_index_three;	
	else if (rindex == 3'd3)
		dataout = lru_output_index_four;	
	else if (rindex == 3'd4)
		dataout = lru_output_index_five;	
	else if (rindex == 3'd5)
		dataout = lru_output_index_six;	
	else if (rindex == 3'd6)
		dataout = lru_output_index_seven;	
	else if (rindex == 3'd7)
		dataout = lru_output_index_eight;	
	
	
end
																	  
lru_register index_one_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_one), .put_two_top_of_stack(put_two_top_of_stack_index_one),
									 .put_three_top_of_stack(put_three_top_of_stack_index_one), .put_four_top_of_stack(put_four_top_of_stack_index_one),
									 .put_five_top_of_stack(put_five_top_of_stack_index_one), .put_six_top_of_stack(put_six_top_of_stack_index_one) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_one), .put_eight_top_of_stack(put_eight_top_of_stack_index_one),
									 .load_lru(load_lru_index_one), .lru_output(lru_output_index_one));

lru_register index_two_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_two), .put_two_top_of_stack(put_two_top_of_stack_index_two),
									 .put_three_top_of_stack(put_three_top_of_stack_index_two), .put_four_top_of_stack(put_four_top_of_stack_index_two),
									 .put_five_top_of_stack(put_five_top_of_stack_index_two), .put_six_top_of_stack(put_six_top_of_stack_index_two) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_two), .put_eight_top_of_stack(put_eight_top_of_stack_index_two),
									 .load_lru(load_lru_index_two), .lru_output(lru_output_index_two));
									 
lru_register index_three_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_three), .put_two_top_of_stack(put_two_top_of_stack_index_three),
									 .put_three_top_of_stack(put_three_top_of_stack_index_three), .put_four_top_of_stack(put_four_top_of_stack_index_three),
									 .put_five_top_of_stack(put_five_top_of_stack_index_three), .put_six_top_of_stack(put_six_top_of_stack_index_three) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_three), .put_eight_top_of_stack(put_eight_top_of_stack_index_three),
									 .load_lru(load_lru_index_three), .lru_output(lru_output_index_three));
									 
lru_register index_four_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_four), .put_two_top_of_stack(put_two_top_of_stack_index_four),
									 .put_three_top_of_stack(put_three_top_of_stack_index_four), .put_four_top_of_stack(put_four_top_of_stack_index_four),
									 .put_five_top_of_stack(put_five_top_of_stack_index_four), .put_six_top_of_stack(put_six_top_of_stack_index_four) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_four), .put_eight_top_of_stack(put_eight_top_of_stack_index_four),
									 .load_lru(load_lru_index_four), .lru_output(lru_output_index_four));
									 
lru_register index_five_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_five), .put_two_top_of_stack(put_two_top_of_stack_index_five),
									 .put_three_top_of_stack(put_three_top_of_stack_index_five), .put_four_top_of_stack(put_four_top_of_stack_index_five),
									 .put_five_top_of_stack(put_five_top_of_stack_index_five), .put_six_top_of_stack(put_six_top_of_stack_index_five) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_five), .put_eight_top_of_stack(put_eight_top_of_stack_index_five),
									 .load_lru(load_lru_index_five), .lru_output(lru_output_index_five));
									 
									 
lru_register index_six_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_six), .put_two_top_of_stack(put_two_top_of_stack_index_six),
									 .put_three_top_of_stack(put_three_top_of_stack_index_six), .put_four_top_of_stack(put_four_top_of_stack_index_six),
									 .put_five_top_of_stack(put_five_top_of_stack_index_six), .put_six_top_of_stack(put_six_top_of_stack_index_six) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_six), .put_eight_top_of_stack(put_eight_top_of_stack_index_six),
									 .load_lru(load_lru_index_six), .lru_output(lru_output_index_six));
									 
lru_register index_seven_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_seven), .put_two_top_of_stack(put_two_top_of_stack_index_seven),
									 .put_three_top_of_stack(put_three_top_of_stack_index_seven), .put_four_top_of_stack(put_four_top_of_stack_index_seven),
									 .put_five_top_of_stack(put_five_top_of_stack_index_seven), .put_six_top_of_stack(put_six_top_of_stack_index_seven) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_seven), .put_eight_top_of_stack(put_eight_top_of_stack_index_seven),
									 .load_lru(load_lru_index_seven), .lru_output(lru_output_index_seven));
									 
lru_register index_eight_lru (.clk(clk), .rst(rst), .put_one_top_of_stack(put_one_top_of_stack_index_eight), .put_two_top_of_stack(put_two_top_of_stack_index_eight),
									 .put_three_top_of_stack(put_three_top_of_stack_index_eight), .put_four_top_of_stack(put_four_top_of_stack_index_eight),
									 .put_five_top_of_stack(put_five_top_of_stack_index_eight), .put_six_top_of_stack(put_six_top_of_stack_index_eight) ,
									 .put_seven_top_of_stack(put_seven_top_of_stack_index_eight), .put_eight_top_of_stack(put_eight_top_of_stack_index_eight),
									 .load_lru(load_lru_index_eight), .lru_output(lru_output_index_eight));
									 
endmodule 