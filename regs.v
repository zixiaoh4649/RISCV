module regs(
	input wire clk,
	input wire rst,
	
	//from id
	input wire [4:0]  rs1_addr,
	input wire [4:0]  rs2_addr,
	
	//forward and write back
	input wire [31:0] rd_forward_data,
	input wire [4:0]  rd_forward_addr,
	input wire        rd_wen,
	
	//to id
	output reg [31:0] rs1_data,
	output reg [31:0] rs2_data
	
);

	reg [31:0] regs [0:31];
	
	always @(*) begin
		if(rst==1'b0) begin
			rs1_data<=32'b0;		
		end else if(rs1_addr==5'b0) begin
			rs1_data<=32'b0;	
		end else if(rd_wen&&(rs1_addr==rd_forward_addr))begin
			rs1_data<=rd_forward_data;
		end else begin
			rs1_data<=regs[rs1_addr];
		end	
	end 

	always @(*) begin
		if(rst==1'b0) begin
			rs2_data<=32'b0;		
		end else if(rs2_addr==5'b0) begin
			rs2_data<=32'b0;	
		end else if(rd_wen&&(rs2_addr==rd_forward_addr))begin
			rs2_data<=rd_forward_data;
		end else begin
			rs2_data<=regs[rs2_addr];
		end	
	end 
	
	
	integer i;
	always @(posedge clk)begin
		if(rst==1'b0)begin
			for(i=0;i<32;i=i+1)begin //?
				regs[i]<=32'b0;
			end
		end else if(rd_wen&&(rd_forward_addr!=5'b0))begin
			regs[rd_forward_addr]<=rd_forward_data;
		end

	end

endmodule