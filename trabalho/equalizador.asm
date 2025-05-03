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
    #li a0, 1 
    mv a0, %dec         
    la a1, newline     
    li a2, 1
    ecall
.end_macro

.macro write_int(%x, %dec, %size)
    la t3, temp
    sw %x, 0(t3)
    li a7, 64          
    mv a0, %dec       
    la a1, temp   
    li a2, %size 
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

    write_string(pixel, s0, 6)      
    #write_int(%x, s0, 8)
    write_string(frequencia, s0, 13) 
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
    
   
.data
newline:       .string  "\n"
temp:          .word 0
filename:      .string "/home/davidson/Documentos/UFPI/3-periodo/Arquitetura-de-computadores/TrabalhoArquitetura/RISC-V/Arquitetura_UFPI/trabalho/gray_pixel_count.bin" 
.align 2
output:        .string "/home/davidson/Documentos/UFPI/3-periodo/Arquitetura-de-computadores/TrabalhoArquitetura/RISC-V/Arquitetura_UFPI/trabalho/teste.txt" 
.align 2
buffer:        .space 21120                # Buffer de 1KB
pixel:         .string  "Pixel "
.align 2
frequencia:     .string  " - ocorrencia"
.align 2
total_acumulado:.word 0
acumulada: 	.space 1024
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
    la s0, acumulada
calcular_freq:
    bge t0, s1, CDF
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

CDF:
    li t0, 0                 # Contador
    la t1, buffer            # Ponteiro12
    la s0, acumulada
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
    la s0, acumulada
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
   li t1,0
   li t2,256
   create_file(output)
write_equal:
    beq t1,t2, exit
    write(t2, t3)
    addi t1, t1, 1
    j write_equal
exit:
    li a7, 10               
    ecall
   
    
