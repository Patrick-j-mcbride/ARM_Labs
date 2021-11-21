/* color_to_gray will allocate a new grayimage structure and fill it
   with the grayscale equivalent of the given image.

   The C prototype is:

   grayimage *color_to_gray(rgbimage *image);
*/
		.data 
		.equ 		img, 0
		.equ 		wd, 8
		.equ 		ht, 12

m1:		.quad		54	
m2:		.quad		184
m3:		.quad		18
m4:		.quad		3
		.text

		.global	color_to_gray
color_to_gray:

		stp		x29, x30, [sp, #-16]!
		stp		x25, x26, [sp, #-16]!
		//---------------------------
		mov 	x26, x0	
		//---------------------------
		ldrsw	x0, [x26, wd] // load width // cols
		ldrsw 	x1, [x26, ht] // load height // rows
	   	//---------------------------
		bl		allocate_grayimage // make gray and put ptr in x0
		mov 	x25, x0
		//---------------------------
		ldrsw	x13, [x26, wd] // load width 
		ldrsw 	x12, [x26, ht] // load height
//--------------------------------------------
		mov 	x3, xzr// 0 oloop itr
//***********************************************************
oloop:	
		ldr 	x16, [x25]
		ldr 	x15, [x16, x3, lsl #3] // load gray row 
		ldr		x10, [x26, img]
		ldr 	x11, [x10, x3, lsl #3] // load rgb row
		mov 	x2, xzr// 0 iloop itr
//===========================================================
iloop:
		mov 	x7, #54
		mov 	x8, #184
		mov 	x9, #18
		
        mov     v0.d[0], xzr
        mov     v1.d[0], xzr
        mov     v2.d[0], xzr
        mov     v3.d[0], xzr  

        ld3     {v1.b, v2.b, v3.b} [0], [x11], #3
        mov     v4.2d[0], x7
        mul     v1.2s, v1.2s, v4.2s
        mov     v4.2d[0], x8
        mul     v2.2s, v2.2s, v4.2s
        mov     v4.2d[0], x9
        mul     v3.2s, v3.2s, v4.2s

        add     d0, d1, d2
        add     d0, d0, d3

        ushr    d0, d0, #8

        umov     w4, v0.b[0]
        strb	w4, [x15], #1 // store in col
		add 	w2, w2, #1// move iloop itr
		cmp 	x2, x13// iloop comp
		bne		iloop// iloop
//===========================================================
		

		add 	w3, w3, #1// move oloop itr
		cmp 	x3, x12// oloop comp
		bne		oloop// oloop
//***********************************************************
		
//--------------------------------------------------------
		mov		x0, x25 // put address of gray into x0
		ldp     x25, x26, [sp], #16
		ldp     x29, x30, [sp], #16 
		ret //return from function 












/* 





//ldr 	x1, [x26] 	// store ptr to array 
		//ldr 	x1, [x1] 	// store first ptr in array
		//ldr		x1, [x1] 	// store first ptr in array


		mov	x2, xzr 
		mov	x3, xzr
		add x2, x2, c
		add x3,x3,r 
		mul x4, x2, x3 										// x4 is total len

		ldr 	x0, [x25] 	// move to first 
		//ldr 	x0, [x0] 	// move to second

		mov 	x5, xzr		// x5 is outer loop itr
		//mov 	x10, xzr
		//mov 	x6, xzr		
		mov 	x7, xzr		
		mov 	x9, xzr		// temp

ol:	
	add x9, x0, x5
		//ldrb	w9, [x1]
		//add 	w10, w10, w9	// add r
		//add 	x6, x6, #54
		//mul		x9, x9, x6
		//add		x7, x7, x9
		//add 	x1, x1, #1

		//ldrb	w9, [x1]
		//add 	w10, w10, w9	// add g
		//add 	x6, x6, #184
		//mul		x9, x9, x6
		//add		x7, x7, x9
		//add 	x1, x1, #1

		//ldrb	w9, [x1]
		//add 	w10, w10, w9	// add b
		//add 	x6, x6, #18
		//mul		x9, x9, x6
		//add		x7, x7, x9
		//add 	x1, x1, #1

		//lsr		x7, x7, #8	// x7 is gray val
		and 	x7, x7, xzr
		add 	X7, X7, #220 
		strb	w7, [x9] // store gray
		//add 	x0, x0, #1

		add 	x5, x5, #1 	// move iterate 
		cmp		x5, c		// check itr
		bne		ol 			// branch untill done
*/