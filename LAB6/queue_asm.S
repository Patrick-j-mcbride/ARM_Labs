    .data

    .equ        arr, 0
    .equ        fidx, 208
    .equ        eidx, 212
    .equ        nitms, 216

    .text
/***************************************************************************
 * lab6
 *
 * A Queue ADT
 *
 * Patrick McBride
 *
 * Thur Oct 14, 2021
 *
 * enque function for queue class
 *  
 **************************************************************************/
    .global _ZN5queue5enqueEi
_ZN5queue5enqueEi:// x0 = *this x1 = int item
        stp     x29, x30, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        mov     x21, x0 // ptr to this
        mov     w22, w1 // int item

        bl      _ZN5queue6isfullEv // will return 1 true, 0 false

        cmp     w0, wzr 
        mov     x0, xzr
        bne     full  

        ldr    w2, [x21, eidx] // load endindex into w2
        str    w22, [x21, x2, lsl#2]   // store item into arr[endindex]

        add     x2, x2, #1 // add to endindex 
        str     w2, [x21, eidx] // store endindex

        cmp     w2, #52 // endindex to 52
        blt     les
        mov     x5, xzr
        str     w5, [x21, eidx] // change end index to 0
les:         
        ldr    w3, [x21, nitms]
        add    x3, x3, #1
        str    w3, [x21, nitms]

        mov     x0, xzr
        add     x0, x0, #1
full:  
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret // int 0 queue is full int 1 item placed in queue


/***************************************************************************
 * lab6
 *
 * A Queue ADT
 *
 * Patrick McBride
 *
 * Thur Oct 14, 2021
 *
 * deque function for queue class
 *  
 **************************************************************************/
    .global _ZN5queue5dequeERi
_ZN5queue5dequeERi: // x0 = *this x1 = int& item
        stp     x29, x30, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        mov     x21, x0
        mov     x22, x1

        bl      _ZN5queue7isemptyEv // will return 1 true, 0 false

        cmp     x0, xzr

        mov     x0, xzr
        bne     empt  

        ldr    w2, [x21, fidx] // load frontindex into x2
        ldr    w0, [x21, x2, lsl#2] // load arr[fidx]
        str    w0, [x22] // 

        add     x2, x2, #1 // add to frontindex 
        str     w2, [x21, fidx] // store frontindex

        cmp     w2, #52
        blt     less
        
        mov     x5, xzr
        str     w5, [x21, fidx] // change front index to 0

less: 
        ldr    w3, [x21, nitms]
        sub    x3, x3, #1
        str    w3, [x21, nitms]

        ldr     w0, [x22]
empt:
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret // int item or 0
