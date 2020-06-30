module cacheline_adaptor
(
    input clk,
    input reset_n,

    // Port to LLC (Lowest Level Cache)
    input logic [255:0] line_i,
    output logic [255:0] line_o,
    input logic [31:0] address_i,
    input read_i,
    input write_i,
    output logic resp_o,

    // Port to memory
    input logic [63:0] burst_i,
    output logic [63:0] burst_o,
    output logic [31:0] address_o,
    output logic read_o,
    output logic write_o,
    input resp_i
);


logic [63:0] register [3:0]; 
logic [2:0] counter_in , counter;
logic [1:0] most_recent_action;  // 0 for no action, 1 for read, 2 for write

assign read_o = read_i;
assign write_o = write_i;
assign address_o = address_i;
assign counter_in = counter + 3'd1;
assign line_o = {register[3],register[2],register[1],register[0]};
assign burst_o = register[0];

always_ff @ (posedge clk) begin
    
	 counter <= counter;
    if (!reset_n) 
		begin
        counter <= '0;
		end
    else if (resp_i) 
		begin
        counter <= counter_in;
		end
    else if(!resp_i)
		begin  
        counter <= 3'd0;
		end
	
	most_recent_action <= most_recent_action;
	if (!reset_n)
		begin
			most_recent_action  <= 2'd0; 
		end
	else if (counter == 3'd3 && resp_i)
		begin
			most_recent_action <= 2'd0;
		end
	else if (read_i)
		begin
			most_recent_action  <= 2'd1;
		end
	else if (write_i)
		begin
			most_recent_action  <= 2'd2;
		end
		
	register <= register;	
	 if (!reset_n)
		begin
			for (int i=0; i<4; i++)
				begin
					register[i] <= '0;
				end
		end
	 else if(most_recent_action == 2'd1)
		begin
			if(resp_i)
				begin
					if(counter == 3'd0)
						register[0] <= burst_i;
					else if(counter == 3'd1)
						register[1] <= burst_i;
					else if(counter == 3'd2)
						register[2] <= burst_i;
					else if (counter == 3'd3)
						register[3] <= burst_i;
				end		
		end
	 else if(most_recent_action == 2'd2)
		begin
			if(resp_i)
				begin
					if(counter == 3'd0)
						register[0] <= line_i[127:64];
					else if(counter == 3'd1)
						register[0] <= line_i[191:128];
					else if(counter == 3'd2)
						register[0] <= line_i[255:192];
					else if(counter == 3'd3)
						register[0] <= register[0];
				end
			else
				register[0] <= line_i[63:0];
			end
	 if(resp_i && counter == 3'd2)
		resp_o <= 1'b1;
	 else
		resp_o <= 1'b0; 
	
end

endmodule : cacheline_adaptor
