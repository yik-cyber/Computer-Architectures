.data 
success:    .asciiz
           "Success!Location:"
fail:       .asciiz
           "Fail!"
endl:      .asciiz
           "\r\n"
buf:        .space 255

.text
main:  
      la $a0, buf
      li $a1, 255
      li $v0, 8
      syscall #read a string
input:     
      li $v0, 12    #read a char
      syscall
      la $s0, ($v0)
      li $t0, '?'
      beq $v0, $t0, over
      la $a0, endl
      li $v0, 4
      syscall

pre:
      la $a0, buf
      xor $t0, $t0, $t0
find_loc:
      xor $t1, $t1, $t1
      lb  $t1, ($a0)
      beq $s0, $t1, pr_suc
      addi $t0, $t0, 1
      addi $a0, $a0, 1
      blt $t0, $a1, find_loc
      
pr_fail:
      la $a0, fail
      li $v0, 4
      syscall
      la $a0, endl
      li $v0, 4
      syscall
      j input
pr_suc:
      la $a0, success
      li $v0, 4
      syscall
      addi $a0, $t0, 1
      li $v0, 1    #print an integer
      syscall
      la $a0, endl
      li $v0, 4
      syscall
      j input

over:
      li $v0, 10
      syscall
