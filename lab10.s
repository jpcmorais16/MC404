.set BASE, 0xFFFF0100

.text
.align 4

int_handler:
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
    bne a7, t0, 1f

        li t1, BASE
        //li a1, 1
        sb a1, 33(t1)

        li t1, BASE
        //li a1, -14
        sb a2, 32(t1)

    1:

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
    la t0, user_main # Loads the user software
    csrw mepc, t0 # entry point into mepc

    mret 
# Escreva aqui o código para mudar para modo de usuário e chamar a função 
# user_main (definida em outro arquivo). Lembre-se de inicializar a 
# pilha do usuário para que seu programa possa utilizá-la.

.globl logica_controle
logica_controle:
    
    li a0, 1
    li a2, -14
    li a7, 10
    ecall

    ret


.bss
    .align 4
    stack: .skip 1024
    stack_base:
    isr_stack: .skip 1024
    isr_stack_base: