.globl _start

_start:

    jal open
    jal read

    la a6, input_adress #bytes 3 e 5 sao largura e altura
    jal getDimensions
    #li a4, 0 #largura
    #li a5, 0 #altura
    li t3, 24
    li t5, 7
    #lw t3, 3(input_adress)
    #lw t5, 5(input_adress)

    #a0: largura do canvas (valor entre 0 e 512)
    #a1: altura do canvas (valor entre 0 e 512)
    #a7: 2201 (número da syscall)

    li a0, 24
    li a1, 7
    li a7, 2201
    ecall   

loop_altura:

    loop_largura:
        addi a6, a6, 1

        mv a0, a4 # x atual da imagem
        mv a1, a5 # y atual da imagem

        # a2
        #===================
        li a2, 0

        lb t4, 0(a6)
        sll t4, t4, 24
        or a2, a2, t4

        lb t4, 0(a6)
        sll t4, t4, 16
        or a2, a2, t4

        lb t4, 0(a6)
        sll t4, t4, 8
        or a2, a2, t4

        li t4, 255
        or a2, a2, t4

        #===================

        jal setPixel

        addi a4, a4, 1
        bne a4, t5, loop_largura # loop de largura 


    addi a5, a5, 1
    bne a5, t3, loop_altura # loop de altura

    

open:
    la a0, input_file    # endereço do caminho para o arquivo
    li a1, 0             # flags (0: rdonly, 1: wronly, 2: rdwr)
    li a2, 0             # modo
    li a7, 1024          # syscall open 
    ecall
    ret

read:
    la a1, input_adress #  buffer
    li a2, 1 # size (lendo apenas 1 byte, mas tamanho é variável)
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
    li t6, 1 # UM
    li t0, 2 # DOIS
    
    li a4, 0
    li a5, 0

    addi a6, a6, 3

    1:
        lbu t6, 0(a6)

        beq t3, t4, 5f #ACABA O LOOP

        beq t1, t6, 4f # PULAM CASO SEJA \N OU ESPACO
        beq t2, t6, 4f #

        beq t3, t6, 2f # PULA PARA SOMAR NA LARGURA
        beq t3, t0, 3f # PULA PARA SOMAR NA LARGURA


        addi t6, t6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
        j 1b # REINICIA O LOOP
    
        2: #pegar a largura

            mul a4, t6, t5 # MULTIPLICA POR 10
            addi a4, t6, -'0' # CONVERTE O BYTE DE ASCII PARA O NUMERO

            addi t6, t6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
            j 1b # REINICIA O LOOP
            
        3: #pegar a altura

            mul a5, t6, t5 # MULTIPLICA POR 10
            addi a5, t6, -'0' # CONVERTE O BYTE DE ASCII PARA O NUMERO

            addi t6, t6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
            j 1b # REINICIA O LOOP


        4: #if o caracter eh espaco ou \n

            addi t3, t3, 1

            addi t6, t6, 1 # SOMA 1 NO ENDERECO DA IMAGEM
            j 1b # REINICIA O LOOP

        5: #if o contador chegou a 3
        
    addi a6, a6, 1

    ret
    

    
input_file: .asciz "imagem.pgm"
input_adress: .skip 0x10  # buffer