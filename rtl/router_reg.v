module router_reg(clock, resetn,addr, header, parity,payload_len, pkt_valid, data_in, fifo_full, rst_int_reg, detect_add, ld_state, laf_state,
					full_state, lfd_state, parity_done, low_pkt_valid, err, dout);
	
	input clock, resetn, pkt_valid;
	input [7:0] data_in;
	input fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state;
	input [7:0] header,parity;
	input [1:0] addr;
	
	input [5:0] payload_len;
	
	output reg parity_done, low_pkt_valid, err;
	output reg [7:0] dout;
	
	reg [7:0] internal_parity_byte,full_state_byte, header_byte,payload_byte;
	
	integer i;
	


always@(posedge clock)
	begin
		if(!resetn)
		begin
			dout=0;
			err=0;
			parity_done=0;
			low_pkt_valid=0;
			internal_parity_byte=0;
			full_state_byte=0;
		end
	end
		
always@(posedge clock)
	begin
		if(rst_int_reg)
			low_pkt_valid=0;
		else if(ld_state && (!pkt_valid ))
			low_pkt_valid=1'b1;
	end
	
always@(posedge clock)
	begin
		if(detect_add)
			parity_done=0;
		else if(ld_state && (!fifo_full) && (!pkt_valid))
			parity_done=1'b1;
		else if(laf_state && low_pkt_valid && (!parity_done))
			parity_done=1'b1;
	end
	
	
always@(posedge clock)
	begin
		if(lfd_state)
				begin
				dout=header_byte;
				internal_parity_byte=internal_parity_byte^header_byte;
				end
		else if(ld_state)
				begin
				for(i=0;i<payload_len;i=i+1)    
					begin 
					@(negedge clock)
					dout=payload_byte;
					internal_parity_byte=internal_parity_byte^dout;
					end
				end
		else if(laf_state)
				@(negedge clock)
				dout=internal_parity_byte;
	end
	
	
	
	
	
always@(posedge clock)
	begin
		if(detect_add && pkt_valid)
			header_byte=header;
		else if(ld_state && (!fifo_full))
			payload_byte=data_in;
		else if(ld_state && fifo_full)
			full_state_byte=parity;
	end	
			
			
			
always@(posedge clock)
	begin
		if(full_state)
		begin
			if(internal_parity_byte==parity)
				err=0;
			else 
				err=1;
		end
		else
			err=0;
	end

endmodule
