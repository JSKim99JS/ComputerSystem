#include "csd_zynq_peripherals.h"

#define csd_SW_ADDR 0x41210000

.global main
main:

	// Read Cache Type Register (CTR)
	mrc p15, 0, r1, c0, c0, 1

	// Read Cache Level ID Register (CLIDR)
	mrc p15, 1, r2, c0, c0, 1

forever:
	ldr r3, =csd_SW_ADDR

	// extract the sw0 value
	ldr r5, [r3]
	bic r5, r5, #0b11111110
	mov r6, #0b00000001

	// if sw0 is 1, then enable the cache or disable
	cmp r5, r6
	bleq enable
	blne disable

	bl toggle

	b forever


enable:
	@------------------------
	@ Enable Caches (L2)
	@------------------------
	ldr r0, =L2_reg1_ctrl
    mov r1, #0x1
    str r1, [r0]

	@------------------------
	@ Enable Caches (IL1, DL1)
	@------------------------
	mrc		p15, 0, r0, c1, c0, 0	@ read control register (CP15 register1)
	orr		r0, r0, #(1<<12)	    @ Enable I bit (Instruction Cache)
	orr		r0, r0, #(1<<2)         @ Enable C bit (Data and Unified Caches)
	mcr		p15, 0, r0, c1, c0, 0	@ write control register (CP15 register2)

	mov pc, lr


disable:
	@------------------------
	@ Disable Caches (L2)
	@------------------------
	ldr r0, =L2_reg1_ctrl
	mov r1, #0x0
	str r1, [r0]
	@------------------------
	@ Disable Caches (IL1, DL1)
	@------------------------
	mrc		p15, 0, r0, c1, c0, 0	@ read control register (CP15 register1)
	bic		r0, r0, #4096		    @ disable I bit (Instruction Cache)
	bic		r0, r0, #4		        @ disable C bit (Data and Unified Caches)
	mcr		p15, 0, r0, c1, c0, 0	@ write control register (CP15 register2)

	mov pc, lr
