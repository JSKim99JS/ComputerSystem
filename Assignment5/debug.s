#include "uart_regs.h"
#include "uart_init.s"

.macro  DEBUGGER

	// store initial register value
	stmfd r13!, {r0 - r12, r14} // using stack
	add r0, r13, #0x38 // r0 contains initial r13
	sub r12, r15, #0x10 // r12 contains initial pc
	mrs r1, cpsr_all // r1 contains initial cpsr

	stmfd r13!, {r0, r1, r12}
	UART_init    // UART Initialization
	ldmfd r13!, {r0, r1, r12}

	ldr	r2, =uart_Channel_sts_reg0
	ldr r3, =uart_TX_RX_FIFO0
	mov r4, #0 // register number count

	mov r5, #101
	bl 21f // ------------
	bl 23f // crlf

    ////////////////////////////
1:
	bl 3f // r0
	bl 22f // ,sp

	bl 3f // r1
	bl 22f // ,sp

	bl 3f // r2
	bl 22f // ,sp

	bl 3f // r3
	bl 23f // crlf

	cmp r4, #16
	bne 1b

    ////////////////////////////
	bl 24f // Check to see if the Tx FIFO is empty
	mov r6, #0x63 // c
	str r6, [r3]

	mov r6, #0x70 // p
	str r6, [r3]

	mov r6, #0x73 // s
	str r6, [r3]

	mov r6, #0x72 // r
	str r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

	mov r6, #0x3D // =
	str r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

	and r7, r1, #0x80000000
	cmp r7, #0
	moveq r6, #0x6E // n
	movne r6, #0x4E // N
	str r6, [r3]

	and r7, r1, #0x40000000
	cmp r7, #0
	moveq r6, #0x7A // z
	movne r6, #0x5A // Z
	str r6, [r3]

	and r7, r1, #0x20000000
	cmp r7, #0
	moveq r6, #0x63 // c
	movne r6, #0x43 // C
	str r6, [r3]

	and r7, r1, #0x10000000
	cmp r7, #0
	moveq r6, #0x76 // v
	movne r6, #0x56 // V
	str r6, [r3]

	mov r6, #0x2C // ,
	str r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

	bl 24f //Check to see if the Tx FIFO is empty

	and r7, r1, #0x00000080
	cmp r7, #0
	moveq r6, #0x69 // i
	movne r6, #0x49 // I
	str r6, [r3]

	and r7, r1, #0x00000040
	cmp r7, #0
	moveq r6, #0x66 // f
	movne r6, #0x46 // F
	str r6, [r3]

	mov r6, #0x2C // ,
	str r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

	mov r7, r1, lsr #24 // J
	and r7, r7, #0x1
	mov r7, r7, lsl #1

	mov r8, r1, lsr #5 // T
	and r8, r8, #0x1

	add r7, r7, r8
	cmp r7, #0x0
	moveq r6, #0x41 // A
	streq r6, [r3]
	moveq r6, #0x52 // R
	streq r6, [r3]
	moveq r6, #0x4D // M
	streq r6, [r3]

	cmp r7, #0x1
	moveq r6, #0x54 // T
	streq r6, [r3]
	moveq r6, #0x68 // h
	streq r6, [r3]
	moveq r6, #0x75 // u
	streq r6, [r3]
	moveq r6, #0x6D // m
	streq r6, [r3]
	moveq r6, #0x62 // b
	streq r6, [r3]

	cmp r7, #0x2
	moveq r6, #0x4A // J
	streq r6, [r3]
	moveq r6, #0x61 // a
	streq r6, [r3]
	moveq r6, #0x7A // z
	streq r6, [r3]
	moveq r6, #0x65 // e
	streq r6, [r3]
	moveq r6, #0x6C // l
	streq r6, [r3]
	moveq r6, #0x6C // l
	streq r6, [r3]
	moveq r6, #0x65 // e
	streq r6, [r3]

	cmp r7, #0x3
	moveq r6, #0x54 // T
	streq r6, [r3]
	moveq r6, #0x68 // h
	streq r6, [r3]
	moveq r6, #0x75 // u
	streq r6, [r3]
	moveq r6, #0x6D // m
	streq r6, [r3]
	moveq r6, #0x62 // b
	streq r6, [r3]
	moveq r6, #0x45 // E
	streq r6, [r3]
	moveq r6, #0x45 // E
	streq r6, [r3]

	// mode, current mode =
	mov r6, #0x20 // space
	str r6, [r3]
	mov r6, #0x6D // m
	str r6, [r3]
	mov r6, #0x6F // o
	str r6, [r3]
	mov r6, #0x64 // d
	str r6, [r3]
	mov r6, #0x65 // e
	str r6, [r3]
	mov r6, #0x2C // ,
	str r6, [r3]
	mov r6, #0x20 // space
	str r6, [r3]
	mov r6, #0x63 // c
	str r6, [r3]
	mov r6, #0x75 // u
	str r6, [r3]
	mov r6, #0x72 // r
	str r6, [r3]
	mov r6, #0x72 // r
	str r6, [r3]
	mov r6, #0x65 // e
	str r6, [r3]
	mov r6, #0x6E // n
	str r6, [r3]
	mov r6, #0x74 // t
	str r6, [r3]
	mov r6, #0x20 // space
	str r6, [r3]
	mov r6, #0x6D // m
	str r6, [r3]
	mov r6, #0x6F // o
	str r6, [r3]
	mov r6, #0x64 // d
	str r6, [r3]
	mov r6, #0x65 // e
	str r6, [r3]
	mov r6, #0x20 // space
	str r6, [r3]
	mov r6, #0x3D // =
	str r6, [r3]
	mov r6, #0x20 // space
	str r6, [r3]

	and r7, r1, #0x1F

	cmp r7, #0x10
	moveq r6, #0x55 // U
	streq r6, [r3]
	moveq r6, #0x53 // S
	streq r6, [r3]
	moveq r6, #0x52 // R
	streq r6, [r3]

	cmp r7, #0x11
	moveq r6, #0x46 // F
	streq r6, [r3]
	moveq r6, #0x49 // I
	streq r6, [r3]
	moveq r6, #0x51 // Q
	streq r6, [r3]

	cmp r7, #0x12
	moveq r6, #0x49 // I
	streq r6, [r3]
	moveq r6, #0x52 // R
	streq r6, [r3]
	moveq r6, #0x51 // Q
	streq r6, [r3]

	cmp r7, #0x13
	moveq r6, #0x53 // S
	streq r6, [r3]
	moveq r6, #0x56 // V
	streq r6, [r3]
	moveq r6, #0x43 // C
	streq r6, [r3]

	cmp r7, #0x16
	moveq r6, #0x4D // M
	streq r6, [r3]
	moveq r6, #0x4F // O
	streq r6, [r3]
	moveq r6, #0x4E // N
	streq r6, [r3]

	cmp r7, #0x17
	moveq r6, #0x41 // A
	streq r6, [r3]
	moveq r6, #0x42 // B
	streq r6, [r3]
	moveq r6, #0x54 // T
	streq r6, [r3]

	cmp r7, #0x1A
	moveq r6, #0x48 // H
	streq r6, [r3]
	moveq r6, #0x59 // Y
	streq r6, [r3]
	moveq r6, #0x50 // P
	streq r6, [r3]

	cmp r7, #0x1B
	moveq r6, #0x55 // U
	streq r6, [r3]
	moveq r6, #0x4E // N
	streq r6, [r3]
	moveq r6, #0xEE // D
	streq r6, [r3]

	cmp r7, #0x1F
	moveq r6, #0x53 // S
	streq r6, [r3]
	moveq r6, #0x59 // Y
	streq r6, [r3]
	moveq r6, #0x53 // S
	streq r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

	mov r6, #0x28 // (
	str r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

	mov r6, #0x3D // =
	str r6, [r3]

	bl 24f // Check to see if the Tx FIFO is empty

	mov r7, r1
	bl 4f

	mov r6, #0x29 // )
	str r6, [r3]

	bl 23f // crlf

    ////////////////////////////
	mov r5, #88
	bl 21f // ------------
	bl 23f // crlf
	bl 23f // crlf

	bl 24f // Check to see if the Tx FIFO is empty

	b 6f

	////////////////////////////

