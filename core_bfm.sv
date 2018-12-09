interface core_bfm;
   import core_pkg::*;

   command_monitor command_monitor_h;
   result_monitor  result_monitor_h;
   
   bit          clk;
   reg          areset;
   reg          reset;
   bit          imem_req;
   bit          imem_valid = 1'b0;
   logic [31:0] imem_addr;
   logic [31:0] imem_data;
   logic [31:0] axi_awaddr  ;
   logic [2:0]  axi_awprot  ;
   logic [0:0]  axi_awvalid ;
   logic [31:0] axi_wdata   ;
   logic [3:0]  axi_wstrb   ;
   logic [0:0]  axi_wvalid  ;
   logic [0:0]  axi_bready  ;
   logic [31:0] axi_araddr  ;
   logic [2:0]  axi_arprot  ;
   logic [0:0]  axi_arvalid ;
   logic [0:0]  axi_rready  ;
   logic [0:0]  axi_awready = 1'b0;
   logic [0:0]  axi_wready  = 1'b0;
   logic [1:0]  axi_bresp   = 2'b00;
   logic [0:0]  axi_bvalid  = 1'b0;
   logic [0:0]  axi_arready = 1'b0;
   logic [31:0] axi_rdata   = 32'h00000000;
   logic [1:0]  axi_rresp   = 2'b00;
   logic [0:0]  axi_rvalid  = 1'b0;
   logic [31:0] rs1_val, rs2_val;
   logic [31:0] iut;
   t_instruction op;
   logic [31:0] instruction_memory[0:63];
   logic [5:0]  instruction_memory_address;

   logic [31:0] data_memory[0:63];
   logic [31:0] dmem_rd_addr  ;
   logic [31:0] dmem_wr_addr  ;
   t_instruction_fields instruction_fields = {7'd0, 5'd0, 5'd0, 3'd0, 5'd0, 5'b01100};
   integer      i;
   assign instruction_memory_address = imem_addr[7:2];




   // ----------------------- IMEM ---------------------------------------
   initial begin
      instruction_memory[0][31:0] = {12'd0, 5'b00000, 3'b010, 5'b00001, 5'b00000, 2'b11};          // lw x1 0(x0)
      instruction_memory[1][31:0] = {12'd4, 5'b00000, 3'b010, 5'b00010, 5'b00000, 2'b11};          // lw x2 4(x0)
      instruction_memory[2][31:0] = {7'd0, 5'b00010, 5'b00001, 3'b000, 5'b00011, 5'b01100, 2'b11}; // add x3 x2,x1
      instruction_memory[3][31:0] = {7'd0, 5'b00011, 5'b00000, 3'b010, 5'd8, 5'b01000, 2'b11};     // sw x3 8(x0)

      for (i = 4; i <= 63; i=i+1)
        instruction_memory[i] = 32'd0;
   end
   
   always @(posedge clk) begin : imem
      imem_data <= instruction_memory[instruction_memory_address];
   end : imem

   // ----------------------- DMEM ---------------------------------------
   initial begin
      data_memory[0] = 32'd10;
      data_memory[1] = 32'd20;
      for (i = 2; i <= 63; i=i+1)
        data_memory[i] = 32'd0;
   end

   always @(posedge clk) begin : dmem
      // read signals
      axi_arready <= axi_arvalid;
      if (axi_arvalid == 1'b1)
        dmem_rd_addr <= {2'b00, axi_araddr[31:2]};
      axi_rdata <= data_memory[dmem_rd_addr];
      axi_rvalid <= axi_arready && axi_arvalid;
      // write signals
      axi_awready <= axi_awvalid;
      if (axi_awvalid == 1'b1)
        dmem_wr_addr <= {2'b00, axi_awaddr[31:2]};
      if (axi_wvalid == 1'b1)
        data_memory[dmem_wr_addr] <= axi_wdata;

      axi_wready <= axi_awready;
      axi_bvalid <= axi_wvalid & axi_wready;

   end : dmem



   // ----------------------- CLK GENERATION ---------------------------------------
   initial begin
      clk = 0;
      forever begin
         #(10*nss);
         clk = ~clk;
      end
   end

   // ----------------------- Send Opcode ---------------------------------------
   task send_op(input logic[31:0] i_rs1_val, input logic[31:0] i_rs2_val, t_instruction i_op);
      areset = 1'b1;
      @(negedge clk);
      @(negedge clk);
      @(negedge clk);
      rs1_val = i_rs1_val;
      rs2_val = i_rs2_val;
      op = i_op;
      iut = create_instruction(i_op, i_rs2_val);
      //instruction_fields = decode_instruction(i_iut);
      data_memory[0] = i_rs1_val;
      data_memory[1] = i_rs2_val;
      instruction_memory[2] = iut;
      @(posedge clk);
      areset = 1'b0;
      @(posedge clk);
      //reset_proc;
      @(axi_wvalid);
      @(axi_bvalid);
      @(posedge clk);
      areset = 1'b1;
   endtask : send_op


   // ----------------------- Reset Task --------------------------------
   task reset_proc;
      begin
         @(negedge clk);
         reset = 1'b0;
         @(negedge clk);
         reset = 1'b1;
         //#(20*nss);
         @(negedge clk);
         reset = 1'b0;
      end
   endtask // reset_proc

   always @(posedge clk) begin : cmd_monitor
      t_cmd cmd;
      string s;
      if (axi_bvalid == 1'b1)
        begin
           // cmd.rs1_val = data_memory[0];
           // cmd.rs2_val = data_memory[1];
           // cmd.iut = instruction_memory[2];
           // cmd.i_f = instruction_fields;
           // s = $sformatf("BFM -------------------> RS1: %8h  RS2: %8h op: %8s",
           //               rs1_val, rs2_val, op.name());
           // $display(s);
           
           command_monitor_h.write_to_monitor(data_memory[0], data_memory[1], op);
        end

   end : cmd_monitor

   always @(posedge clk) begin : rslt_monitor
      if (axi_bvalid == 1'b1)
        result_monitor_h.write_to_monitor(data_memory[2]);
   end : rslt_monitor

   always @(posedge clk) begin : sreset
      reset <= areset;
   end : sreset


endinterface : core_bfm
