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


@>>>>>>>>>>SWICH CASE<<<<<<<<<<<<<<
@	switch(r6){
@		case 0,1,2,3: startReading();
@		case OTHER:print("Invalid operation");
@	}

	cmp r6, #0
	beq startReading
	cmp r6, #1
	beq startReading
	cmp r6, #2
	beq startReading
	cmp r6, #3
	beq startReading
	bne notValidOppcode
@>>>>>>>>>SWITCH CASE END<<<<<<<<<<






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
@>>>>>>>>>>>>>Reading the image is over<<<<<<<<<<<<<<<<<	




@>>>>>>>>>>>>>COMMON OPERATION<<<<<<<<<<<<<<<<<<<<<,

@	switch(r6){
@		case 0:print("Original");
@		case 1:print("Inversion");
@		case 2:print("Rotation by 180");
@		case 3:print("Flip");
@	}

commonOperation:



@>>>>>>>>>>SWICH CASE<<<<<<<<<<<<<<
	cmp r6, #0
	beq print_orginal
	cmp r6, #1
	beq print_inversion
	cmp r6, #2
	beq print_rotation
	bne print_flip
@>>>>>>>>>SWITCH CASE END<<<<<<<<<<	

print_orginal:
	ldr	r0, =format_Original
	bal printend
print_inversion:
	ldr	r0, =format_Inversion
	bal printend
print_rotation:
	ldr	r0, =format_Rotation
	bal printend
print_flip:
	ldr	r0, =format_Flip
	bal printend
printend:	
	bl 	printf

@	for(outerLoopInitialize;outerLoopCondtionCheck;outerLoopIncrement){
@		for(innerLoopInitialize;innerLoopIncrement;innerLoopCondtionCheck){
@			common_innerLoopFunction;
@			swicth(r6){	
@				case 0:original_innerLoopFunction
@				case 1:inversion_innerLoopFunction
@				case 2:rotation_innerLoopFunction
@				case 3:flip_innerLoopFunction
@			}
@			common_innerLoopFinalStatement;
@		}
@		outerLoopFunction;
@	}

	
common_outerLoopInitialize:
	mov r8, #0
	bal common_outerLoopCondtionCheck

common_outerLoopCondtionCheck:
	cmp r8,r4
	bne common_innerLoopInitialize
	beq exit 

common_outerLoopFunction:
	ldr	r0, =formatOut
	bl 	printf
	bal common_outerLoopIncrement

common_outerLoopIncrement:
	add r8, r8, #1
	bal common_outerLoopCondtionCheck

common_innerLoopInitialize:
	mov r9, #0
	bal common_innerLoopCondtionCheck

common_innerLoopCondtionCheck:
	cmp r9,r5
	bne common_innerLoopFunction
	beq common_outerLoopFunction


common_innerLoopFunction:
@>>>>>>>>>>SWICH CASE<<<<<<<<<<<<<<
	cmp r6, #0
	beq original_innerLoopFunction
	cmp r6, #1
	beq inversion_innerLoopFunction
	cmp r6, #2
	beq rotation_innerLoopFunction
	bne flip_innerLoopFunction
@>>>>>>>>>SWITCH CASE END<<<<<<<<<<	


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
	bal common_innerLoopFinalStatement


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
	bal common_innerLoopFinalStatement

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
	bal common_innerLoopFinalStatement


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
	bal common_innerLoopFinalStatement

common_innerLoopFinalStatement:
	ldr r0, =formatp
	bl printf
	bal common_innerLoopIncrement

common_innerLoopIncrement:
	add r9, r9, #1
	bal common_innerLoopCondtionCheck
@>>>>>>>>>>>>>COMMON OPERATION OVER<<<<<<<<<<<<<<<<<<<<<,





@>>>>>>>>>>>>>>>> STACK HANDLING<<<<<<<<<<<<<<<<<<<<<<
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
@>>>>>>>>>>>>>>>> STACK HANDLING OVER<<<<<<<<<<<<<<<<<	
	
	.data	@ data memory	
format_readInt: .asciz "%d"
format_InvalidOperation: .asciz "Invalid operation\n"
format_Inversion: .asciz "Inversion\n"
format_Original: .asciz "Original\n"
format_Rotation: .asciz "Rotation by 180\n"
format_Flip: .asciz "Flip\n"
formatp: .asciz "%d "
formatOut: .asciz "\n"
