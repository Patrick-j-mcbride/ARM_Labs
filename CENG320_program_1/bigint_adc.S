 	.text
        .type   bigint_adc, %function
        .global bigint_adc
bigint_adc:
        stp     x29, x30, [sp, #-16]!           // Save FP & Link Register x30    
        stp     x24, x25, [sp, #-16]!
        stp     x22, x23, [sp, #-16]!     
        stp     x20, x21, [sp, #-16]!
        mov     x22, xzr  
        str     v20, [sp, #-16]!
        mov     x23, xzr
        mov     d20, x2                         // move carry into v register            
        mov     v20.d[1], xzr


        ldr     x25, [x0]                      // load pointer to left blks
        ldr     w23, [x0, #8]                  // load left size 

        ldr     x21, [x1]                      // load pointer to right blks
        ldr     w22, [x1, #8]                  // load right size 

        cmp     w23, w22
        blt     Lhi          
Rhi:     
        mov     x6, x23 
        mov     x7, x25
        mov     x23, x22 
        mov     x25, x21
        mov     x21, x7
        mov     x22, x6 
        mov     x24, x1
        mov     x20, x0                                    
        b       Nx
Lhi:
        mov     x24, x0
        mov     x20, x1 
Nx:
        mov     x0, x23
        add     x0, #1
        
        bl bigint_alloc
        mov     x1, x0
        sub     x23, x23, x22
bulk:     
        cmp     w22, #2
        blt     lol 
        beq     oneMore
        ldp     v1.d[0], v1.d[1], [x25], #16    // load 2 chunks 
        ldp     v2.d[0], v2.d[1], [x21], #16    // load 2 chunks 
        sub     w22, w22, #2                    // decrement itr by 2
        add     v0, v1.d[0], v2.d[0]            // add l to r 
        add     d0, d0, d3                      // add carry 
        mov     d4, d0                          // move chunk
        mov     d3, v0.d[1]                     // move carry
        add     v0, v1.d[1], v2.d[1]            // add l to r 
        add     d0, d0, d3                      // add carry 
        mov     v4.[1], d0                      // move chunk
        stp     v4.d[0], v4.d[1], [x0], #16     // store 2 computed chunks
        mov     d3, v0.d[1]                     // move carry
        b       bulk
oneMore:
        ldr     d1, [x25], #8                   // load 1 chunk
        ldr     d2, [x21], #8                   // load 1 chunk
        add     v0, d1, d2                      // add l to r 
        add     d0, d0, d3                      // add carry 
        str     d0, [x0], #8                    // store chunk
        mov     d3, v0.d[1]                     // move carry
lol:   
        ldr     x4, [x21]
        asr     x4, x4, #63
        mov     d2, x4
        cmp     x23, xzr 
        beq     ll     

fll:    
        cmp     w23, #2
        blt     ll
        beq     om
        ldp     v1.d[0], v1.d[1], [x25], #16    // load 2 chunks
        sub     w23, w23, #2

        add     v0, v1.d[0], d2                 // add l to r 
        add     d0, d0, d3                      // add carry 
        mov     d4, d0                          // move chunk
        mov     d3, v0.d[1]                     // move carry
        add     v0, v1.d[1], d2                 // add l to r 
        add     d0, d0, d3                      // add carry 
        mov     v4.[1], d0                      // move chunk
        stp     v4.d[0], v4.d[1], [x0], #16     // store 2 computed chunks
        mov     d3, v0.d[1]                     // move carry
        b       fll
om:
        ldr     d1, [x25], #8                   // load 1 chunk
        add     v0, d1, d2                      // add l to r 
        add     d0, d0, d3                      // add carry 
        str     d0, [x0], #8                    // store chunk
        mov     d3, v0.d[1]                     // move carry

ll: 
        ldr     x5, [x25]
        asr     x5, x5, #63
        mov     x6, d3
        add     x4, x4, x5 
        add     x4, x4, x6 
        asr     x5, x4, #1
        cmp     x4, x5 
        str     x4, [x0]

        mov     x0, x1

        ldr     v20, [sp], #16
        ldp     x20, x21, [sp], #16
        ldp     x22, x23, [sp], #16
        ldp     x24, x25, [sp], #16
        ldp     x29, x30, [sp], #16             // Restore FP & LR
        ret
