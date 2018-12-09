class core_agent extends uvm_agent;
   `uvm_component_utils(core_agent)

   core_agent_config core_agent_config_h;

   sequencer sequencer_h;
   driver          driver_h;
   scoreboard      scoreboard_h;
   coverage        coverage_h;
   command_monitor command_monitor_h;
   result_monitor  result_monitor_h;

   // uvm_analysis_port #(sequence_item) cmd_mon_ap;
   // uvm_analysis_port #(result_transaction) result_ap;


function new (string name, uvm_component parent);
   super.new(name,parent);
endfunction : new  


function void build_phase(uvm_phase phase);

   if(!uvm_config_db #(core_agent_config)::get(this, "","config", 
                                                   core_agent_config_h))
    `uvm_fatal("AGENT", "Failed to get config object");    
   is_active = core_agent_config_h.get_is_active();

   if (get_is_active() == UVM_ACTIVE) begin : make_stimulus
      sequencer_h  = new("sequencer_h",this);
      driver_h    = driver::type_id::create("driver_h",this);
   end

   command_monitor_h = command_monitor::type_id::create("command_monitor_h",this);
   result_monitor_h  = result_monitor::type_id::create("result_monitor_h",this);
   
   coverage_h = coverage::type_id::create("coverage_h",this);
   scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);

   // cmd_mon_ap = new("cmd_mon_ap",this);
   // result_ap  = new("result_ap", this);

endfunction : build_phase

function void connect_phase(uvm_phase phase);
   if (get_is_active() == UVM_ACTIVE) begin : make_stimulus
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
   end
      
//   command_monitor_h.ap.connect(cmd_mon_ap);
//   result_monitor_h.ap.connect(result_ap);

   command_monitor_h.ap.connect(scoreboard_h.cmd_f.analysis_export);
   command_monitor_h.ap.connect(coverage_h.analysis_export);
   result_monitor_h.ap.connect(scoreboard_h.analysis_export);

endfunction : connect_phase

   function void end_of_elaboration_phase(uvm_phase phase);
      scoreboard_h.set_report_verbosity_level_hier(UVM_HIGH);
   endfunction : end_of_elaboration_phase

   
endclass : core_agent

