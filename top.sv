module top;
   import uvm_pkg::*;
   import   core_pkg::*;
`include "core_macros.svh"
`include "uvm_macros.svh"
   
   core_bfm       bfm();

   core_axi DUT (.clk                    (bfm.clk),
                 .reset                  (bfm.reset),
                 .o_imem_req             (bfm.imem_req),
                 .i_imem_valid           (bfm.imem_valid),
                 .o_imem_addr            (bfm.imem_addr),
                 .i_imem_data            (bfm.imem_data),
                 .o_axi_lite_cmd_awaddr  (bfm.axi_awaddr  ),
                 .o_axi_lite_cmd_awprot  (bfm.axi_awprot  ),
                 .o_axi_lite_cmd_awvalid (bfm.axi_awvalid ),
                 .o_axi_lite_cmd_wdata   (bfm.axi_wdata   ),
                 .o_axi_lite_cmd_wstrb   (bfm.axi_wstrb   ),
                 .o_axi_lite_cmd_wvalid  (bfm.axi_wvalid  ),
                 .o_axi_lite_cmd_bready  (bfm.axi_bready  ),
                 .o_axi_lite_cmd_araddr  (bfm.axi_araddr  ),
                 .o_axi_lite_cmd_arprot  (bfm.axi_arprot  ),
                 .o_axi_lite_cmd_arvalid (bfm.axi_arvalid ),
                 .o_axi_lite_cmd_rready  (bfm.axi_rready  ),
                 .i_axi_lite_rsp_awready (bfm.axi_awready ),
                 .i_axi_lite_rsp_wready  (bfm.axi_wready  ),
                 .i_axi_lite_rsp_bresp   (bfm.axi_bresp   ),
                 .i_axi_lite_rsp_bvalid  (bfm.axi_bvalid  ),
                 .i_axi_lite_rsp_arready (bfm.axi_arready ),
                 .i_axi_lite_rsp_rdata   (bfm.axi_rdata   ),
                 .i_axi_lite_rsp_rresp   (bfm.axi_rresp   ),
                 .i_axi_lite_rsp_rvalid  (bfm.axi_rvalid  ),
                 .i_ext_irq              ( 1'b0          ),
                 .o_ie                   (               ),
                 .o_tie                  (               ),
                 .i_irq_cause            ( 32'd0         )
                 );

   
initial begin
   uvm_config_db #(virtual core_bfm)::set(null, "*", "bfm", bfm);
   run_test();
end

endmodule : top

     
   
