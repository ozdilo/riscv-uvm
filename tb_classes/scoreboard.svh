class scoreboard extends uvm_subscriber #(result_transaction);
   `uvm_component_utils(scoreboard);

   uvm_tlm_analysis_fifo #(sequence_item) cmd_f;

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      cmd_f = new ("cmd_f", this);
   endfunction : build_phase


   function result_transaction predict_result(sequence_item cmd);
      result_transaction predicted;

      predicted = new("predicted");

      case (cmd.op)
        op_addi :
          begin
             predicted.result = $signed(cmd.rs1_val) + $signed(cmd.rs2_val[11:0]); 
          end
        op_add :
          begin
             predicted.result = $signed(cmd.rs1_val) + $signed(cmd.rs2_val); 
          end
        op_sub :
          begin
             predicted.result = $signed(cmd.rs1_val) - $signed(cmd.rs2_val); 
          end
        op_sll : 
          begin
             predicted.result = cmd.rs1_val << cmd.rs2_val[4:0];
          end
        op_slli : 
          begin
             predicted.result = cmd.rs1_val << cmd.rs2_val[4:0];
          end
        op_slti :
          begin
             if ($signed(cmd.rs1_val) < $signed(cmd.rs2_val[11:0]))
               predicted.result = 32'd1;
             else
               predicted.result = 32'd0;
          end
        op_sltiu :
          begin
             if (cmd.rs1_val < { {20{cmd.rs2_val[11]}} , cmd.rs2_val[11:0] })
               predicted.result = 32'd1;
             else
               predicted.result = 32'd0;
          end
        op_slt :
          begin
             if ($signed(cmd.rs1_val) < $signed(cmd.rs2_val))
               predicted.result = 32'd1;
             else
               predicted.result = 32'd0;
          end
        op_sltu :
          begin
             if (cmd.rs1_val < cmd.rs2_val)
               predicted.result = 32'd1;
             else
               predicted.result = 32'd0;
          end
        op_xor : 
          begin
             predicted.result = cmd.rs1_val ^ cmd.rs2_val;
          end
        op_xori : 
          begin
             predicted.result = cmd.rs1_val ^ { {20{cmd.rs2_val[11]}} , cmd.rs2_val[11:0] };
          end
        op_srl : 
          begin
             predicted.result = cmd.rs1_val >> cmd.rs2_val[4:0];
          end
        op_srli : 
          begin
             predicted.result = cmd.rs1_val >> cmd.rs2_val[4:0];
          end
        op_sra : 
          begin
             predicted.result = $signed(cmd.rs1_val) >>> cmd.rs2_val[4:0];
          end
        op_srai : 
          begin
             predicted.result = $signed(cmd.rs1_val) >>> cmd.rs2_val[4:0];
          end
        op_or : 
          begin
             predicted.result = cmd.rs1_val | cmd.rs2_val;
          end
        op_and : 
          begin 
             predicted.result = cmd.rs1_val & cmd.rs2_val;
          end
        op_ori : 
          begin
             predicted.result = cmd.rs1_val | { {20{cmd.rs2_val[11]}} , cmd.rs2_val[11:0] } ;
          end
        op_andi : 
          begin 
             predicted.result = cmd.rs1_val & { {20{cmd.rs2_val[11]}} , cmd.rs2_val[11:0] };
          end        
      endcase

      return predicted;

   endfunction : predict_result
   

   function void write(result_transaction t);
      string      data_str;
      sequence_item cmd;
      result_transaction predicted;

       if (!cmd_f.try_get(cmd))
         `uvm_fatal("SCOREBOARD", "Missing command in self checker")

      predicted = predict_result(cmd);
      // data_str = $sformatf(" %8h %8s %8h = %8h (%8h predicted)",
      //                      cmd.rs1_val, cmd.op.name() ,cmd.rs2_val, t.result,  predicted.result);

      data_str = {cmd.convert2string(),
                  " ==> DUT " , t.convert2string(),
                  " ==> Predicted ", predicted.convert2string()};

      if (!predicted.compare(t))
        `uvm_error ("SCOREBOARD", {"FAIL: ",data_str})
      else
        `uvm_info ( "SCOREBOARD", {"PASS: ",data_str}, UVM_HIGH)

   endfunction : write



endclass : scoreboard






