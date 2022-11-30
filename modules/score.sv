module score (
	input wire reset,
	input wire [1:0] score_state,
	output reg [6:0] left_score, //This will be the player 1 score
   output reg [6:0] right_score, //This will be the player 2/ai score
	output reg game_over
	//Inputs and outputs from Lab 6
	 input [7:0] SW,
    input CLOCK_50,
    output [6:0] HEX0_D,
    output [6:0] HEX1_D,
    output [6:0] HEX2_D
);

//This is the minimal Hex display for the score. We could create a seperate module file and it include it at the top.
//But for now I'll showcase it this way


    wire[7:0] binary_in = SW[7:0];

    reg [7:0] binary;
    reg [11:0] bcd;
//always procedural loop from Lab 6
    always @ (posedge CLOCK_50) begin
        binary = binary_in;
        bcd = 12'd0;

        for (int i = 0; i < 7; i = i + 1) begin
            bcd = bcd << 1;
            bcd[0] = binary[7];
            binary = binary << 1;

            if (bcd[3:0] >= 4'd5)
                bcd[3:0] = bcd[3:0] + 4'd3;

            if (bcd[7:4] >= 4'd5)
                bcd[7:4] = bcd[7:4] + 4'd3;

            if (bcd[11:8] >= 4'd5)
                bcd[11:8] = bcd[11:8] + 4'd3;
        end

        bcd = bcd << 1;
        bcd[0] = binary[7];
    end

    BCD_Display right_score (bcd[3:0], HEX0_D[6:0]);
    BCD_Display left_score (bcd[7:4], HEX1_D[6:0]);
    endmodule

//BCD_Display module
 
module BCD_Display (
    input [3:0] D,
    output [6:0] LED
);
    assign LED[0] = !((!D[3] & D[1]) | (D[3] & !D[2] & !D[1]) | (!D[3] & D[2] & D[0]) | (!D[3] & !D[2] & !D[0]));
    assign LED[1] = !((!D[3] & !D[2]) | (!D[3] & !D[1] & !D[0]) | (!D[3] & D[1] & D[0]) | (D[3] & !D[2] & !D[1]));
    assign LED[2] = !(!D[1] | (D[1] & (!D[3] & (D[2] | D[0]))));                
    assign LED[3] = !(D[3] | (D[1] & !D[2] & !D[3]) | (D[0] & !D[1] & D[2]) | (!D[0] & !D[2] & !D[3]) | (!D[0] & D[1] & D[2]));
    assign LED[4] = !((!D[0] & !D[2]) | (!D[0] & D[1]));                
    assign LED[5] =    !(D[3] | (!D[1] & D[2]) | (!D[0] & !D[1]) | (!D[0] & D[1] & D[2]));                        
    assign LED[6] = !(D[3] | (!D[1] & D[2]) | (!D[2] & D[1]) | (D[1] & !D[0]));                            
endmodule

endmodule
