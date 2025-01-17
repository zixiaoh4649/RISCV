module id(

	//input from if_id
	input wire [31:0] ins_addr2id,
	input wire [31:0] ins,
	
	//between id and regs
	output reg [4:0] rs1_addr,
	output reg [4:0] rs2_addr,
	input wire [31:0] rs1_data,
	input wire [31:0] rs2_data,
	
	//output to id_ex
	output reg [31:0] op1,
	output reg [31:0] op2,
	output reg [31:0] ins2ex,
	output reg [31:0] ins_addr,
	output reg [4:0]  rd_addr,    
	output reg 	      rd_wen,
	output reg [6:0]  oh

			
);
	
	wire [6:0]  opcode;
	wire [4:0]  rd;
	wire [2:0]  f3;
	wire [4:0]  rs1;
	wire [4:0]  rs2;
	wire [11:0] imm_i;
	wire [6:0]  f7;
	

	//I type
	assign opcode=ins[6:0];
	assign rd    =ins[11:7];
	assign f3    =ins[14:12];
	assign rs1   =ins[19:15];
	assign imm_i =ins[31:20];
	
	//R type
	assign f7    =ins[31:25];
	assign rs2   =ins[24:20];



	always @(*) begin
		
		ins2ex  =ins;
		ins_addr=ins_addr2id;
		//default
		oh      =7'b0;
		op1		=32'b0;
		op2		=32'b0;
		rs1_addr=5'b0;
		rs2_addr=5'b0;
		rd_addr =5'b0;
		rd_wen  =1'b0;	
					 
		case(opcode)

			//I type
			7'b0010011:begin  
				case(f3) 
					3'b000:begin	//ADDI
						oh  =7'd19;
						op1	    =rs1_data;
						op2     ={{20{imm_i[11]}},imm_i};
						rs1_addr=rs1;
						rs2_addr=5'b0;
						rd_addr =rd;
						rd_wen  =1'b1;
					end
					3'b010:begin	//SLTI
						oh  	=7'd20;
						op1		=rs1_data;
						op2		={{20{ins[31]}}, ins[31:20]}; //op2 as imm_i here
						rs1_addr=rs1;
						rs2_addr=5'b0;
						rd_addr =rd;
						rd_wen  =1'b1;			
					end
					3'b011:begin	//SLTIU
						oh  	=7'd21;
						op1		=rs1_data;
						op2		={{20{ins[31]}}, ins[31:20]};
						rs1_addr=rs1;
						rs2_addr=5'b0;
						rd_addr =rd;
						rd_wen  =1'b1;			
					end
					3'b001:begin
						case(f7)
							7'b0000000:begin //SLLI
								oh      =7'd25;
								op1	    =rs1_data;
								op2     =rs2;
								rs1_addr=rs1;
								rs2_addr=5'b0;
								rd_addr =rd;
								rd_wen  =1'b1;
							end
						endcase
					end
					3'b101:begin
						case(f7)
							7'b0000000:begin //SRLI
								oh      =7'd26;
								op1	    =rs1_data;
								op2     ={{27'b0}, rs2};
								rs1_addr=rs1;
								rs2_addr=5'b0;
								rd_addr =rd;
								rd_wen  =1'b1;
							end
							7'b0100000:begin //SRAI
								oh      =7'd27;
								op1	    =rs1_data;
								op2     =rs2; //shamt
								rs1_addr=rs1;
								rs2_addr=5'b0;
								rd_addr =rd;
								rd_wen  =1'b1;
							end
						endcase
					end



				endcase
			end


			//R type
			7'b0110011:begin 
				case(f3)
					3'b000:begin
						case(f7)
							7'b0000000:begin //ADD
								oh      =7'd28;
								op1	    =rs1_data;
								op2     =rs2_data;
								rs1_addr=rs1;
								rs2_addr=rs2;
								rd_addr =rd;
								rd_wen  =1'b1;
							end						
							7'b0100000:begin //SUB
								oh      =7'd29;
								op1	    =rs1_data;
								op2     =rs2_data;
								rs1_addr=rs1;
								rs2_addr=rs2;
								rd_addr =rd;
								rd_wen  =1'b1;
							end											
						endcase
					end
					
				endcase
			end
			//R type

			//B type
			7'b1100011:begin 
				case(f3)
					3'b001:begin //BNE
						oh		=7'd6;
						op1		=rs1_data;
						op2		=rs2_data;
						rs1_addr=rs1;
						rs2_addr=rs2;
						rd_addr =5'b0;
						rd_wen  =1'b0;
					end
					3'b000:begin //BEQ
						oh		=7'd5;
						op1		=rs1_data;
						op2		=rs2_data;
						rs1_addr=rs1;
						rs2_addr=rs2;
						rd_addr =5'b0;
						rd_wen  =1'b0;
					end
					3'b100:begin //BLT
						oh		=7'd7;
						op1		=rs1_data;
						op2		=rs2_data;
						rs1_addr=rs1;
						rs2_addr=rs2;
						rd_addr =5'b0;
						rd_wen  =1'b0;
					end
					3'b101:begin //BGE
						oh		=7'd8;
						op1		=rs1_data;
						op2		=rs2_data;
						rs1_addr=rs1;
						rs2_addr=rs2;
						rd_addr =5'b0;
						rd_wen  =1'b0;
					end
					3'b110:begin //BLTU
						oh		=7'd9;
						op1		=rs1_data;
						op2		=rs2_data;
						rs1_addr=rs1;
						rs2_addr=rs2;
						rd_addr =5'b0;
						rd_wen  =1'b0;
					end
					3'b111:begin //BGEU
						oh		=7'd10;
						op1		=rs1_data;
						op2		=rs2_data;
						rs1_addr=rs1;
						rs2_addr=rs2;
						rd_addr =5'b0;
						rd_wen  =1'b0;
					end
				endcase
			end

			//U type
			7'b0110111:begin //LUI
				oh  	=7'd1;
				op1		=32'b0;
				op2		=32'b0;
				rs1_addr=5'b0;
				rs2_addr=5'b0;
				rd_addr =rd;
				rd_wen  =1'b1;	
			end

			//J type
			7'b1101111:begin //JAL
				oh		=7'd3;
				op1		=32'b0;
				op2		=32'b0;
				rs1_addr=5'b0;
				rs2_addr=5'b0;
				rd_addr =rd;
				rd_wen  =1'b1;
			end
					
		endcase//type
	
	end//always

endmodule