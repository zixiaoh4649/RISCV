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
	output reg        rd_wen2reg,

	//to ctrl
	output reg [31:0] jump_addr2ctrl,
	output reg 		  jump_en2ctrl,
	output reg        hold2ctrl
);

	//B type
	wire   [31:0] imm_jump;
	assign imm_jump = {{19{ins[31]}},ins[31], ins[7], ins[30:25], ins[11:8], 1'b0};
	wire   op1_equal_op2;
	assign op1_equal_op2 = (op1 == op2)? 1'b1:1'b0;

	//J type
	//wire   [31:0] imm_jal;
	//assign imm_jal = {12{ins[31]}, ins[31], ins[19:12], ins[20], ins[30:21], 1'b0};

	
	always @(*) begin

		//default
		rd_data    = 32'b0;
		rd_addr    = 5'b0;
		rd_wen2reg = 1'b0;
		jump_addr2ctrl = 32'b0;
		jump_en2ctrl   = 1'b0;
		hold2ctrl	   = 1'b0;
		
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

			//B type
			5'd4:begin //BNE
				if(~op1_equal_op2)begin
					jump_addr2ctrl = ins_addr2ex + imm_jump;
				end
				jump_en2ctrl = ~op1_equal_op2;
				hold2ctrl	 = 1'b0;
			end

			5'd5:begin //BEQ
				if(op1_equal_op2)begin
					jump_addr2ctrl = ins_addr2ex + imm_jump;
				end
				jump_en2ctrl = op1_equal_op2;
				hold2ctrl	 = 1'b0;
			end

			//U type
			5'd6:begin //LUI
				rd_data = {ins[31:12], 12'b0};
			end

			//J type
			5'd5:begin //Jal
				jump_addr2ctrl = ins_addr2ex + {{12{ins[31]}}, ins[31], ins[19:12], ins[20], ins[30:21], 1'b0};
				hold2ctrl	   = 1'b0;
				rd_data		   = ins_addr2ex + 32'd4;
				rd_addr        = rd_addr2ex;
				rd_wen2reg	   = 1'b1;
			end



			
		endcase
		
	
	end



endmodule