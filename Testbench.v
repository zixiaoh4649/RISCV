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
		$readmemb("ins.txt", Testbench.RISCV_soc_inst.rom_inst.rom_mem);
	end


	initial begin
		while(1)begin
			@(posedge clk)
			$display("x27 is %d", Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[27]);
			$display("x28 is %d", Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[28]);
			$display("x29 is %d", Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[29]);
			$display("<-------------------->");
			$display("<-------------------->");
		end

	end

	RISCV_soc RISCV_soc_inst(
		.clk(clk),
		.rst(rst)
	);


endmodule