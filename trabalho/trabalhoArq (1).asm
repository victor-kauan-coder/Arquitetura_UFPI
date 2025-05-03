.data
filename:      .string "/home/davidson/Documentos/UFPI/3-periodo/Arquitetura-de-computadores/TrabalhoArquitetura/RISC-V/Arquitetura_UFPI/trabalho/teste.txt"  
filename_txt: .asciz "/home/davidson/Documentos/UFPI/3-periodo/Arquitetura-de-computadores/TrabalhoArquitetura/RISC-V/Arquitetura_UFPI/trabalho/teste.txt"  
buffer_line:   .space 24 
buffer:        .space 21120                
.align 2                      
frequencia: 	.space 1024    
success_msg:   .string "\nLeitura concluída. Bytes lidos: "
error_open:    .string "\nErro ao abrir o arquivo!"
error_read:    .string "\nErro ao ler o arquivo!"
newline:       .string "\n"
dois_pontos:   .string ": "

.text
.globl main

main:
    # Abrir arquivo binário
    li a7, 1024              
    la a0, filename          
    li a1, 0                 
    ecall
    bltz a0, open_error     
    mv s0, a0                # Descritor do arquivo

    # Ler conteúdo
    li a7, 63
    mv a0, s0
    la a1, buffer
    li a2, 21120
    ecall
    bltz a0, read_error     
    mv s1, a0                # Bytes lidos

    # Fechar arquivo
    li a7, 57
    mv a0, s0
    ecall

    # Calcular frequências
    la s0, frequencia        
    li t0, 0
    la t1, buffer

calcular_freq:
    bge t0, s1, result
    lbu t6, 0(t1)           
    slli t3, t6, 2          
    add t4, s0, t3          
    lw t5, 0(t4)            
    addi t5, t5, 1
    sw t5, 0(t4)            
    addi t1, t1, 1
    addi t0, t0, 1
    j calcular_freq

result:
    # Abrir arquivo de saída
    li a7, 1024
    la a0, filename_txt
    li a1, 1                 
    ecall
    mv s2, a0                # Descritor do arquivo

    # Escrever frequências
    li t1, 0                 # Pixel atual
    li t2, 256               # Limite

print_freq:
    beq t1, t2, exit

    # Salvar t1 e t2 na pilha
    addi sp, sp, -8
    sw t1, 0(sp)
    sw t2, 4(sp)

    # Escrever pixel
    mv a0, t1
    la a1, buffer_line
    jal int_to_str           # a0 = comprimento da string
    mv a2, a0                # Comprimento em a2
    mv a0, s2                # Descritor do arquivo
    la a1, buffer_line
    li a7, 64                # Syscall write
    ecall

    # Escrever ": "
    la a1, dois_pontos
    li a2, 2
    li a7, 64
    mv a0, s2
    ecall

    # Escrever frequência
    slli t3, t1, 2
    add t4, s0, t3
    lw a0, 0(t4)
    la a1, buffer_line
    jal int_to_str           # a0 = comprimento da string
    mv a2, a0                # Comprimento em a2
    mv a0, s2                # Descritor do arquivo
    la a1, buffer_line
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

# Função int_to_str (corrigida)
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

open_error:
    la a0, error_open
    li a7, 4
    ecall
    j exit

read_error:
    la a0, error_read
    li a7, 4
    ecall
    li a7, 57
    mv a0, s0
    ecall

exit:
    # Fechar arquivo de saída
    li a7, 57
    mv a0, s2
    ecall

    li a7, 10
    ecall
