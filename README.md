# Simulating Vehicle Taillights Behavior
**Fundamentals of Digital Logic Design  - Final Project**

This repository acts as the project portion of the final for Oklahoma State University's Fundamentals of Digital Logic Design course.

## Overview
This project implements a Finite State Machine (FSM) to control the taillights of a simulated Ford Thunderbird vehicle on an FPGA platform. The design demonstrates the interaction between sequential logic (state memory) and combinational logic (output generation) to create realistic, time-dependent automotive lighting behavior.

## Objectives
* Design and implement a Finite State Machine (FSM) to control the
taillights of a Ford Thunderbird.
* Simulate realistic automotive lighting behavior using digital logic on an FPGA platform.
* Demonstrate how sequential logic (memory elements) and combinational logic
work together to produce controlled and time-dependent behavior.
* Brake, hazard, left turn signal, right turn signal, and reset are simulated using LEDs and buttons
* Priority handling is demonstrated as follows: reset -> brake -> hazard -> turn signals
* The FSM controls lighting patterns based on driver inputs and displays the current operating mode on a 7-segment display

## Input/Output Description
### Taillight Layout

Each side of the vehicle contains three LEDs, each of which have their own state in the FSM.
* Left side: L1, L2, L3
* Right side: R1, R2, R3


### Inputs
Inputs below are listed in order of priority (top priority is listed first) and represented as buttons on the FPGA platform.
* reset → Resets system (all lights OFF, returns to IDLE)
* left → Activates left turn signal
* right → Activates right turn signal
* brake → Activates brake lights


### Outputs
* lights[5:0] → controls all six taillights
* 7-segment display → shows current mode

## System Behavior
### Priority Handling
* Brake -> Hazard -> Turn Signals (left/right)

### Reset Mode
* When reset = 1
* All lights OFF
* FSM returns to IDLE state


### Left Turn Signal
* When left = 1:
* L1 → L1 + L2 → L1 + L2 + L3
* Sequence repeats continuously if left remains active


### Right Turn Signal
* When right = 1:
* R1 → R1 + R2 → R1 + R2 + R3
* Sequence repeats continuously while active

### Hazard Mode
* When left = 1 AND right = 1:
* L1 + R1 → L1 + L2 + R1 + R2 → L1 + L2 + L3 + R1 + R2 + R3
* Continuous repeating pattern
* Simulates emergency hazard lights

### Brake Mode
* When brake = 1:
* All lights ON simultaneously
* Overrides all other modes


## Authors
Piper Swain  &  Aidan Guarnera
