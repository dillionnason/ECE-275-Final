module score (
	input clk,
	input reset,
	input reg score_right,
	input reg score_left,
	output [2:0] left_score_out, //This will be the player 1 score
  output [2:0] right_score_out, //This will be the player 2/ai score
	output [6:0] right_hex,
	output [6:0] left_hex,
	output game_over
);
	// scores
	reg [2:0] left_score;
	reg [2:0] right_score;

	// reset state
	always @(posedge reset) 
	begin
		left_score <= 3'b000;
		right_score <= 3'b000;
	end

	// score incrementing
	always @(score_left, score_right) 
	begin
		if (score_left)
			left_score = left_score + 3'd1;
		
		if (score_right) 
			right_score = right_score + 3'd1;
	end

	// convert left score to BCD
	wire [2:0] left_binary_in = left_score[2:0];
	reg [2:0] left_binary;
	reg [3:0] left_bcd;

	always @(posedge clk) 
	begin
			left_binary = left_binary_in;
			left_bcd = 4'd0;

			for (int i = 0; i < 3; i = i + 1) 
			begin
					left_bcd = left_bcd << 1;
					left_bcd[0] = left_binary[3];
					left_binary = left_binary << 1;

					if (left_bcd >= 4'd5)
							left_bcd = left_bcd + 4'd3;
			end

			left_bcd = left_bcd << 1;
			left_bcd[0] = left_binary[3];
	end

	// convert scores to BCD
  BCD_Display left_score_hex (
		.D(left_bcd[3:0]),
		.LED(left_hex[6:0])
	);

	// score outputs
	assign left_score_out[2:0] = left_score[2:0];
	assign right_score_out[2:0] = right_score[2:0];
endmodule

// Binary to BCD
module BCD_Display (
	input [3:0] D,
	output [6:0] LED
);
	assign LED[0] = !((!D[3] & D[1]) | (D[3] & !D[2] & !D[1]) | (!D[3] & D[2] & D[0]) | (!D[3] & !D[2] & !D[0]));
	assign LED[1] = !((!D[3] & !D[2]) | (!D[3] & !D[1] & !D[0]) | (!D[3] & D[1] & D[0]) | (D[3] & !D[2] & !D[1]));
	assign LED[2] = !(!D[1] | (D[1] & (!D[3] & (D[2] | D[0]))));                
	assign LED[3] = !(D[3] | (D[1] & !D[2] & !D[3]) | (D[0] & !D[1] & D[2]) | (!D[0] & !D[2] & !D[3]) | (!D[0] & D[1] & D[2]));
	assign LED[4] = !((!D[0] & !D[2]) | (!D[0] & D[1]));                
	assign LED[5] = !(D[3] | (!D[1] & D[2]) | (!D[0] & !D[1]) | (!D[0] & D[1] & D[2]));                        
	assign LED[6] = !(D[3] | (!D[1] & D[2]) | (!D[2] & D[1]) | (D[1] & !D[0]));                            
endmodule
