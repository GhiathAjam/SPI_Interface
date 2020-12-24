module SPI(

input  reg  		clk,
input  reg  		reset,
input  reg  [1:0] 	slaveselct,

input  wire [7:0] 	min,
output wire [7:0] 	mout,
input  reg  [1:0] 	mode,

input  wire [7:0] 	s1in,
output wire [7:0] 	s1out,

input  wire [7:0] 	s2in,
output wire [7:0] 	s2out,

input  wire [7:0] 	s3in,
output wire [7:0] 	s3out
);

wire 			sclk;
wire 			ss1;
wire 			ss2;
wire 			ss3;

wire 			mosi;
wire [1:0] 		modeout;

wire 			miso;



master m(clk,sclk,mosi,miso,min,mout,mode,modeout,reset,slaveselct,ss1,ss2,ss3);

slave s1(sclk,ss1,reset,mosi,miso,s1in,s1out,modeout);
slave s2(sclk,ss2,reset,mosi,miso,s2in,s2out,modeout);
slave s3(sclk,ss3,reset,mosi,miso,s3in,s3out,modeout);


endmodule




module TesetBench_SPI();

reg  			clk;
reg  			reset;
reg [1:0] 		slaveselct;

wire [7:0] 		min  = 8'b01010101;
wire [7:0] 		mout;
reg  [1:0] 		mode;

wire [7:0] 		s1in = 8'b10101010;
wire [7:0] 		s1out;

wire [7:0] 		s2in = 8'b00000000;
wire [7:0] 		s2out;

wire [7:0] 		s3in = 8'b11111111;
wire [7:0] 		s3out;


SPI UUT(clk,reset,slaveselct,min,mout,mode,s1in,s1out,s2in,s2out,s3in,s3out);


always #5 clk<=~clk;
integer i , bi;
initial
	begin
	mode=2'b11;
	clk<= (mode[0] & mode[1]) | (~mode[0] & ~mode[1]);
	reset=1'b1;
	slaveselct = 2'b01;
  	$display("%b , %b , %b , %b  , %b , %b  , %b " ,mout,s1out,s2out,s3out,reset,mode,slaveselct);
  	#15 reset=0;
	
  	$display("%b , %b , %b , %b  , %b , %b  , %b " ,mout,s1out,s2out,s3out,reset,mode,slaveselct);
  	
	for(bi=0;bi<4;bi=bi+1)
		begin
		for(i=0;i<8;i=i+1)
			begin
			#10;
  			$display("%b , %b , %b , %b  , %b , %b  , %b " ,mout,s1out,s2out,s3out,reset,mode,slaveselct);
			end
		slaveselct=slaveselct+1'b1;
		end
  	$finish ;
	end 





endmodule





















