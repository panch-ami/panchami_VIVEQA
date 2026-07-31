# FPGA Digital Hardware Design — VIVEQA Training Repository

This repository contains the Verilog RTL source codes, testbenches, and Vivado implementation files developed during the **1-Month Hands-on FPGA Internship Program** at **VIVEQA** (Deeptech Training Institute by Anmaya Technologies), held at **MUTBI, Manipal**[cite: 3].

The program focused on end-to-end digital hardware design, synthesizable Verilog coding, bus protocol design, and hardware debugging on an industry-standard FPGA platform.

---

## 🛠️ Technology & Tool Stack

* **Target Hardware:** Xilinx Artix-7 100T FPGA Development Board (`Arty A7-100T`)
* **Design Tools:** Xilinx Vivado Design Suite, Vivado XSim, Integrated Logic Analyzer (ILA), Hardware Manager
* **Hardware Description Language:** Verilog HDL
* **Communication Protocols:** UART, SPI (Master), I2C (Master)

---

## 📚 Course Curriculum & Weekly Achievements

### 🔹 Week 1: Digital Design Foundations & Verilog RTL
* Designed combinational and sequential circuits using synthesizable Verilog coding practices.
* Understood and implemented flip flop and async and sync counters. 
* Implemented Finite State Machine (FSM) control logic and understood digital timing concepts.

### 🔹 Week 2: Vivado Design Flow & Hardware Implementation
* Executed the complete FPGA implementation flow: RTL synthesis, place and route, and bitstream generation.
* Authored **XDC constraint files** for physical pin assignments and clock timing definitions.
* Performed on-chip real-time debugging using Xilinx **Integrated Logic Analyzer (ILA)** and Hardware Manager.
* Implemented FSM and ALU designs directly onto the Artix-7 100T board.
* Probed live internal signals using ILA to compare real hardware behavior against simulation waveforms.

### 🔹 Week 3: Intermediate FPGA Design & Peripheral Communication
* Designed hardware controllers for serial communication protocols from scratch in Verilog.
* Studied Clock Domain Crossing (CDC) fundamentals for multi-clock system stability.
* **Labs Completed:**
  * **UART Transmitter:** Designed and verified serial data transmission from FPGA to PC.
  * **SPI Master Controller:** Interfaced and communicated with external peripheral ICs.

### 🔹 Week 4: System Integration & Mini Project
* Planned top-level module architecture, interface specifications, and resource utilization estimates.
* Performed timing analysis and design optimization to meet clock frequency targets.
* **Mini Project:**
  * Developed a fully integrated hardware system combining **UART**, and **FSM control logic** on the Artix-7 100T board.
  * Successfully generated bitstreams, ran hardware demos, and completed full design review walkthroughs.

---

## 🎯 Key Skills Acquired

* Writing clean, synthesizable Verilog HDL for real target architectures.
* End-to-end Vivado toolchain usage (RTL $\rightarrow$ Constraints $\rightarrow$ Synthesis $\rightarrow$ Bitstream).
* Real-time hardware debugging using Vivado ILA logic analyzer probes.
* Custom protocol controller development (UART, SPI, I2C).
* System-level timing closure, resource estimation, and physical FPGA deployment.

---
