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

            mov     x21, x0 // S(31,32)

            mov     x1, #2
            lsl     x1, x1, #32 // x1 is 2.0

            sub     x23, x21, x1 // x23 is (x-2)

            mov     x1, #1
            lsl     x1, x1, #32 // x1 is 1.0

            add     x22, x21, x1 // x22 is (x+1)

            asr     x0, x0, #16
            asr     x1, x21, #16
            smull   x0, w21, w0
            mov     x1, x0

            asr     x0, x0, #16
            asr     x1, x1, #16
            smull   x24, w0, w1 // x24 is (x-2)^4

            asr     x0, x22, #16
            asr     x1, x23, #16
            smull     x22, w0, w1// x22 is (x-2)*(x+1))

            mov     x0, #33
            lsl     x0, x0, #32

            add     x1, x24, x0 // x0 is (x-2)^4 + 33
            lsl     x0, x22, #32
            asr     x1, x1, #16
            sdiv    x0, x0, x1 //bl      divide // x0 is ((x-2)*(x+1))/((x-2)^4 + 33)
            lsl     x0, x0, #16
            mov     x24, x0

            mov     x1, #11
            lsl     x1, x1, #16
            asr     x0, x21, #16
            smull     x0, w1, w21

            asr     x0, x0, #16
            asr     x1, x24, #16 

            smull     x0, w0, w1

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

            sub     x0, x22, x21        // High - Low as S(31,32)
            mov     x1, x23             // move rows to x1

            lsr     x1, x1, #32        // S(47,16)

            sdiv    x0, x0, x1         // mull 

            //bl      divide
            mov     x24, x0            // store increment 

            lsr     x27, x23, #32         // convert rows to integer 

            mov     x26, xzr
            mov     x25, x21            

rw:
            cmp     w26, w27  // compare itr to rows
            bge     dd
            mov     x0, x25
            mov     x1, #32
            bl      printS  // print x

            ldr     x0, =i3
            bl      printf  // print whitespace

            // calculate f(x+itr)
            mov     x0, x25
            bl      fofx

            mov     x1, #32// print f(x+itr)
            bl      printS

            ldr     x0, =nl // add newline 
            bl      printf  

            add     x25, x25, x24 // add move to xLow
            add     w26, w26, #1  // add to itr
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

