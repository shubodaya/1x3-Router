module router_fifo_tb();

	parameter cycle=2;
	parameter FIFO_WIDTH = 9;
	parameter FIFO_DEPTH = 16;
	
	reg clock, resetn, write_enb, soft_reset, read_enb, lfd_state;
	reg [7:0] data_in;
	reg [5:0] payload_len;
	reg [1:0] addr;
	
	wire empty,full;
	wire [7:0] data_out;
	
	reg [7:0] payload_data, parity, header;
	
	wire [4:0] rd_ptr,wr_ptr;
	integer i;
	
router_fifo DUT(.clock(clock),.resetn(resetn),.addr(addr),.payload_len(payload_len),.write_enb(write_enb),.soft_reset(soft_reset),.read_enb(read_enb),.data_in(data_in),.lfd_state(lfd_state),
					.empty(empty),.data_out(data_out),.full(full));
					
initial
  begin
     clock = 1'b0;
     forever
     #(cycle/2) clock = ~clock;
   end
   
task rst_dut();
	begin
	@(negedge clock)
	 resetn=1'b0;
	 write_enb=0;
	 read_enb=0;
	 soft_reset=0;
	@(negedge clock)
	 resetn=1'b1;
	end
endtask

task delay(input integer m);
      begin
	 #m;
      end
endtask
					
task pkt_gen;
	begin
	@(negedge clock);
		payload_len=6'd10;
		addr=2'b01;
		header={payload_len,addr};
		write_enb=1'b1;
		read_enb=1'b0;
		data_in=header;
		lfd_state=1'b1;
		for(i=0; i<payload_len; i=i+1)
			begin
			@(negedge clock);
			lfd_state=0;
			payload_data={$random}%256;
			data_in =payload_data;
			end
		@(negedge clock);
		parity={$random}%256;
		data_in=parity;
		write_enb<=1'b0;
	end
endtask

task read_only;
	begin	
	@(negedge clock);
	begin
		read_enb<=1'b1;
		write_enb<=1'b0;
		#35;
			soft_reset=1;
			read_enb<=1'b0;
	end
	end
endtask

initial
begin
	
	rst_dut;
	pkt_gen;
	delay(10);
	
	read_only;
	delay(5);
	
	#100 $finish;
end
endmodule