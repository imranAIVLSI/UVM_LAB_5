class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    function new (string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    router_tb tb;
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_int::set(this, "*", "recording_detail", 1);
         uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_5_packets::get_type());
        // tb = new("tb", this);
        tb = router_tb::type_id::create("tb", this);
        `uvm_info("BUILD_PHASE", "Build Phase of Testbench is being executed", UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);

    endtask

    function void check_phase(uvm_phase phase);
        super.connect_phase(phase);
        check_config_usage();
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass

class simple_test extends base_test;
    `uvm_component_utils(simple_test)

    function new(string name = "simple_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
        uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase", "default_sequence", yapp_012_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());
    endfunction
endclass

class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new(string name = "short_packet_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());

    endfunction

endclass: short_packet_test

class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new(string name = "set_config_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        // uvm_config_int::set(this,"tb.YAPP.agent", "is_active", UVM_PASSIVE);
        super.build_phase(phase);
    endfunction
endclass: set_config_test

class incr_payload_test extends base_test;
    `uvm_component_utils(incr_payload_test)

    function new(string name = "incr_payload_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_incr_payload_seq::get_type());
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    endfunction    

endclass

class exhaustive_seq_test extends base_test;
    `uvm_component_utils(exhaustive_seq_test)

    function new(string name = "exhaustive_seq_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_exhaustive_seq::get_type());
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    endfunction

endclass: exhaustive_seq_test


class new_test012 extends base_test;
    `uvm_component_utils(new_test012)

    function new(string name = "new_test012", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase",
                                "default_sequence",
                                yapp_012_seq::get_type());
        set_type_override_by_type(yapp_packet::get_type(), short_yapp_packet::get_type());
    endfunction


endclass: new_test012

class test_uvc_integration extends base_test;
    `uvm_component_utils(test_uvc_integration)

    function new(string name = "test_uvc_integration", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "tb.YAPP.agent.sequencer.run_phase", "default_sequence", four_channel_seq::get_type());
        uvm_config_wrapper::set(this, "tb.chan?.rx_agent.sequencer.run_phase", "default_sequence", channel_rx_resp_seq::get_type());
        uvm_config_wrapper::set(this, "tb.clk_rst.agent.sequencer.run_phase", "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb.hbus.masters[?].sequencer.run_phase","default_sequence",hbus_small_packet_seq::get_type());    

    endfunction

endclass
