.include "macro.asm"

.data
buffer:        .space 21120                # Buffer de 1KB
newline:       .string "\n"
.align 2
filename:      .string "bins/gray_pixel_count.bin" 
.align 2
output:        .string "histograma_equalizado_rars.txt" 
.align 2
output_bin:    .string "pixel_bytes.bin"
.align 2

pixel:         .string  "Pixel \0"
.align 2
frequencia:     .string  " - ocorrencia "
.align 2
total_acumulado:.word 0
pixel_count: 	.space 1024
success_msg:   .string "\nLeitura concluída. Bytes lidos: "
.align 2
error_open:    .string "\nErro ao abrir o arquivo!"
.align 2
error_read:    .string "\nErro ao ler o arquivo!"
.align 2

.text
.globl main

main:
    # Abrir arquivo (syscall 1024)
    li a7, 1024              
    la a0, filename          
    li a1, 0                 # Modo leitura (0 = read-only)
    li a2, 0                 # Permissões (obrigatório)
    ecall
    
    bltz a0, open_error      # Tratar erro de abertura
    mv s0, a0                # Salvar descritor

    # Ler arquivo (syscall 63)
    li a7, 63
    mv a0, s0                # Descritor
    la a1, buffer            # Endereço do buffer

    li a2, 21120              # Tamanho máximo
    ecall
    
    bltz a0, read_error      # Tratar erro de leitura
    mv s1, a0                # Salvar bytes lidos

    # Fechar arquivo (syscall 57)
    li a7, 57
    mv a0, s0
    ecall
    
    # Mensagem de sucesso
    la a0, success_msg
    li a7, 4
    ecall
    
    # Mostrar quantidade de bytes
    mv a0, s1
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall

    # Loop de impressão dos bytes
    li t0, 0                 # Contador
    la t1, buffer            # Ponteiro12
    la s0, pixel_count
    fill_zero(s0, 256)
calcular_freq:
    bge t0, s1, CDF
    lbu t6, 0(t1)            # Carregar byte sem sinal
    slli t3,t6, 2
    add t4, s0, t3
    lw t5, 0(t4)
    addi t5,t5,1
    sw t5,0(t4)
    addi t1, t1, 1           
    addi t0, t0, 1          
    j calcular_freq

CDF:
    li t0, 0                 # Contador
    la t1, buffer            # Ponteiro12
    la s0, pixel_count
    
CDF_loop:
    bge t0, s1, equalizer
    slli a3, t0, 2
    add t6, s0, a3
    lw t3, total_acumulado
    lw t6, (t6)
    add t2, s0, a3
    add t4, t6, t3
    sw t4, total_acumulado, t5
    sw t4, (t2)
    addi t0, t0, 1
    addi t1, t1, 1
    j CDF_loop
 
equalizer:
    li t0, 0
    li t2, 255
    la s0, pixel_count

loop:
    bge t0, s1, result
    slli t3, t0, 2
    add t4, s0, t3
    lw t5, 0(t4)
    mul t5, t5, t2
    div t5, t5, s1
    sw t5, (t4)
    #print_int(t5)
    #print_newline()
    addi t0, t0, 1
    j loop
open_error:
    la a0, error_open
    li a7, 4
    ecall
    j exit

read_error:
    la a0, error_read
    li a7, 4
    ecall
    # Fechar arquivo se aberto
    li a7, 57
    mv a0, s0
    ecall

result:
    li t0, 0                 # Contador
    la t1, buffer            # Ponteiro12
    la s0, pixel_count
result_loop:
    bge t0, s1, calcular_freq2
    #print_int(t1)
    lbu t3, 0(t1)
    #print_int(t3)
    slli t4, t3, 2
    add t3, t4, s0
    lw t5, 0(t3)
    #print_int(t5)
    sb t5, (t1)
    addi t0, t0, 1 
    addi t1, t1, 1
    j result_loop
   
calcular_freq2:

    li t0, 0                 # Contador
    la t1, buffer            # Ponteiro12
    la s0, pixel_count
    fill_zero(s0, 256)
calcular_freq2_loop:
    bge t0, s1, exit
    lbu t6, 0(t1)            # Carregar byte sem sinal
    
    slli t3,t6, 2
    
    add t4, s0, t3
    lw t5, 0(t4)
    addi t5, t5, 1
    sw t5,0(t4)
    #print_int(t4)
    # Imprimir valor decimal
    #li a7, 1
    #ecall
    addi t1, t1, 1           
    addi t0, t0, 1          
    j calcular_freq2_loop
    
exit:
    la s0, pixel_count
    escrever_frequencias(s0)
    create_file(output_bin)
    li a7, 1024
    la a0, output_bin
    li a1, 9
    ecall
    mv s0, a0
    write_string_addr(buffer, s0, 21120)
    print_int(a0)
    close_file(s0)
    li a7, 10               
    ecall
   
    
