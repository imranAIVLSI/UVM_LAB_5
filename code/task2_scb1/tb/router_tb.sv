class router_tb extends uvm_env;
    `uvm_component_utils(router_tb)
    yapp_env YAPP;
    channel_env chan0;
    channel_env chan1;
    channel_env chan2;
    hbus_env hbus;
    clock_and_reset_env clk_rst;

    router_mcsequencer mcsequencer;

    // scoreboard
    router_scoreboard scb;

    function new(string name = "router_tb", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // YAPP = new("YAPP", this);
        uvm_config_int::set(this, "chan0", "channel_id", 0);
        uvm_config_int::set(this, "chan1", "channel_id", 1);
        uvm_config_int::set(this, "chan2", "channel_id", 2);
        uvm_config_int::set(this, "hbus", "num_masters", 1);
        uvm_config_int::set(this, "hbus", "num_slaves", 0);

        YAPP = yapp_env::type_id::create("YAPP", this);
        chan0 = channel_env::type_id::create("chan0", this);
        chan1 = channel_env::type_id::create("chan1", this);
        chan2 = channel_env::type_id::create("chan2", this);
        hbus = hbus_env::type_id::create("hbus", this);
        clk_rst = clock_and_reset_env::type_id::create("clk_rst", this);

        mcsequencer = router_mcsequencer::type_id::create("mcsequencer", this);

        scb = router_scoreboard::type_id::create("scb", this);

        `uvm_info("BUILD_PHASE", "Build phase of the testbench is being executed", UVM_HIGH)
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mcsequencer.hbus_seqr = hbus.masters[0].sequencer;
        mcsequencer.yapp_seqr = YAPP.agent.sequencer;
        YAPP.agent.monitor.yapp_out.connect(scb.yapp_in);
        chan0.rx_agent.monitor.item_collected_port.connect(scb.channel0_in);
        chan1.rx_agent.monitor.item_collected_port.connect(scb.channel1_in);
        chan2.rx_agent.monitor.item_collected_port.connect(scb.channel2_in);
    endfunction


    // function void start_of_simulation_phase(uvm_phase phase);
    //     `uvm_info(get_type_name(),"Running Simulation...", UVM_HIGH);
    // endfunction

endclass