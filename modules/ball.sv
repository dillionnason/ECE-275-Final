/*
 *  Bouncing ball example.
 *
 *  Ball will endlessly bounce around a 640x480 space.
 *
 */

module ball 
#(
	parameter BALL_SIZE = 10,
	parameter RIGHT_BOUNDARY = 637,
	parameter LEFT_BOUNDARY = 3,
	parameter TOP_BOUNDARY = 3,
	parameter BOTTOM_BOUNDARY = 477
)

(
	input wire clk, 
	input wire reset,
	output reg signed [10:0] ball_pos_x,
	output reg signed [10:0] ball_pos_y
);

	// these all have +1 bit from the original design for the sign bit
	reg signed [2:0] v_x;
	reg signed [2:0] v_y;
	reg signed [2:0] next_v_x;
	reg signed [2:0] next_v_y;

	reg signed [10:0] pos_x;
	reg signed [10:0] pos_y;
	reg signed [10:0] next_pos_x;
	reg signed [10:0] next_pos_y;

	// update state
	always @(posedge clk or posedge reset) 
	begin
		if (reset) 
		begin
			pos_x <= 11'd320;
			pos_y <= 11'd240;
			v_x <= 3'd1;
			v_y <= 3'd3;
		end

		else
		begin
			pos_x <= next_pos_x;
			pos_y <= next_pos_y;
			v_x <= next_v_x;
			v_y <= next_v_y;
		end
	end

	// inputs + state -> next state
	always @(pos_x, pos_y, v_x, v_y)  
	begin
		if ((pos_y + v_y) <= TOP_BOUNDARY) 	// top collision
		begin
			next_v_y <= -v_y;
			next_v_x <= v_x;
			next_pos_y <= TOP_BOUNDARY + 11'd1;
			next_pos_x <= pos_x + v_x;
		end

		else if ((pos_y + v_y) >= (BOTTOM_BOUNDARY - BALL_SIZE)) // bottom collision 
		begin
			next_v_y <= -v_y;
			next_v_x <= v_x;
			next_pos_y <= BOTTOM_BOUNDARY - 11'd1 - BALL_SIZE;
			next_pos_x <= pos_x + v_x;
		end

		else if ((pos_x + v_x) >= (RIGHT_BOUNDARY - BALL_SIZE)) // right collision
		begin
			next_v_y <= v_y;
			next_v_x <= -v_x;
			next_pos_y <= pos_y + v_y;
			next_pos_x <= RIGHT_BOUNDARY - 11'd1 - BALL_SIZE;
		end

		else if ((pos_x + v_x + BALL_SIZE) <= LEFT_BOUNDARY) // left collision
		begin
			next_v_y <= v_y;
			next_v_x <= -v_x;
			next_pos_y <= pos_y + v_y;
			next_pos_x <= LEFT_BOUNDARY + 11'd1;
		end

		else  // no collision
		begin
			next_v_y <= v_y;
			next_v_x <= v_x;
			next_pos_x <= pos_x + v_x;
			next_pos_y <= pos_y + v_y;
		end
	end

	// inputs + state -> output
	assign ball_pos_x = pos_x;
	assign ball_pos_y = pos_y;
endmodule
