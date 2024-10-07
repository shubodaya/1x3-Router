module router_fsm_tb();
	reg clock, resetn, pkt_valid, parity_done, soft_reset_0, soft_reset_1, soft_reset_2;
	reg [1:0] addr;
	reg fifo_full, low_pkt_valid;
	reg fifo_empty_0, fifo_empty_1, fifo_empty_2;
	
	wire busy, detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, lfd_state;
	
	
	parameter cycle=2;
	
router_fsm DUT(.clock(clock), .resetn(resetn), .pkt_valid(pkt_valid), .parity_done(parity_done), .addr(addr), 
					.soft_reset_0(soft_reset_0),
					.soft_reset_1(soft_reset_1),
					.soft_reset_2(soft_reset_2),
					.fifo_full(fifo_full),.low_pkt_valid(low_pkt_valid),
					.fifo_empty_0(fifo_empty_0),
					.fifo_empty_1(fifo_empty_1),
					.fifo_empty_2(fifo_empty_2),
					.busy(busy), .detect_add(detect_add), .ld_state(ld_state), .laf_state(laf_state), .full_state(full_state), 
														.write_enb_reg(write_enb_reg), .rst_int_reg(rst_int_reg), .lfd_state(lfd_state));



assign low_pkt_valid=~pkt_valid;

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
	pkt_valid=1'b0;
	addr=2'b00;
	low_pkt_valid=1'b1;
	fifo_full=1'b0;
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b0;
	fifo_empty_2=1'b0;
	parity_done=1'b0;
	soft_reset_0=0;
	soft_reset_1=0;
	soft_reset_2=0;
	end
endtask

task one();
	begin
	@(negedge clock)
	pkt_valid=1'b1;
	addr=2'b00;
	fifo_empty_0=1'b1;
	#10;
	fifo_full=1'b0;
	pkt_valid=1'b0;
	#10;
	fifo_full=1'b0;
	pkt_valid=0;
	end
endtask

task two();
	begin	
	pkt_valid=1'b1;
	addr=2'b01;
	fifo_empty_1=1'b1;
	#10;
	fifo_full=1'b1;
	#10 fifo_full=1'b0;
	#2;
	parity_done=1'b0;
	low_pkt_valid=1'b1;
	pkt_valid=0;
	end
endtask

task three();
	begin
	pkt_valid=1'b1;
	addr=2'b10;
	fifo_empty_2=1'b1;
	#10;
	fifo_full=1'b1;
	#5 fifo_full=1'b0;
	#10;
	parity_done=1'b0;
	low_pkt_valid=1'b0;
	#10;
	pkt_valid=1'b0;
	fifo_full=1'b0;
	pkt_valid=0;
	end
endtask

task four();
	begin
	pkt_valid=1'b1;
	addr=2'b01;
	fifo_empty_1=1'b1;
	#10;
	pkt_valid=1'b0;
	fifo_full=1'b0;
	#2;
	fifo_full=1'b1;
	#10 fifo_full=1'b0;
	#2;
	parity_done=1;
	pkt_valid=0;
	end
endtask

task wait_till_1;
	begin
	pkt_valid=1'b1;
	addr=2'b00;
	fifo_empty_0=1'b0;
	#10; 
	fifo_empty_0=1'b1;
	addr=2'b00;
	end
endtask

task wait_till_2;
	begin
	pkt_valid=1'b1;
	addr=2'b01;
	fifo_empty_1=1'b0;
	#10; 
	fifo_empty_1=1'b1;
	addr=2'b01;
	end
endtask

task wait_till_3;
	begin
	pkt_valid=1'b1;
	addr=2'b10;
	fifo_empty_2=1'b0;
	#10; 
	fifo_empty_2=1'b1;
	addr=2'b10;
	end
endtask

task wait_till_4;
	begin
	pkt_valid=1'b1;
	addr=2'b01;
	fifo_empty_1=1'b0;
	#10; 
	fifo_empty_1=1'b1;
	addr=2'b01;
	end
endtask


initial
begin
	rst_dut;
	initialize;
	wait_till_1;
	one;
	#10;
	soft_reset_0=1;
	#20;
	soft_reset_0=0;
	
	rst_dut;
	initialize;
	wait_till_2;
	two;
	#10;
	soft_reset_1=1;
	#20;
	soft_reset_1=0;
	
	rst_dut;
	initialize;
	wait_till_3;
	three;
	#10;
	soft_reset_2=1;
	#20;
	soft_reset_2=0;
	
	rst_dut;
	initialize;
	wait_till_4;
	four;
	#10;
	soft_reset_1=1;
	#20;
	soft_reset_1=0;
	#100;
	$finish;
end
endmodule


