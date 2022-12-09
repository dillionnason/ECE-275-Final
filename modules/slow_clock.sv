/*	slow_clock.sv
 * 
 *	Author: Dillion Nason 
 *  Github: https://github.com/dillionnason
 * 
 *  Author: Joshua Deveau
 *  Github: https://github.com/Altbot69
 *  
 *  Takes fastclock (pixel_clk) and outputs a synced slower clock signal.
 *  Counts to 614400 (two frames).
 */

module slow_clock
#(
	parameter MAX_COUNT
)

(
	input wire fastclock,
	input wire reset,
	output reg slowclock
);
	// 1. Registers/Flip-flops
	reg [19:0] count;	
	wire [19:0] dinputs;

	always @(posedge fastclock or posedge reset)
	begin
		if (reset)
			count <= 20'd0;
		else
			count <= dinputs;
	end

	// 2. Combinational Logic that maps from 
		// inputs + current state -> next state
	assign dinputs = (count == MAX_COUNT) ? 20'd0 : count + 1;
	
	// 3. Combinational Logic that maps from
		// Mealy: inputs + current state -> output
		// Moore: current state -> output
	assign slowclock = (count <= (MAX_COUNT >> 1)) ? 1'b1 : 1'b0;
endmodule
