class random_test extends uvm_test;
   `uvm_component_utils(random_test);

   env       env_h;
   sequencer sequencer_h;
   
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new


   function void build_phase(uvm_phase phase);
      virtual core_bfm bfm;
      env_config env_config_h;

      if(!uvm_config_db #(virtual core_bfm)::get(this, "","bfm", bfm))
        `uvm_fatal("RANDOM TEST", "Failed to get BFM");

      env_config_h = new(bfm);
      
      uvm_config_db #(env_config)::set(this, "env_h*", "config", env_config_h);

      env_h = env::type_id::create("env_h",this);
   endfunction : build_phase

   function void end_of_elaboration_phase(uvm_phase phase);
      sequencer_h = env_h.core_agent_h.sequencer_h;
   endfunction : end_of_elaboration_phase


endclass

