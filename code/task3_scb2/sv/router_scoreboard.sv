class router_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(router_scoreboard)
    // port impelementations decleration for YAPP and three channels
    `uvm_analysis_imp_decl(_yapp)
    `uvm_analysis_imp_decl(_channel0)
    `uvm_analysis_imp_decl(_channel1)
    `uvm_analysis_imp_decl(_channel2)

    // ports impelementations
    uvm_analysis_imp_yapp#(yapp_packet, router_scoreboard) yapp_in;
    uvm_analysis_imp_channel0#(channel_packet, router_scoreboard) channel0_in;
    uvm_analysis_imp_channel1#(channel_packet, router_scoreboard) channel1_in;
    uvm_analysis_imp_channel2#(channel_packet, router_scoreboard) channel2_in;

    yapp_packet q0[$];
    yapp_packet q1[$];
    yapp_packet q2[$];

    //packet counters
    int pkts_received = 0;
    int wrong_pkts = 0;
    int matched_pkts = 0;

    function new(string name = "router_scoreboard", uvm_component parent);
        super.new(name, parent);
        //implementation ports construction
        yapp_in  = new("yapp_in", this);
        channel0_in = new("channel0_in", this);
        channel1_in = new("channel1_in", this);
        channel2_in = new("channel2_in", this);
    endfunction
//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  YAPP write implementation  * * * * * * * * * * * * * * * *  * * * *  * * * *  *   //
//========================================================================================================================//
    function void write_yapp(yapp_packet packet);
        yapp_packet ypkt;
        $cast(ypkt, packet.clone());
        case(ypkt.addr)
            2'b00 : q0.push_back(ypkt);
            2'b01 : q1.push_back(ypkt);
            2'b10 : q2.push_back(ypkt);
        endcase
    endfunction
//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  Channel-0 write implementation  * * * * * * * * * * * * * * * *  * * * *  * * *   //
//========================================================================================================================//
    function void write_channel0(channel_packet packet);
        yapp_packet ypkt;
        if(q0.size()>0) begin 
        ypkt = q0.pop_front();
        end
        pkts_received++;
        if(comp_equal(ypkt, packet)) begin // given comapre function
        // if(ccomp(ypkt, packet)) begin  // uvm_compare function
            `uvm_info(get_type_name(), "Inside IF BLOCK of Q1", UVM_LOW)
            matched_pkts++;
        end
        else begin
            wrong_pkts++;
        end 
        

    endfunction
//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  Channel-1 write implementation  * * * * * * * * * * * * * * * *  * * * *  * * *   //
//========================================================================================================================//
    function void write_channel1(channel_packet packet);
        yapp_packet ypkt;
        if(q1.size()>0) begin 
        ypkt = q1.pop_front();
        end 
        pkts_received++;
        if(comp_equal(ypkt, packet)) begin
        // if(ccomp(ypkt, packet)) begin
            `uvm_info(get_type_name(), "Inside IF BLOCK of Q1", UVM_LOW)
            matched_pkts++;
        end
        else begin
            `uvm_info(get_type_name(), "Inside ELSE BLOCK of Q1", UVM_LOW)
            wrong_pkts++;
        end

    endfunction
//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  Channel-2 write implementation  * * * * * * * * * * * * * * * *  * * * *  * * *   //
//========================================================================================================================//
    function void write_channel2(channel_packet packet);
        yapp_packet ypkt;
        if(q2.size()>0) begin 
        ypkt = q2.pop_front();
        end
        pkts_received++;
        if(comp_equal(ypkt, packet)) begin
        // if(ccomp(ypkt, packet)) begin
            matched_pkts++;
        end
        else begin
            wrong_pkts++;
        end
    endfunction
//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  Custom_Compare Method  * * * * * * * * * * * * * * * *  * * * *  * * * *  * * * * //
//========================================================================================================================//
    function bit comp_equal (input yapp_packet yp, input channel_packet cp);
      // returns first mismatch only
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
   endfunction


//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  UVM_Compare Method  * * * * * * * * * * * * * * * *  * * * *  * * * *  * * * *    //
//========================================================================================================================//

    function bit ccomp(yapp_packet yp, channel_packet cp, uvm_comparer comparer = null);
      if(comparer == null)
        comparer = new();
        ccomp = comparer.compare_field("addr", yp.addr, cp.addr, 2);
        ccomp &= comparer.compare_field("length", yp.length, cp.length, 6);
        ccomp &= comparer.compare_field("parity", yp.parity, cp.parity, 8);

        foreach(yp.payload[i])
          ccomp &= comparer.compare_field("payload", yp.payload[i], cp.payload[i], 8);

        return ccomp;

    endfunction
//========================================================================================================================//
//  * * * * * * * * * * * * * * * *  *  Report Phase Method  * * * * * * * * * * * * * * * *  * * * *  * * * *  * * * *    //
//========================================================================================================================//
    function void report_phase(uvm_phase phase);
        `uvm_info("[Scoreboard]", $sformatf("Packets Received: %0d", pkts_received), UVM_HIGH)
        `uvm_info("[Scoreboard]", $sformatf("Wrong Packets: %0d", wrong_pkts), UVM_HIGH)
        `uvm_info("[Scoreboard]", $sformatf("Matched Packets: %0d", matched_pkts), UVM_HIGH)
        `uvm_info("[Scoreboard]", $sformatf("Packets Left: %0d", ((q0.size())+(q1.size())+(q2.size()))), UVM_HIGH)

    endfunction

endclass