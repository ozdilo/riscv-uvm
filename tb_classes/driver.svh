class driver extends uvm_driver #(sequence_item);
   `uvm_component_utils(driver)

   virtual core_bfm bfm;

  // uvm_get_port #(command_transaction) command_port;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
   function void build_phase(uvm_phase phase);
      core_agent_config core_agent_config_h;
      if(!uvm_config_db #(core_agent_config)::get(this, "","config", core_agent_config_h))
        `uvm_fatal("DRIVER", "Failed to get BFM");
      bfm = core_agent_config_h.bfm;
     // command_port = new("command_port",this);
   endfunction : build_phase

   task run_phase(uvm_phase phase);
      sequence_item command;
      forever begin : command_loop
         seq_item_port.get_next_item(command);
         bfm.send_op(command.rs1_val, command.rs2_val, command.op);
         seq_item_port.item_done();

      end : command_loop
   endtask : run_phase
   
   
endclass : driver
