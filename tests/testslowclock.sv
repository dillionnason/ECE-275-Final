`timescale 1ns/1ps
module testslowclock();
	reg fastclk;
	reg reset;
	wire clock;

	initial begin
		fastclk = 0;
	end

	always begin
		#5 fastclk = ~fastclk;
	end

	//slow_clock slwclk (fastclk, reset, clock);
endmodule
