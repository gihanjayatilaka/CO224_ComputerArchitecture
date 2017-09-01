@ ARM Assembly example for using scanf("%d") and printf("%d")
@ Try this with characters (%c)

	.text	@ instruction memory
	
	.global main

main:
	@ stack handling
	@ push (store) lr to the stack
	sub	sp, sp, #4
	str	lr, [sp, #0]

readDims:

@reading the no of rows
	sub	sp, sp, #4
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf
	ldr	r1, [sp,#0]
	mov r4,r1

	@allocate stack for input
	sub	sp, sp, #4

	@scanf to get an integer
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)
	@r5 holds the number of columns
	ldr	r1, [sp, #0]
	mov r5,r1


	@allocate stack for input
	sub	sp, sp, #4

	@scanf to get an integer
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)
	@r6 holds the opCode
	ldr	r1, [sp, #0]
	mov r6,r1

	@r7 holds the number of elements
	mul r7,r4,r5

printTotal:
	mov r1,r7	
	ldr	r0, =formatElements
	bl 	printf

	mov r8,#0

loopScan:
	
	cmp r7,r8
	beq loopOut
	bal scan
mid:
	add r8,r8,#1
	bal loopScan	
scan:
	@allocate stack for input
	sub	sp, sp, #4

	@scanf to get an integer
	ldr	r0, =formats
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)
	bal mid
loopOut:
	




@printing the original matrix

ldr	r0, =formatOriginal
	bl 	printf

	mov r8,r4
	sub r8,r8,#1
outerLoopOriginal:
	cmp r8,#0
	blt loopOut200
	mov r9,r5
	sub r9,r9,#1
	bal printOutOriginal
mid200:
innerLoopOriginal:
	cmp r9,#0
	blt mid300
	mul r10,r5,r8
	add r10,r10,r9
	mov r2,#4
	mul r10,r2,r10
	ldr	r1, [sp,r10]
	bal printInOriginal
mid400:
	sub r9,r9,#1
	bal innerLoopOriginal

mid300:
	sub r8,r8,#1
	bal outerLoopOriginal

printOutOriginal:
	ldr	r0, =formatOut
	bl 	printf	
	bal mid200

printInOriginal:
	ldr	r0, =formatp
	bl 	printf	
	bal mid400

loopOut200:

ldr	r0, =formatOut
	bl 	printf


@invert operation starts here


ldr	r0, =formatInvert
	bl 	printf

mov r8,#0

outerLoopInvert:
	cmp r4,r8
	beq loopOut2
	mov r9,#0
	bal printOutInvert
mid2:
innerLoopInvert:
	cmp r9,r5
	beq mid3
	mul r10,r5,r8
	add r10,r10,r9
	mov r2,#4
	mul r10,r2,r10
	ldr	r1, [sp,r10]
	bal printInInvert
mid4:
	add r9,r9,#1
	bal innerLoopInvert

mid3:
	add r8,r8,#1
	bal outerLoopInvert

printOutInvert:
	ldr	r0, =formatOut
	bl 	printf	
	bal mid2

printInInvert:
	ldr	r0, =formatp
	bl 	printf	
	bal mid4

loopOut2:

ldr	r0, =formatOut
	bl 	printf


@flip operation starts here


ldr	r0, =formatFlip
	bl 	printf

	mov r8,r4
	sub r8,r8,#1
outerLoopFlip:
	cmp r8,#0
	blt loopOut20
	mov r9,#0
	bal printOutFlip
mid20:
innerLoopFlip:
	cmp r9,r5
	beq mid30
	mul r10,r5,r8
	add r10,r10,r9
	mov r2,#4
	mul r10,r2,r10
	ldr	r1, [sp,r10]
	bal printInFlip
mid40:
	add r9,r9,#1
	bal innerLoopFlip

mid30:
	sub r8,r8,#1
	bal outerLoopFlip

printOutFlip:
	ldr	r0, =formatOut
	bl 	printf	
	bal mid20

printInFlip:
	ldr	r0, =formatp
	bl 	printf	
	bal mid40



loopOut20:

	ldr	r0, =formatOut
	bl 	printf

	lsl r7,r7,#2
	add	sp, sp, r7
	@copy from stack to register
	ldr	r1, [sp,#0]
	
	@release stack
	add	sp, sp, #4

	@format for printf
	ldr	r0, =formatopCode
	bl 	printf

	@copy from stack to register
	ldr	r1, [sp,#0]
	
	@release stack
	add	sp, sp, #4

	@format for printf
	ldr	r0, =formatCol
	bl 	printf


	@copy from stack to register
	ldr	r1, [sp,#0]

	@release stack
	add	sp, sp, #4

	@format for printf
	ldr	r0, =formatRow
	bl 	printf

	mov r8,#0



exit: 
	
    @ stack handling (pop lr from the stack) and return
	ldr	lr, [sp, #0]
	add	sp, sp, #4
	mov	pc, lr		
	
	
	.data	@ data memory
formats: .asciz "%d"
formatp: .asciz " %d "
formatRow: .asciz "The numberOfRows is %d\n"
formatCol: .asciz "The numberOfCols is %d\n"
formatopCode: .asciz "The opCode is %d\n"
formatCheck: .asciz " check "
formatOut: .asciz "\n"
formatElements: .asciz "The numberOfElements is %d\n"
formatOriginal: .asciz "original"
formatFlip: .asciz "flip"
formatInvert: .asciz "invert"
