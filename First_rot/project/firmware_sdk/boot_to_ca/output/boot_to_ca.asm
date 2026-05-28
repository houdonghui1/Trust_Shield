
boot_to_ca.elf:     file format elf32-littlearm


Disassembly of section .text:

00000000 <__isr_vector>:
       0:	00022000 	andeq	r2, r2, r0
       4:	000007c1 	andeq	r0, r0, r1, asr #15
       8:	0000072f 	andeq	r0, r0, pc, lsr #14
       c:	00000731 	andeq	r0, r0, r1, lsr r7
      10:	00000733 	andeq	r0, r0, r3, lsr r7
      14:	00000735 	andeq	r0, r0, r5, lsr r7
      18:	00000737 	andeq	r0, r0, r7, lsr r7
	...
      2c:	00000739 	andeq	r0, r0, r9, lsr r7
      30:	0000073b 	andeq	r0, r0, fp, lsr r7
      34:	00000000 	andeq	r0, r0, r0
      38:	0000073d 	andeq	r0, r0, sp, lsr r7
      3c:	0000073f 	andeq	r0, r0, pc, lsr r7
      40:	00000741 	andeq	r0, r0, r1, asr #14
      44:	00000815 	andeq	r0, r0, r5, lsl r8
      48:	00000817 	andeq	r0, r0, r7, lsl r8
      4c:	00000819 	andeq	r0, r0, r9, lsl r8
      50:	0000081b 	andeq	r0, r0, fp, lsl r8
      54:	0000081d 	andeq	r0, r0, sp, lsl r8
      58:	0000081f 	andeq	r0, r0, pc, lsl r8
      5c:	00000821 	andeq	r0, r0, r1, lsr #16
      60:	00000823 	andeq	r0, r0, r3, lsr #16
      64:	00000825 	andeq	r0, r0, r5, lsr #16
      68:	00000827 	andeq	r0, r0, r7, lsr #16
      6c:	00000829 	andeq	r0, r0, r9, lsr #16
      70:	0000082b 	andeq	r0, r0, fp, lsr #16
      74:	0000082d 	andeq	r0, r0, sp, lsr #16
      78:	0000082f 	andeq	r0, r0, pc, lsr #16
      7c:	00000831 	andeq	r0, r0, r1, lsr r8
      80:	00000833 	andeq	r0, r0, r3, lsr r8
      84:	00000835 	andeq	r0, r0, r5, lsr r8

