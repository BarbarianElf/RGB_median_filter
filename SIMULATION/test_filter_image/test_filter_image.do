##############################################################
------------------FROM RAW TO MIF------------------
##############################################################
# your workspace full path
set path_to_sim_lib "./"
cd $path_to_sim_lib
set raw2mif_file "raw2mif.vhd"
if {![file exists work]} {exec vlib work}
vmap work work
vcom -93 -quiet -work work $raw2mif_file
vsim raw2mif
run 10 ns

quit -sim


##############################################################
------------------FILTER IMAGE------------------
##############################################################


# ******************PLEASE CHANGE altera_list TO YOUR PATH******************
set altera_list [list "C:\\intelFPGA_lite\\19.1\\quartus\\eda\\sim_lib\\altera_mf_components.vhd" "C:\\intelFPGA_lite\\19.1\\quartus\\eda\\sim_lib\\altera_mf.vhd"]

# project ordered file list 
set file_list [list "project_package.vhd" "generic_rom.vhd" "generic_ram.vhd" "fsm.vhd" "counter_ena.vhd" "control_unit.vhd" "buffer_reg.vhd" "median_filter.vhd" "filter_image.vhd" "filter_image_tb.vhd"]

# your project top level
set top_level filter_image_tb

# set run time at online by user
set run_time "13000 ns"

if {![file exists work]} {exec vlib work}

vmap work work
vmap altera_mf work

foreach file_name $altera_list {vcom -93 -quiet -work work $file_name}

foreach file_name $file_list {vcom -93 -quiet -work work $file_name}

vsim -title $top_level $top_level

run $run_time

# saving one of the RAM
mem save -o $path_to_sim_lib/r.mem -f mti -data binary -addr hex -startaddress 0 -endaddress 255 /filter_image_tb/t1/ram_loop(2)/ram/altsyncram_component/MEMORY/m_mem_data_a
mem save -o $path_to_sim_lib/g.mem -f mti -data binary -addr hex -startaddress 0 -endaddress 255 /filter_image_tb/t1/ram_loop(1)/ram/altsyncram_component/MEMORY/m_mem_data_a
mem save -o $path_to_sim_lib/b.mem -f mti -data binary -addr hex -startaddress 0 -endaddress 255 /filter_image_tb/t1/ram_loop(0)/ram/altsyncram_component/MEMORY/m_mem_data_a

quit -sim

##############################################################
------------------FROM MEM TO RAW------------------
##############################################################

set mif2raw_file "mif2raw_hex_modelsim.vhd"
vmap work work
vcom -93 -quiet -work work $mif2raw_file
vsim mif2raw_hex_modelsim
run 10 ns
