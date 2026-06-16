
/home/jdeng/work/caliptra-sw1-C/rom/dev/caliptraRomC-2nd/output/caliptraROMC.elf：     文件格式 elf32-littleriscv


Disassembly of section .text.init:

00000000 <_start>:
   0:	b0201073          	csrw	minstret,zero
   4:	b8201073          	csrw	minstreth,zero
   8:	aaaaa2b7          	lui	t0,0xaaaaa
   c:	0a928293          	add	t0,t0,169 # aaaaa0a9 <_tbs_der_store_end+0x5aa8b089>
  10:	7c029073          	csrw	milm_ctl,t0
  14:	4291                	li	t0,4
  16:	0000100f          	fence.i
  1a:	7f929073          	csrw	mattri2_base,t0
  1e:	0000100f          	fence.i
  22:	00001297          	auipc	t0,0x1
  26:	6aa28293          	add	t0,t0,1706 # 16cc <early_trap_vector>
  2a:	30529073          	csrw	mtvec,t0
  2e:	00002297          	auipc	t0,0x2
  32:	86628293          	add	t0,t0,-1946 # 1894 <_data_lma_start>
  36:	00002317          	auipc	t1,0x2
  3a:	f7630313          	add	t1,t1,-138 # 1fac <_bss_lma_end>
  3e:	50010397          	auipc	t2,0x50010
  42:	fc238393          	add	t2,t2,-62 # 50010000 <_data_vma_start>

00000046 <data_cp_loop>:
  46:	0002ae03          	lw	t3,0(t0)
  4a:	01c3a023          	sw	t3,0(t2)
  4e:	0291                	add	t0,t0,4
  50:	0391                	add	t2,t2,4
  52:	fe62eae3          	bltu	t0,t1,46 <data_cp_loop>
  56:	00002297          	auipc	t0,0x2
  5a:	f5628293          	add	t0,t0,-170 # 1fac <_bss_lma_end>
  5e:	00002317          	auipc	t1,0x2
  62:	f4e30313          	add	t1,t1,-178 # 1fac <_bss_lma_end>
  66:	50010397          	auipc	t2,0x50010
  6a:	6b238393          	add	t2,t2,1714 # 50010718 <_bss_vma_end>

0000006e <bss_cp_loop>:
  6e:	0002ae03          	lw	t3,0(t0)
  72:	01c3a023          	sw	t3,0(t2)
  76:	0291                	add	t0,t0,4
  78:	0391                	add	t2,t2,4
  7a:	fe62eae3          	bltu	t0,t1,6e <bss_cp_loop>
  7e:	50014117          	auipc	sp,0x50014
  82:	6a210113          	add	sp,sp,1698 # 50014720 <STACK>
  86:	4b0010ef          	jal	1536 <main>

0000008a <_finish>:
  8a:	300302b7          	lui	t0,0x30030
  8e:	0cc28293          	add	t0,t0,204 # 300300cc <_bss_lma_end+0x3002e120>
  92:	0ff00f13          	li	t5,255
  96:	01e28023          	sb	t5,0(t0)
  9a:	fe0008e3          	beqz	zero,8a <_finish>
  9e:	0001                	nop
  a0:	0001                	nop
  a2:	0001                	nop
  a4:	0001                	nop
  a6:	0001                	nop
  a8:	0001                	nop
  aa:	0001                	nop
  ac:	0001                	nop
  ae:	0001                	nop
  b0:	0001                	nop
  b2:	0001                	nop
  b4:	0001                	nop
  b6:	0001                	nop
  b8:	0001                	nop
  ba:	0001                	nop
  bc:	0001                	nop
  be:	0001                	nop
  c0:	0001                	nop
  c2:	0001                	nop
  c4:	0001                	nop
  c6:	0001                	nop
  c8:	0001                	nop
  ca:	0001                	nop
  cc:	0001                	nop
  ce:	0001                	nop
  d0:	0001                	nop
  d2:	0001                	nop
  d4:	0001                	nop
  d6:	0001                	nop
  d8:	0001                	nop
  da:	0001                	nop
  dc:	0001                	nop
  de:	0001                	nop
  e0:	0001                	nop
  e2:	0001                	nop
  e4:	0001                	nop
  e6:	0001                	nop
  e8:	0001                	nop
  ea:	0001                	nop
  ec:	0001                	nop
  ee:	0001                	nop
  f0:	0001                	nop
  f2:	0001                	nop
  f4:	0001                	nop
  f6:	0001                	nop
  f8:	0001                	nop
  fa:	0001                	nop
  fc:	0001                	nop
  fe:	0001                	nop
 100:	0001                	nop
 102:	0001                	nop
 104:	0001                	nop
 106:	0001                	nop
 108:	0001                	nop
 10a:	0001                	nop
 10c:	0001                	nop
 10e:	0001                	nop
 110:	0001                	nop
 112:	0001                	nop
 114:	0001                	nop
 116:	0001                	nop
 118:	0001                	nop
 11a:	0001                	nop
 11c:	0001                	nop
 11e:	0001                	nop
 120:	0001                	nop
 122:	0001                	nop
 124:	0001                	nop
 126:	0001                	nop
 128:	0001                	nop
 12a:	0001                	nop
 12c:	0001                	nop
 12e:	0001                	nop
 130:	0001                	nop
 132:	0001                	nop
 134:	0001                	nop
 136:	0001                	nop
 138:	0001                	nop
 13a:	0001                	nop
 13c:	0001                	nop
 13e:	0001                	nop
 140:	0001                	nop
 142:	0001                	nop
 144:	0001                	nop
 146:	0001                	nop
 148:	0001                	nop
 14a:	0001                	nop
 14c:	0001                	nop
 14e:	0001                	nop
 150:	0001                	nop
 152:	0001                	nop
 154:	0001                	nop
 156:	0001                	nop
 158:	0001                	nop
 15a:	0001                	nop
 15c:	0001                	nop
 15e:	0001                	nop
 160:	0001                	nop
 162:	0001                	nop
 164:	0001                	nop

Disassembly of section .text:

00000168 <ecc_keygen_flow>:
     168:	7179                	add	sp,sp,-48
     16a:	ce4e                	sw	s3,28(sp)
     16c:	89ba                	mv	s3,a4
     16e:	10008737          	lui	a4,0x10008
     172:	d422                	sw	s0,40(sp)
     174:	d226                	sw	s1,36(sp)
     176:	d04a                	sw	s2,32(sp)
     178:	cc52                	sw	s4,24(sp)
     17a:	ca56                	sw	s5,20(sp)
     17c:	d606                	sw	ra,44(sp)
     17e:	c85a                	sw	s6,16(sp)
     180:	c65e                	sw	s7,12(sp)
     182:	8aaa                	mv	s5,a0
     184:	8a2e                	mv	s4,a1
     186:	8432                	mv	s0,a2
     188:	8936                	mv	s2,a3
     18a:	84be                	mv	s1,a5
     18c:	0761                	add	a4,a4,24 # 10008018 <_bss_lma_end+0x1000606c>
     18e:	431c                	lw	a5,0(a4)
     190:	8b85                	and	a5,a5,1
     192:	dff5                	beqz	a5,18e <ecc_keygen_flow+0x26>
     194:	000ac783          	lbu	a5,0(s5)
     198:	50010bb7          	lui	s7,0x50010
     19c:	50010b37          	lui	s6,0x50010
     1a0:	18078c63          	beqz	a5,338 <ecc_keygen_flow+0x1d0>
     1a4:	03b00613          	li	a2,59
     1a8:	460b8593          	add	a1,s7,1120 # 50010460 <__func__.0>
     1ac:	0f0b0513          	add	a0,s6,240 # 500100f0 <trap_msg+0x7c>
     1b0:	1c6010ef          	jal	1376 <printf>
     1b4:	001ac783          	lbu	a5,1(s5)
     1b8:	0786                	sll	a5,a5,0x1
     1ba:	03e7f793          	and	a5,a5,62
     1be:	0017e793          	or	a5,a5,1
     1c2:	0220000f          	fence	r,r
     1c6:	0220000f          	fence	r,r
     1ca:	10008737          	lui	a4,0x10008
     1ce:	60f72423          	sw	a5,1544(a4) # 10008608 <_bss_lma_end+0x1000665c>
     1d2:	60c70713          	add	a4,a4,1548
     1d6:	431c                	lw	a5,0(a4)
     1d8:	8b89                	and	a5,a5,2
     1da:	dff5                	beqz	a5,1d6 <ecc_keygen_flow+0x6e>
     1dc:	00094783          	lbu	a5,0(s2)
     1e0:	cb85                	beqz	a5,210 <ecc_keygen_flow+0xa8>
     1e2:	04d00613          	li	a2,77
     1e6:	460b8593          	add	a1,s7,1120
     1ea:	0f0b0513          	add	a0,s6,240
     1ee:	188010ef          	jal	1376 <printf>
     1f2:	00194783          	lbu	a5,1(s2)
     1f6:	0786                	sll	a5,a5,0x1
     1f8:	03e7f793          	and	a5,a5,62
     1fc:	2017e793          	or	a5,a5,513
     200:	0220000f          	fence	r,r
     204:	0220000f          	fence	r,r
     208:	10008737          	lui	a4,0x10008
     20c:	60f72823          	sw	a5,1552(a4) # 10008610 <_bss_lma_end+0x10006664>
     210:	100087b7          	lui	a5,0x10008
     214:	efff8637          	lui	a2,0xefff8
     218:	10008737          	lui	a4,0x10008
     21c:	50078793          	add	a5,a5,1280 # 10008500 <_bss_lma_end+0x10006554>
     220:	b0060613          	add	a2,a2,-1280 # efff7b00 <_tbs_der_store_end+0x9ffd8ae0>
     224:	53070713          	add	a4,a4,1328 # 10008530 <_bss_lma_end+0x10006584>
     228:	85be                	mv	a1,a5
     22a:	0791                	add	a5,a5,4
     22c:	00c786b3          	add	a3,a5,a2
     230:	96d2                	add	a3,a3,s4
     232:	4294                	lw	a3,0(a3)
     234:	c194                	sw	a3,0(a1)
     236:	fee799e3          	bne	a5,a4,228 <ecc_keygen_flow+0xc0>
     23a:	100087b7          	lui	a5,0x10008
     23e:	efff8637          	lui	a2,0xefff8
     242:	10008737          	lui	a4,0x10008
     246:	48078793          	add	a5,a5,1152 # 10008480 <_bss_lma_end+0x100064d4>
     24a:	b8060613          	add	a2,a2,-1152 # efff7b80 <_tbs_der_store_end+0x9ffd8b60>
     24e:	4b070713          	add	a4,a4,1200 # 100084b0 <_bss_lma_end+0x10006504>
     252:	85be                	mv	a1,a5
     254:	0791                	add	a5,a5,4
     256:	00c786b3          	add	a3,a5,a2
     25a:	96a2                	add	a3,a3,s0
     25c:	4294                	lw	a3,0(a3)
     25e:	c194                	sw	a3,0(a1)
     260:	fee799e3          	bne	a5,a4,252 <ecc_keygen_flow+0xea>
     264:	50010537          	lui	a0,0x50010
     268:	10450513          	add	a0,a0,260 # 50010104 <trap_msg+0x90>
     26c:	108010ef          	jal	1374 <puts>
     270:	0220000f          	fence	r,r
     274:	0220000f          	fence	r,r
     278:	100087b7          	lui	a5,0x10008
     27c:	4705                	li	a4,1
     27e:	cb98                	sw	a4,16(a5)
     280:	01878713          	add	a4,a5,24 # 10008018 <_bss_lma_end+0x1000606c>
     284:	431c                	lw	a5,0(a4)
     286:	8b89                	and	a5,a5,2
     288:	dff5                	beqz	a5,284 <ecc_keygen_flow+0x11c>
     28a:	00094783          	lbu	a5,0(s2)
     28e:	c3fd                	beqz	a5,374 <ecc_keygen_flow+0x20c>
     290:	50010537          	lui	a0,0x50010
     294:	11050513          	add	a0,a0,272 # 50010110 <trap_msg+0x9c>
     298:	0dc010ef          	jal	1374 <puts>
     29c:	10008737          	lui	a4,0x10008
     2a0:	61470713          	add	a4,a4,1556 # 10008614 <_bss_lma_end+0x10006668>
     2a4:	431c                	lw	a5,0(a4)
     2a6:	8b89                	and	a5,a5,2
     2a8:	dff5                	beqz	a5,2a4 <ecc_keygen_flow+0x13c>
     2aa:	50010537          	lui	a0,0x50010
     2ae:	19c50513          	add	a0,a0,412 # 5001019c <trap_msg+0x128>
     2b2:	0c2010ef          	jal	1374 <puts>
     2b6:	0009c783          	lbu	a5,0(s3)
     2ba:	12078963          	beqz	a5,3ec <ecc_keygen_flow+0x284>
     2be:	100086b7          	lui	a3,0x10008
     2c2:	efff8637          	lui	a2,0xefff8
     2c6:	100087b7          	lui	a5,0x10008
     2ca:	20068693          	add	a3,a3,512 # 10008200 <_bss_lma_end+0x10006254>
     2ce:	e0460613          	add	a2,a2,-508 # efff7e04 <_tbs_der_store_end+0x9ffd8de4>
     2d2:	23078793          	add	a5,a5,560 # 10008230 <_bss_lma_end+0x10006284>
     2d6:	00c68733          	add	a4,a3,a2
     2da:	428c                	lw	a1,0(a3)
     2dc:	974e                	add	a4,a4,s3
     2de:	c30c                	sw	a1,0(a4)
     2e0:	0691                	add	a3,a3,4
     2e2:	fef69ae3          	bne	a3,a5,2d6 <ecc_keygen_flow+0x16e>
     2e6:	50010537          	lui	a0,0x50010
     2ea:	1e850513          	add	a0,a0,488 # 500101e8 <trap_msg+0x174>
     2ee:	086010ef          	jal	1374 <puts>
     2f2:	0004c783          	lbu	a5,0(s1)
     2f6:	16078163          	beqz	a5,458 <ecc_keygen_flow+0x2f0>
     2fa:	10008737          	lui	a4,0x10008
     2fe:	efff8637          	lui	a2,0xefff8
     302:	100087b7          	lui	a5,0x10008
     306:	28070713          	add	a4,a4,640 # 10008280 <_bss_lma_end+0x100062d4>
     30a:	d8460613          	add	a2,a2,-636 # efff7d84 <_tbs_der_store_end+0x9ffd8d64>
     30e:	2b078793          	add	a5,a5,688 # 100082b0 <_bss_lma_end+0x10006304>
     312:	00c706b3          	add	a3,a4,a2
     316:	430c                	lw	a1,0(a4)
     318:	96a6                	add	a3,a3,s1
     31a:	c28c                	sw	a1,0(a3)
     31c:	0711                	add	a4,a4,4
     31e:	fef71ae3          	bne	a4,a5,312 <ecc_keygen_flow+0x1aa>
     322:	50b2                	lw	ra,44(sp)
     324:	5422                	lw	s0,40(sp)
     326:	5492                	lw	s1,36(sp)
     328:	5902                	lw	s2,32(sp)
     32a:	49f2                	lw	s3,28(sp)
     32c:	4a62                	lw	s4,24(sp)
     32e:	4ad2                	lw	s5,20(sp)
     330:	4b42                	lw	s6,16(sp)
     332:	4bb2                	lw	s7,12(sp)
     334:	6145                	add	sp,sp,48
     336:	8082                	ret
     338:	04400613          	li	a2,68
     33c:	460b8593          	add	a1,s7,1120
     340:	0f0b0513          	add	a0,s6,240
     344:	032010ef          	jal	1376 <printf>
     348:	100087b7          	lui	a5,0x10008
     34c:	efff8637          	lui	a2,0xefff8
     350:	10008737          	lui	a4,0x10008
     354:	08078793          	add	a5,a5,128 # 10008080 <_bss_lma_end+0x100060d4>
     358:	f8060613          	add	a2,a2,-128 # efff7f80 <_tbs_der_store_end+0x9ffd8f60>
     35c:	0b070713          	add	a4,a4,176 # 100080b0 <_bss_lma_end+0x10006104>
     360:	85be                	mv	a1,a5
     362:	0791                	add	a5,a5,4
     364:	00c786b3          	add	a3,a5,a2
     368:	96d6                	add	a3,a3,s5
     36a:	4294                	lw	a3,0(a3)
     36c:	c194                	sw	a3,0(a1)
     36e:	fee799e3          	bne	a5,a4,360 <ecc_keygen_flow+0x1f8>
     372:	b5ad                	j	1dc <ecc_keygen_flow+0x74>
     374:	50010537          	lui	a0,0x50010
     378:	12450513          	add	a0,a0,292 # 50010124 <trap_msg+0xb0>
     37c:	7f9000ef          	jal	1374 <puts>
     380:	100087b7          	lui	a5,0x10008
     384:	efff86b7          	lui	a3,0xefff8
     388:	10008737          	lui	a4,0x10008
     38c:	4401                	li	s0,0
     38e:	18078793          	add	a5,a5,384 # 10008180 <_bss_lma_end+0x100061d4>
     392:	e8468693          	add	a3,a3,-380 # efff7e84 <_tbs_der_store_end+0x9ffd8e64>
     396:	1b070713          	add	a4,a4,432 # 100081b0 <_bss_lma_end+0x10006204>
     39a:	00d78633          	add	a2,a5,a3
     39e:	964a                	add	a2,a2,s2
     3a0:	0007aa03          	lw	s4,0(a5)
     3a4:	4210                	lw	a2,0(a2)
     3a6:	02ca0e63          	beq	s4,a2,3e2 <ecc_keygen_flow+0x27a>
     3aa:	50010537          	lui	a0,0x50010
     3ae:	85a2                	mv	a1,s0
     3b0:	14050513          	add	a0,a0,320 # 50010140 <trap_msg+0xcc>
     3b4:	7c3000ef          	jal	1376 <printf>
     3b8:	50010537          	lui	a0,0x50010
     3bc:	85d2                	mv	a1,s4
     3be:	16c50513          	add	a0,a0,364 # 5001016c <trap_msg+0xf8>
     3c2:	7b5000ef          	jal	1376 <printf>
     3c6:	040a                	sll	s0,s0,0x2
     3c8:	008906b3          	add	a3,s2,s0
     3cc:	50010537          	lui	a0,0x50010
     3d0:	42cc                	lw	a1,4(a3)
     3d2:	18450513          	add	a0,a0,388 # 50010184 <trap_msg+0x110>
     3d6:	7a1000ef          	jal	1376 <printf>
     3da:	4505                	li	a0,1
     3dc:	793000ef          	jal	136e <putchar>
     3e0:	a001                	j	3e0 <ecc_keygen_flow+0x278>
     3e2:	0791                	add	a5,a5,4
     3e4:	0405                	add	s0,s0,1
     3e6:	fae79ae3          	bne	a5,a4,39a <ecc_keygen_flow+0x232>
     3ea:	b5c1                	j	2aa <ecc_keygen_flow+0x142>
     3ec:	100086b7          	lui	a3,0x10008
     3f0:	efff8737          	lui	a4,0xefff8
     3f4:	100087b7          	lui	a5,0x10008
     3f8:	4401                	li	s0,0
     3fa:	20068693          	add	a3,a3,512 # 10008200 <_bss_lma_end+0x10006254>
     3fe:	e0470713          	add	a4,a4,-508 # efff7e04 <_tbs_der_store_end+0x9ffd8de4>
     402:	23078793          	add	a5,a5,560 # 10008230 <_bss_lma_end+0x10006284>
     406:	00e68633          	add	a2,a3,a4
     40a:	964e                	add	a2,a2,s3
     40c:	0006a903          	lw	s2,0(a3)
     410:	4210                	lw	a2,0(a2)
     412:	02c90e63          	beq	s2,a2,44e <ecc_keygen_flow+0x2e6>
     416:	50010537          	lui	a0,0x50010
     41a:	85a2                	mv	a1,s0
     41c:	1b850513          	add	a0,a0,440 # 500101b8 <trap_msg+0x144>
     420:	757000ef          	jal	1376 <printf>
     424:	50010537          	lui	a0,0x50010
     428:	85ca                	mv	a1,s2
     42a:	16c50513          	add	a0,a0,364 # 5001016c <trap_msg+0xf8>
     42e:	749000ef          	jal	1376 <printf>
     432:	040a                	sll	s0,s0,0x2
     434:	00898733          	add	a4,s3,s0
     438:	50010537          	lui	a0,0x50010
     43c:	434c                	lw	a1,4(a4)
     43e:	18450513          	add	a0,a0,388 # 50010184 <trap_msg+0x110>
     442:	735000ef          	jal	1376 <printf>
     446:	4505                	li	a0,1
     448:	727000ef          	jal	136e <putchar>
     44c:	a001                	j	44c <ecc_keygen_flow+0x2e4>
     44e:	0691                	add	a3,a3,4
     450:	0405                	add	s0,s0,1
     452:	faf69ae3          	bne	a3,a5,406 <ecc_keygen_flow+0x29e>
     456:	bd41                	j	2e6 <ecc_keygen_flow+0x17e>
     458:	10008737          	lui	a4,0x10008
     45c:	efff86b7          	lui	a3,0xefff8
     460:	100087b7          	lui	a5,0x10008
     464:	4401                	li	s0,0
     466:	28070713          	add	a4,a4,640 # 10008280 <_bss_lma_end+0x100062d4>
     46a:	d8468693          	add	a3,a3,-636 # efff7d84 <_tbs_der_store_end+0x9ffd8d64>
     46e:	2b078793          	add	a5,a5,688 # 100082b0 <_bss_lma_end+0x10006304>
     472:	00d70633          	add	a2,a4,a3
     476:	9626                	add	a2,a2,s1
     478:	00072903          	lw	s2,0(a4)
     47c:	4210                	lw	a2,0(a2)
     47e:	02c90e63          	beq	s2,a2,4ba <ecc_keygen_flow+0x352>
     482:	50010537          	lui	a0,0x50010
     486:	85a2                	mv	a1,s0
     488:	20450513          	add	a0,a0,516 # 50010204 <trap_msg+0x190>
     48c:	6eb000ef          	jal	1376 <printf>
     490:	50010537          	lui	a0,0x50010
     494:	85ca                	mv	a1,s2
     496:	16c50513          	add	a0,a0,364 # 5001016c <trap_msg+0xf8>
     49a:	6dd000ef          	jal	1376 <printf>
     49e:	040a                	sll	s0,s0,0x2
     4a0:	008487b3          	add	a5,s1,s0
     4a4:	50010537          	lui	a0,0x50010
     4a8:	43cc                	lw	a1,4(a5)
     4aa:	18450513          	add	a0,a0,388 # 50010184 <trap_msg+0x110>
     4ae:	6c9000ef          	jal	1376 <printf>
     4b2:	4505                	li	a0,1
     4b4:	6bb000ef          	jal	136e <putchar>
     4b8:	a001                	j	4b8 <ecc_keygen_flow+0x350>
     4ba:	0711                	add	a4,a4,4
     4bc:	0405                	add	s0,s0,1
     4be:	faf71ae3          	bne	a4,a5,472 <ecc_keygen_flow+0x30a>
     4c2:	b585                	j	322 <ecc_keygen_flow+0x1ba>

