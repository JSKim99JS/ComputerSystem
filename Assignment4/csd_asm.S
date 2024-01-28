#include "uart_regs.h"
#include "uart_init.s"
#define   csd_LED_ADDR 0x41200000

.global main
main:
	UART_init     // UART Initialization

	ldr	r6, =uart_Channel_sts_reg0
	ldr r7, =uart_TX_RX_FIFO0
	ldr r8, =csd_LED_ADDR
	ldr r9, =selection // address of memory that stores selected number from the menu
	mov r10, #1 // LED turned on

	bl print_menu

check_empty:
	// check empty: bit#1 is Rx FIFO empty or not (1: empty, 0: not empty)
	ldr r1, [r6]
	and r1, r1, #1<<1
	cmp r1, #0b10
	beq check_empty // if empty, than go to check_empty

toss_selection:
	// read data and transmit it back to sender
	ldr r2, [r7]
	str r2, [r7]

	str r2, [r9] // store selected number from the menu

	mov r2, #0x0D // carriage return
	str r2, [r7]

	mov r2, #0x0A // line feed
	str r2, [r7]

	bl print_menu

loop:
	str r10, [r8]
	mov r10, r10, lsl #1

	ldr r0, [r9] // load 'selection' to r0 register so that duration.c can get the parameter 'selection'
	bl duration

	cmp r10, #256
	moveq r10, #1

	// check if user selected another or same number
	ldr r1, [r6]
	and r1, r1, #1<<1
	cmp r1, #0b10
	bne toss_selection // if yes(not empty), then go to toss_selection to echo that number on terminal

	b loop // else, just back to loop to rotate LEDs

print_menu:
	ldr r3, =menu
TX_loop:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r4, [r6]		// read Channel Status Register
	and	r4, r4, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r4, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop		// if TxFIFO is NOT empty, keep checking until it is empty
	//----------

	ldrb r5, [r3], #1
	strb r5, [r7]	// fill the TxFIFO with -(0x2D)
	cmp  r5, #0x00
	bne  TX_loop

	mov pc, lr

.data
menu:
	.ascii "----------------- LED On Duration ----------------"
	.byte 0x0D
	.byte 0x0A
	.ascii "1. 100ms 2. 200ms 3. 300ms 4. 400 ms"
	.byte 0x0D
	.byte 0x0A
	.ascii "5. 500ms 6. 600ms 7. 700ms 8. 1 sec"
	.byte 0x0D
	.byte 0x0A
	.ascii "---------------------------------------------------"
	.byte 0x0D
	.byte 0x0A
	.ascii "Select: "
	.byte 0x00

selection:
	.byte 0x00

