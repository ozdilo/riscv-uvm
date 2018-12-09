class command_monitor extends uvm_component;
   `uvm_component_utils(command_monitor);

   virtual core_bfm bfm;

   uvm_analysis_port #(sequence_item) ap;

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      core_agent_config core_agent_config_h;
      if(!uvm_config_db #(core_agent_config)::get(this, "","config", core_agent_config_h))
	`uvm_fatal("COMMAND MONITOR", "Failed to get CONFIG");
      core_agent_config_h.bfm.command_monitor_h = this;
      ap  = new("ap",this);
   endfunction : build_phase

   function void write_to_monitor(logic[31:0] rs1_val, logic[31:0] rs2_val, t_instruction op);
      sequence_item cmd;
      `uvm_info("COMMAND MONITOR",$sformatf("MONITOR: RS1: %2h  RS2: %2h  op: %s",
                                            rs1_val, rs2_val, op.name()), UVM_HIGH);
      cmd = new("cmd");
      cmd.rs1_val = rs1_val;
      cmd.rs2_val = rs2_val;
      cmd.op = op;
      ap.write(cmd);
   endfunction : write_to_monitor
   
endclass : command_monitor

