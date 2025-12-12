
TOP_NAME := tb_emulator

SRC_FILE := \
	../hdl/types_pkg.sv\
	../hdl/dec_cat_map.sv\
	../hdl/bin_to_bcd.sv\
	../hdl/seg_display_calc.sv\
	../hdl/add_sub_mult.sv\
	../hdl/select_action.sv\
	../hdl/select_btn_action.sv\
	../hdl/unbounce_btn.sv\
	../hdl/unbounce_array.sv\
	../tb/tb_macos_only.sv\
	../tb/tb_emulator.sv

.PHONY: run clean

obj_dir/V$(TOP_NAME): $(SRC_FILE)
	verilator -cc --exe --trace --trace-structs --build -j 0 --timing \
		src/sim_main_tb.cpp $(SRC_FILE) --top $(TOP_NAME)

run: obj_dir/V$(TOP_NAME)
	./obj_dir/V$(TOP_NAME)

clean:
	rm -rf obj_dir V$(TOP_NAME)
  