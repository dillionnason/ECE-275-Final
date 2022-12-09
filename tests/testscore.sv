`include "../modules/score.sv"
`include "../modules/ball.sv"

`timescale 1ns/1ps
module testscore();
	// score
	reg clk;
	reg reset;
	reg score_left;
	reg score_right;
	reg [6:0] right_hex;
	reg [6:0] left_hex;
	reg game_over;

	// ball
	reg [9:0] right_paddle;
	reg [9:0] left_paddle;
	reg [10:0] ball_pos_x;
	reg [10:0] ball_pos_y;

	initial
	begin
		clk = 1'b0;
		reset = 1'b1;
		score_left = 1'b0;
		score_right = 1'b0;
		right_paddle = 10'd217;
		left_paddle = 10'd257;
		#54; 
		reset = 1'b0;
	end

	score score_mod(
		.clk(clk),
		.reset(reset),
		.score_left(score_left),
		.score_right(score_right),
		.right_hex(right_hex),
		.left_hex(left_hex),
		.game_over(game_over)
	);

	ball ball_mod(
		.clk(clk),
		.reset(reset),
		.left_paddle_y(left_paddle),
		.right_paddle_y(right_paddle),
		.score_right(score_right),
		.score_left(score_left),
		.ball_pos_x(ball_pos_x),
		.ball_pos_y(ball_pos_y)
	);

	always
	begin
		#54 clk = ~clk;
	end
endmodule
