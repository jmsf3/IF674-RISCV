# Simulation Results

## AUIPC

We conducted a simulation using the instructions provided in the file [instruction.mif](instruction.mif) and the testbench [Testbench](/verif/testbench.sv) to evaluate the pipeline's functionality.

The obtained result matches the expected outcome, which can be verified below.

### Instructions Tested

The simulation included testing the following instructions:

```assembly
addi x1,x0,8
sub x6,x6,x1
and x7,x6,x1
auipc x6,3
```

### Registers after each instruction

The following information is extracted from the simulation log and can be interpreted as demonstrated in the example below:

```shell
tt: Register [x] written with value: [hhhhhhhh] | [dddddddd]
```

In the above example, `tt` represents the simulation time, `x` represents the register number, `hhhhhhhh` represents the hexadecimal value stored in the register, and `dddddddd` represents the same value in decimal.

---

```shell
55: Register [ 1] written with value: [00000008] | [          8]
65: Register [ 6] written with value: [fffffff8] | [         -8]
75: Register [ 7] written with value: [00000008] | [          8]
85: Register [ 6] written with value: [0000300c] | [      12300]
```