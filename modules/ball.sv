/*	ball.sv
 * 
 *	Author: Dillion Nason 
 *  Github: https://github.com/dillionnason
 *  
 *  Updates ball position, calculates collisions, sets score signals
 */

module ball 
#(
	parameter BALL_SIZE = 10,
	parameter RIGHT_BOUNDARY = 637,
	parameter LEFT_BOUNDARY = 3,
	parameter TOP_BOUNDARY = 3,
	parameter BOTTOM_BOUNDARY = 477,
	parameter PADDLE_HEIGHT = 46,
	parameter PADDLE_WIDTH = 10,
	parameter PLAYER_PADDLE_X = 10,
	parameter AI_PADDLE_X = 620
)

(
	input wire clk, 
	input wire reset,
	input wire game_over,
	input wire [9:0] left_paddle_y,
	input wire [9:0] right_paddle_y,
	output reg score_right,
	output reg score_left,
	output reg signed [10:0] ball_pos_x,
	output reg signed [10:0] ball_pos_y
);

	// 1. Registers
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

	// passes the paddle positions to the procedural blocks (converting them to signed)
	wire [10:0] left_paddle_pos_unsigned = { 1'b0, left_paddle_y[9:0] };
	wire [10:0] right_paddle_pos_unsigned = { 1'b0, right_paddle_y[9:0] };

	wire signed [10:0] left_paddle_pos = $signed(left_paddle_pos_unsigned);
	wire signed [10:0] right_paddle_pos = $signed(right_paddle_pos_unsigned);

	// 2. Next state -> current state
	always @(posedge clk or posedge reset) 
	begin
		if (reset) 
		begin
			pos_x <= 11'd320;
			pos_y <= 11'd240;
			v_x <= 3'd1;
			v_y <= 3'd0;
			left_collision <= 1'b0;
			right_collision <= 1'b0;
		end

		else if (~game_over)
		begin
			pos_x <= next_pos_x;
			pos_y <= next_pos_y;
			v_x <= next_v_x;
			v_y <= next_v_y;
			left_collision <= next_left_collision;
			right_collision <= next_right_collision;
		end
	end

	// 3. Map inputs + state -> next state
	// calculates collisions and score conditions
	always @(*)  
	begin
		paddle_collision = 1'b0;
		next_left_collision = 1'b0;
		next_right_collision = 1'b0;

		/*****************************************************************
		 * 					RIGHT PADDLE COLLISION 						 *
		 *****************************************************************/
		if ((pos_x + v_x) >= (AI_PADDLE_X - BALL_SIZE) && (pos_x + v_x) <= (AI_PADDLE_X + PADDLE_WIDTH)) // is it entering the right paddles column
		begin
			paddle_collision = 1'b1;

			if ( ((pos_y + v_y) >= right_paddle_pos) && ((pos_y + v_y) <= (right_paddle_pos + 11'd7)) ) // -2, -3 collision
			begin
				next_v_y <= -3'd3;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd8)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd14))) // -2, -2 collision
			begin
				next_v_y <= -3'd2;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd15)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd21))) // -3, -1 collision
			begin
				next_v_y <= -3'd1;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd22)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd28))) // -3, 0 collision
			begin
				next_v_y <= 3'd0;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd29)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd35))) // -3, 1 collision
			begin
				next_v_y <= 3'd1;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd36)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd42))) // -2, 2 collision
			begin
				next_v_y <= 3'd2;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else if (((pos_y + v_y) >= (right_paddle_pos + 11'd43)) && ((pos_y + v_y) <= (right_paddle_pos + 11'd49))) // -1, 3 collision
			begin
				next_v_y <= 3'd3;
				next_v_x <= -3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= AI_PADDLE_X - BALL_SIZE - 1;
			end

			else 
				paddle_collision = 1'b0;
		end

		/*****************************************************************
		 * 					 LEFT PADDLE COLLISION 						 *
		 *****************************************************************/
		else if ((pos_x + v_x) <= (PLAYER_PADDLE_X + PADDLE_WIDTH) && (pos_x + v_x) >= (PLAYER_PADDLE_X)) // is it entering the left paddles column
		begin
			paddle_collision = 1'b1;

			if ( ((pos_y + v_y) >= left_paddle_pos) && ((pos_y + v_y) <= (left_paddle_pos + 11'd7)) ) // 2, -3 collision
			begin
				next_v_y <= -3'd3;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else if (((pos_y + v_y) >= (left_paddle_pos + 11'd8)) && ((pos_y + v_y) <= (left_paddle_pos + 11'd14))) // 2, -2 collision
			begin
				next_v_y <= -3'd2;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else if (((pos_y + v_y) >= (left_paddle_pos + 11'd15)) && ((pos_y + v_y) <= (left_paddle_pos + 11'd21))) // 3, -1 collision
			begin
				next_v_y <= -3'd1;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else if (((pos_y + v_y) >= (left_paddle_pos + 11'd22)) && ((pos_y + v_y) <= (left_paddle_pos + 11'd28))) // 3, 0 collision
			begin
				next_v_y <= 3'd0;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else if (((pos_y + v_y) >= (left_paddle_pos + 11'd29)) && ((pos_y + v_y) <= (left_paddle_pos + 11'd35))) // 3, 1 collision
			begin
				next_v_y <= 3'd1;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else if (((pos_y + v_y) >= (left_paddle_pos + 11'd36)) && ((pos_y + v_y) <= (left_paddle_pos + 11'd42))) // 2, 2 collision
			begin
				next_v_y <= 3'd2;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else if (((pos_y + v_y) >= (left_paddle_pos + 11'd43)) && ((pos_y + v_y) <= (left_paddle_pos + 11'd49))) // 1, 3 collision
			begin
				next_v_y <= 3'd3;
				next_v_x <= 3'd2;
				next_pos_y <= pos_y + v_y;
				next_pos_x <= PLAYER_PADDLE_X + PADDLE_WIDTH + 1;
			end

			else 
				paddle_collision = 1'b0;
		end

		/*****************************************************************
		 * 						EDGE COLLISIONS    				   		 *
		 *****************************************************************/
		if (paddle_collision == 1'b0)
		begin
		next_left_collision = 1'b0;
		next_right_collision = 1'b0;

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
				next_pos_x <= 11'd320;
				next_pos_y <= 11'd240;
				next_v_x <= 3'd1;
				next_v_y <= 3'd0;
				next_right_collision = 1'b1;
			end

			else if ((pos_x + v_x) <= LEFT_BOUNDARY) // left collision
			begin
				next_pos_x <= 11'd320;
				next_pos_y <= 11'd240;
				next_v_x <= 3'd1;
				next_v_y <= 3'd0;
				next_left_collision = 1'b1;
			end

			/*****************************************************************
			* 						  NO COLLISIONS    				   		 *
			*****************************************************************/
			else
			begin
				next_v_y <= v_y;
				next_v_x <= v_x;
				next_pos_x <= pos_x + v_x;
				next_pos_y <= pos_y + v_y;
			end
		end
	end

	// 4. Map state -> output
	assign ball_pos_x = pos_x;
	assign ball_pos_y = pos_y;
	assign score_right = right_collision;
	assign score_left = left_collision;
endmodule
