.set BASE, 0xFFFF0100

.text
.align 4


int_handler:
    #a0 vertical
    #a1 horizontal
      ###### Tratador de interrupções e syscalls ######
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
    beq a7, t0, 10f

    li t0, 11
    beq a7, t0, 11f

    li t0, 12
    beq a7, t0, 12f

    li t0, 13
    beq a7, t0, 13f

    li t0, 15
    beq a7, t0, 15f

    li t0, 16
    beq a7, t0, 16f

    10:
        li t1, BASE

        sb a1, 33(t1)

        sb a2, 32(t1)
        j fim

    11:
        li t1, BASE
        sb a0, 34(t1)
        j fim

    12:
        li t1, BASE
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

    13:
        li t1, BASE

        li t2, 1
        sb t2, 2(t1)

        loop_13:
            lb t3, 2(t1)
            beq t3, zero, loop_13

        lb a0, 0x1c(t1)
        j fim

    15:
        li t1, BASE

        li t2, 1
        sb t2, 0(t1)

        loop_15:
            lb t3, 0(t1)
            beq t3, zero , loop_15


        addi t4, t1, 0x10
        lb a0, 0(t4)

        addi t5, t1, 0x14
        lb a1, 0(t5)

        addi t6, t1, 0x18
        lb a2, 0(t6)

        j fim
    
    16:
        li t1, BASE

        li t2, 1
        sb t2, 0(t1)

        loop_16:
            lb t3, 0(t1)
            beq t3, zero , loop_16


        addi t4, t1, 0x4
        lb a0, 0(t4)

        addi t5, t1, 0x8
        lb a1, 0(t5)

        addi t6, t1, 0xC
        lb a2, 0(t6)
        j fim

    17:
    

    fim:

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
    lw x10, 40(sp) 
    lw x11, 44(sp) 
    lw x12, 48(sp) 
    lw x13, 52(sp) 
    lw x14, 56(sp) 
    lw x15, 60(sp) 
    lw x16, 64(sp)
    lw x17, 68(sp) 
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

    la t0, isr_stack_base
    csrw mscratch, t0

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