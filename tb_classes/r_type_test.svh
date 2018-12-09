class r_type_test extends random_test;
   `uvm_component_utils(r_type_test);

   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   task run_phase(uvm_phase phase);
      r_type_sequence r_type;
      r_type = new("r_type");
      phase.raise_objection(this);
      r_type.start(sequencer_h);
      phase.drop_objection(this);
   endtask : run_phase

endclass
