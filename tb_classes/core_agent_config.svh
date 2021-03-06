class core_agent_config;

   virtual core_bfm bfm;
   protected  uvm_active_passive_enum     is_active;

   function new (virtual core_bfm bfm, uvm_active_passive_enum
		 is_active);
      this.bfm = bfm;
      this.is_active = is_active;
   endfunction : new

   function uvm_active_passive_enum get_is_active();
      return is_active;
   endfunction : get_is_active
   
endclass : core_agent_config
