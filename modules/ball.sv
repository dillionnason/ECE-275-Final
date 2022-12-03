module ball 
#(
	parameter BALL_SIZE = 10,
	parameter RIGHT_BOUNDARY = 637,
	parameter LEFT_BOUNDARY = 3,
	parameter TOP_BOUNDARY = 3,
	parameter BOTTOM_BOUNDARY = 477,
	parameter PADDLE_HEIGHT = 46,
	parameter PADDLE_WIDTH = 10,
	parameter PLAYER_PADDLE_X = 46,
	parameter AI_PADDLE_X = 620
)

(
	input wire clk, 
	input wire reset,
	input wire [9:0] left_paddle_y,
	input wire [9:0] right_paddle_y,
	output reg score_right,
	output reg score_left,
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

	/* these are just to pass the score condition from the procedural
	 * blocks to the output */
	reg left_collision;
	reg right_collision;
	reg paddle_collision;

	reg next_left_collision;
	reg next_right_collision;

	// passes the paddle positions to the procedural blocks
	wire [10:0] left_paddle_pos_unsigned = { 1'b0, left_paddle_y[9:0] };
	wire [10:0] right_paddle_pos_unsigned = { 1'b0, right_paddle_y[9:0] };

	wire signed [10:0] left_paddle_pos = $signed(left_paddle_pos_unsigned);
	wire signed [10:0] right_paddle_pos = $signed(right_paddle_pos_unsigned);

	// update state
	always @(posedge clk or posedge reset) 
	begin
		if (reset) 
		begin
			pos_x <= 11'd320;
			pos_y <= 11'd240;
			v_x <= 3'd1;
			v_y <= 3'd3;
			left_collision <= 1'b0;
			right_collision <= 1'b0;
		end

		else
		begin
			pos_x <= next_pos_x;
			pos_y <= next_pos_y;
			v_x <= next_v_x;
			v_y <= next_v_y;
			left_collision <= next_left_collision;
			right_collision <= next_right_collision;
		end
	end

	// inputs + state -> next state
	always @(*)  
	begin
		paddle_collision = 1'b0;

		if ((pos_x + v_x) >= (AI_PADDLE_X - BALL_SIZE) && (pos_x + v_x) <= (AI_PADDLE_X + PADDLE_WIDTH)) // is it entering the right paddles column
		begin
			paddle_collision = 1'b1;

			if ( ((pos_y + v_y) >= right_paddle_pos) && ((pos_y + v_y) <= (right_paddle_pos + 11'd7)) ) // -1, -3 collision
			begin
				next_v_y <= -3'd3;
				next_v_x <= -3'd1;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd8)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd14))) // -2, -2 collision
			begin
				next_v_y <= -3'd2;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd15)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd21))) // -3, -1 collision
			begin
				next_v_y <= -3'd1;
				next_v_x <= -3'd3;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd22)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd28))) // -3, 0 collision
			begin
				next_v_y <= 3'd0;
				next_v_x <= -3'd3;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd29)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd35))) // -3, 1 collision
			begin
				next_v_y <= 3'd1;
				next_v_x <= -3'd3;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd36)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd42))) // -2, 2 collision
			begin
				next_v_y <= 3'd2;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd43)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd49))) // -1, 3 collision
			begin
				next_v_y <= 3'd3;
				next_v_x <= -3'd1;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else 
				paddle_collision = 1'b0;
		end

		if (paddle_collision == 1'b0)
		begin
			if ((pos_y + v_y) <= TOP_BOUNDARY) 	// top collision
			begin
				next_v_y <= -v_y;
				next_v_x <= v_x;
				next_pos_y <= TOP_BOUNDARY + 11'd1;
				next_pos_x <= pos_x + v_x;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			else if ((pos_y + v_y) >= (BOTTOM_BOUNDARY - BALL_SIZE)) // bottom collision 
			begin
				next_v_y <= -v_y;
				next_v_x <= v_x;
				next_pos_y <= BOTTOM_BOUNDARY - 11'd1 - BALL_SIZE;
				next_pos_x <= pos_x + v_x;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end

			/* the next two conditions only need to flip the score bits
			 * as once the score module has updated it will reset the rest of the
			 * modules, including this one */
			else if ((pos_x + v_x) >= (RIGHT_BOUNDARY - BALL_SIZE)) // right collision
				next_right_collision <= 1'b1;
			else if ((pos_x + v_x + BALL_SIZE) <= LEFT_BOUNDARY) // left collision
				next_left_collision <= 1'b1;

			else  // no collision
			begin
				next_v_y <= v_y;
				next_v_x <= v_x;
				next_pos_x <= pos_x + v_x;
				next_pos_y <= pos_y + v_y;
				next_left_collision <= 1'b0;
				next_right_collision <= 1'b0;
			end
		end
	end

	// inputs + state -> output
	assign ball_pos_x = pos_x;
	assign ball_pos_y = pos_y;
	assign score_right = right_collision;
	assign score_left = left_collision;
endmodule