000004c4 <ecc_signing_flow>:
     4c4:	1101                	add	sp,sp,-32
     4c6:	ca26                	sw	s1,20(sp)
     4c8:	84ba                	mv	s1,a4
     4ca:	10008737          	lui	a4,0x10008
     4ce:	cc22                	sw	s0,24(sp)
     4d0:	c84a                	sw	s2,16(sp)
     4d2:	c64e                	sw	s3,12(sp)
     4d4:	c452                	sw	s4,8(sp)
     4d6:	ce06                	sw	ra,28(sp)
     4d8:	842a                	mv	s0,a0
     4da:	8a2e                	mv	s4,a1
     4dc:	89b2                	mv	s3,a2
     4de:	8936                	mv	s2,a3
     4e0:	0761                	add	a4,a4,24 # 10008018 <_bss_lma_end+0x1000606c>
     4e2:	431c                	lw	a5,0(a4)
     4e4:	8b85                	and	a5,a5,1
     4e6:	dff5                	beqz	a5,4e2 <ecc_signing_flow+0x1e>
     4e8:	100087b7          	lui	a5,0x10008
     4ec:	00044703          	lbu	a4,0(s0)
     4f0:	58078793          	add	a5,a5,1408 # 10008580 <_bss_lma_end+0x100065d4>
     4f4:	e31d                	bnez	a4,51a <ecc_signing_flow+0x56>
     4f6:	efff8637          	lui	a2,0xefff8
     4fa:	10008737          	lui	a4,0x10008
     4fe:	a8060613          	add	a2,a2,-1408 # efff7a80 <_tbs_der_store_end+0x9ffd8a60>
     502:	5b070713          	add	a4,a4,1456 # 100085b0 <_bss_lma_end+0x10006604>
     506:	85be                	mv	a1,a5
     508:	0791                	add	a5,a5,4
     50a:	00c786b3          	add	a3,a5,a2
     50e:	96a2                	add	a3,a3,s0
     510:	4294                	lw	a3,0(a3)
     512:	c194                	sw	a3,0(a1)
     514:	fee799e3          	bne	a5,a4,506 <ecc_signing_flow+0x42>
     518:	a81d                	j	54e <ecc_signing_flow+0x8a>
     51a:	50010537          	lui	a0,0x50010
     51e:	23450513          	add	a0,a0,564 # 50010234 <trap_msg+0x1c0>
     522:	653000ef          	jal	1374 <puts>
     526:	00144783          	lbu	a5,1(s0)
     52a:	0786                	sll	a5,a5,0x1
     52c:	03e7f793          	and	a5,a5,62
     530:	0017e793          	or	a5,a5,1
     534:	0220000f          	fence	r,r
     538:	0220000f          	fence	r,r
     53c:	10008737          	lui	a4,0x10008
     540:	60f72023          	sw	a5,1536(a4) # 10008600 <_bss_lma_end+0x10006654>
     544:	60470713          	add	a4,a4,1540
     548:	431c                	lw	a5,0(a4)
     54a:	8b89                	and	a5,a5,2
     54c:	dff5                	beqz	a5,548 <ecc_signing_flow+0x84>
     54e:	100087b7          	lui	a5,0x10008
     552:	efff8637          	lui	a2,0xefff8
     556:	10008737          	lui	a4,0x10008
     55a:	10078793          	add	a5,a5,256 # 10008100 <_bss_lma_end+0x10006154>
     55e:	f0060613          	add	a2,a2,-256 # efff7f00 <_tbs_der_store_end+0x9ffd8ee0>
     562:	13070713          	add	a4,a4,304 # 10008130 <_bss_lma_end+0x10006184>
     566:	85be                	mv	a1,a5
     568:	0791                	add	a5,a5,4
     56a:	00c786b3          	add	a3,a5,a2
     56e:	96d2                	add	a3,a3,s4
     570:	4294                	lw	a3,0(a3)
     572:	c194                	sw	a3,0(a1)
     574:	fee799e3          	bne	a5,a4,566 <ecc_signing_flow+0xa2>
     578:	100087b7          	lui	a5,0x10008
     57c:	efff8637          	lui	a2,0xefff8
     580:	10008737          	lui	a4,0x10008
     584:	48078793          	add	a5,a5,1152 # 10008480 <_bss_lma_end+0x100064d4>
     588:	b8060613          	add	a2,a2,-1152 # efff7b80 <_tbs_der_store_end+0x9ffd8b60>
     58c:	4b070713          	add	a4,a4,1200 # 100084b0 <_bss_lma_end+0x10006504>
     590:	85be                	mv	a1,a5
     592:	0791                	add	a5,a5,4
     594:	00c786b3          	add	a3,a5,a2
     598:	96ce                	add	a3,a3,s3
     59a:	4294                	lw	a3,0(a3)
     59c:	c194                	sw	a3,0(a1)
     59e:	fee799e3          	bne	a5,a4,590 <ecc_signing_flow+0xcc>
     5a2:	50010537          	lui	a0,0x50010
     5a6:	25450513          	add	a0,a0,596 # 50010254 <trap_msg+0x1e0>
     5aa:	5cb000ef          	jal	1374 <puts>
     5ae:	0220000f          	fence	r,r
     5b2:	0220000f          	fence	r,r
     5b6:	100087b7          	lui	a5,0x10008
     5ba:	4709                	li	a4,2
     5bc:	cb98                	sw	a4,16(a5)
     5be:	01878713          	add	a4,a5,24 # 10008018 <_bss_lma_end+0x1000606c>
     5c2:	431c                	lw	a5,0(a4)
     5c4:	8b89                	and	a5,a5,2
     5c6:	dff5                	beqz	a5,5c2 <ecc_signing_flow+0xfe>
     5c8:	50010537          	lui	a0,0x50010
     5cc:	26450513          	add	a0,a0,612 # 50010264 <trap_msg+0x1f0>
     5d0:	5a5000ef          	jal	1374 <puts>
     5d4:	00094783          	lbu	a5,0(s2)
     5d8:	cbb5                	beqz	a5,64c <ecc_signing_flow+0x188>
     5da:	100087b7          	lui	a5,0x10008
     5de:	efff8637          	lui	a2,0xefff8
     5e2:	10008737          	lui	a4,0x10008
     5e6:	30078793          	add	a5,a5,768 # 10008300 <_bss_lma_end+0x10006354>
     5ea:	d0460613          	add	a2,a2,-764 # efff7d04 <_tbs_der_store_end+0x9ffd8ce4>
     5ee:	33070713          	add	a4,a4,816 # 10008330 <_bss_lma_end+0x10006384>
     5f2:	00c786b3          	add	a3,a5,a2
     5f6:	438c                	lw	a1,0(a5)
     5f8:	96ca                	add	a3,a3,s2
     5fa:	c28c                	sw	a1,0(a3)
     5fc:	0791                	add	a5,a5,4
     5fe:	fee79ae3          	bne	a5,a4,5f2 <ecc_signing_flow+0x12e>
     602:	50010537          	lui	a0,0x50010
     606:	2dc50513          	add	a0,a0,732 # 500102dc <trap_msg+0x268>
     60a:	56b000ef          	jal	1374 <puts>
     60e:	0004c783          	lbu	a5,0(s1)
     612:	c3dd                	beqz	a5,6b8 <ecc_signing_flow+0x1f4>
     614:	100087b7          	lui	a5,0x10008
     618:	efff8637          	lui	a2,0xefff8
     61c:	10008737          	lui	a4,0x10008
     620:	38078793          	add	a5,a5,896 # 10008380 <_bss_lma_end+0x100063d4>
     624:	c8460613          	add	a2,a2,-892 # efff7c84 <_tbs_der_store_end+0x9ffd8c64>
     628:	3b070713          	add	a4,a4,944 # 100083b0 <_bss_lma_end+0x10006404>
     62c:	00c786b3          	add	a3,a5,a2
     630:	438c                	lw	a1,0(a5)
     632:	96a6                	add	a3,a3,s1
     634:	c28c                	sw	a1,0(a3)
     636:	0791                	add	a5,a5,4
     638:	fee79ae3          	bne	a5,a4,62c <ecc_signing_flow+0x168>
     63c:	40f2                	lw	ra,28(sp)
     63e:	4462                	lw	s0,24(sp)
     640:	44d2                	lw	s1,20(sp)
     642:	4942                	lw	s2,16(sp)
     644:	49b2                	lw	s3,12(sp)
     646:	4a22                	lw	s4,8(sp)
     648:	6105                	add	sp,sp,32
     64a:	8082                	ret
     64c:	100087b7          	lui	a5,0x10008
     650:	efff86b7          	lui	a3,0xefff8
     654:	10008737          	lui	a4,0x10008
     658:	4401                	li	s0,0
     65a:	30078793          	add	a5,a5,768 # 10008300 <_bss_lma_end+0x10006354>
     65e:	d0468693          	add	a3,a3,-764 # efff7d04 <_tbs_der_store_end+0x9ffd8ce4>
     662:	33070713          	add	a4,a4,816 # 10008330 <_bss_lma_end+0x10006384>
     666:	00d78633          	add	a2,a5,a3
     66a:	964a                	add	a2,a2,s2
     66c:	0007a983          	lw	s3,0(a5)
     670:	4210                	lw	a2,0(a2)
     672:	02c98e63          	beq	s3,a2,6ae <ecc_signing_flow+0x1ea>
     676:	50010537          	lui	a0,0x50010
     67a:	85a2                	mv	a1,s0
     67c:	28050513          	add	a0,a0,640 # 50010280 <trap_msg+0x20c>
     680:	4f7000ef          	jal	1376 <printf>
     684:	50010537          	lui	a0,0x50010
     688:	85ce                	mv	a1,s3
     68a:	2ac50513          	add	a0,a0,684 # 500102ac <trap_msg+0x238>
     68e:	4e9000ef          	jal	1376 <printf>
     692:	040a                	sll	s0,s0,0x2
     694:	008906b3          	add	a3,s2,s0
     698:	50010537          	lui	a0,0x50010
     69c:	42cc                	lw	a1,4(a3)
     69e:	2c450513          	add	a0,a0,708 # 500102c4 <trap_msg+0x250>
     6a2:	4d5000ef          	jal	1376 <printf>
     6a6:	4505                	li	a0,1
     6a8:	4c7000ef          	jal	136e <putchar>
     6ac:	a001                	j	6ac <ecc_signing_flow+0x1e8>
     6ae:	0791                	add	a5,a5,4
     6b0:	0405                	add	s0,s0,1
     6b2:	fae79ae3          	bne	a5,a4,666 <ecc_signing_flow+0x1a2>
     6b6:	b7b1                	j	602 <ecc_signing_flow+0x13e>
     6b8:	100087b7          	lui	a5,0x10008
     6bc:	efff86b7          	lui	a3,0xefff8
     6c0:	10008737          	lui	a4,0x10008
     6c4:	4401                	li	s0,0
     6c6:	38078793          	add	a5,a5,896 # 10008380 <_bss_lma_end+0x100063d4>
     6ca:	c8468693          	add	a3,a3,-892 # efff7c84 <_tbs_der_store_end+0x9ffd8c64>
     6ce:	3b070713          	add	a4,a4,944 # 100083b0 <_bss_lma_end+0x10006404>
     6d2:	00d78633          	add	a2,a5,a3
     6d6:	9626                	add	a2,a2,s1
     6d8:	0007a903          	lw	s2,0(a5)
     6dc:	4210                	lw	a2,0(a2)
     6de:	02c90e63          	beq	s2,a2,71a <ecc_signing_flow+0x256>
     6e2:	50010537          	lui	a0,0x50010
     6e6:	85a2                	mv	a1,s0
     6e8:	2f850513          	add	a0,a0,760 # 500102f8 <trap_msg+0x284>
     6ec:	48b000ef          	jal	1376 <printf>
     6f0:	50010537          	lui	a0,0x50010
     6f4:	85ca                	mv	a1,s2
     6f6:	16c50513          	add	a0,a0,364 # 5001016c <trap_msg+0xf8>
     6fa:	47d000ef          	jal	1376 <printf>
     6fe:	040a                	sll	s0,s0,0x2
     700:	00848733          	add	a4,s1,s0
     704:	50010537          	lui	a0,0x50010
     708:	434c                	lw	a1,4(a4)
     70a:	18450513          	add	a0,a0,388 # 50010184 <trap_msg+0x110>
     70e:	469000ef          	jal	1376 <printf>
     712:	4505                	li	a0,1
     714:	45b000ef          	jal	136e <putchar>
     718:	a001                	j	718 <ecc_signing_flow+0x254>
     71a:	0791                	add	a5,a5,4
     71c:	0405                	add	s0,s0,1
     71e:	fae79ae3          	bne	a5,a4,6d2 <ecc_signing_flow+0x20e>
     722:	bf29                	j	63c <ecc_signing_flow+0x178>

00000724 <ecc_verifying_flow>:
     724:	1141                	add	sp,sp,-16
     726:	c422                	sw	s0,8(sp)
     728:	8436                	mv	s0,a3
     72a:	100086b7          	lui	a3,0x10008
     72e:	c606                	sw	ra,12(sp)
     730:	c226                	sw	s1,4(sp)
     732:	c04a                	sw	s2,0(sp)
     734:	06e1                	add	a3,a3,24 # 10008018 <_bss_lma_end+0x1000606c>
     736:	429c                	lw	a5,0(a3)
     738:	8b85                	and	a5,a5,1
     73a:	dff5                	beqz	a5,736 <ecc_verifying_flow+0x12>
     73c:	100087b7          	lui	a5,0x10008
     740:	100086b7          	lui	a3,0x10008
     744:	10078793          	add	a5,a5,256 # 10008100 <_bss_lma_end+0x10006154>
     748:	13068693          	add	a3,a3,304 # 10008130 <_bss_lma_end+0x10006184>
     74c:	883e                	mv	a6,a5
     74e:	00452883          	lw	a7,4(a0)
     752:	0791                	add	a5,a5,4
     754:	01182023          	sw	a7,0(a6)
     758:	0511                	add	a0,a0,4
     75a:	fed799e3          	bne	a5,a3,74c <ecc_verifying_flow+0x28>
     75e:	100087b7          	lui	a5,0x10008
     762:	100086b7          	lui	a3,0x10008
     766:	20078793          	add	a5,a5,512 # 10008200 <_bss_lma_end+0x10006254>
     76a:	23068693          	add	a3,a3,560 # 10008230 <_bss_lma_end+0x10006284>
     76e:	853e                	mv	a0,a5
     770:	0045a803          	lw	a6,4(a1)
     774:	0791                	add	a5,a5,4
     776:	01052023          	sw	a6,0(a0)
     77a:	0591                	add	a1,a1,4
     77c:	fed799e3          	bne	a5,a3,76e <ecc_verifying_flow+0x4a>
     780:	100087b7          	lui	a5,0x10008
     784:	100086b7          	lui	a3,0x10008
     788:	28078793          	add	a5,a5,640 # 10008280 <_bss_lma_end+0x100062d4>
     78c:	2b068693          	add	a3,a3,688 # 100082b0 <_bss_lma_end+0x10006304>
     790:	85be                	mv	a1,a5
     792:	4248                	lw	a0,4(a2)
     794:	0791                	add	a5,a5,4
     796:	c188                	sw	a0,0(a1)
     798:	0611                	add	a2,a2,4
     79a:	fed79be3          	bne	a5,a3,790 <ecc_verifying_flow+0x6c>
     79e:	100087b7          	lui	a5,0x10008
     7a2:	100086b7          	lui	a3,0x10008
     7a6:	8622                	mv	a2,s0
     7a8:	30078793          	add	a5,a5,768 # 10008300 <_bss_lma_end+0x10006354>
     7ac:	33068693          	add	a3,a3,816 # 10008330 <_bss_lma_end+0x10006384>
     7b0:	85be                	mv	a1,a5
     7b2:	4248                	lw	a0,4(a2)
     7b4:	0791                	add	a5,a5,4
     7b6:	c188                	sw	a0,0(a1)
     7b8:	0611                	add	a2,a2,4
     7ba:	fed79be3          	bne	a5,a3,7b0 <ecc_verifying_flow+0x8c>
     7be:	100087b7          	lui	a5,0x10008
     7c2:	100086b7          	lui	a3,0x10008
     7c6:	38078793          	add	a5,a5,896 # 10008380 <_bss_lma_end+0x100063d4>
     7ca:	3b068693          	add	a3,a3,944 # 100083b0 <_bss_lma_end+0x10006404>
     7ce:	863e                	mv	a2,a5
     7d0:	434c                	lw	a1,4(a4)
     7d2:	0791                	add	a5,a5,4
     7d4:	c20c                	sw	a1,0(a2)
     7d6:	0711                	add	a4,a4,4
     7d8:	fed79be3          	bne	a5,a3,7ce <mrac+0xe>
     7dc:	50010537          	lui	a0,0x50010
     7e0:	32450513          	add	a0,a0,804 # 50010324 <trap_msg+0x2b0>
     7e4:	391000ef          	jal	1374 <puts>
     7e8:	0220000f          	fence	r,r
     7ec:	0220000f          	fence	r,r
     7f0:	100087b7          	lui	a5,0x10008
     7f4:	470d                	li	a4,3
     7f6:	cb98                	sw	a4,16(a5)
     7f8:	00062837          	lui	a6,0x62
     7fc:	30030737          	lui	a4,0x30030
     800:	300308b7          	lui	a7,0x30030
     804:	3e900513          	li	a0,1001
     808:	01878593          	add	a1,a5,24 # 10008018 <_bss_lma_end+0x1000606c>
     80c:	64070713          	add	a4,a4,1600 # 30030640 <_bss_lma_end+0x3002e694>
     810:	a8080813          	add	a6,a6,-1408 # 61a80 <_bss_lma_end+0x5fad4>
     814:	64888893          	add	a7,a7,1608 # 30030648 <_bss_lma_end+0x3002e69c>
     818:	419c                	lw	a5,0(a1)
     81a:	8b89                	and	a5,a5,2
     81c:	c3bd                	beqz	a5,882 <mfdc+0x89>
     81e:	50010537          	lui	a0,0x50010
     822:	33450513          	add	a0,a0,820 # 50010334 <trap_msg+0x2c0>
     826:	34f000ef          	jal	1374 <puts>
     82a:	100087b7          	lui	a5,0x10008
     82e:	4581                	li	a1,0
     830:	40078793          	add	a5,a5,1024 # 10008400 <_bss_lma_end+0x10006454>
     834:	46b1                	li	a3,12
     836:	00259713          	sll	a4,a1,0x2
     83a:	973e                	add	a4,a4,a5
     83c:	00072903          	lw	s2,0(a4)
     840:	4044                	lw	s1,4(s0)
     842:	06990b63          	beq	s2,s1,8b8 <mfdc+0xbf>
     846:	50010537          	lui	a0,0x50010
     84a:	35050513          	add	a0,a0,848 # 50010350 <trap_msg+0x2dc>
     84e:	329000ef          	jal	1376 <printf>
     852:	50010537          	lui	a0,0x50010
     856:	85ca                	mv	a1,s2
     858:	38050513          	add	a0,a0,896 # 50010380 <trap_msg+0x30c>
     85c:	31b000ef          	jal	1376 <printf>
     860:	50010537          	lui	a0,0x50010
     864:	85a6                	mv	a1,s1
     866:	39850513          	add	a0,a0,920 # 50010398 <trap_msg+0x324>
     86a:	30d000ef          	jal	1376 <printf>
     86e:	4505                	li	a0,1
     870:	2ff000ef          	jal	136e <putchar>
     874:	557d                	li	a0,-1
     876:	40b2                	lw	ra,12(sp)
     878:	4422                	lw	s0,8(sp)
     87a:	4492                	lw	s1,4(sp)
     87c:	4902                	lw	s2,0(sp)
     87e:	0141                	add	sp,sp,16
     880:	8082                	ret
     882:	157d                	add	a0,a0,-1
     884:	d965                	beqz	a0,874 <mfdc+0x7b>
     886:	4310                	lw	a2,0(a4)
     888:	01060333          	add	t1,a2,a6
     88c:	4354                	lw	a3,4(a4)
     88e:	00c337b3          	sltu	a5,t1,a2
     892:	97b6                	add	a5,a5,a3
     894:	0068a023          	sw	t1,0(a7)
     898:	861a                	mv	a2,t1
     89a:	00f8a223          	sw	a5,4(a7)
     89e:	00072303          	lw	t1,0(a4)
     8a2:	00472383          	lw	t2,4(a4)
     8a6:	00f3e663          	bltu	t2,a5,8b2 <mfdc+0xb9>
     8aa:	f67797e3          	bne	a5,t2,818 <mfdc+0x1f>
     8ae:	f6c375e3          	bgeu	t1,a2,818 <mfdc+0x1f>
     8b2:	10500073          	wfi
     8b6:	b7e5                	j	89e <mfdc+0xa5>
     8b8:	0585                	add	a1,a1,1
     8ba:	0411                	add	s0,s0,4
     8bc:	f6d59de3          	bne	a1,a3,836 <mfdc+0x3d>
     8c0:	4501                	li	a0,0
     8c2:	bf55                	j	876 <mfdc+0x7d>

