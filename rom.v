module rom(
	input wire [31:0] pc2rom,
	output reg [31:0] rom_ins
);

	reg[31:0] rom_mem[0:4095];
	
	always @(*)begin
		rom_ins = rom_mem[pc2rom>>2];
	end

	
endmodule
