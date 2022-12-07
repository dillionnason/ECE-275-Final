// Checks all of the draw conditions and outputs
// whether the current pixel should be on or off
module display 
#(
	parameter RIGHT_BOUNDARY = 637,
	parameter LEFT_BOUNDARY = 3,
	parameter TOP_BOUNDARY = 3,
	parameter BOTTOM_BOUNDARY = 477,
	parameter PLAYER_PADDLE_X = 10'd10,
	parameter AI_PADDLE_X = 10'd620,
	parameter PADDLE_WIDTH = 10'd10,
	parameter PADDLE_HEIGHT = 10'd46,
	parameter BALL_SIZE = 10'd10
)

(
	input [9:0] ball_x,
	input [9:0] ball_y,
	input reg [9:0] player_paddle, //left paddle
	input reg [9:0] ai_paddle,     //Right paddle
	input [9:0] X_pix,
	input [9:0] Y_pix,
	output draw
);
	// number of boxes for generate block
	localparam N = 3;

	// Parameters for each box
	// 	1. Player paddle (left)
	// 	2. AI paddle (right)
	// 	3. Ball
	wire [9:0] boxes_x [N] = '{ PLAYER_PADDLE_X, AI_PADDLE_X, ball_x[9:0] };
	wire [9:0] boxes_y [N] = '{ player_paddle[9:0], ai_paddle[9:0], ball_y[9:0] };
	wire [9:0] boxes_width [N] = '{ PADDLE_WIDTH, PADDLE_WIDTH, BALL_SIZE };
	wire [9:0] boxes_height [N] = '{ PADDLE_HEIGHT, PADDLE_HEIGHT, BALL_SIZE };
	wire [N-1:0] boxes;

	genvar i;
	generate
		for(i=0; i<N; i=i+1) begin : box_module_generate
			box_module box_i (
				.X_pix(X_pix),
				.Y_pix(Y_pix),
				.box_x(boxes_x[i]),
				.box_y(boxes_y[i]),
				.box_width(boxes_width[i]),
				.box_height(boxes_height[i]),
				.box(boxes[i])
			);
		end
	endgenerate

	// Draws a border on the screen
	reg screen_edge;
	screen_boundary 
	#(
		.RIGHT_BOUND(RIGHT_BOUNDARY),
		.LEFT_BOUND(LEFT_BOUNDARY),
		.TOP_BOUND(TOP_BOUNDARY),
		.BOTTOM_BOUND(BOTTOM_BOUNDARY)
	) 
	edges (
		.X_pix(X_pix),
		.Y_pix(Y_pix),
		.draw(screen_edge)
	);

	// toggle pixel if any of the above modules have output
	assign draw = (boxes | screen_edge) ? 1 : 0;
endmodule


// Check if the pixel is within the box using combinational logic
module box_module(
	input [9:0] X_pix,
	input [9:0] Y_pix,
	input [9:0] box_x,
	input [9:0] box_y,
	input [9:0] box_width,
	input [9:0] box_height,
	output wire box
);
	// these make the assignment easier to read
	wire left_bound = X_pix > box_x;
	wire right_bound = X_pix < (box_x+box_width);
	wire top_bound = Y_pix > box_y;
	wire bottom_bound = Y_pix < (box_y+box_height);

	assign box = (left_bound && right_bound && top_bound && bottom_bound) ? 1 : 0;
endmodule


// Adds a border to the screen so it's clearer where the boundaries are 
module screen_boundary
#(
	parameter RIGHT_BOUND = 637,
	parameter LEFT_BOUND = 3,
	parameter TOP_BOUND = 3,
	parameter BOTTOM_BOUND = 477
)

(
	input [9:0] X_pix,
	input [9:0] Y_pix,
	output wire draw
);
	wire left = (X_pix < LEFT_BOUND) ? 1 : 0;
	wire right = (X_pix > RIGHT_BOUND) ? 1 : 0;
	wire top = (Y_pix < TOP_BOUND) ? 1 : 0;
	wire bottom = (Y_pix > BOTTOM_BOUND) ? 1 : 0;

	assign draw = (left || right || top || bottom) ? 1 : 0;
endmodule
