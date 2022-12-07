`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\slow_clock.sv"
`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\ball.sv"
`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\paddles.sv"
`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\score.sv"
`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\DE0_VGA.v"
`include "C:\altera\13.0sp1\ModelSim Files and Modules for final Project\VGA\pong\Modules\display.sv"

module pongtop (
	input CLOCK_50,
	input [2:0] BUTTON,
	output [6:0] HEX0_D, 	// Right score output
	output [6:0] HEX1_D,  // Left score output
	output wire	[3:0]	VGA_R,		//Output Red
	output wire	[3:0]	VGA_G,		//Output Green
	output wire	[3:0]	VGA_B,		//Output Blue
	output wire	[0:0]	VGA_HS,		//Horizontal Sync
	output wire	[0:0]	VGA_VS		//Vertical Sync
);

	// Display driver stuff
	wire [9:0] X_pix;				//Location in X of the driver
	wire [9:0] Y_pix;				//Location in Y of the driver

	wire [0:0] H_visible;		//H_blank?
	wire [0:0] V_visible;		//V_blank?

	wire [0:0] pixel_clk;		//Pixel clock. Every clock a pixel is being drawn. 
	wire [9:0] pixel_cnt;		//How many pixels have been output.

	reg	[11:0] pixel_color;	//12 Bits representing color of pixel, 4 bits for R, G, and B
													//4 bits for Blue are in most significant position, Red in least
	
	// Pass pins and current pixel values to display driver
	DE0_VGA VGA_Driver
	(
		.clk_50(CLOCK_50),
		.pixel_color(pixel_color),
		.VGA_BUS_R(VGA_R), 
		.VGA_BUS_G(VGA_G), 
		.VGA_BUS_B(VGA_B), 
		.VGA_HS(VGA_HS), 
		.VGA_VS(VGA_VS), 
		.X_pix(X_pix), 
		.Y_pix(Y_pix), 
		.H_visible(H_visible),
		.V_visible(V_visible), 
		.pixel_clk(pixel_clk),
		.pixel_cnt(pixel_cnt)
	);


	// Parameters for the pong modules
	// Need to be signed
	localparam RIGHT_BOUNDARY = 637;
	localparam LEFT_BOUNDARY = 3;
	localparam TOP_BOUNDARY = 3;
	localparam BOTTOM_BOUNDARY = 477;
	localparam PLAYER_PADDLE_X = 10;
	localparam AI_PADDLE_X = 620;
	localparam PADDLE_WIDTH = 10;
	localparam PADDLE_HEIGHT = 46;
	localparam BALL_SIZE = 7;
	
	/* This tells the slow clock module how much to count. 
	 * Since it's based on the 18.43MHz pixel clock 1 cycle is 54 ns, 
	 * so total slow clock cycle will be MAX_COUNT * 54ns. 
	 * Works best if it is a multiple of 307200 (1 frame) */
	localparam MAX_COUNT = 20'd614400; 

	// Pong modules
	reg slw_clk;

	slow_clock 
	#(
		.MAX_COUNT(MAX_COUNT)
	) 
	slw_clk_mod(
		.fastclock(pixel_clk), 
		.reset(reset), 
		.slowclock(slw_clk)
	);

	// Paddle state and player input
	// reg paddle_state [19:0];
	wire [9:0] left_paddle_y = 10'd217;
	wire [9:0] right_paddle_y = 10'd217;
	// paddles paddle_mod(
	// 	.clk(slwclk), 
	// 	.reset(BUTTON[2]), 
	// 	.button_up(BUTTON[0]),
	// 	.button_down(BUTTON[1]),
	// 	.paddle_state(paddle_state[19:0]));

	// Ball state, collision detection, score detection
	reg signed [10:0] ball_x;
	reg signed [10:0] ball_y;
	reg score_right;
	reg score_left;

	ball 
	#(
		.BALL_SIZE(BALL_SIZE),
		.RIGHT_BOUNDARY(RIGHT_BOUNDARY),
		.LEFT_BOUNDARY(LEFT_BOUNDARY),
		.TOP_BOUNDARY(TOP_BOUNDARY),
		.BOTTOM_BOUNDARY(BOTTOM_BOUNDARY),
		.PADDLE_HEIGHT(PADDLE_HEIGHT),
		.PADDLE_WIDTH(PADDLE_WIDTH),
		.PLAYER_PADDLE_X(PLAYER_PADDLE_X),
		.AI_PADDLE_X(AI_PADDLE_X)
	)
	ball_mod(
		.clk(slw_clk),
		.reset(reset),
		.left_paddle_y(left_paddle_y),
		.right_paddle_y(right_paddle_y),
		.score_right(score_right),
		.score_left(score_left),
		.ball_pos_x(ball_x),
		.ball_pos_y(ball_y)
	);

	score score_mod(
		.clk(CLOCK_50),
		.reset(reset),
		.right_hex(HEX0_D),
		.left_hex(HEX1_D)
	);

	// This module holds all of the different draw modules (paddles, screen edge,
	// ball, score) and outputs when pixels should be white or black
	reg draw;
	/* This is a little hacky.
	 * The ball module needs the positions values to be signed (so, plus one bit
	 * for sign bit), whereas the display module is simpler with unsigned
	 * values (since no negative pixels). Since the max values are only 10 bits 
 	 * rather than 11, this section converts the values to unsigned, and then 
	 * the last bit is chopped off when they are connected to the display module */
	reg [10:0] unsigned_ball_x;
	reg [10:0] unsigned_ball_y;
	assign unsigned_ball_x = $unsigned(ball_x);
	assign unsigned_ball_y = $unsigned(ball_y);
	
	wire [9:0] player_paddle;
	wire [9:0] ai_paddle;

	display 
	#(
		.RIGHT_BOUNDARY(RIGHT_BOUNDARY),
		.LEFT_BOUNDARY(LEFT_BOUNDARY),
		.TOP_BOUNDARY(TOP_BOUNDARY),
		.BOTTOM_BOUNDARY(BOTTOM_BOUNDARY),
		.PLAYER_PADDLE_X(PLAYER_PADDLE_X),
		.AI_PADDLE_X(AI_PADDLE_X),
		.PADDLE_WIDTH(PADDLE_WIDTH),
		.BALL_SIZE(BALL_SIZE)
	)
	display_mod(
		.ball_x(unsigned_ball_x[9:0]),
		.ball_y(unsigned_ball_y[9:0]),
		.left_paddle(left_paddle_y),
		.right_paddle(right_paddle_y),
		.X_pix(X_pix),
		.Y_pix(Y_pix),
		.draw(draw),
		.player_paddle(player_paddle),
		.ai_paddle(ai_paddle)
	);
	
	
    paddles moving_mod(
	.clk(slw_clk),
	.reset(reset),
	.button_up(~BUTTON[1]),
	.button_down(~BUTTON[0]),
	.ball_pos_y(ball_y),
	.player_paddle(player_paddle),
	.ai_paddle(ai_paddle)
	);

	// Takes the output from the display module and tells the VGA driver what to
	// draw based on that
	always @(posedge pixel_clk)
	begin
		if (draw)
			pixel_color <= 12'b1111_1111_1111;
		else
			pixel_color <= 12'b0000_0000_0000;
	end

endmodule