000008c4 <ecc_sigh_test>:
     8c4:	8c010113          	add	sp,sp,-1856
     8c8:	72912a23          	sw	s1,1844(sp)
     8cc:	84ae                	mv	s1,a1
     8ce:	500105b7          	lui	a1,0x50010
     8d2:	72812c23          	sw	s0,1848(sp)
     8d6:	73312623          	sw	s3,1836(sp)
     8da:	00058413          	mv	s0,a1
     8de:	03000613          	li	a2,48
     8e2:	00058593          	mv	a1,a1
     8e6:	89aa                	mv	s3,a0
     8e8:	0ce8                	add	a0,sp,604
     8ea:	72112e23          	sw	ra,1852(sp)
     8ee:	73212823          	sw	s2,1840(sp)
     8f2:	73412423          	sw	s4,1832(sp)
     8f6:	6b1000ef          	jal	17a6 <memcpy>
     8fa:	07000613          	li	a2,112
     8fe:	4581                	li	a1,0
     900:	49c10513          	add	a0,sp,1180
     904:	5fb000ef          	jal	16fe <memset>
     908:	486927b7          	lui	a5,0x48692
     90c:	05478793          	add	a5,a5,84 # 48692054 <_bss_lma_end+0x486900a8>
     910:	48f12823          	sw	a5,1168(sp)
     914:	686577b7          	lui	a5,0x68657
     918:	26578793          	add	a5,a5,613 # 68657265 <_tbs_der_store_end+0x18638245>
     91c:	03000613          	li	a2,48
     920:	48f12a23          	sw	a5,1172(sp)
     924:	800007b7          	lui	a5,0x80000
     928:	00c405b3          	add	a1,s0,a2
     92c:	48f12c23          	sw	a5,1176(sp)
     930:	0568                	add	a0,sp,652
     932:	44000793          	li	a5,1088
     936:	50f12623          	sw	a5,1292(sp)
     93a:	66d000ef          	jal	17a6 <memcpy>
     93e:	06040593          	add	a1,s0,96
     942:	4651                	li	a2,20
     944:	04a8                	add	a0,sp,584
     946:	661000ef          	jal	17a6 <memcpy>
     94a:	03000613          	li	a2,48
     94e:	0cec                	add	a1,sp,604
     950:	51410513          	add	a0,sp,1300
     954:	50010823          	sb	zero,1296(sp)
     958:	64f000ef          	jal	17a6 <memcpy>
     95c:	08000613          	li	a2,128
     960:	49010593          	add	a1,sp,1168
     964:	59810513          	add	a0,sp,1432
     968:	58010a23          	sb	zero,1428(sp)
     96c:	63b000ef          	jal	17a6 <memcpy>
     970:	4651                	li	a2,20
     972:	04ac                	add	a1,sp,584
     974:	61c10513          	add	a0,sp,1564
     978:	60010c23          	sb	zero,1560(sp)
     97c:	62b000ef          	jal	17a6 <memcpy>
     980:	03000613          	li	a2,48
     984:	056c                	add	a1,sp,652
     986:	6a010513          	add	a0,sp,1696
     98a:	61d000ef          	jal	17a6 <memcpy>
     98e:	02000713          	li	a4,32
     992:	58e10b23          	sb	a4,1430(sp)
     996:	4715                	li	a4,5
     998:	47b1                	li	a5,12
     99a:	60e10d23          	sb	a4,1562(sp)
     99e:	08400613          	li	a2,132
     9a2:	30000713          	li	a4,768
     9a6:	51010593          	add	a1,sp,1296
     9aa:	1b08                	add	a0,sp,432
     9ac:	68e11e23          	sh	a4,1692(sp)
     9b0:	50f10923          	sb	a5,1298(sp)
     9b4:	68f10f23          	sb	a5,1694(sp)
     9b8:	5ef000ef          	jal	17a6 <memcpy>
     9bc:	08400613          	li	a2,132
     9c0:	59410593          	add	a1,sp,1428
     9c4:	1208                	add	a0,sp,288
     9c6:	5e1000ef          	jal	17a6 <memcpy>
     9ca:	08400613          	li	a2,132
     9ce:	61810593          	add	a1,sp,1560
     9d2:	0908                	add	a0,sp,144
     9d4:	5d3000ef          	jal	17a6 <memcpy>
     9d8:	08400613          	li	a2,132
     9dc:	69c10593          	add	a1,sp,1692
     9e0:	850a                	mv	a0,sp
     9e2:	5c5000ef          	jal	17a6 <memcpy>
     9e6:	868a                	mv	a3,sp
     9e8:	0910                	add	a2,sp,144
     9ea:	120c                	add	a1,sp,288
     9ec:	1b08                	add	a0,sp,432
     9ee:	2eb1                	jal	d4a <hmac_flow>
     9f0:	30100793          	li	a5,769
     9f4:	03000613          	li	a2,48
     9f8:	4581                	li	a1,0
     9fa:	0588                	add	a0,sp,704
     9fc:	2af11e23          	sh	a5,700(sp)
     a00:	4ff000ef          	jal	16fe <memset>
     a04:	03000613          	li	a2,48
     a08:	4581                	li	a1,0
     a0a:	1dc8                	add	a0,sp,756
     a0c:	2e010823          	sb	zero,752(sp)
     a10:	4ef000ef          	jal	16fe <memset>
     a14:	03000613          	li	a2,48
     a18:	4581                	li	a1,0
     a1a:	1628                	add	a0,sp,808
     a1c:	32010223          	sb	zero,804(sp)
     a20:	4df000ef          	jal	16fe <memset>
     a24:	40100793          	li	a5,1025
     a28:	03000613          	li	a2,48
     a2c:	4581                	li	a1,0
     a2e:	0ee8                	add	a0,sp,860
     a30:	34f11c23          	sh	a5,856(sp)
     a34:	4cb000ef          	jal	16fe <memset>
     a38:	4405                	li	s0,1
     a3a:	03000613          	li	a2,48
     a3e:	4581                	li	a1,0
     a40:	0f08                	add	a0,sp,912
     a42:	38810623          	sb	s0,908(sp)
     a46:	4b9000ef          	jal	16fe <memset>
     a4a:	03000613          	li	a2,48
     a4e:	4581                	li	a1,0
     a50:	07c8                	add	a0,sp,964
     a52:	3c810023          	sb	s0,960(sp)
     a56:	4a9000ef          	jal	16fe <memset>
     a5a:	079c                	add	a5,sp,960
     a5c:	0778                	add	a4,sp,908
     a5e:	0eb4                	add	a3,sp,856
     a60:	1650                	add	a2,sp,804
     a62:	1d8c                	add	a1,sp,752
     a64:	1d68                	add	a0,sp,700
     a66:	f02ff0ef          	jal	168 <ecc_keygen_flow>
     a6a:	50010537          	lui	a0,0x50010
     a6e:	3b050513          	add	a0,a0,944 # 500103b0 <trap_msg+0x33c>
     a72:	103000ef          	jal	1374 <puts>
     a76:	0760                	add	s0,sp,908
     a78:	3bc10a13          	add	s4,sp,956
     a7c:	50010937          	lui	s2,0x50010
     a80:	404c                	lw	a1,4(s0)
     a82:	3c090513          	add	a0,s2,960 # 500103c0 <trap_msg+0x34c>
     a86:	0411                	add	s0,s0,4
     a88:	0ef000ef          	jal	1376 <printf>
     a8c:	fe8a1ae3          	bne	s4,s0,a80 <ecc_sigh_test+0x1bc>
     a90:	4529                	li	a0,10
     a92:	0dd000ef          	jal	136e <putchar>
     a96:	03000613          	li	a2,48
     a9a:	0f0c                	add	a1,sp,912
     a9c:	8526                	mv	a0,s1
     a9e:	509000ef          	jal	17a6 <memcpy>
     aa2:	50010537          	lui	a0,0x50010
     aa6:	3c850513          	add	a0,a0,968 # 500103c8 <trap_msg+0x354>
     aaa:	0cb000ef          	jal	1374 <puts>
     aae:	0780                	add	s0,sp,960
     ab0:	3f010a13          	add	s4,sp,1008
     ab4:	404c                	lw	a1,4(s0)
     ab6:	3c090513          	add	a0,s2,960
     aba:	0411                	add	s0,s0,4
     abc:	0bb000ef          	jal	1376 <printf>
     ac0:	fe8a1ae3          	bne	s4,s0,ab4 <ecc_sigh_test+0x1f0>
     ac4:	4529                	li	a0,10
     ac6:	0a9000ef          	jal	136e <putchar>
     aca:	03000613          	li	a2,48
     ace:	07cc                	add	a1,sp,964
     ad0:	00c48533          	add	a0,s1,a2
     ad4:	4d3000ef          	jal	17a6 <memcpy>
     ad8:	4405                	li	s0,1
     ada:	03000613          	li	a2,48
     ade:	4581                	li	a1,0
     ae0:	1fa8                	add	a0,sp,1016
     ae2:	3e810a23          	sb	s0,1012(sp)
     ae6:	419000ef          	jal	16fe <memset>
     aea:	03000613          	li	a2,48
     aee:	4581                	li	a1,0
     af0:	42c10513          	add	a0,sp,1068
     af4:	42810423          	sb	s0,1064(sp)
     af8:	407000ef          	jal	16fe <memset>
     afc:	85ce                	mv	a1,s3
     afe:	03000613          	li	a2,48
     b02:	46010513          	add	a0,sp,1120
     b06:	4a1000ef          	jal	17a6 <memcpy>
     b0a:	42810713          	add	a4,sp,1064
     b0e:	1fd4                	add	a3,sp,1012
     b10:	1650                	add	a2,sp,804
     b12:	45c10593          	add	a1,sp,1116
     b16:	0ea8                	add	a0,sp,856
     b18:	3275                	jal	4c4 <ecc_signing_flow>
     b1a:	50010537          	lui	a0,0x50010
     b1e:	3d850513          	add	a0,a0,984 # 500103d8 <trap_msg+0x364>
     b22:	053000ef          	jal	1374 <puts>
     b26:	1fc0                	add	s0,sp,1012
     b28:	42410993          	add	s3,sp,1060
     b2c:	404c                	lw	a1,4(s0)
     b2e:	3c090513          	add	a0,s2,960
     b32:	0411                	add	s0,s0,4
     b34:	043000ef          	jal	1376 <printf>
     b38:	ff341ae3          	bne	s0,s3,b2c <ecc_sigh_test+0x268>
     b3c:	4529                	li	a0,10
     b3e:	031000ef          	jal	136e <putchar>
     b42:	03000613          	li	a2,48
     b46:	1fac                	add	a1,sp,1016
     b48:	06048513          	add	a0,s1,96
     b4c:	45b000ef          	jal	17a6 <memcpy>
     b50:	50010537          	lui	a0,0x50010
     b54:	3e850513          	add	a0,a0,1000 # 500103e8 <trap_msg+0x374>
     b58:	01d000ef          	jal	1374 <puts>
     b5c:	42810413          	add	s0,sp,1064
     b60:	45810993          	add	s3,sp,1112
     b64:	404c                	lw	a1,4(s0)
     b66:	3c090513          	add	a0,s2,960
     b6a:	0411                	add	s0,s0,4
     b6c:	00b000ef          	jal	1376 <printf>
     b70:	fe899ae3          	bne	s3,s0,b64 <ecc_sigh_test+0x2a0>
     b74:	4529                	li	a0,10
     b76:	7f8000ef          	jal	136e <putchar>
     b7a:	03000613          	li	a2,48
     b7e:	42c10593          	add	a1,sp,1068
     b82:	09048513          	add	a0,s1,144
     b86:	421000ef          	jal	17a6 <memcpy>
     b8a:	0220000f          	fence	r,r
     b8e:	0220000f          	fence	r,r
     b92:	100187b7          	lui	a5,0x10018
     b96:	07b1                	add	a5,a5,12 # 1001800c <_bss_lma_end+0x10016060>
     b98:	4711                	li	a4,4
     b9a:	c398                	sw	a4,0(a5)
     b9c:	4398                	lw	a4,0(a5)
     b9e:	8b11                	and	a4,a4,4
     ba0:	ff75                	bnez	a4,b9c <ecc_sigh_test+0x2d8>
     ba2:	73812403          	lw	s0,1848(sp)
     ba6:	50010537          	lui	a0,0x50010
     baa:	73c12083          	lw	ra,1852(sp)
     bae:	73412483          	lw	s1,1844(sp)
     bb2:	73012903          	lw	s2,1840(sp)
     bb6:	72c12983          	lw	s3,1836(sp)
     bba:	72812a03          	lw	s4,1832(sp)
     bbe:	3f850513          	add	a0,a0,1016 # 500103f8 <trap_msg+0x384>
     bc2:	74010113          	add	sp,sp,1856
     bc6:	7ae0006f          	j	1374 <puts>

00000bca <ecc_verify_test>:
     bca:	d9010113          	add	sp,sp,-624
     bce:	26812423          	sw	s0,616(sp)
     bd2:	03000613          	li	a2,48
     bd6:	842e                	mv	s0,a1
     bd8:	85aa                	mv	a1,a0
     bda:	1408                	add	a0,sp,544
     bdc:	26112623          	sw	ra,620(sp)
     be0:	26912223          	sw	s1,612(sp)
     be4:	27212023          	sw	s2,608(sp)
     be8:	25312e23          	sw	s3,604(sp)
     bec:	3bb000ef          	jal	17a6 <memcpy>
     bf0:	03000613          	li	a2,48
     bf4:	85a2                	mv	a1,s0
     bf6:	0a88                	add	a0,sp,336
     bf8:	3af000ef          	jal	17a6 <memcpy>
     bfc:	50010537          	lui	a0,0x50010
     c00:	3b050513          	add	a0,a0,944 # 500103b0 <trap_msg+0x33c>
     c04:	770000ef          	jal	1374 <puts>
     c08:	14c10913          	add	s2,sp,332
     c0c:	17c10993          	add	s3,sp,380
     c10:	500104b7          	lui	s1,0x50010
     c14:	00492583          	lw	a1,4(s2)
     c18:	3c048513          	add	a0,s1,960 # 500103c0 <trap_msg+0x34c>
     c1c:	0911                	add	s2,s2,4
     c1e:	758000ef          	jal	1376 <printf>
     c22:	ff3919e3          	bne	s2,s3,c14 <ecc_verify_test+0x4a>
     c26:	4529                	li	a0,10
     c28:	746000ef          	jal	136e <putchar>
     c2c:	03000613          	li	a2,48
     c30:	00c405b3          	add	a1,s0,a2
     c34:	0348                	add	a0,sp,388
     c36:	371000ef          	jal	17a6 <memcpy>
     c3a:	50010537          	lui	a0,0x50010
     c3e:	3c850513          	add	a0,a0,968 # 500103c8 <trap_msg+0x354>
     c42:	732000ef          	jal	1374 <puts>
     c46:	18010913          	add	s2,sp,384
     c4a:	1b010993          	add	s3,sp,432
     c4e:	00492583          	lw	a1,4(s2)
     c52:	3c048513          	add	a0,s1,960
     c56:	0911                	add	s2,s2,4
     c58:	71e000ef          	jal	1376 <printf>
     c5c:	ff3919e3          	bne	s2,s3,c4e <ecc_verify_test+0x84>
     c60:	4529                	li	a0,10
     c62:	70c000ef          	jal	136e <putchar>
     c66:	03000613          	li	a2,48
     c6a:	06040593          	add	a1,s0,96
     c6e:	1b28                	add	a0,sp,440
     c70:	337000ef          	jal	17a6 <memcpy>
     c74:	50010537          	lui	a0,0x50010
     c78:	3d850513          	add	a0,a0,984 # 500103d8 <trap_msg+0x364>
     c7c:	6f8000ef          	jal	1374 <puts>
     c80:	1b410913          	add	s2,sp,436
     c84:	1e410993          	add	s3,sp,484
     c88:	00492583          	lw	a1,4(s2)
     c8c:	3c048513          	add	a0,s1,960
     c90:	0911                	add	s2,s2,4
     c92:	6e4000ef          	jal	1376 <printf>
     c96:	ff3919e3          	bne	s2,s3,c88 <ecc_verify_test+0xbe>
     c9a:	4529                	li	a0,10
     c9c:	2dc9                	jal	136e <putchar>
     c9e:	09040593          	add	a1,s0,144
     ca2:	03000613          	li	a2,48
     ca6:	13e8                	add	a0,sp,492
     ca8:	2ff000ef          	jal	17a6 <memcpy>
     cac:	50010537          	lui	a0,0x50010
     cb0:	3e850513          	add	a0,a0,1000 # 500103e8 <trap_msg+0x374>
     cb4:	25c1                	jal	1374 <puts>
     cb6:	13a0                	add	s0,sp,488
     cb8:	21810913          	add	s2,sp,536
     cbc:	404c                	lw	a1,4(s0)
     cbe:	3c048513          	add	a0,s1,960
     cc2:	0411                	add	s0,s0,4
     cc4:	2d4d                	jal	1376 <printf>
     cc6:	ff241be3          	bne	s0,s2,cbc <ecc_verify_test+0xf2>
     cca:	4529                	li	a0,10
     ccc:	254d                	jal	136e <putchar>
     cce:	03400613          	li	a2,52
     cd2:	0c6c                	add	a1,sp,540
     cd4:	0208                	add	a0,sp,256
     cd6:	2d1000ef          	jal	17a6 <memcpy>
     cda:	03400613          	li	a2,52
     cde:	02ec                	add	a1,sp,332
     ce0:	0188                	add	a0,sp,192
     ce2:	2c5000ef          	jal	17a6 <memcpy>
     ce6:	03400613          	li	a2,52
     cea:	030c                	add	a1,sp,384
     cec:	0108                	add	a0,sp,128
     cee:	2b9000ef          	jal	17a6 <memcpy>
     cf2:	03400613          	li	a2,52
     cf6:	1b4c                	add	a1,sp,436
     cf8:	0088                	add	a0,sp,64
     cfa:	2ad000ef          	jal	17a6 <memcpy>
     cfe:	03400613          	li	a2,52
     d02:	13ac                	add	a1,sp,488
     d04:	850a                	mv	a0,sp
     d06:	2a1000ef          	jal	17a6 <memcpy>
     d0a:	870a                	mv	a4,sp
     d0c:	0094                	add	a3,sp,64
     d0e:	0110                	add	a2,sp,128
     d10:	018c                	add	a1,sp,192
     d12:	0208                	add	a0,sp,256
     d14:	3c01                	jal	724 <ecc_verifying_flow>
     d16:	842a                	mv	s0,a0
     d18:	e505                	bnez	a0,d40 <ecc_verify_test+0x176>
     d1a:	50010537          	lui	a0,0x50010
     d1e:	41c50513          	add	a0,a0,1052 # 5001041c <trap_msg+0x3a8>
     d22:	2d89                	jal	1374 <puts>
     d24:	8522                	mv	a0,s0
     d26:	26c12083          	lw	ra,620(sp)
     d2a:	26812403          	lw	s0,616(sp)
     d2e:	26412483          	lw	s1,612(sp)
     d32:	26012903          	lw	s2,608(sp)
     d36:	25c12983          	lw	s3,604(sp)
     d3a:	27010113          	add	sp,sp,624
     d3e:	8082                	ret
     d40:	50010537          	lui	a0,0x50010
     d44:	44050513          	add	a0,a0,1088 # 50010440 <trap_msg+0x3cc>
     d48:	bfe9                	j	d22 <ecc_verify_test+0x158>

