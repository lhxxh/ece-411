import rv32i_types::*;

module mem_wb_reg
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [31:0] mem_rdata_in,
    input logic [31:0] pc_wdata_in,
    input RVFI_monitor_packet monitor_in,
    input RVFI_control_packet control_in,
    output RVFI_monitor_packet monitor_out,
    output RVFI_control_packet control_out
);

RVFI_monitor_packet monitor;
RVFI_control_packet control;

logic [31:0] mem_rdata;
logic [31:0] pc_wdata;

always_ff @(posedge clk)
begin
    if (rst)
    begin
        monitor <= '0;
        control <= '0;
        mem_rdata <= '0;
        pc_wdata <= '0;
    end
    else if (load)
    begin
        monitor <= monitor_in;
        control <= control_in;
        mem_rdata <= mem_rdata_in;
        pc_wdata <= pc_wdata_in;
    end
    else
    begin
        monitor <= monitor;
        control <= control;
        mem_rdata <= mem_rdata;
        pc_wdata <= pc_wdata;
    end
end

always_comb 
begin
    monitor_out = monitor;
    control_out = control;
    monitor_out.mem_rdata = mem_rdata;
    if (control_out.opcode != op_jal) monitor_out.pc_wdata = pc_wdata;
end

endmodule : mem_wb_reg