00000088 <__do_global_dtors_aux>:
      88:	b510      	push	{r4, lr}
      8a:	4c05      	ldr	r4, [pc, #20]	; (a0 <__do_global_dtors_aux+0x18>)
      8c:	7823      	ldrb	r3, [r4, #0]
      8e:	b933      	cbnz	r3, 9e <__do_global_dtors_aux+0x16>
      90:	4b04      	ldr	r3, [pc, #16]	; (a4 <__do_global_dtors_aux+0x1c>)
      92:	b113      	cbz	r3, 9a <__do_global_dtors_aux+0x12>
      94:	4804      	ldr	r0, [pc, #16]	; (a8 <__do_global_dtors_aux+0x20>)
      96:	f3af 8000 	nop.w
      9a:	2301      	movs	r3, #1
      9c:	7023      	strb	r3, [r4, #0]
      9e:	bd10      	pop	{r4, pc}
      a0:	0002006c 	andeq	r0, r2, ip, rrx
      a4:	00000000 	andeq	r0, r0, r0
      a8:	00001258 	andeq	r1, r0, r8, asr r2

000000ac <frame_dummy>:
      ac:	b508      	push	{r3, lr}
      ae:	4b03      	ldr	r3, [pc, #12]	; (bc <frame_dummy+0x10>)
      b0:	b11b      	cbz	r3, ba <frame_dummy+0xe>
      b2:	4903      	ldr	r1, [pc, #12]	; (c0 <frame_dummy+0x14>)
      b4:	4803      	ldr	r0, [pc, #12]	; (c4 <frame_dummy+0x18>)
      b6:	f3af 8000 	nop.w
      ba:	bd08      	pop	{r3, pc}
      bc:	00000000 	andeq	r0, r0, r0
      c0:	00020070 	andeq	r0, r2, r0, ror r0
      c4:	00001258 	andeq	r1, r0, r8, asr r2

000000c8 <set_fuses>:
      c8:	b570      	push	{r4, r5, r6, lr}
      ca:	4604      	mov	r4, r0
      cc:	f100 0510 	add.w	r5, r0, #16
      d0:	f44f 72a4 	mov.w	r2, #328	; 0x148
      d4:	2100      	movs	r1, #0
      d6:	4628      	mov	r0, r5
      d8:	f000 fbc2 	bl	860 <memset>
      dc:	4e0e      	ldr	r6, [pc, #56]	; (118 <set_fuses+0x50>)
      de:	f106 0e30 	add.w	lr, r6, #48	; 0x30
      e2:	46b4      	mov	ip, r6
      e4:	e8bc 000f 	ldmia.w	ip!, {r0, r1, r2, r3}
      e8:	6028      	str	r0, [r5, #0]
      ea:	6069      	str	r1, [r5, #4]
      ec:	60aa      	str	r2, [r5, #8]
      ee:	60eb      	str	r3, [r5, #12]
      f0:	4666      	mov	r6, ip
      f2:	3510      	adds	r5, #16
      f4:	45f4      	cmp	ip, lr
      f6:	d1f4      	bne.n	e2 <set_fuses+0x1a>
      f8:	4d08      	ldr	r5, [pc, #32]	; (11c <set_fuses+0x54>)
      fa:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
      fc:	6420      	str	r0, [r4, #64]	; 0x40
      fe:	6461      	str	r1, [r4, #68]	; 0x44
     100:	64a2      	str	r2, [r4, #72]	; 0x48
     102:	64e3      	str	r3, [r4, #76]	; 0x4c
     104:	cd0f      	ldmia	r5!, {r0, r1, r2, r3}
     106:	6520      	str	r0, [r4, #80]	; 0x50
     108:	6561      	str	r1, [r4, #84]	; 0x54
     10a:	65a2      	str	r2, [r4, #88]	; 0x58
     10c:	65e3      	str	r3, [r4, #92]	; 0x5c
     10e:	f245 533b 	movw	r3, #21819	; 0x553b
     112:	f8a4 3154 	strh.w	r3, [r4, #340]	; 0x154
     116:	bd70      	pop	{r4, r5, r6, pc}
     118:	000011e8 	andeq	r1, r0, r8, ror #3
     11c:	000011c8 	andeq	r1, r0, r8, asr #3

00000120 <caliptra_req_idev_csr_start>:
     120:	4a03      	ldr	r2, [pc, #12]	; (130 <caliptra_req_idev_csr_start+0x10>)
     122:	f8d2 30bc 	ldr.w	r3, [r2, #188]	; 0xbc
     126:	f043 0301 	orr.w	r3, r3, #1
     12a:	f8c2 30bc 	str.w	r3, [r2, #188]	; 0xbc
     12e:	4770      	bx	lr
     130:	30030000 	andcc	r0, r3, r0

00000134 <caliptra_configure_itrng_entropy>:
     134:	b430      	push	{r4, r5}
     136:	4d0d      	ldr	r5, [pc, #52]	; (16c <caliptra_configure_itrng_entropy+0x38>)
     138:	f8d5 4118 	ldr.w	r4, [r5, #280]	; 0x118
     13c:	ea4f 4c14 	mov.w	ip, r4, lsr #16
     140:	ea4f 4c0c 	mov.w	ip, ip, lsl #16
     144:	ea4c 0000 	orr.w	r0, ip, r0
     148:	f8c5 0118 	str.w	r0, [r5, #280]	; 0x118
     14c:	f8d5 0118 	ldr.w	r0, [r5, #280]	; 0x118
     150:	b280      	uxth	r0, r0
     152:	ea40 4001 	orr.w	r0, r0, r1, lsl #16
     156:	f8c5 0118 	str.w	r0, [r5, #280]	; 0x118
     15a:	f8d5 311c 	ldr.w	r3, [r5, #284]	; 0x11c
     15e:	0c1b      	lsrs	r3, r3, #16
     160:	041b      	lsls	r3, r3, #16
     162:	4313      	orrs	r3, r2
     164:	f8c5 311c 	str.w	r3, [r5, #284]	; 0x11c
     168:	bc30      	pop	{r4, r5}
     16a:	4770      	bx	lr
     16c:	30030000 	andcc	r0, r3, r0

00000170 <caliptra_set_wdt_timeout>:
     170:	4b02      	ldr	r3, [pc, #8]	; (17c <caliptra_set_wdt_timeout+0xc>)
     172:	f8c3 0110 	str.w	r0, [r3, #272]	; 0x110
     176:	f8c3 1114 	str.w	r1, [r3, #276]	; 0x114
     17a:	4770      	bx	lr
     17c:	30030000 	andcc	r0, r3, r0

00000180 <caliptra_ready_for_fuses>:
     180:	4b04      	ldr	r3, [pc, #16]	; (194 <caliptra_ready_for_fuses+0x14>)
     182:	6bdb      	ldr	r3, [r3, #60]	; 0x3c
     184:	f013 4f80 	tst.w	r3, #1073741824	; 0x40000000
     188:	d101      	bne.n	18e <caliptra_ready_for_fuses+0xe>
     18a:	2000      	movs	r0, #0
     18c:	4770      	bx	lr
     18e:	2001      	movs	r0, #1
     190:	4770      	bx	lr
     192:	bf00      	nop
     194:	30030000 	andcc	r0, r3, r0

00000198 <caliptra_init_fuses>:
     198:	b330      	cbz	r0, 1e8 <caliptra_init_fuses+0x50>
     19a:	b510      	push	{r4, lr}
     19c:	4604      	mov	r4, r0
     19e:	f7ff ffef 	bl	180 <caliptra_ready_for_fuses>
     1a2:	b320      	cbz	r0, 1ee <caliptra_init_fuses+0x56>
     1a4:	2300      	movs	r3, #0
     1a6:	e005      	b.n	1b4 <caliptra_init_fuses+0x1c>
     1a8:	f854 1023 	ldr.w	r1, [r4, r3, lsl #2]
     1ac:	4a13      	ldr	r2, [pc, #76]	; (1fc <caliptra_init_fuses+0x64>)
     1ae:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
     1b2:	3301      	adds	r3, #1
     1b4:	2b0b      	cmp	r3, #11
     1b6:	d9f7      	bls.n	1a8 <caliptra_init_fuses+0x10>
     1b8:	f104 0030 	add.w	r0, r4, #48	; 0x30
     1bc:	2300      	movs	r3, #0
     1be:	e005      	b.n	1cc <caliptra_init_fuses+0x34>
     1c0:	f850 1023 	ldr.w	r1, [r0, r3, lsl #2]
     1c4:	4a0e      	ldr	r2, [pc, #56]	; (200 <Stack_Size>)
     1c6:	f842 1023 	str.w	r1, [r2, r3, lsl #2]
     1ca:	3301      	adds	r3, #1
     1cc:	2b07      	cmp	r3, #7
     1ce:	d9f7      	bls.n	1c0 <caliptra_init_fuses+0x28>
     1d0:	f8b4 2144 	ldrh.w	r2, [r4, #324]	; 0x144
     1d4:	4b0b      	ldr	r3, [pc, #44]	; (204 <Stack_Size+0x4>)
     1d6:	f8c3 2348 	str.w	r2, [r3, #840]	; 0x348
     1da:	2201      	movs	r2, #1
     1dc:	f8c3 20b0 	str.w	r2, [r3, #176]	; 0xb0
     1e0:	f7ff ffce 	bl	180 <caliptra_ready_for_fuses>
     1e4:	b930      	cbnz	r0, 1f4 <caliptra_init_fuses+0x5c>
     1e6:	bd10      	pop	{r4, pc}
     1e8:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     1ec:	4770      	bx	lr
     1ee:	f06f 0001 	mvn.w	r0, #1
     1f2:	e7f8      	b.n	1e6 <caliptra_init_fuses+0x4e>
     1f4:	f06f 0002 	mvn.w	r0, #2
     1f8:	e7f5      	b.n	1e6 <caliptra_init_fuses+0x4e>
     1fa:	bf00      	nop
     1fc:	30030200 	andcc	r0, r3, r0, lsl #4
     200:	30030230 	andcc	r0, r3, r0, lsr r2
     204:	30030000 	andcc	r0, r3, r0

00000208 <drv_caliptra1x_init>:
     208:	b510      	push	{r4, lr}
     20a:	4604      	mov	r4, r0
     20c:	b991      	cbnz	r1, 234 <drv_caliptra1x_init+0x2c>
     20e:	f04f 4020 	mov.w	r0, #2684354560	; 0xa0000000
     212:	2100      	movs	r1, #0
     214:	f7ff ffac 	bl	170 <caliptra_set_wdt_timeout>
     218:	f64f 72ff 	movw	r2, #65535	; 0xffff
     21c:	4611      	mov	r1, r2
     21e:	2001      	movs	r0, #1
     220:	f7ff ff88 	bl	134 <caliptra_configure_itrng_entropy>
     224:	f104 0010 	add.w	r0, r4, #16
     228:	f7ff ffb6 	bl	198 <caliptra_init_fuses>
     22c:	4601      	mov	r1, r0
     22e:	b920      	cbnz	r0, 23a <drv_caliptra1x_init+0x32>
     230:	2000      	movs	r0, #0
     232:	bd10      	pop	{r4, pc}
     234:	f7ff ff74 	bl	120 <caliptra_req_idev_csr_start>
     238:	e7e9      	b.n	20e <drv_caliptra1x_init+0x6>
     23a:	4802      	ldr	r0, [pc, #8]	; (244 <drv_caliptra1x_init+0x3c>)
     23c:	f000 f830 	bl	2a0 <drv_uart_printf>
     240:	2001      	movs	r0, #1
     242:	e7f6      	b.n	232 <drv_caliptra1x_init+0x2a>
     244:	000011ac 	andeq	r1, r0, ip, lsr #3

00000248 <drv_check_rw_data>:
     248:	6001      	str	r1, [r0, #0]
     24a:	6803      	ldr	r3, [r0, #0]
     24c:	4293      	cmp	r3, r2
     24e:	d007      	beq.n	260 <drv_check_rw_data+0x18>
     250:	f04f 4380 	mov.w	r3, #1073741824	; 0x40000000
     254:	2001      	movs	r0, #1
     256:	6018      	str	r0, [r3, #0]
     258:	685a      	ldr	r2, [r3, #4]
     25a:	4402      	add	r2, r0
     25c:	601a      	str	r2, [r3, #0]
     25e:	4770      	bx	lr
     260:	2000      	movs	r0, #0
     262:	f04f 4380 	mov.w	r3, #1073741824	; 0x40000000
     266:	6018      	str	r0, [r3, #0]
     268:	4770      	bx	lr
	...

0000026c <vprintf>:
     26c:	b500      	push	{lr}
     26e:	b091      	sub	sp, #68	; 0x44
     270:	460a      	mov	r2, r1
     272:	4601      	mov	r1, r0
     274:	4668      	mov	r0, sp
     276:	f000 fc05 	bl	a84 <vsiprintf>
     27a:	2800      	cmp	r0, #0
     27c:	dc05      	bgt.n	28a <vprintf+0x1e>
     27e:	4668      	mov	r0, sp
     280:	f000 fbe2 	bl	a48 <strlen>
     284:	b011      	add	sp, #68	; 0x44
     286:	f85d fb04 	ldr.w	pc, [sp], #4
     28a:	4668      	mov	r0, sp
     28c:	f000 fbdc 	bl	a48 <strlen>
     290:	b2c2      	uxtb	r2, r0
     292:	4669      	mov	r1, sp
     294:	4801      	ldr	r0, [pc, #4]	; (29c <vprintf+0x30>)
     296:	f000 f88b 	bl	3b0 <drv_uart_putchars>
     29a:	e7f0      	b.n	27e <vprintf+0x12>
     29c:	00020088 	andeq	r0, r2, r8, lsl #1

000002a0 <drv_uart_printf>:
     2a0:	b40f      	push	{r0, r1, r2, r3}
     2a2:	b500      	push	{lr}
     2a4:	b083      	sub	sp, #12
     2a6:	a904      	add	r1, sp, #16
     2a8:	f851 0b04 	ldr.w	r0, [r1], #4
     2ac:	9101      	str	r1, [sp, #4]
     2ae:	f7ff ffdd 	bl	26c <vprintf>
     2b2:	b003      	add	sp, #12
     2b4:	f85d eb04 	ldr.w	lr, [sp], #4
     2b8:	b004      	add	sp, #16
     2ba:	4770      	bx	lr

000002bc <drv_uart_default_config>:
     2bc:	f44f 33e1 	mov.w	r3, #115200	; 0x1c200
     2c0:	6043      	str	r3, [r0, #4]
     2c2:	230f      	movs	r3, #15
     2c4:	7203      	strb	r3, [r0, #8]
     2c6:	2300      	movs	r3, #0
     2c8:	7243      	strb	r3, [r0, #9]
     2ca:	7283      	strb	r3, [r0, #10]
     2cc:	72c3      	strb	r3, [r0, #11]
     2ce:	7303      	strb	r3, [r0, #12]
     2d0:	7343      	strb	r3, [r0, #13]
     2d2:	2301      	movs	r3, #1
     2d4:	7383      	strb	r3, [r0, #14]
     2d6:	4770      	bx	lr

000002d8 <drv_uart_set_config>:
     2d8:	b508      	push	{r3, lr}
     2da:	6841      	ldr	r1, [r0, #4]
     2dc:	7a03      	ldrb	r3, [r0, #8]
     2de:	fb03 f201 	mul.w	r2, r3, r1
     2e2:	490e      	ldr	r1, [pc, #56]	; (31c <drv_uart_set_config+0x44>)
     2e4:	fbb1 f2f2 	udiv	r2, r1, r2
     2e8:	0419      	lsls	r1, r3, #16
     2ea:	ea41 5102 	orr.w	r1, r1, r2, lsl #20
     2ee:	7a43      	ldrb	r3, [r0, #9]
     2f0:	ea41 3103 	orr.w	r1, r1, r3, lsl #12
     2f4:	7a83      	ldrb	r3, [r0, #10]
     2f6:	ea41 21c3 	orr.w	r1, r1, r3, lsl #11
     2fa:	7ac3      	ldrb	r3, [r0, #11]
     2fc:	ea41 1143 	orr.w	r1, r1, r3, lsl #5
     300:	7b03      	ldrb	r3, [r0, #12]
     302:	ea41 1103 	orr.w	r1, r1, r3, lsl #4
     306:	7b42      	ldrb	r2, [r0, #13]
     308:	ea41 0182 	orr.w	r1, r1, r2, lsl #2
     30c:	7b82      	ldrb	r2, [r0, #14]
     30e:	4311      	orrs	r1, r2
     310:	6800      	ldr	r0, [r0, #0]
     312:	460a      	mov	r2, r1
     314:	3008      	adds	r0, #8
     316:	f7ff ff97 	bl	248 <drv_check_rw_data>
     31a:	bd08      	pop	{r3, pc}
     31c:	02625a00 	rsbeq	r5, r2, #0, 20

00000320 <drv_uart_init>:
     320:	b538      	push	{r3, r4, r5, lr}
     322:	4604      	mov	r4, r0
     324:	2500      	movs	r5, #0
     326:	7485      	strb	r5, [r0, #18]
     328:	74c5      	strb	r5, [r0, #19]
     32a:	f7ff ffd5 	bl	2d8 <drv_uart_set_config>
     32e:	7425      	strb	r5, [r4, #16]
     330:	74a5      	strb	r5, [r4, #18]
     332:	74e5      	strb	r5, [r4, #19]
     334:	6822      	ldr	r2, [r4, #0]
     336:	6853      	ldr	r3, [r2, #4]
     338:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     33c:	6053      	str	r3, [r2, #4]
     33e:	6822      	ldr	r2, [r4, #0]
     340:	6853      	ldr	r3, [r2, #4]
     342:	f423 7380 	bic.w	r3, r3, #256	; 0x100
     346:	6053      	str	r3, [r2, #4]
     348:	6822      	ldr	r2, [r4, #0]
     34a:	6853      	ldr	r3, [r2, #4]
     34c:	f443 7300 	orr.w	r3, r3, #512	; 0x200
     350:	6053      	str	r3, [r2, #4]
     352:	6822      	ldr	r2, [r4, #0]
     354:	6853      	ldr	r3, [r2, #4]
     356:	f423 7300 	bic.w	r3, r3, #512	; 0x200
     35a:	6053      	str	r3, [r2, #4]
     35c:	6822      	ldr	r2, [r4, #0]
     35e:	6853      	ldr	r3, [r2, #4]
     360:	f443 6380 	orr.w	r3, r3, #1024	; 0x400
     364:	6053      	str	r3, [r2, #4]
     366:	6822      	ldr	r2, [r4, #0]
     368:	6853      	ldr	r3, [r2, #4]
     36a:	f423 6380 	bic.w	r3, r3, #1024	; 0x400
     36e:	6053      	str	r3, [r2, #4]
     370:	6822      	ldr	r2, [r4, #0]
     372:	6853      	ldr	r3, [r2, #4]
     374:	f443 6300 	orr.w	r3, r3, #2048	; 0x800
     378:	6053      	str	r3, [r2, #4]
     37a:	6822      	ldr	r2, [r4, #0]
     37c:	6853      	ldr	r3, [r2, #4]
     37e:	f423 6300 	bic.w	r3, r3, #2048	; 0x800
     382:	6053      	str	r3, [r2, #4]
     384:	6823      	ldr	r3, [r4, #0]
     386:	f240 12ff 	movw	r2, #511	; 0x1ff
     38a:	611a      	str	r2, [r3, #16]
     38c:	6823      	ldr	r3, [r4, #0]
     38e:	611d      	str	r5, [r3, #16]
     390:	6822      	ldr	r2, [r4, #0]
     392:	6853      	ldr	r3, [r2, #4]
     394:	f043 0301 	orr.w	r3, r3, #1
     398:	6053      	str	r3, [r2, #4]
     39a:	6822      	ldr	r2, [r4, #0]
     39c:	6853      	ldr	r3, [r2, #4]
     39e:	f023 0301 	bic.w	r3, r3, #1
     3a2:	6053      	str	r3, [r2, #4]
     3a4:	6822      	ldr	r2, [r4, #0]
     3a6:	6853      	ldr	r3, [r2, #4]
     3a8:	f043 0302 	orr.w	r3, r3, #2
     3ac:	6053      	str	r3, [r2, #4]
     3ae:	bd38      	pop	{r3, r4, r5, pc}

000003b0 <drv_uart_putchars>:
     3b0:	b410      	push	{r4}
     3b2:	2300      	movs	r3, #0
     3b4:	7483      	strb	r3, [r0, #18]
     3b6:	f890 c012 	ldrb.w	ip, [r0, #18]
     3ba:	4594      	cmp	ip, r2
     3bc:	d20c      	bcs.n	3d8 <drv_uart_putchars+0x28>
     3be:	6804      	ldr	r4, [r0, #0]
     3c0:	6963      	ldr	r3, [r4, #20]
     3c2:	0a1b      	lsrs	r3, r3, #8
     3c4:	f013 0f18 	tst.w	r3, #24
     3c8:	d1f5      	bne.n	3b6 <drv_uart_putchars+0x6>
     3ca:	f10c 0301 	add.w	r3, ip, #1
     3ce:	7483      	strb	r3, [r0, #18]
     3d0:	f811 300c 	ldrb.w	r3, [r1, ip]
     3d4:	6023      	str	r3, [r4, #0]
     3d6:	e7ee      	b.n	3b6 <drv_uart_putchars+0x6>
     3d8:	6803      	ldr	r3, [r0, #0]
     3da:	699a      	ldr	r2, [r3, #24]
     3dc:	f412 7f80 	tst.w	r2, #256	; 0x100
     3e0:	d0fa      	beq.n	3d8 <drv_uart_putchars+0x28>
     3e2:	691a      	ldr	r2, [r3, #16]
     3e4:	f442 7280 	orr.w	r2, r2, #256	; 0x100
     3e8:	611a      	str	r2, [r3, #16]
     3ea:	6803      	ldr	r3, [r0, #0]
     3ec:	2200      	movs	r2, #0
     3ee:	611a      	str	r2, [r3, #16]
     3f0:	bc10      	pop	{r4}
     3f2:	4770      	bx	lr

000003f4 <drv_uart_putchar>:
     3f4:	6802      	ldr	r2, [r0, #0]
     3f6:	6953      	ldr	r3, [r2, #20]
     3f8:	0a1b      	lsrs	r3, r3, #8
     3fa:	f013 0f18 	tst.w	r3, #24
     3fe:	d101      	bne.n	404 <drv_uart_putchar+0x10>
     400:	780b      	ldrb	r3, [r1, #0]
     402:	6013      	str	r3, [r2, #0]
     404:	6803      	ldr	r3, [r0, #0]
     406:	699a      	ldr	r2, [r3, #24]
     408:	f412 7f80 	tst.w	r2, #256	; 0x100
     40c:	d0fa      	beq.n	404 <drv_uart_putchar+0x10>
     40e:	691a      	ldr	r2, [r3, #16]
     410:	f442 7280 	orr.w	r2, r2, #256	; 0x100
     414:	611a      	str	r2, [r3, #16]
     416:	6803      	ldr	r3, [r0, #0]
     418:	2200      	movs	r2, #0
     41a:	611a      	str	r2, [r3, #16]
     41c:	4770      	bx	lr

0000041e <drv_uart_getchar>:
     41e:	b410      	push	{r4}
     420:	e009      	b.n	436 <drv_uart_getchar+0x18>
     422:	69db      	ldr	r3, [r3, #28]
     424:	700b      	strb	r3, [r1, #0]
     426:	2000      	movs	r0, #0
     428:	bc10      	pop	{r4}
     42a:	4770      	bx	lr
     42c:	6803      	ldr	r3, [r0, #0]
     42e:	695a      	ldr	r2, [r3, #20]
     430:	f012 0f1f 	tst.w	r2, #31
     434:	d1f5      	bne.n	422 <drv_uart_getchar+0x4>
     436:	6803      	ldr	r3, [r0, #0]
     438:	699c      	ldr	r4, [r3, #24]
     43a:	691a      	ldr	r2, [r3, #16]
     43c:	f042 02c0 	orr.w	r2, r2, #192	; 0xc0
     440:	611a      	str	r2, [r3, #16]
     442:	6803      	ldr	r3, [r0, #0]
     444:	2200      	movs	r2, #0
     446:	611a      	str	r2, [r3, #16]
     448:	b2a3      	uxth	r3, r4
     44a:	f014 0f40 	tst.w	r4, #64	; 0x40
     44e:	d001      	beq.n	454 <drv_uart_getchar+0x36>
     450:	2201      	movs	r2, #1
     452:	7402      	strb	r2, [r0, #16]
     454:	f013 0f80 	tst.w	r3, #128	; 0x80
     458:	d001      	beq.n	45e <drv_uart_getchar+0x40>
     45a:	2302      	movs	r3, #2
     45c:	7403      	strb	r3, [r0, #16]
     45e:	7c03      	ldrb	r3, [r0, #16]
     460:	2b00      	cmp	r3, #0
     462:	d0e3      	beq.n	42c <drv_uart_getchar+0xe>
     464:	7a83      	ldrb	r3, [r0, #10]
     466:	2b01      	cmp	r3, #1
     468:	d0e0      	beq.n	42c <drv_uart_getchar+0xe>
     46a:	2300      	movs	r3, #0
     46c:	7403      	strb	r3, [r0, #16]
     46e:	7483      	strb	r3, [r0, #18]
     470:	74c3      	strb	r3, [r0, #19]
     472:	6804      	ldr	r4, [r0, #0]
     474:	6862      	ldr	r2, [r4, #4]
     476:	f442 7280 	orr.w	r2, r2, #256	; 0x100
     47a:	6062      	str	r2, [r4, #4]
     47c:	6804      	ldr	r4, [r0, #0]
     47e:	6862      	ldr	r2, [r4, #4]
     480:	f422 7280 	bic.w	r2, r2, #256	; 0x100
     484:	6062      	str	r2, [r4, #4]
     486:	6804      	ldr	r4, [r0, #0]
     488:	6862      	ldr	r2, [r4, #4]
     48a:	f442 7200 	orr.w	r2, r2, #512	; 0x200
     48e:	6062      	str	r2, [r4, #4]
     490:	6804      	ldr	r4, [r0, #0]
     492:	6862      	ldr	r2, [r4, #4]
     494:	f422 7200 	bic.w	r2, r2, #512	; 0x200
     498:	6062      	str	r2, [r4, #4]
     49a:	6804      	ldr	r4, [r0, #0]
     49c:	6862      	ldr	r2, [r4, #4]
     49e:	f442 6280 	orr.w	r2, r2, #1024	; 0x400
     4a2:	6062      	str	r2, [r4, #4]
     4a4:	6804      	ldr	r4, [r0, #0]
     4a6:	6862      	ldr	r2, [r4, #4]
     4a8:	f422 6280 	bic.w	r2, r2, #1024	; 0x400
     4ac:	6062      	str	r2, [r4, #4]
     4ae:	6804      	ldr	r4, [r0, #0]
     4b0:	6862      	ldr	r2, [r4, #4]
     4b2:	f442 6200 	orr.w	r2, r2, #2048	; 0x800
     4b6:	6062      	str	r2, [r4, #4]
     4b8:	6800      	ldr	r0, [r0, #0]
     4ba:	6842      	ldr	r2, [r0, #4]
     4bc:	f422 6200 	bic.w	r2, r2, #2048	; 0x800
     4c0:	6042      	str	r2, [r0, #4]
     4c2:	700b      	strb	r3, [r1, #0]
     4c4:	2001      	movs	r0, #1
     4c6:	e7af      	b.n	428 <drv_uart_getchar+0xa>

000004c8 <uart_int_tx_done_callback>:
     4c8:	4770      	bx	lr

000004ca <uart_int_rx_stop_callback>:
     4ca:	4770      	bx	lr

000004cc <uart_int_rx_parity_error_callback>:
     4cc:	4770      	bx	lr

000004ce <uart_int_rx_noise_detect_callback>:
     4ce:	4770      	bx	lr

000004d0 <uart_int_rx_stop_detect_callback>:
     4d0:	4770      	bx	lr

000004d2 <uart_int_tx_fifo_empty_callback>:
     4d2:	4770      	bx	lr

000004d4 <uart_int_tx_fifo_thres_callback>:
     4d4:	4770      	bx	lr

000004d6 <uart_int_rx_fifo_noempty_callback>:
     4d6:	4770      	bx	lr

000004d8 <uart_int_rx_fifo_thres_callback>:
     4d8:	4770      	bx	lr

000004da <drv_uart_interrupt_handler>:
     4da:	b538      	push	{r3, r4, r5, lr}
     4dc:	4604      	mov	r4, r0
     4de:	6803      	ldr	r3, [r0, #0]
     4e0:	699d      	ldr	r5, [r3, #24]
     4e2:	68db      	ldr	r3, [r3, #12]
     4e4:	b29b      	uxth	r3, r3
     4e6:	401d      	ands	r5, r3
     4e8:	f415 7f80 	tst.w	r5, #256	; 0x100
     4ec:	d144      	bne.n	578 <drv_uart_interrupt_handler+0x9e>
     4ee:	f015 0f40 	tst.w	r5, #64	; 0x40
     4f2:	d00f      	beq.n	514 <drv_uart_interrupt_handler+0x3a>
     4f4:	2301      	movs	r3, #1
     4f6:	7423      	strb	r3, [r4, #16]
     4f8:	7aa3      	ldrb	r3, [r4, #10]
     4fa:	2b01      	cmp	r3, #1
     4fc:	d147      	bne.n	58e <drv_uart_interrupt_handler+0xb4>
     4fe:	4620      	mov	r0, r4
     500:	f7ff ffe3 	bl	4ca <uart_int_rx_stop_callback>
     504:	6822      	ldr	r2, [r4, #0]
     506:	6913      	ldr	r3, [r2, #16]
     508:	f043 0340 	orr.w	r3, r3, #64	; 0x40
     50c:	6113      	str	r3, [r2, #16]
     50e:	6823      	ldr	r3, [r4, #0]
     510:	2200      	movs	r2, #0
     512:	611a      	str	r2, [r3, #16]
     514:	f015 0f80 	tst.w	r5, #128	; 0x80
     518:	d00f      	beq.n	53a <drv_uart_interrupt_handler+0x60>
     51a:	2302      	movs	r3, #2
     51c:	7423      	strb	r3, [r4, #16]
     51e:	7aa3      	ldrb	r3, [r4, #10]
     520:	2b01      	cmp	r3, #1
     522:	d166      	bne.n	5f2 <drv_uart_interrupt_handler+0x118>
     524:	4620      	mov	r0, r4
     526:	f7ff ffd1 	bl	4cc <uart_int_rx_parity_error_callback>
     52a:	6822      	ldr	r2, [r4, #0]
     52c:	6913      	ldr	r3, [r2, #16]
     52e:	f043 0380 	orr.w	r3, r3, #128	; 0x80
     532:	6113      	str	r3, [r2, #16]
     534:	6823      	ldr	r3, [r4, #0]
     536:	2200      	movs	r2, #0
     538:	611a      	str	r2, [r3, #16]
     53a:	f015 0f20 	tst.w	r5, #32
     53e:	f040 808a 	bne.w	656 <drv_uart_interrupt_handler+0x17c>
     542:	f015 0f10 	tst.w	r5, #16
     546:	f040 8092 	bne.w	66e <drv_uart_interrupt_handler+0x194>
     54a:	f015 0f01 	tst.w	r5, #1
     54e:	f040 809a 	bne.w	686 <drv_uart_interrupt_handler+0x1ac>
     552:	f015 0f02 	tst.w	r5, #2
     556:	f040 80a2 	bne.w	69e <drv_uart_interrupt_handler+0x1c4>
     55a:	f015 0f04 	tst.w	r5, #4
     55e:	f000 80c1 	beq.w	6e4 <drv_uart_interrupt_handler+0x20a>
     562:	7ce2      	ldrb	r2, [r4, #19]
     564:	7e23      	ldrb	r3, [r4, #24]
     566:	429a      	cmp	r2, r3
     568:	f0c0 80ac 	bcc.w	6c4 <drv_uart_interrupt_handler+0x1ea>
     56c:	6822      	ldr	r2, [r4, #0]
     56e:	68d3      	ldr	r3, [r2, #12]
     570:	f023 030c 	bic.w	r3, r3, #12
     574:	60d3      	str	r3, [r2, #12]
     576:	e0aa      	b.n	6ce <drv_uart_interrupt_handler+0x1f4>
     578:	f7ff ffa6 	bl	4c8 <uart_int_tx_done_callback>
     57c:	6822      	ldr	r2, [r4, #0]
     57e:	6913      	ldr	r3, [r2, #16]
     580:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     584:	6113      	str	r3, [r2, #16]
     586:	6823      	ldr	r3, [r4, #0]
     588:	2200      	movs	r2, #0
     58a:	611a      	str	r2, [r3, #16]
     58c:	e7af      	b.n	4ee <drv_uart_interrupt_handler+0x14>
     58e:	6822      	ldr	r2, [r4, #0]
     590:	68d3      	ldr	r3, [r2, #12]
     592:	f023 03cc 	bic.w	r3, r3, #204	; 0xcc
     596:	60d3      	str	r3, [r2, #12]
     598:	2300      	movs	r3, #0
     59a:	7423      	strb	r3, [r4, #16]
     59c:	74a3      	strb	r3, [r4, #18]
     59e:	74e3      	strb	r3, [r4, #19]
     5a0:	6822      	ldr	r2, [r4, #0]
     5a2:	6853      	ldr	r3, [r2, #4]
     5a4:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     5a8:	6053      	str	r3, [r2, #4]
     5aa:	6822      	ldr	r2, [r4, #0]
     5ac:	6853      	ldr	r3, [r2, #4]
     5ae:	f423 7380 	bic.w	r3, r3, #256	; 0x100
     5b2:	6053      	str	r3, [r2, #4]
     5b4:	6822      	ldr	r2, [r4, #0]
     5b6:	6853      	ldr	r3, [r2, #4]
     5b8:	f443 7300 	orr.w	r3, r3, #512	; 0x200
     5bc:	6053      	str	r3, [r2, #4]
     5be:	6822      	ldr	r2, [r4, #0]
     5c0:	6853      	ldr	r3, [r2, #4]
     5c2:	f423 7300 	bic.w	r3, r3, #512	; 0x200
     5c6:	6053      	str	r3, [r2, #4]
     5c8:	6822      	ldr	r2, [r4, #0]
     5ca:	6853      	ldr	r3, [r2, #4]
     5cc:	f443 6380 	orr.w	r3, r3, #1024	; 0x400
     5d0:	6053      	str	r3, [r2, #4]
     5d2:	6822      	ldr	r2, [r4, #0]
     5d4:	6853      	ldr	r3, [r2, #4]
     5d6:	f423 6380 	bic.w	r3, r3, #1024	; 0x400
     5da:	6053      	str	r3, [r2, #4]
     5dc:	6822      	ldr	r2, [r4, #0]
     5de:	6853      	ldr	r3, [r2, #4]
     5e0:	f443 6300 	orr.w	r3, r3, #2048	; 0x800
     5e4:	6053      	str	r3, [r2, #4]
     5e6:	6822      	ldr	r2, [r4, #0]
     5e8:	6853      	ldr	r3, [r2, #4]
     5ea:	f423 6300 	bic.w	r3, r3, #2048	; 0x800
     5ee:	6053      	str	r3, [r2, #4]
     5f0:	e785      	b.n	4fe <drv_uart_interrupt_handler+0x24>
     5f2:	6822      	ldr	r2, [r4, #0]
     5f4:	68d3      	ldr	r3, [r2, #12]
     5f6:	f023 03cc 	bic.w	r3, r3, #204	; 0xcc
     5fa:	60d3      	str	r3, [r2, #12]
     5fc:	2300      	movs	r3, #0
     5fe:	7423      	strb	r3, [r4, #16]
     600:	74a3      	strb	r3, [r4, #18]
     602:	74e3      	strb	r3, [r4, #19]
     604:	6822      	ldr	r2, [r4, #0]
     606:	6853      	ldr	r3, [r2, #4]
     608:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     60c:	6053      	str	r3, [r2, #4]
     60e:	6822      	ldr	r2, [r4, #0]
     610:	6853      	ldr	r3, [r2, #4]
     612:	f423 7380 	bic.w	r3, r3, #256	; 0x100
     616:	6053      	str	r3, [r2, #4]
     618:	6822      	ldr	r2, [r4, #0]
     61a:	6853      	ldr	r3, [r2, #4]
     61c:	f443 7300 	orr.w	r3, r3, #512	; 0x200
     620:	6053      	str	r3, [r2, #4]
     622:	6822      	ldr	r2, [r4, #0]
     624:	6853      	ldr	r3, [r2, #4]
     626:	f423 7300 	bic.w	r3, r3, #512	; 0x200
     62a:	6053      	str	r3, [r2, #4]
     62c:	6822      	ldr	r2, [r4, #0]
     62e:	6853      	ldr	r3, [r2, #4]
     630:	f443 6380 	orr.w	r3, r3, #1024	; 0x400
     634:	6053      	str	r3, [r2, #4]
     636:	6822      	ldr	r2, [r4, #0]
     638:	6853      	ldr	r3, [r2, #4]
     63a:	f423 6380 	bic.w	r3, r3, #1024	; 0x400
     63e:	6053      	str	r3, [r2, #4]
     640:	6822      	ldr	r2, [r4, #0]
     642:	6853      	ldr	r3, [r2, #4]
     644:	f443 6300 	orr.w	r3, r3, #2048	; 0x800
     648:	6053      	str	r3, [r2, #4]
     64a:	6822      	ldr	r2, [r4, #0]
     64c:	6853      	ldr	r3, [r2, #4]
     64e:	f423 6300 	bic.w	r3, r3, #2048	; 0x800
     652:	6053      	str	r3, [r2, #4]
     654:	e766      	b.n	524 <drv_uart_interrupt_handler+0x4a>
     656:	4620      	mov	r0, r4
     658:	f7ff ff39 	bl	4ce <uart_int_rx_noise_detect_callback>
     65c:	6822      	ldr	r2, [r4, #0]
     65e:	6913      	ldr	r3, [r2, #16]
     660:	f043 0320 	orr.w	r3, r3, #32
     664:	6113      	str	r3, [r2, #16]
     666:	6823      	ldr	r3, [r4, #0]
     668:	2200      	movs	r2, #0
     66a:	611a      	str	r2, [r3, #16]
     66c:	e769      	b.n	542 <drv_uart_interrupt_handler+0x68>
     66e:	4620      	mov	r0, r4
     670:	f7ff ff2e 	bl	4d0 <uart_int_rx_stop_detect_callback>
     674:	6822      	ldr	r2, [r4, #0]
     676:	6913      	ldr	r3, [r2, #16]
     678:	f043 0310 	orr.w	r3, r3, #16
     67c:	6113      	str	r3, [r2, #16]
     67e:	6823      	ldr	r3, [r4, #0]
     680:	2200      	movs	r2, #0
     682:	611a      	str	r2, [r3, #16]
     684:	e761      	b.n	54a <drv_uart_interrupt_handler+0x70>
     686:	4620      	mov	r0, r4
     688:	f7ff ff24 	bl	4d4 <uart_int_tx_fifo_thres_callback>
     68c:	6822      	ldr	r2, [r4, #0]
     68e:	6913      	ldr	r3, [r2, #16]
     690:	f043 0301 	orr.w	r3, r3, #1
     694:	6113      	str	r3, [r2, #16]
     696:	6823      	ldr	r3, [r4, #0]
     698:	2200      	movs	r2, #0
     69a:	611a      	str	r2, [r3, #16]
     69c:	e759      	b.n	552 <drv_uart_interrupt_handler+0x78>
     69e:	4620      	mov	r0, r4
     6a0:	f7ff ff17 	bl	4d2 <uart_int_tx_fifo_empty_callback>
     6a4:	6822      	ldr	r2, [r4, #0]
     6a6:	6913      	ldr	r3, [r2, #16]
     6a8:	f043 0302 	orr.w	r3, r3, #2
     6ac:	6113      	str	r3, [r2, #16]
     6ae:	6823      	ldr	r3, [r4, #0]
     6b0:	2200      	movs	r2, #0
     6b2:	611a      	str	r2, [r3, #16]
     6b4:	e751      	b.n	55a <drv_uart_interrupt_handler+0x80>
     6b6:	69d9      	ldr	r1, [r3, #28]
     6b8:	6962      	ldr	r2, [r4, #20]
     6ba:	7ce3      	ldrb	r3, [r4, #19]
     6bc:	1c58      	adds	r0, r3, #1
     6be:	74e0      	strb	r0, [r4, #19]
     6c0:	f822 1013 	strh.w	r1, [r2, r3, lsl #1]
     6c4:	6823      	ldr	r3, [r4, #0]
     6c6:	695a      	ldr	r2, [r3, #20]
     6c8:	f012 0f1f 	tst.w	r2, #31
     6cc:	d1f3      	bne.n	6b6 <drv_uart_interrupt_handler+0x1dc>
     6ce:	4620      	mov	r0, r4
     6d0:	f7ff ff02 	bl	4d8 <uart_int_rx_fifo_thres_callback>
     6d4:	6822      	ldr	r2, [r4, #0]
     6d6:	6913      	ldr	r3, [r2, #16]
     6d8:	f043 0304 	orr.w	r3, r3, #4
     6dc:	6113      	str	r3, [r2, #16]
     6de:	6823      	ldr	r3, [r4, #0]
     6e0:	2200      	movs	r2, #0
     6e2:	611a      	str	r2, [r3, #16]
     6e4:	f015 0f08 	tst.w	r5, #8
     6e8:	d020      	beq.n	72c <drv_uart_interrupt_handler+0x252>
     6ea:	7ce2      	ldrb	r2, [r4, #19]
     6ec:	7e23      	ldrb	r3, [r4, #24]
     6ee:	429a      	cmp	r2, r3
     6f0:	d30c      	bcc.n	70c <drv_uart_interrupt_handler+0x232>
     6f2:	6822      	ldr	r2, [r4, #0]
     6f4:	68d3      	ldr	r3, [r2, #12]
     6f6:	f023 030c 	bic.w	r3, r3, #12
     6fa:	60d3      	str	r3, [r2, #12]
     6fc:	e00b      	b.n	716 <drv_uart_interrupt_handler+0x23c>
     6fe:	69d9      	ldr	r1, [r3, #28]
     700:	6962      	ldr	r2, [r4, #20]
     702:	7ce3      	ldrb	r3, [r4, #19]
     704:	1c58      	adds	r0, r3, #1
     706:	74e0      	strb	r0, [r4, #19]
     708:	f822 1013 	strh.w	r1, [r2, r3, lsl #1]
     70c:	6823      	ldr	r3, [r4, #0]
     70e:	695a      	ldr	r2, [r3, #20]
     710:	f012 0f1f 	tst.w	r2, #31
     714:	d1f3      	bne.n	6fe <drv_uart_interrupt_handler+0x224>
     716:	4620      	mov	r0, r4
     718:	f7ff fedd 	bl	4d6 <uart_int_rx_fifo_noempty_callback>
     71c:	6822      	ldr	r2, [r4, #0]
     71e:	6913      	ldr	r3, [r2, #16]
     720:	f043 0308 	orr.w	r3, r3, #8
     724:	6113      	str	r3, [r2, #16]
     726:	6823      	ldr	r3, [r4, #0]
     728:	2200      	movs	r2, #0
     72a:	611a      	str	r2, [r3, #16]
     72c:	bd38      	pop	{r3, r4, r5, pc}

0000072e <NMI_Handler>:
     72e:	4770      	bx	lr

00000730 <HardFault_Handler>:
     730:	e7fe      	b.n	730 <HardFault_Handler>

00000732 <MemManage_Handler>:
     732:	e7fe      	b.n	732 <MemManage_Handler>

00000734 <BusFault_Handler>:
     734:	e7fe      	b.n	734 <BusFault_Handler>

00000736 <UsageFault_Handler>:
     736:	e7fe      	b.n	736 <UsageFault_Handler>

00000738 <SVC_Handler>:
     738:	4770      	bx	lr

0000073a <DebugMon_Handler>:
     73a:	4770      	bx	lr

0000073c <PendSV_Handler>:
     73c:	4770      	bx	lr

0000073e <SysTick_Handler>:
     73e:	4770      	bx	lr

00000740 <Uart0_Handler>:
     740:	b508      	push	{r3, lr}
     742:	4b04      	ldr	r3, [pc, #16]	; (754 <Uart0_Handler+0x14>)
     744:	2201      	movs	r2, #1
     746:	f8c3 2180 	str.w	r2, [r3, #384]	; 0x180
     74a:	4803      	ldr	r0, [pc, #12]	; (758 <Uart0_Handler+0x18>)
     74c:	f7ff fec5 	bl	4da <drv_uart_interrupt_handler>
     750:	bd08      	pop	{r3, pc}
     752:	bf00      	nop
     754:	e000e100 	and	lr, r0, r0, lsl #2
     758:	00020088 	andeq	r0, r2, r8, lsl #1

0000075c <main>:
     75c:	b500      	push	{lr}
     75e:	b0d9      	sub	sp, #356	; 0x164
     760:	4c14      	ldr	r4, [pc, #80]	; (7b4 <main+0x58>)
     762:	4b15      	ldr	r3, [pc, #84]	; (7b8 <main+0x5c>)
     764:	6023      	str	r3, [r4, #0]
     766:	4620      	mov	r0, r4
     768:	f7ff fda8 	bl	2bc <drv_uart_default_config>
     76c:	4620      	mov	r0, r4
     76e:	f7ff fdd7 	bl	320 <drv_uart_init>
     772:	4812      	ldr	r0, [pc, #72]	; (7bc <main+0x60>)
     774:	f7ff fd94 	bl	2a0 <drv_uart_printf>
     778:	f04f 4380 	mov.w	r3, #1073741824	; 0x40000000
     77c:	22ed      	movs	r2, #237	; 0xed
     77e:	601a      	str	r2, [r3, #0]
     780:	f44f 72ac 	mov.w	r2, #344	; 0x158
     784:	2100      	movs	r1, #0
     786:	a801      	add	r0, sp, #4
     788:	f000 f86a 	bl	860 <memset>
     78c:	a801      	add	r0, sp, #4
     78e:	f7ff fc9b 	bl	c8 <set_fuses>
     792:	2100      	movs	r1, #0
     794:	a801      	add	r0, sp, #4
     796:	f7ff fd37 	bl	208 <drv_caliptra1x_init>
     79a:	4c06      	ldr	r4, [pc, #24]	; (7b4 <main+0x58>)
     79c:	f20d 115f 	addw	r1, sp, #351	; 0x15f
     7a0:	4620      	mov	r0, r4
     7a2:	f7ff fe3c 	bl	41e <drv_uart_getchar>
     7a6:	f20d 115f 	addw	r1, sp, #351	; 0x15f
     7aa:	4620      	mov	r0, r4
     7ac:	f7ff fe22 	bl	3f4 <drv_uart_putchar>
     7b0:	e7f3      	b.n	79a <main+0x3e>
     7b2:	bf00      	nop
     7b4:	00020088 	andeq	r0, r2, r8, lsl #1
     7b8:	40001000 	andmi	r1, r0, r0
     7bc:	00001218 	andeq	r1, r0, r8, lsl r2

000007c0 <Reset_Handler>:
     7c0:	490a      	ldr	r1, [pc, #40]	; (7ec <Reset_Handler+0x2c>)
     7c2:	4a0b      	ldr	r2, [pc, #44]	; (7f0 <Reset_Handler+0x30>)
     7c4:	4b0b      	ldr	r3, [pc, #44]	; (7f4 <Reset_Handler+0x34>)
     7c6:	1a9b      	subs	r3, r3, r2
     7c8:	dd03      	ble.n	7d2 <Reset_Handler+0x12>
     7ca:	3b04      	subs	r3, #4
     7cc:	58c8      	ldr	r0, [r1, r3]
     7ce:	50d0      	str	r0, [r2, r3]
     7d0:	dcfb      	bgt.n	7ca <Reset_Handler+0xa>
     7d2:	4909      	ldr	r1, [pc, #36]	; (7f8 <Reset_Handler+0x38>)
     7d4:	4a09      	ldr	r2, [pc, #36]	; (7fc <Reset_Handler+0x3c>)
     7d6:	2000      	movs	r0, #0
     7d8:	4291      	cmp	r1, r2
     7da:	bfbc      	itt	lt
     7dc:	f841 0b04 	strlt.w	r0, [r1], #4
     7e0:	e7fa      	blt.n	7d8 <Reset_Handler+0x18>
     7e2:	f7ff ffbb 	bl	75c <main>
     7e6:	f000 f827 	bl	838 <exit>
     7ea:	125c0000 	subsne	r0, ip, #0
     7ee:	00000000 	andeq	r0, r0, r0
     7f2:	006c0002 	rsbeq	r0, ip, r2
     7f6:	006c0002 	rsbeq	r0, ip, r2
     7fa:	00b80002 	adcseq	r0, r8, r2
     7fe:	e7fe0002 	ldrb	r0, [lr, r2]!
     802:	e7fe      	b.n	802 <Reset_Handler+0x42>
     804:	e7fe      	b.n	804 <Reset_Handler+0x44>
     806:	e7fe      	b.n	806 <Reset_Handler+0x46>
     808:	e7fe      	b.n	808 <Reset_Handler+0x48>
     80a:	e7fe      	b.n	80a <Reset_Handler+0x4a>
     80c:	e7fe      	b.n	80c <Reset_Handler+0x4c>
     80e:	e7fe      	b.n	80e <Reset_Handler+0x4e>
     810:	e7fe      	b.n	810 <Reset_Handler+0x50>
     812:	e7fe      	b.n	812 <Reset_Handler+0x52>

00000814 <Uart1_Handler>:
     814:	e7fe      	b.n	814 <Uart1_Handler>

00000816 <Resv2_Handler>:
     816:	e7fe      	b.n	816 <Resv2_Handler>

00000818 <Resv3_Handler>:
     818:	e7fe      	b.n	818 <Resv3_Handler>

0000081a <EthDma_Handler>:
     81a:	e7fe      	b.n	81a <EthDma_Handler>

0000081c <Gpioa_Handler>:
     81c:	e7fe      	b.n	81c <Gpioa_Handler>

0000081e <Resv6_Handler>:
     81e:	e7fe      	b.n	81e <Resv6_Handler>

00000820 <Resv7_Handler>:
     820:	e7fe      	b.n	820 <Resv7_Handler>

00000822 <Bastim_Ch0_Handler>:
     822:	e7fe      	b.n	822 <Bastim_Ch0_Handler>

00000824 <Bastim_Ch1_Handler>:
     824:	e7fe      	b.n	824 <Bastim_Ch1_Handler>

00000826 <Bastim_Ch2_Handler>:
     826:	e7fe      	b.n	826 <Bastim_Ch2_Handler>

00000828 <Bastim_Ch3_Handler>:
     828:	e7fe      	b.n	828 <Bastim_Ch3_Handler>

0000082a <EthSma_Handler>:
     82a:	e7fe      	b.n	82a <EthSma_Handler>

0000082c <EthTx_Handler>:
     82c:	e7fe      	b.n	82c <EthTx_Handler>

0000082e <EthRx_Handler>:
     82e:	e7fe      	b.n	82e <EthRx_Handler>

00000830 <Resv15_Handler>:
     830:	e7fe      	b.n	830 <Resv15_Handler>

00000832 <AdvtimGen_Handler>:
     832:	e7fe      	b.n	832 <AdvtimGen_Handler>

00000834 <AdvtimCap_Handler>:
     834:	e7fe      	b.n	834 <AdvtimCap_Handler>
     836:	bf00      	nop

00000838 <exit>:
     838:	b508      	push	{r3, lr}
     83a:	4b07      	ldr	r3, [pc, #28]	; (858 <exit+0x20>)
     83c:	4604      	mov	r4, r0
     83e:	b113      	cbz	r3, 846 <exit+0xe>
     840:	2100      	movs	r1, #0
     842:	f3af 8000 	nop.w
     846:	4b05      	ldr	r3, [pc, #20]	; (85c <exit+0x24>)
     848:	6818      	ldr	r0, [r3, #0]
     84a:	6a83      	ldr	r3, [r0, #40]	; 0x28
     84c:	b103      	cbz	r3, 850 <exit+0x18>
     84e:	4798      	blx	r3
     850:	4620      	mov	r0, r4
     852:	f000 fc9d 	bl	1190 <_exit>
     856:	bf00      	nop
     858:	00000000 	andeq	r0, r0, r0
     85c:	00001220 	andeq	r1, r0, r0, lsr #4

00000860 <memset>:
     860:	4603      	mov	r3, r0
     862:	4402      	add	r2, r0
     864:	4293      	cmp	r3, r2
     866:	d100      	bne.n	86a <memset+0xa>
     868:	4770      	bx	lr
     86a:	f803 1b01 	strb.w	r1, [r3], #1
     86e:	e7f9      	b.n	864 <memset+0x4>

00000870 <_free_r>:
     870:	b538      	push	{r3, r4, r5, lr}
     872:	4605      	mov	r5, r0
     874:	2900      	cmp	r1, #0
     876:	d040      	beq.n	8fa <_free_r+0x8a>
     878:	f851 3c04 	ldr.w	r3, [r1, #-4]
     87c:	1f0c      	subs	r4, r1, #4
     87e:	2b00      	cmp	r3, #0
     880:	bfb8      	it	lt
     882:	18e4      	addlt	r4, r4, r3
     884:	f000 f908 	bl	a98 <__malloc_lock>
     888:	4a1c      	ldr	r2, [pc, #112]	; (8fc <_free_r+0x8c>)
     88a:	6813      	ldr	r3, [r2, #0]
     88c:	b933      	cbnz	r3, 89c <_free_r+0x2c>
     88e:	6063      	str	r3, [r4, #4]
     890:	6014      	str	r4, [r2, #0]
     892:	4628      	mov	r0, r5
     894:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
     898:	f000 b904 	b.w	aa4 <__malloc_unlock>
     89c:	42a3      	cmp	r3, r4
     89e:	d908      	bls.n	8b2 <_free_r+0x42>
     8a0:	6820      	ldr	r0, [r4, #0]
     8a2:	1821      	adds	r1, r4, r0
     8a4:	428b      	cmp	r3, r1
     8a6:	bf01      	itttt	eq
     8a8:	6819      	ldreq	r1, [r3, #0]
     8aa:	685b      	ldreq	r3, [r3, #4]
     8ac:	1809      	addeq	r1, r1, r0
     8ae:	6021      	streq	r1, [r4, #0]
     8b0:	e7ed      	b.n	88e <_free_r+0x1e>
     8b2:	461a      	mov	r2, r3
     8b4:	685b      	ldr	r3, [r3, #4]
     8b6:	b10b      	cbz	r3, 8bc <_free_r+0x4c>
     8b8:	42a3      	cmp	r3, r4
     8ba:	d9fa      	bls.n	8b2 <_free_r+0x42>
     8bc:	6811      	ldr	r1, [r2, #0]
     8be:	1850      	adds	r0, r2, r1
     8c0:	42a0      	cmp	r0, r4
     8c2:	d10b      	bne.n	8dc <_free_r+0x6c>
     8c4:	6820      	ldr	r0, [r4, #0]
     8c6:	4401      	add	r1, r0
     8c8:	1850      	adds	r0, r2, r1
     8ca:	4283      	cmp	r3, r0
     8cc:	6011      	str	r1, [r2, #0]
     8ce:	d1e0      	bne.n	892 <_free_r+0x22>
     8d0:	6818      	ldr	r0, [r3, #0]
     8d2:	685b      	ldr	r3, [r3, #4]
     8d4:	4401      	add	r1, r0
     8d6:	6011      	str	r1, [r2, #0]
     8d8:	6053      	str	r3, [r2, #4]
     8da:	e7da      	b.n	892 <_free_r+0x22>
     8dc:	d902      	bls.n	8e4 <_free_r+0x74>
     8de:	230c      	movs	r3, #12
     8e0:	602b      	str	r3, [r5, #0]
     8e2:	e7d6      	b.n	892 <_free_r+0x22>
     8e4:	6820      	ldr	r0, [r4, #0]
     8e6:	1821      	adds	r1, r4, r0
     8e8:	428b      	cmp	r3, r1
     8ea:	bf01      	itttt	eq
     8ec:	6819      	ldreq	r1, [r3, #0]
     8ee:	685b      	ldreq	r3, [r3, #4]
     8f0:	1809      	addeq	r1, r1, r0
     8f2:	6021      	streq	r1, [r4, #0]
     8f4:	6063      	str	r3, [r4, #4]
     8f6:	6054      	str	r4, [r2, #4]
     8f8:	e7cb      	b.n	892 <_free_r+0x22>
     8fa:	bd38      	pop	{r3, r4, r5, pc}
     8fc:	000200a4 	andeq	r0, r2, r4, lsr #1

00000900 <sbrk_aligned>:
     900:	b570      	push	{r4, r5, r6, lr}
     902:	4e0e      	ldr	r6, [pc, #56]	; (93c <sbrk_aligned+0x3c>)
     904:	460c      	mov	r4, r1
     906:	6831      	ldr	r1, [r6, #0]
     908:	4605      	mov	r5, r0
     90a:	b911      	cbnz	r1, 912 <sbrk_aligned+0x12>
     90c:	f000 f88c 	bl	a28 <_sbrk_r>
     910:	6030      	str	r0, [r6, #0]
     912:	4621      	mov	r1, r4
     914:	4628      	mov	r0, r5
     916:	f000 f887 	bl	a28 <_sbrk_r>
     91a:	1c43      	adds	r3, r0, #1
     91c:	d00a      	beq.n	934 <sbrk_aligned+0x34>
     91e:	1cc4      	adds	r4, r0, #3
     920:	f024 0403 	bic.w	r4, r4, #3
     924:	42a0      	cmp	r0, r4
     926:	d007      	beq.n	938 <sbrk_aligned+0x38>
     928:	1a21      	subs	r1, r4, r0
     92a:	4628      	mov	r0, r5
     92c:	f000 f87c 	bl	a28 <_sbrk_r>
     930:	3001      	adds	r0, #1
     932:	d101      	bne.n	938 <sbrk_aligned+0x38>
     934:	f04f 34ff 	mov.w	r4, #4294967295	; 0xffffffff
     938:	4620      	mov	r0, r4
     93a:	bd70      	pop	{r4, r5, r6, pc}
     93c:	000200a8 	andeq	r0, r2, r8, lsr #1

00000940 <_malloc_r>:
     940:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
     944:	1ccd      	adds	r5, r1, #3
     946:	f025 0503 	bic.w	r5, r5, #3
     94a:	3508      	adds	r5, #8
     94c:	2d0c      	cmp	r5, #12
     94e:	bf38      	it	cc
     950:	250c      	movcc	r5, #12
     952:	2d00      	cmp	r5, #0
     954:	4607      	mov	r7, r0
     956:	db01      	blt.n	95c <_malloc_r+0x1c>
     958:	42a9      	cmp	r1, r5
     95a:	d905      	bls.n	968 <_malloc_r+0x28>
     95c:	230c      	movs	r3, #12
     95e:	2600      	movs	r6, #0
     960:	603b      	str	r3, [r7, #0]
     962:	4630      	mov	r0, r6
     964:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
     968:	4e2e      	ldr	r6, [pc, #184]	; (a24 <_malloc_r+0xe4>)
     96a:	f000 f895 	bl	a98 <__malloc_lock>
     96e:	6833      	ldr	r3, [r6, #0]
     970:	461c      	mov	r4, r3
     972:	bb34      	cbnz	r4, 9c2 <_malloc_r+0x82>
     974:	4629      	mov	r1, r5
     976:	4638      	mov	r0, r7
     978:	f7ff ffc2 	bl	900 <sbrk_aligned>
     97c:	1c43      	adds	r3, r0, #1
     97e:	4604      	mov	r4, r0
     980:	d14d      	bne.n	a1e <_malloc_r+0xde>
     982:	6834      	ldr	r4, [r6, #0]
     984:	4626      	mov	r6, r4
     986:	2e00      	cmp	r6, #0
     988:	d140      	bne.n	a0c <_malloc_r+0xcc>
     98a:	6823      	ldr	r3, [r4, #0]
     98c:	4631      	mov	r1, r6
     98e:	4638      	mov	r0, r7
     990:	eb04 0803 	add.w	r8, r4, r3
     994:	f000 f848 	bl	a28 <_sbrk_r>
     998:	4580      	cmp	r8, r0
     99a:	d13a      	bne.n	a12 <_malloc_r+0xd2>
     99c:	6821      	ldr	r1, [r4, #0]
     99e:	3503      	adds	r5, #3
     9a0:	1a6d      	subs	r5, r5, r1
     9a2:	f025 0503 	bic.w	r5, r5, #3
     9a6:	3508      	adds	r5, #8
     9a8:	2d0c      	cmp	r5, #12
     9aa:	bf38      	it	cc
     9ac:	250c      	movcc	r5, #12
     9ae:	4638      	mov	r0, r7
     9b0:	4629      	mov	r1, r5
     9b2:	f7ff ffa5 	bl	900 <sbrk_aligned>
     9b6:	3001      	adds	r0, #1
     9b8:	d02b      	beq.n	a12 <_malloc_r+0xd2>
     9ba:	6823      	ldr	r3, [r4, #0]
     9bc:	442b      	add	r3, r5
     9be:	6023      	str	r3, [r4, #0]
     9c0:	e00e      	b.n	9e0 <_malloc_r+0xa0>
     9c2:	6822      	ldr	r2, [r4, #0]
     9c4:	1b52      	subs	r2, r2, r5
     9c6:	d41e      	bmi.n	a06 <_malloc_r+0xc6>
     9c8:	2a0b      	cmp	r2, #11
     9ca:	d916      	bls.n	9fa <_malloc_r+0xba>
     9cc:	1961      	adds	r1, r4, r5
     9ce:	42a3      	cmp	r3, r4
     9d0:	6025      	str	r5, [r4, #0]
     9d2:	bf18      	it	ne
     9d4:	6059      	strne	r1, [r3, #4]
     9d6:	6863      	ldr	r3, [r4, #4]
     9d8:	bf08      	it	eq
     9da:	6031      	streq	r1, [r6, #0]
     9dc:	5162      	str	r2, [r4, r5]
     9de:	604b      	str	r3, [r1, #4]
     9e0:	4638      	mov	r0, r7
     9e2:	f104 060b 	add.w	r6, r4, #11
     9e6:	f000 f85d 	bl	aa4 <__malloc_unlock>
     9ea:	f026 0607 	bic.w	r6, r6, #7
     9ee:	1d23      	adds	r3, r4, #4
     9f0:	1af2      	subs	r2, r6, r3
     9f2:	d0b6      	beq.n	962 <_malloc_r+0x22>
     9f4:	1b9b      	subs	r3, r3, r6
     9f6:	50a3      	str	r3, [r4, r2]
     9f8:	e7b3      	b.n	962 <_malloc_r+0x22>
     9fa:	6862      	ldr	r2, [r4, #4]
     9fc:	42a3      	cmp	r3, r4
     9fe:	bf0c      	ite	eq
     a00:	6032      	streq	r2, [r6, #0]
     a02:	605a      	strne	r2, [r3, #4]
     a04:	e7ec      	b.n	9e0 <_malloc_r+0xa0>
     a06:	4623      	mov	r3, r4
     a08:	6864      	ldr	r4, [r4, #4]
     a0a:	e7b2      	b.n	972 <_malloc_r+0x32>
     a0c:	4634      	mov	r4, r6
     a0e:	6876      	ldr	r6, [r6, #4]
     a10:	e7b9      	b.n	986 <_malloc_r+0x46>
     a12:	230c      	movs	r3, #12
     a14:	4638      	mov	r0, r7
     a16:	603b      	str	r3, [r7, #0]
     a18:	f000 f844 	bl	aa4 <__malloc_unlock>
     a1c:	e7a1      	b.n	962 <_malloc_r+0x22>
     a1e:	6025      	str	r5, [r4, #0]
     a20:	e7de      	b.n	9e0 <_malloc_r+0xa0>
     a22:	bf00      	nop
     a24:	000200a4 	andeq	r0, r2, r4, lsr #1

00000a28 <_sbrk_r>:
     a28:	b538      	push	{r3, r4, r5, lr}
     a2a:	2300      	movs	r3, #0
     a2c:	4d05      	ldr	r5, [pc, #20]	; (a44 <_sbrk_r+0x1c>)
     a2e:	4604      	mov	r4, r0
     a30:	4608      	mov	r0, r1
     a32:	602b      	str	r3, [r5, #0]
     a34:	f000 fb9e 	bl	1174 <_sbrk>
     a38:	1c43      	adds	r3, r0, #1
     a3a:	d102      	bne.n	a42 <_sbrk_r+0x1a>
     a3c:	682b      	ldr	r3, [r5, #0]
     a3e:	b103      	cbz	r3, a42 <_sbrk_r+0x1a>
     a40:	6023      	str	r3, [r4, #0]
     a42:	bd38      	pop	{r3, r4, r5, pc}
     a44:	000200ac 	andeq	r0, r2, ip, lsr #1

00000a48 <strlen>:
     a48:	4603      	mov	r3, r0
     a4a:	f813 2b01 	ldrb.w	r2, [r3], #1
     a4e:	2a00      	cmp	r2, #0
     a50:	d1fb      	bne.n	a4a <strlen+0x2>
     a52:	1a18      	subs	r0, r3, r0
     a54:	3801      	subs	r0, #1
     a56:	4770      	bx	lr

00000a58 <_vsiprintf_r>:
     a58:	b500      	push	{lr}
     a5a:	b09b      	sub	sp, #108	; 0x6c
     a5c:	9100      	str	r1, [sp, #0]
     a5e:	9104      	str	r1, [sp, #16]
     a60:	f06f 4100 	mvn.w	r1, #2147483648	; 0x80000000
     a64:	9105      	str	r1, [sp, #20]
     a66:	9102      	str	r1, [sp, #8]
     a68:	4905      	ldr	r1, [pc, #20]	; (a80 <_vsiprintf_r+0x28>)
     a6a:	9103      	str	r1, [sp, #12]
     a6c:	4669      	mov	r1, sp
     a6e:	f000 f87b 	bl	b68 <_svfiprintf_r>
     a72:	2200      	movs	r2, #0
     a74:	9b00      	ldr	r3, [sp, #0]
     a76:	701a      	strb	r2, [r3, #0]
     a78:	b01b      	add	sp, #108	; 0x6c
     a7a:	f85d fb04 	ldr.w	pc, [sp], #4
     a7e:	bf00      	nop
     a80:	ffff0208 			; <UNDEFINED> instruction: 0xffff0208

00000a84 <vsiprintf>:
     a84:	4613      	mov	r3, r2
     a86:	460a      	mov	r2, r1
     a88:	4601      	mov	r1, r0
     a8a:	4802      	ldr	r0, [pc, #8]	; (a94 <vsiprintf+0x10>)
     a8c:	6800      	ldr	r0, [r0, #0]
     a8e:	f7ff bfe3 	b.w	a58 <_vsiprintf_r>
     a92:	bf00      	nop
     a94:	00020000 	andeq	r0, r2, r0

00000a98 <__malloc_lock>:
     a98:	4801      	ldr	r0, [pc, #4]	; (aa0 <__malloc_lock+0x8>)
     a9a:	f000 bafb 	b.w	1094 <__retarget_lock_acquire_recursive>
     a9e:	bf00      	nop
     aa0:	000200b0 	strheq	r0, [r2], -r0	; <UNPREDICTABLE>

00000aa4 <__malloc_unlock>:
     aa4:	4801      	ldr	r0, [pc, #4]	; (aac <__malloc_unlock+0x8>)
     aa6:	f000 baf6 	b.w	1096 <__retarget_lock_release_recursive>
     aaa:	bf00      	nop
     aac:	000200b0 	strheq	r0, [r2], -r0	; <UNPREDICTABLE>

00000ab0 <__ssputs_r>:
     ab0:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
     ab4:	688e      	ldr	r6, [r1, #8]
     ab6:	4682      	mov	sl, r0
     ab8:	429e      	cmp	r6, r3
     aba:	460c      	mov	r4, r1
     abc:	4690      	mov	r8, r2
     abe:	461f      	mov	r7, r3
     ac0:	d838      	bhi.n	b34 <__ssputs_r+0x84>
     ac2:	898a      	ldrh	r2, [r1, #12]
     ac4:	f412 6f90 	tst.w	r2, #1152	; 0x480
     ac8:	d032      	beq.n	b30 <__ssputs_r+0x80>
     aca:	6825      	ldr	r5, [r4, #0]
     acc:	6909      	ldr	r1, [r1, #16]
     ace:	3301      	adds	r3, #1
     ad0:	eba5 0901 	sub.w	r9, r5, r1
     ad4:	6965      	ldr	r5, [r4, #20]
     ad6:	444b      	add	r3, r9
     ad8:	eb05 0545 	add.w	r5, r5, r5, lsl #1
     adc:	eb05 75d5 	add.w	r5, r5, r5, lsr #31
     ae0:	106d      	asrs	r5, r5, #1
     ae2:	429d      	cmp	r5, r3
     ae4:	bf38      	it	cc
     ae6:	461d      	movcc	r5, r3
     ae8:	0553      	lsls	r3, r2, #21
     aea:	d531      	bpl.n	b50 <__ssputs_r+0xa0>
     aec:	4629      	mov	r1, r5
     aee:	f7ff ff27 	bl	940 <_malloc_r>
     af2:	4606      	mov	r6, r0
     af4:	b950      	cbnz	r0, b0c <__ssputs_r+0x5c>
     af6:	230c      	movs	r3, #12
     af8:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     afc:	f8ca 3000 	str.w	r3, [sl]
     b00:	89a3      	ldrh	r3, [r4, #12]
     b02:	f043 0340 	orr.w	r3, r3, #64	; 0x40
     b06:	81a3      	strh	r3, [r4, #12]
     b08:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
     b0c:	464a      	mov	r2, r9
     b0e:	6921      	ldr	r1, [r4, #16]
     b10:	f000 fad0 	bl	10b4 <memcpy>
     b14:	89a3      	ldrh	r3, [r4, #12]
     b16:	f423 6390 	bic.w	r3, r3, #1152	; 0x480
     b1a:	f043 0380 	orr.w	r3, r3, #128	; 0x80
     b1e:	81a3      	strh	r3, [r4, #12]
     b20:	6126      	str	r6, [r4, #16]
     b22:	444e      	add	r6, r9
     b24:	6026      	str	r6, [r4, #0]
     b26:	463e      	mov	r6, r7
     b28:	6165      	str	r5, [r4, #20]
     b2a:	eba5 0509 	sub.w	r5, r5, r9
     b2e:	60a5      	str	r5, [r4, #8]
     b30:	42be      	cmp	r6, r7
     b32:	d900      	bls.n	b36 <__ssputs_r+0x86>
     b34:	463e      	mov	r6, r7
     b36:	4632      	mov	r2, r6
     b38:	4641      	mov	r1, r8
     b3a:	6820      	ldr	r0, [r4, #0]
     b3c:	f000 fac8 	bl	10d0 <memmove>
     b40:	68a3      	ldr	r3, [r4, #8]
     b42:	2000      	movs	r0, #0
     b44:	1b9b      	subs	r3, r3, r6
     b46:	60a3      	str	r3, [r4, #8]
     b48:	6823      	ldr	r3, [r4, #0]
     b4a:	4433      	add	r3, r6
     b4c:	6023      	str	r3, [r4, #0]
     b4e:	e7db      	b.n	b08 <__ssputs_r+0x58>
     b50:	462a      	mov	r2, r5
     b52:	f000 fad7 	bl	1104 <_realloc_r>
     b56:	4606      	mov	r6, r0
     b58:	2800      	cmp	r0, #0
     b5a:	d1e1      	bne.n	b20 <__ssputs_r+0x70>
     b5c:	4650      	mov	r0, sl
     b5e:	6921      	ldr	r1, [r4, #16]
     b60:	f7ff fe86 	bl	870 <_free_r>
     b64:	e7c7      	b.n	af6 <__ssputs_r+0x46>
	...

00000b68 <_svfiprintf_r>:
     b68:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
     b6c:	4698      	mov	r8, r3
     b6e:	898b      	ldrh	r3, [r1, #12]
     b70:	4607      	mov	r7, r0
     b72:	061b      	lsls	r3, r3, #24
     b74:	460d      	mov	r5, r1
     b76:	4614      	mov	r4, r2
     b78:	b09d      	sub	sp, #116	; 0x74
     b7a:	d50e      	bpl.n	b9a <_svfiprintf_r+0x32>
     b7c:	690b      	ldr	r3, [r1, #16]
     b7e:	b963      	cbnz	r3, b9a <_svfiprintf_r+0x32>
     b80:	2140      	movs	r1, #64	; 0x40
     b82:	f7ff fedd 	bl	940 <_malloc_r>
     b86:	6028      	str	r0, [r5, #0]
     b88:	6128      	str	r0, [r5, #16]
     b8a:	b920      	cbnz	r0, b96 <_svfiprintf_r+0x2e>
     b8c:	230c      	movs	r3, #12
     b8e:	603b      	str	r3, [r7, #0]
     b90:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     b94:	e0d1      	b.n	d3a <_svfiprintf_r+0x1d2>
     b96:	2340      	movs	r3, #64	; 0x40
     b98:	616b      	str	r3, [r5, #20]
     b9a:	2300      	movs	r3, #0
     b9c:	9309      	str	r3, [sp, #36]	; 0x24
     b9e:	2320      	movs	r3, #32
     ba0:	f88d 3029 	strb.w	r3, [sp, #41]	; 0x29
     ba4:	2330      	movs	r3, #48	; 0x30
     ba6:	f04f 0901 	mov.w	r9, #1
     baa:	f8cd 800c 	str.w	r8, [sp, #12]
     bae:	f8df 81a4 	ldr.w	r8, [pc, #420]	; d54 <_svfiprintf_r+0x1ec>
     bb2:	f88d 302a 	strb.w	r3, [sp, #42]	; 0x2a
     bb6:	4623      	mov	r3, r4
     bb8:	469a      	mov	sl, r3
     bba:	f813 2b01 	ldrb.w	r2, [r3], #1
     bbe:	b10a      	cbz	r2, bc4 <_svfiprintf_r+0x5c>
     bc0:	2a25      	cmp	r2, #37	; 0x25
     bc2:	d1f9      	bne.n	bb8 <_svfiprintf_r+0x50>
     bc4:	ebba 0b04 	subs.w	fp, sl, r4
     bc8:	d00b      	beq.n	be2 <_svfiprintf_r+0x7a>
     bca:	465b      	mov	r3, fp
     bcc:	4622      	mov	r2, r4
     bce:	4629      	mov	r1, r5
     bd0:	4638      	mov	r0, r7
     bd2:	f7ff ff6d 	bl	ab0 <__ssputs_r>
     bd6:	3001      	adds	r0, #1
     bd8:	f000 80aa 	beq.w	d30 <_svfiprintf_r+0x1c8>
     bdc:	9a09      	ldr	r2, [sp, #36]	; 0x24
     bde:	445a      	add	r2, fp
     be0:	9209      	str	r2, [sp, #36]	; 0x24
     be2:	f89a 3000 	ldrb.w	r3, [sl]
     be6:	2b00      	cmp	r3, #0
     be8:	f000 80a2 	beq.w	d30 <_svfiprintf_r+0x1c8>
     bec:	2300      	movs	r3, #0
     bee:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
     bf2:	e9cd 2305 	strd	r2, r3, [sp, #20]
     bf6:	f10a 0a01 	add.w	sl, sl, #1
     bfa:	9304      	str	r3, [sp, #16]
     bfc:	9307      	str	r3, [sp, #28]
     bfe:	f88d 3053 	strb.w	r3, [sp, #83]	; 0x53
     c02:	931a      	str	r3, [sp, #104]	; 0x68
     c04:	4654      	mov	r4, sl
     c06:	2205      	movs	r2, #5
     c08:	f814 1b01 	ldrb.w	r1, [r4], #1
     c0c:	4851      	ldr	r0, [pc, #324]	; (d54 <_svfiprintf_r+0x1ec>)
     c0e:	f000 fa43 	bl	1098 <memchr>
     c12:	9a04      	ldr	r2, [sp, #16]
     c14:	b9d8      	cbnz	r0, c4e <_svfiprintf_r+0xe6>
     c16:	06d0      	lsls	r0, r2, #27
     c18:	bf44      	itt	mi
     c1a:	2320      	movmi	r3, #32
     c1c:	f88d 3053 	strbmi.w	r3, [sp, #83]	; 0x53
     c20:	0711      	lsls	r1, r2, #28
     c22:	bf44      	itt	mi
     c24:	232b      	movmi	r3, #43	; 0x2b
     c26:	f88d 3053 	strbmi.w	r3, [sp, #83]	; 0x53
     c2a:	f89a 3000 	ldrb.w	r3, [sl]
     c2e:	2b2a      	cmp	r3, #42	; 0x2a
     c30:	d015      	beq.n	c5e <_svfiprintf_r+0xf6>
     c32:	4654      	mov	r4, sl
     c34:	2000      	movs	r0, #0
     c36:	f04f 0c0a 	mov.w	ip, #10
     c3a:	9a07      	ldr	r2, [sp, #28]
     c3c:	4621      	mov	r1, r4
     c3e:	f811 3b01 	ldrb.w	r3, [r1], #1
     c42:	3b30      	subs	r3, #48	; 0x30
     c44:	2b09      	cmp	r3, #9
     c46:	d94e      	bls.n	ce6 <_svfiprintf_r+0x17e>
     c48:	b1b0      	cbz	r0, c78 <_svfiprintf_r+0x110>
     c4a:	9207      	str	r2, [sp, #28]
     c4c:	e014      	b.n	c78 <_svfiprintf_r+0x110>
     c4e:	eba0 0308 	sub.w	r3, r0, r8
     c52:	fa09 f303 	lsl.w	r3, r9, r3
     c56:	4313      	orrs	r3, r2
     c58:	46a2      	mov	sl, r4
     c5a:	9304      	str	r3, [sp, #16]
     c5c:	e7d2      	b.n	c04 <_svfiprintf_r+0x9c>
     c5e:	9b03      	ldr	r3, [sp, #12]
     c60:	1d19      	adds	r1, r3, #4
     c62:	681b      	ldr	r3, [r3, #0]
     c64:	9103      	str	r1, [sp, #12]
     c66:	2b00      	cmp	r3, #0
     c68:	bfbb      	ittet	lt
     c6a:	425b      	neglt	r3, r3
     c6c:	f042 0202 	orrlt.w	r2, r2, #2
     c70:	9307      	strge	r3, [sp, #28]
     c72:	9307      	strlt	r3, [sp, #28]
     c74:	bfb8      	it	lt
     c76:	9204      	strlt	r2, [sp, #16]
     c78:	7823      	ldrb	r3, [r4, #0]
     c7a:	2b2e      	cmp	r3, #46	; 0x2e
     c7c:	d10c      	bne.n	c98 <_svfiprintf_r+0x130>
     c7e:	7863      	ldrb	r3, [r4, #1]
     c80:	2b2a      	cmp	r3, #42	; 0x2a
     c82:	d135      	bne.n	cf0 <_svfiprintf_r+0x188>
     c84:	9b03      	ldr	r3, [sp, #12]
     c86:	3402      	adds	r4, #2
     c88:	1d1a      	adds	r2, r3, #4
     c8a:	681b      	ldr	r3, [r3, #0]
     c8c:	9203      	str	r2, [sp, #12]
     c8e:	2b00      	cmp	r3, #0
     c90:	bfb8      	it	lt
     c92:	f04f 33ff 	movlt.w	r3, #4294967295	; 0xffffffff
     c96:	9305      	str	r3, [sp, #20]
     c98:	f8df a0bc 	ldr.w	sl, [pc, #188]	; d58 <_svfiprintf_r+0x1f0>
     c9c:	2203      	movs	r2, #3
     c9e:	4650      	mov	r0, sl
     ca0:	7821      	ldrb	r1, [r4, #0]
     ca2:	f000 f9f9 	bl	1098 <memchr>
     ca6:	b140      	cbz	r0, cba <_svfiprintf_r+0x152>
     ca8:	2340      	movs	r3, #64	; 0x40
     caa:	eba0 000a 	sub.w	r0, r0, sl
     cae:	fa03 f000 	lsl.w	r0, r3, r0
     cb2:	9b04      	ldr	r3, [sp, #16]
     cb4:	3401      	adds	r4, #1
     cb6:	4303      	orrs	r3, r0
     cb8:	9304      	str	r3, [sp, #16]
     cba:	f814 1b01 	ldrb.w	r1, [r4], #1
     cbe:	2206      	movs	r2, #6
     cc0:	4826      	ldr	r0, [pc, #152]	; (d5c <_svfiprintf_r+0x1f4>)
     cc2:	f88d 1028 	strb.w	r1, [sp, #40]	; 0x28
     cc6:	f000 f9e7 	bl	1098 <memchr>
     cca:	2800      	cmp	r0, #0
     ccc:	d038      	beq.n	d40 <_svfiprintf_r+0x1d8>
     cce:	4b24      	ldr	r3, [pc, #144]	; (d60 <_svfiprintf_r+0x1f8>)
     cd0:	bb1b      	cbnz	r3, d1a <_svfiprintf_r+0x1b2>
     cd2:	9b03      	ldr	r3, [sp, #12]
     cd4:	3307      	adds	r3, #7
     cd6:	f023 0307 	bic.w	r3, r3, #7
     cda:	3308      	adds	r3, #8
     cdc:	9303      	str	r3, [sp, #12]
     cde:	9b09      	ldr	r3, [sp, #36]	; 0x24
     ce0:	4433      	add	r3, r6
     ce2:	9309      	str	r3, [sp, #36]	; 0x24
     ce4:	e767      	b.n	bb6 <_svfiprintf_r+0x4e>
     ce6:	460c      	mov	r4, r1
     ce8:	2001      	movs	r0, #1
     cea:	fb0c 3202 	mla	r2, ip, r2, r3
     cee:	e7a5      	b.n	c3c <_svfiprintf_r+0xd4>
     cf0:	2300      	movs	r3, #0
     cf2:	f04f 0c0a 	mov.w	ip, #10
     cf6:	4619      	mov	r1, r3
     cf8:	3401      	adds	r4, #1
     cfa:	9305      	str	r3, [sp, #20]
     cfc:	4620      	mov	r0, r4
     cfe:	f810 2b01 	ldrb.w	r2, [r0], #1
     d02:	3a30      	subs	r2, #48	; 0x30
     d04:	2a09      	cmp	r2, #9
     d06:	d903      	bls.n	d10 <_svfiprintf_r+0x1a8>
     d08:	2b00      	cmp	r3, #0
     d0a:	d0c5      	beq.n	c98 <_svfiprintf_r+0x130>
     d0c:	9105      	str	r1, [sp, #20]
     d0e:	e7c3      	b.n	c98 <_svfiprintf_r+0x130>
     d10:	4604      	mov	r4, r0
     d12:	2301      	movs	r3, #1
     d14:	fb0c 2101 	mla	r1, ip, r1, r2
     d18:	e7f0      	b.n	cfc <_svfiprintf_r+0x194>
     d1a:	ab03      	add	r3, sp, #12
     d1c:	9300      	str	r3, [sp, #0]
     d1e:	462a      	mov	r2, r5
     d20:	4638      	mov	r0, r7
     d22:	4b10      	ldr	r3, [pc, #64]	; (d64 <_svfiprintf_r+0x1fc>)
     d24:	a904      	add	r1, sp, #16
     d26:	f3af 8000 	nop.w
     d2a:	1c42      	adds	r2, r0, #1
     d2c:	4606      	mov	r6, r0
     d2e:	d1d6      	bne.n	cde <_svfiprintf_r+0x176>
     d30:	89ab      	ldrh	r3, [r5, #12]
     d32:	065b      	lsls	r3, r3, #25
     d34:	f53f af2c 	bmi.w	b90 <_svfiprintf_r+0x28>
     d38:	9809      	ldr	r0, [sp, #36]	; 0x24
     d3a:	b01d      	add	sp, #116	; 0x74
     d3c:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
     d40:	ab03      	add	r3, sp, #12
     d42:	9300      	str	r3, [sp, #0]
     d44:	462a      	mov	r2, r5
     d46:	4638      	mov	r0, r7
     d48:	4b06      	ldr	r3, [pc, #24]	; (d64 <_svfiprintf_r+0x1fc>)
     d4a:	a904      	add	r1, sp, #16
     d4c:	f000 f87c 	bl	e48 <_printf_i>
     d50:	e7eb      	b.n	d2a <_svfiprintf_r+0x1c2>
     d52:	bf00      	nop
     d54:	00001224 	andeq	r1, r0, r4, lsr #4
     d58:	0000122a 	andeq	r1, r0, sl, lsr #4
     d5c:	0000122e 	andeq	r1, r0, lr, lsr #4
     d60:	00000000 	andeq	r0, r0, r0
     d64:	00000ab1 			; <UNDEFINED> instruction: 0x00000ab1

00000d68 <_printf_common>:
     d68:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
     d6c:	4616      	mov	r6, r2
     d6e:	4699      	mov	r9, r3
     d70:	688a      	ldr	r2, [r1, #8]
     d72:	690b      	ldr	r3, [r1, #16]
     d74:	4607      	mov	r7, r0
     d76:	4293      	cmp	r3, r2
     d78:	bfb8      	it	lt
     d7a:	4613      	movlt	r3, r2
     d7c:	6033      	str	r3, [r6, #0]
     d7e:	f891 2043 	ldrb.w	r2, [r1, #67]	; 0x43
     d82:	460c      	mov	r4, r1
     d84:	f8dd 8020 	ldr.w	r8, [sp, #32]
     d88:	b10a      	cbz	r2, d8e <_printf_common+0x26>
     d8a:	3301      	adds	r3, #1
     d8c:	6033      	str	r3, [r6, #0]
     d8e:	6823      	ldr	r3, [r4, #0]
     d90:	0699      	lsls	r1, r3, #26
     d92:	bf42      	ittt	mi
     d94:	6833      	ldrmi	r3, [r6, #0]
     d96:	3302      	addmi	r3, #2
     d98:	6033      	strmi	r3, [r6, #0]
     d9a:	6825      	ldr	r5, [r4, #0]
     d9c:	f015 0506 	ands.w	r5, r5, #6
     da0:	d106      	bne.n	db0 <_printf_common+0x48>
     da2:	f104 0a19 	add.w	sl, r4, #25
     da6:	68e3      	ldr	r3, [r4, #12]
     da8:	6832      	ldr	r2, [r6, #0]
     daa:	1a9b      	subs	r3, r3, r2
     dac:	42ab      	cmp	r3, r5
     dae:	dc28      	bgt.n	e02 <_printf_common+0x9a>
     db0:	f894 2043 	ldrb.w	r2, [r4, #67]	; 0x43
     db4:	1e13      	subs	r3, r2, #0
     db6:	6822      	ldr	r2, [r4, #0]
     db8:	bf18      	it	ne
     dba:	2301      	movne	r3, #1
     dbc:	0692      	lsls	r2, r2, #26
     dbe:	d42d      	bmi.n	e1c <_printf_common+0xb4>
     dc0:	4649      	mov	r1, r9
     dc2:	4638      	mov	r0, r7
     dc4:	f104 0243 	add.w	r2, r4, #67	; 0x43
     dc8:	47c0      	blx	r8
     dca:	3001      	adds	r0, #1
     dcc:	d020      	beq.n	e10 <_printf_common+0xa8>
     dce:	6823      	ldr	r3, [r4, #0]
     dd0:	68e5      	ldr	r5, [r4, #12]
     dd2:	f003 0306 	and.w	r3, r3, #6
     dd6:	2b04      	cmp	r3, #4
     dd8:	bf18      	it	ne
     dda:	2500      	movne	r5, #0
     ddc:	6832      	ldr	r2, [r6, #0]
     dde:	f04f 0600 	mov.w	r6, #0
     de2:	68a3      	ldr	r3, [r4, #8]
     de4:	bf08      	it	eq
     de6:	1aad      	subeq	r5, r5, r2
     de8:	6922      	ldr	r2, [r4, #16]
     dea:	bf08      	it	eq
     dec:	ea25 75e5 	biceq.w	r5, r5, r5, asr #31
     df0:	4293      	cmp	r3, r2
     df2:	bfc4      	itt	gt
     df4:	1a9b      	subgt	r3, r3, r2
     df6:	18ed      	addgt	r5, r5, r3
     df8:	341a      	adds	r4, #26
     dfa:	42b5      	cmp	r5, r6
     dfc:	d11a      	bne.n	e34 <_printf_common+0xcc>
     dfe:	2000      	movs	r0, #0
     e00:	e008      	b.n	e14 <_printf_common+0xac>
     e02:	2301      	movs	r3, #1
     e04:	4652      	mov	r2, sl
     e06:	4649      	mov	r1, r9
     e08:	4638      	mov	r0, r7
     e0a:	47c0      	blx	r8
     e0c:	3001      	adds	r0, #1
     e0e:	d103      	bne.n	e18 <_printf_common+0xb0>
     e10:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     e14:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
     e18:	3501      	adds	r5, #1
     e1a:	e7c4      	b.n	da6 <_printf_common+0x3e>
     e1c:	2030      	movs	r0, #48	; 0x30
     e1e:	18e1      	adds	r1, r4, r3
     e20:	f881 0043 	strb.w	r0, [r1, #67]	; 0x43
     e24:	1c5a      	adds	r2, r3, #1
     e26:	f894 1045 	ldrb.w	r1, [r4, #69]	; 0x45
     e2a:	4422      	add	r2, r4
     e2c:	3302      	adds	r3, #2
     e2e:	f882 1043 	strb.w	r1, [r2, #67]	; 0x43
     e32:	e7c5      	b.n	dc0 <_printf_common+0x58>
     e34:	2301      	movs	r3, #1
     e36:	4622      	mov	r2, r4
     e38:	4649      	mov	r1, r9
     e3a:	4638      	mov	r0, r7
     e3c:	47c0      	blx	r8
     e3e:	3001      	adds	r0, #1
     e40:	d0e6      	beq.n	e10 <_printf_common+0xa8>
     e42:	3601      	adds	r6, #1
     e44:	e7d9      	b.n	dfa <_printf_common+0x92>
	...

00000e48 <_printf_i>:
     e48:	e92d 47ff 	stmdb	sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, lr}
     e4c:	7e0f      	ldrb	r7, [r1, #24]
     e4e:	4691      	mov	r9, r2
     e50:	2f78      	cmp	r7, #120	; 0x78
     e52:	4680      	mov	r8, r0
     e54:	460c      	mov	r4, r1
     e56:	469a      	mov	sl, r3
     e58:	9d0c      	ldr	r5, [sp, #48]	; 0x30
     e5a:	f101 0243 	add.w	r2, r1, #67	; 0x43
     e5e:	d807      	bhi.n	e70 <_printf_i+0x28>
     e60:	2f62      	cmp	r7, #98	; 0x62
     e62:	d80a      	bhi.n	e7a <_printf_i+0x32>
     e64:	2f00      	cmp	r7, #0
     e66:	f000 80d9 	beq.w	101c <_printf_i+0x1d4>
     e6a:	2f58      	cmp	r7, #88	; 0x58
     e6c:	f000 80a4 	beq.w	fb8 <_printf_i+0x170>
     e70:	f104 0542 	add.w	r5, r4, #66	; 0x42
     e74:	f884 7042 	strb.w	r7, [r4, #66]	; 0x42
     e78:	e03a      	b.n	ef0 <_printf_i+0xa8>
     e7a:	f1a7 0363 	sub.w	r3, r7, #99	; 0x63
     e7e:	2b15      	cmp	r3, #21
     e80:	d8f6      	bhi.n	e70 <_printf_i+0x28>
     e82:	a101      	add	r1, pc, #4	; (adr r1, e88 <_printf_i+0x40>)
     e84:	f851 f023 	ldr.w	pc, [r1, r3, lsl #2]
     e88:	00000ee1 	andeq	r0, r0, r1, ror #29
     e8c:	00000ef5 	strdeq	r0, [r0], -r5
     e90:	00000e71 	andeq	r0, r0, r1, ror lr
     e94:	00000e71 	andeq	r0, r0, r1, ror lr
     e98:	00000e71 	andeq	r0, r0, r1, ror lr
     e9c:	00000e71 	andeq	r0, r0, r1, ror lr
     ea0:	00000ef5 	strdeq	r0, [r0], -r5
     ea4:	00000e71 	andeq	r0, r0, r1, ror lr
     ea8:	00000e71 	andeq	r0, r0, r1, ror lr
     eac:	00000e71 	andeq	r0, r0, r1, ror lr
     eb0:	00000e71 	andeq	r0, r0, r1, ror lr
     eb4:	00001003 	andeq	r1, r0, r3
     eb8:	00000f25 	andeq	r0, r0, r5, lsr #30
     ebc:	00000fe5 	andeq	r0, r0, r5, ror #31
     ec0:	00000e71 	andeq	r0, r0, r1, ror lr
     ec4:	00000e71 	andeq	r0, r0, r1, ror lr
     ec8:	00001025 	andeq	r1, r0, r5, lsr #32
     ecc:	00000e71 	andeq	r0, r0, r1, ror lr
     ed0:	00000f25 	andeq	r0, r0, r5, lsr #30
     ed4:	00000e71 	andeq	r0, r0, r1, ror lr
     ed8:	00000e71 	andeq	r0, r0, r1, ror lr
     edc:	00000fed 	andeq	r0, r0, sp, ror #31
     ee0:	682b      	ldr	r3, [r5, #0]
     ee2:	1d1a      	adds	r2, r3, #4
     ee4:	681b      	ldr	r3, [r3, #0]
     ee6:	602a      	str	r2, [r5, #0]
     ee8:	f104 0542 	add.w	r5, r4, #66	; 0x42
     eec:	f884 3042 	strb.w	r3, [r4, #66]	; 0x42
     ef0:	2301      	movs	r3, #1
     ef2:	e0a4      	b.n	103e <_printf_i+0x1f6>
     ef4:	6820      	ldr	r0, [r4, #0]
     ef6:	6829      	ldr	r1, [r5, #0]
     ef8:	0606      	lsls	r6, r0, #24
     efa:	f101 0304 	add.w	r3, r1, #4
     efe:	d50a      	bpl.n	f16 <_printf_i+0xce>
     f00:	680e      	ldr	r6, [r1, #0]
     f02:	602b      	str	r3, [r5, #0]
     f04:	2e00      	cmp	r6, #0
     f06:	da03      	bge.n	f10 <_printf_i+0xc8>
     f08:	232d      	movs	r3, #45	; 0x2d
     f0a:	4276      	negs	r6, r6
     f0c:	f884 3043 	strb.w	r3, [r4, #67]	; 0x43
     f10:	230a      	movs	r3, #10
     f12:	485e      	ldr	r0, [pc, #376]	; (108c <_printf_i+0x244>)
     f14:	e019      	b.n	f4a <_printf_i+0x102>
     f16:	680e      	ldr	r6, [r1, #0]
     f18:	f010 0f40 	tst.w	r0, #64	; 0x40
     f1c:	602b      	str	r3, [r5, #0]
     f1e:	bf18      	it	ne
     f20:	b236      	sxthne	r6, r6
     f22:	e7ef      	b.n	f04 <_printf_i+0xbc>
     f24:	682b      	ldr	r3, [r5, #0]
     f26:	6820      	ldr	r0, [r4, #0]
     f28:	1d19      	adds	r1, r3, #4
     f2a:	6029      	str	r1, [r5, #0]
     f2c:	0601      	lsls	r1, r0, #24
     f2e:	d501      	bpl.n	f34 <_printf_i+0xec>
     f30:	681e      	ldr	r6, [r3, #0]
     f32:	e002      	b.n	f3a <_printf_i+0xf2>
     f34:	0646      	lsls	r6, r0, #25
     f36:	d5fb      	bpl.n	f30 <_printf_i+0xe8>
     f38:	881e      	ldrh	r6, [r3, #0]
     f3a:	2f6f      	cmp	r7, #111	; 0x6f
     f3c:	bf0c      	ite	eq
     f3e:	2308      	moveq	r3, #8
     f40:	230a      	movne	r3, #10
     f42:	4852      	ldr	r0, [pc, #328]	; (108c <_printf_i+0x244>)
     f44:	2100      	movs	r1, #0
     f46:	f884 1043 	strb.w	r1, [r4, #67]	; 0x43
     f4a:	6865      	ldr	r5, [r4, #4]
     f4c:	2d00      	cmp	r5, #0
     f4e:	bfa8      	it	ge
     f50:	6821      	ldrge	r1, [r4, #0]
     f52:	60a5      	str	r5, [r4, #8]
     f54:	bfa4      	itt	ge
     f56:	f021 0104 	bicge.w	r1, r1, #4
     f5a:	6021      	strge	r1, [r4, #0]
     f5c:	b90e      	cbnz	r6, f62 <_printf_i+0x11a>
     f5e:	2d00      	cmp	r5, #0
     f60:	d04d      	beq.n	ffe <_printf_i+0x1b6>
     f62:	4615      	mov	r5, r2
     f64:	fbb6 f1f3 	udiv	r1, r6, r3
     f68:	fb03 6711 	mls	r7, r3, r1, r6
     f6c:	5dc7      	ldrb	r7, [r0, r7]
     f6e:	f805 7d01 	strb.w	r7, [r5, #-1]!
     f72:	4637      	mov	r7, r6
     f74:	42bb      	cmp	r3, r7
     f76:	460e      	mov	r6, r1
     f78:	d9f4      	bls.n	f64 <_printf_i+0x11c>
     f7a:	2b08      	cmp	r3, #8
     f7c:	d10b      	bne.n	f96 <_printf_i+0x14e>
     f7e:	6823      	ldr	r3, [r4, #0]
     f80:	07de      	lsls	r6, r3, #31
     f82:	d508      	bpl.n	f96 <_printf_i+0x14e>
     f84:	6923      	ldr	r3, [r4, #16]
     f86:	6861      	ldr	r1, [r4, #4]
     f88:	4299      	cmp	r1, r3
     f8a:	bfde      	ittt	le
     f8c:	2330      	movle	r3, #48	; 0x30
     f8e:	f805 3c01 	strble.w	r3, [r5, #-1]
     f92:	f105 35ff 	addle.w	r5, r5, #4294967295	; 0xffffffff
     f96:	1b52      	subs	r2, r2, r5
     f98:	6122      	str	r2, [r4, #16]
     f9a:	464b      	mov	r3, r9
     f9c:	4621      	mov	r1, r4
     f9e:	4640      	mov	r0, r8
     fa0:	f8cd a000 	str.w	sl, [sp]
     fa4:	aa03      	add	r2, sp, #12
     fa6:	f7ff fedf 	bl	d68 <_printf_common>
     faa:	3001      	adds	r0, #1
     fac:	d14c      	bne.n	1048 <_printf_i+0x200>
     fae:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     fb2:	b004      	add	sp, #16
     fb4:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
     fb8:	4834      	ldr	r0, [pc, #208]	; (108c <_printf_i+0x244>)
     fba:	f881 7045 	strb.w	r7, [r1, #69]	; 0x45
     fbe:	6829      	ldr	r1, [r5, #0]
     fc0:	6823      	ldr	r3, [r4, #0]
     fc2:	f851 6b04 	ldr.w	r6, [r1], #4
     fc6:	6029      	str	r1, [r5, #0]
     fc8:	061d      	lsls	r5, r3, #24
     fca:	d514      	bpl.n	ff6 <_printf_i+0x1ae>
     fcc:	07df      	lsls	r7, r3, #31
     fce:	bf44      	itt	mi
     fd0:	f043 0320 	orrmi.w	r3, r3, #32
     fd4:	6023      	strmi	r3, [r4, #0]
     fd6:	b91e      	cbnz	r6, fe0 <_printf_i+0x198>
     fd8:	6823      	ldr	r3, [r4, #0]
     fda:	f023 0320 	bic.w	r3, r3, #32
     fde:	6023      	str	r3, [r4, #0]
     fe0:	2310      	movs	r3, #16
     fe2:	e7af      	b.n	f44 <_printf_i+0xfc>
     fe4:	6823      	ldr	r3, [r4, #0]
     fe6:	f043 0320 	orr.w	r3, r3, #32
     fea:	6023      	str	r3, [r4, #0]
     fec:	2378      	movs	r3, #120	; 0x78
     fee:	4828      	ldr	r0, [pc, #160]	; (1090 <_printf_i+0x248>)
     ff0:	f884 3045 	strb.w	r3, [r4, #69]	; 0x45
     ff4:	e7e3      	b.n	fbe <_printf_i+0x176>
     ff6:	0659      	lsls	r1, r3, #25
     ff8:	bf48      	it	mi
     ffa:	b2b6      	uxthmi	r6, r6
     ffc:	e7e6      	b.n	fcc <_printf_i+0x184>
     ffe:	4615      	mov	r5, r2
    1000:	e7bb      	b.n	f7a <_printf_i+0x132>
    1002:	682b      	ldr	r3, [r5, #0]
    1004:	6826      	ldr	r6, [r4, #0]
    1006:	1d18      	adds	r0, r3, #4
    1008:	6961      	ldr	r1, [r4, #20]
    100a:	6028      	str	r0, [r5, #0]
    100c:	0635      	lsls	r5, r6, #24
    100e:	681b      	ldr	r3, [r3, #0]
    1010:	d501      	bpl.n	1016 <_printf_i+0x1ce>
    1012:	6019      	str	r1, [r3, #0]
    1014:	e002      	b.n	101c <_printf_i+0x1d4>
    1016:	0670      	lsls	r0, r6, #25
    1018:	d5fb      	bpl.n	1012 <_printf_i+0x1ca>
    101a:	8019      	strh	r1, [r3, #0]
    101c:	2300      	movs	r3, #0
    101e:	4615      	mov	r5, r2
    1020:	6123      	str	r3, [r4, #16]
    1022:	e7ba      	b.n	f9a <_printf_i+0x152>
    1024:	682b      	ldr	r3, [r5, #0]
    1026:	2100      	movs	r1, #0
    1028:	1d1a      	adds	r2, r3, #4
    102a:	602a      	str	r2, [r5, #0]
    102c:	681d      	ldr	r5, [r3, #0]
    102e:	6862      	ldr	r2, [r4, #4]
    1030:	4628      	mov	r0, r5
    1032:	f000 f831 	bl	1098 <memchr>
    1036:	b108      	cbz	r0, 103c <_printf_i+0x1f4>
    1038:	1b40      	subs	r0, r0, r5
    103a:	6060      	str	r0, [r4, #4]
    103c:	6863      	ldr	r3, [r4, #4]
    103e:	6123      	str	r3, [r4, #16]
    1040:	2300      	movs	r3, #0
    1042:	f884 3043 	strb.w	r3, [r4, #67]	; 0x43
    1046:	e7a8      	b.n	f9a <_printf_i+0x152>
    1048:	462a      	mov	r2, r5
    104a:	4649      	mov	r1, r9
    104c:	4640      	mov	r0, r8
    104e:	6923      	ldr	r3, [r4, #16]
    1050:	47d0      	blx	sl
    1052:	3001      	adds	r0, #1
    1054:	d0ab      	beq.n	fae <_printf_i+0x166>
    1056:	6823      	ldr	r3, [r4, #0]
    1058:	079b      	lsls	r3, r3, #30
    105a:	d413      	bmi.n	1084 <_printf_i+0x23c>
    105c:	68e0      	ldr	r0, [r4, #12]
    105e:	9b03      	ldr	r3, [sp, #12]
    1060:	4298      	cmp	r0, r3
    1062:	bfb8      	it	lt
    1064:	4618      	movlt	r0, r3
    1066:	e7a4      	b.n	fb2 <_printf_i+0x16a>
    1068:	2301      	movs	r3, #1
    106a:	4632      	mov	r2, r6
    106c:	4649      	mov	r1, r9
    106e:	4640      	mov	r0, r8
    1070:	47d0      	blx	sl
    1072:	3001      	adds	r0, #1
    1074:	d09b      	beq.n	fae <_printf_i+0x166>
    1076:	3501      	adds	r5, #1
    1078:	68e3      	ldr	r3, [r4, #12]
    107a:	9903      	ldr	r1, [sp, #12]
    107c:	1a5b      	subs	r3, r3, r1
    107e:	42ab      	cmp	r3, r5
    1080:	dcf2      	bgt.n	1068 <_printf_i+0x220>
    1082:	e7eb      	b.n	105c <_printf_i+0x214>
    1084:	2500      	movs	r5, #0
    1086:	f104 0619 	add.w	r6, r4, #25
    108a:	e7f5      	b.n	1078 <_printf_i+0x230>
    108c:	00001235 	andeq	r1, r0, r5, lsr r2
    1090:	00001246 	andeq	r1, r0, r6, asr #4

00001094 <__retarget_lock_acquire_recursive>:
    1094:	4770      	bx	lr

00001096 <__retarget_lock_release_recursive>:
    1096:	4770      	bx	lr

00001098 <memchr>:
    1098:	4603      	mov	r3, r0
    109a:	b510      	push	{r4, lr}
    109c:	b2c9      	uxtb	r1, r1
    109e:	4402      	add	r2, r0
    10a0:	4293      	cmp	r3, r2
    10a2:	4618      	mov	r0, r3
    10a4:	d101      	bne.n	10aa <memchr+0x12>
    10a6:	2000      	movs	r0, #0
    10a8:	e003      	b.n	10b2 <memchr+0x1a>
    10aa:	7804      	ldrb	r4, [r0, #0]
    10ac:	3301      	adds	r3, #1
    10ae:	428c      	cmp	r4, r1
    10b0:	d1f6      	bne.n	10a0 <memchr+0x8>
    10b2:	bd10      	pop	{r4, pc}

000010b4 <memcpy>:
    10b4:	440a      	add	r2, r1
    10b6:	4291      	cmp	r1, r2
    10b8:	f100 33ff 	add.w	r3, r0, #4294967295	; 0xffffffff
    10bc:	d100      	bne.n	10c0 <memcpy+0xc>
    10be:	4770      	bx	lr
    10c0:	b510      	push	{r4, lr}
    10c2:	f811 4b01 	ldrb.w	r4, [r1], #1
    10c6:	4291      	cmp	r1, r2
    10c8:	f803 4f01 	strb.w	r4, [r3, #1]!
    10cc:	d1f9      	bne.n	10c2 <memcpy+0xe>
    10ce:	bd10      	pop	{r4, pc}

000010d0 <memmove>:
    10d0:	4288      	cmp	r0, r1
    10d2:	b510      	push	{r4, lr}
    10d4:	eb01 0402 	add.w	r4, r1, r2
    10d8:	d902      	bls.n	10e0 <memmove+0x10>
    10da:	4284      	cmp	r4, r0
    10dc:	4623      	mov	r3, r4
    10de:	d807      	bhi.n	10f0 <memmove+0x20>
    10e0:	1e43      	subs	r3, r0, #1
    10e2:	42a1      	cmp	r1, r4
    10e4:	d008      	beq.n	10f8 <memmove+0x28>
    10e6:	f811 2b01 	ldrb.w	r2, [r1], #1
    10ea:	f803 2f01 	strb.w	r2, [r3, #1]!
    10ee:	e7f8      	b.n	10e2 <memmove+0x12>
    10f0:	4601      	mov	r1, r0
    10f2:	4402      	add	r2, r0
    10f4:	428a      	cmp	r2, r1
    10f6:	d100      	bne.n	10fa <memmove+0x2a>
    10f8:	bd10      	pop	{r4, pc}
    10fa:	f813 4d01 	ldrb.w	r4, [r3, #-1]!
    10fe:	f802 4d01 	strb.w	r4, [r2, #-1]!
    1102:	e7f7      	b.n	10f4 <memmove+0x24>

00001104 <_realloc_r>:
    1104:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
    1108:	4680      	mov	r8, r0
    110a:	4614      	mov	r4, r2
    110c:	460e      	mov	r6, r1
    110e:	b921      	cbnz	r1, 111a <_realloc_r+0x16>
    1110:	4611      	mov	r1, r2
    1112:	e8bd 41f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, lr}
    1116:	f7ff bc13 	b.w	940 <_malloc_r>
    111a:	b92a      	cbnz	r2, 1128 <_realloc_r+0x24>
    111c:	f7ff fba8 	bl	870 <_free_r>
    1120:	4625      	mov	r5, r4
    1122:	4628      	mov	r0, r5
    1124:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
    1128:	f000 f81b 	bl	1162 <_malloc_usable_size_r>
    112c:	4284      	cmp	r4, r0
    112e:	4607      	mov	r7, r0
    1130:	d802      	bhi.n	1138 <_realloc_r+0x34>
    1132:	ebb4 0f50 	cmp.w	r4, r0, lsr #1
    1136:	d812      	bhi.n	115e <_realloc_r+0x5a>
    1138:	4621      	mov	r1, r4
    113a:	4640      	mov	r0, r8
    113c:	f7ff fc00 	bl	940 <_malloc_r>
    1140:	4605      	mov	r5, r0
    1142:	2800      	cmp	r0, #0
    1144:	d0ed      	beq.n	1122 <_realloc_r+0x1e>
    1146:	42bc      	cmp	r4, r7
    1148:	4622      	mov	r2, r4
    114a:	4631      	mov	r1, r6
    114c:	bf28      	it	cs
    114e:	463a      	movcs	r2, r7
    1150:	f7ff ffb0 	bl	10b4 <memcpy>
    1154:	4631      	mov	r1, r6
    1156:	4640      	mov	r0, r8
    1158:	f7ff fb8a 	bl	870 <_free_r>
    115c:	e7e1      	b.n	1122 <_realloc_r+0x1e>
    115e:	4635      	mov	r5, r6
    1160:	e7df      	b.n	1122 <_realloc_r+0x1e>

00001162 <_malloc_usable_size_r>:
    1162:	f851 3c04 	ldr.w	r3, [r1, #-4]
    1166:	1f18      	subs	r0, r3, #4
    1168:	2b00      	cmp	r3, #0
    116a:	bfbc      	itt	lt
    116c:	580b      	ldrlt	r3, [r1, r0]
    116e:	18c0      	addlt	r0, r0, r3
    1170:	4770      	bx	lr
	...

00001174 <_sbrk>:
    1174:	4a04      	ldr	r2, [pc, #16]	; (1188 <_sbrk+0x14>)
    1176:	4905      	ldr	r1, [pc, #20]	; (118c <_sbrk+0x18>)
    1178:	6813      	ldr	r3, [r2, #0]
    117a:	2b00      	cmp	r3, #0
    117c:	bf08      	it	eq
    117e:	460b      	moveq	r3, r1
    1180:	4418      	add	r0, r3
    1182:	6010      	str	r0, [r2, #0]
    1184:	4618      	mov	r0, r3
    1186:	4770      	bx	lr
    1188:	000200b4 	strheq	r0, [r2], -r4
    118c:	000200b8 	strheq	r0, [r2], -r8

00001190 <_exit>:
    1190:	e7fe      	b.n	1190 <_exit>
    1192:	bf00      	nop

00001194 <_init>:
    1194:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    1196:	bf00      	nop
    1198:	bcf8      	pop	{r3, r4, r5, r6, r7}
    119a:	bc08      	pop	{r3}
    119c:	469e      	mov	lr, r3
    119e:	4770      	bx	lr

000011a0 <_fini>:
    11a0:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
    11a2:	bf00      	nop
    11a4:	bcf8      	pop	{r3, r4, r5, r6, r7}
    11a6:	bc08      	pop	{r3}
    11a8:	469e      	mov	lr, r3
    11aa:	4770      	bx	lr
    11ac:	6c696146 	stfvse	f6, [r9], #-280	; 0xfffffee8
    11b0:	74206465 	strtvc	r6, [r0], #-1125	; 0xfffffb9b
    11b4:	6e69206f 	cdpvs	0, 6, cr2, cr9, cr15, {3}
    11b8:	66207469 	strtvs	r7, [r0], -r9, ror #8
    11bc:	73657375 	cmnvc	r5, #-738197503	; 0xd4000001
    11c0:	6425203a 	strtvs	r2, [r5], #-58	; 0xffffffc6
    11c4:	0000000a 	andeq	r0, r0, sl

000011c8 <default_field_entropy>:
    11c8:	80818283 	addhi	r8, r1, r3, lsl #5
    11cc:	84858687 	strhi	r8, [r5], #1671	; 0x687
    11d0:	88898a8b 	stmhi	r9, {r0, r1, r3, r7, r9, fp, pc}
    11d4:	8c8d8e8f 	stchi	14, cr8, [sp], {143}	; 0x8f
    11d8:	90919293 	umullsls	r9, r1, r3, r2
    11dc:	94959697 	ldrls	r9, [r5], #1687	; 0x697
    11e0:	98999a9b 	ldmls	r9, {r0, r1, r3, r4, r7, r9, fp, ip, pc}
    11e4:	9c9d9e9f 	ldcls	14, cr9, [sp], {159}	; 0x9f

000011e8 <default_uds_seed>:
    11e8:	00010203 	andeq	r0, r1, r3, lsl #4
    11ec:	04050607 	streq	r0, [r5], #-1543	; 0xfffff9f9
    11f0:	08090a0b 	stmdaeq	r9, {r0, r1, r3, r9, fp}
    11f4:	0c0d0e0f 	stceq	14, cr0, [sp], {15}
    11f8:	10111213 	andsne	r1, r1, r3, lsl r2
    11fc:	14151617 	ldrne	r1, [r5], #-1559	; 0xfffff9e9
    1200:	18191a1b 	ldmdane	r9, {r0, r1, r3, r4, r9, fp, ip}
    1204:	1c1d1e1f 	ldcne	14, cr1, [sp], {31}
    1208:	20212223 	eorcs	r2, r1, r3, lsr #4
    120c:	24252627 	strtcs	r2, [r5], #-1575	; 0xfffff9d9
    1210:	28292a2b 	stmdacs	r9!, {r0, r1, r3, r5, r9, fp, sp}
    1214:	2c2d2e2f 	stccs	14, cr2, [sp], #-188	; 0xffffff44
    1218:	61632042 	cmnvs	r3, r2, asr #32
    121c:	00000a0d 	andeq	r0, r0, sp, lsl #20

00001220 <_global_impure_ptr>:
    1220:	00020004 	andeq	r0, r2, r4
    1224:	2b302d23 	blcs	c0c6b8 <__StackTop+0xbea6b8>
    1228:	6c680020 	stclvs	0, cr0, [r8], #-128	; 0xffffff80
    122c:	6665004c 	strbtvs	r0, [r5], -ip, asr #32
    1230:	47464567 	strbmi	r4, [r6, -r7, ror #10]
    1234:	32313000 	eorscc	r3, r1, #0
    1238:	36353433 			; <UNDEFINED> instruction: 0x36353433
    123c:	41393837 	teqmi	r9, r7, lsr r8
    1240:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    1244:	31300046 	teqcc	r0, r6, asr #32
    1248:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    124c:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    1250:	64636261 	strbtvs	r6, [r3], #-609	; 0xfffffd9f
    1254:	00006665 	andeq	r6, r0, r5, ror #12

00001258 <__EH_FRAME_BEGIN__>:
    1258:	00000000 	andeq	r0, r0, r0

Disassembly of section .data:

00020000 <_impure_ptr>:
   20000:	00020004 	andeq	r0, r2, r4

00020004 <impure_data>:
	...

00020064 <__frame_dummy_init_array_entry>:
   20064:	000000ad 	andeq	r0, r0, sp, lsr #1

00020068 <__do_global_dtors_aux_fini_array_entry>:
   20068:	00000089 	andeq	r0, r0, r9, lsl #1

Disassembly of section .bss:

0002006c <__bss_start__>:
   2006c:	00000000 	andeq	r0, r0, r0

00020070 <object.0>:
	...

00020088 <huart0>:
	...

000200a4 <__malloc_free_list>:
   200a4:	00000000 	andeq	r0, r0, r0

000200a8 <__malloc_sbrk_start>:
   200a8:	00000000 	andeq	r0, r0, r0

000200ac <errno>:
   200ac:	00000000 	andeq	r0, r0, r0

000200b0 <__lock___malloc_recursive_mutex>:
   200b0:	00000000 	andeq	r0, r0, r0

000200b4 <heap_end.0>:
   200b4:	00000000 	andeq	r0, r0, r0

Disassembly of section .stack_dummy:

000200b8 <__HeapBase>:
	...

Disassembly of section .ARM.attributes:

00000000 <.ARM.attributes>:
   0:	00002841 	andeq	r2, r0, r1, asr #16
   4:	61656100 	cmnvs	r5, r0, lsl #2
   8:	01006962 	tsteq	r0, r2, ror #18
   c:	0000001e 	andeq	r0, r0, lr, lsl r0
  10:	4d2d3705 	stcmi	7, cr3, [sp, #-20]!	; 0xffffffec
  14:	070a0600 	streq	r0, [sl, -r0, lsl #12]
  18:	1202094d 	andne	r0, r2, #1261568	; 0x134000
  1c:	15011404 	strne	r1, [r1, #-1028]	; 0xfffffbfc
  20:	18031701 	stmdane	r3, {r0, r8, r9, sl, ip}
  24:	22011a01 	andcs	r1, r1, #4096	; 0x1000
  28:	Address 0x0000000000000028 is out of bounds.


Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347 	bcc	10d0d24 <__StackTop+0x10aed24>
   4:	4e472820 	cdpmi	8, 4, cr2, cr7, cr0, {1}
   8:	72412055 	subvc	r2, r1, #85	; 0x55
   c:	6d45206d 	stclvs	0, cr2, [r5, #-436]	; 0xfffffe4c
  10:	64646562 	strbtvs	r6, [r4], #-1378	; 0xfffffa9e
  14:	54206465 	strtpl	r6, [r0], #-1125	; 0xfffffb9b
  18:	636c6f6f 	cmnvs	ip, #444	; 0x1bc
  1c:	6e696168 	powvsez	f6, f1, #0.0
  20:	2e303120 	rsfcssp	f3, f0, f0
  24:	30322d33 	eorscc	r2, r2, r3, lsr sp
  28:	312e3132 			; <UNDEFINED> instruction: 0x312e3132
  2c:	31202930 			; <UNDEFINED> instruction: 0x31202930
  30:	2e332e30 	mrccs	14, 1, r2, cr3, cr0, {1}
  34:	30322031 	eorscc	r2, r2, r1, lsr r0
  38:	38303132 	ldmdacc	r0!, {r1, r4, r5, r8, ip, sp}
  3c:	28203432 	stmdacs	r0!, {r1, r4, r5, sl, ip, sp}
  40:	656c6572 	strbvs	r6, [ip, #-1394]!	; 0xfffffa8e
  44:	29657361 	stmdbcs	r5!, {r0, r5, r6, r8, r9, ip, sp, lr}^
	...

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	0000000c 	andeq	r0, r0, ip
   4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
   8:	7c020001 	stcvc	0, cr0, [r2], {1}
   c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  10:	00000014 	andeq	r0, r0, r4, lsl r0
  14:	00000000 	andeq	r0, r0, r0
  18:	00000838 	andeq	r0, r0, r8, lsr r8
  1c:	00000028 	andeq	r0, r0, r8, lsr #32
  20:	83080e41 	movwhi	r0, #36417	; 0x8e41
  24:	00018e02 	andeq	r8, r1, r2, lsl #28
  28:	0000000c 	andeq	r0, r0, ip
  2c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  30:	7c020001 	stcvc	0, cr0, [r2], {1}
  34:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  38:	0000000c 	andeq	r0, r0, ip
  3c:	00000028 	andeq	r0, r0, r8, lsr #32
  40:	00000860 	andeq	r0, r0, r0, ror #16
  44:	00000010 	andeq	r0, r0, r0, lsl r0
  48:	0000000c 	andeq	r0, r0, ip
  4c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  50:	7c020001 	stcvc	0, cr0, [r2], {1}
  54:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  58:	00000024 	andeq	r0, r0, r4, lsr #32
  5c:	00000048 	andeq	r0, r0, r8, asr #32
  60:	00000870 	andeq	r0, r0, r0, ror r8
  64:	00000090 	muleq	r0, r0, r0
  68:	83100e41 	tsthi	r0, #1040	; 0x410
  6c:	85038404 	strhi	r8, [r3, #-1028]	; 0xfffffbfc
  70:	53018e02 	movwpl	r8, #7682	; 0x1e02
  74:	c4c5ce0a 	strbgt	ip, [r5], #3594	; 0xe0a
  78:	42000ec3 	andmi	r0, r0, #3120	; 0xc30
  7c:	0000000b 	andeq	r0, r0, fp
  80:	0000000c 	andeq	r0, r0, ip
  84:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  88:	7c020001 	stcvc	0, cr0, [r2], {1}
  8c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  90:	00000018 	andeq	r0, r0, r8, lsl r0
  94:	00000080 	andeq	r0, r0, r0, lsl #1
  98:	00000900 	andeq	r0, r0, r0, lsl #18
  9c:	00000040 	andeq	r0, r0, r0, asr #32
  a0:	84100e41 	ldrhi	r0, [r0], #-3649	; 0xfffff1bf
  a4:	86038504 	strhi	r8, [r3], -r4, lsl #10
  a8:	00018e02 	andeq	r8, r1, r2, lsl #28
  ac:	0000001c 	andeq	r0, r0, ip, lsl r0
  b0:	00000080 	andeq	r0, r0, r0, lsl #1
  b4:	00000940 	andeq	r0, r0, r0, asr #18
  b8:	000000e8 	andeq	r0, r0, r8, ror #1
  bc:	84180e42 	ldrhi	r0, [r8], #-3650	; 0xfffff1be
  c0:	86058506 	strhi	r8, [r5], -r6, lsl #10
  c4:	88038704 	stmdahi	r3, {r2, r8, r9, sl, pc}
  c8:	00018e02 	andeq	r8, r1, r2, lsl #28
  cc:	0000000c 	andeq	r0, r0, ip
  d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  d4:	7c020001 	stcvc	0, cr0, [r2], {1}
  d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  dc:	00000018 	andeq	r0, r0, r8, lsl r0
  e0:	000000cc 	andeq	r0, r0, ip, asr #1
  e4:	00000a28 	andeq	r0, r0, r8, lsr #20
  e8:	00000020 	andeq	r0, r0, r0, lsr #32
  ec:	83100e41 	tsthi	r0, #1040	; 0x410
  f0:	85038404 	strhi	r8, [r3, #-1028]	; 0xfffffbfc
  f4:	00018e02 	andeq	r8, r1, r2, lsl #28
  f8:	0000000c 	andeq	r0, r0, ip
  fc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 100:	7c020001 	stcvc	0, cr0, [r2], {1}
 104:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 108:	00000018 	andeq	r0, r0, r8, lsl r0
 10c:	000000f8 	strdeq	r0, [r0], -r8
 110:	00000a58 	andeq	r0, r0, r8, asr sl
 114:	0000002c 	andeq	r0, r0, ip, lsr #32
 118:	8e040e41 	cdphi	14, 0, cr0, cr4, cr1, {2}
 11c:	700e4101 	andvc	r4, lr, r1, lsl #2
 120:	00040e4f 	andeq	r0, r4, pc, asr #28
 124:	0000000c 	andeq	r0, r0, ip
 128:	000000f8 	strdeq	r0, [r0], -r8
 12c:	00000a84 	andeq	r0, r0, r4, lsl #21
 130:	00000014 	andeq	r0, r0, r4, lsl r0
 134:	0000000c 	andeq	r0, r0, ip
 138:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 13c:	7c020001 	stcvc	0, cr0, [r2], {1}
 140:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 144:	0000000c 	andeq	r0, r0, ip
 148:	00000134 	andeq	r0, r0, r4, lsr r1
 14c:	00000a98 	muleq	r0, r8, sl
 150:	0000000c 	andeq	r0, r0, ip
 154:	0000000c 	andeq	r0, r0, ip
 158:	00000134 	andeq	r0, r0, r4, lsr r1
 15c:	00000aa4 	andeq	r0, r0, r4, lsr #21
 160:	0000000c 	andeq	r0, r0, ip
 164:	0000000c 	andeq	r0, r0, ip
 168:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 16c:	7c020001 	stcvc	0, cr0, [r2], {1}
 170:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 174:	00000020 	andeq	r0, r0, r0, lsr #32
 178:	00000164 	andeq	r0, r0, r4, ror #2
 17c:	00000ab0 			; <UNDEFINED> instruction: 0x00000ab0
 180:	000000b6 	strheq	r0, [r0], -r6
 184:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 188:	86078508 	strhi	r8, [r7], -r8, lsl #10
 18c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 190:	8a038904 	bhi	e25a8 <__StackTop+0xc05a8>
 194:	00018e02 	andeq	r8, r1, r2, lsl #28
 198:	00000028 	andeq	r0, r0, r8, lsr #32
 19c:	00000164 	andeq	r0, r0, r4, ror #2
 1a0:	00000000 	andeq	r0, r0, r0
 1a4:	000000f6 	strdeq	r0, [r0], -r6
 1a8:	84300e43 	ldrthi	r0, [r0], #-3651	; 0xfffff1bd
 1ac:	86088509 	strhi	r8, [r8], -r9, lsl #10
 1b0:	88068707 	stmdahi	r6, {r0, r1, r2, r8, r9, sl, pc}
 1b4:	8a048905 	bhi	1225d0 <__StackTop+0x1005d0>
 1b8:	8e028b03 	vmlahi.f64	d8, d2, d3
 1bc:	0a6a0201 	beq	1a809c8 <__StackTop+0x1a5e9c8>
 1c0:	0b42240e 	bleq	1089200 <__StackTop+0x1067200>
 1c4:	0000002c 	andeq	r0, r0, ip, lsr #32
 1c8:	00000164 	andeq	r0, r0, r4, ror #2
 1cc:	00000b68 	andeq	r0, r0, r8, ror #22
 1d0:	00000200 	andeq	r0, r0, r0, lsl #4
 1d4:	84240e42 	strthi	r0, [r4], #-3650	; 0xfffff1be
 1d8:	86088509 	strhi	r8, [r8], -r9, lsl #10
 1dc:	88068707 	stmdahi	r6, {r0, r1, r2, r8, r9, sl, pc}
 1e0:	8a048905 	bhi	1225fc <__StackTop+0x1005fc>
 1e4:	8e028b03 	vmlahi.f64	d8, d2, d3
 1e8:	980e4701 	stmdals	lr, {r0, r8, r9, sl, lr}
 1ec:	0ae10201 	beq	ff8409f8 <__StackTop+0xff81e9f8>
 1f0:	0b42240e 	bleq	1089230 <__StackTop+0x1067230>
 1f4:	0000000c 	andeq	r0, r0, ip
 1f8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1fc:	7c020001 	stcvc	0, cr0, [r2], {1}
 200:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 204:	00000020 	andeq	r0, r0, r0, lsr #32
 208:	000001f4 	strdeq	r0, [r0], -r4
 20c:	00000d68 	andeq	r0, r0, r8, ror #26
 210:	000000de 	ldrdeq	r0, [r0], -lr
 214:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 218:	86078508 	strhi	r8, [r7], -r8, lsl #10
 21c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 220:	8a038904 	bhi	e2638 <__StackTop+0xc0638>
 224:	00018e02 	andeq	r8, r1, r2, lsl #28
 228:	00000028 	andeq	r0, r0, r8, lsr #32
 22c:	000001f4 	strdeq	r0, [r0], -r4
 230:	00000e48 	andeq	r0, r0, r8, asr #28
 234:	0000024c 	andeq	r0, r0, ip, asr #4
 238:	84300e42 	ldrthi	r0, [r0], #-3650	; 0xfffff1be
 23c:	86078508 	strhi	r8, [r7], -r8, lsl #10
 240:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 244:	8a038904 	bhi	e265c <__StackTop+0xc065c>
 248:	02018e02 	andeq	r8, r1, #2, 28
 24c:	200e0ab4 			; <UNDEFINED> instruction: 0x200e0ab4
 250:	00000b42 	andeq	r0, r0, r2, asr #22
 254:	0000000c 	andeq	r0, r0, ip
 258:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 25c:	7c020001 	stcvc	0, cr0, [r2], {1}
 260:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 264:	00000020 	andeq	r0, r0, r0, lsr #32
 268:	00000254 	andeq	r0, r0, r4, asr r2
 26c:	00000000 	andeq	r0, r0, r0
 270:	0000001a 	andeq	r0, r0, sl, lsl r0
 274:	83100e41 	tsthi	r0, #1040	; 0x410
 278:	85038404 	strhi	r8, [r3, #-1028]	; 0xfffffbfc
 27c:	4a018e02 	bmi	63a8c <__StackTop+0x41a8c>
 280:	c3c4c5ce 	bicgt	ip, r4, #864026624	; 0x33800000
 284:	0000000e 	andeq	r0, r0, lr
 288:	00000024 	andeq	r0, r0, r4, lsr #32
 28c:	00000254 	andeq	r0, r0, r4, asr r2
 290:	00000000 	andeq	r0, r0, r0
 294:	000000b8 	strheq	r0, [r0], -r8
 298:	84100e42 	ldrhi	r0, [r0], #-3650	; 0xfffff1be
 29c:	86038504 	strhi	r8, [r3], -r4, lsl #10
 2a0:	02018e02 	andeq	r8, r1, #2, 28
 2a4:	c6ce0a41 	strbgt	r0, [lr], r1, asr #20
 2a8:	000ec4c5 	andeq	ip, lr, r5, asr #9
 2ac:	00000b42 	andeq	r0, r0, r2, asr #22
 2b0:	0000000c 	andeq	r0, r0, ip
 2b4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2b8:	7c020001 	stcvc	0, cr0, [r2], {1}
 2bc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2c0:	0000000c 	andeq	r0, r0, ip
 2c4:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 2c8:	00000000 	andeq	r0, r0, r0
 2cc:	00000002 	andeq	r0, r0, r2
 2d0:	0000000c 	andeq	r0, r0, ip
 2d4:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 2d8:	00000000 	andeq	r0, r0, r0
 2dc:	00000002 	andeq	r0, r0, r2
 2e0:	0000000c 	andeq	r0, r0, ip
 2e4:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 2e8:	00000000 	andeq	r0, r0, r0
 2ec:	00000002 	andeq	r0, r0, r2
 2f0:	0000000c 	andeq	r0, r0, ip
 2f4:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 2f8:	00000000 	andeq	r0, r0, r0
 2fc:	00000002 	andeq	r0, r0, r2
 300:	0000000c 	andeq	r0, r0, ip
 304:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 308:	00000000 	andeq	r0, r0, r0
 30c:	00000002 	andeq	r0, r0, r2
 310:	0000000c 	andeq	r0, r0, ip
 314:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 318:	00001094 	muleq	r0, r4, r0
 31c:	00000002 	andeq	r0, r0, r2
 320:	0000000c 	andeq	r0, r0, ip
 324:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 328:	00000000 	andeq	r0, r0, r0
 32c:	00000004 	andeq	r0, r0, r4
 330:	0000000c 	andeq	r0, r0, ip
 334:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 338:	00000000 	andeq	r0, r0, r0
 33c:	00000004 	andeq	r0, r0, r4
 340:	0000000c 	andeq	r0, r0, ip
 344:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 348:	00000000 	andeq	r0, r0, r0
 34c:	00000002 	andeq	r0, r0, r2
 350:	0000000c 	andeq	r0, r0, ip
 354:	000002b0 			; <UNDEFINED> instruction: 0x000002b0
 358:	00001096 	muleq	r0, r6, r0
 35c:	00000002 	andeq	r0, r0, r2
 360:	0000000c 	andeq	r0, r0, ip
 364:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 368:	7c020001 	stcvc	0, cr0, [r2], {1}
 36c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 370:	00000014 	andeq	r0, r0, r4, lsl r0
 374:	00000360 	andeq	r0, r0, r0, ror #6
 378:	00001098 	muleq	r0, r8, r0
 37c:	0000001c 	andeq	r0, r0, ip, lsl r0
 380:	84080e42 	strhi	r0, [r8], #-3650	; 0xfffff1be
 384:	00018e02 	andeq	r8, r1, r2, lsl #28
 388:	0000000c 	andeq	r0, r0, ip
 38c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 390:	7c020001 	stcvc	0, cr0, [r2], {1}
 394:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 398:	00000014 	andeq	r0, r0, r4, lsl r0
 39c:	00000388 	andeq	r0, r0, r8, lsl #7
 3a0:	000010b4 	strheq	r1, [r0], -r4
 3a4:	0000001c 	andeq	r0, r0, ip, lsl r0
 3a8:	84080e47 	strhi	r0, [r8], #-3655	; 0xfffff1b9
 3ac:	00018e02 	andeq	r8, r1, r2, lsl #28
 3b0:	0000000c 	andeq	r0, r0, ip
 3b4:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3b8:	7c020001 	stcvc	0, cr0, [r2], {1}
 3bc:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3c0:	00000014 	andeq	r0, r0, r4, lsl r0
 3c4:	000003b0 			; <UNDEFINED> instruction: 0x000003b0
 3c8:	000010d0 	ldrdeq	r1, [r0], -r0
 3cc:	00000034 	andeq	r0, r0, r4, lsr r0
 3d0:	84080e42 	strhi	r0, [r8], #-3650	; 0xfffff1be
 3d4:	00018e02 	andeq	r8, r1, r2, lsl #28
 3d8:	0000000c 	andeq	r0, r0, ip
 3dc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 3e0:	7c020001 	stcvc	0, cr0, [r2], {1}
 3e4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 3e8:	00000028 	andeq	r0, r0, r8, lsr #32
 3ec:	000003d8 	ldrdeq	r0, [r0], -r8
 3f0:	00001104 	andeq	r1, r0, r4, lsl #2
 3f4:	0000005e 	andeq	r0, r0, lr, asr r0
 3f8:	84180e42 	ldrhi	r0, [r8], #-3650	; 0xfffff1be
 3fc:	86058506 	strhi	r8, [r5], -r6, lsl #10
 400:	88038704 	stmdahi	r3, {r2, r8, r9, sl, pc}
 404:	47018e02 	strmi	r8, [r1, -r2, lsl #28]
 408:	c7c8ce0a 	strbgt	ip, [r8, sl, lsl #28]
 40c:	0ec4c5c6 	cdpeq	5, 12, cr12, cr4, cr6, {6}
 410:	000b4200 	andeq	r4, fp, r0, lsl #4
 414:	0000000c 	andeq	r0, r0, ip
 418:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 41c:	7c020001 	stcvc	0, cr0, [r2], {1}
 420:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 424:	0000000c 	andeq	r0, r0, ip
 428:	00000414 	andeq	r0, r0, r4, lsl r4
 42c:	00001162 	andeq	r1, r0, r2, ror #2
 430:	00000010 	andeq	r0, r0, r0, lsl r0
 434:	0000000c 	andeq	r0, r0, ip
 438:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 43c:	7c020001 	stcvc	0, cr0, [r2], {1}
 440:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 444:	0000000c 	andeq	r0, r0, ip
 448:	00000434 	andeq	r0, r0, r4, lsr r4
 44c:	00001174 	andeq	r1, r0, r4, ror r1
 450:	0000001c 	andeq	r0, r0, ip, lsl r0
 454:	0000000c 	andeq	r0, r0, ip
 458:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 45c:	7c020001 	stcvc	0, cr0, [r2], {1}
 460:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 464:	0000000c 	andeq	r0, r0, ip
 468:	00000454 	andeq	r0, r0, r4, asr r4
 46c:	00001190 	muleq	r0, r0, r1
 470:	00000002 	andeq	r0, r0, r2