00000d4a <hmac_flow>:
     d4a:	1101                	add	sp,sp,-32
     d4c:	cc22                	sw	s0,24(sp)
     d4e:	ca26                	sw	s1,20(sp)
     d50:	c84a                	sw	s2,16(sp)
     d52:	c64e                	sw	s3,12(sp)
     d54:	ce06                	sw	ra,28(sp)
     d56:	c452                	sw	s4,8(sp)
     d58:	10010737          	lui	a4,0x10010
     d5c:	892a                	mv	s2,a0
     d5e:	84ae                	mv	s1,a1
     d60:	89b2                	mv	s3,a2
     d62:	8436                	mv	s0,a3
     d64:	0006ca03          	lbu	s4,0(a3)
     d68:	0761                	add	a4,a4,24 # 10010018 <_bss_lma_end+0x1000e06c>
     d6a:	431c                	lw	a5,0(a4)
     d6c:	8b85                	and	a5,a5,1
     d6e:	dff5                	beqz	a5,d6a <hmac_flow+0x20>
     d70:	00094783          	lbu	a5,0(s2)
     d74:	cff9                	beqz	a5,e52 <hmac_flow+0x108>
     d76:	00194783          	lbu	a5,1(s2)
     d7a:	0786                	sll	a5,a5,0x1
     d7c:	03e7f793          	and	a5,a5,62
     d80:	0017e793          	or	a5,a5,1
     d84:	0220000f          	fence	r,r
     d88:	0220000f          	fence	r,r
     d8c:	10010737          	lui	a4,0x10010
     d90:	60f72023          	sw	a5,1536(a4) # 10010600 <_bss_lma_end+0x1000e654>
     d94:	60470713          	add	a4,a4,1540
     d98:	431c                	lw	a5,0(a4)
     d9a:	8b89                	and	a5,a5,2
     d9c:	dff5                	beqz	a5,d98 <hmac_flow+0x4e>
     d9e:	0004c783          	lbu	a5,0(s1)
     da2:	cff1                	beqz	a5,e7e <hmac_flow+0x134>
     da4:	0014c783          	lbu	a5,1(s1)
     da8:	0786                	sll	a5,a5,0x1
     daa:	03e7f793          	and	a5,a5,62
     dae:	0017e793          	or	a5,a5,1
     db2:	0220000f          	fence	r,r
     db6:	0220000f          	fence	r,r
     dba:	10010737          	lui	a4,0x10010
     dbe:	60f72423          	sw	a5,1544(a4) # 10010608 <_bss_lma_end+0x1000e65c>
     dc2:	60c70713          	add	a4,a4,1548
     dc6:	431c                	lw	a5,0(a4)
     dc8:	8b89                	and	a5,a5,2
     dca:	dff5                	beqz	a5,dc6 <hmac_flow+0x7c>
     dcc:	0049a703          	lw	a4,4(s3)
     dd0:	100107b7          	lui	a5,0x10010
     dd4:	12e7a823          	sw	a4,304(a5) # 10010130 <_bss_lma_end+0x1000e184>
     dd8:	0089a703          	lw	a4,8(s3)
     ddc:	13478793          	add	a5,a5,308
     de0:	c398                	sw	a4,0(a5)
     de2:	00c9a703          	lw	a4,12(s3)
     de6:	c3d8                	sw	a4,4(a5)
     de8:	0109a703          	lw	a4,16(s3)
     dec:	c798                	sw	a4,8(a5)
     dee:	0149a703          	lw	a4,20(s3)
     df2:	c7d8                	sw	a4,12(a5)
     df4:	020a0163          	beqz	s4,e16 <hmac_flow+0xcc>
     df8:	00144783          	lbu	a5,1(s0)
     dfc:	0786                	sll	a5,a5,0x1
     dfe:	0ff7f793          	zext.b	a5,a5
     e02:	7c17e793          	or	a5,a5,1985
     e06:	0220000f          	fence	r,r
     e0a:	0220000f          	fence	r,r
     e0e:	10010737          	lui	a4,0x10010
     e12:	60f72823          	sw	a5,1552(a4) # 10010610 <_bss_lma_end+0x1000e664>
     e16:	0220000f          	fence	r,r
     e1a:	0220000f          	fence	r,r
     e1e:	100107b7          	lui	a5,0x10010
     e22:	4705                	li	a4,1
     e24:	cb98                	sw	a4,16(a5)
     e26:	060a0c63          	beqz	s4,e9e <hmac_flow+0x154>
     e2a:	50010537          	lui	a0,0x50010
     e2e:	48850513          	add	a0,a0,1160 # 50010488 <__func__.0+0x28>
     e32:	2389                	jal	1374 <puts>
     e34:	10010737          	lui	a4,0x10010
     e38:	61470713          	add	a4,a4,1556 # 10010614 <_bss_lma_end+0x1000e668>
     e3c:	431c                	lw	a5,0(a4)
     e3e:	8b89                	and	a5,a5,2
     e40:	dff5                	beqz	a5,e3c <hmac_flow+0xf2>
     e42:	40f2                	lw	ra,28(sp)
     e44:	4462                	lw	s0,24(sp)
     e46:	44d2                	lw	s1,20(sp)
     e48:	4942                	lw	s2,16(sp)
     e4a:	49b2                	lw	s3,12(sp)
     e4c:	4a22                	lw	s4,8(sp)
     e4e:	6105                	add	sp,sp,32
     e50:	8082                	ret
     e52:	50010537          	lui	a0,0x50010
     e56:	47050513          	add	a0,a0,1136 # 50010470 <__func__.0+0x10>
     e5a:	2b29                	jal	1374 <puts>
     e5c:	100107b7          	lui	a5,0x10010
     e60:	10010737          	lui	a4,0x10010
     e64:	04078793          	add	a5,a5,64 # 10010040 <_bss_lma_end+0x1000e094>
     e68:	07070713          	add	a4,a4,112 # 10010070 <_bss_lma_end+0x1000e0c4>
     e6c:	86be                	mv	a3,a5
     e6e:	00492603          	lw	a2,4(s2)
     e72:	0791                	add	a5,a5,4
     e74:	c290                	sw	a2,0(a3)
     e76:	0911                	add	s2,s2,4
     e78:	fee79ae3          	bne	a5,a4,e6c <hmac_flow+0x122>
     e7c:	b70d                	j	d9e <hmac_flow+0x54>
     e7e:	100107b7          	lui	a5,0x10010
     e82:	10010737          	lui	a4,0x10010
     e86:	08078793          	add	a5,a5,128 # 10010080 <_bss_lma_end+0x1000e0d4>
     e8a:	10070713          	add	a4,a4,256 # 10010100 <_bss_lma_end+0x1000e154>
     e8e:	86be                	mv	a3,a5
     e90:	40d0                	lw	a2,4(s1)
     e92:	0791                	add	a5,a5,4
     e94:	c290                	sw	a2,0(a3)
     e96:	0491                	add	s1,s1,4
     e98:	fee79be3          	bne	a5,a4,e8e <hmac_flow+0x144>
     e9c:	bf05                	j	dcc <hmac_flow+0x82>
     e9e:	50010537          	lui	a0,0x50010
     ea2:	4a850513          	add	a0,a0,1192 # 500104a8 <__func__.0+0x48>
     ea6:	21f9                	jal	1374 <puts>
     ea8:	100107b7          	lui	a5,0x10010
     eac:	4581                	li	a1,0
     eae:	10078793          	add	a5,a5,256 # 10010100 <_bss_lma_end+0x1000e154>
     eb2:	46b1                	li	a3,12
     eb4:	00259713          	sll	a4,a1,0x2
     eb8:	973e                	add	a4,a4,a5
     eba:	00072903          	lw	s2,0(a4)
     ebe:	4044                	lw	s1,4(s0)
     ec0:	02990663          	beq	s2,s1,eec <hmac_flow+0x1a2>
     ec4:	50010537          	lui	a0,0x50010
     ec8:	4c050513          	add	a0,a0,1216 # 500104c0 <__func__.0+0x60>
     ecc:	216d                	jal	1376 <printf>
     ece:	50010537          	lui	a0,0x50010
     ed2:	85ca                	mv	a1,s2
     ed4:	16c50513          	add	a0,a0,364 # 5001016c <trap_msg+0xf8>
     ed8:	2979                	jal	1376 <printf>
     eda:	50010537          	lui	a0,0x50010
     ede:	85a6                	mv	a1,s1
     ee0:	18450513          	add	a0,a0,388 # 50010184 <trap_msg+0x110>
     ee4:	2949                	jal	1376 <printf>
     ee6:	4505                	li	a0,1
     ee8:	2159                	jal	136e <putchar>
     eea:	a001                	j	eea <hmac_flow+0x1a0>
     eec:	0585                	add	a1,a1,1 # 50010001 <_data_vma_start+0x1>
     eee:	0411                	add	s0,s0,4
     ef0:	fcd592e3          	bne	a1,a3,eb4 <hmac_flow+0x16a>
     ef4:	b7b9                	j	e42 <hmac_flow+0xf8>

00000ef6 <mailbox_send_data>:
     ef6:	7179                	add	sp,sp,-48
     ef8:	d04a                	sw	s2,32(sp)
     efa:	892a                	mv	s2,a0
     efc:	10000537          	lui	a0,0x10000
     f00:	d606                	sw	ra,44(sp)
     f02:	d226                	sw	s1,36(sp)
     f04:	d422                	sw	s0,40(sp)
     f06:	84ae                	mv	s1,a1
     f08:	ce4e                	sw	s3,28(sp)
     f0a:	cc52                	sw	s4,24(sp)
     f0c:	ca56                	sw	s5,20(sp)
     f0e:	2159                	jal	1394 <soc_ifc_set_flow_status_field>
     f10:	50010537          	lui	a0,0x50010
     f14:	4ec50513          	add	a0,a0,1260 # 500104ec <__func__.0+0x8c>
     f18:	29b1                	jal	1374 <puts>
     f1a:	30020737          	lui	a4,0x30020
     f1e:	0761                	add	a4,a4,24 # 30020018 <_bss_lma_end+0x3001e06c>
     f20:	431c                	lw	a5,0(a4)
     f22:	8b85                	and	a5,a5,1
     f24:	dff5                	beqz	a5,f20 <mailbox_send_data+0x2a>
     f26:	294d                	jal	13d8 <soc_ifc_read_mbox_cmd>
     f28:	c42a                	sw	a0,8(sp)
     f2a:	c62e                	sw	a1,12(sp)
     f2c:	842a                	mv	s0,a0
     f2e:	85aa                	mv	a1,a0
     f30:	50010537          	lui	a0,0x50010
     f34:	4f850513          	add	a0,a0,1272 # 500104f8 <__func__.0+0x98>
     f38:	300209b7          	lui	s3,0x30020
     f3c:	292d                	jal	1376 <printf>
     f3e:	09d1                	add	s3,s3,20 # 30020014 <_bss_lma_end+0x3001e068>
     f40:	50010a37          	lui	s4,0x50010
     f44:	4a91                	li	s5,4
     f46:	e049                	bnez	s0,fc8 <mailbox_send_data+0xd2>
     f48:	0220000f          	fence	r,r
     f4c:	0220000f          	fence	r,r
     f50:	1a2b47b7          	lui	a5,0x1a2b4
     f54:	30020737          	lui	a4,0x30020
     f58:	c4d78793          	add	a5,a5,-947 # 1a2b3c4d <_bss_lma_end+0x1a2b1ca1>
     f5c:	c71c                	sw	a5,8(a4)
     f5e:	0220000f          	fence	r,r
     f62:	0220000f          	fence	r,r
     f66:	50010537          	lui	a0,0x50010
     f6a:	c744                	sw	s1,12(a4)
     f6c:	85a6                	mv	a1,s1
     f6e:	53450513          	add	a0,a0,1332 # 50010534 <__func__.0+0xd4>
     f72:	2111                	jal	1376 <printf>
     f74:	300206b7          	lui	a3,0x30020
     f78:	4781                	li	a5,0
     f7a:	4811                	li	a6,4
     f7c:	06c1                	add	a3,a3,16 # 30020010 <_bss_lma_end+0x3001e064>
     f7e:	0497ef63          	bltu	a5,s1,fdc <mailbox_send_data+0xe6>
     f82:	50010537          	lui	a0,0x50010
     f86:	55c50513          	add	a0,a0,1372 # 5001055c <__func__.0+0xfc>
     f8a:	26ed                	jal	1374 <puts>
     f8c:	0220000f          	fence	r,r
     f90:	0220000f          	fence	r,r
     f94:	300207b7          	lui	a5,0x30020
     f98:	4705                	li	a4,1
     f9a:	cfd8                	sw	a4,28(a5)
     f9c:	4fcc                	lw	a1,28(a5)
     f9e:	8199                	srl	a1,a1,0x6
     fa0:	899d                	and	a1,a1,7
     fa2:	4611                	li	a2,4
     fa4:	06c58863          	beq	a1,a2,1014 <mailbox_send_data+0x11e>
     fa8:	50010537          	lui	a0,0x50010
     fac:	57850513          	add	a0,a0,1400 # 50010578 <__func__.0+0x118>
     fb0:	26d9                	jal	1376 <printf>
     fb2:	547d                	li	s0,-1
     fb4:	8522                	mv	a0,s0
     fb6:	50b2                	lw	ra,44(sp)
     fb8:	5422                	lw	s0,40(sp)
     fba:	5492                	lw	s1,36(sp)
     fbc:	5902                	lw	s2,32(sp)
     fbe:	49f2                	lw	s3,28(sp)
     fc0:	4a62                	lw	s4,24(sp)
     fc2:	4ad2                	lw	s5,20(sp)
     fc4:	6145                	add	sp,sp,48
     fc6:	8082                	ret
     fc8:	0009a583          	lw	a1,0(s3)
     fcc:	520a0513          	add	a0,s4,1312 # 50010520 <__func__.0+0xc0>
     fd0:	265d                	jal	1376 <printf>
     fd2:	01547363          	bgeu	s0,s5,fd8 <mailbox_send_data+0xe2>
     fd6:	4411                	li	s0,4
     fd8:	1471                	add	s0,s0,-4
     fda:	b7b5                	j	f46 <mailbox_send_data+0x50>
     fdc:	40f485b3          	sub	a1,s1,a5
     fe0:	00b87363          	bgeu	a6,a1,fe6 <mailbox_send_data+0xf0>
     fe4:	4591                	li	a1,4
     fe6:	4701                	li	a4,0
     fe8:	4601                	li	a2,0
     fea:	00f90333          	add	t1,s2,a5
     fee:	00e30533          	add	a0,t1,a4
     ff2:	00371893          	sll	a7,a4,0x3
     ff6:	00054503          	lbu	a0,0(a0)
     ffa:	01151533          	sll	a0,a0,a7
     ffe:	0705                	add	a4,a4,1 # 30020001 <_bss_lma_end+0x3001e055>
    1000:	8e49                	or	a2,a2,a0
    1002:	fee596e3          	bne	a1,a4,fee <mailbox_send_data+0xf8>
    1006:	0220000f          	fence	r,r
    100a:	0220000f          	fence	r,r
    100e:	c290                	sw	a2,0(a3)
    1010:	0791                	add	a5,a5,4 # 30020004 <_bss_lma_end+0x3001e058>
    1012:	b7b5                	j	f7e <mailbox_send_data+0x88>
    1014:	50010537          	lui	a0,0x50010
    1018:	5cc50513          	add	a0,a0,1484 # 500105cc <__func__.0+0x16c>
    101c:	2ea1                	jal	1374 <puts>
    101e:	bf59                	j	fb4 <mailbox_send_data+0xbe>

00001020 <whisperPutc>:
    1020:	1141                	add	sp,sp,-16
    1022:	c422                	sw	s0,8(sp)
    1024:	c606                	sw	ra,12(sp)
    1026:	47a9                	li	a5,10
    1028:	842a                	mv	s0,a0
    102a:	00f51563          	bne	a0,a5,1034 <whisperPutc+0x14>
    102e:	4535                	li	a0,13
    1030:	2965                	jal	14e8 <uart_tx>
    1032:	8522                	mv	a0,s0
    1034:	2955                	jal	14e8 <uart_tx>
    1036:	8522                	mv	a0,s0
    1038:	40b2                	lw	ra,12(sp)
    103a:	4422                	lw	s0,8(sp)
    103c:	0141                	add	sp,sp,16
    103e:	8082                	ret

00001040 <whisperPuts>:
    1040:	1141                	add	sp,sp,-16
    1042:	c422                	sw	s0,8(sp)
    1044:	c606                	sw	ra,12(sp)
    1046:	842a                	mv	s0,a0
    1048:	00044503          	lbu	a0,0(s0)
    104c:	e901                	bnez	a0,105c <whisperPuts+0x1c>
    104e:	4529                	li	a0,10
    1050:	3fc1                	jal	1020 <whisperPutc>
    1052:	40b2                	lw	ra,12(sp)
    1054:	4422                	lw	s0,8(sp)
    1056:	4505                	li	a0,1
    1058:	0141                	add	sp,sp,16
    105a:	8082                	ret
    105c:	0405                	add	s0,s0,1
    105e:	37c9                	jal	1020 <whisperPutc>
    1060:	b7e5                	j	1048 <whisperPuts+0x8>

00001062 <whisperPrintUnsigned>:
    1062:	7139                	add	sp,sp,-64
    1064:	da26                	sw	s1,52(sp)
    1066:	d64e                	sw	s3,44(sp)
    1068:	de06                	sw	ra,60(sp)
    106a:	dc22                	sw	s0,56(sp)
    106c:	d84a                	sw	s2,48(sp)
    106e:	84ae                	mv	s1,a1
    1070:	89b2                	mv	s3,a2
    1072:	ed15                	bnez	a0,10ae <whisperPrintUnsigned+0x4c>
    1074:	03000793          	li	a5,48
    1078:	00f10623          	sb	a5,12(sp)
    107c:	4405                	li	s0,1
    107e:	8922                	mv	s2,s0
    1080:	04994963          	blt	s2,s1,10d2 <whisperPrintUnsigned+0x70>
    1084:	02040793          	add	a5,s0,32
    1088:	002784b3          	add	s1,a5,sp
    108c:	14ad                	add	s1,s1,-21
    108e:	40848933          	sub	s2,s1,s0
    1092:	0004c503          	lbu	a0,0(s1)
    1096:	14fd                	add	s1,s1,-1
    1098:	3761                	jal	1020 <whisperPutc>
    109a:	fe991ce3          	bne	s2,s1,1092 <whisperPrintUnsigned+0x30>
    109e:	8522                	mv	a0,s0
    10a0:	50f2                	lw	ra,60(sp)
    10a2:	5462                	lw	s0,56(sp)
    10a4:	54d2                	lw	s1,52(sp)
    10a6:	5942                	lw	s2,48(sp)
    10a8:	59b2                	lw	s3,44(sp)
    10aa:	6121                	add	sp,sp,64
    10ac:	8082                	ret
    10ae:	007c                	add	a5,sp,12
    10b0:	4401                	li	s0,0
    10b2:	46a9                	li	a3,10
    10b4:	4625                	li	a2,9
    10b6:	02d57733          	remu	a4,a0,a3
    10ba:	85aa                	mv	a1,a0
    10bc:	0405                	add	s0,s0,1
    10be:	0785                	add	a5,a5,1
    10c0:	03070713          	add	a4,a4,48
    10c4:	fee78fa3          	sb	a4,-1(a5)
    10c8:	02d55533          	divu	a0,a0,a3
    10cc:	feb665e3          	bltu	a2,a1,10b6 <whisperPrintUnsigned+0x54>
    10d0:	b77d                	j	107e <whisperPrintUnsigned+0x1c>
    10d2:	854e                	mv	a0,s3
    10d4:	37b1                	jal	1020 <whisperPutc>
    10d6:	0905                	add	s2,s2,1
    10d8:	b765                	j	1080 <whisperPrintUnsigned+0x1e>

