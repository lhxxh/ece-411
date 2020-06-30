module level_two_cache
(
	input clk,
	input rst,
	// from level one
	input logic [31:0] addr_to_level_two_cache,
	output logic [255:0] rdata_from_level_two_cache,
	input logic [255:0] wdata_to_level_two_cache,
	input logic read_to_level_two_cache,
	input logic write_to_level_two_cache,
	output logic resp_from_level_two_cache,
	
	// to physical memory
   input logic [63:0] rdata_from_physical_memory,
   output logic [63:0] wdata_to_physical_memory,
   output logic [31:0] addr_to_physical_memory,
   output logic read_to_physical_memory,
   output logic write_to_physical_memory,
   input logic resp_from_physical_memory
);

//cacheline_adaptor cacheline_adaptor
//(
//    .clk(clk),
//    .reset_n(~rst),
//
//    // Port to LLC (Lowest Level Cache)
//    .line_i(wdata_to_level_two_cache),
//    .line_o(rdata_from_level_two_cache),
//    .address_i(addr_to_level_two_cache),
//    .read_i(read_to_level_two_cache),
//    .write_i(write_to_level_two_cache),
//    .resp_o(resp_from_level_two_cache),
//
//    // Port to memory
//    .burst_i(rdata_from_physical_memory),
//    .burst_o(wdata_to_physical_memory),
//    .address_o(addr_to_physical_memory),
//    .read_o(read_to_physical_memory),
//    .write_o(write_to_physical_memory),
//    .resp_i(resp_from_physical_memory)
//);

logic [31:0] mem_addr_to_cache_line_adaptor;
logic [255:0] mem_rdata_from_cache_line_adaptor;
logic [255:0] mem_wdata_to_cache_line_adaptor;
logic mem_read_to_cache_line_adaptor;
logic mem_write_to_cache_line_adaptor;
logic mem_resp_from_cache_line_adaptor;

four_way_cache L_two_cache
(
	.clk(clk),
	.rst(rst),
	.mem_address(addr_to_level_two_cache),   
	.mem_rdata(rdata_from_level_two_cache),
	.mem_wdata(wdata_to_level_two_cache),
	.mem_read(read_to_level_two_cache),
	.mem_write(write_to_level_two_cache),
	.mem_resp(resp_from_level_two_cache),
	.pmem_address(mem_addr_to_cache_line_adaptor),   
	.pmem_rdata(mem_rdata_from_cache_line_adaptor),
	.pmem_wdata(mem_wdata_to_cache_line_adaptor),
	.pmem_read(mem_read_to_cache_line_adaptor),
	.pmem_write(mem_write_to_cache_line_adaptor),
	.pmem_resp(mem_resp_from_cache_line_adaptor)
);

cacheline_adaptor cacheline_adaptor
(
    .clk(clk),
    .reset_n(~rst),

    // Port to LLC (Lowest Level Cache)
    .line_i(mem_wdata_to_cache_line_adaptor),
    .line_o(mem_rdata_from_cache_line_adaptor),
    .address_i(mem_addr_to_cache_line_adaptor),
    .read_i(mem_read_to_cache_line_adaptor),
    .write_i(mem_write_to_cache_line_adaptor),
    .resp_o(mem_resp_from_cache_line_adaptor),

    // Port to memory
    .burst_i(rdata_from_physical_memory),
    .burst_o(wdata_to_physical_memory),
    .address_o(addr_to_physical_memory),
    .read_o(read_to_physical_memory),
    .write_o(write_to_physical_memory),
    .resp_i(resp_from_physical_memory)
);
endmodule
