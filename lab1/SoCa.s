.set gpt, 0xFFFF0100
.set carro, 0xFFFF0300
.set serial, 0xFFFF0500
.set canvas, 0xFFFF0700

motor: # MOTOR
    li t1, carro

    li t2, 2
    bge a0, t2, error

    li t2, -2
    bge t2, a0, error

    li t2, 128
    bge a1, t2, error

    li t2, -128
    bge t2, a1, error

    sb a0, 0x21(t1)

    sb a1, 0x20(t1)
    
    li a0, 0

    j success

    error:
        li a0, -1

    success:

    j fim

handbreak: # HANDBREAK
    li t1, carro
    sb a0, 34(t1)
    j fim

sensors: # SENSORS
    li t1, carro
    li t2, 1
    sb t2, 1(t1)

    loop_12_1:
        lb t4, 1(t1)
        bne t4, zero, loop_12_1

    mv t0, a0 //endereco do vetor

    addi t2, t1, 36 //endereco dos pixels

    li t3, 256 //iterador

    loop_12_2:
        lb t4, 0(t2)
        sb t4, 0(t0) 

        addi t0, t0, 1
        addi t2, t2, 1
        addi t3, t3, -1
        bne t3, zero, loop_12_2

    j fim

sensors_distance: # SENSOR DISTANCE
    li t1, carro

    li t2, 1
    sb t2, 2(t1)

    loop_13:
        lb t3, 2(t1)
        bne t3, zero, loop_13

    lw a0, 0x1c(t1)
    j fim

position: # POSITION
    li t1, carro

    li t2, 1
    sb t2, 0(t1)

    loop_15:
        lb t3, 0(t1)
        bne t3, zero , loop_15


    addi t4, t1, 0x10
    lw t0, 0(t4)
    sw t0, 0(a0)

    addi t5, t1, 0x14
    lw t0, 0(t5)
    sw t0, 0(a1)

    addi t6, t1, 0x18
    lw t0, 0(t6)
    sw t0, 0(a2)

    j fim

rotation: # ROTATION
    li t1, carro

    li t2, 1
    sb t2, 0(t1)

    loop_16:
        lb t3, 0(t1)
        bne t3, zero , loop_16


    addi t4, t1, 0x4
    lw t0, 0(t4)
    sw t0, 0(a0)

    addi t5, t1, 0x8
    lw t0, 0(t5)
    sw t0, 0(a1)

    addi t6, t1, 0xC
    lw t0, 0(t6)
    sw t0, 0(a2)

    j fim

read:
    li t1, serial

    li t2, 1
    mv t3, a2 # iterador
    mv t4, a1 # move pelo buffer

    loop_fora_read:

        sb t2, 2(t1)

            loop_dentro_read:
                lb t5, 2(t1)
                bne t5, zero, loop_dentro_read


        lb t6, 3(t1)
        sb t6, 0(t4)
        addi t4, t4, 1

        addi t3, t3, -1
        bne t3, zero, loop_fora_read

    mv a0, a2
    j fim

write:
    li t1, serial

    li t2, 1
    mv t3, a2 # iterador
    mv t4, a1 # move pelo buffer

    loop_fora_write:
 
        lb t5, 0(t4)
        sb t5, 1(t1)
        sb t2, 0(t1)
    
            loop_dentro_write:
                lb t6, 0(t1)
                bne t6, zero, loop_dentro_write


        addi t4, t4, 1
        addi t3, t3, -1
        bne t3, zero, loop_fora_write

    j fim

draw_line:
    #fica pra depois
    #a0 array de bytes
    li t1, canvas

    mv t2, a0 # percorre o array

    li t3, 504
    lh t3, 2(canvas)

    sw t2, 8(canvas)
    j fim

get_time:
    li t1, gpt
    
    li t2, 1
    
    sb t2, 0(t1)

    loop_time:
        lb t3, 0(t1)
        bne t3, zero, loop_time

    lw a0, 8(t1)
    j fim


int_handler:
    
    csrrw sp, mscratch, sp 
    addi sp, sp, -64

    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    sw s3, 24(sp)

    li t0, 10
    beq a7, t0, motor

    li t0, 11
    beq a7, t0, handbreak

    li t0, 12
    beq a7, t0, sensors

    li t0, 13
    beq a7, t0, sensors_distance

    li t0, 15
    beq a7, t0, position

    li t0, 16
    beq a7, t0, rotation  

    li t0, 17
    beq a7, t0, read

    li t0, 18
    beq a7, t0, write

    li t0, 19
    beq a7, t0, draw_line

    fim:

    lw s0, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    lw s3, 24(sp)

    addi sp, sp, 64
    csrrw sp, mscratch, sp 
  
  csrr t0, mepc  # carrega endereço de retorno (endereço 
                 # da instrução que invocou a syscall)
  addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
  csrw mepc, t0  # armazena endereço de retorno de volta no mepc
  mret           # Recuperar o restante do contexto (pc <- mepc)

.globl _start
_start:

  la t0, int_handler  # Carregar o endereço da rotina que tratará as interrupções
  csrw mtvec, t0      # (e syscalls) em no registrador MTVEC para configurar
                      # o vetor de interrupções.
    la sp, stack_base
    #li sp, 0x07FFFFFC

    la t0, isr_stack_base
    csrw mscratch, t0

    # Habilita Interrupções Global
    csrr t1, mstatus # Seta o bit 3 (MIE)
    ori t1, t1, 0x8 # do registrador mstatus
    csrw mstatus, t1


    csrr t1, mie # Seta o bit 11 (MEIE)
    li t2, 0x800 # do registrador mie
    or t1, t1, t2
    csrw mie, t1

    csrr t1, mstatus # Update the mstatus.MPP
    li t2, ~0x1800 # field (bits 11 and 12)
    and t1, t1, t2 # with value 00 (U-mode)
    csrw mstatus, t1
    la t0, main # Loads the user software
    csrw mepc, t0 # entry point into mepc

    mret

.bss
    .align 4
    stack: .skip 1024
    stack_base:
    isr_stack: .skip 1024
    isr_stack_base: