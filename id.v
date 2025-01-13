module id(

	//input from if_id
	input wire [31:0] ins_addr2id,
	input wire [31:0] ins,
	
	//between id and regs
	output wire [4:0] rs1_addr,
	output wire [4:0] rs2_addr,
	input wire [31:0] rs1_data,
	input wire [31:0] rs2_data,
	
	//output to id_ex
	output wire [4:0] op1,
	output wire [4:0] op2,
	output wire [4:0] rs1_o,	//?
	output wire [4:0] rs2_o,	//?
	output wire [31:0] ins2ex,
	output wire [31:0] ins_addr,
	output wire [4:0] rd_addr,
	output wire 	  rd_wen
			
);
	
	wire [6:0] opcode;
	wire [4:0] rd;
	wire [2:0] f3;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [11:0] imm_i;

	//I type
	assign opcode=ins[6:0];
	assign rd    =ins[11:7];
	assign f3    =ins[14:12];
	assign rs1   =ins[19:15];
	assign imm_i =ins[31:20];



	always @(*) begin
		
		ins2ex  =ins;
		ins_addr=ins_addr2id;
		
		case(opcode)
			7'b0010011: begin	//I type 
				case(f3) 
					000:begin	//ADDI
						op1	    =rs1;
						op2     ={{20{imm_i[11]}},imm_i};
						rs1_addr=rs1;
						rs2_addr=5'b0;
						rd_addr =rd;
						rd_wen  =1'b1;
					end
					default:begin
						op1=32'b0;
						op2=32'b0;
						rs1_addr=5'b0;
						rs2_addr=5'b0;
						rd_addr =5'b0;
						rd_wen  =1'b0;			
					end
				endcase
			end
			
			
			default:begin
			end							
		
		endcase//type
	
	end//always

endmodule