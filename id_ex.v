module id_ex(
	input wire clk,
	input wire rst,

	//from id
	input wire [31:0] op1,
	input wire [31:0] op2,
	input wire [31:0] ins2ex,
	input wire [31:0] ins_addr,
	input wire [4:0]  rd_addr,
	input wire 	      rd_wen,
	input wire [4:0]  oh_in, //oh
	
	//to ex
	output wire [31:0] op1_ex,
	output wire [31:0] op2_ex,
	output wire [31:0] ins,
	output wire [31:0] ins_addr2ex,
	output wire [4:0]  rd_addr2ex,
	output wire        rd_wen2ex,
	output wire [4:0]  oh
);

	dff_set #(32) dff_op1(clk, rst, 32'b0, op1, op1_ex);
	
	dff_set #(32) dff_op2(clk, rst, 32'b0, op2, op2_ex);
	
	dff_set #(32) dff_ins(clk, rst, 32'h13, ins2ex, ins);
	
	dff_set #(32) dff_ins_addr(clk, rst, 32'b0, ins_addr, ins_addr2ex);
	
	dff_set #(5) dff_oh(clk, rst, 5'b0, oh_in, oh);
	
	dff_set #(5) dff_rd_addr(clk, rst, 5'b0, rd_addr, rd_addr2ex);
	
	dff_set #(1) dff_rd_wen(clk, rst, 1'b0, rd_wen, rd_wen2ex);
	
	
	
	
endmodule