
echo Start of Simulation

#-------------------------------------------------------------------
# prepare workspace
#-------------------------------------------------------------------

# your workspace full path
set path_to_sim_lib "./"

# your project ordered file list
set altera_list [list "C:\\intelFPGA_lite\\19.1\\quartus\\eda\\sim_lib\\altera_mf_components.vhd" "C:\\intelFPGA_lite\\19.1\\quartus\\eda\\sim_lib\\altera_mf.vhd"]
set file_list [list "project_package.vhd" "generic_rom.vhd" "generic_ram.vhd" "fsm.vhd" "counter_ena.vhd" "control_unit.vhd" "buffer_reg.vhd" "bypass.vhd" "bypass_tb.vhd"]

# your project top level
set top_level bypass_tb

# set run time at online by user
set run_time "13000 ns"

#-------------------------------------------------------------------
# compile and run
#-------------------------------------------------------------------

cd $path_to_sim_lib

if {![file exists work]} {exec vlib work}

vmap work work
vmap altera_mf work

foreach file_name $altera_list {vcom -93 -quiet -work work $file_name}

foreach file_name $file_list {vcom -93 -quiet -work work $file_name}

vsim -title $top_level $top_level

run $run_time

# saving one of the ram
mem save -o $path_to_sim_lib/r.mem -f mti -data binary -addr hex -startaddress 0 -endaddress 255 /bypass_tb/t1/ram_loop(2)/ram/altsyncram_component/MEMORY/m_mem_data_a

# open r mem to see what was wirrten
notepad r.mem -r