TOP_NAME := top

SRC_FILE := \
    ../hdl/types_pkg.sv \
    ../hdl/add_sub_mult.sv \
    ../hdl/bin_to_bcd.sv \
    ../hdl/dec_cat_map.sv \
    ../hdl/seg_display_calc.sv \
    ../hdl/select_action.sv \
    ../hdl/select_btn_action.sv \
    ../hdl/top.sv  \
    ../hdl/unbounce_array.sv \
    ../hdl/unbounce_btn.sv \
    

.PHONY: run clean

obj_dir/V$(TOP_NAME): $(SRC_FILE)
	verilator -cc --exe --trace --trace-structs --build --timing \
	src/sim_main.cpp $(SRC_FILE) --top $(TOP_NAME)

run: obj_dir/V$(TOP_NAME)
	./obj_dir/V$(TOP_NAME)

clean:
	rm -rf obj_dir V$(TOP_NAME)
