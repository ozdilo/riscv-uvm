`timescale 1ps / 1ps
package core_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"

   typedef enum bit[6:0] {op_add    = 7'b0000001,
                          op_sub    = 7'b0010001,
                          op_sll    = 7'b0000011,
                          op_slt    = 7'b0000101,
                          op_sltu   = 7'b0000111,
                          op_xor    = 7'b0001001,
                          op_srl    = 7'b0001011,
                          op_sra    = 7'b0011011,
                          op_or     = 7'b0001101,
                          op_and    = 7'b0001111,
                          op_addi   = 7'b0000000,
                          op_slli   = 7'b0000010,
                          op_slti   = 7'b0000100,
                          op_sltiu  = 7'b0000110,
                          op_xori   = 7'b0001000,
                          op_srli   = 7'b0001010,
                          op_srai   = 7'b0011010,
                          op_ori    = 7'b0001100,
                          op_andi   = 7'b0001110} t_instruction;

   
   
   localparam nss = 1000;
   localparam uss = 1000000;

   logic [31:0] nop = 32'b00000000000000000000000000010011;

   typedef struct {
      logic [6:0] funct7;
      logic [4:0] rs2;
      logic [4:0] rs1;
      logic [2:0] funct3;
      logic [4:0] rd;
      logic [4:0] opcode;
   } t_instruction_fields;

   t_instruction_fields nop_fields = {7'd0, 5'd0, 5'd0, 3'd0, 5'd0, 5'b01100};


   typedef struct {
      logic [31:0] rs1_val;
      logic [31:0] rs2_val;
      logic [31:0] iut;
      t_instruction_fields i_f;
   } t_cmd;

   // ----------------------- create_instruction function ----------------------
   function logic[31:0] create_instruction;
      input        t_instruction op;
      input logic [31:0] imm;
      static logic [4:0] rs1 = 5'd1;
      static logic [4:0] rs2 = 5'd2;
      static logic [4:0] rd = 5'd3;

      case (op)
        op_add  : return {7'b0000000, rs2, rs1, 3'b000, rd, 5'b01100, 2'b11};
        op_sub  : return {7'b0100000, rs2, rs1, 3'b000, rd, 5'b01100, 2'b11};
        op_sll  : return {7'b0000000, rs2, rs1, 3'b001, rd, 5'b01100, 2'b11};
        op_slt  : return {7'b0000000, rs2, rs1, 3'b010, rd, 5'b01100, 2'b11};
        op_sltu : return {7'b0000000, rs2, rs1, 3'b011, rd, 5'b01100, 2'b11};
        op_xor  : return {7'b0000000, rs2, rs1, 3'b100, rd, 5'b01100, 2'b11};
        op_srl  : return {7'b0000000, rs2, rs1, 3'b101, rd, 5'b01100, 2'b11};
        op_sra  : return {7'b0100000, rs2, rs1, 3'b101, rd, 5'b01100, 2'b11};
        op_or   : return {7'b0000000, rs2, rs1, 3'b110, rd, 5'b01100, 2'b11};
        op_and  : return {7'b0000000, rs2, rs1, 3'b111, rd, 5'b01100, 2'b11};
        op_addi : return {imm[11:0], rs1, 3'b000, rd, 5'b00100, 2'b11};
        op_slli : return {7'b0000000, imm[4:0], rs1, 3'b001, rd, 5'b00100, 2'b11};
        op_slti : return {imm[11:0], rs1, 3'b010, rd, 5'b00100, 2'b11};
        op_sltiu: return {imm[11:0], rs1, 3'b011, rd, 5'b00100, 2'b11};
        op_xori : return {imm[11:0], rs1, 3'b100, rd, 5'b00100, 2'b11};
        op_srli : return {7'b0000000, imm[4:0], rs1, 3'b101, rd, 5'b00100, 2'b11};
        op_srai : return {7'b0100000, imm[4:0], rs1, 3'b101, rd, 5'b00100, 2'b11};
        op_ori  : return {imm[11:0], rs1, 3'b110, rd, 5'b00100, 2'b11};
        op_andi : return {imm[11:0], rs1, 3'b111, rd, 5'b00100, 2'b11};
        default : return nop; // nop
      endcase // case (op)

   endfunction // create_instruction

   // ----------------------- instruction fields function ----------------------
   function t_instruction get_instruction_enum;
      input t_instruction_fields i_f;
      logic [5:0]  funct;
      t_instruction instr;

      funct = {i_f.funct7[6:5], 
               i_f.funct3, 
               i_f.opcode[3]};
      instr[5:0] = funct;
      instr[6] = (i_f == nop_fields);
      return instr;

   endfunction // get_instruction_enum


   // ----------------------- instruction fields function ----------------------
   function t_instruction_fields decode_instruction;
      input [31:0] instr;
      t_instruction_fields instr_fields;
      if (instr[6:2] == 5'b01100)
        instr_fields = {instr[31:25], instr[24:20], 
                        instr[19:15], instr[14:12],
                        instr[11:7], instr[6:2]};
      else
        if (instr[14:12] == 3'b101)
          instr_fields = {instr[31:25], instr[24:20], 
                          instr[19:15], instr[14:12],
                          instr[11:7], instr[6:2]};
        else
          instr_fields = {7'd0, instr[24:20], 
                          instr[19:15], instr[14:12],
                          instr[11:7], instr[6:2]};
      return instr_fields;
   endfunction // decode_instruction

`include "sequence_item.svh"
   typedef uvm_sequencer #(sequence_item) sequencer;
`include "imm_sequence_item.svh"
`include "r_sequence_item.svh"
`include "imm_type_sequence.svh"
`include "r_type_sequence.svh"
`include "env_config.svh"
`include "core_agent_config.svh"

`include "result_transaction.svh"
`include "coverage.svh"
`include "scoreboard.svh"
`include "driver.svh"
`include "command_monitor.svh"
`include "result_monitor.svh"
`include "core_agent.svh"
`include "env.svh"

`include "random_test.svh"
`include "imm_type_test.svh"
`include "r_type_test.svh"

 
endpackage : core_pkg
   
