module paddles (
	input wire clk,
	input wire reset,
	input button_up,
	input button_down,
	input wire [9:0] ball_pos_y,
	output reg [9:0] player_paddle,
	output reg [9:0] ai_paddle
);
	// left paddle
	player_paddle player(
		.clk(clk),
		.reset(reset),
		.button_up(button_up),
		.button_down(button_down),
		.player_paddle(player_paddle)
	);

	// right paddle
	ai_paddle ai(
		.clk(clk),
		.reset(reset),
		.ball_pos_y(ball_pos_y),
		.ai_paddle(ai_paddle)
	);
endmodule

// Left paddle
module player_paddle(
	input wire clk,
	input wire reset,
	input button_up,
	input button_down,
	output [9:0] player_paddle
	
);
	// Looks at button inputs to move
	//1.  Registers
	reg [9:0] player_paddle_x_position; //Can remain the same
	reg [9:0] player_paddle_y_position; //This will be changeable given certain conditions
	reg [9:0] player_paddle_next_y_position;

	always @(posedge clk or posedge reset)
	begin
		if(reset)
			player_paddle_y_position <= 10'd240; //Puts paddle in middle position
		else
			player_paddle_y_position <= player_paddle_next_y_position; //assign D input to Q at rising edge of the clock
	end
	
	//2. input + state -> next state
	always @(*) 
	begin
		if(player_paddle_y_position == 10'd0) //Top of the screen
		begin
			if(button_down == 1 && button_up == 0)
				player_paddle_next_y_position <= player_paddle_y_position + 1; //Moves the paddle down
			else
				player_paddle_next_y_position <= player_paddle_y_position;
		end
		
		if (player_paddle_y_position == 10'd480) //Bottom of the screen
		begin
			if(button_up == 1 && button_down == 0)
				player_paddle_next_y_position <= player_paddle_y_position - 1; //move up

			if(button_up == 0 && button_down == 0)
				player_paddle_next_y_position <= player_paddle_y_position;
		end 

		else
		begin //middle of screen
			if(button_up == 1 && button_down == 0)
				player_paddle_next_y_position <= player_paddle_y_position - 1; //move up

			if(button_up == 0 && button_down == 1)
				player_paddle_next_y_position <= player_paddle_y_position + 1; //Moves down

			if(button_up == 0 && button_down == 0)
				player_paddle_next_y_position <= player_paddle_y_position; //stay
		end
	end
	
	
	assign player_paddle = player_paddle_y_position;
	//3. Input state -> output
	//Nothing to do because state = player_paddle_y_position = output
	
endmodule

// Right paddle
module ai_paddle(
	input wire clk,
	input wire reset,
	input wire [9:0] ball_pos_y,
	output [9:0] ai_paddle
);
	// Looks at ball state to move
	
	/* Idea code for the ai paddle to get me started noted not perfect
	 * For this the idea is that the ai slide "tracks" the ball position so it bounces
	 * In order to achieve this my idea is that this slide will track the y position of the boucing ball and try to track it
	 * So it will look something like this below
	 */

	reg [9:0] ai_paddle_x_position; //Should remain the same
	reg [9:0] ai_paddle_y_position; //This will be changeable given certain conditions
	reg [9:0] ai_paddle_next_y_position;
	
	always @(posedge clk or posedge reset)
	begin
		if(reset)
			ai_paddle_y_position <= 9'd240; //Puts paddle in middle position
		else
			ai_paddle_y_position <= ai_paddle_next_y_position; //assign D input to Q at rising edge of the clock
	end
	
	
	always @(*)
	begin
		if(ball_pos_y > ai_paddle_y_position) //If the ball y position is greater then the ai paddle (that means the ball is below the ai paddle) 
			ai_paddle_next_y_position = ai_paddle_y_position + 1; //Then the ai paddle will move down to be level with the ball 

		if(ball_pos_y < ai_paddle_y_position) //If the ball y position is lower then the ai paddle (that means the ball is above the ai paddle)
			ai_paddle_next_y_position = ai_paddle_y_position - 1; //Then the ai paddle will move above to be level with the ball
	end

	assign ai_paddle = ai_paddle_y_position; 
	
	//The thing that would make this easier or harder is all dependant on the speed of the ai paddle
	
endmodule
