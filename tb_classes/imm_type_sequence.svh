class imm_type_sequence extends uvm_sequence #(sequence_item);
   `uvm_object_utils (imm_type_sequence)

   sequence_item command;

   function new (string name = "imm_type");
      super.new(name);
   endfunction : new

   task body();
      repeat (100) begin
         command = imm_sequence_item::type_id::create("command");
         start_item(command);
         assert(command.randomize());
         finish_item(command);
      end

   endtask : body
endclass : imm_type_sequence






