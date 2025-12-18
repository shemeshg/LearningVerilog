## High‑Level Behavior

This design follows the calculator assignment from the FPGA Programming Handbook (CH5), 

https://github.com/PacktPublishing/The-FPGA-Programming-Handbook-Second-Edition/tree/main/CH5


but uses the following custom button layout:

```
        Mult
Minus   Mode    Plus
        Div
```

The calculator operates in **two modes**, controlled by a single toggle switch.

### **Edit Mode (E)**
- The 7‑segment display shows the **current switch value**, which serves as the operand.
- Pressing an arithmetic button only **selects** the operation; no computation occurs.

### **Compute Mode (C)**
- The 7‑segment display shows the **running total**.
- Pressing an arithmetic button **executes** the selected operation using the current operand.

---

## Mode Switch

A single switch determines which mode is active:

```verilog
logic isEdit;   // 1 = Edit mode, 0 = Compute mode
```

---

## 7‑Segment Mode Indicator

The most significant digit of the display indicates the active mode:

- `'E'` when in Edit mode  
- `''` when in Compute mode  

Example encoding:

```verilog
assign seg7[7] = isEdit ? 4'hE : 4'hC;
```

(Adjust as needed for your 7‑segment driver.)

- after clicking operand btn, it will flip to compute mode for 1sec and back
if pressed in compute mode, then just do nothing.
---

## Internal Registers

Only two data registers are required:

```verilog
logic [15:0] total;     // running total
logic [15:0] operand;   // current switch value
```

And one register to store the selected operation:

```verilog
typedef enum logic [1:0] {ADD, SUB, MUL, DIV} op_t;
op_t op;
```

---

## Operand Handling

In Edit mode, the operand simply mirrors the switch inputs:

```verilog
always_comb begin
    if (isEdit)
        operand = switches;
end
```

---

## Button Handling (No FSM Required)

Arithmetic buttons always update the selected operation.  

```verilog
always_ff @(posedge clk) begin
    if (reset) begin
        total <= 0;

    end else begin
        unique case (1'b1)
            btn_plus:   total <= total + operand;
            btn_minus:  total <= total - operand;
            btn_mult:   total <= total * operand;
            btn_div:    if (operand != 0) total <= total / operand;
            btn_reset:  total <= 0;
        endcase
    end
end

```

---

## 7‑Segment Display Output

```verilog
logic [15:0] displayValue;

assign displayValue = isEdit ? operand : total;
```

Feed `displayValue` into your hex‑to‑7‑segment driver.

---

## Architecture Summary

| Component       | Behavior |
|-----------------|----------|
| `isEdit`        | Selects Edit vs. Compute mode |
| Switches        | Provide operand in Edit or view mode  |
| Buttons         | Choose operation to execute  |
| 7‑segment       | Shows operand (E) or total (C) |
| `7SegDisp[7]`   | Displays **E** or **C** |

This produces a clean, minimal calculator design with no state machine—just simple mode‑dependent logic.

---

If you want, I can also rewrite this in a more formal documentation style, or help you turn it into a full top‑level module.