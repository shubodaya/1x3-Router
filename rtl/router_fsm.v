module router_fsm(clock, resetn, pkt_valid, parity_done, addr, 
					soft_reset_0,
					soft_reset_1,
					soft_reset_2,
					fifo_full,low_pkt_valid,
					fifo_empty_0,
					fifo_empty_1,
					fifo_empty_2,
					busy, detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, lfd_state);
			
			input clock, resetn, pkt_valid, parity_done, soft_reset_0, soft_reset_1, soft_reset_2;
			input [1:0] addr;
			input fifo_full, low_pkt_valid;
			input fifo_empty_0, fifo_empty_1, fifo_empty_2;
			
			output reg busy, write_enb_reg, rst_int_reg;
			output reg detect_add, ld_state, laf_state, full_state, lfd_state;
			reg [2:0] pre_state, next_state;
			
			parameter DECODE_ADDRESS=3'b000;
			parameter LOAD_FIRST_DATA=3'b001;
			parameter LOAD_DATA=3'b010;
			parameter LOAD_PARITY=3'b011;
			parameter FIFO_FULL_STATE=3'b100;
			parameter LOAD_AFTER_FULL=3'b101;
			parameter CHECK_PARITY_ERROR=3'b110;
			parameter WAIT_TILL_EMPTY=3'b111;
			
	
always@(posedge clock)
	begin
		if(~resetn)
			pre_state=DECODE_ADDRESS;
		else
			pre_state=next_state;
	end
			
always @(posedge clock)
	begin
	case(pre_state)
		DECODE_ADDRESS: begin
						busy=0;
						write_enb_reg=0;
						if((pkt_valid && (addr[1:0] ==2'b00) && fifo_empty_0)||
							(pkt_valid && (addr[1:0] ==2'b01) && fifo_empty_1)||
							(pkt_valid && (addr[1:0] ==2'b10) && fifo_empty_2))
							next_state=LOAD_FIRST_DATA;
						else if((pkt_valid && (addr[1:0] ==2'b00) && (!fifo_empty_0))||
								(pkt_valid && (addr[1:0] ==2'b01) && (!fifo_empty_1))||
								(pkt_valid && (addr[1:0] ==2'b10) && (!fifo_empty_2)))
							next_state=WAIT_TILL_EMPTY;
						else 
							next_state=DECODE_ADDRESS;
						end
						
		WAIT_TILL_EMPTY: begin
						busy=1;
						write_enb_reg=0;
						 if((fifo_empty_0 && (addr == 2'b00))||
							(fifo_empty_1 && (addr == 2'b01))||
							(fifo_empty_2 && (addr == 2'b10)))
							next_state=LOAD_FIRST_DATA;
						 else	
							next_state=WAIT_TILL_EMPTY;
						end
							
		LOAD_FIRST_DATA: 
						begin
						busy=1;
						write_enb_reg=1;
						 next_state=LOAD_DATA;
						end
							
		LOAD_DATA:		begin
						busy=0;
						write_enb_reg=1;
						if((!fifo_full) && (!pkt_valid))
							next_state=LOAD_PARITY;
						else if(fifo_full)
							next_state=FIFO_FULL_STATE;
						else
							next_state=LOAD_DATA;
						end
				
		LOAD_PARITY:	begin
						busy=1;
						write_enb_reg=1;
						next_state=CHECK_PARITY_ERROR;
						end	
						
		FIFO_FULL_STATE: begin
						busy=1;
						write_enb_reg=0;
						 if(!fifo_full)
							next_state=LOAD_AFTER_FULL;
						 else if(fifo_full)
							next_state=FIFO_FULL_STATE;
						end
						
		LOAD_AFTER_FULL: begin
							busy=1;
							write_enb_reg=1;
						 if((!parity_done) && (low_pkt_valid))
							next_state=LOAD_PARITY;	
						 else if(parity_done)
							next_state=DECODE_ADDRESS;
						 else if((!parity_done) && (!low_pkt_valid))
							next_state=LOAD_DATA;
						
						end
														
		CHECK_PARITY_ERROR: begin
							busy=1;
							write_enb_reg=0;
							if(fifo_full)
								next_state=FIFO_FULL_STATE;								
							else if(!fifo_full)
								next_state=DECODE_ADDRESS;
							
							end
								
								
		default: next_state=DECODE_ADDRESS;
	endcase
	end
	
always@(posedge clock)
	begin
		if(soft_reset_0||soft_reset_1||soft_reset_2)
			next_state=DECODE_ADDRESS;
	end
		
		
assign detect_add=(pre_state==DECODE_ADDRESS)?1:0;
assign rst_int_reg=(pre_state==CHECK_PARITY_ERROR)?1:0;
assign lfd_state =(pre_state==LOAD_FIRST_DATA)?1:0;
assign ld_state = (pre_state==LOAD_DATA)?1:0;
assign full_state = (pre_state==FIFO_FULL_STATE)?1:0;
assign laf_state = (pre_state==LOAD_AFTER_FULL)?1:0;


endmodule
