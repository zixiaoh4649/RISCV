module if_id(
	input wire clk,
	input wire rst,
	input wire [31:0] ins2id,
	input wire [31:0] ins_addr,
	output wire [31:0] ins_addr2id,
	output wire [31:0] ins,

	//hold
	input wire hold
);
	dff_set #(32) dff1(clk, rst, hold, 32'b0, ins_addr, ins_addr2id); 
	dff_set #(32) dff2(clk, rst, hold, 32'h13, ins2id, ins);  //32'h13 is the ins for NOP

endmodule