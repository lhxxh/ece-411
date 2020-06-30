import rv32i_types::*;

module branch_predictor #(
    parameter n_index = 256,
    parameter n_offset = 8
)
(
    input logic clk,
    input logic rst,
    input logic halt,
    input logic [31:0] id_pc,
    input logic [31:0] mem_pc,
    input logic mem_predict_correct,
    input logic mem_br_en,
    input rv32i_opcode id_opcode,
    input rv32i_opcode mem_opcode,
    output logic id_br_predict
);


logic id_valid;
logic mem_valid;
branch_predictor_state state [n_index];
logic [n_offset-1:0] id_pc_hash;
logic [n_offset-1:0] mem_pc_hash;
logic [31:0] correct_counter;
logic [31:0] total_counter;

// if mem_valid, need to update branch table
// if id_valid, need to make prediction
assign mem_valid = (mem_opcode == op_br) & ~halt;
assign id_valid = (id_opcode == op_br) & ~halt &
    ((mem_valid & mem_predict_correct) | ((mem_opcode != op_jalr) & (mem_opcode != op_br)));
assign id_pc_hash = id_pc[n_offset+1:2];
assign mem_pc_hash = mem_pc[n_offset+1:2];


function branch_predictor_state table_update (branch_predictor_state state, logic br_en);
    branch_predictor_state next_state;
    unique case (state)
        strongly_not_taken : if (br_en) next_state = weakly_not_taken; else next_state = strongly_not_taken; 
        weakly_not_taken : if (br_en) next_state = weakly_taken; else next_state = strongly_not_taken; 
        weakly_taken : if (br_en) next_state = strongly_taken; else next_state = weakly_not_taken; 
        strongly_taken : if (br_en) next_state = strongly_taken; else next_state = weakly_taken; 
    endcase
    return next_state;
endfunction

always_ff @(posedge clk)
begin
    if (rst)
    begin
        for (int i=0; i<n_index; i=i+1) begin
            state[i] <= weakly_not_taken;
            correct_counter <= '0;
            total_counter <= '0;
        end
    end
    else if (mem_valid) 
    begin
        total_counter <= total_counter + 1;
        state[mem_pc_hash] = table_update(state[mem_pc_hash], mem_br_en);
        if (mem_predict_correct) correct_counter <= correct_counter + 1;
    end
end

always_comb 
begin
    id_br_predict = 0;
    if (id_valid) id_br_predict = ((state[id_pc_hash] == weakly_taken) | (state[id_pc_hash] == strongly_taken)) ? 1'b1 : 1'b0;
end

endmodule
