
bootloader.elf:     file format elf32-littlearm


Disassembly of section .text:

00000000 <__isr_vector>:
       0:	00022000 	andeq	r2, r2, r0
       4:	00000625 	andeq	r0, r0, r5, lsr #12
       8:	000005af 	andeq	r0, r0, pc, lsr #11
       c:	000005b1 			; <UNDEFINED> instruction: 0x000005b1
      10:	000005b3 			; <UNDEFINED> instruction: 0x000005b3
      14:	000005b5 			; <UNDEFINED> instruction: 0x000005b5
      18:	000005b7 			; <UNDEFINED> instruction: 0x000005b7
	...
      2c:	000005b9 			; <UNDEFINED> instruction: 0x000005b9
      30:	000005bb 			; <UNDEFINED> instruction: 0x000005bb
      34:	00000000 	andeq	r0, r0, r0
      38:	000005bd 			; <UNDEFINED> instruction: 0x000005bd
      3c:	000005bf 			; <UNDEFINED> instruction: 0x000005bf
      40:	000005c1 	andeq	r0, r0, r1, asr #11
      44:	00000679 	andeq	r0, r0, r9, ror r6
      48:	0000067b 	andeq	r0, r0, fp, ror r6
      4c:	0000067d 	andeq	r0, r0, sp, ror r6
      50:	0000067f 	andeq	r0, r0, pc, ror r6
      54:	00000681 	andeq	r0, r0, r1, lsl #13
      58:	00000683 	andeq	r0, r0, r3, lsl #13
      5c:	00000685 	andeq	r0, r0, r5, lsl #13
      60:	00000687 	andeq	r0, r0, r7, lsl #13
      64:	00000689 	andeq	r0, r0, r9, lsl #13
      68:	0000068b 	andeq	r0, r0, fp, lsl #13
      6c:	0000068d 	andeq	r0, r0, sp, lsl #13
      70:	0000068f 	andeq	r0, r0, pc, lsl #13
      74:	00000691 	muleq	r0, r1, r6
      78:	00000693 	muleq	r0, r3, r6
      7c:	00000695 	muleq	r0, r5, r6
      80:	00000697 	muleq	r0, r7, r6
      84:	00000699 	muleq	r0, r9, r6

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
      a8:	00001064 	andeq	r1, r0, r4, rrx

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
      c4:	00001064 	andeq	r1, r0, r4, rrx

