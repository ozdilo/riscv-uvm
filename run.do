if [file exists "work"] {vdel -all}
vlib work

set showWave 0

#VERILOG DUT
vlog -f dut.f

vlog -f tb.f
if { $showWave == 1 } {
    vsim -novopt top +UVM_TESTNAME=r_type_test +UVM_VERBOSITY=UVM_MEDIUM
    add wave -position insertpoint sim:/top/bfm/*
    add wave -position insertpoint  \
        sim:/top/bfm/data_memory \
        sim:/top/bfm/instruction_memory
    add wave -position insertpoint sim:/top/DUT/*
    add wave -position insertpoint sim:/top/DUT/core_1/*
    add wave -position insertpoint sim:/top/DUT/core_1/memory_1/*
    add wave -position insertpoint  \
        sim:/top/DUT/core_1/reg32_32_1/regs
    add wave -position insertpoint sim:/top/DUT/core_1/reg32_32_1/*
} elseif { $showWave == 0 } {
    vopt top -o top_optimized  +acc +cover=sbfec+core(behavioral).
    vsim top_optimized -coverage +UVM_TESTNAME=r_type_test
}
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage save r_type_test.ucdb


if { $showWave == 2 } {
    vsim -novopt top +UVM_TESTNAME=imm_type_test +UVM_VERBOSITY=UVM_MEDIUM
    add wave -position insertpoint sim:/top/bfm/*
    add wave -position insertpoint  \
        sim:/top/bfm/data_memory \
        sim:/top/bfm/instruction_memory
    add wave -position insertpoint sim:/top/DUT/*
    add wave -position insertpoint sim:/top/DUT/core_1/*
    add wave -position insertpoint  \
        sim:/top/DUT/core_axi_1/core_1/reg32_32_1/regs
} elseif { $showWave == 0 } {
    vsim top_optimized -coverage +UVM_TESTNAME=imm_type_test
}


set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage save imm_type_test.ucdb

vcover merge  core.ucdb r_type_test.ucdb imm_type_test.ucdb
vcover report core.ucdb -cvg -details
#quit
