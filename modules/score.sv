/*	score.sv
 * 
 *	Author: Dillion Nason 
 *  Github: https://github.com/dillionnason
 * 
 *  Author: Joshua Deveau
 *  Github: https://github.com/Altbot69
 *  
 *  Reads current score state and increments score accordingly.
 *  Outputs to Hex displays.
 */

module score (
	input clk,
	input reset,
	input reg score_right,
	input reg score_left,
	output [6:0] right_hex,
	output [6:0] left_hex,
	output game_over
);
	// 1. Registers
	reg [3:0] left_score;
	reg [3:0] right_score;
	reg end_game;
	wire [3:0] next_left_score;
	wire [3:0] next_right_score;

	// 2. Next state -> current state
	always @(posedge reset or posedge clk) 
	begin
		if (reset)
		begin
			left_score <= 4'b0000;
			right_score <= 4'b0000;
			end_game <= 1'b0;
		end

		else 
		begin
			/* If the next score is greater than 7 don't update the current value,
			 * set the game_over flag (end_game maps to that below), which tells the
			 * ball module to stop updating and wait for the reset signal */
			if (next_left_score > 4'b0111)
				end_game <= 1'b1;
			else
				left_score <= next_left_score;

			if (next_right_score > 4'b0111)
				end_game <= 1'b1;
			else
				right_score <= next_right_score;
		end
	end
	
	// 3. Map inputs + state -> next state
	// This will increment the next score value
	assign next_right_score = (score_right) ? right_score + 1 : right_score;
	assign next_left_score = (score_left) ? left_score + 1 : left_score;

	// 4. Map state -> output
  	BCD_Display left_score_bcd (
		.D(left_score[3:0]),
		.LED(left_hex[6:0])
	);

	BCD_Display right_score_bcd (
		.D(right_score[3:0]),
		.LED(right_hex[6:0])
	);

	assign game_over = end_game;
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
