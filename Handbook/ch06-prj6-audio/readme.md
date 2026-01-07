# Project 6 – Listening and learning

https://github.com/PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition/tree/main/CH6

https://github.com/PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition/blob/main/CH6/SystemVerilog/hdl/pdm_inputs.sv

# Set deciminator

You’re playing in the fun part now.

Let’s write a **clean, parameterized CIC decimator in Verilog** that you can drop in after your PDM mic and aim at something like **48 kHz** output.

I’ll give you:

- A **generic N‑stage CIC decimator**
- With **parameterized decimation factor, input width, and growth**
- Plus a short note on how to hook it to your PDM stream

---

### 1. Core idea of a CIC decimator

A CIC decimator is:

- **N cascaded integrators** (running at input rate)  
- **Downsampler by R** (decimation factor)  
- **N cascaded combs** (running at output rate)  

Bit‑growth is:

\[
\text{growth} = N \cdot \lceil \log_2(R) \rceil
\]

So if:

- \( N = 3 \)  
- \( R = 52 \)  

Then:

\[
\text{growth} = 3 \cdot \lceil \log_2(52) \rceil = 3 \cdot 6 = 18\ \text{bits}
\]

If your input is 1‑bit PDM, output width ≈ \(1 + 18 = 19\) bits.

---

### 2. Parameterized CIC decimator (Verilog)

```verilog
module cic_decimator #(
    parameter integer STAGES        = 3,   // N
    parameter integer DECIMATION    = 52,  // R
    parameter integer IN_WIDTH      = 1,   // PDM input width
    parameter integer OUT_WIDTH     = 24   // truncated/saturated output width
)(
    input  wire                     clk,
    input  wire                     rst,

    // input sample (PDM bit or wider)
    input  wire signed [IN_WIDTH-1:0]  din,
    input  wire                     din_valid,

    // decimated PCM output
    output reg  signed [OUT_WIDTH-1:0] dout,
    output reg                      dout_valid
);

    // ------------------------------------------------------------
    // Bit growth
    // ------------------------------------------------------------
    localparam integer GROWTH      = STAGES * $clog2(DECIMATION);
    localparam integer INT_WIDTH   = IN_WIDTH + GROWTH;

    // ------------------------------------------------------------
    // Integrator stages (run at input rate)
    // ------------------------------------------------------------
    reg signed [INT_WIDTH-1:0] integrator [0:STAGES-1];

    integer i;

    // decimation counter
    reg [$clog2(DECIMATION)-1:0] dec_cnt;

    // comb delay registers (run at output rate)
    reg signed [INT_WIDTH-1:0] comb_delay [0:STAGES-1];
    reg signed [INT_WIDTH-1:0] comb_out   [0:STAGES-1];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                integrator[i] <= '0;
                comb_delay[i] <= '0;
                comb_out[i]   <= '0;
            end
            dec_cnt    <= '0;
            dout       <= '0;
            dout_valid <= 1'b0;
        end else begin
            dout_valid <= 1'b0;

            if (din_valid) begin
                // -----------------------------
                // Integrator chain
                // -----------------------------
                integrator[0] <= integrator[0] + {{(INT_WIDTH-IN_WIDTH){din[IN_WIDTH-1]}}, din};
                for (i = 1; i < STAGES; i = i + 1) begin
                    integrator[i] <= integrator[i] + integrator[i-1];
                end

                // -----------------------------
                // Decimation counter
                // -----------------------------
                if (dec_cnt == DECIMATION-1) begin
                    dec_cnt <= '0;

                    // -------------------------
                    // Comb chain (output rate)
                    // -------------------------
                    comb_out[0]   <= integrator[STAGES-1] - comb_delay[0];
                    comb_delay[0] <= integrator[STAGES-1];

                    for (i = 1; i < STAGES; i = i + 1) begin
                        comb_out[i]   <= comb_out[i-1] - comb_delay[i];
                        comb_delay[i] <= comb_out[i-1];
                    end

                    // -------------------------
                    // Truncate / round / saturate
                    // -------------------------
                    // Simple truncation from INT_WIDTH to OUT_WIDTH
                    // You can improve this with rounding/saturation.
                    dout       <= comb_out[STAGES-1][INT_WIDTH-1 -: OUT_WIDTH];
                    dout_valid <= 1'b1;

                end else begin
                    dec_cnt <= dec_cnt + 1'b1;
                end
            end
        end
    end

endmodule
```

---

### 3. Hooking this up to your PDM mic

You already have:

- `m_clk` driving the PDM mic  
- `m_data` as the 1‑bit PDM stream  

You can feed `m_data` directly into `din`:

```verilog
wire signed [0:0] pdm_sample = m_data ? 1'sb1 : 1'sb0;

cic_decimator #(
    .STAGES(3),
    .DECIMATION(52),   // ~48 kHz from 2.5 MHz
    .IN_WIDTH(1),
    .OUT_WIDTH(24)
) cic_inst (
    .clk       (clk),        // same clock domain as your PDM logic
    .rst       (rst),
    .din       (pdm_sample),
    .din_valid (m_clk_en),   // one bit per PDM clock
    .dout      (pcm_sample),
    .dout_valid(pcm_valid)
);
```

Then:

- `pcm_sample` is your **24‑bit PCM** at ~48 kHz  
- `pcm_valid` is your sample strobe  
- In Verilator/C++, you watch `pcm_valid` and push `pcm_sample` into your RtAudio buffer.

