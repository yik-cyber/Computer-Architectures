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
           
