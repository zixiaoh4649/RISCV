module pc_reg (
	input wire clk,
	input wire rst,
	output reg [31:0] pc_o,

	//jump
	input wire hold,
	input wire jump_addr,
	input wire jump_en
); 

	always @(posedge clk)begin

		if (rst==1'b0)begin

			pc_o <= 32'b0;

		end else if(jump_en)begin

			pc_o <= jump_addr;

		end else begin

			pc_o <= pc_o + 3'd4;

		end
	end
	
endmodule