000010da <whisperPrintDecimal>:
    10da:	7139                	add	sp,sp,-64
    10dc:	da26                	sw	s1,52(sp)
    10de:	d452                	sw	s4,40(sp)
    10e0:	de06                	sw	ra,60(sp)
    10e2:	dc22                	sw	s0,56(sp)
    10e4:	d84a                	sw	s2,48(sp)
    10e6:	d64e                	sw	s3,44(sp)
    10e8:	84ae                	mv	s1,a1
    10ea:	8a32                	mv	s4,a2
    10ec:	02055b63          	bgez	a0,1122 <whisperPrintDecimal+0x48>
    10f0:	40a00533          	neg	a0,a0
    10f4:	fff58493          	add	s1,a1,-1
    10f8:	4905                	li	s2,1
    10fa:	007c                	add	a5,sp,12
    10fc:	4401                	li	s0,0
    10fe:	46a9                	li	a3,10
    1100:	02d56733          	rem	a4,a0,a3
    1104:	0405                	add	s0,s0,1
    1106:	0785                	add	a5,a5,1
    1108:	02d54533          	div	a0,a0,a3
    110c:	03070713          	add	a4,a4,48
    1110:	fee78fa3          	sb	a4,-1(a5)
    1114:	f575                	bnez	a0,1100 <whisperPrintDecimal+0x26>
    1116:	00090d63          	beqz	s2,1130 <whisperPrintDecimal+0x56>
    111a:	02d00513          	li	a0,45
    111e:	26e9                	jal	14e8 <uart_tx>
    1120:	a801                	j	1130 <whisperPrintDecimal+0x56>
    1122:	e129                	bnez	a0,1164 <whisperPrintDecimal+0x8a>
    1124:	03000793          	li	a5,48
    1128:	00f10623          	sb	a5,12(sp)
    112c:	4901                	li	s2,0
    112e:	4405                	li	s0,1
    1130:	89a2                	mv	s3,s0
    1132:	0299cb63          	blt	s3,s1,1168 <whisperPrintDecimal+0x8e>
    1136:	02040793          	add	a5,s0,32
    113a:	002784b3          	add	s1,a5,sp
    113e:	14ad                	add	s1,s1,-21
    1140:	408489b3          	sub	s3,s1,s0
    1144:	0004c503          	lbu	a0,0(s1)
    1148:	14fd                	add	s1,s1,-1
    114a:	3dd9                	jal	1020 <whisperPutc>
    114c:	fe999ce3          	bne	s3,s1,1144 <whisperPrintDecimal+0x6a>
    1150:	01240533          	add	a0,s0,s2
    1154:	50f2                	lw	ra,60(sp)
    1156:	5462                	lw	s0,56(sp)
    1158:	54d2                	lw	s1,52(sp)
    115a:	5942                	lw	s2,48(sp)
    115c:	59b2                	lw	s3,44(sp)
    115e:	5a22                	lw	s4,40(sp)
    1160:	6121                	add	sp,sp,64
    1162:	8082                	ret
    1164:	4901                	li	s2,0
    1166:	bf51                	j	10fa <whisperPrintDecimal+0x20>
    1168:	8552                	mv	a0,s4
    116a:	3d5d                	jal	1020 <whisperPutc>
    116c:	0985                	add	s3,s3,1
    116e:	b7d1                	j	1132 <whisperPrintDecimal+0x58>

00001170 <whisperPrintInt>:
    1170:	47a9                	li	a5,10
    1172:	00f69563          	bne	a3,a5,117c <whisperPrintInt+0xc>
    1176:	0ff67613          	zext.b	a2,a2
    117a:	b785                	j	10da <whisperPrintDecimal>
    117c:	1101                	add	sp,sp,-32
    117e:	c84a                	sw	s2,16(sp)
    1180:	ce06                	sw	ra,28(sp)
    1182:	cc22                	sw	s0,24(sp)
    1184:	ca26                	sw	s1,20(sp)
    1186:	c64e                	sw	s3,12(sp)
    1188:	c452                	sw	s4,8(sp)
    118a:	47a1                	li	a5,8
    118c:	892a                	mv	s2,a0
    118e:	02f69f63          	bne	a3,a5,11cc <whisperPrintInt+0x5c>
    1192:	44f9                	li	s1,30
    1194:	4781                	li	a5,0
    1196:	4401                	li	s0,0
    1198:	0fd00993          	li	s3,253
    119c:	00995533          	srl	a0,s2,s1
    11a0:	891d                	and	a0,a0,7
    11a2:	e111                	bnez	a0,11a6 <whisperPrintInt+0x36>
    11a4:	c791                	beqz	a5,11b0 <whisperPrintInt+0x40>
    11a6:	03050513          	add	a0,a0,48
    11aa:	3d9d                	jal	1020 <whisperPutc>
    11ac:	0405                	add	s0,s0,1
    11ae:	4785                	li	a5,1
    11b0:	14f5                	add	s1,s1,-3
    11b2:	0ff4f493          	zext.b	s1,s1
    11b6:	ff3493e3          	bne	s1,s3,119c <whisperPrintInt+0x2c>
    11ba:	8522                	mv	a0,s0
    11bc:	40f2                	lw	ra,28(sp)
    11be:	4462                	lw	s0,24(sp)
    11c0:	44d2                	lw	s1,20(sp)
    11c2:	4942                	lw	s2,16(sp)
    11c4:	49b2                	lw	s3,12(sp)
    11c6:	4a22                	lw	s4,8(sp)
    11c8:	6105                	add	sp,sp,32
    11ca:	8082                	ret
    11cc:	47c1                	li	a5,16
    11ce:	547d                	li	s0,-1
    11d0:	fef695e3          	bne	a3,a5,11ba <whisperPrintInt+0x4a>
    11d4:	44f1                	li	s1,28
    11d6:	4701                	li	a4,0
    11d8:	4401                	li	s0,0
    11da:	4a25                	li	s4,9
    11dc:	0fc00993          	li	s3,252
    11e0:	009957b3          	srl	a5,s2,s1
    11e4:	8bbd                	and	a5,a5,15
    11e6:	e791                	bnez	a5,11f2 <whisperPrintInt+0x82>
    11e8:	e311                	bnez	a4,11ec <whisperPrintInt+0x7c>
    11ea:	e899                	bnez	s1,1200 <whisperPrintInt+0x90>
    11ec:	03078513          	add	a0,a5,48
    11f0:	a029                	j	11fa <whisperPrintInt+0x8a>
    11f2:	03778513          	add	a0,a5,55
    11f6:	fefa7be3          	bgeu	s4,a5,11ec <whisperPrintInt+0x7c>
    11fa:	351d                	jal	1020 <whisperPutc>
    11fc:	0405                	add	s0,s0,1
    11fe:	4705                	li	a4,1
    1200:	14f1                	add	s1,s1,-4
    1202:	0ff4f493          	zext.b	s1,s1
    1206:	fd349de3          	bne	s1,s3,11e0 <whisperPrintInt+0x70>
    120a:	bf45                	j	11ba <whisperPrintInt+0x4a>

0000120c <whisperPrintfImpl>:
    120c:	7179                	add	sp,sp,-48
    120e:	d422                	sw	s0,40(sp)
    1210:	d226                	sw	s1,36(sp)
    1212:	d04a                	sw	s2,32(sp)
    1214:	ce4e                	sw	s3,28(sp)
    1216:	cc52                	sw	s4,24(sp)
    1218:	ca56                	sw	s5,20(sp)
    121a:	c85a                	sw	s6,16(sp)
    121c:	c65e                	sw	s7,12(sp)
    121e:	c462                	sw	s8,8(sp)
    1220:	d606                	sw	ra,44(sp)
    1222:	c266                	sw	s9,4(sp)
    1224:	c06a                	sw	s10,0(sp)
    1226:	842a                	mv	s0,a0
    1228:	84ae                	mv	s1,a1
    122a:	4901                	li	s2,0
    122c:	02500993          	li	s3,37
    1230:	03000a93          	li	s5,48
    1234:	02d00b13          	li	s6,45
    1238:	02a00b93          	li	s7,42
    123c:	06f00a13          	li	s4,111
    1240:	07500c13          	li	s8,117
    1244:	00044503          	lbu	a0,0(s0)
    1248:	e105                	bnez	a0,1268 <whisperPrintfImpl+0x5c>
    124a:	50b2                	lw	ra,44(sp)
    124c:	5422                	lw	s0,40(sp)
    124e:	854a                	mv	a0,s2
    1250:	5492                	lw	s1,36(sp)
    1252:	5902                	lw	s2,32(sp)
    1254:	49f2                	lw	s3,28(sp)
    1256:	4a62                	lw	s4,24(sp)
    1258:	4ad2                	lw	s5,20(sp)
    125a:	4b42                	lw	s6,16(sp)
    125c:	4bb2                	lw	s7,12(sp)
    125e:	4c22                	lw	s8,8(sp)
    1260:	4c92                	lw	s9,4(sp)
    1262:	4d02                	lw	s10,0(sp)
    1264:	6145                	add	sp,sp,48
    1266:	8082                	ret
    1268:	01350663          	beq	a0,s3,1274 <whisperPrintfImpl+0x68>
    126c:	3b55                	jal	1020 <whisperPutc>
    126e:	0905                	add	s2,s2,1
    1270:	0405                	add	s0,s0,1
    1272:	bfc9                	j	1244 <whisperPrintfImpl+0x38>
    1274:	00144703          	lbu	a4,1(s0)
    1278:	db69                	beqz	a4,124a <whisperPrintfImpl+0x3e>
    127a:	0405                	add	s0,s0,1
    127c:	02000793          	li	a5,32
    1280:	01371563          	bne	a4,s3,128a <whisperPrintfImpl+0x7e>
    1284:	854e                	mv	a0,s3
    1286:	248d                	jal	14e8 <uart_tx>
    1288:	b7e5                	j	1270 <whisperPrintfImpl+0x64>
    128a:	863e                	mv	a2,a5
    128c:	00044783          	lbu	a5,0(s0)
    1290:	8722                	mv	a4,s0
    1292:	0405                	add	s0,s0,1
    1294:	ff578be3          	beq	a5,s5,128a <whisperPrintfImpl+0x7e>
    1298:	01678363          	beq	a5,s6,129e <whisperPrintfImpl+0x92>
    129c:	843a                	mv	s0,a4
    129e:	00044783          	lbu	a5,0(s0)
    12a2:	03779c63          	bne	a5,s7,12da <whisperPrintfImpl+0xce>
    12a6:	0405                	add	s0,s0,1
    12a8:	4581                	li	a1,0
    12aa:	00044783          	lbu	a5,0(s0)
    12ae:	0b478263          	beq	a5,s4,1352 <whisperPrintfImpl+0x146>
    12b2:	04fa6d63          	bltu	s4,a5,130c <whisperPrintfImpl+0x100>
    12b6:	06300713          	li	a4,99
    12ba:	0ae78063          	beq	a5,a4,135a <whisperPrintfImpl+0x14e>
    12be:	06400713          	li	a4,100
    12c2:	06e78c63          	beq	a5,a4,133a <whisperPrintfImpl+0x12e>
    12c6:	05800713          	li	a4,88
    12ca:	fae793e3          	bne	a5,a4,1270 <whisperPrintfImpl+0x64>
    12ce:	00448c93          	add	s9,s1,4
    12d2:	46c1                	li	a3,16
    12d4:	4088                	lw	a0,0(s1)
    12d6:	3d69                	jal	1170 <whisperPrintInt>
    12d8:	a0ad                	j	1342 <whisperPrintfImpl+0x136>
    12da:	fd078793          	add	a5,a5,-48
    12de:	0ff7f793          	zext.b	a5,a5
    12e2:	4725                	li	a4,9
    12e4:	4581                	li	a1,0
    12e6:	fcf762e3          	bltu	a4,a5,12aa <whisperPrintfImpl+0x9e>
    12ea:	4829                	li	a6,10
    12ec:	a029                	j	12f6 <whisperPrintfImpl+0xea>
    12ee:	030585b3          	mul	a1,a1,a6
    12f2:	842a                	mv	s0,a0
    12f4:	95be                	add	a1,a1,a5
    12f6:	00044783          	lbu	a5,0(s0)
    12fa:	fd078793          	add	a5,a5,-48
    12fe:	0ff7f693          	zext.b	a3,a5
    1302:	00140513          	add	a0,s0,1
    1306:	fed774e3          	bgeu	a4,a3,12ee <whisperPrintfImpl+0xe2>
    130a:	b745                	j	12aa <whisperPrintfImpl+0x9e>
    130c:	03878e63          	beq	a5,s8,1348 <whisperPrintfImpl+0x13c>
    1310:	07800713          	li	a4,120
    1314:	fae78de3          	beq	a5,a4,12ce <whisperPrintfImpl+0xc2>
    1318:	07300713          	li	a4,115
    131c:	f4e79ae3          	bne	a5,a4,1270 <whisperPrintfImpl+0x64>
    1320:	00448d13          	add	s10,s1,4
    1324:	8cca                	mv	s9,s2
    1326:	4084                	lw	s1,0(s1)
    1328:	412c87b3          	sub	a5,s9,s2
    132c:	97a6                	add	a5,a5,s1
    132e:	0007c503          	lbu	a0,0(a5)
    1332:	e91d                	bnez	a0,1368 <whisperPrintfImpl+0x15c>
    1334:	84ea                	mv	s1,s10
    1336:	8966                	mv	s2,s9
    1338:	bf25                	j	1270 <whisperPrintfImpl+0x64>
    133a:	4088                	lw	a0,0(s1)
    133c:	00448c93          	add	s9,s1,4
    1340:	3b69                	jal	10da <whisperPrintDecimal>
    1342:	992a                	add	s2,s2,a0
    1344:	84e6                	mv	s1,s9
    1346:	b72d                	j	1270 <whisperPrintfImpl+0x64>
    1348:	4088                	lw	a0,0(s1)
    134a:	00448c93          	add	s9,s1,4
    134e:	3b11                	jal	1062 <whisperPrintUnsigned>
    1350:	bfcd                	j	1342 <whisperPrintfImpl+0x136>
    1352:	00448c93          	add	s9,s1,4
    1356:	46a1                	li	a3,8
    1358:	bfb5                	j	12d4 <whisperPrintfImpl+0xc8>
    135a:	0004c503          	lbu	a0,0(s1)
    135e:	00448c93          	add	s9,s1,4
    1362:	397d                	jal	1020 <whisperPutc>
    1364:	0905                	add	s2,s2,1
    1366:	bff9                	j	1344 <whisperPrintfImpl+0x138>
    1368:	3965                	jal	1020 <whisperPutc>
    136a:	0c85                	add	s9,s9,1
    136c:	bf75                	j	1328 <whisperPrintfImpl+0x11c>

0000136e <putchar>:
    136e:	0ff57513          	zext.b	a0,a0
    1372:	b17d                	j	1020 <whisperPutc>

00001374 <puts>:
    1374:	b1f1                	j	1040 <whisperPuts>

00001376 <printf>:
    1376:	7139                	add	sp,sp,-64
    1378:	d22e                	sw	a1,36(sp)
    137a:	104c                	add	a1,sp,36
    137c:	ce06                	sw	ra,28(sp)
    137e:	d432                	sw	a2,40(sp)
    1380:	d636                	sw	a3,44(sp)
    1382:	d83a                	sw	a4,48(sp)
    1384:	da3e                	sw	a5,52(sp)
    1386:	dc42                	sw	a6,56(sp)
    1388:	de46                	sw	a7,60(sp)
    138a:	c62e                	sw	a1,12(sp)
    138c:	3541                	jal	120c <whisperPrintfImpl>
    138e:	40f2                	lw	ra,28(sp)
    1390:	6121                	add	sp,sp,64
    1392:	8082                	ret

00001394 <soc_ifc_set_flow_status_field>:
    1394:	1141                	add	sp,sp,-16
    1396:	c422                	sw	s0,8(sp)
    1398:	85aa                	mv	a1,a0
    139a:	842a                	mv	s0,a0
    139c:	50010537          	lui	a0,0x50010
    13a0:	61850513          	add	a0,a0,1560 # 50010618 <__func__.0+0x1b8>
    13a4:	c606                	sw	ra,12(sp)
    13a6:	3fc1                	jal	1376 <printf>
    13a8:	300307b7          	lui	a5,0x30030
    13ac:	5fdc                	lw	a5,60(a5)
    13ae:	00841693          	sll	a3,s0,0x8
    13b2:	00f46733          	or	a4,s0,a5
    13b6:	c691                	beqz	a3,13c2 <soc_ifc_set_flow_status_field+0x2e>
    13b8:	ff000737          	lui	a4,0xff000
    13bc:	8ff9                	and	a5,a5,a4
    13be:	0087e733          	or	a4,a5,s0
    13c2:	0220000f          	fence	r,r
    13c6:	0220000f          	fence	r,r
    13ca:	300307b7          	lui	a5,0x30030
    13ce:	40b2                	lw	ra,12(sp)
    13d0:	4422                	lw	s0,8(sp)
    13d2:	dfd8                	sw	a4,60(a5)
    13d4:	0141                	add	sp,sp,16
    13d6:	8082                	ret

000013d8 <soc_ifc_read_mbox_cmd>:
    13d8:	1141                	add	sp,sp,-16
    13da:	300207b7          	lui	a5,0x30020
    13de:	478c                	lw	a1,8(a5)
    13e0:	47c8                	lw	a0,12(a5)
    13e2:	0141                	add	sp,sp,16
    13e4:	8082                	ret

000013e6 <end_sim_if_itrng_disabled>:
    13e6:	300307b7          	lui	a5,0x30030
    13ea:	0e07a783          	lw	a5,224(a5) # 300300e0 <_bss_lma_end+0x3002e134>
    13ee:	8b85                	and	a5,a5,1
    13f0:	e391                	bnez	a5,13f4 <end_sim_if_itrng_disabled+0xe>
    13f2:	a001                	j	13f2 <end_sim_if_itrng_disabled+0xc>
    13f4:	8082                	ret

000013f6 <enable_csrng>:
    13f6:	1141                	add	sp,sp,-16
    13f8:	c606                	sw	ra,12(sp)
    13fa:	37f5                	jal	13e6 <end_sim_if_itrng_disabled>
    13fc:	0220000f          	fence	r,r
    1400:	0220000f          	fence	r,r
    1404:	009097b7          	lui	a5,0x909
    1408:	20003737          	lui	a4,0x20003
    140c:	09978793          	add	a5,a5,153 # 909099 <_bss_lma_end+0x9070ed>
    1410:	d35c                	sw	a5,36(a4)
    1412:	0220000f          	fence	r,r
    1416:	0220000f          	fence	r,r
    141a:	87ba                	mv	a5,a4
    141c:	4719                	li	a4,6
    141e:	d398                	sw	a4,32(a5)
    1420:	0220000f          	fence	r,r
    1424:	0220000f          	fence	r,r
    1428:	200027b7          	lui	a5,0x20002
    142c:	66600713          	li	a4,1638
    1430:	cbd8                	sw	a4,20(a5)
    1432:	0220000f          	fence	r,r
    1436:	0220000f          	fence	r,r
    143a:	873e                	mv	a4,a5
    143c:	6785                	lui	a5,0x1
    143e:	90178793          	add	a5,a5,-1791 # 901 <ecc_sigh_test+0x3d>
    1442:	cf1c                	sw	a5,24(a4)
    1444:	200037b7          	lui	a5,0x20003
    1448:	0d078793          	add	a5,a5,208 # 200030d0 <_bss_lma_end+0x20001124>
    144c:	00020737          	lui	a4,0x20
    1450:	4394                	lw	a3,0(a5)
    1452:	fee69fe3          	bne	a3,a4,1450 <enable_csrng+0x5a>
    1456:	40b2                	lw	ra,12(sp)
    1458:	0141                	add	sp,sp,16
    145a:	8082                	ret

0000145c <generate_random_numbers>:
    145c:	86aa                	mv	a3,a0
    145e:	557d                	li	a0,-1
    1460:	08d05363          	blez	a3,14e6 <generate_random_numbers+0x8a>
    1464:	c1c9                	beqz	a1,14e6 <generate_random_numbers+0x8a>
    1466:	0220000f          	fence	r,r
    146a:	0220000f          	fence	r,r
    146e:	6785                	lui	a5,0x1
    1470:	20002737          	lui	a4,0x20002
    1474:	078d                	add	a5,a5,3 # 1003 <mailbox_send_data+0x10d>
    1476:	cf1c                	sw	a5,24(a4)
    1478:	02070793          	add	a5,a4,32 # 20002020 <_bss_lma_end+0x20000074>
    147c:	4705                	li	a4,1
    147e:	4390                	lw	a2,0(a5)
    1480:	fee61fe3          	bne	a2,a4,147e <generate_random_numbers+0x22>
    1484:	20002637          	lui	a2,0x20002
    1488:	6515                	lui	a0,0x5
    148a:	20002837          	lui	a6,0x20002
    148e:	200028b7          	lui	a7,0x20002
    1492:	4701                	li	a4,0
    1494:	0661                	add	a2,a2,24 # 20002018 <_bss_lma_end+0x2000006c>
    1496:	90350513          	add	a0,a0,-1789 # 4903 <_bss_lma_end+0x2957>
    149a:	02080813          	add	a6,a6,32 # 20002020 <_bss_lma_end+0x20000074>
    149e:	4305                	li	t1,1
    14a0:	02488893          	add	a7,a7,36 # 20002024 <_bss_lma_end+0x20000078>
    14a4:	00377793          	and	a5,a4,3
    14a8:	eb8d                	bnez	a5,14da <generate_random_numbers+0x7e>
    14aa:	0220000f          	fence	r,r
    14ae:	0220000f          	fence	r,r
    14b2:	c208                	sw	a0,0(a2)
    14b4:	00082783          	lw	a5,0(a6)
    14b8:	fe679ee3          	bne	a5,t1,14b4 <generate_random_numbers+0x58>
    14bc:	0008a783          	lw	a5,0(a7)
    14c0:	0087de13          	srl	t3,a5,0x8
    14c4:	00f58023          	sb	a5,0(a1)
    14c8:	01c580a3          	sb	t3,1(a1)
    14cc:	0107de13          	srl	t3,a5,0x10
    14d0:	83e1                	srl	a5,a5,0x18
    14d2:	01c58123          	sb	t3,2(a1)
    14d6:	00f581a3          	sb	a5,3(a1)
    14da:	0705                	add	a4,a4,1
    14dc:	0585                	add	a1,a1,1
    14de:	fce693e3          	bne	a3,a4,14a4 <generate_random_numbers+0x48>
    14e2:	4501                	li	a0,0
    14e4:	8082                	ret
    14e6:	8082                	ret