000000c8 <drv_check_rw_data>:
      c8:	6001      	str	r1, [r0, #0]
      ca:	6803      	ldr	r3, [r0, #0]
      cc:	4293      	cmp	r3, r2
      ce:	d007      	beq.n	e0 <drv_check_rw_data+0x18>
      d0:	f04f 4380 	mov.w	r3, #1073741824	; 0x40000000
      d4:	2001      	movs	r0, #1
      d6:	6018      	str	r0, [r3, #0]
      d8:	685a      	ldr	r2, [r3, #4]
      da:	4402      	add	r2, r0
      dc:	601a      	str	r2, [r3, #0]
      de:	4770      	bx	lr
      e0:	2000      	movs	r0, #0
      e2:	f04f 4380 	mov.w	r3, #1073741824	; 0x40000000
      e6:	6018      	str	r0, [r3, #0]
      e8:	4770      	bx	lr
	...

000000ec <vprintf>:
      ec:	b500      	push	{lr}
      ee:	b091      	sub	sp, #68	; 0x44
      f0:	460a      	mov	r2, r1
      f2:	4601      	mov	r1, r0
      f4:	4668      	mov	r0, sp
      f6:	f000 fb03 	bl	700 <vsiprintf>
      fa:	2800      	cmp	r0, #0
      fc:	dc05      	bgt.n	10a <vprintf+0x1e>
      fe:	4668      	mov	r0, sp
     100:	f000 fae0 	bl	6c4 <strlen>
     104:	b011      	add	sp, #68	; 0x44
     106:	f85d fb04 	ldr.w	pc, [sp], #4
     10a:	4668      	mov	r0, sp
     10c:	f000 fada 	bl	6c4 <strlen>
     110:	b2c2      	uxtb	r2, r0
     112:	4669      	mov	r1, sp
     114:	4801      	ldr	r0, [pc, #4]	; (11c <vprintf+0x30>)
     116:	f000 f88b 	bl	230 <drv_uart_putchars>
     11a:	e7f0      	b.n	fe <vprintf+0x12>
     11c:	00020088 	andeq	r0, r2, r8, lsl #1

00000120 <drv_uart_printf>:
     120:	b40f      	push	{r0, r1, r2, r3}
     122:	b500      	push	{lr}
     124:	b083      	sub	sp, #12
     126:	a904      	add	r1, sp, #16
     128:	f851 0b04 	ldr.w	r0, [r1], #4
     12c:	9101      	str	r1, [sp, #4]
     12e:	f7ff ffdd 	bl	ec <vprintf>
     132:	b003      	add	sp, #12
     134:	f85d eb04 	ldr.w	lr, [sp], #4
     138:	b004      	add	sp, #16
     13a:	4770      	bx	lr

0000013c <drv_uart_default_config>:
     13c:	f44f 33e1 	mov.w	r3, #115200	; 0x1c200
     140:	6043      	str	r3, [r0, #4]
     142:	230f      	movs	r3, #15
     144:	7203      	strb	r3, [r0, #8]
     146:	2300      	movs	r3, #0
     148:	7243      	strb	r3, [r0, #9]
     14a:	7283      	strb	r3, [r0, #10]
     14c:	72c3      	strb	r3, [r0, #11]
     14e:	7303      	strb	r3, [r0, #12]
     150:	7343      	strb	r3, [r0, #13]
     152:	2301      	movs	r3, #1
     154:	7383      	strb	r3, [r0, #14]
     156:	4770      	bx	lr

00000158 <drv_uart_set_config>:
     158:	b508      	push	{r3, lr}
     15a:	6841      	ldr	r1, [r0, #4]
     15c:	7a03      	ldrb	r3, [r0, #8]
     15e:	fb03 f201 	mul.w	r2, r3, r1
     162:	490e      	ldr	r1, [pc, #56]	; (19c <drv_uart_set_config+0x44>)
     164:	fbb1 f2f2 	udiv	r2, r1, r2
     168:	0419      	lsls	r1, r3, #16
     16a:	ea41 5102 	orr.w	r1, r1, r2, lsl #20
     16e:	7a43      	ldrb	r3, [r0, #9]
     170:	ea41 3103 	orr.w	r1, r1, r3, lsl #12
     174:	7a83      	ldrb	r3, [r0, #10]
     176:	ea41 21c3 	orr.w	r1, r1, r3, lsl #11
     17a:	7ac3      	ldrb	r3, [r0, #11]
     17c:	ea41 1143 	orr.w	r1, r1, r3, lsl #5
     180:	7b03      	ldrb	r3, [r0, #12]
     182:	ea41 1103 	orr.w	r1, r1, r3, lsl #4
     186:	7b42      	ldrb	r2, [r0, #13]
     188:	ea41 0182 	orr.w	r1, r1, r2, lsl #2
     18c:	7b82      	ldrb	r2, [r0, #14]
     18e:	4311      	orrs	r1, r2
     190:	6800      	ldr	r0, [r0, #0]
     192:	460a      	mov	r2, r1
     194:	3008      	adds	r0, #8
     196:	f7ff ff97 	bl	c8 <drv_check_rw_data>
     19a:	bd08      	pop	{r3, pc}
     19c:	02625a00 	rsbeq	r5, r2, #0, 20

000001a0 <drv_uart_init>:
     1a0:	b538      	push	{r3, r4, r5, lr}
     1a2:	4604      	mov	r4, r0
     1a4:	2500      	movs	r5, #0
     1a6:	7485      	strb	r5, [r0, #18]
     1a8:	74c5      	strb	r5, [r0, #19]
     1aa:	f7ff ffd5 	bl	158 <drv_uart_set_config>
     1ae:	7425      	strb	r5, [r4, #16]
     1b0:	74a5      	strb	r5, [r4, #18]
     1b2:	74e5      	strb	r5, [r4, #19]
     1b4:	6822      	ldr	r2, [r4, #0]
     1b6:	6853      	ldr	r3, [r2, #4]
     1b8:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     1bc:	6053      	str	r3, [r2, #4]
     1be:	6822      	ldr	r2, [r4, #0]
     1c0:	6853      	ldr	r3, [r2, #4]
     1c2:	f423 7380 	bic.w	r3, r3, #256	; 0x100
     1c6:	6053      	str	r3, [r2, #4]
     1c8:	6822      	ldr	r2, [r4, #0]
     1ca:	6853      	ldr	r3, [r2, #4]
     1cc:	f443 7300 	orr.w	r3, r3, #512	; 0x200
     1d0:	6053      	str	r3, [r2, #4]
     1d2:	6822      	ldr	r2, [r4, #0]
     1d4:	6853      	ldr	r3, [r2, #4]
     1d6:	f423 7300 	bic.w	r3, r3, #512	; 0x200
     1da:	6053      	str	r3, [r2, #4]
     1dc:	6822      	ldr	r2, [r4, #0]
     1de:	6853      	ldr	r3, [r2, #4]
     1e0:	f443 6380 	orr.w	r3, r3, #1024	; 0x400
     1e4:	6053      	str	r3, [r2, #4]
     1e6:	6822      	ldr	r2, [r4, #0]
     1e8:	6853      	ldr	r3, [r2, #4]
     1ea:	f423 6380 	bic.w	r3, r3, #1024	; 0x400
     1ee:	6053      	str	r3, [r2, #4]
     1f0:	6822      	ldr	r2, [r4, #0]
     1f2:	6853      	ldr	r3, [r2, #4]
     1f4:	f443 6300 	orr.w	r3, r3, #2048	; 0x800
     1f8:	6053      	str	r3, [r2, #4]
     1fa:	6822      	ldr	r2, [r4, #0]
     1fc:	6853      	ldr	r3, [r2, #4]
     1fe:	f423 6300 	bic.w	r3, r3, #2048	; 0x800
     202:	6053      	str	r3, [r2, #4]
     204:	6823      	ldr	r3, [r4, #0]
     206:	f240 12ff 	movw	r2, #511	; 0x1ff
     20a:	611a      	str	r2, [r3, #16]
     20c:	6823      	ldr	r3, [r4, #0]
     20e:	611d      	str	r5, [r3, #16]
     210:	6822      	ldr	r2, [r4, #0]
     212:	6853      	ldr	r3, [r2, #4]
     214:	f043 0301 	orr.w	r3, r3, #1
     218:	6053      	str	r3, [r2, #4]
     21a:	6822      	ldr	r2, [r4, #0]
     21c:	6853      	ldr	r3, [r2, #4]
     21e:	f023 0301 	bic.w	r3, r3, #1
     222:	6053      	str	r3, [r2, #4]
     224:	6822      	ldr	r2, [r4, #0]
     226:	6853      	ldr	r3, [r2, #4]
     228:	f043 0302 	orr.w	r3, r3, #2
     22c:	6053      	str	r3, [r2, #4]
     22e:	bd38      	pop	{r3, r4, r5, pc}

00000230 <drv_uart_putchars>:
     230:	b410      	push	{r4}
     232:	2300      	movs	r3, #0
     234:	7483      	strb	r3, [r0, #18]
     236:	f890 c012 	ldrb.w	ip, [r0, #18]
     23a:	4594      	cmp	ip, r2
     23c:	d20c      	bcs.n	258 <drv_uart_putchars+0x28>
     23e:	6804      	ldr	r4, [r0, #0]
     240:	6963      	ldr	r3, [r4, #20]
     242:	0a1b      	lsrs	r3, r3, #8
     244:	f013 0f18 	tst.w	r3, #24
     248:	d1f5      	bne.n	236 <drv_uart_putchars+0x6>
     24a:	f10c 0301 	add.w	r3, ip, #1
     24e:	7483      	strb	r3, [r0, #18]
     250:	f811 300c 	ldrb.w	r3, [r1, ip]
     254:	6023      	str	r3, [r4, #0]
     256:	e7ee      	b.n	236 <drv_uart_putchars+0x6>
     258:	6803      	ldr	r3, [r0, #0]
     25a:	699a      	ldr	r2, [r3, #24]
     25c:	f412 7f80 	tst.w	r2, #256	; 0x100
     260:	d0fa      	beq.n	258 <drv_uart_putchars+0x28>
     262:	691a      	ldr	r2, [r3, #16]
     264:	f442 7280 	orr.w	r2, r2, #256	; 0x100
     268:	611a      	str	r2, [r3, #16]
     26a:	6803      	ldr	r3, [r0, #0]
     26c:	2200      	movs	r2, #0
     26e:	611a      	str	r2, [r3, #16]
     270:	bc10      	pop	{r4}
     272:	4770      	bx	lr

00000274 <drv_uart_putchar>:
     274:	6802      	ldr	r2, [r0, #0]
     276:	6953      	ldr	r3, [r2, #20]
     278:	0a1b      	lsrs	r3, r3, #8
     27a:	f013 0f18 	tst.w	r3, #24
     27e:	d101      	bne.n	284 <drv_uart_putchar+0x10>
     280:	780b      	ldrb	r3, [r1, #0]
     282:	6013      	str	r3, [r2, #0]
     284:	6803      	ldr	r3, [r0, #0]
     286:	699a      	ldr	r2, [r3, #24]
     288:	f412 7f80 	tst.w	r2, #256	; 0x100
     28c:	d0fa      	beq.n	284 <drv_uart_putchar+0x10>
     28e:	691a      	ldr	r2, [r3, #16]
     290:	f442 7280 	orr.w	r2, r2, #256	; 0x100
     294:	611a      	str	r2, [r3, #16]
     296:	6803      	ldr	r3, [r0, #0]
     298:	2200      	movs	r2, #0
     29a:	611a      	str	r2, [r3, #16]
     29c:	4770      	bx	lr

0000029e <drv_uart_getchar>:
     29e:	b410      	push	{r4}
     2a0:	e009      	b.n	2b6 <drv_uart_getchar+0x18>
     2a2:	69db      	ldr	r3, [r3, #28]
     2a4:	700b      	strb	r3, [r1, #0]
     2a6:	2000      	movs	r0, #0
     2a8:	bc10      	pop	{r4}
     2aa:	4770      	bx	lr
     2ac:	6803      	ldr	r3, [r0, #0]
     2ae:	695a      	ldr	r2, [r3, #20]
     2b0:	f012 0f1f 	tst.w	r2, #31
     2b4:	d1f5      	bne.n	2a2 <drv_uart_getchar+0x4>
     2b6:	6803      	ldr	r3, [r0, #0]
     2b8:	699c      	ldr	r4, [r3, #24]
     2ba:	691a      	ldr	r2, [r3, #16]
     2bc:	f042 02c0 	orr.w	r2, r2, #192	; 0xc0
     2c0:	611a      	str	r2, [r3, #16]
     2c2:	6803      	ldr	r3, [r0, #0]
     2c4:	2200      	movs	r2, #0
     2c6:	611a      	str	r2, [r3, #16]
     2c8:	b2a3      	uxth	r3, r4
     2ca:	f014 0f40 	tst.w	r4, #64	; 0x40
     2ce:	d001      	beq.n	2d4 <drv_uart_getchar+0x36>
     2d0:	2201      	movs	r2, #1
     2d2:	7402      	strb	r2, [r0, #16]
     2d4:	f013 0f80 	tst.w	r3, #128	; 0x80
     2d8:	d001      	beq.n	2de <drv_uart_getchar+0x40>
     2da:	2302      	movs	r3, #2
     2dc:	7403      	strb	r3, [r0, #16]
     2de:	7c03      	ldrb	r3, [r0, #16]
     2e0:	2b00      	cmp	r3, #0
     2e2:	d0e3      	beq.n	2ac <drv_uart_getchar+0xe>
     2e4:	7a83      	ldrb	r3, [r0, #10]
     2e6:	2b01      	cmp	r3, #1
     2e8:	d0e0      	beq.n	2ac <drv_uart_getchar+0xe>
     2ea:	2300      	movs	r3, #0
     2ec:	7403      	strb	r3, [r0, #16]
     2ee:	7483      	strb	r3, [r0, #18]
     2f0:	74c3      	strb	r3, [r0, #19]
     2f2:	6804      	ldr	r4, [r0, #0]
     2f4:	6862      	ldr	r2, [r4, #4]
     2f6:	f442 7280 	orr.w	r2, r2, #256	; 0x100
     2fa:	6062      	str	r2, [r4, #4]
     2fc:	6804      	ldr	r4, [r0, #0]
     2fe:	6862      	ldr	r2, [r4, #4]
     300:	f422 7280 	bic.w	r2, r2, #256	; 0x100
     304:	6062      	str	r2, [r4, #4]
     306:	6804      	ldr	r4, [r0, #0]
     308:	6862      	ldr	r2, [r4, #4]
     30a:	f442 7200 	orr.w	r2, r2, #512	; 0x200
     30e:	6062      	str	r2, [r4, #4]
     310:	6804      	ldr	r4, [r0, #0]
     312:	6862      	ldr	r2, [r4, #4]
     314:	f422 7200 	bic.w	r2, r2, #512	; 0x200
     318:	6062      	str	r2, [r4, #4]
     31a:	6804      	ldr	r4, [r0, #0]
     31c:	6862      	ldr	r2, [r4, #4]
     31e:	f442 6280 	orr.w	r2, r2, #1024	; 0x400
     322:	6062      	str	r2, [r4, #4]
     324:	6804      	ldr	r4, [r0, #0]
     326:	6862      	ldr	r2, [r4, #4]
     328:	f422 6280 	bic.w	r2, r2, #1024	; 0x400
     32c:	6062      	str	r2, [r4, #4]
     32e:	6804      	ldr	r4, [r0, #0]
     330:	6862      	ldr	r2, [r4, #4]
     332:	f442 6200 	orr.w	r2, r2, #2048	; 0x800
     336:	6062      	str	r2, [r4, #4]
     338:	6800      	ldr	r0, [r0, #0]
     33a:	6842      	ldr	r2, [r0, #4]
     33c:	f422 6200 	bic.w	r2, r2, #2048	; 0x800
     340:	6042      	str	r2, [r0, #4]
     342:	700b      	strb	r3, [r1, #0]
     344:	2001      	movs	r0, #1
     346:	e7af      	b.n	2a8 <drv_uart_getchar+0xa>

00000348 <uart_int_tx_done_callback>:
     348:	4770      	bx	lr

0000034a <uart_int_rx_stop_callback>:
     34a:	4770      	bx	lr

0000034c <uart_int_rx_parity_error_callback>:
     34c:	4770      	bx	lr

0000034e <uart_int_rx_noise_detect_callback>:
     34e:	4770      	bx	lr

00000350 <uart_int_rx_stop_detect_callback>:
     350:	4770      	bx	lr

00000352 <uart_int_tx_fifo_empty_callback>:
     352:	4770      	bx	lr

00000354 <uart_int_tx_fifo_thres_callback>:
     354:	4770      	bx	lr

00000356 <uart_int_rx_fifo_noempty_callback>:
     356:	4770      	bx	lr

00000358 <uart_int_rx_fifo_thres_callback>:
     358:	4770      	bx	lr

0000035a <drv_uart_interrupt_handler>:
     35a:	b538      	push	{r3, r4, r5, lr}
     35c:	4604      	mov	r4, r0
     35e:	6803      	ldr	r3, [r0, #0]
     360:	699d      	ldr	r5, [r3, #24]
     362:	68db      	ldr	r3, [r3, #12]
     364:	b29b      	uxth	r3, r3
     366:	401d      	ands	r5, r3
     368:	f415 7f80 	tst.w	r5, #256	; 0x100
     36c:	d144      	bne.n	3f8 <drv_uart_interrupt_handler+0x9e>
     36e:	f015 0f40 	tst.w	r5, #64	; 0x40
     372:	d00f      	beq.n	394 <drv_uart_interrupt_handler+0x3a>
     374:	2301      	movs	r3, #1
     376:	7423      	strb	r3, [r4, #16]
     378:	7aa3      	ldrb	r3, [r4, #10]
     37a:	2b01      	cmp	r3, #1
     37c:	d147      	bne.n	40e <drv_uart_interrupt_handler+0xb4>
     37e:	4620      	mov	r0, r4
     380:	f7ff ffe3 	bl	34a <uart_int_rx_stop_callback>
     384:	6822      	ldr	r2, [r4, #0]
     386:	6913      	ldr	r3, [r2, #16]
     388:	f043 0340 	orr.w	r3, r3, #64	; 0x40
     38c:	6113      	str	r3, [r2, #16]
     38e:	6823      	ldr	r3, [r4, #0]
     390:	2200      	movs	r2, #0
     392:	611a      	str	r2, [r3, #16]
     394:	f015 0f80 	tst.w	r5, #128	; 0x80
     398:	d00f      	beq.n	3ba <drv_uart_interrupt_handler+0x60>
     39a:	2302      	movs	r3, #2
     39c:	7423      	strb	r3, [r4, #16]
     39e:	7aa3      	ldrb	r3, [r4, #10]
     3a0:	2b01      	cmp	r3, #1
     3a2:	d166      	bne.n	472 <drv_uart_interrupt_handler+0x118>
     3a4:	4620      	mov	r0, r4
     3a6:	f7ff ffd1 	bl	34c <uart_int_rx_parity_error_callback>
     3aa:	6822      	ldr	r2, [r4, #0]
     3ac:	6913      	ldr	r3, [r2, #16]
     3ae:	f043 0380 	orr.w	r3, r3, #128	; 0x80
     3b2:	6113      	str	r3, [r2, #16]
     3b4:	6823      	ldr	r3, [r4, #0]
     3b6:	2200      	movs	r2, #0
     3b8:	611a      	str	r2, [r3, #16]
     3ba:	f015 0f20 	tst.w	r5, #32
     3be:	f040 808a 	bne.w	4d6 <drv_uart_interrupt_handler+0x17c>
     3c2:	f015 0f10 	tst.w	r5, #16
     3c6:	f040 8092 	bne.w	4ee <drv_uart_interrupt_handler+0x194>
     3ca:	f015 0f01 	tst.w	r5, #1
     3ce:	f040 809a 	bne.w	506 <drv_uart_interrupt_handler+0x1ac>
     3d2:	f015 0f02 	tst.w	r5, #2
     3d6:	f040 80a2 	bne.w	51e <drv_uart_interrupt_handler+0x1c4>
     3da:	f015 0f04 	tst.w	r5, #4
     3de:	f000 80c1 	beq.w	564 <drv_uart_interrupt_handler+0x20a>
     3e2:	7ce2      	ldrb	r2, [r4, #19]
     3e4:	7e23      	ldrb	r3, [r4, #24]
     3e6:	429a      	cmp	r2, r3
     3e8:	f0c0 80ac 	bcc.w	544 <drv_uart_interrupt_handler+0x1ea>
     3ec:	6822      	ldr	r2, [r4, #0]
     3ee:	68d3      	ldr	r3, [r2, #12]
     3f0:	f023 030c 	bic.w	r3, r3, #12
     3f4:	60d3      	str	r3, [r2, #12]
     3f6:	e0aa      	b.n	54e <drv_uart_interrupt_handler+0x1f4>
     3f8:	f7ff ffa6 	bl	348 <uart_int_tx_done_callback>
     3fc:	6822      	ldr	r2, [r4, #0]
     3fe:	6913      	ldr	r3, [r2, #16]
     400:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     404:	6113      	str	r3, [r2, #16]
     406:	6823      	ldr	r3, [r4, #0]
     408:	2200      	movs	r2, #0
     40a:	611a      	str	r2, [r3, #16]
     40c:	e7af      	b.n	36e <drv_uart_interrupt_handler+0x14>
     40e:	6822      	ldr	r2, [r4, #0]
     410:	68d3      	ldr	r3, [r2, #12]
     412:	f023 03cc 	bic.w	r3, r3, #204	; 0xcc
     416:	60d3      	str	r3, [r2, #12]
     418:	2300      	movs	r3, #0
     41a:	7423      	strb	r3, [r4, #16]
     41c:	74a3      	strb	r3, [r4, #18]
     41e:	74e3      	strb	r3, [r4, #19]
     420:	6822      	ldr	r2, [r4, #0]
     422:	6853      	ldr	r3, [r2, #4]
     424:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     428:	6053      	str	r3, [r2, #4]
     42a:	6822      	ldr	r2, [r4, #0]
     42c:	6853      	ldr	r3, [r2, #4]
     42e:	f423 7380 	bic.w	r3, r3, #256	; 0x100
     432:	6053      	str	r3, [r2, #4]
     434:	6822      	ldr	r2, [r4, #0]
     436:	6853      	ldr	r3, [r2, #4]
     438:	f443 7300 	orr.w	r3, r3, #512	; 0x200
     43c:	6053      	str	r3, [r2, #4]
     43e:	6822      	ldr	r2, [r4, #0]
     440:	6853      	ldr	r3, [r2, #4]
     442:	f423 7300 	bic.w	r3, r3, #512	; 0x200
     446:	6053      	str	r3, [r2, #4]
     448:	6822      	ldr	r2, [r4, #0]
     44a:	6853      	ldr	r3, [r2, #4]
     44c:	f443 6380 	orr.w	r3, r3, #1024	; 0x400
     450:	6053      	str	r3, [r2, #4]
     452:	6822      	ldr	r2, [r4, #0]
     454:	6853      	ldr	r3, [r2, #4]
     456:	f423 6380 	bic.w	r3, r3, #1024	; 0x400
     45a:	6053      	str	r3, [r2, #4]
     45c:	6822      	ldr	r2, [r4, #0]
     45e:	6853      	ldr	r3, [r2, #4]
     460:	f443 6300 	orr.w	r3, r3, #2048	; 0x800
     464:	6053      	str	r3, [r2, #4]
     466:	6822      	ldr	r2, [r4, #0]
     468:	6853      	ldr	r3, [r2, #4]
     46a:	f423 6300 	bic.w	r3, r3, #2048	; 0x800
     46e:	6053      	str	r3, [r2, #4]
     470:	e785      	b.n	37e <drv_uart_interrupt_handler+0x24>
     472:	6822      	ldr	r2, [r4, #0]
     474:	68d3      	ldr	r3, [r2, #12]
     476:	f023 03cc 	bic.w	r3, r3, #204	; 0xcc
     47a:	60d3      	str	r3, [r2, #12]
     47c:	2300      	movs	r3, #0
     47e:	7423      	strb	r3, [r4, #16]
     480:	74a3      	strb	r3, [r4, #18]
     482:	74e3      	strb	r3, [r4, #19]
     484:	6822      	ldr	r2, [r4, #0]
     486:	6853      	ldr	r3, [r2, #4]
     488:	f443 7380 	orr.w	r3, r3, #256	; 0x100
     48c:	6053      	str	r3, [r2, #4]
     48e:	6822      	ldr	r2, [r4, #0]
     490:	6853      	ldr	r3, [r2, #4]
     492:	f423 7380 	bic.w	r3, r3, #256	; 0x100
     496:	6053      	str	r3, [r2, #4]
     498:	6822      	ldr	r2, [r4, #0]
     49a:	6853      	ldr	r3, [r2, #4]
     49c:	f443 7300 	orr.w	r3, r3, #512	; 0x200
     4a0:	6053      	str	r3, [r2, #4]
     4a2:	6822      	ldr	r2, [r4, #0]
     4a4:	6853      	ldr	r3, [r2, #4]
     4a6:	f423 7300 	bic.w	r3, r3, #512	; 0x200
     4aa:	6053      	str	r3, [r2, #4]
     4ac:	6822      	ldr	r2, [r4, #0]
     4ae:	6853      	ldr	r3, [r2, #4]
     4b0:	f443 6380 	orr.w	r3, r3, #1024	; 0x400
     4b4:	6053      	str	r3, [r2, #4]
     4b6:	6822      	ldr	r2, [r4, #0]
     4b8:	6853      	ldr	r3, [r2, #4]
     4ba:	f423 6380 	bic.w	r3, r3, #1024	; 0x400
     4be:	6053      	str	r3, [r2, #4]
     4c0:	6822      	ldr	r2, [r4, #0]
     4c2:	6853      	ldr	r3, [r2, #4]
     4c4:	f443 6300 	orr.w	r3, r3, #2048	; 0x800
     4c8:	6053      	str	r3, [r2, #4]
     4ca:	6822      	ldr	r2, [r4, #0]
     4cc:	6853      	ldr	r3, [r2, #4]
     4ce:	f423 6300 	bic.w	r3, r3, #2048	; 0x800
     4d2:	6053      	str	r3, [r2, #4]
     4d4:	e766      	b.n	3a4 <drv_uart_interrupt_handler+0x4a>
     4d6:	4620      	mov	r0, r4
     4d8:	f7ff ff39 	bl	34e <uart_int_rx_noise_detect_callback>
     4dc:	6822      	ldr	r2, [r4, #0]
     4de:	6913      	ldr	r3, [r2, #16]
     4e0:	f043 0320 	orr.w	r3, r3, #32
     4e4:	6113      	str	r3, [r2, #16]
     4e6:	6823      	ldr	r3, [r4, #0]
     4e8:	2200      	movs	r2, #0
     4ea:	611a      	str	r2, [r3, #16]
     4ec:	e769      	b.n	3c2 <drv_uart_interrupt_handler+0x68>
     4ee:	4620      	mov	r0, r4
     4f0:	f7ff ff2e 	bl	350 <uart_int_rx_stop_detect_callback>
     4f4:	6822      	ldr	r2, [r4, #0]
     4f6:	6913      	ldr	r3, [r2, #16]
     4f8:	f043 0310 	orr.w	r3, r3, #16
     4fc:	6113      	str	r3, [r2, #16]
     4fe:	6823      	ldr	r3, [r4, #0]
     500:	2200      	movs	r2, #0
     502:	611a      	str	r2, [r3, #16]
     504:	e761      	b.n	3ca <drv_uart_interrupt_handler+0x70>
     506:	4620      	mov	r0, r4
     508:	f7ff ff24 	bl	354 <uart_int_tx_fifo_thres_callback>
     50c:	6822      	ldr	r2, [r4, #0]
     50e:	6913      	ldr	r3, [r2, #16]
     510:	f043 0301 	orr.w	r3, r3, #1
     514:	6113      	str	r3, [r2, #16]
     516:	6823      	ldr	r3, [r4, #0]
     518:	2200      	movs	r2, #0
     51a:	611a      	str	r2, [r3, #16]
     51c:	e759      	b.n	3d2 <drv_uart_interrupt_handler+0x78>
     51e:	4620      	mov	r0, r4
     520:	f7ff ff17 	bl	352 <uart_int_tx_fifo_empty_callback>
     524:	6822      	ldr	r2, [r4, #0]
     526:	6913      	ldr	r3, [r2, #16]
     528:	f043 0302 	orr.w	r3, r3, #2
     52c:	6113      	str	r3, [r2, #16]
     52e:	6823      	ldr	r3, [r4, #0]
     530:	2200      	movs	r2, #0
     532:	611a      	str	r2, [r3, #16]
     534:	e751      	b.n	3da <drv_uart_interrupt_handler+0x80>
     536:	69d9      	ldr	r1, [r3, #28]
     538:	6962      	ldr	r2, [r4, #20]
     53a:	7ce3      	ldrb	r3, [r4, #19]
     53c:	1c58      	adds	r0, r3, #1
     53e:	74e0      	strb	r0, [r4, #19]
     540:	f822 1013 	strh.w	r1, [r2, r3, lsl #1]
     544:	6823      	ldr	r3, [r4, #0]
     546:	695a      	ldr	r2, [r3, #20]
     548:	f012 0f1f 	tst.w	r2, #31
     54c:	d1f3      	bne.n	536 <drv_uart_interrupt_handler+0x1dc>
     54e:	4620      	mov	r0, r4
     550:	f7ff ff02 	bl	358 <uart_int_rx_fifo_thres_callback>
     554:	6822      	ldr	r2, [r4, #0]
     556:	6913      	ldr	r3, [r2, #16]
     558:	f043 0304 	orr.w	r3, r3, #4
     55c:	6113      	str	r3, [r2, #16]
     55e:	6823      	ldr	r3, [r4, #0]
     560:	2200      	movs	r2, #0
     562:	611a      	str	r2, [r3, #16]
     564:	f015 0f08 	tst.w	r5, #8
     568:	d020      	beq.n	5ac <drv_uart_interrupt_handler+0x252>
     56a:	7ce2      	ldrb	r2, [r4, #19]
     56c:	7e23      	ldrb	r3, [r4, #24]
     56e:	429a      	cmp	r2, r3
     570:	d30c      	bcc.n	58c <drv_uart_interrupt_handler+0x232>
     572:	6822      	ldr	r2, [r4, #0]
     574:	68d3      	ldr	r3, [r2, #12]
     576:	f023 030c 	bic.w	r3, r3, #12
     57a:	60d3      	str	r3, [r2, #12]
     57c:	e00b      	b.n	596 <drv_uart_interrupt_handler+0x23c>
     57e:	69d9      	ldr	r1, [r3, #28]
     580:	6962      	ldr	r2, [r4, #20]
     582:	7ce3      	ldrb	r3, [r4, #19]
     584:	1c58      	adds	r0, r3, #1
     586:	74e0      	strb	r0, [r4, #19]
     588:	f822 1013 	strh.w	r1, [r2, r3, lsl #1]
     58c:	6823      	ldr	r3, [r4, #0]
     58e:	695a      	ldr	r2, [r3, #20]
     590:	f012 0f1f 	tst.w	r2, #31
     594:	d1f3      	bne.n	57e <drv_uart_interrupt_handler+0x224>
     596:	4620      	mov	r0, r4
     598:	f7ff fedd 	bl	356 <uart_int_rx_fifo_noempty_callback>
     59c:	6822      	ldr	r2, [r4, #0]
     59e:	6913      	ldr	r3, [r2, #16]
     5a0:	f043 0308 	orr.w	r3, r3, #8
     5a4:	6113      	str	r3, [r2, #16]
     5a6:	6823      	ldr	r3, [r4, #0]
     5a8:	2200      	movs	r2, #0
     5aa:	611a      	str	r2, [r3, #16]
     5ac:	bd38      	pop	{r3, r4, r5, pc}

000005ae <NMI_Handler>:
     5ae:	4770      	bx	lr

000005b0 <HardFault_Handler>:
     5b0:	e7fe      	b.n	5b0 <HardFault_Handler>

000005b2 <MemManage_Handler>:
     5b2:	e7fe      	b.n	5b2 <MemManage_Handler>

000005b4 <BusFault_Handler>:
     5b4:	e7fe      	b.n	5b4 <BusFault_Handler>

000005b6 <UsageFault_Handler>:
     5b6:	e7fe      	b.n	5b6 <UsageFault_Handler>

000005b8 <SVC_Handler>:
     5b8:	4770      	bx	lr

000005ba <DebugMon_Handler>:
     5ba:	4770      	bx	lr

000005bc <PendSV_Handler>:
     5bc:	4770      	bx	lr

000005be <SysTick_Handler>:
     5be:	4770      	bx	lr

000005c0 <Uart0_Handler>:
     5c0:	b508      	push	{r3, lr}
     5c2:	4b04      	ldr	r3, [pc, #16]	; (5d4 <Uart0_Handler+0x14>)
     5c4:	2201      	movs	r2, #1
     5c6:	f8c3 2180 	str.w	r2, [r3, #384]	; 0x180
     5ca:	4803      	ldr	r0, [pc, #12]	; (5d8 <Uart0_Handler+0x18>)
     5cc:	f7ff fec5 	bl	35a <drv_uart_interrupt_handler>
     5d0:	bd08      	pop	{r3, pc}
     5d2:	bf00      	nop
     5d4:	e000e100 	and	lr, r0, r0, lsl #2
     5d8:	00020088 	andeq	r0, r2, r8, lsl #1

000005dc <main>:
     5dc:	b500      	push	{lr}
     5de:	b083      	sub	sp, #12
     5e0:	4c0d      	ldr	r4, [pc, #52]	; (618 <main+0x3c>)
     5e2:	4b0e      	ldr	r3, [pc, #56]	; (61c <main+0x40>)
     5e4:	6023      	str	r3, [r4, #0]
     5e6:	4620      	mov	r0, r4
     5e8:	f7ff fda8 	bl	13c <drv_uart_default_config>
     5ec:	4620      	mov	r0, r4
     5ee:	f7ff fdd7 	bl	1a0 <drv_uart_init>
     5f2:	480b      	ldr	r0, [pc, #44]	; (620 <main+0x44>)
     5f4:	f7ff fd94 	bl	120 <drv_uart_printf>
     5f8:	f04f 4380 	mov.w	r3, #1073741824	; 0x40000000
     5fc:	22ed      	movs	r2, #237	; 0xed
     5fe:	601a      	str	r2, [r3, #0]
     600:	4c05      	ldr	r4, [pc, #20]	; (618 <main+0x3c>)
     602:	f10d 0107 	add.w	r1, sp, #7
     606:	4620      	mov	r0, r4
     608:	f7ff fe49 	bl	29e <drv_uart_getchar>
     60c:	f10d 0107 	add.w	r1, sp, #7
     610:	4620      	mov	r0, r4
     612:	f7ff fe2f 	bl	274 <drv_uart_putchar>
     616:	e7f3      	b.n	600 <main+0x24>
     618:	00020088 	andeq	r0, r2, r8, lsl #1
     61c:	40001000 	andmi	r1, r0, r0
     620:	00001000 	andeq	r1, r0, r0

00000624 <Reset_Handler>:
     624:	490a      	ldr	r1, [pc, #40]	; (650 <Reset_Handler+0x2c>)
     626:	4a0b      	ldr	r2, [pc, #44]	; (654 <Reset_Handler+0x30>)
     628:	4b0b      	ldr	r3, [pc, #44]	; (658 <Reset_Handler+0x34>)
     62a:	1a9b      	subs	r3, r3, r2
     62c:	dd03      	ble.n	636 <Reset_Handler+0x12>
     62e:	3b04      	subs	r3, #4
     630:	58c8      	ldr	r0, [r1, r3]
     632:	50d0      	str	r0, [r2, r3]
     634:	dcfb      	bgt.n	62e <Reset_Handler+0xa>
     636:	4909      	ldr	r1, [pc, #36]	; (65c <Reset_Handler+0x38>)
     638:	4a09      	ldr	r2, [pc, #36]	; (660 <Reset_Handler+0x3c>)
     63a:	2000      	movs	r0, #0
     63c:	4291      	cmp	r1, r2
     63e:	bfbc      	itt	lt
     640:	f841 0b04 	strlt.w	r0, [r1], #4
     644:	e7fa      	blt.n	63c <Reset_Handler+0x18>
     646:	f7ff ffc9 	bl	5dc <main>
     64a:	f000 f827 	bl	69c <exit>
     64e:	10680000 	rsbne	r0, r8, r0
     652:	00000000 	andeq	r0, r0, r0
     656:	006c0002 	rsbeq	r0, ip, r2
     65a:	006c0002 	rsbeq	r0, ip, r2
     65e:	00b80002 	adcseq	r0, r8, r2
     662:	e7fe0002 	ldrb	r0, [lr, r2]!
     666:	e7fe      	b.n	666 <Reset_Handler+0x42>
     668:	e7fe      	b.n	668 <Reset_Handler+0x44>
     66a:	e7fe      	b.n	66a <Reset_Handler+0x46>
     66c:	e7fe      	b.n	66c <Reset_Handler+0x48>
     66e:	e7fe      	b.n	66e <Reset_Handler+0x4a>
     670:	e7fe      	b.n	670 <Reset_Handler+0x4c>
     672:	e7fe      	b.n	672 <Reset_Handler+0x4e>
     674:	e7fe      	b.n	674 <Reset_Handler+0x50>
     676:	e7fe      	b.n	676 <Reset_Handler+0x52>

00000678 <Uart1_Handler>:
     678:	e7fe      	b.n	678 <Uart1_Handler>

0000067a <Resv2_Handler>:
     67a:	e7fe      	b.n	67a <Resv2_Handler>

0000067c <Resv3_Handler>:
     67c:	e7fe      	b.n	67c <Resv3_Handler>

0000067e <EthDma_Handler>:
     67e:	e7fe      	b.n	67e <EthDma_Handler>

00000680 <Gpioa_Handler>:
     680:	e7fe      	b.n	680 <Gpioa_Handler>

00000682 <Resv6_Handler>:
     682:	e7fe      	b.n	682 <Resv6_Handler>

00000684 <Resv7_Handler>:
     684:	e7fe      	b.n	684 <Resv7_Handler>

00000686 <Bastim_Ch0_Handler>:
     686:	e7fe      	b.n	686 <Bastim_Ch0_Handler>

00000688 <Bastim_Ch1_Handler>:
     688:	e7fe      	b.n	688 <Bastim_Ch1_Handler>

0000068a <Bastim_Ch2_Handler>:
     68a:	e7fe      	b.n	68a <Bastim_Ch2_Handler>

0000068c <Bastim_Ch3_Handler>:
     68c:	e7fe      	b.n	68c <Bastim_Ch3_Handler>

0000068e <EthSma_Handler>:
     68e:	e7fe      	b.n	68e <EthSma_Handler>

00000690 <EthTx_Handler>:
     690:	e7fe      	b.n	690 <EthTx_Handler>

00000692 <EthRx_Handler>:
     692:	e7fe      	b.n	692 <EthRx_Handler>

00000694 <Resv15_Handler>:
     694:	e7fe      	b.n	694 <Resv15_Handler>

00000696 <AdvtimGen_Handler>:
     696:	e7fe      	b.n	696 <AdvtimGen_Handler>

00000698 <AdvtimCap_Handler>:
     698:	e7fe      	b.n	698 <AdvtimCap_Handler>
     69a:	bf00      	nop

0000069c <exit>:
     69c:	b508      	push	{r3, lr}
     69e:	4b07      	ldr	r3, [pc, #28]	; (6bc <exit+0x20>)
     6a0:	4604      	mov	r4, r0
     6a2:	b113      	cbz	r3, 6aa <exit+0xe>
     6a4:	2100      	movs	r1, #0
     6a6:	f3af 8000 	nop.w
     6aa:	4b05      	ldr	r3, [pc, #20]	; (6c0 <exit+0x24>)
     6ac:	6818      	ldr	r0, [r3, #0]
     6ae:	6a83      	ldr	r3, [r0, #40]	; 0x28
     6b0:	b103      	cbz	r3, 6b4 <exit+0x18>
     6b2:	4798      	blx	r3
     6b4:	4620      	mov	r0, r4
     6b6:	f000 fc95 	bl	fe4 <_exit>
     6ba:	bf00      	nop
     6bc:	00000000 	andeq	r0, r0, r0
     6c0:	0000102c 	andeq	r1, r0, ip, lsr #32

000006c4 <strlen>:
     6c4:	4603      	mov	r3, r0
     6c6:	f813 2b01 	ldrb.w	r2, [r3], #1
     6ca:	2a00      	cmp	r2, #0
     6cc:	d1fb      	bne.n	6c6 <strlen+0x2>
     6ce:	1a18      	subs	r0, r3, r0
     6d0:	3801      	subs	r0, #1
     6d2:	4770      	bx	lr

000006d4 <_vsiprintf_r>:
     6d4:	b500      	push	{lr}
     6d6:	b09b      	sub	sp, #108	; 0x6c
     6d8:	9100      	str	r1, [sp, #0]
     6da:	9104      	str	r1, [sp, #16]
     6dc:	f06f 4100 	mvn.w	r1, #2147483648	; 0x80000000
     6e0:	9105      	str	r1, [sp, #20]
     6e2:	9102      	str	r1, [sp, #8]
     6e4:	4905      	ldr	r1, [pc, #20]	; (6fc <_vsiprintf_r+0x28>)
     6e6:	9103      	str	r1, [sp, #12]
     6e8:	4669      	mov	r1, sp
     6ea:	f000 f86f 	bl	7cc <_svfiprintf_r>
     6ee:	2200      	movs	r2, #0
     6f0:	9b00      	ldr	r3, [sp, #0]
     6f2:	701a      	strb	r2, [r3, #0]
     6f4:	b01b      	add	sp, #108	; 0x6c
     6f6:	f85d fb04 	ldr.w	pc, [sp], #4
     6fa:	bf00      	nop
     6fc:	ffff0208 			; <UNDEFINED> instruction: 0xffff0208

00000700 <vsiprintf>:
     700:	4613      	mov	r3, r2
     702:	460a      	mov	r2, r1
     704:	4601      	mov	r1, r0
     706:	4802      	ldr	r0, [pc, #8]	; (710 <vsiprintf+0x10>)
     708:	6800      	ldr	r0, [r0, #0]
     70a:	f7ff bfe3 	b.w	6d4 <_vsiprintf_r>
     70e:	bf00      	nop
     710:	00020000 	andeq	r0, r2, r0

00000714 <__ssputs_r>:
     714:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
     718:	688e      	ldr	r6, [r1, #8]
     71a:	4682      	mov	sl, r0
     71c:	429e      	cmp	r6, r3
     71e:	460c      	mov	r4, r1
     720:	4690      	mov	r8, r2
     722:	461f      	mov	r7, r3
     724:	d838      	bhi.n	798 <__ssputs_r+0x84>
     726:	898a      	ldrh	r2, [r1, #12]
     728:	f412 6f90 	tst.w	r2, #1152	; 0x480
     72c:	d032      	beq.n	794 <__ssputs_r+0x80>
     72e:	6825      	ldr	r5, [r4, #0]
     730:	6909      	ldr	r1, [r1, #16]
     732:	3301      	adds	r3, #1
     734:	eba5 0901 	sub.w	r9, r5, r1
     738:	6965      	ldr	r5, [r4, #20]
     73a:	444b      	add	r3, r9
     73c:	eb05 0545 	add.w	r5, r5, r5, lsl #1
     740:	eb05 75d5 	add.w	r5, r5, r5, lsr #31
     744:	106d      	asrs	r5, r5, #1
     746:	429d      	cmp	r5, r3
     748:	bf38      	it	cc
     74a:	461d      	movcc	r5, r3
     74c:	0553      	lsls	r3, r2, #21
     74e:	d531      	bpl.n	7b4 <__ssputs_r+0xa0>
     750:	4629      	mov	r1, r5
     752:	f000 fb6f 	bl	e34 <_malloc_r>
     756:	4606      	mov	r6, r0
     758:	b950      	cbnz	r0, 770 <__ssputs_r+0x5c>
     75a:	230c      	movs	r3, #12
     75c:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     760:	f8ca 3000 	str.w	r3, [sl]
     764:	89a3      	ldrh	r3, [r4, #12]
     766:	f043 0340 	orr.w	r3, r3, #64	; 0x40
     76a:	81a3      	strh	r3, [r4, #12]
     76c:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
     770:	464a      	mov	r2, r9
     772:	6921      	ldr	r1, [r4, #16]
     774:	f000 face 	bl	d14 <memcpy>
     778:	89a3      	ldrh	r3, [r4, #12]
     77a:	f423 6390 	bic.w	r3, r3, #1152	; 0x480
     77e:	f043 0380 	orr.w	r3, r3, #128	; 0x80
     782:	81a3      	strh	r3, [r4, #12]
     784:	6126      	str	r6, [r4, #16]
     786:	444e      	add	r6, r9
     788:	6026      	str	r6, [r4, #0]
     78a:	463e      	mov	r6, r7
     78c:	6165      	str	r5, [r4, #20]
     78e:	eba5 0509 	sub.w	r5, r5, r9
     792:	60a5      	str	r5, [r4, #8]
     794:	42be      	cmp	r6, r7
     796:	d900      	bls.n	79a <__ssputs_r+0x86>
     798:	463e      	mov	r6, r7
     79a:	4632      	mov	r2, r6
     79c:	4641      	mov	r1, r8
     79e:	6820      	ldr	r0, [r4, #0]
     7a0:	f000 fac6 	bl	d30 <memmove>
     7a4:	68a3      	ldr	r3, [r4, #8]
     7a6:	2000      	movs	r0, #0
     7a8:	1b9b      	subs	r3, r3, r6
     7aa:	60a3      	str	r3, [r4, #8]
     7ac:	6823      	ldr	r3, [r4, #0]
     7ae:	4433      	add	r3, r6
     7b0:	6023      	str	r3, [r4, #0]
     7b2:	e7db      	b.n	76c <__ssputs_r+0x58>
     7b4:	462a      	mov	r2, r5
     7b6:	f000 fbb1 	bl	f1c <_realloc_r>
     7ba:	4606      	mov	r6, r0
     7bc:	2800      	cmp	r0, #0
     7be:	d1e1      	bne.n	784 <__ssputs_r+0x70>
     7c0:	4650      	mov	r0, sl
     7c2:	6921      	ldr	r1, [r4, #16]
     7c4:	f000 face 	bl	d64 <_free_r>
     7c8:	e7c7      	b.n	75a <__ssputs_r+0x46>
	...

000007cc <_svfiprintf_r>:
     7cc:	e92d 4ff0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, lr}
     7d0:	4698      	mov	r8, r3
     7d2:	898b      	ldrh	r3, [r1, #12]
     7d4:	4607      	mov	r7, r0
     7d6:	061b      	lsls	r3, r3, #24
     7d8:	460d      	mov	r5, r1
     7da:	4614      	mov	r4, r2
     7dc:	b09d      	sub	sp, #116	; 0x74
     7de:	d50e      	bpl.n	7fe <_svfiprintf_r+0x32>
     7e0:	690b      	ldr	r3, [r1, #16]
     7e2:	b963      	cbnz	r3, 7fe <_svfiprintf_r+0x32>
     7e4:	2140      	movs	r1, #64	; 0x40
     7e6:	f000 fb25 	bl	e34 <_malloc_r>
     7ea:	6028      	str	r0, [r5, #0]
     7ec:	6128      	str	r0, [r5, #16]
     7ee:	b920      	cbnz	r0, 7fa <_svfiprintf_r+0x2e>
     7f0:	230c      	movs	r3, #12
     7f2:	603b      	str	r3, [r7, #0]
     7f4:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     7f8:	e0d1      	b.n	99e <_svfiprintf_r+0x1d2>
     7fa:	2340      	movs	r3, #64	; 0x40
     7fc:	616b      	str	r3, [r5, #20]
     7fe:	2300      	movs	r3, #0
     800:	9309      	str	r3, [sp, #36]	; 0x24
     802:	2320      	movs	r3, #32
     804:	f88d 3029 	strb.w	r3, [sp, #41]	; 0x29
     808:	2330      	movs	r3, #48	; 0x30
     80a:	f04f 0901 	mov.w	r9, #1
     80e:	f8cd 800c 	str.w	r8, [sp, #12]
     812:	f8df 81a4 	ldr.w	r8, [pc, #420]	; 9b8 <_svfiprintf_r+0x1ec>
     816:	f88d 302a 	strb.w	r3, [sp, #42]	; 0x2a
     81a:	4623      	mov	r3, r4
     81c:	469a      	mov	sl, r3
     81e:	f813 2b01 	ldrb.w	r2, [r3], #1
     822:	b10a      	cbz	r2, 828 <_svfiprintf_r+0x5c>
     824:	2a25      	cmp	r2, #37	; 0x25
     826:	d1f9      	bne.n	81c <_svfiprintf_r+0x50>
     828:	ebba 0b04 	subs.w	fp, sl, r4
     82c:	d00b      	beq.n	846 <_svfiprintf_r+0x7a>
     82e:	465b      	mov	r3, fp
     830:	4622      	mov	r2, r4
     832:	4629      	mov	r1, r5
     834:	4638      	mov	r0, r7
     836:	f7ff ff6d 	bl	714 <__ssputs_r>
     83a:	3001      	adds	r0, #1
     83c:	f000 80aa 	beq.w	994 <_svfiprintf_r+0x1c8>
     840:	9a09      	ldr	r2, [sp, #36]	; 0x24
     842:	445a      	add	r2, fp
     844:	9209      	str	r2, [sp, #36]	; 0x24
     846:	f89a 3000 	ldrb.w	r3, [sl]
     84a:	2b00      	cmp	r3, #0
     84c:	f000 80a2 	beq.w	994 <_svfiprintf_r+0x1c8>
     850:	2300      	movs	r3, #0
     852:	f04f 32ff 	mov.w	r2, #4294967295	; 0xffffffff
     856:	e9cd 2305 	strd	r2, r3, [sp, #20]
     85a:	f10a 0a01 	add.w	sl, sl, #1
     85e:	9304      	str	r3, [sp, #16]
     860:	9307      	str	r3, [sp, #28]
     862:	f88d 3053 	strb.w	r3, [sp, #83]	; 0x53
     866:	931a      	str	r3, [sp, #104]	; 0x68
     868:	4654      	mov	r4, sl
     86a:	2205      	movs	r2, #5
     86c:	f814 1b01 	ldrb.w	r1, [r4], #1
     870:	4851      	ldr	r0, [pc, #324]	; (9b8 <_svfiprintf_r+0x1ec>)
     872:	f000 fa41 	bl	cf8 <memchr>
     876:	9a04      	ldr	r2, [sp, #16]
     878:	b9d8      	cbnz	r0, 8b2 <_svfiprintf_r+0xe6>
     87a:	06d0      	lsls	r0, r2, #27
     87c:	bf44      	itt	mi
     87e:	2320      	movmi	r3, #32
     880:	f88d 3053 	strbmi.w	r3, [sp, #83]	; 0x53
     884:	0711      	lsls	r1, r2, #28
     886:	bf44      	itt	mi
     888:	232b      	movmi	r3, #43	; 0x2b
     88a:	f88d 3053 	strbmi.w	r3, [sp, #83]	; 0x53
     88e:	f89a 3000 	ldrb.w	r3, [sl]
     892:	2b2a      	cmp	r3, #42	; 0x2a
     894:	d015      	beq.n	8c2 <_svfiprintf_r+0xf6>
     896:	4654      	mov	r4, sl
     898:	2000      	movs	r0, #0
     89a:	f04f 0c0a 	mov.w	ip, #10
     89e:	9a07      	ldr	r2, [sp, #28]
     8a0:	4621      	mov	r1, r4
     8a2:	f811 3b01 	ldrb.w	r3, [r1], #1
     8a6:	3b30      	subs	r3, #48	; 0x30
     8a8:	2b09      	cmp	r3, #9
     8aa:	d94e      	bls.n	94a <_svfiprintf_r+0x17e>
     8ac:	b1b0      	cbz	r0, 8dc <_svfiprintf_r+0x110>
     8ae:	9207      	str	r2, [sp, #28]
     8b0:	e014      	b.n	8dc <_svfiprintf_r+0x110>
     8b2:	eba0 0308 	sub.w	r3, r0, r8
     8b6:	fa09 f303 	lsl.w	r3, r9, r3
     8ba:	4313      	orrs	r3, r2
     8bc:	46a2      	mov	sl, r4
     8be:	9304      	str	r3, [sp, #16]
     8c0:	e7d2      	b.n	868 <_svfiprintf_r+0x9c>
     8c2:	9b03      	ldr	r3, [sp, #12]
     8c4:	1d19      	adds	r1, r3, #4
     8c6:	681b      	ldr	r3, [r3, #0]
     8c8:	9103      	str	r1, [sp, #12]
     8ca:	2b00      	cmp	r3, #0
     8cc:	bfbb      	ittet	lt
     8ce:	425b      	neglt	r3, r3
     8d0:	f042 0202 	orrlt.w	r2, r2, #2
     8d4:	9307      	strge	r3, [sp, #28]
     8d6:	9307      	strlt	r3, [sp, #28]
     8d8:	bfb8      	it	lt
     8da:	9204      	strlt	r2, [sp, #16]
     8dc:	7823      	ldrb	r3, [r4, #0]
     8de:	2b2e      	cmp	r3, #46	; 0x2e
     8e0:	d10c      	bne.n	8fc <_svfiprintf_r+0x130>
     8e2:	7863      	ldrb	r3, [r4, #1]
     8e4:	2b2a      	cmp	r3, #42	; 0x2a
     8e6:	d135      	bne.n	954 <_svfiprintf_r+0x188>
     8e8:	9b03      	ldr	r3, [sp, #12]
     8ea:	3402      	adds	r4, #2
     8ec:	1d1a      	adds	r2, r3, #4
     8ee:	681b      	ldr	r3, [r3, #0]
     8f0:	9203      	str	r2, [sp, #12]
     8f2:	2b00      	cmp	r3, #0
     8f4:	bfb8      	it	lt
     8f6:	f04f 33ff 	movlt.w	r3, #4294967295	; 0xffffffff
     8fa:	9305      	str	r3, [sp, #20]
     8fc:	f8df a0bc 	ldr.w	sl, [pc, #188]	; 9bc <_svfiprintf_r+0x1f0>
     900:	2203      	movs	r2, #3
     902:	4650      	mov	r0, sl
     904:	7821      	ldrb	r1, [r4, #0]
     906:	f000 f9f7 	bl	cf8 <memchr>
     90a:	b140      	cbz	r0, 91e <_svfiprintf_r+0x152>
     90c:	2340      	movs	r3, #64	; 0x40
     90e:	eba0 000a 	sub.w	r0, r0, sl
     912:	fa03 f000 	lsl.w	r0, r3, r0
     916:	9b04      	ldr	r3, [sp, #16]
     918:	3401      	adds	r4, #1
     91a:	4303      	orrs	r3, r0
     91c:	9304      	str	r3, [sp, #16]
     91e:	f814 1b01 	ldrb.w	r1, [r4], #1
     922:	2206      	movs	r2, #6
     924:	4826      	ldr	r0, [pc, #152]	; (9c0 <_svfiprintf_r+0x1f4>)
     926:	f88d 1028 	strb.w	r1, [sp, #40]	; 0x28
     92a:	f000 f9e5 	bl	cf8 <memchr>
     92e:	2800      	cmp	r0, #0
     930:	d038      	beq.n	9a4 <_svfiprintf_r+0x1d8>
     932:	4b24      	ldr	r3, [pc, #144]	; (9c4 <_svfiprintf_r+0x1f8>)
     934:	bb1b      	cbnz	r3, 97e <_svfiprintf_r+0x1b2>
     936:	9b03      	ldr	r3, [sp, #12]
     938:	3307      	adds	r3, #7
     93a:	f023 0307 	bic.w	r3, r3, #7
     93e:	3308      	adds	r3, #8
     940:	9303      	str	r3, [sp, #12]
     942:	9b09      	ldr	r3, [sp, #36]	; 0x24
     944:	4433      	add	r3, r6
     946:	9309      	str	r3, [sp, #36]	; 0x24
     948:	e767      	b.n	81a <_svfiprintf_r+0x4e>
     94a:	460c      	mov	r4, r1
     94c:	2001      	movs	r0, #1
     94e:	fb0c 3202 	mla	r2, ip, r2, r3
     952:	e7a5      	b.n	8a0 <_svfiprintf_r+0xd4>
     954:	2300      	movs	r3, #0
     956:	f04f 0c0a 	mov.w	ip, #10
     95a:	4619      	mov	r1, r3
     95c:	3401      	adds	r4, #1
     95e:	9305      	str	r3, [sp, #20]
     960:	4620      	mov	r0, r4
     962:	f810 2b01 	ldrb.w	r2, [r0], #1
     966:	3a30      	subs	r2, #48	; 0x30
     968:	2a09      	cmp	r2, #9
     96a:	d903      	bls.n	974 <_svfiprintf_r+0x1a8>
     96c:	2b00      	cmp	r3, #0
     96e:	d0c5      	beq.n	8fc <_svfiprintf_r+0x130>
     970:	9105      	str	r1, [sp, #20]
     972:	e7c3      	b.n	8fc <_svfiprintf_r+0x130>
     974:	4604      	mov	r4, r0
     976:	2301      	movs	r3, #1
     978:	fb0c 2101 	mla	r1, ip, r1, r2
     97c:	e7f0      	b.n	960 <_svfiprintf_r+0x194>
     97e:	ab03      	add	r3, sp, #12
     980:	9300      	str	r3, [sp, #0]
     982:	462a      	mov	r2, r5
     984:	4638      	mov	r0, r7
     986:	4b10      	ldr	r3, [pc, #64]	; (9c8 <_svfiprintf_r+0x1fc>)
     988:	a904      	add	r1, sp, #16
     98a:	f3af 8000 	nop.w
     98e:	1c42      	adds	r2, r0, #1
     990:	4606      	mov	r6, r0
     992:	d1d6      	bne.n	942 <_svfiprintf_r+0x176>
     994:	89ab      	ldrh	r3, [r5, #12]
     996:	065b      	lsls	r3, r3, #25
     998:	f53f af2c 	bmi.w	7f4 <_svfiprintf_r+0x28>
     99c:	9809      	ldr	r0, [sp, #36]	; 0x24
     99e:	b01d      	add	sp, #116	; 0x74
     9a0:	e8bd 8ff0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, fp, pc}
     9a4:	ab03      	add	r3, sp, #12
     9a6:	9300      	str	r3, [sp, #0]
     9a8:	462a      	mov	r2, r5
     9aa:	4638      	mov	r0, r7
     9ac:	4b06      	ldr	r3, [pc, #24]	; (9c8 <_svfiprintf_r+0x1fc>)
     9ae:	a904      	add	r1, sp, #16
     9b0:	f000 f87c 	bl	aac <_printf_i>
     9b4:	e7eb      	b.n	98e <_svfiprintf_r+0x1c2>
     9b6:	bf00      	nop
     9b8:	00001030 	andeq	r1, r0, r0, lsr r0
     9bc:	00001036 	andeq	r1, r0, r6, lsr r0
     9c0:	0000103a 	andeq	r1, r0, sl, lsr r0
     9c4:	00000000 	andeq	r0, r0, r0
     9c8:	00000715 	andeq	r0, r0, r5, lsl r7

000009cc <_printf_common>:
     9cc:	e92d 47f0 	stmdb	sp!, {r4, r5, r6, r7, r8, r9, sl, lr}
     9d0:	4616      	mov	r6, r2
     9d2:	4699      	mov	r9, r3
     9d4:	688a      	ldr	r2, [r1, #8]
     9d6:	690b      	ldr	r3, [r1, #16]
     9d8:	4607      	mov	r7, r0
     9da:	4293      	cmp	r3, r2
     9dc:	bfb8      	it	lt
     9de:	4613      	movlt	r3, r2
     9e0:	6033      	str	r3, [r6, #0]
     9e2:	f891 2043 	ldrb.w	r2, [r1, #67]	; 0x43
     9e6:	460c      	mov	r4, r1
     9e8:	f8dd 8020 	ldr.w	r8, [sp, #32]
     9ec:	b10a      	cbz	r2, 9f2 <_printf_common+0x26>
     9ee:	3301      	adds	r3, #1
     9f0:	6033      	str	r3, [r6, #0]
     9f2:	6823      	ldr	r3, [r4, #0]
     9f4:	0699      	lsls	r1, r3, #26
     9f6:	bf42      	ittt	mi
     9f8:	6833      	ldrmi	r3, [r6, #0]
     9fa:	3302      	addmi	r3, #2
     9fc:	6033      	strmi	r3, [r6, #0]
     9fe:	6825      	ldr	r5, [r4, #0]
     a00:	f015 0506 	ands.w	r5, r5, #6
     a04:	d106      	bne.n	a14 <_printf_common+0x48>
     a06:	f104 0a19 	add.w	sl, r4, #25
     a0a:	68e3      	ldr	r3, [r4, #12]
     a0c:	6832      	ldr	r2, [r6, #0]
     a0e:	1a9b      	subs	r3, r3, r2
     a10:	42ab      	cmp	r3, r5
     a12:	dc28      	bgt.n	a66 <_printf_common+0x9a>
     a14:	f894 2043 	ldrb.w	r2, [r4, #67]	; 0x43
     a18:	1e13      	subs	r3, r2, #0
     a1a:	6822      	ldr	r2, [r4, #0]
     a1c:	bf18      	it	ne
     a1e:	2301      	movne	r3, #1
     a20:	0692      	lsls	r2, r2, #26
     a22:	d42d      	bmi.n	a80 <_printf_common+0xb4>
     a24:	4649      	mov	r1, r9
     a26:	4638      	mov	r0, r7
     a28:	f104 0243 	add.w	r2, r4, #67	; 0x43
     a2c:	47c0      	blx	r8
     a2e:	3001      	adds	r0, #1
     a30:	d020      	beq.n	a74 <_printf_common+0xa8>
     a32:	6823      	ldr	r3, [r4, #0]
     a34:	68e5      	ldr	r5, [r4, #12]
     a36:	f003 0306 	and.w	r3, r3, #6
     a3a:	2b04      	cmp	r3, #4
     a3c:	bf18      	it	ne
     a3e:	2500      	movne	r5, #0
     a40:	6832      	ldr	r2, [r6, #0]
     a42:	f04f 0600 	mov.w	r6, #0
     a46:	68a3      	ldr	r3, [r4, #8]
     a48:	bf08      	it	eq
     a4a:	1aad      	subeq	r5, r5, r2
     a4c:	6922      	ldr	r2, [r4, #16]
     a4e:	bf08      	it	eq
     a50:	ea25 75e5 	biceq.w	r5, r5, r5, asr #31
     a54:	4293      	cmp	r3, r2
     a56:	bfc4      	itt	gt
     a58:	1a9b      	subgt	r3, r3, r2
     a5a:	18ed      	addgt	r5, r5, r3
     a5c:	341a      	adds	r4, #26
     a5e:	42b5      	cmp	r5, r6
     a60:	d11a      	bne.n	a98 <_printf_common+0xcc>
     a62:	2000      	movs	r0, #0
     a64:	e008      	b.n	a78 <_printf_common+0xac>
     a66:	2301      	movs	r3, #1
     a68:	4652      	mov	r2, sl
     a6a:	4649      	mov	r1, r9
     a6c:	4638      	mov	r0, r7
     a6e:	47c0      	blx	r8
     a70:	3001      	adds	r0, #1
     a72:	d103      	bne.n	a7c <_printf_common+0xb0>
     a74:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     a78:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
     a7c:	3501      	adds	r5, #1
     a7e:	e7c4      	b.n	a0a <_printf_common+0x3e>
     a80:	2030      	movs	r0, #48	; 0x30
     a82:	18e1      	adds	r1, r4, r3
     a84:	f881 0043 	strb.w	r0, [r1, #67]	; 0x43
     a88:	1c5a      	adds	r2, r3, #1
     a8a:	f894 1045 	ldrb.w	r1, [r4, #69]	; 0x45
     a8e:	4422      	add	r2, r4
     a90:	3302      	adds	r3, #2
     a92:	f882 1043 	strb.w	r1, [r2, #67]	; 0x43
     a96:	e7c5      	b.n	a24 <_printf_common+0x58>
     a98:	2301      	movs	r3, #1
     a9a:	4622      	mov	r2, r4
     a9c:	4649      	mov	r1, r9
     a9e:	4638      	mov	r0, r7
     aa0:	47c0      	blx	r8
     aa2:	3001      	adds	r0, #1
     aa4:	d0e6      	beq.n	a74 <_printf_common+0xa8>
     aa6:	3601      	adds	r6, #1
     aa8:	e7d9      	b.n	a5e <_printf_common+0x92>
	...

00000aac <_printf_i>:
     aac:	e92d 47ff 	stmdb	sp!, {r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, sl, lr}
     ab0:	7e0f      	ldrb	r7, [r1, #24]
     ab2:	4691      	mov	r9, r2
     ab4:	2f78      	cmp	r7, #120	; 0x78
     ab6:	4680      	mov	r8, r0
     ab8:	460c      	mov	r4, r1
     aba:	469a      	mov	sl, r3
     abc:	9d0c      	ldr	r5, [sp, #48]	; 0x30
     abe:	f101 0243 	add.w	r2, r1, #67	; 0x43
     ac2:	d807      	bhi.n	ad4 <_printf_i+0x28>
     ac4:	2f62      	cmp	r7, #98	; 0x62
     ac6:	d80a      	bhi.n	ade <_printf_i+0x32>
     ac8:	2f00      	cmp	r7, #0
     aca:	f000 80d9 	beq.w	c80 <_printf_i+0x1d4>
     ace:	2f58      	cmp	r7, #88	; 0x58
     ad0:	f000 80a4 	beq.w	c1c <_printf_i+0x170>
     ad4:	f104 0542 	add.w	r5, r4, #66	; 0x42
     ad8:	f884 7042 	strb.w	r7, [r4, #66]	; 0x42
     adc:	e03a      	b.n	b54 <_printf_i+0xa8>
     ade:	f1a7 0363 	sub.w	r3, r7, #99	; 0x63
     ae2:	2b15      	cmp	r3, #21
     ae4:	d8f6      	bhi.n	ad4 <_printf_i+0x28>
     ae6:	a101      	add	r1, pc, #4	; (adr r1, aec <_printf_i+0x40>)
     ae8:	f851 f023 	ldr.w	pc, [r1, r3, lsl #2]
     aec:	00000b45 	andeq	r0, r0, r5, asr #22
     af0:	00000b59 	andeq	r0, r0, r9, asr fp
     af4:	00000ad5 	ldrdeq	r0, [r0], -r5
     af8:	00000ad5 	ldrdeq	r0, [r0], -r5
     afc:	00000ad5 	ldrdeq	r0, [r0], -r5
     b00:	00000ad5 	ldrdeq	r0, [r0], -r5
     b04:	00000b59 	andeq	r0, r0, r9, asr fp
     b08:	00000ad5 	ldrdeq	r0, [r0], -r5
     b0c:	00000ad5 	ldrdeq	r0, [r0], -r5
     b10:	00000ad5 	ldrdeq	r0, [r0], -r5
     b14:	00000ad5 	ldrdeq	r0, [r0], -r5
     b18:	00000c67 	andeq	r0, r0, r7, ror #24
     b1c:	00000b89 	andeq	r0, r0, r9, lsl #23
     b20:	00000c49 	andeq	r0, r0, r9, asr #24
     b24:	00000ad5 	ldrdeq	r0, [r0], -r5
     b28:	00000ad5 	ldrdeq	r0, [r0], -r5
     b2c:	00000c89 	andeq	r0, r0, r9, lsl #25
     b30:	00000ad5 	ldrdeq	r0, [r0], -r5
     b34:	00000b89 	andeq	r0, r0, r9, lsl #23
     b38:	00000ad5 	ldrdeq	r0, [r0], -r5
     b3c:	00000ad5 	ldrdeq	r0, [r0], -r5
     b40:	00000c51 	andeq	r0, r0, r1, asr ip
     b44:	682b      	ldr	r3, [r5, #0]
     b46:	1d1a      	adds	r2, r3, #4
     b48:	681b      	ldr	r3, [r3, #0]
     b4a:	602a      	str	r2, [r5, #0]
     b4c:	f104 0542 	add.w	r5, r4, #66	; 0x42
     b50:	f884 3042 	strb.w	r3, [r4, #66]	; 0x42
     b54:	2301      	movs	r3, #1
     b56:	e0a4      	b.n	ca2 <_printf_i+0x1f6>
     b58:	6820      	ldr	r0, [r4, #0]
     b5a:	6829      	ldr	r1, [r5, #0]
     b5c:	0606      	lsls	r6, r0, #24
     b5e:	f101 0304 	add.w	r3, r1, #4
     b62:	d50a      	bpl.n	b7a <_printf_i+0xce>
     b64:	680e      	ldr	r6, [r1, #0]
     b66:	602b      	str	r3, [r5, #0]
     b68:	2e00      	cmp	r6, #0
     b6a:	da03      	bge.n	b74 <_printf_i+0xc8>
     b6c:	232d      	movs	r3, #45	; 0x2d
     b6e:	4276      	negs	r6, r6
     b70:	f884 3043 	strb.w	r3, [r4, #67]	; 0x43
     b74:	230a      	movs	r3, #10
     b76:	485e      	ldr	r0, [pc, #376]	; (cf0 <_printf_i+0x244>)
     b78:	e019      	b.n	bae <_printf_i+0x102>
     b7a:	680e      	ldr	r6, [r1, #0]
     b7c:	f010 0f40 	tst.w	r0, #64	; 0x40
     b80:	602b      	str	r3, [r5, #0]
     b82:	bf18      	it	ne
     b84:	b236      	sxthne	r6, r6
     b86:	e7ef      	b.n	b68 <_printf_i+0xbc>
     b88:	682b      	ldr	r3, [r5, #0]
     b8a:	6820      	ldr	r0, [r4, #0]
     b8c:	1d19      	adds	r1, r3, #4
     b8e:	6029      	str	r1, [r5, #0]
     b90:	0601      	lsls	r1, r0, #24
     b92:	d501      	bpl.n	b98 <_printf_i+0xec>
     b94:	681e      	ldr	r6, [r3, #0]
     b96:	e002      	b.n	b9e <_printf_i+0xf2>
     b98:	0646      	lsls	r6, r0, #25
     b9a:	d5fb      	bpl.n	b94 <_printf_i+0xe8>
     b9c:	881e      	ldrh	r6, [r3, #0]
     b9e:	2f6f      	cmp	r7, #111	; 0x6f
     ba0:	bf0c      	ite	eq
     ba2:	2308      	moveq	r3, #8
     ba4:	230a      	movne	r3, #10
     ba6:	4852      	ldr	r0, [pc, #328]	; (cf0 <_printf_i+0x244>)
     ba8:	2100      	movs	r1, #0
     baa:	f884 1043 	strb.w	r1, [r4, #67]	; 0x43
     bae:	6865      	ldr	r5, [r4, #4]
     bb0:	2d00      	cmp	r5, #0
     bb2:	bfa8      	it	ge
     bb4:	6821      	ldrge	r1, [r4, #0]
     bb6:	60a5      	str	r5, [r4, #8]
     bb8:	bfa4      	itt	ge
     bba:	f021 0104 	bicge.w	r1, r1, #4
     bbe:	6021      	strge	r1, [r4, #0]
     bc0:	b90e      	cbnz	r6, bc6 <_printf_i+0x11a>
     bc2:	2d00      	cmp	r5, #0
     bc4:	d04d      	beq.n	c62 <_printf_i+0x1b6>
     bc6:	4615      	mov	r5, r2
     bc8:	fbb6 f1f3 	udiv	r1, r6, r3
     bcc:	fb03 6711 	mls	r7, r3, r1, r6
     bd0:	5dc7      	ldrb	r7, [r0, r7]
     bd2:	f805 7d01 	strb.w	r7, [r5, #-1]!
     bd6:	4637      	mov	r7, r6
     bd8:	42bb      	cmp	r3, r7
     bda:	460e      	mov	r6, r1
     bdc:	d9f4      	bls.n	bc8 <_printf_i+0x11c>
     bde:	2b08      	cmp	r3, #8
     be0:	d10b      	bne.n	bfa <_printf_i+0x14e>
     be2:	6823      	ldr	r3, [r4, #0]
     be4:	07de      	lsls	r6, r3, #31
     be6:	d508      	bpl.n	bfa <_printf_i+0x14e>
     be8:	6923      	ldr	r3, [r4, #16]
     bea:	6861      	ldr	r1, [r4, #4]
     bec:	4299      	cmp	r1, r3
     bee:	bfde      	ittt	le
     bf0:	2330      	movle	r3, #48	; 0x30
     bf2:	f805 3c01 	strble.w	r3, [r5, #-1]
     bf6:	f105 35ff 	addle.w	r5, r5, #4294967295	; 0xffffffff
     bfa:	1b52      	subs	r2, r2, r5
     bfc:	6122      	str	r2, [r4, #16]
     bfe:	464b      	mov	r3, r9
     c00:	4621      	mov	r1, r4
     c02:	4640      	mov	r0, r8
     c04:	f8cd a000 	str.w	sl, [sp]
     c08:	aa03      	add	r2, sp, #12
     c0a:	f7ff fedf 	bl	9cc <_printf_common>
     c0e:	3001      	adds	r0, #1
     c10:	d14c      	bne.n	cac <_printf_i+0x200>
     c12:	f04f 30ff 	mov.w	r0, #4294967295	; 0xffffffff
     c16:	b004      	add	sp, #16
     c18:	e8bd 87f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, r9, sl, pc}
     c1c:	4834      	ldr	r0, [pc, #208]	; (cf0 <_printf_i+0x244>)
     c1e:	f881 7045 	strb.w	r7, [r1, #69]	; 0x45
     c22:	6829      	ldr	r1, [r5, #0]
     c24:	6823      	ldr	r3, [r4, #0]
     c26:	f851 6b04 	ldr.w	r6, [r1], #4
     c2a:	6029      	str	r1, [r5, #0]
     c2c:	061d      	lsls	r5, r3, #24
     c2e:	d514      	bpl.n	c5a <_printf_i+0x1ae>
     c30:	07df      	lsls	r7, r3, #31
     c32:	bf44      	itt	mi
     c34:	f043 0320 	orrmi.w	r3, r3, #32
     c38:	6023      	strmi	r3, [r4, #0]
     c3a:	b91e      	cbnz	r6, c44 <_printf_i+0x198>
     c3c:	6823      	ldr	r3, [r4, #0]
     c3e:	f023 0320 	bic.w	r3, r3, #32
     c42:	6023      	str	r3, [r4, #0]
     c44:	2310      	movs	r3, #16
     c46:	e7af      	b.n	ba8 <_printf_i+0xfc>
     c48:	6823      	ldr	r3, [r4, #0]
     c4a:	f043 0320 	orr.w	r3, r3, #32
     c4e:	6023      	str	r3, [r4, #0]
     c50:	2378      	movs	r3, #120	; 0x78
     c52:	4828      	ldr	r0, [pc, #160]	; (cf4 <_printf_i+0x248>)
     c54:	f884 3045 	strb.w	r3, [r4, #69]	; 0x45
     c58:	e7e3      	b.n	c22 <_printf_i+0x176>
     c5a:	0659      	lsls	r1, r3, #25
     c5c:	bf48      	it	mi
     c5e:	b2b6      	uxthmi	r6, r6
     c60:	e7e6      	b.n	c30 <_printf_i+0x184>
     c62:	4615      	mov	r5, r2
     c64:	e7bb      	b.n	bde <_printf_i+0x132>
     c66:	682b      	ldr	r3, [r5, #0]
     c68:	6826      	ldr	r6, [r4, #0]
     c6a:	1d18      	adds	r0, r3, #4
     c6c:	6961      	ldr	r1, [r4, #20]
     c6e:	6028      	str	r0, [r5, #0]
     c70:	0635      	lsls	r5, r6, #24
     c72:	681b      	ldr	r3, [r3, #0]
     c74:	d501      	bpl.n	c7a <_printf_i+0x1ce>
     c76:	6019      	str	r1, [r3, #0]
     c78:	e002      	b.n	c80 <_printf_i+0x1d4>
     c7a:	0670      	lsls	r0, r6, #25
     c7c:	d5fb      	bpl.n	c76 <_printf_i+0x1ca>
     c7e:	8019      	strh	r1, [r3, #0]
     c80:	2300      	movs	r3, #0
     c82:	4615      	mov	r5, r2
     c84:	6123      	str	r3, [r4, #16]
     c86:	e7ba      	b.n	bfe <_printf_i+0x152>
     c88:	682b      	ldr	r3, [r5, #0]
     c8a:	2100      	movs	r1, #0
     c8c:	1d1a      	adds	r2, r3, #4
     c8e:	602a      	str	r2, [r5, #0]
     c90:	681d      	ldr	r5, [r3, #0]
     c92:	6862      	ldr	r2, [r4, #4]
     c94:	4628      	mov	r0, r5
     c96:	f000 f82f 	bl	cf8 <memchr>
     c9a:	b108      	cbz	r0, ca0 <_printf_i+0x1f4>
     c9c:	1b40      	subs	r0, r0, r5
     c9e:	6060      	str	r0, [r4, #4]
     ca0:	6863      	ldr	r3, [r4, #4]
     ca2:	6123      	str	r3, [r4, #16]
     ca4:	2300      	movs	r3, #0
     ca6:	f884 3043 	strb.w	r3, [r4, #67]	; 0x43
     caa:	e7a8      	b.n	bfe <_printf_i+0x152>
     cac:	462a      	mov	r2, r5
     cae:	4649      	mov	r1, r9
     cb0:	4640      	mov	r0, r8
     cb2:	6923      	ldr	r3, [r4, #16]
     cb4:	47d0      	blx	sl
     cb6:	3001      	adds	r0, #1
     cb8:	d0ab      	beq.n	c12 <_printf_i+0x166>
     cba:	6823      	ldr	r3, [r4, #0]
     cbc:	079b      	lsls	r3, r3, #30
     cbe:	d413      	bmi.n	ce8 <_printf_i+0x23c>
     cc0:	68e0      	ldr	r0, [r4, #12]
     cc2:	9b03      	ldr	r3, [sp, #12]
     cc4:	4298      	cmp	r0, r3
     cc6:	bfb8      	it	lt
     cc8:	4618      	movlt	r0, r3
     cca:	e7a4      	b.n	c16 <_printf_i+0x16a>
     ccc:	2301      	movs	r3, #1
     cce:	4632      	mov	r2, r6
     cd0:	4649      	mov	r1, r9
     cd2:	4640      	mov	r0, r8
     cd4:	47d0      	blx	sl
     cd6:	3001      	adds	r0, #1
     cd8:	d09b      	beq.n	c12 <_printf_i+0x166>
     cda:	3501      	adds	r5, #1
     cdc:	68e3      	ldr	r3, [r4, #12]
     cde:	9903      	ldr	r1, [sp, #12]
     ce0:	1a5b      	subs	r3, r3, r1
     ce2:	42ab      	cmp	r3, r5
     ce4:	dcf2      	bgt.n	ccc <_printf_i+0x220>
     ce6:	e7eb      	b.n	cc0 <_printf_i+0x214>
     ce8:	2500      	movs	r5, #0
     cea:	f104 0619 	add.w	r6, r4, #25
     cee:	e7f5      	b.n	cdc <_printf_i+0x230>
     cf0:	00001041 	andeq	r1, r0, r1, asr #32
     cf4:	00001052 	andeq	r1, r0, r2, asr r0

00000cf8 <memchr>:
     cf8:	4603      	mov	r3, r0
     cfa:	b510      	push	{r4, lr}
     cfc:	b2c9      	uxtb	r1, r1
     cfe:	4402      	add	r2, r0
     d00:	4293      	cmp	r3, r2
     d02:	4618      	mov	r0, r3
     d04:	d101      	bne.n	d0a <memchr+0x12>
     d06:	2000      	movs	r0, #0
     d08:	e003      	b.n	d12 <memchr+0x1a>
     d0a:	7804      	ldrb	r4, [r0, #0]
     d0c:	3301      	adds	r3, #1
     d0e:	428c      	cmp	r4, r1
     d10:	d1f6      	bne.n	d00 <memchr+0x8>
     d12:	bd10      	pop	{r4, pc}

00000d14 <memcpy>:
     d14:	440a      	add	r2, r1
     d16:	4291      	cmp	r1, r2
     d18:	f100 33ff 	add.w	r3, r0, #4294967295	; 0xffffffff
     d1c:	d100      	bne.n	d20 <memcpy+0xc>
     d1e:	4770      	bx	lr
     d20:	b510      	push	{r4, lr}
     d22:	f811 4b01 	ldrb.w	r4, [r1], #1
     d26:	4291      	cmp	r1, r2
     d28:	f803 4f01 	strb.w	r4, [r3, #1]!
     d2c:	d1f9      	bne.n	d22 <memcpy+0xe>
     d2e:	bd10      	pop	{r4, pc}

00000d30 <memmove>:
     d30:	4288      	cmp	r0, r1
     d32:	b510      	push	{r4, lr}
     d34:	eb01 0402 	add.w	r4, r1, r2
     d38:	d902      	bls.n	d40 <memmove+0x10>
     d3a:	4284      	cmp	r4, r0
     d3c:	4623      	mov	r3, r4
     d3e:	d807      	bhi.n	d50 <memmove+0x20>
     d40:	1e43      	subs	r3, r0, #1
     d42:	42a1      	cmp	r1, r4
     d44:	d008      	beq.n	d58 <memmove+0x28>
     d46:	f811 2b01 	ldrb.w	r2, [r1], #1
     d4a:	f803 2f01 	strb.w	r2, [r3, #1]!
     d4e:	e7f8      	b.n	d42 <memmove+0x12>
     d50:	4601      	mov	r1, r0
     d52:	4402      	add	r2, r0
     d54:	428a      	cmp	r2, r1
     d56:	d100      	bne.n	d5a <memmove+0x2a>
     d58:	bd10      	pop	{r4, pc}
     d5a:	f813 4d01 	ldrb.w	r4, [r3, #-1]!
     d5e:	f802 4d01 	strb.w	r4, [r2, #-1]!
     d62:	e7f7      	b.n	d54 <memmove+0x24>

00000d64 <_free_r>:
     d64:	b538      	push	{r3, r4, r5, lr}
     d66:	4605      	mov	r5, r0
     d68:	2900      	cmp	r1, #0
     d6a:	d040      	beq.n	dee <_free_r+0x8a>
     d6c:	f851 3c04 	ldr.w	r3, [r1, #-4]
     d70:	1f0c      	subs	r4, r1, #4
     d72:	2b00      	cmp	r3, #0
     d74:	bfb8      	it	lt
     d76:	18e4      	addlt	r4, r4, r3
     d78:	f000 f910 	bl	f9c <__malloc_lock>
     d7c:	4a1c      	ldr	r2, [pc, #112]	; (df0 <_free_r+0x8c>)
     d7e:	6813      	ldr	r3, [r2, #0]
     d80:	b933      	cbnz	r3, d90 <_free_r+0x2c>
     d82:	6063      	str	r3, [r4, #4]
     d84:	6014      	str	r4, [r2, #0]
     d86:	4628      	mov	r0, r5
     d88:	e8bd 4038 	ldmia.w	sp!, {r3, r4, r5, lr}
     d8c:	f000 b90c 	b.w	fa8 <__malloc_unlock>
     d90:	42a3      	cmp	r3, r4
     d92:	d908      	bls.n	da6 <_free_r+0x42>
     d94:	6820      	ldr	r0, [r4, #0]
     d96:	1821      	adds	r1, r4, r0
     d98:	428b      	cmp	r3, r1
     d9a:	bf01      	itttt	eq
     d9c:	6819      	ldreq	r1, [r3, #0]
     d9e:	685b      	ldreq	r3, [r3, #4]
     da0:	1809      	addeq	r1, r1, r0
     da2:	6021      	streq	r1, [r4, #0]
     da4:	e7ed      	b.n	d82 <_free_r+0x1e>
     da6:	461a      	mov	r2, r3
     da8:	685b      	ldr	r3, [r3, #4]
     daa:	b10b      	cbz	r3, db0 <_free_r+0x4c>
     dac:	42a3      	cmp	r3, r4
     dae:	d9fa      	bls.n	da6 <_free_r+0x42>
     db0:	6811      	ldr	r1, [r2, #0]
     db2:	1850      	adds	r0, r2, r1
     db4:	42a0      	cmp	r0, r4
     db6:	d10b      	bne.n	dd0 <_free_r+0x6c>
     db8:	6820      	ldr	r0, [r4, #0]
     dba:	4401      	add	r1, r0
     dbc:	1850      	adds	r0, r2, r1
     dbe:	4283      	cmp	r3, r0
     dc0:	6011      	str	r1, [r2, #0]
     dc2:	d1e0      	bne.n	d86 <_free_r+0x22>
     dc4:	6818      	ldr	r0, [r3, #0]
     dc6:	685b      	ldr	r3, [r3, #4]
     dc8:	4401      	add	r1, r0
     dca:	6011      	str	r1, [r2, #0]
     dcc:	6053      	str	r3, [r2, #4]
     dce:	e7da      	b.n	d86 <_free_r+0x22>
     dd0:	d902      	bls.n	dd8 <_free_r+0x74>
     dd2:	230c      	movs	r3, #12
     dd4:	602b      	str	r3, [r5, #0]
     dd6:	e7d6      	b.n	d86 <_free_r+0x22>
     dd8:	6820      	ldr	r0, [r4, #0]
     dda:	1821      	adds	r1, r4, r0
     ddc:	428b      	cmp	r3, r1
     dde:	bf01      	itttt	eq
     de0:	6819      	ldreq	r1, [r3, #0]
     de2:	685b      	ldreq	r3, [r3, #4]
     de4:	1809      	addeq	r1, r1, r0
     de6:	6021      	streq	r1, [r4, #0]
     de8:	6063      	str	r3, [r4, #4]
     dea:	6054      	str	r4, [r2, #4]
     dec:	e7cb      	b.n	d86 <_free_r+0x22>
     dee:	bd38      	pop	{r3, r4, r5, pc}
     df0:	000200a4 	andeq	r0, r2, r4, lsr #1

00000df4 <sbrk_aligned>:
     df4:	b570      	push	{r4, r5, r6, lr}
     df6:	4e0e      	ldr	r6, [pc, #56]	; (e30 <sbrk_aligned+0x3c>)
     df8:	460c      	mov	r4, r1
     dfa:	6831      	ldr	r1, [r6, #0]
     dfc:	4605      	mov	r5, r0
     dfe:	b911      	cbnz	r1, e06 <sbrk_aligned+0x12>
     e00:	f000 f8bc 	bl	f7c <_sbrk_r>
     e04:	6030      	str	r0, [r6, #0]
     e06:	4621      	mov	r1, r4
     e08:	4628      	mov	r0, r5
     e0a:	f000 f8b7 	bl	f7c <_sbrk_r>
     e0e:	1c43      	adds	r3, r0, #1
     e10:	d00a      	beq.n	e28 <sbrk_aligned+0x34>
     e12:	1cc4      	adds	r4, r0, #3
     e14:	f024 0403 	bic.w	r4, r4, #3
     e18:	42a0      	cmp	r0, r4
     e1a:	d007      	beq.n	e2c <sbrk_aligned+0x38>
     e1c:	1a21      	subs	r1, r4, r0
     e1e:	4628      	mov	r0, r5
     e20:	f000 f8ac 	bl	f7c <_sbrk_r>
     e24:	3001      	adds	r0, #1
     e26:	d101      	bne.n	e2c <sbrk_aligned+0x38>
     e28:	f04f 34ff 	mov.w	r4, #4294967295	; 0xffffffff
     e2c:	4620      	mov	r0, r4
     e2e:	bd70      	pop	{r4, r5, r6, pc}
     e30:	000200a8 	andeq	r0, r2, r8, lsr #1

00000e34 <_malloc_r>:
     e34:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
     e38:	1ccd      	adds	r5, r1, #3
     e3a:	f025 0503 	bic.w	r5, r5, #3
     e3e:	3508      	adds	r5, #8
     e40:	2d0c      	cmp	r5, #12
     e42:	bf38      	it	cc
     e44:	250c      	movcc	r5, #12
     e46:	2d00      	cmp	r5, #0
     e48:	4607      	mov	r7, r0
     e4a:	db01      	blt.n	e50 <_malloc_r+0x1c>
     e4c:	42a9      	cmp	r1, r5
     e4e:	d905      	bls.n	e5c <_malloc_r+0x28>
     e50:	230c      	movs	r3, #12
     e52:	2600      	movs	r6, #0
     e54:	603b      	str	r3, [r7, #0]
     e56:	4630      	mov	r0, r6
     e58:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
     e5c:	4e2e      	ldr	r6, [pc, #184]	; (f18 <_malloc_r+0xe4>)
     e5e:	f000 f89d 	bl	f9c <__malloc_lock>
     e62:	6833      	ldr	r3, [r6, #0]
     e64:	461c      	mov	r4, r3
     e66:	bb34      	cbnz	r4, eb6 <_malloc_r+0x82>
     e68:	4629      	mov	r1, r5
     e6a:	4638      	mov	r0, r7
     e6c:	f7ff ffc2 	bl	df4 <sbrk_aligned>
     e70:	1c43      	adds	r3, r0, #1
     e72:	4604      	mov	r4, r0
     e74:	d14d      	bne.n	f12 <_malloc_r+0xde>
     e76:	6834      	ldr	r4, [r6, #0]
     e78:	4626      	mov	r6, r4
     e7a:	2e00      	cmp	r6, #0
     e7c:	d140      	bne.n	f00 <_malloc_r+0xcc>
     e7e:	6823      	ldr	r3, [r4, #0]
     e80:	4631      	mov	r1, r6
     e82:	4638      	mov	r0, r7
     e84:	eb04 0803 	add.w	r8, r4, r3
     e88:	f000 f878 	bl	f7c <_sbrk_r>
     e8c:	4580      	cmp	r8, r0
     e8e:	d13a      	bne.n	f06 <_malloc_r+0xd2>
     e90:	6821      	ldr	r1, [r4, #0]
     e92:	3503      	adds	r5, #3
     e94:	1a6d      	subs	r5, r5, r1
     e96:	f025 0503 	bic.w	r5, r5, #3
     e9a:	3508      	adds	r5, #8
     e9c:	2d0c      	cmp	r5, #12
     e9e:	bf38      	it	cc
     ea0:	250c      	movcc	r5, #12
     ea2:	4638      	mov	r0, r7
     ea4:	4629      	mov	r1, r5
     ea6:	f7ff ffa5 	bl	df4 <sbrk_aligned>
     eaa:	3001      	adds	r0, #1
     eac:	d02b      	beq.n	f06 <_malloc_r+0xd2>
     eae:	6823      	ldr	r3, [r4, #0]
     eb0:	442b      	add	r3, r5
     eb2:	6023      	str	r3, [r4, #0]
     eb4:	e00e      	b.n	ed4 <_malloc_r+0xa0>
     eb6:	6822      	ldr	r2, [r4, #0]
     eb8:	1b52      	subs	r2, r2, r5
     eba:	d41e      	bmi.n	efa <_malloc_r+0xc6>
     ebc:	2a0b      	cmp	r2, #11
     ebe:	d916      	bls.n	eee <_malloc_r+0xba>
     ec0:	1961      	adds	r1, r4, r5
     ec2:	42a3      	cmp	r3, r4
     ec4:	6025      	str	r5, [r4, #0]
     ec6:	bf18      	it	ne
     ec8:	6059      	strne	r1, [r3, #4]
     eca:	6863      	ldr	r3, [r4, #4]
     ecc:	bf08      	it	eq
     ece:	6031      	streq	r1, [r6, #0]
     ed0:	5162      	str	r2, [r4, r5]
     ed2:	604b      	str	r3, [r1, #4]
     ed4:	4638      	mov	r0, r7
     ed6:	f104 060b 	add.w	r6, r4, #11
     eda:	f000 f865 	bl	fa8 <__malloc_unlock>
     ede:	f026 0607 	bic.w	r6, r6, #7
     ee2:	1d23      	adds	r3, r4, #4
     ee4:	1af2      	subs	r2, r6, r3
     ee6:	d0b6      	beq.n	e56 <_malloc_r+0x22>
     ee8:	1b9b      	subs	r3, r3, r6
     eea:	50a3      	str	r3, [r4, r2]
     eec:	e7b3      	b.n	e56 <_malloc_r+0x22>
     eee:	6862      	ldr	r2, [r4, #4]
     ef0:	42a3      	cmp	r3, r4
     ef2:	bf0c      	ite	eq
     ef4:	6032      	streq	r2, [r6, #0]
     ef6:	605a      	strne	r2, [r3, #4]
     ef8:	e7ec      	b.n	ed4 <_malloc_r+0xa0>
     efa:	4623      	mov	r3, r4
     efc:	6864      	ldr	r4, [r4, #4]
     efe:	e7b2      	b.n	e66 <_malloc_r+0x32>
     f00:	4634      	mov	r4, r6
     f02:	6876      	ldr	r6, [r6, #4]
     f04:	e7b9      	b.n	e7a <_malloc_r+0x46>
     f06:	230c      	movs	r3, #12
     f08:	4638      	mov	r0, r7
     f0a:	603b      	str	r3, [r7, #0]
     f0c:	f000 f84c 	bl	fa8 <__malloc_unlock>
     f10:	e7a1      	b.n	e56 <_malloc_r+0x22>
     f12:	6025      	str	r5, [r4, #0]
     f14:	e7de      	b.n	ed4 <_malloc_r+0xa0>
     f16:	bf00      	nop
     f18:	000200a4 	andeq	r0, r2, r4, lsr #1

00000f1c <_realloc_r>:
     f1c:	e92d 41f0 	stmdb	sp!, {r4, r5, r6, r7, r8, lr}
     f20:	4680      	mov	r8, r0
     f22:	4614      	mov	r4, r2
     f24:	460e      	mov	r6, r1
     f26:	b921      	cbnz	r1, f32 <_realloc_r+0x16>
     f28:	4611      	mov	r1, r2
     f2a:	e8bd 41f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, lr}
     f2e:	f7ff bf81 	b.w	e34 <_malloc_r>
     f32:	b92a      	cbnz	r2, f40 <_realloc_r+0x24>
     f34:	f7ff ff16 	bl	d64 <_free_r>
     f38:	4625      	mov	r5, r4
     f3a:	4628      	mov	r0, r5
     f3c:	e8bd 81f0 	ldmia.w	sp!, {r4, r5, r6, r7, r8, pc}
     f40:	f000 f838 	bl	fb4 <_malloc_usable_size_r>
     f44:	4284      	cmp	r4, r0
     f46:	4607      	mov	r7, r0
     f48:	d802      	bhi.n	f50 <_realloc_r+0x34>
     f4a:	ebb4 0f50 	cmp.w	r4, r0, lsr #1
     f4e:	d812      	bhi.n	f76 <_realloc_r+0x5a>
     f50:	4621      	mov	r1, r4
     f52:	4640      	mov	r0, r8
     f54:	f7ff ff6e 	bl	e34 <_malloc_r>
     f58:	4605      	mov	r5, r0
     f5a:	2800      	cmp	r0, #0
     f5c:	d0ed      	beq.n	f3a <_realloc_r+0x1e>
     f5e:	42bc      	cmp	r4, r7
     f60:	4622      	mov	r2, r4
     f62:	4631      	mov	r1, r6
     f64:	bf28      	it	cs
     f66:	463a      	movcs	r2, r7
     f68:	f7ff fed4 	bl	d14 <memcpy>
     f6c:	4631      	mov	r1, r6
     f6e:	4640      	mov	r0, r8
     f70:	f7ff fef8 	bl	d64 <_free_r>
     f74:	e7e1      	b.n	f3a <_realloc_r+0x1e>
     f76:	4635      	mov	r5, r6
     f78:	e7df      	b.n	f3a <_realloc_r+0x1e>
	...

00000f7c <_sbrk_r>:
     f7c:	b538      	push	{r3, r4, r5, lr}
     f7e:	2300      	movs	r3, #0
     f80:	4d05      	ldr	r5, [pc, #20]	; (f98 <_sbrk_r+0x1c>)
     f82:	4604      	mov	r4, r0
     f84:	4608      	mov	r0, r1
     f86:	602b      	str	r3, [r5, #0]
     f88:	f000 f81e 	bl	fc8 <_sbrk>
     f8c:	1c43      	adds	r3, r0, #1
     f8e:	d102      	bne.n	f96 <_sbrk_r+0x1a>
     f90:	682b      	ldr	r3, [r5, #0]
     f92:	b103      	cbz	r3, f96 <_sbrk_r+0x1a>
     f94:	6023      	str	r3, [r4, #0]
     f96:	bd38      	pop	{r3, r4, r5, pc}
     f98:	000200ac 	andeq	r0, r2, ip, lsr #1

00000f9c <__malloc_lock>:
     f9c:	4801      	ldr	r0, [pc, #4]	; (fa4 <__malloc_lock+0x8>)
     f9e:	f000 b811 	b.w	fc4 <__retarget_lock_acquire_recursive>
     fa2:	bf00      	nop
     fa4:	000200b0 	strheq	r0, [r2], -r0	; <UNPREDICTABLE>

00000fa8 <__malloc_unlock>:
     fa8:	4801      	ldr	r0, [pc, #4]	; (fb0 <__malloc_unlock+0x8>)
     faa:	f000 b80c 	b.w	fc6 <__retarget_lock_release_recursive>
     fae:	bf00      	nop
     fb0:	000200b0 	strheq	r0, [r2], -r0	; <UNPREDICTABLE>

00000fb4 <_malloc_usable_size_r>:
     fb4:	f851 3c04 	ldr.w	r3, [r1, #-4]
     fb8:	1f18      	subs	r0, r3, #4
     fba:	2b00      	cmp	r3, #0
     fbc:	bfbc      	itt	lt
     fbe:	580b      	ldrlt	r3, [r1, r0]
     fc0:	18c0      	addlt	r0, r0, r3
     fc2:	4770      	bx	lr

00000fc4 <__retarget_lock_acquire_recursive>:
     fc4:	4770      	bx	lr

00000fc6 <__retarget_lock_release_recursive>:
     fc6:	4770      	bx	lr

00000fc8 <_sbrk>:
     fc8:	4a04      	ldr	r2, [pc, #16]	; (fdc <_sbrk+0x14>)
     fca:	4905      	ldr	r1, [pc, #20]	; (fe0 <_sbrk+0x18>)
     fcc:	6813      	ldr	r3, [r2, #0]
     fce:	2b00      	cmp	r3, #0
     fd0:	bf08      	it	eq
     fd2:	460b      	moveq	r3, r1
     fd4:	4418      	add	r0, r3
     fd6:	6010      	str	r0, [r2, #0]
     fd8:	4618      	mov	r0, r3
     fda:	4770      	bx	lr
     fdc:	000200b4 	strheq	r0, [r2], -r4
     fe0:	000200b8 	strheq	r0, [r2], -r8

00000fe4 <_exit>:
     fe4:	e7fe      	b.n	fe4 <_exit>
     fe6:	bf00      	nop

00000fe8 <_init>:
     fe8:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
     fea:	bf00      	nop
     fec:	bcf8      	pop	{r3, r4, r5, r6, r7}
     fee:	bc08      	pop	{r3}
     ff0:	469e      	mov	lr, r3
     ff2:	4770      	bx	lr

00000ff4 <_fini>:
     ff4:	b5f8      	push	{r3, r4, r5, r6, r7, lr}
     ff6:	bf00      	nop
     ff8:	bcf8      	pop	{r3, r4, r5, r6, r7}
     ffa:	bc08      	pop	{r3}
     ffc:	469e      	mov	lr, r3
     ffe:	4770      	bx	lr
    1000:	69676e45 	stmdbvs	r7!, {r0, r2, r6, r9, sl, fp, sp, lr}^
    1004:	6920656e 	stmdbvs	r0!, {r1, r2, r3, r5, r6, r8, sl, sp, lr}
    1008:	706f2073 	rsbvc	r2, pc, r3, ror r0	; <UNPREDICTABLE>
    100c:	74617265 	strbtvc	r7, [r1], #-613	; 0xfffffd9b
    1010:	2c657669 	stclcs	6, cr7, [r5], #-420	; 0xfffffe5c
    1014:	6c656820 	stclvs	8, cr6, [r5], #-128	; 0xffffff80
    1018:	61206f6c 			; <UNDEFINED> instruction: 0x61206f6c
    101c:	6720646e 	strvs	r6, [r0, -lr, ror #8]!
    1020:	62646f6f 	rsbvs	r6, r4, #444	; 0x1bc
    1024:	0d2e6579 	cfstr32eq	mvfx6, [lr, #-484]!	; 0xfffffe1c
    1028:	0000000a 	andeq	r0, r0, sl

0000102c <_global_impure_ptr>:
    102c:	00020004 	andeq	r0, r2, r4
    1030:	2b302d23 	blcs	c0c4c4 <__StackTop+0xbea4c4>
    1034:	6c680020 	stclvs	0, cr0, [r8], #-128	; 0xffffff80
    1038:	6665004c 	strbtvs	r0, [r5], -ip, asr #32
    103c:	47464567 	strbmi	r4, [r6, -r7, ror #10]
    1040:	32313000 	eorscc	r3, r1, #0
    1044:	36353433 			; <UNDEFINED> instruction: 0x36353433
    1048:	41393837 	teqmi	r9, r7, lsr r8
    104c:	45444342 	strbmi	r4, [r4, #-834]	; 0xfffffcbe
    1050:	31300046 	teqcc	r0, r6, asr #32
    1054:	35343332 	ldrcc	r3, [r4, #-818]!	; 0xfffffcce
    1058:	39383736 	ldmdbcc	r8!, {r1, r2, r4, r5, r8, r9, sl, ip, sp}
    105c:	64636261 	strbtvs	r6, [r3], #-609	; 0xfffffd9f
    1060:	00006665 	andeq	r6, r0, r5, ror #12

00001064 <__EH_FRAME_BEGIN__>:
    1064:	00000000 	andeq	r0, r0, r0

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
  18:	0000069c 	muleq	r0, ip, r6
  1c:	00000028 	andeq	r0, r0, r8, lsr #32
  20:	83080e41 	movwhi	r0, #36417	; 0x8e41
  24:	00018e02 	andeq	r8, r1, r2, lsl #28
  28:	0000000c 	andeq	r0, r0, ip
  2c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  30:	7c020001 	stcvc	0, cr0, [r2], {1}
  34:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  38:	00000018 	andeq	r0, r0, r8, lsl r0
  3c:	00000028 	andeq	r0, r0, r8, lsr #32
  40:	000006d4 	ldrdeq	r0, [r0], -r4
  44:	0000002c 	andeq	r0, r0, ip, lsr #32
  48:	8e040e41 	cdphi	14, 0, cr0, cr4, cr1, {2}
  4c:	700e4101 	andvc	r4, lr, r1, lsl #2
  50:	00040e4f 	andeq	r0, r4, pc, asr #28
  54:	0000000c 	andeq	r0, r0, ip
  58:	00000028 	andeq	r0, r0, r8, lsr #32
  5c:	00000700 	andeq	r0, r0, r0, lsl #14
  60:	00000014 	andeq	r0, r0, r4, lsl r0
  64:	0000000c 	andeq	r0, r0, ip
  68:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  6c:	7c020001 	stcvc	0, cr0, [r2], {1}
  70:	000d0c0e 	andeq	r0, sp, lr, lsl #24
  74:	00000020 	andeq	r0, r0, r0, lsr #32
  78:	00000064 	andeq	r0, r0, r4, rrx
  7c:	00000714 	andeq	r0, r0, r4, lsl r7
  80:	000000b6 	strheq	r0, [r0], -r6
  84:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
  88:	86078508 	strhi	r8, [r7], -r8, lsl #10
  8c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
  90:	8a038904 	bhi	e24a8 <__StackTop+0xc04a8>
  94:	00018e02 	andeq	r8, r1, r2, lsl #28
  98:	00000028 	andeq	r0, r0, r8, lsr #32
  9c:	00000064 	andeq	r0, r0, r4, rrx
  a0:	00000000 	andeq	r0, r0, r0
  a4:	000000f6 	strdeq	r0, [r0], -r6
  a8:	84300e43 	ldrthi	r0, [r0], #-3651	; 0xfffff1bd
  ac:	86088509 	strhi	r8, [r8], -r9, lsl #10
  b0:	88068707 	stmdahi	r6, {r0, r1, r2, r8, r9, sl, pc}
  b4:	8a048905 	bhi	1224d0 <__StackTop+0x1004d0>
  b8:	8e028b03 	vmlahi.f64	d8, d2, d3
  bc:	0a6a0201 	beq	1a808c8 <__StackTop+0x1a5e8c8>
  c0:	0b42240e 	bleq	1089100 <__StackTop+0x1067100>
  c4:	0000002c 	andeq	r0, r0, ip, lsr #32
  c8:	00000064 	andeq	r0, r0, r4, rrx
  cc:	000007cc 	andeq	r0, r0, ip, asr #15
  d0:	00000200 	andeq	r0, r0, r0, lsl #4
  d4:	84240e42 	strthi	r0, [r4], #-3650	; 0xfffff1be
  d8:	86088509 	strhi	r8, [r8], -r9, lsl #10
  dc:	88068707 	stmdahi	r6, {r0, r1, r2, r8, r9, sl, pc}
  e0:	8a048905 	bhi	1224fc <__StackTop+0x1004fc>
  e4:	8e028b03 	vmlahi.f64	d8, d2, d3
  e8:	980e4701 	stmdals	lr, {r0, r8, r9, sl, lr}
  ec:	0ae10201 	beq	ff8408f8 <__StackTop+0xff81e8f8>
  f0:	0b42240e 	bleq	1089130 <__StackTop+0x1067130>
  f4:	0000000c 	andeq	r0, r0, ip
  f8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
  fc:	7c020001 	stcvc	0, cr0, [r2], {1}
 100:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 104:	00000020 	andeq	r0, r0, r0, lsr #32
 108:	000000f4 	strdeq	r0, [r0], -r4
 10c:	000009cc 	andeq	r0, r0, ip, asr #19
 110:	000000de 	ldrdeq	r0, [r0], -lr
 114:	84200e42 	strthi	r0, [r0], #-3650	; 0xfffff1be
 118:	86078508 	strhi	r8, [r7], -r8, lsl #10
 11c:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 120:	8a038904 	bhi	e2538 <__StackTop+0xc0538>
 124:	00018e02 	andeq	r8, r1, r2, lsl #28
 128:	00000028 	andeq	r0, r0, r8, lsr #32
 12c:	000000f4 	strdeq	r0, [r0], -r4
 130:	00000aac 	andeq	r0, r0, ip, lsr #21
 134:	0000024c 	andeq	r0, r0, ip, asr #4
 138:	84300e42 	ldrthi	r0, [r0], #-3650	; 0xfffff1be
 13c:	86078508 	strhi	r8, [r7], -r8, lsl #10
 140:	88058706 	stmdahi	r5, {r1, r2, r8, r9, sl, pc}
 144:	8a038904 	bhi	e255c <__StackTop+0xc055c>
 148:	02018e02 	andeq	r8, r1, #2, 28
 14c:	200e0ab4 			; <UNDEFINED> instruction: 0x200e0ab4
 150:	00000b42 	andeq	r0, r0, r2, asr #22
 154:	0000000c 	andeq	r0, r0, ip
 158:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 15c:	7c020001 	stcvc	0, cr0, [r2], {1}
 160:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 164:	00000014 	andeq	r0, r0, r4, lsl r0
 168:	00000154 	andeq	r0, r0, r4, asr r1
 16c:	00000cf8 	strdeq	r0, [r0], -r8
 170:	0000001c 	andeq	r0, r0, ip, lsl r0
 174:	84080e42 	strhi	r0, [r8], #-3650	; 0xfffff1be
 178:	00018e02 	andeq	r8, r1, r2, lsl #28
 17c:	0000000c 	andeq	r0, r0, ip
 180:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 184:	7c020001 	stcvc	0, cr0, [r2], {1}
 188:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 18c:	00000014 	andeq	r0, r0, r4, lsl r0
 190:	0000017c 	andeq	r0, r0, ip, ror r1
 194:	00000d14 	andeq	r0, r0, r4, lsl sp
 198:	0000001c 	andeq	r0, r0, ip, lsl r0
 19c:	84080e47 	strhi	r0, [r8], #-3655	; 0xfffff1b9
 1a0:	00018e02 	andeq	r8, r1, r2, lsl #28
 1a4:	0000000c 	andeq	r0, r0, ip
 1a8:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1ac:	7c020001 	stcvc	0, cr0, [r2], {1}
 1b0:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1b4:	00000014 	andeq	r0, r0, r4, lsl r0
 1b8:	000001a4 	andeq	r0, r0, r4, lsr #3
 1bc:	00000d30 	andeq	r0, r0, r0, lsr sp
 1c0:	00000034 	andeq	r0, r0, r4, lsr r0
 1c4:	84080e42 	strhi	r0, [r8], #-3650	; 0xfffff1be
 1c8:	00018e02 	andeq	r8, r1, r2, lsl #28
 1cc:	0000000c 	andeq	r0, r0, ip
 1d0:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 1d4:	7c020001 	stcvc	0, cr0, [r2], {1}
 1d8:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 1dc:	00000024 	andeq	r0, r0, r4, lsr #32
 1e0:	000001cc 	andeq	r0, r0, ip, asr #3
 1e4:	00000d64 	andeq	r0, r0, r4, ror #26
 1e8:	00000090 	muleq	r0, r0, r0
 1ec:	83100e41 	tsthi	r0, #1040	; 0x410
 1f0:	85038404 	strhi	r8, [r3, #-1028]	; 0xfffffbfc
 1f4:	53018e02 	movwpl	r8, #7682	; 0x1e02
 1f8:	c4c5ce0a 	strbgt	ip, [r5], #3594	; 0xe0a
 1fc:	42000ec3 	andmi	r0, r0, #3120	; 0xc30
 200:	0000000b 	andeq	r0, r0, fp
 204:	0000000c 	andeq	r0, r0, ip
 208:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 20c:	7c020001 	stcvc	0, cr0, [r2], {1}
 210:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 214:	00000018 	andeq	r0, r0, r8, lsl r0
 218:	00000204 	andeq	r0, r0, r4, lsl #4
 21c:	00000df4 	strdeq	r0, [r0], -r4
 220:	00000040 	andeq	r0, r0, r0, asr #32
 224:	84100e41 	ldrhi	r0, [r0], #-3649	; 0xfffff1bf
 228:	86038504 	strhi	r8, [r3], -r4, lsl #10
 22c:	00018e02 	andeq	r8, r1, r2, lsl #28
 230:	0000001c 	andeq	r0, r0, ip, lsl r0
 234:	00000204 	andeq	r0, r0, r4, lsl #4
 238:	00000e34 	andeq	r0, r0, r4, lsr lr
 23c:	000000e8 	andeq	r0, r0, r8, ror #1
 240:	84180e42 	ldrhi	r0, [r8], #-3650	; 0xfffff1be
 244:	86058506 	strhi	r8, [r5], -r6, lsl #10
 248:	88038704 	stmdahi	r3, {r2, r8, r9, sl, pc}
 24c:	00018e02 	andeq	r8, r1, r2, lsl #28
 250:	0000000c 	andeq	r0, r0, ip
 254:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 258:	7c020001 	stcvc	0, cr0, [r2], {1}
 25c:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 260:	00000028 	andeq	r0, r0, r8, lsr #32
 264:	00000250 	andeq	r0, r0, r0, asr r2
 268:	00000f1c 	andeq	r0, r0, ip, lsl pc
 26c:	0000005e 	andeq	r0, r0, lr, asr r0
 270:	84180e42 	ldrhi	r0, [r8], #-3650	; 0xfffff1be
 274:	86058506 	strhi	r8, [r5], -r6, lsl #10
 278:	88038704 	stmdahi	r3, {r2, r8, r9, sl, pc}
 27c:	47018e02 	strmi	r8, [r1, -r2, lsl #28]
 280:	c7c8ce0a 	strbgt	ip, [r8, sl, lsl #28]
 284:	0ec4c5c6 	cdpeq	5, 12, cr12, cr4, cr6, {6}
 288:	000b4200 	andeq	r4, fp, r0, lsl #4
 28c:	0000000c 	andeq	r0, r0, ip
 290:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 294:	7c020001 	stcvc	0, cr0, [r2], {1}
 298:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 29c:	00000018 	andeq	r0, r0, r8, lsl r0
 2a0:	0000028c 	andeq	r0, r0, ip, lsl #5
 2a4:	00000f7c 	andeq	r0, r0, ip, ror pc
 2a8:	00000020 	andeq	r0, r0, r0, lsr #32
 2ac:	83100e41 	tsthi	r0, #1040	; 0x410
 2b0:	85038404 	strhi	r8, [r3, #-1028]	; 0xfffffbfc
 2b4:	00018e02 	andeq	r8, r1, r2, lsl #28
 2b8:	0000000c 	andeq	r0, r0, ip
 2bc:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2c0:	7c020001 	stcvc	0, cr0, [r2], {1}
 2c4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2c8:	0000000c 	andeq	r0, r0, ip
 2cc:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 2d0:	00000f9c 	muleq	r0, ip, pc	; <UNPREDICTABLE>
 2d4:	0000000c 	andeq	r0, r0, ip
 2d8:	0000000c 	andeq	r0, r0, ip
 2dc:	000002b8 			; <UNDEFINED> instruction: 0x000002b8
 2e0:	00000fa8 	andeq	r0, r0, r8, lsr #31
 2e4:	0000000c 	andeq	r0, r0, ip
 2e8:	0000000c 	andeq	r0, r0, ip
 2ec:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 2f0:	7c020001 	stcvc	0, cr0, [r2], {1}
 2f4:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 2f8:	0000000c 	andeq	r0, r0, ip
 2fc:	000002e8 	andeq	r0, r0, r8, ror #5
 300:	00000fb4 			; <UNDEFINED> instruction: 0x00000fb4
 304:	00000010 	andeq	r0, r0, r0, lsl r0
 308:	0000000c 	andeq	r0, r0, ip
 30c:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 310:	7c020001 	stcvc	0, cr0, [r2], {1}
 314:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 318:	00000020 	andeq	r0, r0, r0, lsr #32
 31c:	00000308 	andeq	r0, r0, r8, lsl #6
 320:	00000000 	andeq	r0, r0, r0
 324:	0000001a 	andeq	r0, r0, sl, lsl r0
 328:	83100e41 	tsthi	r0, #1040	; 0x410
 32c:	85038404 	strhi	r8, [r3, #-1028]	; 0xfffffbfc
 330:	4a018e02 	bmi	63b40 <__StackTop+0x41b40>
 334:	c3c4c5ce 	bicgt	ip, r4, #864026624	; 0x33800000
 338:	0000000e 	andeq	r0, r0, lr
 33c:	00000024 	andeq	r0, r0, r4, lsr #32
 340:	00000308 	andeq	r0, r0, r8, lsl #6
 344:	00000000 	andeq	r0, r0, r0
 348:	000000b8 	strheq	r0, [r0], -r8
 34c:	84100e42 	ldrhi	r0, [r0], #-3650	; 0xfffff1be
 350:	86038504 	strhi	r8, [r3], -r4, lsl #10
 354:	02018e02 	andeq	r8, r1, #2, 28
 358:	c6ce0a41 	strbgt	r0, [lr], r1, asr #20
 35c:	000ec4c5 	andeq	ip, lr, r5, asr #9
 360:	00000b42 	andeq	r0, r0, r2, asr #22
 364:	0000000c 	andeq	r0, r0, ip
 368:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 36c:	7c020001 	stcvc	0, cr0, [r2], {1}
 370:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 374:	0000000c 	andeq	r0, r0, ip
 378:	00000364 	andeq	r0, r0, r4, ror #6
 37c:	00000000 	andeq	r0, r0, r0
 380:	00000002 	andeq	r0, r0, r2
 384:	0000000c 	andeq	r0, r0, ip
 388:	00000364 	andeq	r0, r0, r4, ror #6
 38c:	00000000 	andeq	r0, r0, r0
 390:	00000002 	andeq	r0, r0, r2
 394:	0000000c 	andeq	r0, r0, ip
 398:	00000364 	andeq	r0, r0, r4, ror #6
 39c:	00000000 	andeq	r0, r0, r0
 3a0:	00000002 	andeq	r0, r0, r2
 3a4:	0000000c 	andeq	r0, r0, ip
 3a8:	00000364 	andeq	r0, r0, r4, ror #6
 3ac:	00000000 	andeq	r0, r0, r0
 3b0:	00000002 	andeq	r0, r0, r2
 3b4:	0000000c 	andeq	r0, r0, ip
 3b8:	00000364 	andeq	r0, r0, r4, ror #6
 3bc:	00000000 	andeq	r0, r0, r0
 3c0:	00000002 	andeq	r0, r0, r2
 3c4:	0000000c 	andeq	r0, r0, ip
 3c8:	00000364 	andeq	r0, r0, r4, ror #6
 3cc:	00000fc4 	andeq	r0, r0, r4, asr #31
 3d0:	00000002 	andeq	r0, r0, r2
 3d4:	0000000c 	andeq	r0, r0, ip
 3d8:	00000364 	andeq	r0, r0, r4, ror #6
 3dc:	00000000 	andeq	r0, r0, r0
 3e0:	00000004 	andeq	r0, r0, r4
 3e4:	0000000c 	andeq	r0, r0, ip
 3e8:	00000364 	andeq	r0, r0, r4, ror #6
 3ec:	00000000 	andeq	r0, r0, r0
 3f0:	00000004 	andeq	r0, r0, r4
 3f4:	0000000c 	andeq	r0, r0, ip
 3f8:	00000364 	andeq	r0, r0, r4, ror #6
 3fc:	00000000 	andeq	r0, r0, r0
 400:	00000002 	andeq	r0, r0, r2
 404:	0000000c 	andeq	r0, r0, ip
 408:	00000364 	andeq	r0, r0, r4, ror #6
 40c:	00000fc6 	andeq	r0, r0, r6, asr #31
 410:	00000002 	andeq	r0, r0, r2
 414:	0000000c 	andeq	r0, r0, ip
 418:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 41c:	7c020001 	stcvc	0, cr0, [r2], {1}
 420:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 424:	0000000c 	andeq	r0, r0, ip
 428:	00000414 	andeq	r0, r0, r4, lsl r4
 42c:	00000fc8 	andeq	r0, r0, r8, asr #31
 430:	0000001c 	andeq	r0, r0, ip, lsl r0
 434:	0000000c 	andeq	r0, r0, ip
 438:	ffffffff 			; <UNDEFINED> instruction: 0xffffffff
 43c:	7c020001 	stcvc	0, cr0, [r2], {1}
 440:	000d0c0e 	andeq	r0, sp, lr, lsl #24
 444:	0000000c 	andeq	r0, r0, ip
 448:	00000434 	andeq	r0, r0, r4, lsr r4
 44c:	00000fe4 	andeq	r0, r0, r4, ror #31
 450:	00000002 	andeq	r0, r0, r2
