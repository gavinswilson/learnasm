SYS_WRITE   equ 1 ; write text to stdout
SYS_READ    equ 0 ; read text from stdin
SYS_EXIT    equ 60 ; terminate the program
STDOUT      equ 1 ; stdout
OPEN_FILE   equ 2 ; open file
SYS_CLOSE   equ 3 ; sys_close


section .bss
    uinput resb 24 ; 24 bytes for user string
    uinput_len equ $ - uinput ; get length of user input

section .text
    global _start          ;must be declared for linker (ld)


open_file:
    mov rdi, filename
    mov rsi, 0102o     ;O_CREAT, man open
    mov rdx, 0666o     ;umode_t
    mov rax, OPEN_FILE
    syscall
    mov [fd], rax
    ret

write_to_file:
    mov rdx, msglen       ;message length
    mov rsi, msg       ;message to write
    mov rdi, [fd]      ;file descriptor
    mov rax, 1         ;system call number (sys_write)
    syscall            ;call kernel
    
    mov rdx, uinput_len       ;message length
    mov rsi, uinput     ;message to write
    mov rdi, [fd]      ;file descriptor
    mov rax, 1         ;system call number (sys_write)
    syscall            ;call kernel
    ret

close_file:
    mov rdi, [fd]
    mov rax, SYS_CLOSE         ;sys_close
    syscall
    ret

read_terminal:  
    mov rax, SYS_READ
    mov rdi, STDOUT
    mov rsi, uinput
    mov rdx, uinput_len
    syscall
    ret

write_terminal:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, msg
    mov rdx, msglen
    syscall
    ret

write_terminal2:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, uinput
    mov rdx, uinput_len
    syscall
    ret
 

_start:           
    call write_terminal
    call read_terminal
    call write_terminal2
    

    call open_file
    call write_to_file
    call close_file

    mov rax, SYS_EXIT        
    mov rdi, 12
    syscall  

section .data
    msg db 'Hello, world', 0xa
    msglen equ $ - msg
    newline db '\n', 0xa
    newlinelen equ $ - newline
    filename db 'out.txt', 0
    lenfilename equ $ - filename
    fd dq 0