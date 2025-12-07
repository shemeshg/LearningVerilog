
const isEmulator = true;
export const topModule = isEmulator ? "tb_emulator": "tb_select_action"
export const inFiles=[
    "../hdl/types_pkg.sv",
    "../hdl/add_sub_mult.sv",
    "../hdl/select_action.sv",
    "../hdl/select_btn_action.sv",
    "../hdl/unbounce_btn.sv",
    isEmulator ? "../tb/tb_emulator.sv" : "../tb/tb_select_action.sv" 
]