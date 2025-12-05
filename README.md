# Learning FPGA

This repository is my personal journey into learning FPGA development, guided by the excellent *FPGA Programming Handbook – Second Edition*.  

To support my learning, I built an emulator for the **Nexys A7** board using **Qt/QML**.  
The emulator helps ease the effort of testing and synthesis by simulating hardware behavior.  

- The Verilog code examples are located in the `./Handbook` folder, following the structure of the book.  
- The `./Youtube` folder contains tutorial material that parallels the examples, serving as an additional learning resource.  

The emulator operates by having the testbench generate temporary files that represent the status of LEDs and the screen buffer.  
It then provides switch states and button press states for the Verilog code to read, making experimentation smoother and more accessible.


<img width="992" height="352" alt="image" src="https://github.com/user-attachments/assets/8ffea46a-af87-4ca0-b3e9-0d8588f6da84" />


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
