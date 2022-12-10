/*	pongtop.sv
 * 
 *	Author: Dillion Nason 
 *  Github: https://github.com/dillionnason
 * 
 *  Author: Joshua Deveau
 *  Github: https://github.com/Altbot69
 *  
 *  ECE 275 Final Project
 *  Pong implemented in System Verilog on the DE0 Development Board
 */

`include "modules/slow_clock.sv"
`include "modules/ball.sv"
`include "modules/paddles.sv"
`include "modules/score.sv"
`include "modules/DE0_VGA.v"
`include "modules/display.sv"

module pongtop (
	input CLOCK_50,
	input [2:0] BUTTON,
	input [9:0] SW,
	output [6:0] HEX0_D, 	// Right score output
	output [6:0] HEX3_D,    // Left score output
	output wire	[3:0]	VGA_R,		//Output Red
	output wire	[3:0]	VGA_G,		//Output Green
	output wire	[3:0]	VGA_B,		//Output Blue
	output wire	[0:0]	VGA_HS,		//Horizontal Sync
	output wire	[0:0]	VGA_VS		//Vertical Sync
);

	/*************************************************************************
	 * VGA driver                   										 *
	 *************************************************************************/
	wire [9:0] X_pix;		//Location in X of the driver
	wire [9:0] Y_pix;		//Location in Y of the driver

	wire [0:0] H_visible;	//H_blank?
	wire [0:0] V_visible;	//V_blank?

	wire [0:0] pixel_clk;	//Pixel clock. Every clock a pixel is being drawn. 
	wire [9:0] pixel_cnt;	//How many pixels have been output.

	reg	[11:0] pixel_color;	//12 Bits representing color of pixel, 4 bits for R, G, and B
							//4 bits for Blue are in most significant position, Red in least
	
	// Pass pins and current pixel values to VGA driver
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


	/*************************************************************************
	 * Pong parameters              										 *
	 *************************************************************************/
	localparam RIGHT_BOUNDARY = 637;
	localparam LEFT_BOUNDARY = 3;
	localparam TOP_BOUNDARY = 3;
	localparam BOTTOM_BOUNDARY = 477;
	localparam PLAYER_PADDLE_X = 10;
	localparam AI_PADDLE_X = 620;
	localparam PADDLE_WIDTH = 10;
	localparam PADDLE_HEIGHT = 46;
	localparam BALL_SIZE = 7;

	/*************************************************************************
	 * Pong registers and wires      										 *
	 *************************************************************************/
	 // difficulty settings
	reg player_speed;
	reg ai_speed;
	assign player_speed = (SW[1]) ? 1 : 0;
	assign ai_speed = (SW[0]) ? 1 : 0;
	
	/* This tells the slow clock module how much to count. 
	 * Since it's based on the 18.43MHz pixel clock 1 cycle is 54 ns, 
	 * so total slow clock cycle will be MAX_COUNT * 54ns. 
	 * Works best if it is a multiple of 307200 (1 frame) */
	reg [19:0] clock_speed;
	assign clock_speed = (SW[9]) ? 20'd307200 : 20'd614400; 

	// color settings
	reg color;
	assign color = (SW[8]) ? 1 : 0;

	wire reset = ~BUTTON[2];
	wire slw_clk;
	// Paddle positions
	wire [9:0] player_paddle;
	wire [9:0] ai_paddle;
	/* This is a little hacky.
	 * The ball module needs the positions values to be signed (so, plus one bit
	 * for sign bit), whereas the display module is simpler with unsigned
	 * values (since no negative pixels). Since the max values are only 10 bits 
 	 * rather than 11, this section converts the values to unsigned, and then 
	 * the last bit is chopped off when they are connected to the display module */
	reg signed [10:0] ball_x;
	reg signed [10:0] ball_y;
	reg [10:0] unsigned_ball_x;
	reg [10:0] unsigned_ball_y;
	assign unsigned_ball_x = $unsigned(ball_x);
	assign unsigned_ball_y = $unsigned(ball_y);
	// Game state conditions (set by the ball and score modules)
	reg score_right;
	reg score_left;
	wire game_over;
	// current "draw state", set by the display module based on the 
	// current X_pix and Y_pix outputs from the VGA driver
	reg red;
	reg green;
	reg blue;

	/*************************************************************************
	 * Pong modules                  										 *
	 *************************************************************************/
	
	// takes the 18.43MHz pixel clock and converts it to a 30Hz clock
	slow_clock slw_clk_mod(
		.fastclock(pixel_clk), 
		.reset(reset), 
		.clock_speed(clock_speed),
		.slowclock(slw_clk)
	);

	// Handles updating ball position, calculating collisions, score conditions
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
	ball_mod
	(
		.clk(slw_clk),
		.reset(reset),
		.game_over(game_over),
		.left_paddle_y(player_paddle),
		.right_paddle_y(ai_paddle),
		.score_right(score_right),
		.score_left(score_left),
		.ball_pos_x(ball_x),
		.ball_pos_y(ball_y)
	);	
		
	// Handles player input, moving paddles
  	paddles paddle_mod
	(
		.clk(slw_clk),
		.reset(reset),
		.button_up(~BUTTON[1]),
		.button_down(~BUTTON[0]),
		.player_speed(player_speed),
		.ai_speed(ai_speed),
		.ball_pos_y(ball_y),
		.player_paddle(player_paddle),
		.ai_paddle(ai_paddle)
	);

	// Handles incrementing score based on ball module outputs, outputing to Hex displays, 
	// outputing game_over signal to the ball if score > 7
	score score_mod
	(
		.clk(slw_clk),
		.reset(reset),
		.score_right(score_right),
		.score_left(score_left),
		.right_hex(HEX3_D[6:0]),
		.left_hex(HEX0_D[6:0]),
		.game_over(game_over)
	);

	// This module holds all of the different draw modules (paddles, screen edge,
	// ball, score) and outputs when pixels should be white or black
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
	display_mod
	(
		.ball_x(unsigned_ball_x[9:0]),
		.ball_y(unsigned_ball_y[9:0]),
		.player_paddle(player_paddle),
		.ai_paddle(ai_paddle),
		.X_pix(X_pix),
		.Y_pix(Y_pix),
		.color_switches(SW[4:2]),
		.reset(reset),
		.red(red),
		.green(green),
		.blue(blue)
	);

	// Takes the output from the display module and tells the VGA driver what to
	// draw based on that
	wire [3:0] red_sub = {4{red}};
	wire [3:0] green_sub = {4{green}};
	wire [3:0] blue_sub = {4{blue}};

	wire [11:0] pix_col = (color) ? { red_sub, green_sub, blue_sub } :
						  (red | green | blue) ? {12{1'b1}} : 12'd0;
	always @(posedge pixel_clk)
	begin
		pixel_color <= pix_col;
	end

endmodule