000014e8 <uart_tx>:
    14e8:	20001737          	lui	a4,0x20001
    14ec:	0751                	add	a4,a4,20 # 20001014 <_bss_lma_end+0x1ffff068>
    14ee:	431c                	lw	a5,0(a4)
    14f0:	8b85                	and	a5,a5,1
    14f2:	fff5                	bnez	a5,14ee <uart_tx+0x6>
    14f4:	0220000f          	fence	r,r
    14f8:	0220000f          	fence	r,r
    14fc:	200017b7          	lui	a5,0x20001
    1500:	cfc8                	sw	a0,28(a5)
    1502:	8082                	ret

00001504 <enable_uart>:
    1504:	0220000f          	fence	r,r
    1508:	0220000f          	fence	r,r
    150c:	04b707b7          	lui	a5,0x4b70
    1510:	20001737          	lui	a4,0x20001
    1514:	078d                	add	a5,a5,3 # 4b70003 <_bss_lma_end+0x4b6e057>
    1516:	cb1c                	sw	a5,16(a4)
    1518:	8082                	ret

0000151a <end_sim_if_uart_disabled>:
    151a:	300307b7          	lui	a5,0x30030
    151e:	0e07a783          	lw	a5,224(a5) # 300300e0 <_bss_lma_end+0x3002e134>
    1522:	8ba1                	and	a5,a5,8
    1524:	e391                	bnez	a5,1528 <end_sim_if_uart_disabled+0xe>
    1526:	a001                	j	1526 <end_sim_if_uart_disabled+0xc>
    1528:	8082                	ret

0000152a <init_uart>:
    152a:	1141                	add	sp,sp,-16
    152c:	c606                	sw	ra,12(sp)
    152e:	37f5                	jal	151a <end_sim_if_uart_disabled>
    1530:	40b2                	lw	ra,12(sp)
    1532:	0141                	add	sp,sp,16
    1534:	bfc1                	j	1504 <enable_uart>

00001536 <main>:
    1536:	7169                	add	sp,sp,-304
    1538:	12112623          	sw	ra,300(sp)
    153c:	12812423          	sw	s0,296(sp)
    1540:	12912223          	sw	s1,292(sp)
    1544:	1a00                	add	s0,sp,304
    1546:	13212023          	sw	s2,288(sp)
    154a:	11312e23          	sw	s3,284(sp)
    154e:	11412c23          	sw	s4,280(sp)
    1552:	11512a23          	sw	s5,276(sp)
    1556:	11612823          	sw	s6,272(sp)
    155a:	11712623          	sw	s7,268(sp)
    155e:	11812423          	sw	s8,264(sp)
    1562:	500104b7          	lui	s1,0x50010
    1566:	37d1                	jal	152a <init_uart>
    1568:	3579                	jal	13f6 <enable_csrng>
    156a:	64048513          	add	a0,s1,1600 # 50010640 <__func__.0+0x1e0>
    156e:	3519                	jal	1374 <puts>
    1570:	50010537          	lui	a0,0x50010
    1574:	66850513          	add	a0,a0,1640 # 50010668 <__func__.0+0x208>
    1578:	3bf5                	jal	1374 <puts>
    157a:	64048513          	add	a0,s1,1600
    157e:	3bdd                	jal	1374 <puts>
    1580:	50010637          	lui	a2,0x50010
    1584:	500105b7          	lui	a1,0x50010
    1588:	50010537          	lui	a0,0x50010
    158c:	69060613          	add	a2,a2,1680 # 50010690 <__func__.0+0x230>
    1590:	69c58593          	add	a1,a1,1692 # 5001069c <__func__.0+0x23c>
    1594:	6a850513          	add	a0,a0,1704 # 500106a8 <__func__.0+0x248>
    1598:	30020937          	lui	s2,0x30020
    159c:	3be9                	jal	1376 <printf>
    159e:	f1040993          	add	s3,s0,-240
    15a2:	0951                	add	s2,s2,20 # 30020014 <_bss_lma_end+0x3001e068>
    15a4:	50010a37          	lui	s4,0x50010
    15a8:	3d05                	jal	13d8 <soc_ifc_read_mbox_cmd>
    15aa:	eca42c23          	sw	a0,-296(s0)
    15ae:	ecb42e23          	sw	a1,-292(s0)
    15b2:	00159793          	sll	a5,a1,0x1
    15b6:	84aa                	mv	s1,a0
    15b8:	8b2a                	mv	s6,a0
    15ba:	8aae                	mv	s5,a1
    15bc:	fe07d6e3          	bgez	a5,15a8 <main+0x72>
    15c0:	50010537          	lui	a0,0x50010
    15c4:	6c050513          	add	a0,a0,1728 # 500106c0 <__func__.0+0x260>
    15c8:	337d                	jal	1376 <printf>
    15ca:	44c107b7          	lui	a5,0x44c10
    15ce:	17cd                	add	a5,a5,-13 # 44c0fff3 <_bss_lma_end+0x44c0e047>
    15d0:	04fa9463          	bne	s5,a5,1618 <main+0xe2>
    15d4:	8b0a                	mv	s6,sp
    15d6:	1101                	add	sp,sp,-32
    15d8:	858a                	mv	a1,sp
    15da:	02000513          	li	a0,32
    15de:	3dbd                	jal	145c <generate_random_numbers>
    15e0:	8a8a                	mv	s5,sp
    15e2:	84aa                	mv	s1,a0
    15e4:	e905                	bnez	a0,1614 <main+0xde>
    15e6:	50010537          	lui	a0,0x50010
    15ea:	70050513          	add	a0,a0,1792 # 50010700 <__func__.0+0x2a0>
    15ee:	3359                	jal	1374 <puts>
    15f0:	02000b93          	li	s7,32
    15f4:	009a87b3          	add	a5,s5,s1
    15f8:	0007c583          	lbu	a1,0(a5)
    15fc:	710a0513          	add	a0,s4,1808 # 50010710 <__func__.0+0x2b0>
    1600:	0485                	add	s1,s1,1
    1602:	3b95                	jal	1376 <printf>
    1604:	ff7498e3          	bne	s1,s7,15f4 <main+0xbe>
    1608:	4529                	li	a0,10
    160a:	3395                	jal	136e <putchar>
    160c:	85a6                	mv	a1,s1
    160e:	8556                	mv	a0,s5
    1610:	8e7ff0ef          	jal	ef6 <mailbox_send_data>
    1614:	815a                	mv	sp,s6
    1616:	bf49                	j	15a8 <main+0x72>
    1618:	44c107b7          	lui	a5,0x44c10
    161c:	17dd                	add	a5,a5,-9 # 44c0fff7 <_bss_lma_end+0x44c0e04b>
    161e:	06fa9363          	bne	s5,a5,1684 <main+0x14e>
    1622:	04bd                	add	s1,s1,15
    1624:	98c1                	and	s1,s1,-16
    1626:	8c0a                	mv	s8,sp
    1628:	7131                	add	sp,sp,-192
    162a:	8a8a                	mv	s5,sp
    162c:	40910133          	sub	sp,sp,s1
    1630:	8b8a                	mv	s7,sp
    1632:	4481                	li	s1,0
    1634:	03649263          	bne	s1,s6,1658 <main+0x122>
    1638:	4481                	li	s1,0
    163a:	03649c63          	bne	s1,s6,1672 <main+0x13c>
    163e:	4529                	li	a0,10
    1640:	333d                	jal	136e <putchar>
    1642:	85d6                	mv	a1,s5
    1644:	855e                	mv	a0,s7
    1646:	a7eff0ef          	jal	8c4 <ecc_sigh_test>
    164a:	0c000593          	li	a1,192
    164e:	8556                	mv	a0,s5
    1650:	8a7ff0ef          	jal	ef6 <mailbox_send_data>
    1654:	8162                	mv	sp,s8
    1656:	bf89                	j	15a8 <main+0x72>
    1658:	00249513          	sll	a0,s1,0x2
    165c:	00092783          	lw	a5,0(s2)
    1660:	4611                	li	a2,4
    1662:	ed440593          	add	a1,s0,-300
    1666:	955e                	add	a0,a0,s7
    1668:	ecf42a23          	sw	a5,-300(s0)
    166c:	0485                	add	s1,s1,1
    166e:	2a25                	jal	17a6 <memcpy>
    1670:	b7d1                	j	1634 <main+0xfe>
    1672:	009b87b3          	add	a5,s7,s1
    1676:	0007c583          	lbu	a1,0(a5)
    167a:	710a0513          	add	a0,s4,1808
    167e:	39e5                	jal	1376 <printf>
    1680:	0485                	add	s1,s1,1
    1682:	bf65                	j	163a <main+0x104>
    1684:	44c107b7          	lui	a5,0x44c10
    1688:	17e1                	add	a5,a5,-8 # 44c0fff8 <_bss_lma_end+0x44c0e04c>
    168a:	f0fa9fe3          	bne	s5,a5,15a8 <main+0x72>
    168e:	ee040793          	add	a5,s0,-288
    1692:	00092703          	lw	a4,0(s2)
    1696:	c398                	sw	a4,0(a5)
    1698:	ece42a23          	sw	a4,-300(s0)
    169c:	0791                	add	a5,a5,4
    169e:	ff379ae3          	bne	a5,s3,1692 <main+0x15c>
    16a2:	87ce                	mv	a5,s3
    16a4:	f4040693          	add	a3,s0,-192
    16a8:	00092703          	lw	a4,0(s2)
    16ac:	c398                	sw	a4,0(a5)
    16ae:	ece42a23          	sw	a4,-300(s0)
    16b2:	0791                	add	a5,a5,4
    16b4:	fed79ae3          	bne	a5,a3,16a8 <main+0x172>
    16b8:	85ce                	mv	a1,s3
    16ba:	ee040513          	add	a0,s0,-288
    16be:	d0cff0ef          	jal	bca <ecc_verify_test>
    16c2:	4585                	li	a1,1
    16c4:	833ff0ef          	jal	ef6 <mailbox_send_data>
    16c8:	b5c5                	j	15a8 <main+0x72>
	...

000016cc <early_trap_vector>:
    16cc:	342022f3          	csrr	t0,mcause
    16d0:	34102373          	csrr	t1,mepc
    16d4:	343023f3          	csrr	t2,mtval
    16d8:	30030e37          	lui	t3,0x30030
    16dc:	0cce0e13          	add	t3,t3,204 # 300300cc <_bss_lma_end+0x3002e120>
    16e0:	5000fe97          	auipc	t4,0x5000f
    16e4:	994e8e93          	add	t4,t4,-1644 # 50010074 <trap_msg>

000016e8 <trap_print_loop>:
    16e8:	000e8283          	lb	t0,0(t4)
    16ec:	005e0023          	sb	t0,0(t3)
    16f0:	0e85                	add	t4,t4,1
    16f2:	fe029be3          	bnez	t0,16e8 <trap_print_loop>
    16f6:	4f05                	li	t5,1
    16f8:	01ee0023          	sb	t5,0(t3)
    16fc:	bfc1                	j	16cc <early_trap_vector>

000016fe <memset>:
    16fe:	433d                	li	t1,15
    1700:	872a                	mv	a4,a0
    1702:	02c37363          	bgeu	t1,a2,1728 <memset+0x2a>
    1706:	00f77793          	and	a5,a4,15
    170a:	efbd                	bnez	a5,1788 <memset+0x8a>
    170c:	e5ad                	bnez	a1,1776 <memset+0x78>
    170e:	ff067693          	and	a3,a2,-16
    1712:	8a3d                	and	a2,a2,15
    1714:	96ba                	add	a3,a3,a4
    1716:	c30c                	sw	a1,0(a4)
    1718:	c34c                	sw	a1,4(a4)
    171a:	c70c                	sw	a1,8(a4)
    171c:	c74c                	sw	a1,12(a4)
    171e:	0741                	add	a4,a4,16 # 20001010 <_bss_lma_end+0x1ffff064>
    1720:	fed76be3          	bltu	a4,a3,1716 <memset+0x18>
    1724:	e211                	bnez	a2,1728 <memset+0x2a>
    1726:	8082                	ret
    1728:	40c306b3          	sub	a3,t1,a2
    172c:	068a                	sll	a3,a3,0x2
    172e:	00000297          	auipc	t0,0x0
    1732:	9696                	add	a3,a3,t0
    1734:	00a68067          	jr	10(a3)
    1738:	00b70723          	sb	a1,14(a4)
    173c:	00b706a3          	sb	a1,13(a4)
    1740:	00b70623          	sb	a1,12(a4)
    1744:	00b705a3          	sb	a1,11(a4)
    1748:	00b70523          	sb	a1,10(a4)
    174c:	00b704a3          	sb	a1,9(a4)
    1750:	00b70423          	sb	a1,8(a4)
    1754:	00b703a3          	sb	a1,7(a4)
    1758:	00b70323          	sb	a1,6(a4)
    175c:	00b702a3          	sb	a1,5(a4)
    1760:	00b70223          	sb	a1,4(a4)
    1764:	00b701a3          	sb	a1,3(a4)
    1768:	00b70123          	sb	a1,2(a4)
    176c:	00b700a3          	sb	a1,1(a4)
    1770:	00b70023          	sb	a1,0(a4)
    1774:	8082                	ret
    1776:	0ff5f593          	zext.b	a1,a1
    177a:	00859693          	sll	a3,a1,0x8
    177e:	8dd5                	or	a1,a1,a3
    1780:	01059693          	sll	a3,a1,0x10
    1784:	8dd5                	or	a1,a1,a3
    1786:	b761                	j	170e <memset+0x10>
    1788:	00279693          	sll	a3,a5,0x2
    178c:	00000297          	auipc	t0,0x0
    1790:	9696                	add	a3,a3,t0
    1792:	8286                	mv	t0,ra
    1794:	fa8680e7          	jalr	-88(a3)
    1798:	8096                	mv	ra,t0
    179a:	17c1                	add	a5,a5,-16
    179c:	8f1d                	sub	a4,a4,a5
    179e:	963e                	add	a2,a2,a5
    17a0:	f8c374e3          	bgeu	t1,a2,1728 <memset+0x2a>
    17a4:	b7a5                	j	170c <memset+0xe>

000017a6 <memcpy>:
    17a6:	00a5c7b3          	xor	a5,a1,a0
    17aa:	8b8d                	and	a5,a5,3
    17ac:	00c508b3          	add	a7,a0,a2
    17b0:	e7b1                	bnez	a5,17fc <memcpy+0x56>
    17b2:	478d                	li	a5,3
    17b4:	04c7f463          	bgeu	a5,a2,17fc <memcpy+0x56>
    17b8:	00357793          	and	a5,a0,3
    17bc:	872a                	mv	a4,a0
    17be:	e7dd                	bnez	a5,186c <memcpy+0xc6>
    17c0:	ffc8f613          	and	a2,a7,-4
    17c4:	40e606b3          	sub	a3,a2,a4
    17c8:	02000793          	li	a5,32
    17cc:	04d7c463          	blt	a5,a3,1814 <memcpy+0x6e>
    17d0:	86ae                	mv	a3,a1
    17d2:	87ba                	mv	a5,a4
    17d4:	02c77163          	bgeu	a4,a2,17f6 <memcpy+0x50>
    17d8:	0006a803          	lw	a6,0(a3)
    17dc:	0791                	add	a5,a5,4
    17de:	ff07ae23          	sw	a6,-4(a5)
    17e2:	0691                	add	a3,a3,4
    17e4:	fec7eae3          	bltu	a5,a2,17d8 <memcpy+0x32>
    17e8:	fff60793          	add	a5,a2,-1
    17ec:	8f99                	sub	a5,a5,a4
    17ee:	9bf1                	and	a5,a5,-4
    17f0:	0791                	add	a5,a5,4
    17f2:	973e                	add	a4,a4,a5
    17f4:	95be                	add	a1,a1,a5
    17f6:	01176663          	bltu	a4,a7,1802 <memcpy+0x5c>
    17fa:	8082                	ret
    17fc:	872a                	mv	a4,a0
    17fe:	ff157ee3          	bgeu	a0,a7,17fa <memcpy+0x54>
    1802:	0005c783          	lbu	a5,0(a1)
    1806:	0705                	add	a4,a4,1
    1808:	fef70fa3          	sb	a5,-1(a4)
    180c:	0585                	add	a1,a1,1
    180e:	fee89ae3          	bne	a7,a4,1802 <memcpy+0x5c>
    1812:	8082                	ret
    1814:	02470713          	add	a4,a4,36
    1818:	5194                	lw	a3,32(a1)
    181a:	0005a383          	lw	t2,0(a1)
    181e:	0045a283          	lw	t0,4(a1)
    1822:	0085af83          	lw	t6,8(a1)
    1826:	00c5af03          	lw	t5,12(a1)
    182a:	0105ae83          	lw	t4,16(a1)
    182e:	0145ae03          	lw	t3,20(a1)
    1832:	0185a303          	lw	t1,24(a1)
    1836:	01c5a803          	lw	a6,28(a1)
    183a:	fed72e23          	sw	a3,-4(a4)
    183e:	fc772e23          	sw	t2,-36(a4)
    1842:	fe572023          	sw	t0,-32(a4)
    1846:	fff72223          	sw	t6,-28(a4)
    184a:	ffe72423          	sw	t5,-24(a4)
    184e:	ffd72623          	sw	t4,-20(a4)
    1852:	ffc72823          	sw	t3,-16(a4)
    1856:	fe672a23          	sw	t1,-12(a4)
    185a:	ff072c23          	sw	a6,-8(a4)
    185e:	40e606b3          	sub	a3,a2,a4
    1862:	02458593          	add	a1,a1,36
    1866:	fad7c7e3          	blt	a5,a3,1814 <memcpy+0x6e>
    186a:	b79d                	j	17d0 <memcpy+0x2a>
    186c:	0005c783          	lbu	a5,0(a1)
    1870:	0705                	add	a4,a4,1
    1872:	fef70fa3          	sb	a5,-1(a4)
    1876:	00377793          	and	a5,a4,3
    187a:	0585                	add	a1,a1,1
    187c:	d3b1                	beqz	a5,17c0 <memcpy+0x1a>
    187e:	0005c783          	lbu	a5,0(a1)
    1882:	0705                	add	a4,a4,1
    1884:	fef70fa3          	sb	a5,-1(a4)
    1888:	00377793          	and	a5,a4,3
    188c:	0585                	add	a1,a1,1
    188e:	fff9                	bnez	a5,186c <memcpy+0xc6>
    1890:	bf05                	j	17c0 <memcpy+0x1a>

Disassembly of section .data:

50010000 <trap_msg-0x74>:
50010000:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010004:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010008:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
5001000c:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010010:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010014:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010018:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
5001001c:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010020:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010024:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010028:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
5001002c:	0b0b0b0b          	.insn	4, 0x0b0b0b0b
50010030:	b6a8d563          	bge	a7,a0,5000f39a <_bss_lma_end+0x5000d3ee>
50010034:	6a72                	.insn	2, 0x6a72
50010036:	6f5c                	.insn	2, 0x6f5c
50010038:	977d                	sra	a4,a4,0x3f
5001003a:	24f9                	jal	50010308 <trap_msg+0x294>
5001003c:	cf7ee6c7          	.insn	4, 0xcf7ee6c7
50010040:	0c48                	add	a0,sp,532
50010042:	fb6d                	bnez	a4,50010034 <_data_vma_start+0x34>
50010044:	cbdee973          	csrrs	s2,0xcbd,29
50010048:	9796                	add	a5,a5,t0
5001004a:	7a95                	lui	s5,0xfffe5
5001004c:	ddbc                	sw	a5,120(a1)
5001004e:	f61d489b          	.insn	4, 0xf61d489b
50010052:	4c5d                	li	s8,23
50010054:	97b4                	.insn	2, 0x97b4
50010056:	5b32                	lw	s6,44(sp)
50010058:	dab9                	beqz	a3,5000ffae <_bss_lma_end+0x5000e002>
5001005a:	fb68                	.insn	2, 0xfb68
5001005c:	82c2                	mv	t0,a6
5001005e:	f1b5                	bnez	a1,5000ffc2 <_bss_lma_end+0x5000e016>
50010060:	18d4                	add	a3,sp,116
50010062:	c8f5                	beqz	s1,50010156 <trap_msg+0xe2>
50010064:	1bd4                	add	a3,sp,500
50010066:	f3aa                	.insn	2, 0xf3aa
50010068:	6c1c                	.insn	2, 0x6c1c
5001006a:	6ed5                	lui	t4,0x15
5001006c:	3c9e16fb          	.insn	4, 0x3c9e16fb
50010070:	f504                	.insn	2, 0xf504
50010072:	800a                	c.mv	zero,sp

