///selection sort
//for(i = 0; i < 31; i++) {
//    minIndex = i;
//    for(j = i+1; j < 32; j++){
//        if(v[minIndex] > v[j]) minIndex = j;
//    }
//    tmp = v[i];
//    v[i] = v[minIndex];
//    v[minIndex] = tmp
//}

#include "debug.s"

.global main
main:

	ldr r0, =Input_data //r0 = i
	ldr r1, =Output_data

    /////////////////////////////
    mrs r12, cpsr_all
	stmfd r13!, {r0 - r12, r14}
	DEBUGGER
	.ltorg
	ldmfd r13!, {r0 - r12, r14}
	msr cpsr_all, r12

	add r2, r0, #124 //r2 = 31
	add r3, r0, #128 //r3 = 32

outside_loop:

    /////////////////////////////
    mrs r12, cpsr_all
	stmfd r13!, {r0 - r12, r14}
	DEBUGGER
	.ltorg
	ldmfd r13!, {r0 - r12, r14}
	msr cpsr_all, r12

	mov r4, r0 //r4 = minIndex = i
	add r5, r0, #4 //r5 = j = i+1

    /////////////////////////////
    mrs r12, cpsr_all
	stmfd r13!, {r0 - r12, r14}
	DEBUGGER
	.ltorg
	ldmfd r13!, {r0 - r12, r14}
	msr cpsr_all, r12

	ldr r6, [r4] //r6 = v[minIndex]
	inside_loop:

    	/////////////////////////////
    	mrs r12, cpsr_all
		stmfd r13!, {r0 - r12, r14}
		DEBUGGER
		.ltorg
		ldmfd r13!, {r0 - r12, r14}
		msr cpsr_all, r12

		ldr r7, [r5] //r7 = v[j]

    	/////////////////////////////
    	mrs r12, cpsr_all
		stmfd r13!, {r0 - r12, r14}
		DEBUGGER
		.ltorg
		ldmfd r13!, {r0 - r12, r14}
		msr cpsr_all, r12

		cmp r6, r7
		movge r4, r5 //if(v[minIndex] >= v[j]) minIndex = j;
		ldrge r6, [r4] //and v[minIndex] update

    	/////////////////////////////
    	mrs r12, cpsr_all
		stmfd r13!, {r0 - r12, r14}
		DEBUGGER
		.ltorg
		ldmfd r13!, {r0 - r12, r14}
		msr cpsr_all, r12

		add r5, r5, #4 //j++

    	/////////////////////////////
    	mrs r12, cpsr_all
		stmfd r13!, {r0 - r12, r14}
		DEBUGGER
		.ltorg
		ldmfd r13!, {r0 - r12, r14}
		msr cpsr_all, r12

		cmp r5, r3

    	/////////////////////////////
    	mrs r12, cpsr_all
		stmfd r13!, {r0 - r12, r14}
		DEBUGGER
		.ltorg
		ldmfd r13!, {r0 - r12, r14}
		msr cpsr_all, r12

		bne inside_loop //if(j != 32) goto inside_loop

	ldr r8, [r0] //r8 = tmp = v[i]
	str r6, [r0] //v[i] = v[minIndex]
	str r8, [r4] //v[minIndex] = tmp

	add r0, r0, #4 //i++

    /////////////////////////////
    mrs r12, cpsr_all
	stmfd r13!, {r0 - r12, r14}
	DEBUGGER
	.ltorg
	ldmfd r13!, {r0 - r12, r14}
	msr cpsr_all, r12

	cmp r0, r2
	bne outside_loop //if(i != 31) goto outside_loop

	ldr r0, =Input_data //r0 = i
moving_loop:

	ldr r2, [r0], #4 //load a word into r2 and update r0 (= r0 + 4)
	str r2, [r1], #4 //store the word to memory and update r1 (= r1 + 4)

    /////////////////////////////
    mrs r12, cpsr_all
	stmfd r13!, {r0 - r12, r14}
	DEBUGGER
	.ltorg
	ldmfd r13!, {r0 - r12, r14}
	msr cpsr_all, r12

	cmp r0, r3
	bne moving_loop //if(i != 32) goto moving_loop

forever:
	nop
 	b forever

.data
Input_data:
		.word 2, 0, -7, -1, 3, 8, -4, 10
		.word -9, -16, 15, 13, 1, 4, -3, 14
 		.word -8, -10, -15, 6, -13, -5, 9, 12
 		.word -11, -14, -6, 11, 5, 7, -2, -12

Output_data:
		.word 0, 0, 0, 0, 0, 0, 0, 0
 		.word 0, 0, 0, 0, 0, 0, 0, 0
		.word 0, 0, 0, 0, 0, 0, 0, 0
 		.word 0, 0, 0, 0, 0, 0, 0, 0
