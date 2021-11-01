/***************************************************************************
 * lab4part1.S
 *
 * Arrays, Loops, and Functions
 *
 * Patrick McBride
 *
 * Thur Sep 23, 2021
 *
 *
 * It should be assembled and linked as follows:
 *  gcc lab4part1.S
 *  
 **************************************************************************/
        .data

arr:    .skip   4096
        .align  4

msg:    .asciz "Enter text (ctrl-D to end): "
        .align  4

ptsm:   .asciz "\n%d\n"
        .align  4

skp:    .asciz "\n"
        .align  4


sum:    .8byte   0

        .text

        .type checkSum, %function
        .global checkSum
checkSum:
        stp     x29,x30, [sp, #-16]! // store return address
        stp     x25,x26, [sp, #-16]!

        mov     x26, xzr
        mov     x1, xzr

ct:  
        ldrb    w1, [x0]  
        add     x0, x0, #1 
        add     x26, x26, x1
        cmp     w1, #0
        bne     ct

        mov     x0, x26

        ldp     x25,x26, [sp], #16
        ldp     x29,x30, [sp], #16 // get return address
        ret

        .type main, %function
        .global main

main:
        stp     x29,x30, [sp, #-16]! // store return address
        stp     x25,x26, [sp, #-16]! // store return address

        ldr     x0, =msg
        bl      printf 

        ldr     x26, =arr

read:   
        bl      getchar
        cmp     w0, #-1
        beq     nd 
        strb    w0, [x26]
        add     x26, x26, #1
        bl      read
nd:
        strb    wzr, [x26]

        ldr     x0, =skp
        bl      printf // skip line

        ldr     x0, =arr
        bl      printf // print array

        ldr     x25, sum
        ldr     x0, =arr
        bl      checkSum // calculate sum 
        add     x25, x25, x0

        mov     x1, x25
        ldr     x0, =ptsm
        bl      printf

        ldr     x0, =arr
        bl      checkSum // calculate sum 
        add     x25, x25, x0

        mov     x1, x25
        ldr     x0, =ptsm
        bl      printf

        ldp     x25,x26, [sp], #16
        ldp     x29,x30, [sp], #16 // get return address
        mov     x0, #0
        ret
.end