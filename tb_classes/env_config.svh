class env_config;
 virtual core_bfm bfm;

 function new(virtual core_bfm bfm);
    this.bfm = bfm;
 endfunction : new
endclass : env_config

