.macro escrever_frequencias(%reg)
result:
    # Abrir arquivo de saída
    li a7, 1024
    la a0, output
    li a1, 1                 
    ecall
    mv s2, a0                # Descritor do arquivo

    # Escrever frequências
    li t1, 0                 # Pixel atual
    li t2, 256               # Limite

print_freq:
    beq t1, t2, fim_macro

    # Salvar t1 e t2 na pilha
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)
    write_string(pixel, s2, 6)
    # Escrever pixel
    mv a0, t1
    la a1, buffer
    jal int_to_str           # a0 = comprimento da string
    mv a2, a0                # Comprimento em a2
    mv a0, s2                # Descritor do arquivo
    la a1, buffer
    li a7, 64                # Syscall write
    ecall
    write_string(frequencia, s2, 14)
    # Escrever frequência
    slli t3, t1, 2
    add t4, %reg, t3
    lw a0, 0(t4)
    la a1, buffer
    jal int_to_str           # a0 = comprimento da string
    mv a2, a0                # Comprimento em a2
    mv a0, s2                # Descritor do arquivo
    la a1, buffer
    li a7, 64                # Syscall write
    ecall

    # Nova linha
    la a1, newline
    li a2, 1
    li a7, 64
    mv a0, s2
    ecall

    # Restaurar t1 e t2 da pilha
    lw t1, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8

    addi t1, t1, 1
    j print_freq


int_to_str:
    li t0, 10
    mv t5, a1                # Usa o buffer passado em a1
    li t3, 0
    beqz a0, zero_case

loop_conversao:
    beqz a0, inverter
    rem t4, a0, t0
    div a0, a0, t0
    addi t4, t4, 48
    sb t4, 0(t5)
    addi t5, t5, 1
    addi t3, t3, 1
    j loop_conversao

zero_case:
    li t4, '0'
    sb t4, 0(a1)
    addi t3, t3, 1
    j end

inverter:
    mv t4, a1
    addi t5, t5, -1

reverse_loop:
    bge t4, t5, end
    lb t6, 0(t4)
    lb t2, 0(t5)
    sb t2, 0(t4)
    sb t6, 0(t5)
    addi t4, t4, 1
    addi t5, t5, -1
    j reverse_loop

end:
    mv a0, t3                # Retorna comprimento
    ret
fim_macro:
    # Fechar arquivo de saída
    li a7, 57
    mv a0, s2
    ecall
.end_macro

.macro print_int(%x)
    add a0, %x, zero
    li a7, 1
    ecall
.end_macro

.macro print_newline
    addi a0, zero, 10
    li a7, 11
    ecall
.end_macro 

.macro write_newline(%dec)
    li a7, 64     
    mv a0, %dec         
    la a1, newline     
    li a2, 1
    ecall
.end_macro

.macro write_string(%string, %dec, %size)
    li a7, 64          
    mv a0, %dec         
    la a1, %string     
    li a2, %size
    ecall
.end_macro

.macro create_file(%file)
    li a7, 1024
    la a0, %file
    li a1, 1
    ecall
    close_file(a0)
.end_macro
    

.macro write(%x, %y) #Pixel x - ocorrencia y
    li a7, 1024       
    la a0, output     
    li a1, 9           
    li a2, 1          
    ecall #open file

    mv s0, a0   #guarda decriptor 

    bltz s0, open_error

    write_string(pixel, s0, 8)      
    write_int_to_file(%x, s0)
    write_string(frequencia, s0, 15) 
    write_newline(s0)
    li a7, 57          
    mv a0, s0          
    ecall

.end_macro

.macro close_file(%decriptor)
    li a7, 57
    mv a0, %decriptor
    ecall
.end_macro
    