21: // print '-'
 	//----------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r6, [r2]		// read Channel Status Register
	and	r6, r6, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r6, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	21b    			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	mov  r7, #0x2D
	strb r7, [r3]	// fill the TxFIFO with '-'
	sub  r5, r5, #1
	cmp  r5, #0
	bne  21b

	moveq  pc, lr		// return to the caller

22: // print comma and space
	 	//----------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r6, [r2]		// read Channel Status Register
	and	r6, r6, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r6, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	22b    			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	mov  r7, #0x2C
	strb r7, [r3]	// fill the TxFIFO with ','
	mov  r7, #0x20
	strb r7, [r3]	// fill the TxFIFO with 'SP'

	mov  pc, lr		// return to the caller

23: // print carriage return and line feed
	 	//----------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r6, [r2]		// read Channel Status Register
	and	r6, r6, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r6, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	23b    			// if TxFIFO is NOT empty, keep checking until it is empty
	//------------------------------------------------------------------------------

	mov  r7, #0x0D
	strb r7, [r3]	// fill the TxFIFO with 'cr'
	mov  r7, #0x0A
	strb r7, [r3]	// fill the TxFIFO with 'lf'

	mov  pc, lr		// return to the caller

24: // Check to see if the Tx FIFO is empty
	 	//----------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r6, [r2]		// read Channel Status Register
	and	r6, r6, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r6, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	24b    			// if TxFIFO is NOT empty, keep checking until it is empty

	moveq pc, lr
	//------------------------------------------------------------------------------

