#define csd_LED_ADDR 0x41200000
#define csd_SW_ADDR 0x41210000

.extern csd_main

.global main
main:

	ldr r0, =csd_LED_ADDR
	mov r1, #1 //LED turned on

loop:
	str r1, [r0]
	mov r1, r1, lsl #1
	bl sw_btn
	cmp r1, #256
	moveq r1, #1
	b loop

.data
.align 4
