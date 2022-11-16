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
    li a1, -14
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

    jal go_left
 
    loop_coordenadas:
        jal get_positioning
        li t2, 83
        li t3, -19
        bge a3, t2, loop_coordenadas # if a3 < t2 then loop_coordenadas
    
    jal backward
    jal stop
        

    li a7,93
    ecall


