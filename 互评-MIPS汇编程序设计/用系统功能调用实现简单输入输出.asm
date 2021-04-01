.data
upper_word:  .asciiz
            "Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ",
            "Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ",
            "Mary ","November ","Oscar ","Paper ","Quebec ","Research ",
            "Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ",
            "Yankee ","Zulu "
upper_offset:  .word
               0,7,14,21,28,34,43,49,56,63,71,
               77,83,89,99,106,113,121,131,
               139,146,155,163,171,178,186
low_word:     .asciiz
              "alpha ","bravo ","china ","delta ","echo ","foxtrot ",
              "golf ","hotel ","india ","juliet ","kilo ","lima ",
              "mary ","november ","oscar ","paper ","quebec ","research ",
              "sierra ","tango ","uniform ","victor ","whisky ","x-ray ",
              "yankee ","zulu "
low_offset:  .word
             0,7,14,21,28,34,43,49,56,63,71,
             77,83,89,99,106,113,121,131,
             139,146,155,163,171,178,186
numbers:     .asciiz
                 "zero ", "First ", "Second ", "Third ", "Fourth ",
                 "Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
numbers_offset:   .word
                 0,6,13,21,28,36,43,50,59,67
.text
main:
      li $v0, 12  #read a char
      syscall
      li $t0, '?'
      beq $v0, $t0, over
      
      blt $v0, 48, others
      ble $v0, 57, pr_num
      blt $v0, 65, others
      ble $v0, 90, pr_upper
      blt $v0, 97, others
      ble $v0, 122, pr_low
      
pr_num:
      subi $v0, $v0, 48
      sll $v0, $v0, 2
      la $a0, numbers_offset
      add $a0, $a0, $v0
      lw $v0, ($a0)
      la $a0, numbers
      add $a0, $a0, $v0
      li $v0, 4
      syscall
      j main

pr_upper:
      subi $v0, $v0, 65
      sll $v0, $v0, 2
      la $a0, upper_offset
      add $a0, $a0, $v0
      lw $v0, ($a0)
      la $a0, upper_word
      add $a0, $a0, $v0
      li $v0, 4
      syscall
      j main

pr_low:
      subi $v0, $v0, 97
      sll $v0, $v0, 2
      la $a0, low_offset
      add $a0, $a0, $v0
      lw $v0, ($a0)
      la $a0, low_word
      add $a0, $a0, $v0
      li $v0, 4
      syscall
      j main
      
others:
      xor $a0, $a0, $a0
      addi $a0, $a0, '*'
      li $v0, 11 #print a char 
      syscall
      j main
over:
      li $v0, 10
      syscall
        
