// ------------------------------------------
//  Author: Prof. Taeweon Suh
//          Computer Science & Engineering
//          College of Informatics, Korea Univ.
//  Date:   May 06, 2020
//  
//  It is based on Boot code in Xilinx SDK
// ------------------------------------------

.globl  csd_MMUTable_lv2
.section .csd_mmu_tbl_lv2,"a"

csd_MMUTable_lv2:
// figure2
//.word	0x400002
//.word	0x401002
//.word	0x402002
// addition output -> 1573376 = 0x18_0200
// figure3
.word	0x400002
.word	0x402002
.word	0x400002
// addition output -> 523776 = 0x7_fe00


.globl  csd_MMUTable
.section .csd_mmu_tbl,"a"

csd_MMUTable:
	/* Each table entry occupies one 32-bit word and there are
	 * 4096 entries, so the entire table takes up 16KB.
	 * Each entry covers a 1MB section.
	 *
	 * The following defines only 3 1MB sections
	 *     1st 1MB: 0x0000_0000 (VA) -> 0x0000_0000 (PA)
	 *     2nd 1MB: 0x0010_0000 (VA) -> 0x0020_0000 (PA)
	 *     3rd 1MB: 0x0020_0000 (VA) -> 0x0040_0000 (PA)
	 *     4th 1MB: 0x0030_0000 (VA) -> 0x0020_0000 (PA)
	 *     5th 1MB: 0x0040_0000 (VA) -> 0x0010_0000 (PA)
	 */
.set SECT, 0
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, SECT+0x100000
.word	SECT + 0x15de6		/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.set	SECT, SECT+0x400000
.word	csd_MMUTable_lv2 + 0x1e1	/* S=b1 TEX=b101 AP=b11, Domain=b1111, C=b0, B=b1 */
.end
