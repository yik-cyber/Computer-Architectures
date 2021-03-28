;实验目的：掌握在PC机上利用DOS功能调用实现简单输入输出的方法。
;实验内容：利用DOS功能调用从键盘输入，转换后在屏幕上显示，具体要求如下：
;(1)如果输入的是字母（A~Z，区分大小写）或数字（0~9），则将其转换成对应的英文单词后在屏幕上显示，对应关系见下表。如果输入为小写字符，则需要在程序中将单词的首字母转换为小写，然后再输出显示
;(2)若输入的不是字母或数字，则在屏幕上输出字符“？”
;(3)每输入一个字符，即时转换并在屏幕上显示，并且在转换之后输出一个空格
;(4)支持反复输入，直到按ESC键退出程序返回DOS命令行
;(5)程序结束时，在屏幕上显示本人的学号和姓名全拼
;(6)程序中的循环要使用LOOP类指令实现
 
;格式示例：
;	输入(不会显示出来)：1A&2b&3C
;	输出：One Apple And Two banana And Three Cake

data segment
    numbers  db 'Zero $One $Two $Three $Four $Five $Six $Seven $Eight $Nine $'
    chars db 'Spark $At $And$'
    words db 'Apple $Banana $Cake $Dessert $Egg $Fig $Grape $Honey $Icecream $Juice $Kiwi $Lemon $Mango $Nut $Orange $Peach $Quarenden $Radish $Strawberry $Tangerine $Udon $Veal $Watermelon $Xacuti $Yam $Zucchini $'
    other_word db '? $'
    num_offset dw 0,6,11,16,23,29,35,40,47,54
    words_offset dw 0,7,15,21,30,35,40,47,54,64,71,77,84,91,96,104,111,122,130,142,153,159,165,177,185,190
    myname db 0ah, 0dh, 'Name:yik-cyber',0ah,0dh,'$'
    myid db 'ID:114514', 0ah, 0dh, '$'
data ends

stack segment stack
    sta db 3000 dup(?)
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
    
    input: mov ah, 07h ;get one byte input
           int 21h
           mov ah, 00h
           mov bl, 1bh
           cmp al, bl
           je flag2
           mov bl, '@'
           cmp bl, al
           jne chosen
           mov dx, offset chars
           add dx, 0007h
           mov ah, 09h
           int 21h
           jmp input ;return to input
    
    chosen: cmp al, 30h     ; < 48
            jl symbols1
            cmp al, 39h     ;48<= ? <= 57
            jle nums
            cmp al, 41h     ;57 < ? < 65
            jl flag
            cmp al, 5ah     ;65 <= ? <= 90
            jle alpha
            cmp al, 61h     ;90 < ? < 97
            jl flag
            cmp al, 7ah    ;97 <= ? <= 122
            jle prealpha
            jmp FAR PTR others
    
    flag: jmp FAR PTR others 

    flag2: jmp FAR PTR over

    nums: sub al, 30h
          mov si, ax
          sal si, 01h
          mov bx, offset num_offset
          mov bx, [bx + si]    ;offset dw
          mov dx, offset numbers
          add dx, bx
          mov ah, 09h
          int 21h
          jmp input   
    
    prealpha: sub al, 20h
    alpha:  sub al, 41h
            mov si, ax
            sal si, 01h
            mov bx, offset words_offset
            mov bx, [bx + si]
            mov dx, offset words
            add dx, bx
            mov ah, 09h
            int 21h
            jmp input
    
    over: mov bl, 1bh    ;esc
          cmp bl, al
          jne symbols1
          mov dx, offset myname
          mov ah, 09h
          int 21h
          mov dx, offset myid
          mov ah, 09h
          int 21h
          mov ax, 4c00h
          int 21h            
    symbols1: 
              mov bl, '*'   ;output spark for *
              cmp al, bl
              jne symbols2
              mov dx, offset chars
              mov ah, 09h
              int 21h
              jmp input
    symbols2: mov bl, '&'
              cmp al, bl
              jne others
              mov dx, offset chars ;output and for &
              add dx, 1bh
              mov ah, 09h
              int 21
              jmp input
    others: mov dx, offset other_word
            mov ah, 09h
            int 21h
            jmp FAR PTR input
    


code ends
end begin
           
