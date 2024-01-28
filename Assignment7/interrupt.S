#include "csd_zynq_peripherals.h"
#include "uart_regs.h"
#include "uart_init.s"

#define	TIMER_INITIAL	30000000

.align 5

csd_vector_table:
	b .
	b .
	b .
	b .
	b .
	b .
	b csd_IRQ_ISR
	b .

.global main
main:

	// Disable interrupt: CPSR'I = 1
	cpsID i

	cps #0x12	   	       // IRQ mode 
	ldr	r13,=irq_stack_top // Stack pointer setup for IRQ mode

	cps #0x1F	             // SYS mode 

	// Set VBAR (Vector Base Address Register) to my vector table
	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	// Enable interrupt: CPSR'I = 0
	cpsIE i

// ---------------------------
// Generic Interrupt Controller (GIC) setup - Begin
// ---------------------------

	// Distributor Control Register
	ldr r0, =GICD_CTLR
	ldr r1, [r0]
	mov r2, #1       // Enable
	orr r1, r1, r2
	str r1, [r0]
	//ldr r3, [r0]

	// Interrupt Set-Enable Register 0
	ldr r0, =GICD_ISENABLER0
	ldr r1, [r0]
	mov r2, #1 << 29   // Enable #29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	//ldr r3, [r0]

	// According to specifications, 
	// Cortex-A9 supports 5-bit version of priority format [7:3] in secure world
	// ( 0 -> 8 -> 16 -> 24...)

	// Interrupt Priority Register #7
	ldr r0, =GICD_PRIOR7
	ldr r1, [r0]
	mov r2, #0x10 << 8    // Priority 16 for ID# 29 (Private Timer)
	orr r1, r1, r2
	str r1, [r0]
	//ldr r3, [r0]

	// CPU Interface Control Register
	ldr r0, =GICC_CTLR
	ldr r1, [r0]
	mov r2, #1        // Enable
	orr r1, r1, r2
	str r1, [r0]
	//ldr r3, [r0]

 	// CPU Interface Interrupt Priority Mask Register
	ldr r0, =GICC_PMR
	ldr r1, [r0]
	mov r2, #0xFF     // Lowest
	orr r1, r1, r2
	str r1, [r0]
	//ldr r3, [r0]

// ---------------------------
// Generic Interrupt Controller (GIC) setup - End
// ---------------------------


// ---------------------------
// Private Timer setup - Begin
// ---------------------------

 	// Private Timer Load Register
	ldr r0, =PRIVATE_LOAD
 	ldr r1, =TIMER_INITIAL
 	str r1, [r0]

 	// Private Timer Control Register
  	ldr r0, =PRIVATE_CONTROL
 	mov r1, #10 << 8   // Prescalar 333Mhz / 11 = 30.3030Mhz = 30Mhz = 30,000,000
 	orr r1, r1, #7     // IRQ Enable, Auto-Reload, Timer Enable
 	str r1, [r0]

// ----------------------------
// Private Timer setup - End
// ----------------------------

	UART_init     // UART Initialization

	ldr r0, =PRIVATE_COUNTER
	ldr r1, =PRIVATE_STATUS
	ldr r2, =GICD_ISPENDR0
	ldr	r3, =uart_Channel_sts_reg0
	ldr r4, =uart_TX_RX_FIFO0

	// print 00: 00: 00
	ldr r5, =time
TX_loop1:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r6, [r3]		// read Channel Status Register
	and	r6, r6, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r6, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop1		// if TxFIFO is NOT empty, keep checking until it is empty
	//----------

	ldrb r7, [r5], #1
	strb r7, [r4]	// fill the TxFIFO with 0
	cmp  r7, #0x00
	bne  TX_loop1


forever:
	ldr r5, [r0]
	ldr r6, [r1]
	ldr r7, [r2]
	b forever

// Interrupt Service Routines (ISRs) - Begin
// ----------------------------

csd_IRQ_ISR:

	srsfd sp!, #0x12
	stmfd sp!, {r0-r12}

 	// Interrupt Ack
  	ldr r0, =GICC_IAR
	ldr r3, [r0]

 	// get_time (update time by 1sec)
 	ldr r0, =time
 	stmfd sp!, {r0-r12}
 	bl get_time
 	ldmfd sp!, {r0-r12}

 	// print_time
 	ldr	r1, =uart_Channel_sts_reg0
	ldr r2, =uart_TX_RX_FIFO0

TX_loop2:
	// ---------  Check to see if the Tx FIFO is empty ------------------------------
	ldr r4, [r1]		// read Channel Status Register
	and	r4, r4, #0x8	// read Transmit Buffer Empty bit(bit[3])
	cmp	r4, #0x8		// check if TxFIFO is empty and ready to receive new data
	bne	TX_loop2		// if TxFIFO is NOT empty, keep checking until it is empty
	//----------

	ldrb r5, [r0], #1
	strb r5, [r2]	// fill the TxFIFO with '0'
	cmp  r5, #0x00
	bne  TX_loop2

	// Clear Interrupt Status bit
  	ldr r0, =PRIVATE_STATUS
  	mov r1, #1
	str r1, [r0]

 	// End-of-Interrupt
  	ldr r0, =GICC_EOIR
	str r3, [r0]

	ldmfd sp!, {r0-r12}
	rfefd sp!
	subs pc, lr, #4

// ----------------------------
// Interrupt Service Routines (ISRs) - End
// ----------------------------

.data
time:
	.ascii "00: 00: 00"
	.byte 0x0D // carriage return - go to the front of the line
	.byte 0x00

irq_stack:     .space 1024
irq_stack_top:

