section .data
    message:    db 'Hello'
    
section .bss
    filename:   resb 255
    
section .text
    global      _start

_start:
    mov rax, 60
    mov rdi, 12
    syscall

