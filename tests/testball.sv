`include "../modules/ball.sv"

`timescale 1ns/1ps
module testball();
	reg clk;
	reg reset;
	reg score_left;
	reg score_right;
	reg [10:0] ball_pos_x;
	reg [10:0] ball_pos_y;

	initial begin
		clk = 1'd1;
		reset = 1'd1;
		#20 reset = 1'd0;
	end

	ball ball_mod(
		.clk(clk),
		.reset(reset),
		.score_right(score_right),
		.score_left(score_left),
		.ball_pos_x(ball_pos_x),
		.ball_pos_y(ball_pos_y)
	);

	always begin
		#20;
		if (score_right || score_left) 
		begin
			clk = ~clk;
			reset = ~reset;
			#20; 
			clk = ~clk;
			reset = ~reset;
		end
		else 
			clk = ~clk;
	end

endmodule
