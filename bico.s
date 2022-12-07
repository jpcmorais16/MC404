.globl set_motor
set_motor:
  #a0 vertical
  #a1 horizontal
  addi sp, sp, -16

  sw a0, 12(sp)
  sw a1, 8(sp)
  sw a2, 4(sp)

  li a7, 10
  ecall

  lw a0, 12(sp)
  lw a1, 8(sp)
  lw a2, 4(sp)
  addi sp, sp, 16
  ret

.globl set_handbreak
set_handbreak:

  li a7, 11
  ecall
  ret

.globl read_camera
read_camera:

  li a7, 12
  ecall
  ret

.globl read_sensor_distance
read_sensor_distance:

  li a7, 13
  ecall
  ret

.globl get_position
get_position:

  li a7, 15
  ecall
  ret

.globl get_rotation
get_rotation:

  li a7, 16
  ecall
  ret

# .globl get_time
# get_time:

#   li a7, 20
#   ecall
#   ret

.globl display_img
display_img:

  li a7, 19
  ecall
  ret

.section .data
test_str:
	.asciz "OPA"

.section .text
.align 2

.globl filter_1d_image
filter_1d_image:
	#a0 -> img
	#a1 -> filter (vetor de 3 posic)
	addi sp, sp, -16

	sw ra, 4(sp)
	sw s1, 0(sp)

	addi sp, sp, -256

	mv t0, a0 # percorre a imagem
	li t1, 256 # tamanho imagem

	mv t2, sp
	li t3, 0 #iterador
	loop_salva_pilha:
		lbu t4, 0(t0)
		sb t4, 0(t2) # salva cada byte do vetor original na pilha

		addi t2, t2, 1
		addi t0, t0, 1
		addi t3, t3, 1

		bne t3, t1, loop_salva_pilha
	



	mv t0, a0 # percorre a imagem original
	mv t1, sp # percorre a pilha
	li t2, 0 #iterador
	li t4, 254 #condicao de parada
	li s1, 255

	sb zero, 0(t0) # borda
	sb zero, 255(t0) # borda

	addi t0, t0, 1

	loop_filter:

		li t6, 0 # resultado final
		lbu t5, 0(t1) # valor original da imagem
		lb t3, 1(a1) # valor do filtro
		mul t6, t5, t3

		lbu t5, -1(t1) # valor original da imagem à esquerda
		lb t3, 0(a1) # valor do filtro à esquerda
		mul t5, t5, t3
		add t6, t6, t5 # soma no resultado final

		lbu t5, 1(t1) # valor original da imagem à direita
		lb t3, 2(a1) # valor do filtro à direita
		mul t5, t5, t3
		add t6, t6, t5

		blt t6, zero, menor_0
		bge t6, s1, maior_255

		j normal


		menor_0:
			li t6, 0
			j normal

		maior_255:
			li t6, 255
			j normal

		normal:
			sb t6, 0(t0) # salva o byte no endereco do registrador que percorre

		addi t0, t0, 1
		addi t2, t2, 1
		addi t1, t1, 1

		bne t2, t4, loop_filter

	addi sp, sp, 256
	lw s1, 0(sp)
	lw ra, 4(sp)
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

.globl puts
puts:
    mv t1, a0 # move pelo buffer
	li t2, 0 # condicao de parada

	loop_puts:
		lbu t3, 0(t1)
		beq t3, t2, fim_loop_puts

		mv a1, t1
		li a2, 1
		li a7, 18
		ecall
		
		addi t1, t1, 1
		j loop_puts

	fim_loop_puts:

	addi sp, sp, -16

	li t3, '\n'
	sb t3, 12(sp)

	addi a1, sp, 12
	li a2, 1
	li a7, 18
	ecall

	addi sp, sp, 16

	li a0, 1

	ret

.globl gets
gets:

    mv t3, a0       
    mv a1, a0 
    addi sp, sp, -16
    
    loop_gets:

		sw a1, 0(sp)

        li a0, 0
        li a2, 1 
        li a7, 17    

        ecall
		
        lw a1, 0(sp)
        
        lbu t2, 0(a1)

        li t5, '\n'
        li t6, 0 

        beq t2, t5, fim_loop_gets
        beq t2, t6, fim_loop_gets
        addi a1, a1, 1
        j loop_gets

    fim_loop_gets:

	sb t6, 0(a1)

    addi sp, sp, 16

    mv a0, t3
    

  ret

