            .data
xLowS:      .skip   256
            .align  4
xHighS:     .skip   256
            .align  4
rowsS:      .skip   256
            .align  4
o1:         .asciz  "\nThis program will create a table for f(x) = (x^3 -x^2 -2x)/( ( (x-2)^4 )/11 ) + 3)\n\nEnter the lowest value of x: "
            .align  2
i1:         .asciz  "%s"
            .align  2
i2:         .asciz  "\n"
            .align  2
i3:         .asciz  "          "
            .align  2
nl:         .asciz  "\n"
            .align  2
o2:         .asciz  "\nEnter the highest value of x: "
            .align  2
o3:         .asciz  "\nEnter the number of rows for the table: "
            .align  2

xLow:       .dword  0
xHigh:      .dword  0
rows:       .dword  0

            .text
//***********************************************
            .global fofx
fofx:
            stp     x29, x30, [sp, #-16]!
            stp     x25, x26, [sp, #-16]!
            stp     x23, x24, [sp, #-16]!
            stp     x21, x22, [sp, #-16]!
                                            // x0 is x as S(31,32)

            mov     x21, x0                 // move x to x21 S(31,32)

            mov     x1, #1                  // x1 = 1 as U(32)
            lsl     x1, x1, #32             // x1 is 1.0 as U(32)

            mov     x2, #2                  // x2 = 2 as U(32)        
            lsl     x2, x2, #32             // x2 is 2.0 as S(31,32)

            sub     x22, x21, x1            // x-1 in x22 as S(31,32)
            sub     x23, x21, x2            // x-2 in x23 as S(31,32)

            asr     x0, x23, #16            // x-2 in x0 as S(47,16)
            asr     x1, x23, #16            // x-2 in x1 as S(47,16)
            smull   x0, w0, w1              // (x-2)^2 in x0 as S(31,32)

            asr     x0, x0, #16             // (x-2)^2 in x0 as S(47,16)
            smull   x0, w0, w1              // (x-2)^3 in x0 as S(31,32)
            asr     x0, x0, #16             // (x-2)^3 in x0 as S(47,16)
            smull   x24, w0, w1             // (x-2)^4 in x24 as S(31,32)

            asr     x0, x22, #16            // x-1 in x0 as S(47,16)
            asr     x1, x23, #16            // x-2 in x1 as S(47,16)
            smull   x25, w0, w1             // (x-2)(x-1) in x25 as S(31,32)

            mov     x0, #33
            lsl     x0, x0, #32             // 33 in x0 as S(31,32)

            add     x26, x24, x0            // (x-2)^4 + 33 in x26 as S(31,32)

            mov     x0, #11                 // x0 is 11 as U(64)
            lsl     x0, x0, #16
            asr     x1, x21, #16
            smull   x24, w1, w0            // x24 is 11x as S(31,32)

            asr     x0, x24, #16
            asr     x1, x25, #16

            smull   x0, w0, w1            // x0 is S(31,32)

            asr     x1, x26, #16

            sdiv    x0, x0, x1              // x0 is S(47,16)
            lsl     x0, x0, #16

            ldp     x21, x22, [sp], #16
            ldp     x23, x24, [sp], #16
            ldp     x25, x26, [sp], #16
            ldp     x29, x30, [sp], #16
            ret
//***********************************************


// 11x * ((x-2)*(x+1))/((x-2)^4 + 33) 

//***********************************************

            .global divide
divide:
        stp     x29, x30, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!

        mov     x2, xzr     // x2 is count
        mov     x3, xzr     // x3 is quotient

tp:
        cmp     x1, x0
        bge     bt
        add     w2, w2, #1
        lsl     x1, x1, #1
        b       tp
bt: 
        cmp     w2, wzr
        blt     rt

        cmp     x1, x0
        ble     div

        lsl     x3, x3, #1
        sub     w2, w2, #1
        asr     x1, x1, #1
        b       bt
div:          
        lsl     x3, x3, #1
        add     x3, x3, #1
        sub     x0, x0, x1
        sub     x2, x2, #1
        asr     x1, x1, #1
        b       bt
rt:
        mov     x0, x3
        ldp     x21, x22, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
        
//***********************************************

//***********************************************
            .global main
main:
            stp     x29, x30, [sp, #-16]!
            stp     x27, x28, [sp, #-16]!
            stp     x25, x26, [sp, #-16]!
            stp     x23, x24, [sp, #-16]!
            stp     x21, x22, [sp, #-16]!

            ldr     x0, =o1
            bl      printf      // print program message and prompt for lowest x value

            ldr     x0, =i1
            ldr     x1, =xLowS
            bl      scanf       // read lowest x value

            ldr     x0, =o2     
            bl      printf      // prompt for highest x value

            ldr     x0, =i1
            ldr     x1, =xHighS
            bl      scanf       // read highest x value

            ldr     x0, =o3     
            bl      printf      // prompt for number of rows

            ldr     x0, =i1
            ldr     x1, =rowsS
            bl      scanf       // read number of rows


            ldr     x0, =xLowS      // convert and store low as S(31,32)
            mov     x1, #32
            bl      strtoSfixed
            mov     x21, x0

            ldr     x0, =xHighS     // convert and store high as S(31,32)
            mov     x1, #32
            bl      strtoSfixed
            mov     x22, x0

            ldr     x0, =rowsS      // convert and store rows as S(31,32)
            mov     x1, #32
            bl      strtoSfixed
            mov     x23, x0

            // x low  is in x21 S(31,32)
            // x high is in x22 S(31,32)
            // rows   is in x23 S(31,32)

            lsr     x24, x23, #32
            // rows   is in x24 U(64)

            sub     x25, x22, x21
            // hi - lo   in x25 S(31,32)
            
            sdiv    x25, x25, x24
            // (hi-lo)/rows in x25 S(31,32)

            mov     x28, xzr 
            // increment starting at 0 in x28    


rw:
            cmp     w28, w24    // compare itr to rows
            bgt     dd          // branch if itr >= rows

            mov     x0, x21     // move current x to x0
            mov     x1, #32
            //bl      printS      // print current x
            mov     x2, #4
            bl      printSd

            ldr     x0, =i3
            bl      printf      // print whitespace

            // calculate f(x+itr)
            mov     x0, x21     // move current x to x0
            bl      fofx        // x0 is f(x) as S(31,32) 

            mov     x1, #32
            //bl      printS      // print f(x)
            mov     x2, #4
            bl      printSd

            ldr     x0, =nl     
            bl      printf      // print newline

            add     x21, x21, x25 // add x to move
            add     w28, w28, #1  // add to itr
            b     rw

dd:
            mov     x0, xzr
            ldp     x21, x22, [sp], #16
            ldp     x23, x24, [sp], #16
            ldp     x25, x26, [sp], #16
            ldp     x27, x28, [sp], #16
            ldp     x29, x30, [sp], #16
            ret
//***********************************************

