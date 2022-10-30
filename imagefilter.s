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