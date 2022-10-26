puts:
    lb t1, 0(a0)
    li t2, '\0'
    li t3, 0 # iterador
    
    loop_puts:
        addi t1, t1, 1
        addi t3, t3, 1
        lb t4, 0(t1)
        bne t4, t2, loop_puts 

    li t2, '\n'
    sb t2, t1
    
    li a0, 1
    mv a1, t1
    mv a2, t3
    li a7, 64


    addi sp, sp, -16
    sw ra, 12(sp)
    sw fp, 8(sp)
    addi fp, sp, 16


    li t4, '\n'
    sb t4, 4(sp)
    
    li a0, 1
    mv a1, t4
    li a2, 1


    lw ra, 8(sp)
    lw fp, 12(sp)
    addi sp, sp, 16


    ret



gets:
    mv t0, a0 # endereco da entrada em t0

    li a0, 0

    li t1, '\n'
    li t2, 26

    li a0, 0
    li a1, t0
    li a2, 1
    li a7, 63
    
    loop_gets:

        ecall
        addi a1, a1, 1

        lb t4, 0(a1)
        bne t4, t1, loop_gets
        bne t4, t2, loop_gets

    li t1, '\0'
    sb t1, 0(a1)

    mv a0, t0
    
    ret


atoi:
    mv t0, a0
    
    li t1, '\0'
    li t2, 0
    li t5, 10

    loop_atoi:

        mul t2, t2, t5

        lb t3, 0(a0)
        addi t3, t3, -'0'
        add t2, t2, t3 
       
        addi t0, t0, 1

        lb t4, 0(t0)
        bne t4, t1, loop_atoi 

    mv a0, t2
    ret

