module regs(
	input wire clk,
	input wire rst,
	input wire [4:0] rs1_addr,
	input wire [4:0] rs2_addr,
	output reg [31:0] rs1_data,
	output reg [31:0] rs2_data
	
);

	reg [31:0] regs [0:31];
	
	always @(*) begin
		if(rst==1'b0) begin
			rs1_data<=32'b0;		
		end else if(rs1_addr==5'b0) begin
			rs1_data<=32'b0;	
		end else begin
			rs1_data<=regs[rs1_addr];
		end	
	end 

	always @(*) begin
		if(rst==1'b0) begin
			rs2_data<=32'b0;		
		end else if(rs1_addr==5'b0) begin
			rs2_data<=32'b0;	
		end else begin
			rs2_data<=regs[rs2_addr];
		end	
	end 


endmodule