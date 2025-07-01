//------------------------------------------------------------------------------
// Multichannel Sequencer Component for Router
//------------------------------------------------------------------------------

class router_mcsequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(router_mcsequencer)

    // Reference handles for HBUS and YAPP UVC sequencers
    hbus_master_sequencer hbus_seqr;
    yapp_tx_sequencer     yapp_seqr;

    // Constructor
    function new(string name = "router_mcsequencer", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Additional configuration or methods can be added here as needed

endclass : router_mcsequencer