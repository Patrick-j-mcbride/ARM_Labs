/***************************************************************************
 * helloas.S
 *
 * "Hello World" in ARM Assembly
 *
 * Christopher J Smith
 * Scott K Logan
 *
 * Tue Aug 18, 2020
 *
 * This is a simple Hello, World program written in ARM assembly using
 * Linux system calls.
 * This version will run without the C standard library, and provides its
 * own _start function.
 *
 * It should be assembled and linked as follows:
 *   as -o helloas.o helloas.S
 *   ld -o helloas helloas.o
 **************************************************************************/
    .data

msg:    .ascii "Hello World!\n"
len     = . - msg
    
    .text

.globl _start
    // main is called by the _start function which is in the C
    // standrd library
_start:
    // write( int fd, const void *buf, size_t count)
    mov     x0, #1
    ldr     x1, =msg // ascii message from line 22
    ldr     x2, =len // length of msg from line 23
    mov     x8, #64 // call print
    svc     #0
    //return from main()
    mov     x0, #0          //Status -> 0
    mov     x8, #93 // call exit
    svc     #0 // return 0

.end
