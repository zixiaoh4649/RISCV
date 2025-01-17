`timescale 1ns/100ps

module Testbench;

	reg clk;
	reg rst;

	always #10 clk = ~clk;

	RISCV_soc RISCV_soc_inst(
		.clk(clk),
		.rst(rst)
	);


	initial begin
		clk<= 1'b1;
		rst<= 1'b0;

		#30;

		rst <= 1'b1;
	end


	initial begin
		$readmemh("./inst_txt/rv32ui-p-lb.txt", Testbench.RISCV_soc_inst.rom_inst.rom_mem);
	end


	wire x3  = Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[3];
	wire x26 = Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[26];
	wire x27 = Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[27];
	integer i;

	initial begin
			
			wait(x26 == 32'b1);
			#25;
			if(x27 == 32'b1)begin
				$display("@@@@ pass @@@@");
			end else begin
				$display("#########fail#########");
				for(i=0;i<32;i=i+1)begin
					$display("x%2d is %d", i, Testbench.RISCV_soc_inst.riscv_inst.regs_inst.regs[i]);
				end
			end
	end

	// integer n;
	// initial begin
	// 	for(n=0;n<1000;n=n+10)begin
	// 		#10;
	// 		$display("time:%d, x27:%d", n, x27);
	// 	end
	// end

	time start_time, end_time;
	real elapsed_time;

	initial begin
    	start_time = $time; 

		wait(x26 == 32'b1);

		end_time = $time; 
		elapsed_time = (end_time - start_time) / 1000.0; 
		$display("Time: %0f us", elapsed_time);
	end



endmodule