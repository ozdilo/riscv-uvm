class imm_sequence_item extends sequence_item;
   `uvm_object_utils(imm_sequence_item)

   constraint imm_only {op inside {op_addi, op_slli, op_slti, op_sltiu, op_xori, op_srli, op_srai, op_ori, op_andi};}

   function new(string name="");super.new(name);endfunction
endclass : imm_sequence_item
