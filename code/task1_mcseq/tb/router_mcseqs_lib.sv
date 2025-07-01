//------------------------------------------------------------------------------
// Multichannel Sequence Library for Router
//------------------------------------------------------------------------------

class router_simple_mcseq extends uvm_sequence;
    `uvm_object_utils(router_simple_mcseq)
    `uvm_declare_p_sequencer(router_mcsequencer)

    // Constructor
    function new(string name = "router_simple_mcseq");
        super.new(name);
    endfunction

    hbus_small_packet_seq h_small;
    hbus_read_max_pkt_seq maxpkt_reg;
    yapp_012_seq six_012_seq;
    hbus_set_yapp_regs_seq lrg_payload;
    yapp_seq_rnd rand_6_seq;

    virtual task body();
        uvm_phase phase;
        phase = get_starting_phase();
        if (phase != null) phase.raise_objection(this, get_type_name());
        `uvm_do_on(h_small, p_sequencer.hbus_seqr)
        `uvm_do_on(maxpkt_reg, p_sequencer.hbus_seqr)
        repeat(6) begin
            `uvm_do_on(yapp_seq_012, p_sequencer.yapp_seqr)
        end
        lrg_payload.max_pkt_size = 63;
        lrg_payload.enable = 1;
        `uvm_do_on(lrg_payload, p_sequencer.hbus_seqr)
        `uvm_do_on(maxpkt_reg, p_sequencer.hbus_seqr)
        rand_6_seq.count = 6;
        `uvm_do_on(yapp_seq_rnd, p_sequencer.yapp_seqr)

        if (phase != null) phase.drop_objection(this, get_type_name());
    endtask

endclass : router_simple_mcseq
