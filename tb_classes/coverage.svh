class coverage extends uvm_subscriber #(sequence_item);
   `uvm_component_utils(coverage)


   t_instruction op;

   covergroup op_cov;
      coverpoint op {
//         bins all_instructions[] = {[op_add:op_andi]};
         bins all_instructions[] = {
                                    op_add    ,
                                    op_sub    ,
                                    op_sll    ,
                                    op_slt    ,
                                    op_sltu   ,
                                    op_xor    ,
                                    op_srl    ,
                                    op_sra    ,
                                    op_or     ,
                                    op_and    ,
                                    op_addi   ,
                                    op_slli   ,
                                    op_slti   ,
                                    op_sltiu  ,
                                    op_xori   ,
                                    op_srli   ,
                                    op_srai   ,
                                    op_ori    ,
                                    op_andi   };





}
   endgroup



   function new (string name, uvm_component parent);
      super.new(name, parent);
      op_cov = new();
   endfunction : new



   function void write(sequence_item t);
         op = t.op;
         op_cov.sample();
   endfunction : write

endclass : coverage






