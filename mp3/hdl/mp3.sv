module mp3
(
	input clk,
	input rst,
	
	// to physical memory
	input logic [63:0] rdata_from_physical_memory,
   output logic [63:0] wdata_to_physical_memory,
   output logic [31:0] addr_to_physical_memory,
   output logic read_to_physical_memory,
   output logic write_to_physical_memory,
   input logic resp_from_physical_memory	
);

logic inst_read;
logic [31:0] inst_addr;
logic inst_resp;
logic [31:0] inst_rdata;
logic data_read;
logic data_write;
logic [3:0] data_mbe;
logic [31:0] data_addr;
logic [31:0] data_wdata;
logic data_resp;
logic [31:0] data_rdata;

logic [31:0] addr_to_level_two_cache;
logic [255:0] rdata_from_level_two_cache;
logic [255:0] wdata_to_level_two_cache;
logic read_to_level_two_cache;
logic write_to_level_two_cache;
logic resp_from_level_two_cache;

pipeline_cpu cpu
(
    .clk(clk) ,
    .rst(rst) ,
    .inst_resp(inst_resp) ,
    .inst_rdata(inst_rdata),
    .data_resp(data_resp),
    .data_rdata(data_rdata),
    .inst_read(inst_read),
    .inst_addr(inst_addr),
    .data_read(data_read),
    .data_write(data_write),
    .data_mbe(data_mbe),
    .data_addr(data_addr),
    .data_wdata(data_wdata)
);

level_one_cache level_one_cache
(
   .clk(clk),
   .rst(rst),
   .inst_resp(inst_resp),
  	.inst_rdata(inst_rdata),
  	.data_resp(data_resp),
  	.data_rdata(data_rdata),

  	.inst_read(inst_read),
  	.inst_addr(inst_addr),
  	.data_read(data_read),
  	.data_write(data_write),
  	.data_mbe(data_mbe),
  	.data_addr(data_addr),
  	.data_wdata(data_wdata),

  	// to level two
  	.addr_to_level_two_cache(addr_to_level_two_cache),
  	.rdata_from_level_two_cache(rdata_from_level_two_cache),
  	.wdata_to_level_two_cache(wdata_to_level_two_cache),
  	.read_to_level_two_cache(read_to_level_two_cache),
  	.write_to_level_two_cache(write_to_level_two_cache),
  	.resp_from_level_two_cache(resp_from_level_two_cache)
);

level_two_cache level_two_cache
(
   .clk(clk),
	.rst(rst),
	// from level one
	.addr_to_level_two_cache(addr_to_level_two_cache),
	.rdata_from_level_two_cache(rdata_from_level_two_cache),
	.wdata_to_level_two_cache(wdata_to_level_two_cache),
	.read_to_level_two_cache(read_to_level_two_cache),
	.write_to_level_two_cache(write_to_level_two_cache),
	.resp_from_level_two_cache(resp_from_level_two_cache),

	// to physical memory
  .rdata_from_physical_memory(rdata_from_physical_memory),
  .wdata_to_physical_memory(wdata_to_physical_memory),
  .addr_to_physical_memory(addr_to_physical_memory),
  .read_to_physical_memory(read_to_physical_memory),
  .write_to_physical_memory(write_to_physical_memory),
  .resp_from_physical_memory(resp_from_physical_memory)
  
);

endmodule : mp3
