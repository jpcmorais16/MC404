.set baseGPT, 0xFFFF0100 
.set baseSynth, 0xFFFF0300


main_isr:
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

    li t1, 1
    sw t1, 0(baseGPT)

    la t2, _system_time

    loop_GPT0:
        lw t1, 0(baseGPT)
        bne t1, zero, loop_coordenadas
    
    lw t1, 4(baseGPT) # tempo do sistema
    
    sw t1, 0(t2)

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

    mret

.globl _start
_start:
    la t1, main_isr
    csrw mtvec, t1
    la mscratch, isr_stack_base

    la t0, _system_time
    sw zero, 0(t0)

    li t2, 100
    sw t2, 8(baseGPT)

    la sp, stack_base
    jal main



.globl play_note
play_note:
    #a0: ch
    #a1: instrumento
    #a2: nota
    #a3: velocidade
    #a4: duracao
    li t0, baseSynth

    sb a0, 0(t0)
    sh a1, 2(t0)
    sb a2, 4(t0)
    sb a3, 5(t0)
    sh a4, 6(t0)

    ret


_system_time: .skip 0x0
isr_stack_base: .skip 0xFFFF0100
stack_base: .skip 0xFFFF0010
