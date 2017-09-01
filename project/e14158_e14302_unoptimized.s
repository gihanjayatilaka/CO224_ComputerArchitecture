@CO224
@01/09/2014
@E14158 gihanchanaka@gmail.com E14302 hiruna72@gmail.com
@https://github.com/gihanchanaka/CO224_ComputerArchitecture


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

@	r4=noOFRows
@	r5=noOfCols
@	r6=oppcode

	sub	sp, sp, #4
	ldr	r0, =format_readInt
	mov	r1, sp	
	bl	scanf
	ldr	r4, [sp,#0]

	sub	sp, sp, #4
	ldr	r0, =format_readInt
	mov	r1, sp	
	bl	scanf
	ldr	r5, [sp,#0]

	sub	sp, sp, #4
	ldr	r0, =format_readInt
	mov	r1, sp	
	bl	scanf
	ldr	r6, [sp,#0]



@To see if this is an original 
	cmp r6, #0
	beq startReading
	bne checkWhetherAnInversion


@To see if this is an inversion
checkWhetherAnInversion: 
	cmp r6, #1
	beq startReading
	bne checkWhetherARotation

@To see if this is a rotation
checkWhetherARotation: 
	cmp r6, #2
	beq startReading
	bne checkWhetherAFlip

@To see if this is a flip 
checkWhetherAFlip:
	cmp r6, #3
	beq startReading
	bne notValidOppcode

@r8,r9 are used as the loop iteration variables in this program


@>>>>>>>>>>>>>Reading the image <<<<<<<<<<<<<<<<<<<<<<<<<
@loop initializing>> r7=noOfElements, r8=0
startReading:
	mul r7, r4, r5
	mov r8,#0

conditionCheck:
	cmp r7,r8
	beq loopTermination
	bal scan
increment:
	add r8,r8,#1
	bal conditionCheck	
scan:
	@allocate stack for input
	sub	sp, sp, #4
	@scanf to get an integer
	ldr	r0, =format_readInt
	mov	r1, sp	
	bl	scanf	@scanf("%d",sp)
	bal increment
loopTermination:
	


@>>>>>>>>>>SWICH CASE<<<<<<<<<<<<<<
@To see if this is an original 
	cmp r6, #0
	beq originalOperation

@To see if this is an inversion 
	cmp r6, #1
	beq inversionOperation

@To see if this is a rotation
checkWhetherARotation2: 
	cmp r6, #2
	beq rotationOperation
	bne checkWhetherAFlip2

@To see if this is a flip 
checkWhetherAFlip2:
	cmp r6, #3
	beq flipOperation
	bne notValidOppcode


@>>>>>>>>>>>>>ORIGINAL<<<<<<<<<<<<<<<<<<<<<,
originalOperation:
	ldr	r0, =format_Original
	bl 	printf



@	for(outerLoopInitialize;outerLoopCondtionCheck;outerLoopIncrement){
@		for(innerLoopInitialize;innerLoopIncrement;innerLoopCondtionCheck){
@			innerLoopFunction;
@		}
@		outerLoopFunction;
@	}

	
original_outerLoopInitialize:
	mov r8, #0
	bal original_outerLoopCondtionCheck

original_outerLoopCondtionCheck:
	cmp r8,r4
	bne original_innerLoopInitialize
	beq exit 

original_outerLoopFunction:
	ldr	r0, =formatOut
	bl 	printf
	bal original_outerLoopIncrement

original_outerLoopIncrement:
	add r8, r8, #1
	bal original_outerLoopCondtionCheck

original_innerLoopInitialize:
	mov r9, #0
	bal original_innerLoopCondtionCheck

original_innerLoopCondtionCheck:
	cmp r9,r5
	bne original_innerLoopFunction
	beq original_outerLoopFunction

original_innerLoopFunction:
	mov r10, r8
	mov r11, r9
	mul r12, r10, r5
	add r12, r12, r11
	mov r2, #4
	mul r0, r12, r2
	mov r12, r0;
	mul r0, r4, r5
	mul r10, r0, r2
	sub r12, r10, r12
	sub r12, r12, #4
	ldr r1, [sp,r12]
	ldr r0, =formatp
	bl printf

	bal original_innerLoopIncrement


original_innerLoopIncrement:
	add r9, r9, #1
	bal original_innerLoopCondtionCheck
@>>>>>>>>>>>>>ORIGINAL OVER<<<<<<<<<<<<<<<<<<<<<,


@>>>>>>>>>>>>>INVERT<<<<<<<<<<<<<<<<<<<<<,
inversionOperation:
	ldr	r0, =format_Inversion
	bl 	printf



@	for(outerLoopInitialize;outerLoopCondtionCheck;outerLoopIncrement){
@		for(innerLoopInitialize;innerLoopIncrement;innerLoopCondtionCheck){
@			innerLoopFunction;
@		}
@		outerLoopFunction;
@	}

	
inversion_outerLoopInitialize:
	mov r8, #0
	bal inversion_outerLoopCondtionCheck

inversion_outerLoopCondtionCheck:
	cmp r8,r4
	bne inversion_innerLoopInitialize
	beq exit 

inversion_outerLoopFunction:
	ldr	r0, =formatOut
	bl 	printf
	bal inversion_outerLoopIncrement

inversion_outerLoopIncrement:
	add r8, r8, #1
	bal inversion_outerLoopCondtionCheck

inversion_innerLoopInitialize:
	mov r9, #0
	bal inversion_innerLoopCondtionCheck

inversion_innerLoopCondtionCheck:
	cmp r9,r5
	bne inversion_innerLoopFunction
	beq inversion_outerLoopFunction

inversion_innerLoopFunction:
	mov r10, r8
	mov r11, r9
	mul r12, r10, r5
	add r12, r12, r11
	mov r2, #4
	mul r0, r12, r2
	mov r12, r0;
	mul r0, r4, r5
	mul r10, r0, r2
	sub r12, r10, r12
	sub r12, r12, #4
	ldr r1, [sp,r12]
	mov r10, #255
	sub r1, r10, r1
	ldr r0, =formatp
	bl printf

	bal inversion_innerLoopIncrement


inversion_innerLoopIncrement:
	add r9, r9, #1
	bal inversion_innerLoopCondtionCheck
@>>>>>>>>>>>>>INVERT OVER<<<<<<<<<<<<<<<<<<<<<,




@>>>>>>>>>>>>>RORARTION<<<<<<<<<<<<<<<<<<<<<,
rotationOperation:
	ldr	r0, =format_Rotation
	bl 	printf



@	for(outerLoopInitialize;outerLoopCondtionCheck;outerLoopIncrement){
@		for(innerLoopInitialize;innerLoopIncrement;innerLoopCondtionCheck){
@			innerLoopFunction;
@		}
@		outerLoopFunction;
@	}

	
rotation_outerLoopInitialize:
	mov r8, #0
	bal rotation_outerLoopCondtionCheck

rotation_outerLoopCondtionCheck:
	cmp r8,r4
	bne rotation_innerLoopInitialize
	beq exit 

rotation_outerLoopFunction:
	ldr	r0, =formatOut
	bl 	printf
	bal rotation_outerLoopIncrement

rotation_outerLoopIncrement:
	add r8, r8, #1
	bal rotation_outerLoopCondtionCheck

rotation_innerLoopInitialize:
	mov r9, #0
	bal rotation_innerLoopCondtionCheck

rotation_innerLoopCondtionCheck:
	cmp r9,r5
	bne rotation_innerLoopFunction
	beq rotation_outerLoopFunction

rotation_innerLoopFunction:
	sub r10, r4, r8
	sub r10, r10, #1
	sub r11, r5, r9
	sub r11, r11, #1
	mul r12, r10, r5
	add r12, r12, r11
	mov r2, #4
	mul r0, r12, r2
	mov r12, r0;
	mul r0, r4, r5
	mul r10, r0, r2
	sub r12, r10, r12
	sub r12, r12, #4

	ldr r1, [sp,r12]
	ldr r0, =formatp
	bl printf

	bal rotation_innerLoopIncrement


rotation_innerLoopIncrement:
	add r9, r9, #1
	bal rotation_innerLoopCondtionCheck
@>>>>>>>>>>>ROTATION OVER<<<<<<<<<<<<<<<<<<<<<<





@>>>>>>>>>>>>>FLIP<<<<<<<<<<<<<<<<<<<<<,
flipOperation:
	ldr	r0, =format_Flip
	bl 	printf



@	for(outerLoopInitialize;outerLoopCondtionCheck;outerLoopIncrement){
@		for(innerLoopInitialize;innerLoopIncrement;innerLoopCondtionCheck){
@			innerLoopFunction;
@		}
@		outerLoopFunction;
@	}

	
flip_outerLoopInitialize:
	mov r8, #0
	bal flip_outerLoopCondtionCheck

flip_outerLoopCondtionCheck:
	cmp r8,r4
	bne flip_innerLoopInitialize
	beq exit 

flip_outerLoopFunction:
	ldr	r0, =formatOut
	bl 	printf
	bal flip_outerLoopIncrement

flip_outerLoopIncrement:
	add r8, r8, #1
	bal flip_outerLoopCondtionCheck

flip_innerLoopInitialize:
	mov r9, #0
	bal flip_innerLoopCondtionCheck

flip_innerLoopCondtionCheck:
	cmp r9,r5
	bne flip_innerLoopFunction
	beq flip_outerLoopFunction

flip_innerLoopFunction:
	mov r10, r8
	sub r11, r5, r9
	sub r11, r11, #1
	mul r12, r10, r5
	add r12, r12, r11
	mov r2, #4
	mul r0, r12, r2
	mov r12, r0
	mul r0, r4, r5
	mul r10, r0, r2
	sub r12, r10, r12
	sub r12, r12, #4

	ldr r1, [sp,r12]
	ldr r0, =formatp
	bl printf

	bal flip_innerLoopIncrement


flip_innerLoopIncrement:
	add r9, r9, #1
	bal flip_innerLoopCondtionCheck

@>>>>>>>>>>>FLIP OVER<<<<<<<<<<<<<<<<<<<<<<





notValidOppcode:
	ldr r0, =format_InvalidOperation
	bl printf
	add sp, sp, #12
	bal exitFinal



exit: 
	mul r0, r4,r5
	add r0, r0, #3
	mov r1, #4
	mul r2, r1, r0
	add sp, sp, r2
	bal exitFinal

exitFinal:
    @ stack handling (pop lr from the stack) and return


	ldr	lr, [sp, #0]
	add	sp, sp, #4
	mov	pc, lr		
	
	
	.data	@ data memory	
format_readInt: .asciz "%d"
format_InvalidOperation: .asciz "Invalid operation\n"
format_Inversion: .asciz "Inversion\n"
format_Original: .asciz "Original\n"
format_Rotation: .asciz "Rotation by 180\n"
format_Flip: .asciz "Flip\n"
formatp: .asciz "%d "
formatOut: .asciz "\n"
