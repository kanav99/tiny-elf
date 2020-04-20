; HW_4.asm
BITS 64
ehdr:                                          ; ELF64_Ehdr
        db  0x7F, "ELF", 2, 1, 1, 0            ; e_indent
times 8 db  0                                  ; EI_PAD
        dw  3                                  ; e_type
        dw  0x3e                               ; e_machine
        dd  1                                  ; e_version
scl     dq  0x0068732f6e69622f                 ; e_entry
        dq  phdr1 - $$                         ; e_phoff
plc     mov  al, 0x3b
        syscall
        dd  0                                  ; e_shoff
        dd  0                                  ; e_flags
        dw  ehdrsize                           ; e_ehsize
        dw  phdrsize                           ; e_phentsize
        dw  2                                  ; e_phnum
        dw  0                                  ; e_shentsize
        dw  0                                  ; e_shnum
        dw  0                                  ; e_shstrndx

ehdrsize    equ $ - ehdr

dynsym:
        db  0                                  

        db 0
        ; size
        dq 0
yo      xor rdx, rdx            ;3 bytes
        push qword [rel scl]    ;6 bytes
        mov rdi, rsp
        jmp lab

; symbol: __libc_start_main
    ; name
    dd 1
    ; type
    db 18
    ; visibility
    db 0
    ; shndx
    dw 1
    ; value
    dq yo - $$

dynamic:
    ; size
    dq 4
; symbol: __libc_start_main end

dynsymsize equ $ - dynsym

    dq hash

    dq 5
    dq dynstr

    dq 6
    dq dynsym


phdr1:
        dd  1                                  ; p_type
        dd  7                                  ; p_flags
        dq  $$                                 ; p_offset
        dq  $$                                 ; p_vaddr
lab     xor rax, rax
        jmp lab2
        db  0
        db  0
        db  0
        ; dq  $$                               ; p_paddr
        dq  filesize                           ; p_filesz
        dq  filesize                           ; p_memsz
        dq  0                                  ; p_align

phdrsize    equ $ - phdr1

phdr2:
        dd  2                                  ; p_type
        dd  7                                  ; p_flags
        dq  dynamic - $$                       ; p_offset
        dq  dynamic - $$                       ; p_vaddr
lab2    push rax
        push rdi
        mov  rsi, rsp
        jmp plc                                ; p_paddr
        dq  dynamicsize                        ; p_filesz
        db  dynamicsize                        ; p_memsz
        db  0                                  ; p_align: header ends here

hash:
    dd  1
    dd  2
    dd  1
    dd  0
    dw  0
    db  0

dynstr:
    db 0    ; hash ends here
hashsize equ $ - hash
    db "__libc_start_main"

filesize equ $ - $$
dynamicsize equ $ - dynamic
