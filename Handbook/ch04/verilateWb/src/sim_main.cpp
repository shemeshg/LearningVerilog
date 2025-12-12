#include <verilated.h>
#include "verilated_vcd_c.h"
#include "Vtb_emulator.h"

int main(int argc, char **argv)
{
    // Construct context object, design object, and trace object
    VerilatedContext *m_contextp = new VerilatedContext; // Context
    VerilatedVcdC *m_tracep = new VerilatedVcdC;         // Trace
    Vtb_emulator *m_duvp = new Vtb_emulator;             // Design
    // Trace configuration
    /*
    m_contextp->traceEverOn(true);     // Turn on trace switch in context
    m_duvp->trace(m_tracep, 3);        // Set depth to 3
    m_tracep->open("cnt_ceil_wf.vcd"); // Open the VCD file to store data
    */

    // Write data to the waveform file
    while (!m_contextp->gotFinish())
    {
        m_duvp->eval();
        //m_tracep->dump(m_contextp->time());
        m_contextp->timeInc(1);
    }
    // Remember to close the trace object to save data in the file
    //m_tracep->close();
    // Free memory
    delete m_duvp;
    return 0;
}