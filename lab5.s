.global _start

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall
    


_start:
    li a0, 0 # file descriptor = 0 (stdin)
    la a1, input_adress #  buffer
    li a2, 1 # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63 # syscall read (63)
    ecall




    li t1, 65
    li t2, 10
    #t5 eh o k
    
    srl t5, t1, 1
1:
    
    div t3, t1, t5
    add t4, zero, t5
    add t5, t3, t4
    srl t5, t5, 1


    addi t2, t2, -1
    beq t2, zero, 1f


    jal zero, 1b

1:

    li a0, 1            # file descriptor = 1 (stdout)
    la a1, string       # buffer
    li a2, 19           # size
    li a7, 64           # syscall write (64)
    ecall

    li a0, 13
    li a7, 93
    ecall

string:  .asciz "Hello! It works!!!\n"
input_adress: .skip 0x10  # buffer