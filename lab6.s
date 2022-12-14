.globl _start

_start:

    jal open
    jal read

    la a6, input_adress #bytes 3 e 5 sao largura e altura
    jal getDimensions
    #li a4, 0 #largura
    #li a5, 0 #altura
    #lw t3, 3(input_adress)
    #lw t5, 5(input_adress)

    #a0: largura do canvas (valor entre 0 e 512)
    #a1: altura do canvas (valor entre 0 e 512)
    #a7: 2201 (número da syscall)

    #li a0, 24
    #li a1, 7
    mv a0, a4
    mv a1, a5
    li a7, 2201
    ecall   

    li t5, 0

loop_altura:

    li t4, 0

    loop_largura:
        

        mv a0, t4 # x atual da imagem
        mv a1, t5 # y atual da imagem

        # a2
        #===================
        li a2, 0
        li t3, 256

        # lb t6, 0(a6)
        # sll t6, t6, 24
        # or a2, a2, t6

        # lb t6, 0(a6)
        # sll t6, t6, 16
        # or a2, a2, t6

        # lb t6, 0(a6)
        # sll t6, t6, 8
        # or a2, a2, t6

        # li t6, 255
        # or a2, a2, t6

        lbu t6, 0(a6)
        mul a2, a2, t3
        add a2, a2, t6

        lbu t6, 0(a6)
        mul a2, a2, t3
        add a2, a2, t6

        lbu t6, 0(a6)
        mul a2, a2, t3
        add a2, a2, t6

        mul a2, a2, t3
        add a2, a2, 255

        #===================

        jal setPixel

        addi a6, a6, 1
        addi t4, t4, 1
        blt t4, a4, loop_largura # loop de largura 


    addi t5, t5, 1
    blt t5, a5, loop_altura # loop de altura

    li a0, 0
    li a7, 93
    ecall

    

open:
    la a0, input_file    # endereço do caminho para o arquivo
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
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
    #li a2, 0xFFFFFFFF # pixel branco
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
    

    
input_file: .asciz "imagem.pgm"
input_adress: .skip 0x10  # buffer