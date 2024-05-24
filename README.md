# cs202_MiniRiscVCPU

## The Structure Diagram

![struct](struct.jpg)

## Settings of IPcore

### Instruction Memory
Component Name: prgrom
#### **Basic**
* Memory type: Single Port ROM

#### **Port A Options**

* Port A Width: 32
* Port A Depth: 16384
* Enable Port Type: Always Enabled
* Primitives Output Register:<font color = red> No</font>
#### **Other Options**
* Load Init File: Load your instruction coe file.

### Data Memory
Component Name: prgrom
#### **Basic**
* Memory type: Single Port RAM
#### **Port A Options**
* Write Width: 32
* Read Width: 32
* Write Depth: 16384
* Read Depth: 16384
* Enable Port Type: Always Enabled
* Primitives Output Register:<font color = red> No</font>
#### **Other Options**
* Load Init File: No