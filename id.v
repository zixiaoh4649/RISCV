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
	wire [31:0] mem_addr;

	//I type
	assign opcode=ins[6:0];
	assign rd    =ins[11:7];
	assign f3    =ins[14:12];
	assign rs1   =ins[19:15];
	assign mem_addr = rs1+{{20{ins[31]}}, ins[31:20]};


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

			//I type and part of R type ？？？？？
			7'b1100111:begin
				oh 	    = 7'd4;
				op1	    =rs1_data;
				op2     ={{20{ins[31]}}, ins[31:20]};
				rs1_addr=rs1;
				rs2_addr=5'b0;
				rd_addr =rd;
				rd_wen  =1'b1;				
			end
			7'b0000011:begin
				op1	    =rs1_data;
				op2     =mem_addr[1:0]; //byte offset
				rs1_addr=mem_addr[31:2]>>2;
				rs2_addr=5'b0;
				rd_addr =rd;
				rd_wen  =1'b1;
				case(f3)
					3'b000: oh = 7'd11; //LB
					3'b001: oh = 7'd12; //LH
					3'b010: oh = 7'd13; //LW
					3'b100: oh = 7'd14; //LBU
					3'b101: oh = 7'd15; //LHUS
				endcase
			end
			7'b0010011:begin  
				op1	    =rs1_data;
				op2     ={{20{ins[31]}}, ins[31:20]};
				rs1_addr=rs1;
				rs2_addr=5'b0;
				rd_addr =rd;
				rd_wen  =1'b1;
				case(f3) 
					3'b000: oh = 7'd19;	//ADDI
					3'b010: oh = 7'd20;	//SLTI
					3'b011: oh = 7'd21;	//SLTIU						
					3'b001:begin 		//SLLI
						oh =7'd25; 
						op2 = rs2; //shamt
					end
					3'b101:begin
						op2 = rs2; //shamt
						case(f7)
							7'b0000000: oh = 7'd26; //SRLI					
							7'b0100000: oh = 7'd27; //SRAI 
						endcase
					end
					3'b100: oh = 7'd22; //XORI
					3'b110: oh = 7'd23; //ORI
					3'b111: oh = 7'd24; //ANDI
				endcase
			end




			//R type
			7'b0110011:begin 
				op1	    =rs1_data;
				op2     =rs2_data;
				rs1_addr=rs1;
				rs2_addr=rs2;
				rd_addr =rd;
				rd_wen  =1'b1;				
				case(f3)
					3'b000:begin
						case(f7)
							7'b0000000: oh =7'd28; //ADD
							7'b0100000: oh =7'd29; //SUB
						endcase
					end
					3'b001: oh =7'd30; //SLL
					3'b010: oh =7'd31;//SLT						
					3'b011: oh =7'd32;//SLTU
					3'b100: oh =7'd33;//XOR
					3'b101:begin
						case(f7)					
							7'b0000000: oh =7'd34;//SRL								
							7'b0100000: oh =7'd35;//SRA
						endcase
					end
					3'b110: oh =7'd36;//OR								
					3'b111: oh =7'd37;//AND								
				endcase
			end
			//R type

			//B type
			7'b1100011: begin
				op1       = rs1_data;
				op2       = rs2_data;
				rs1_addr  = rs1;
				rs2_addr  = rs2;
				rd_addr   = 5'b0;
				rd_wen    = 1'b0;
				oh = 7'd0; //default
				case (f3)
					3'b001: oh = 7'd6;  // BNE
					3'b000: oh = 7'd5;  // BEQ
					3'b100: oh = 7'd7;  // BLT
					3'b101: oh = 7'd8;  // BGE
					3'b110: oh = 7'd9;  // BLTU
					3'b111: oh = 7'd10; // BGEU
				endcase
			end
			
			//U type
			7'b0110111:begin //LUI
				oh  	=7'd1;
				op1		={ins[31:12], 12'b0};
				op2		=32'b0;
				rs1_addr=5'b0;
				rs2_addr=5'b0;
				rd_addr =rd;
				rd_wen  =1'b1;	
			end
			7'b0010111:begin //AUIPC
				oh  	=7'd2;
				op1		={ins[31:12], 12'b0};
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