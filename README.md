# Simulating Vehicle Taillight Behavior
**Fundamentals of Digital Logic Design  - Final Project**

## Overview
This project implements a Finite State Machine (FSM) to control the taillights of a simulated Ford Thunderbird vehicle on an FPGA platform. The design demonstrates the interaction between sequential logic (state memory) and combinational logic (output generation) to create realistic, time-dependent automotive lighting behavior.

## Objectives
* Design and implement a Finite State Machine (FSM) to control the
taillights of a Ford Thunderbird.
* Simulate realistic automotive lighting behavior using digital logic on an FPGA platform.
* Demonstrate how sequential logic (memory elements) and combinational logic
work together to produce controlled and time-dependent behavior.
* Brake, hazard, left turn signal, right turn signal, and reset are simulated using LEDs and push buttons.
* Priority handling is demonstrated as follows: reset → brake → hazard → turn signals.
* The FSM controls lighting patterns based on driver inputs and displays the current operating mode on a 7-segment display.

## Input/Output Description

### Inputs
Inputs below are listed in order of priority (top priority is listed first) and represented as push buttons on the FPGA platform.
* reset → Resets system (all lights OFF, returns to IDLE)
* left → Activates left turn signal
* right → Activates right turn signal
* brake → Activates brake lights


### Outputs
* lights[5:0] → controls all six taillights
* 7-segment display → shows current mode


### Taillight Layout

Each side of the vehicle contains three LEDs, each of which have their own state in the FSM.
* Left side: L1, L2, L3
* Right side: R1, R2, R3

On the vehicle, the taillights are placed as so:

| L3 | L2 | L1 | R1 | R2 | R3 |

## System Behavior
### Priority Handling
* Reset → Brake → Hazard → Turn Signals (left/right)

### Mode Descriptions
|Mode → |  Reset   |  Left Turn   |   Right Turn    |    Hazard   |   Brake    |
|----------|--------------|-----------------|-------------|------------|------------|
| Occurs when: | reset = 1  | left = 1  | right = 1  | left AND right = 1  | brake = 1  |
| Lighting Behavior: |All lights OFF|L1 → L1 + L2 → L1 + L2 + L3|R1 → R1 + R2 → R1 + R2 + R3|L1 + R1 → L1 + L2 + R1 + R2 → L1 + L2 + L3 + R1 + R2 + R3|All lights ON simultaneously|
| Current Behavior: |FSM is in IDLE state|The above state sequence repeats continuously while left remains active|The above state sequence repeats continuously while right remains active |The above state sequence continues while right and left remain active| FSM is in BRAKE state|

## FSM Design
* Type: Moore FSM
* Outputs depend only on current state, not previous inputs
* Each state represents a different step in the light sequence
* State transitions coincide with the rising edge of the clock

### State Flow Chart
<img src="https://github.com/user-attachments/assets/666b2775-22b1-4d29-b3f3-88f1214ebd81" width="500">


## Clock Divider
The FPGA clock is divided using a clock divider module to slow down state transitions so that:
* Light sequences are visible to the human eye
* Transitions appear smooth and realistic

## 7-Segment Display
Displays current system mode:
| Mode   | Display |
| ------ | ------- |
| Idle   | OFF     |
| Left Turn Signal   | L       |
| Right Turn Signal | r       |
| Hazard (L and R turn signals are activated)| H       |
| Brake  | b       |

## Simulation and Verification
* Simulated in ModelSim
* Verified using a comprehensive testbench
* Waveforms checked for correct state transitions, timing accuracy, output sequencing, and priority enforcement
#### ModelSim Waveform:
<img src="https://github.com/user-attachments/assets/3f709863-cd2e-44fe-a996-c7961222f36e" width="800">

## FPGA Implementation
Implemented on FPGA using:
* Push buttons → inputs (left, right, brake, reset)
* LEDs → taillight outputs
* 7-segment display → mode indicator
All signals are mapped using a constraints file for hardware compatibility.


https://github.com/user-attachments/assets/a71ec2f5-4c70-4fdd-8f75-bb4ae49a63bb


## Authors
Piper Swain  &  Aidan Guarnera
