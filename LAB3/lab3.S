/***************************************************************************
 * lab3.S
 *
 * Printf and Scanf
 *
 * Patrick McBride
 *
 * Tue Aug 18, 2020
 *
 * takes two 32 bit ints adds them and returns them 
 * takes two 64 bit ints adds them and returns them 
 *
 * It should be assembled and linked as follows:
 *  gcc lab3.S
 *  
 **************************************************************************/
        .data

iMsg:   .asciz  "Enter two numbers\n"
        .align  2

linpt:   .asciz  "%ld%ld"
        .align  2

inpt:   .asciz  "%d%d"
        .align  2

lopt:   .asciz  "The sum is %ld\n"
        .align  2

opt:   .asciz  "The sum is %d\n"
        .align  2

i:      .word   0
j:      .word  0
n:      .dword   0
m:      .dword  0

        .text

        .global main
main:
        str lr, [sp, #-16]! // store return address

        ldr x0, =iMsg // load message
        bl printf // print message

        ldr x0, =inpt
        ldr x1, =i
        ldr x2, =j
        bl scanf

        ldr x1, i
        ldr x2, j
        add x1, x1, x2
        ldr x0, =opt
        bl printf

        ldr x0, =iMsg // load message
        bl printf // print message

        ldr x0, =linpt
        ldr x1, =n
        ldr x2, =m
        bl scanf

        ldr x1, n
        ldr x2, m
        add x1, x1, x2
        ldr x0, =lopt
        bl printf

    ldr lr, [sp], #16 // get return address
    mov x0, #0
    ret
    .end


























ldr x1,=i // address 
ldr x1, i // value

// address is one byte of data 
// 2x32 2x64 
get 32
get 32
get 64
get 64 
32+32 
64+64 
print 32+32
//x0-x8 for params
// printf(<ptr to format stir>, <a value> ) ldr x0, =<format str>  ldr x1,<a value>
// scanf(<ptr to format stir>, <an address>) 