class sequence_item extends uvm_sequence_item;
   `uvm_object_utils(sequence_item)
   rand logic[31:0]        rs1_val;
   rand logic[31:0]        rs2_val;
   rand t_instruction      op;


   function void do_copy(uvm_object rhs);
      sequence_item RHS;

      if(rhs == null) 
        `uvm_fatal(get_type_name(), "Tried to copy from a null pointer")

      if(!$cast(RHS,rhs))
        `uvm_fatal(get_type_name(), "Tried to copy wrong type.")
      
      super.do_copy(rhs); // copy all parent class data

      rs1_val = RHS.rs1_val;
      rs2_val = RHS.rs2_val;
      op = RHS.op;

   endfunction : do_copy

   function sequence_item clone_me();
      sequence_item clone;
      uvm_object tmp;

      tmp = this.clone();
      $cast(clone, tmp);
      return clone;
   endfunction : clone_me
   

   function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      sequence_item RHS;
      bit   same;
      
      if (rhs==null) `uvm_fatal(get_type_name(),
                                "Tried to do comparison to a null pointer");
      
      if (!$cast(RHS,rhs))
        same = 0;
      else
        same = super.do_compare(rhs, comparer) && 
               (RHS.rs1_val == rs1_val) &&
               (RHS.rs2_val == rs2_val) &&
               (RHS.op == op);
      return same;
   endfunction : do_compare


   function string convert2string();
      string s;
      s = $sformatf("RS1: %8h  RS2: %8h op: %8s",
                        rs1_val, rs2_val, op.name());
      return s;
   endfunction : convert2string

   function new (string name = "");
      super.new(name);
   endfunction : new

endclass : sequence_item

      
        
