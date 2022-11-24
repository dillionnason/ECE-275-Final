module paddles (
	input wire clk,
	input wire reset,
	input button_up,
	input button_down,
	input reg [19:0] ball_state,
	output reg [19:0] paddle_state
);
	player_paddle player(
		.clk(clk),
		.reset(reset),
		.button_up(button_up),
		.button_down(button_down),
		.paddle_state(player_paddle[9:0])
	);

	ai_paddle ai(
		.clk(clk),
		.reset(reset),
		.ball_state(ball_state),
		.paddle_state(paddle_state[19:10])
	);
endmodule

// Left paddle
module player_paddle(
	input wire clk,
	input wire reset,
	input button_up,
	input button_down,
	output reg [9:0] paddle_state
);
	// Looks at button inputs to move
endmodule

// Right paddle
module ai_paddle(
	input wire clk,
	input wire reset,
	input reg [19:0] ball_state,
	output reg [9:0] paddle_state
);
	// Looks at ball state to move
endmodule
