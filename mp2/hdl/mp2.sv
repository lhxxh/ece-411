import rv32i_types::*;

module mp2
(
    input clk,
    input rst,
    input pmem_resp,
    input [63:0] pmem_rdata,
    output logic pmem_read,
    output logic pmem_write,
    output rv32i_word pmem_address,
    output [63:0] pmem_wdata
);
// between cpu and cache 
logic [31:0] mem_address;   
logic	[31:0] mem_rdata;
logic [31:0] mem_wdata;
logic mem_read;
logic mem_write;
logic [3:0] mem_byte_enable;
logic mem_resp;
// between cache and cacheline adaptor
logic [31:0] cmem_address;   
logic	[255:0] cmem_rdata;
logic [255:0] cmem_wdata;
logic cmem_read;
logic cmem_write;
logic cmem_resp;

// Keep cpu named `cpu` for RVFI Monitor
// Note: you have to rename your mp2 module to `cpu`
cpu cpu(.*);

// Keep cache named `cache` for RVFI Monitor
cache cache(.*, .pmem_address (cmem_address), .pmem_rdata (cmem_rdata), .pmem_wdata (cmem_wdata),
.pmem_read (cmem_read), .pmem_write(cmem_write), .pmem_resp(cmem_resp));

// From MP0
cacheline_adaptor cacheline_adaptor
(
.clk(clk), .reset_n(~rst), .line_i(cmem_wdata), .line_o(cmem_rdata),
.address_i(cmem_address), .read_i(cmem_read), .write_i(cmem_write),
.resp_o(cmem_resp), .burst_i(pmem_rdata), .burst_o(pmem_wdata), .address_o(pmem_address),
.read_o(pmem_read), .write_o(pmem_write), .resp_i(pmem_resp)
);

endmodule : mp2
