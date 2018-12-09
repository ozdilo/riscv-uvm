class r_sequence_item extends sequence_item;
   `uvm_object_utils(r_sequence_item)

   constraint r_only {op inside {op_add, op_sub, op_sll, op_slt, op_sltu, op_xor, op_srl, op_sra, op_or, op_and};}

   function new(string name="");super.new(name);endfunction
endclass : r_sequence_item

      
        
