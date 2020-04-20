; HW_4.asm
BITS 64
ehdr:                                          ; ELF64_Ehdr : const
        db  0x7F, "ELF", 2, 1, 1, 0            ; e_indent : const
times 8 db  0                                  ; EI_PAD : const
        dw  3                                  ; e_type : const
        dw  0x3e                               ; e_machine : const
        dd  1                                  ; e_version : const
scl     dq  0x0068732f6e69622f                 ; e_entry
        dq  phdr1 - $$                         ; e_phoff : const
plc     mov  al, 0x3b ; 2 byte
        syscall ; 2 byte
        dq  0                                  ; PLAY HERE!!!
        dw  64                                 ; e_ehsize : const
        dw  56                                 ; e_phentsize : const
        db  2                                  ; e_phnum : const
dynsym:
        db  0                                  ; const
yo      xor rdx, rdx            ;3 bytes
        push qword [rel scl]    ;6 bytes
        mov rdi, rsp ; 3 bytes
        xor rax, rax ; 3 byte
        push rax ; 1 byte
        push rdi ; 1 byte
        mov  rsi, rsp ; 3 bytes
        jmp plc ; 2 bytes
        db  0

; symbol: __libc_start_main
    ; name
    dd 0
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
        dq  0
        ; dq  $$                               ; p_paddr
        dq  filesize                           ; p_filesz
        dq  filesize                           ; p_memsz
        dq  0                                  ; p_align

phdr2:
        dd  2                                  ; p_type
        dd  7                                  ; p_flags
        dq  dynamic - $$                       ; p_offset
        dq  dynamic - $$                       ; p_vaddr
        ; dq  0
        ; dq  dynamicsize                        ; p_filesz
dynstr: db "__libc_start_main", 0
hash:
    dd  1
    dd  2
    dd  1
    dq  0
hashsize equ $ - hash

filesize equ $ - $$
dynamicsize equ $ - dynamic
