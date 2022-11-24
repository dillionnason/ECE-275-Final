`include "modules/slow_clock.sv"
`include "modules/ball.sv"
`include "modules/paddles.sv"
`include "modules/score.sv"

module pongtop (
	input [2:0] BUTTON,
	input CLOCK_50
);
	reg slw_clk;
	slow_clock slw_clk_mod(
		.fastclock(CLOCK_50), 
		.reset(BUTTON[2]), 
		.slowclock(slw_clk));

	reg paddle_state [19:0];
	paddles paddle_mod(
		.clk(slwclk), 
		.reset(BUTTON[2]), 
		.button_up(BUTTON[0]),
		.button_down(BUTTON[1]),
		.paddle_state(paddle_state[19:0]));

	reg ball_state [19:0];
	reg score_state [1:0];
	ball ball_mod(
		.clk(slw_clk),
		.reset(BUTTON[2]),
		.paddle_state(paddle_state[19:0]),
		.ball_pos(ball_state[19:0]),
		.score_state(score_state[1:0])
	);
	

endmodule
