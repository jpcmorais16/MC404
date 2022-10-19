.globl _start




_start:

    jal open
    jal read

    la t0, input_adress #bytes 3 e 5 sao largura e altura
    li t1, 0 #largura
    li t2, 0 #altura
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

1:

2:
    mul t6, t1, t2 # altura e largura
    addi t6, t6, 8 # soma 8 
    add t6, t6, t0 # soma o endereco de inicio do arquivo

    mv a0, t1 # x atual da imagem
    mv a1, t2 # y atual da imagem

    # a2
    #===================
    li a2, 0

    lb t4, 0(t6)
    sll t4, t4, 24
    or a2, a2, t4

    lb t4, 0(t6)
    sll t4, t4, 16
    or a2, a2, t4

    lb t4, 0(t6)
    sll t4, t4, 8
    or a2, a2, t4

    li t4, 255
    or a2, a2, t4

    #===================

    jal setPixel

    addi t1, t1, 1
    bne t1, t3, 2b # loop de largura 

2:
    addi t2, t2, 1
    bne t2, t5, 1b # loop de altura

1:
    

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


    

    
input_file: .asciz "imagem.pgm"
input_adress: .skip 0x10  # buffer