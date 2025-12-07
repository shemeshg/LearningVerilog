
const isEmulator = true;
export const topModule = isEmulator ? "tb_emulator": "tb_unbounce_btn"
export const inFiles=[
    "../hdl/types_pkg.sv",
    "../hdl/add_sub_mult.sv",
    "../hdl/select_action.sv",
    "../hdl/select_btn_action.sv",
    "../hdl/unbounce_btn.sv",
    "../hdl/unbounce_array.sv",
    isEmulator ? "../tb/tb_emulator.sv" : "../tb/tb_unbounce_btn.sv" 
]