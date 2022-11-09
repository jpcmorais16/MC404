# string: .skip 0x10
# .globl _start
# _start:
#     li a0, 1234
#     la a1, string
#     li a2, 10
#     jal itoa
#     jal puts
#     jal exit


.globl puts
puts:
    mv t1, a0
    li t2, 0
    li t3, 0 # iterador

    loop_puts:
        lb t4, 0(t1)
        addi t1, t1, 1
        addi t3, t3, 1
        bne t4, t2, loop_puts 

    addi t3, t3, -1

    
    mv a1, a0
    li a0, 1   
    mv a2, t3
    li a7, 64
    ecall


    addi sp, sp, -16
    sw ra, 12(sp)
    sw fp, 8(sp)
    addi fp, sp, 16


    li t4, '\n'
    sb t4, 4(sp)
    
    li a0, 1
    addi a1, sp, 4
    li a2, 1
    li a7, 64
    ecall

    lw ra, 12(sp)
    lw fp, 8(sp)
    addi sp, sp, 16

    li a0, 1

    ret


.globl gets
gets:
    mv t0, a0 # endereco da entrada em t0

    li t1, 10 # \n

    addi a1, t0, -1

    mv t5, a1
    loop_gets:

        li a0, 0
        addi a1, t5, 1
        li a2, 1
        li a7, 63

        mv t5, a1
        
        ecall
        #addi a1, a1, 1
        
        lb t4, 0(a1)       
        bne t4, t1, loop_gets

    li t1, 0 # \0 no final
    sb t1, 0(a1)

    mv a0, t0
    
    ret

.globl atoi
atoi:
    #a0 -> string para converter

    addi t0, a0, -1
    li t1, 45 # -
    li t5, 48
    li t6, 57
    li t3, 1 #t3 eh o sinal

    loop_atoi1: # procura numero ou '-': entre 48 e 57, ou 45
        addi t0, t0, 1
        lb t2, 0(t0)
        

        beq t2, t5, negativo
        bge t2, t5, and_atoi

        j loop_atoi1

        and_atoi:
            blt t2, t6, fim_loop_atoi1
            j loop_atoi1

        negativo:
            li t3, -1
            addi t0, t0, 1

    fim_loop_atoi1:    

    li a0, 0 # resultado
    li t1, 0 # iterador
    li t2, 10
    #t0 tem o endereco
   
    loop_atoi2:
        lb t4, 0(t0)
        beq t4, zero, fim_loop_atoi2 # quebra se vier \0

        addi t4, t4, -48
        mul a0, a0, t2
        add a0, a0, t4

        addi t0, t0, 1
        
        j loop_atoi2

    fim_loop_atoi2:

    mul a0, a0, t3

    ret

.globl itoa
#char * base10( int value, char * str):
base10: 

        mv a7, a1
        bge a0, zero, positivo10

        li t1 , '-'
        sb t1, 0(a1)
        addi a1, a1, 1
        li t1, -1
        mul a0, a0, t1
            
        positivo10:

        li t0, 10
        li t1, 0 
        mv a4, a0

        loop_itoa10_1:
            div a4, a4, t0
            addi t1, t1, 1
            bne a4, zero, loop_itoa10_1  
        
        add t3, t1, a1
        sb zero, 0(t3)

        mv a4, a0
        li t0, 10
        addi t3, t3, -1

        loop_itoa10_2:
            rem t1,a4,t0
            div a4,a4,t0
            addi t1,t1,'0'
            sb t1, 0(t3)
            addi t3, t3, -1
            blt zero, a4, loop_itoa10_2

        mv a0, a7
        ret

#char * base16( int value, char * str):
base16: 

        blt a0, zero, negativo16
        j positivo16
        
        negativo16:
        li t0, -1
        mul a0, a0, t0

        positivo16:

        li t0, 10
        li t1, 0 
        mv a4, a0

        loop_itoa16_1:
        
            div a4, a4, t0
            addi t1, t1, 1
            bne a4, zero, loop_itoa16_1  
        
        add t3, t1, a1
        sb zero, 0(t3)
        addi t3,t3,-1

        mv a4, a0
        li t0, 16
        li t1, 10
        li t4, 0

        loop_itoa16_2:
            rem t2, a4, t0
            div a4, a4, t0
            blt t2, t1, menorque10

            addi t2, t2, 7

            menorque10:
            addi t2, t2, '0'
            sb t2, 0(t3)
            addi t4, t4, 1
            addi t3, t3, -1
            blt zero, a4, loop_itoa16_2
            addi t3, t3, 1

        mv a0, t3

        ret


.globl itoa
itoa:
   
    addi sp, sp, -16
    sw ra, 0(sp)

    li t1, 16
    beq a2, t1, b16

        mv a7, a1
        bge a0, zero, positivo10

        li t1 , '-'
        sb t1, 0(a1)
        addi a1, a1, 1
        li t1, -1
        mul a0, a0, t1
            
        positivo10:

        li t0, 10
        li t1, 0 
        mv a4, a0

        loop_itoa10_1:
            div a4, a4, t0
            addi t1, t1, 1
            bne a4, zero, loop_itoa10_1  
        
        add t3, t1, a1
        sb zero, 0(t3)

        mv a4, a0
        li t0, 10
        addi t3, t3, -1

        loop_itoa10_2:
            rem t1,a4,t0
            div a4,a4,t0
            addi t1,t1,'0'
            sb t1, 0(t3)
            addi t3, t3, -1
            blt zero, a4, loop_itoa10_2

        mv a0, a7
        j fim_itoa
        
    b16: 
        blt a0, zero, negativo16
        j positivo16
        
        negativo16:
        li t0, -1
        mul a0, a0, t0

        positivo16:

        li t0, 10
        li t1, 0 
        mv a4, a0

        loop_itoa16_1:
        
            div a4, a4, t0
            addi t1, t1, 1
            bne a4, zero, loop_itoa16_1  
        
        add t3, t1, a1
        sb zero, 0(t3)
        addi t3,t3,-1

        mv a4, a0
        li t0, 16
        li t1, 10
        li t4, 0

        loop_itoa16_2:
            rem t2, a4, t0
            div a4, a4, t0
            blt t2, t1, menorque10

            addi t2, t2, 7

            menorque10:
            addi t2, t2, '0'
            sb t2, 0(t3)
            addi t4, t4, 1
            addi t3, t3, -1
            blt zero, a4, loop_itoa16_2
            addi t3, t3, 1

        mv a0, t3


    fim_itoa:
        lw ra,0(sp)
        addi sp, sp, 16
    ret   
        
.globl time
time:
    addi sp, sp, -32

    addi a0, sp, 20
    addi a1, sp, 16
    li a7, 169
    ecall

    addi a0, sp, 20
    lw t1, 0(a0) # tempo em segundos
    lw t2, 8(a0) # fração do tempo em microssegundos
    li t3, 1000
    mul t1, t1, t3
    div t2, t2, t3
    add a0, t2, t1


    addi sp, sp, 32

    ret

.globl sleep
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

.globl approx_sqrt
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
        add t1, t1, t3 # k + y/k
        div t1, t1, t2      
        
        addi t0, t0, 1
        bge a1, t0, loop_sqrt

    1:

    mv a0, t1

    ret

.globl imageFilter
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

    
.globl exit
exit:
    #li a0, 0
    li a7, 93
    ecall
    
