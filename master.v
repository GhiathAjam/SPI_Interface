module master(

input 			clk,
output 			sclk,
output reg 		mosi,
input 			miso,
input  wire [7:0] 	dataincopy,
output wire [7:0] 	dataout,
input  wire [1:0] 	mode,
output wire [1:0] 	modeout,
input 			reset,
input  wire [1:0] 	slaveselct,
output  		selctslave1,selctslave2,selctslave3
);

reg [7:0] datain;
initial 
    datain = dataincopy;

assign sclk = clk;
assign selctslave1 = ~( slaveselct[0] & ~slaveselct[1]);
assign selctslave2 = ~(~slaveselct[0] &  slaveselct[1]);
assign selctslave3 = ~( slaveselct[0] &  slaveselct[1]);

always @ (posedge clk )
	begin
  	if(reset |  slaveselct == 2'b00)
    		datain = dataincopy;
  	else if ( mode == 0 | mode == 2'b11 )
    		begin
    		datain[7:1]=datain[6:0];
    		datain[0]<=miso;
    		end
  	else
    		mosi=datain[7];
	end

always @(negedge clk )
	begin
  	if(reset |  slaveselct == 2'b00)
    		datain = dataincopy;
    	else if( mode == 0 | mode == 2'b11) 
    		mosi=datain[7];      
	else
    		begin
    		datain[7:1] = datain[6:0];
    		datain[0] <= miso;
    		end
	end

assign dataout = datain;
assign modeout = mode;

endmodule 


module testbench_master();

reg  		clk;
reg  		reset;
reg  [1:0] 	slaveselct;
wire 		ss1;
wire 		ss2;
wire 		ss3;
wire 		sclk;
wire 		mosi;
reg  		miso;
wire [7:0] 	in = 8'b11001100;
wire [7:0] 	out;
reg  [1:0] 	mode;
wire [1:0] 	modeout;
reg  [7:0] 	masterin=8'b10101010; 
integer 	i;

master m(clk,sclk,mosi,miso,in,out,mode,modeout,reset,slaveselct,ss1,ss2,ss3);

always #5 clk<=~clk;

initial
	begin
	//slaveselct=2'b00;
	slaveselct=2'b01;
	reset=1'b1;
	mode<=2'b01;
	clk<=(mode[0] & mode[1]) | (~mode[0] & ~mode[1]);
  	$display("%d , %b , %b , %b , %b , %b ,%b , %b , %b , %b , %b " ,sclk,mosi,miso,in,out,modeout,reset,slaveselct,ss1,ss2,ss3);
  	#10 reset=0;
  	$display("%d , %b , %b , %b , %b , %b ,%b , %b , %b , %b , %b " ,sclk,mosi,miso,in,out,modeout,reset,slaveselct,ss1,ss2,ss3);
  	for(i=0;i<9;i=i+1)
		begin
  		miso<=masterin[i%8];
		#10;
  		$display("%d , %b , %b , %b , %b , %b ,%b , %b , %b , %b , %b " ,sclk,mosi,miso,in,out,modeout,reset,slaveselct,ss1,ss2,ss3);
		end
  	$finish ;
	end 

endmodule