3: // 'r0 ='
	mov r6, #0x72 // r
	str r6, [r3]

	////// print register number//////////
	cmp r4, #0x9

	movgt r6, #0x31 // 10's digit is always 1
	strgt r6, [r3]
	addgt r6, r4, #0x26 // 1's digit ex) 0xA + 0x26 = 0x30('0')
	strgt r6, [r3]

	addle r6, r4, #0x30
	strle r6, [r3]
	//////////////////////////////////////

	//// put register value into r7 ////
	cmp r4, #13 // when r13
	moveq r7, r0
	beq 31f

	cmp r4, #15 // when r15
	moveq r7, r12
	beq 31f

	ldm r13!, {r7}

31:
	mov r6, #0x20 // space
	str r6, [r3]

	mov r6, #0x3D // =
	str r6, [r3]

	mov r6, #0x20 // space
	str r6, [r3]

4:
	mov r6, #0x30 // 0
	str r6, [r3]

	mov r6, #0x78 // x
	str r6, [r3]

	mov r8, #8 // for checking how many hex number is printed
    mov r9, #0xF0000000 // for masking that hex num
    mov r10, #28 // for shifting the extracted hex num

5: // 0000_0000
    and r11, r7, r9 // extract hex num
    mov r9, r9, lsr #4

    mov r11, r11, lsr r10 // shifting the hex num
    sub r10, r10, #4

    cmp r11, #0x9 // to identify if that number is alphabet of number
    addgt r11, r11, #0x57
    addle r11, r11, #0x30
    str r11, [r3]

    sub r8, r8, #1 // check how many hex num is printed

    cmp r8, #4 // after printing 4 hex number, print '_'
    moveq r11, #0x5F
    streq r11, [r3]

    cmp r8, #0
    bne 5b

	//// after printing 8 hex number,
	add r4, r4, #1 // regi num 카운트 증가
	mov pc, lr

6:
	nop
.endm
