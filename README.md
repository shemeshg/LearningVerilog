# Learning FPGA

This repository documents my personal journey into FPGA development, inspired by the excellent *FPGA Programming Handbook – Second Edition*.

To support the learning process, I built an emulator for the **Nexys A7** board using **Qt/QML**.  
The emulator reduces the friction of testing and synthesis by simulating hardware behavior in real time.

- Verilog examples are located in the `./Handbook` directory, following the chapter structure of the book.  
- The `./Youtube` directory contains tutorial material that complements the examples.  


<img width="992" height="352" alt="image" src="https://github.com/user-attachments/assets/8ffea46a-af87-4ca0-b3e9-0d8588f6da84" />


## Getting Started

This project uses **Google ZX scripts** to manage simulation, validation, and build steps.

### Install the CLI Tools

From the project root, run:

```
npm install
```

This installs all required Node‑based tooling, including the ZX environment used by the assignment CLI scripts.

### Required Step Before Building the Emulator

Each assignment under `Handbook/chXX-<assignmentName>` (where **XX** is the chapter number from the book) includes a dedicated **CLI script** located in its `cli/` folder.

**You must run this CLI script before building the emulator.**

Running it will (based on `params.ts` file):

1. Validate the design using **Verilator**, **Icarus**, or **Vivado** .  
2. Generate a **CMake fragment** containing all required HDL files.  
3. Place this generated CMake file where the emulator can include it during its build.

Without running this script, the emulator will not have the HDL sources it needs.

### Simulators

The workflow supports multiple Verilog simulators (based on `params.ts` config file):

- **Verilator** — required by the Qt-based emulator and recommended for fast, cycle‑accurate simulation  
- **Icarus Verilog**  
- **Vivado xvlog**   


## Emulator

The emulator is written in **Qt (C++/QML)**.  
Its **only external dependency is Verilator**, which is required to compile the HDL into a model that the emulator can load.

To run the emulator:

1. Run the assignment’s CLI script to generate the CMake HDL file.  
2. Open the emulator project in **Qt Creator**.  
3. Build and run the emulator.  

## Workflow Overview

The following diagram illustrates how each part of the system works together:

```
        ┌──────────────────────────┐
        │  Verilog Source (HDL)    │
        │  Handbook/chXX-*         │
        └─────────────┬────────────┘
                      │
                      │ 1. Run CLI script
                      ▼
        ┌──────────────────────────┐
        │   CLI Script (ZX)        │
        │ - Validates HDL          │
        │ - Runs Verilator/Icarus  │
        │ - Generates CMake file   │
        └─────────────┬────────────┘
                      │
                      │ 2. Generated CMake fragment
                      ▼
        ┌──────────────────────────┐
        │   Emulator Build (Qt)    │
        │ - Includes HDL CMake     │
        │ - Uses Verilator model   │
        └─────────────┬────────────┘
                      │
                      │ 3. Build & Run
                      ▼
        ┌──────────────────────────┐
        │   Emulator Runtime        │
        └─────────────┬────────────┘
                      │
                      │ 4. Interactive simulation loop
                      ▼
        ┌──────────────────────────┐
        │   Verilog Testbench      │
        │ - Reads emulator inputs  │
        │ - Writes hardware state  │
        └──────────────────────────┘
```


## References

- **The FPGA Programming Handbook – Second Edition**  
  https://github.com/PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition/tree/main

- **Icarus Verilog – Getting Started**  
  https://steveicarus.github.io/iverilog/usage/getting_started.html

- **YouTube – Hardware Modeling Using Verilog**  
  https://www.youtube.com/watch?v=9uw25PU5B3k&list=PLJ5C_6qdAvBELELTSPgzYkQg3HgclQh-5&index=3

