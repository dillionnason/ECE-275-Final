//`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\ball.sv" //This will include the ball module for the ai

module paddles (
	input wire clk,
	input wire reset,
	input button_up,
	input button_down,
	//input reg [19:0] ball_state,
	input wire [9:0] player_paddle_x_position, //Can remain the same
	input wire [9:0] player_paddle_y_position, //This will be changeable given certain conditions
	input wire [9:0] ai_paddle_x_position, //Should remain the same
	input wire [9:0] ai_paddle_y_position, //This will be changeable given certain conditions
	//Include the nest positions here
	//input wire [9:0] player_paddle_next_y_position
	//input wire [9:0] ai_paddle_next_y_position
	output reg player_paddle,
	output reg ai_paddle
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
	
	/* Idea code to get me started noted not perfect
	
	
	//1.  Registers
	reg[8:0] player_paddle_y_position;
	reg[8:0] player_paddle_next_y_position;
	always @(posedge clk, posedge reset)
	begin
	if(reset)
	player_paddle_y_position <= 9'd240; //Puts paddle in middle position
	else
	player_paddle_y_position <= player_paddle_next_y_position; //assign D input to Q at rising edge of the clock
	end
	
	//2. input + state -> next state
	
	always @(*) 
	begin
	if(player_paddle_y_position ==9'd0) //Top of the screen
	begin
	if(button_down == 1 && button_up == 0)
	player_paddle_next_y_position = player_paddle_y_position + 1; //Moves the paddle down
	else
	player_paddle_next_y_position = player_paddle_y_position
	end else if (player_paddle_y_position == 9'd480) //Bottom of the screen
	begin
	if(button_up == 1 && button_down == 0)
	player_paddle_next_y_position = player_paddle_y_position - 1; //move up
	else
	player_paddle_next_y_position = player_paddle_y_position
	end else begin //middle of screen
	if(button_up == 1 && button_down == 0)
	player_paddle_next_y_position = player_paddle_next_y_position - 1; //move up
	else if(button_up == 0 && button_down == 1)
	player_paddle_next_y_position = player_paddle_y_position + 1; //Moves down
	else
	player_paddle_next_y_position = player_paddle_y_position; //stay
	end
	
	//3. Input state -> output
	//Nothing to do because state = player_paddle_y_position = output
	
	*/
endmodule

// Right paddle
module ai_paddle(
	input wire clk,
	input wire reset,
	input reg [19:0] ball_state,
	output reg [9:0] paddle_state
);
	// Looks at ball state to move
	
	
	
	/* Idea code for the ai paddle to get me started noted not perfect
	
	 *For this the idea is that the ai slide "tracks" the ball position so it bounces
	 *In order to achieve this my idea is that this slide will track the y position of the boucing ball and try to track it
	 *So it will look something like this below
	 
	 */
	 /*
	 
	 reg[8:0] ai_paddle_y_position;
	 reg[8:0] ai_paddle_next_y_position;
	 always @(posedge clk or reset)
	 if(reset)
	player_paddle_y_position <= 9'd240; //Puts paddle in middle position
	else
	ai_paddle_y_position <= ai_paddle_next_y_position; //assign D input to Q at rising edge of the clock
	end
	
	
	 always @(*)
	 begin
	 if(ball_pos_y > ai_paddle_y_position) //If the ball y position is greater then the ai paddle (that means the ball is below the ai paddle) 
	 ai_paddle_next_y_position = ai_paddle_y_position + 1; //Then the ai paddle will move down to be level with the ball 
	 else if(ball_pos_y < ai_paddle_y_position) //If the ball y position is lower then the ai paddle (that means the ball is above the ai paddle)
	 ai_paddle_y_position = ai_paddle_y_position - 1; //Then the ai paddle will move above to be level with the ball
	 end
	 */
	//The thing that would make this easier or harder is all dependant on the speed of the ai paddle
	
	
endmodule
