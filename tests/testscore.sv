/* Include the module file so you can instantiate it in the testbench */
`include "../modules/score.sv"

/* timestep/precision pretty much always leave this the same */
`timescale 1ns/1ps
/* test bench modules don't need any inputs or outputs */
module testscore();
	/* register for each of the inputs and outputs
	 * I just name them the same as they are in the module, can be seen below */
	reg clk;
	reg reset;
	reg score_left;
	reg score_right;
	reg [2:0] left_score_out; 
  reg [2:0] right_score_out; 
	reg [6:0] right_hex;
	reg [6:0] left_hex;
	reg game_over;

	/* Initial block runs once, I always do a reset pulse in the intial block 
	 * (set high, wait time step, set low) */
	initial
	begin
		clk = 1'b0;
		reset = 1'b1;
		score_left = 1'b0;
		score_right = 1'b0;
		#54; 
		reset = 1'b0;
	end

	/* Instantiate module with all the registers from above */
	score score_mod(
		.clk(clk),
		.reset(reset),
		.score_left(score_left),
		.score_right(score_right),
		.left_score_out(left_score_out),
		.right_score_out(right_score_out),
		.right_hex(right_hex),
		.left_hex(left_hex),
		.game_over(game_over)
	);

	/* This runs constantly, the one thing that is always needed is toggling
	 * the clock each time step. This one just toggles the score states back and 
	 * forth to test the score incrementing */
	always
	begin
		#54 clk = ~clk;
	end
endmodule
