module router_sync(detect_add, addr, write_enb_reg, clock, resetn, 
					read_enb_0,
					read_enb_1,
					read_enb_2,
					empty_0,
					empty_1,
					empty_2,
					full_0,
					full_1,
					full_2,
					write_enb,
					vld_out_0,
					vld_out_1,
					vld_out_2, 
					soft_reset_0,
					soft_reset_1,
					soft_reset_2,
					fifo_full);
		
		input detect_add, write_enb_reg,clock,resetn;
		input [1:0] addr;
		input read_enb_0, read_enb_1, read_enb_2, empty_0, empty_1, empty_2, full_0, full_1, full_2;
		
		output reg vld_out_0, vld_out_1, vld_out_2;
		output reg soft_reset_0, soft_reset_1, soft_reset_2;
		output reg fifo_full;
		output reg [2:0] write_enb;
		
		reg [4:0] no_of_clk_cycle_0,no_of_clk_cycle_1,no_of_clk_cycle_2;

always@(posedge clock && detect_add)
	begin
	case(addr)
		2'b00:
				fifo_full<=full_0;
		2'b01:
				fifo_full<=full_1;
		2'b10:
				fifo_full<=full_2;
				
		default: fifo_full<=1'b0;
	endcase
	end
	
always@*
	begin
	if(write_enb_reg)
		begin
		case(addr)
			2'b00: 		
						write_enb <= 3'b001;
			2'b01: 		
						write_enb <= 3'b010;
			2'b10: 		
						write_enb <= 3'b100;  
			
			default: 	write_enb <= 3'b000;
		endcase
		end
	else 
		write_enb<=3'b000;
	end

always@(posedge clock)
	begin
		if (~resetn)
			begin
			no_of_clk_cycle_0<=5'd0;
			no_of_clk_cycle_1<=5'd0;
			no_of_clk_cycle_2<=5'd0;
			soft_reset_0<=1'b0;
			soft_reset_1<=1'b0;
			soft_reset_2<=1'b0;
			write_enb<=0;
			end
		if(~read_enb_0 && (~empty_0))
			begin
			no_of_clk_cycle_0<=no_of_clk_cycle_0+1'b1;
			end
		else if(~read_enb_1 && (~empty_1))
			begin
			no_of_clk_cycle_1<=no_of_clk_cycle_1+1'b1;
			end
		else if(~read_enb_2 && (~empty_2))
			begin
			no_of_clk_cycle_2<=no_of_clk_cycle_2+1'b1;	
			end
	end
	
always@ (posedge clock)
	begin
		if(read_enb_0)
			no_of_clk_cycle_0<=5'd0;
		else if(read_enb_1)
			no_of_clk_cycle_1<=5'd0;
		else if(read_enb_2)
			no_of_clk_cycle_2<=5'd0;
	end
	
always@(posedge clock)
	begin
		if((no_of_clk_cycle_0==5'd30) && (~read_enb_0))
			begin
			soft_reset_0<=1'b1;
			no_of_clk_cycle_0<=5'd0;
			end
		else if((no_of_clk_cycle_1==5'd30) && (~read_enb_1))
			begin
			soft_reset_1<=1'b1;
			no_of_clk_cycle_1<=5'd0;
			end
		else if((no_of_clk_cycle_2==5'd30) && (~read_enb_2))
			begin
			soft_reset_2<=1'b1;
			no_of_clk_cycle_2<=5'd0;
			end
	end


always@*
	begin
		if(~empty_0)
			begin
			vld_out_0=1;
			vld_out_1=0;
			vld_out_2=0;
			end
		else if(~empty_1)
			begin
			vld_out_1=1;
			vld_out_0=0;
			vld_out_2=0;
			end
		else if(~empty_2)
			begin
			vld_out_2=1;
			vld_out_0=0;
			vld_out_1=0;
			end
		else 
			begin
			vld_out_0=0;
			vld_out_1=0;
			vld_out_2=0;
			end
	end


endmodule
