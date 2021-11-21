 	.text
        .type   bigint_adc, %function
        .global bigint_adc
bigint_adc:
        stp     x29, x30, [sp, #-16]!           // Save FP & Link Register x30    
        stp     x26, x27, [sp, #-16]!
        stp     x24, x25, [sp, #-16]!
        mov     x26, xzr
        stp     x22, x23, [sp, #-16]! 
        mov     x27, xzr    
        stp     x20, x21, [sp, #-16]!
        mov     w26, w2  
        

        ldr     x25, [x0]   
        mov     x23, xzr                   // load pointer to left blks
        ldr     w23, [x0, #8]              // load left size 

        ldr     x21, [x1] 
        mov     x22, xzr                    // load pointer to right blks
        ldr     w22, [x1, #8]               // load right size 

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
        add     X0, x0, #1
        
        bl      bigint_alloc
        mov     x1, x0
        sub     x23, x23, x22
bulk:     
        cmp     w22, #2
        blt     lol 
        beq     oneMore

        ldp     x5, x6, [x25], #16    // load 2 chunks 
        ldp     x3, x4, [x21], #16    // load 2 chunks 
        sub     w22, w22, #2          // decrement itr by 2
        adds    x2, x26, 0xFFFFFFFFFFFFFFFF 
        adcs    x5, x5, x3            // add l to r
        adcs    x6, x6, x4            // add l to r
        adc     x26, x27, xzr 
        stp     x5, x6, [x0], #16    // load 2 chunks 

        b       bulk
oneMore:
        ldr     x5, [x25], #8                   // load 1 chunk
        ldr     x3, [x21], #8                   // load 1 chunk
        adds    x2, x26, 0xFFFFFFFFFFFFFFFF 
        adcs    x5, x5, x3                      // add l to r
        adc     x26, x27, xzr 
        str     x5, [x0], #8                   
lol:   
        ldr     x3, [x21]
        asr     x3, x3, #63
        cmp     x23, xzr 
        beq     ll     

fll:    
        cmp     w23, #2
        blt     ll
        beq     om

        ldp     x5, x6, [x25], #16    // load 2 chunks 
        sub     w23, w23, #2          // decrement itr by 2
        adds    x2, x26, 0xFFFFFFFFFFFFFFFF 
        adcs    x5, x5, x3            // add l to r
        adcs    x6, x6, x3            // add l to r
        adc     x26, x27, xzr 
        stp     x5, x6, [x0], #16    
                   
        b       fll

om:
        ldr     x5, [x25], #8                   // load 1 chunk
        adds    x2, x26, #0xFFFFFFFFFFFFFFFF 
        adcs    x5, x5, x3                      // add l to r
        adc     x26, x27, xzr 
        str     x5, [x0], #8  

ll: 
        ldr     x5, [x25]
        asr     x5, x5, #63
        adds    x2, x26, #0xFFFFFFFFFFFFFFFF 
        adc     x5, x5, x3                      // add l to r
        str     x5, [x0], #8                   

        mov     x0, x1
        bl      bigint_trim

        ldp     x20, x21, [sp], #16
        ldp     x22, x23, [sp], #16
        ldp     x24, x25, [sp], #16
        ldp     x26, x27, [sp], #16
        ldp     x29, x30, [sp], #16             // Restore FP & LR
        ret
