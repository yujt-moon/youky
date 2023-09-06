[org 0x7c00]

; 清空屏幕
mov ax, 3
int 0x10

; 打印欢迎信息
mov si, msg
call print

mov ax, 0
mov ds, ax
mov ecx, 1
mov bx, 1
mov edi, 0x1000
call read_disk

jmp $

; si 字符串开始
print:
    mov ah, 0x0e
.put_char:
    mov al, [si]
    cmp al, 0x00
    jz .ret
    int 0x10
    inc si
    jmp .put_char
.ret:
    ret

; 读取硬盘
; ecx 保存 32 位的起始扇区
; bx 保存读取多少扇区
; edi 保存内存的起始位置
read_disk:
    ; 读写的扇区数量
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    ; 起始扇区的 0 ~ 7 位
    inc dx  ; 0x1f3
    mov al, cl
    out dx, al

    ; 起始扇区的 8 ~ 15 位
    inc dx  ; 0x1f4
    mov al, ch
    out dx, al

    ; 起始扇区的 16 ~ 32 位
    inc dx  ; 0x1f5
    shr ecx, 16
    mov al, cl
    out dx, al

    ; 起始扇区的 24 ~ 27
    inc dx  ; 0x1f6
    mov al, ch
    and al, 0000_1111b

    or al, 1110_0000b
    out dx, al

    ; 读硬盘
    inc dx  ; 0x1f7
    mov al, 0x20
    out dx, al

.wait:
    ; 判断硬盘状态
    in al, dx
    jmp $+2
    jmp $+2
    jmp $+2
    and al, 1000_1000b
    cmp al, 0000_1000b
    jnz .wait
    xor cx, cx
    mov ax, 256
    mul bx
    mov cx, ax
.read:
    ; 直接 in ax, 0x1f0 无效
    mov dx, 0x1f0
    in ax, dx
    mov [edi], ax
    add edi, 2
    loop .read
.ret:
    ret

msg:
    db 'youky is starting ...', 0x00

times 510 - ($ - $$) db 0
db 0x55, 0xaa 
