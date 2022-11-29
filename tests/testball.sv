`include "../modules/ball.sv"

`timescale 1ns/1ps
module testball();
	reg clk;
	reg reset;
	reg [10:0] ball_pos_x;
	reg [10:0] ball_pos_y;

	initial begin
		clk = 1'd1;
		reset = 1'd1;
		#54 reset = 1'd0;
	end

	ball 
	#(
		.BALL_SIZE(10),
		.RIGHT_BOUNDARY(637),
		.LEFT_BOUNDARY(3),
		.TOP_BOUNDARY(3),
		.BOTTOM_BOUNDARY(477)
	)
	ball_mod(
		.clk(clk),
		.reset(reset),
		.ball_pos_x(ball_pos_x),
		.ball_pos_y(ball_pos_y)
	);

	always begin
		#54 clk = ~clk;
	end
endmodule
