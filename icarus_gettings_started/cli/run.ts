#!/usr/bin/env tsx
import { exit } from 'process'
import { $, cd } from 'zx'

const $$debug = $({ verbose: true, env: process.env })

const binaryFile = "out"

const topModule = "hello"
const inFiles=[
    "../hdl/types_pkg.sv",
    "../hdl/add_sub_mult.sv",
    "../hdl/select_action.sv",

    "../hdl/hello.sv"            
]
await $`mkdir -p  ../build`
cd('../build')
await $$debug`rm -f ${binaryFile}`
await $$debug`iverilog -g2012 -o ${binaryFile} -s ${topModule}  ${inFiles}`
await $$debug`vvp ${binaryFile}`

exit(0)