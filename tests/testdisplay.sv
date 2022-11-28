`include "../modules/display.sv"
`include "../modules/DE0_VGA.v"

`timescale 1ns/1ps
module testdisplay();
	reg [9:0] X_pix;
	reg [9:0] Y_pix;
	reg [19:0] pixels;
	reg draw;

	display display_mod(
		.X_pix(X_pix),
		.Y_pix(Y_pix),
		.draw(draw)
	);

	initial 
	begin
		X_pix = 10'd0;
		Y_pix = 10'd0;
		pixels = 20'd0;
	end

	always 
	begin
		pixels += 20'd1;
		pixels = (pixels % 307200);
		X_pix += 10'd1;
		X_pix = (X_pix % 640);
		if (X_pix == 639)
			Y_pix += 1;
		Y_pix = (Y_pix % 480); 
		#20;
	end
endmodule
