# Learning FPGA

This project provides an emulator for the **Nexys A7** board, written in **Qt/QML**, along with Verilog code located in the `./Handbook` folder.  
Additionally, the `./Youtube` folder contains tutorial material that is roughly equivalent to the examples from *The FPGA Programming Handbook – Second Edition*.  

The emulator works by having the testbench write temporary files that represent the status of LEDs and the screen buffer.  
In turn, the emulator writes the switch states and button press states for the Verilog code to read.

## Getting Started

This project uses **Google ZX scripts** to manage simulation and testing:

- **macOS**: Runs with **Icarus Verilog** by default.  
- **Linux**: Runs with **Vivado xvlog** for testing.

The emulator is implemented in **Qt (C++/QML)** and has no external dependencies.  
To run it:

1. Open the project with **Qt Creator**.  
2. Build and run the emulator directly.  
3. Ensure that the correct paths are set for the status files (LEDs, switches, and button states) in both:
   - The C++ code (emulator side).  
   - The Verilog testbench (simulation side).  

This setup allows the testbench to write temporary files for LED and screen buffer states, while the emulator provides switch and button states for Verilog to read.


## References

- **The FPGA Programming Handbook – Second Edition**  
  [GitHub Repository (CH4)](https://github.com/PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition/tree/main)

- **Icarus Verilog – Getting Started**  
  [Official Guide](https://steveicarus.github.io/iverilog/usage/getting_started.html)

- **YouTube – Hardware Modeling Using Verilog**  
  [Video Playlist](https://www.youtube.com/watch?v=9uw25PU5B3k&list=PLJ5C_6qdAvBELELTSPgzYkQg3HgclQh-5&index=3)
