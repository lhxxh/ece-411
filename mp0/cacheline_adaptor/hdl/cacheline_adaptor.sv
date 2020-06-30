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
logic [1:0] most_recently_action, most_recently_action_in; // 0 means nothing, 1 means read, 2 means write

assign read_o = read_i;
assign write_o = write_i;
assign address_o = address_i;
assign resp_o = ~resp_i;
assign counter_in = counter + 3'd1;
assign most_recently_action_in = most_recently_action;

always_ff @ (posedge clk) begin
    
    if (!reset_n) begin
    
        counter <= '0;

    end

    else if (resp_i) begin
    
        counter <= counter_in;

    end

    else begin
        
        counter <= 3'd0;

    end


    if (!reset_n) begin

        most_recently_action <= 2'd0;

    end

    else if (write_i) begin
        
        most_recently_action <= 2'd2;

    end

    else if (read_i) begin
        
        most_recently_action <= 2'd1; 

    end

    else begin
        
        most_recently_action <= most_recently_action_in;

    end


end

always_comb begin            

// $monitor(resp_i);
if(most_recently_action == 2'd1) begin                            //read

    if (counter == 3'd0 && resp_i ) begin
        
        register[0] = burst_i;

    end

    else if (counter == 3'd1 && resp_i ) begin
        
        register[1] = burst_i;

    end

    else if (counter == 3'd2 && resp_i ) begin
        
        register[2] = burst_i;

    end

    else if (counter == 3'd3 && resp_i) begin
        
        register[3] = burst_i;

    end

    else begin
        
        register = register;

    end

    end

else if(most_recently_action == 2'd2) begin                             //write

    if (counter == 3'd0 && resp_i) begin
        
        register[0] = line_i[63:0];

    end

    else if (counter == 3'd1 && resp_i) begin
        
        register[0] = line_i[127:64];

    end

    else if (counter == 3'd2 && resp_i) begin
        
        register[0] = line_i[191:128];

    end

    else if (counter == 3'd3 && resp_i ) begin
        
        register[0] = line_i[255:192];

    end

    else begin
        
        register = register;

    end

    end

else begin
    
    register = register;

end



    if(resp_i) begin
        
        line_o = line_o;

    end

    else begin
        
        line_o = {register[3],register[2],register[1],register[0]};

    end

    if(resp_i) begin
        
        burst_o = register[0];

    end

    else begin
        
        burst_o = burst_o;

    end

end



endmodule : cacheline_adaptor
