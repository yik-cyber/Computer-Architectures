;实验目的：掌握汇编程序的基本结构
;实验内容：调试通过参考书《微型计算机基本原理与应用》第5章第137页的示例程序，并增加如下功能：
;(1)	程序开始时，在屏幕上显示本人的姓名全拼和学号,格式如下：
;NAME: Xiao Wanzi
;ID:1302102910
;(2)	程序结束时，在屏幕上显示“Good Bye!”
;(3)	此题不需要提交源代码，仅用于熟悉掌握汇编程序的基本结构。
;提示：输入输出可见参考书《微型计算机基本原理与应用》的附录二“DOS功能调用”

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
