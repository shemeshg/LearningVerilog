#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vtop.h"

int main(int argc, char **argv) {
    VerilatedContext* ctx = new VerilatedContext;
    VerilatedVcdC* trace = new VerilatedVcdC;
    Vtop* dut = new Vtop;

    ctx->traceEverOn(true);
    dut->trace(trace, 3);
    trace->open("wave.vcd");

    // Initialize inputs
    dut->CLK100MHZ = 0;
    dut->CPU_RESETN = 0;
    dut->SW = 0;
    dut->BTNC = dut->BTNU = dut->BTNL = dut->BTNR = dut->BTND = 0;

    // Apply reset for a few cycles
    for (int i = 0; i < 5; i++) {
        dut->CLK100MHZ = 0; dut->eval(); trace->dump(ctx->time()); ctx->timeInc(1);
        dut->CLK100MHZ = 1; dut->eval(); trace->dump(ctx->time()); ctx->timeInc(1);
    }
    dut->CPU_RESETN = 1;

    // Main simulation loop
    for (int t = 0; t < 200000; t++) {
        // Toggle clock
        dut->CLK100MHZ ^= 1;

        // Example stimulus
        dut->SW = 0x1234;
        dut->BTNC = (t == 1000);
        dut->BTNU = (t == 2000);

        dut->eval();
        trace->dump(ctx->time());
        ctx->timeInc(1);
    }

    trace->close();
    delete dut;
    return 0;
}
