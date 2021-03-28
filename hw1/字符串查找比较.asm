;实验目的：掌握串指令的基本功能及应用
;实验内容：利用DOS功能调用从键盘输入一个字符串，然后输入单个字符，利用串扫描指令查找该字符串中是否有该字符。具体要求如下：
;(1)输出该字符出现的总次数，没有出现输出Sorry!
;(2)如果找到，则在屏幕上显示：
;Last position: X
;其中，X为该字符在字符串中最后一次出现的位置
;(3)输入一个字符串后，可以反复输入希望查询的字符，直到按ESC键结束程序
;(4)每个输入字符独占一行，输出查找结果独占一行，位置编码从1开始，格式示例如下：
;abcdefagh
;a
;2
;Last position: 7
;x
;Sorry!
;(5)程序结束时，在屏幕上显示本人的学号和姓名全拼
;ID: 1302102910
;NAME: Xiao Xiannv







data segment
    buf db 1024 dup(?)
    pos_msg db 'Last position:$'
    sorry_msg db 'Sorry!$'
    out_buf db '000$' ;最多不会超过3位，所以用3位缓存
    myname db 'NAME:yik-cyber$'
    myid db 'ID:114514$'
    endl db 0ah, 0dh, '$' ;换行回车符
    flag_msg db 00h
    cnt dw 0001h
data ends
stack segment stack
    sta db 1024 dup(?)
    top equ length sta
stack ends
code segment
    assume cs:code, ds:data, ss:stack
    begin: mov ax, data ; preaparations
           mov ds, ax
           mov ax, stack
           mov ss, ax
           mov ax, top
           mov sp, ax
    
    str_input: mov bh, 00h
               mov bx, offset buf
               mov [bx], 1000    ;the first byte store the max length
               mov dx, bx
               mov ah, 0ah
               int 21h    ;input the string

               mov bx, dx
               mov dx, offset endl
               mov ah, 09h
               int 21h    ;output the \r\n to avoid next line cover the current line
    
    char_input: mov ah, 01h    ;input one byte
                int 21h

                mov bx, offset flag_msg
                mov dl, 00h
                mov [bx], dl

                mov dx, offset endl
                mov ah, 09h
                int 21h 

                mov dl, 1bh
                cmp al, dl
                jne find_char
                jmp FAR PTR over
        
    find_char: xor si, si ;count 
               xor di, di ;last pos
               ; cl = legth
               mov bx, offset buf
               add bx, 01h
               mov cl, [bx]
               mov ch, 0
               add bx, cx
        
    strloop: mov dl, [bx]
             cmp al, dl
             jne flag
             add si, 01h ;eq, cnt++
             cmp si, 01h
             jnz flag ; si > 1, not store the pos
             mov di, cx
             dec di
             
       flag: dec cx
             dec bx
             jg strloop
             cmp si, 0
             je sorry_output
             mov ax, si
             
     mod_pre: mov cl, 10d
              mov si, 03d
              mov bx, offset out_buf

     mod_num: div cl
              dec si
              add ah, 30h
              mov [bx + si], ah
              cmp al, 0
              jnz mod_num

              mov dx, bx  ;out put numbers
              add dx, si
              mov ah, 09h
              int 21h
              mov dx, offset endl
              mov ah, 09h
              int 21h
              mov bx, offset flag_msg
              mov bl, [bx]
              cmp bl, 00h
              jne char_input
              
     pos_output: mov bx, offset flag_msg
                 mov al, 01h
                 mov [bx], al ;set the flag to ffh
                 mov dx, offset pos_msg
                 mov ah, 09h
                 int 21h
                 mov ax, di
                 jmp mod_pre
                 
    sorry_output: mov dx, offset sorry_msg
                  mov ah, 09h
                  int 21h
                  mov dx, offset endl
                  mov ah, 09h
                  int 21h
                  jmp FAR PTR char_input
    
    over: mov dx, offset myname
          mov ah, 09h
          int 21h
          mov dx, offset endl
          mov ah, 09h
          int 21h
          mov dx, offset myid
          mov ah, 09h
          int 21h
          mov ax, 4c00h
          int 21h

code ends
end begin