50010074 <trap_msg>:
50010074:	7878                	.insn	2, 0x7878
50010076:	7878                	.insn	2, 0x7878
50010078:	7878                	.insn	2, 0x7878
5001007a:	7878                	.insn	2, 0x7878
5001007c:	7878                	.insn	2, 0x7878
5001007e:	7878                	.insn	2, 0x7878
50010080:	7878                	.insn	2, 0x7878
50010082:	7878                	.insn	2, 0x7878
50010084:	7878                	.insn	2, 0x7878
50010086:	7878                	.insn	2, 0x7878
50010088:	7878                	.insn	2, 0x7878
5001008a:	7878                	.insn	2, 0x7878
5001008c:	7878                	.insn	2, 0x7878
5001008e:	7878                	.insn	2, 0x7878
50010090:	7878                	.insn	2, 0x7878
50010092:	7878                	.insn	2, 0x7878
50010094:	7878                	.insn	2, 0x7878
50010096:	7878                	.insn	2, 0x7878
50010098:	7878                	.insn	2, 0x7878
5001009a:	7878                	.insn	2, 0x7878
5001009c:	200a                	.insn	2, 0x200a
5001009e:	2020                	.insn	2, 0x2020
500100a0:	5254                	lw	a3,36(a2)
500100a2:	5041                	c.li	zero,-16
500100a4:	5620                	lw	s0,104(a2)
500100a6:	4345                	li	t1,17
500100a8:	4f54                	lw	a3,28(a4)
500100aa:	2052                	.insn	2, 0x2052
500100ac:	5845                	li	a6,-15
500100ae:	4345                	li	t1,17
500100b0:	5455                	li	s0,-11
500100b2:	4e49                	li	t3,18
500100b4:	4b202147          	.insn	4, 0x4b202147
500100b8:	4c49                	li	s8,18
500100ba:	204c                	.insn	2, 0x204c
500100bc:	214d4953          	.insn	4, 0x214d4953
500100c0:	2121                	jal	500104c8 <__func__.0+0x68>
500100c2:	2020                	.insn	2, 0x2020
500100c4:	0a20                	add	s0,sp,280
500100c6:	7878                	.insn	2, 0x7878
500100c8:	7878                	.insn	2, 0x7878
500100ca:	7878                	.insn	2, 0x7878
500100cc:	7878                	.insn	2, 0x7878
500100ce:	7878                	.insn	2, 0x7878
500100d0:	7878                	.insn	2, 0x7878
500100d2:	7878                	.insn	2, 0x7878
500100d4:	7878                	.insn	2, 0x7878
500100d6:	7878                	.insn	2, 0x7878
500100d8:	7878                	.insn	2, 0x7878
500100da:	7878                	.insn	2, 0x7878
500100dc:	7878                	.insn	2, 0x7878
500100de:	7878                	.insn	2, 0x7878
500100e0:	7878                	.insn	2, 0x7878
500100e2:	7878                	.insn	2, 0x7878
500100e4:	7878                	.insn	2, 0x7878
500100e6:	7878                	.insn	2, 0x7878
500100e8:	7878                	.insn	2, 0x7878
500100ea:	7878                	.insn	2, 0x7878
500100ec:	7878                	.insn	2, 0x7878
500100ee:	000a                	c.slli	zero,0x2
500100f0:	7566                	.insn	2, 0x7566
500100f2:	636e                	.insn	2, 0x636e
500100f4:	203a                	.insn	2, 0x203a
500100f6:	7325                	lui	t1,0xfffe9
500100f8:	202c                	.insn	2, 0x202c
500100fa:	696c                	.insn	2, 0x696c
500100fc:	656e                	.insn	2, 0x656e
500100fe:	203a                	.insn	2, 0x203a
50010100:	6425                	lui	s0,0x9
50010102:	000a                	c.slli	zero,0x2
50010104:	450a                	lw	a0,128(sp)
50010106:	4b204343          	.insn	4, 0x4b204343
5001010a:	5945                	li	s2,-15
5001010c:	004e4547          	.insn	4, 0x004e4547
50010110:	74696157          	.insn	4, 0x74696157
50010114:	6620                	.insn	2, 0x6620
50010116:	4b20726f          	jal	tp,500175c8 <STACK+0x2ea8>
5001011a:	2056                	.insn	2, 0x2056
5001011c:	74697277          	.insn	4, 0x74697277
50010120:	0065                	c.nop	25
50010122:	0000                	unimp
50010124:	6f4c                	.insn	2, 0x6f4c
50010126:	6461                	lui	s0,0x18
50010128:	5020                	lw	s0,96(s0)
5001012a:	4952                	lw	s2,20(sp)
5001012c:	4b56                	lw	s6,84(sp)
5001012e:	5945                	li	s2,-15
50010130:	6420                	.insn	2, 0x6420
50010132:	7461                	lui	s0,0xffff8
50010134:	2061                	jal	500101bc <trap_msg+0x148>
50010136:	7266                	.insn	2, 0x7266
50010138:	45206d6f          	jal	s10,5001658a <STACK+0x1e6a>
5001013c:	00004343          	.insn	4, 0x4343
50010140:	7441                	lui	s0,0xffff0
50010142:	6f20                	.insn	2, 0x6f20
50010144:	6666                	.insn	2, 0x6666
50010146:	20746573          	csrrs	a0,0x207,8
5001014a:	5d64255b          	.insn	4, 0x5d64255b
5001014e:	202c                	.insn	2, 0x202c
50010150:	6365                	lui	t1,0x19
50010152:	72705f63          	blez	t2,50010890 <iccm_code0_start+0x178>
50010156:	7669                	lui	a2,0xffffa
50010158:	2079656b          	.insn	4, 0x2079656b
5001015c:	6164                	.insn	2, 0x6164
5001015e:	6174                	.insn	2, 0x6174
50010160:	6d20                	.insn	2, 0x6d20
50010162:	7369                	lui	t1,0xffffa
50010164:	616d                	add	sp,sp,240
50010166:	6374                	.insn	2, 0x6374
50010168:	2168                	.insn	2, 0x2168
5001016a:	000a                	c.slli	zero,0x2
5001016c:	6341                	lui	t1,0x10
5001016e:	7574                	.insn	2, 0x7574
50010170:	6c61                	lui	s8,0x18
50010172:	2020                	.insn	2, 0x2020
50010174:	6420                	.insn	2, 0x6420
50010176:	7461                	lui	s0,0xffff8
50010178:	3a61                	jal	5000fb10 <_bss_lma_end+0x5000db64>
5001017a:	3020                	.insn	2, 0x3020
5001017c:	2578                	.insn	2, 0x2578
5001017e:	786c                	.insn	2, 0x786c
50010180:	000a                	c.slli	zero,0x2
50010182:	0000                	unimp
50010184:	7845                	lui	a6,0xffff1
50010186:	6570                	.insn	2, 0x6570
50010188:	64657463          	bgeu	a0,t1,500107d0 <iccm_code0_start+0xb8>
5001018c:	6420                	.insn	2, 0x6420
5001018e:	7461                	lui	s0,0xffff8
50010190:	3a61                	jal	5000fb28 <_bss_lma_end+0x5000db7c>
50010192:	3020                	.insn	2, 0x3020
50010194:	2578                	.insn	2, 0x2578
50010196:	786c                	.insn	2, 0x786c
50010198:	000a                	c.slli	zero,0x2
5001019a:	0000                	unimp
5001019c:	6f4c                	.insn	2, 0x6f4c
5001019e:	6461                	lui	s0,0x18
500101a0:	5020                	lw	s0,96(s0)
500101a2:	4255                	li	tp,21
500101a4:	5f59454b          	.insn	4, 0x5f59454b
500101a8:	2058                	.insn	2, 0x2058
500101aa:	6164                	.insn	2, 0x6164
500101ac:	6174                	.insn	2, 0x6174
500101ae:	6620                	.insn	2, 0x6620
500101b0:	6f72                	.insn	2, 0x6f72
500101b2:	206d                	jal	5001025c <trap_msg+0x1e8>
500101b4:	4345                	li	t1,17
500101b6:	74410043          	.insn	4, 0x74410043
500101ba:	6f20                	.insn	2, 0x6f20
500101bc:	6666                	.insn	2, 0x6666
500101be:	20746573          	csrrs	a0,0x207,8
500101c2:	5d64255b          	.insn	4, 0x5d64255b
500101c6:	202c                	.insn	2, 0x202c
500101c8:	6365                	lui	t1,0x19
500101ca:	75705f63          	blez	s7,50010928 <iccm_code0_start+0x210>
500101ce:	6b62                	.insn	2, 0x6b62
500101d0:	7965                	lui	s2,0xffff9
500101d2:	785f 6420 7461      	.insn	6, 0x74616420785f
500101d8:	2061                	jal	50010260 <trap_msg+0x1ec>
500101da:	696d                	lui	s2,0x1b
500101dc:	74616d73          	csrrs	s10,0x746,2
500101e0:	0a216863          	bltu	sp,sp,50010290 <trap_msg+0x21c>
500101e4:	0000                	unimp
500101e6:	0000                	unimp
500101e8:	6f4c                	.insn	2, 0x6f4c
500101ea:	6461                	lui	s0,0x18
500101ec:	5020                	lw	s0,96(s0)
500101ee:	4255                	li	tp,21
500101f0:	5f59454b          	.insn	4, 0x5f59454b
500101f4:	2059                	jal	5001027a <trap_msg+0x206>
500101f6:	6164                	.insn	2, 0x6164
500101f8:	6174                	.insn	2, 0x6174
500101fa:	6620                	.insn	2, 0x6620
500101fc:	6f72                	.insn	2, 0x6f72
500101fe:	206d                	jal	500102a8 <trap_msg+0x234>
50010200:	4345                	li	t1,17
50010202:	74410043          	.insn	4, 0x74410043
50010206:	6f20                	.insn	2, 0x6f20
50010208:	6666                	.insn	2, 0x6666
5001020a:	20746573          	csrrs	a0,0x207,8
5001020e:	5d64255b          	.insn	4, 0x5d64255b
50010212:	202c                	.insn	2, 0x202c
50010214:	6365                	lui	t1,0x19
50010216:	75705f63          	blez	s7,50010974 <iccm_code0_start+0x25c>
5001021a:	6b62                	.insn	2, 0x6b62
5001021c:	7965                	lui	s2,0xffff9
5001021e:	795f 6420 7461      	.insn	6, 0x74616420795f
50010224:	2061                	jal	500102ac <trap_msg+0x238>
50010226:	696d                	lui	s2,0x1b
50010228:	74616d73          	csrrs	s10,0x746,2
5001022c:	0a216863          	bltu	sp,sp,500102dc <trap_msg+0x268>
50010230:	0000                	unimp
50010232:	0000                	unimp
50010234:	6e49                	lui	t3,0x12
50010236:	656a                	.insn	2, 0x656a
50010238:	50207463          	bgeu	zero,sp,50010740 <iccm_code0_start+0x28>
5001023c:	4952                	lw	s2,20(sp)
5001023e:	4b56                	lw	s6,84(sp)
50010240:	5945                	li	s2,-15
50010242:	6620                	.insn	2, 0x6620
50010244:	6f72                	.insn	2, 0x6f72
50010246:	206d                	jal	500102f0 <trap_msg+0x27c>
50010248:	7420766b          	.insn	4, 0x7420766b
5001024c:	4345206f          	j	50062680 <_tbs_der_store_end+0x43660>
50010250:	00000043          	.insn	4, 0x0043
50010254:	450a                	lw	a0,128(sp)
50010256:	53204343          	.insn	4, 0x53204343
5001025a:	4749                	li	a4,18
5001025c:	494e                	lw	s2,208(sp)
5001025e:	474e                	lw	a4,208(sp)
50010260:	0000                	unimp
50010262:	0000                	unimp
50010264:	6f4c                	.insn	2, 0x6f4c
50010266:	6461                	lui	s0,0x18
50010268:	5320                	lw	s0,96(a4)
5001026a:	4749                	li	a4,18
5001026c:	5f4e                	lw	t5,240(sp)
5001026e:	2052                	.insn	2, 0x2052
50010270:	6164                	.insn	2, 0x6164
50010272:	6174                	.insn	2, 0x6174
50010274:	6620                	.insn	2, 0x6620
50010276:	6f72                	.insn	2, 0x6f72
50010278:	206d                	jal	50010322 <trap_msg+0x2ae>
5001027a:	4345                	li	t1,17
5001027c:	00000043          	.insn	4, 0x0043
50010280:	7441                	lui	s0,0xffff0
50010282:	6f20                	.insn	2, 0x6f20
50010284:	6666                	.insn	2, 0x6666
50010286:	20746573          	csrrs	a0,0x207,8
5001028a:	5d64255b          	.insn	4, 0x5d64255b
5001028e:	202c                	.insn	2, 0x202c
50010290:	6365                	lui	t1,0x19
50010292:	69735f63          	bge	t1,s7,50010930 <iccm_code0_start+0x218>
50010296:	725f6e67          	.insn	4, 0x725f6e67
5001029a:	6420                	.insn	2, 0x6420
5001029c:	7461                	lui	s0,0xffff8
5001029e:	2061                	jal	50010326 <trap_msg+0x2b2>
500102a0:	696d                	lui	s2,0x1b
500102a2:	74616d73          	csrrs	s10,0x746,2
500102a6:	0a216863          	bltu	sp,sp,50010356 <trap_msg+0x2e2>
500102aa:	0000                	unimp
500102ac:	6341                	lui	t1,0x10
500102ae:	7574                	.insn	2, 0x7574
500102b0:	6c61                	lui	s8,0x18
500102b2:	2020                	.insn	2, 0x2020
500102b4:	6420                	.insn	2, 0x6420
500102b6:	7461                	lui	s0,0xffff8
500102b8:	3a61                	jal	5000fc50 <_bss_lma_end+0x5000dca4>
500102ba:	3020                	.insn	2, 0x3020
500102bc:	2578                	.insn	2, 0x2578
500102be:	3830                	.insn	2, 0x3830
500102c0:	786c                	.insn	2, 0x786c
500102c2:	000a                	c.slli	zero,0x2
500102c4:	7845                	lui	a6,0xffff1
500102c6:	6570                	.insn	2, 0x6570
500102c8:	64657463          	bgeu	a0,t1,50010910 <iccm_code0_start+0x1f8>
500102cc:	6420                	.insn	2, 0x6420
500102ce:	7461                	lui	s0,0xffff8
500102d0:	3a61                	jal	5000fc68 <_bss_lma_end+0x5000dcbc>
500102d2:	3020                	.insn	2, 0x3020
500102d4:	2578                	.insn	2, 0x2578
500102d6:	3830                	.insn	2, 0x3830
500102d8:	786c                	.insn	2, 0x786c
500102da:	000a                	c.slli	zero,0x2
500102dc:	6f4c                	.insn	2, 0x6f4c
500102de:	6461                	lui	s0,0x18
500102e0:	5320                	lw	s0,96(a4)
500102e2:	4749                	li	a4,18
500102e4:	5f4e                	lw	t5,240(sp)
500102e6:	61642053          	.insn	4, 0x61642053
500102ea:	6174                	.insn	2, 0x6174
500102ec:	6620                	.insn	2, 0x6620
500102ee:	6f72                	.insn	2, 0x6f72
500102f0:	206d                	jal	5001039a <trap_msg+0x326>
500102f2:	4345                	li	t1,17
500102f4:	00000043          	.insn	4, 0x0043
500102f8:	7441                	lui	s0,0xffff0
500102fa:	6f20                	.insn	2, 0x6f20
500102fc:	6666                	.insn	2, 0x6666
500102fe:	20746573          	csrrs	a0,0x207,8
50010302:	5d64255b          	.insn	4, 0x5d64255b
50010306:	202c                	.insn	2, 0x202c
50010308:	6365                	lui	t1,0x19
5001030a:	69735f63          	bge	t1,s7,500109a8 <iccm_code0_start+0x290>
5001030e:	735f6e67          	.insn	4, 0x735f6e67
50010312:	6420                	.insn	2, 0x6420
50010314:	7461                	lui	s0,0xffff8
50010316:	2061                	jal	5001039e <trap_msg+0x32a>
50010318:	696d                	lui	s2,0x1b
5001031a:	74616d73          	csrrs	s10,0x746,2
5001031e:	0a216863          	bltu	sp,sp,500103ce <trap_msg+0x35a>
50010322:	0000                	unimp
50010324:	450a                	lw	a0,128(sp)
50010326:	56204343          	.insn	4, 0x56204343
5001032a:	5245                	li	tp,-15
5001032c:	4649                	li	a2,18
5001032e:	4959                	li	s2,22
50010330:	474e                	lw	a4,208(sp)
50010332:	0000                	unimp
50010334:	6f4c                	.insn	2, 0x6f4c
50010336:	6461                	lui	s0,0x18
50010338:	5620                	lw	s0,104(a2)
5001033a:	5245                	li	tp,-15
5001033c:	4649                	li	a2,18
5001033e:	5f59                	li	t5,-10
50010340:	2052                	.insn	2, 0x2052
50010342:	6164                	.insn	2, 0x6164
50010344:	6174                	.insn	2, 0x6174
50010346:	6620                	.insn	2, 0x6620
50010348:	6f72                	.insn	2, 0x6f72
5001034a:	206d                	jal	500103f4 <trap_msg+0x380>
5001034c:	4345                	li	t1,17
5001034e:	74410043          	.insn	4, 0x74410043
50010352:	6f20                	.insn	2, 0x6f20
50010354:	6666                	.insn	2, 0x6666
50010356:	20746573          	csrrs	a0,0x207,8
5001035a:	5d64255b          	.insn	4, 0x5d64255b
5001035e:	202c                	.insn	2, 0x202c
50010360:	6365                	lui	t1,0x19
50010362:	65765f63          	bge	a2,s7,500109c0 <iccm_code0_start+0x2a8>
50010366:	6972                	.insn	2, 0x6972
50010368:	7966                	.insn	2, 0x7966
5001036a:	725f 6420 7461      	.insn	6, 0x74616420725f
50010370:	2061                	jal	500103f8 <trap_msg+0x384>
50010372:	696d                	lui	s2,0x1b
50010374:	74616d73          	csrrs	s10,0x746,2
50010378:	0a216863          	bltu	sp,sp,50010428 <trap_msg+0x3b4>
5001037c:	0000                	unimp
5001037e:	0000                	unimp
50010380:	6341                	lui	t1,0x10
50010382:	7574                	.insn	2, 0x7574
50010384:	6c61                	lui	s8,0x18
50010386:	2020                	.insn	2, 0x2020
50010388:	6420                	.insn	2, 0x6420
5001038a:	7461                	lui	s0,0xffff8
5001038c:	3a61                	jal	5000fd24 <_bss_lma_end+0x5000dd78>
5001038e:	3020                	.insn	2, 0x3020
50010390:	2578                	.insn	2, 0x2578
50010392:	7838                	.insn	2, 0x7838
50010394:	000a                	c.slli	zero,0x2
50010396:	0000                	unimp
50010398:	7845                	lui	a6,0xffff1
5001039a:	6570                	.insn	2, 0x6570
5001039c:	64657463          	bgeu	a0,t1,500109e4 <iccm_code0_start+0x2cc>
500103a0:	6420                	.insn	2, 0x6420
500103a2:	7461                	lui	s0,0xffff8
500103a4:	3a61                	jal	5000fd3c <_bss_lma_end+0x5000dd90>
500103a6:	3020                	.insn	2, 0x3020
500103a8:	2578                	.insn	2, 0x2578
500103aa:	7838                	.insn	2, 0x7838
500103ac:	000a                	c.slli	zero,0x2
500103ae:	0000                	unimp
500103b0:	7570                	.insn	2, 0x7570
500103b2:	6b62                	.insn	2, 0x6b62
500103b4:	7965                	lui	s2,0xffff9
500103b6:	785f 642e 7461      	.insn	6, 0x7461642e785f
500103bc:	3a61                	jal	5000fd54 <_bss_lma_end+0x5000dda8>
500103be:	0000                	unimp
500103c0:	7830                	.insn	2, 0x7830
500103c2:	3025                	jal	5000fbea <_bss_lma_end+0x5000dc3e>
500103c4:	7838                	.insn	2, 0x7838
500103c6:	0020                	add	s0,sp,8
500103c8:	7570                	.insn	2, 0x7570
500103ca:	6b62                	.insn	2, 0x6b62
500103cc:	7965                	lui	s2,0xffff9
500103ce:	795f 642e 7461      	.insn	6, 0x7461642e795f
500103d4:	3a61                	jal	5000fd6c <_bss_lma_end+0x5000ddc0>
500103d6:	0000                	unimp
500103d8:	6e676973          	csrrs	s2,0x6e6,14
500103dc:	725f 642e 7461      	.insn	6, 0x7461642e725f
500103e2:	3a61                	jal	5000fd7a <_bss_lma_end+0x5000ddce>
500103e4:	0000                	unimp
500103e6:	0000                	unimp
500103e8:	6e676973          	csrrs	s2,0x6e6,14
500103ec:	735f 642e 7461      	.insn	6, 0x7461642e735f
500103f2:	3a61                	jal	5000fd8a <_bss_lma_end+0x5000ddde>
500103f4:	0000                	unimp
500103f6:	0000                	unimp
500103f8:	6554                	.insn	2, 0x6554
500103fa:	706d                	c.lui	zero,0xffffb
500103fc:	7261726f          	jal	tp,50027b22 <_tbs_der_store_end+0x8b02>
50010400:	2079                	jal	5001048e <__func__.0+0x2e>
50010402:	64656573          	csrrs	a0,hviprio1,10
50010406:	6320                	.insn	2, 0x6320
50010408:	656c                	.insn	2, 0x656c
5001040a:	7261                	lui	tp,0xffff8
5001040c:	6465                	lui	s0,0x19
5001040e:	6920                	.insn	2, 0x6920
50010410:	206e                	.insn	2, 0x206e
50010412:	5379654b          	.insn	4, 0x5379654b
50010416:	6f6c                	.insn	2, 0x6f6c
50010418:	3374                	.insn	2, 0x3374
5001041a:	002e                	c.slli	zero,0xb
5001041c:	6e676953          	.insn	4, 0x6e676953
50010420:	7461                	lui	s0,0xffff8
50010422:	7275                	lui	tp,0xffffd
50010424:	2065                	jal	500104cc <__func__.0+0x6c>
50010426:	6576                	.insn	2, 0x6576
50010428:	6972                	.insn	2, 0x6972
5001042a:	6966                	.insn	2, 0x6966
5001042c:	69746163          	bltu	s0,s7,50010aae <iccm_code0_start+0x396>
50010430:	73206e6f          	jal	t3,50016b62 <STACK+0x2442>
50010434:	6375                	lui	t1,0x1d
50010436:	73736563          	bltu	t1,s7,50010b60 <iccm_code0_start+0x448>
5001043a:	7566                	.insn	2, 0x7566
5001043c:	216c                	.insn	2, 0x216c
5001043e:	0000                	unimp
50010440:	6e676953          	.insn	4, 0x6e676953
50010444:	7461                	lui	s0,0xffff8
50010446:	7275                	lui	tp,0xffffd
50010448:	2065                	jal	500104f0 <__func__.0+0x90>
5001044a:	6576                	.insn	2, 0x6576
5001044c:	6972                	.insn	2, 0x6972
5001044e:	6966                	.insn	2, 0x6966
50010450:	69746163          	bltu	s0,s7,50010ad2 <iccm_code0_start+0x3ba>
50010454:	66206e6f          	jal	t3,50016ab6 <STACK+0x2396>
50010458:	6961                	lui	s2,0x18
5001045a:	656c                	.insn	2, 0x656c
5001045c:	2164                	.insn	2, 0x2164
	...

