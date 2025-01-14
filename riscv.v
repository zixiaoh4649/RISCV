module(
    input wire clk,
    input wire rst,

    output wire [31:0] pc2rom,
    input  wire [31:0] rom_ins
)


regs regs_instance (
    .clk(clk),
    .rst(rst),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_forward_data(rd_forward_data),
    .rd_forward_addr(rd_forward_addr),
    .rd_wen(rd_wen),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);