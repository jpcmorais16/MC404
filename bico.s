.globl set_motor
set_motor:
  #a0 vertical
  #a1 horizontal

  li a7, 10
  ecall
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

.globl filter_1d_image
filter_1d_image:
  #a0 -> img
  #a1 -> filter (vetor de 3 posic)

  mv t0, a0 # percorre a imagem
  li t1, 254 # tamanho imagem

  sb zero, 0(t0)
  addi t0, t0, 1

  loop_filter:
    lbu t6, 0(t0) # resultado final
    lbu t2, 1(a1)
    mul t6, t6, t2  

    lbu t3, -1(t0)
    lbu t2, 0(a1)
    add t6, t6, t2

    lbu t3, 1(t0)
    lbu t2, 2(a1)
    add t6, t6, t2
    
    sb t6, 0(t0)

    add t0, t0, 1
    add t1, t1, -1
    bne t1, zero, loop_filter

    sb zero, 0(t0)

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
    mv s1, a0 # move pelo buffer
	li s2, 0 # condicao de parada

	loop_puts:
		lb s3, 0(s1)
		beq s3, s2, fim_loop_puts

		mv a1, s1
		li a2, 1
		li a7, 18
		ecall
		
		addi s1, s1, 1
		j loop_puts

	fim_loop_puts:

	addi sp, sp, -16

	li s3, '\n'
	sb s3, 12(sp)

	addi a1, sp, 12
	li a2, 1
	li a7, 18
	ecall

	addi sp, sp, 16

	li a0, 1

	ret

.globl gets
gets:
    mv s1, a0 # move pelo buffer
	li s2, 0 # iterador
	li s3, '\n' # parada 1
	li s4, 26 # parada 2

	loop_gets:
		lb s5, 0(s1)
		beq s5, s3, fim_loop_gets
		beq s5, s4, fim_loop_gets

		mv a1, s1
		li a2, 1
		li a7, 17
		ecall

		addi s1, s1, 1
		addi s2, s2, 1
		j loop_gets
		
	fim_loop_gets:
	
	sb zero, 0(s1)

	mv a0, s2
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

base10: 

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


base16: 
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
      jal ra , base10
      j 3f
      
  2: 
      jal ra, base16
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