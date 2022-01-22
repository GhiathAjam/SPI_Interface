
// LFSR,  PRBS , 1+X14+X15
// 0110 1110 0010 101
//
//clk reset seed load enable
//
//AC BC D2 11 4D AE 15 77 C6 DB F4 C9
//55 8A C4 A5 3A 17 24 E1 63 AC 2B F9




module LFSR( 

input			 clk,
input 			rst,
input 			en,
output reg [1:15] 	 Y,
input			ld,
input[1:15]		seed
);

   wire [1:15] nxt;

initial Y = 15'b011011100010101;
always @(posedge clk or posedge rst)
    if (rst)
      Y <= 15'b011011100010101;
    else if(en)
	if(ld)
	Y<=seed;
	else
	Y<=nxt; 
	
assign nxt = {Y[15]^Y[15-1],Y[1:15-1]};     

endmodule



module Randomizer(
  	input		d_in,
	input		clk,
	input		 rst,
	input		en,
 	output 		d_out,
	input		ld,
	input[1:15]	seed
);
//input d_in,clk, rst,en;
//output d_out;

 wire [1:15]Y;
LFSR a(clk,rst,en,Y,ld,seed);

assign d_out=d_in^Y[1];

endmodule



