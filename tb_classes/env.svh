class env extends uvm_env;
   `uvm_component_utils(env);

   core_agent        core_agent_h;
   core_agent_config core_agent_config_h;
   
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      virtual core_bfm bfm;

      env_config env_config_h;
      if(!uvm_config_db #(env_config)::get(this, "","config", env_config_h))
        `uvm_fatal("RANDOM TEST", "Failed to get BFM");

      core_agent_config_h  = new(.bfm(env_config_h.bfm),  .is_active(UVM_ACTIVE));

      uvm_config_db #(core_agent_config)::set(this, "core_agent_h*",  
                                                 "config", core_agent_config_h);
      core_agent_h  = new("core_agent_h",this);

   endfunction : build_phase
   
endclass

