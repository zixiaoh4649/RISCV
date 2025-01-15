module ex(
	input wire [31:0] ins,
	input wire [31:0] ins_addr2ex,
	input wire [31:0] op1,    //op1_ex
	input wire [31:0] op2,    //op2_ex
	input wire [4:0]  rd_addr2ex, 
	input wire        rd_wen,  //rd_wen2ex
	input wire [4:0]  oh,
	output reg [4:0]  rd_addr,
	output reg [31:0] rd_data,
	output reg        rd_wen2reg
);
	
	always @(*) begin
		
		
		case(oh)
			5'd1:begin //ADDI
				rd_data    = op1 + op2;
				rd_addr    = rd_addr2ex;
				rd_wen2reg = 1'b1;
				
			end
			5'd2:begin //ADD
				rd_data    = op1 + op2;
				rd_addr    = rd_addr2ex;
				rd_wen2reg = 1'b1;
			end
			
			5'd3:begin //SUB
				rd_data    = op1 - op2;
				rd_addr    = rd_addr2ex;
				rd_wen2reg = 1'b1;
			end
			
			default:begin
				rd_data    = 32'b0;
				rd_addr    = 5'b0;
				rd_wen2reg = 1'b0;
			end
		endcase
		
	
	end



endmodule