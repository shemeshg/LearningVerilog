#!/usr/bin/env tsx
import { exit } from 'process'
import { $, cd } from 'zx'
import { topModule, inFiles } from './params.ts';  
const $$debug = $({ verbose: true, env: process.env })

const binaryFile = "out"


await $`mkdir -p  ../build`
cd('../build')
await $$debug`rm -f ${binaryFile}`
await $$debug`iverilog -g2012 -o ${binaryFile} -s ${topModule}  ${inFiles}`
await $$debug`vvp ${binaryFile}`

exit(0)