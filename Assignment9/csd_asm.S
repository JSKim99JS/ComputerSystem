// ------------------------------------------
//  Author: Prof. Taeweon Suh
//          Computer Science & Engineering
//          College of Informatics, Korea Univ.
//  Date:   May 29, 2022
// ------------------------------------------

// Vector table base location should be aligned at 2^5
.align 5
// --------------------------
// Our interrupt vector table
// --------------------------
csd_vector_table:
	b .
	b .
	b .
	b csd_prefetch_abort
	b csd_data_abort
	b .
	b .
	b .

.global main
main:

	// -------------------------------------
	// Set VBAR (Vector Base Address Register) to 
	// the base location of our interrupt vector table
	// -------------------------------------
	ldr     r0, =csd_vector_table
	mcr     p15, 0, r0, c12, c0, 0
	dsb
	isb

	// read SCTLR (System Control Register) to r0
	mrc	p15, 0, r0, c1, c0, 0

	// read SCR (Secure Configuration Register) to r1
	mrc p15, 0, r1, c1, c1, 0

	// read TTBCR (Translation Table Base Control Register) to r2
	mrc p15, 0, r2, c2, c0, 2

	// read TTBR0 to r3
	mrc p15, 0, r3, c2, c0, 0

	// read DACR (Domain Access Control Register) to r4
	mrc p15, 0, r4, c3, c0, 0

	/* Disable MMU, if enabled */
	mrc	p15, 0, r0, c1, c0, 0		/* read CP15 register 1 */
	bic	r0, r0, #0x1			/* clear bit 0 */
	mcr	p15, 0, r0, c1, c0, 0		/* write value back */

	/* Invalidate caches and TLBs */
	mov	r0,#0				/* r0 = 0  */
	mcr	p15, 0, r0, c8, c7, 0		/* invalidate TLBs */
	mcr	p15, 0, r0, c7, c5, 0		/* invalidate icache */
	mcr	p15, 0, r0, c7, c5, 6		/* Invalidate branch predictor array */

// case A: turn on both (1) and (2): prefetch abort at "dsb"
// case B: turn on only (2): data abort at "ldr r6, [r0]  // read from 0x10_0000"

// ---------------------- (1) start --------------------------
// Its behavior:
// If $ and TLBs are invalidated and SW-exception handling is turned on,
// debugger hangs when executing dsb (right after MMU enable).
//
// My thought:
// If you let it go with entering F5 and suspend CPU
// then, it keeps executing the prefetch abort vector (because it can't find the translation info.?)
// so I guess it is an expected result...
// You should have at least a page with interrupt vector table already mapped.

/*
	// Invalidate caches and TLBs (from Boot.S)
	mov	r0,#0				// r0 = 0
	mcr	p15, 0, r0, c8, c7, 0		// invalidate TLBs
	mcr	p15, 0, r0, c7, c5, 0		// invalidate icache
	mcr	p15, 0, r0, c7, c5, 6		// Invalidate branch predictor array
*/
// ---------------------- (1) end --------------------------

    /* Begin: store some words to the start of each 1MB section */
    // flat mapping, storing data
	mov r0, #0x400000
	mov r1, #0x400000
	add r1, r1, #0x1000 // r1 <- 0x401000
	mov r2, #0x400000
	add r2, r2, #0x2000 // r2 <- 0x402000

	mov r3, #0x0
	sub r3, r3, #1024 // r3 <- -1024
	mov r4, #1
	mov r5, #1025

	mov r6, #2049

putting_data:
	str r3, [r0], #4
	str r4, [r1], #4
	str r5, [r2], #4

	add r3, r3, #1
	add r4, r4, #1
	add r5, r5, #1

	cmp r5, r6
	bne putting_data

    /* End */

	ldr	r0,=csd_MMUTable	   /* Load MMU translation table base */
	orr	r0, r0, #0x5B			/* Outer-cacheable, WB */
	mcr	15, 0, r0, c2, c0, 0		/* TTBR0 */

	// Clear PD0 in TTBCR (Translation Table Base Control Register)
	mrc p15, 0, r2, c2, c0, 2
	bic r2, r2, #(1<<4)   // Set PD0 to 0 = HW-based page table walk
	mcr p15, 0, r2, c2, c0, 2

// ---------------------- (2) start --------------------------
/*
    // Play with HW page walk or SW handling of TLB miss
	// Page Table Walk by HW or SW (translation fault)
	// TTBCR (Translation Table Base Control Register) PD1, PD0
	mrc p15, 0, r2, c2, c0, 2
	orr r2, r2, #(1<<5)   // Set PD1 to 1 = TLB miss generates a translation fault
	orr r2, r2, #(1<<4)   // Set PD0 to 1 = TLB miss generates a translation fault
	mcr p15, 0, r2, c2, c0, 2
*/
// ---------------------- (2) end --------------------------

	/* Enable MMU */
	// Set M-bit in SCTLR (System Control Register)
	mrc	p15, 0, r0, c1, c0, 0
	bic r0, r0, #(1<<12)  // I-bit = I$ disable
	bic r0, r0, #(1<<2)   // C-bit = $ disable
	orr r0, r0, #(1<<0)   // M-bit = MMU enable
	mcr	p15, 0, r0, c1, c0, 0	/* Enable MMU */
	dsb					        /* dsb	allow the MMU to start up */
	isb					        /* isb	flush prefetch buffer */

	// read SCTLR (System Control Register) to r0
	mrc	p15, 0, r0, c1, c0, 0

	// addition
	mov r0, #0x200000
	mov r1, #0x0
	mov r2, #0x200000
	add r2, r2, #0x3000

addition:
	ldr r3, [r0], #4
	add r1, r1, r3

	cmp r0, r2
	bne addition

	mov r4, r1

forever:
	nop
	b forever


csd_prefetch_abort:
	mrc p15, 0, r10, c6, c0, 2  // read IFAR to r10
	mrc p15, 0, r11, c5, c0, 1  // read IFSR to r11
	b .

csd_data_abort:
	mrc p15, 0, r10, c6, c0, 0  // read DFAR to r10
	mrc p15, 0, r11, c5, c0, 0  // read DFSR to r11
	b .
