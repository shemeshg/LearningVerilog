#!/bin/bash
mkdir  -p build
cd build
source /usr/local/Xilinx/2025.1/Vivado/settings64.sh
xvlog -sv ../../hdl/count_ones.sv ../../tb/tb_count_ones.sv
xelab tb_count_ones -debug typical -s tb_sim 
xsim tb_sim --runall