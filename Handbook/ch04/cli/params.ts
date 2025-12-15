
export const emulatorHdlCmakeFolderStr = "../../../NexysA7Emulator/Bal/HdlLib/"

export enum Mode {
  Emulator = "Emulator",
  Testbench = "Testbench",
  Deploy = "Deploy"
}

export const use_verilator = true;


export const currentMode: Mode = Mode.Deploy; // change as needed
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
  "../hdl/types_pkg.sv",
  "../hdl/dec_cat_map.sv",
  "../hdl/bin_to_bcd.sv",
  "../hdl/seg_display_calc.sv",
  "../hdl/add_sub_mult.sv",
  "../hdl/select_action.sv",
  "../hdl/select_btn_action.sv",
  "../hdl/unbounce_btn.sv",
  "../hdl/unbounce_array.sv"
];

// Append OS‑specific file only for Emulator/Testbench
if (currentMode === Mode.Testbench) {
  inFiles.push(
    process.platform === "darwin"
      ? "../tb/tb_macos_only.sv"
      : "../tb/tb_ubuntu_only.sv"
  );
}

// Append mode‑specific file
if (currentMode === Mode.Testbench) {
  inFiles.push(`../tb/${topModule}.sv`);
} else if (currentMode === Mode.Deploy) {
  inFiles.push("../hdl/top.sv"); // placeholder for Deploy
}
