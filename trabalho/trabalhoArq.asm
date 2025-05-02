.data
filename:      .string "C://Users//kauan//Documents//Code//Arquitetura//risc//trabalho//red_channel.bin"  
buffer:        .space 21120                # Buffer de 1KB
frequencia: 	.space 1024
success_msg:   .string "\nLeitura concluída. Bytes lidos: "
error_open:    .string "\nErro ao abrir o arquivo!"
error_read:    .string "\nErro ao ler o arquivo!"
newline:       .string "\n"

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
    la t1, buffer            # Ponteiro
    la s0, frequencia
    
    
calcular_freq:
    bge t0, s1, result
    lbu t6, 0(t1)            # Carregar byte sem sinal
    slli t3,t6, 2
    add t4, s0, t3
    lw t5, 0(t4)
    addi t5,t5,1
    sw t5,0(t4)
    # Imprimir valor decimal
    #li a7, 1
    #ecall
    addi t1, t1, 1           
    addi t0, t0, 1          
    j calcular_freq

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
li t1,0
li t2,256
print_freq:
    beq t1,t2, exit
    mv a0, t1
    li a7, 1
    ecall 
    li a0, 58
    li a7, 11
    ecall
    li a0, 32             
    li a7, 11
    ecall
    slli t3, t1, 2
    add t4, t3, s0
    lw a0, 0(t4)
    li a7, 1
    ecall
    la a0, newline
    li a7,4
    ecall
    addi t1,t1,1
    j print_freq
exit:
    li a7, 10               
    ecall