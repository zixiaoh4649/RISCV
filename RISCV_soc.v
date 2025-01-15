module RISCV_soc(
	input wire clk,
	input wire rst
);

	riscv riscv_inst(
    	clki	(clk),
    	rsti	(rst),
    	pc2rom	(pc2rom),
    	rom_ins (rom_ins)
	);

    wire [31:0] pc2rom;
	wire [31:0] rom_ins;


	rom rom_inst(
	pc2rom  (pc2rom),
	rom_ins (rom_ins)
	);

endmodule
