
/home/jdeng/work/caliptra-sw1-C/rom/dev/caliptraRomC/output/caliptraROMC.elf：     文件格式 elf32-littleriscv


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
  22:	00004297          	auipc	t0,0x4
  26:	e5a28293          	add	t0,t0,-422 # 3e7c <early_trap_vector>
  2a:	30529073          	csrw	mtvec,t0
  2e:	00004297          	auipc	t0,0x4
  32:	16e28293          	add	t0,t0,366 # 419c <_data_lma_start>
  36:	00005317          	auipc	t1,0x5
  3a:	45630313          	add	t1,t1,1110 # 548c <_bss_lma_end>
  3e:	50010397          	auipc	t2,0x50010
  42:	fc238393          	add	t2,t2,-62 # 50010000 <SOC_expected_digest>

00000046 <data_cp_loop>:
  46:	0002ae03          	lw	t3,0(t0)
  4a:	01c3a023          	sw	t3,0(t2)
  4e:	0291                	add	t0,t0,4
  50:	0391                	add	t2,t2,4
  52:	fe62eae3          	bltu	t0,t1,46 <data_cp_loop>
  56:	00005297          	auipc	t0,0x5
  5a:	43628293          	add	t0,t0,1078 # 548c <_bss_lma_end>
  5e:	00005317          	auipc	t1,0x5
  62:	42e30313          	add	t1,t1,1070 # 548c <_bss_lma_end>
  66:	50011397          	auipc	t2,0x50011
  6a:	28a38393          	add	t2,t2,650 # 500112f0 <SOC_FW_data>

0000006e <bss_cp_loop>:
  6e:	0002ae03          	lw	t3,0(t0)
  72:	01c3a023          	sw	t3,0(t2)
  76:	0291                	add	t0,t0,4
  78:	0391                	add	t2,t2,4
  7a:	fe62eae3          	bltu	t0,t1,6e <bss_cp_loop>
  7e:	5001d117          	auipc	sp,0x5001d
  82:	87210113          	add	sp,sp,-1934 # 5001c8f0 <STACK>
  86:	271030ef          	jal	3af6 <main>

0000008a <_finish>:
  8a:	300302b7          	lui	t0,0x30030
  8e:	0cc28293          	add	t0,t0,204 # 300300cc <_bss_lma_end+0x3002ac40>
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

00000168 <store_to_datavault>:
     168:	1101                	add	sp,sp,-32
     16a:	040077b7          	lui	a5,0x4007
     16e:	c64e                	sw	s3,12(sp)
     170:	c256                	sw	s5,4(sp)
     172:	08278793          	add	a5,a5,130 # 4007082 <_bss_lma_end+0x4001bf6>
     176:	8aaa                	mv	s5,a0
     178:	89ae                	mv	s3,a1
     17a:	50010537          	lui	a0,0x50010
     17e:	500105b7          	lui	a1,0x50010
     182:	ca26                	sw	s1,20(sp)
     184:	c452                	sw	s4,8(sp)
     186:	84b2                	mv	s1,a2
     188:	00f60a33          	add	s4,a2,a5
     18c:	25058593          	add	a1,a1,592 # 50010250 <__func__.1>
     190:	97b6                	add	a5,a5,a3
     192:	0d100613          	li	a2,209
     196:	16450513          	add	a0,a0,356 # 50010164 <trap_msg+0x7c>
     19a:	cc22                	sw	s0,24(sp)
     19c:	c84a                	sw	s2,16(sp)
     19e:	00279413          	sll	s0,a5,0x2
     1a2:	ce06                	sw	ra,28(sp)
     1a4:	8936                	mv	s2,a3
     1a6:	6e5000ef          	jal	108a <printf>
     1aa:	47a5                	li	a5,9
     1ac:	0097e463          	bltu	a5,s1,1b4 <store_to_datavault+0x4c>
     1b0:	0327f263          	bgeu	a5,s2,1d4 <store_to_datavault+0x6c>
     1b4:	50010537          	lui	a0,0x50010
     1b8:	17850513          	add	a0,a0,376 # 50010178 <trap_msg+0x90>
     1bc:	6cd000ef          	jal	1088 <puts>
     1c0:	557d                	li	a0,-1
     1c2:	40f2                	lw	ra,28(sp)
     1c4:	4462                	lw	s0,24(sp)
     1c6:	44d2                	lw	s1,20(sp)
     1c8:	4942                	lw	s2,16(sp)
     1ca:	49b2                	lw	s3,12(sp)
     1cc:	4a22                	lw	s4,8(sp)
     1ce:	4a92                	lw	s5,4(sp)
     1d0:	6105                	add	sp,sp,32
     1d2:	8082                	ret
     1d4:	03000713          	li	a4,48
     1d8:	02e486b3          	mul	a3,s1,a4
     1dc:	1001c7b7          	lui	a5,0x1001c
     1e0:	23078793          	add	a5,a5,560 # 1001c230 <_bss_lma_end+0x10016da4>
     1e4:	0a0a                	sll	s4,s4,0x2
     1e6:	96be                	add	a3,a3,a5
     1e8:	4781                	li	a5,0
     1ea:	00fa85b3          	add	a1,s5,a5
     1ee:	00f68633          	add	a2,a3,a5
     1f2:	418c                	lw	a1,0(a1)
     1f4:	c20c                	sw	a1,0(a2)
     1f6:	0791                	add	a5,a5,4
     1f8:	fee799e3          	bne	a5,a4,1ea <store_to_datavault+0x82>
     1fc:	0220000f          	fence	r,r
     200:	0220000f          	fence	r,r
     204:	02f907b3          	mul	a5,s2,a5
     208:	4705                	li	a4,1
     20a:	00ea2023          	sw	a4,0(s4)
     20e:	1001c737          	lui	a4,0x1001c
     212:	23070713          	add	a4,a4,560 # 1001c230 <_bss_lma_end+0x10016da4>
     216:	03000693          	li	a3,48
     21a:	97ba                	add	a5,a5,a4
     21c:	4701                	li	a4,0
     21e:	00e985b3          	add	a1,s3,a4
     222:	00e78633          	add	a2,a5,a4
     226:	418c                	lw	a1,0(a1)
     228:	c20c                	sw	a1,0(a2)
     22a:	0711                	add	a4,a4,4
     22c:	fed719e3          	bne	a4,a3,21e <store_to_datavault+0xb6>
     230:	0220000f          	fence	r,r
     234:	0220000f          	fence	r,r
     238:	4785                	li	a5,1
     23a:	50010537          	lui	a0,0x50010
     23e:	c01c                	sw	a5,0(s0)
     240:	864a                	mv	a2,s2
     242:	85a6                	mv	a1,s1
     244:	1a450513          	add	a0,a0,420 # 500101a4 <trap_msg+0xbc>
     248:	643000ef          	jal	108a <printf>
     24c:	4501                	li	a0,0
     24e:	bf95                	j	1c2 <store_to_datavault+0x5a>

00000250 <read_from_datavault>:
     250:	1101                	add	sp,sp,-32
     252:	c84a                	sw	s2,16(sp)
     254:	c64e                	sw	s3,12(sp)
     256:	892e                	mv	s2,a1
     258:	89aa                	mv	s3,a0
     25a:	500105b7          	lui	a1,0x50010
     25e:	50010537          	lui	a0,0x50010
     262:	cc22                	sw	s0,24(sp)
     264:	23c58593          	add	a1,a1,572 # 5001023c <__func__.0>
     268:	8432                	mv	s0,a2
     26a:	16450513          	add	a0,a0,356 # 50010164 <trap_msg+0x7c>
     26e:	0ec00613          	li	a2,236
     272:	ca26                	sw	s1,20(sp)
     274:	ce06                	sw	ra,28(sp)
     276:	84b6                	mv	s1,a3
     278:	613000ef          	jal	108a <printf>
     27c:	47a5                	li	a5,9
     27e:	0087e463          	bltu	a5,s0,286 <read_from_datavault+0x36>
     282:	0297f063          	bgeu	a5,s1,2a2 <read_from_datavault+0x52>
     286:	50010537          	lui	a0,0x50010
     28a:	17850513          	add	a0,a0,376 # 50010178 <trap_msg+0x90>
     28e:	5fb000ef          	jal	1088 <puts>
     292:	557d                	li	a0,-1
     294:	40f2                	lw	ra,28(sp)
     296:	4462                	lw	s0,24(sp)
     298:	44d2                	lw	s1,20(sp)
     29a:	4942                	lw	s2,16(sp)
     29c:	49b2                	lw	s3,12(sp)
     29e:	6105                	add	sp,sp,32
     2a0:	8082                	ret
     2a2:	03000713          	li	a4,48
     2a6:	02e406b3          	mul	a3,s0,a4
     2aa:	1001c7b7          	lui	a5,0x1001c
     2ae:	23078793          	add	a5,a5,560 # 1001c230 <_bss_lma_end+0x10016da4>
     2b2:	96be                	add	a3,a3,a5
     2b4:	4781                	li	a5,0
     2b6:	00f68633          	add	a2,a3,a5
     2ba:	420c                	lw	a1,0(a2)
     2bc:	00f98633          	add	a2,s3,a5
     2c0:	c20c                	sw	a1,0(a2)
     2c2:	0791                	add	a5,a5,4
     2c4:	fee799e3          	bne	a5,a4,2b6 <read_from_datavault+0x66>
     2c8:	02f487b3          	mul	a5,s1,a5
     2cc:	1001c737          	lui	a4,0x1001c
     2d0:	23070713          	add	a4,a4,560 # 1001c230 <_bss_lma_end+0x10016da4>
     2d4:	03000693          	li	a3,48
     2d8:	97ba                	add	a5,a5,a4
     2da:	4701                	li	a4,0
     2dc:	00e78633          	add	a2,a5,a4
     2e0:	420c                	lw	a1,0(a2)
     2e2:	00e90633          	add	a2,s2,a4
     2e6:	c20c                	sw	a1,0(a2)
     2e8:	0711                	add	a4,a4,4
     2ea:	fed719e3          	bne	a4,a3,2dc <read_from_datavault+0x8c>
     2ee:	50010537          	lui	a0,0x50010
     2f2:	8626                	mv	a2,s1
     2f4:	85a2                	mv	a1,s0
     2f6:	1f050513          	add	a0,a0,496 # 500101f0 <trap_msg+0x108>
     2fa:	591000ef          	jal	108a <printf>
     2fe:	4501                	li	a0,0
     300:	bf51                	j	294 <read_from_datavault+0x44>

00000302 <ecc_keygen_flow>:
     302:	7179                	add	sp,sp,-48
     304:	ce4e                	sw	s3,28(sp)
     306:	89ba                	mv	s3,a4
     308:	10008737          	lui	a4,0x10008
     30c:	d422                	sw	s0,40(sp)
     30e:	d226                	sw	s1,36(sp)
     310:	d04a                	sw	s2,32(sp)
     312:	cc52                	sw	s4,24(sp)
     314:	ca56                	sw	s5,20(sp)
     316:	d606                	sw	ra,44(sp)
     318:	c85a                	sw	s6,16(sp)
     31a:	c65e                	sw	s7,12(sp)
     31c:	8aaa                	mv	s5,a0
     31e:	8a2e                	mv	s4,a1
     320:	8432                	mv	s0,a2
     322:	8936                	mv	s2,a3
     324:	84be                	mv	s1,a5
     326:	0761                	add	a4,a4,24 # 10008018 <_bss_lma_end+0x10002b8c>
     328:	431c                	lw	a5,0(a4)
     32a:	8b85                	and	a5,a5,1
     32c:	dff5                	beqz	a5,328 <ecc_keygen_flow+0x26>
     32e:	000ac783          	lbu	a5,0(s5)
     332:	50010bb7          	lui	s7,0x50010
     336:	50010b37          	lui	s6,0x50010
     33a:	18078c63          	beqz	a5,4d2 <ecc_keygen_flow+0x1d0>
     33e:	03b00613          	li	a2,59
     342:	510b8593          	add	a1,s7,1296 # 50010510 <__func__.0>
     346:	164b0513          	add	a0,s6,356 # 50010164 <trap_msg+0x7c>
     34a:	541000ef          	jal	108a <printf>
     34e:	001ac783          	lbu	a5,1(s5)
     352:	0786                	sll	a5,a5,0x1
     354:	03e7f793          	and	a5,a5,62
     358:	0017e793          	or	a5,a5,1
     35c:	0220000f          	fence	r,r
     360:	0220000f          	fence	r,r
     364:	10008737          	lui	a4,0x10008
     368:	60f72423          	sw	a5,1544(a4) # 10008608 <_bss_lma_end+0x1000317c>
     36c:	60c70713          	add	a4,a4,1548
     370:	431c                	lw	a5,0(a4)
     372:	8b89                	and	a5,a5,2
     374:	dff5                	beqz	a5,370 <ecc_keygen_flow+0x6e>
     376:	00094783          	lbu	a5,0(s2)
     37a:	cb85                	beqz	a5,3aa <ecc_keygen_flow+0xa8>
     37c:	04d00613          	li	a2,77
     380:	510b8593          	add	a1,s7,1296
     384:	164b0513          	add	a0,s6,356
     388:	503000ef          	jal	108a <printf>
     38c:	00194783          	lbu	a5,1(s2)
     390:	0786                	sll	a5,a5,0x1
     392:	03e7f793          	and	a5,a5,62
     396:	2017e793          	or	a5,a5,513
     39a:	0220000f          	fence	r,r
     39e:	0220000f          	fence	r,r
     3a2:	10008737          	lui	a4,0x10008
     3a6:	60f72823          	sw	a5,1552(a4) # 10008610 <_bss_lma_end+0x10003184>
     3aa:	100087b7          	lui	a5,0x10008
     3ae:	efff8637          	lui	a2,0xefff8
     3b2:	10008737          	lui	a4,0x10008
     3b6:	50078793          	add	a5,a5,1280 # 10008500 <_bss_lma_end+0x10003074>
     3ba:	b0060613          	add	a2,a2,-1280 # efff7b00 <_tbs_der_store_end+0x9ffd8ae0>
     3be:	53070713          	add	a4,a4,1328 # 10008530 <_bss_lma_end+0x100030a4>
     3c2:	85be                	mv	a1,a5
     3c4:	0791                	add	a5,a5,4
     3c6:	00c786b3          	add	a3,a5,a2
     3ca:	96d2                	add	a3,a3,s4
     3cc:	4294                	lw	a3,0(a3)
     3ce:	c194                	sw	a3,0(a1)
     3d0:	fee799e3          	bne	a5,a4,3c2 <ecc_keygen_flow+0xc0>
     3d4:	100087b7          	lui	a5,0x10008
     3d8:	efff8637          	lui	a2,0xefff8
     3dc:	10008737          	lui	a4,0x10008
     3e0:	48078793          	add	a5,a5,1152 # 10008480 <_bss_lma_end+0x10002ff4>
     3e4:	b8060613          	add	a2,a2,-1152 # efff7b80 <_tbs_der_store_end+0x9ffd8b60>
     3e8:	4b070713          	add	a4,a4,1200 # 100084b0 <_bss_lma_end+0x10003024>
     3ec:	85be                	mv	a1,a5
     3ee:	0791                	add	a5,a5,4
     3f0:	00c786b3          	add	a3,a5,a2
     3f4:	96a2                	add	a3,a3,s0
     3f6:	4294                	lw	a3,0(a3)
     3f8:	c194                	sw	a3,0(a1)
     3fa:	fee799e3          	bne	a5,a4,3ec <ecc_keygen_flow+0xea>
     3fe:	50010537          	lui	a0,0x50010
     402:	26450513          	add	a0,a0,612 # 50010264 <__func__.1+0x14>
     406:	483000ef          	jal	1088 <puts>
     40a:	0220000f          	fence	r,r
     40e:	0220000f          	fence	r,r
     412:	100087b7          	lui	a5,0x10008
     416:	4705                	li	a4,1
     418:	cb98                	sw	a4,16(a5)
     41a:	01878713          	add	a4,a5,24 # 10008018 <_bss_lma_end+0x10002b8c>
     41e:	431c                	lw	a5,0(a4)
     420:	8b89                	and	a5,a5,2
     422:	dff5                	beqz	a5,41e <ecc_keygen_flow+0x11c>
     424:	00094783          	lbu	a5,0(s2)
     428:	c3fd                	beqz	a5,50e <ecc_keygen_flow+0x20c>
     42a:	50010537          	lui	a0,0x50010
     42e:	27050513          	add	a0,a0,624 # 50010270 <__func__.1+0x20>
     432:	457000ef          	jal	1088 <puts>
     436:	10008737          	lui	a4,0x10008
     43a:	61470713          	add	a4,a4,1556 # 10008614 <_bss_lma_end+0x10003188>
     43e:	431c                	lw	a5,0(a4)
     440:	8b89                	and	a5,a5,2
     442:	dff5                	beqz	a5,43e <ecc_keygen_flow+0x13c>
     444:	50010537          	lui	a0,0x50010
     448:	2fc50513          	add	a0,a0,764 # 500102fc <__func__.1+0xac>
     44c:	43d000ef          	jal	1088 <puts>
     450:	0009c783          	lbu	a5,0(s3)
     454:	12078963          	beqz	a5,586 <ecc_keygen_flow+0x284>
     458:	100086b7          	lui	a3,0x10008
     45c:	efff8637          	lui	a2,0xefff8
     460:	100087b7          	lui	a5,0x10008
     464:	20068693          	add	a3,a3,512 # 10008200 <_bss_lma_end+0x10002d74>
     468:	e0460613          	add	a2,a2,-508 # efff7e04 <_tbs_der_store_end+0x9ffd8de4>
     46c:	23078793          	add	a5,a5,560 # 10008230 <_bss_lma_end+0x10002da4>
     470:	00c68733          	add	a4,a3,a2
     474:	428c                	lw	a1,0(a3)
     476:	974e                	add	a4,a4,s3
     478:	c30c                	sw	a1,0(a4)
     47a:	0691                	add	a3,a3,4
     47c:	fef69ae3          	bne	a3,a5,470 <ecc_keygen_flow+0x16e>
     480:	50010537          	lui	a0,0x50010
     484:	34850513          	add	a0,a0,840 # 50010348 <__func__.1+0xf8>
     488:	401000ef          	jal	1088 <puts>
     48c:	0004c783          	lbu	a5,0(s1)
     490:	16078163          	beqz	a5,5f2 <ecc_keygen_flow+0x2f0>
     494:	10008737          	lui	a4,0x10008
     498:	efff8637          	lui	a2,0xefff8
     49c:	100087b7          	lui	a5,0x10008
     4a0:	28070713          	add	a4,a4,640 # 10008280 <_bss_lma_end+0x10002df4>
     4a4:	d8460613          	add	a2,a2,-636 # efff7d84 <_tbs_der_store_end+0x9ffd8d64>
     4a8:	2b078793          	add	a5,a5,688 # 100082b0 <_bss_lma_end+0x10002e24>
     4ac:	00c706b3          	add	a3,a4,a2
     4b0:	430c                	lw	a1,0(a4)
     4b2:	96a6                	add	a3,a3,s1
     4b4:	c28c                	sw	a1,0(a3)
     4b6:	0711                	add	a4,a4,4
     4b8:	fef71ae3          	bne	a4,a5,4ac <ecc_keygen_flow+0x1aa>
     4bc:	50b2                	lw	ra,44(sp)
     4be:	5422                	lw	s0,40(sp)
     4c0:	5492                	lw	s1,36(sp)
     4c2:	5902                	lw	s2,32(sp)
     4c4:	49f2                	lw	s3,28(sp)
     4c6:	4a62                	lw	s4,24(sp)
     4c8:	4ad2                	lw	s5,20(sp)
     4ca:	4b42                	lw	s6,16(sp)
     4cc:	4bb2                	lw	s7,12(sp)
     4ce:	6145                	add	sp,sp,48
     4d0:	8082                	ret
     4d2:	04400613          	li	a2,68
     4d6:	510b8593          	add	a1,s7,1296
     4da:	164b0513          	add	a0,s6,356
     4de:	3ad000ef          	jal	108a <printf>
     4e2:	100087b7          	lui	a5,0x10008
     4e6:	efff8637          	lui	a2,0xefff8
     4ea:	10008737          	lui	a4,0x10008
     4ee:	08078793          	add	a5,a5,128 # 10008080 <_bss_lma_end+0x10002bf4>
     4f2:	f8060613          	add	a2,a2,-128 # efff7f80 <_tbs_der_store_end+0x9ffd8f60>
     4f6:	0b070713          	add	a4,a4,176 # 100080b0 <_bss_lma_end+0x10002c24>
     4fa:	85be                	mv	a1,a5
     4fc:	0791                	add	a5,a5,4
     4fe:	00c786b3          	add	a3,a5,a2
     502:	96d6                	add	a3,a3,s5
     504:	4294                	lw	a3,0(a3)
     506:	c194                	sw	a3,0(a1)
     508:	fee799e3          	bne	a5,a4,4fa <ecc_keygen_flow+0x1f8>
     50c:	b5ad                	j	376 <ecc_keygen_flow+0x74>
     50e:	50010537          	lui	a0,0x50010
     512:	28450513          	add	a0,a0,644 # 50010284 <__func__.1+0x34>
     516:	373000ef          	jal	1088 <puts>
     51a:	100087b7          	lui	a5,0x10008
     51e:	efff86b7          	lui	a3,0xefff8
     522:	10008737          	lui	a4,0x10008
     526:	4401                	li	s0,0
     528:	18078793          	add	a5,a5,384 # 10008180 <_bss_lma_end+0x10002cf4>
     52c:	e8468693          	add	a3,a3,-380 # efff7e84 <_tbs_der_store_end+0x9ffd8e64>
     530:	1b070713          	add	a4,a4,432 # 100081b0 <_bss_lma_end+0x10002d24>
     534:	00d78633          	add	a2,a5,a3
     538:	964a                	add	a2,a2,s2
     53a:	0007aa03          	lw	s4,0(a5)
     53e:	4210                	lw	a2,0(a2)
     540:	02ca0e63          	beq	s4,a2,57c <ecc_keygen_flow+0x27a>
     544:	50010537          	lui	a0,0x50010
     548:	85a2                	mv	a1,s0
     54a:	2a050513          	add	a0,a0,672 # 500102a0 <__func__.1+0x50>
     54e:	33d000ef          	jal	108a <printf>
     552:	50010537          	lui	a0,0x50010
     556:	85d2                	mv	a1,s4
     558:	2cc50513          	add	a0,a0,716 # 500102cc <__func__.1+0x7c>
     55c:	32f000ef          	jal	108a <printf>
     560:	040a                	sll	s0,s0,0x2
     562:	008906b3          	add	a3,s2,s0
     566:	50010537          	lui	a0,0x50010
     56a:	42cc                	lw	a1,4(a3)
     56c:	2e450513          	add	a0,a0,740 # 500102e4 <__func__.1+0x94>
     570:	31b000ef          	jal	108a <printf>
     574:	4505                	li	a0,1
     576:	30d000ef          	jal	1082 <putchar>
     57a:	a001                	j	57a <ecc_keygen_flow+0x278>
     57c:	0791                	add	a5,a5,4
     57e:	0405                	add	s0,s0,1
     580:	fae79ae3          	bne	a5,a4,534 <ecc_keygen_flow+0x232>
     584:	b5c1                	j	444 <ecc_keygen_flow+0x142>
     586:	100086b7          	lui	a3,0x10008
     58a:	efff8737          	lui	a4,0xefff8
     58e:	100087b7          	lui	a5,0x10008
     592:	4401                	li	s0,0
     594:	20068693          	add	a3,a3,512 # 10008200 <_bss_lma_end+0x10002d74>
     598:	e0470713          	add	a4,a4,-508 # efff7e04 <_tbs_der_store_end+0x9ffd8de4>
     59c:	23078793          	add	a5,a5,560 # 10008230 <_bss_lma_end+0x10002da4>
     5a0:	00e68633          	add	a2,a3,a4
     5a4:	964e                	add	a2,a2,s3
     5a6:	0006a903          	lw	s2,0(a3)
     5aa:	4210                	lw	a2,0(a2)
     5ac:	02c90e63          	beq	s2,a2,5e8 <ecc_keygen_flow+0x2e6>
     5b0:	50010537          	lui	a0,0x50010
     5b4:	85a2                	mv	a1,s0
     5b6:	31850513          	add	a0,a0,792 # 50010318 <__func__.1+0xc8>
     5ba:	2d1000ef          	jal	108a <printf>
     5be:	50010537          	lui	a0,0x50010
     5c2:	85ca                	mv	a1,s2
     5c4:	2cc50513          	add	a0,a0,716 # 500102cc <__func__.1+0x7c>
     5c8:	2c3000ef          	jal	108a <printf>
     5cc:	040a                	sll	s0,s0,0x2
     5ce:	00898733          	add	a4,s3,s0
     5d2:	50010537          	lui	a0,0x50010
     5d6:	434c                	lw	a1,4(a4)
     5d8:	2e450513          	add	a0,a0,740 # 500102e4 <__func__.1+0x94>
     5dc:	2af000ef          	jal	108a <printf>
     5e0:	4505                	li	a0,1
     5e2:	2a1000ef          	jal	1082 <putchar>
     5e6:	a001                	j	5e6 <ecc_keygen_flow+0x2e4>
     5e8:	0691                	add	a3,a3,4
     5ea:	0405                	add	s0,s0,1
     5ec:	faf69ae3          	bne	a3,a5,5a0 <ecc_keygen_flow+0x29e>
     5f0:	bd41                	j	480 <ecc_keygen_flow+0x17e>
     5f2:	10008737          	lui	a4,0x10008
     5f6:	efff86b7          	lui	a3,0xefff8
     5fa:	100087b7          	lui	a5,0x10008
     5fe:	4401                	li	s0,0
     600:	28070713          	add	a4,a4,640 # 10008280 <_bss_lma_end+0x10002df4>
     604:	d8468693          	add	a3,a3,-636 # efff7d84 <_tbs_der_store_end+0x9ffd8d64>
     608:	2b078793          	add	a5,a5,688 # 100082b0 <_bss_lma_end+0x10002e24>
     60c:	00d70633          	add	a2,a4,a3
     610:	9626                	add	a2,a2,s1
     612:	00072903          	lw	s2,0(a4)
     616:	4210                	lw	a2,0(a2)
     618:	02c90e63          	beq	s2,a2,654 <ecc_keygen_flow+0x352>
     61c:	50010537          	lui	a0,0x50010
     620:	85a2                	mv	a1,s0
     622:	36450513          	add	a0,a0,868 # 50010364 <__func__.1+0x114>
     626:	265000ef          	jal	108a <printf>
     62a:	50010537          	lui	a0,0x50010
     62e:	85ca                	mv	a1,s2
     630:	2cc50513          	add	a0,a0,716 # 500102cc <__func__.1+0x7c>
     634:	257000ef          	jal	108a <printf>
     638:	040a                	sll	s0,s0,0x2
     63a:	008487b3          	add	a5,s1,s0
     63e:	50010537          	lui	a0,0x50010
     642:	43cc                	lw	a1,4(a5)
     644:	2e450513          	add	a0,a0,740 # 500102e4 <__func__.1+0x94>
     648:	243000ef          	jal	108a <printf>
     64c:	4505                	li	a0,1
     64e:	235000ef          	jal	1082 <putchar>
     652:	a001                	j	652 <ecc_keygen_flow+0x350>
     654:	0711                	add	a4,a4,4
     656:	0405                	add	s0,s0,1
     658:	faf71ae3          	bne	a4,a5,60c <ecc_keygen_flow+0x30a>
     65c:	b585                	j	4bc <ecc_keygen_flow+0x1ba>

0000065e <ecc_signing_flow>:
     65e:	1101                	add	sp,sp,-32
     660:	ca26                	sw	s1,20(sp)
     662:	84ba                	mv	s1,a4
     664:	10008737          	lui	a4,0x10008
     668:	cc22                	sw	s0,24(sp)
     66a:	c84a                	sw	s2,16(sp)
     66c:	c64e                	sw	s3,12(sp)
     66e:	c452                	sw	s4,8(sp)
     670:	ce06                	sw	ra,28(sp)
     672:	842a                	mv	s0,a0
     674:	8a2e                	mv	s4,a1
     676:	89b2                	mv	s3,a2
     678:	8936                	mv	s2,a3
     67a:	0761                	add	a4,a4,24 # 10008018 <_bss_lma_end+0x10002b8c>
     67c:	431c                	lw	a5,0(a4)
     67e:	8b85                	and	a5,a5,1
     680:	dff5                	beqz	a5,67c <ecc_signing_flow+0x1e>
     682:	100087b7          	lui	a5,0x10008
     686:	00044703          	lbu	a4,0(s0)
     68a:	58078793          	add	a5,a5,1408 # 10008580 <_bss_lma_end+0x100030f4>
     68e:	e31d                	bnez	a4,6b4 <ecc_signing_flow+0x56>
     690:	efff8637          	lui	a2,0xefff8
     694:	10008737          	lui	a4,0x10008
     698:	a8060613          	add	a2,a2,-1408 # efff7a80 <_tbs_der_store_end+0x9ffd8a60>
     69c:	5b070713          	add	a4,a4,1456 # 100085b0 <_bss_lma_end+0x10003124>
     6a0:	85be                	mv	a1,a5
     6a2:	0791                	add	a5,a5,4
     6a4:	00c786b3          	add	a3,a5,a2
     6a8:	96a2                	add	a3,a3,s0
     6aa:	4294                	lw	a3,0(a3)
     6ac:	c194                	sw	a3,0(a1)
     6ae:	fee799e3          	bne	a5,a4,6a0 <ecc_signing_flow+0x42>
     6b2:	a81d                	j	6e8 <ecc_signing_flow+0x8a>
     6b4:	50010537          	lui	a0,0x50010
     6b8:	39450513          	add	a0,a0,916 # 50010394 <__func__.1+0x144>
     6bc:	1cd000ef          	jal	1088 <puts>
     6c0:	00144783          	lbu	a5,1(s0)
     6c4:	0786                	sll	a5,a5,0x1
     6c6:	03e7f793          	and	a5,a5,62
     6ca:	0017e793          	or	a5,a5,1
     6ce:	0220000f          	fence	r,r
     6d2:	0220000f          	fence	r,r
     6d6:	10008737          	lui	a4,0x10008
     6da:	60f72023          	sw	a5,1536(a4) # 10008600 <_bss_lma_end+0x10003174>
     6de:	60470713          	add	a4,a4,1540
     6e2:	431c                	lw	a5,0(a4)
     6e4:	8b89                	and	a5,a5,2
     6e6:	dff5                	beqz	a5,6e2 <ecc_signing_flow+0x84>
     6e8:	100087b7          	lui	a5,0x10008
     6ec:	efff8637          	lui	a2,0xefff8
     6f0:	10008737          	lui	a4,0x10008
     6f4:	10078793          	add	a5,a5,256 # 10008100 <_bss_lma_end+0x10002c74>
     6f8:	f0060613          	add	a2,a2,-256 # efff7f00 <_tbs_der_store_end+0x9ffd8ee0>
     6fc:	13070713          	add	a4,a4,304 # 10008130 <_bss_lma_end+0x10002ca4>
     700:	85be                	mv	a1,a5
     702:	0791                	add	a5,a5,4
     704:	00c786b3          	add	a3,a5,a2
     708:	96d2                	add	a3,a3,s4
     70a:	4294                	lw	a3,0(a3)
     70c:	c194                	sw	a3,0(a1)
     70e:	fee799e3          	bne	a5,a4,700 <ecc_signing_flow+0xa2>
     712:	100087b7          	lui	a5,0x10008
     716:	efff8637          	lui	a2,0xefff8
     71a:	10008737          	lui	a4,0x10008
     71e:	48078793          	add	a5,a5,1152 # 10008480 <_bss_lma_end+0x10002ff4>
     722:	b8060613          	add	a2,a2,-1152 # efff7b80 <_tbs_der_store_end+0x9ffd8b60>
     726:	4b070713          	add	a4,a4,1200 # 100084b0 <_bss_lma_end+0x10003024>
     72a:	85be                	mv	a1,a5
     72c:	0791                	add	a5,a5,4
     72e:	00c786b3          	add	a3,a5,a2
     732:	96ce                	add	a3,a3,s3
     734:	4294                	lw	a3,0(a3)
     736:	c194                	sw	a3,0(a1)
     738:	fee799e3          	bne	a5,a4,72a <ecc_signing_flow+0xcc>
     73c:	50010537          	lui	a0,0x50010
     740:	3b450513          	add	a0,a0,948 # 500103b4 <__func__.1+0x164>
     744:	145000ef          	jal	1088 <puts>
     748:	0220000f          	fence	r,r
     74c:	0220000f          	fence	r,r
     750:	100087b7          	lui	a5,0x10008
     754:	4709                	li	a4,2
     756:	cb98                	sw	a4,16(a5)
     758:	01878713          	add	a4,a5,24 # 10008018 <_bss_lma_end+0x10002b8c>
     75c:	431c                	lw	a5,0(a4)
     75e:	8b89                	and	a5,a5,2
     760:	dff5                	beqz	a5,75c <ecc_signing_flow+0xfe>
     762:	50010537          	lui	a0,0x50010
     766:	3c450513          	add	a0,a0,964 # 500103c4 <__func__.1+0x174>
     76a:	11f000ef          	jal	1088 <puts>
     76e:	00094783          	lbu	a5,0(s2)
     772:	cbb5                	beqz	a5,7e6 <mrac+0x26>
     774:	100087b7          	lui	a5,0x10008
     778:	efff8637          	lui	a2,0xefff8
     77c:	10008737          	lui	a4,0x10008
     780:	30078793          	add	a5,a5,768 # 10008300 <_bss_lma_end+0x10002e74>
     784:	d0460613          	add	a2,a2,-764 # efff7d04 <_tbs_der_store_end+0x9ffd8ce4>
     788:	33070713          	add	a4,a4,816 # 10008330 <_bss_lma_end+0x10002ea4>
     78c:	00c786b3          	add	a3,a5,a2
     790:	438c                	lw	a1,0(a5)
     792:	96ca                	add	a3,a3,s2
     794:	c28c                	sw	a1,0(a3)
     796:	0791                	add	a5,a5,4
     798:	fee79ae3          	bne	a5,a4,78c <ecc_signing_flow+0x12e>
     79c:	50010537          	lui	a0,0x50010
     7a0:	43c50513          	add	a0,a0,1084 # 5001043c <__func__.1+0x1ec>
     7a4:	0e5000ef          	jal	1088 <puts>
     7a8:	0004c783          	lbu	a5,0(s1)
     7ac:	c3dd                	beqz	a5,852 <mfdc+0x59>
     7ae:	100087b7          	lui	a5,0x10008
     7b2:	efff8637          	lui	a2,0xefff8
     7b6:	10008737          	lui	a4,0x10008
     7ba:	38078793          	add	a5,a5,896 # 10008380 <_bss_lma_end+0x10002ef4>
     7be:	c8460613          	add	a2,a2,-892 # efff7c84 <_tbs_der_store_end+0x9ffd8c64>
     7c2:	3b070713          	add	a4,a4,944 # 100083b0 <_bss_lma_end+0x10002f24>
     7c6:	00c786b3          	add	a3,a5,a2
     7ca:	438c                	lw	a1,0(a5)
     7cc:	96a6                	add	a3,a3,s1
     7ce:	c28c                	sw	a1,0(a3)
     7d0:	0791                	add	a5,a5,4
     7d2:	fee79ae3          	bne	a5,a4,7c6 <mrac+0x6>
     7d6:	40f2                	lw	ra,28(sp)
     7d8:	4462                	lw	s0,24(sp)
     7da:	44d2                	lw	s1,20(sp)
     7dc:	4942                	lw	s2,16(sp)
     7de:	49b2                	lw	s3,12(sp)
     7e0:	4a22                	lw	s4,8(sp)
     7e2:	6105                	add	sp,sp,32
     7e4:	8082                	ret
     7e6:	100087b7          	lui	a5,0x10008
     7ea:	efff86b7          	lui	a3,0xefff8
     7ee:	10008737          	lui	a4,0x10008
     7f2:	4401                	li	s0,0
     7f4:	30078793          	add	a5,a5,768 # 10008300 <_bss_lma_end+0x10002e74>
     7f8:	d0468693          	add	a3,a3,-764 # efff7d04 <_tbs_der_store_end+0x9ffd8ce4>
     7fc:	33070713          	add	a4,a4,816 # 10008330 <_bss_lma_end+0x10002ea4>
     800:	00d78633          	add	a2,a5,a3
     804:	964a                	add	a2,a2,s2
     806:	0007a983          	lw	s3,0(a5)
     80a:	4210                	lw	a2,0(a2)
     80c:	02c98e63          	beq	s3,a2,848 <mfdc+0x4f>
     810:	50010537          	lui	a0,0x50010
     814:	85a2                	mv	a1,s0
     816:	3e050513          	add	a0,a0,992 # 500103e0 <__func__.1+0x190>
     81a:	071000ef          	jal	108a <printf>
     81e:	50010537          	lui	a0,0x50010
     822:	85ce                	mv	a1,s3
     824:	40c50513          	add	a0,a0,1036 # 5001040c <__func__.1+0x1bc>
     828:	063000ef          	jal	108a <printf>
     82c:	040a                	sll	s0,s0,0x2
     82e:	008906b3          	add	a3,s2,s0
     832:	50010537          	lui	a0,0x50010
     836:	42cc                	lw	a1,4(a3)
     838:	42450513          	add	a0,a0,1060 # 50010424 <__func__.1+0x1d4>
     83c:	04f000ef          	jal	108a <printf>
     840:	4505                	li	a0,1
     842:	041000ef          	jal	1082 <putchar>
     846:	a001                	j	846 <mfdc+0x4d>
     848:	0791                	add	a5,a5,4
     84a:	0405                	add	s0,s0,1
     84c:	fae79ae3          	bne	a5,a4,800 <mfdc+0x7>
     850:	b7b1                	j	79c <ecc_signing_flow+0x13e>
     852:	100087b7          	lui	a5,0x10008
     856:	efff86b7          	lui	a3,0xefff8
     85a:	10008737          	lui	a4,0x10008
     85e:	4401                	li	s0,0
     860:	38078793          	add	a5,a5,896 # 10008380 <_bss_lma_end+0x10002ef4>
     864:	c8468693          	add	a3,a3,-892 # efff7c84 <_tbs_der_store_end+0x9ffd8c64>
     868:	3b070713          	add	a4,a4,944 # 100083b0 <_bss_lma_end+0x10002f24>
     86c:	00d78633          	add	a2,a5,a3
     870:	9626                	add	a2,a2,s1
     872:	0007a903          	lw	s2,0(a5)
     876:	4210                	lw	a2,0(a2)
     878:	02c90e63          	beq	s2,a2,8b4 <mfdc+0xbb>
     87c:	50010537          	lui	a0,0x50010
     880:	85a2                	mv	a1,s0
     882:	45850513          	add	a0,a0,1112 # 50010458 <__func__.1+0x208>
     886:	005000ef          	jal	108a <printf>
     88a:	50010537          	lui	a0,0x50010
     88e:	85ca                	mv	a1,s2
     890:	2cc50513          	add	a0,a0,716 # 500102cc <__func__.1+0x7c>
     894:	7f6000ef          	jal	108a <printf>
     898:	040a                	sll	s0,s0,0x2
     89a:	00848733          	add	a4,s1,s0
     89e:	50010537          	lui	a0,0x50010
     8a2:	434c                	lw	a1,4(a4)
     8a4:	2e450513          	add	a0,a0,740 # 500102e4 <__func__.1+0x94>
     8a8:	7e2000ef          	jal	108a <printf>
     8ac:	4505                	li	a0,1
     8ae:	7d4000ef          	jal	1082 <putchar>
     8b2:	a001                	j	8b2 <mfdc+0xb9>
     8b4:	0791                	add	a5,a5,4
     8b6:	0405                	add	s0,s0,1
     8b8:	fae79ae3          	bne	a5,a4,86c <mfdc+0x73>
     8bc:	bf29                	j	7d6 <mrac+0x16>

000008be <ecc_verifying_flow>:
     8be:	1141                	add	sp,sp,-16
     8c0:	c422                	sw	s0,8(sp)
     8c2:	8436                	mv	s0,a3
     8c4:	100086b7          	lui	a3,0x10008
     8c8:	c606                	sw	ra,12(sp)
     8ca:	c226                	sw	s1,4(sp)
     8cc:	c04a                	sw	s2,0(sp)
     8ce:	06e1                	add	a3,a3,24 # 10008018 <_bss_lma_end+0x10002b8c>
     8d0:	429c                	lw	a5,0(a3)
     8d2:	8b85                	and	a5,a5,1
     8d4:	dff5                	beqz	a5,8d0 <ecc_verifying_flow+0x12>
     8d6:	100087b7          	lui	a5,0x10008
     8da:	100086b7          	lui	a3,0x10008
     8de:	10078793          	add	a5,a5,256 # 10008100 <_bss_lma_end+0x10002c74>
     8e2:	13068693          	add	a3,a3,304 # 10008130 <_bss_lma_end+0x10002ca4>
     8e6:	883e                	mv	a6,a5
     8e8:	00452883          	lw	a7,4(a0)
     8ec:	0791                	add	a5,a5,4
     8ee:	01182023          	sw	a7,0(a6)
     8f2:	0511                	add	a0,a0,4
     8f4:	fed799e3          	bne	a5,a3,8e6 <ecc_verifying_flow+0x28>
     8f8:	100087b7          	lui	a5,0x10008
     8fc:	100086b7          	lui	a3,0x10008
     900:	20078793          	add	a5,a5,512 # 10008200 <_bss_lma_end+0x10002d74>
     904:	23068693          	add	a3,a3,560 # 10008230 <_bss_lma_end+0x10002da4>
     908:	853e                	mv	a0,a5
     90a:	0045a803          	lw	a6,4(a1)
     90e:	0791                	add	a5,a5,4
     910:	01052023          	sw	a6,0(a0)
     914:	0591                	add	a1,a1,4
     916:	fed799e3          	bne	a5,a3,908 <ecc_verifying_flow+0x4a>
     91a:	100087b7          	lui	a5,0x10008
     91e:	100086b7          	lui	a3,0x10008
     922:	28078793          	add	a5,a5,640 # 10008280 <_bss_lma_end+0x10002df4>
     926:	2b068693          	add	a3,a3,688 # 100082b0 <_bss_lma_end+0x10002e24>
     92a:	85be                	mv	a1,a5
     92c:	4248                	lw	a0,4(a2)
     92e:	0791                	add	a5,a5,4
     930:	c188                	sw	a0,0(a1)
     932:	0611                	add	a2,a2,4
     934:	fed79be3          	bne	a5,a3,92a <ecc_verifying_flow+0x6c>
     938:	100087b7          	lui	a5,0x10008
     93c:	100086b7          	lui	a3,0x10008
     940:	8622                	mv	a2,s0
     942:	30078793          	add	a5,a5,768 # 10008300 <_bss_lma_end+0x10002e74>
     946:	33068693          	add	a3,a3,816 # 10008330 <_bss_lma_end+0x10002ea4>
     94a:	85be                	mv	a1,a5
     94c:	4248                	lw	a0,4(a2)
     94e:	0791                	add	a5,a5,4
     950:	c188                	sw	a0,0(a1)
     952:	0611                	add	a2,a2,4
     954:	fed79be3          	bne	a5,a3,94a <ecc_verifying_flow+0x8c>
     958:	100087b7          	lui	a5,0x10008
     95c:	100086b7          	lui	a3,0x10008
     960:	38078793          	add	a5,a5,896 # 10008380 <_bss_lma_end+0x10002ef4>
     964:	3b068693          	add	a3,a3,944 # 100083b0 <_bss_lma_end+0x10002f24>
     968:	863e                	mv	a2,a5
     96a:	434c                	lw	a1,4(a4)
     96c:	0791                	add	a5,a5,4
     96e:	c20c                	sw	a1,0(a2)
     970:	0711                	add	a4,a4,4
     972:	fed79be3          	bne	a5,a3,968 <ecc_verifying_flow+0xaa>
     976:	50010537          	lui	a0,0x50010
     97a:	48450513          	add	a0,a0,1156 # 50010484 <__func__.1+0x234>
     97e:	2729                	jal	1088 <puts>
     980:	0220000f          	fence	r,r
     984:	0220000f          	fence	r,r
     988:	100087b7          	lui	a5,0x10008
     98c:	470d                	li	a4,3
     98e:	cb98                	sw	a4,16(a5)
     990:	00062837          	lui	a6,0x62
     994:	30030737          	lui	a4,0x30030
     998:	300308b7          	lui	a7,0x30030
     99c:	3e900513          	li	a0,1001
     9a0:	01878593          	add	a1,a5,24 # 10008018 <_bss_lma_end+0x10002b8c>
     9a4:	64070713          	add	a4,a4,1600 # 30030640 <_bss_lma_end+0x3002b1b4>
     9a8:	a8080813          	add	a6,a6,-1408 # 61a80 <_bss_lma_end+0x5c5f4>
     9ac:	64888893          	add	a7,a7,1608 # 30030648 <_bss_lma_end+0x3002b1bc>
     9b0:	419c                	lw	a5,0(a1)
     9b2:	8b89                	and	a5,a5,2
     9b4:	cfb1                	beqz	a5,a10 <ecc_verifying_flow+0x152>
     9b6:	50010537          	lui	a0,0x50010
     9ba:	49450513          	add	a0,a0,1172 # 50010494 <__func__.1+0x244>
     9be:	25e9                	jal	1088 <puts>
     9c0:	100087b7          	lui	a5,0x10008
     9c4:	4581                	li	a1,0
     9c6:	40078793          	add	a5,a5,1024 # 10008400 <_bss_lma_end+0x10002f74>
     9ca:	46b1                	li	a3,12
     9cc:	00259713          	sll	a4,a1,0x2
     9d0:	973e                	add	a4,a4,a5
     9d2:	00072903          	lw	s2,0(a4)
     9d6:	4044                	lw	s1,4(s0)
     9d8:	06990763          	beq	s2,s1,a46 <ecc_verifying_flow+0x188>
     9dc:	50010537          	lui	a0,0x50010
     9e0:	4b050513          	add	a0,a0,1200 # 500104b0 <__func__.1+0x260>
     9e4:	255d                	jal	108a <printf>
     9e6:	50010537          	lui	a0,0x50010
     9ea:	85ca                	mv	a1,s2
     9ec:	4e050513          	add	a0,a0,1248 # 500104e0 <__func__.1+0x290>
     9f0:	2d69                	jal	108a <printf>
     9f2:	50010537          	lui	a0,0x50010
     9f6:	85a6                	mv	a1,s1
     9f8:	4f850513          	add	a0,a0,1272 # 500104f8 <__func__.1+0x2a8>
     9fc:	2579                	jal	108a <printf>
     9fe:	4505                	li	a0,1
     a00:	2549                	jal	1082 <putchar>
     a02:	557d                	li	a0,-1
     a04:	40b2                	lw	ra,12(sp)
     a06:	4422                	lw	s0,8(sp)
     a08:	4492                	lw	s1,4(sp)
     a0a:	4902                	lw	s2,0(sp)
     a0c:	0141                	add	sp,sp,16
     a0e:	8082                	ret
     a10:	157d                	add	a0,a0,-1
     a12:	d965                	beqz	a0,a02 <ecc_verifying_flow+0x144>
     a14:	4310                	lw	a2,0(a4)
     a16:	01060333          	add	t1,a2,a6
     a1a:	4354                	lw	a3,4(a4)
     a1c:	00c337b3          	sltu	a5,t1,a2
     a20:	97b6                	add	a5,a5,a3
     a22:	0068a023          	sw	t1,0(a7)
     a26:	861a                	mv	a2,t1
     a28:	00f8a223          	sw	a5,4(a7)
     a2c:	00072303          	lw	t1,0(a4)
     a30:	00472383          	lw	t2,4(a4)
     a34:	00f3e663          	bltu	t2,a5,a40 <ecc_verifying_flow+0x182>
     a38:	f6779ce3          	bne	a5,t2,9b0 <ecc_verifying_flow+0xf2>
     a3c:	f6c37ae3          	bgeu	t1,a2,9b0 <ecc_verifying_flow+0xf2>
     a40:	10500073          	wfi
     a44:	b7e5                	j	a2c <ecc_verifying_flow+0x16e>
     a46:	0585                	add	a1,a1,1
     a48:	0411                	add	s0,s0,4
     a4a:	f8d591e3          	bne	a1,a3,9cc <ecc_verifying_flow+0x10e>
     a4e:	4501                	li	a0,0
     a50:	bf55                	j	a04 <ecc_verifying_flow+0x146>

00000a52 <hmac_flow>:
     a52:	1101                	add	sp,sp,-32
     a54:	cc22                	sw	s0,24(sp)
     a56:	ca26                	sw	s1,20(sp)
     a58:	c84a                	sw	s2,16(sp)
     a5a:	c64e                	sw	s3,12(sp)
     a5c:	ce06                	sw	ra,28(sp)
     a5e:	c452                	sw	s4,8(sp)
     a60:	10010737          	lui	a4,0x10010
     a64:	892a                	mv	s2,a0
     a66:	84ae                	mv	s1,a1
     a68:	89b2                	mv	s3,a2
     a6a:	8436                	mv	s0,a3
     a6c:	0006ca03          	lbu	s4,0(a3)
     a70:	0761                	add	a4,a4,24 # 10010018 <_bss_lma_end+0x1000ab8c>
     a72:	431c                	lw	a5,0(a4)
     a74:	8b85                	and	a5,a5,1
     a76:	dff5                	beqz	a5,a72 <hmac_flow+0x20>
     a78:	00094783          	lbu	a5,0(s2)
     a7c:	cff9                	beqz	a5,b5a <hmac_flow+0x108>
     a7e:	00194783          	lbu	a5,1(s2)
     a82:	0786                	sll	a5,a5,0x1
     a84:	03e7f793          	and	a5,a5,62
     a88:	0017e793          	or	a5,a5,1
     a8c:	0220000f          	fence	r,r
     a90:	0220000f          	fence	r,r
     a94:	10010737          	lui	a4,0x10010
     a98:	60f72023          	sw	a5,1536(a4) # 10010600 <_bss_lma_end+0x1000b174>
     a9c:	60470713          	add	a4,a4,1540
     aa0:	431c                	lw	a5,0(a4)
     aa2:	8b89                	and	a5,a5,2
     aa4:	dff5                	beqz	a5,aa0 <hmac_flow+0x4e>
     aa6:	0004c783          	lbu	a5,0(s1)
     aaa:	cff1                	beqz	a5,b86 <hmac_flow+0x134>
     aac:	0014c783          	lbu	a5,1(s1)
     ab0:	0786                	sll	a5,a5,0x1
     ab2:	03e7f793          	and	a5,a5,62
     ab6:	0017e793          	or	a5,a5,1
     aba:	0220000f          	fence	r,r
     abe:	0220000f          	fence	r,r
     ac2:	10010737          	lui	a4,0x10010
     ac6:	60f72423          	sw	a5,1544(a4) # 10010608 <_bss_lma_end+0x1000b17c>
     aca:	60c70713          	add	a4,a4,1548
     ace:	431c                	lw	a5,0(a4)
     ad0:	8b89                	and	a5,a5,2
     ad2:	dff5                	beqz	a5,ace <hmac_flow+0x7c>
     ad4:	0049a703          	lw	a4,4(s3)
     ad8:	100107b7          	lui	a5,0x10010
     adc:	12e7a823          	sw	a4,304(a5) # 10010130 <_bss_lma_end+0x1000aca4>
     ae0:	0089a703          	lw	a4,8(s3)
     ae4:	13478793          	add	a5,a5,308
     ae8:	c398                	sw	a4,0(a5)
     aea:	00c9a703          	lw	a4,12(s3)
     aee:	c3d8                	sw	a4,4(a5)
     af0:	0109a703          	lw	a4,16(s3)
     af4:	c798                	sw	a4,8(a5)
     af6:	0149a703          	lw	a4,20(s3)
     afa:	c7d8                	sw	a4,12(a5)
     afc:	020a0163          	beqz	s4,b1e <hmac_flow+0xcc>
     b00:	00144783          	lbu	a5,1(s0)
     b04:	0786                	sll	a5,a5,0x1
     b06:	0ff7f793          	zext.b	a5,a5
     b0a:	7c17e793          	or	a5,a5,1985
     b0e:	0220000f          	fence	r,r
     b12:	0220000f          	fence	r,r
     b16:	10010737          	lui	a4,0x10010
     b1a:	60f72823          	sw	a5,1552(a4) # 10010610 <_bss_lma_end+0x1000b184>
     b1e:	0220000f          	fence	r,r
     b22:	0220000f          	fence	r,r
     b26:	100107b7          	lui	a5,0x10010
     b2a:	4705                	li	a4,1
     b2c:	cb98                	sw	a4,16(a5)
     b2e:	060a0c63          	beqz	s4,ba6 <hmac_flow+0x154>
     b32:	50010537          	lui	a0,0x50010
     b36:	53850513          	add	a0,a0,1336 # 50010538 <__func__.0+0x28>
     b3a:	23b9                	jal	1088 <puts>
     b3c:	10010737          	lui	a4,0x10010
     b40:	61470713          	add	a4,a4,1556 # 10010614 <_bss_lma_end+0x1000b188>
     b44:	431c                	lw	a5,0(a4)
     b46:	8b89                	and	a5,a5,2
     b48:	dff5                	beqz	a5,b44 <hmac_flow+0xf2>
     b4a:	40f2                	lw	ra,28(sp)
     b4c:	4462                	lw	s0,24(sp)
     b4e:	44d2                	lw	s1,20(sp)
     b50:	4942                	lw	s2,16(sp)
     b52:	49b2                	lw	s3,12(sp)
     b54:	4a22                	lw	s4,8(sp)
     b56:	6105                	add	sp,sp,32
     b58:	8082                	ret
     b5a:	50010537          	lui	a0,0x50010
     b5e:	52050513          	add	a0,a0,1312 # 50010520 <__func__.0+0x10>
     b62:	231d                	jal	1088 <puts>
     b64:	100107b7          	lui	a5,0x10010
     b68:	10010737          	lui	a4,0x10010
     b6c:	04078793          	add	a5,a5,64 # 10010040 <_bss_lma_end+0x1000abb4>
     b70:	07070713          	add	a4,a4,112 # 10010070 <_bss_lma_end+0x1000abe4>
     b74:	86be                	mv	a3,a5
     b76:	00492603          	lw	a2,4(s2)
     b7a:	0791                	add	a5,a5,4
     b7c:	c290                	sw	a2,0(a3)
     b7e:	0911                	add	s2,s2,4
     b80:	fee79ae3          	bne	a5,a4,b74 <hmac_flow+0x122>
     b84:	b70d                	j	aa6 <hmac_flow+0x54>
     b86:	100107b7          	lui	a5,0x10010
     b8a:	10010737          	lui	a4,0x10010
     b8e:	08078793          	add	a5,a5,128 # 10010080 <_bss_lma_end+0x1000abf4>
     b92:	10070713          	add	a4,a4,256 # 10010100 <_bss_lma_end+0x1000ac74>
     b96:	86be                	mv	a3,a5
     b98:	40d0                	lw	a2,4(s1)
     b9a:	0791                	add	a5,a5,4
     b9c:	c290                	sw	a2,0(a3)
     b9e:	0491                	add	s1,s1,4
     ba0:	fee79be3          	bne	a5,a4,b96 <hmac_flow+0x144>
     ba4:	bf05                	j	ad4 <hmac_flow+0x82>
     ba6:	50010537          	lui	a0,0x50010
     baa:	55850513          	add	a0,a0,1368 # 50010558 <__func__.0+0x48>
     bae:	29e9                	jal	1088 <puts>
     bb0:	100107b7          	lui	a5,0x10010
     bb4:	4581                	li	a1,0
     bb6:	10078793          	add	a5,a5,256 # 10010100 <_bss_lma_end+0x1000ac74>
     bba:	46b1                	li	a3,12
     bbc:	00259713          	sll	a4,a1,0x2
     bc0:	973e                	add	a4,a4,a5
     bc2:	00072903          	lw	s2,0(a4)
     bc6:	4044                	lw	s1,4(s0)
     bc8:	02990663          	beq	s2,s1,bf4 <hmac_flow+0x1a2>
     bcc:	50010537          	lui	a0,0x50010
     bd0:	57050513          	add	a0,a0,1392 # 50010570 <__func__.0+0x60>
     bd4:	295d                	jal	108a <printf>
     bd6:	50010537          	lui	a0,0x50010
     bda:	85ca                	mv	a1,s2
     bdc:	2cc50513          	add	a0,a0,716 # 500102cc <__func__.1+0x7c>
     be0:	216d                	jal	108a <printf>
     be2:	50010537          	lui	a0,0x50010
     be6:	85a6                	mv	a1,s1
     be8:	2e450513          	add	a0,a0,740 # 500102e4 <__func__.1+0x94>
     bec:	2979                	jal	108a <printf>
     bee:	4505                	li	a0,1
     bf0:	2949                	jal	1082 <putchar>
     bf2:	a001                	j	bf2 <hmac_flow+0x1a0>
     bf4:	0585                	add	a1,a1,1
     bf6:	0411                	add	s0,s0,4
     bf8:	fcd592e3          	bne	a1,a3,bbc <hmac_flow+0x16a>
     bfc:	b7b9                	j	b4a <hmac_flow+0xf8>

00000bfe <mailbox_send_data>:
     bfe:	7179                	add	sp,sp,-48
     c00:	d04a                	sw	s2,32(sp)
     c02:	892a                	mv	s2,a0
     c04:	10000537          	lui	a0,0x10000
     c08:	d606                	sw	ra,44(sp)
     c0a:	d226                	sw	s1,36(sp)
     c0c:	d422                	sw	s0,40(sp)
     c0e:	84ae                	mv	s1,a1
     c10:	ce4e                	sw	s3,28(sp)
     c12:	cc52                	sw	s4,24(sp)
     c14:	ca56                	sw	s5,20(sp)
     c16:	285010ef          	jal	269a <soc_ifc_set_flow_status_field>
     c1a:	50010537          	lui	a0,0x50010
     c1e:	59c50513          	add	a0,a0,1436 # 5001059c <__func__.0+0x8c>
     c22:	219d                	jal	1088 <puts>
     c24:	30020737          	lui	a4,0x30020
     c28:	0761                	add	a4,a4,24 # 30020018 <_bss_lma_end+0x3001ab8c>
     c2a:	431c                	lw	a5,0(a4)
     c2c:	8b85                	and	a5,a5,1
     c2e:	dff5                	beqz	a5,c2a <mailbox_send_data+0x2c>
     c30:	2b1010ef          	jal	26e0 <soc_ifc_read_mbox_cmd>
     c34:	c42a                	sw	a0,8(sp)
     c36:	c62e                	sw	a1,12(sp)
     c38:	842a                	mv	s0,a0
     c3a:	85aa                	mv	a1,a0
     c3c:	50010537          	lui	a0,0x50010
     c40:	5a850513          	add	a0,a0,1448 # 500105a8 <__func__.0+0x98>
     c44:	300209b7          	lui	s3,0x30020
     c48:	2189                	jal	108a <printf>
     c4a:	09d1                	add	s3,s3,20 # 30020014 <_bss_lma_end+0x3001ab88>
     c4c:	50010a37          	lui	s4,0x50010
     c50:	4a91                	li	s5,4
     c52:	e049                	bnez	s0,cd4 <mailbox_send_data+0xd6>
     c54:	0220000f          	fence	r,r
     c58:	0220000f          	fence	r,r
     c5c:	1a2b47b7          	lui	a5,0x1a2b4
     c60:	30020737          	lui	a4,0x30020
     c64:	c4d78793          	add	a5,a5,-947 # 1a2b3c4d <_bss_lma_end+0x1a2ae7c1>
     c68:	c71c                	sw	a5,8(a4)
     c6a:	0220000f          	fence	r,r
     c6e:	0220000f          	fence	r,r
     c72:	50010537          	lui	a0,0x50010
     c76:	c744                	sw	s1,12(a4)
     c78:	85a6                	mv	a1,s1
     c7a:	5e450513          	add	a0,a0,1508 # 500105e4 <__func__.0+0xd4>
     c7e:	2131                	jal	108a <printf>
     c80:	300206b7          	lui	a3,0x30020
     c84:	4781                	li	a5,0
     c86:	4811                	li	a6,4
     c88:	06c1                	add	a3,a3,16 # 30020010 <_bss_lma_end+0x3001ab84>
     c8a:	0497ef63          	bltu	a5,s1,ce8 <mailbox_send_data+0xea>
     c8e:	50010537          	lui	a0,0x50010
     c92:	60c50513          	add	a0,a0,1548 # 5001060c <__func__.0+0xfc>
     c96:	2ecd                	jal	1088 <puts>
     c98:	0220000f          	fence	r,r
     c9c:	0220000f          	fence	r,r
     ca0:	300207b7          	lui	a5,0x30020
     ca4:	4705                	li	a4,1
     ca6:	cfd8                	sw	a4,28(a5)
     ca8:	4fcc                	lw	a1,28(a5)
     caa:	8199                	srl	a1,a1,0x6
     cac:	899d                	and	a1,a1,7
     cae:	4611                	li	a2,4
     cb0:	06c58863          	beq	a1,a2,d20 <mailbox_send_data+0x122>
     cb4:	50010537          	lui	a0,0x50010
     cb8:	62850513          	add	a0,a0,1576 # 50010628 <__func__.0+0x118>
     cbc:	26f9                	jal	108a <printf>
     cbe:	547d                	li	s0,-1
     cc0:	8522                	mv	a0,s0
     cc2:	50b2                	lw	ra,44(sp)
     cc4:	5422                	lw	s0,40(sp)
     cc6:	5492                	lw	s1,36(sp)
     cc8:	5902                	lw	s2,32(sp)
     cca:	49f2                	lw	s3,28(sp)
     ccc:	4a62                	lw	s4,24(sp)
     cce:	4ad2                	lw	s5,20(sp)
     cd0:	6145                	add	sp,sp,48
     cd2:	8082                	ret
     cd4:	0009a583          	lw	a1,0(s3)
     cd8:	5d0a0513          	add	a0,s4,1488 # 500105d0 <__func__.0+0xc0>
     cdc:	267d                	jal	108a <printf>
     cde:	01547363          	bgeu	s0,s5,ce4 <mailbox_send_data+0xe6>
     ce2:	4411                	li	s0,4
     ce4:	1471                	add	s0,s0,-4
     ce6:	b7b5                	j	c52 <mailbox_send_data+0x54>
     ce8:	40f485b3          	sub	a1,s1,a5
     cec:	00b87363          	bgeu	a6,a1,cf2 <mailbox_send_data+0xf4>
     cf0:	4591                	li	a1,4
     cf2:	4701                	li	a4,0
     cf4:	4601                	li	a2,0
     cf6:	00f90333          	add	t1,s2,a5
     cfa:	00e30533          	add	a0,t1,a4
     cfe:	00371893          	sll	a7,a4,0x3
     d02:	00054503          	lbu	a0,0(a0)
     d06:	01151533          	sll	a0,a0,a7
     d0a:	0705                	add	a4,a4,1 # 30020001 <_bss_lma_end+0x3001ab75>
     d0c:	8e49                	or	a2,a2,a0
     d0e:	fee596e3          	bne	a1,a4,cfa <mailbox_send_data+0xfc>
     d12:	0220000f          	fence	r,r
     d16:	0220000f          	fence	r,r
     d1a:	c290                	sw	a2,0(a3)
     d1c:	0791                	add	a5,a5,4 # 30020004 <_bss_lma_end+0x3001ab78>
     d1e:	b7b5                	j	c8a <mailbox_send_data+0x8c>
     d20:	50010537          	lui	a0,0x50010
     d24:	67c50513          	add	a0,a0,1660 # 5001067c <__func__.0+0x16c>
     d28:	2685                	jal	1088 <puts>
     d2a:	bf59                	j	cc0 <mailbox_send_data+0xc2>

00000d2c <whisperPutc>:
     d2c:	1141                	add	sp,sp,-16
     d2e:	c422                	sw	s0,8(sp)
     d30:	c606                	sw	ra,12(sp)
     d32:	47a9                	li	a5,10
     d34:	842a                	mv	s0,a0
     d36:	00f51663          	bne	a0,a5,d42 <whisperPutc+0x16>
     d3a:	4535                	li	a0,13
     d3c:	1b3010ef          	jal	26ee <uart_tx>
     d40:	8522                	mv	a0,s0
     d42:	1ad010ef          	jal	26ee <uart_tx>
     d46:	8522                	mv	a0,s0
     d48:	40b2                	lw	ra,12(sp)
     d4a:	4422                	lw	s0,8(sp)
     d4c:	0141                	add	sp,sp,16
     d4e:	8082                	ret

00000d50 <whisperPuts>:
     d50:	1141                	add	sp,sp,-16
     d52:	c422                	sw	s0,8(sp)
     d54:	c606                	sw	ra,12(sp)
     d56:	842a                	mv	s0,a0
     d58:	00044503          	lbu	a0,0(s0)
     d5c:	e901                	bnez	a0,d6c <whisperPuts+0x1c>
     d5e:	4529                	li	a0,10
     d60:	37f1                	jal	d2c <whisperPutc>
     d62:	40b2                	lw	ra,12(sp)
     d64:	4422                	lw	s0,8(sp)
     d66:	4505                	li	a0,1
     d68:	0141                	add	sp,sp,16
     d6a:	8082                	ret
     d6c:	0405                	add	s0,s0,1
     d6e:	3f7d                	jal	d2c <whisperPutc>
     d70:	b7e5                	j	d58 <whisperPuts+0x8>

00000d72 <whisperPrintUnsigned>:
     d72:	7139                	add	sp,sp,-64
     d74:	da26                	sw	s1,52(sp)
     d76:	d64e                	sw	s3,44(sp)
     d78:	de06                	sw	ra,60(sp)
     d7a:	dc22                	sw	s0,56(sp)
     d7c:	d84a                	sw	s2,48(sp)
     d7e:	84ae                	mv	s1,a1
     d80:	89b2                	mv	s3,a2
     d82:	ed15                	bnez	a0,dbe <whisperPrintUnsigned+0x4c>
     d84:	03000793          	li	a5,48
     d88:	00f10623          	sb	a5,12(sp)
     d8c:	4405                	li	s0,1
     d8e:	8922                	mv	s2,s0
     d90:	04994963          	blt	s2,s1,de2 <whisperPrintUnsigned+0x70>
     d94:	02040793          	add	a5,s0,32
     d98:	002784b3          	add	s1,a5,sp
     d9c:	14ad                	add	s1,s1,-21
     d9e:	40848933          	sub	s2,s1,s0
     da2:	0004c503          	lbu	a0,0(s1)
     da6:	14fd                	add	s1,s1,-1
     da8:	3751                	jal	d2c <whisperPutc>
     daa:	fe991ce3          	bne	s2,s1,da2 <whisperPrintUnsigned+0x30>
     dae:	8522                	mv	a0,s0
     db0:	50f2                	lw	ra,60(sp)
     db2:	5462                	lw	s0,56(sp)
     db4:	54d2                	lw	s1,52(sp)
     db6:	5942                	lw	s2,48(sp)
     db8:	59b2                	lw	s3,44(sp)
     dba:	6121                	add	sp,sp,64
     dbc:	8082                	ret
     dbe:	007c                	add	a5,sp,12
     dc0:	4401                	li	s0,0
     dc2:	46a9                	li	a3,10
     dc4:	4625                	li	a2,9
     dc6:	02d57733          	remu	a4,a0,a3
     dca:	85aa                	mv	a1,a0
     dcc:	0405                	add	s0,s0,1
     dce:	0785                	add	a5,a5,1
     dd0:	03070713          	add	a4,a4,48
     dd4:	fee78fa3          	sb	a4,-1(a5)
     dd8:	02d55533          	divu	a0,a0,a3
     ddc:	feb665e3          	bltu	a2,a1,dc6 <whisperPrintUnsigned+0x54>
     de0:	b77d                	j	d8e <whisperPrintUnsigned+0x1c>
     de2:	854e                	mv	a0,s3
     de4:	37a1                	jal	d2c <whisperPutc>
     de6:	0905                	add	s2,s2,1
     de8:	b765                	j	d90 <whisperPrintUnsigned+0x1e>

00000dea <whisperPrintDecimal>:
     dea:	7139                	add	sp,sp,-64
     dec:	da26                	sw	s1,52(sp)
     dee:	d452                	sw	s4,40(sp)
     df0:	de06                	sw	ra,60(sp)
     df2:	dc22                	sw	s0,56(sp)
     df4:	d84a                	sw	s2,48(sp)
     df6:	d64e                	sw	s3,44(sp)
     df8:	84ae                	mv	s1,a1
     dfa:	8a32                	mv	s4,a2
     dfc:	02055c63          	bgez	a0,e34 <whisperPrintDecimal+0x4a>
     e00:	40a00533          	neg	a0,a0
     e04:	fff58493          	add	s1,a1,-1
     e08:	4905                	li	s2,1
     e0a:	007c                	add	a5,sp,12
     e0c:	4401                	li	s0,0
     e0e:	46a9                	li	a3,10
     e10:	02d56733          	rem	a4,a0,a3
     e14:	0405                	add	s0,s0,1
     e16:	0785                	add	a5,a5,1
     e18:	02d54533          	div	a0,a0,a3
     e1c:	03070713          	add	a4,a4,48
     e20:	fee78fa3          	sb	a4,-1(a5)
     e24:	f575                	bnez	a0,e10 <whisperPrintDecimal+0x26>
     e26:	00090e63          	beqz	s2,e42 <whisperPrintDecimal+0x58>
     e2a:	02d00513          	li	a0,45
     e2e:	0c1010ef          	jal	26ee <uart_tx>
     e32:	a801                	j	e42 <whisperPrintDecimal+0x58>
     e34:	e129                	bnez	a0,e76 <whisperPrintDecimal+0x8c>
     e36:	03000793          	li	a5,48
     e3a:	00f10623          	sb	a5,12(sp)
     e3e:	4901                	li	s2,0
     e40:	4405                	li	s0,1
     e42:	89a2                	mv	s3,s0
     e44:	0299cb63          	blt	s3,s1,e7a <whisperPrintDecimal+0x90>
     e48:	02040793          	add	a5,s0,32
     e4c:	002784b3          	add	s1,a5,sp
     e50:	14ad                	add	s1,s1,-21
     e52:	408489b3          	sub	s3,s1,s0
     e56:	0004c503          	lbu	a0,0(s1)
     e5a:	14fd                	add	s1,s1,-1
     e5c:	3dc1                	jal	d2c <whisperPutc>
     e5e:	fe999ce3          	bne	s3,s1,e56 <whisperPrintDecimal+0x6c>
     e62:	01240533          	add	a0,s0,s2
     e66:	50f2                	lw	ra,60(sp)
     e68:	5462                	lw	s0,56(sp)
     e6a:	54d2                	lw	s1,52(sp)
     e6c:	5942                	lw	s2,48(sp)
     e6e:	59b2                	lw	s3,44(sp)
     e70:	5a22                	lw	s4,40(sp)
     e72:	6121                	add	sp,sp,64
     e74:	8082                	ret
     e76:	4901                	li	s2,0
     e78:	bf49                	j	e0a <whisperPrintDecimal+0x20>
     e7a:	8552                	mv	a0,s4
     e7c:	3d45                	jal	d2c <whisperPutc>
     e7e:	0985                	add	s3,s3,1
     e80:	b7d1                	j	e44 <whisperPrintDecimal+0x5a>

00000e82 <whisperPrintInt>:
     e82:	47a9                	li	a5,10
     e84:	00f69563          	bne	a3,a5,e8e <whisperPrintInt+0xc>
     e88:	0ff67613          	zext.b	a2,a2
     e8c:	bfb9                	j	dea <whisperPrintDecimal>
     e8e:	1101                	add	sp,sp,-32
     e90:	c84a                	sw	s2,16(sp)
     e92:	ce06                	sw	ra,28(sp)
     e94:	cc22                	sw	s0,24(sp)
     e96:	ca26                	sw	s1,20(sp)
     e98:	c64e                	sw	s3,12(sp)
     e9a:	c452                	sw	s4,8(sp)
     e9c:	47a1                	li	a5,8
     e9e:	892a                	mv	s2,a0
     ea0:	02f69f63          	bne	a3,a5,ede <whisperPrintInt+0x5c>
     ea4:	44f9                	li	s1,30
     ea6:	4781                	li	a5,0
     ea8:	4401                	li	s0,0
     eaa:	0fd00993          	li	s3,253
     eae:	00995533          	srl	a0,s2,s1
     eb2:	891d                	and	a0,a0,7
     eb4:	e111                	bnez	a0,eb8 <whisperPrintInt+0x36>
     eb6:	c791                	beqz	a5,ec2 <whisperPrintInt+0x40>
     eb8:	03050513          	add	a0,a0,48
     ebc:	3d85                	jal	d2c <whisperPutc>
     ebe:	0405                	add	s0,s0,1
     ec0:	4785                	li	a5,1
     ec2:	14f5                	add	s1,s1,-3
     ec4:	0ff4f493          	zext.b	s1,s1
     ec8:	ff3493e3          	bne	s1,s3,eae <whisperPrintInt+0x2c>
     ecc:	8522                	mv	a0,s0
     ece:	40f2                	lw	ra,28(sp)
     ed0:	4462                	lw	s0,24(sp)
     ed2:	44d2                	lw	s1,20(sp)
     ed4:	4942                	lw	s2,16(sp)
     ed6:	49b2                	lw	s3,12(sp)
     ed8:	4a22                	lw	s4,8(sp)
     eda:	6105                	add	sp,sp,32
     edc:	8082                	ret
     ede:	47c1                	li	a5,16
     ee0:	547d                	li	s0,-1
     ee2:	fef695e3          	bne	a3,a5,ecc <whisperPrintInt+0x4a>
     ee6:	44f1                	li	s1,28
     ee8:	4701                	li	a4,0
     eea:	4401                	li	s0,0
     eec:	4a25                	li	s4,9
     eee:	0fc00993          	li	s3,252
     ef2:	009957b3          	srl	a5,s2,s1
     ef6:	8bbd                	and	a5,a5,15
     ef8:	e791                	bnez	a5,f04 <whisperPrintInt+0x82>
     efa:	e311                	bnez	a4,efe <whisperPrintInt+0x7c>
     efc:	e899                	bnez	s1,f12 <whisperPrintInt+0x90>
     efe:	03078513          	add	a0,a5,48
     f02:	a029                	j	f0c <whisperPrintInt+0x8a>
     f04:	03778513          	add	a0,a5,55
     f08:	fefa7be3          	bgeu	s4,a5,efe <whisperPrintInt+0x7c>
     f0c:	3505                	jal	d2c <whisperPutc>
     f0e:	0405                	add	s0,s0,1
     f10:	4705                	li	a4,1
     f12:	14f1                	add	s1,s1,-4
     f14:	0ff4f493          	zext.b	s1,s1
     f18:	fd349de3          	bne	s1,s3,ef2 <whisperPrintInt+0x70>
     f1c:	bf45                	j	ecc <whisperPrintInt+0x4a>

00000f1e <whisperPrintfImpl>:
     f1e:	7179                	add	sp,sp,-48
     f20:	d422                	sw	s0,40(sp)
     f22:	d226                	sw	s1,36(sp)
     f24:	d04a                	sw	s2,32(sp)
     f26:	ce4e                	sw	s3,28(sp)
     f28:	cc52                	sw	s4,24(sp)
     f2a:	ca56                	sw	s5,20(sp)
     f2c:	c85a                	sw	s6,16(sp)
     f2e:	c65e                	sw	s7,12(sp)
     f30:	c462                	sw	s8,8(sp)
     f32:	d606                	sw	ra,44(sp)
     f34:	c266                	sw	s9,4(sp)
     f36:	c06a                	sw	s10,0(sp)
     f38:	842a                	mv	s0,a0
     f3a:	84ae                	mv	s1,a1
     f3c:	4901                	li	s2,0
     f3e:	02500993          	li	s3,37
     f42:	03000a93          	li	s5,48
     f46:	02d00b13          	li	s6,45
     f4a:	02a00b93          	li	s7,42
     f4e:	06f00a13          	li	s4,111
     f52:	07500c13          	li	s8,117
     f56:	00044503          	lbu	a0,0(s0)
     f5a:	e105                	bnez	a0,f7a <whisperPrintfImpl+0x5c>
     f5c:	50b2                	lw	ra,44(sp)
     f5e:	5422                	lw	s0,40(sp)
     f60:	854a                	mv	a0,s2
     f62:	5492                	lw	s1,36(sp)
     f64:	5902                	lw	s2,32(sp)
     f66:	49f2                	lw	s3,28(sp)
     f68:	4a62                	lw	s4,24(sp)
     f6a:	4ad2                	lw	s5,20(sp)
     f6c:	4b42                	lw	s6,16(sp)
     f6e:	4bb2                	lw	s7,12(sp)
     f70:	4c22                	lw	s8,8(sp)
     f72:	4c92                	lw	s9,4(sp)
     f74:	4d02                	lw	s10,0(sp)
     f76:	6145                	add	sp,sp,48
     f78:	8082                	ret
     f7a:	01350663          	beq	a0,s3,f86 <whisperPrintfImpl+0x68>
     f7e:	337d                	jal	d2c <whisperPutc>
     f80:	0905                	add	s2,s2,1
     f82:	0405                	add	s0,s0,1
     f84:	bfc9                	j	f56 <whisperPrintfImpl+0x38>
     f86:	00144703          	lbu	a4,1(s0)
     f8a:	db69                	beqz	a4,f5c <whisperPrintfImpl+0x3e>
     f8c:	0405                	add	s0,s0,1
     f8e:	02000793          	li	a5,32
     f92:	01371663          	bne	a4,s3,f9e <whisperPrintfImpl+0x80>
     f96:	854e                	mv	a0,s3
     f98:	756010ef          	jal	26ee <uart_tx>
     f9c:	b7dd                	j	f82 <whisperPrintfImpl+0x64>
     f9e:	863e                	mv	a2,a5
     fa0:	00044783          	lbu	a5,0(s0)
     fa4:	8722                	mv	a4,s0
     fa6:	0405                	add	s0,s0,1
     fa8:	ff578be3          	beq	a5,s5,f9e <whisperPrintfImpl+0x80>
     fac:	01678363          	beq	a5,s6,fb2 <whisperPrintfImpl+0x94>
     fb0:	843a                	mv	s0,a4
     fb2:	00044783          	lbu	a5,0(s0)
     fb6:	03779c63          	bne	a5,s7,fee <whisperPrintfImpl+0xd0>
     fba:	0405                	add	s0,s0,1
     fbc:	4581                	li	a1,0
     fbe:	00044783          	lbu	a5,0(s0)
     fc2:	0b478263          	beq	a5,s4,1066 <whisperPrintfImpl+0x148>
     fc6:	04fa6d63          	bltu	s4,a5,1020 <whisperPrintfImpl+0x102>
     fca:	06300713          	li	a4,99
     fce:	0ae78063          	beq	a5,a4,106e <whisperPrintfImpl+0x150>
     fd2:	06400713          	li	a4,100
     fd6:	06e78c63          	beq	a5,a4,104e <whisperPrintfImpl+0x130>
     fda:	05800713          	li	a4,88
     fde:	fae792e3          	bne	a5,a4,f82 <whisperPrintfImpl+0x64>
     fe2:	00448c93          	add	s9,s1,4
     fe6:	46c1                	li	a3,16
     fe8:	4088                	lw	a0,0(s1)
     fea:	3d61                	jal	e82 <whisperPrintInt>
     fec:	a0ad                	j	1056 <whisperPrintfImpl+0x138>
     fee:	fd078793          	add	a5,a5,-48
     ff2:	0ff7f793          	zext.b	a5,a5
     ff6:	4725                	li	a4,9
     ff8:	4581                	li	a1,0
     ffa:	fcf762e3          	bltu	a4,a5,fbe <whisperPrintfImpl+0xa0>
     ffe:	4829                	li	a6,10
    1000:	a029                	j	100a <whisperPrintfImpl+0xec>
    1002:	030585b3          	mul	a1,a1,a6
    1006:	842a                	mv	s0,a0
    1008:	95be                	add	a1,a1,a5
    100a:	00044783          	lbu	a5,0(s0)
    100e:	fd078793          	add	a5,a5,-48
    1012:	0ff7f693          	zext.b	a3,a5
    1016:	00140513          	add	a0,s0,1
    101a:	fed774e3          	bgeu	a4,a3,1002 <whisperPrintfImpl+0xe4>
    101e:	b745                	j	fbe <whisperPrintfImpl+0xa0>
    1020:	03878e63          	beq	a5,s8,105c <whisperPrintfImpl+0x13e>
    1024:	07800713          	li	a4,120
    1028:	fae78de3          	beq	a5,a4,fe2 <whisperPrintfImpl+0xc4>
    102c:	07300713          	li	a4,115
    1030:	f4e799e3          	bne	a5,a4,f82 <whisperPrintfImpl+0x64>
    1034:	00448d13          	add	s10,s1,4
    1038:	8cca                	mv	s9,s2
    103a:	4084                	lw	s1,0(s1)
    103c:	412c87b3          	sub	a5,s9,s2
    1040:	97a6                	add	a5,a5,s1
    1042:	0007c503          	lbu	a0,0(a5)
    1046:	e91d                	bnez	a0,107c <whisperPrintfImpl+0x15e>
    1048:	84ea                	mv	s1,s10
    104a:	8966                	mv	s2,s9
    104c:	bf1d                	j	f82 <whisperPrintfImpl+0x64>
    104e:	4088                	lw	a0,0(s1)
    1050:	00448c93          	add	s9,s1,4
    1054:	3b59                	jal	dea <whisperPrintDecimal>
    1056:	992a                	add	s2,s2,a0
    1058:	84e6                	mv	s1,s9
    105a:	b725                	j	f82 <whisperPrintfImpl+0x64>
    105c:	4088                	lw	a0,0(s1)
    105e:	00448c93          	add	s9,s1,4
    1062:	3b01                	jal	d72 <whisperPrintUnsigned>
    1064:	bfcd                	j	1056 <whisperPrintfImpl+0x138>
    1066:	00448c93          	add	s9,s1,4
    106a:	46a1                	li	a3,8
    106c:	bfb5                	j	fe8 <whisperPrintfImpl+0xca>
    106e:	0004c503          	lbu	a0,0(s1)
    1072:	00448c93          	add	s9,s1,4
    1076:	395d                	jal	d2c <whisperPutc>
    1078:	0905                	add	s2,s2,1
    107a:	bff9                	j	1058 <whisperPrintfImpl+0x13a>
    107c:	3945                	jal	d2c <whisperPutc>
    107e:	0c85                	add	s9,s9,1
    1080:	bf75                	j	103c <whisperPrintfImpl+0x11e>

00001082 <putchar>:
    1082:	0ff57513          	zext.b	a0,a0
    1086:	b15d                	j	d2c <whisperPutc>

00001088 <puts>:
    1088:	b1e1                	j	d50 <whisperPuts>

0000108a <printf>:
    108a:	7139                	add	sp,sp,-64
    108c:	d22e                	sw	a1,36(sp)
    108e:	104c                	add	a1,sp,36
    1090:	ce06                	sw	ra,28(sp)
    1092:	d432                	sw	a2,40(sp)
    1094:	d636                	sw	a3,44(sp)
    1096:	d83a                	sw	a4,48(sp)
    1098:	da3e                	sw	a5,52(sp)
    109a:	dc42                	sw	a6,56(sp)
    109c:	de46                	sw	a7,60(sp)
    109e:	c62e                	sw	a1,12(sp)
    10a0:	3dbd                	jal	f1e <whisperPrintfImpl>
    10a2:	40f2                	lw	ra,28(sp)
    10a4:	6121                	add	sp,sp,64
    10a6:	8082                	ret

000010a8 <check_spi_status>:
    10a8:	200006b7          	lui	a3,0x20000
    10ac:	1141                	add	sp,sp,-16
    10ae:	200007b7          	lui	a5,0x20000
    10b2:	30030637          	lui	a2,0x30030
    10b6:	68a9                	lui	a7,0xa
    10b8:	30030337          	lui	t1,0x30030
    10bc:	c422                	sw	s0,8(sp)
    10be:	06d1                	add	a3,a3,20 # 20000014 <_bss_lma_end+0x1fffab88>
    10c0:	4298                	lw	a4,0(a3)
    10c2:	c606                	sw	ra,12(sp)
    10c4:	5bc0                	lw	s0,52(a5)
    10c6:	03000fb7          	lui	t6,0x3000
    10ca:	01000f37          	lui	t5,0x1000
    10ce:	02878813          	add	a6,a5,40 # 20000028 <_bss_lma_end+0x1fffab9c>
    10d2:	64060613          	add	a2,a2,1600 # 30030640 <_bss_lma_end+0x3002b1b4>
    10d6:	c4088893          	add	a7,a7,-960 # 9c40 <_bss_lma_end+0x47b4>
    10da:	64830313          	add	t1,t1,1608 # 30030648 <_bss_lma_end+0x3002b1bc>
    10de:	01f777b3          	and	a5,a4,t6
    10e2:	07e79c63          	bne	a5,t5,115a <check_spi_status+0xb2>
    10e6:	200007b7          	lui	a5,0x20000
    10ea:	07d1                	add	a5,a5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    10ec:	00171693          	sll	a3,a4,0x1
    10f0:	0a06c263          	bltz	a3,1194 <check_spi_status+0xec>
    10f4:	439c                	lw	a5,0(a5)
    10f6:	cc31                	beqz	s0,1152 <check_spi_status+0xaa>
    10f8:	50010537          	lui	a0,0x50010
    10fc:	85a2                	mv	a1,s0
    10fe:	6c850513          	add	a0,a0,1736 # 500106c8 <__func__.0+0x1b8>
    1102:	3761                	jal	108a <printf>
    1104:	01047793          	and	a5,s0,16
    1108:	c791                	beqz	a5,1114 <check_spi_status+0x6c>
    110a:	50010537          	lui	a0,0x50010
    110e:	6e050513          	add	a0,a0,1760 # 500106e0 <__func__.0+0x1d0>
    1112:	3f9d                	jal	1088 <puts>
    1114:	00847793          	and	a5,s0,8
    1118:	c791                	beqz	a5,1124 <check_spi_status+0x7c>
    111a:	50010537          	lui	a0,0x50010
    111e:	6f450513          	add	a0,a0,1780 # 500106f4 <__func__.0+0x1e4>
    1122:	379d                	jal	1088 <puts>
    1124:	02047793          	and	a5,s0,32
    1128:	c791                	beqz	a5,1134 <check_spi_status+0x8c>
    112a:	50010537          	lui	a0,0x50010
    112e:	70450513          	add	a0,a0,1796 # 50010704 <__func__.0+0x1f4>
    1132:	3f99                	jal	1088 <puts>
    1134:	00247793          	and	a5,s0,2
    1138:	c791                	beqz	a5,1144 <check_spi_status+0x9c>
    113a:	50010537          	lui	a0,0x50010
    113e:	71850513          	add	a0,a0,1816 # 50010718 <__func__.0+0x208>
    1142:	3799                	jal	1088 <puts>
    1144:	0220000f          	fence	r,r
    1148:	0220000f          	fence	r,r
    114c:	200007b7          	lui	a5,0x20000
    1150:	dbc0                	sw	s0,52(a5)
    1152:	40b2                	lw	ra,12(sp)
    1154:	4422                	lw	s0,8(sp)
    1156:	0141                	add	sp,sp,16
    1158:	8082                	ret
    115a:	00082783          	lw	a5,0(a6)
    115e:	4208                	lw	a0,0(a2)
    1160:	01150733          	add	a4,a0,a7
    1164:	424c                	lw	a1,4(a2)
    1166:	00a737b3          	sltu	a5,a4,a0
    116a:	97ae                	add	a5,a5,a1
    116c:	00e32023          	sw	a4,0(t1)
    1170:	853a                	mv	a0,a4
    1172:	00f32223          	sw	a5,4(t1)
    1176:	00062e03          	lw	t3,0(a2)
    117a:	00462e83          	lw	t4,4(a2)
    117e:	00fee863          	bltu	t4,a5,118e <check_spi_status+0xe6>
    1182:	01d79463          	bne	a5,t4,118a <check_spi_status+0xe2>
    1186:	00ae6463          	bltu	t3,a0,118e <check_spi_status+0xe6>
    118a:	4298                	lw	a4,0(a3)
    118c:	bf89                	j	10de <check_spi_status+0x36>
    118e:	10500073          	wfi
    1192:	b7d5                	j	1176 <check_spi_status+0xce>
    1194:	4398                	lw	a4,0(a5)
    1196:	bf99                	j	10ec <check_spi_status+0x44>

00001198 <fifo_rx_wait>:
    1198:	200006b7          	lui	a3,0x20000
    119c:	3e900713          	li	a4,1001
    11a0:	06d1                	add	a3,a3,20 # 20000014 <_bss_lma_end+0x1fffab88>
    11a2:	429c                	lw	a5,0(a3)
    11a4:	83a1                	srl	a5,a5,0x8
    11a6:	177d                	add	a4,a4,-1
    11a8:	0ff7f793          	zext.b	a5,a5
    11ac:	c709                	beqz	a4,11b6 <fifo_rx_wait+0x1e>
    11ae:	fef51ae3          	bne	a0,a5,11a2 <fifo_rx_wait+0xa>
    11b2:	4501                	li	a0,0
    11b4:	8082                	ret
    11b6:	4505                	li	a0,1
    11b8:	8082                	ret

000011ba <spi_command_wait>:
    11ba:	200007b7          	lui	a5,0x20000
    11be:	07d1                	add	a5,a5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    11c0:	4398                	lw	a4,0(a5)
    11c2:	00171693          	sll	a3,a4,0x1
    11c6:	fe06dde3          	bgez	a3,11c0 <spi_command_wait+0x6>
    11ca:	8082                	ret

000011cc <set_spi_csid>:
    11cc:	0220000f          	fence	r,r
    11d0:	0220000f          	fence	r,r
    11d4:	200007b7          	lui	a5,0x20000
    11d8:	d388                	sw	a0,32(a5)
    11da:	8082                	ret

000011dc <write_tx_fifo>:
    11dc:	20000737          	lui	a4,0x20000
    11e0:	3e800793          	li	a5,1000
    11e4:	0751                	add	a4,a4,20 # 20000014 <_bss_lma_end+0x1fffab88>
    11e6:	4314                	lw	a3,0(a4)
    11e8:	17fd                	add	a5,a5,-1 # 1fffffff <_bss_lma_end+0x1fffab73>
    11ea:	cf91                	beqz	a5,1206 <write_tx_fifo+0x2a>
    11ec:	00269613          	sll	a2,a3,0x2
    11f0:	fe064be3          	bltz	a2,11e6 <write_tx_fifo+0xa>
    11f4:	0220000f          	fence	r,r
    11f8:	0220000f          	fence	r,r
    11fc:	200007b7          	lui	a5,0x20000
    1200:	d7c8                	sw	a0,44(a5)
    1202:	4501                	li	a0,0
    1204:	8082                	ret
    1206:	557d                	li	a0,-1
    1208:	8082                	ret

0000120a <spi_command>:
    120a:	20000737          	lui	a4,0x20000
    120e:	3e800793          	li	a5,1000
    1212:	0751                	add	a4,a4,20 # 20000014 <_bss_lma_end+0x1fffab88>
    1214:	00072803          	lw	a6,0(a4)
    1218:	17fd                	add	a5,a5,-1 # 1fffffff <_bss_lma_end+0x1fffab73>
    121a:	c399                	beqz	a5,1220 <spi_command+0x16>
    121c:	fe085ce3          	bgez	a6,1214 <spi_command+0xa>
    1220:	05a6                	sll	a1,a1,0x9
    1222:	062a                	sll	a2,a2,0xa
    1224:	8e4d                	or	a2,a2,a1
    1226:	8e49                	or	a2,a2,a0
    1228:	06b2                	sll	a3,a3,0xc
    122a:	8e55                	or	a2,a2,a3
    122c:	0220000f          	fence	r,r
    1230:	0220000f          	fence	r,r
    1234:	200007b7          	lui	a5,0x20000
    1238:	d3d0                	sw	a2,36(a5)
    123a:	8082                	ret

0000123c <spi_read_response>:
    123c:	200007b7          	lui	a5,0x20000
    1240:	3e800713          	li	a4,1000
    1244:	07d1                	add	a5,a5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    1246:	4394                	lw	a3,0(a5)
    1248:	00769613          	sll	a2,a3,0x7
    124c:	00064963          	bltz	a2,125e <spi_read_response+0x22>
    1250:	200007b7          	lui	a5,0x20000
    1254:	5788                	lw	a0,40(a5)
    1256:	8121                	srl	a0,a0,0x8
    1258:	0ff57513          	zext.b	a0,a0
    125c:	8082                	ret
    125e:	177d                	add	a4,a4,-1
    1260:	f37d                	bnez	a4,1246 <spi_read_response+0xa>
    1262:	0ff00513          	li	a0,255
    1266:	8082                	ret

00001268 <end_sim_if_qspi_disabled>:
    1268:	300307b7          	lui	a5,0x30030
    126c:	0e07a783          	lw	a5,224(a5) # 300300e0 <_bss_lma_end+0x3002ac54>
    1270:	8b89                	and	a5,a5,2
    1272:	e391                	bnez	a5,1276 <end_sim_if_qspi_disabled+0xe>
    1274:	a001                	j	1274 <end_sim_if_qspi_disabled+0xc>
    1276:	8082                	ret

00001278 <enable_spi_host>:
    1278:	0220000f          	fence	r,r
    127c:	0220000f          	fence	r,r
    1280:	a00007b7          	lui	a5,0xa0000
    1284:	20000737          	lui	a4,0x20000
    1288:	07f78793          	add	a5,a5,127 # a000007f <_tbs_der_store_end+0x4ffe105f>
    128c:	cb1c                	sw	a5,16(a4)
    128e:	8082                	ret

00001290 <init_qspi>:
    1290:	1141                	add	sp,sp,-16
    1292:	c606                	sw	ra,12(sp)
    1294:	3fd1                	jal	1268 <end_sim_if_qspi_disabled>
    1296:	40b2                	lw	ra,12(sp)
    1298:	0141                	add	sp,sp,16
    129a:	bff9                	j	1278 <enable_spi_host>

0000129c <configure_spi_host_slow>:
    129c:	200007b7          	lui	a5,0x20000
    12a0:	07f1                	add	a5,a5,28 # 2000001c <_bss_lma_end+0x1fffab90>
    12a2:	e501                	bnez	a0,12aa <configure_spi_host_slow+0xe>
    12a4:	200007b7          	lui	a5,0x20000
    12a8:	07e1                	add	a5,a5,24 # 20000018 <_bss_lma_end+0x1fffab8c>
    12aa:	0220000f          	fence	r,r
    12ae:	0220000f          	fence	r,r
    12b2:	c0000737          	lui	a4,0xc0000
    12b6:	03170713          	add	a4,a4,49 # c0000031 <_tbs_der_store_end+0x6ffe1011>
    12ba:	c398                	sw	a4,0(a5)
    12bc:	8082                	ret

000012be <sd_send_cmd>:
    12be:	715d                	add	sp,sp,-80
    12c0:	72fd                	lui	t0,0xfffff
    12c2:	c686                	sw	ra,76(sp)
    12c4:	c4a2                	sw	s0,72(sp)
    12c6:	c2a6                	sw	s1,68(sp)
    12c8:	de4e                	sw	s3,60(sp)
    12ca:	d462                	sw	s8,40(sp)
    12cc:	c0ca                	sw	s2,64(sp)
    12ce:	dc52                	sw	s4,56(sp)
    12d0:	da56                	sw	s5,52(sp)
    12d2:	d85a                	sw	s6,48(sp)
    12d4:	d65e                	sw	s7,44(sp)
    12d6:	d266                	sw	s9,36(sp)
    12d8:	d06a                	sw	s10,32(sp)
    12da:	ce6e                	sw	s11,28(sp)
    12dc:	842a                	mv	s0,a0
    12de:	9116                	add	sp,sp,t0
    12e0:	4501                	li	a0,0
    12e2:	89ae                	mv	s3,a1
    12e4:	8c32                	mv	s8,a2
    12e6:	84b6                	mv	s1,a3
    12e8:	35d5                	jal	11cc <set_spi_csid>
    12ea:	8522                	mv	a0,s0
    12ec:	3dc5                	jal	11dc <write_tx_fifo>
    12ee:	4689                	li	a3,2
    12f0:	4601                	li	a2,0
    12f2:	4585                	li	a1,1
    12f4:	4501                	li	a0,0
    12f6:	3f11                	jal	120a <spi_command>
    12f8:	0189d513          	srl	a0,s3,0x18
    12fc:	35c5                	jal	11dc <write_tx_fifo>
    12fe:	4689                	li	a3,2
    1300:	4601                	li	a2,0
    1302:	4585                	li	a1,1
    1304:	4501                	li	a0,0
    1306:	3711                	jal	120a <spi_command>
    1308:	0109d513          	srl	a0,s3,0x10
    130c:	3dc1                	jal	11dc <write_tx_fifo>
    130e:	4689                	li	a3,2
    1310:	4601                	li	a2,0
    1312:	4585                	li	a1,1
    1314:	4501                	li	a0,0
    1316:	3dd5                	jal	120a <spi_command>
    1318:	0089d513          	srl	a0,s3,0x8
    131c:	35c1                	jal	11dc <write_tx_fifo>
    131e:	4689                	li	a3,2
    1320:	4601                	li	a2,0
    1322:	4585                	li	a1,1
    1324:	4501                	li	a0,0
    1326:	35d5                	jal	120a <spi_command>
    1328:	854e                	mv	a0,s3
    132a:	3d4d                	jal	11dc <write_tx_fifo>
    132c:	4501                	li	a0,0
    132e:	4689                	li	a3,2
    1330:	4601                	li	a2,0
    1332:	4585                	li	a1,1
    1334:	3dd9                	jal	120a <spi_command>
    1336:	04000793          	li	a5,64
    133a:	09500513          	li	a0,149
    133e:	00f40a63          	beq	s0,a5,1352 <sd_send_cmd+0x94>
    1342:	04800793          	li	a5,72
    1346:	08700513          	li	a0,135
    134a:	00f40463          	beq	s0,a5,1352 <sd_send_cmd+0x94>
    134e:	0ff00513          	li	a0,255
    1352:	3569                	jal	11dc <write_tx_fifo>
    1354:	4689                	li	a3,2
    1356:	4601                	li	a2,0
    1358:	4585                	li	a1,1
    135a:	4501                	li	a0,0
    135c:	357d                	jal	120a <spi_command>
    135e:	3db1                	jal	11ba <spi_command_wait>
    1360:	05200793          	li	a5,82
    1364:	12f41e63          	bne	s0,a5,14a0 <sd_send_cmd+0x1e2>
    1368:	6605                	lui	a2,0x1
    136a:	4581                	li	a1,0
    136c:	0808                	add	a0,sp,16
    136e:	80a5                	srl	s1,s1,0x9
    1370:	433020ef          	jal	3fa2 <memset>
    1374:	04000413          	li	s0,64
    1378:	557d                	li	a0,-1
    137a:	147d                	add	s0,s0,-1
    137c:	3585                	jal	11dc <write_tx_fifo>
    137e:	fc6d                	bnez	s0,1378 <sd_send_cmd+0xba>
    1380:	468d                	li	a3,3
    1382:	4601                	li	a2,0
    1384:	4585                	li	a1,1
    1386:	0ff00513          	li	a0,255
    138a:	3541                	jal	120a <spi_command>
    138c:	4981                	li	s3,0
    138e:	3535                	jal	11ba <spi_command_wait>
    1390:	4a01                	li	s4,0
    1392:	40000a93          	li	s5,1024
    1396:	02999f63          	bne	s3,s1,13d4 <sd_send_cmd+0x116>
    139a:	4505                	li	a0,1
    139c:	3d05                	jal	11cc <set_spi_csid>
    139e:	0ff00513          	li	a0,255
    13a2:	3d2d                	jal	11dc <write_tx_fifo>
    13a4:	4689                	li	a3,2
    13a6:	4601                	li	a2,0
    13a8:	4581                	li	a1,0
    13aa:	4501                	li	a0,0
    13ac:	3db9                	jal	120a <spi_command>
    13ae:	4401                	li	s0,0
    13b0:	6285                	lui	t0,0x1
    13b2:	9116                	add	sp,sp,t0
    13b4:	40b6                	lw	ra,76(sp)
    13b6:	8522                	mv	a0,s0
    13b8:	4496                	lw	s1,68(sp)
    13ba:	4426                	lw	s0,72(sp)
    13bc:	4906                	lw	s2,64(sp)
    13be:	59f2                	lw	s3,60(sp)
    13c0:	5a62                	lw	s4,56(sp)
    13c2:	5ad2                	lw	s5,52(sp)
    13c4:	5b42                	lw	s6,48(sp)
    13c6:	5bb2                	lw	s7,44(sp)
    13c8:	5c22                	lw	s8,40(sp)
    13ca:	5c92                	lw	s9,36(sp)
    13cc:	5d02                	lw	s10,32(sp)
    13ce:	4df2                	lw	s11,28(sp)
    13d0:	6161                	add	sp,sp,80
    13d2:	8082                	ret
    13d4:	01010913          	add	s2,sp,16
    13d8:	20000b37          	lui	s6,0x20000
    13dc:	20000bb7          	lui	s7,0x20000
    13e0:	8d4a                	mv	s10,s2
    13e2:	4c81                	li	s9,0
    13e4:	0b51                	add	s6,s6,20 # 20000014 <_bss_lma_end+0x1fffab88>
    13e6:	028b8b93          	add	s7,s7,40 # 20000028 <_bss_lma_end+0x1fffab9c>
    13ea:	468d                	li	a3,3
    13ec:	4601                	li	a2,0
    13ee:	4585                	li	a1,1
    13f0:	0ff00513          	li	a0,255
    13f4:	3d19                	jal	120a <spi_command>
    13f6:	33d1                	jal	11ba <spi_command_wait>
    13f8:	04000513          	li	a0,64
    13fc:	3b71                	jal	1198 <fifo_rx_wait>
    13fe:	8dea                	mv	s11,s10
    1400:	4681                	li	a3,0
    1402:	000b2403          	lw	s0,0(s6)
    1406:	010007b7          	lui	a5,0x1000
    140a:	8c7d                	and	s0,s0,a5
    140c:	f87d                	bnez	s0,1402 <sd_send_cmd+0x144>
    140e:	000ba783          	lw	a5,0(s7)
    1412:	0ff7f613          	zext.b	a2,a5
    1416:	00cda023          	sw	a2,0(s11)
    141a:	0087d613          	srl	a2,a5,0x8
    141e:	0ff67613          	zext.b	a2,a2
    1422:	00cda223          	sw	a2,4(s11)
    1426:	0107d613          	srl	a2,a5,0x10
    142a:	0ff67613          	zext.b	a2,a2
    142e:	83e1                	srl	a5,a5,0x18
    1430:	00cda423          	sw	a2,8(s11)
    1434:	00fda623          	sw	a5,12(s11)
    1438:	557d                	li	a0,-1
    143a:	c636                	sw	a3,12(sp)
    143c:	3345                	jal	11dc <write_tx_fifo>
    143e:	46b2                	lw	a3,12(sp)
    1440:	0691                	add	a3,a3,4
    1442:	10000593          	li	a1,256
    1446:	0dc1                	add	s11,s11,16
    1448:	fab69de3          	bne	a3,a1,1402 <sd_send_cmd+0x144>
    144c:	9cae                	add	s9,s9,a1
    144e:	400d0d13          	add	s10,s10,1024
    1452:	f95c9ce3          	bne	s9,s5,13ea <sd_send_cmd+0x12c>
    1456:	0fe00793          	li	a5,254
    145a:	00092683          	lw	a3,0(s2)
    145e:	0405                	add	s0,s0,1
    1460:	02f68e63          	beq	a3,a5,149c <sd_send_cmd+0x1de>
    1464:	0911                	add	s2,s2,4
    1466:	ff541ae3          	bne	s0,s5,145a <sd_send_cmd+0x19c>
    146a:	468d                	li	a3,3
    146c:	4601                	li	a2,0
    146e:	4585                	li	a1,1
    1470:	0ff00513          	li	a0,255
    1474:	3b59                	jal	120a <spi_command>
    1476:	020a0163          	beqz	s4,1498 <sd_send_cmd+0x1da>
    147a:	200a0793          	add	a5,s4,512
    147e:	00faed63          	bltu	s5,a5,1498 <sd_send_cmd+0x1da>
    1482:	00999513          	sll	a0,s3,0x9
    1486:	010a0793          	add	a5,s4,16
    148a:	20000613          	li	a2,512
    148e:	002785b3          	add	a1,a5,sp
    1492:	9562                	add	a0,a0,s8
    1494:	3b7020ef          	jal	404a <memcpy>
    1498:	0985                	add	s3,s3,1
    149a:	bdf5                	j	1396 <sd_send_cmd+0xd8>
    149c:	8a22                	mv	s4,s0
    149e:	b7f1                	j	146a <sd_send_cmd+0x1ac>
    14a0:	05100793          	li	a5,81
    14a4:	1ef41163          	bne	s0,a5,1686 <sd_send_cmd+0x3c8>
    14a8:	40000613          	li	a2,1024
    14ac:	4581                	li	a1,0
    14ae:	0808                	add	a0,sp,16
    14b0:	2f3020ef          	jal	3fa2 <memset>
    14b4:	04000413          	li	s0,64
    14b8:	557d                	li	a0,-1
    14ba:	147d                	add	s0,s0,-1
    14bc:	3305                	jal	11dc <write_tx_fifo>
    14be:	fc6d                	bnez	s0,14b8 <sd_send_cmd+0x1fa>
    14c0:	468d                	li	a3,3
    14c2:	4601                	li	a2,0
    14c4:	4585                	li	a1,1
    14c6:	0ff00513          	li	a0,255
    14ca:	3381                	jal	120a <spi_command>
    14cc:	31fd                	jal	11ba <spi_command_wait>
    14ce:	100287b7          	lui	a5,0x10028
    14d2:	4f9c                	lw	a5,24(a5)
    14d4:	468d                	li	a3,3
    14d6:	4601                	li	a2,0
    14d8:	4585                	li	a1,1
    14da:	0ff00513          	li	a0,255
    14de:	3335                	jal	120a <spi_command>
    14e0:	39e9                	jal	11ba <spi_command_wait>
    14e2:	0800                	add	s0,sp,16
    14e4:	04000513          	li	a0,64
    14e8:	20000ab7          	lui	s5,0x20000
    14ec:	20000a37          	lui	s4,0x20000
    14f0:	3165                	jal	1198 <fifo_rx_wait>
    14f2:	10040993          	add	s3,s0,256
    14f6:	84a2                	mv	s1,s0
    14f8:	0ad1                	add	s5,s5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    14fa:	028a0a13          	add	s4,s4,40 # 20000028 <_bss_lma_end+0x1fffab9c>
    14fe:	000aa783          	lw	a5,0(s5)
    1502:	00779713          	sll	a4,a5,0x7
    1506:	fe074ce3          	bltz	a4,14fe <sd_send_cmd+0x240>
    150a:	000a2783          	lw	a5,0(s4)
    150e:	0087d713          	srl	a4,a5,0x8
    1512:	00f48023          	sb	a5,0(s1)
    1516:	00e480a3          	sb	a4,1(s1)
    151a:	0107d713          	srl	a4,a5,0x10
    151e:	83e1                	srl	a5,a5,0x18
    1520:	00e48123          	sb	a4,2(s1)
    1524:	00f481a3          	sb	a5,3(s1)
    1528:	557d                	li	a0,-1
    152a:	0491                	add	s1,s1,4
    152c:	3945                	jal	11dc <write_tx_fifo>
    152e:	fd3498e3          	bne	s1,s3,14fe <sd_send_cmd+0x240>
    1532:	468d                	li	a3,3
    1534:	4601                	li	a2,0
    1536:	4585                	li	a1,1
    1538:	0ff00513          	li	a0,255
    153c:	31f9                	jal	120a <spi_command>
    153e:	39b5                	jal	11ba <spi_command_wait>
    1540:	04000513          	li	a0,64
    1544:	20000ab7          	lui	s5,0x20000
    1548:	20000a37          	lui	s4,0x20000
    154c:	31b1                	jal	1198 <fifo_rx_wait>
    154e:	84a2                	mv	s1,s0
    1550:	0ad1                	add	s5,s5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    1552:	028a0a13          	add	s4,s4,40 # 20000028 <_bss_lma_end+0x1fffab9c>
    1556:	000aa783          	lw	a5,0(s5)
    155a:	00779713          	sll	a4,a5,0x7
    155e:	fe074ce3          	bltz	a4,1556 <sd_send_cmd+0x298>
    1562:	000a2783          	lw	a5,0(s4)
    1566:	0087d713          	srl	a4,a5,0x8
    156a:	10f48023          	sb	a5,256(s1)
    156e:	10e480a3          	sb	a4,257(s1)
    1572:	0107d713          	srl	a4,a5,0x10
    1576:	83e1                	srl	a5,a5,0x18
    1578:	10e48123          	sb	a4,258(s1)
    157c:	10f481a3          	sb	a5,259(s1)
    1580:	557d                	li	a0,-1
    1582:	0491                	add	s1,s1,4
    1584:	39a1                	jal	11dc <write_tx_fifo>
    1586:	fd3498e3          	bne	s1,s3,1556 <sd_send_cmd+0x298>
    158a:	468d                	li	a3,3
    158c:	4601                	li	a2,0
    158e:	4585                	li	a1,1
    1590:	0ff00513          	li	a0,255
    1594:	399d                	jal	120a <spi_command>
    1596:	3115                	jal	11ba <spi_command_wait>
    1598:	04000513          	li	a0,64
    159c:	20000ab7          	lui	s5,0x20000
    15a0:	20000a37          	lui	s4,0x20000
    15a4:	3ed5                	jal	1198 <fifo_rx_wait>
    15a6:	84a2                	mv	s1,s0
    15a8:	0ad1                	add	s5,s5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    15aa:	028a0a13          	add	s4,s4,40 # 20000028 <_bss_lma_end+0x1fffab9c>
    15ae:	000aa783          	lw	a5,0(s5)
    15b2:	00779713          	sll	a4,a5,0x7
    15b6:	fe074ce3          	bltz	a4,15ae <sd_send_cmd+0x2f0>
    15ba:	000a2783          	lw	a5,0(s4)
    15be:	0087d713          	srl	a4,a5,0x8
    15c2:	20f48023          	sb	a5,512(s1)
    15c6:	20e480a3          	sb	a4,513(s1)
    15ca:	0107d713          	srl	a4,a5,0x10
    15ce:	83e1                	srl	a5,a5,0x18
    15d0:	20e48123          	sb	a4,514(s1)
    15d4:	20f481a3          	sb	a5,515(s1)
    15d8:	557d                	li	a0,-1
    15da:	0491                	add	s1,s1,4
    15dc:	3101                	jal	11dc <write_tx_fifo>
    15de:	fd3498e3          	bne	s1,s3,15ae <sd_send_cmd+0x2f0>
    15e2:	468d                	li	a3,3
    15e4:	4601                	li	a2,0
    15e6:	4581                	li	a1,0
    15e8:	0ff00513          	li	a0,255
    15ec:	3939                	jal	120a <spi_command>
    15ee:	4505                	li	a0,1
    15f0:	3ef1                	jal	11cc <set_spi_csid>
    15f2:	36e1                	jal	11ba <spi_command_wait>
    15f4:	04000513          	li	a0,64
    15f8:	20000ab7          	lui	s5,0x20000
    15fc:	20000a37          	lui	s4,0x20000
    1600:	3e61                	jal	1198 <fifo_rx_wait>
    1602:	0ad1                	add	s5,s5,20 # 20000014 <_bss_lma_end+0x1fffab88>
    1604:	01000b37          	lui	s6,0x1000
    1608:	028a0a13          	add	s4,s4,40 # 20000028 <_bss_lma_end+0x1fffab9c>
    160c:	000aa483          	lw	s1,0(s5)
    1610:	0164f4b3          	and	s1,s1,s6
    1614:	fce5                	bnez	s1,160c <sd_send_cmd+0x34e>
    1616:	000a2783          	lw	a5,0(s4)
    161a:	0087d713          	srl	a4,a5,0x8
    161e:	30f40023          	sb	a5,768(s0)
    1622:	30e400a3          	sb	a4,769(s0)
    1626:	0107d713          	srl	a4,a5,0x10
    162a:	83e1                	srl	a5,a5,0x18
    162c:	30e40123          	sb	a4,770(s0)
    1630:	30f401a3          	sb	a5,771(s0)
    1634:	557d                	li	a0,-1
    1636:	0411                	add	s0,s0,4
    1638:	3655                	jal	11dc <write_tx_fifo>
    163a:	fd3419e3          	bne	s0,s3,160c <sd_send_cmd+0x34e>
    163e:	557d                	li	a0,-1
    1640:	3e71                	jal	11dc <write_tx_fifo>
    1642:	557d                	li	a0,-1
    1644:	3e61                	jal	11dc <write_tx_fifo>
    1646:	4689                	li	a3,2
    1648:	4581                	li	a1,0
    164a:	4601                	li	a2,0
    164c:	451d                	li	a0,7
    164e:	3e75                	jal	120a <spi_command>
    1650:	080c                	add	a1,sp,16
    1652:	0fe00693          	li	a3,254
    1656:	40000713          	li	a4,1024
    165a:	009587b3          	add	a5,a1,s1
    165e:	0007c603          	lbu	a2,0(a5) # 10028000 <_bss_lma_end+0x10022b74>
    1662:	87a6                	mv	a5,s1
    1664:	0485                	add	s1,s1,1
    1666:	00d61d63          	bne	a2,a3,1680 <sd_send_cmd+0x3c2>
    166a:	20178793          	add	a5,a5,513
    166e:	d4f760e3          	bltu	a4,a5,13ae <sd_send_cmd+0xf0>
    1672:	20000613          	li	a2,512
    1676:	95a6                	add	a1,a1,s1
    1678:	8562                	mv	a0,s8
    167a:	1d1020ef          	jal	404a <memcpy>
    167e:	bb05                	j	13ae <sd_send_cmd+0xf0>
    1680:	fce49de3          	bne	s1,a4,165a <sd_send_cmd+0x39c>
    1684:	b32d                	j	13ae <sd_send_cmd+0xf0>
    1686:	4685                	li	a3,1
    1688:	8536                	mv	a0,a3
    168a:	4601                	li	a2,0
    168c:	4581                	li	a1,0
    168e:	3eb5                	jal	120a <spi_command>
    1690:	4505                	li	a0,1
    1692:	3e2d                	jal	11cc <set_spi_csid>
    1694:	361d                	jal	11ba <spi_command_wait>
    1696:	365d                	jal	123c <spi_read_response>
    1698:	842a                	mv	s0,a0
    169a:	0ff00513          	li	a0,255
    169e:	3e3d                	jal	11dc <write_tx_fifo>
    16a0:	4689                	li	a3,2
    16a2:	4601                	li	a2,0
    16a4:	4581                	li	a1,0
    16a6:	4501                	li	a0,0
    16a8:	368d                	jal	120a <spi_command>
    16aa:	b319                	j	13b0 <sd_send_cmd+0xf2>

000016ac <sendpulse>:
    16ac:	1141                	add	sp,sp,-16
    16ae:	557d                	li	a0,-1
    16b0:	c606                	sw	ra,12(sp)
    16b2:	362d                	jal	11dc <write_tx_fifo>
    16b4:	40b2                	lw	ra,12(sp)
    16b6:	4689                	li	a3,2
    16b8:	4601                	li	a2,0
    16ba:	4581                	li	a1,0
    16bc:	450d                	li	a0,3
    16be:	0141                	add	sp,sp,16
    16c0:	b6a9                	j	120a <spi_command>

000016c2 <init_sd_card>:
    16c2:	1141                	add	sp,sp,-16
    16c4:	c606                	sw	ra,12(sp)
    16c6:	c422                	sw	s0,8(sp)
    16c8:	c226                	sw	s1,4(sp)
    16ca:	c04a                	sw	s2,0(sp)
    16cc:	3675                	jal	1278 <enable_spi_host>
    16ce:	4501                	li	a0,0
    16d0:	36f1                	jal	129c <configure_spi_host_slow>
    16d2:	4505                	li	a0,1
    16d4:	36e1                	jal	129c <configure_spi_host_slow>
    16d6:	4505                	li	a0,1
    16d8:	af5ff0ef          	jal	11cc <set_spi_csid>
    16dc:	4451                	li	s0,20
    16de:	37f9                	jal	16ac <sendpulse>
    16e0:	4905                	li	s2,1
    16e2:	37e9                	jal	16ac <sendpulse>
    16e4:	54fd                	li	s1,-1
    16e6:	37d9                	jal	16ac <sendpulse>
    16e8:	4681                	li	a3,0
    16ea:	4601                	li	a2,0
    16ec:	4581                	li	a1,0
    16ee:	04000513          	li	a0,64
    16f2:	36f1                	jal	12be <sd_send_cmd>
    16f4:	07251563          	bne	a0,s2,175e <init_sd_card+0x9c>
    16f8:	4485                	li	s1,1
    16fa:	4681                	li	a3,0
    16fc:	4601                	li	a2,0
    16fe:	1aa00593          	li	a1,426
    1702:	04800513          	li	a0,72
    1706:	3e65                	jal	12be <sd_send_cmd>
    1708:	06950763          	beq	a0,s1,1776 <init_sd_card+0xb4>
    170c:	fff40793          	add	a5,s0,-1
    1710:	e02d                	bnez	s0,1772 <init_sd_card+0xb0>
    1712:	4681                	li	a3,0
    1714:	4601                	li	a2,0
    1716:	4581                	li	a1,0
    1718:	06900513          	li	a0,105
    171c:	364d                	jal	12be <sd_send_cmd>
    171e:	00a4b433          	sltu	s0,s1,a0
    1722:	40800433          	neg	s0,s0
    1726:	fd847413          	and	s0,s0,-40
    172a:	06940413          	add	s0,s0,105
    172e:	3e800493          	li	s1,1000
    1732:	597d                	li	s2,-1
    1734:	4681                	li	a3,0
    1736:	4601                	li	a2,0
    1738:	4581                	li	a1,0
    173a:	8522                	mv	a0,s0
    173c:	3649                	jal	12be <sd_send_cmd>
    173e:	c92d                	beqz	a0,17b0 <init_sd_card+0xee>
    1740:	14fd                	add	s1,s1,-1
    1742:	ff2499e3          	bne	s1,s2,1734 <init_sd_card+0x72>
    1746:	4681                	li	a3,0
    1748:	4601                	li	a2,0
    174a:	20000593          	li	a1,512
    174e:	05000513          	li	a0,80
    1752:	36b5                	jal	12be <sd_send_cmd>
    1754:	00a03533          	snez	a0,a0
    1758:	40a00533          	neg	a0,a0
    175c:	a029                	j	1766 <init_sd_card+0xa4>
    175e:	147d                	add	s0,s0,-1
    1760:	f89414e3          	bne	s0,s1,16e8 <init_sd_card+0x26>
    1764:	557d                	li	a0,-1
    1766:	40b2                	lw	ra,12(sp)
    1768:	4422                	lw	s0,8(sp)
    176a:	4492                	lw	s1,4(sp)
    176c:	4902                	lw	s2,0(sp)
    176e:	0141                	add	sp,sp,16
    1770:	8082                	ret
    1772:	843e                	mv	s0,a5
    1774:	b759                	j	16fa <init_sd_card+0x38>
    1776:	3e900493          	li	s1,1001
    177a:	4405                	li	s0,1
    177c:	4681                	li	a3,0
    177e:	4601                	li	a2,0
    1780:	4581                	li	a1,0
    1782:	07700513          	li	a0,119
    1786:	b39ff0ef          	jal	12be <sd_send_cmd>
    178a:	02851163          	bne	a0,s0,17ac <init_sd_card+0xea>
    178e:	4681                	li	a3,0
    1790:	4601                	li	a2,0
    1792:	400005b7          	lui	a1,0x40000
    1796:	06900513          	li	a0,105
    179a:	b25ff0ef          	jal	12be <sd_send_cmd>
    179e:	c501                	beqz	a0,17a6 <init_sd_card+0xe4>
    17a0:	14fd                	add	s1,s1,-1
    17a2:	fce9                	bnez	s1,177c <init_sd_card+0xba>
    17a4:	4401                	li	s0,0
    17a6:	fff40513          	add	a0,s0,-1
    17aa:	bf75                	j	1766 <init_sd_card+0xa4>
    17ac:	f975                	bnez	a0,17a0 <init_sd_card+0xde>
    17ae:	bfdd                	j	17a4 <init_sd_card+0xe2>
    17b0:	d8d5                	beqz	s1,1764 <init_sd_card+0xa2>
    17b2:	bf51                	j	1746 <init_sd_card+0x84>

000017b4 <read_sd_card>:
    17b4:	1101                	add	sp,sp,-32
    17b6:	c64e                	sw	s3,12(sp)
    17b8:	89b6                	mv	s3,a3
    17ba:	cc22                	sw	s0,24(sp)
    17bc:	ca26                	sw	s1,20(sp)
    17be:	c84a                	sw	s2,16(sp)
    17c0:	ce06                	sw	ra,28(sp)
    17c2:	842a                	mv	s0,a0
    17c4:	84ae                	mv	s1,a1
    17c6:	8932                	mv	s2,a2
    17c8:	8e1ff0ef          	jal	10a8 <check_spi_status>
    17cc:	00099f63          	bnez	s3,17ea <read_sd_card+0x36>
    17d0:	4681                	li	a3,0
    17d2:	8626                	mv	a2,s1
    17d4:	85a2                	mv	a1,s0
    17d6:	05100513          	li	a0,81
    17da:	4462                	lw	s0,24(sp)
    17dc:	40f2                	lw	ra,28(sp)
    17de:	44d2                	lw	s1,20(sp)
    17e0:	4942                	lw	s2,16(sp)
    17e2:	49b2                	lw	s3,12(sp)
    17e4:	6105                	add	sp,sp,32
    17e6:	ad9ff06f          	j	12be <sd_send_cmd>
    17ea:	86ca                	mv	a3,s2
    17ec:	8626                	mv	a2,s1
    17ee:	85a2                	mv	a1,s0
    17f0:	05200513          	li	a0,82
    17f4:	b7dd                	j	17da <read_sd_card+0x26>

000017f6 <sha256_flow_produce>:
    17f6:	1141                	add	sp,sp,-16
    17f8:	10028737          	lui	a4,0x10028
    17fc:	c422                	sw	s0,8(sp)
    17fe:	c606                	sw	ra,12(sp)
    1800:	842e                	mv	s0,a1
    1802:	0761                	add	a4,a4,24 # 10028018 <_bss_lma_end+0x10022b8c>
    1804:	431c                	lw	a5,0(a4)
    1806:	8b85                	and	a5,a5,1
    1808:	dff5                	beqz	a5,1804 <sha256_flow_produce+0xe>
    180a:	100287b7          	lui	a5,0x10028
    180e:	10028737          	lui	a4,0x10028
    1812:	08078793          	add	a5,a5,128 # 10028080 <_bss_lma_end+0x10022bf4>
    1816:	0c070713          	add	a4,a4,192 # 100280c0 <_bss_lma_end+0x10022c34>
    181a:	86be                	mv	a3,a5
    181c:	4150                	lw	a2,4(a0)
    181e:	0791                	add	a5,a5,4
    1820:	c290                	sw	a2,0(a3)
    1822:	0511                	add	a0,a0,4
    1824:	fee79be3          	bne	a5,a4,181a <sha256_flow_produce+0x24>
    1828:	50010537          	lui	a0,0x50010
    182c:	040a                	sll	s0,s0,0x2
    182e:	72850513          	add	a0,a0,1832 # 50010728 <__func__.0+0x218>
    1832:	8811                	and	s0,s0,4
    1834:	855ff0ef          	jal	1088 <puts>
    1838:	00146413          	or	s0,s0,1
    183c:	0220000f          	fence	r,r
    1840:	0220000f          	fence	r,r
    1844:	100287b7          	lui	a5,0x10028
    1848:	cb80                	sw	s0,16(a5)
    184a:	01878713          	add	a4,a5,24 # 10028018 <_bss_lma_end+0x10022b8c>
    184e:	431c                	lw	a5,0(a4)
    1850:	8b89                	and	a5,a5,2
    1852:	dff5                	beqz	a5,184e <sha256_flow_produce+0x58>
    1854:	50010537          	lui	a0,0x50010
    1858:	73850513          	add	a0,a0,1848 # 50010738 <__func__.0+0x228>
    185c:	82dff0ef          	jal	1088 <puts>
    1860:	100287b7          	lui	a5,0x10028
    1864:	1007a783          	lw	a5,256(a5) # 10028100 <_bss_lma_end+0x10022c74>
    1868:	100287b7          	lui	a5,0x10028
    186c:	1047a783          	lw	a5,260(a5) # 10028104 <_bss_lma_end+0x10022c78>
    1870:	100287b7          	lui	a5,0x10028
    1874:	1087a783          	lw	a5,264(a5) # 10028108 <_bss_lma_end+0x10022c7c>
    1878:	100287b7          	lui	a5,0x10028
    187c:	10c7a783          	lw	a5,268(a5) # 1002810c <_bss_lma_end+0x10022c80>
    1880:	100287b7          	lui	a5,0x10028
    1884:	1107a783          	lw	a5,272(a5) # 10028110 <_bss_lma_end+0x10022c84>
    1888:	100287b7          	lui	a5,0x10028
    188c:	1147a783          	lw	a5,276(a5) # 10028114 <_bss_lma_end+0x10022c88>
    1890:	100287b7          	lui	a5,0x10028
    1894:	1187a783          	lw	a5,280(a5) # 10028118 <_bss_lma_end+0x10022c8c>
    1898:	40b2                	lw	ra,12(sp)
    189a:	4422                	lw	s0,8(sp)
    189c:	100287b7          	lui	a5,0x10028
    18a0:	11c7a783          	lw	a5,284(a5) # 1002811c <_bss_lma_end+0x10022c90>
    18a4:	0141                	add	sp,sp,16
    18a6:	8082                	ret

000018a8 <sha384_core>:
    18a8:	ff0107b7          	lui	a5,0xff010
    18ac:	d0010113          	add	sp,sp,-768
    18b0:	f0078793          	add	a5,a5,-256 # ff00ff00 <_tbs_der_store_end+0xaeff0ee0>
    18b4:	c0be                	sw	a5,64(sp)
    18b6:	00ff07b7          	lui	a5,0xff0
    18ba:	0ff78793          	add	a5,a5,255 # ff00ff <_bss_lma_end+0xfeac73>
    18be:	2f712023          	sw	s7,736(sp)
    18c2:	2e812e23          	sw	s0,764(sp)
    18c6:	2e912c23          	sw	s1,760(sp)
    18ca:	2f212a23          	sw	s2,756(sp)
    18ce:	2f312823          	sw	s3,752(sp)
    18d2:	2f412623          	sw	s4,748(sp)
    18d6:	2f512423          	sw	s5,744(sp)
    18da:	2f612223          	sw	s6,740(sp)
    18de:	2d812e23          	sw	s8,732(sp)
    18e2:	2d912c23          	sw	s9,728(sp)
    18e6:	2da12a23          	sw	s10,724(sp)
    18ea:	2db12823          	sw	s11,720(sp)
    18ee:	c4aa                	sw	a0,72(sp)
    18f0:	c6ae                	sw	a1,76(sp)
    18f2:	4b81                	li	s7,0
    18f4:	c2be                	sw	a5,68(sp)
    18f6:	47b6                	lw	a5,76(sp)
    18f8:	02fbed63          	bltu	s7,a5,1932 <sha384_core+0x8a>
    18fc:	2fc12403          	lw	s0,764(sp)
    1900:	2f812483          	lw	s1,760(sp)
    1904:	2f412903          	lw	s2,756(sp)
    1908:	2f012983          	lw	s3,752(sp)
    190c:	2ec12a03          	lw	s4,748(sp)
    1910:	2e812a83          	lw	s5,744(sp)
    1914:	2e412b03          	lw	s6,740(sp)
    1918:	2e012b83          	lw	s7,736(sp)
    191c:	2dc12c03          	lw	s8,732(sp)
    1920:	2d812c83          	lw	s9,728(sp)
    1924:	2d412d03          	lw	s10,724(sp)
    1928:	2d012d83          	lw	s11,720(sp)
    192c:	30010113          	add	sp,sp,768
    1930:	8082                	ret
    1932:	47a6                	lw	a5,72(sp)
    1934:	4581                	li	a1,0
    1936:	01778533          	add	a0,a5,s7
    193a:	00b507b3          	add	a5,a0,a1
    193e:	43d4                	lw	a3,4(a5)
    1940:	0007a803          	lw	a6,0(a5)
    1944:	0106d713          	srl	a4,a3,0x10
    1948:	01081793          	sll	a5,a6,0x10
    194c:	8fd9                	or	a5,a5,a4
    194e:	7741                	lui	a4,0xffff0
    1950:	8f7d                	and	a4,a4,a5
    1952:	01085813          	srl	a6,a6,0x10
    1956:	07c2                	sll	a5,a5,0x10
    1958:	01076733          	or	a4,a4,a6
    195c:	06c2                	sll	a3,a3,0x10
    195e:	83c1                	srl	a5,a5,0x10
    1960:	8fd5                	or	a5,a5,a3
    1962:	0186d813          	srl	a6,a3,0x18
    1966:	00871693          	sll	a3,a4,0x8
    196a:	4406                	lw	s0,64(sp)
    196c:	01871893          	sll	a7,a4,0x18
    1970:	00d866b3          	or	a3,a6,a3
    1974:	00879813          	sll	a6,a5,0x8
    1978:	83a1                	srl	a5,a5,0x8
    197a:	00887833          	and	a6,a6,s0
    197e:	8ee1                	and	a3,a3,s0
    1980:	00f8e7b3          	or	a5,a7,a5
    1984:	4416                	lw	s0,68(sp)
    1986:	8321                	srl	a4,a4,0x8
    1988:	8fe1                	and	a5,a5,s0
    198a:	8f61                	and	a4,a4,s0
    198c:	05058413          	add	s0,a1,80 # 40000050 <_bss_lma_end+0x3fffabc4>
    1990:	002408b3          	add	a7,s0,sp
    1994:	00f867b3          	or	a5,a6,a5
    1998:	8ed9                	or	a3,a3,a4
    199a:	00f8a023          	sw	a5,0(a7)
    199e:	00d8a223          	sw	a3,4(a7)
    19a2:	05a1                	add	a1,a1,8
    19a4:	08000793          	li	a5,128
    19a8:	f8f599e3          	bne	a1,a5,193a <sha384_core+0x92>
    19ac:	0894                	add	a3,sp,80
    19ae:	46cc                	lw	a1,12(a3)
    19b0:	4698                	lw	a4,8(a3)
    19b2:	00175813          	srl	a6,a4,0x1
    19b6:	01f59793          	sll	a5,a1,0x1f
    19ba:	0015d313          	srl	t1,a1,0x1
    19be:	0107e7b3          	or	a5,a5,a6
    19c2:	01f71813          	sll	a6,a4,0x1f
    19c6:	00686833          	or	a6,a6,t1
    19ca:	01859e13          	sll	t3,a1,0x18
    19ce:	00875313          	srl	t1,a4,0x8
    19d2:	006e6e33          	or	t3,t3,t1
    19d6:	0085de93          	srl	t4,a1,0x8
    19da:	01871313          	sll	t1,a4,0x18
    19de:	01d36333          	or	t1,t1,t4
    19e2:	00684833          	xor	a6,a6,t1
    19e6:	831d                	srl	a4,a4,0x7
    19e8:	01959313          	sll	t1,a1,0x19
    19ec:	00e36733          	or	a4,t1,a4
    19f0:	01c7c7b3          	xor	a5,a5,t3
    19f4:	819d                	srl	a1,a1,0x7
    19f6:	8fb9                	xor	a5,a5,a4
    19f8:	00b84833          	xor	a6,a6,a1
    19fc:	4298                	lw	a4,0(a3)
    19fe:	46ac                	lw	a1,72(a3)
    1a00:	04c6ae03          	lw	t3,76(a3)
    1a04:	0046a303          	lw	t1,4(a3)
    1a08:	95ba                	add	a1,a1,a4
    1a0a:	00e5b733          	sltu	a4,a1,a4
    1a0e:	9372                	add	t1,t1,t3
    1a10:	933a                	add	t1,t1,a4
    1a12:	95be                	add	a1,a1,a5
    1a14:	0746a883          	lw	a7,116(a3)
    1a18:	5aa8                	lw	a0,112(a3)
    1a1a:	00f5b7b3          	sltu	a5,a1,a5
    1a1e:	981a                	add	a6,a6,t1
    1a20:	01078733          	add	a4,a5,a6
    1a24:	01355813          	srl	a6,a0,0x13
    1a28:	00d89793          	sll	a5,a7,0xd
    1a2c:	0138d313          	srl	t1,a7,0x13
    1a30:	0107e7b3          	or	a5,a5,a6
    1a34:	00d51813          	sll	a6,a0,0xd
    1a38:	00686833          	or	a6,a6,t1
    1a3c:	01d8de13          	srl	t3,a7,0x1d
    1a40:	00351313          	sll	t1,a0,0x3
    1a44:	006e6e33          	or	t3,t3,t1
    1a48:	00389e93          	sll	t4,a7,0x3
    1a4c:	01d55313          	srl	t1,a0,0x1d
    1a50:	01d36333          	or	t1,t1,t4
    1a54:	00684833          	xor	a6,a6,t1
    1a58:	8119                	srl	a0,a0,0x6
    1a5a:	01a89313          	sll	t1,a7,0x1a
    1a5e:	00a36533          	or	a0,t1,a0
    1a62:	01c7c7b3          	xor	a5,a5,t3
    1a66:	8fa9                	xor	a5,a5,a0
    1a68:	0068d893          	srl	a7,a7,0x6
    1a6c:	97ae                	add	a5,a5,a1
    1a6e:	01184533          	xor	a0,a6,a7
    1a72:	00b7b5b3          	sltu	a1,a5,a1
    1a76:	972a                	add	a4,a4,a0
    1a78:	95ba                	add	a1,a1,a4
    1a7a:	08068713          	add	a4,a3,128
    1a7e:	c31c                	sw	a5,0(a4)
    1a80:	c34c                	sw	a1,4(a4)
    1a82:	06a1                	add	a3,a3,8
    1a84:	0c9c                	add	a5,sp,592
    1a86:	f2d794e3          	bne	a5,a3,19ae <sha384_core+0x106>
    1a8a:	425c                	lw	a5,4(a2)
    1a8c:	cc3e                	sw	a5,24(sp)
    1a8e:	465c                	lw	a5,12(a2)
    1a90:	ce3e                	sw	a5,28(sp)
    1a92:	4a5c                	lw	a5,20(a2)
    1a94:	d03e                	sw	a5,32(sp)
    1a96:	4e1c                	lw	a5,24(a2)
    1a98:	c23e                	sw	a5,4(sp)
    1a9a:	4e5c                	lw	a5,28(a2)
    1a9c:	d23e                	sw	a5,36(sp)
    1a9e:	521c                	lw	a5,32(a2)
    1aa0:	c43e                	sw	a5,8(sp)
    1aa2:	525c                	lw	a5,36(a2)
    1aa4:	d43e                	sw	a5,40(sp)
    1aa6:	561c                	lw	a5,40(a2)
    1aa8:	c63e                	sw	a5,12(sp)
    1aaa:	565c                	lw	a5,44(a2)
    1aac:	d63e                	sw	a5,44(sp)
    1aae:	5a1c                	lw	a5,48(a2)
    1ab0:	c83e                	sw	a5,16(sp)
    1ab2:	5a5c                	lw	a5,52(a2)
    1ab4:	d83e                	sw	a5,48(sp)
    1ab6:	5e1c                	lw	a5,56(a2)
    1ab8:	ca3e                	sw	a5,20(sp)
    1aba:	5e5c                	lw	a5,60(a2)
    1abc:	4204                	lw	s1,0(a2)
    1abe:	4600                	lw	s0,8(a2)
    1ac0:	01062383          	lw	t2,16(a2) # 1010 <whisperPrintfImpl+0xf2>
    1ac4:	da3e                	sw	a5,52(sp)
    1ac6:	4352                	lw	t1,20(sp)
    1ac8:	8d3e                	mv	s10,a5
    1aca:	4fc2                	lw	t6,16(sp)
    1acc:	5c42                	lw	s8,48(sp)
    1ace:	42b2                	lw	t0,12(sp)
    1ad0:	4792                	lw	a5,4(sp)
    1ad2:	dc3e                	sw	a5,56(sp)
    1ad4:	5792                	lw	a5,36(sp)
    1ad6:	5cb2                	lw	s9,44(sp)
    1ad8:	46a2                	lw	a3,8(sp)
    1ada:	5522                	lw	a0,40(sp)
    1adc:	de3e                	sw	a5,60(sp)
    1ade:	8e9e                	mv	t4,t2
    1ae0:	5982                	lw	s3,32(sp)
    1ae2:	8f22                	mv	t5,s0
    1ae4:	4a72                	lw	s4,28(sp)
    1ae6:	85a6                	mv	a1,s1
    1ae8:	48e2                	lw	a7,24(sp)
    1aea:	4a81                	li	s5,0
    1aec:	500117b7          	lui	a5,0x50011
    1af0:	88078713          	add	a4,a5,-1920 # 50010880 <k>
    1af4:	050a8793          	add	a5,s5,80
    1af8:	9756                	add	a4,a4,s5
    1afa:	00278e33          	add	t3,a5,sp
    1afe:	00472803          	lw	a6,4(a4) # ffff0004 <_tbs_der_store_end+0xaffd0fe4>
    1b02:	431c                	lw	a5,0(a4)
    1b04:	000e2703          	lw	a4,0(t3)
    1b08:	973e                	add	a4,a4,a5
    1b0a:	004e2e03          	lw	t3,4(t3)
    1b0e:	9872                	add	a6,a6,t3
    1b10:	00f737b3          	sltu	a5,a4,a5
    1b14:	fff6cb13          	not	s6,a3
    1b18:	97c2                	add	a5,a5,a6
    1b1a:	01fb7b33          	and	s6,s6,t6
    1b1e:	fff54913          	not	s2,a0
    1b22:	0056f833          	and	a6,a3,t0
    1b26:	01897933          	and	s2,s2,s8
    1b2a:	010b4833          	xor	a6,s6,a6
    1b2e:	01957e33          	and	t3,a0,s9
    1b32:	01c94e33          	xor	t3,s2,t3
    1b36:	983a                	add	a6,a6,a4
    1b38:	97f2                	add	a5,a5,t3
    1b3a:	00e83733          	sltu	a4,a6,a4
    1b3e:	973e                	add	a4,a4,a5
    1b40:	01251913          	sll	s2,a0,0x12
    1b44:	00e6d793          	srl	a5,a3,0xe
    1b48:	00f96933          	or	s2,s2,a5
    1b4c:	01269e13          	sll	t3,a3,0x12
    1b50:	00e55793          	srl	a5,a0,0xe
    1b54:	00fe6e33          	or	t3,t3,a5
    1b58:	00e51b13          	sll	s6,a0,0xe
    1b5c:	0126d793          	srl	a5,a3,0x12
    1b60:	00fb6b33          	or	s6,s6,a5
    1b64:	01255d93          	srl	s11,a0,0x12
    1b68:	00e69793          	sll	a5,a3,0xe
    1b6c:	01b7e7b3          	or	a5,a5,s11
    1b70:	01694933          	xor	s2,s2,s6
    1b74:	00fe4e33          	xor	t3,t3,a5
    1b78:	01769b13          	sll	s6,a3,0x17
    1b7c:	00955793          	srl	a5,a0,0x9
    1b80:	0167e7b3          	or	a5,a5,s6
    1b84:	01751d93          	sll	s11,a0,0x17
    1b88:	0096db13          	srl	s6,a3,0x9
    1b8c:	01bb6b33          	or	s6,s6,s11
    1b90:	00f947b3          	xor	a5,s2,a5
    1b94:	016e4e33          	xor	t3,t3,s6
    1b98:	97c2                	add	a5,a5,a6
    1b9a:	0107b833          	sltu	a6,a5,a6
    1b9e:	9772                	add	a4,a4,t3
    1ba0:	933e                	add	t1,t1,a5
    1ba2:	9742                	add	a4,a4,a6
    1ba4:	976a                	add	a4,a4,s10
    1ba6:	00f337b3          	sltu	a5,t1,a5
    1baa:	97ba                	add	a5,a5,a4
    1bac:	00489813          	sll	a6,a7,0x4
    1bb0:	01c5d713          	srl	a4,a1,0x1c
    1bb4:	00e86833          	or	a6,a6,a4
    1bb8:	00459e13          	sll	t3,a1,0x4
    1bbc:	01c8d713          	srl	a4,a7,0x1c
    1bc0:	00ee6e33          	or	t3,t3,a4
    1bc4:	0028d913          	srl	s2,a7,0x2
    1bc8:	01e59713          	sll	a4,a1,0x1e
    1bcc:	00e96933          	or	s2,s2,a4
    1bd0:	01e89b13          	sll	s6,a7,0x1e
    1bd4:	0025d713          	srl	a4,a1,0x2
    1bd8:	01676733          	or	a4,a4,s6
    1bdc:	01284833          	xor	a6,a6,s2
    1be0:	00ee4e33          	xor	t3,t3,a4
    1be4:	0078d913          	srl	s2,a7,0x7
    1be8:	01959713          	sll	a4,a1,0x19
    1bec:	00e96933          	or	s2,s2,a4
    1bf0:	01989b13          	sll	s6,a7,0x19
    1bf4:	0075d713          	srl	a4,a1,0x7
    1bf8:	01676733          	or	a4,a4,s6
    1bfc:	01df4d33          	xor	s10,t5,t4
    1c00:	00ee4e33          	xor	t3,t3,a4
    1c04:	00bd7d33          	and	s10,s10,a1
    1c08:	013a4b33          	xor	s6,s4,s3
    1c0c:	01df7733          	and	a4,t5,t4
    1c10:	01284833          	xor	a6,a6,s2
    1c14:	011b7b33          	and	s6,s6,a7
    1c18:	00ed4733          	xor	a4,s10,a4
    1c1c:	013a7933          	and	s2,s4,s3
    1c20:	012b4933          	xor	s2,s6,s2
    1c24:	9742                	add	a4,a4,a6
    1c26:	9e4a                	add	t3,t3,s2
    1c28:	01073833          	sltu	a6,a4,a6
    1c2c:	9872                	add	a6,a6,t3
    1c2e:	5e62                	lw	t3,56(sp)
    1c30:	01c30933          	add	s2,t1,t3
    1c34:	971a                	add	a4,a4,t1
    1c36:	5e72                	lw	t3,60(sp)
    1c38:	00693b33          	sltu	s6,s2,t1
    1c3c:	9e3e                	add	t3,t3,a5
    1c3e:	00673333          	sltu	t1,a4,t1
    1c42:	97c2                	add	a5,a5,a6
    1c44:	0aa1                	add	s5,s5,8
    1c46:	dc76                	sw	t4,56(sp)
    1c48:	de4e                	sw	s3,60(sp)
    1c4a:	28000813          	li	a6,640
    1c4e:	979a                	add	a5,a5,t1
    1c50:	9b72                	add	s6,s6,t3
    1c52:	837e                	mv	t1,t6
    1c54:	8d62                	mv	s10,s8
    1c56:	0b0a9063          	bne	s5,a6,1cf6 <sha384_core+0x44e>
    1c5a:	9726                	add	a4,a4,s1
    1c5c:	4862                	lw	a6,24(sp)
    1c5e:	009734b3          	sltu	s1,a4,s1
    1c62:	97c2                	add	a5,a5,a6
    1c64:	94be                	add	s1,s1,a5
    1c66:	95a2                	add	a1,a1,s0
    1c68:	47f2                	lw	a5,28(sp)
    1c6a:	97c6                	add	a5,a5,a7
    1c6c:	0085b433          	sltu	s0,a1,s0
    1c70:	943e                	add	s0,s0,a5
    1c72:	9f1e                	add	t5,t5,t2
    1c74:	5782                	lw	a5,32(sp)
    1c76:	97d2                	add	a5,a5,s4
    1c78:	007f33b3          	sltu	t2,t5,t2
    1c7c:	93be                	add	t2,t2,a5
    1c7e:	4792                	lw	a5,4(sp)
    1c80:	9ebe                	add	t4,t4,a5
    1c82:	c218                	sw	a4,0(a2)
    1c84:	5712                	lw	a4,36(sp)
    1c86:	974e                	add	a4,a4,s3
    1c88:	00feb7b3          	sltu	a5,t4,a5
    1c8c:	97ba                	add	a5,a5,a4
    1c8e:	ce5c                	sw	a5,28(a2)
    1c90:	47a2                	lw	a5,8(sp)
    1c92:	993e                	add	s2,s2,a5
    1c94:	5722                	lw	a4,40(sp)
    1c96:	975a                	add	a4,a4,s6
    1c98:	00f937b3          	sltu	a5,s2,a5
    1c9c:	97ba                	add	a5,a5,a4
    1c9e:	d25c                	sw	a5,36(a2)
    1ca0:	47b2                	lw	a5,12(sp)
    1ca2:	96be                	add	a3,a3,a5
    1ca4:	5732                	lw	a4,44(sp)
    1ca6:	972a                	add	a4,a4,a0
    1ca8:	00f6b7b3          	sltu	a5,a3,a5
    1cac:	97ba                	add	a5,a5,a4
    1cae:	d65c                	sw	a5,44(a2)
    1cb0:	47c2                	lw	a5,16(sp)
    1cb2:	92be                	add	t0,t0,a5
    1cb4:	5742                	lw	a4,48(sp)
    1cb6:	9766                	add	a4,a4,s9
    1cb8:	00f2b7b3          	sltu	a5,t0,a5
    1cbc:	97ba                	add	a5,a5,a4
    1cbe:	da5c                	sw	a5,52(a2)
    1cc0:	47d2                	lw	a5,20(sp)
    1cc2:	9fbe                	add	t6,t6,a5
    1cc4:	5752                	lw	a4,52(sp)
    1cc6:	00ffb7b3          	sltu	a5,t6,a5
    1cca:	9762                	add	a4,a4,s8
    1ccc:	97ba                	add	a5,a5,a4
    1cce:	c244                	sw	s1,4(a2)
    1cd0:	c60c                	sw	a1,8(a2)
    1cd2:	c640                	sw	s0,12(a2)
    1cd4:	01e62823          	sw	t5,16(a2)
    1cd8:	00762a23          	sw	t2,20(a2)
    1cdc:	01d62c23          	sw	t4,24(a2)
    1ce0:	03262023          	sw	s2,32(a2)
    1ce4:	d614                	sw	a3,40(a2)
    1ce6:	02562823          	sw	t0,48(a2)
    1cea:	03f62c23          	sw	t6,56(a2)
    1cee:	de5c                	sw	a5,60(a2)
    1cf0:	080b8b93          	add	s7,s7,128
    1cf4:	b109                	j	18f6 <sha384_core+0x4e>
    1cf6:	8f96                	mv	t6,t0
    1cf8:	8c66                	mv	s8,s9
    1cfa:	82b6                	mv	t0,a3
    1cfc:	8caa                	mv	s9,a0
    1cfe:	8efa                	mv	t4,t5
    1d00:	89d2                	mv	s3,s4
    1d02:	8f2e                	mv	t5,a1
    1d04:	8a46                	mv	s4,a7
    1d06:	86ca                	mv	a3,s2
    1d08:	855a                	mv	a0,s6
    1d0a:	85ba                	mv	a1,a4
    1d0c:	88be                	mv	a7,a5
    1d0e:	bbf9                	j	1aec <sha384_core+0x244>

00001d10 <sha384_digest>:
    1d10:	7129                	add	sp,sp,-320
    1d12:	12812c23          	sw	s0,312(sp)
    1d16:	01058413          	add	s0,a1,16
    1d1a:	13412423          	sw	s4,296(sp)
    1d1e:	13612023          	sw	s6,288(sp)
    1d22:	8a36                	mv	s4,a3
    1d24:	07f47b13          	and	s6,s0,127
    1d28:	08000693          	li	a3,128
    1d2c:	416686b3          	sub	a3,a3,s6
    1d30:	13312623          	sw	s3,300(sp)
    1d34:	07000993          	li	s3,112
    1d38:	00d9b9b3          	sltu	s3,s3,a3
    1d3c:	12912a23          	sw	s1,308(sp)
    1d40:	13212823          	sw	s2,304(sp)
    1d44:	11712e23          	sw	s7,284(sp)
    1d48:	099e                	sll	s3,s3,0x7
    1d4a:	12112e23          	sw	ra,316(sp)
    1d4e:	13512223          	sw	s5,292(sp)
    1d52:	11812c23          	sw	s8,280(sp)
    1d56:	8baa                	mv	s7,a0
    1d58:	84ae                	mv	s1,a1
    1d5a:	8932                	mv	s2,a2
    1d5c:	08098993          	add	s3,s3,128
    1d60:	9436                	add	s0,s0,a3
    1d62:	000a0b63          	beqz	s4,1d78 <sha384_digest+0x68>
    1d66:	50010537          	lui	a0,0x50010
    1d6a:	862e                	mv	a2,a1
    1d6c:	874e                	mv	a4,s3
    1d6e:	85a2                	mv	a1,s0
    1d70:	7ac50513          	add	a0,a0,1964 # 500107ac <__func__.0+0x29c>
    1d74:	b16ff0ef          	jal	108a <printf>
    1d78:	500117b7          	lui	a5,0x50011
    1d7c:	2b07a703          	lw	a4,688(a5) # 500112b0 <__func__.2+0x630>
    1d80:	2b47a783          	lw	a5,692(a5)
    1d84:	00f92223          	sw	a5,4(s2)
    1d88:	500117b7          	lui	a5,0x50011
    1d8c:	00e92023          	sw	a4,0(s2)
    1d90:	2b87a703          	lw	a4,696(a5) # 500112b8 <__func__.2+0x638>
    1d94:	2bc7a783          	lw	a5,700(a5)
    1d98:	00f92623          	sw	a5,12(s2)
    1d9c:	500117b7          	lui	a5,0x50011
    1da0:	00e92423          	sw	a4,8(s2)
    1da4:	2c07a703          	lw	a4,704(a5) # 500112c0 <__func__.2+0x640>
    1da8:	2c47a783          	lw	a5,708(a5)
    1dac:	00f92a23          	sw	a5,20(s2)
    1db0:	500117b7          	lui	a5,0x50011
    1db4:	00e92823          	sw	a4,16(s2)
    1db8:	2c87a703          	lw	a4,712(a5) # 500112c8 <__func__.2+0x648>
    1dbc:	2cc7a783          	lw	a5,716(a5)
    1dc0:	00f92e23          	sw	a5,28(s2)
    1dc4:	500117b7          	lui	a5,0x50011
    1dc8:	00e92c23          	sw	a4,24(s2)
    1dcc:	2d07a703          	lw	a4,720(a5) # 500112d0 <__func__.2+0x650>
    1dd0:	2d47a783          	lw	a5,724(a5)
    1dd4:	02f92223          	sw	a5,36(s2)
    1dd8:	500117b7          	lui	a5,0x50011
    1ddc:	02e92023          	sw	a4,32(s2)
    1de0:	2d87a703          	lw	a4,728(a5) # 500112d8 <__func__.2+0x658>
    1de4:	2dc7a783          	lw	a5,732(a5)
    1de8:	02f92623          	sw	a5,44(s2)
    1dec:	500117b7          	lui	a5,0x50011
    1df0:	02e92423          	sw	a4,40(s2)
    1df4:	2e07a703          	lw	a4,736(a5) # 500112e0 <__func__.2+0x660>
    1df8:	2e47a783          	lw	a5,740(a5)
    1dfc:	02f92a23          	sw	a5,52(s2)
    1e00:	500117b7          	lui	a5,0x50011
    1e04:	02e92823          	sw	a4,48(s2)
    1e08:	41340c33          	sub	s8,s0,s3
    1e0c:	2e87a703          	lw	a4,744(a5) # 500112e8 <__func__.2+0x668>
    1e10:	2ec7a783          	lw	a5,748(a5)
    1e14:	02e92c23          	sw	a4,56(s2)
    1e18:	02f92e23          	sw	a5,60(s2)
    1e1c:	864a                	mv	a2,s2
    1e1e:	85e2                	mv	a1,s8
    1e20:	855e                	mv	a0,s7
    1e22:	a87ff0ef          	jal	18a8 <sha384_core>
    1e26:	000a0863          	beqz	s4,1e36 <sha384_digest+0x126>
    1e2a:	50011537          	lui	a0,0x50011
    1e2e:	80050513          	add	a0,a0,-2048 # 50010800 <__func__.0+0x2f0>
    1e32:	a56ff0ef          	jal	1088 <puts>
    1e36:	40848433          	sub	s0,s1,s0
    1e3a:	944e                	add	s0,s0,s3
    1e3c:	01010a93          	add	s5,sp,16
    1e40:	8622                	mv	a2,s0
    1e42:	018b85b3          	add	a1,s7,s8
    1e46:	8556                	mv	a0,s5
    1e48:	202020ef          	jal	404a <memcpy>
    1e4c:	11040793          	add	a5,s0,272
    1e50:	978a                	add	a5,a5,sp
    1e52:	f8000713          	li	a4,-128
    1e56:	00140513          	add	a0,s0,1
    1e5a:	41640433          	sub	s0,s0,s6
    1e5e:	f0e78023          	sb	a4,-256(a5)
    1e62:	08840413          	add	s0,s0,136
    1e66:	4601                	li	a2,0
    1e68:	00a46663          	bltu	s0,a0,1e74 <sha384_digest+0x164>
    1e6c:	08700613          	li	a2,135
    1e70:	41660633          	sub	a2,a2,s6
    1e74:	4581                	li	a1,0
    1e76:	9556                	add	a0,a0,s5
    1e78:	12a020ef          	jal	3fa2 <memset>
    1e7c:	00349793          	sll	a5,s1,0x3
    1e80:	83c1                	srl	a5,a5,0x10
    1e82:	04ce                	sll	s1,s1,0x13
    1e84:	8cdd                	or	s1,s1,a5
    1e86:	ff010737          	lui	a4,0xff010
    1e8a:	00849793          	sll	a5,s1,0x8
    1e8e:	f0070713          	add	a4,a4,-256 # ff00ff00 <_tbs_der_store_end+0xaeff0ee0>
    1e92:	8ff9                	and	a5,a5,a4
    1e94:	00ff0737          	lui	a4,0xff0
    1e98:	80a1                	srl	s1,s1,0x8
    1e9a:	0ff70713          	add	a4,a4,255 # ff00ff <_bss_lma_end+0xfeac73>
    1e9e:	8cf9                	and	s1,s1,a4
    1ea0:	4621                	li	a2,8
    1ea2:	8fc5                	or	a5,a5,s1
    1ea4:	00c105b3          	add	a1,sp,a2
    1ea8:	008a8533          	add	a0,s5,s0
    1eac:	c402                	sw	zero,8(sp)
    1eae:	c63e                	sw	a5,12(sp)
    1eb0:	19a020ef          	jal	404a <memcpy>
    1eb4:	000a0863          	beqz	s4,1ec4 <sha384_digest+0x1b4>
    1eb8:	50011537          	lui	a0,0x50011
    1ebc:	83050513          	add	a0,a0,-2000 # 50010830 <__func__.0+0x320>
    1ec0:	9c8ff0ef          	jal	1088 <puts>
    1ec4:	864a                	mv	a2,s2
    1ec6:	85ce                	mv	a1,s3
    1ec8:	8556                	mv	a0,s5
    1eca:	9dfff0ef          	jal	18a8 <sha384_core>
    1ece:	020a0d63          	beqz	s4,1f08 <sha384_digest+0x1f8>
    1ed2:	13812403          	lw	s0,312(sp)
    1ed6:	50011537          	lui	a0,0x50011
    1eda:	13c12083          	lw	ra,316(sp)
    1ede:	13412483          	lw	s1,308(sp)
    1ee2:	13012903          	lw	s2,304(sp)
    1ee6:	12c12983          	lw	s3,300(sp)
    1eea:	12812a03          	lw	s4,296(sp)
    1eee:	12412a83          	lw	s5,292(sp)
    1ef2:	12012b03          	lw	s6,288(sp)
    1ef6:	11c12b83          	lw	s7,284(sp)
    1efa:	11812c03          	lw	s8,280(sp)
    1efe:	85050513          	add	a0,a0,-1968 # 50010850 <__func__.0+0x340>
    1f02:	6131                	add	sp,sp,320
    1f04:	984ff06f          	j	1088 <puts>
    1f08:	13c12083          	lw	ra,316(sp)
    1f0c:	13812403          	lw	s0,312(sp)
    1f10:	13412483          	lw	s1,308(sp)
    1f14:	13012903          	lw	s2,304(sp)
    1f18:	12c12983          	lw	s3,300(sp)
    1f1c:	12812a03          	lw	s4,296(sp)
    1f20:	12412a83          	lw	s5,292(sp)
    1f24:	12012b03          	lw	s6,288(sp)
    1f28:	11c12b83          	lw	s7,284(sp)
    1f2c:	11812c03          	lw	s8,280(sp)
    1f30:	6131                	add	sp,sp,320
    1f32:	8082                	ret

00001f34 <delay_second.constprop.0>:
    1f34:	300305b7          	lui	a1,0x30030
    1f38:	64058593          	add	a1,a1,1600 # 30030640 <_bss_lma_end+0x3002b1b4>
    1f3c:	02626737          	lui	a4,0x2626
    1f40:	4190                	lw	a2,0(a1)
    1f42:	a0070713          	add	a4,a4,-1536 # 2625a00 <_bss_lma_end+0x2620574>
    1f46:	9732                	add	a4,a4,a2
    1f48:	41d4                	lw	a3,4(a1)
    1f4a:	00c737b3          	sltu	a5,a4,a2
    1f4e:	863a                	mv	a2,a4
    1f50:	30030737          	lui	a4,0x30030
    1f54:	97b6                	add	a5,a5,a3
    1f56:	64c72423          	sw	a2,1608(a4) # 30030648 <_bss_lma_end+0x3002b1bc>
    1f5a:	64f72623          	sw	a5,1612(a4)
    1f5e:	0005a803          	lw	a6,0(a1)
    1f62:	0045a883          	lw	a7,4(a1)
    1f66:	00f8e763          	bltu	a7,a5,1f74 <delay_second.constprop.0+0x40>
    1f6a:	01179463          	bne	a5,a7,1f72 <delay_second.constprop.0+0x3e>
    1f6e:	00c86363          	bltu	a6,a2,1f74 <delay_second.constprop.0+0x40>
    1f72:	8082                	ret
    1f74:	10500073          	wfi
    1f78:	b7dd                	j	1f5e <delay_second.constprop.0+0x2a>

00001f7a <sha_init>:
    1f7a:	1141                	add	sp,sp,-16
    1f7c:	c422                	sw	s0,8(sp)
    1f7e:	842a                	mv	s0,a0
    1f80:	85aa                	mv	a1,a0
    1f82:	040a                	sll	s0,s0,0x2
    1f84:	50011537          	lui	a0,0x50011
    1f88:	b0050513          	add	a0,a0,-1280 # 50010b00 <k+0x280>
    1f8c:	8831                	and	s0,s0,12
    1f8e:	c606                	sw	ra,12(sp)
    1f90:	00146413          	or	s0,s0,1
    1f94:	8f6ff0ef          	jal	108a <printf>
    1f98:	0220000f          	fence	r,r
    1f9c:	0220000f          	fence	r,r
    1fa0:	100207b7          	lui	a5,0x10020
    1fa4:	cb80                	sw	s0,16(a5)
    1fa6:	40b2                	lw	ra,12(sp)
    1fa8:	4422                	lw	s0,8(sp)
    1faa:	0141                	add	sp,sp,16
    1fac:	8082                	ret

00001fae <sha_next>:
    1fae:	1141                	add	sp,sp,-16
    1fb0:	c422                	sw	s0,8(sp)
    1fb2:	842a                	mv	s0,a0
    1fb4:	85aa                	mv	a1,a0
    1fb6:	040a                	sll	s0,s0,0x2
    1fb8:	50011537          	lui	a0,0x50011
    1fbc:	b2450513          	add	a0,a0,-1244 # 50010b24 <k+0x2a4>
    1fc0:	8831                	and	s0,s0,12
    1fc2:	c606                	sw	ra,12(sp)
    1fc4:	00246413          	or	s0,s0,2
    1fc8:	8c2ff0ef          	jal	108a <printf>
    1fcc:	0220000f          	fence	r,r
    1fd0:	0220000f          	fence	r,r
    1fd4:	100207b7          	lui	a5,0x10020
    1fd8:	cb80                	sw	s0,16(a5)
    1fda:	40b2                	lw	ra,12(sp)
    1fdc:	4422                	lw	s0,8(sp)
    1fde:	0141                	add	sp,sp,16
    1fe0:	8082                	ret

00001fe2 <sha_next_last>:
    1fe2:	1141                	add	sp,sp,-16
    1fe4:	c422                	sw	s0,8(sp)
    1fe6:	842a                	mv	s0,a0
    1fe8:	85aa                	mv	a1,a0
    1fea:	040a                	sll	s0,s0,0x2
    1fec:	50011537          	lui	a0,0x50011
    1ff0:	b4850513          	add	a0,a0,-1208 # 50010b48 <k+0x2c8>
    1ff4:	8831                	and	s0,s0,12
    1ff6:	c606                	sw	ra,12(sp)
    1ff8:	02246413          	or	s0,s0,34
    1ffc:	88eff0ef          	jal	108a <printf>
    2000:	0220000f          	fence	r,r
    2004:	0220000f          	fence	r,r
    2008:	100207b7          	lui	a5,0x10020
    200c:	cb80                	sw	s0,16(a5)
    200e:	40b2                	lw	ra,12(sp)
    2010:	4422                	lw	s0,8(sp)
    2012:	0141                	add	sp,sp,16
    2014:	8082                	ret

00002016 <sha512_flow_produce>:
    2016:	7115                	add	sp,sp,-224
    2018:	cba6                	sw	s1,212(sp)
    201a:	c5d2                	sw	s4,200(sp)
    201c:	84ae                	mv	s1,a1
    201e:	c1da                	sw	s6,192(sp)
    2020:	8a32                	mv	s4,a2
    2022:	8b2a                	mv	s6,a0
    2024:	08000613          	li	a2,128
    2028:	4581                	li	a1,0
    202a:	1008                	add	a0,sp,32
    202c:	cda2                	sw	s0,216(sp)
    202e:	c9ca                	sw	s2,208(sp)
    2030:	c7ce                	sw	s3,204(sp)
    2032:	c3d6                	sw	s5,196(sp)
    2034:	df5e                	sw	s7,188(sp)
    2036:	cf86                	sw	ra,220(sp)
    2038:	dd62                	sw	s8,184(sp)
    203a:	db66                	sw	s9,180(sp)
    203c:	d96a                	sw	s10,176(sp)
    203e:	d76e                	sw	s11,172(sp)
    2040:	c802                	sw	zero,16(sp)
    2042:	ca02                	sw	zero,20(sp)
    2044:	cc02                	sw	zero,24(sp)
    2046:	ce02                	sw	zero,28(sp)
    2048:	01d4da93          	srl	s5,s1,0x1d
    204c:	757010ef          	jal	3fa2 <memset>
    2050:	00349b93          	sll	s7,s1,0x3
    2054:	01010913          	add	s2,sp,16
    2058:	4401                	li	s0,0
    205a:	04000993          	li	s3,64
    205e:	8622                	mv	a2,s0
    2060:	855e                	mv	a0,s7
    2062:	85d6                	mv	a1,s5
    2064:	64b010ef          	jal	3eae <__lshrdi3>
    2068:	00a907a3          	sb	a0,15(s2)
    206c:	0421                	add	s0,s0,8
    206e:	197d                	add	s2,s2,-1
    2070:	ff3417e3          	bne	s0,s3,205e <sha512_flow_produce+0x48>
    2074:	09048993          	add	s3,s1,144
    2078:	10020737          	lui	a4,0x10020
    207c:	f809f993          	and	s3,s3,-128
    2080:	0761                	add	a4,a4,24 # 10020018 <_bss_lma_end+0x1001ab8c>
    2082:	431c                	lw	a5,0(a4)
    2084:	8b85                	and	a5,a5,1
    2086:	dff5                	beqz	a5,2082 <sha512_flow_produce+0x6c>
    2088:	450d                	li	a0,3
    208a:	3dc5                	jal	1f7a <sha_init>
    208c:	4a81                	li	s5,0
    208e:	4b81                	li	s7,0
    2090:	4401                	li	s0,0
    2092:	08000c13          	li	s8,128
    2096:	f8000c93          	li	s9,-128
    209a:	07f00d13          	li	s10,127
    209e:	4dbd                	li	s11,15
    20a0:	01347c63          	bgeu	s0,s3,20b8 <sha512_flow_produce+0xa2>
    20a4:	08000613          	li	a2,128
    20a8:	4581                	li	a1,0
    20aa:	1008                	add	a0,sp,32
    20ac:	6f7010ef          	jal	3fa2 <memset>
    20b0:	408487b3          	sub	a5,s1,s0
    20b4:	04f4f763          	bgeu	s1,a5,2102 <sha512_flow_produce+0xec>
    20b8:	3db5                	jal	1f34 <delay_second.constprop.0>
    20ba:	100207b7          	lui	a5,0x10020
    20be:	effe0637          	lui	a2,0xeffe0
    20c2:	10020737          	lui	a4,0x10020
    20c6:	10078793          	add	a5,a5,256 # 10020100 <_bss_lma_end+0x1001ac74>
    20ca:	efc60613          	add	a2,a2,-260 # effdfefc <_tbs_der_store_end+0x9ffc0edc>
    20ce:	14070713          	add	a4,a4,320 # 10020140 <_bss_lma_end+0x1001acb4>
    20d2:	86be                	mv	a3,a5
    20d4:	0791                	add	a5,a5,4
    20d6:	428c                	lw	a1,0(a3)
    20d8:	00c786b3          	add	a3,a5,a2
    20dc:	96d2                	add	a3,a3,s4
    20de:	c28c                	sw	a1,0(a3)
    20e0:	fee799e3          	bne	a5,a4,20d2 <sha512_flow_produce+0xbc>
    20e4:	40fe                	lw	ra,220(sp)
    20e6:	446e                	lw	s0,216(sp)
    20e8:	44de                	lw	s1,212(sp)
    20ea:	494e                	lw	s2,208(sp)
    20ec:	49be                	lw	s3,204(sp)
    20ee:	4a2e                	lw	s4,200(sp)
    20f0:	4a9e                	lw	s5,196(sp)
    20f2:	4b0e                	lw	s6,192(sp)
    20f4:	5bfa                	lw	s7,188(sp)
    20f6:	5c6a                	lw	s8,184(sp)
    20f8:	5cda                	lw	s9,180(sp)
    20fa:	5d4a                	lw	s10,176(sp)
    20fc:	5dba                	lw	s11,172(sp)
    20fe:	612d                	add	sp,sp,224
    2100:	8082                	ret
    2102:	cfbd                	beqz	a5,2180 <sha512_flow_produce+0x16a>
    2104:	893e                	mv	s2,a5
    2106:	00fc7463          	bgeu	s8,a5,210e <sha512_flow_produce+0xf8>
    210a:	08000913          	li	s2,128
    210e:	008b05b3          	add	a1,s6,s0
    2112:	864a                	mv	a2,s2
    2114:	1008                	add	a0,sp,32
    2116:	c63e                	sw	a5,12(sp)
    2118:	733010ef          	jal	404a <memcpy>
    211c:	47b2                	lw	a5,12(sp)
    211e:	944a                	add	s0,s0,s2
    2120:	02fd6463          	bltu	s10,a5,2148 <sha512_flow_produce+0x132>
    2124:	09090793          	add	a5,s2,144
    2128:	0818                	add	a4,sp,16
    212a:	97ba                	add	a5,a5,a4
    212c:	f9978023          	sb	s9,-128(a5)
    2130:	412d0933          	sub	s2,s10,s2
    2134:	4b85                	li	s7,1
    2136:	012df963          	bgeu	s11,s2,2148 <sha512_flow_produce+0x132>
    213a:	4641                	li	a2,16
    213c:	85ba                	mv	a1,a4
    213e:	0908                	add	a0,sp,144
    2140:	70b010ef          	jal	404a <memcpy>
    2144:	08040413          	add	s0,s0,128
    2148:	100207b7          	lui	a5,0x10020
    214c:	10020737          	lui	a4,0x10020
    2150:	1014                	add	a3,sp,32
    2152:	08078793          	add	a5,a5,128 # 10020080 <_bss_lma_end+0x1001abf4>
    2156:	10070713          	add	a4,a4,256 # 10020100 <_bss_lma_end+0x1001ac74>
    215a:	863e                	mv	a2,a5
    215c:	428c                	lw	a1,0(a3)
    215e:	0791                	add	a5,a5,4
    2160:	c20c                	sw	a1,0(a2)
    2162:	0691                	add	a3,a3,4
    2164:	fee79be3          	bne	a5,a4,215a <sha512_flow_produce+0x144>
    2168:	450d                	li	a0,3
    216a:	020a9563          	bnez	s5,2194 <sha512_flow_produce+0x17e>
    216e:	3531                	jal	1f7a <sha_init>
    2170:	10020737          	lui	a4,0x10020
    2174:	0a85                	add	s5,s5,1
    2176:	0761                	add	a4,a4,24 # 10020018 <_bss_lma_end+0x1001ab8c>
    2178:	431c                	lw	a5,0(a4)
    217a:	8b89                	and	a5,a5,2
    217c:	dff5                	beqz	a5,2178 <sha512_flow_produce+0x162>
    217e:	b70d                	j	20a0 <sha512_flow_produce+0x8a>
    2180:	000b8463          	beqz	s7,2188 <sha512_flow_produce+0x172>
    2184:	01849463          	bne	s1,s8,218c <sha512_flow_produce+0x176>
    2188:	03910023          	sb	s9,32(sp)
    218c:	4641                	li	a2,16
    218e:	00c105b3          	add	a1,sp,a2
    2192:	b775                	j	213e <sha512_flow_produce+0x128>
    2194:	01347463          	bgeu	s0,s3,219c <sha512_flow_produce+0x186>
    2198:	3d19                	jal	1fae <sha_next>
    219a:	bfd9                	j	2170 <sha512_flow_produce+0x15a>
    219c:	3599                	jal	1fe2 <sha_next_last>
    219e:	bfc9                	j	2170 <sha512_flow_produce+0x15a>

000021a0 <measure_soc>:
    21a0:	712d                	add	sp,sp,-288
    21a2:	11212823          	sw	s2,272(sp)
    21a6:	11612023          	sw	s6,256(sp)
    21aa:	892e                	mv	s2,a1
    21ac:	08000613          	li	a2,128
    21b0:	4581                	li	a1,0
    21b2:	8b2a                	mv	s6,a0
    21b4:	1088                	add	a0,sp,96
    21b6:	10112e23          	sw	ra,284(sp)
    21ba:	10812c23          	sw	s0,280(sp)
    21be:	10912a23          	sw	s1,276(sp)
    21c2:	11312623          	sw	s3,268(sp)
    21c6:	11412423          	sw	s4,264(sp)
    21ca:	11512223          	sw	s5,260(sp)
    21ce:	dfde                	sw	s7,252(sp)
    21d0:	dde2                	sw	s8,248(sp)
    21d2:	dbe6                	sw	s9,244(sp)
    21d4:	d9ea                	sw	s10,240(sp)
    21d6:	d7ee                	sw	s11,236(sp)
    21d8:	c802                	sw	zero,16(sp)
    21da:	ca02                	sw	zero,20(sp)
    21dc:	cc02                	sw	zero,24(sp)
    21de:	ce02                	sw	zero,28(sp)
    21e0:	1000                	add	s0,sp,32
    21e2:	5c1010ef          	jal	3fa2 <memset>
    21e6:	04000613          	li	a2,64
    21ea:	4581                	li	a1,0
    21ec:	8522                	mv	a0,s0
    21ee:	5b5010ef          	jal	3fa2 <memset>
    21f2:	500115b7          	lui	a1,0x50011
    21f6:	50010537          	lui	a0,0x50010
    21fa:	13f00613          	li	a2,319
    21fe:	c8058593          	add	a1,a1,-896 # 50010c80 <__func__.2>
    2202:	16450513          	add	a0,a0,356 # 50010164 <trap_msg+0x7c>
    2206:	e85fe0ef          	jal	108a <printf>
    220a:	01d95a93          	srl	s5,s2,0x1d
    220e:	00391b93          	sll	s7,s2,0x3
    2212:	01010993          	add	s3,sp,16
    2216:	4481                	li	s1,0
    2218:	04000a13          	li	s4,64
    221c:	8626                	mv	a2,s1
    221e:	855e                	mv	a0,s7
    2220:	85d6                	mv	a1,s5
    2222:	48d010ef          	jal	3eae <__lshrdi3>
    2226:	00a987a3          	sb	a0,15(s3)
    222a:	04a1                	add	s1,s1,8
    222c:	19fd                	add	s3,s3,-1
    222e:	ff4497e3          	bne	s1,s4,221c <measure_soc+0x7c>
    2232:	09090a13          	add	s4,s2,144
    2236:	10020737          	lui	a4,0x10020
    223a:	f80a7a13          	and	s4,s4,-128
    223e:	0761                	add	a4,a4,24 # 10020018 <_bss_lma_end+0x1001ab8c>
    2240:	431c                	lw	a5,0(a4)
    2242:	8b85                	and	a5,a5,1
    2244:	dff5                	beqz	a5,2240 <measure_soc+0xa0>
    2246:	450d                	li	a0,3
    2248:	3b0d                	jal	1f7a <sha_init>
    224a:	4a81                	li	s5,0
    224c:	4b81                	li	s7,0
    224e:	4481                	li	s1,0
    2250:	08000c13          	li	s8,128
    2254:	f8000c93          	li	s9,-128
    2258:	07f00d13          	li	s10,127
    225c:	4dbd                	li	s11,15
    225e:	0144fc63          	bgeu	s1,s4,2276 <measure_soc+0xd6>
    2262:	08000613          	li	a2,128
    2266:	4581                	li	a1,0
    2268:	1088                	add	a0,sp,96
    226a:	539010ef          	jal	3fa2 <memset>
    226e:	409907b3          	sub	a5,s2,s1
    2272:	0ef97c63          	bgeu	s2,a5,236a <measure_soc+0x1ca>
    2276:	397d                	jal	1f34 <delay_second.constprop.0>
    2278:	100207b7          	lui	a5,0x10020
    227c:	10020737          	lui	a4,0x10020
    2280:	8922                	mv	s2,s0
    2282:	86a2                	mv	a3,s0
    2284:	10078793          	add	a5,a5,256 # 10020100 <_bss_lma_end+0x1001ac74>
    2288:	14070713          	add	a4,a4,320 # 10020140 <_bss_lma_end+0x1001acb4>
    228c:	863e                	mv	a2,a5
    228e:	4210                	lw	a2,0(a2)
    2290:	c290                	sw	a2,0(a3)
    2292:	0791                	add	a5,a5,4
    2294:	0691                	add	a3,a3,4
    2296:	fee79be3          	bne	a5,a4,228c <measure_soc+0xec>
    229a:	50011537          	lui	a0,0x50011
    229e:	b7450513          	add	a0,a0,-1164 # 50010b74 <k+0x2f4>
    22a2:	de7fe0ef          	jal	1088 <puts>
    22a6:	04040493          	add	s1,s0,64
    22aa:	500119b7          	lui	s3,0x50011
    22ae:	400c                	lw	a1,0(s0)
    22b0:	b9098513          	add	a0,s3,-1136 # 50010b90 <k+0x310>
    22b4:	0411                	add	s0,s0,4
    22b6:	dd5fe0ef          	jal	108a <printf>
    22ba:	fe849ae3          	bne	s1,s0,22ae <measure_soc+0x10e>
    22be:	4529                	li	a0,10
    22c0:	dc3fe0ef          	jal	1082 <putchar>
    22c4:	50010437          	lui	s0,0x50010
    22c8:	50011537          	lui	a0,0x50011
    22cc:	00040493          	mv	s1,s0
    22d0:	b9850513          	add	a0,a0,-1128 # 50010b98 <k+0x318>
    22d4:	db5fe0ef          	jal	1088 <puts>
    22d8:	04048a13          	add	s4,s1,64
    22dc:	00040413          	mv	s0,s0
    22e0:	400c                	lw	a1,0(s0)
    22e2:	b9098513          	add	a0,s3,-1136
    22e6:	0411                	add	s0,s0,4 # 50010004 <SOC_expected_digest+0x4>
    22e8:	da3fe0ef          	jal	108a <printf>
    22ec:	ff441ae3          	bne	s0,s4,22e0 <measure_soc+0x140>
    22f0:	4529                	li	a0,10
    22f2:	d91fe0ef          	jal	1082 <putchar>
    22f6:	50011537          	lui	a0,0x50011
    22fa:	bb450513          	add	a0,a0,-1100 # 50010bb4 <k+0x334>
    22fe:	d8bfe0ef          	jal	1088 <puts>
    2302:	4401                	li	s0,0
    2304:	4785                	li	a5,1
    2306:	50011a37          	lui	s4,0x50011
    230a:	49c1                	li	s3,16
    230c:	00092603          	lw	a2,0(s2)
    2310:	4094                	lw	a3,0(s1)
    2312:	00d60863          	beq	a2,a3,2322 <measure_soc+0x182>
    2316:	85a2                	mv	a1,s0
    2318:	bd0a0513          	add	a0,s4,-1072 # 50010bd0 <k+0x350>
    231c:	d6ffe0ef          	jal	108a <printf>
    2320:	4781                	li	a5,0
    2322:	0405                	add	s0,s0,1
    2324:	0911                	add	s2,s2,4
    2326:	0491                	add	s1,s1,4
    2328:	ff3412e3          	bne	s0,s3,230c <measure_soc+0x16c>
    232c:	c3ed                	beqz	a5,240e <measure_soc+0x26e>
    232e:	50011537          	lui	a0,0x50011
    2332:	c1050513          	add	a0,a0,-1008 # 50010c10 <k+0x390>
    2336:	d53fe0ef          	jal	1088 <puts>
    233a:	4501                	li	a0,0
    233c:	11c12083          	lw	ra,284(sp)
    2340:	11812403          	lw	s0,280(sp)
    2344:	11412483          	lw	s1,276(sp)
    2348:	11012903          	lw	s2,272(sp)
    234c:	10c12983          	lw	s3,268(sp)
    2350:	10812a03          	lw	s4,264(sp)
    2354:	10412a83          	lw	s5,260(sp)
    2358:	10012b03          	lw	s6,256(sp)
    235c:	5bfe                	lw	s7,252(sp)
    235e:	5c6e                	lw	s8,248(sp)
    2360:	5cde                	lw	s9,244(sp)
    2362:	5d4e                	lw	s10,240(sp)
    2364:	5dbe                	lw	s11,236(sp)
    2366:	6115                	add	sp,sp,288
    2368:	8082                	ret
    236a:	c3c1                	beqz	a5,23ea <measure_soc+0x24a>
    236c:	89be                	mv	s3,a5
    236e:	00fc7463          	bgeu	s8,a5,2376 <measure_soc+0x1d6>
    2372:	08000993          	li	s3,128
    2376:	009b05b3          	add	a1,s6,s1
    237a:	864e                	mv	a2,s3
    237c:	1088                	add	a0,sp,96
    237e:	c63e                	sw	a5,12(sp)
    2380:	4cb010ef          	jal	404a <memcpy>
    2384:	47b2                	lw	a5,12(sp)
    2386:	94ce                	add	s1,s1,s3
    2388:	02fd6463          	bltu	s10,a5,23b0 <measure_soc+0x210>
    238c:	0d098793          	add	a5,s3,208
    2390:	0818                	add	a4,sp,16
    2392:	97ba                	add	a5,a5,a4
    2394:	f9978023          	sb	s9,-128(a5)
    2398:	413d09b3          	sub	s3,s10,s3
    239c:	4b85                	li	s7,1
    239e:	013df963          	bgeu	s11,s3,23b0 <measure_soc+0x210>
    23a2:	4641                	li	a2,16
    23a4:	85ba                	mv	a1,a4
    23a6:	0988                	add	a0,sp,208
    23a8:	4a3010ef          	jal	404a <memcpy>
    23ac:	08048493          	add	s1,s1,128
    23b0:	100207b7          	lui	a5,0x10020
    23b4:	10020737          	lui	a4,0x10020
    23b8:	1094                	add	a3,sp,96
    23ba:	08078793          	add	a5,a5,128 # 10020080 <_bss_lma_end+0x1001abf4>
    23be:	10070713          	add	a4,a4,256 # 10020100 <_bss_lma_end+0x1001ac74>
    23c2:	863e                	mv	a2,a5
    23c4:	428c                	lw	a1,0(a3)
    23c6:	0791                	add	a5,a5,4
    23c8:	c20c                	sw	a1,0(a2)
    23ca:	0691                	add	a3,a3,4
    23cc:	fee79be3          	bne	a5,a4,23c2 <measure_soc+0x222>
    23d0:	450d                	li	a0,3
    23d2:	020a9663          	bnez	s5,23fe <measure_soc+0x25e>
    23d6:	ba5ff0ef          	jal	1f7a <sha_init>
    23da:	10020737          	lui	a4,0x10020
    23de:	0a85                	add	s5,s5,1
    23e0:	0761                	add	a4,a4,24 # 10020018 <_bss_lma_end+0x1001ab8c>
    23e2:	431c                	lw	a5,0(a4)
    23e4:	8b89                	and	a5,a5,2
    23e6:	dff5                	beqz	a5,23e2 <measure_soc+0x242>
    23e8:	bd9d                	j	225e <measure_soc+0xbe>
    23ea:	000b8463          	beqz	s7,23f2 <measure_soc+0x252>
    23ee:	01891463          	bne	s2,s8,23f6 <measure_soc+0x256>
    23f2:	07910023          	sb	s9,96(sp)
    23f6:	4641                	li	a2,16
    23f8:	00c105b3          	add	a1,sp,a2
    23fc:	b76d                	j	23a6 <measure_soc+0x206>
    23fe:	0144f563          	bgeu	s1,s4,2408 <measure_soc+0x268>
    2402:	badff0ef          	jal	1fae <sha_next>
    2406:	bfd1                	j	23da <measure_soc+0x23a>
    2408:	bdbff0ef          	jal	1fe2 <sha_next_last>
    240c:	b7f9                	j	23da <measure_soc+0x23a>
    240e:	50011537          	lui	a0,0x50011
    2412:	c2850513          	add	a0,a0,-984 # 50010c28 <k+0x3a8>
    2416:	c73fe0ef          	jal	1088 <puts>
    241a:	557d                	li	a0,-1
    241c:	b705                	j	233c <measure_soc+0x19c>

0000241e <measure_fmc>:
    241e:	712d                	add	sp,sp,-288
    2420:	11212823          	sw	s2,272(sp)
    2424:	11612023          	sw	s6,256(sp)
    2428:	892e                	mv	s2,a1
    242a:	08000613          	li	a2,128
    242e:	4581                	li	a1,0
    2430:	8b2a                	mv	s6,a0
    2432:	1088                	add	a0,sp,96
    2434:	10112e23          	sw	ra,284(sp)
    2438:	10812c23          	sw	s0,280(sp)
    243c:	10912a23          	sw	s1,276(sp)
    2440:	11312623          	sw	s3,268(sp)
    2444:	11412423          	sw	s4,264(sp)
    2448:	11512223          	sw	s5,260(sp)
    244c:	dfde                	sw	s7,252(sp)
    244e:	dde2                	sw	s8,248(sp)
    2450:	dbe6                	sw	s9,244(sp)
    2452:	d9ea                	sw	s10,240(sp)
    2454:	d7ee                	sw	s11,236(sp)
    2456:	c802                	sw	zero,16(sp)
    2458:	ca02                	sw	zero,20(sp)
    245a:	cc02                	sw	zero,24(sp)
    245c:	ce02                	sw	zero,28(sp)
    245e:	1000                	add	s0,sp,32
    2460:	343010ef          	jal	3fa2 <memset>
    2464:	04000613          	li	a2,64
    2468:	4581                	li	a1,0
    246a:	8522                	mv	a0,s0
    246c:	337010ef          	jal	3fa2 <memset>
    2470:	500115b7          	lui	a1,0x50011
    2474:	50010537          	lui	a0,0x50010
    2478:	22600613          	li	a2,550
    247c:	c7458593          	add	a1,a1,-908 # 50010c74 <__func__.0>
    2480:	16450513          	add	a0,a0,356 # 50010164 <trap_msg+0x7c>
    2484:	c07fe0ef          	jal	108a <printf>
    2488:	01d95a93          	srl	s5,s2,0x1d
    248c:	00391b93          	sll	s7,s2,0x3
    2490:	01010993          	add	s3,sp,16
    2494:	4481                	li	s1,0
    2496:	04000a13          	li	s4,64
    249a:	8626                	mv	a2,s1
    249c:	855e                	mv	a0,s7
    249e:	85d6                	mv	a1,s5
    24a0:	20f010ef          	jal	3eae <__lshrdi3>
    24a4:	00a987a3          	sb	a0,15(s3)
    24a8:	04a1                	add	s1,s1,8
    24aa:	19fd                	add	s3,s3,-1
    24ac:	ff4497e3          	bne	s1,s4,249a <measure_fmc+0x7c>
    24b0:	09090a13          	add	s4,s2,144
    24b4:	10020737          	lui	a4,0x10020
    24b8:	f80a7a13          	and	s4,s4,-128
    24bc:	0761                	add	a4,a4,24 # 10020018 <_bss_lma_end+0x1001ab8c>
    24be:	431c                	lw	a5,0(a4)
    24c0:	8b85                	and	a5,a5,1
    24c2:	dff5                	beqz	a5,24be <measure_fmc+0xa0>
    24c4:	4a81                	li	s5,0
    24c6:	4b81                	li	s7,0
    24c8:	4481                	li	s1,0
    24ca:	08000c13          	li	s8,128
    24ce:	f8000c93          	li	s9,-128
    24d2:	07f00d13          	li	s10,127
    24d6:	4dbd                	li	s11,15
    24d8:	0144fc63          	bgeu	s1,s4,24f0 <measure_fmc+0xd2>
    24dc:	08000613          	li	a2,128
    24e0:	4581                	li	a1,0
    24e2:	1088                	add	a0,sp,96
    24e4:	2bf010ef          	jal	3fa2 <memset>
    24e8:	409907b3          	sub	a5,s2,s1
    24ec:	0ef97d63          	bgeu	s2,a5,25e6 <measure_fmc+0x1c8>
    24f0:	a45ff0ef          	jal	1f34 <delay_second.constprop.0>
    24f4:	100207b7          	lui	a5,0x10020
    24f8:	10020737          	lui	a4,0x10020
    24fc:	8922                	mv	s2,s0
    24fe:	86a2                	mv	a3,s0
    2500:	10078793          	add	a5,a5,256 # 10020100 <_bss_lma_end+0x1001ac74>
    2504:	14070713          	add	a4,a4,320 # 10020140 <_bss_lma_end+0x1001acb4>
    2508:	863e                	mv	a2,a5
    250a:	4210                	lw	a2,0(a2)
    250c:	c290                	sw	a2,0(a3)
    250e:	0791                	add	a5,a5,4
    2510:	0691                	add	a3,a3,4
    2512:	fee79be3          	bne	a5,a4,2508 <measure_fmc+0xea>
    2516:	50011537          	lui	a0,0x50011
    251a:	c3c50513          	add	a0,a0,-964 # 50010c3c <k+0x3bc>
    251e:	b6bfe0ef          	jal	1088 <puts>
    2522:	04040493          	add	s1,s0,64
    2526:	500119b7          	lui	s3,0x50011
    252a:	400c                	lw	a1,0(s0)
    252c:	b9098513          	add	a0,s3,-1136 # 50010b90 <k+0x310>
    2530:	0411                	add	s0,s0,4
    2532:	b59fe0ef          	jal	108a <printf>
    2536:	fe849ae3          	bne	s1,s0,252a <measure_fmc+0x10c>
    253a:	4529                	li	a0,10
    253c:	b47fe0ef          	jal	1082 <putchar>
    2540:	50010437          	lui	s0,0x50010
    2544:	50011537          	lui	a0,0x50011
    2548:	08040493          	add	s1,s0,128 # 50010080 <FMC_expected_digest>
    254c:	c5850513          	add	a0,a0,-936 # 50010c58 <k+0x3d8>
    2550:	b39fe0ef          	jal	1088 <puts>
    2554:	04048a13          	add	s4,s1,64
    2558:	08040413          	add	s0,s0,128
    255c:	400c                	lw	a1,0(s0)
    255e:	b9098513          	add	a0,s3,-1136
    2562:	0411                	add	s0,s0,4
    2564:	b27fe0ef          	jal	108a <printf>
    2568:	ff441ae3          	bne	s0,s4,255c <measure_fmc+0x13e>
    256c:	4529                	li	a0,10
    256e:	b15fe0ef          	jal	1082 <putchar>
    2572:	50011537          	lui	a0,0x50011
    2576:	bb450513          	add	a0,a0,-1100 # 50010bb4 <k+0x334>
    257a:	b0ffe0ef          	jal	1088 <puts>
    257e:	4401                	li	s0,0
    2580:	4785                	li	a5,1
    2582:	50011a37          	lui	s4,0x50011
    2586:	49c1                	li	s3,16
    2588:	00092603          	lw	a2,0(s2)
    258c:	4094                	lw	a3,0(s1)
    258e:	00d60863          	beq	a2,a3,259e <measure_fmc+0x180>
    2592:	85a2                	mv	a1,s0
    2594:	bd0a0513          	add	a0,s4,-1072 # 50010bd0 <k+0x350>
    2598:	af3fe0ef          	jal	108a <printf>
    259c:	4781                	li	a5,0
    259e:	0405                	add	s0,s0,1
    25a0:	0911                	add	s2,s2,4
    25a2:	0491                	add	s1,s1,4
    25a4:	ff3412e3          	bne	s0,s3,2588 <measure_fmc+0x16a>
    25a8:	c3ed                	beqz	a5,268a <measure_fmc+0x26c>
    25aa:	50011537          	lui	a0,0x50011
    25ae:	c1050513          	add	a0,a0,-1008 # 50010c10 <k+0x390>
    25b2:	ad7fe0ef          	jal	1088 <puts>
    25b6:	4501                	li	a0,0
    25b8:	11c12083          	lw	ra,284(sp)
    25bc:	11812403          	lw	s0,280(sp)
    25c0:	11412483          	lw	s1,276(sp)
    25c4:	11012903          	lw	s2,272(sp)
    25c8:	10c12983          	lw	s3,268(sp)
    25cc:	10812a03          	lw	s4,264(sp)
    25d0:	10412a83          	lw	s5,260(sp)
    25d4:	10012b03          	lw	s6,256(sp)
    25d8:	5bfe                	lw	s7,252(sp)
    25da:	5c6e                	lw	s8,248(sp)
    25dc:	5cde                	lw	s9,244(sp)
    25de:	5d4e                	lw	s10,240(sp)
    25e0:	5dbe                	lw	s11,236(sp)
    25e2:	6115                	add	sp,sp,288
    25e4:	8082                	ret
    25e6:	c3c1                	beqz	a5,2666 <measure_fmc+0x248>
    25e8:	89be                	mv	s3,a5
    25ea:	00fc7463          	bgeu	s8,a5,25f2 <measure_fmc+0x1d4>
    25ee:	08000993          	li	s3,128
    25f2:	009b05b3          	add	a1,s6,s1
    25f6:	864e                	mv	a2,s3
    25f8:	1088                	add	a0,sp,96
    25fa:	c63e                	sw	a5,12(sp)
    25fc:	24f010ef          	jal	404a <memcpy>
    2600:	47b2                	lw	a5,12(sp)
    2602:	94ce                	add	s1,s1,s3
    2604:	02fd6463          	bltu	s10,a5,262c <measure_fmc+0x20e>
    2608:	0d098793          	add	a5,s3,208
    260c:	0818                	add	a4,sp,16
    260e:	97ba                	add	a5,a5,a4
    2610:	f9978023          	sb	s9,-128(a5)
    2614:	413d09b3          	sub	s3,s10,s3
    2618:	4b85                	li	s7,1
    261a:	013df963          	bgeu	s11,s3,262c <measure_fmc+0x20e>
    261e:	4641                	li	a2,16
    2620:	85ba                	mv	a1,a4
    2622:	0988                	add	a0,sp,208
    2624:	227010ef          	jal	404a <memcpy>
    2628:	08048493          	add	s1,s1,128
    262c:	100207b7          	lui	a5,0x10020
    2630:	10020737          	lui	a4,0x10020
    2634:	1094                	add	a3,sp,96
    2636:	08078793          	add	a5,a5,128 # 10020080 <_bss_lma_end+0x1001abf4>
    263a:	10070713          	add	a4,a4,256 # 10020100 <_bss_lma_end+0x1001ac74>
    263e:	863e                	mv	a2,a5
    2640:	428c                	lw	a1,0(a3)
    2642:	0791                	add	a5,a5,4
    2644:	c20c                	sw	a1,0(a2)
    2646:	0691                	add	a3,a3,4
    2648:	fee79be3          	bne	a5,a4,263e <measure_fmc+0x220>
    264c:	450d                	li	a0,3
    264e:	020a9663          	bnez	s5,267a <measure_fmc+0x25c>
    2652:	929ff0ef          	jal	1f7a <sha_init>
    2656:	10020737          	lui	a4,0x10020
    265a:	0a85                	add	s5,s5,1
    265c:	0761                	add	a4,a4,24 # 10020018 <_bss_lma_end+0x1001ab8c>
    265e:	431c                	lw	a5,0(a4)
    2660:	8b89                	and	a5,a5,2
    2662:	dff5                	beqz	a5,265e <measure_fmc+0x240>
    2664:	bd95                	j	24d8 <measure_fmc+0xba>
    2666:	000b8463          	beqz	s7,266e <measure_fmc+0x250>
    266a:	01891463          	bne	s2,s8,2672 <measure_fmc+0x254>
    266e:	07910023          	sb	s9,96(sp)
    2672:	4641                	li	a2,16
    2674:	00c105b3          	add	a1,sp,a2
    2678:	b76d                	j	2622 <measure_fmc+0x204>
    267a:	0144f563          	bgeu	s1,s4,2684 <measure_fmc+0x266>
    267e:	931ff0ef          	jal	1fae <sha_next>
    2682:	bfd1                	j	2656 <measure_fmc+0x238>
    2684:	95fff0ef          	jal	1fe2 <sha_next_last>
    2688:	b7f9                	j	2656 <measure_fmc+0x238>
    268a:	50011537          	lui	a0,0x50011
    268e:	c2850513          	add	a0,a0,-984 # 50010c28 <k+0x3a8>
    2692:	9f7fe0ef          	jal	1088 <puts>
    2696:	557d                	li	a0,-1
    2698:	b705                	j	25b8 <measure_fmc+0x19a>

0000269a <soc_ifc_set_flow_status_field>:
    269a:	1141                	add	sp,sp,-16
    269c:	c422                	sw	s0,8(sp)
    269e:	85aa                	mv	a1,a0
    26a0:	842a                	mv	s0,a0
    26a2:	50011537          	lui	a0,0x50011
    26a6:	c8c50513          	add	a0,a0,-884 # 50010c8c <__func__.2+0xc>
    26aa:	c606                	sw	ra,12(sp)
    26ac:	9dffe0ef          	jal	108a <printf>
    26b0:	300307b7          	lui	a5,0x30030
    26b4:	5fdc                	lw	a5,60(a5)
    26b6:	00841693          	sll	a3,s0,0x8
    26ba:	00f46733          	or	a4,s0,a5
    26be:	c691                	beqz	a3,26ca <soc_ifc_set_flow_status_field+0x30>
    26c0:	ff000737          	lui	a4,0xff000
    26c4:	8ff9                	and	a5,a5,a4
    26c6:	0087e733          	or	a4,a5,s0
    26ca:	0220000f          	fence	r,r
    26ce:	0220000f          	fence	r,r
    26d2:	300307b7          	lui	a5,0x30030
    26d6:	40b2                	lw	ra,12(sp)
    26d8:	4422                	lw	s0,8(sp)
    26da:	dfd8                	sw	a4,60(a5)
    26dc:	0141                	add	sp,sp,16
    26de:	8082                	ret

000026e0 <soc_ifc_read_mbox_cmd>:
    26e0:	1141                	add	sp,sp,-16
    26e2:	300207b7          	lui	a5,0x30020
    26e6:	478c                	lw	a1,8(a5)
    26e8:	47c8                	lw	a0,12(a5)
    26ea:	0141                	add	sp,sp,16
    26ec:	8082                	ret

000026ee <uart_tx>:
    26ee:	20001737          	lui	a4,0x20001
    26f2:	0751                	add	a4,a4,20 # 20001014 <_bss_lma_end+0x1fffbb88>
    26f4:	431c                	lw	a5,0(a4)
    26f6:	8b85                	and	a5,a5,1
    26f8:	fff5                	bnez	a5,26f4 <uart_tx+0x6>
    26fa:	0220000f          	fence	r,r
    26fe:	0220000f          	fence	r,r
    2702:	200017b7          	lui	a5,0x20001
    2706:	cfc8                	sw	a0,28(a5)
    2708:	8082                	ret

0000270a <enable_uart>:
    270a:	0220000f          	fence	r,r
    270e:	0220000f          	fence	r,r
    2712:	0bcb07b7          	lui	a5,0xbcb0
    2716:	20001737          	lui	a4,0x20001
    271a:	078d                	add	a5,a5,3 # bcb0003 <_bss_lma_end+0xbcaab77>
    271c:	cb1c                	sw	a5,16(a4)
    271e:	8082                	ret

00002720 <end_sim_if_uart_disabled>:
    2720:	300307b7          	lui	a5,0x30030
    2724:	0e07a783          	lw	a5,224(a5) # 300300e0 <_bss_lma_end+0x3002ac54>
    2728:	8ba1                	and	a5,a5,8
    272a:	e391                	bnez	a5,272e <end_sim_if_uart_disabled+0xe>
    272c:	a001                	j	272c <end_sim_if_uart_disabled+0xc>
    272e:	8082                	ret

00002730 <init_uart>:
    2730:	1141                	add	sp,sp,-16
    2732:	c606                	sw	ra,12(sp)
    2734:	37f5                	jal	2720 <end_sim_if_uart_disabled>
    2736:	40b2                	lw	ra,12(sp)
    2738:	0141                	add	sp,sp,16
    273a:	bfc1                	j	270a <enable_uart>

0000273c <asn1_write_tag>:
    273c:	411c                	lw	a5,0(a0)
    273e:	1141                	add	sp,sp,-16
    2740:	c422                	sw	s0,8(sp)
    2742:	c226                	sw	s1,4(sp)
    2744:	c606                	sw	ra,12(sp)
    2746:	84b6                	mv	s1,a3
    2748:	00178693          	add	a3,a5,1
    274c:	872e                	mv	a4,a1
    274e:	c114                	sw	a3,0(a0)
    2750:	00e78023          	sb	a4,0(a5)
    2754:	07f00693          	li	a3,127
    2758:	842a                	mv	s0,a0
    275a:	85b2                	mv	a1,a2
    275c:	0ff4f713          	zext.b	a4,s1
    2760:	411c                	lw	a5,0(a0)
    2762:	0296e363          	bltu	a3,s1,2788 <asn1_write_tag+0x4c>
    2766:	00178693          	add	a3,a5,1
    276a:	c014                	sw	a3,0(s0)
    276c:	00e78023          	sb	a4,0(a5)
    2770:	8626                	mv	a2,s1
    2772:	4008                	lw	a0,0(s0)
    2774:	0d7010ef          	jal	404a <memcpy>
    2778:	401c                	lw	a5,0(s0)
    277a:	97a6                	add	a5,a5,s1
    277c:	c01c                	sw	a5,0(s0)
    277e:	40b2                	lw	ra,12(sp)
    2780:	4422                	lw	s0,8(sp)
    2782:	4492                	lw	s1,4(sp)
    2784:	0141                	add	sp,sp,16
    2786:	8082                	ret
    2788:	00178693          	add	a3,a5,1
    278c:	c114                	sw	a3,0(a0)
    278e:	f8200693          	li	a3,-126
    2792:	00d78023          	sb	a3,0(a5)
    2796:	411c                	lw	a5,0(a0)
    2798:	00178693          	add	a3,a5,1
    279c:	c114                	sw	a3,0(a0)
    279e:	0084d693          	srl	a3,s1,0x8
    27a2:	00d78023          	sb	a3,0(a5)
    27a6:	411c                	lw	a5,0(a0)
    27a8:	bf7d                	j	2766 <asn1_write_tag+0x2a>

000027aa <encode_dn>:
    27aa:	7161                	add	sp,sp,-432
    27ac:	1a912223          	sw	s1,420(sp)
    27b0:	1b212023          	sw	s2,416(sp)
    27b4:	19412c23          	sw	s4,408(sp)
    27b8:	45500793          	li	a5,1109
    27bc:	01010a13          	add	s4,sp,16
    27c0:	84ae                	mv	s1,a1
    27c2:	468d                	li	a3,3
    27c4:	860a                	mv	a2,sp
    27c6:	892a                	mv	s2,a0
    27c8:	4599                	li	a1,6
    27ca:	0048                	add	a0,sp,4
    27cc:	1a112623          	sw	ra,428(sp)
    27d0:	19312e23          	sw	s3,412(sp)
    27d4:	1a812423          	sw	s0,424(sp)
    27d8:	00f11023          	sh	a5,0(sp)
    27dc:	00d10123          	sb	a3,2(sp)
    27e0:	c252                	sw	s4,4(sp)
    27e2:	3fa9                	jal	273c <asn1_write_tag>
    27e4:	8526                	mv	a0,s1
    27e6:	151010ef          	jal	4136 <strlen>
    27ea:	86aa                	mv	a3,a0
    27ec:	8626                	mv	a2,s1
    27ee:	0048                	add	a0,sp,4
    27f0:	45b1                	li	a1,12
    27f2:	37a9                	jal	273c <asn1_write_tag>
    27f4:	4692                	lw	a3,4(sp)
    27f6:	09010993          	add	s3,sp,144
    27fa:	414686b3          	sub	a3,a3,s4
    27fe:	8652                	mv	a2,s4
    2800:	0028                	add	a0,sp,8
    2802:	03000593          	li	a1,48
    2806:	c44e                	sw	s3,8(sp)
    2808:	3f15                	jal	273c <asn1_write_tag>
    280a:	46a2                	lw	a3,8(sp)
    280c:	0a04                	add	s1,sp,272
    280e:	413686b3          	sub	a3,a3,s3
    2812:	864e                	mv	a2,s3
    2814:	0068                	add	a0,sp,12
    2816:	03100593          	li	a1,49
    281a:	c626                	sw	s1,12(sp)
    281c:	3705                	jal	273c <asn1_write_tag>
    281e:	46b2                	lw	a3,12(sp)
    2820:	8e85                	sub	a3,a3,s1
    2822:	8626                	mv	a2,s1
    2824:	854a                	mv	a0,s2
    2826:	03000593          	li	a1,48
    282a:	3f09                	jal	273c <asn1_write_tag>
    282c:	1ac12083          	lw	ra,428(sp)
    2830:	1a812403          	lw	s0,424(sp)
    2834:	1a412483          	lw	s1,420(sp)
    2838:	1a012903          	lw	s2,416(sp)
    283c:	19c12983          	lw	s3,412(sp)
    2840:	19812a03          	lw	s4,408(sp)
    2844:	615d                	add	sp,sp,432
    2846:	8082                	ret

00002848 <convert_le32_to_be_bytes>:
    2848:	4781                	li	a5,0
    284a:	00c79363          	bne	a5,a2,2850 <convert_le32_to_be_bytes+0x8>
    284e:	8082                	ret
    2850:	00279713          	sll	a4,a5,0x2
    2854:	972e                	add	a4,a4,a1
    2856:	4318                	lw	a4,0(a4)
    2858:	01875693          	srl	a3,a4,0x18
    285c:	00d50023          	sb	a3,0(a0)
    2860:	01075693          	srl	a3,a4,0x10
    2864:	00d500a3          	sb	a3,1(a0)
    2868:	00875693          	srl	a3,a4,0x8
    286c:	00d50123          	sb	a3,2(a0)
    2870:	00e501a3          	sb	a4,3(a0)
    2874:	0785                	add	a5,a5,1
    2876:	0511                	add	a0,a0,4
    2878:	bfc9                	j	284a <convert_le32_to_be_bytes+0x2>

0000287a <generate_intermediate_tbs_der>:
    287a:	81010113          	add	sp,sp,-2032
    287e:	7e112623          	sw	ra,2028(sp)
    2882:	7f212023          	sw	s2,2016(sp)
    2886:	7e812423          	sw	s0,2024(sp)
    288a:	7e912223          	sw	s1,2020(sp)
    288e:	7d312e23          	sw	s3,2012(sp)
    2892:	7d412c23          	sw	s4,2008(sp)
    2896:	7d512a23          	sw	s5,2004(sp)
    289a:	7d612823          	sw	s6,2000(sp)
    289e:	7d712623          	sw	s7,1996(sp)
    28a2:	7d812423          	sw	s8,1992(sp)
    28a6:	7d912223          	sw	s9,1988(sp)
    28aa:	7da12023          	sw	s10,1984(sp)
    28ae:	7bb12e23          	sw	s11,1980(sp)
    28b2:	c0010113          	add	sp,sp,-1024
    28b6:	8bb2                	mv	s7,a2
    28b8:	3b010a93          	add	s5,sp,944
    28bc:	6605                	lui	a2,0x1
    28be:	8caa                	mv	s9,a0
    28c0:	80060613          	add	a2,a2,-2048 # 800 <mfdc+0x7>
    28c4:	89ae                	mv	s3,a1
    28c6:	8556                	mv	a0,s5
    28c8:	4581                	li	a1,0
    28ca:	8b36                	mv	s6,a3
    28cc:	8c42                	mv	s8,a6
    28ce:	84ba                	mv	s1,a4
    28d0:	8a3e                	mv	s4,a5
    28d2:	6405                	lui	s0,0x1
    28d4:	6ce010ef          	jal	3fa2 <memset>
    28d8:	0818                	add	a4,sp,16
    28da:	ba040793          	add	a5,s0,-1120 # ba0 <hmac_flow+0x14e>
    28de:	97ba                	add	a5,a5,a4
    28e0:	40878433          	sub	s0,a5,s0
    28e4:	010207b7          	lui	a5,0x1020
    28e8:	50040913          	add	s2,s0,1280
    28ec:	3a078793          	add	a5,a5,928 # 10203a0 <_bss_lma_end+0x101af14>
    28f0:	00f92e23          	sw	a5,28(s2)
    28f4:	500115b7          	lui	a1,0x50011
    28f8:	53c40793          	add	a5,s0,1340
    28fc:	4631                	li	a2,12
    28fe:	cc858593          	add	a1,a1,-824 # 50010cc8 <__func__.2+0x48>
    2902:	853e                	mv	a0,a5
    2904:	4d89                	li	s11,2
    2906:	c63e                	sw	a5,12(sp)
    2908:	53b40023          	sb	s11,1312(s0)
    290c:	73e010ef          	jal	404a <memcpy>
    2910:	56840793          	add	a5,s0,1384
    2914:	500115b7          	lui	a1,0x50011
    2918:	02400613          	li	a2,36
    291c:	cd858593          	add	a1,a1,-808 # 50010cd8 <__func__.2+0x58>
    2920:	853e                	mv	a0,a5
    2922:	c63e                	sw	a5,12(sp)
    2924:	726010ef          	jal	404a <memcpy>
    2928:	40000793          	li	a5,1024
    292c:	05e00613          	li	a2,94
    2930:	4581                	li	a1,0
    2932:	6a040513          	add	a0,s0,1696
    2936:	68f42e23          	sw	a5,1692(s0)
    293a:	668010ef          	jal	3fa2 <memset>
    293e:	500115b7          	lui	a1,0x50011
    2942:	461d                	li	a2,7
    2944:	d0058593          	add	a1,a1,-768 # 50010d00 <__func__.2+0x80>
    2948:	53440513          	add	a0,s0,1332
    294c:	6fe010ef          	jal	404a <memcpy>
    2950:	000487b7          	lui	a5,0x48
    2954:	12b78793          	add	a5,a5,299 # 4812b <_bss_lma_end+0x42c9f>
    2958:	02f92223          	sw	a5,36(s2)
    295c:	02000613          	li	a2,32
    2960:	02200793          	li	a5,34
    2964:	4581                	li	a1,0
    2966:	54840513          	add	a0,s0,1352
    296a:	52f40423          	sb	a5,1320(s0)
    296e:	634010ef          	jal	3fa2 <memset>
    2972:	10000613          	li	a2,256
    2976:	4581                	li	a1,0
    2978:	70040513          	add	a0,s0,1792
    297c:	626010ef          	jal	3fa2 <memset>
    2980:	61440793          	add	a5,s0,1556
    2984:	853e                	mv	a0,a5
    2986:	04400613          	li	a2,68
    298a:	4581                	li	a1,0
    298c:	c63e                	sw	a5,12(sp)
    298e:	65840d13          	add	s10,s0,1624
    2992:	610010ef          	jal	3fa2 <memset>
    2996:	04400613          	li	a2,68
    299a:	4581                	li	a1,0
    299c:	856a                	mv	a0,s10
    299e:	604010ef          	jal	3fa2 <memset>
    29a2:	500105b7          	lui	a1,0x50010
    29a6:	40200793          	li	a5,1026
    29aa:	02800613          	li	a2,40
    29ae:	0c058593          	add	a1,a1,192 # 500100c0 <FMC_expected_digest+0x40>
    29b2:	58c40513          	add	a0,s0,1420
    29b6:	02f92623          	sw	a5,44(s2)
    29ba:	52041823          	sh	zero,1328(s0)
    29be:	68c010ef          	jal	404a <memcpy>
    29c2:	020c8163          	beqz	s9,29e4 <generate_intermediate_tbs_der+0x16a>
    29c6:	00098f63          	beqz	s3,29e4 <generate_intermediate_tbs_der+0x16a>
    29ca:	000b8d63          	beqz	s7,29e4 <generate_intermediate_tbs_der+0x16a>
    29ce:	000b0b63          	beqz	s6,29e4 <generate_intermediate_tbs_der+0x16a>
    29d2:	c889                	beqz	s1,29e4 <generate_intermediate_tbs_der+0x16a>
    29d4:	000a0863          	beqz	s4,29e4 <generate_intermediate_tbs_der+0x16a>
    29d8:	000a2703          	lw	a4,0(s4)
    29dc:	7ff00793          	li	a5,2047
    29e0:	04e7e863          	bltu	a5,a4,2a30 <generate_intermediate_tbs_der+0x1b6>
    29e4:	50011537          	lui	a0,0x50011
    29e8:	cb450513          	add	a0,a0,-844 # 50010cb4 <__func__.2+0x34>
    29ec:	e9cfe0ef          	jal	1088 <puts>
    29f0:	557d                	li	a0,-1
    29f2:	40010113          	add	sp,sp,1024
    29f6:	7ec12083          	lw	ra,2028(sp)
    29fa:	7e812403          	lw	s0,2024(sp)
    29fe:	7e412483          	lw	s1,2020(sp)
    2a02:	7e012903          	lw	s2,2016(sp)
    2a06:	7dc12983          	lw	s3,2012(sp)
    2a0a:	7d812a03          	lw	s4,2008(sp)
    2a0e:	7d412a83          	lw	s5,2004(sp)
    2a12:	7d012b03          	lw	s6,2000(sp)
    2a16:	7cc12b83          	lw	s7,1996(sp)
    2a1a:	7c812c03          	lw	s8,1992(sp)
    2a1e:	7c412c83          	lw	s9,1988(sp)
    2a22:	7c012d03          	lw	s10,1984(sp)
    2a26:	7bc12d83          	lw	s11,1980(sp)
    2a2a:	7f010113          	add	sp,sp,2032
    2a2e:	8082                	ret
    2a30:	85e6                	mv	a1,s9
    2a32:	4631                	li	a2,12
    2a34:	12c8                	add	a0,sp,356
    2a36:	3d09                	jal	2848 <convert_le32_to_be_bytes>
    2a38:	85ce                	mv	a1,s3
    2a3a:	4631                	li	a2,12
    2a3c:	0b48                	add	a0,sp,404
    2a3e:	3529                	jal	2848 <convert_le32_to_be_bytes>
    2a40:	03000613          	li	a2,48
    2a44:	5b440593          	add	a1,s0,1460
    2a48:	69e40513          	add	a0,s0,1694
    2a4c:	5fe010ef          	jal	404a <memcpy>
    2a50:	03000613          	li	a2,48
    2a54:	5e440593          	add	a1,s0,1508
    2a58:	6ce40513          	add	a0,s0,1742
    2a5c:	5ee010ef          	jal	404a <memcpy>
    2a60:	0f810c93          	add	s9,sp,248
    2a64:	1968                	add	a0,sp,188
    2a66:	469d                	li	a3,7
    2a68:	11d0                	add	a2,sp,228
    2a6a:	4599                	li	a1,6
    2a6c:	01992623          	sw	s9,12(s2)
    2a70:	ccdff0ef          	jal	273c <asn1_write_tag>
    2a74:	4695                	li	a3,5
    2a76:	09d0                	add	a2,sp,212
    2a78:	4599                	li	a1,6
    2a7a:	1968                	add	a0,sp,188
    2a7c:	cc1ff0ef          	jal	273c <asn1_write_tag>
    2a80:	00c92683          	lw	a3,12(s2)
    2a84:	2b010993          	add	s3,sp,688
    2a88:	419686b3          	sub	a3,a3,s9
    2a8c:	8666                	mv	a2,s9
    2a8e:	0188                	add	a0,sp,192
    2a90:	03000593          	li	a1,48
    2a94:	01392823          	sw	s3,16(s2)
    2a98:	ca5ff0ef          	jal	273c <asn1_write_tag>
    2a9c:	06200693          	li	a3,98
    2aa0:	04f0                	add	a2,sp,588
    2aa2:	458d                	li	a1,3
    2aa4:	0188                	add	a0,sp,192
    2aa6:	c97ff0ef          	jal	273c <asn1_write_tag>
    2aaa:	01092683          	lw	a3,16(s2)
    2aae:	413686b3          	sub	a3,a3,s3
    2ab2:	8636                	mv	a2,a3
    2ab4:	85ce                	mv	a1,s3
    2ab6:	03a8                	add	a0,sp,456
    2ab8:	c636                	sw	a3,12(sp)
    2aba:	590010ef          	jal	404a <memcpy>
    2abe:	04400613          	li	a2,68
    2ac2:	61440593          	add	a1,s0,1556
    2ac6:	4b040513          	add	a0,s0,1200
    2aca:	580010ef          	jal	404a <memcpy>
    2ace:	85ea                	mv	a1,s10
    2ad0:	04400613          	li	a2,68
    2ad4:	46040513          	add	a0,s0,1120
    2ad8:	572010ef          	jal	404a <memcpy>
    2adc:	0810                	add	a2,sp,16
    2ade:	4585                	li	a1,1
    2ae0:	1088                	add	a0,sp,96
    2ae2:	d15fe0ef          	jal	17f6 <sha256_flow_produce>
    2ae6:	65c42783          	lw	a5,1628(s0)
    2aea:	52f41723          	sh	a5,1326(s0)
    2aee:	000a2603          	lw	a2,0(s4)
    2af2:	83c1                	srl	a5,a5,0x10
    2af4:	4581                	li	a1,0
    2af6:	8526                	mv	a0,s1
    2af8:	52f41823          	sh	a5,1328(s0)
    2afc:	4d15                	li	s10,5
    2afe:	4a4010ef          	jal	3fa2 <memset>
    2b02:	866a                	mv	a2,s10
    2b04:	51c40593          	add	a1,s0,1308
    2b08:	8526                	mv	a0,s1
    2b0a:	540010ef          	jal	404a <memcpy>
    2b0e:	4619                	li	a2,6
    2b10:	52c40593          	add	a1,s0,1324
    2b14:	01a48533          	add	a0,s1,s10
    2b18:	532010ef          	jal	404a <memcpy>
    2b1c:	4631                	li	a2,12
    2b1e:	53c40593          	add	a1,s0,1340
    2b22:	00b48513          	add	a0,s1,11
    2b26:	524010ef          	jal	404a <memcpy>
    2b2a:	0c410c93          	add	s9,sp,196
    2b2e:	01748793          	add	a5,s1,23
    2b32:	85de                	mv	a1,s7
    2b34:	8566                	mv	a0,s9
    2b36:	00f92a23          	sw	a5,20(s2)
    2b3a:	c71ff0ef          	jal	27aa <encode_dn>
    2b3e:	01492783          	lw	a5,20(s2)
    2b42:	02400613          	li	a2,36
    2b46:	56840593          	add	a1,s0,1384
    2b4a:	853e                	mv	a0,a5
    2b4c:	4fe010ef          	jal	404a <memcpy>
    2b50:	02450793          	add	a5,a0,36
    2b54:	85da                	mv	a1,s6
    2b56:	8566                	mv	a0,s9
    2b58:	00f92a23          	sw	a5,20(s2)
    2b5c:	c4fff0ef          	jal	27aa <encode_dn>
    2b60:	46b2                	lw	a3,12(sp)
    2b62:	864e                	mv	a2,s3
    2b64:	03000593          	li	a1,48
    2b68:	8566                	mv	a0,s9
    2b6a:	bd3ff0ef          	jal	273c <asn1_write_tag>
    2b6e:	040c1363          	bnez	s8,2bb4 <generate_intermediate_tbs_der+0x33a>
    2b72:	5ba409a3          	sb	s10,1459(s0)
    2b76:	02800693          	li	a3,40
    2b7a:	1a70                	add	a2,sp,316
    2b7c:	0a300593          	li	a1,163
    2b80:	01c8                	add	a0,sp,196
    2b82:	bbbff0ef          	jal	273c <asn1_write_tag>
    2b86:	469e                	lw	a3,196(sp)
    2b88:	8e85                	sub	a3,a3,s1
    2b8a:	00da2023          	sw	a3,0(s4)
    2b8e:	8626                	mv	a2,s1
    2b90:	03000593          	li	a1,48
    2b94:	01a8                	add	a0,sp,200
    2b96:	c5d6                	sw	s5,200(sp)
    2b98:	ba5ff0ef          	jal	273c <asn1_write_tag>
    2b9c:	442e                	lw	s0,200(sp)
    2b9e:	41540433          	sub	s0,s0,s5
    2ba2:	8622                	mv	a2,s0
    2ba4:	85d6                	mv	a1,s5
    2ba6:	8526                	mv	a0,s1
    2ba8:	4a2010ef          	jal	404a <memcpy>
    2bac:	4501                	li	a0,0
    2bae:	008a2023          	sw	s0,0(s4)
    2bb2:	b581                	j	29f2 <generate_intermediate_tbs_der+0x178>
    2bb4:	4785                	li	a5,1
    2bb6:	00fc1663          	bne	s8,a5,2bc2 <generate_intermediate_tbs_der+0x348>
    2bba:	4791                	li	a5,4
    2bbc:	5af409a3          	sb	a5,1459(s0)
    2bc0:	bf5d                	j	2b76 <generate_intermediate_tbs_der+0x2fc>
    2bc2:	470d                	li	a4,3
    2bc4:	01bc1563          	bne	s8,s11,2bce <generate_intermediate_tbs_der+0x354>
    2bc8:	16e101a3          	sb	a4,355(sp)
    2bcc:	b76d                	j	2b76 <generate_intermediate_tbs_der+0x2fc>
    2bce:	faec14e3          	bne	s8,a4,2b76 <generate_intermediate_tbs_der+0x2fc>
    2bd2:	4789                	li	a5,2
    2bd4:	16f101a3          	sb	a5,355(sp)
    2bd8:	bf79                	j	2b76 <generate_intermediate_tbs_der+0x2fc>

00002bda <add_signature_to_cert>:
    2bda:	710d                	add	sp,sp,-352
    2bdc:	15212823          	sw	s2,336(sp)
    2be0:	15512223          	sw	s5,324(sp)
    2be4:	892e                	mv	s2,a1
    2be6:	8aaa                	mv	s5,a0
    2be8:	85b2                	mv	a1,a2
    2bea:	0828                	add	a0,sp,24
    2bec:	03000613          	li	a2,48
    2bf0:	14112e23          	sw	ra,348(sp)
    2bf4:	14812c23          	sw	s0,344(sp)
    2bf8:	14912a23          	sw	s1,340(sp)
    2bfc:	8436                	mv	s0,a3
    2bfe:	84ba                	mv	s1,a4
    2c00:	15312623          	sw	s3,332(sp)
    2c04:	15412423          	sw	s4,328(sp)
    2c08:	89be                	mv	s3,a5
    2c0a:	c3fff0ef          	jal	2848 <convert_le32_to_be_bytes>
    2c0e:	85a2                	mv	a1,s0
    2c10:	03000613          	li	a2,48
    2c14:	00a8                	add	a0,sp,72
    2c16:	c33ff0ef          	jal	2848 <convert_le32_to_be_bytes>
    2c1a:	03000413          	li	s0,48
    2c1e:	00448a13          	add	s4,s1,4
    2c22:	864a                	mv	a2,s2
    2c24:	85d6                	mv	a1,s5
    2c26:	00848023          	sb	s0,0(s1)
    2c2a:	8552                	mv	a0,s4
    2c2c:	41e010ef          	jal	404a <memcpy>
    2c30:	4631                	li	a2,12
    2c32:	500115b7          	lui	a1,0x50011
    2c36:	cc858593          	add	a1,a1,-824 # 50010cc8 <__func__.2+0x48>
    2c3a:	00c10533          	add	a0,sp,a2
    2c3e:	40c010ef          	jal	404a <memcpy>
    2c42:	4631                	li	a2,12
    2c44:	9952                	add	s2,s2,s4
    2c46:	00c105b3          	add	a1,sp,a2
    2c4a:	854a                	mv	a0,s2
    2c4c:	3fe010ef          	jal	404a <memcpy>
    2c50:	4789                	li	a5,2
    2c52:	06f10d23          	sb	a5,122(sp)
    2c56:	01810783          	lb	a5,24(sp)
    2c5a:	06811c23          	sh	s0,120(sp)
    2c5e:	0e07d363          	bgez	a5,2d44 <add_signature_to_cert+0x16a>
    2c62:	03100793          	li	a5,49
    2c66:	8622                	mv	a2,s0
    2c68:	082c                	add	a1,sp,24
    2c6a:	07d10513          	add	a0,sp,125
    2c6e:	06f10da3          	sb	a5,123(sp)
    2c72:	06010e23          	sb	zero,124(sp)
    2c76:	0ad10413          	add	s0,sp,173
    2c7a:	3d0010ef          	jal	404a <memcpy>
    2c7e:	4789                	li	a5,2
    2c80:	00f40023          	sb	a5,0(s0)
    2c84:	04810783          	lb	a5,72(sp)
    2c88:	0c07d763          	bgez	a5,2d56 <add_signature_to_cert+0x17c>
    2c8c:	03100793          	li	a5,49
    2c90:	00f400a3          	sb	a5,1(s0)
    2c94:	00040123          	sb	zero,2(s0)
    2c98:	00340513          	add	a0,s0,3
    2c9c:	03000613          	li	a2,48
    2ca0:	00ac                	add	a1,sp,72
    2ca2:	3a8010ef          	jal	404a <memcpy>
    2ca6:	03340413          	add	s0,s0,51
    2caa:	07810a93          	add	s5,sp,120
    2cae:	41540633          	sub	a2,s0,s5
    2cb2:	1679                	add	a2,a2,-2
    2cb4:	07f00713          	li	a4,127
    2cb8:	0ff67793          	zext.b	a5,a2
    2cbc:	0ac76963          	bltu	a4,a2,2d6e <add_signature_to_cert+0x194>
    2cc0:	06f10ca3          	sb	a5,121(sp)
    2cc4:	478d                	li	a5,3
    2cc6:	41540433          	sub	s0,s0,s5
    2cca:	00f90623          	sb	a5,12(s2)
    2cce:	07f00693          	li	a3,127
    2cd2:	00140793          	add	a5,s0,1
    2cd6:	0ff7f713          	zext.b	a4,a5
    2cda:	0af6e863          	bltu	a3,a5,2d8a <add_signature_to_cert+0x1b0>
    2cde:	00e90793          	add	a5,s2,14
    2ce2:	00e906a3          	sb	a4,13(s2)
    2ce6:	00178713          	add	a4,a5,1
    2cea:	8622                	mv	a2,s0
    2cec:	00078023          	sb	zero,0(a5)
    2cf0:	853a                	mv	a0,a4
    2cf2:	85d6                	mv	a1,s5
    2cf4:	356010ef          	jal	404a <memcpy>
    2cf8:	942a                	add	s0,s0,a0
    2cfa:	40940633          	sub	a2,s0,s1
    2cfe:	1671                	add	a2,a2,-4
    2d00:	07f00713          	li	a4,127
    2d04:	0ff67793          	zext.b	a5,a2
    2d08:	08c76a63          	bltu	a4,a2,2d9c <add_signature_to_cert+0x1c2>
    2d0c:	00f480a3          	sb	a5,1(s1)
    2d10:	85d2                	mv	a1,s4
    2d12:	00248513          	add	a0,s1,2
    2d16:	1c0010ef          	jal	3ed6 <memmove>
    2d1a:	1479                	add	s0,s0,-2
    2d1c:	8c05                	sub	s0,s0,s1
    2d1e:	0089a023          	sw	s0,0(s3)
    2d22:	15c12083          	lw	ra,348(sp)
    2d26:	15812403          	lw	s0,344(sp)
    2d2a:	15412483          	lw	s1,340(sp)
    2d2e:	15012903          	lw	s2,336(sp)
    2d32:	14c12983          	lw	s3,332(sp)
    2d36:	14812a03          	lw	s4,328(sp)
    2d3a:	14412a83          	lw	s5,324(sp)
    2d3e:	4501                	li	a0,0
    2d40:	6135                	add	sp,sp,352
    2d42:	8082                	ret
    2d44:	8622                	mv	a2,s0
    2d46:	082c                	add	a1,sp,24
    2d48:	18e8                	add	a0,sp,124
    2d4a:	06810da3          	sb	s0,123(sp)
    2d4e:	2fc010ef          	jal	404a <memcpy>
    2d52:	1160                	add	s0,sp,172
    2d54:	b72d                	j	2c7e <add_signature_to_cert+0xa4>
    2d56:	03000613          	li	a2,48
    2d5a:	00c400a3          	sb	a2,1(s0)
    2d5e:	00240513          	add	a0,s0,2
    2d62:	00ac                	add	a1,sp,72
    2d64:	2e6010ef          	jal	404a <memcpy>
    2d68:	03240413          	add	s0,s0,50
    2d6c:	bf3d                	j	2caa <add_signature_to_cert+0xd0>
    2d6e:	f8100713          	li	a4,-127
    2d72:	07a10593          	add	a1,sp,122
    2d76:	07b10513          	add	a0,sp,123
    2d7a:	06e10ca3          	sb	a4,121(sp)
    2d7e:	06f10d23          	sb	a5,122(sp)
    2d82:	0405                	add	s0,s0,1
    2d84:	152010ef          	jal	3ed6 <memmove>
    2d88:	bf35                	j	2cc4 <add_signature_to_cert+0xea>
    2d8a:	f8100793          	li	a5,-127
    2d8e:	00f906a3          	sb	a5,13(s2)
    2d92:	00e90723          	sb	a4,14(s2)
    2d96:	00f90793          	add	a5,s2,15
    2d9a:	b7b1                	j	2ce6 <add_signature_to_cert+0x10c>
    2d9c:	0ff00713          	li	a4,255
    2da0:	00c76963          	bltu	a4,a2,2db2 <add_signature_to_cert+0x1d8>
    2da4:	f8100713          	li	a4,-127
    2da8:	00e480a3          	sb	a4,1(s1)
    2dac:	00f48123          	sb	a5,2(s1)
    2db0:	b7b5                	j	2d1c <add_signature_to_cert+0x142>
    2db2:	f8200713          	li	a4,-126
    2db6:	8221                	srl	a2,a2,0x8
    2db8:	00e480a3          	sb	a4,1(s1)
    2dbc:	00c48123          	sb	a2,2(s1)
    2dc0:	00f481a3          	sb	a5,3(s1)
    2dc4:	bfa1                	j	2d1c <add_signature_to_cert+0x142>

00002dc6 <ldevid>:
    2dc6:	72f9                	lui	t0,0xffffe
    2dc8:	c5010113          	add	sp,sp,-944
    2dcc:	6785                	lui	a5,0x1
    2dce:	3a112623          	sw	ra,940(sp)
    2dd2:	37078793          	add	a5,a5,880 # 1370 <sd_send_cmd+0xb2>
    2dd6:	3a812423          	sw	s0,936(sp)
    2dda:	3a912223          	sw	s1,932(sp)
    2dde:	3b212023          	sw	s2,928(sp)
    2de2:	39312e23          	sw	s3,924(sp)
    2de6:	39412c23          	sw	s4,920(sp)
    2dea:	6985                	lui	s3,0x1
    2dec:	39512a23          	sw	s5,916(sp)
    2df0:	39612823          	sw	s6,912(sp)
    2df4:	39712623          	sw	s7,908(sp)
    2df8:	39812423          	sw	s8,904(sp)
    2dfc:	39912223          	sw	s9,900(sp)
    2e00:	39a12023          	sw	s10,896(sp)
    2e04:	37b12e23          	sw	s11,892(sp)
    2e08:	9116                	add	sp,sp,t0
    2e0a:	002784b3          	add	s1,a5,sp
    2e0e:	80098913          	add	s2,s3,-2048 # 800 <mfdc+0x7>
    2e12:	864a                	mv	a2,s2
    2e14:	4581                	li	a1,0
    2e16:	80048513          	add	a0,s1,-2048
    2e1a:	188010ef          	jal	3fa2 <memset>
    2e1e:	1e80                	add	s0,sp,880
    2e20:	864e                	mv	a2,s3
    2e22:	4581                	li	a1,0
    2e24:	8526                	mv	a0,s1
    2e26:	03242623          	sw	s2,44(s0)
    2e2a:	178010ef          	jal	3fa2 <memset>
    2e2e:	08200613          	li	a2,130
    2e32:	4581                	li	a1,0
    2e34:	2da40513          	add	a0,s0,730
    2e38:	35c40913          	add	s2,s0,860
    2e3c:	03342823          	sw	s3,48(s0)
    2e40:	162010ef          	jal	3fa2 <memset>
    2e44:	4485                	li	s1,1
    2e46:	4d99                	li	s11,6
    2e48:	08400613          	li	a2,132
    2e4c:	4581                	li	a1,0
    2e4e:	854a                	mv	a0,s2
    2e50:	2c940c23          	sb	s1,728(s0)
    2e54:	2db40ca3          	sb	s11,729(s0)
    2e58:	14a010ef          	jal	3fa2 <memset>
    2e5c:	500115b7          	lui	a1,0x50011
    2e60:	462d                	li	a2,11
    2e62:	d0c58593          	add	a1,a1,-756 # 50010d0c <__func__.2+0x8c>
    2e66:	6d010513          	add	a0,sp,1744
    2e6a:	1e0010ef          	jal	404a <memcpy>
    2e6e:	3e040a93          	add	s5,s0,992
    2e72:	08400613          	li	a2,132
    2e76:	4581                	li	a1,0
    2e78:	8556                	mv	a0,s5
    2e7a:	128010ef          	jal	3fa2 <memset>
    2e7e:	08200613          	li	a2,130
    2e82:	4581                	li	a1,0
    2e84:	46640513          	add	a0,s0,1126
    2e88:	11a010ef          	jal	3fa2 <memset>
    2e8c:	f9040d13          	add	s10,s0,-112
    2e90:	2d840593          	add	a1,s0,728
    2e94:	08400613          	li	a2,132
    2e98:	856a                	mv	a0,s10
    2e9a:	f0040c93          	add	s9,s0,-256
    2e9e:	46940223          	sb	s1,1124(s0)
    2ea2:	47b402a3          	sb	s11,1125(s0)
    2ea6:	1a4010ef          	jal	404a <memcpy>
    2eaa:	85ca                	mv	a1,s2
    2eac:	08400613          	li	a2,132
    2eb0:	8566                	mv	a0,s9
    2eb2:	198010ef          	jal	404a <memcpy>
    2eb6:	e7040c13          	add	s8,s0,-400
    2eba:	85d6                	mv	a1,s5
    2ebc:	08400613          	li	a2,132
    2ec0:	8562                	mv	a0,s8
    2ec2:	188010ef          	jal	404a <memcpy>
    2ec6:	de040b13          	add	s6,s0,-544
    2eca:	46440b93          	add	s7,s0,1124
    2ece:	85de                	mv	a1,s7
    2ed0:	08400613          	li	a2,132
    2ed4:	855a                	mv	a0,s6
    2ed6:	174010ef          	jal	404a <memcpy>
    2eda:	86da                	mv	a3,s6
    2edc:	8662                	mv	a2,s8
    2ede:	85e6                	mv	a1,s9
    2ee0:	856a                	mv	a0,s10
    2ee2:	b71fd0ef          	jal	a52 <hmac_flow>
    2ee6:	50011537          	lui	a0,0x50011
    2eea:	d1850513          	add	a0,a0,-744 # 50010d18 <__func__.2+0x98>
    2eee:	99afe0ef          	jal	1088 <puts>
    2ef2:	08200613          	li	a2,130
    2ef6:	4581                	li	a1,0
    2ef8:	4ea40513          	add	a0,s0,1258
    2efc:	0a6010ef          	jal	3fa2 <memset>
    2f00:	08200613          	li	a2,130
    2f04:	4581                	li	a1,0
    2f06:	56e40513          	add	a0,s0,1390
    2f0a:	4e940423          	sb	s1,1256(s0)
    2f0e:	4fb404a3          	sb	s11,1257(s0)
    2f12:	090010ef          	jal	3fa2 <memset>
    2f16:	4e840593          	add	a1,s0,1256
    2f1a:	08400613          	li	a2,132
    2f1e:	856a                	mv	a0,s10
    2f20:	56940623          	sb	s1,1388(s0)
    2f24:	569406a3          	sb	s1,1389(s0)
    2f28:	122010ef          	jal	404a <memcpy>
    2f2c:	56c40593          	add	a1,s0,1388
    2f30:	08400613          	li	a2,132
    2f34:	8566                	mv	a0,s9
    2f36:	114010ef          	jal	404a <memcpy>
    2f3a:	85d6                	mv	a1,s5
    2f3c:	08400613          	li	a2,132
    2f40:	8562                	mv	a0,s8
    2f42:	108010ef          	jal	404a <memcpy>
    2f46:	85de                	mv	a1,s7
    2f48:	08400613          	li	a2,132
    2f4c:	855a                	mv	a0,s6
    2f4e:	0fc010ef          	jal	404a <memcpy>
    2f52:	86da                	mv	a3,s6
    2f54:	8662                	mv	a2,s8
    2f56:	85e6                	mv	a1,s9
    2f58:	856a                	mv	a0,s10
    2f5a:	af9fd0ef          	jal	a52 <hmac_flow>
    2f5e:	50011537          	lui	a0,0x50011
    2f62:	d4450513          	add	a0,a0,-700 # 50010d44 <__func__.2+0xc4>
    2f66:	922fe0ef          	jal	1088 <puts>
    2f6a:	50011537          	lui	a0,0x50011
    2f6e:	d7450513          	add	a0,a0,-652 # 50010d74 <__func__.2+0xf4>
    2f72:	916fe0ef          	jal	1088 <puts>
    2f76:	0220000f          	fence	r,r
    2f7a:	0220000f          	fence	r,r
    2f7e:	100187b7          	lui	a5,0x10018
    2f82:	0791                	add	a5,a5,4 # 10018004 <_bss_lma_end+0x10012b78>
    2f84:	4711                	li	a4,4
    2f86:	c398                	sw	a4,0(a5)
    2f88:	4398                	lw	a4,0(a5)
    2f8a:	8b11                	and	a4,a4,4
    2f8c:	ff75                	bnez	a4,2f88 <ldevid+0x1c2>
    2f8e:	50011537          	lui	a0,0x50011
    2f92:	da050513          	add	a0,a0,-608 # 50010da0 <__func__.2+0x120>
    2f96:	1e80                	add	s0,sp,880
    2f98:	8f0fe0ef          	jal	1088 <puts>
    2f9c:	08200613          	li	a2,130
    2fa0:	4581                	li	a1,0
    2fa2:	5f240513          	add	a0,s0,1522
    2fa6:	7fd000ef          	jal	3fa2 <memset>
    2faa:	67440a13          	add	s4,s0,1652
    2fae:	4485                	li	s1,1
    2fb0:	4799                	li	a5,6
    2fb2:	08400613          	li	a2,132
    2fb6:	4581                	li	a1,0
    2fb8:	8552                	mv	a0,s4
    2fba:	5ef408a3          	sb	a5,1521(s0)
    2fbe:	5e940823          	sb	s1,1520(s0)
    2fc2:	7e1000ef          	jal	3fa2 <memset>
    2fc6:	6785                	lui	a5,0x1
    2fc8:	9e878793          	add	a5,a5,-1560 # 9e8 <ecc_verifying_flow+0x12a>
    2fcc:	500115b7          	lui	a1,0x50011
    2fd0:	00278533          	add	a0,a5,sp
    2fd4:	4639                	li	a2,14
    2fd6:	dc458593          	add	a1,a1,-572 # 50010dc4 <__func__.2+0x144>
    2fda:	070010ef          	jal	404a <memcpy>
    2fde:	6f840993          	add	s3,s0,1784
    2fe2:	08400613          	li	a2,132
    2fe6:	4581                	li	a1,0
    2fe8:	854e                	mv	a0,s3
    2fea:	7b9000ef          	jal	3fa2 <memset>
    2fee:	08200613          	li	a2,130
    2ff2:	4581                	li	a1,0
    2ff4:	77e40513          	add	a0,s0,1918
    2ff8:	7ab000ef          	jal	3fa2 <memset>
    2ffc:	490d                	li	s2,3
    2ffe:	5f040593          	add	a1,s0,1520
    3002:	08400613          	li	a2,132
    3006:	f9040513          	add	a0,s0,-112
    300a:	76940e23          	sb	s1,1916(s0)
    300e:	77240ea3          	sb	s2,1917(s0)
    3012:	038010ef          	jal	404a <memcpy>
    3016:	85d2                	mv	a1,s4
    3018:	08400613          	li	a2,132
    301c:	f0040513          	add	a0,s0,-256
    3020:	02a010ef          	jal	404a <memcpy>
    3024:	85ce                	mv	a1,s3
    3026:	08400613          	li	a2,132
    302a:	e7040513          	add	a0,s0,-400
    302e:	01c010ef          	jal	404a <memcpy>
    3032:	77c40593          	add	a1,s0,1916
    3036:	08400613          	li	a2,132
    303a:	de040513          	add	a0,s0,-544
    303e:	00c010ef          	jal	404a <memcpy>
    3042:	0a94                	add	a3,sp,336
    3044:	1390                	add	a2,sp,480
    3046:	1c8c                	add	a1,sp,624
    3048:	0608                	add	a0,sp,768
    304a:	a09fd0ef          	jal	a52 <hmac_flow>
    304e:	50011537          	lui	a0,0x50011
    3052:	dd450513          	add	a0,a0,-556 # 50010dd4 <__func__.2+0x154>
    3056:	832fe0ef          	jal	1088 <puts>
    305a:	03200613          	li	a2,50
    305e:	4581                	li	a1,0
    3060:	06640513          	add	a0,s0,102
    3064:	73f000ef          	jal	3fa2 <memset>
    3068:	03400613          	li	a2,52
    306c:	4581                	li	a1,0
    306e:	09840513          	add	a0,s0,152
    3072:	06940223          	sb	s1,100(s0)
    3076:	072402a3          	sb	s2,101(s0)
    307a:	729000ef          	jal	3fa2 <memset>
    307e:	03400613          	li	a2,52
    3082:	4581                	li	a1,0
    3084:	0cc40513          	add	a0,s0,204
    3088:	71b000ef          	jal	3fa2 <memset>
    308c:	03200613          	li	a2,50
    3090:	4581                	li	a1,0
    3092:	10240513          	add	a0,s0,258
    3096:	70d000ef          	jal	3fa2 <memset>
    309a:	4795                	li	a5,5
    309c:	03400613          	li	a2,52
    30a0:	4581                	li	a1,0
    30a2:	13440513          	add	a0,s0,308
    30a6:	10f400a3          	sb	a5,257(s0)
    30aa:	10940023          	sb	s1,256(s0)
    30ae:	6f5000ef          	jal	3fa2 <memset>
    30b2:	03400613          	li	a2,52
    30b6:	4581                	li	a1,0
    30b8:	16840513          	add	a0,s0,360
    30bc:	12940a23          	sb	s1,308(s0)
    30c0:	6e3000ef          	jal	3fa2 <memset>
    30c4:	4d810793          	add	a5,sp,1240
    30c8:	4a410713          	add	a4,sp,1188
    30cc:	47010693          	add	a3,sp,1136
    30d0:	43c10613          	add	a2,sp,1084
    30d4:	40810593          	add	a1,sp,1032
    30d8:	0fc8                	add	a0,sp,980
    30da:	16940423          	sb	s1,360(s0)
    30de:	a24fd0ef          	jal	302 <ecc_keygen_flow>
    30e2:	50011537          	lui	a0,0x50011
    30e6:	e0050513          	add	a0,a0,-512 # 50010e00 <__func__.2+0x180>
    30ea:	f9ffd0ef          	jal	1088 <puts>
    30ee:	0220000f          	fence	r,r
    30f2:	0220000f          	fence	r,r
    30f6:	100187b7          	lui	a5,0x10018
    30fa:	07b1                	add	a5,a5,12 # 1001800c <_bss_lma_end+0x10012b80>
    30fc:	4711                	li	a4,4
    30fe:	c398                	sw	a4,0(a5)
    3100:	4380                	lw	s0,0(a5)
    3102:	8811                	and	s0,s0,4
    3104:	fc75                	bnez	s0,3100 <ldevid+0x33a>
    3106:	50011537          	lui	a0,0x50011
    310a:	e3c50513          	add	a0,a0,-452 # 50010e3c <__func__.2+0x1bc>
    310e:	f7bfd0ef          	jal	1088 <puts>
    3112:	4a810493          	add	s1,sp,1192
    3116:	4dc10593          	add	a1,sp,1244
    311a:	468d                	li	a3,3
    311c:	4609                	li	a2,2
    311e:	8526                	mv	a0,s1
    3120:	c62e                	sw	a1,12(sp)
    3122:	846fd0ef          	jal	168 <store_to_datavault>
    3126:	6785                	lui	a5,0x1
    3128:	b7078793          	add	a5,a5,-1168 # b70 <hmac_flow+0x11e>
    312c:	00278a33          	add	s4,a5,sp
    3130:	500116b7          	lui	a3,0x50011
    3134:	50011637          	lui	a2,0x50011
    3138:	4805                	li	a6,1
    313a:	0f7c                	add	a5,sp,924
    313c:	8752                	mv	a4,s4
    313e:	e6068693          	add	a3,a3,-416 # 50010e60 <__func__.2+0x1e0>
    3142:	e7460613          	add	a2,a2,-396 # 50010e74 <__func__.2+0x1f4>
    3146:	45b2                	lw	a1,12(sp)
    3148:	8526                	mv	a0,s1
    314a:	f30ff0ef          	jal	287a <generate_intermediate_tbs_der>
    314e:	892a                	mv	s2,a0
    3150:	30051563          	bnez	a0,345a <ldevid+0x694>
    3154:	6785                	lui	a5,0x1
    3156:	80078793          	add	a5,a5,-2048 # 800 <mfdc+0x7>
    315a:	39c12583          	lw	a1,924(sp)
    315e:	37010993          	add	s3,sp,880
    3162:	2eb7ec63          	bltu	a5,a1,345a <ldevid+0x694>
    3166:	500114b7          	lui	s1,0x50011
    316a:	e8848513          	add	a0,s1,-376 # 50010e88 <__func__.2+0x208>
    316e:	f1dfd0ef          	jal	108a <printf>
    3172:	50011537          	lui	a0,0x50011
    3176:	e9c50513          	add	a0,a0,-356 # 50010e9c <__func__.2+0x21c>
    317a:	f0ffd0ef          	jal	1088 <puts>
    317e:	4abd                	li	s5,15
    3180:	50011b37          	lui	s6,0x50011
    3184:	50011bb7          	lui	s7,0x50011
    3188:	50011c37          	lui	s8,0x50011
    318c:	02c9a783          	lw	a5,44(s3)
    3190:	2af96563          	bltu	s2,a5,343a <ldevid+0x674>
    3194:	4529                	li	a0,10
    3196:	eedfd0ef          	jal	1082 <putchar>
    319a:	5001f7b7          	lui	a5,0x5001f
    319e:	02c9aa83          	lw	s5,44(s3)
    31a2:	82078793          	add	a5,a5,-2016 # 5001e820 <tbs_der_store>
    31a6:	4685                	li	a3,1
    31a8:	40d78623          	sb	a3,1036(a5)
    31ac:	4157a423          	sw	s5,1032(a5)
    31b0:	6785                	lui	a5,0x1
    31b2:	b7078793          	add	a5,a5,-1168 # b70 <hmac_flow+0x11e>
    31b6:	00278a33          	add	s4,a5,sp
    31ba:	5001f537          	lui	a0,0x5001f
    31be:	8656                	mv	a2,s5
    31c0:	85d2                	mv	a1,s4
    31c2:	a2850513          	add	a0,a0,-1496 # 5001ea28 <tbs_der_store+0x208>
    31c6:	685000ef          	jal	404a <memcpy>
    31ca:	3a410913          	add	s2,sp,932
    31ce:	4685                	li	a3,1
    31d0:	864a                	mv	a2,s2
    31d2:	85d6                	mv	a1,s5
    31d4:	8552                	mv	a0,s4
    31d6:	b3bfe0ef          	jal	1d10 <sha384_digest>
    31da:	03400613          	li	a2,52
    31de:	4581                	li	a1,0
    31e0:	19c98513          	add	a0,s3,412
    31e4:	5bf000ef          	jal	3fa2 <memset>
    31e8:	1e94                	add	a3,sp,880
    31ea:	03000513          	li	a0,48
    31ee:	008907b3          	add	a5,s2,s0
    31f2:	4390                	lw	a2,0(a5)
    31f4:	43cc                	lw	a1,4(a5)
    31f6:	28068793          	add	a5,a3,640
    31fa:	d38c                	sw	a1,32(a5)
    31fc:	d3d0                	sw	a2,36(a5)
    31fe:	51010793          	add	a5,sp,1296
    3202:	97a2                	add	a5,a5,s0
    3204:	c38c                	sw	a1,0(a5)
    3206:	c3d0                	sw	a2,4(a5)
    3208:	0421                	add	s0,s0,8
    320a:	50c10993          	add	s3,sp,1292
    320e:	fea410e3          	bne	s0,a0,31ee <ldevid+0x428>
    3212:	50011537          	lui	a0,0x50011
    3216:	ed450513          	add	a0,a0,-300 # 50010ed4 <__func__.2+0x254>
    321a:	e6ffd0ef          	jal	1088 <puts>
    321e:	53c10413          	add	s0,sp,1340
    3222:	50011937          	lui	s2,0x50011
    3226:	0049a583          	lw	a1,4(s3)
    322a:	b9090513          	add	a0,s2,-1136 # 50010b90 <k+0x310>
    322e:	0991                	add	s3,s3,4
    3230:	e5bfd0ef          	jal	108a <printf>
    3234:	fe8999e3          	bne	s3,s0,3226 <ldevid+0x460>
    3238:	4529                	li	a0,10
    323a:	e49fd0ef          	jal	1082 <putchar>
    323e:	03200613          	li	a2,50
    3242:	4581                	li	a1,0
    3244:	54210513          	add	a0,sp,1346
    3248:	55b000ef          	jal	3fa2 <memset>
    324c:	479d                	li	a5,7
    324e:	4985                	li	s3,1
    3250:	03400613          	li	a2,52
    3254:	4581                	li	a1,0
    3256:	57410513          	add	a0,sp,1396
    325a:	54f100a3          	sb	a5,1345(sp)
    325e:	55310023          	sb	s3,1344(sp)
    3262:	541000ef          	jal	3fa2 <memset>
    3266:	03400613          	li	a2,52
    326a:	4581                	li	a1,0
    326c:	5a810513          	add	a0,sp,1448
    3270:	57310a23          	sb	s3,1396(sp)
    3274:	57410413          	add	s0,sp,1396
    3278:	52b000ef          	jal	3fa2 <memset>
    327c:	5a810713          	add	a4,sp,1448
    3280:	86a2                	mv	a3,s0
    3282:	43c10613          	add	a2,sp,1084
    3286:	50c10593          	add	a1,sp,1292
    328a:	54010513          	add	a0,sp,1344
    328e:	5b310423          	sb	s3,1448(sp)
    3292:	bccfd0ef          	jal	65e <ecc_signing_flow>
    3296:	50011537          	lui	a0,0x50011
    329a:	ee450513          	add	a0,a0,-284 # 50010ee4 <__func__.2+0x264>
    329e:	debfd0ef          	jal	1088 <puts>
    32a2:	5a410a13          	add	s4,sp,1444
    32a6:	500119b7          	lui	s3,0x50011
    32aa:	404c                	lw	a1,4(s0)
    32ac:	ef498513          	add	a0,s3,-268 # 50010ef4 <__func__.2+0x274>
    32b0:	0411                	add	s0,s0,4
    32b2:	dd9fd0ef          	jal	108a <printf>
    32b6:	ff441ae3          	bne	s0,s4,32aa <ldevid+0x4e4>
    32ba:	50011537          	lui	a0,0x50011
    32be:	efc50513          	add	a0,a0,-260 # 50010efc <__func__.2+0x27c>
    32c2:	dc7fd0ef          	jal	1088 <puts>
    32c6:	5a810413          	add	s0,sp,1448
    32ca:	5d810a13          	add	s4,sp,1496
    32ce:	404c                	lw	a1,4(s0)
    32d0:	ef498513          	add	a0,s3,-268
    32d4:	0411                	add	s0,s0,4
    32d6:	db5fd0ef          	jal	108a <printf>
    32da:	ff441ae3          	bne	s0,s4,32ce <ldevid+0x508>
    32de:	4529                	li	a0,10
    32e0:	da3fd0ef          	jal	1082 <putchar>
    32e4:	0220000f          	fence	r,r
    32e8:	0220000f          	fence	r,r
    32ec:	100187b7          	lui	a5,0x10018
    32f0:	07f1                	add	a5,a5,28 # 1001801c <_bss_lma_end+0x10012b90>
    32f2:	4711                	li	a4,4
    32f4:	c398                	sw	a4,0(a5)
    32f6:	4398                	lw	a4,0(a5)
    32f8:	8b11                	and	a4,a4,4
    32fa:	ff75                	bnez	a4,32f6 <ldevid+0x530>
    32fc:	50011537          	lui	a0,0x50011
    3300:	f0c50513          	add	a0,a0,-244 # 50010f0c <__func__.2+0x28c>
    3304:	d85fd0ef          	jal	1088 <puts>
    3308:	03400613          	li	a2,52
    330c:	4581                	li	a1,0
    330e:	5dc10513          	add	a0,sp,1500
    3312:	491000ef          	jal	3fa2 <memset>
    3316:	03400613          	li	a2,52
    331a:	4581                	li	a1,0
    331c:	61010513          	add	a0,sp,1552
    3320:	483000ef          	jal	3fa2 <memset>
    3324:	46a5                	li	a3,9
    3326:	4621                	li	a2,8
    3328:	61410593          	add	a1,sp,1556
    332c:	5e010513          	add	a0,sp,1504
    3330:	f21fc0ef          	jal	250 <read_from_datavault>
    3334:	50011537          	lui	a0,0x50011
    3338:	f3050513          	add	a0,a0,-208 # 50010f30 <__func__.2+0x2b0>
    333c:	5dc10413          	add	s0,sp,1500
    3340:	d49fd0ef          	jal	1088 <puts>
    3344:	60c10993          	add	s3,sp,1548
    3348:	404c                	lw	a1,4(s0)
    334a:	b9090513          	add	a0,s2,-1136
    334e:	0411                	add	s0,s0,4
    3350:	d3bfd0ef          	jal	108a <printf>
    3354:	ff341ae3          	bne	s0,s3,3348 <ldevid+0x582>
    3358:	4529                	li	a0,10
    335a:	d29fd0ef          	jal	1082 <putchar>
    335e:	50011537          	lui	a0,0x50011
    3362:	f4850513          	add	a0,a0,-184 # 50010f48 <__func__.2+0x2c8>
    3366:	d23fd0ef          	jal	1088 <puts>
    336a:	61010413          	add	s0,sp,1552
    336e:	64010993          	add	s3,sp,1600
    3372:	404c                	lw	a1,4(s0)
    3374:	b9090513          	add	a0,s2,-1136
    3378:	0411                	add	s0,s0,4
    337a:	d11fd0ef          	jal	108a <printf>
    337e:	ff341ae3          	bne	s0,s3,3372 <ldevid+0x5ac>
    3382:	4529                	li	a0,10
    3384:	1e80                	add	s0,sp,880
    3386:	cfdfd0ef          	jal	1082 <putchar>
    338a:	03400613          	li	a2,52
    338e:	19c40593          	add	a1,s0,412
    3392:	da040513          	add	a0,s0,-608
    3396:	4b5000ef          	jal	404a <memcpy>
    339a:	03400613          	li	a2,52
    339e:	26c40593          	add	a1,s0,620
    33a2:	d6040513          	add	a0,s0,-672
    33a6:	4a5000ef          	jal	404a <memcpy>
    33aa:	03400613          	li	a2,52
    33ae:	2a040593          	add	a1,s0,672
    33b2:	d2040513          	add	a0,s0,-736
    33b6:	495000ef          	jal	404a <memcpy>
    33ba:	03400613          	li	a2,52
    33be:	20440593          	add	a1,s0,516
    33c2:	ce040513          	add	a0,s0,-800
    33c6:	485000ef          	jal	404a <memcpy>
    33ca:	03400613          	li	a2,52
    33ce:	23840593          	add	a1,s0,568
    33d2:	ca040513          	add	a0,s0,-864
    33d6:	475000ef          	jal	404a <memcpy>
    33da:	0818                	add	a4,sp,16
    33dc:	0894                	add	a3,sp,80
    33de:	0910                	add	a2,sp,144
    33e0:	098c                	add	a1,sp,208
    33e2:	0a08                	add	a0,sp,272
    33e4:	cdafd0ef          	jal	8be <ecc_verifying_flow>
    33e8:	e141                	bnez	a0,3468 <ldevid+0x6a2>
    33ea:	50011537          	lui	a0,0x50011
    33ee:	f6050513          	add	a0,a0,-160 # 50010f60 <__func__.2+0x2e0>
    33f2:	c97fd0ef          	jal	1088 <puts>
    33f6:	57810913          	add	s2,sp,1400
    33fa:	5ac10993          	add	s3,sp,1452
    33fe:	4685                	li	a3,1
    3400:	4601                	li	a2,0
    3402:	85ce                	mv	a1,s3
    3404:	854a                	mv	a0,s2
    3406:	d63fc0ef          	jal	168 <store_to_datavault>
    340a:	6505                	lui	a0,0x1
    340c:	37050793          	add	a5,a0,880 # 1370 <sd_send_cmd+0xb2>
    3410:	00278a33          	add	s4,a5,sp
    3414:	b7050513          	add	a0,a0,-1168
    3418:	864a                	mv	a2,s2
    341a:	171c                	add	a5,sp,928
    341c:	8752                	mv	a4,s4
    341e:	86ce                	mv	a3,s3
    3420:	544c                	lw	a1,44(s0)
    3422:	950a                	add	a0,a0,sp
    3424:	fb6ff0ef          	jal	2bda <add_signature_to_cert>
    3428:	892a                	mv	s2,a0
    342a:	c531                	beqz	a0,3476 <ldevid+0x6b0>
    342c:	50011537          	lui	a0,0x50011
    3430:	eb450513          	add	a0,a0,-332 # 50010eb4 <__func__.2+0x234>
    3434:	c55fd0ef          	jal	1088 <puts>
    3438:	a001                	j	3438 <ldevid+0x672>
    343a:	012a07b3          	add	a5,s4,s2
    343e:	0007c603          	lbu	a2,0(a5)
    3442:	cd4b0593          	add	a1,s6,-812 # 50010cd4 <__func__.2+0x54>
    3446:	00cae463          	bltu	s5,a2,344e <ldevid+0x688>
    344a:	d08b8593          	add	a1,s7,-760 # 50010d08 <__func__.2+0x88>
    344e:	eacc0513          	add	a0,s8,-340 # 50010eac <__func__.2+0x22c>
    3452:	c39fd0ef          	jal	108a <printf>
    3456:	0905                	add	s2,s2,1
    3458:	bb15                	j	318c <ldevid+0x3c6>
    345a:	50011537          	lui	a0,0x50011
    345e:	eb450513          	add	a0,a0,-332 # 50010eb4 <__func__.2+0x234>
    3462:	c27fd0ef          	jal	1088 <puts>
    3466:	a001                	j	3466 <ldevid+0x6a0>
    3468:	50011537          	lui	a0,0x50011
    346c:	f8450513          	add	a0,a0,-124 # 50010f84 <__func__.2+0x304>
    3470:	c19fd0ef          	jal	1088 <puts>
    3474:	a001                	j	3474 <ldevid+0x6ae>
    3476:	580c                	lw	a1,48(s0)
    3478:	6785                	lui	a5,0x1
    347a:	fab7e9e3          	bltu	a5,a1,342c <ldevid+0x666>
    347e:	e8848513          	add	a0,s1,-376
    3482:	c09fd0ef          	jal	108a <printf>
    3486:	50011537          	lui	a0,0x50011
    348a:	fa450513          	add	a0,a0,-92 # 50010fa4 <__func__.2+0x324>
    348e:	bfbfd0ef          	jal	1088 <puts>
    3492:	44bd                	li	s1,15
    3494:	500119b7          	lui	s3,0x50011
    3498:	50011ab7          	lui	s5,0x50011
    349c:	50011b37          	lui	s6,0x50011
    34a0:	581c                	lw	a5,48(s0)
    34a2:	06f96963          	bltu	s2,a5,3514 <ldevid+0x74e>
    34a6:	4529                	li	a0,10
    34a8:	bdbfd0ef          	jal	1082 <putchar>
    34ac:	5001e7b7          	lui	a5,0x5001e
    34b0:	5810                	lw	a2,48(s0)
    34b2:	00078793          	mv	a5,a5
    34b6:	4705                	li	a4,1
    34b8:	40c7a423          	sw	a2,1032(a5) # 5001e408 <cert_store+0x408>
    34bc:	40e78623          	sb	a4,1036(a5)
    34c0:	6785                	lui	a5,0x1
    34c2:	37078793          	add	a5,a5,880 # 1370 <sd_send_cmd+0xb2>
    34c6:	5001e537          	lui	a0,0x5001e
    34ca:	002785b3          	add	a1,a5,sp
    34ce:	20850513          	add	a0,a0,520 # 5001e208 <cert_store+0x208>
    34d2:	379000ef          	jal	404a <memcpy>
    34d6:	6289                	lui	t0,0x2
    34d8:	9116                	add	sp,sp,t0
    34da:	3ac12083          	lw	ra,940(sp)
    34de:	3a812403          	lw	s0,936(sp)
    34e2:	3a412483          	lw	s1,932(sp)
    34e6:	3a012903          	lw	s2,928(sp)
    34ea:	39c12983          	lw	s3,924(sp)
    34ee:	39812a03          	lw	s4,920(sp)
    34f2:	39412a83          	lw	s5,916(sp)
    34f6:	39012b03          	lw	s6,912(sp)
    34fa:	38c12b83          	lw	s7,908(sp)
    34fe:	38812c03          	lw	s8,904(sp)
    3502:	38412c83          	lw	s9,900(sp)
    3506:	38012d03          	lw	s10,896(sp)
    350a:	37c12d83          	lw	s11,892(sp)
    350e:	3b010113          	add	sp,sp,944
    3512:	8082                	ret
    3514:	012a07b3          	add	a5,s4,s2
    3518:	0007c603          	lbu	a2,0(a5)
    351c:	cd498593          	add	a1,s3,-812 # 50010cd4 <__func__.2+0x54>
    3520:	00c4e463          	bltu	s1,a2,3528 <ldevid+0x762>
    3524:	d08a8593          	add	a1,s5,-760 # 50010d08 <__func__.2+0x88>
    3528:	eacb0513          	add	a0,s6,-340 # 50010eac <__func__.2+0x22c>
    352c:	b5ffd0ef          	jal	108a <printf>
    3530:	0905                	add	s2,s2,1
    3532:	b7bd                	j	34a0 <ldevid+0x6da>

00003534 <idevid>:
    3534:	72f9                	lui	t0,0xffffe
    3536:	7179                	add	sp,sp,-48
    3538:	0e028293          	add	t0,t0,224 # ffffe0e0 <_tbs_der_store_end+0xaffdf0c0>
    353c:	6785                	lui	a5,0x1
    353e:	d606                	sw	ra,44(sp)
    3540:	f2078793          	add	a5,a5,-224 # f20 <whisperPrintfImpl+0x2>
    3544:	d422                	sw	s0,40(sp)
    3546:	d226                	sw	s1,36(sp)
    3548:	d04a                	sw	s2,32(sp)
    354a:	ce4e                	sw	s3,28(sp)
    354c:	cc52                	sw	s4,24(sp)
    354e:	ca56                	sw	s5,20(sp)
    3550:	c85a                	sw	s6,16(sp)
    3552:	c65e                	sw	s7,12(sp)
    3554:	c462                	sw	s8,8(sp)
    3556:	c266                	sw	s9,4(sp)
    3558:	6905                	lui	s2,0x1
    355a:	9116                	add	sp,sp,t0
    355c:	00f104b3          	add	s1,sp,a5
    3560:	80090913          	add	s2,s2,-2048 # 800 <mfdc+0x7>
    3564:	864a                	mv	a2,s2
    3566:	4581                	li	a1,0
    3568:	80048513          	add	a0,s1,-2048
    356c:	237000ef          	jal	3fa2 <memset>
    3570:	6605                	lui	a2,0x1
    3572:	4581                	li	a1,0
    3574:	8526                	mv	a0,s1
    3576:	25212023          	sw	s2,576(sp)
    357a:	229000ef          	jal	3fa2 <memset>
    357e:	08400613          	li	a2,132
    3582:	4581                	li	a1,0
    3584:	0748                	add	a0,sp,900
    3586:	21d000ef          	jal	3fa2 <memset>
    358a:	4785                	li	a5,1
    358c:	08400613          	li	a2,132
    3590:	4581                	li	a1,0
    3592:	40810513          	add	a0,sp,1032
    3596:	38f10223          	sb	a5,900(sp)
    359a:	209000ef          	jal	3fa2 <memset>
    359e:	40810413          	add	s0,sp,1032
    35a2:	500115b7          	lui	a1,0x50011
    35a6:	462d                	li	a2,11
    35a8:	fb458593          	add	a1,a1,-76 # 50010fb4 <__func__.2+0x334>
    35ac:	00440513          	add	a0,s0,4
    35b0:	29b000ef          	jal	404a <memcpy>
    35b4:	50011537          	lui	a0,0x50011
    35b8:	fc050513          	add	a0,a0,-64 # 50010fc0 <__func__.2+0x340>
    35bc:	acdfd0ef          	jal	1088 <puts>
    35c0:	4901                	li	s2,0
    35c2:	500114b7          	lui	s1,0x50011
    35c6:	4a3d                	li	s4,15
    35c8:	02000993          	li	s3,32
    35cc:	404c                	lw	a1,4(s0)
    35ce:	b9048513          	add	a0,s1,-1136 # 50010b90 <k+0x310>
    35d2:	ab9fd0ef          	jal	108a <printf>
    35d6:	00f97793          	and	a5,s2,15
    35da:	01479563          	bne	a5,s4,35e4 <idevid+0xb0>
    35de:	4529                	li	a0,10
    35e0:	aa3fd0ef          	jal	1082 <putchar>
    35e4:	0905                	add	s2,s2,1
    35e6:	0411                	add	s0,s0,4
    35e8:	ff3912e3          	bne	s2,s3,35cc <idevid+0x98>
    35ec:	4529                	li	a0,10
    35ee:	a95fd0ef          	jal	1082 <putchar>
    35f2:	48c10913          	add	s2,sp,1164
    35f6:	08400613          	li	a2,132
    35fa:	4581                	li	a1,0
    35fc:	854a                	mv	a0,s2
    35fe:	1a5000ef          	jal	3fa2 <memset>
    3602:	08200613          	li	a2,130
    3606:	4581                	li	a1,0
    3608:	51210513          	add	a0,sp,1298
    360c:	197000ef          	jal	3fa2 <memset>
    3610:	4785                	li	a5,1
    3612:	50f10823          	sb	a5,1296(sp)
    3616:	074c                	add	a1,sp,900
    3618:	4799                	li	a5,6
    361a:	08400613          	li	a2,132
    361e:	1b08                	add	a0,sp,432
    3620:	50f108a3          	sb	a5,1297(sp)
    3624:	227000ef          	jal	404a <memcpy>
    3628:	40810593          	add	a1,sp,1032
    362c:	08400613          	li	a2,132
    3630:	1208                	add	a0,sp,288
    3632:	219000ef          	jal	404a <memcpy>
    3636:	85ca                	mv	a1,s2
    3638:	08400613          	li	a2,132
    363c:	0908                	add	a0,sp,144
    363e:	20d000ef          	jal	404a <memcpy>
    3642:	51010593          	add	a1,sp,1296
    3646:	08400613          	li	a2,132
    364a:	850a                	mv	a0,sp
    364c:	1ff000ef          	jal	404a <memcpy>
    3650:	868a                	mv	a3,sp
    3652:	0910                	add	a2,sp,144
    3654:	120c                	add	a1,sp,288
    3656:	1b08                	add	a0,sp,432
    3658:	bfafd0ef          	jal	a52 <hmac_flow>
    365c:	50011537          	lui	a0,0x50011
    3660:	fd050513          	add	a0,a0,-48 # 50010fd0 <__func__.2+0x350>
    3664:	a25fd0ef          	jal	1088 <puts>
    3668:	0220000f          	fence	r,r
    366c:	0220000f          	fence	r,r
    3670:	10018737          	lui	a4,0x10018
    3674:	4791                	li	a5,4
    3676:	c31c                	sw	a5,0(a4)
    3678:	431c                	lw	a5,0(a4)
    367a:	8b91                	and	a5,a5,4
    367c:	fff5                	bnez	a5,3678 <idevid+0x144>
    367e:	50011537          	lui	a0,0x50011
    3682:	ffc50513          	add	a0,a0,-4 # 50010ffc <__func__.2+0x37c>
    3686:	a03fd0ef          	jal	1088 <puts>
    368a:	08200613          	li	a2,130
    368e:	4581                	li	a1,0
    3690:	59610513          	add	a0,sp,1430
    3694:	10f000ef          	jal	3fa2 <memset>
    3698:	4785                	li	a5,1
    369a:	58f10a23          	sb	a5,1428(sp)
    369e:	08400613          	li	a2,132
    36a2:	4799                	li	a5,6
    36a4:	4581                	li	a1,0
    36a6:	61810513          	add	a0,sp,1560
    36aa:	58f10aa3          	sb	a5,1429(sp)
    36ae:	0f5000ef          	jal	3fa2 <memset>
    36b2:	61810413          	add	s0,sp,1560
    36b6:	500115b7          	lui	a1,0x50011
    36ba:	4639                	li	a2,14
    36bc:	01858593          	add	a1,a1,24 # 50011018 <__func__.2+0x398>
    36c0:	00440513          	add	a0,s0,4
    36c4:	187000ef          	jal	404a <memcpy>
    36c8:	50011537          	lui	a0,0x50011
    36cc:	02850513          	add	a0,a0,40 # 50011028 <__func__.2+0x3a8>
    36d0:	9b9fd0ef          	jal	1088 <puts>
    36d4:	4901                	li	s2,0
    36d6:	4a3d                	li	s4,15
    36d8:	02000993          	li	s3,32
    36dc:	404c                	lw	a1,4(s0)
    36de:	b9048513          	add	a0,s1,-1136
    36e2:	9a9fd0ef          	jal	108a <printf>
    36e6:	00f97793          	and	a5,s2,15
    36ea:	01479563          	bne	a5,s4,36f4 <idevid+0x1c0>
    36ee:	4529                	li	a0,10
    36f0:	993fd0ef          	jal	1082 <putchar>
    36f4:	0905                	add	s2,s2,1
    36f6:	0411                	add	s0,s0,4
    36f8:	ff3912e3          	bne	s2,s3,36dc <idevid+0x1a8>
    36fc:	4529                	li	a0,10
    36fe:	f2010413          	add	s0,sp,-224
    3702:	981fd0ef          	jal	1082 <putchar>
    3706:	08200613          	li	a2,130
    370a:	4581                	li	a1,0
    370c:	77e40513          	add	a0,s0,1918
    3710:	093000ef          	jal	3fa2 <memset>
    3714:	4905                	li	s2,1
    3716:	67440593          	add	a1,s0,1652
    371a:	498d                	li	s3,3
    371c:	08400613          	li	a2,132
    3720:	29040513          	add	a0,s0,656
    3724:	77240e23          	sb	s2,1916(s0)
    3728:	77340ea3          	sb	s3,1917(s0)
    372c:	11f000ef          	jal	404a <memcpy>
    3730:	6f840593          	add	a1,s0,1784
    3734:	08400613          	li	a2,132
    3738:	20040513          	add	a0,s0,512
    373c:	10f000ef          	jal	404a <memcpy>
    3740:	56c40593          	add	a1,s0,1388
    3744:	08400613          	li	a2,132
    3748:	17040513          	add	a0,s0,368
    374c:	0ff000ef          	jal	404a <memcpy>
    3750:	77c40593          	add	a1,s0,1916
    3754:	08400613          	li	a2,132
    3758:	850a                	mv	a0,sp
    375a:	0f1000ef          	jal	404a <memcpy>
    375e:	868a                	mv	a3,sp
    3760:	0910                	add	a2,sp,144
    3762:	120c                	add	a1,sp,288
    3764:	1b08                	add	a0,sp,432
    3766:	aecfd0ef          	jal	a52 <hmac_flow>
    376a:	50011537          	lui	a0,0x50011
    376e:	dd450513          	add	a0,a0,-556 # 50010dd4 <__func__.2+0x154>
    3772:	917fd0ef          	jal	1088 <puts>
    3776:	03200613          	li	a2,50
    377a:	4581                	li	a1,0
    377c:	32e40513          	add	a0,s0,814
    3780:	023000ef          	jal	3fa2 <memset>
    3784:	03400613          	li	a2,52
    3788:	4581                	li	a1,0
    378a:	36040513          	add	a0,s0,864
    378e:	33240623          	sb	s2,812(s0)
    3792:	333406a3          	sb	s3,813(s0)
    3796:	00d000ef          	jal	3fa2 <memset>
    379a:	03400613          	li	a2,52
    379e:	4581                	li	a1,0
    37a0:	39440513          	add	a0,s0,916
    37a4:	7fe000ef          	jal	3fa2 <memset>
    37a8:	03200613          	li	a2,50
    37ac:	4581                	li	a1,0
    37ae:	3ca40513          	add	a0,s0,970
    37b2:	7f0000ef          	jal	3fa2 <memset>
    37b6:	479d                	li	a5,7
    37b8:	03400613          	li	a2,52
    37bc:	4581                	li	a1,0
    37be:	3fc40513          	add	a0,s0,1020
    37c2:	3cf404a3          	sb	a5,969(s0)
    37c6:	3d240423          	sb	s2,968(s0)
    37ca:	7d8000ef          	jal	3fa2 <memset>
    37ce:	03400613          	li	a2,52
    37d2:	4581                	li	a1,0
    37d4:	43040513          	add	a0,s0,1072
    37d8:	3f240e23          	sb	s2,1020(s0)
    37dc:	7c6000ef          	jal	3fa2 <memset>
    37e0:	43240823          	sb	s2,1072(s0)
    37e4:	0e60                	add	s0,sp,796
    37e6:	0e9c                	add	a5,sp,848
    37e8:	8722                	mv	a4,s0
    37ea:	15b4                	add	a3,sp,744
    37ec:	1d50                	add	a2,sp,692
    37ee:	050c                	add	a1,sp,640
    37f0:	04e8                	add	a0,sp,588
    37f2:	b11fc0ef          	jal	302 <ecc_keygen_flow>
    37f6:	50011537          	lui	a0,0x50011
    37fa:	03c50513          	add	a0,a0,60 # 5001103c <__func__.2+0x3bc>
    37fe:	88bfd0ef          	jal	1088 <puts>
    3802:	50011537          	lui	a0,0x50011
    3806:	07850513          	add	a0,a0,120 # 50011078 <__func__.2+0x3f8>
    380a:	87ffd0ef          	jal	1088 <puts>
    380e:	34c10913          	add	s2,sp,844
    3812:	404c                	lw	a1,4(s0)
    3814:	b9048513          	add	a0,s1,-1136
    3818:	0411                	add	s0,s0,4
    381a:	871fd0ef          	jal	108a <printf>
    381e:	ff241ae3          	bne	s0,s2,3812 <idevid+0x2de>
    3822:	4529                	li	a0,10
    3824:	85ffd0ef          	jal	1082 <putchar>
    3828:	50011537          	lui	a0,0x50011
    382c:	08850513          	add	a0,a0,136 # 50011088 <__func__.2+0x408>
    3830:	859fd0ef          	jal	1088 <puts>
    3834:	0e80                	add	s0,sp,848
    3836:	38010913          	add	s2,sp,896
    383a:	404c                	lw	a1,4(s0)
    383c:	b9048513          	add	a0,s1,-1136
    3840:	0411                	add	s0,s0,4
    3842:	849fd0ef          	jal	108a <printf>
    3846:	ff241ae3          	bne	s0,s2,383a <idevid+0x306>
    384a:	4529                	li	a0,10
    384c:	837fd0ef          	jal	1082 <putchar>
    3850:	0220000f          	fence	r,r
    3854:	0220000f          	fence	r,r
    3858:	100187b7          	lui	a5,0x10018
    385c:	07b1                	add	a5,a5,12 # 1001800c <_bss_lma_end+0x10012b80>
    385e:	4711                	li	a4,4
    3860:	c398                	sw	a4,0(a5)
    3862:	4384                	lw	s1,0(a5)
    3864:	8891                	and	s1,s1,4
    3866:	fcf5                	bnez	s1,3862 <idevid+0x32e>
    3868:	50011537          	lui	a0,0x50011
    386c:	e3c50513          	add	a0,a0,-452 # 50010e3c <__func__.2+0x1bc>
    3870:	819fd0ef          	jal	1088 <puts>
    3874:	50011637          	lui	a2,0x50011
    3878:	72010913          	add	s2,sp,1824
    387c:	e7460693          	add	a3,a2,-396 # 50010e74 <__func__.2+0x1f4>
    3880:	4801                	li	a6,0
    3882:	049c                	add	a5,sp,576
    3884:	874a                	mv	a4,s2
    3886:	e7460613          	add	a2,a2,-396
    388a:	0ecc                	add	a1,sp,852
    388c:	1608                	add	a0,sp,800
    388e:	fedfe0ef          	jal	287a <generate_intermediate_tbs_der>
    3892:	842a                	mv	s0,a0
    3894:	18051363          	bnez	a0,3a1a <idevid+0x4e6>
    3898:	6785                	lui	a5,0x1
    389a:	80078793          	add	a5,a5,-2048 # 800 <mfdc+0x7>
    389e:	24012583          	lw	a1,576(sp)
    38a2:	f2010993          	add	s3,sp,-224
    38a6:	16b7ea63          	bltu	a5,a1,3a1a <idevid+0x4e6>
    38aa:	50011ab7          	lui	s5,0x50011
    38ae:	e88a8513          	add	a0,s5,-376 # 50010e88 <__func__.2+0x208>
    38b2:	fd8fd0ef          	jal	108a <printf>
    38b6:	50011537          	lui	a0,0x50011
    38ba:	09850513          	add	a0,a0,152 # 50011098 <__func__.2+0x418>
    38be:	fcafd0ef          	jal	1088 <puts>
    38c2:	4a01                	li	s4,0
    38c4:	4b3d                	li	s6,15
    38c6:	50011bb7          	lui	s7,0x50011
    38ca:	50011c37          	lui	s8,0x50011
    38ce:	50011cb7          	lui	s9,0x50011
    38d2:	3209a783          	lw	a5,800(s3)
    38d6:	12fa6263          	bltu	s4,a5,39fa <idevid+0x4c6>
    38da:	4529                	li	a0,10
    38dc:	fa6fd0ef          	jal	1082 <putchar>
    38e0:	5001f537          	lui	a0,0x5001f
    38e4:	82050793          	add	a5,a0,-2016 # 5001e820 <tbs_der_store>
    38e8:	3209a603          	lw	a2,800(s3)
    38ec:	72010593          	add	a1,sp,1824
    38f0:	82050513          	add	a0,a0,-2016
    38f4:	44c109b7          	lui	s3,0x44c10
    38f8:	20c7a023          	sw	a2,512(a5)
    38fc:	20078223          	sb	zero,516(a5)
    3900:	19ed                	add	s3,s3,-5 # 44c0fffb <_bss_lma_end+0x44c0ab6f>
    3902:	748000ef          	jal	404a <memcpy>
    3906:	ddbfe0ef          	jal	26e0 <soc_ifc_read_mbox_cmd>
    390a:	ff359ee3          	bne	a1,s3,3906 <idevid+0x3d2>
    390e:	50011537          	lui	a0,0x50011
    3912:	0c850513          	add	a0,a0,200 # 500110c8 <__func__.2+0x448>
    3916:	f72fd0ef          	jal	1088 <puts>
    391a:	f2010913          	add	s2,sp,-224
    391e:	24012583          	lw	a1,576(sp)
    3922:	72010513          	add	a0,sp,1824
    3926:	44c10a37          	lui	s4,0x44c10
    392a:	ad4fd0ef          	jal	bfe <mailbox_send_data>
    392e:	89ca                	mv	s3,s2
    3930:	1a71                	add	s4,s4,-4 # 44c0fffc <_bss_lma_end+0x44c0ab70>
    3932:	daffe0ef          	jal	26e0 <soc_ifc_read_mbox_cmd>
    3936:	32a9a223          	sw	a0,804(s3)
    393a:	32b9a423          	sw	a1,808(s3)
    393e:	892a                	mv	s2,a0
    3940:	ff4599e3          	bne	a1,s4,3932 <idevid+0x3fe>
    3944:	85aa                	mv	a1,a0
    3946:	50010537          	lui	a0,0x50010
    394a:	5a850513          	add	a0,a0,1448 # 500105a8 <__func__.0+0x98>
    394e:	f3cfd0ef          	jal	108a <printf>
    3952:	6785                	lui	a5,0x1
    3954:	300209b7          	lui	s3,0x30020
    3958:	f2078793          	add	a5,a5,-224 # f20 <whisperPrintfImpl+0x2>
    395c:	09d1                	add	s3,s3,20 # 30020014 <_bss_lma_end+0x3001ab88>
    395e:	00f10a33          	add	s4,sp,a5
    3962:	50011b37          	lui	s6,0x50011
    3966:	0d24e163          	bltu	s1,s2,3a28 <idevid+0x4f4>
    396a:	46a5                	li	a3,9
    396c:	4621                	li	a2,8
    396e:	0ecc                	add	a1,sp,852
    3970:	1608                	add	a0,sp,800
    3972:	ff6fc0ef          	jal	168 <store_to_datavault>
    3976:	85ca                	mv	a1,s2
    3978:	e88a8513          	add	a0,s5,-376
    397c:	f0efd0ef          	jal	108a <printf>
    3980:	50011537          	lui	a0,0x50011
    3984:	10050513          	add	a0,a0,256 # 50011100 <__func__.2+0x480>
    3988:	f00fd0ef          	jal	1088 <puts>
    398c:	6785                	lui	a5,0x1
    398e:	f2078793          	add	a5,a5,-224 # f20 <whisperPrintfImpl+0x2>
    3992:	00f104b3          	add	s1,sp,a5
    3996:	49bd                	li	s3,15
    3998:	50011a37          	lui	s4,0x50011
    399c:	50011ab7          	lui	s5,0x50011
    39a0:	50011b37          	lui	s6,0x50011
    39a4:	09241e63          	bne	s0,s2,3a40 <idevid+0x50c>
    39a8:	4529                	li	a0,10
    39aa:	ed8fd0ef          	jal	1082 <putchar>
    39ae:	5001e537          	lui	a0,0x5001e
    39b2:	00050793          	mv	a5,a0
    39b6:	2087a023          	sw	s0,512(a5)
    39ba:	20078223          	sb	zero,516(a5)
    39be:	6785                	lui	a5,0x1
    39c0:	f2078793          	add	a5,a5,-224 # f20 <whisperPrintfImpl+0x2>
    39c4:	00f105b3          	add	a1,sp,a5
    39c8:	8622                	mv	a2,s0
    39ca:	00050513          	mv	a0,a0
    39ce:	2db5                	jal	404a <memcpy>
    39d0:	4585                	li	a1,1
    39d2:	4501                	li	a0,0
    39d4:	a2afd0ef          	jal	bfe <mailbox_send_data>
    39d8:	6289                	lui	t0,0x2
    39da:	f2028293          	add	t0,t0,-224 # 1f20 <sha384_digest+0x210>
    39de:	9116                	add	sp,sp,t0
    39e0:	50b2                	lw	ra,44(sp)
    39e2:	5422                	lw	s0,40(sp)
    39e4:	5492                	lw	s1,36(sp)
    39e6:	5902                	lw	s2,32(sp)
    39e8:	49f2                	lw	s3,28(sp)
    39ea:	4a62                	lw	s4,24(sp)
    39ec:	4ad2                	lw	s5,20(sp)
    39ee:	4b42                	lw	s6,16(sp)
    39f0:	4bb2                	lw	s7,12(sp)
    39f2:	4c22                	lw	s8,8(sp)
    39f4:	4c92                	lw	s9,4(sp)
    39f6:	6145                	add	sp,sp,48
    39f8:	8082                	ret
    39fa:	014907b3          	add	a5,s2,s4
    39fe:	0007c603          	lbu	a2,0(a5)
    3a02:	cd4b8593          	add	a1,s7,-812 # 50010cd4 <__func__.2+0x54>
    3a06:	00cb6463          	bltu	s6,a2,3a0e <idevid+0x4da>
    3a0a:	d08c0593          	add	a1,s8,-760 # 50010d08 <__func__.2+0x88>
    3a0e:	eacc8513          	add	a0,s9,-340 # 50010eac <__func__.2+0x22c>
    3a12:	e78fd0ef          	jal	108a <printf>
    3a16:	0a05                	add	s4,s4,1 # 50011001 <__func__.2+0x381>
    3a18:	bd6d                	j	38d2 <idevid+0x39e>
    3a1a:	50011537          	lui	a0,0x50011
    3a1e:	0a850513          	add	a0,a0,168 # 500110a8 <__func__.2+0x428>
    3a22:	e66fd0ef          	jal	1088 <puts>
    3a26:	a001                	j	3a26 <idevid+0x4f2>
    3a28:	009a07b3          	add	a5,s4,s1
    3a2c:	0009a583          	lw	a1,0(s3)
    3a30:	8626                	mv	a2,s1
    3a32:	c38c                	sw	a1,0(a5)
    3a34:	0e0b0513          	add	a0,s6,224 # 500110e0 <__func__.2+0x460>
    3a38:	e52fd0ef          	jal	108a <printf>
    3a3c:	0491                	add	s1,s1,4
    3a3e:	b725                	j	3966 <idevid+0x432>
    3a40:	008487b3          	add	a5,s1,s0
    3a44:	0007c603          	lbu	a2,0(a5)
    3a48:	cd4a0593          	add	a1,s4,-812
    3a4c:	00c9e463          	bltu	s3,a2,3a54 <idevid+0x520>
    3a50:	d08a8593          	add	a1,s5,-760 # 50010d08 <__func__.2+0x88>
    3a54:	eacb0513          	add	a0,s6,-340
    3a58:	e32fd0ef          	jal	108a <printf>
    3a5c:	0405                	add	s0,s0,1
    3a5e:	b799                	j	39a4 <idevid+0x470>

00003a60 <init_doe>:
    3a60:	2eb94737          	lui	a4,0x2eb94
    3a64:	100007b7          	lui	a5,0x10000
    3a68:	29770713          	add	a4,a4,663 # 2eb94297 <_bss_lma_end+0x2eb8ee0b>
    3a6c:	772856b7          	lui	a3,0x77285
    3a70:	c398                	sw	a4,0(a5)
    3a72:	19668693          	add	a3,a3,406 # 77285196 <_tbs_der_store_end+0x27266176>
    3a76:	c3d4                	sw	a3,4(a5)
    3a78:	3dd3a6b7          	lui	a3,0x3dd3a
    3a7c:	a1e68693          	add	a3,a3,-1506 # 3dd39a1e <_bss_lma_end+0x3dd34592>
    3a80:	c794                	sw	a3,8(a5)
    3a82:	b95d46b7          	lui	a3,0xb95d4
    3a86:	38f68693          	add	a3,a3,911 # b95d438f <_tbs_der_store_end+0x695b536f>
    3a8a:	c7d4                	sw	a3,12(a5)
    3a8c:	0220000f          	fence	r,r
    3a90:	0220000f          	fence	r,r
    3a94:	4685                	li	a3,1
    3a96:	cb94                	sw	a3,16(a5)
    3a98:	01478693          	add	a3,a5,20 # 10000014 <_bss_lma_end+0xfffab88>
    3a9c:	4298                	lw	a4,0(a3)
    3a9e:	8b09                	and	a4,a4,2
    3aa0:	df75                	beqz	a4,3a9c <init_doe+0x3c>
    3aa2:	14451737          	lui	a4,0x14451
    3aa6:	62470713          	add	a4,a4,1572 # 14451624 <_bss_lma_end+0x1444c198>
    3aaa:	c398                	sw	a4,0(a5)
    3aac:	6a753737          	lui	a4,0x6a753
    3ab0:	c3270713          	add	a4,a4,-974 # 6a752c32 <_tbs_der_store_end+0x1a733c12>
    3ab4:	c3d8                	sw	a4,4(a5)
    3ab6:	9056e737          	lui	a4,0x9056e
    3aba:	88470713          	add	a4,a4,-1916 # 9056d884 <_tbs_der_store_end+0x4054e864>
    3abe:	c798                	sw	a4,8(a5)
    3ac0:	daf3d737          	lui	a4,0xdaf3d
    3ac4:	89d70713          	add	a4,a4,-1891 # daf3c89d <_tbs_der_store_end+0x8af1d87d>
    3ac8:	c7d8                	sw	a4,12(a5)
    3aca:	0220000f          	fence	r,r
    3ace:	0220000f          	fence	r,r
    3ad2:	100007b7          	lui	a5,0x10000
    3ad6:	4719                	li	a4,6
    3ad8:	cb98                	sw	a4,16(a5)
    3ada:	01478713          	add	a4,a5,20 # 10000014 <_bss_lma_end+0xfffab88>
    3ade:	431c                	lw	a5,0(a4)
    3ae0:	8b89                	and	a5,a5,2
    3ae2:	dff5                	beqz	a5,3ade <init_doe+0x7e>
    3ae4:	0220000f          	fence	r,r
    3ae8:	0220000f          	fence	r,r
    3aec:	100007b7          	lui	a5,0x10000
    3af0:	470d                	li	a4,3
    3af2:	cb98                	sw	a4,16(a5)
    3af4:	8082                	ret

00003af6 <main>:
    3af6:	c6010113          	add	sp,sp,-928
    3afa:	38112e23          	sw	ra,924(sp)
    3afe:	38812c23          	sw	s0,920(sp)
    3b02:	38912a23          	sw	s1,916(sp)
    3b06:	39312623          	sw	s3,908(sp)
    3b0a:	39412423          	sw	s4,904(sp)
    3b0e:	500119b7          	lui	s3,0x50011
    3b12:	39212823          	sw	s2,912(sp)
    3b16:	39512223          	sw	s5,900(sp)
    3b1a:	39612023          	sw	s6,896(sp)
    3b1e:	37712e23          	sw	s7,892(sp)
    3b22:	37812c23          	sw	s8,888(sp)
    3b26:	37912a23          	sw	s9,884(sp)
    3b2a:	37a12823          	sw	s10,880(sp)
    3b2e:	37b12623          	sw	s11,876(sp)
    3b32:	bfffe0ef          	jal	2730 <init_uart>
    3b36:	f5afd0ef          	jal	1290 <init_qspi>
    3b3a:	11098513          	add	a0,s3,272 # 50011110 <__func__.2+0x490>
    3b3e:	d4afd0ef          	jal	1088 <puts>
    3b42:	50011537          	lui	a0,0x50011
    3b46:	13850513          	add	a0,a0,312 # 50011138 <__func__.2+0x4b8>
    3b4a:	d3efd0ef          	jal	1088 <puts>
    3b4e:	11098513          	add	a0,s3,272
    3b52:	d36fd0ef          	jal	1088 <puts>
    3b56:	50011637          	lui	a2,0x50011
    3b5a:	500115b7          	lui	a1,0x50011
    3b5e:	50011537          	lui	a0,0x50011
    3b62:	16060613          	add	a2,a2,352 # 50011160 <__func__.2+0x4e0>
    3b66:	16c58593          	add	a1,a1,364 # 5001116c <__func__.2+0x4ec>
    3b6a:	17850513          	add	a0,a0,376 # 50011178 <__func__.2+0x4f8>
    3b6e:	d1cfd0ef          	jal	108a <printf>
    3b72:	50010537          	lui	a0,0x50010
    3b76:	1010                	add	a2,sp,32
    3b78:	04000593          	li	a1,64
    3b7c:	08050513          	add	a0,a0,128 # 50010080 <FMC_expected_digest>
    3b80:	c96fe0ef          	jal	2016 <sha512_flow_produce>
    3b84:	50011537          	lui	a0,0x50011
    3b88:	19050513          	add	a0,a0,400 # 50011190 <__func__.2+0x510>
    3b8c:	cfcfd0ef          	jal	1088 <puts>
    3b90:	1000                	add	s0,sp,32
    3b92:	1084                	add	s1,sp,96
    3b94:	50011a37          	lui	s4,0x50011
    3b98:	400c                	lw	a1,0(s0)
    3b9a:	1a4a0513          	add	a0,s4,420 # 500111a4 <__func__.2+0x524>
    3b9e:	0411                	add	s0,s0,4
    3ba0:	ceafd0ef          	jal	108a <printf>
    3ba4:	fe941ae3          	bne	s0,s1,3b98 <main+0xa2>
    3ba8:	4529                	li	a0,10
    3baa:	cd8fd0ef          	jal	1082 <putchar>
    3bae:	50010537          	lui	a0,0x50010
    3bb2:	8626                	mv	a2,s1
    3bb4:	04000593          	li	a1,64
    3bb8:	00050513          	mv	a0,a0
    3bbc:	c5afe0ef          	jal	2016 <sha512_flow_produce>
    3bc0:	50011537          	lui	a0,0x50011
    3bc4:	1ac50513          	add	a0,a0,428 # 500111ac <__func__.2+0x52c>
    3bc8:	cc0fd0ef          	jal	1088 <puts>
    3bcc:	8926                	mv	s2,s1
    3bce:	1100                	add	s0,sp,160
    3bd0:	00092583          	lw	a1,0(s2)
    3bd4:	1a4a0513          	add	a0,s4,420
    3bd8:	0911                	add	s2,s2,4
    3bda:	cb0fd0ef          	jal	108a <printf>
    3bde:	fe8919e3          	bne	s2,s0,3bd0 <main+0xda>
    3be2:	4529                	li	a0,10
    3be4:	c9efd0ef          	jal	1082 <putchar>
    3be8:	0e010913          	add	s2,sp,224
    3bec:	85a6                	mv	a1,s1
    3bee:	04000613          	li	a2,64
    3bf2:	854a                	mv	a0,s2
    3bf4:	2999                	jal	404a <memcpy>
    3bf6:	04000613          	li	a2,64
    3bfa:	100c                	add	a1,sp,32
    3bfc:	1208                	add	a0,sp,288
    3bfe:	21b1                	jal	404a <memcpy>
    3c00:	8622                	mv	a2,s0
    3c02:	08000593          	li	a1,128
    3c06:	854a                	mv	a0,s2
    3c08:	c0efe0ef          	jal	2016 <sha512_flow_produce>
    3c0c:	50011537          	lui	a0,0x50011
    3c10:	1c050513          	add	a0,a0,448 # 500111c0 <__func__.2+0x540>
    3c14:	c74fd0ef          	jal	1088 <puts>
    3c18:	84a2                	mv	s1,s0
    3c1a:	408c                	lw	a1,0(s1)
    3c1c:	1a4a0513          	add	a0,s4,420
    3c20:	0491                	add	s1,s1,4
    3c22:	c68fd0ef          	jal	108a <printf>
    3c26:	fe991ae3          	bne	s2,s1,3c1a <main+0x124>
    3c2a:	4529                	li	a0,10
    3c2c:	44c104b7          	lui	s1,0x44c10
    3c30:	c52fd0ef          	jal	1082 <putchar>
    3c34:	14e5                	add	s1,s1,-7 # 44c0fff9 <_bss_lma_end+0x44c0ab6d>
    3c36:	aabfe0ef          	jal	26e0 <soc_ifc_read_mbox_cmd>
    3c3a:	feb49ee3          	bne	s1,a1,3c36 <main+0x140>
    3c3e:	50011537          	lui	a0,0x50011
    3c42:	1d450513          	add	a0,a0,468 # 500111d4 <__func__.2+0x554>
    3c46:	c42fd0ef          	jal	1088 <puts>
    3c4a:	8522                	mv	a0,s0
    3c4c:	04000593          	li	a1,64
    3c50:	44c10437          	lui	s0,0x44c10
    3c54:	fabfc0ef          	jal	bfe <mailbox_send_data>
    3c58:	1469                	add	s0,s0,-6 # 44c0fffa <_bss_lma_end+0x44c0ab6e>
    3c5a:	a87fe0ef          	jal	26e0 <soc_ifc_read_mbox_cmd>
    3c5e:	cc2a                	sw	a0,24(sp)
    3c60:	ce2e                	sw	a1,28(sp)
    3c62:	feb41ce3          	bne	s0,a1,3c5a <main+0x164>
    3c66:	50011537          	lui	a0,0x50011
    3c6a:	1f450513          	add	a0,a0,500 # 500111f4 <__func__.2+0x574>
    3c6e:	c1afd0ef          	jal	1088 <puts>
    3c72:	111117b7          	lui	a5,0x11111
    3c76:	1280                	add	s0,sp,352
    3c78:	11178793          	add	a5,a5,273 # 11111111 <_bss_lma_end+0x1110bc85>
    3c7c:	4591                	li	a1,4
    3c7e:	8522                	mv	a0,s0
    3c80:	16f12023          	sw	a5,352(sp)
    3c84:	f7bfc0ef          	jal	bfe <mailbox_send_data>
    3c88:	dd9ff0ef          	jal	3a60 <init_doe>
    3c8c:	8a9ff0ef          	jal	3534 <idevid>
    3c90:	936ff0ef          	jal	2dc6 <ldevid>
    3c94:	a2ffd0ef          	jal	16c2 <init_sd_card>
    3c98:	84aa                	mv	s1,a0
    3c9a:	1c051163          	bnez	a0,3e5c <main+0x366>
    3c9e:	50011537          	lui	a0,0x50011
    3ca2:	50014ab7          	lui	s5,0x50014
    3ca6:	21c50513          	add	a0,a0,540 # 5001121c <__func__.2+0x59c>
    3caa:	6b85                	lui	s7,0x1
    3cac:	bdcfd0ef          	jal	1088 <puts>
    3cb0:	8f0a8a13          	add	s4,s5,-1808 # 500138f0 <FMC_data>
    3cb4:	8f0a8b13          	add	s6,s5,-1808
    3cb8:	4901                	li	s2,0
    3cba:	800b8b93          	add	s7,s7,-2048 # 800 <mfdc+0x7>
    3cbe:	50011cb7          	lui	s9,0x50011
    3cc2:	50011d37          	lui	s10,0x50011
    3cc6:	4dbd                	li	s11,15
    3cc8:	20000613          	li	a2,512
    3ccc:	0ff00593          	li	a1,255
    3cd0:	8522                	mv	a0,s0
    3cd2:	2cc1                	jal	3fa2 <memset>
    3cd4:	4681                	li	a3,0
    3cd6:	4601                	li	a2,0
    3cd8:	85a2                	mv	a1,s0
    3cda:	01790533          	add	a0,s2,s7
    3cde:	ad7fd0ef          	jal	17b4 <read_sd_card>
    3ce2:	c62a                	sw	a0,12(sp)
    3ce4:	02091c63          	bnez	s2,3d1c <main+0x226>
    3ce8:	4581                	li	a1,0
    3cea:	22cc8513          	add	a0,s9,556 # 5001122c <__func__.2+0x5ac>
    3cee:	b9cfd0ef          	jal	108a <printf>
    3cf2:	4c01                	li	s8,0
    3cf4:	01840733          	add	a4,s0,s8
    3cf8:	00074583          	lbu	a1,0(a4)
    3cfc:	234d0513          	add	a0,s10,564 # 50011234 <__func__.2+0x5b4>
    3d00:	b8afd0ef          	jal	108a <printf>
    3d04:	00fc7713          	and	a4,s8,15
    3d08:	01b71563          	bne	a4,s11,3d12 <main+0x21c>
    3d0c:	4529                	li	a0,10
    3d0e:	b74fd0ef          	jal	1082 <putchar>
    3d12:	0c05                	add	s8,s8,1
    3d14:	20000793          	li	a5,512
    3d18:	fcfc1ee3          	bne	s8,a5,3cf4 <main+0x1fe>
    3d1c:	855a                	mv	a0,s6
    3d1e:	20000613          	li	a2,512
    3d22:	85a2                	mv	a1,s0
    3d24:	261d                	jal	404a <memcpy>
    3d26:	0905                	add	s2,s2,1
    3d28:	02800793          	li	a5,40
    3d2c:	200b0b13          	add	s6,s6,512
    3d30:	f8f91ce3          	bne	s2,a5,3cc8 <main+0x1d2>
    3d34:	4529                	li	a0,10
    3d36:	b4cfd0ef          	jal	1082 <putchar>
    3d3a:	47b2                	lw	a5,12(sp)
    3d3c:	eb9d                	bnez	a5,3d72 <main+0x27c>
    3d3e:	50011537          	lui	a0,0x50011
    3d42:	23c50513          	add	a0,a0,572 # 5001123c <__func__.2+0x5bc>
    3d46:	b42fd0ef          	jal	1088 <puts>
    3d4a:	6595                	lui	a1,0x5
    3d4c:	8f0a8513          	add	a0,s5,-1808
    3d50:	ecefe0ef          	jal	241e <measure_fmc>
    3d54:	0ff57513          	zext.b	a0,a0
    3d58:	ed09                	bnez	a0,3d72 <main+0x27c>
    3d5a:	400007b7          	lui	a5,0x40000
    3d5e:	40005737          	lui	a4,0x40005
    3d62:	000a2683          	lw	a3,0(s4)
    3d66:	c394                	sw	a3,0(a5)
    3d68:	0791                	add	a5,a5,4 # 40000004 <_bss_lma_end+0x3fffab78>
    3d6a:	0a11                	add	s4,s4,4
    3d6c:	fee79be3          	bne	a5,a4,3d62 <main+0x26c>
    3d70:	4485                	li	s1,1
    3d72:	50011537          	lui	a0,0x50011
    3d76:	25050513          	add	a0,a0,592 # 50011250 <__func__.2+0x5d0>
    3d7a:	50011a37          	lui	s4,0x50011
    3d7e:	6b89                	lui	s7,0x2
    3d80:	b08fd0ef          	jal	1088 <puts>
    3d84:	2f0a0b13          	add	s6,s4,752 # 500112f0 <SOC_FW_data>
    3d88:	4901                	li	s2,0
    3d8a:	20000d93          	li	s11,512
    3d8e:	800b8b93          	add	s7,s7,-2048 # 1800 <sha256_flow_produce+0xa>
    3d92:	50011c37          	lui	s8,0x50011
    3d96:	50011cb7          	lui	s9,0x50011
    3d9a:	4d3d                	li	s10,15
    3d9c:	20000613          	li	a2,512
    3da0:	0ff00593          	li	a1,255
    3da4:	8522                	mv	a0,s0
    3da6:	2af5                	jal	3fa2 <memset>
    3da8:	4601                	li	a2,0
    3daa:	4681                	li	a3,0
    3dac:	85a2                	mv	a1,s0
    3dae:	01790533          	add	a0,s2,s7
    3db2:	a03fd0ef          	jal	17b4 <read_sd_card>
    3db6:	8aaa                	mv	s5,a0
    3db8:	85ca                	mv	a1,s2
    3dba:	22cc0513          	add	a0,s8,556 # 5001122c <__func__.2+0x5ac>
    3dbe:	accfd0ef          	jal	108a <printf>
    3dc2:	4601                	li	a2,0
    3dc4:	00c407b3          	add	a5,s0,a2
    3dc8:	0007c583          	lbu	a1,0(a5)
    3dcc:	234c8513          	add	a0,s9,564 # 50011234 <__func__.2+0x5b4>
    3dd0:	c632                	sw	a2,12(sp)
    3dd2:	ab8fd0ef          	jal	108a <printf>
    3dd6:	4632                	lw	a2,12(sp)
    3dd8:	00f67793          	and	a5,a2,15
    3ddc:	01a79663          	bne	a5,s10,3de8 <main+0x2f2>
    3de0:	4529                	li	a0,10
    3de2:	aa0fd0ef          	jal	1082 <putchar>
    3de6:	4632                	lw	a2,12(sp)
    3de8:	0605                	add	a2,a2,1
    3dea:	fdb61de3          	bne	a2,s11,3dc4 <main+0x2ce>
    3dee:	855a                	mv	a0,s6
    3df0:	85a2                	mv	a1,s0
    3df2:	2ca1                	jal	404a <memcpy>
    3df4:	0905                	add	s2,s2,1
    3df6:	47cd                	li	a5,19
    3df8:	200b0b13          	add	s6,s6,512
    3dfc:	faf910e3          	bne	s2,a5,3d9c <main+0x2a6>
    3e00:	4529                	li	a0,10
    3e02:	a80fd0ef          	jal	1082 <putchar>
    3e06:	040a9163          	bnez	s5,3e48 <main+0x352>
    3e0a:	50011537          	lui	a0,0x50011
    3e0e:	26050513          	add	a0,a0,608 # 50011260 <__func__.2+0x5e0>
    3e12:	a76fd0ef          	jal	1088 <puts>
    3e16:	6589                	lui	a1,0x2
    3e18:	60058593          	add	a1,a1,1536 # 2600 <measure_fmc+0x1e2>
    3e1c:	2f0a0513          	add	a0,s4,752
    3e20:	b80fe0ef          	jal	21a0 <measure_soc>
    3e24:	0ff57513          	zext.b	a0,a0
    3e28:	e105                	bnez	a0,3e48 <main+0x352>
    3e2a:	1a2b4437          	lui	s0,0x1a2b4
    3e2e:	c4d40413          	add	s0,s0,-947 # 1a2b3c4d <_bss_lma_end+0x1a2ae7c1>
    3e32:	8affe0ef          	jal	26e0 <soc_ifc_read_mbox_cmd>
    3e36:	feb41ee3          	bne	s0,a1,3e32 <main+0x33c>
    3e3a:	6589                	lui	a1,0x2
    3e3c:	60058593          	add	a1,a1,1536 # 2600 <measure_fmc+0x1e2>
    3e40:	2f0a0513          	add	a0,s4,752
    3e44:	dbbfc0ef          	jal	bfe <mailbox_send_data>
    3e48:	c891                	beqz	s1,3e5c <main+0x366>
    3e4a:	50011537          	lui	a0,0x50011
    3e4e:	27450513          	add	a0,a0,628 # 50011274 <__func__.2+0x5f4>
    3e52:	a36fd0ef          	jal	1088 <puts>
    3e56:	400007b7          	lui	a5,0x40000
    3e5a:	9782                	jalr	a5
    3e5c:	11098513          	add	a0,s3,272
    3e60:	a28fd0ef          	jal	1088 <puts>
    3e64:	50011537          	lui	a0,0x50011
    3e68:	28450513          	add	a0,a0,644 # 50011284 <__func__.2+0x604>
    3e6c:	a1cfd0ef          	jal	1088 <puts>
    3e70:	11098513          	add	a0,s3,272
    3e74:	a14fd0ef          	jal	1088 <puts>
    3e78:	a001                	j	3e78 <main+0x382>
	...

00003e7c <early_trap_vector>:
    3e7c:	342022f3          	csrr	t0,mcause
    3e80:	34102373          	csrr	t1,mepc
    3e84:	343023f3          	csrr	t2,mtval
    3e88:	30030e37          	lui	t3,0x30030
    3e8c:	0cce0e13          	add	t3,t3,204 # 300300cc <_bss_lma_end+0x3002ac40>
    3e90:	5000ce97          	auipc	t4,0x5000c
    3e94:	258e8e93          	add	t4,t4,600 # 500100e8 <trap_msg>

00003e98 <trap_print_loop>:
    3e98:	000e8283          	lb	t0,0(t4)
    3e9c:	005e0023          	sb	t0,0(t3)
    3ea0:	0e85                	add	t4,t4,1
    3ea2:	fe029be3          	bnez	t0,3e98 <trap_print_loop>
    3ea6:	4f05                	li	t5,1
    3ea8:	01ee0023          	sb	t5,0(t3)
    3eac:	bfc1                	j	3e7c <early_trap_vector>

00003eae <__lshrdi3>:
    3eae:	ca19                	beqz	a2,3ec4 <__lshrdi3+0x16>
    3eb0:	02000793          	li	a5,32
    3eb4:	8f91                	sub	a5,a5,a2
    3eb6:	00f04863          	bgtz	a5,3ec6 <__lshrdi3+0x18>
    3eba:	1601                	add	a2,a2,-32
    3ebc:	00c5d533          	srl	a0,a1,a2
    3ec0:	4701                	li	a4,0
    3ec2:	85ba                	mv	a1,a4
    3ec4:	8082                	ret
    3ec6:	00c5d733          	srl	a4,a1,a2
    3eca:	00c55533          	srl	a0,a0,a2
    3ece:	00f595b3          	sll	a1,a1,a5
    3ed2:	8d4d                	or	a0,a0,a1
    3ed4:	b7fd                	j	3ec2 <__lshrdi3+0x14>

00003ed6 <memmove>:
    3ed6:	02a5f263          	bgeu	a1,a0,3efa <memmove+0x24>
    3eda:	00c58733          	add	a4,a1,a2
    3ede:	00e57e63          	bgeu	a0,a4,3efa <memmove+0x24>
    3ee2:	00c507b3          	add	a5,a0,a2
    3ee6:	ca1d                	beqz	a2,3f1c <memmove+0x46>
    3ee8:	17fd                	add	a5,a5,-1 # 3fffffff <_bss_lma_end+0x3fffab73>
    3eea:	fff74683          	lbu	a3,-1(a4) # 40004fff <_bss_lma_end+0x3ffffb73>
    3eee:	00d78023          	sb	a3,0(a5)
    3ef2:	177d                	add	a4,a4,-1
    3ef4:	fef51ae3          	bne	a0,a5,3ee8 <memmove+0x12>
    3ef8:	8082                	ret
    3efa:	47bd                	li	a5,15
    3efc:	02c7e163          	bltu	a5,a2,3f1e <memmove+0x48>
    3f00:	87aa                	mv	a5,a0
    3f02:	fff60693          	add	a3,a2,-1
    3f06:	ca59                	beqz	a2,3f9c <memmove+0xc6>
    3f08:	0685                	add	a3,a3,1
    3f0a:	96be                	add	a3,a3,a5
    3f0c:	0785                	add	a5,a5,1
    3f0e:	0005c703          	lbu	a4,0(a1)
    3f12:	fee78fa3          	sb	a4,-1(a5)
    3f16:	0585                	add	a1,a1,1
    3f18:	fed79ae3          	bne	a5,a3,3f0c <memmove+0x36>
    3f1c:	8082                	ret
    3f1e:	00b567b3          	or	a5,a0,a1
    3f22:	8b8d                	and	a5,a5,3
    3f24:	eba5                	bnez	a5,3f94 <memmove+0xbe>
    3f26:	ff060893          	add	a7,a2,-16
    3f2a:	ff08f893          	and	a7,a7,-16
    3f2e:	08c1                	add	a7,a7,16
    3f30:	011506b3          	add	a3,a0,a7
    3f34:	872e                	mv	a4,a1
    3f36:	87aa                	mv	a5,a0
    3f38:	00072803          	lw	a6,0(a4)
    3f3c:	0107a023          	sw	a6,0(a5)
    3f40:	00472803          	lw	a6,4(a4)
    3f44:	0107a223          	sw	a6,4(a5)
    3f48:	00872803          	lw	a6,8(a4)
    3f4c:	0107a423          	sw	a6,8(a5)
    3f50:	00c72803          	lw	a6,12(a4)
    3f54:	07c1                	add	a5,a5,16
    3f56:	ff07ae23          	sw	a6,-4(a5)
    3f5a:	0741                	add	a4,a4,16
    3f5c:	fcd79ee3          	bne	a5,a3,3f38 <memmove+0x62>
    3f60:	00c67813          	and	a6,a2,12
    3f64:	95c6                	add	a1,a1,a7
    3f66:	00f67713          	and	a4,a2,15
    3f6a:	02080a63          	beqz	a6,3f9e <memmove+0xc8>
    3f6e:	ffc70813          	add	a6,a4,-4
    3f72:	ffc87813          	and	a6,a6,-4
    3f76:	0811                	add	a6,a6,4
    3f78:	010687b3          	add	a5,a3,a6
    3f7c:	872e                	mv	a4,a1
    3f7e:	0691                	add	a3,a3,4
    3f80:	00072883          	lw	a7,0(a4)
    3f84:	ff16ae23          	sw	a7,-4(a3)
    3f88:	0711                	add	a4,a4,4
    3f8a:	fef69ae3          	bne	a3,a5,3f7e <memmove+0xa8>
    3f8e:	8a0d                	and	a2,a2,3
    3f90:	95c2                	add	a1,a1,a6
    3f92:	bf85                	j	3f02 <memmove+0x2c>
    3f94:	fff60693          	add	a3,a2,-1
    3f98:	87aa                	mv	a5,a0
    3f9a:	b7bd                	j	3f08 <memmove+0x32>
    3f9c:	8082                	ret
    3f9e:	863a                	mv	a2,a4
    3fa0:	b78d                	j	3f02 <memmove+0x2c>

00003fa2 <memset>:
    3fa2:	433d                	li	t1,15
    3fa4:	872a                	mv	a4,a0
    3fa6:	02c37363          	bgeu	t1,a2,3fcc <memset+0x2a>
    3faa:	00f77793          	and	a5,a4,15
    3fae:	efbd                	bnez	a5,402c <memset+0x8a>
    3fb0:	e5ad                	bnez	a1,401a <memset+0x78>
    3fb2:	ff067693          	and	a3,a2,-16
    3fb6:	8a3d                	and	a2,a2,15
    3fb8:	96ba                	add	a3,a3,a4
    3fba:	c30c                	sw	a1,0(a4)
    3fbc:	c34c                	sw	a1,4(a4)
    3fbe:	c70c                	sw	a1,8(a4)
    3fc0:	c74c                	sw	a1,12(a4)
    3fc2:	0741                	add	a4,a4,16
    3fc4:	fed76be3          	bltu	a4,a3,3fba <memset+0x18>
    3fc8:	e211                	bnez	a2,3fcc <memset+0x2a>
    3fca:	8082                	ret
    3fcc:	40c306b3          	sub	a3,t1,a2
    3fd0:	068a                	sll	a3,a3,0x2
    3fd2:	00000297          	auipc	t0,0x0
    3fd6:	9696                	add	a3,a3,t0
    3fd8:	00a68067          	jr	10(a3)
    3fdc:	00b70723          	sb	a1,14(a4)
    3fe0:	00b706a3          	sb	a1,13(a4)
    3fe4:	00b70623          	sb	a1,12(a4)
    3fe8:	00b705a3          	sb	a1,11(a4)
    3fec:	00b70523          	sb	a1,10(a4)
    3ff0:	00b704a3          	sb	a1,9(a4)
    3ff4:	00b70423          	sb	a1,8(a4)
    3ff8:	00b703a3          	sb	a1,7(a4)
    3ffc:	00b70323          	sb	a1,6(a4)
    4000:	00b702a3          	sb	a1,5(a4)
    4004:	00b70223          	sb	a1,4(a4)
    4008:	00b701a3          	sb	a1,3(a4)
    400c:	00b70123          	sb	a1,2(a4)
    4010:	00b700a3          	sb	a1,1(a4)
    4014:	00b70023          	sb	a1,0(a4)
    4018:	8082                	ret
    401a:	0ff5f593          	zext.b	a1,a1
    401e:	00859693          	sll	a3,a1,0x8
    4022:	8dd5                	or	a1,a1,a3
    4024:	01059693          	sll	a3,a1,0x10
    4028:	8dd5                	or	a1,a1,a3
    402a:	b761                	j	3fb2 <memset+0x10>
    402c:	00279693          	sll	a3,a5,0x2
    4030:	00000297          	auipc	t0,0x0
    4034:	9696                	add	a3,a3,t0
    4036:	8286                	mv	t0,ra
    4038:	fa8680e7          	jalr	-88(a3)
    403c:	8096                	mv	ra,t0
    403e:	17c1                	add	a5,a5,-16
    4040:	8f1d                	sub	a4,a4,a5
    4042:	963e                	add	a2,a2,a5
    4044:	f8c374e3          	bgeu	t1,a2,3fcc <memset+0x2a>
    4048:	b7a5                	j	3fb0 <memset+0xe>

0000404a <memcpy>:
    404a:	00a5c7b3          	xor	a5,a1,a0
    404e:	8b8d                	and	a5,a5,3
    4050:	00c508b3          	add	a7,a0,a2
    4054:	e7b1                	bnez	a5,40a0 <memcpy+0x56>
    4056:	478d                	li	a5,3
    4058:	04c7f463          	bgeu	a5,a2,40a0 <memcpy+0x56>
    405c:	00357793          	and	a5,a0,3
    4060:	872a                	mv	a4,a0
    4062:	e7dd                	bnez	a5,4110 <memcpy+0xc6>
    4064:	ffc8f613          	and	a2,a7,-4
    4068:	40e606b3          	sub	a3,a2,a4
    406c:	02000793          	li	a5,32
    4070:	04d7c463          	blt	a5,a3,40b8 <memcpy+0x6e>
    4074:	86ae                	mv	a3,a1
    4076:	87ba                	mv	a5,a4
    4078:	02c77163          	bgeu	a4,a2,409a <memcpy+0x50>
    407c:	0006a803          	lw	a6,0(a3)
    4080:	0791                	add	a5,a5,4
    4082:	ff07ae23          	sw	a6,-4(a5)
    4086:	0691                	add	a3,a3,4
    4088:	fec7eae3          	bltu	a5,a2,407c <memcpy+0x32>
    408c:	fff60793          	add	a5,a2,-1
    4090:	8f99                	sub	a5,a5,a4
    4092:	9bf1                	and	a5,a5,-4
    4094:	0791                	add	a5,a5,4
    4096:	973e                	add	a4,a4,a5
    4098:	95be                	add	a1,a1,a5
    409a:	01176663          	bltu	a4,a7,40a6 <memcpy+0x5c>
    409e:	8082                	ret
    40a0:	872a                	mv	a4,a0
    40a2:	ff157ee3          	bgeu	a0,a7,409e <memcpy+0x54>
    40a6:	0005c783          	lbu	a5,0(a1)
    40aa:	0705                	add	a4,a4,1
    40ac:	fef70fa3          	sb	a5,-1(a4)
    40b0:	0585                	add	a1,a1,1
    40b2:	fee89ae3          	bne	a7,a4,40a6 <memcpy+0x5c>
    40b6:	8082                	ret
    40b8:	02470713          	add	a4,a4,36
    40bc:	5194                	lw	a3,32(a1)
    40be:	0005a383          	lw	t2,0(a1)
    40c2:	0045a283          	lw	t0,4(a1)
    40c6:	0085af83          	lw	t6,8(a1)
    40ca:	00c5af03          	lw	t5,12(a1)
    40ce:	0105ae83          	lw	t4,16(a1)
    40d2:	0145ae03          	lw	t3,20(a1)
    40d6:	0185a303          	lw	t1,24(a1)
    40da:	01c5a803          	lw	a6,28(a1)
    40de:	fed72e23          	sw	a3,-4(a4)
    40e2:	fc772e23          	sw	t2,-36(a4)
    40e6:	fe572023          	sw	t0,-32(a4)
    40ea:	fff72223          	sw	t6,-28(a4)
    40ee:	ffe72423          	sw	t5,-24(a4)
    40f2:	ffd72623          	sw	t4,-20(a4)
    40f6:	ffc72823          	sw	t3,-16(a4)
    40fa:	fe672a23          	sw	t1,-12(a4)
    40fe:	ff072c23          	sw	a6,-8(a4)
    4102:	40e606b3          	sub	a3,a2,a4
    4106:	02458593          	add	a1,a1,36
    410a:	fad7c7e3          	blt	a5,a3,40b8 <memcpy+0x6e>
    410e:	b79d                	j	4074 <memcpy+0x2a>
    4110:	0005c783          	lbu	a5,0(a1)
    4114:	0705                	add	a4,a4,1
    4116:	fef70fa3          	sb	a5,-1(a4)
    411a:	00377793          	and	a5,a4,3
    411e:	0585                	add	a1,a1,1
    4120:	d3b1                	beqz	a5,4064 <memcpy+0x1a>
    4122:	0005c783          	lbu	a5,0(a1)
    4126:	0705                	add	a4,a4,1
    4128:	fef70fa3          	sb	a5,-1(a4)
    412c:	00377793          	and	a5,a4,3
    4130:	0585                	add	a1,a1,1
    4132:	fff9                	bnez	a5,4110 <memcpy+0xc6>
    4134:	bf05                	j	4064 <memcpy+0x1a>

00004136 <strlen>:
    4136:	00357793          	and	a5,a0,3
    413a:	872a                	mv	a4,a0
    413c:	ef9d                	bnez	a5,417a <strlen+0x44>
    413e:	7f7f86b7          	lui	a3,0x7f7f8
    4142:	f7f68693          	add	a3,a3,-129 # 7f7f7f7f <_tbs_der_store_end+0x2f7d8f5f>
    4146:	55fd                	li	a1,-1
    4148:	4310                	lw	a2,0(a4)
    414a:	00d677b3          	and	a5,a2,a3
    414e:	97b6                	add	a5,a5,a3
    4150:	8fd1                	or	a5,a5,a2
    4152:	8fd5                	or	a5,a5,a3
    4154:	0711                	add	a4,a4,4
    4156:	feb789e3          	beq	a5,a1,4148 <strlen+0x12>
    415a:	ffc74683          	lbu	a3,-4(a4)
    415e:	40a707b3          	sub	a5,a4,a0
    4162:	ca8d                	beqz	a3,4194 <strlen+0x5e>
    4164:	ffd74683          	lbu	a3,-3(a4)
    4168:	c29d                	beqz	a3,418e <strlen+0x58>
    416a:	ffe74503          	lbu	a0,-2(a4)
    416e:	00a03533          	snez	a0,a0
    4172:	953e                	add	a0,a0,a5
    4174:	1579                	add	a0,a0,-2
    4176:	8082                	ret
    4178:	d2f9                	beqz	a3,413e <strlen+0x8>
    417a:	00074783          	lbu	a5,0(a4)
    417e:	0705                	add	a4,a4,1
    4180:	00377693          	and	a3,a4,3
    4184:	fbf5                	bnez	a5,4178 <strlen+0x42>
    4186:	8f09                	sub	a4,a4,a0
    4188:	fff70513          	add	a0,a4,-1
    418c:	8082                	ret
    418e:	ffd78513          	add	a0,a5,-3
    4192:	8082                	ret
    4194:	ffc78513          	add	a0,a5,-4
    4198:	8082                	ret

Disassembly of section .data:

50010000 <SOC_expected_digest>:
50010000:	2e6a                	.insn	2, 0x2e6a
50010002:	034a                	sll	t1,t1,0x12
50010004:	ac52                	.insn	2, 0xac52
50010006:	261c                	.insn	2, 0x261c
50010008:	2f69                	jal	500107a2 <__func__.0+0x292>
5001000a:	5098a77b          	.insn	4, 0x5098a77b
5001000e:	145e                	sll	s0,s0,0x37
50010010:	f1fa0593          	add	a1,s4,-225
50010014:	0a3d                	add	s4,s4,15
50010016:	99a0                	.insn	2, 0x99a0
50010018:	bb349d53          	.insn	4, 0xbb349d53
5001001c:	20e9                	jal	500100e6 <FMC_expected_digest+0x66>
5001001e:	6118                	.insn	2, 0x6118
50010020:	5219                	li	tp,-26
50010022:	1d88                	add	a0,sp,752
50010024:	db95                	beqz	a5,5000ff58 <_bss_lma_end+0x5000aacc>
50010026:	8e1c                	.insn	2, 0x8e1c
50010028:	a6b0                	.insn	2, 0xa6b0
5001002a:	cf1d                	beqz	a4,50010068 <RT_expected_digest+0x28>
5001002c:	891d6757          	.insn	4, 0x891d6757
50010030:	376af07f          	.insn	4, 0x376af07f
50010034:	804c                	.insn	2, 0x804c
50010036:	99e16b8f          	.insn	4, 0x99e16b8f
5001003a:	ab25                	j	50010572 <__func__.0+0x62>
5001003c:	1b18                	add	a4,sp,432
5001003e:	          	.insn	4, 0x0e20eb27

50010040 <RT_expected_digest>:
50010040:	0e20                	add	s0,sp,792
50010042:	b52e                	.insn	2, 0xb52e
50010044:	8068                	.insn	2, 0x8068
50010046:	4d54                	lw	a3,28(a0)
50010048:	c532                	sw	a2,136(sp)
5001004a:	aef61ce3          	bne	a2,a5,5000fb42 <_bss_lma_end+0x5000a6b6>
5001004e:	bd3498bb          	.insn	4, 0xbd3498bb
50010052:	877d42ef          	jal	t0,4ffe48c8 <_bss_lma_end+0x4ffdf43c>
50010056:	a78e                	.insn	2, 0xa78e
50010058:	6306                	.insn	2, 0x6306
5001005a:	c861                	beqz	s0,5001012a <trap_msg+0x42>
5001005c:	bc39                	j	5000fa7a <_bss_lma_end+0x5000a5ee>
5001005e:	423842ff          	.insn	4, 0x423842ff
50010062:	871a                	mv	a4,t1
50010064:	f390cd8f          	.insn	4, 0xf390cd8f
50010068:	66f4                	.insn	2, 0x66f4
5001006a:	0a75                	add	s4,s4,29
5001006c:	20a1                	jal	500100b4 <FMC_expected_digest+0x34>
5001006e:	7386                	.insn	2, 0x7386
50010070:	86b5                	sra	a3,a3,0xd
50010072:	22dd02d3          	.insn	4, 0x22dd02d3
50010076:	01ea                	sll	gp,gp,0x1a
50010078:	1421                	add	s0,s0,-24
5001007a:	3560                	.insn	2, 0x3560
5001007c:	99e5                	and	a1,a1,-7
5001007e:	7635                	lui	a2,0xfffed

50010080 <FMC_expected_digest>:
50010080:	fde1                	bnez	a1,50010058 <RT_expected_digest+0x18>
50010082:	3688                	.insn	2, 0x3688
50010084:	12b5                	add	t0,t0,-19 # 401d <memset+0x7b>
50010086:	4029                	c.li	zero,10
50010088:	e418                	.insn	2, 0xe418
5001008a:	c83e                	sw	a5,16(sp)
5001008c:	861f bef9 8665      	.insn	6, 0x8665bef9861f
50010092:	140c                	add	a1,sp,544
50010094:	c241                	beqz	a2,50010114 <trap_msg+0x2c>
50010096:	db55                	beqz	a4,5001004a <RT_expected_digest+0xa>
50010098:	613d                	add	sp,sp,480
5001009a:	8164                	.insn	2, 0x8164
5001009c:	ba6e                	.insn	2, 0xba6e
5001009e:	efe5                	bnez	a5,50010196 <trap_msg+0xae>
500100a0:	2bae                	.insn	2, 0x2bae
500100a2:	c3ae                	sw	a1,196(sp)
500100a4:	ad25                	j	500106dc <__func__.0+0x1cc>
500100a6:	c885                	beqz	s1,500100d6 <FMC_expected_digest+0x56>
500100a8:	872d                	sra	a4,a4,0xb
500100aa:	c7ae5f53          	.insn	4, 0xc7ae5f53
500100ae:	aafc                	.insn	2, 0xaafc
500100b0:	6a6d                	lui	s4,0x1b
500100b2:	6d92                	.insn	2, 0x6d92
500100b4:	7c3619bf 82eeaf26 	.insn	8, 0x82eeaf267c3619bf
500100bc:	c841                	beqz	s0,5001014c <trap_msg+0x64>
500100be:	2630a0e7          	.insn	4, 0x2630a0e7
500100c2:	1030                	add	a2,sp,40
500100c4:	0306                	sll	t1,t1,0x1
500100c6:	1d55                	add	s10,s10,-11
500100c8:	ff01010f          	.insn	4, 0xff01010f
500100cc:	0604                	add	s1,sp,768
500100ce:	06040403          	lb	s0,96(s0)
500100d2:	0000                	unimp
500100d4:	1230                	add	a2,sp,296
500100d6:	0306                	sll	t1,t1,0x1
500100d8:	1d55                	add	s10,s10,-11
500100da:	ff010113          	add	sp,sp,-16
500100de:	0804                	add	s1,sp,16
500100e0:	0630                	add	a2,sp,776
500100e2:	0101                	add	sp,sp,0
500100e4:	000102ff          	.insn	4, 0x000102ff

500100e8 <trap_msg>:
500100e8:	7878                	.insn	2, 0x7878
500100ea:	7878                	.insn	2, 0x7878
500100ec:	7878                	.insn	2, 0x7878
500100ee:	7878                	.insn	2, 0x7878
500100f0:	7878                	.insn	2, 0x7878
500100f2:	7878                	.insn	2, 0x7878
500100f4:	7878                	.insn	2, 0x7878
500100f6:	7878                	.insn	2, 0x7878
500100f8:	7878                	.insn	2, 0x7878
500100fa:	7878                	.insn	2, 0x7878
500100fc:	7878                	.insn	2, 0x7878
500100fe:	7878                	.insn	2, 0x7878
50010100:	7878                	.insn	2, 0x7878
50010102:	7878                	.insn	2, 0x7878
50010104:	7878                	.insn	2, 0x7878
50010106:	7878                	.insn	2, 0x7878
50010108:	7878                	.insn	2, 0x7878
5001010a:	7878                	.insn	2, 0x7878
5001010c:	7878                	.insn	2, 0x7878
5001010e:	7878                	.insn	2, 0x7878
50010110:	200a                	.insn	2, 0x200a
50010112:	2020                	.insn	2, 0x2020
50010114:	5254                	lw	a3,36(a2)
50010116:	5041                	c.li	zero,-16
50010118:	5620                	lw	s0,104(a2)
5001011a:	4345                	li	t1,17
5001011c:	4f54                	lw	a3,28(a4)
5001011e:	2052                	.insn	2, 0x2052
50010120:	5845                	li	a6,-15
50010122:	4345                	li	t1,17
50010124:	5455                	li	s0,-11
50010126:	4e49                	li	t3,18
50010128:	4b202147          	.insn	4, 0x4b202147
5001012c:	4c49                	li	s8,18
5001012e:	204c                	.insn	2, 0x204c
50010130:	214d4953          	.insn	4, 0x214d4953
50010134:	2121                	jal	5001053c <__func__.0+0x2c>
50010136:	2020                	.insn	2, 0x2020
50010138:	0a20                	add	s0,sp,280
5001013a:	7878                	.insn	2, 0x7878
5001013c:	7878                	.insn	2, 0x7878
5001013e:	7878                	.insn	2, 0x7878
50010140:	7878                	.insn	2, 0x7878
50010142:	7878                	.insn	2, 0x7878
50010144:	7878                	.insn	2, 0x7878
50010146:	7878                	.insn	2, 0x7878
50010148:	7878                	.insn	2, 0x7878
5001014a:	7878                	.insn	2, 0x7878
5001014c:	7878                	.insn	2, 0x7878
5001014e:	7878                	.insn	2, 0x7878
50010150:	7878                	.insn	2, 0x7878
50010152:	7878                	.insn	2, 0x7878
50010154:	7878                	.insn	2, 0x7878
50010156:	7878                	.insn	2, 0x7878
50010158:	7878                	.insn	2, 0x7878
5001015a:	7878                	.insn	2, 0x7878
5001015c:	7878                	.insn	2, 0x7878
5001015e:	7878                	.insn	2, 0x7878
50010160:	7878                	.insn	2, 0x7878
50010162:	000a                	c.slli	zero,0x2
50010164:	7566                	.insn	2, 0x7566
50010166:	636e                	.insn	2, 0x636e
50010168:	203a                	.insn	2, 0x203a
5001016a:	7325                	lui	t1,0xfffe9
5001016c:	202c                	.insn	2, 0x202c
5001016e:	696c                	.insn	2, 0x696c
50010170:	656e                	.insn	2, 0x656e
50010172:	203a                	.insn	2, 0x203a
50010174:	6425                	lui	s0,0x9
50010176:	000a                	c.slli	zero,0x2
50010178:	7245                	lui	tp,0xffff1
5001017a:	6f72                	.insn	2, 0x6f72
5001017c:	3a72                	.insn	2, 0x3a72
5001017e:	5220                	lw	s0,96(a2)
50010180:	6765                	lui	a4,0x19
50010182:	7369                	lui	t1,0xffffa
50010184:	6574                	.insn	2, 0x6574
50010186:	2072                	.insn	2, 0x2072
50010188:	6e69                	lui	t3,0x1a
5001018a:	6564                	.insn	2, 0x6564
5001018c:	2078                	.insn	2, 0x2078
5001018e:	2074756f          	jal	a0,50057b94 <_tbs_der_store_end+0x38b74>
50010192:	7220666f          	jal	a2,500168b4 <FMC_data+0x2fc4>
50010196:	6e61                	lui	t3,0x18
50010198:	28206567          	.insn	4, 0x28206567
5001019c:	2d30                	.insn	2, 0x2d30
5001019e:	2939                	jal	500105bc <__func__.0+0xac>
500101a0:	0000                	unimp
500101a2:	0000                	unimp
500101a4:	63637553          	.insn	4, 0x63637553
500101a8:	7365                	lui	t1,0xffff9
500101aa:	44203a73          	csrrc	s4,0x442,zero
500101ae:	7461                	lui	s0,0xffff8
500101b0:	2061                	jal	50010238 <trap_msg+0x150>
500101b2:	726f7473          	csrrc	s0,mhpmevent6h,30
500101b6:	6465                	lui	s0,0x19
500101b8:	7420                	.insn	2, 0x7420
500101ba:	4144206f          	j	500525ce <_tbs_der_store_end+0x335ae>
500101be:	4154                	lw	a3,4(a0)
500101c0:	565f 5541 544c      	.insn	6, 0x544c5541565f
500101c6:	455f 544e 5952      	.insn	6, 0x5952544e455f
500101cc:	255f 3830 2078      	.insn	6, 0x20783830255f
500101d2:	6e61                	lui	t3,0x18
500101d4:	2064                	.insn	2, 0x2064
500101d6:	4144                	lw	s1,4(a0)
500101d8:	4154                	lw	a3,4(a0)
500101da:	565f 5541 544c      	.insn	6, 0x544c5541565f
500101e0:	455f 544e 5952      	.insn	6, 0x5952544e455f
500101e6:	255f 3830 0a78      	.insn	6, 0x0a783830255f
500101ec:	0000                	unimp
500101ee:	0000                	unimp
500101f0:	63637553          	.insn	4, 0x63637553
500101f4:	7365                	lui	t1,0xffff9
500101f6:	44203a73          	csrrc	s4,0x442,zero
500101fa:	7461                	lui	s0,0xffff8
500101fc:	2061                	jal	50010284 <__func__.1+0x34>
500101fe:	6572                	.insn	2, 0x6572
50010200:	6461                	lui	s0,0x18
50010202:	6620                	.insn	2, 0x6620
50010204:	6f72                	.insn	2, 0x6f72
50010206:	206d                	jal	500102b0 <__func__.1+0x60>
50010208:	4144                	lw	s1,4(a0)
5001020a:	4154                	lw	a3,4(a0)
5001020c:	565f 5541 544c      	.insn	6, 0x544c5541565f
50010212:	455f 544e 5952      	.insn	6, 0x5952544e455f
50010218:	255f 3830 2078      	.insn	6, 0x20783830255f
5001021e:	6e61                	lui	t3,0x18
50010220:	2064                	.insn	2, 0x2064
50010222:	4144                	lw	s1,4(a0)
50010224:	4154                	lw	a3,4(a0)
50010226:	565f 5541 544c      	.insn	6, 0x544c5541565f
5001022c:	455f 544e 5952      	.insn	6, 0x5952544e455f
50010232:	255f 3830 0a78      	.insn	6, 0x0a783830255f
50010238:	0000                	unimp
	...

5001023c <__func__.0>:
5001023c:	6572                	.insn	2, 0x6572
5001023e:	6461                	lui	s0,0x18
50010240:	665f 6f72 5f6d      	.insn	6, 0x5f6d6f72665f
50010246:	6164                	.insn	2, 0x6164
50010248:	6174                	.insn	2, 0x6174
5001024a:	6176                	.insn	2, 0x6176
5001024c:	6c75                	lui	s8,0x1d
5001024e:	0074                	add	a3,sp,12

50010250 <__func__.1>:
50010250:	726f7473          	csrrc	s0,mhpmevent6h,30
50010254:	5f65                	li	t5,-7
50010256:	6f74                	.insn	2, 0x6f74
50010258:	645f 7461 7661      	.insn	6, 0x76617461645f
5001025e:	7561                	lui	a0,0xffff8
50010260:	746c                	.insn	2, 0x746c
50010262:	0000                	unimp
50010264:	450a                	lw	a0,128(sp)
50010266:	4b204343          	.insn	4, 0x4b204343
5001026a:	5945                	li	s2,-15
5001026c:	004e4547          	.insn	4, 0x004e4547
50010270:	74696157          	.insn	4, 0x74696157
50010274:	6620                	.insn	2, 0x6620
50010276:	4b20726f          	jal	tp,50017728 <FMC_data+0x3e38>
5001027a:	2056                	.insn	2, 0x2056
5001027c:	74697277          	.insn	4, 0x74697277
50010280:	0065                	c.nop	25
50010282:	0000                	unimp
50010284:	6f4c                	.insn	2, 0x6f4c
50010286:	6461                	lui	s0,0x18
50010288:	5020                	lw	s0,96(s0)
5001028a:	4952                	lw	s2,20(sp)
5001028c:	4b56                	lw	s6,84(sp)
5001028e:	5945                	li	s2,-15
50010290:	6420                	.insn	2, 0x6420
50010292:	7461                	lui	s0,0xffff8
50010294:	2061                	jal	5001031c <__func__.1+0xcc>
50010296:	7266                	.insn	2, 0x7266
50010298:	45206d6f          	jal	s10,500166ea <FMC_data+0x2dfa>
5001029c:	00004343          	.insn	4, 0x4343
500102a0:	7441                	lui	s0,0xffff0
500102a2:	6f20                	.insn	2, 0x6f20
500102a4:	6666                	.insn	2, 0x6666
500102a6:	20746573          	csrrs	a0,0x207,8
500102aa:	5d64255b          	.insn	4, 0x5d64255b
500102ae:	202c                	.insn	2, 0x202c
500102b0:	6365                	lui	t1,0x19
500102b2:	72705f63          	blez	t2,500109f0 <k+0x170>
500102b6:	7669                	lui	a2,0xffffa
500102b8:	2079656b          	.insn	4, 0x2079656b
500102bc:	6164                	.insn	2, 0x6164
500102be:	6174                	.insn	2, 0x6174
500102c0:	6d20                	.insn	2, 0x6d20
500102c2:	7369                	lui	t1,0xffffa
500102c4:	616d                	add	sp,sp,240
500102c6:	6374                	.insn	2, 0x6374
500102c8:	2168                	.insn	2, 0x2168
500102ca:	000a                	c.slli	zero,0x2
500102cc:	6341                	lui	t1,0x10
500102ce:	7574                	.insn	2, 0x7574
500102d0:	6c61                	lui	s8,0x18
500102d2:	2020                	.insn	2, 0x2020
500102d4:	6420                	.insn	2, 0x6420
500102d6:	7461                	lui	s0,0xffff8
500102d8:	3a61                	jal	5000fc70 <_bss_lma_end+0x5000a7e4>
500102da:	3020                	.insn	2, 0x3020
500102dc:	2578                	.insn	2, 0x2578
500102de:	786c                	.insn	2, 0x786c
500102e0:	000a                	c.slli	zero,0x2
500102e2:	0000                	unimp
500102e4:	7845                	lui	a6,0xffff1
500102e6:	6570                	.insn	2, 0x6570
500102e8:	64657463          	bgeu	a0,t1,50010930 <k+0xb0>
500102ec:	6420                	.insn	2, 0x6420
500102ee:	7461                	lui	s0,0xffff8
500102f0:	3a61                	jal	5000fc88 <_bss_lma_end+0x5000a7fc>
500102f2:	3020                	.insn	2, 0x3020
500102f4:	2578                	.insn	2, 0x2578
500102f6:	786c                	.insn	2, 0x786c
500102f8:	000a                	c.slli	zero,0x2
500102fa:	0000                	unimp
500102fc:	6f4c                	.insn	2, 0x6f4c
500102fe:	6461                	lui	s0,0x18
50010300:	5020                	lw	s0,96(s0)
50010302:	4255                	li	tp,21
50010304:	5f59454b          	.insn	4, 0x5f59454b
50010308:	2058                	.insn	2, 0x2058
5001030a:	6164                	.insn	2, 0x6164
5001030c:	6174                	.insn	2, 0x6174
5001030e:	6620                	.insn	2, 0x6620
50010310:	6f72                	.insn	2, 0x6f72
50010312:	206d                	jal	500103bc <__func__.1+0x16c>
50010314:	4345                	li	t1,17
50010316:	74410043          	.insn	4, 0x74410043
5001031a:	6f20                	.insn	2, 0x6f20
5001031c:	6666                	.insn	2, 0x6666
5001031e:	20746573          	csrrs	a0,0x207,8
50010322:	5d64255b          	.insn	4, 0x5d64255b
50010326:	202c                	.insn	2, 0x202c
50010328:	6365                	lui	t1,0x19
5001032a:	75705f63          	blez	s7,50010a88 <k+0x208>
5001032e:	6b62                	.insn	2, 0x6b62
50010330:	7965                	lui	s2,0xffff9
50010332:	785f 6420 7461      	.insn	6, 0x74616420785f
50010338:	2061                	jal	500103c0 <__func__.1+0x170>
5001033a:	696d                	lui	s2,0x1b
5001033c:	74616d73          	csrrs	s10,0x746,2
50010340:	0a216863          	bltu	sp,sp,500103f0 <__func__.1+0x1a0>
50010344:	0000                	unimp
50010346:	0000                	unimp
50010348:	6f4c                	.insn	2, 0x6f4c
5001034a:	6461                	lui	s0,0x18
5001034c:	5020                	lw	s0,96(s0)
5001034e:	4255                	li	tp,21
50010350:	5f59454b          	.insn	4, 0x5f59454b
50010354:	2059                	jal	500103da <__func__.1+0x18a>
50010356:	6164                	.insn	2, 0x6164
50010358:	6174                	.insn	2, 0x6174
5001035a:	6620                	.insn	2, 0x6620
5001035c:	6f72                	.insn	2, 0x6f72
5001035e:	206d                	jal	50010408 <__func__.1+0x1b8>
50010360:	4345                	li	t1,17
50010362:	74410043          	.insn	4, 0x74410043
50010366:	6f20                	.insn	2, 0x6f20
50010368:	6666                	.insn	2, 0x6666
5001036a:	20746573          	csrrs	a0,0x207,8
5001036e:	5d64255b          	.insn	4, 0x5d64255b
50010372:	202c                	.insn	2, 0x202c
50010374:	6365                	lui	t1,0x19
50010376:	75705f63          	blez	s7,50010ad4 <k+0x254>
5001037a:	6b62                	.insn	2, 0x6b62
5001037c:	7965                	lui	s2,0xffff9
5001037e:	795f 6420 7461      	.insn	6, 0x74616420795f
50010384:	2061                	jal	5001040c <__func__.1+0x1bc>
50010386:	696d                	lui	s2,0x1b
50010388:	74616d73          	csrrs	s10,0x746,2
5001038c:	0a216863          	bltu	sp,sp,5001043c <__func__.1+0x1ec>
50010390:	0000                	unimp
50010392:	0000                	unimp
50010394:	6e49                	lui	t3,0x12
50010396:	656a                	.insn	2, 0x656a
50010398:	50207463          	bgeu	zero,sp,500108a0 <k+0x20>
5001039c:	4952                	lw	s2,20(sp)
5001039e:	4b56                	lw	s6,84(sp)
500103a0:	5945                	li	s2,-15
500103a2:	6620                	.insn	2, 0x6620
500103a4:	6f72                	.insn	2, 0x6f72
500103a6:	206d                	jal	50010450 <__func__.1+0x200>
500103a8:	7420766b          	.insn	4, 0x7420766b
500103ac:	4345206f          	j	500627e0 <_tbs_der_store_end+0x437c0>
500103b0:	00000043          	.insn	4, 0x0043
500103b4:	450a                	lw	a0,128(sp)
500103b6:	53204343          	.insn	4, 0x53204343
500103ba:	4749                	li	a4,18
500103bc:	494e                	lw	s2,208(sp)
500103be:	474e                	lw	a4,208(sp)
500103c0:	0000                	unimp
500103c2:	0000                	unimp
500103c4:	6f4c                	.insn	2, 0x6f4c
500103c6:	6461                	lui	s0,0x18
500103c8:	5320                	lw	s0,96(a4)
500103ca:	4749                	li	a4,18
500103cc:	5f4e                	lw	t5,240(sp)
500103ce:	2052                	.insn	2, 0x2052
500103d0:	6164                	.insn	2, 0x6164
500103d2:	6174                	.insn	2, 0x6174
500103d4:	6620                	.insn	2, 0x6620
500103d6:	6f72                	.insn	2, 0x6f72
500103d8:	206d                	jal	50010482 <__func__.1+0x232>
500103da:	4345                	li	t1,17
500103dc:	00000043          	.insn	4, 0x0043
500103e0:	7441                	lui	s0,0xffff0
500103e2:	6f20                	.insn	2, 0x6f20
500103e4:	6666                	.insn	2, 0x6666
500103e6:	20746573          	csrrs	a0,0x207,8
500103ea:	5d64255b          	.insn	4, 0x5d64255b
500103ee:	202c                	.insn	2, 0x202c
500103f0:	6365                	lui	t1,0x19
500103f2:	69735f63          	bge	t1,s7,50010a90 <k+0x210>
500103f6:	725f6e67          	.insn	4, 0x725f6e67
500103fa:	6420                	.insn	2, 0x6420
500103fc:	7461                	lui	s0,0xffff8
500103fe:	2061                	jal	50010486 <__func__.1+0x236>
50010400:	696d                	lui	s2,0x1b
50010402:	74616d73          	csrrs	s10,0x746,2
50010406:	0a216863          	bltu	sp,sp,500104b6 <__func__.1+0x266>
5001040a:	0000                	unimp
5001040c:	6341                	lui	t1,0x10
5001040e:	7574                	.insn	2, 0x7574
50010410:	6c61                	lui	s8,0x18
50010412:	2020                	.insn	2, 0x2020
50010414:	6420                	.insn	2, 0x6420
50010416:	7461                	lui	s0,0xffff8
50010418:	3a61                	jal	5000fdb0 <_bss_lma_end+0x5000a924>
5001041a:	3020                	.insn	2, 0x3020
5001041c:	2578                	.insn	2, 0x2578
5001041e:	3830                	.insn	2, 0x3830
50010420:	786c                	.insn	2, 0x786c
50010422:	000a                	c.slli	zero,0x2
50010424:	7845                	lui	a6,0xffff1
50010426:	6570                	.insn	2, 0x6570
50010428:	64657463          	bgeu	a0,t1,50010a70 <k+0x1f0>
5001042c:	6420                	.insn	2, 0x6420
5001042e:	7461                	lui	s0,0xffff8
50010430:	3a61                	jal	5000fdc8 <_bss_lma_end+0x5000a93c>
50010432:	3020                	.insn	2, 0x3020
50010434:	2578                	.insn	2, 0x2578
50010436:	3830                	.insn	2, 0x3830
50010438:	786c                	.insn	2, 0x786c
5001043a:	000a                	c.slli	zero,0x2
5001043c:	6f4c                	.insn	2, 0x6f4c
5001043e:	6461                	lui	s0,0x18
50010440:	5320                	lw	s0,96(a4)
50010442:	4749                	li	a4,18
50010444:	5f4e                	lw	t5,240(sp)
50010446:	61642053          	.insn	4, 0x61642053
5001044a:	6174                	.insn	2, 0x6174
5001044c:	6620                	.insn	2, 0x6620
5001044e:	6f72                	.insn	2, 0x6f72
50010450:	206d                	jal	500104fa <__func__.1+0x2aa>
50010452:	4345                	li	t1,17
50010454:	00000043          	.insn	4, 0x0043
50010458:	7441                	lui	s0,0xffff0
5001045a:	6f20                	.insn	2, 0x6f20
5001045c:	6666                	.insn	2, 0x6666
5001045e:	20746573          	csrrs	a0,0x207,8
50010462:	5d64255b          	.insn	4, 0x5d64255b
50010466:	202c                	.insn	2, 0x202c
50010468:	6365                	lui	t1,0x19
5001046a:	69735f63          	bge	t1,s7,50010b08 <k+0x288>
5001046e:	735f6e67          	.insn	4, 0x735f6e67
50010472:	6420                	.insn	2, 0x6420
50010474:	7461                	lui	s0,0xffff8
50010476:	2061                	jal	500104fe <__func__.1+0x2ae>
50010478:	696d                	lui	s2,0x1b
5001047a:	74616d73          	csrrs	s10,0x746,2
5001047e:	0a216863          	bltu	sp,sp,5001052e <__func__.0+0x1e>
50010482:	0000                	unimp
50010484:	450a                	lw	a0,128(sp)
50010486:	56204343          	.insn	4, 0x56204343
5001048a:	5245                	li	tp,-15
5001048c:	4649                	li	a2,18
5001048e:	4959                	li	s2,22
50010490:	474e                	lw	a4,208(sp)
50010492:	0000                	unimp
50010494:	6f4c                	.insn	2, 0x6f4c
50010496:	6461                	lui	s0,0x18
50010498:	5620                	lw	s0,104(a2)
5001049a:	5245                	li	tp,-15
5001049c:	4649                	li	a2,18
5001049e:	5f59                	li	t5,-10
500104a0:	2052                	.insn	2, 0x2052
500104a2:	6164                	.insn	2, 0x6164
500104a4:	6174                	.insn	2, 0x6174
500104a6:	6620                	.insn	2, 0x6620
500104a8:	6f72                	.insn	2, 0x6f72
500104aa:	206d                	jal	50010554 <__func__.0+0x44>
500104ac:	4345                	li	t1,17
500104ae:	74410043          	.insn	4, 0x74410043
500104b2:	6f20                	.insn	2, 0x6f20
500104b4:	6666                	.insn	2, 0x6666
500104b6:	20746573          	csrrs	a0,0x207,8
500104ba:	5d64255b          	.insn	4, 0x5d64255b
500104be:	202c                	.insn	2, 0x202c
500104c0:	6365                	lui	t1,0x19
500104c2:	65765f63          	bge	a2,s7,50010b20 <k+0x2a0>
500104c6:	6972                	.insn	2, 0x6972
500104c8:	7966                	.insn	2, 0x7966
500104ca:	725f 6420 7461      	.insn	6, 0x74616420725f
500104d0:	2061                	jal	50010558 <__func__.0+0x48>
500104d2:	696d                	lui	s2,0x1b
500104d4:	74616d73          	csrrs	s10,0x746,2
500104d8:	0a216863          	bltu	sp,sp,50010588 <__func__.0+0x78>
500104dc:	0000                	unimp
500104de:	0000                	unimp
500104e0:	6341                	lui	t1,0x10
500104e2:	7574                	.insn	2, 0x7574
500104e4:	6c61                	lui	s8,0x18
500104e6:	2020                	.insn	2, 0x2020
500104e8:	6420                	.insn	2, 0x6420
500104ea:	7461                	lui	s0,0xffff8
500104ec:	3a61                	jal	5000fe84 <_bss_lma_end+0x5000a9f8>
500104ee:	3020                	.insn	2, 0x3020
500104f0:	2578                	.insn	2, 0x2578
500104f2:	7838                	.insn	2, 0x7838
500104f4:	000a                	c.slli	zero,0x2
500104f6:	0000                	unimp
500104f8:	7845                	lui	a6,0xffff1
500104fa:	6570                	.insn	2, 0x6570
500104fc:	64657463          	bgeu	a0,t1,50010b44 <k+0x2c4>
50010500:	6420                	.insn	2, 0x6420
50010502:	7461                	lui	s0,0xffff8
50010504:	3a61                	jal	5000fe9c <_bss_lma_end+0x5000aa10>
50010506:	3020                	.insn	2, 0x3020
50010508:	2578                	.insn	2, 0x2578
5001050a:	7838                	.insn	2, 0x7838
5001050c:	000a                	c.slli	zero,0x2
	...

50010510 <__func__.0>:
50010510:	6365                	lui	t1,0x19
50010512:	656b5f63          	bge	s6,s6,50010b70 <k+0x2f0>
50010516:	6779                	lui	a4,0x1e
50010518:	6e65                	lui	t3,0x19
5001051a:	665f 6f6c 0077      	.insn	6, 0x00776f6c665f
50010520:	6f4c                	.insn	2, 0x6f4c
50010522:	6461                	lui	s0,0x18
50010524:	4b20                	lw	s0,80(a4)
50010526:	7965                	lui	s2,0xffff9
50010528:	6420                	.insn	2, 0x6420
5001052a:	7461                	lui	s0,0xffff8
5001052c:	2061                	jal	500105b4 <__func__.0+0xa4>
5001052e:	6f74                	.insn	2, 0x6f74
50010530:	4820                	lw	s0,80(s0)
50010532:	414d                	li	sp,19
50010534:	00000043          	.insn	4, 0x0043
50010538:	6f4c                	.insn	2, 0x6f4c
5001053a:	6461                	lui	s0,0x18
5001053c:	5420                	lw	s0,104(s0)
5001053e:	4741                	li	a4,16
50010540:	6420                	.insn	2, 0x6420
50010542:	7461                	lui	s0,0xffff8
50010544:	2061                	jal	500105cc <__func__.0+0xbc>
50010546:	7266                	.insn	2, 0x7266
50010548:	48206d6f          	jal	s10,500169ca <FMC_data+0x30da>
5001054c:	414d                	li	sp,19
5001054e:	6f742043          	.insn	4, 0x6f742043
50010552:	4b20                	lw	s0,80(a4)
50010554:	0056                	c.slli	zero,0x15
50010556:	0000                	unimp
50010558:	6f4c                	.insn	2, 0x6f4c
5001055a:	6461                	lui	s0,0x18
5001055c:	5420                	lw	s0,104(s0)
5001055e:	4741                	li	a4,16
50010560:	6420                	.insn	2, 0x6420
50010562:	7461                	lui	s0,0xffff8
50010564:	2061                	jal	500105ec <__func__.0+0xdc>
50010566:	7266                	.insn	2, 0x7266
50010568:	48206d6f          	jal	s10,500169ea <FMC_data+0x30fa>
5001056c:	414d                	li	sp,19
5001056e:	74410043          	.insn	4, 0x74410043
50010572:	6f20                	.insn	2, 0x6f20
50010574:	6666                	.insn	2, 0x6666
50010576:	20746573          	csrrs	a0,0x207,8
5001057a:	5d64255b          	.insn	4, 0x5d64255b
5001057e:	202c                	.insn	2, 0x202c
50010580:	6d68                	.insn	2, 0x6d68
50010582:	6361                	lui	t1,0x18
50010584:	745f 6761 6420      	.insn	6, 0x64206761745f
5001058a:	7461                	lui	s0,0xffff8
5001058c:	2061                	jal	50010614 <__func__.0+0x104>
5001058e:	696d                	lui	s2,0x1b
50010590:	74616d73          	csrrs	s10,0x746,2
50010594:	0a216863          	bltu	sp,sp,50010644 <__func__.0+0x134>
50010598:	0000                	unimp
5001059a:	0000                	unimp
5001059c:	5746                	lw	a4,112(sp)
5001059e:	203a                	.insn	2, 0x203a
500105a0:	74696157          	.insn	4, 0x74696157
500105a4:	0000                	unimp
500105a6:	0000                	unimp
500105a8:	5746                	lw	a4,112(sp)
500105aa:	203a                	.insn	2, 0x203a
500105ac:	6552                	.insn	2, 0x6552
500105ae:	6461                	lui	s0,0x18
500105b0:	6e69                	lui	t3,0x1a
500105b2:	30252067          	.insn	4, 0x30252067
500105b6:	6438                	.insn	2, 0x6438
500105b8:	6220                	.insn	2, 0x6220
500105ba:	7479                	lui	s0,0xffffe
500105bc:	7365                	lui	t1,0xffff9
500105be:	6620                	.insn	2, 0x6620
500105c0:	6f72                	.insn	2, 0x6f72
500105c2:	206d                	jal	5001066c <__func__.0+0x15c>
500105c4:	616d                	add	sp,sp,240
500105c6:	6c69                	lui	s8,0x1a
500105c8:	6f62                	.insn	2, 0x6f62
500105ca:	0a78                	add	a4,sp,284
500105cc:	0000                	unimp
500105ce:	0000                	unimp
500105d0:	2020                	.insn	2, 0x2020
500105d2:	6164                	.insn	2, 0x6164
500105d4:	6174                	.insn	2, 0x6174
500105d6:	3a74756f          	jal	a0,5005817c <_tbs_der_store_end+0x3915c>
500105da:	3020                	.insn	2, 0x3020
500105dc:	2578                	.insn	2, 0x2578
500105de:	3830                	.insn	2, 0x3830
500105e0:	0a78                	add	a4,sp,284
500105e2:	0000                	unimp
500105e4:	5746                	lw	a4,112(sp)
500105e6:	203a                	.insn	2, 0x203a
500105e8:	74697257          	.insn	4, 0x74697257
500105ec:	6e69                	lui	t3,0x1a
500105ee:	78302067          	.insn	4, 0x78302067
500105f2:	3025                	jal	5000fe1a <_bss_lma_end+0x5000a98e>
500105f4:	7838                	.insn	2, 0x7838
500105f6:	6220                	.insn	2, 0x6220
500105f8:	7479                	lui	s0,0xffffe
500105fa:	7365                	lui	t1,0xffff9
500105fc:	7420                	.insn	2, 0x7420
500105fe:	616d206f          	j	500e2c14 <_tbs_der_store_end+0xc3bf4>
50010602:	6c69                	lui	s8,0x1a
50010604:	6f62                	.insn	2, 0x6f62
50010606:	0a78                	add	a4,sp,284
50010608:	0000                	unimp
5001060a:	0000                	unimp
5001060c:	5746                	lw	a4,112(sp)
5001060e:	203a                	.insn	2, 0x203a
50010610:	20746553          	.insn	4, 0x20746553
50010614:	6164                	.insn	2, 0x6164
50010616:	6174                	.insn	2, 0x6174
50010618:	7220                	.insn	2, 0x7220
5001061a:	6165                	add	sp,sp,112
5001061c:	7964                	.insn	2, 0x7964
5001061e:	7320                	.insn	2, 0x7320
50010620:	6174                	.insn	2, 0x6174
50010622:	7574                	.insn	2, 0x7574
50010624:	00000073          	ecall
50010628:	5245                	li	tp,-15
5001062a:	4f52                	lw	t5,20(sp)
5001062c:	3a52                	.insn	2, 0x3a52
5001062e:	6d20                	.insn	2, 0x6d20
50010630:	6961                	lui	s2,0x18
50010632:	626c                	.insn	2, 0x626c
50010634:	6920786f          	jal	a6,50017cc6 <FMC_data+0x43d6>
50010638:	206e                	.insn	2, 0x206e
5001063a:	6e75                	lui	t3,0x1d
5001063c:	7865                	lui	a6,0xffff9
5001063e:	6570                	.insn	2, 0x6570
50010640:	64657463          	bgeu	a0,t1,50010c88 <__func__.2+0x8>
50010644:	7320                	.insn	2, 0x7320
50010646:	6174                	.insn	2, 0x6174
50010648:	6574                	.insn	2, 0x6574
5001064a:	2820                	.insn	2, 0x2820
5001064c:	3025                	jal	5000fe74 <_bss_lma_end+0x5000a9e8>
5001064e:	7838                	.insn	2, 0x7838
50010650:	2029                	jal	5001065a <__func__.0+0x14a>
50010652:	6e656877          	.insn	4, 0x6e656877
50010656:	6520                	.insn	2, 0x6520
50010658:	7078                	.insn	2, 0x7078
5001065a:	6365                	lui	t1,0x19
5001065c:	6974                	.insn	2, 0x6974
5001065e:	676e                	.insn	2, 0x676e
50010660:	4d20                	lw	s0,88(a0)
50010662:	4f42                	lw	t5,16(sp)
50010664:	5f58                	lw	a4,60(a4)
50010666:	5845                	li	a6,-15
50010668:	4345                	li	t1,17
5001066a:	5455                	li	s0,-11
5001066c:	5f45                	li	t5,-15
5001066e:	20434f53          	.insn	4, 0x20434f53
50010672:	3028                	.insn	2, 0x3028
50010674:	2578                	.insn	2, 0x2578
50010676:	3830                	.insn	2, 0x3830
50010678:	2978                	.insn	2, 0x2978
5001067a:	000a                	c.slli	zero,0x2
5001067c:	5746                	lw	a4,112(sp)
5001067e:	203a                	.insn	2, 0x203a
50010680:	614d                	add	sp,sp,176
50010682:	6c69                	lui	s8,0x1a
50010684:	6f62                	.insn	2, 0x6f62
50010686:	2078                	.insn	2, 0x2078
50010688:	6e69                	lui	t3,0x1a
5001068a:	6520                	.insn	2, 0x6520
5001068c:	7078                	.insn	2, 0x7078
5001068e:	6365                	lui	t1,0x19
50010690:	6574                	.insn	2, 0x6574
50010692:	2064                	.insn	2, 0x2064
50010694:	74617473          	csrrc	s0,0x746,2
50010698:	2c65                	jal	50010950 <k+0xd0>
5001069a:	4d20                	lw	s0,88(a0)
5001069c:	4f42                	lw	t5,16(sp)
5001069e:	5f58                	lw	a4,60(a4)
500106a0:	5845                	li	a6,-15
500106a2:	4345                	li	t1,17
500106a4:	5455                	li	s0,-11
500106a6:	5f45                	li	t5,-15
500106a8:	2c434f53          	.insn	4, 0x2c434f53
500106ac:	6520                	.insn	2, 0x6520
500106ae:	646e                	.insn	2, 0x646e
500106b0:	6e69                	lui	t3,0x1a
500106b2:	65742067          	.insn	4, 0x65742067
500106b6:	77207473          	csrrc	s0,0x772,0
500106ba:	7469                	lui	s0,0xffffa
500106bc:	2068                	.insn	2, 0x2068
500106be:	63637573          	csrrc	a0,0x636,6
500106c2:	7365                	lui	t1,0xffff9
500106c4:	00000073          	ecall
500106c8:	20495053          	.insn	4, 0x20495053
500106cc:	7245                	lui	tp,0xffff1
500106ce:	6f72                	.insn	2, 0x6f72
500106d0:	7372                	.insn	2, 0x7372
500106d2:	203a                	.insn	2, 0x203a
500106d4:	7830                	.insn	2, 0x7830
500106d6:	3025                	jal	5000fefe <_bss_lma_end+0x5000aa72>
500106d8:	6c38                	.insn	2, 0x6c38
500106da:	0a58                	add	a4,sp,276
500106dc:	0000                	unimp
500106de:	0000                	unimp
500106e0:	2020                	.insn	2, 0x2020
500106e2:	6d6d6f43          	.insn	4, 0x6d6d6f43
500106e6:	6e61                	lui	t3,0x18
500106e8:	2064                	.insn	2, 0x2064
500106ea:	6e49                	lui	t3,0x12
500106ec:	6176                	.insn	2, 0x6176
500106ee:	696c                	.insn	2, 0x696c
500106f0:	0064                	add	s1,sp,12
500106f2:	0000                	unimp
500106f4:	2020                	.insn	2, 0x2020
500106f6:	44495343          	.insn	4, 0x44495343
500106fa:	4920                	lw	s0,80(a0)
500106fc:	766e                	.insn	2, 0x766e
500106fe:	6c61                	lui	s8,0x18
50010700:	6469                	lui	s0,0x1a
50010702:	0000                	unimp
50010704:	2020                	.insn	2, 0x2020
50010706:	6341                	lui	t1,0x10
50010708:	73736563          	bltu	t1,s7,50010e32 <__func__.2+0x1b2>
5001070c:	4920                	lw	s0,80(a0)
5001070e:	766e                	.insn	2, 0x766e
50010710:	6c61                	lui	s8,0x18
50010712:	6469                	lui	s0,0x1a
50010714:	0000                	unimp
50010716:	0000                	unimp
50010718:	2020                	.insn	2, 0x2020
5001071a:	4946                	lw	s2,80(sp)
5001071c:	4f46                	lw	t5,80(sp)
5001071e:	4f20                	lw	s0,88(a4)
50010720:	6576                	.insn	2, 0x6576
50010722:	6672                	.insn	2, 0x6672
50010724:	6f6c                	.insn	2, 0x6f6c
50010726:	6e450077          	.insn	4, 0x6e450077
5001072a:	6261                	lui	tp,0x18
5001072c:	656c                	.insn	2, 0x656c
5001072e:	5320                	lw	s0,96(a4)
50010730:	4148                	lw	a0,4(a0)
50010732:	3532                	.insn	2, 0x3532
50010734:	0036                	c.slli	zero,0xd
50010736:	0000                	unimp
50010738:	6f4c                	.insn	2, 0x6f4c
5001073a:	6461                	lui	s0,0x18
5001073c:	4420                	lw	s0,72(s0)
5001073e:	4749                	li	a4,18
50010740:	5345                	li	t1,-15
50010742:	2054                	.insn	2, 0x2054
50010744:	6164                	.insn	2, 0x6164
50010746:	6174                	.insn	2, 0x6174
50010748:	6620                	.insn	2, 0x6620
5001074a:	6f72                	.insn	2, 0x6f72
5001074c:	206d                	jal	500107f6 <__func__.0+0x2e6>
5001074e:	32414853          	.insn	4, 0x32414853
50010752:	3635                	jal	5001027e <__func__.1+0x2e>
50010754:	0000                	unimp
50010756:	0000                	unimp
50010758:	726f7453          	.insn	4, 0x726f7453
5001075c:	6e69                	lui	t3,0x1a
5001075e:	48532067          	.insn	4, 0x48532067
50010762:	3241                	jal	500100e2 <FMC_expected_digest+0x62>
50010764:	3635                	jal	50010290 <__func__.1+0x40>
50010766:	6420                	.insn	2, 0x6420
50010768:	6769                	lui	a4,0x1a
5001076a:	7365                	lui	t1,0xffff9
5001076c:	2074                	.insn	2, 0x2074
5001076e:	6f74                	.insn	2, 0x6f74
50010770:	5020                	lw	s0,96(s0)
50010772:	65205243          	.insn	4, 0x65205243
50010776:	746e                	.insn	2, 0x746e
50010778:	7972                	.insn	2, 0x7972
5001077a:	2520                	.insn	2, 0x2520
5001077c:	0a64                	add	s1,sp,284
5001077e:	0000                	unimp
50010780:	7441                	lui	s0,0xffff0
50010782:	6f20                	.insn	2, 0x6f20
50010784:	6666                	.insn	2, 0x6666
50010786:	20746573          	csrrs	a0,0x207,8
5001078a:	5d64255b          	.insn	4, 0x5d64255b
5001078e:	202c                	.insn	2, 0x202c
50010790:	5f616873          	csrrs	a6,sattri3_base,2
50010794:	6964                	.insn	2, 0x6964
50010796:	74736567          	.insn	4, 0x74736567
5001079a:	6420                	.insn	2, 0x6420
5001079c:	7461                	lui	s0,0xffff8
5001079e:	2061                	jal	50010826 <__func__.0+0x316>
500107a0:	696d                	lui	s2,0x1b
500107a2:	74616d73          	csrrs	s10,0x746,2
500107a6:	0a216863          	bltu	sp,sp,50010856 <__func__.0+0x346>
500107aa:	0000                	unimp
500107ac:	202d                	jal	500107d6 <__func__.0+0x2c6>
500107ae:	3128                	.insn	2, 0x3128
500107b0:	2029342f          	.insn	4, 0x2029342f
500107b4:	207c                	.insn	2, 0x207c
500107b6:	6f74                	.insn	2, 0x6f74
500107b8:	6174                	.insn	2, 0x6174
500107ba:	5f6c                	lw	a1,124(a4)
500107bc:	656c                	.insn	2, 0x656c
500107be:	3a6e                	.insn	2, 0x3a6e
500107c0:	2520                	.insn	2, 0x2520
500107c2:	2c64                	.insn	2, 0x2c64
500107c4:	6d20                	.insn	2, 0x6d20
500107c6:	7365                	lui	t1,0xffff9
500107c8:	65676173          	csrrs	sp,hviprio1h,14
500107cc:	6c5f 6e65 203a      	.insn	6, 0x203a6e656c5f
500107d2:	6425                	lui	s0,0x9
500107d4:	202c                	.insn	2, 0x202c
500107d6:	6170                	.insn	2, 0x6170
500107d8:	6464                	.insn	2, 0x6464
500107da:	6e69                	lui	t3,0x1a
500107dc:	656c5f67          	.insn	4, 0x656c5f67
500107e0:	3a6e                	.insn	2, 0x3a6e
500107e2:	2520                	.insn	2, 0x2520
500107e4:	2c64                	.insn	2, 0x2c64
500107e6:	6620                	.insn	2, 0x6620
500107e8:	6e69                	lui	t3,0x1a
500107ea:	6c61                	lui	s8,0x18
500107ec:	625f 6f6c 6b63      	.insn	6, 0x6b636f6c625f
500107f2:	6c5f 6e65 203a      	.insn	6, 0x203a6e656c5f
500107f8:	6425                	lui	s0,0x9
500107fa:	0a20                	add	s0,sp,280
500107fc:	0000                	unimp
500107fe:	0000                	unimp
50010800:	202d                	jal	5001082a <__func__.0+0x31a>
50010802:	3228                	.insn	2, 0x3228
50010804:	2029342f          	.insn	4, 0x2029342f
50010808:	207c                	.insn	2, 0x207c
5001080a:	33616873          	csrrs	a6,mhpmevent22,2
5001080e:	3438                	.insn	2, 0x3438
50010810:	635f 726f 2865      	.insn	6, 0x2865726f635f
50010816:	2029                	jal	50010820 <__func__.0+0x310>
50010818:	6e69                	lui	t3,0x1a
5001081a:	7469                	lui	s0,0xffffa
5001081c:	6169                	add	sp,sp,208
5001081e:	206c                	.insn	2, 0x206c
50010820:	6964                	.insn	2, 0x6964
50010822:	74736567          	.insn	4, 0x74736567
50010826:	6420                	.insn	2, 0x6420
50010828:	2e656e6f          	jal	t3,50066b0e <_tbs_der_store_end+0x47aee>
5001082c:	0000                	unimp
5001082e:	0000                	unimp
50010830:	202d                	jal	5001085a <__func__.0+0x34a>
50010832:	3328                	.insn	2, 0x3328
50010834:	2029342f          	.insn	4, 0x2029342f
50010838:	207c                	.insn	2, 0x207c
5001083a:	33616873          	csrrs	a6,mhpmevent22,2
5001083e:	3438                	.insn	2, 0x3438
50010840:	7020                	.insn	2, 0x7020
50010842:	6461                	lui	s0,0x18
50010844:	6964                	.insn	2, 0x6964
50010846:	676e                	.insn	2, 0x676e
50010848:	6420                	.insn	2, 0x6420
5001084a:	2e656e6f          	jal	t3,50066b30 <_tbs_der_store_end+0x47b10>
5001084e:	0000                	unimp
50010850:	202d                	jal	5001087a <__func__.0+0x36a>
50010852:	3428                	.insn	2, 0x3428
50010854:	2029342f          	.insn	4, 0x2029342f
50010858:	207c                	.insn	2, 0x207c
5001085a:	33616873          	csrrs	a6,mhpmevent22,2
5001085e:	3438                	.insn	2, 0x3438
50010860:	635f 726f 2865      	.insn	6, 0x2865726f635f
50010866:	2029                	jal	50010870 <__func__.0+0x360>
50010868:	6966                	.insn	2, 0x6966
5001086a:	616e                	.insn	2, 0x616e
5001086c:	206c                	.insn	2, 0x206c
5001086e:	6964                	.insn	2, 0x6964
50010870:	74736567          	.insn	4, 0x74736567
50010874:	6420                	.insn	2, 0x6420
50010876:	2e656e6f          	jal	t3,50066b5c <_tbs_der_store_end+0x47b3c>
5001087a:	0000                	unimp
5001087c:	0000                	unimp
	...

50010880 <k>:
50010880:	ae22                	.insn	2, 0xae22
50010882:	d728                	sw	a0,104(a4)
50010884:	2f98                	.insn	2, 0x2f98
50010886:	428a                	lw	t0,128(sp)
50010888:	65cd                	lui	a1,0x13
5001088a:	449123ef          	jal	t2,500234d2 <_tbs_der_store_end+0x44b2>
5001088e:	3b2f7137          	lui	sp,0x3b2f7
50010892:	ec4d                	bnez	s0,5001094c <k+0xcc>
50010894:	b5c0fbcf          	.insn	4, 0xb5c0fbcf
50010898:	dbbc                	sw	a5,112(a5)
5001089a:	8189                	srl	a1,a1,0x2
5001089c:	dba5                	beqz	a5,5001080c <__func__.0+0x2fc>
5001089e:	e9b5                	bnez	a1,50010912 <k+0x92>
500108a0:	b538                	.insn	2, 0xb538
500108a2:	f348                	.insn	2, 0xf348
500108a4:	3956c25b          	.insn	4, 0x3956c25b
500108a8:	d019                	beqz	s0,500107ae <__func__.0+0x29e>
500108aa:	b605                	j	500103ca <__func__.1+0x17a>
500108ac:	11f1                	add	gp,gp,-4
500108ae:	59f1                	li	s3,-4
500108b0:	af194f9b          	.insn	4, 0xaf194f9b
500108b4:	82a4                	.insn	2, 0x82a4
500108b6:	8118923f 5ed5da6d 	.insn	8, 0x5ed5da6d8118923f
500108be:	ab1c                	.insn	2, 0xab1c
500108c0:	0242                	sll	tp,tp,0x10
500108c2:	aa98a303          	lw	t1,-1367(a7)
500108c6:	6fbed807          	.insn	4, 0x6fbed807
500108ca:	4570                	lw	a2,76(a0)
500108cc:	5b01                	li	s6,-32
500108ce:	b28c1283          	lh	t0,-1240(s8) # 17b28 <_bss_lma_end+0x1269c>
500108d2:	4ee4                	lw	s1,92(a3)
500108d4:	85be                	mv	a1,a5
500108d6:	2431                	jal	50010ae2 <k+0x262>
500108d8:	b4e2                	.insn	2, 0xb4e2
500108da:	7dc3d5ff          	.insn	4, 0x7dc3d5ff
500108de:	550c                	lw	a1,40(a0)
500108e0:	f27b896f          	jal	s2,4ffc9806 <_bss_lma_end+0x4ffc437a>
500108e4:	5d74                	lw	a3,124(a0)
500108e6:	72be                	.insn	2, 0x72be
500108e8:	96b1                	sra	a3,a3,0x2c
500108ea:	3b16                	.insn	2, 0x3b16
500108ec:	b1fe                	.insn	2, 0xb1fe
500108ee:	80de                	mv	ra,s7
500108f0:	1235                	add	tp,tp,-19 # 17fed <_bss_lma_end+0x12b61>
500108f2:	06a725c7          	.insn	4, 0x06a725c7
500108f6:	9bdc                	.insn	2, 0x9bdc
500108f8:	2694                	.insn	2, 0x2694
500108fa:	cf69                	beqz	a4,500109d4 <k+0x154>
500108fc:	f174                	.insn	2, 0xf174
500108fe:	4ad2c19b          	.insn	4, 0x4ad2c19b
50010902:	9ef1                	.insn	2, 0x9ef1
50010904:	69c1                	lui	s3,0x10
50010906:	25e3e49b          	.insn	4, 0x25e3e49b
5001090a:	4786384f          	.insn	4, 0x4786384f
5001090e:	efbe                	.insn	2, 0xefbe
50010910:	d5b5                	beqz	a1,5001087c <__func__.0+0x36c>
50010912:	8b8c                	.insn	2, 0x8b8c
50010914:	9dc6                	add	s11,s11,a7
50010916:	0fc1                	add	t6,t6,16 # 3000010 <_bss_lma_end+0x2ffab84>
50010918:	9c65                	.insn	2, 0x9c65
5001091a:	77ac                	.insn	2, 0x77ac
5001091c:	a1cc                	.insn	2, 0xa1cc
5001091e:	240c                	.insn	2, 0x240c
50010920:	0275                	add	tp,tp,29 # 1d <_start+0x1d>
50010922:	2c6f592b          	.insn	4, 0x2c6f592b
50010926:	2de9                	jal	50011000 <__func__.2+0x380>
50010928:	6ea6e483          	.insn	4, 0x6ea6e483
5001092c:	84aa                	mv	s1,a0
5001092e:	4a74                	lw	a3,84(a2)
50010930:	fbd4                	.insn	2, 0xfbd4
50010932:	bd41                	j	500107c2 <__func__.0+0x2b2>
50010934:	a9dc                	.insn	2, 0xa9dc
50010936:	5cb0                	lw	a2,120(s1)
50010938:	53b5                	li	t2,-19
5001093a:	8311                	srl	a4,a4,0x4
5001093c:	88da                	mv	a7,s6
5001093e:	76f9                	lui	a3,0xffffe
50010940:	ee66dfab          	.insn	4, 0xee66dfab
50010944:	5152                	lw	sp,52(sp)
50010946:	983e                	add	a6,a6,a5
50010948:	3210                	.insn	2, 0x3210
5001094a:	2db4                	.insn	2, 0x2db4
5001094c:	c66d                	beqz	a2,50010a36 <k+0x1b6>
5001094e:	a831                	j	5001096a <k+0xea>
50010950:	98fb213f b00327c8 	.insn	8, 0xb00327c898fb213f
50010958:	0ee4                	add	s1,sp,860
5001095a:	7fc7beef          	jal	t4,5008c156 <_tbs_der_store_end+0x6d136>
5001095e:	bf59                	j	500108f4 <k+0x74>
50010960:	8fc2                	mv	t6,a6
50010962:	3da8                	.insn	2, 0x3da8
50010964:	c6e00bf3          	.insn	4, 0xc6e00bf3
50010968:	a725                	j	50011090 <__func__.2+0x410>
5001096a:	930a                	add	t1,t1,sp
5001096c:	d5a79147          	.insn	4, 0xd5a79147
50010970:	e003826f          	jal	tp,4ff48f70 <_bss_lma_end+0x4ff43ae4>
50010974:	6351                	lui	t1,0x14
50010976:	06ca                	sll	a3,a3,0x12
50010978:	6e70                	.insn	2, 0x6e70
5001097a:	0a0e                	sll	s4,s4,0x3
5001097c:	14292967          	.insn	4, 0x14292967
50010980:	2ffc                	.insn	2, 0x2ffc
50010982:	46d2                	lw	a3,20(sp)
50010984:	0a85                	add	s5,s5,1
50010986:	c92627b7          	lui	a5,0xc9262
5001098a:	5c26                	lw	s8,104(sp)
5001098c:	2138                	.insn	2, 0x2138
5001098e:	2aed2e1b          	.insn	4, 0x2aed2e1b
50010992:	5ac4                	lw	s1,52(a3)
50010994:	6dfc                	.insn	2, 0x6dfc
50010996:	4d2c                	lw	a1,88(a0)
50010998:	b3df 9d95 0d13      	.insn	6, 0x0d139d95b3df
5001099e:	5338                	lw	a4,96(a4)
500109a0:	63de                	.insn	2, 0x63de
500109a2:	73548baf          	.insn	4, 0x73548baf
500109a6:	650a                	.insn	2, 0x650a
500109a8:	b2a8                	.insn	2, 0xb2a8
500109aa:	0abb3c77          	.insn	4, 0x0abb3c77
500109ae:	766a                	.insn	2, 0x766a
500109b0:	aee6                	.insn	2, 0xaee6
500109b2:	47ed                	li	a5,27
500109b4:	c92e                	sw	a1,144(sp)
500109b6:	81c2                	mv	gp,a6
500109b8:	1482353b          	.insn	4, 0x1482353b
500109bc:	2c85                	jal	50010c2c <k+0x3ac>
500109be:	9272                	add	tp,tp,t3
500109c0:	0364                	add	s1,sp,396
500109c2:	4cf1                	li	s9,28
500109c4:	e8a1                	bnez	s1,50010a14 <k+0x194>
500109c6:	3001a2bf 664bbc42 	.insn	8, 0x664bbc423001a2bf
500109ce:	a81a                	.insn	2, 0xa81a
500109d0:	9791                	sra	a5,a5,0x24
500109d2:	d0f8                	sw	a4,100(s1)
500109d4:	8b70                	.insn	2, 0x8b70
500109d6:	be30c24b          	.insn	4, 0xbe30c24b
500109da:	0654                	add	a3,sp,772
500109dc:	c76c51a3          	.insn	4, 0xc76c51a3
500109e0:	5218                	lw	a4,32(a2)
500109e2:	e819d6ef          	jal	a3,4ffae862 <_bss_lma_end+0x4ffa93d6>
500109e6:	d192                	sw	tp,224(sp)
500109e8:	a910                	.insn	2, 0xa910
500109ea:	5565                	li	a0,-7
500109ec:	0624                	add	s1,sp,776
500109ee:	d699                	beqz	a3,500108fc <k+0x7c>
500109f0:	202a                	.insn	2, 0x202a
500109f2:	5771                	li	a4,-4
500109f4:	3585                	jal	50010854 <__func__.0+0x344>
500109f6:	f40e                	.insn	2, 0xf40e
500109f8:	d1b8                	sw	a4,96(a1)
500109fa:	a07032bb          	.insn	4, 0xa07032bb
500109fe:	106a                	c.slli	zero,0x3a
50010a00:	d0c8                	sw	a0,36(s1)
50010a02:	b8d2                	.insn	2, 0xb8d2
50010a04:	c116                	sw	t0,128(sp)
50010a06:	19a4                	add	s1,sp,248
50010a08:	5141ab53          	.insn	4, 0x5141ab53
50010a0c:	6c08                	.insn	2, 0x6c08
50010a0e:	eb991e37          	lui	t3,0xeb991
50010a12:	df8e                	sw	gp,252(sp)
50010a14:	774c                	.insn	2, 0x774c
50010a16:	2748                	.insn	2, 0x2748
50010a18:	48a8                	lw	a0,80(s1)
50010a1a:	bcb5e19b          	.insn	4, 0xbcb5e19b
50010a1e:	34b0                	.insn	2, 0x34b0
50010a20:	c5c95a63          	bge	s2,t3,5000fe74 <_bss_lma_end+0x5000a9e8>
50010a24:	391c0cb3          	.insn	4, 0x391c0cb3
50010a28:	e3418acb          	.insn	4, 0xe3418acb
50010a2c:	aa4a                	.insn	2, 0xaa4a
50010a2e:	4ed8                	lw	a4,28(a3)
50010a30:	7763e373          	csrrs	t1,0x776,7
50010a34:	5b9cca4f          	.insn	4, 0x5b9cca4f
50010a38:	d6b2b8a3          	.insn	4, 0xd6b2b8a3
50010a3c:	682e6ff3          	csrrs	t6,0x682,28
50010a40:	b2fc                	.insn	2, 0xb2fc
50010a42:	82ee5def          	jal	s11,4fff5a70 <_bss_lma_end+0x4fff05e4>
50010a46:	2f60748f          	.insn	4, 0x2f60748f
50010a4a:	636f4317          	auipc	t1,0x636f4
50010a4e:	78a5                	lui	a7,0xfffe9
50010a50:	ab72                	.insn	2, 0xab72
50010a52:	a1f0                	.insn	2, 0xa1f0
50010a54:	7814                	.insn	2, 0x7814
50010a56:	84c8                	.insn	2, 0x84c8
50010a58:	39ec                	.insn	2, 0x39ec
50010a5a:	1a64                	add	s1,sp,316
50010a5c:	0208                	add	a0,sp,256
50010a5e:	1e288cc7          	.insn	4, 0x1e288cc7
50010a62:	fffa2363          	.insn	4, 0xfffa2363
50010a66:	90be                	add	ra,ra,a5
50010a68:	bde9                	j	50010942 <k+0xc2>
50010a6a:	de82                	sw	zero,124(sp)
50010a6c:	a4506ceb          	.insn	4, 0xa4506ceb
50010a70:	7915                	lui	s2,0xfffe5
50010a72:	b2c6                	.insn	2, 0xb2c6
50010a74:	bef9a3f7          	.insn	4, 0xbef9a3f7
50010a78:	e372532b          	.insn	4, 0xe372532b
50010a7c:	78f2                	.insn	2, 0x78f2
50010a7e:	c671                	beqz	a2,50010b4a <k+0x2ca>
50010a80:	619c                	.insn	2, 0x619c
50010a82:	ea26                	.insn	2, 0xea26
50010a84:	3ece                	.insn	2, 0x3ece
50010a86:	c207ca27          	.insn	4, 0xc207ca27
50010a8a:	21c0                	.insn	2, 0x21c0
50010a8c:	d186b8c7          	.insn	4, 0xd186b8c7
50010a90:	eb1e                	.insn	2, 0xeb1e
50010a92:	cde0                	sw	s0,92(a1)
50010a94:	7dd6                	.insn	2, 0x7dd6
50010a96:	eada                	.insn	2, 0xeada
50010a98:	d178                	sw	a4,100(a0)
50010a9a:	ee6e                	.insn	2, 0xee6e
50010a9c:	f57d4f7f          	.insn	4, 0xf57d4f7f
50010aa0:	6fba                	.insn	2, 0x6fba
50010aa2:	67aa7217          	auipc	tp,0x67aa7
50010aa6:	06f0                	add	a2,sp,844
50010aa8:	98a6                	add	a7,a7,s1
50010aaa:	a2c8                	.insn	2, 0xa2c8
50010aac:	7dc5                	lui	s11,0xffff1
50010aae:	0dae0a63          	beq	t3,s10,50010b82 <k+0x302>
50010ab2:	bef9                	j	50010690 <__func__.0+0x180>
50010ab4:	9804                	.insn	2, 0x9804
50010ab6:	471b113f 0b35131c 	.insn	8, 0x0b35131c471b113f
50010abe:	1b71                	add	s6,s6,-4
50010ac0:	7d84                	.insn	2, 0x7d84
50010ac2:	2304                	.insn	2, 0x2304
50010ac4:	77f5                	lui	a5,0xffffd
50010ac6:	249328db          	.insn	4, 0x249328db
50010aca:	ab7b40c7          	.insn	4, 0xab7b40c7
50010ace:	32ca                	.insn	2, 0x32ca
50010ad0:	bebc                	.insn	2, 0xbebc
50010ad2:	15c9                	add	a1,a1,-14 # 12ff2 <_bss_lma_end+0xdb66>
50010ad4:	be0a                	.insn	2, 0xbe0a
50010ad6:	3c9e                	.insn	2, 0x3c9e
50010ad8:	0d4c                	add	a1,sp,660
50010ada:	9c10                	.insn	2, 0x9c10
50010adc:	67c4                	.insn	2, 0x67c4
50010ade:	431d                	li	t1,7
50010ae0:	42b6                	lw	t0,76(sp)
50010ae2:	cb3e                	sw	a5,148(sp)
50010ae4:	d4be                	sw	a5,104(sp)
50010ae6:	4cc5                	li	s9,17
50010ae8:	7e2a                	.insn	2, 0x7e2a
50010aea:	fc65                	bnez	s0,50010ae2 <k+0x262>
50010aec:	299c                	.insn	2, 0x299c
50010aee:	faec597f          	.insn	4, 0xfaec597f
50010af2:	3ad6                	.insn	2, 0x3ad6
50010af4:	5fcb6fab          	.insn	4, 0x5fcb6fab
50010af8:	4a475817          	auipc	a6,0x4a475
50010afc:	198c                	add	a1,sp,240
50010afe:	6c44                	.insn	2, 0x6c44
50010b00:	35414853          	.insn	4, 0x35414853
50010b04:	3231                	jal	50010410 <__func__.1+0x1c0>
50010b06:	203a                	.insn	2, 0x203a
50010b08:	20746553          	.insn	4, 0x20746553
50010b0c:	6f6d                	lui	t5,0x1b
50010b0e:	6564                	.insn	2, 0x6564
50010b10:	203a                	.insn	2, 0x203a
50010b12:	7830                	.insn	2, 0x7830
50010b14:	7825                	lui	a6,0xfffe9
50010b16:	6120                	.insn	2, 0x6120
50010b18:	646e                	.insn	2, 0x646e
50010b1a:	6920                	.insn	2, 0x6920
50010b1c:	696e                	.insn	2, 0x696e
50010b1e:	0a74                	add	a3,sp,284
50010b20:	0000                	unimp
50010b22:	0000                	unimp
50010b24:	35414853          	.insn	4, 0x35414853
50010b28:	3231                	jal	50010434 <__func__.1+0x1e4>
50010b2a:	203a                	.insn	2, 0x203a
50010b2c:	20746553          	.insn	4, 0x20746553
50010b30:	6f6d                	lui	t5,0x1b
50010b32:	6564                	.insn	2, 0x6564
50010b34:	203a                	.insn	2, 0x203a
50010b36:	7830                	.insn	2, 0x7830
50010b38:	7825                	lui	a6,0xfffe9
50010b3a:	6120                	.insn	2, 0x6120
50010b3c:	646e                	.insn	2, 0x646e
50010b3e:	6e20                	.insn	2, 0x6e20
50010b40:	7865                	lui	a6,0xffff9
50010b42:	0a74                	add	a3,sp,284
50010b44:	0000                	unimp
50010b46:	0000                	unimp
50010b48:	35414853          	.insn	4, 0x35414853
50010b4c:	3231                	jal	50010458 <__func__.1+0x208>
50010b4e:	203a                	.insn	2, 0x203a
50010b50:	20746553          	.insn	4, 0x20746553
50010b54:	6f6d                	lui	t5,0x1b
50010b56:	6564                	.insn	2, 0x6564
50010b58:	203a                	.insn	2, 0x203a
50010b5a:	7830                	.insn	2, 0x7830
50010b5c:	7825                	lui	a6,0xfffe9
50010b5e:	6120                	.insn	2, 0x6120
50010b60:	646e                	.insn	2, 0x646e
50010b62:	6e20                	.insn	2, 0x6e20
50010b64:	7865                	lui	a6,0xffff9
50010b66:	2074                	.insn	2, 0x2074
50010b68:	68746977          	.insn	4, 0x68746977
50010b6c:	6c20                	.insn	2, 0x6c20
50010b6e:	7361                	lui	t1,0xffff8
50010b70:	0a74                	add	a3,sp,284
50010b72:	0000                	unimp
50010b74:	656d                	lui	a0,0x1b
50010b76:	7361                	lui	t1,0xffff8
50010b78:	7275                	lui	tp,0xffffd
50010b7a:	5365                	li	t1,-7
50010b7c:	6d20434f          	.insn	4, 0x6d20434f
50010b80:	6165                	add	sp,sp,112
50010b82:	65727573          	csrrc	a0,hviprio2h,4
50010b86:	7620                	.insn	2, 0x7620
50010b88:	6c61                	lui	s8,0x18
50010b8a:	6575                	lui	a0,0x1d
50010b8c:	003a                	c.slli	zero,0xe
50010b8e:	0000                	unimp
50010b90:	7830                	.insn	2, 0x7830
50010b92:	3025                	jal	500103ba <__func__.1+0x16a>
50010b94:	7838                	.insn	2, 0x7838
50010b96:	0020                	add	s0,sp,8
50010b98:	656d                	lui	a0,0x1b
50010b9a:	7361                	lui	t1,0xffff8
50010b9c:	7275                	lui	tp,0xffffd
50010b9e:	5365                	li	t1,-7
50010ba0:	6520434f          	.insn	4, 0x6520434f
50010ba4:	7078                	.insn	2, 0x7078
50010ba6:	6365                	lui	t1,0x19
50010ba8:	5f74                	lw	a3,124(a4)
50010baa:	6176                	.insn	2, 0x6176
50010bac:	756c                	.insn	2, 0x756c
50010bae:	3a65                	jal	50010566 <__func__.0+0x56>
50010bb0:	0000                	unimp
50010bb2:	0000                	unimp
50010bb4:	706d6f43          	.insn	4, 0x706d6f43
50010bb8:	7261                	lui	tp,0xffff8
50010bba:	6e69                	lui	t3,0x1a
50010bbc:	48532067          	.insn	4, 0x48532067
50010bc0:	3541                	jal	50010a40 <k+0x1c0>
50010bc2:	3231                	jal	500104ce <__func__.1+0x27e>
50010bc4:	6420                	.insn	2, 0x6420
50010bc6:	6769                	lui	a4,0x1a
50010bc8:	7365                	lui	t1,0xffff9
50010bca:	2e74                	.insn	2, 0x2e74
50010bcc:	2e2e                	.insn	2, 0x2e2e
50010bce:	0000                	unimp
50010bd0:	694d                	lui	s2,0x13
50010bd2:	74616d73          	csrrs	s10,0x746,2
50010bd6:	61206863          	bltu	zero,s2,500111e6 <__func__.2+0x566>
50010bda:	2074                	.insn	2, 0x2074
50010bdc:	64726f77          	.insn	4, 0x64726f77
50010be0:	2520                	.insn	2, 0x2520
50010be2:	3a64                	.insn	2, 0x3a64
50010be4:	4d20                	lw	s0,88(a0)
50010be6:	6165                	add	sp,sp,112
50010be8:	65727573          	csrrc	a0,hviprio2h,4
50010bec:	656d                	lui	a0,0x1b
50010bee:	746e                	.insn	2, 0x746e
50010bf0:	7620                	.insn	2, 0x7620
50010bf2:	6c61                	lui	s8,0x18
50010bf4:	6575                	lui	a0,0x1d
50010bf6:	3020                	.insn	2, 0x3020
50010bf8:	2578                	.insn	2, 0x2578
50010bfa:	3830                	.insn	2, 0x3830
50010bfc:	2c78                	.insn	2, 0x2c78
50010bfe:	4520                	lw	s0,72(a0)
50010c00:	7078                	.insn	2, 0x7078
50010c02:	6365                	lui	t1,0x19
50010c04:	6574                	.insn	2, 0x6574
50010c06:	2064                	.insn	2, 0x2064
50010c08:	7830                	.insn	2, 0x7830
50010c0a:	3025                	jal	50010432 <__func__.1+0x1e2>
50010c0c:	7838                	.insn	2, 0x7838
50010c0e:	000a                	c.slli	zero,0x2
50010c10:	654d                	lui	a0,0x13
50010c12:	7361                	lui	t1,0xffff8
50010c14:	7275                	lui	tp,0xffffd
50010c16:	6d65                	lui	s10,0x19
50010c18:	6e65                	lui	t3,0x19
50010c1a:	2074                	.insn	2, 0x2074
50010c1c:	63637573          	csrrc	a0,0x636,6
50010c20:	7365                	lui	t1,0xffff9
50010c22:	00002173          	csrr	sp,ustatus
50010c26:	0000                	unimp
50010c28:	654d                	lui	a0,0x13
50010c2a:	7361                	lui	t1,0xffff8
50010c2c:	7275                	lui	tp,0xffffd
50010c2e:	6d65                	lui	s10,0x19
50010c30:	6e65                	lui	t3,0x19
50010c32:	2074                	.insn	2, 0x2074
50010c34:	6166                	.insn	2, 0x6166
50010c36:	6c69                	lui	s8,0x1a
50010c38:	6465                	lui	s0,0x19
50010c3a:	0021                	c.nop	8
50010c3c:	656d                	lui	a0,0x1b
50010c3e:	7361                	lui	t1,0xffff8
50010c40:	7275                	lui	tp,0xffffd
50010c42:	4665                	li	a2,25
50010c44:	434d                	li	t1,19
50010c46:	6d20                	.insn	2, 0x6d20
50010c48:	6165                	add	sp,sp,112
50010c4a:	65727573          	csrrc	a0,hviprio2h,4
50010c4e:	7620                	.insn	2, 0x7620
50010c50:	6c61                	lui	s8,0x18
50010c52:	6575                	lui	a0,0x1d
50010c54:	003a                	c.slli	zero,0xe
50010c56:	0000                	unimp
50010c58:	656d                	lui	a0,0x1b
50010c5a:	7361                	lui	t1,0xffff8
50010c5c:	7275                	lui	tp,0xffffd
50010c5e:	4665                	li	a2,25
50010c60:	434d                	li	t1,19
50010c62:	6520                	.insn	2, 0x6520
50010c64:	7078                	.insn	2, 0x7078
50010c66:	6365                	lui	t1,0x19
50010c68:	5f74                	lw	a3,124(a4)
50010c6a:	6176                	.insn	2, 0x6176
50010c6c:	756c                	.insn	2, 0x756c
50010c6e:	3a65                	jal	50010626 <__func__.0+0x116>
50010c70:	0000                	unimp
	...

50010c74 <__func__.0>:
50010c74:	656d                	lui	a0,0x1b
50010c76:	7361                	lui	t1,0xffff8
50010c78:	7275                	lui	tp,0xffffd
50010c7a:	5f65                	li	t5,-7
50010c7c:	6d66                	.insn	2, 0x6d66
50010c7e:	          	beq	s10,s6,500112be <__func__.2+0x63e>

50010c80 <__func__.2>:
50010c80:	656d                	lui	a0,0x1b
50010c82:	7361                	lui	t1,0xffff8
50010c84:	7275                	lui	tp,0xffffd
50010c86:	5f65                	li	t5,-7
50010c88:	00636f73          	csrrs	t5,0x6,6
50010c8c:	5f434f53          	.insn	4, 0x5f434f53
50010c90:	4649                	li	a2,18
50010c92:	53203a43          	.insn	4, 0x53203a43
50010c96:	7465                	lui	s0,0xffff9
50010c98:	6620                	.insn	2, 0x6620
50010c9a:	6f6c                	.insn	2, 0x6f6c
50010c9c:	74735f77          	.insn	4, 0x74735f77
50010ca0:	7461                	lui	s0,0xffff8
50010ca2:	7375                	lui	t1,0xffffd
50010ca4:	6620                	.insn	2, 0x6620
50010ca6:	6569                	lui	a0,0x1a
50010ca8:	646c                	.insn	2, 0x646c
50010caa:	203a                	.insn	2, 0x203a
50010cac:	7830                	.insn	2, 0x7830
50010cae:	3025                	jal	500104d6 <__func__.1+0x286>
50010cb0:	7838                	.insn	2, 0x7838
50010cb2:	000a                	c.slli	zero,0x2
50010cb4:	6e49                	lui	t3,0x12
50010cb6:	6176                	.insn	2, 0x6176
50010cb8:	696c                	.insn	2, 0x696c
50010cba:	2064                	.insn	2, 0x2064
50010cbc:	6170                	.insn	2, 0x6170
50010cbe:	6172                	.insn	2, 0x6172
50010cc0:	656d                	lui	a0,0x1b
50010cc2:	6574                	.insn	2, 0x6574
50010cc4:	7372                	.insn	2, 0x7372
50010cc6:	0000                	unimp
50010cc8:	0a30                	add	a2,sp,280
50010cca:	0806                	sll	a6,a6,0x1
50010ccc:	862a                	mv	a2,a0
50010cce:	ce48                	sw	a0,28(a2)
50010cd0:	043d                	add	s0,s0,15 # ffff800f <_tbs_der_store_end+0xaffd8fef>
50010cd2:	00000303          	lb	t1,0(zero) # 0 <_start>
50010cd6:	0000                	unimp
50010cd8:	2230                	.insn	2, 0x2230
50010cda:	0f18                	add	a4,sp,912
50010cdc:	3032                	.insn	2, 0x3032
50010cde:	3532                	.insn	2, 0x3532
50010ce0:	3130                	.insn	2, 0x3130
50010ce2:	3130                	.insn	2, 0x3130
50010ce4:	3030                	.insn	2, 0x3030
50010ce6:	3030                	.insn	2, 0x3030
50010ce8:	3030                	.insn	2, 0x3030
50010cea:	185a                	sll	a6,a6,0x36
50010cec:	3230320f          	.insn	4, 0x3230320f
50010cf0:	30313037          	lui	zero,0x30313
50010cf4:	3031                	jal	50010500 <__func__.1+0x2b0>
50010cf6:	3030                	.insn	2, 0x3030
50010cf8:	3030                	.insn	2, 0x3030
50010cfa:	5a30                	lw	a2,112(a2)
50010cfc:	0000                	unimp
50010cfe:	0000                	unimp
50010d00:	862a                	mv	a2,a0
50010d02:	ce48                	sw	a0,28(a2)
50010d04:	023d                	add	tp,tp,15 # ffffd00f <_tbs_der_store_end+0xaffddfef>
50010d06:	0001                	nop
50010d08:	0030                	add	a2,sp,8
50010d0a:	0000                	unimp
50010d0c:	646c                	.insn	2, 0x646c
50010d0e:	7665                	lui	a2,0xffff9
50010d10:	6469                	lui	s0,0x1a
50010d12:	635f 6964 0000      	.insn	6, 0x6964635f
50010d18:	20494443          	.insn	4, 0x20494443
50010d1c:	6964                	.insn	2, 0x6964
50010d1e:	6576                	.insn	2, 0x6576
50010d20:	7372                	.insn	2, 0x7372
50010d22:	6669                	lui	a2,0x1a
50010d24:	6569                	lui	a0,0x1a
50010d26:	2064                	.insn	2, 0x2064
50010d28:	68746977          	.insn	4, 0x68746977
50010d2c:	6c20                	.insn	2, 0x6c20
50010d2e:	6261                	lui	tp,0x18
50010d30:	6c65                	lui	s8,0x19
50010d32:	2720                	.insn	2, 0x2720
50010d34:	646c                	.insn	2, 0x646c
50010d36:	7665                	lui	a2,0xffff9
50010d38:	6469                	lui	s0,0x1a
50010d3a:	635f 6964 2e27      	.insn	6, 0x2e276964635f
50010d40:	0000                	unimp
50010d42:	0000                	unimp
50010d44:	20494443          	.insn	4, 0x20494443
50010d48:	6964                	.insn	2, 0x6964
50010d4a:	6576                	.insn	2, 0x6576
50010d4c:	7372                	.insn	2, 0x7372
50010d4e:	6669                	lui	a2,0x1a
50010d50:	6569                	lui	a0,0x1a
50010d52:	2064                	.insn	2, 0x2064
50010d54:	68746977          	.insn	4, 0x68746977
50010d58:	4620                	lw	s0,72(a2)
50010d5a:	6569                	lui	a0,0x1a
50010d5c:	646c                	.insn	2, 0x646c
50010d5e:	4520                	lw	s0,72(a0)
50010d60:	746e                	.insn	2, 0x746e
50010d62:	6f72                	.insn	2, 0x6f72
50010d64:	7970                	.insn	2, 0x7970
50010d66:	6620                	.insn	2, 0x6620
50010d68:	6f72                	.insn	2, 0x6f72
50010d6a:	206d                	jal	50010e14 <__func__.2+0x194>
50010d6c:	746f6c53          	.insn	4, 0x746f6c53
50010d70:	2e31                	jal	5001108c <__func__.2+0x40c>
50010d72:	0000                	unimp
50010d74:	444c                	lw	a1,12(s0)
50010d76:	7665                	lui	a2,0xffff9
50010d78:	4449                	li	s0,18
50010d7a:	432e                	lw	t1,200(sp)
50010d7c:	4944                	lw	s1,20(a0)
50010d7e:	6420                	.insn	2, 0x6420
50010d80:	7265                	lui	tp,0xffff9
50010d82:	7669                	lui	a2,0xffffa
50010d84:	6465                	lui	s0,0x19
50010d86:	6120                	.insn	2, 0x6120
50010d88:	646e                	.insn	2, 0x646e
50010d8a:	7320                	.insn	2, 0x7320
50010d8c:	6f74                	.insn	2, 0x6f74
50010d8e:	6572                	.insn	2, 0x6572
50010d90:	2064                	.insn	2, 0x2064
50010d92:	6e69                	lui	t3,0x1a
50010d94:	4b20                	lw	s0,80(a4)
50010d96:	7965                	lui	s2,0xffff9
50010d98:	746f6c53          	.insn	4, 0x746f6c53
50010d9c:	2e36                	.insn	2, 0x2e36
50010d9e:	0000                	unimp
50010da0:	6946                	.insn	2, 0x6946
50010da2:	6c65                	lui	s8,0x19
50010da4:	2064                	.insn	2, 0x2064
50010da6:	6e45                	lui	t3,0x11
50010da8:	7274                	.insn	2, 0x7274
50010daa:	2079706f          	j	500a87b0 <_tbs_der_store_end+0x89790>
50010dae:	61656c63          	bltu	a0,s6,500113c6 <SOC_FW_data+0xd6>
50010db2:	6572                	.insn	2, 0x6572
50010db4:	2064                	.insn	2, 0x2064
50010db6:	6e69                	lui	t3,0x1a
50010db8:	4b20                	lw	s0,80(a4)
50010dba:	7965                	lui	s2,0xffff9
50010dbc:	746f6c53          	.insn	4, 0x746f6c53
50010dc0:	2e31                	jal	500110dc <__func__.2+0x45c>
50010dc2:	0000                	unimp
50010dc4:	646c                	.insn	2, 0x646c
50010dc6:	7665                	lui	a2,0xffff9
50010dc8:	6469                	lui	s0,0x1a
50010dca:	6b5f 7965 6567      	.insn	6, 0x656779656b5f
50010dd0:	006e                	c.slli	zero,0x1b
50010dd2:	0000                	unimp
50010dd4:	4345                	li	t1,17
50010dd6:	65732043          	.insn	4, 0x65732043
50010dda:	6465                	lui	s0,0x19
50010ddc:	6420                	.insn	2, 0x6420
50010dde:	7265                	lui	tp,0xffff9
50010de0:	7669                	lui	a2,0xffffa
50010de2:	6465                	lui	s0,0x19
50010de4:	6120                	.insn	2, 0x6120
50010de6:	646e                	.insn	2, 0x646e
50010de8:	7320                	.insn	2, 0x7320
50010dea:	6f74                	.insn	2, 0x6f74
50010dec:	6572                	.insn	2, 0x6572
50010dee:	2064                	.insn	2, 0x2064
50010df0:	6e69                	lui	t3,0x1a
50010df2:	4b20                	lw	s0,80(a4)
50010df4:	7965                	lui	s2,0xffff9
50010df6:	746f6c53          	.insn	4, 0x746f6c53
50010dfa:	00002e33          	sltz	t3,zero
50010dfe:	0000                	unimp
50010e00:	4345                	li	t1,17
50010e02:	656b2043          	.insn	4, 0x656b2043
50010e06:	2079                	jal	50010e94 <__func__.2+0x214>
50010e08:	6170                	.insn	2, 0x6170
50010e0a:	7269                	lui	tp,0xffffa
50010e0c:	6720                	.insn	2, 0x6720
50010e0e:	6e65                	lui	t3,0x19
50010e10:	7265                	lui	tp,0xffff9
50010e12:	7461                	lui	s0,0xffff8
50010e14:	6465                	lui	s0,0x19
50010e16:	203a                	.insn	2, 0x203a
50010e18:	7250                	.insn	2, 0x7250
50010e1a:	7669                	lui	a2,0xffffa
50010e1c:	7461                	lui	s0,0xffff8
50010e1e:	2065                	jal	50010ec6 <__func__.2+0x246>
50010e20:	6e69                	lui	t3,0x1a
50010e22:	5320                	lw	s0,96(a4)
50010e24:	6f6c                	.insn	2, 0x6f6c
50010e26:	3574                	.insn	2, 0x3574
50010e28:	202c                	.insn	2, 0x202c
50010e2a:	7550                	.insn	2, 0x7550
50010e2c:	6c62                	.insn	2, 0x6c62
50010e2e:	6369                	lui	t1,0x1a
50010e30:	7220                	.insn	2, 0x7220
50010e32:	7465                	lui	s0,0xffff9
50010e34:	7275                	lui	tp,0xffffd
50010e36:	656e                	.insn	2, 0x656e
50010e38:	2e64                	.insn	2, 0x2e64
50010e3a:	0000                	unimp
50010e3c:	6554                	.insn	2, 0x6554
50010e3e:	706d                	c.lui	zero,0xffffb
50010e40:	7261726f          	jal	tp,50028566 <_tbs_der_store_end+0x9546>
50010e44:	2079                	jal	50010ed2 <__func__.2+0x252>
50010e46:	64656573          	csrrs	a0,hviprio1,10
50010e4a:	6320                	.insn	2, 0x6320
50010e4c:	656c                	.insn	2, 0x656c
50010e4e:	7261                	lui	tp,0xffff8
50010e50:	6465                	lui	s0,0x19
50010e52:	6920                	.insn	2, 0x6920
50010e54:	206e                	.insn	2, 0x206e
50010e56:	5379654b          	.insn	4, 0x5379654b
50010e5a:	6f6c                	.insn	2, 0x6f6c
50010e5c:	3374                	.insn	2, 0x3374
50010e5e:	002e                	c.slli	zero,0xb
50010e60:	696c6143          	.insn	4, 0x696c6143
50010e64:	7470                	.insn	2, 0x7470
50010e66:	6172                	.insn	2, 0x6172
50010e68:	3120                	.insn	2, 0x3120
50010e6a:	302e                	.insn	2, 0x302e
50010e6c:	4c20                	lw	s0,88(s0)
50010e6e:	6544                	.insn	2, 0x6544
50010e70:	4976                	lw	s2,92(sp)
50010e72:	0044                	add	s1,sp,4
50010e74:	696c6143          	.insn	4, 0x696c6143
50010e78:	7470                	.insn	2, 0x7470
50010e7a:	6172                	.insn	2, 0x6172
50010e7c:	3120                	.insn	2, 0x3120
50010e7e:	302e                	.insn	2, 0x302e
50010e80:	4920                	lw	s0,80(a0)
50010e82:	6544                	.insn	2, 0x6544
50010e84:	4976                	lw	s2,92(sp)
50010e86:	0044                	add	s1,sp,4
50010e88:	74726563          	bltu	tp,t2,500115d2 <SOC_FW_data+0x2e2>
50010e8c:	6c5f 6e65 3d20      	.insn	6, 0x3d206e656c5f
50010e92:	3020                	.insn	2, 0x3020
50010e94:	2578                	.insn	2, 0x2578
50010e96:	0a78                	add	a4,sp,284
50010e98:	0000                	unimp
50010e9a:	0000                	unimp
50010e9c:	644c                	.insn	2, 0x644c
50010e9e:	5665                	li	a2,-7
50010ea0:	4449                	li	s0,18
50010ea2:	7420                	.insn	2, 0x7420
50010ea4:	7362                	.insn	2, 0x7362
50010ea6:	6420                	.insn	2, 0x6420
50010ea8:	7265                	lui	tp,0xffff9
50010eaa:	003a                	c.slli	zero,0xe
50010eac:	7325                	lui	t1,0xfffe9
50010eae:	5825                	li	a6,-23
50010eb0:	0000                	unimp
50010eb2:	0000                	unimp
50010eb4:	656e6567          	.insn	4, 0x656e6567
50010eb8:	6172                	.insn	2, 0x6172
50010eba:	6574                	.insn	2, 0x6574
50010ebc:	4c20                	lw	s0,88(s0)
50010ebe:	6564                	.insn	2, 0x6564
50010ec0:	4956                	lw	s2,84(sp)
50010ec2:	2044                	.insn	2, 0x2044
50010ec4:	74726563          	bltu	tp,t2,5001160e <SOC_FW_data+0x31e>
50010ec8:	6420                	.insn	2, 0x6420
50010eca:	7265                	lui	tp,0xffff9
50010ecc:	6620                	.insn	2, 0x6620
50010ece:	6961                	lui	s2,0x18
50010ed0:	646c                	.insn	2, 0x646c
50010ed2:	0021                	c.nop	8
50010ed4:	6564                	.insn	2, 0x6564
50010ed6:	5f72                	lw	t5,60(sp)
50010ed8:	2e727363          	bgeu	tp,t2,500111be <__func__.2+0x53e>
50010edc:	6964                	.insn	2, 0x6964
50010ede:	74736567          	.insn	4, 0x74736567
50010ee2:	003a                	c.slli	zero,0xe
50010ee4:	6e676953          	.insn	4, 0x6e676953
50010ee8:	7461                	lui	s0,0xffff8
50010eea:	7275                	lui	tp,0xffffd
50010eec:	2065                	jal	50010f94 <__func__.2+0x314>
50010eee:	3a52                	.insn	2, 0x3a52
50010ef0:	0000                	unimp
50010ef2:	0000                	unimp
50010ef4:	3025                	jal	5001071c <__func__.0+0x20c>
50010ef6:	7838                	.insn	2, 0x7838
50010ef8:	0020                	add	s0,sp,8
50010efa:	0000                	unimp
50010efc:	530a                	lw	t1,160(sp)
50010efe:	6769                	lui	a4,0x1a
50010f00:	616e                	.insn	2, 0x616e
50010f02:	7574                	.insn	2, 0x7574
50010f04:	6572                	.insn	2, 0x6572
50010f06:	5320                	lw	s0,96(a4)
50010f08:	003a                	c.slli	zero,0xe
50010f0a:	0000                	unimp
50010f0c:	6554                	.insn	2, 0x6554
50010f0e:	706d                	c.lui	zero,0xffffb
50010f10:	7261726f          	jal	tp,50028636 <_tbs_der_store_end+0x9616>
50010f14:	2079                	jal	50010fa2 <__func__.2+0x322>
50010f16:	64656573          	csrrs	a0,hviprio1,10
50010f1a:	6320                	.insn	2, 0x6320
50010f1c:	656c                	.insn	2, 0x656c
50010f1e:	7261                	lui	tp,0xffff8
50010f20:	6465                	lui	s0,0x19
50010f22:	6920                	.insn	2, 0x6920
50010f24:	206e                	.insn	2, 0x206e
50010f26:	5379654b          	.insn	4, 0x5379654b
50010f2a:	6f6c                	.insn	2, 0x6f6c
50010f2c:	3774                	.insn	2, 0x3774
50010f2e:	002e                	c.slli	zero,0xb
50010f30:	6469                	lui	s0,0x1a
50010f32:	7665                	lui	a2,0xffff9
50010f34:	6469                	lui	s0,0x1a
50010f36:	705f 6275 656b      	.insn	6, 0x656b6275705f
50010f3c:	5f79                	li	t5,-2
50010f3e:	2e78                	.insn	2, 0x2e78
50010f40:	6164                	.insn	2, 0x6164
50010f42:	6174                	.insn	2, 0x6174
50010f44:	003a                	c.slli	zero,0xe
50010f46:	0000                	unimp
50010f48:	6469                	lui	s0,0x1a
50010f4a:	7665                	lui	a2,0xffff9
50010f4c:	6469                	lui	s0,0x1a
50010f4e:	705f 6275 656b      	.insn	6, 0x656b6275705f
50010f54:	5f79                	li	t5,-2
50010f56:	2e79                	jal	500112f4 <SOC_FW_data+0x4>
50010f58:	6164                	.insn	2, 0x6164
50010f5a:	6174                	.insn	2, 0x6174
50010f5c:	003a                	c.slli	zero,0xe
50010f5e:	0000                	unimp
50010f60:	6e676953          	.insn	4, 0x6e676953
50010f64:	7461                	lui	s0,0xffff8
50010f66:	7275                	lui	tp,0xffffd
50010f68:	2065                	jal	50011010 <__func__.2+0x390>
50010f6a:	6576                	.insn	2, 0x6576
50010f6c:	6972                	.insn	2, 0x6972
50010f6e:	6966                	.insn	2, 0x6966
50010f70:	69746163          	bltu	s0,s7,500115f2 <SOC_FW_data+0x302>
50010f74:	73206e6f          	jal	t3,500176a6 <FMC_data+0x3db6>
50010f78:	6375                	lui	t1,0x1d
50010f7a:	73736563          	bltu	t1,s7,500116a4 <SOC_FW_data+0x3b4>
50010f7e:	7566                	.insn	2, 0x7566
50010f80:	216c                	.insn	2, 0x216c
50010f82:	0000                	unimp
50010f84:	6e676953          	.insn	4, 0x6e676953
50010f88:	7461                	lui	s0,0xffff8
50010f8a:	7275                	lui	tp,0xffffd
50010f8c:	2065                	jal	50011034 <__func__.2+0x3b4>
50010f8e:	6576                	.insn	2, 0x6576
50010f90:	6972                	.insn	2, 0x6972
50010f92:	6966                	.insn	2, 0x6966
50010f94:	69746163          	bltu	s0,s7,50011616 <SOC_FW_data+0x326>
50010f98:	66206e6f          	jal	t3,500175fa <FMC_data+0x3d0a>
50010f9c:	6961                	lui	s2,0x18
50010f9e:	656c                	.insn	2, 0x656c
50010fa0:	2164                	.insn	2, 0x2164
50010fa2:	0000                	unimp
50010fa4:	644c                	.insn	2, 0x644c
50010fa6:	5665                	li	a2,-7
50010fa8:	4449                	li	s0,18
50010faa:	6320                	.insn	2, 0x6320
50010fac:	7265                	lui	tp,0xffff9
50010fae:	3a74                	.insn	2, 0x3a74
50010fb0:	0000                	unimp
50010fb2:	0000                	unimp
50010fb4:	6469                	lui	s0,0x1a
50010fb6:	7665                	lui	a2,0xffff9
50010fb8:	6469                	lui	s0,0x1a
50010fba:	635f 6964 0000      	.insn	6, 0x6964635f
50010fc0:	6c62                	.insn	2, 0x6c62
50010fc2:	5f6b636f          	jal	t1,500c75b8 <_tbs_der_store_end+0xa8598>
50010fc6:	2e696463          	bltu	s2,t1,500112ae <__func__.2+0x62e>
50010fca:	6164                	.insn	2, 0x6164
50010fcc:	6174                	.insn	2, 0x6174
50010fce:	003a                	c.slli	zero,0xe
50010fd0:	4449                	li	s0,18
50010fd2:	7665                	lui	a2,0xffff9
50010fd4:	4449                	li	s0,18
50010fd6:	432e                	lw	t1,200(sp)
50010fd8:	4944                	lw	s1,20(a0)
50010fda:	6420                	.insn	2, 0x6420
50010fdc:	7265                	lui	tp,0xffff9
50010fde:	7669                	lui	a2,0xffffa
50010fe0:	6465                	lui	s0,0x19
50010fe2:	6120                	.insn	2, 0x6120
50010fe4:	646e                	.insn	2, 0x646e
50010fe6:	7320                	.insn	2, 0x7320
50010fe8:	6f74                	.insn	2, 0x6f74
50010fea:	6572                	.insn	2, 0x6572
50010fec:	2064                	.insn	2, 0x2064
50010fee:	6e69                	lui	t3,0x1a
50010ff0:	4b20                	lw	s0,80(a4)
50010ff2:	7965                	lui	s2,0xffff9
50010ff4:	746f6c53          	.insn	4, 0x746f6c53
50010ff8:	2e36                	.insn	2, 0x2e36
50010ffa:	0000                	unimp
50010ffc:	4455                	li	s0,21
50010ffe:	6c632053          	.insn	4, 0x6c632053
50011002:	6165                	add	sp,sp,112
50011004:	6572                	.insn	2, 0x6572
50011006:	2064                	.insn	2, 0x2064
50011008:	6e69                	lui	t3,0x1a
5001100a:	4b20                	lw	s0,80(a4)
5001100c:	7965                	lui	s2,0xffff9
5001100e:	746f6c53          	.insn	4, 0x746f6c53
50011012:	2e30                	.insn	2, 0x2e30
50011014:	0000                	unimp
50011016:	0000                	unimp
50011018:	6469                	lui	s0,0x1a
5001101a:	7665                	lui	a2,0xffff9
5001101c:	6469                	lui	s0,0x1a
5001101e:	6b5f 7965 6567      	.insn	6, 0x656779656b5f
50011024:	006e                	c.slli	zero,0x1b
50011026:	0000                	unimp
50011028:	6c62                	.insn	2, 0x6c62
5001102a:	5f6b636f          	jal	t1,500c7620 <_tbs_der_store_end+0xa8600>
5001102e:	64656573          	csrrs	a0,hviprio1,10
50011032:	642e                	.insn	2, 0x642e
50011034:	7461                	lui	s0,0xffff8
50011036:	3a61                	jal	500109ce <k+0x14e>
50011038:	0000                	unimp
5001103a:	0000                	unimp
5001103c:	4345                	li	t1,17
5001103e:	656b2043          	.insn	4, 0x656b2043
50011042:	2079                	jal	500110d0 <__func__.2+0x450>
50011044:	6170                	.insn	2, 0x6170
50011046:	7269                	lui	tp,0xffffa
50011048:	6720                	.insn	2, 0x6720
5001104a:	6e65                	lui	t3,0x19
5001104c:	7265                	lui	tp,0xffff9
5001104e:	7461                	lui	s0,0xffff8
50011050:	6465                	lui	s0,0x19
50011052:	203a                	.insn	2, 0x203a
50011054:	7250                	.insn	2, 0x7250
50011056:	7669                	lui	a2,0xffffa
50011058:	7461                	lui	s0,0xffff8
5001105a:	2065                	jal	50011102 <__func__.2+0x482>
5001105c:	6e69                	lui	t3,0x1a
5001105e:	5320                	lw	s0,96(a4)
50011060:	6f6c                	.insn	2, 0x6f6c
50011062:	3774                	.insn	2, 0x3774
50011064:	202c                	.insn	2, 0x202c
50011066:	7550                	.insn	2, 0x7550
50011068:	6c62                	.insn	2, 0x6c62
5001106a:	6369                	lui	t1,0x1a
5001106c:	7220                	.insn	2, 0x7220
5001106e:	7465                	lui	s0,0xffff9
50011070:	7275                	lui	tp,0xffffd
50011072:	656e                	.insn	2, 0x656e
50011074:	2e64                	.insn	2, 0x2e64
50011076:	0000                	unimp
50011078:	7570                	.insn	2, 0x7570
5001107a:	6b62                	.insn	2, 0x6b62
5001107c:	7965                	lui	s2,0xffff9
5001107e:	785f 642e 7461      	.insn	6, 0x7461642e785f
50011084:	3a61                	jal	50010a1c <k+0x19c>
50011086:	0000                	unimp
50011088:	7570                	.insn	2, 0x7570
5001108a:	6b62                	.insn	2, 0x6b62
5001108c:	7965                	lui	s2,0xffff9
5001108e:	795f 642e 7461      	.insn	6, 0x7461642e795f
50011094:	3a61                	jal	50010a2c <k+0x1ac>
50011096:	0000                	unimp
50011098:	6449                	lui	s0,0x12
5001109a:	5665                	li	a2,-7
5001109c:	4449                	li	s0,18
5001109e:	7420                	.insn	2, 0x7420
500110a0:	7362                	.insn	2, 0x7362
500110a2:	6420                	.insn	2, 0x6420
500110a4:	7265                	lui	tp,0xffff9
500110a6:	003a                	c.slli	zero,0xe
500110a8:	656e6567          	.insn	4, 0x656e6567
500110ac:	6172                	.insn	2, 0x6172
500110ae:	6574                	.insn	2, 0x6574
500110b0:	4920                	lw	s0,80(a0)
500110b2:	6564                	.insn	2, 0x6564
500110b4:	4956                	lw	s2,84(sp)
500110b6:	2044                	.insn	2, 0x2044
500110b8:	74726563          	bltu	tp,t2,50011802 <SOC_FW_data+0x512>
500110bc:	6420                	.insn	2, 0x6420
500110be:	7265                	lui	tp,0xffff9
500110c0:	6620                	.insn	2, 0x6620
500110c2:	6961                	lui	s2,0x18
500110c4:	646c                	.insn	2, 0x646c
500110c6:	0021                	c.nop	8
500110c8:	646e6553          	.insn	4, 0x646e6553
500110cc:	6920                	.insn	2, 0x6920
500110ce:	6564                	.insn	2, 0x6564
500110d0:	6976                	.insn	2, 0x6976
500110d2:	2064                	.insn	2, 0x2064
500110d4:	20525343          	.insn	4, 0x20525343
500110d8:	6d6d6f63          	bltu	s10,s6,500117b6 <SOC_FW_data+0x4c6>
500110dc:	6e61                	lui	t3,0x18
500110de:	0064                	add	s1,sp,12
500110e0:	6164                	.insn	2, 0x6164
500110e2:	6174                	.insn	2, 0x6174
500110e4:	3a74756f          	jal	a0,50058c8a <_tbs_der_store_end+0x39c6a>
500110e8:	3020                	.insn	2, 0x3020
500110ea:	2578                	.insn	2, 0x2578
500110ec:	3830                	.insn	2, 0x3830
500110ee:	2c78                	.insn	2, 0x2c78
500110f0:	6f20                	.insn	2, 0x6f20
500110f2:	6666                	.insn	2, 0x6666
500110f4:	3a746573          	csrrs	a0,0x3a7,8
500110f8:	2520                	.insn	2, 0x2520
500110fa:	0a64                	add	s1,sp,284
500110fc:	0000                	unimp
500110fe:	0000                	unimp
50011100:	6449                	lui	s0,0x12
50011102:	5665                	li	a2,-7
50011104:	4449                	li	s0,18
50011106:	6320                	.insn	2, 0x6320
50011108:	7265                	lui	tp,0xffff9
5001110a:	3a74                	.insn	2, 0x3a74
5001110c:	0000                	unimp
5001110e:	0000                	unimp
50011110:	2d2d                	jal	5001174a <SOC_FW_data+0x45a>
50011112:	2d2d                	jal	5001174c <SOC_FW_data+0x45c>
50011114:	2d2d                	jal	5001174e <SOC_FW_data+0x45e>
50011116:	2d2d                	jal	50011750 <SOC_FW_data+0x460>
50011118:	2d2d                	jal	50011752 <SOC_FW_data+0x462>
5001111a:	2d2d                	jal	50011754 <SOC_FW_data+0x464>
5001111c:	2d2d                	jal	50011756 <SOC_FW_data+0x466>
5001111e:	2d2d                	jal	50011758 <SOC_FW_data+0x468>
50011120:	2d2d                	jal	5001175a <SOC_FW_data+0x46a>
50011122:	2d2d                	jal	5001175c <SOC_FW_data+0x46c>
50011124:	2d2d                	jal	5001175e <SOC_FW_data+0x46e>
50011126:	2d2d                	jal	50011760 <SOC_FW_data+0x470>
50011128:	2d2d                	jal	50011762 <SOC_FW_data+0x472>
5001112a:	2d2d                	jal	50011764 <SOC_FW_data+0x474>
5001112c:	2d2d                	jal	50011766 <SOC_FW_data+0x476>
5001112e:	2d2d                	jal	50011768 <SOC_FW_data+0x478>
50011130:	2d2d                	jal	5001176a <SOC_FW_data+0x47a>
50011132:	2d2d                	jal	5001176c <SOC_FW_data+0x47c>
50011134:	0000                	unimp
50011136:	0000                	unimp
50011138:	2020                	.insn	2, 0x2020
5001113a:	2020                	.insn	2, 0x2020
5001113c:	2020                	.insn	2, 0x2020
5001113e:	2020                	.insn	2, 0x2020
50011140:	2020                	.insn	2, 0x2020
50011142:	2020                	.insn	2, 0x2020
50011144:	696c6143          	.insn	4, 0x696c6143
50011148:	7470                	.insn	2, 0x7470
5001114a:	6172                	.insn	2, 0x6172
5001114c:	5220                	lw	s0,96(a2)
5001114e:	2e2e4d4f          	.insn	4, 0x2e2e4d4f
50011152:	202e                	.insn	2, 0x202e
50011154:	2020                	.insn	2, 0x2020
50011156:	2020                	.insn	2, 0x2020
50011158:	2020                	.insn	2, 0x2020
5001115a:	2020                	.insn	2, 0x2020
5001115c:	0000                	unimp
5001115e:	0000                	unimp
50011160:	3930                	.insn	2, 0x3930
50011162:	323a                	.insn	2, 0x323a
50011164:	3a32                	.insn	2, 0x3a32
50011166:	00003933          	snez	s2,zero
5001116a:	0000                	unimp
5001116c:	754a                	.insn	2, 0x754a
5001116e:	206c                	.insn	2, 0x206c
50011170:	3920                	.insn	2, 0x3920
50011172:	3220                	.insn	2, 0x3220
50011174:	3230                	.insn	2, 0x3230
50011176:	0036                	c.slli	zero,0xd
50011178:	706d6f43          	.insn	4, 0x706d6f43
5001117c:	6c69                	lui	s8,0x1a
5001117e:	6465                	lui	s0,0x19
50011180:	6f20                	.insn	2, 0x6f20
50011182:	3a6e                	.insn	2, 0x3a6e
50011184:	2520                	.insn	2, 0x2520
50011186:	74612073          	csrs	0x746,sp
5001118a:	2520                	.insn	2, 0x2520
5001118c:	00000a73          	.insn	4, 0x0a73
50011190:	4d46                	lw	s10,80(sp)
50011192:	656d2043          	.insn	4, 0x656d2043
50011196:	7361                	lui	t1,0xffff8
50011198:	7275                	lui	tp,0xffffd
5001119a:	2065                	jal	50011242 <__func__.2+0x5c2>
5001119c:	6176                	.insn	2, 0x6176
5001119e:	756c                	.insn	2, 0x756c
500111a0:	3a65                	jal	50010b58 <k+0x2d8>
500111a2:	0000                	unimp
500111a4:	3025                	jal	500109cc <k+0x14c>
500111a6:	7838                	.insn	2, 0x7838
500111a8:	0000                	unimp
500111aa:	0000                	unimp
500111ac:	20434f53          	.insn	4, 0x20434f53
500111b0:	656d                	lui	a0,0x1b
500111b2:	7361                	lui	t1,0xffff8
500111b4:	7275                	lui	tp,0xffffd
500111b6:	2065                	jal	5001125e <__func__.2+0x5de>
500111b8:	6176                	.insn	2, 0x6176
500111ba:	756c                	.insn	2, 0x756c
500111bc:	3a65                	jal	50010b74 <k+0x2f4>
500111be:	0000                	unimp
500111c0:	4f52                	lw	t5,20(sp)
500111c2:	204d                	jal	50011264 <__func__.2+0x5e4>
500111c4:	656d                	lui	a0,0x1b
500111c6:	7361                	lui	t1,0xffff8
500111c8:	7275                	lui	tp,0xffffd
500111ca:	2065                	jal	50011272 <__func__.2+0x5f2>
500111cc:	6176                	.insn	2, 0x6176
500111ce:	756c                	.insn	2, 0x756c
500111d0:	3a65                	jal	50010b88 <k+0x308>
500111d2:	0000                	unimp
500111d4:	6174624f          	.insn	4, 0x6174624f
500111d8:	6e69                	lui	t3,0x1a
500111da:	6720                	.insn	2, 0x6720
500111dc:	7465                	lui	s0,0xffff9
500111de:	5220                	lw	s0,96(a2)
500111e0:	76204d4f          	.insn	4, 0x76204d4f
500111e4:	6c61                	lui	s8,0x18
500111e6:	6575                	lui	a0,0x1d
500111e8:	6320                	.insn	2, 0x6320
500111ea:	616d6d6f          	jal	s10,500e7800 <_tbs_der_store_end+0xc87e0>
500111ee:	646e                	.insn	2, 0x646e
500111f0:	0000                	unimp
500111f2:	0000                	unimp
500111f4:	6854                	.insn	2, 0x6854
500111f6:	2065                	jal	5001129e <__func__.2+0x61e>
500111f8:	656d                	lui	a0,0x1b
500111fa:	7361                	lui	t1,0xffff8
500111fc:	7275                	lui	tp,0xffffd
500111fe:	6d65                	lui	s10,0x19
50011200:	6e65                	lui	t3,0x19
50011202:	2074                	.insn	2, 0x2074
50011204:	6168                	.insn	2, 0x6168
50011206:	61702073          	csrr	zero,0x617
5001120a:	64657373          	csrrc	t1,hviprio1,10
5001120e:	202c                	.insn	2, 0x202c
50011210:	72617473          	csrrc	s0,mhpmevent6h,2
50011214:	6974                	.insn	2, 0x6974
50011216:	676e                	.insn	2, 0x676e
50011218:	0000                	unimp
5001121a:	0000                	unimp
5001121c:	4d46                	lw	s10,80(sp)
5001121e:	69662043          	.insn	4, 0x69662043
50011222:	6d72                	.insn	2, 0x6d72
50011224:	72696177          	.insn	4, 0x72696177
50011228:	3a65                	jal	50010be0 <k+0x360>
5001122a:	0000                	unimp
5001122c:	6425                	lui	s0,0x9
5001122e:	0a3a                	sll	s4,s4,0xe
50011230:	0000                	unimp
50011232:	0000                	unimp
50011234:	7830                	.insn	2, 0x7830
50011236:	3025                	jal	50010a5e <k+0x1de>
50011238:	7832                	.insn	2, 0x7832
5001123a:	0020                	add	s0,sp,8
5001123c:	654d                	lui	a0,0x13
5001123e:	7361                	lui	t1,0xffff8
50011240:	7275                	lui	tp,0xffffd
50011242:	2065                	jal	500112ea <__func__.2+0x66a>
50011244:	4d46                	lw	s10,80(sp)
50011246:	74732043          	.insn	4, 0x74732043
5001124a:	7261                	lui	tp,0xffff8
5001124c:	3a74                	.insn	2, 0x3a74
5001124e:	0000                	unimp
50011250:	20434f53          	.insn	4, 0x20434f53
50011254:	6966                	.insn	2, 0x6966
50011256:	6d72                	.insn	2, 0x6d72
50011258:	72696177          	.insn	4, 0x72696177
5001125c:	3a65                	jal	50010c14 <k+0x394>
5001125e:	0000                	unimp
50011260:	654d                	lui	a0,0x13
50011262:	7361                	lui	t1,0xffff8
50011264:	7275                	lui	tp,0xffffd
50011266:	2065                	jal	5001130e <SOC_FW_data+0x1e>
50011268:	20434f53          	.insn	4, 0x20434f53
5001126c:	72617473          	csrrc	s0,mhpmevent6h,2
50011270:	3a74                	.insn	2, 0x3a74
50011272:	0000                	unimp
50011274:	754a                	.insn	2, 0x754a
50011276:	706d                	c.lui	zero,0xffffb
50011278:	7420                	.insn	2, 0x7420
5001127a:	4d46206f          	j	5007374e <_tbs_der_store_end+0x5472e>
5001127e:	2e2e2e43          	.insn	4, 0x2e2e2e43
50011282:	0000                	unimp
50011284:	5220                	lw	s0,96(a2)
50011286:	6165                	add	sp,sp,112
50011288:	64656863          	bltu	a0,t1,500118d8 <SOC_FW_data+0x5e8>
5001128c:	6520                	.insn	2, 0x6520
5001128e:	646e                	.insn	2, 0x646e
50011290:	6f20                	.insn	2, 0x6f20
50011292:	2066                	.insn	2, 0x2066
50011294:	4f52                	lw	t5,20(sp)
50011296:	204d                	jal	50011338 <SOC_FW_data+0x48>
50011298:	5746                	lw	a4,112(sp)
5001129a:	7520                	.insn	2, 0x7520
5001129c:	656e                	.insn	2, 0x656e
5001129e:	7078                	.insn	2, 0x7078
500112a0:	6365                	lui	t1,0x19
500112a2:	6574                	.insn	2, 0x6574
500112a4:	6c64                	.insn	2, 0x6c64
500112a6:	2179                	jal	50011734 <SOC_FW_data+0x444>
	...
500112b0:	9ed8                	.insn	2, 0x9ed8
500112b2:	c105                	beqz	a0,500112d2 <__func__.2+0x652>
500112b4:	9d5d                	.insn	2, 0x9d5d
500112b6:	d507cbbb          	.insn	4, 0xd507cbbb
500112ba:	367c                	.insn	2, 0x367c
500112bc:	292a                	.insn	2, 0x292a
500112be:	629a                	.insn	2, 0x629a
500112c0:	3070dd17          	auipc	s10,0x3070d
500112c4:	015a                	sll	sp,sp,0x16
500112c6:	9159                	srl	a0,a0,0x36
500112c8:	5939                	li	s2,-18
500112ca:	f70e                	.insn	2, 0xf70e
500112cc:	ecd8                	.insn	2, 0xecd8
500112ce:	0b31152f          	.insn	4, 0x0b31152f
500112d2:	ffc0                	.insn	2, 0xffc0
500112d4:	67332667          	.insn	4, 0x67332667
500112d8:	1511                	add	a0,a0,-28 # 12fe4 <_bss_lma_end+0xdb58>
500112da:	6858                	.insn	2, 0x6858
500112dc:	8eb44a87          	.insn	4, 0x8eb44a87
500112e0:	64f98fa7          	.insn	4, 0x64f98fa7
500112e4:	2e0d                	jal	50011616 <SOC_FW_data+0x326>
500112e6:	db0c                	sw	a1,48(a4)
500112e8:	4fa4                	lw	s1,88(a5)
500112ea:	befa                	.insn	2, 0xbefa
500112ec:	481d                	li	a6,7
500112ee:	47b5                	li	a5,13

Disassembly of section .dccm:

500112f0 <SOC_FW_data>:
	...

500138f0 <FMC_data>:
	...

Disassembly of section .cert_store:

5001e000 <cert_store>:
	...

Disassembly of section .tbs_der_store:

5001e820 <tbs_der_store>:
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
  30:	0a01                	add	s4,s4,0 # 1b000 <_bss_lma_end+0x15b74>
  32:	0b              	Address 0x32 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	01b2                	sll	gp,gp,0xc
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0401                	add	s0,s0,0 # 9000 <_bss_lma_end+0x3b74>
   8:	0000                	unimp
   a:	0000                	unimp
   c:	0000b407          	.insn	4, 0xb407
  10:	1d00                	add	s0,sp,688
  12:	0000                	unimp
  14:	0000                	unimp
  16:	0026                	c.slli	zero,0x9
  18:	0000                	unimp
  1a:	3eae                	.insn	2, 0x3eae
  1c:	0000                	unimp
  1e:	0028                	add	a0,sp,8
  20:	0000                	unimp
  22:	0000                	unimp
  24:	0000                	unimp
  26:	0801                	add	a6,a6,0 # ffff9000 <_tbs_der_store_end+0xaffd9fe0>
  28:	00007607          	.insn	4, 0x7607
  2c:	0100                	add	s0,sp,128
  2e:	0704                	add	s1,sp,896
  30:	0080                	add	s0,sp,64
  32:	0000                	unimp
  34:	0408                	add	a0,sp,512
  36:	6905                	lui	s2,0x1
  38:	746e                	.insn	2, 0x746e
  3a:	0100                	add	s0,sp,128
  3c:	0508                	add	a0,sp,640
  3e:	008d                	add	ra,ra,3
  40:	0000                	unimp
  42:	1001                	c.nop	-32
  44:	6a04                	.insn	2, 0x6a04
  46:	0000                	unimp
  48:	0100                	add	s0,sp,128
  4a:	0601                	add	a2,a2,0 # ffffa000 <_tbs_der_store_end+0xaffdafe0>
  4c:	0031                	c.nop	12
  4e:	0000                	unimp
  50:	0101                	add	sp,sp,0 # 3b2f7000 <_bss_lma_end+0x3b2f1b74>
  52:	2f08                	.insn	2, 0x2f08
  54:	0000                	unimp
  56:	0100                	add	s0,sp,128
  58:	0502                	c.slli64	a0
  5a:	0000009b          	.insn	4, 0x009b
  5e:	0201                	add	tp,tp,0 # fffe1000 <_tbs_der_store_end+0xaffc1fe0>
  60:	00003d07          	.insn	4, 0x3d07
  64:	0100                	add	s0,sp,128
  66:	0504                	add	s1,sp,640
  68:	0092                	sll	ra,ra,0x4
  6a:	0000                	unimp
  6c:	0401                	add	s0,s0,0
  6e:	00007b07          	.insn	4, 0x7b07
  72:	0100                	add	s0,sp,128
  74:	0801                	add	a6,a6,0
  76:	0038                	add	a4,sp,8
  78:	0000                	unimp
  7a:	0101                	add	sp,sp,0
  7c:	8d02                	jr	s10
  7e:	0001                	nop
  80:	0200                	add	s0,sp,256
  82:	0028                	add	a0,sp,8
  84:	0000                	unimp
  86:	0f80                	add	s0,sp,976
  88:	0034                	add	a3,sp,8
  8a:	0000                	unimp
  8c:	2702                	.insn	2, 0x2702
  8e:	0000                	unimp
  90:	8100                	.insn	2, 0x8100
  92:	2d16                	.insn	2, 0x2d16
  94:	0000                	unimp
  96:	0300                	add	s0,sp,384
  98:	008c                	add	a1,sp,64
  9a:	0000                	unimp
  9c:	9302                	jalr	t1
  9e:	0001                	nop
  a0:	8400                	.insn	2, 0x8400
  a2:	00003b0f          	.insn	4, 0x3b0f
  a6:	0100                	add	s0,sp,128
  a8:	0402                	c.slli64	s0
  aa:	001e                	c.slli	zero,0x7
  ac:	0000                	unimp
  ae:	0401                	add	s0,s0,0
  b0:	00001603          	lh	a2,0(zero) # 0 <_start>
  b4:	0100                	add	s0,sp,128
  b6:	0404                	add	s1,sp,512
  b8:	0176                	sll	sp,sp,0x1d
  ba:	0000                	unimp
  bc:	0801                	add	a6,a6,0
  be:	00016e03          	.insn	4, 0x00016e03
  c2:	0100                	add	s0,sp,128
  c4:	0408                	add	a0,sp,512
  c6:	0000006f          	j	c6 <_finish+0x3c>
  ca:	1001                	c.nop	-32
  cc:	0000a503          	lw	a0,0(ra)
  d0:	0100                	add	s0,sp,128
  d2:	0320                	add	s0,sp,392
  d4:	0062                	c.slli	zero,0x18
  d6:	0000                	unimp
  d8:	7c02                	.insn	2, 0x7c02
  da:	0001                	nop
  dc:	a800                	.insn	2, 0xa800
  de:	340d                	jal	fffffb00 <_tbs_der_store_end+0xaffe0ae0>
  e0:	0000                	unimp
  e2:	0300                	add	s0,sp,384
  e4:	00d8                	add	a4,sp,68
  e6:	0000                	unimp
  e8:	0009                	c.nop	2
  ea:	0000                	unimp
  ec:	0800                	add	s0,sp,16
  ee:	f102                	.insn	2, 0xf102
  f0:	0a01                	add	s4,s4,0
  f2:	00000113          	li	sp,0
  f6:	6c0a                	.insn	2, 0x6c0a
  f8:	0200776f          	jal	a4,7118 <_bss_lma_end+0x1c8c>
  fc:	01f1                	add	gp,gp,28
  fe:	811a                	mv	sp,t1
 100:	0000                	unimp
 102:	0000                	unimp
 104:	0000090b          	.insn	4, 0x090b
 108:	0200                	add	s0,sp,256
 10a:	01f1                	add	gp,gp,28
 10c:	811f 0000 0400      	.insn	6, 0x04000000811f
 112:	0c00                	add	s0,sp,528
 114:	0208                	add	a0,sp,256
 116:	01f8                	add	a4,sp,204
 118:	3309                	jal	fffffe1a <_tbs_der_store_end+0xaffe0dfa>
 11a:	0001                	nop
 11c:	0400                	add	s0,sp,512
 11e:	01fa0073          	.insn	4, 0x01fa0073
 122:	0000e813          	or	a6,ra,0
 126:	0400                	add	s0,sp,512
 128:	6c6c                	.insn	2, 0x6c6c
 12a:	fb00                	.insn	2, 0xfb00
 12c:	0a01                	add	s4,s4,0
 12e:	009c                	add	a5,sp,64
 130:	0000                	unimp
 132:	0d00                	add	s0,sp,656
 134:	0050                	add	a2,sp,4
 136:	0000                	unimp
 138:	fc02                	.insn	2, 0xfc02
 13a:	0301                	add	t1,t1,0 # ffffa000 <_tbs_der_store_end+0xaffdafe0>
 13c:	00000113          	li	sp,0
 140:	00013303          	.insn	4, 0x00013303
 144:	0e00                	add	s0,sp,784
 146:	0058                	add	a4,sp,4
 148:	0000                	unimp
 14a:	8001                	c.srli64	s0
 14c:	0101                	add	sp,sp,0
 14e:	009c                	add	a5,sp,64
 150:	0000                	unimp
 152:	3eae                	.insn	2, 0x3eae
 154:	0000                	unimp
 156:	0028                	add	a0,sp,8
 158:	0000                	unimp
 15a:	9c01                	.insn	2, 0x9c01
 15c:	7505                	lui	a0,0xfffe1
 15e:	1300                	add	s0,sp,416
 160:	009c                	add	a5,sp,64
 162:	0000                	unimp
 164:	000c                	.insn	2, 0x000c
 166:	0000                	unimp
 168:	6205                	lui	tp,0x1
 16a:	2700                	.insn	2, 0x2700
 16c:	00d8                	add	a4,sp,68
 16e:	0000                	unimp
 170:	004d                	c.nop	19
 172:	0000                	unimp
 174:	7506                	.insn	2, 0x7506
 176:	0075                	c.nop	29
 178:	0185                	add	gp,gp,1
 17a:	4011                	c.li	zero,4
 17c:	0001                	nop
 17e:	0f00                	add	s0,sp,912
 180:	6d62                	.insn	2, 0x6d62
 182:	0100                	add	s0,sp,128
 184:	0186                	sll	gp,gp,0x1
 186:	e31a                	.insn	2, 0xe31a
 188:	0000                	unimp
 18a:	8500                	.insn	2, 0x8500
 18c:	0000                	unimp
 18e:	0600                	add	s0,sp,768
 190:	01870077          	.insn	4, 0x01870077
 194:	0001330b          	.insn	4, 0x0001330b
 198:	1000                	add	s0,sp,32
 19a:	3ec6                	.insn	2, 0x3ec6
 19c:	0000                	unimp
 19e:	0010                	.insn	2, 0x0010
 1a0:	0000                	unimp
 1a2:	0e11                	add	t3,t3,4 # 19004 <_bss_lma_end+0x13b78>
 1a4:	0000                	unimp
 1a6:	0100                	add	s0,sp,128
 1a8:	0190                	add	a2,sp,192
 1aa:	9714                	.insn	2, 0x9714
 1ac:	0000                	unimp
 1ae:	9c00                	.insn	2, 0x9c00
 1b0:	0000                	unimp
 1b2:	0000                	unimp
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	2401                	jal	200 <store_to_datavault+0x98>
   2:	0b00                	add	s0,sp,400
   4:	030b3e0b          	.insn	4, 0x030b3e0b
   8:	000e                	c.slli	zero,0x3
   a:	0200                	add	s0,sp,256
   c:	0016                	c.slli	zero,0x5
   e:	213a0e03          	lb	t3,531(s4)
  12:	3b02                	.insn	2, 0x3b02
  14:	490b390b          	.insn	4, 0x490b390b
  18:	03000013          	li	zero,48
  1c:	0026                	c.slli	zero,0x9
  1e:	1349                	add	t1,t1,-14
  20:	0000                	unimp
  22:	0d04                	add	s1,sp,656
  24:	0300                	add	s0,sp,384
  26:	3a08                	.insn	2, 0x3a08
  28:	0221                	add	tp,tp,8 # 1008 <whisperPrintfImpl+0xea>
  2a:	0b39053b          	.insn	4, 0x0b39053b
  2e:	1349                	add	t1,t1,-14
  30:	0000                	unimp
  32:	0505                	add	a0,a0,1 # fffe1001 <_tbs_der_store_end+0xaffc1fe1>
  34:	0300                	add	s0,sp,384
  36:	3a08                	.insn	2, 0x3a08
  38:	0121                	add	sp,sp,8
  3a:	0380213b          	.insn	4, 0x0380213b
  3e:	0b39                	add	s6,s6,14
  40:	1349                	add	t1,t1,-14
  42:	1702                	sll	a4,a4,0x20
  44:	0000                	unimp
  46:	3406                	.insn	2, 0x3406
  48:	0300                	add	s0,sp,384
  4a:	3a08                	.insn	2, 0x3a08
  4c:	0121                	add	sp,sp,8
  4e:	0b39053b          	.insn	4, 0x0b39053b
  52:	1349                	add	t1,t1,-14
  54:	0000                	unimp
  56:	25011107          	.insn	4, 0x25011107
  5a:	130e                	sll	t1,t1,0x23
  5c:	1b1f030b          	.insn	4, 0x1b1f030b
  60:	111f 1201 1006      	.insn	6, 0x10061201111f
  66:	08000017          	auipc	zero,0x8000
  6a:	0024                	add	s1,sp,8
  6c:	0b3e0b0b          	.insn	4, 0x0b3e0b0b
  70:	00000803          	lb	a6,0(zero) # 0 <_start>
  74:	1309                	add	t1,t1,-30
  76:	0301                	add	t1,t1,0
  78:	0b0e                	sll	s6,s6,0x3
  7a:	3b0b3a0b          	.insn	4, 0x3b0b3a0b
  7e:	3905                	jal	fffffcae <_tbs_der_store_end+0xaffe0c8e>
  80:	0013010b          	.insn	4, 0x0013010b
  84:	0a00                	add	s0,sp,272
  86:	000d                	c.nop	3
  88:	0b3a0803          	lb	a6,179(s4)
  8c:	0b39053b          	.insn	4, 0x0b39053b
  90:	1349                	add	t1,t1,-14
  92:	0b38                	add	a4,sp,408
  94:	0000                	unimp
  96:	03000d0b          	.insn	4, 0x03000d0b
  9a:	3a0e                	.insn	2, 0x3a0e
  9c:	39053b0b          	.insn	4, 0x39053b0b
  a0:	3813490b          	.insn	4, 0x3813490b
  a4:	0c00000b          	.insn	4, 0x0c00000b
  a8:	0b0b0117          	auipc	sp,0xb0b0
  ac:	0b3a                	sll	s6,s6,0xe
  ae:	0b39053b          	.insn	4, 0x0b39053b
  b2:	1301                	add	t1,t1,-32
  b4:	0000                	unimp
  b6:	160d                	add	a2,a2,-29
  b8:	0300                	add	s0,sp,384
  ba:	3a0e                	.insn	2, 0x3a0e
  bc:	39053b0b          	.insn	4, 0x39053b0b
  c0:	0013490b          	.insn	4, 0x0013490b
  c4:	0e00                	add	s0,sp,784
  c6:	012e                	sll	sp,sp,0xb
  c8:	0e03193f 053b0b3a 	.insn	8, 0x053b0b3a0e03193f
  d0:	0b39                	add	s6,s6,14
  d2:	13491927          	.insn	4, 0x13491927
  d6:	0111                	add	sp,sp,4 # b0b00ac <_bss_lma_end+0xb0aac20>
  d8:	0612                	sll	a2,a2,0x4
  da:	1840                	add	s0,sp,52
  dc:	197a                	sll	s2,s2,0x3e
  de:	0000                	unimp
  e0:	0300340f          	.insn	4, 0x0300340f
  e4:	3a08                	.insn	2, 0x3a08
  e6:	39053b0b          	.insn	4, 0x39053b0b
  ea:	0213490b          	.insn	4, 0x0213490b
  ee:	10000017          	auipc	zero,0x10000
  f2:	0111010b          	.insn	4, 0x0111010b
  f6:	0612                	sll	a2,a2,0x4
  f8:	0000                	unimp
  fa:	3411                	jal	fffffafe <_tbs_der_store_end+0xaffe0ade>
  fc:	0300                	add	s0,sp,384
  fe:	3a0e                	.insn	2, 0x3a0e
 100:	39053b0b          	.insn	4, 0x39053b0b
 104:	0213490b          	.insn	4, 0x0213490b
 108:	00000017          	auipc	zero,0x0

Disassembly of section .debug_loclists:

00000000 <.debug_loclists>:
   0:	00a9                	add	ra,ra,10
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0004                	.insn	2, 0x0004
   8:	0000                	unimp
   a:	0000                	unimp
   c:	003eae07          	.insn	4, 0x003eae07
  10:	c000                	sw	s0,0(s0)
  12:	003e                	c.slli	zero,0xf
  14:	0600                	add	s0,sp,768
  16:	935a                	add	t1,t1,s6
  18:	5b04                	lw	s1,48(a4)
  1a:	c0070493          	add	s1,a4,-1024 # 19c00 <_bss_lma_end+0x14774>
  1e:	003e                	c.slli	zero,0xf
  20:	c600                	sw	s0,8(a2)
  22:	003e                	c.slli	zero,0xf
  24:	0600                	add	s0,sp,768
  26:	0aa503a3          	sb	a0,167(a0)
  2a:	9f26                	add	t5,t5,s1
  2c:	003ec607          	.insn	4, 0x003ec607
  30:	ce00                	sw	s0,24(a2)
  32:	003e                	c.slli	zero,0xf
  34:	0600                	add	s0,sp,768
  36:	935a                	add	t1,t1,s6
  38:	5b04                	lw	s1,48(a4)
  3a:	ce070493          	add	s1,a4,-800
  3e:	003e                	c.slli	zero,0xf
  40:	d600                	sw	s0,40(a2)
  42:	003e                	c.slli	zero,0xf
  44:	0600                	add	s0,sp,768
  46:	0aa503a3          	sb	a0,167(a0)
  4a:	9f26                	add	t5,t5,s1
  4c:	0700                	add	s0,sp,896
  4e:	3eae                	.insn	2, 0x3eae
  50:	0000                	unimp
  52:	3ebc                	.insn	2, 0x3ebc
  54:	0000                	unimp
  56:	5c01                	li	s8,-32
  58:	003ebc07          	.insn	4, 0x003ebc07
  5c:	c200                	sw	s0,0(a2)
  5e:	003e                	c.slli	zero,0xf
  60:	0300                	add	s0,sp,384
  62:	207c                	.insn	2, 0x207c
  64:	079f 3ec2 0000      	.insn	6, 0x3ec2079f
  6a:	3ec6                	.insn	2, 0x3ec6
  6c:	0000                	unimp
  6e:	a30a                	.insn	2, 0xa30a
  70:	260ca503          	lw	a0,608(s9)
  74:	2da8                	.insn	2, 0x2da8
  76:	00a8                	add	a0,sp,72
  78:	079f 3ec6 0000      	.insn	6, 0x3ec6079f
  7e:	3ed6                	.insn	2, 0x3ed6
  80:	0000                	unimp
  82:	5c01                	li	s8,-32
  84:	0700                	add	s0,sp,896
  86:	3eb6                	.insn	2, 0x3eb6
  88:	0000                	unimp
  8a:	3ec4                	.insn	2, 0x3ec4
  8c:	0000                	unimp
  8e:	5f01                	li	t5,-32
  90:	003ec607          	.insn	4, 0x003ec607
  94:	d600                	sw	s0,40(a2)
  96:	003e                	c.slli	zero,0xf
  98:	0100                	add	s0,sp,128
  9a:	005f c607 003e      	.insn	6, 0x003ec607005f
  a0:	d200                	sw	s0,32(a2)
  a2:	003e                	c.slli	zero,0xf
  a4:	0600                	add	s0,sp,768
  a6:	007f007b          	.insn	4, 0x007f007b
  aa:	9f24                	.insn	2, 0x9f24
	...

Disassembly of section .debug_aranges:

00000000 <.debug_aranges>:
   0:	001c                	.insn	2, 0x001c
   2:	0000                	unimp
   4:	0002                	c.slli64	zero
   6:	0000                	unimp
   8:	0000                	unimp
   a:	0004                	.insn	2, 0x0004
   c:	0000                	unimp
   e:	0000                	unimp
  10:	3eae                	.insn	2, 0x3eae
  12:	0000                	unimp
  14:	0028                	add	a0,sp,8
	...

Disassembly of section .debug_line:

00000000 <.debug_line>:
   0:	00000103          	lb	sp,0(zero) # 0 <_start>
   4:	0005                	c.nop	1
   6:	0004                	.insn	2, 0x0004
   8:	00000033          	add	zero,zero,zero
   c:	0101                	add	sp,sp,0
   e:	fb01                	bnez	a4,ffffff1e <_tbs_der_store_end+0xaffe0efe>
  10:	0d0e                	sll	s10,s10,0x3
  12:	0100                	add	s0,sp,128
  14:	0101                	add	sp,sp,0
  16:	0001                	nop
  18:	0000                	unimp
  1a:	0001                	nop
  1c:	0100                	add	s0,sp,128
  1e:	0101                	add	sp,sp,0
  20:	021f 0026 0000      	.insn	6, 0x0026021f
  26:	008c                	add	a1,sp,64
  28:	0000                	unimp
  2a:	0102                	c.slli64	sp
  2c:	021f 030f 001c      	.insn	6, 0x001c030f021f
  32:	0000                	unimp
  34:	1c01                	add	s8,s8,-32 # 17fe0 <_bss_lma_end+0x12b54>
  36:	0000                	unimp
  38:	0100                	add	s0,sp,128
  3a:	00a8                	add	a0,sp,72
  3c:	0000                	unimp
  3e:	0501                	add	a0,a0,0
  40:	0001                	nop
  42:	0205                	add	tp,tp,1 # 1 <_start+0x1>
  44:	3eae                	.insn	2, 0x3eae
  46:	0000                	unimp
  48:	01038003          	lb	zero,16(t2)
  4c:	0305                	add	t1,t1,1
  4e:	00090103          	lb	sp,0(s2) # 1000 <whisperPrintfImpl+0xe2>
  52:	0100                	add	s0,sp,128
  54:	0605                	add	a2,a2,1
  56:	0306                	sll	t1,t1,0x1
  58:	0900                	add	s0,sp,144
  5a:	0000                	unimp
  5c:	0501                	add	a0,a0,0
  5e:	03030603          	lb	a2,48(t1)
  62:	0209                	add	tp,tp,2 # 2 <_start+0x2>
  64:	0100                	add	s0,sp,128
  66:	00090103          	lb	sp,0(s2)
  6a:	0100                	add	s0,sp,128
  6c:	1a05                	add	s4,s4,-31
  6e:	0306                	sll	t1,t1,0x1
  70:	0900                	add	s0,sp,144
  72:	0000                	unimp
  74:	0501                	add	a0,a0,0
  76:	01030603          	lb	a2,16(t1)
  7a:	0609                	add	a2,a2,2
  7c:	0100                	add	s0,sp,128
  7e:	00090203          	lb	tp,0(s2)
  82:	0100                	add	s0,sp,128
  84:	0605                	add	a2,a2,1
  86:	0306                	sll	t1,t1,0x1
  88:	0900                	add	s0,sp,144
  8a:	0000                	unimp
  8c:	0501                	add	a0,a0,0
  8e:	02030607          	.insn	4, 0x02030607
  92:	0409                	add	s0,s0,2
  94:	0100                	add	s0,sp,128
  96:	00090103          	lb	sp,0(s2)
  9a:	0100                	add	s0,sp,128
  9c:	2705                	jal	7bc <ecc_signing_flow+0x15e>
  9e:	0306                	sll	t1,t1,0x1
  a0:	0900                	add	s0,sp,144
  a2:	0000                	unimp
  a4:	0501                	add	a0,a0,0
  a6:	0324                	add	s1,sp,392
  a8:	0900                	add	s0,sp,144
  aa:	0002                	c.slli64	zero
  ac:	0501                	add	a0,a0,0
  ae:	0a030603          	lb	a2,160(t1)
  b2:	0609                	add	a2,a2,2
  b4:	0100                	add	s0,sp,128
  b6:	0b05                	add	s6,s6,1
  b8:	0306                	sll	t1,t1,0x1
  ba:	0900                	add	s0,sp,144
  bc:	0000                	unimp
  be:	0501                	add	a0,a0,0
  c0:	0301                	add	t1,t1,0
  c2:	0901                	add	s2,s2,0
  c4:	0002                	c.slli64	zero
  c6:	0501                	add	a0,a0,0
  c8:	79030607          	.insn	4, 0x79030607
  cc:	0209                	add	tp,tp,2 # 2 <_start+0x2>
  ce:	0100                	add	s0,sp,128
  d0:	00090203          	lb	tp,0(s2)
  d4:	0100                	add	s0,sp,128
  d6:	2505                	jal	6f6 <ecc_signing_flow+0x98>
  d8:	0306                	sll	t1,t1,0x1
  da:	0900                	add	s0,sp,144
  dc:	0000                	unimp
  de:	0501                	add	a0,a0,0
  e0:	01030607          	.insn	4, 0x01030607
  e4:	0409                	add	s0,s0,2
  e6:	0100                	add	s0,sp,128
  e8:	2405                	jal	308 <ecc_keygen_flow+0x6>
  ea:	0306                	sll	t1,t1,0x1
  ec:	0900                	add	s0,sp,144
  ee:	0000                	unimp
  f0:	0501                	add	a0,a0,0
  f2:	0314                	add	a3,sp,384
  f4:	097d                	add	s2,s2,31
  f6:	0004                	.insn	2, 0x0004
  f8:	0501                	add	a0,a0,0
  fa:	032a                	sll	t1,t1,0xa
  fc:	00040903          	lb	s2,0(s0)
 100:	0901                	add	s2,s2,0
 102:	0004                	.insn	2, 0x0004
 104:	0100                	add	s0,sp,128
 106:	01              	Address 0x106 is out of bounds.


Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	5744                	lw	s1,44(a4)
   2:	75727473          	csrrc	s0,0x757,4
   6:	68007463          	bgeu	zero,zero,68e <ecc_signing_flow+0x30>
   a:	6769                	lui	a4,0x1a
   c:	0068                	add	a0,sp,12
   e:	72726163          	bltu	tp,t2,730 <ecc_signing_flow+0xd2>
  12:	6569                	lui	a0,0x1a
  14:	6f630073          	.insn	4, 0x6f630073
  18:	706d                	c.lui	zero,0xffffb
  1a:	656c                	.insn	2, 0x656c
  1c:	2078                	.insn	2, 0x2078
  1e:	465f 6f6c 7461      	.insn	6, 0x74616f6c465f
  24:	3631                	jal	fffffb30 <_tbs_der_store_end+0xaffe0b10>
  26:	5500                	lw	s0,40(a0)
  28:	79744953          	.insn	4, 0x79744953
  2c:	6570                	.insn	2, 0x6570
  2e:	7500                	.insn	2, 0x7500
  30:	736e                	.insn	2, 0x736e
  32:	6769                	lui	a4,0x1a
  34:	656e                	.insn	2, 0x656e
  36:	2064                	.insn	2, 0x2064
  38:	72616863          	bltu	sp,t1,768 <ecc_signing_flow+0x10a>
  3c:	7300                	.insn	2, 0x7300
  3e:	6f68                	.insn	2, 0x6f68
  40:	7472                	.insn	2, 0x7472
  42:	7520                	.insn	2, 0x7520
  44:	736e                	.insn	2, 0x736e
  46:	6769                	lui	a4,0x1a
  48:	656e                	.insn	2, 0x656e
  4a:	2064                	.insn	2, 0x2064
  4c:	6e69                	lui	t3,0x1a
  4e:	0074                	add	a3,sp,12
  50:	5744                	lw	s1,44(a4)
  52:	6e75                	lui	t3,0x1d
  54:	6f69                	lui	t5,0x1a
  56:	006e                	c.slli	zero,0x1b
  58:	5f5f 736c 7268      	.insn	6, 0x7268736c5f5f
  5e:	6964                	.insn	2, 0x6964
  60:	6f630033          	.insn	4, 0x6f630033
  64:	706d                	c.lui	zero,0xffffb
  66:	656c                	.insn	2, 0x656c
  68:	2078                	.insn	2, 0x2078
  6a:	6f6c                	.insn	2, 0x6f6c
  6c:	676e                	.insn	2, 0x676e
  6e:	6420                	.insn	2, 0x6420
  70:	6c62756f          	jal	a0,27736 <_bss_lma_end+0x222aa>
  74:	0065                	c.nop	25
  76:	6f6c                	.insn	2, 0x6f6c
  78:	676e                	.insn	2, 0x676e
  7a:	6c20                	.insn	2, 0x6c20
  7c:	20676e6f          	jal	t3,76282 <_bss_lma_end+0x70df6>
  80:	6e75                	lui	t3,0x1d
  82:	6e676973          	csrrs	s2,0x6e6,14
  86:	6465                	lui	s0,0x19
  88:	6920                	.insn	2, 0x6920
  8a:	746e                	.insn	2, 0x746e
  8c:	6c00                	.insn	2, 0x6c00
  8e:	20676e6f          	jal	t3,76294 <_bss_lma_end+0x70e08>
  92:	6f6c                	.insn	2, 0x6f6c
  94:	676e                	.insn	2, 0x676e
  96:	6920                	.insn	2, 0x6920
  98:	746e                	.insn	2, 0x746e
  9a:	7300                	.insn	2, 0x7300
  9c:	6f68                	.insn	2, 0x6f68
  9e:	7472                	.insn	2, 0x7472
  a0:	6920                	.insn	2, 0x6920
  a2:	746e                	.insn	2, 0x746e
  a4:	6300                	.insn	2, 0x6300
  a6:	6c706d6f          	jal	s10,6f6c <_bss_lma_end+0x1ae0>
  aa:	7865                	lui	a6,0xffff9
  ac:	6420                	.insn	2, 0x6420
  ae:	6c62756f          	jal	a0,27774 <_bss_lma_end+0x222e8>
  b2:	0065                	c.nop	25
  b4:	20554e47          	.insn	4, 0x20554e47
  b8:	20373143          	.insn	4, 0x20373143
  bc:	3331                	jal	fffffdc8 <_tbs_der_store_end+0xaffe0da8>
  be:	312e                	.insn	2, 0x312e
  c0:	312e                	.insn	2, 0x312e
  c2:	3220                	.insn	2, 0x3220
  c4:	3230                	.insn	2, 0x3230
  c6:	31373033          	.insn	4, 0x31373033
  ca:	6d2d2033          	.insn	4, 0x6d2d2033
  ce:	646f6d63          	bltu	t5,t1,728 <ecc_signing_flow+0xca>
  d2:	6c65                	lui	s8,0x19
  d4:	6d3d                	lui	s10,0xf
  d6:	6465                	lui	s0,0x19
  d8:	6e61                	lui	t3,0x18
  da:	2079                	jal	168 <store_to_datavault>
  dc:	6d2d                	lui	s10,0xb
  de:	6261                	lui	tp,0x18
  e0:	3d69                	jal	ffffff7a <_tbs_der_store_end+0xaffe0f5a>
  e2:	6c69                	lui	s8,0x1a
  e4:	3370                	.insn	2, 0x3370
  e6:	2032                	.insn	2, 0x2032
  e8:	6d2d                	lui	s10,0xb
  ea:	646f6d63          	bltu	t5,t1,744 <ecc_signing_flow+0xe6>
  ee:	6c65                	lui	s8,0x19
  f0:	6d3d                	lui	s10,0xf
  f2:	6465                	lui	s0,0x19
  f4:	6e61                	lui	t3,0x18
  f6:	2079                	jal	184 <store_to_datavault+0x1c>
  f8:	6d2d                	lui	s10,0xb
  fa:	7574                	.insn	2, 0x7574
  fc:	656e                	.insn	2, 0x656e
  fe:	723d                	lui	tp,0xfffef
 100:	656b636f          	jal	t1,b6756 <_bss_lma_end+0xb12ca>
 104:	2074                	.insn	2, 0x2074
 106:	6d2d                	lui	s10,0xb
 108:	7369                	lui	t1,0xffffa
 10a:	2d61                	jal	7a2 <ecc_signing_flow+0x144>
 10c:	63657073          	csrc	0x636,10
 110:	323d                	jal	fffffa3e <_tbs_der_store_end+0xaffe0a1e>
 112:	322e                	.insn	2, 0x322e
 114:	2d20                	.insn	2, 0x2d20
 116:	616d                	add	sp,sp,240
 118:	6372                	.insn	2, 0x6372
 11a:	3d68                	.insn	2, 0x3d68
 11c:	7672                	.insn	2, 0x7672
 11e:	6d693233          	.insn	4, 0x6d693233
 122:	672d2063          	.insn	4, 0x672d2063
 126:	2d20                	.insn	2, 0x2d20
 128:	2d20734f          	.insn	4, 0x2d20734f
 12c:	2d20324f          	.insn	4, 0x2d20324f
 130:	2d20734f          	.insn	4, 0x2d20734f
 134:	6266                	.insn	2, 0x6266
 136:	6975                	lui	s2,0x1d
 138:	646c                	.insn	2, 0x646c
 13a:	6e69                	lui	t3,0x1a
 13c:	696c2d67          	.insn	4, 0x696c2d67
 140:	6762                	.insn	2, 0x6762
 142:	2d206363          	bltu	zero,s2,408 <ecc_keygen_flow+0x106>
 146:	6e66                	.insn	2, 0x6e66
 148:	74732d6f          	jal	s10,3308e <_bss_lma_end+0x2dc02>
 14c:	6361                	lui	t1,0x18
 14e:	72702d6b          	.insn	4, 0x72702d6b
 152:	6365746f          	jal	s0,57788 <_bss_lma_end+0x522fc>
 156:	6f74                	.insn	2, 0x6f74
 158:	2072                	.insn	2, 0x2072
 15a:	662d                	lui	a2,0xb
 15c:	6976                	.insn	2, 0x6976
 15e:	69626973          	csrrs	s2,0x696,4
 162:	696c                	.insn	2, 0x696c
 164:	7974                	.insn	2, 0x7974
 166:	683d                	lui	a6,0xf
 168:	6469                	lui	s0,0x1a
 16a:	6564                	.insn	2, 0x6564
 16c:	006e                	c.slli	zero,0x1b
 16e:	706d6f63          	bltu	s10,t1,88c <mfdc+0x93>
 172:	656c                	.insn	2, 0x656c
 174:	2078                	.insn	2, 0x2078
 176:	6c66                	.insn	2, 0x6c66
 178:	0074616f          	jal	sp,4697e <_bss_lma_end+0x414f2>
 17c:	66696873          	csrrs	a6,0x666,18
 180:	5f74                	lw	a3,124(a4)
 182:	6e756f63          	bltu	a0,t2,880 <mfdc+0x87>
 186:	5f74                	lw	a3,124(a4)
 188:	7974                	.insn	2, 0x7974
 18a:	6570                	.insn	2, 0x6570
 18c:	5f00                	lw	s0,56(a4)
 18e:	6f42                	.insn	2, 0x6f42
 190:	44006c6f          	jal	s8,65d0 <_bss_lma_end+0x1144>
 194:	7449                	lui	s0,0xffff2
 196:	7079                	c.lui	zero,0xffffe
 198:	0065                	c.nop	25

Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	2e2e                	.insn	2, 0x2e2e
   2:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
   6:	2e2e                	.insn	2, 0x2e2e
   8:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
   c:	2e2e                	.insn	2, 0x2e2e
   e:	672f2e2f          	.insn	4, 0x672f2e2f
  12:	6c2f6363          	bltu	t5,sp,6d8 <ecc_signing_flow+0x7a>
  16:	6269                	lui	tp,0x1a
  18:	2f636367          	.insn	4, 0x2f636367
  1c:	696c                	.insn	2, 0x696c
  1e:	6762                	.insn	2, 0x6762
  20:	2e326363          	bltu	tp,gp,306 <ecc_keygen_flow+0x4>
  24:	682f0063          	beq	t5,sp,6a4 <ecc_signing_flow+0x46>
  28:	2f656d6f          	jal	s10,5631e <_bss_lma_end+0x50e92>
  2c:	6f68                	.insn	2, 0x6f68
  2e:	6475                	lui	s0,0x1d
  30:	68676e6f          	jal	t3,766b6 <_bss_lma_end+0x7122a>
  34:	6975                	lui	s2,0x1d
  36:	7369722f          	.insn	4, 0x7369722f
  3a:	672d7663          	bgeu	s10,s2,6a6 <ecc_signing_flow+0x48>
  3e:	756e                	.insn	2, 0x756e
  40:	742d                	lui	s0,0xfffeb
  42:	636c6f6f          	jal	t5,c6678 <_bss_lma_end+0xc11ec>
  46:	6168                	.insn	2, 0x6168
  48:	6e69                	lui	t3,0x1a
  4a:	6975622f          	.insn	4, 0x6975622f
  4e:	646c                	.insn	2, 0x646c
  50:	672d                	lui	a4,0xb
  52:	6e2d6363          	bltu	s10,sp,738 <ecc_signing_flow+0xda>
  56:	7765                	lui	a4,0xffff9
  58:	696c                	.insn	2, 0x696c
  5a:	2d62                	.insn	2, 0x2d62
  5c:	67617473          	csrrc	s0,0x676,2
  60:	3265                	jal	fffffa08 <_tbs_der_store_end+0xaffe09e8>
  62:	7369722f          	.insn	4, 0x7369722f
  66:	34367663          	bgeu	a2,gp,3b2 <ecc_keygen_flow+0xb0>
  6a:	752d                	lui	a0,0xfffeb
  6c:	6b6e                	.insn	2, 0x6b6e
  6e:	6f6e                	.insn	2, 0x6f6e
  70:	652d6e77          	.insn	4, 0x652d6e77
  74:	666c                	.insn	2, 0x666c
  76:	3376722f          	.insn	4, 0x3376722f
  7a:	6932                	.insn	2, 0x6932
  7c:	636d                	lui	t1,0x1b
  7e:	706c692f          	.insn	4, 0x706c692f
  82:	6c2f3233          	.insn	4, 0x6c2f3233
  86:	6269                	lui	tp,0x1a
  88:	00636367          	.insn	4, 0x00636367
  8c:	2e2e                	.insn	2, 0x2e2e
  8e:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
  92:	2e2e                	.insn	2, 0x2e2e
  94:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
  98:	2e2e                	.insn	2, 0x2e2e
  9a:	672f2e2f          	.insn	4, 0x672f2e2f
  9e:	6c2f6363          	bltu	t5,sp,764 <ecc_signing_flow+0x106>
  a2:	6269                	lui	tp,0x1a
  a4:	00636367          	.insn	4, 0x00636367
  a8:	696c                	.insn	2, 0x696c
  aa:	6762                	.insn	2, 0x6762
  ac:	2e326363          	bltu	tp,gp,392 <ecc_keygen_flow+0x90>
  b0:	0068                	add	a0,sp,12

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	000c                	.insn	2, 0x000c
   2:	0000                	unimp
   4:	ffffffff          	.insn	4, 0xffffffff
   8:	7c010003          	lb	zero,1984(sp)
   c:	0d01                	add	s10,s10,0 # b000 <_bss_lma_end+0x5b74>
   e:	0002                	c.slli64	zero
  10:	000c                	.insn	2, 0x000c
  12:	0000                	unimp
  14:	0000                	unimp
  16:	0000                	unimp
  18:	3eae                	.insn	2, 0x3eae
  1a:	0000                	unimp
  1c:	0028                	add	a0,sp,8
	...
