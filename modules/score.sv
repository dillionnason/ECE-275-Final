module score (
	input wire reset,
	input wire [1:0] score_state,
	output reg [5:0] current_score,
	output reg game_over
);





/*
//This is the minimal Hex display for the score. We could create a seperate module file and it include it at the top.
//But for now I'll showcase it this way

module BCD_Display_Left_Score(
input [3:0] BCD,
output [6:0] LED_Segment //This would be replaced with current_score and every increment would change the HEX display
);

assign LED_Segment[0] = ((BCD[0]&!BCD[1])&(!BCD[2]&!BCD[3]))|((!BCD[0]&!BCD[1])&(BCD[2]&!BCD[3]))|((BCD[0]&BCD[1])&(!BCD[2]&BCD[3]))|((BCD[0]&!BCD[1])&(BCD[2]&BCD[3]));

assign LED_Segment[1] = (!BCD[1]*BCD[0]*!BCD[3]*BCD[2])+(!BCD[1]*!BCD[0]*BCD[3]*BCD[2])+(BCD[1]*BCD[0]*BCD[3])+(BCD[1]*!BCD[0]*BCD[2]);

assign LED_Segment[2] = (BCD[1]*!BCD[0]*!BCD[3]*!BCD[2])+(BCD[3]*BCD[2]*!BCD[1]*!BCD[0])+(BCD[3]*BCD[2]*BCD[1]);

assign LED_Segment[3] = (BCD[0]*BCD[1]*BCD[2])+(!BCD[0]*!BCD[1]*BCD[2]*!BCD[3])+(BCD[0]*!BCD[1]*!BCD[2]*!BCD[3])+(!BCD[0]*BCD[1]*!BCD[2]*BCD[3]);

assign LED_Segment[4] = (BCD[3]*!BCD[2]*!BCD[1]*BCD[0])+(!BCD[3]*BCD[0])+(!BCD[3]*BCD[2]*!BCD[1]*!BCD[0]);

assign LED_Segment[5] = (BCD[3]*BCD[2]*!BCD[1]*BCD[0])+(!BCD[3]*BCD[2]*BCD[1]*BCD[0])+(!BCD[3]*!BCD[2]*BCD[1]*!BCD[0])+(BCD[0]*!BCD[3]*!BCD[2]);

assign LED_Segment[6] = (!BCD[3]*!BCD[2]*!BCD[1])+(!BCD[3]*BCD[2]*BCD[1]*BCD[0])+(BCD[3]*BCD[2]*!BCD[1]*!BCD[0]);
endmodule

module BCD_Display_Right_Score(
input [3:0] BCD,
output [6:0] LED_Segment //This would be replaced with current_score and every increment would change the HEX display 
);

assign LED_Segment[0] = ((BCD[0]&!BCD[1])&(!BCD[2]&!BCD[3]))|((!BCD[0]&!BCD[1])&(BCD[2]&!BCD[3]))|((BCD[0]&BCD[1])&(!BCD[2]&BCD[3]))|((BCD[0]&!BCD[1])&(BCD[2]&BCD[3]));

assign LED_Segment[1] = (!BCD[1]*BCD[0]*!BCD[3]*BCD[2])+(!BCD[1]*!BCD[0]*BCD[3]*BCD[2])+(BCD[1]*BCD[0]*BCD[3])+(BCD[1]*!BCD[0]*BCD[2]);

assign LED_Segment[2] = (BCD[1]*!BCD[0]*!BCD[3]*!BCD[2])+(BCD[3]*BCD[2]*!BCD[1]*!BCD[0])+(BCD[3]*BCD[2]*BCD[1]);

assign LED_Segment[3] = (BCD[0]*BCD[1]*BCD[2])+(!BCD[0]*!BCD[1]*BCD[2]*!BCD[3])+(BCD[0]*!BCD[1]*!BCD[2]*!BCD[3])+(!BCD[0]*BCD[1]*!BCD[2]*BCD[3]);

assign LED_Segment[4] = (BCD[3]*!BCD[2]*!BCD[1]*BCD[0])+(!BCD[3]*BCD[0])+(!BCD[3]*BCD[2]*!BCD[1]*!BCD[0]);

assign LED_Segment[5] = (BCD[3]*BCD[2]*!BCD[1]*BCD[0])+(!BCD[3]*BCD[2]*BCD[1]*BCD[0])+(!BCD[3]*!BCD[2]*BCD[1]*!BCD[0])+(BCD[0]*!BCD[3]*!BCD[2]);

assign LED_Segment[6] = (!BCD[3]*!BCD[2]*!BCD[1])+(!BCD[3]*BCD[2]*BCD[1]*BCD[0])+(BCD[3]*BCD[2]*!BCD[1]*!BCD[0]);
endmodule

*/

endmodule
