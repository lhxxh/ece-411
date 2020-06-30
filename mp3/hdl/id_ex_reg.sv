import rv32i_types::*;

module id_ex_reg
(
    input logic clk,
    input logic rst,
    input logic load,
    input logic [31:0] rs1_rdata_in, rs2_rdata_in,
    input logic br_predict_in,
    input RVFI_monitor_packet monitor_in,
    input RVFI_control_packet control_in,
    output RVFI_monitor_packet monitor_out,
    output RVFI_control_packet control_out
);

RVFI_monitor_packet monitor;
RVFI_control_packet control;

logic [31:0] rs1_rdata;
logic [31:0] rs2_rdata;
logic br_predict;

always_ff @(posedge clk)
begin
    if (rst)
    begin
        monitor <= '0;
        control <= '0;
        rs1_rdata <= '0;
        rs2_rdata <= '0;
        br_predict <= '0;
    end
    else if (load)
    begin
        monitor <= monitor_in;
        control <= control_in;
        rs1_rdata <= rs1_rdata_in;
        rs2_rdata <= rs2_rdata_in;
        br_predict <= br_predict_in;
    end
    else
    begin
        monitor <= monitor;
        control <= control;
        rs1_rdata <= rs1_rdata;
        rs2_rdata <= rs2_rdata;
        br_predict <= br_predict;
    end
end


always_comb 
begin
    monitor_out = monitor;
    control_out = control;
    monitor_out.rs1_rdata = rs1_rdata;
    monitor_out.rs2_rdata = rs2_rdata;
    monitor_out.br_predict = br_predict;
end

endmodule : id_ex_reg
