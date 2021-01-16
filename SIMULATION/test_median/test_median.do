
echo Start of Simulation

#-------------------------------------------------------------------
# prepare workspace
#-------------------------------------------------------------------

# your workspace full path
set path_to_sim_lib "./"

# your project ordered file list
set file_list [list "project_package.vhd" "median_filter.vhd" "median_filter_tb.vhd"]

# your project top level
set top_level median_filter_tb

# set run time at online by user
set run_time "20 ns"

#-------------------------------------------------------------------
# compile and run
#-------------------------------------------------------------------

cd $path_to_sim_lib

if {![file exists work]} {exec vlib work}

vmap work work

foreach file_name $file_list {vcom -93 -quiet -work work $file_name}

vsim -title $top_level $top_level

# waves
do wave.do

run $run_time
