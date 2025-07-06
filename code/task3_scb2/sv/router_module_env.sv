class router_module_env extends uvm_env;

    `uvm_component_utils(router_module_env)

    router_scoreboard rt_scb;
    router_reference rt_reference;

    function new(string name = "router_module_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rt_scb = router_scoreboard::type_id::create("rt_scb", this);
        rt_reference = router_reference::type_id::create("rt_reference", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        rt_reference.yapp_out.connect(rt_scb.yapp_in);
    endfunction

endclass