import rv32i_types::*;

module finish_reg
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [31:0] rd_wdata_in,
    input RVFI_monitor_packet monitor_in,
    input RVFI_control_packet control_in,
    output RVFI_monitor_packet monitor_out,
    output RVFI_control_packet control_out
);

RVFI_monitor_packet monitor;
RVFI_control_packet control;

logic [31:0] rd_wdata;

always_ff @(posedge clk)
begin
    if (rst)
    begin
        monitor <= '0;
        control <= '0;
        rd_wdata <= '0;
    end
    else if (load)
    begin
        monitor <= monitor_in;
        control <= control_in;
        rd_wdata <= rd_wdata_in;
    end
    else
    begin
        monitor <= monitor;
        control <= control;
        rd_wdata <= rd_wdata;
    end
end

always_comb 
begin
    monitor_out = monitor;
    control_out = control;
    monitor_out.rd_wdata = rd_wdata;
end

endmodule : finish_reg
