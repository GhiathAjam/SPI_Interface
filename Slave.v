module slave (

input 		sclk,
input 		cs,
input 		reset,
input 		mosi,
output reg 	miso,
input [7:0] 	dataincopy,
output[7:0] 	dataout,
input [1:0] 	smode
);

reg   [7:0] datain;
initial
    datain=dataincopy;

always @ (posedge sclk)
	begin
	if (reset)
		datain=dataincopy;
	else if (~cs)
  		begin		
		if (smode==0 | smode==2'b11)
  			begin
    			datain[7:1]=datain[6:0];
    			datain[0]<=mosi;
  			end
		else
 			begin
    			miso=datain[7];
  			end  
  		end

	else
    		miso=1'bz;
	end

always @(negedge sclk)
	begin
	if (reset)
		datain=dataincopy;
	else if(~cs)
		begin
 		if(smode==0 | smode==2'b11) 
			begin
    			miso=datain[7];      
			end
		else
  			begin
     	 		datain[7:1]=datain[6:0];
     	 		datain[0]<=mosi;
  			end	
		end
	else
  		miso=1'bz;
	end

assign dataout=datain;

endmodule


module testbench_slave();

reg 		reset;
reg 		sclk;
reg 		mosi;
wire 		miso;
reg 		cs;
wire[7:0] 	in=8'b11001100;
wire[7:0] 	out;
reg [1:0] 	smode;
reg [7:0] 	slavein=8'b10101010; 
integer 	i;

slave s(sclk,cs,reset,mosi,miso,in,out,smode);

always #5 sclk<=~sclk;

initial
	begin
	reset=1'b1;
	cs=1'b0;
	//cs=1'b1;
	smode<=2'b01;
	sclk<=(smode[0] & smode[1]) | (~smode[0] & ~smode[1]);
  	$display("%d , %b , %b , %b , %b , %b , %b, %b " ,sclk,miso,mosi,in,out,smode,reset,cs);
  	#10 reset=0;
  	$display("%d , %b , %b , %b , %b , %b , %b, %b " ,sclk,miso,mosi,in,out,smode,reset,cs);
  	for(i=0;i<9;i=i+1)
		begin
  		mosi<=slavein[i%8];
		#10;
  		$display("%d , %b , %b , %b , %b , %b , %b , %b " ,sclk,miso,mosi,in,out,smode,reset,cs);
		end
  	$finish ;
	end 

endmodule




