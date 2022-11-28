`timescale 1ns/1ps
module testslowclock();
	reg fastclk;
	reg reset;
	wire clock;

	slow_clock slwclk (fastclk, reset, clock);

	initial begin
		fastclk = 0;
		reset = 1;
		#20 reset = 0;
	end

	always begin
		#5 fastclk = ~fastclk;
	end
endmodule
