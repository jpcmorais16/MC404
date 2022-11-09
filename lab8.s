.set BASE, 0xFFFF0100


get_positioning: 
    li a0, BASE
    li a1, 1
    sb a1, 0(a0)
    
    loop_espera:
        lb a1, 0(a0)
        bne a1, zero, loop_espera

    lw a1, 8(a0)
    lw a2, 12(a0)
    lw a3, 16(a0)
    lw a4, 20(a0)
    lw a5, 24(a0)
    lw a0, 0(a0)

    ret

go_left:
    li a0, BASE
    li a1, 1
    sb a1, 33(a0)

    li a0, BASE
    li a1, -20
    sb a1, 32(a0)

    ret

go_right:
    li a0, BASE
    li a1, 1
    sb a1, 33(a0)

    li a0, BASE
    li a1, 1
    sb a1, 32(a0)


    ret

go_straight:
    li a0, BASE
    li a1, 0
    sb a1, 32(a0)
    
    li a0, BASE
    li a1, 1
    sb a1, 33(a0)

    ret

backward:
    li a0, BASE
    li a1, -1
    sb a1, 33(a0)

    ret

stop:
    li a0, BASE
    li a1, 0
    sb a1, 33(a0)

    ret

.globl _start
_start:

    li t0, -95
    li t1, 92
    div t6, t0, t1
    addi t6, t6, -1

    jal go_left
    jal get_positioning



    loop_direcao:
        #jal stop
        mv t0, a3 # ultimo x
        mv t1, a5 # ultimo z
        jal get_positioning
        
        li t2, -1
        mul t3, t0, t2
        mul t4, t1, t2

        add t3, a3, t3 # delta x1
        add t4, a5, t4 # delta z1
        div t5, t4, t3 # coef angular 1

        

        #jal go_left
        blt t6, t5, loop_direcao

        


        
    jal go_left

    jal go_straight
    loop_coordenadas:
        jal get_positioning
        li t2, 73
        li t3, -19
        bge a5, t3, loop_coordenadas # if a3 < t2 then loop_coordenadas
    
        

    li a7,93
    ecall