50010460 <__func__.0>:
50010460:	6365                	lui	t1,0x19
50010462:	656b5f63          	bge	s6,s6,50010ac0 <iccm_code0_start+0x3a8>
50010466:	6779                	lui	a4,0x1e
50010468:	6e65                	lui	t3,0x19
5001046a:	665f 6f6c 0077      	.insn	6, 0x00776f6c665f
50010470:	6f4c                	.insn	2, 0x6f4c
50010472:	6461                	lui	s0,0x18
50010474:	4b20                	lw	s0,80(a4)
50010476:	7965                	lui	s2,0xffff9
50010478:	6420                	.insn	2, 0x6420
5001047a:	7461                	lui	s0,0xffff8
5001047c:	2061                	jal	50010504 <__func__.0+0xa4>
5001047e:	6f74                	.insn	2, 0x6f74
50010480:	4820                	lw	s0,80(s0)
50010482:	414d                	li	sp,19
50010484:	00000043          	.insn	4, 0x0043
50010488:	6f4c                	.insn	2, 0x6f4c
5001048a:	6461                	lui	s0,0x18
5001048c:	5420                	lw	s0,104(s0)
5001048e:	4741                	li	a4,16
50010490:	6420                	.insn	2, 0x6420
50010492:	7461                	lui	s0,0xffff8
50010494:	2061                	jal	5001051c <__func__.0+0xbc>
50010496:	7266                	.insn	2, 0x7266
50010498:	48206d6f          	jal	s10,5001691a <STACK+0x21fa>
5001049c:	414d                	li	sp,19
5001049e:	6f742043          	.insn	4, 0x6f742043
500104a2:	4b20                	lw	s0,80(a4)
500104a4:	0056                	c.slli	zero,0x15
500104a6:	0000                	unimp
500104a8:	6f4c                	.insn	2, 0x6f4c
500104aa:	6461                	lui	s0,0x18
500104ac:	5420                	lw	s0,104(s0)
500104ae:	4741                	li	a4,16
500104b0:	6420                	.insn	2, 0x6420
500104b2:	7461                	lui	s0,0xffff8
500104b4:	2061                	jal	5001053c <__func__.0+0xdc>
500104b6:	7266                	.insn	2, 0x7266
500104b8:	48206d6f          	jal	s10,5001693a <STACK+0x221a>
500104bc:	414d                	li	sp,19
500104be:	74410043          	.insn	4, 0x74410043
500104c2:	6f20                	.insn	2, 0x6f20
500104c4:	6666                	.insn	2, 0x6666
500104c6:	20746573          	csrrs	a0,0x207,8
500104ca:	5d64255b          	.insn	4, 0x5d64255b
500104ce:	202c                	.insn	2, 0x202c
500104d0:	6d68                	.insn	2, 0x6d68
500104d2:	6361                	lui	t1,0x18
500104d4:	745f 6761 6420      	.insn	6, 0x64206761745f
500104da:	7461                	lui	s0,0xffff8
500104dc:	2061                	jal	50010564 <__func__.0+0x104>
500104de:	696d                	lui	s2,0x1b
500104e0:	74616d73          	csrrs	s10,0x746,2
500104e4:	0a216863          	bltu	sp,sp,50010594 <__func__.0+0x134>
500104e8:	0000                	unimp
500104ea:	0000                	unimp
500104ec:	5746                	lw	a4,112(sp)
500104ee:	203a                	.insn	2, 0x203a
500104f0:	74696157          	.insn	4, 0x74696157
500104f4:	0000                	unimp
500104f6:	0000                	unimp
500104f8:	5746                	lw	a4,112(sp)
500104fa:	203a                	.insn	2, 0x203a
500104fc:	6552                	.insn	2, 0x6552
500104fe:	6461                	lui	s0,0x18
50010500:	6e69                	lui	t3,0x1a
50010502:	30252067          	.insn	4, 0x30252067
50010506:	6438                	.insn	2, 0x6438
50010508:	6220                	.insn	2, 0x6220
5001050a:	7479                	lui	s0,0xffffe
5001050c:	7365                	lui	t1,0xffff9
5001050e:	6620                	.insn	2, 0x6620
50010510:	6f72                	.insn	2, 0x6f72
50010512:	206d                	jal	500105bc <__func__.0+0x15c>
50010514:	616d                	add	sp,sp,240
50010516:	6c69                	lui	s8,0x1a
50010518:	6f62                	.insn	2, 0x6f62
5001051a:	0a78                	add	a4,sp,284
5001051c:	0000                	unimp
5001051e:	0000                	unimp
50010520:	2020                	.insn	2, 0x2020
50010522:	6164                	.insn	2, 0x6164
50010524:	6174                	.insn	2, 0x6174
50010526:	3a74756f          	jal	a0,500580cc <_tbs_der_store_end+0x390ac>
5001052a:	3020                	.insn	2, 0x3020
5001052c:	2578                	.insn	2, 0x2578
5001052e:	3830                	.insn	2, 0x3830
50010530:	0a78                	add	a4,sp,284
50010532:	0000                	unimp
50010534:	5746                	lw	a4,112(sp)
50010536:	203a                	.insn	2, 0x203a
50010538:	74697257          	.insn	4, 0x74697257
5001053c:	6e69                	lui	t3,0x1a
5001053e:	78302067          	.insn	4, 0x78302067
50010542:	3025                	jal	5000fd6a <_bss_lma_end+0x5000ddbe>
50010544:	7838                	.insn	2, 0x7838
50010546:	6220                	.insn	2, 0x6220
50010548:	7479                	lui	s0,0xffffe
5001054a:	7365                	lui	t1,0xffff9
5001054c:	7420                	.insn	2, 0x7420
5001054e:	616d206f          	j	500e2b64 <_tbs_der_store_end+0xc3b44>
50010552:	6c69                	lui	s8,0x1a
50010554:	6f62                	.insn	2, 0x6f62
50010556:	0a78                	add	a4,sp,284
50010558:	0000                	unimp
5001055a:	0000                	unimp
5001055c:	5746                	lw	a4,112(sp)
5001055e:	203a                	.insn	2, 0x203a
50010560:	20746553          	.insn	4, 0x20746553
50010564:	6164                	.insn	2, 0x6164
50010566:	6174                	.insn	2, 0x6174
50010568:	7220                	.insn	2, 0x7220
5001056a:	6165                	add	sp,sp,112
5001056c:	7964                	.insn	2, 0x7964
5001056e:	7320                	.insn	2, 0x7320
50010570:	6174                	.insn	2, 0x6174
50010572:	7574                	.insn	2, 0x7574
50010574:	00000073          	ecall
50010578:	5245                	li	tp,-15
5001057a:	4f52                	lw	t5,20(sp)
5001057c:	3a52                	.insn	2, 0x3a52
5001057e:	6d20                	.insn	2, 0x6d20
50010580:	6961                	lui	s2,0x18
50010582:	626c                	.insn	2, 0x626c
50010584:	6920786f          	jal	a6,50017c16 <STACK+0x34f6>
50010588:	206e                	.insn	2, 0x206e
5001058a:	6e75                	lui	t3,0x1d
5001058c:	7865                	lui	a6,0xffff9
5001058e:	6570                	.insn	2, 0x6570
50010590:	64657463          	bgeu	a0,t1,50010bd8 <iccm_code0_start+0x4c0>
50010594:	7320                	.insn	2, 0x7320
50010596:	6174                	.insn	2, 0x6174
50010598:	6574                	.insn	2, 0x6574
5001059a:	2820                	.insn	2, 0x2820
5001059c:	3025                	jal	5000fdc4 <_bss_lma_end+0x5000de18>
5001059e:	7838                	.insn	2, 0x7838
500105a0:	2029                	jal	500105aa <__func__.0+0x14a>
500105a2:	6e656877          	.insn	4, 0x6e656877
500105a6:	6520                	.insn	2, 0x6520
500105a8:	7078                	.insn	2, 0x7078
500105aa:	6365                	lui	t1,0x19
500105ac:	6974                	.insn	2, 0x6974
500105ae:	676e                	.insn	2, 0x676e
500105b0:	4d20                	lw	s0,88(a0)
500105b2:	4f42                	lw	t5,16(sp)
500105b4:	5f58                	lw	a4,60(a4)
500105b6:	5845                	li	a6,-15
500105b8:	4345                	li	t1,17
500105ba:	5455                	li	s0,-11
500105bc:	5f45                	li	t5,-15
500105be:	20434f53          	.insn	4, 0x20434f53
500105c2:	3028                	.insn	2, 0x3028
500105c4:	2578                	.insn	2, 0x2578
500105c6:	3830                	.insn	2, 0x3830
500105c8:	2978                	.insn	2, 0x2978
500105ca:	000a                	c.slli	zero,0x2
500105cc:	5746                	lw	a4,112(sp)
500105ce:	203a                	.insn	2, 0x203a
500105d0:	614d                	add	sp,sp,176
500105d2:	6c69                	lui	s8,0x1a
500105d4:	6f62                	.insn	2, 0x6f62
500105d6:	2078                	.insn	2, 0x2078
500105d8:	6e69                	lui	t3,0x1a
500105da:	6520                	.insn	2, 0x6520
500105dc:	7078                	.insn	2, 0x7078
500105de:	6365                	lui	t1,0x19
500105e0:	6574                	.insn	2, 0x6574
500105e2:	2064                	.insn	2, 0x2064
500105e4:	74617473          	csrrc	s0,0x746,2
500105e8:	2c65                	jal	500108a0 <iccm_code0_start+0x188>
500105ea:	4d20                	lw	s0,88(a0)
500105ec:	4f42                	lw	t5,16(sp)
500105ee:	5f58                	lw	a4,60(a4)
500105f0:	5845                	li	a6,-15
500105f2:	4345                	li	t1,17
500105f4:	5455                	li	s0,-11
500105f6:	5f45                	li	t5,-15
500105f8:	2c434f53          	.insn	4, 0x2c434f53
500105fc:	6520                	.insn	2, 0x6520
500105fe:	646e                	.insn	2, 0x646e
50010600:	6e69                	lui	t3,0x1a
50010602:	65742067          	.insn	4, 0x65742067
50010606:	77207473          	csrrc	s0,0x772,0
5001060a:	7469                	lui	s0,0xffffa
5001060c:	2068                	.insn	2, 0x2068
5001060e:	63637573          	csrrc	a0,0x636,6
50010612:	7365                	lui	t1,0xffff9
50010614:	00000073          	ecall
50010618:	5f434f53          	.insn	4, 0x5f434f53
5001061c:	4649                	li	a2,18
5001061e:	53203a43          	.insn	4, 0x53203a43
50010622:	7465                	lui	s0,0xffff9
50010624:	6620                	.insn	2, 0x6620
50010626:	6f6c                	.insn	2, 0x6f6c
50010628:	74735f77          	.insn	4, 0x74735f77
5001062c:	7461                	lui	s0,0xffff8
5001062e:	7375                	lui	t1,0xffffd
50010630:	6620                	.insn	2, 0x6620
50010632:	6569                	lui	a0,0x1a
50010634:	646c                	.insn	2, 0x646c
50010636:	203a                	.insn	2, 0x203a
50010638:	7830                	.insn	2, 0x7830
5001063a:	3025                	jal	5000fe62 <_bss_lma_end+0x5000deb6>
5001063c:	7838                	.insn	2, 0x7838
5001063e:	000a                	c.slli	zero,0x2
50010640:	2d2d                	jal	50010c7a <iccm_code0_start+0x562>
50010642:	2d2d                	jal	50010c7c <iccm_code0_start+0x564>
50010644:	2d2d                	jal	50010c7e <iccm_code0_start+0x566>
50010646:	2d2d                	jal	50010c80 <iccm_code0_start+0x568>
50010648:	2d2d                	jal	50010c82 <iccm_code0_start+0x56a>
5001064a:	2d2d                	jal	50010c84 <iccm_code0_start+0x56c>
5001064c:	2d2d                	jal	50010c86 <iccm_code0_start+0x56e>
5001064e:	2d2d                	jal	50010c88 <iccm_code0_start+0x570>
50010650:	2d2d                	jal	50010c8a <iccm_code0_start+0x572>
50010652:	2d2d                	jal	50010c8c <iccm_code0_start+0x574>
50010654:	2d2d                	jal	50010c8e <iccm_code0_start+0x576>
50010656:	2d2d                	jal	50010c90 <iccm_code0_start+0x578>
50010658:	2d2d                	jal	50010c92 <iccm_code0_start+0x57a>
5001065a:	2d2d                	jal	50010c94 <iccm_code0_start+0x57c>
5001065c:	2d2d                	jal	50010c96 <iccm_code0_start+0x57e>
5001065e:	2d2d                	jal	50010c98 <iccm_code0_start+0x580>
50010660:	2d2d                	jal	50010c9a <iccm_code0_start+0x582>
50010662:	2d2d                	jal	50010c9c <iccm_code0_start+0x584>
50010664:	0000                	unimp
50010666:	0000                	unimp
50010668:	2020                	.insn	2, 0x2020
5001066a:	2020                	.insn	2, 0x2020
5001066c:	2020                	.insn	2, 0x2020
5001066e:	2020                	.insn	2, 0x2020
50010670:	2020                	.insn	2, 0x2020
50010672:	2020                	.insn	2, 0x2020
50010674:	696c6143          	.insn	4, 0x696c6143
50010678:	7470                	.insn	2, 0x7470
5001067a:	6172                	.insn	2, 0x6172
5001067c:	5220                	lw	s0,96(a2)
5001067e:	2e2e4d4f          	.insn	4, 0x2e2e4d4f
50010682:	202e                	.insn	2, 0x202e
50010684:	2020                	.insn	2, 0x2020
50010686:	2020                	.insn	2, 0x2020
50010688:	2020                	.insn	2, 0x2020
5001068a:	2020                	.insn	2, 0x2020
5001068c:	0000                	unimp
5001068e:	0000                	unimp
50010690:	3431                	jal	5001009c <trap_msg+0x28>
50010692:	353a                	.insn	2, 0x353a
50010694:	3a32                	.insn	2, 0x3a32
50010696:	3835                	jal	5000fed2 <_bss_lma_end+0x5000df26>
50010698:	0000                	unimp
5001069a:	0000                	unimp
5001069c:	2074634f          	.insn	4, 0x2074634f
500106a0:	3431                	jal	500100ac <trap_msg+0x38>
500106a2:	3220                	.insn	2, 0x3220
500106a4:	3230                	.insn	2, 0x3230
500106a6:	0035                	c.nop	13
500106a8:	706d6f43          	.insn	4, 0x706d6f43
500106ac:	6c69                	lui	s8,0x1a
500106ae:	6465                	lui	s0,0x19
500106b0:	6f20                	.insn	2, 0x6f20
500106b2:	3a6e                	.insn	2, 0x3a6e
500106b4:	2520                	.insn	2, 0x2520
500106b6:	74612073          	csrs	0x746,sp
500106ba:	2520                	.insn	2, 0x2520
500106bc:	00000a73          	.insn	4, 0x0a73
500106c0:	6552                	.insn	2, 0x6552
500106c2:	76696563          	bltu	s2,t1,50010e2c <iccm_code0_start+0x714>
500106c6:	6465                	lui	s0,0x19
500106c8:	6d20                	.insn	2, 0x6d20
500106ca:	6961                	lui	s2,0x18
500106cc:	626c                	.insn	2, 0x626c
500106ce:	6320786f          	jal	a6,50017d00 <STACK+0x35e0>
500106d2:	616d6d6f          	jal	s10,500e6ce8 <_tbs_der_store_end+0xc7cc8>
500106d6:	646e                	.insn	2, 0x646e
500106d8:	2820                	.insn	2, 0x2820
500106da:	7865                	lui	a6,0xffff9
500106dc:	6570                	.insn	2, 0x6570
500106de:	6e697463          	bgeu	s2,t1,50010dc6 <iccm_code0_start+0x6ae>
500106e2:	45522067          	.insn	4, 0x45522067
500106e6:	20295053          	.insn	4, 0x20295053
500106ea:	7266                	.insn	2, 0x7266
500106ec:	53206d6f          	jal	s10,50016c1e <STACK+0x24fe>
500106f0:	2021434f          	.insn	4, 0x2021434f
500106f4:	20746f47          	.insn	4, 0x20746f47
500106f8:	7830                	.insn	2, 0x7830
500106fa:	7825                	lui	a6,0xfffe9
500106fc:	000a                	c.slli	zero,0x2
500106fe:	0000                	unimp
50010700:	20746547          	.insn	4, 0x20746547
50010704:	6172                	.insn	2, 0x6172
50010706:	646e                	.insn	2, 0x646e
50010708:	3a736d6f          	jal	s10,500472ae <_tbs_der_store_end+0x2828e>
5001070c:	0000                	unimp
5001070e:	0000                	unimp
50010710:	3025                	jal	5000ff38 <_bss_lma_end+0x5000df8c>
50010712:	7832                	.insn	2, 0x7832
50010714:	0020                	add	s0,sp,8
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	2029                	jal	10 <_start+0x10>
   8:	3331                	jal	fffffd14 <_tbs_der_store_end+0xaffe0cf4>
   a:	312e                	.insn	2, 0x312e
   c:	312e                	.insn	2, 0x312e
   e:	3220                	.insn	2, 0x3220
  10:	3230                	.insn	2, 0x3230
  12:	31373033          	.insn	4, 0x31373033
  16:	43470033          	.insn	4, 0x43470033
  1a:	28203a43          	.insn	4, 0x28203a43
  1e:	29554e47          	.insn	4, 0x29554e47
  22:	3120                	.insn	2, 0x3120
  24:	2e312e33          	.insn	4, 0x2e312e33
  28:	2031                	jal	34 <_start+0x34>
  2a:	3032                	.insn	2, 0x3032
  2c:	3332                	.insn	2, 0x3332
  2e:	3730                	.insn	2, 0x3730
  30:	3331                	jal	fffffd3c <_tbs_der_store_end+0xaffe0d1c>
	...

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	3241                	jal	fffff980 <_tbs_der_store_end+0xaffe0960>
   2:	0000                	unimp
   4:	7200                	.insn	2, 0x7200
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <_start+0x14>
   c:	0028                	add	a0,sp,8
   e:	0000                	unimp
  10:	1004                	add	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	5f30                	lw	a2,120(a4)
  1c:	326d                	jal	fffff9c6 <_tbs_der_store_end+0xaffe09a6>
  1e:	3070                	.insn	2, 0x3070
  20:	635f 7032 5f30      	.insn	6, 0x5f307032635f
  26:	6d7a                	.insn	2, 0x6d7a
  28:	756d                	lui	a0,0xffffb
  2a:	316c                	.insn	2, 0x316c
  2c:	3070                	.insn	2, 0x3070
  2e:	0800                	add	s0,sp,16
  30:	0a01                	add	s4,s4,0
  32:	0b              	Address 0x32 is out of bounds.