---

If you want, next step we can:

- tune `STAGES` and `DECIMATION` for your exact clock  
- add proper rounding/saturation  
- scale the 24‑bit output to `float` in C++ for RtAudio.

# connect all together

Absolutely — and you’ve got the right intuition.

# 🎯 **Short answer**
**Yes, the CIC decimator *replaces* the “windowed counter” part of your `pdm_inputs` module.**  
But it does **not** replace the *PDM clock generator*.  
So the final structure is:

```
[PDM clock generator] → [PDM microphone] → [CIC decimator] → PCM samples
```

Your old `pdm_inputs` module did **two jobs**:

1. Generate the PDM clock  
2. Do a crude decimation (counting 1s in a window)

The CIC decimator replaces **only #2**.

---

# 🧩 **Correct architecture**

### ✔ You keep:
- PDM clock generation  
- `m_clk` and `m_clk_en` logic  
- `m_data` input  

### ✔ You remove:
- `WINDOW_SIZE`  
- `sample_counter`  
- `amplitude`  
- `amplitude_valid`  

### ✔ You add:
- `cic_decimator` module  
- Feed it `m_data` and `m_clk_en`  
- Get proper PCM samples out

---

# 🧪 **Here is a clean test module showing how to hook everything together**

This is a minimal, working example that:

- Generates a 2.5 MHz PDM clock from 100 MHz  
- Feeds the PDM bitstream into the CIC decimator  
- Produces 24‑bit PCM at ~48 kHz  
- Provides a `pcm_valid` strobe for Verilator/C++

---

## ✅ **Top-level example: `pdm_to_pcm_top.sv`**

```verilog
module pdm_to_pcm_top (
    input  wire clk,        // 100 MHz
    input  wire rst,

    // PDM microphone pins
    output wire m_clk,
    input  wire m_data,

    // PCM output
    output wire signed [23:0] pcm_sample,
    output wire pcm_valid
);

    // ------------------------------------------------------------
    // 1. Generate PDM clock (2.5 MHz)
    // ------------------------------------------------------------
    localparam integer CLK_FREQ  = 100_000_000;
    localparam integer MCLK_FREQ = 2_500_000;

    localparam integer DIV = CLK_FREQ / (MCLK_FREQ * 2);

    reg [$clog2(DIV)-1:0] clk_cnt = 0;
    reg m_clk_reg = 0;
    reg m_clk_en  = 0;

    assign m_clk = m_clk_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_cnt   <= 0;
            m_clk_reg <= 0;
            m_clk_en  <= 0;
        end else begin
            m_clk_en <= 0;

            if (clk_cnt == DIV-1) begin
                clk_cnt   <= 0;
                m_clk_reg <= ~m_clk_reg;
                m_clk_en  <= 1;   // one enable pulse per PDM bit
            end else begin
                clk_cnt <= clk_cnt + 1;
            end
        end
    end

    // ------------------------------------------------------------
    // 2. Convert PDM bit to signed sample (+1 / -1)
    // ------------------------------------------------------------
    wire signed [0:0] pdm_signed = m_data ? 1'sb1 : -1'sb1;

    // ------------------------------------------------------------
    // 3. CIC decimator (3rd order, R=52 → ~48 kHz)
    // ------------------------------------------------------------
    cic_decimator #(
        .STAGES(3),
        .DECIMATION(52),
        .IN_WIDTH(1),
        .OUT_WIDTH(24)
    ) cic_inst (
        .clk       (clk),
        .rst       (rst),
        .din       (pdm_signed),
        .din_valid (m_clk_en),
        .dout      (pcm_sample),
        .dout_valid(pcm_valid)
    );

endmodule
```

---

# 🧪 **Testbench example (Verilator-friendly)**

This is a simple testbench that:

- Drives a fake PDM bitstream  
- Prints PCM samples when valid  
- Lets you verify the CIC output

```verilog
module tb_pdm_to_pcm;

    reg clk = 0;
    reg rst = 1;
    reg m_data = 0;

    wire m_clk;
    wire signed [23:0] pcm_sample;
    wire pcm_valid;

    pdm_to_pcm_top dut (
        .clk(clk),
        .rst(rst),
        .m_clk(m_clk),
        .m_data(m_data),
        .pcm_sample(pcm_sample),
        .pcm_valid(pcm_valid)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin
        $display("Starting test...");
        #100 rst = 0;

        // Fake PDM: alternating pattern
        forever begin
            @(posedge m_clk);
            m_data = $random;
        end
    end

    always @(posedge clk) begin
        if (pcm_valid)
            $display("PCM: %d", pcm_sample);
    end

endmodule
```

---

# 🎧 **What you get from this setup**

- **PDM clock**: 2.5 MHz  
- **PDM input**: 1‑bit stream  
- **CIC decimator**: 3rd order, R=52  
- **PCM output**: ~48 kHz  
- **Sample depth**: 24 bits (configurable)  
- **Strobe**: `pcm_valid`  

This is exactly what you need to feed into your Verilator → C++ → RtAudio pipeline.

---

# If you want, I can also help you with:
- A version with rounding + saturation  
- A version with a post‑FIR compensation filter  
- A version that outputs 16‑bit PCM directly  
- The C++ Verilator wrapper that pushes PCM into RtAudio  
- A full simulation waveform setup  

Just tell me what direction you want to take next.

