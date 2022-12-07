.set gpt, 0xFFFF0100
.set carro, 0xFFFF0300
.set serial, 0xFFFF0500
.set canvas, 0xFFFF0700

.text
.align 4

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
        li a0, 0
        mv t5, a1
        li t2, 0

        loop_fora_read:
           
            li t0, 1
            li t1, serial
            sb t0, 0x2(t1)
 
            loop_dentro_read:
                lb t0, 0x2(t1)
                bne t0, zero, loop_dentro_read

            lb t0, 0x3(t1)
            sb t0, 0(t5) 

            addi t5, t5, 1
            addi t2, t2, 1
            
            beq t2, a2, fim_loop_read
            j loop_fora_read

        fim_loop_read:
            mv a0, t2

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
    lh t3, 2(t1)

    sw t2, 8(t1)
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
    addi sp, sp, -128

    sw x0, 0(sp) 
    sw x1, 4(sp)
    sw x2, 8(sp) 
    sw x3, 12(sp) 
    sw x4, 16(sp) 
    sw x5, 20(sp) 
    sw x6, 24(sp) 
    sw x7, 28(sp) 
    sw x8, 32(sp) 
    sw x9, 36(sp) 
    sw x10, 40(sp) 
    sw x11, 44(sp) 
    sw x12, 48(sp) 
    sw x13, 52(sp) 
    sw x14, 56(sp) 
    sw x15, 60(sp) 
    sw x16, 64(sp)
    sw x17, 68(sp) 
    sw x18, 72(sp)
    sw x19, 76(sp) 
    sw x20, 80(sp) 
    sw x21, 84(sp) 
    sw x22, 88(sp) 
    sw x23, 92(sp) 
    sw x24, 96(sp) 
    sw x25, 100(sp) 
    sw x26, 104(sp) 
    sw x27, 108(sp) 
    sw x28, 112(sp) 
    sw x29, 116(sp) 
    sw x30, 120(sp) 
    sw x31, 124(sp)

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

    li t0, 20
    beq a7, t0, get_time

    fim:

      csrr t0, mepc  # carrega endereço de retorno (endereço 
                 # da instrução que invocou a syscall)
  addi t0, t0, 4 # soma 4 no endereço de retorno (para retornar após a ecall) 
  csrw mepc, t0  # armazena endereço de retorno de volta no mepc

    lw x0, 0(sp) 
    lw x1, 4(sp)
    lw x2, 8(sp) 
    lw x3, 12(sp) 
    lw x4, 16(sp) 
    lw x5, 20(sp) 
    lw x6, 24(sp) 
    lw x7, 28(sp) 
    lw x8, 32(sp) 
    lw x9, 36(sp) 
    # lw x10, 40(sp) 
    # lw x11, 44(sp) 
    # lw x12, 48(sp) 
    # lw x13, 52(sp) 
    # lw x14, 56(sp) 
    # lw x15, 60(sp) 
    # lw x16, 64(sp)
    # lw x17, 68(sp) 
    lw x18, 72(sp)
    lw x19, 76(sp) 
    lw x20, 80(sp) 
    lw x21, 84(sp) 
    lw x22, 88(sp) 
    lw x23, 92(sp) 
    lw x24, 96(sp) 
    lw x25, 100(sp) 
    lw x26, 104(sp) 
    lw x27, 108(sp) 
    lw x28, 112(sp) 
    lw x29, 116(sp) 
    lw x30, 120(sp) 
    lw x31, 124(sp)

    addi sp, sp, 128
    csrrw sp, mscratch, sp 
  

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