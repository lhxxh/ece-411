module hit_and_miss_counter
(
	input logic clk,
	input logic rst,
	input logic cache_hit_counter_increment,
	input logic cache_miss_counter_increment,
	output logic [31:0] cache_hit_counter_output,
	output logic [31:0] cache_miss_counter_output
);

always_ff @ (posedge clk) begin
	if(rst)
		begin
			cache_hit_counter_output <= '0;
			cache_miss_counter_output <= '0;
		end
	else if(cache_hit_counter_increment)
		cache_hit_counter_output <= cache_hit_counter_output + 32'd1;
	else if(cache_miss_counter_increment)
		cache_miss_counter_output <= cache_miss_counter_output + 32'd1;
		
end


endmodule
