`timescale 1ns/1ns
module testslowclock();
	reg fastclk;
	reg reset;
	wire clock;

	slow_clock 
	#(
		.MAX_COUNT(20'd614400)
	)
	slwclk (
		.fastclock(fastclk), 
		.reset(reset),
		.slowclock(clock)
	);

	initial begin
		fastclk = 0;
		reset = 1;
		#54 reset = 0; // 54 ns reset pulse
	end

	always begin
		#54 fastclk = ~fastclk; // 54 ns = 18.63MHz (Pixel Clock) 
	end
endmodule
