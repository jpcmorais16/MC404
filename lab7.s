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


    lw ra, 12(sp)
    lw fp, 8(sp)
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

        mv t5, a1
        ecall
        #addi a1, a1, 1

        li a0, 0
        addi a1, t5, 1
        li a2, 1
        li a7, 63

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

itoa:
    #a0 -> numero
    #a1 -> string 
    #a2 -> base

    mv t0, a0
    li t1, 0 # iterador 

    loop_itoa:
        





time:
    addi sp, sp, -32

    la a0, 20(sp)
    la a1, 16(sp)
    li a7, 169
    ecall

    la a0, 20(sp)
    lw t1, 0(a0) # tempo em segundos
    lw t2, 8(a0) # fração do tempo em microssegundos
    li t3, 1000
    mul t1, t1, t3
    div t2, t2, t3
    add a0, t2, t1


    addi sp, sp, 32

    ret

sleep:
    #a0 eh o tempo em ms
    mv t1, a0

    addi sp, sp, -16
    sw ra, 12(sp)
    sw fp, 8(sp)

    addi fp, sp, 16

    jal time

    mv t0, a0 # time0


    loop_sleep: #while time - time0 < tempo em ms
        jal time
        sub t2, a0, t0
        bge t1, t2, loop_sleep

    
    lw ra, 12(sp)
    lw fp, 8(sp)
    addi sp, sp, 16

    ret


approx_sqrt:
    #a0 eh a entrada
    #a1 eh o numero de iteracoes

    li t0, 0 #iterador
    mv t1, a0 # k
    li t2, 2

    div t1, t1, t2 

    beq a1, zero, 1f
    loop_sqrt:

        div t3, a0, t1 # y/k
        addi t1, t1, t3 # k + y/k
        div t1, t1, t2      
        
        addi t0, t0, 1
        bge a1, t0, loop_sqrt

    1:

    mv a0, t1

    ret


imageFilter:
    #a0 eh a imagem
    #a1 eh a largura
    #a2 eh a altura
    #a3 eh a matriz 
    mv a6, a0
    mv t6, a3

    mv a0, a1
    mv a1, a2
    li a7, 2201
    ecall   

    li t5, 0

    loop_altura:
        
        li t4, 0

        loop_largura:
            
            #====================================================
            
            li t1, 0
            li t0, 0
            addi t2, a1, -1
            addi t3, a2, -1
            beq t4, t1, borda
            beq t4, t2, borda
            beq t5, t1, borda
            beq t5, t3, borda

            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, -1
            addi a2, t5, -1
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 0(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, 0
            addi a2, t5, -1
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 1(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, 1
            addi a2, t5, -1
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 2(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, -1
            addi a2, t5, 0
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 3(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2

            
            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, 0
            addi a2, t5, 0
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, 8
            lb t1, 4(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, 1
            addi a2, t5, 0
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 5(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, -1
            addi a2, t5, 1
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 6(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, 0
            addi a2, t5, 1
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            #li t1, -1
            lb t1, 7(t6)
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2


            mv a1, t4 #aquimano
            mv a2, t5 #aquidnv
            addi a1, t4, 1
            addi a2, t5, 1
            #jal pegaPixelDaImagemOriginal
            mul t2, a2, a4
            add t2, t2, a1
            add a0, t2, a6

            li t1, -1
            lbu t2, 0(a0)
            mul t2, t2, t1
            add t0, t0, t2

        

            li t1, 256
            bge t0, t1, branco
            blt t0, zero, preto
            j normal

            branco:
                li t0, 255
                j normal

            preto:
                li t0, 0

            normal:

            mv a0, t4 # x atual da imagem
            mv a1, t5 # y atual da imagem

            li a2, 0
            li a3, 256

            add a2, a2, t0
            mul a2, a2, a3

            add a2, a2, t0
            mul a2, a2, a3

            add a2, a2, t0
            mul a2, a2, a3

            addi a2, a2, 255

            #jal setPixel
            li a7, 2200 # syscall setGSPixel (2200)
            ecall

            #====================================================
            addi t4, t4, 1
            blt t4, a1, loop_largura # loop de largura 
            j fim
            
            borda:
                mv a0, t4
                mv a1, t5

                li a2, 255
                #jal setPixel
                li a7, 2200 # syscall setGSPixel (2200)
                ecall

                addi t4, t4, 1
                blt t4, a1, loop_largura # loop de largura 

        fim:
        addi t5, t5, 1
        blt t5, a2, loop_altura # loop de altura

        ret

    

exit:
    #li a0, 0
    li a7, 93
    ecall