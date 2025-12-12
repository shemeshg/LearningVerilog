#!/usr/bin/env tsx
import { exit } from 'process'
import { $, cd } from 'zx'
import { topModule, inFiles, use_verilator, verilog_sim_main_cpp } from './params.ts';

import { writeFile } from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

// ✅ Recreate __dirname in ESM
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

async function run_verilator() {
  const makefileText = `
TOP_NAME := ${topModule}

SRC_FILE := \\
\t${inFiles.map(f => `${f}`).join("\\\n\t")}

.PHONY: run clean

obj_dir/V$(TOP_NAME): $(SRC_FILE)
\tverilator -cc --exe --trace --trace-structs --build -j 0 --timing \\
\t\tsrc/${verilog_sim_main_cpp} $(SRC_FILE) --top $(TOP_NAME)

run: obj_dir/V$(TOP_NAME)
\t./obj_dir/V$(TOP_NAME)

clean:
\trm -rf obj_dir V$(TOP_NAME)
  `;

  const outPath = path.join(__dirname, "..", "verilateWb", "Makefile");

  await writeFile(outPath, makefileText, { encoding: "utf8" });
  cd('../verilateWb')
  const $$debug = $({ verbose: true, env: process.env })
  await $$debug`make`;
  await $$debug`make run`;
}
async function run_icarus() {

  const $$debug = $({ verbose: true, env: process.env })
  process.on("SIGTERM", async () => {
    console.log("SIGTERM");
    await $$debug`killall vvp || true`
    process.exit();
  });

  process.on("SIGINT", async () => {
    console.log("SIGINT");
    await $$debug`killall vvp || true`
    process.exit();
  });


  const binaryFile = "out"

  await $$debug`killall vvp || true`
  await $`mkdir -p  ../build`
  cd('../build')
  await $$debug`rm -f ${binaryFile}`
  await $$debug`iverilog -g2012 -o ${binaryFile} -s ${topModule}  ${inFiles}`
  await $$debug`vvp ${binaryFile}`
}

async function getVivadoEnv() {
  const result = await $`bash -c "set +u && source /usr/local/Xilinx/2025.1/Vivado/settings64.sh && env"`

  const envVars = Object.fromEntries(
    result.stdout
      .split('\n')
      .map(line => line.split('='))
      .filter(([key, val]) => key && val)
  )

  Object.assign(process.env, envVars)

  const $$ = $({ verbose: false, env: process.env })
  const $$debug = $({ verbose: true, env: process.env })

  return [$$, $$debug]
}

async function run_xvlog() {

  const [$$, $$debug] = await getVivadoEnv()
  if (!$$ || !$$debug) { throw new Error("Could not init Vivadeo Env."); }

  await $`mkdir -p ../build`
  cd('../build')

  await $$`echo $XILINX_VIVADO`
  await $$`xvlog -sv ${inFiles}`
  const xelab = await $$`xelab ${topModule} -debug typical -s tb_sim`

  let errorsAndWarnings = xelab.stdout
    .split('\n')
    .filter(line => line.startsWith('WARNING: ') || line.startsWith('ERROR'))
    .filter(line => !line.includes('XSIM 43-3431'))
  if (errorsAndWarnings.length > 0) {
    console.log(errorsAndWarnings)
    throw new Error("Fix Linter Errors")
  }

  await $$debug`xsim tb_sim --runall`
}

if (use_verilator) {
  await run_verilator();
} else if (process.platform === "darwin") {
  await run_icarus();
} else if (process.platform === "linux") {
  await run_xvlog();
} else {
  console.log("Unsupported platform:", process.platform);
}
exit(0)