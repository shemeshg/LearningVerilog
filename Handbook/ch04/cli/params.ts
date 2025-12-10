
const isEmulator = true;
export const topModule = isEmulator ? "tb_emulator": "tb_seg_display"
export const inFiles=[
    "../hdl/types_pkg.sv",
    "../hdl/dec_cat_map.sv",
    "../hdl/bin_to_bcd.sv",
    "../hdl/seg_display_calc.sv",
    "../hdl/add_sub_mult.sv",
    "../hdl/select_action.sv",
    "../hdl/select_btn_action.sv",
    "../hdl/unbounce_btn.sv",
    "../hdl/unbounce_array.sv",
    //macos only
    "../tb/tb_macos_only.sv",
    isEmulator ? "../tb/tb_emulator.sv" : "../tb/tb_seg_display.sv" 
]