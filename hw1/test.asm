data segment
    num dw 0011101000000111b ;3A07H
    notes db 'The result is:', '$'
    myname db 'NAME:yik-cyber',0ah,0dh,'$'
    idnumber db 'ID:114514',0ah,0dh, '$'
    byebye db 0ah,0dh,'Good Bye!','$'
data ends
stack segment stack
    sta db 50 dup(?)
    top equ length sta
stack ends
code segment
    assume cs:code, ds:data, ss:stack
  begin: mov ax, data
         mov ds, ax     ; ds = data
         mov ax, stack
         mov ss, ax     ; ss = stack
         mov ax, top
         mov sp, ax     ; sp = top
         mov dx, offset myname
         mov ah, 09h
         int 21h
         mov dx, offset idnumber
         mov ah, 09h
         int 21h
         mov dx, offset notes
         mov ah, 09h
         int 21h
         mov bx, num
         mov ch, 4
  rotate: mov cl, 4
          rol bx, cl   ; left rotate cl 
          mov al, bl
          and al, 0fh
          add al, 30h
          cmp al, '9'
          jl display
          add al, 07h
  display: mov dl, al
           mov ah, 2
           int 21h
           dec ch
           jnz rotate
           mov dx, offset byebye
           mov ah, 09h
           int 21h
           mov ax, 4c00h
           int 21h
code ends
end begin
