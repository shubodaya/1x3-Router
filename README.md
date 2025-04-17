# RTL Design and Implementation of 1x3 Router

This project represents the **RTL Design and Implementation of a 1x3 Router**, which I completed during my time as a **Graduate Trainee** at **Maven Silicon** in **2021**. The design involves creating a basic **Router 1x3** (Single Ingress, 3 Egress Ports) that accepts data packets on a single 8-bit port and routes them to one of three output ports.

The project initially involved creating the RTL design, and later I added a **verification testbench** to ensure the correctness of the implementation. The final design was verified, synthesized, and implemented on an **FPGA** platform.

---

## Router 1x3 Block Diagram:
![Router 1x3 Block Diagram](./router.png?raw=true)

---

## Functionality:

1. **Input Register:**
   - This block is responsible for extracting the header, calculating, and checking the parity of incoming packets.
   
2. **Synchronizer:**
   - The synchronizer decodes the header and determines which output port the data should be sent to. It ensures proper synchronization between the **FSM** and **FIFO** modules, facilitating accurate data communication between the input and output ports.
   
3. **FSM (Finite State Machine):**
   - The FSM is the core controller of the router. It generates the necessary control signals for **FIFO** and **Synchronizer** based on status signals.
   
4. **FIFO (First In First Out):**
   - A synchronous, active-low reset FIFO allows simultaneous read and write operations, providing efficient data storage and transfer between blocks.

---

## Steps Covered During the Project:

1. **Block-level Structure Design:**
   - Designed the block-level structure for the router, identifying key components such as the **Input Register**, **Synchronizer**, **FSM**, and **FIFO**.

2. **RTL Implementation:**
   - Implemented the router's functionality using **Verilog HDL** and verified the design through individual **Verilog testbenches**.

3. **FPGA Implementation:**
   - Synthesized and implemented the design to generate a bit file and tested the router on an FPGA platform.

4. **Verification Environment Development:**
   - Developed a class-based verification environment and verified the **1x3 Router RTL model** in **SystemVerilog** using **UVM** (Universal Verification Methodology).

5. **Coverage Generation:**
   - Generated functional and code coverage reports for the RTL verification sign-off, ensuring all aspects of the design were thoroughly tested and validated.

---

## Technologies Used:

- **Verilog HDL**: For the RTL design and implementation of the router.
- **SystemVerilog**: For creating the verification environment.
- **UVM**: To apply the Universal Verification Methodology for systematic verification.
- **FPGA**: For synthesizing and testing the design.
- **Verilog Testbenches**: Used to verify individual components and ensure correctness.
- **Git**: For version control during project development.

---

## Acknowledgments:

- **Maven Silicon**: For providing the opportunity and support during the internship.
- **FPGA Development Tools**: For synthesizing and testing the design.
- **SystemVerilog & UVM**: For advanced verification methodologies.

