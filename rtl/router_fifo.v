module router_fifo(clock,resetn,addr,payload_len, write_enb,soft_reset,read_enb,data_in,lfd_state,
					empty,data_out,full);
	
	parameter FIFO_WIDTH = 9;
	parameter FIFO_DEPTH = 16;
	
	input clock,resetn,soft_reset,write_enb,read_enb,lfd_state;
	input [FIFO_WIDTH-2:0] data_in;
	input  [5:0] payload_len;
	input [1:0] addr;

	reg [FIFO_WIDTH-1:0]mem[FIFO_DEPTH-1:0];
	reg [4:0] rd_ptr,wr_ptr;
	
	output reg empty,full;
	output reg [FIFO_WIDTH-2:0] data_out;
	
	integer i;
	
always @(posedge clock)
	begin
	if(~resetn || soft_reset)
		begin
			data_out=0;
			full=1'b0;
			empty=1'b1;
			wr_ptr=0;
			rd_ptr=0;
			for(i=0;i<FIFO_DEPTH;i=i+1)
					mem[i]=0;
		end
	else if(lfd_state)
			mem[wr_ptr]={1'b1,payload_len,addr};
	end 
		
	
always@(posedge clock)
	begin
		if(write_enb)
			begin
			if(!full)
				begin
				mem[wr_ptr]={1'b0,data_in};
				wr_ptr = wr_ptr + 1'b1;
				rd_ptr=wr_ptr;
				end
			end
	end

always@(posedge clock)
	begin
		if(read_enb)
			begin
			mem[payload_len+1]={1'b0,data_in};
			if(!empty)
				begin
				wr_ptr=0;
				data_out = mem[rd_ptr];
				rd_ptr = rd_ptr - 1'b1;
				end
			else 
				begin
				rd_ptr=0;
				data_out= mem[0];
				end
			end
	end
	

	
assign empty=(rd_ptr==0)?1'b1:1'b0;
assign full=(wr_ptr==(payload_len +1 ))?1'b1:1'b0;	


endmodule
	
	
	
	
	
	
	