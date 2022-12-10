`include "C:/altera/ECE-275-Final/modules/paddles.sv"

`timescale 1ns/1ps
module testpaddle();
	reg clk;
	reg reset;
	reg button_up;
	reg button_down;
	reg [9:0] ball_pos_y;
	reg [9:0] player_paddle;
	reg [9:0] ai_paddle;
	reg player_speed;
	reg ai_speed;

	initial
	begin
		clk = 1'b0;
		reset = 1'b1;
		button_up = 1'b0;
		button_down = 1'b0;
		ball_pos_y = 10'd270;
		player_speed = 1'b0;
		ai_speed = 1'b0;
		#54;
		reset = 1'b0;
	end

	paddles paddle_mode(
		.clk(clk),
		.reset(reset),
		.button_up(button_up),
		.button_down(button_down),
		.player_speed(player_speed),
		.ai_speed(ai_speed),
		.ball_pos_y(ball_pos_y),
		.player_paddle(player_paddle),
		.ai_paddle(ai_paddle)
	);

	always
	begin
		#54 clk = ~clk;
	end

endmodule
