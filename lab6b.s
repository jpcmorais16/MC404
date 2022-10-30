.globl _start

_start:

    jal open
    jal read

    la a6, input_adress
    jal getDimensions

    mv a0, a4
    mv a1, a5
    li a7, 2201
    ecall   


    li t5, 0

loop_altura:
    
    
    li t4, 0

    loop_largura:
        
        #====================================================
        
        li t1, 0
        li t0, 0
        addi t2, a4, -1
        addi t3, a5, -1
        beq t4, t1, borda
        beq t4, t2, borda
        beq t5, t1, borda
        beq t5, t3, borda

        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, -1
        addi a2, t5, -1
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, 0
        addi a2, t5, -1
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, 1
        addi a2, t5, -1
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, -1
        addi a2, t5, 0
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, 1
        addi a2, t5, 0
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, -1
        addi a2, t5, 1
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, 0
        addi a2, t5, 1
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, 1
        addi a2, t5, 1
        jal pegaPixelDaImagemOriginal

        li t1, -1
        lbu t2, 0(a0)
        mul t2, t2, t1
        add t0, t0, t2


        mv a1, t4 #aquimano
        mv a2, t5 #aquidnv
        addi a1, t4, 0
        addi a2, t5, 0
        jal pegaPixelDaImagemOriginal

        li t1, 8
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

        jal setPixel

        #====================================================
        addi t4, t4, 1
        blt t4, a4, loop_largura # loop de largura 
        j fim
        
        borda:
            mv a0, t4
            mv a1, t5

            li a2, 255
            jal setPixel

            addi t4, t4, 1
            blt t4, a4, loop_largura # loop de largura 

    fim:
    addi t5, t5, 1
    blt t5, a5, loop_altura # loop de altura

    li a0, 0
    li a7, 93
    ecall

    

open:
    la a0, input_file    # endereço do caminho para o arquivo
    li a1, 0            # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # modo
    li a7, 1024          # syscall open 
    ecall
    ret

read:
    la a1, input_adress #  buffer
    li a2, 300000 # size (lendo apenas 1 byte, mas tamanho é variável)
    li a7, 63 # syscall read (63)
    ecall
    ret

setPixel:
    #li a0, 100 # coordenada x = 100
    #li a1, 200 # coordenada y = 200
    #li a2, 0 # pixel branco
    li a7, 2200 # syscall setGSPixel (2200)
    ecall
    ret

getDimensions:
    li t1, '\n'
    li t2, ' '
    li t3, 0 # contador de \n e espaco
    li t4, 3 # maximo de \n e espaco
    li t5, 10 # DEZ
    #li t6, 1 # UM
    li t0, 1 # DOIS
    
    li a4, 0
    li a5, 0

    addi a6, a6, 3

    1:
        lbu t6, 0(a6)

        beq t3, t4, 5f #ACABA O LOOP

        beq t1, t6, somaNoContador # PULAM CASO SEJA \N OU ESPACO
        beq t2, t6, somaNoContador #

        
        beq t3, zero, largura # PULA PARA SOMAR NA LARGURA
        beq t3, t0, altura # PULA PARA SOMAR NA ALTURA


        addi a6, a6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
        j 1b # REINICIA O LOOP
    
        largura: #pegar a largura

            mul a4, a4, t5 # MULTIPLICA POR 10
            addi t6, t6, -'0' # CONVERTE O BYTE DE ASCII PARA O NUMERO
            add a4, a4, t6

            addi a6, a6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
            j 1b # REINICIA O LOOP
            
        altura: #pegar a altura

            mul a5, a5, t5 # MULTIPLICA POR 10
            addi t6, t6, -'0' # CONVERTE O BYTE DE ASCII PARA O NUMERO
            add a5, a5, t6

            addi a6, a6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
            j 1b # REINICIA O LOOP


        somaNoContador: #if o caracter eh espaco ou \n

            addi t3, t3, 1

            addi a6, a6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
            j 1b # REINICIA O LOOP

        5: #if o contador chegou a 3
        

    ret

pegaPixelDaImagemOriginal: # nao pode usar t0, t1, t4, t5
    
    #a1 -> x
    #a2 -> y

    mul t2, a2, a4
    add t2, t2, a1

    add a0, t2, a6
    ret

    
input_file: .asciz "imagem.pgm"
input_adress: .skip 0x10  # buffer