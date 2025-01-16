module ctrl(
	input  wire 		hold2ctrl;
	input  wire 		jump_en2ctrl;
	input  wire [31:0] 	jump_addr2ctrl;
	output reg 			hold;
	output reg 			jump_en;
	output reg [31:0]  	jump_addr;
);

	always @(*) begin
		
		jump_addr = jump_addr2ctrl;
		jump_en	  = jump_en2ctrl;

		if(jump_en2ctrl || hold2ctrl) begin
			hold = 1'b1;
		end else begin
			hold = 1'b0;
		end

	end


endmodule