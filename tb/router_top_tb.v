module router_top_tb;
	reg clock,resetn;
	reg read_enb_0,read_enb_1, read_enb_2;
	reg[7:0] data_in;
	reg pkt_valid;
	
	reg [5:0] payload_len;
	reg [7:0] header,parity;
	reg [1:0]addr;
	reg [7:0] payload_data;
	
	wire [7:0] data_out_0, data_out_1, data_out_2;
	wire valid_out_0, valid_out_1, valid_out_2;
	wire error, busy;
	
	parameter cycle=2;
	integer i;
	
router_top DUT(.clock(clock),.resetn(resetn),.payload_len(payload_len),.addr(addr),.header(header),.parity(parity),.read_enb_0(read_enb_0),.read_enb_1(read_enb_1),.read_enb_2(read_enb_2),
					.pkt_valid(pkt_valid),.data_in(data_in),.data_out_0(data_out_0),.data_out_1(data_out_1),.data_out_2(data_out_2),
					.valid_out_0(valid_out_0),.valid_out_1(valid_out_1),.valid_out_2(valid_out_2),.error(error),.busy(busy));

initial
	begin
	clock=1'b0;
	forever
	#(cycle/2)clock=~clock;
	end
		
task rst_dut();
	begin
	@(negedge clock)
	 resetn=1'b0;
	@(negedge clock)
	 resetn=1'b1;
	end
endtask

task initialize();
	begin
	read_enb_0=0;
	read_enb_1=0;
	read_enb_2=0;
	data_in=0;
	pkt_valid=0;
	end
endtask




task pkt_one();
	begin
	@(negedge clock)
	pkt_valid=1'b1;
	payload_len=6'd10;
	addr=2'b00;
	parity=0;
	header={payload_len,addr};
	read_enb_0<=1'b0;
	data_in=header;
	parity=parity^header; 
	#5;
	for(i=0; i<payload_len; i=i+1)
			begin
			@(negedge clock);
			payload_data={$random}%256;
			data_in =payload_data;
			parity=parity^data_in;
			end
			@(negedge clock);
			pkt_valid=0;
			data_in=parity;
	end
endtask

task pkt_two();
	begin
	@(negedge clock)
	pkt_valid=1'b1;
	payload_len=6'd14;
	addr=2'b01;
	parity=0;
	header={payload_len,addr};
	read_enb_1<=1'b0;
	data_in=header;
	parity=parity^header; 
	for(i=0; i<payload_len; i=i+1)
			begin
			@(negedge clock);
			payload_data={$random}%256;
			data_in =payload_data;
			parity=parity^data_in;
			end
			@(negedge clock);
			pkt_valid=0;
			data_in=parity;
	end
endtask

task pkt_three();
	begin
	@(negedge clock)
	pkt_valid=1'b1;
	payload_len=6'd18;
	addr=2'b10;
	header={payload_len,addr};
	read_enb_2<=1'b0;
	data_in=header;
	parity=parity^header; 
	for(i=0; i<payload_len; i=i+1)
			begin
			@(negedge clock);
			payload_data={$random}%256;
			data_in =payload_data;
			parity=parity^data_in;
			end
			@(negedge clock);
			pkt_valid=0;
			data_in=parity;
	end
endtask




initial
begin
rst_dut;
initialize;
pkt_one;
#10;
read_enb_0=1;

#50;
rst_dut;
initialize;
pkt_two;
#10;
read_enb_1=1;

#50;
rst_dut;
initialize;
pkt_three;
#10;
read_enb_2=1;

#50 
initialize;
#50 $finish;
end

endmodule
