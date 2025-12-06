#!/usr/bin/env tsx
import { exit } from 'process'
import { $, cd } from 'zx'
import { topModule, inFiles } from './params.ts';
async function run_icarus() {
    const $$debug = $({ verbose: true, env: process.env })
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
  if (process.platform === "darwin") {
    await run_icarus();
  } else if (process.platform === "linux") {
    await run_xvlog();
  } else {
    console.log("Unsupported platform:", process.platform);
  }
exit(0)