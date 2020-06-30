module level_one_cache 
(
	input logic clk,
	input logic rst,
	output logic inst_resp,
	output logic [31:0] inst_rdata,
	output logic data_resp,
	output logic [31:0] data_rdata,
	
	input logic inst_read,
	input logic [31:0] inst_addr,
	input logic data_read,
	input logic data_write,
	input logic [3:0] data_mbe,
	input logic [31:0] data_addr,
	input logic [31:0] data_wdata,
	
	// to level two
	output logic [31:0] addr_to_level_two_cache,
	input logic [255:0] rdata_from_level_two_cache,
	output logic [255:0] wdata_to_level_two_cache,
	output logic read_to_level_two_cache,
	output logic write_to_level_two_cache,
	input logic resp_from_level_two_cache
);
// inst to arbiter
	logic [31:0] inst_addr_to_arbiter;
	logic	[255:0] inst_rdata_from_arbiter;
	logic [255:0] inst_wdata_to_arbiter;
	logic inst_read_to_arbiter;
	logic inst_write_to_arbiter;
	logic inst_resp_from_arbiter;
// data to arbiter
	logic [31:0] data_addr_to_arbiter;
	logic	[255:0] data_rdata_from_arbiter;
	logic [255:0] data_wdata_to_arbiter;
	logic data_read_to_arbiter;
	logic data_write_to_arbiter;
	logic data_resp_from_arbiter;
// delay
	logic [255:0] inst_rdata_to_cache_one_from_arbiter;
	logic [255:0] data_rdata_to_cache_one_from_arbiter;
	
	
cache inst_cache
(
	.clk(clk),
	.rst(rst),
	.mem_address(inst_addr),   
	.mem_rdata(inst_rdata),
   .mem_wdata('x),
	.mem_read(1'b1),
   .mem_write(1'b0),
	.mem_byte_enable(4'd0),
   .mem_resp(inst_resp),
	.pmem_address(inst_addr_to_arbiter),   
	.pmem_rdata(inst_rdata_to_cache_one_from_arbiter),
	.pmem_wdata(inst_wdata_to_arbiter),
	.pmem_read(inst_read_to_arbiter),
	.pmem_write(inst_write_to_arbiter),
	.pmem_resp(inst_resp_from_arbiter)
);

cache data_cache
(
	.clk(clk),
	.rst(rst),
	.mem_address(data_addr),   
	.mem_rdata(data_rdata),
   .mem_wdata(data_wdata),
	.mem_read(data_read),
   .mem_write(data_write),
	.mem_byte_enable(data_mbe),
   .mem_resp(data_resp),
	.pmem_address(data_addr_to_arbiter),   
	.pmem_rdata(data_rdata_to_cache_one_from_arbiter),
	.pmem_wdata(data_wdata_to_arbiter),
	.pmem_read(data_read_to_arbiter),
	.pmem_write(data_write_to_arbiter),
	.pmem_resp(data_resp_from_arbiter)
);

arbiter arbiter
(
	.clk(clk),
	.rst(rst),
// inst to arbiter
	.inst_addr_to_arbiter(inst_addr_to_arbiter),
	.inst_rdata_from_arbiter(inst_rdata_from_arbiter),
	.inst_wdata_to_arbiter(inst_wdata_to_arbiter),
	.inst_read_to_arbiter(inst_read_to_arbiter),
	.inst_write_to_arbiter(inst_write_to_arbiter),
	.inst_resp_from_arbiter(inst_resp_from_arbiter),
// data to arbiter
	.data_addr_to_arbiter(data_addr_to_arbiter),
	.data_rdata_from_arbiter(data_rdata_from_arbiter),
	.data_wdata_to_arbiter(data_wdata_to_arbiter),
	.data_read_to_arbiter(data_read_to_arbiter),
	.data_write_to_arbiter(data_write_to_arbiter),
	.data_resp_from_arbiter(data_resp_from_arbiter),
// to level two cache
	.addr_to_level_two_cache(addr_to_level_two_cache),
	.rdata_from_level_two_cache(rdata_from_level_two_cache),
	.wdata_to_level_two_cache(wdata_to_level_two_cache),
	.read_to_level_two_cache(read_to_level_two_cache),
	.write_to_level_two_cache(write_to_level_two_cache),
	.resp_from_level_two_cache(resp_from_level_two_cache)
);

register_posedge # (.width(256))  inst_delay
(
    .clk(clk),
    .rst(rst),
    .load(1'b1),
    .in(inst_rdata_from_arbiter),
    .out(inst_rdata_to_cache_one_from_arbiter)
);


register_posedge # (.width(256))  data_deplay
(
    .clk(clk),
    .rst(rst),
    .load(1'b1),
    .in(data_rdata_from_arbiter),
    .out(data_rdata_to_cache_one_from_arbiter)
);

endmodule
