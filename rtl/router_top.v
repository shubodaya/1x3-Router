module router_top(clock, resetn, payload_len,addr, header, parity,read_enb_0, read_enb_1, read_enb_2, pkt_valid, data_in, data_out_0, data_out_1, data_out_2,
					valid_out_0, valid_out_1, valid_out_2, error, busy);

	input clock,resetn;
	input read_enb_0,read_enb_1, read_enb_2;
	input [7:0] data_in,header,parity;
	input pkt_valid;
	input  [5:0] payload_len;
	input [1:0] addr;
	
	output [7:0] data_out_0, data_out_1, data_out_2;
	output valid_out_0, valid_out_1, valid_out_2;
	output error, busy;
	
	wire low_pkt_valid, empty_0, empty_1, empty_2, detect_add, ld_state, laf_state, full_state, write_enb_reg, 
			rst_int_reg, lfd_state, soft_reset_0, soft_reset_1, soft_reset_2, fifo_full,full_0,full_1,full_2, parity_done;
	wire[2:0] write_enb;
	wire [7:0] dout;
	
router_fifo FIFO_0(.clock(clock),.resetn(resetn),.addr(addr),.payload_len(payload_len),.write_enb(write_enb[0]),.soft_reset(soft_reset_0),.read_enb(read_enb_0),.data_in(dout),.lfd_state(lfd_state),
					.empty(empty_0),.data_out(data_out_0),.full(full_0));
					
router_fifo FIFO_1(.clock(clock),.resetn(resetn),.addr(addr),.payload_len(payload_len),.write_enb(write_enb[1]),.soft_reset(soft_reset_1),.read_enb(read_enb_1),.data_in(dout),.lfd_state(lfd_state),
					.empty(empty_1),.data_out(data_out_1),.full(full_1));
					
router_fifo FIFO_2(.clock(clock),.resetn(resetn),.addr(addr),.payload_len(payload_len),.write_enb(write_enb[2]),.soft_reset(soft_reset_2),.read_enb(read_enb_2),.data_in(dout),.lfd_state(lfd_state),
					.empty(empty_2),.data_out(data_out_2),.full(full_2));
					
router_fsm FSM(.clock(clock), .resetn(resetn), .pkt_valid(pkt_valid), .parity_done(parity_done), .addr(addr), 
					.soft_reset_0(soft_reset_0),
					.soft_reset_1(soft_reset_1),
					.soft_reset_2(soft_reset_2),
					.fifo_full(fifo_full),.low_pkt_valid(low_pkt_valid),
					.fifo_empty_0(empty_0),
					.fifo_empty_1(empty_1),
					.fifo_empty_2(empty_2),
					.busy(busy), .detect_add(detect_add),
					.ld_state(ld_state), 
					.laf_state(laf_state), 
					.full_state(full_state), 
					.write_enb_reg(write_enb_reg), 
					.rst_int_reg(rst_int_reg), 
					.lfd_state(lfd_state));

router_sync SYNCHRONIZER (.detect_add(detect_add),.addr(addr),.write_enb_reg(write_enb_reg),.clock(clock),.resetn(resetn), 
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
					.vld_out_0(valid_out_0),
					.vld_out_1(valid_out_1),
					.vld_out_2(valid_out_2), 
					.soft_reset_0(soft_reset_0),
					.soft_reset_1(soft_reset_1),
					.soft_reset_2(soft_reset_2),
					.fifo_full(fifo_full));
					
router_reg REGISTER(.clock(clock), .resetn(resetn),.addr(addr),.header(header),.parity(parity),.payload_len(payload_len), .pkt_valid(pkt_valid), .data_in(data_in), 
					.fifo_full(fifo_full), 
					.rst_int_reg(rst_int_reg), 
					.detect_add(detect_add),
					.ld_state(ld_state),
					.laf_state(laf_state),
					.full_state(full_state),
					.lfd_state(lfd_state),
					.parity_done(parity_done),
					.low_pkt_valid(low_pkt_valid), 
					.err(error),
					.dout(dout));
					

			
					
endmodule