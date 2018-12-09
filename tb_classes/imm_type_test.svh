class imm_type_test extends random_test;
   `uvm_component_utils(imm_type_test);

   
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction : new

   task run_phase(uvm_phase phase);
      imm_type_sequence imm_type;
      imm_type = new("imm_type");
      phase.raise_objection(this);
      imm_type.start(sequencer_h);
      phase.drop_objection(this);
   endtask : run_phase
  
endclass
   
   
