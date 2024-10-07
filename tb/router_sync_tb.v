module router_sync_tb();

	reg detect_add, write_enb_reg,clock,resetn;
	reg  [1:0] addr;
	reg read_enb_0, read_enb_1, read_enb_2, empty_0, empty_1, empty_2, full_0, full_1, full_2;

	wire  vld_out_0, vld_out_1, vld_out_2, soft_reset_0, soft_reset_1, soft_reset_2, fifo_full;
	wire  [2:0] write_enb;
	
	parameter cycle=2;
	
router_sync DUT (.detect_add(detect_add),.addr(addr),.write_enb_reg(write_enb_reg),.clock(clock),.resetn(resetn), 
					.read_enb_0(read_enb_0),
					.read_enb_1(read_enb_1),
					.read_enb_2(read_enb_2),
					.empty_0(empty_0),
					.empty_1(empty_1),
					.empty_2(empty_2),
					.full_0(full_0),
					.full_1(full_1),
					.full_2(full_2),
					.write_enb(write_enb),
					.vld_out_0(vld_out_0),
					.vld_out_1(vld_out_1),
					.vld_out_2(vld_out_2), 
					.soft_reset_0(soft_reset_0),
					.soft_reset_1(soft_reset_1),
					.soft_reset_2(soft_reset_2),
					.fifo_full(fifo_full));
	
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
	@(negedge clock)
	 resetn=1'b1;
	end
endtask

task delay(input integer m);
      begin
	 #m;
      end
endtask

task initialize;
	begin
	@(negedge clock);
		begin
	read_enb_0=1'b0;
	read_enb_1=1'b0;
	read_enb_2=1'b0;
	empty_0=1'b1;
	empty_1=1'b1;
	empty_2=1'b1;
	full_0=1'b0;
	full_1=1'b0;
	full_2=1'b0;
	detect_add=1'b0;
	write_enb_reg=1'b0;
		end
	end
endtask
	

task data_0;
	begin
	detect_add=1'b1;
	full_0=1'b1;
	addr=2'b00;
	empty_0=0;
	end
endtask

task data_1;
	begin	
	detect_add=1'b1;
	full_1=1'b1;
	addr=2'b01;
	empty_1=0;
	end
endtask

task data_2;
	begin
	detect_add=1'b1;
	full_2=1'b1;
	addr=2'b10;
	empty_2=0;
	end
endtask

task data_3;
	begin
	detect_add=1'b1;
	addr=2'b11;
	end
endtask

initial
begin
	rst_dut;
	initialize;
	write_enb_reg=1;
	data_0;
	#10;
	initialize;
	write_enb_reg=1;
	data_1;
	#10;
	initialize;
	write_enb_reg=1;
	data_2;
	
	#10;
	
	initialize;
	rst_dut;
	empty_0=0;
	detect_add=1;
	read_enb_0=1'b0;
	read_enb_1=1'b1;
	read_enb_2=1'b1;
	write_enb_reg=1'b1;
	#60;
	write_enb_reg=0;
	
	#10;
	initialize;
	rst_dut;
	empty_1=0;
	read_enb_0=1'b1;
	read_enb_1=1'b0;
	read_enb_2=1'b1;
	write_enb_reg=1'b1;
	#60;
	write_enb_reg=0;
	
	#10;
	initialize;
	rst_dut;
	empty_2=0;
	read_enb_0=1'b1;
	read_enb_1=1'b1;
	read_enb_2=1'b0;
	write_enb_reg=1'b1;
	#60;
	write_enb_reg=0;
	
	
	#10 initialize;
	rst_dut;
	#100;
	$finish;
end
	

endmodule