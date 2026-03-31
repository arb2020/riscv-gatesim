# Standard Cell Library — 68nm CMOS

A custom standard cell library designed and verified as part of EE/CE 6325 VLSI Design at UT Dallas. All cells were designed in Cadence Virtuoso, simulated with HSPICE, and verified with DRC and LVS using Calibre.

---

## Technology Specifications

| Parameter | Value |
|---|---|
| Process | 68nm CMOS |
| pMOS Width | 1.5 µm |
| nMOS Width | 1.3 µm |
| Channel Length | 68 nm |
| Pin Pitch | 0.52 µm |
| Supply Voltage | 1.2V |

---

## Tool Flow

1. Schematic entry — Cadence Virtuoso
2. Layout — Cadence Virtuoso
3. Functional simulation — HSPICE
4. Abstract view generation — Cadence Virtuoso
5. DRC and LVS verification — Calibre
6. Timing characterization — PrimeLib

---

## Cell Library

### INV
**Boolean:** `A'`

Simple CMOS inverter with one pMOS pull-up and one nMOS pull-down.

---

### NAND2
**Boolean:** `(AB)'`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | — |
| Cell Width | — |
| Pin Pitch | 0.52 µm |

---

### NOR2
**Boolean:** `(A+B)'`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | — |
| Cell Width | — |
| Pin Pitch | 0.52 µm |

---

### XOR2
**Boolean:** `((A+B)'+(A.B))'`

Implemented using an efficient 10-transistor design to minimize area and transistor count compared to a standard gate-level implementation.

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.171 µm |
| Cell Width | 4.204 µm |
| Pin Pitch | 0.52 µm |

---

### XNOR2
**Boolean:** `((A.B)'.(A+B))'`

Implemented using an efficient 10-transistor design, mirroring the XOR2 topology with an inverted output stage.

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.171 µm |
| Cell Width | 4.204 µm |
| Pin Pitch | 0.52 µm |

---

### AOI21
**Boolean:** `(AB+C)'`

Simplified via DeMorgan: `(A'+B')(C')`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.368 µm |
| Cell Width | 3.140 µm |
| Pin Pitch | 0.52 µm |

---

### AOI22
**Boolean:** `(AB+CD)'`

Simplified via DeMorgan: `(A'+B')(C'+D')`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.654 µm |
| Cell Width | 3.475 µm |
| Pin Pitch | 0.52 µm |

---

### AOI123
**Boolean:** `(A)(BC+D)(EFG)'`

Simplified: `(A')(B'+C')(D'+E'+F')`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.878 µm |
| Cell Width | 4.503 µm |
| Pin Pitch | 0.52 µm |

---

### OAI12
**Boolean:** `((A+B)·C)'`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.654 µm |
| Cell Width | 3.142 µm |
| Pin Pitch | 0.52 µm |

---

### OAI22
**Boolean:** `((A+B)(C+D))'`

Simplified: `(A'B')+(C'D')`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.654 µm |
| Cell Width | 3.475 µm |
| Pin Pitch | 0.52 µm |

---

### OAI321
**Boolean:** `((A+B+C)(D+E)(F))'`

Simplified: `A'B'C' + D'E' + F'`

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Length | 5.878 µm |
| Cell Width | 4.503 µm |
| Pin Pitch | 0.52 µm |

---

### DFF (D Flip-Flop)
**Type:** Rising edge triggered with active-high synchronous reset

Built from tri-state inverters. Layout was optimized by flipping cells to share VDD/GND rails, minimizing diffusion breaks to 4. Four M2 layers were used for input/output pins. Clock routing used a centered horizontal poly to minimize wire length.

| Measurement | Value |
|---|---|
| Channel Length | 68 nm |
| Cell Width | 7.063 µm |
| Cell Height | 7.246 µm |
| Pin Pitch | 0.26x multiple |
| Diffusion Breaks | 4 |
| M2 Layers | 4 |

**Timing Characterization (HSPICE):**

| Parameter | Q → HIGH | Q → LOW |
|---|---|---|
| Tsu_dd | 40.2 ps | 42.2 ps |
| Tsu_opt | 40.5 ps | 42.5 ps |
| Thold | 42.5 ps | 40.5 ps |
| Tclk→Q | 315 ps | 280 ps |
| TD | 355.5 ps | 322.5 ps |

> **Note:** CLK rising edge reference point is at 3000 ps. Tsu_dd is defined as the smallest decimal setup time that still reliably drives Q to the correct output. TD = Tclk→Q + Tsu_opt.

Timing characterization was completed using PrimeLib for timing, power, and noise analysis.

---

## Combined Layout

All 11 combinational cells were placed into a single combined layout. Cell arrangement from left to right:

`INV` → `NOR2` → `XOR2` → `XNOR2` → `OAI12` → `AOI21` → `NAND2` → `OAI22` → `AOI22` → `AOI123` → `OAI321`

DRC and LVS were run on the combined layout with clean results — no DRC errors and a passing LVS with all 82 instances matched (41 nMOS + 41 pMOS).

---

## Contributors

- Areeb Iqbal
- Jonathan Le

**Advisor:** Dr. Carl Sechen  
**Course:** EE/CE 6325 VLSI Design — UT Dallas
