module TestBench;

reg clk, res, en;
reg ld;
initial clk =0;
always #5 clk=~clk;
reg [1:96] ip = 'hACBCD2114DAE1577C6DBF4C9 ;
reg [1:96] op = 0;
reg [1:15] seed;
reg d_in;
wire d_out,bit;
integer i;
Randomizer Rz(d_in,clk,res,en,d_out,ld,seed);
initial begin
////put ld=1 then put seed u want ex.seed=15'b11011100010101
ld=0;
//seed = 15'b11011100010101;
////
res=0;
en=1;
#5 ld=0;
for (i = 1; i < 97; i = i + 1) begin
 assign d_in = ip[i];
 #10 op[i] = d_out;

end
en = ~en;
$display(" input in hex= %h ",ip);
$display(" output in hex= %h ",op);
end

endmodule


