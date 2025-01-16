`timescale 1ns/100ps

module Testbench;

	reg clk;
	reg rst;

	always #10 clk = ~clk;

	initial begin
		clk<= 1'b1;
		rst<= 1'b0;

		#30;

		rst <= 1'b1;
	end


	initial begin
		$readmemh(".\inst_txt\rv32ui-p-add.txt", Testbench.RISCV_soc_inst.rom_inst.rom_mem);
	end


	wire x3  = Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[3];
	wire x26 = Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[26];
	wire x27 = Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[27];
	integer i;

	initial begin
		while(1)begin
			@(posedge clk)
			// $display("x27 is %d", Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[27]);
			// $display("x28 is %d", Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[28]);
			// $display("x29 is %d", Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[29]);
			// $display("<-------------------->");
			// $display("<-------------------->");

			wait(x26 == 32'b1);
			#200;
			if(x27 == 32'b1)begin
				$display("#########pass#########")；
			end else begin
				$display("#########fail#########");
				for(i=0;i<32;i=i+1)begin
					$display("x%2d is %d", i, Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[i]);
				end

			end

		end

	end

	RISCV_soc RISCV_soc_inst(
		.clk(clk),
		.rst(rst)
	);


endmodule