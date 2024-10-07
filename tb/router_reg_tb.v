module router_reg_tb;
	reg clock, resetn, pkt_valid;
	reg [7:0] data_in;
	reg fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state;
	
	wire parity_done, low_pkt_valid, err;
	wire [7:0] dout;

	
	reg [5:0] payload_len;
	reg [7:0] payload_data, parity, header;
	reg [1:0] addr;
	
	
	
	parameter cycle=2;
	
	integer i;
	
router_reg DUT(.clock(clock), .resetn(resetn),.addr(addr),.header(header), .parity(parity),.payload_len(payload_len), .pkt_valid(pkt_valid), .data_in(data_in), .fifo_full(fifo_full), 
				.rst_int_reg(rst_int_reg), .detect_add(detect_add), .ld_state(ld_state), .laf_state(laf_state),
				.full_state(full_state), .lfd_state(lfd_state), .parity_done(parity_done), .low_pkt_valid(low_pkt_valid), .err(err), 
				.dout(dout));
					
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

task initialize;
	begin
		rst_int_reg=0;
		detect_add=0;
		pkt_valid=0;
		full_state=0;
		ld_state=0;
		lfd_state=0;
		laf_state=0;
	end
endtask
		


	
/*task bad_packet;
    begin
       @(negedge clock)
        payload_len=6'd20;
		addr=2'b01;  //valid packet
		pkt_valid=1'b1;
		detect_add=1'b1;
		parity=0;
          
        header={payload_len,addr};
		
        data_in=header;
        parity=parity^header;  
         @(negedge clock)   //header
         detect_add=1'b0;
         lfd_state=1'b1;
		 full_state=1'b0;
         fifo_full=1'b0;
         laf_state=1'b0;  
      for(i=0;i<payload_len;i=i+1)    //payload
        begin 
            @(negedge clock)
                lfd_state=1'b0;
				ld_state=1'b1;
                payload_data={$random}%256;
                data_in=payload_data;
				parity=parity^data_in;
				
		end
            @(negedge clock)    //parity
				pkt_valid=0;
                data_in=parity;
				rst_int_reg=1'b0;
         
        @(negedge clock)
                ld_state=1'b0; 
                rst_int_reg=1'b1;
        
	end
endtask	*/

task parity_check;
    begin
       @(negedge clock)
        payload_len=6'd14;
		addr=2'b01;  //valid packet
		pkt_valid=1'b1;
		detect_add=1'b1;
		parity=0;
        header={payload_len,addr};
		ld_state=0;
		laf_state=0;
		full_state=0;
        data_in=header;
        parity=parity^header;  
		
         @(negedge clock)   //header
         lfd_state=1'b1;
         fifo_full=1'b0;
         laf_state=1'b0;  
		 
      for(i=0;i<payload_len;i=i+1)    //payload
        begin 
            @(negedge clock)
				detect_add=1'b0;
                lfd_state=1'b0;
				ld_state=1'b1;
                payload_data={$random}%256;
                data_in=payload_data;
				parity=parity^data_in;
		end
			
			
           @(negedge clock)    //parity
				pkt_valid=0;
                data_in=parity;
				rst_int_reg=1'b0;
				ld_state=0;
				laf_state=1;
				
				
				
        @(negedge clock)
                ld_state=1'b0; 
				laf_state=0;
				full_state=1;
				fifo_full=1;
                rst_int_reg=1'b1;
	end
endtask	


initial
begin
	initialize;
	rst_dut;
	ld_state=1;
	fifo_full=0;
	pkt_valid=0;
	#10;
	
	initialize;
	rst_int_reg=1;
	#10;
	
	initialize;
	detect_add=1;
	#10;
	
	initialize;
	ld_state=1;
	pkt_valid=0;
	fifo_full=1;
	#10;
	fifo_full=0;
	
	initialize;
	rst_dut;
	parity_check;
	#20;
	
	#20 $finish;
end

endmodule