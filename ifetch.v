module ifetch (
	input wire [31:0] pc_o,
	input wire [31:0] rom_ins,
	output wire [31:0] pc2rom,
	output wire [31:0] ins2id,
	output wire [31:0] ins_addr //for later branch addr calculate
	
);

	assign pc2rom = pc_o;
	assign ins2id = rom_ins;
	assign ins_addr = pc_o;
	
	
endmodule
