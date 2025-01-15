module riscv(
    input wire clki,
    input wire rsti,

    output wire [31:0] pc2rom,
    input  wire [31:0] rom_ins
);

    wire [31:0] pc_o;
    pc_reg pc_reg_inst (
        .clk (clki),
        .rst (rsti),
        .pc_o(pc_o)
    );

    //from ifetch 
    wire [31:0] ins2id;
    wire [31:0] ins_addr;
    //to if_id

    //from if_id
    wire [31:0] ins_addr2id;
    wire [31:0] ins;
    //to id
    
    //from id to regs
    wire [4:0]  rs1_addr_regs;
    wire [4:0]  rs2_addr_regs;
    wire [4:0]  rs1_data;
    wire [4:0]  rs2_data;

    //from id
    wire [31:0] ins2ex;
    wire [31:0] ins_addr_id2idex;
    wire [31:0] op1;
    wire [31:0] op2;
    wire [4:0]  rd_addr;
    wire        rd_wen;
    wire [4:0]  oh_id2idex;
    //to id_ex

    //from id_ex
    wire [31:0] op1_ex;
    wire [31:0] op2_ex;
    wire [31:0] ins_addr2ex;
    wire [31:0] ins_ex_i;
    wire [4:0]  rd_addr_ex;
    wire [31:0] rd_wen_ex;
    wire [4:0]  oh_ex;
    //to ex

    //from ex to regs
    wire [4:0]  rd_addr_ex2regs;
    wire [31:0] rd_data_o;
    wire        rd_wen_o;


    ifetch ifetch_inst (
        .pc_o    (pc_o),
        .rom_ins (rom_ins),
        .pc2rom  (pc2rom),
        .ins2id  (ins2id),
        .ins_addr(ins_addr) //for later branch addr calculate
        
    );


    if_id if_id_ins(
        .clk        (clki),
        .rst        (rsti),
        .ins2id     (ins2id),
        .ins_addr   (ins_addr),
        .ins_addr2id(ins_addr2id),
        .ins        (ins) 
    );


    id id_inst(
        .ins_addr2id(ins_addr2id),
        .ins        (ins),
        .rs1_addr   (rs1_addr_regs),
        .rs2_addr   (rs2_addr_regs),
        .rs1_data   (rs1_data),
        .rs2_data   (rs2_data),
        .op1        (op1),
        .op2        (op2),
        .ins2ex     (ins2ex),
        .ins_addr   (ins_addr_id2idex),
        .rd_addr    (rd_addr),    
        .rd_wen     (rd_wen),
        .oh         (oh_id2idex) 
	    );


    regs regs_inst(
	    .clk             (clki),
	    .rst             (rsti),
	    .rs1_addr        (rs1_addr_regs),
	    .rs2_addr        (rs2_addr_regs),
	    .rd_forward_data (rd_data_o),                     
	    .rd_forward_addr (rd_addr_ex2regs),
	    .rd_wen          (rd_wen_o),
	    .rs1_data        (rs1_data),
	    .rs2_data	     (rs2_data)
    );

    
    id_ex id_ex_inst(
        //input
        .clk         (clki),
        .rst         (rsti),
        .op1         (op1),
        .op2         (op2),
        .ins2ex      (ins2ex),
        .ins_addr    (ins_addr_id2idex),
        .rd_addr     (rd_addr),
        .rd_wen      (rd_wen),
        .oh_in       (oh_id2idex),
        //output
        .op1_ex      (op1_ex),
        .op2_ex      (op2_ex),
        .ins         (ins_ex_i),
        .ins_addr2ex (ins_addr2ex),
        .rd_addr2ex  (rd_addr_ex),
        .rd_wen2ex   (rd_wen_ex),
        .oh          (oh_ex)
    );


    ex ex_inst(
        //input
	    .ins       (ins_ex_i),
	    .ins_addr2ex(ins_addr2ex),
	    .op1       (op1_ex),    
	    .op2       (op2_ex),    
	    .rd_addr2ex(rd_addr2ex), 
	    .rd_wen    (rd_wen_ex),  
	    .oh        (oh_ex),
        //output
	    .rd_addr   (rd_addr_ex2regs),
	    .rd_data   (rd_data_o),
	    .rd_wen2reg(rd_wen_o)
    );



endmodule