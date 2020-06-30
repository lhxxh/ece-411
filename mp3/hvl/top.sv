module mp3_tb;
`timescale 1ns/10ps

/********************* Do not touch for proper compilation *******************/
// Instantiate Interfaces
tb_itf itf();
rvfi_itf rvfi(itf.clk, itf.rst);

// Instantiate Testbench
source_tb tb(
    .magic_mem_itf(itf),
    .mem_itf(itf),
    .sm_itf(itf),
    .tb_itf(itf),
    .rvfi(rvfi)
);
/****************************** End do not touch *****************************/

/************************ Signals necessary for monitor **********************/
// This section not required until CP3

// assign rvfi.commit = dut.cpu.wb_regfile_write; // Set high when a valid instruction is modifying regfile or PC
assign rvfi.halt =  (dut.cpu.wb_monitor.pc_rdata == dut.cpu.if_pc) && (dut.cpu.wb_control.opcode == 7'b1100011 | dut.cpu.wb_control.opcode == 7'b1101111 | dut.cpu.wb_control.opcode == 7'b1100111);   // Set high when you detect an infinite loop
//assign rvfi.halt = 1'b0;
initial rvfi.order = 0;
always @(posedge itf.clk iff rvfi.commit) rvfi.order <= rvfi.order + 1; // Modify for OoO

assign rvfi.clk = itf.clk;
assign rvfi.rst = itf.rst;

assign rvfi.inst = dut.cpu.wb_control.instruction;
assign rvfi.trap = 0;

assign rvfi.commit = dut.cpu.wb_control.is_valid_instruction & dut.cpu.finish_load;
assign rvfi.rs1_addr = dut.cpu.wb_monitor.rs1;
assign rvfi.rs2_addr = dut.cpu.wb_monitor.rs2;
assign rvfi.rs1_rdata = dut.cpu.wb_monitor.rs1_rdata;
assign rvfi.rs2_rdata = dut.cpu.wb_monitor.rs2_rdata;
assign rvfi.load_regfile = dut.cpu.wb_control.regfile_write & dut.cpu.mem_wb_load;
assign rvfi.rd_addr = dut.cpu.wb_monitor.rd;
assign rvfi.rd_wdata = (dut.cpu.wb_monitor.rd) ? dut.cpu.wb_regfilemux_out : '0;
assign rvfi.pc_rdata = dut.cpu.wb_monitor.pc_rdata;
assign rvfi.pc_wdata = dut.cpu.wb_monitor.pc_wdata;
assign rvfi.mem_addr = dut.cpu.wb_monitor.mem_addr;
assign rvfi.mem_rmask = dut.cpu.wb_monitor.mem_rmask;
assign rvfi.mem_wmask = dut.cpu.wb_monitor.mem_wmask;
assign rvfi.mem_rdata = dut.cpu.wb_monitor.mem_rdata;
assign rvfi.mem_wdata = dut.cpu.wb_monitor.mem_wdata;


always @(rvfi.errcode iff (rvfi.errcode != 0)) begin
    repeat (30) @(posedge rvfi.clk);
    $display("TOP: Errcode: %0d", rvfi.errcode);
    $finish;
end

/**************************** End RVFIMON signals ****************************/

/********************* Assign Shadow Memory Signals Here *********************/
// This section not required until CP2
assign itf.inst_read = dut.cpu.inst_read;
assign itf.inst_addr = dut.cpu.inst_addr;
assign itf.inst_rdata = dut.cpu.inst_rdata;
assign itf.inst_resp = dut.cpu.inst_resp;
assign itf.data_read = dut.cpu.data_read;
assign itf.data_write = dut.cpu.data_write;
assign itf.data_addr = dut.cpu.data_addr;
assign itf.data_rdata = dut.cpu.data_rdata;
assign itf.data_wdata = dut.cpu.data_wdata;
assign itf.data_resp = dut.cpu.data_resp;
assign itf.data_mbe = dut.cpu.data_mbe;

/*********************** End Shadow Memory Assignments ***********************/

// Set this to the proper value
assign itf.registers = dut.cpu.regfile.data;

/*********************** Instantiate your design here ************************/

// showing signals
logic mem_read;
logic mem_write;
logic [31:0] mem_addr;
logic [63:0] mem_wdata;
logic mem_resp;
logic [63:0] mem_rdata;
logic [31:0] inst_cache_hit_counter;
logic [31:0] inst_cache_miss_counter;
logic [31:0] data_cache_hit_counter;
logic [31:0] data_cache_miss_counter;
logic [31:0] level_two_cache_hit_counter;
logic [31:0] level_two_cache_miss_counter;

mp3 dut
(
  .clk(itf.clk),
  .rst(itf.rst),

  // to physical memory
  .rdata_from_physical_memory(itf.mem_rdata),
  .wdata_to_physical_memory(itf.mem_wdata),
  .addr_to_physical_memory(itf.mem_addr),
  .read_to_physical_memory(itf.mem_read),
  .write_to_physical_memory(itf.mem_write),
  .resp_from_physical_memory(itf.mem_resp),
  .*
);

always @(posedge itf.clk iff (dut.cpu.data_addr == 32'h00000c90)) begin
  $display("address c90, to level one cache time %0t ", $time);
end

//always @(posedge itf.clk iff (dut.addr_to_level_two_cache == 32'h00000da0)) begin
//	$display("address da0, to level two cache time %0t", $time);
//end

//always @(posedge itf.clk iff (dut.addr_to_physical_memory == 32'h00000da0) ) begin
//	$display("address da0, to physical memory time %0t", $time);
//end

//always @(posedge itf.clk) begin
//	$display("time %t",$time);
//end

// assign clk = itf.clk;
// assign rst = itf.rst;
// assign inst_read = itf.inst_read;
// assign inst_addr = itf.inst_addr;
// assign inst_resp = itf.inst_resp;
// assign inst_rdata = itf.inst_rdata;
// assign data_read = itf.data_read;
// assign data_write = itf.data_write;
// assign data_mbe = itf.data_mbe;
// assign data_addr = itf.data_addr;
// assign data_wdata = itf.data_wdata;
// assign data_resp = itf.data_resp;
// assign data_rdata = itf.data_rdata;
assign mem_rdata = itf.mem_rdata;
assign mem_wdata = itf.mem_wdata;
assign mem_addr = itf.mem_addr;
assign mem_read = itf.mem_read;
assign mem_write = itf.mem_write;
assign mem_resp = itf.mem_resp;
/***************************** End Instantiation *****************************/

endmodule