.globl atoi
atoi:
    #a0 -> string para converter

	# primeiro byte:
	lb t0, 0(a0)
	li t1, 45 # -
	li t2, 48 # 0
	li t3, 57 # 9
	li t4, 1 # flag de negativo
	li t6, 0 # resultado

	beq t0, t1, negativo #testar se eh negativo
	j positivo

	negativo:
		li t4, 0

	positivo:
	
	addi t0, t0, 1
	li t1, 10

	loop_atoi:

		lb t5, 0(t0)
		bge	t5, t2, fim_loop_atoi # ascii menor que 0
		blt t5, t3, fim_loop_atoi # ascii maior que 9

		mul t6, t6, t1 # multiplica por 10

		addi t5, t5, -48
		add t6, t6, t5 # soma no resultado

		j loop_atoi
		
	fim_loop_atoi:

	beq t4, zero, valor_negativo
	j fim_atoi

	valor_negativo:
		li t4, -1
		mul t6, t6, t4

	fim_atoi:

	mv a0, t6
	ret


    # addi t0, a0, -1
    # li t1, 45 # -
    # li t5, 48
    # li t6, 57
    # li t3, 1 #t3 eh o sinal

    # loop_atoi1: # procura numero ou '-': entre 48 e 57, ou 45
    #     addi t0, t0, 1
    #     lb t2, 0(t0)
        

    #     beq t2, t1, negativo
    #     bge t2, t5, and_atoi

    #     j loop_atoi1

    #     and_atoi:
    #         blt t2, t6, fim_loop_atoi1
    #         j loop_atoi1

    #     negativo:
    #         li t3, -1
    #         addi t0, t0, 1

    # fim_loop_atoi1:    

    # li a0, 0 # resultado
    # li t1, 0 # iterador
    # li t2, 10
    # #t0 tem o endereco
   
    # loop_atoi2:
    #     lb t4, 0(t0)
    #     beq t4, zero, fim_loop_atoi2 # quebra se vier \0

    #     addi t4, t4, -48
    #     mul a0, a0, t2
    #     add a0, a0, t4

    #     addi t0, t0, 1
        
    #     j loop_atoi2

    # fim_loop_atoi2:

    # mul a0, a0, t3

    # ret

.globl sleep
sleep:
    #a0 eh o tempo em ms
    mv t1, a0

    addi sp, sp, -16
    sw ra, 12(sp)
    sw fp, 8(sp)

    addi fp, sp, 16

    #jal time
    li a7, 20
    ecall

    mv t0, a0 # time0


    loop_sleep: #while time - time0 < tempo em ms
        #jal time
        li a7, 20
        ecall
        sub t2, a0, t0
        bge t1, t2, loop_sleep

    
    lw ra, 12(sp)
    lw fp, 8(sp)
    addi sp, sp, 16

    ret

decimal: 

      mv a7, a1
      bge a0, zero, 4f
      li t1 , '-'
      sb t1, 0(a1)
      addi a1, a1, 1
      li t1, -1
      mul a0, a0, t1
          
      4:
      li t0, 10
      li t1, 0
      mv a4, a0
          5:
            div a4, a4, t0
            addi t1, t1, 1
            bne a4, zero, 5b  
      
      add t3, t1, a1
      sb zero, 0(t3)

      mv a4, a0
      li t0, 10
      addi t3, t3, -1
      6:
          rem t1,a4,t0
          div a4,a4,t0
          addi t1, t1, '0'
          sb t1, 0(t3)
          addi t3, t3, -1
          blt zero, a4, 6b
      mv a0, a7
      ret


hexa: 
      blt a0, zero, 1f
      j 2f
      1:
          li t0, -1
          mul a0, a0, t0
      2:
      li t0, 10
      li t1, 0
      mv a4, a0
          5:
            div a4, a4, t0
            addi t1, t1, 1
            bne a4, zero, 5b  
      
      add t3, t1, a1
      sb zero, 0(t3)
      addi t3, t3, -1

      mv a4, a0
      li t0, 16
      li t1, 10
      li t4, 0

      6:
          rem t2, a4, t0
          div a4, a4, t0
          bge t2, t1, 7f
          j 8f

          7:
            addi t2, t2, 7  
          8:

          addi t2, t2, '0'
          sb t2, 0(t3)
          addi t4, t4, 1
          addi t3, t3, -1
          blt zero, a4, 6b
          addi t3, t3, 1
      mv a0, t3
      ret


.globl itoa
itoa:
   
  addi sp, sp, -16
  sw ra, 0(sp)

  li t1, 16
  beq a2, t1, 2f

  1: 
      jal ra , decimal
      j 3f
      
  2: 
      jal ra, hexa
      j 3f
  3:
      lw ra, 0(sp)
      addi sp, sp, 16
  ret 

.globl get_time
get_time:

  li a7, 20
  ecall
  ret