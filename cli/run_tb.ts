//npx tsx run_tb.ts
import { exit } from 'process'
import { $, cd, quiet } from 'zx'

const tb_main_class="tb_add_sub_mult"

const xvlog_files = [
  //"../../hdl/count_ones.sv", 
  //"../../tb/tb_count_ones.sv",
  //"../../hdl/leading_ones.sv", 
  //"../../tb/tb_leading_ones.sv",
  "../../hdl/types_pkg.sv", 
  "../../hdl/add_sub_mult.sv", 
  "../../tb/tb_add_sub_mult.sv",
]

async function getVivadoEnv(){
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

const [$$, $$debug] = await getVivadoEnv()
if (!$$ || !$$debug){throw new Error("Could not init Vivadeo Env.");}

await $`[ -d build ] || mkdir build`
cd('build')

await $$`echo $XILINX_VIVADO`
await $$`xvlog -sv ${xvlog_files}`
const xelab = await $$`xelab ${tb_main_class} -debug typical -s tb_sim`

let errorsAndWarnings = xelab.stdout
  .split('\n')
  .filter(line => line.startsWith('WARNING: ') || line.startsWith('ERROR'))
  .filter(line => !line.includes('XSIM 43-3431'))
if (errorsAndWarnings.length > 0) {
  console.log(errorsAndWarnings)
  throw new Error("Fix Linter Errors")
}

await $$debug`xsim tb_sim --runall`

exit(0)
