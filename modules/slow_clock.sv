module slow_clock
#(
	parameter MAX_COUNT
)

(
	input wire fastclock,
	input wire reset,
	output reg slowclock
);
	// 1. Registers/Flip-flops
	reg [27:0] count;	
	wire [27:0] dinputs;

	always @(posedge fastclock or posedge reset)
	begin
		if (reset)
			count <= 28'd0;
		else
			count <= dinputs;
	end

	// 2. Combinational Logic that maps from 
		// inputs + current state -> next state
	assign dinputs = (count == MAX_COUNT) ? 28'd0 : count + 1;
	
	// 3. Combinational Logic that maps from
		// Mealy: inputs + current state -> output
		// Moore: current state -> output
	assign slowclock = (count == 28'd0) ? 1'b1 : 1'b0;
endmodule
