
export const emulatorHdlCmakeFolderStr = "../../../NexysA7Emulator/Bal/HdlLib/"

export enum Mode {
  Testbench = "Testbench",
  Deploy = "Deploy"
}

export const use_verilator = true;


export const currentMode: Mode = Mode.Testbench; // change as needed
export const verilog_sim_main_cpp = currentMode === Mode.Testbench  ? "sim_main_tb.cpp" : "sim_main_top.cpp";

// Top module selection
let topModule: string;



switch (currentMode) {
  case Mode.Testbench:
    topModule = "tb_emulator";
    break;
  case Mode.Deploy:
    topModule = "top"; // placeholder for Deploy
    break;
  default:
    throw new Error(`Unhandled mode: ${currentMode}`);
}


export { topModule };

// Base input files (always included)
export const inFiles: string[] = [
  "../ip_fake/sys_pll.sv",
  "../hdl/types_pkg.sv",
  "../hdl/edge_detect.sv",
  "../hdl/divider_nr.sv",
  "../hdl/dec_cat_map.sv",
  "../hdl/bin_to_bcd.sv",
  "../hdl/seg_display_calc.sv",
  "../hdl/add_sub_mult.sv",
  "../hdl/select_btn_action.sv",
  "../hdl/unbounce_btn.sv",
  "../hdl/unbounce_array.sv",
  "../hdl/clock_seg_display.sv",
  "../hdl/seg_display.sv",
  "../hdl/rgb_test.sv"
];


// Append mode‑specific file
if (currentMode === Mode.Testbench) {
  inFiles.push(`../tb/${topModule}.sv`);
} else if (currentMode === Mode.Deploy) {
  inFiles.push("../hdl/top.sv"); // placeholder for Deploy
}
