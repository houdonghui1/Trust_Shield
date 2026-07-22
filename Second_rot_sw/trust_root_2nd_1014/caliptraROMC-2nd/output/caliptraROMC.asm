
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
  22:	00003297          	auipc	t0,0x3
  26:	45228293          	add	t0,t0,1106 # 3474 <early_trap_vector>
  2a:	30529073          	csrw	mtvec,t0
  2e:	00003297          	auipc	t0,0x3
  32:	7de28293          	add	t0,t0,2014 # 380c <_data_lma_start>
  36:	00004317          	auipc	t1,0x4
  3a:	38e30313          	add	t1,t1,910 # 43c4 <_data_lma_end>
  3e:	50010397          	auipc	t2,0x50010
  42:	fc238393          	add	t2,t2,-62 # 50010000 <curve_n>

00000046 <data_cp_loop>:
  46:	0002ae03          	lw	t3,0(t0)
  4a:	01c3a023          	sw	t3,0(t2)
  4e:	0291                	add	t0,t0,4
  50:	0391                	add	t2,t2,4
  52:	fe62eae3          	bltu	t0,t1,46 <data_cp_loop>
  56:	50011297          	auipc	t0,0x50011
  5a:	b6228293          	add	t0,t0,-1182 # 50010bb8 <signature>
  5e:	50013317          	auipc	t1,0x50013
  62:	c3e30313          	add	t1,t1,-962 # 50012c9c <_bss_lma_end>
  66:	50011397          	auipc	t2,0x50011
  6a:	b5238393          	add	t2,t2,-1198 # 50010bb8 <signature>

0000006e <bss_cp_loop>:
  6e:	0002ae03          	lw	t3,0(t0)
  72:	01c3a023          	sw	t3,0(t2)
  76:	0291                	add	t0,t0,4
  78:	0391                	add	t2,t2,4
  7a:	fe62eae3          	bltu	t0,t1,6e <bss_cp_loop>
  7e:	50017117          	auipc	sp,0x50017
  82:	c2210113          	add	sp,sp,-990 # 50016ca0 <STACK>
  86:	6e3020ef          	jal	2f68 <main>

0000008a <_finish>:
  8a:	300302b7          	lui	t0,0x30030
  8e:	0cc28293          	add	t0,t0,204 # 300300cc <_data_lma_end+0x3002bd08>
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

00000168 <getRandomNumber>:
     168:	50010637          	lui	a2,0x50010
     16c:	41c656b7          	lui	a3,0x41c65
     170:	688d                	lui	a7,0x3
     172:	17062783          	lw	a5,368(a2) # 50010170 <bare_rng_seed>
     176:	17462703          	lw	a4,372(a2)
     17a:	4581                	li	a1,0
     17c:	e6d68693          	add	a3,a3,-403 # 41c64e6d <_data_lma_end+0x41c60aa9>
     180:	03988893          	add	a7,a7,57 # 3039 <main+0xd1>
     184:	03000313          	li	t1,48
     188:	02d78833          	mul	a6,a5,a3
     18c:	02d70733          	mul	a4,a4,a3
     190:	02d7b7b3          	mulhu	a5,a5,a3
     194:	973e                	add	a4,a4,a5
     196:	011807b3          	add	a5,a6,a7
     19a:	0107b833          	sltu	a6,a5,a6
     19e:	9742                	add	a4,a4,a6
     1a0:	00b50833          	add	a6,a0,a1
     1a4:	00e80023          	sb	a4,0(a6)
     1a8:	0585                	add	a1,a1,1
     1aa:	fc659fe3          	bne	a1,t1,188 <getRandomNumber+0x20>
     1ae:	16f62823          	sw	a5,368(a2)
     1b2:	16e62a23          	sw	a4,372(a2)
     1b6:	4505                	li	a0,1
     1b8:	8082                	ret

000001ba <vli_clear>:
     1ba:	03000613          	li	a2,48
     1be:	4581                	li	a1,0
     1c0:	4540306f          	j	3614 <memset>

000001c4 <vli_isZero>:
     1c4:	03050713          	add	a4,a0,48
     1c8:	411c                	lw	a5,0(a0)
     1ca:	4154                	lw	a3,4(a0)
     1cc:	8fd5                	or	a5,a5,a3
     1ce:	e791                	bnez	a5,1da <vli_isZero+0x16>
     1d0:	0521                	add	a0,a0,8
     1d2:	fee51be3          	bne	a0,a4,1c8 <vli_isZero+0x4>
     1d6:	4505                	li	a0,1
     1d8:	8082                	ret
     1da:	4501                	li	a0,0
     1dc:	8082                	ret

000001de <vli_testBit>:
     1de:	0065d793          	srl	a5,a1,0x6
     1e2:	1141                	add	sp,sp,-16
     1e4:	078e                	sll	a5,a5,0x3
     1e6:	c422                	sw	s0,8(sp)
     1e8:	03f5f613          	and	a2,a1,63
     1ec:	00f50433          	add	s0,a0,a5
     1f0:	4581                	li	a1,0
     1f2:	4505                	li	a0,1
     1f4:	c606                	sw	ra,12(sp)
     1f6:	2d8030ef          	jal	34ce <__ashldi3>
     1fa:	4018                	lw	a4,0(s0)
     1fc:	405c                	lw	a5,4(s0)
     1fe:	40b2                	lw	ra,12(sp)
     200:	4422                	lw	s0,8(sp)
     202:	8d79                	and	a0,a0,a4
     204:	8dfd                	and	a1,a1,a5
     206:	0141                	add	sp,sp,16
     208:	8082                	ret

0000020a <vli_numBits>:
     20a:	4795                	li	a5,5
     20c:	567d                	li	a2,-1
     20e:	00379713          	sll	a4,a5,0x3
     212:	972a                	add	a4,a4,a0
     214:	4314                	lw	a3,0(a4)
     216:	4358                	lw	a4,4(a4)
     218:	8ed9                	or	a3,a3,a4
     21a:	ca81                	beqz	a3,22a <vli_numBits+0x20>
     21c:	00379713          	sll	a4,a5,0x3
     220:	953a                	add	a0,a0,a4
     222:	4118                	lw	a4,0(a0)
     224:	4154                	lw	a3,4(a0)
     226:	4601                	li	a2,0
     228:	a821                	j	240 <vli_numBits+0x36>
     22a:	17fd                	add	a5,a5,-1
     22c:	fec791e3          	bne	a5,a2,20e <vli_numBits+0x4>
     230:	4501                	li	a0,0
     232:	8082                	ret
     234:	01f69593          	sll	a1,a3,0x1f
     238:	8305                	srl	a4,a4,0x1
     23a:	8f4d                	or	a4,a4,a1
     23c:	8285                	srl	a3,a3,0x1
     23e:	0605                	add	a2,a2,1
     240:	00d765b3          	or	a1,a4,a3
     244:	f9e5                	bnez	a1,234 <vli_numBits+0x2a>
     246:	00679513          	sll	a0,a5,0x6
     24a:	9532                	add	a0,a0,a2
     24c:	8082                	ret

0000024e <vli_set>:
     24e:	4781                	li	a5,0
     250:	03000713          	li	a4,48
     254:	00f586b3          	add	a3,a1,a5
     258:	0006a803          	lw	a6,0(a3)
     25c:	0046a883          	lw	a7,4(a3)
     260:	00f506b3          	add	a3,a0,a5
     264:	0106a023          	sw	a6,0(a3)
     268:	0116a223          	sw	a7,4(a3)
     26c:	07a1                	add	a5,a5,8
     26e:	fee793e3          	bne	a5,a4,254 <vli_set+0x6>
     272:	8082                	ret

00000274 <vli_cmp>:
     274:	02800793          	li	a5,40
     278:	58e1                	li	a7,-8
     27a:	00f50733          	add	a4,a0,a5
     27e:	00f586b3          	add	a3,a1,a5
     282:	4310                	lw	a2,0(a4)
     284:	0006a803          	lw	a6,0(a3)
     288:	4358                	lw	a4,4(a4)
     28a:	42d4                	lw	a3,4(a3)
     28c:	02e6e163          	bltu	a3,a4,2ae <vli_cmp+0x3a>
     290:	00d71463          	bne	a4,a3,298 <vli_cmp+0x24>
     294:	00c86d63          	bltu	a6,a2,2ae <vli_cmp+0x3a>
     298:	00d76d63          	bltu	a4,a3,2b2 <vli_cmp+0x3e>
     29c:	00e69463          	bne	a3,a4,2a4 <vli_cmp+0x30>
     2a0:	01066963          	bltu	a2,a6,2b2 <vli_cmp+0x3e>
     2a4:	17e1                	add	a5,a5,-8
     2a6:	fd179ae3          	bne	a5,a7,27a <vli_cmp+0x6>
     2aa:	4501                	li	a0,0
     2ac:	8082                	ret
     2ae:	4505                	li	a0,1
     2b0:	8082                	ret
     2b2:	557d                	li	a0,-1
     2b4:	8082                	ret

000002b6 <vli_rshift1>:
     2b6:	03050713          	add	a4,a0,48
     2ba:	4581                	li	a1,0
     2bc:	00e51363          	bne	a0,a4,2c2 <vli_rshift1+0xc>
     2c0:	8082                	ret
     2c2:	f8070693          	add	a3,a4,-128
     2c6:	0786a803          	lw	a6,120(a3)
     2ca:	5efc                	lw	a5,124(a3)
     2cc:	01f79893          	sll	a7,a5,0x1f
     2d0:	00185613          	srl	a2,a6,0x1
     2d4:	8385                	srl	a5,a5,0x1
     2d6:	8fcd                	or	a5,a5,a1
     2d8:	00c8e633          	or	a2,a7,a2
     2dc:	deb0                	sw	a2,120(a3)
     2de:	defc                	sw	a5,124(a3)
     2e0:	01f81593          	sll	a1,a6,0x1f
     2e4:	1761                	add	a4,a4,-8
     2e6:	bfd9                	j	2bc <vli_rshift1+0x6>

000002e8 <vli_add>:
     2e8:	8e2a                	mv	t3,a0
     2ea:	8eae                	mv	t4,a1
     2ec:	4701                	li	a4,0
     2ee:	4501                	li	a0,0
     2f0:	4581                	li	a1,0
     2f2:	03000f13          	li	t5,48
     2f6:	00ee87b3          	add	a5,t4,a4
     2fa:	00e606b3          	add	a3,a2,a4
     2fe:	0007a883          	lw	a7,0(a5)
     302:	0047a303          	lw	t1,4(a5)
     306:	429c                	lw	a5,0(a3)
     308:	97c6                	add	a5,a5,a7
     30a:	0046a803          	lw	a6,4(a3)
     30e:	981a                	add	a6,a6,t1
     310:	0117b6b3          	sltu	a3,a5,a7
     314:	96c2                	add	a3,a3,a6
     316:	00a78833          	add	a6,a5,a0
     31a:	00f837b3          	sltu	a5,a6,a5
     31e:	96ae                	add	a3,a3,a1
     320:	97b6                	add	a5,a5,a3
     322:	01089463          	bne	a7,a6,32a <vli_add+0x42>
     326:	00f30c63          	beq	t1,a5,33e <vli_add+0x56>
     32a:	4505                	li	a0,1
     32c:	4581                	li	a1,0
     32e:	0067e863          	bltu	a5,t1,33e <vli_add+0x56>
     332:	00f31463          	bne	t1,a5,33a <vli_add+0x52>
     336:	01186463          	bltu	a6,a7,33e <vli_add+0x56>
     33a:	4501                	li	a0,0
     33c:	4581                	li	a1,0
     33e:	00ee06b3          	add	a3,t3,a4
     342:	0106a023          	sw	a6,0(a3)
     346:	c2dc                	sw	a5,4(a3)
     348:	0721                	add	a4,a4,8
     34a:	fbe716e3          	bne	a4,t5,2f6 <vli_add+0xe>
     34e:	8082                	ret

00000350 <vli_sub>:
     350:	8e2a                	mv	t3,a0
     352:	8eae                	mv	t4,a1
     354:	4701                	li	a4,0
     356:	4501                	li	a0,0
     358:	4581                	li	a1,0
     35a:	03000f93          	li	t6,48
     35e:	00ee87b3          	add	a5,t4,a4
     362:	0007a883          	lw	a7,0(a5)
     366:	40a88833          	sub	a6,a7,a0
     36a:	0047a303          	lw	t1,4(a5)
     36e:	0108b6b3          	sltu	a3,a7,a6
     372:	00e60f33          	add	t5,a2,a4
     376:	40b307b3          	sub	a5,t1,a1
     37a:	8f95                	sub	a5,a5,a3
     37c:	000f2683          	lw	a3,0(t5)
     380:	40d806b3          	sub	a3,a6,a3
     384:	004f2f03          	lw	t5,4(t5)
     388:	00d83833          	sltu	a6,a6,a3
     38c:	41e787b3          	sub	a5,a5,t5
     390:	410787b3          	sub	a5,a5,a6
     394:	00d89463          	bne	a7,a3,39c <vli_sub+0x4c>
     398:	00f30c63          	beq	t1,a5,3b0 <vli_sub+0x60>
     39c:	4505                	li	a0,1
     39e:	4581                	li	a1,0
     3a0:	00f36863          	bltu	t1,a5,3b0 <vli_sub+0x60>
     3a4:	00679463          	bne	a5,t1,3ac <vli_sub+0x5c>
     3a8:	00d8e463          	bltu	a7,a3,3b0 <vli_sub+0x60>
     3ac:	4501                	li	a0,0
     3ae:	4581                	li	a1,0
     3b0:	00ee0833          	add	a6,t3,a4
     3b4:	00d82023          	sw	a3,0(a6)
     3b8:	00f82223          	sw	a5,4(a6)
     3bc:	0721                	add	a4,a4,8
     3be:	fbf710e3          	bne	a4,t6,35e <vli_sub+0xe>
     3c2:	8082                	ret

000003c4 <vli_mult>:
     3c4:	7179                	add	sp,sp,-48
     3c6:	d622                	sw	s0,44(sp)
     3c8:	d426                	sw	s1,40(sp)
     3ca:	d24a                	sw	s2,36(sp)
     3cc:	d04e                	sw	s3,32(sp)
     3ce:	ce52                	sw	s4,28(sp)
     3d0:	cc56                	sw	s5,24(sp)
     3d2:	ca5a                	sw	s6,20(sp)
     3d4:	c85e                	sw	s7,16(sp)
     3d6:	c662                	sw	s8,12(sp)
     3d8:	c466                	sw	s9,8(sp)
     3da:	4701                	li	a4,0
     3dc:	4e01                	li	t3,0
     3de:	4e81                	li	t4,0
     3e0:	4f81                	li	t6,0
     3e2:	4281                	li	t0,0
     3e4:	4395                	li	t2,5
     3e6:	4499                	li	s1,6
     3e8:	442d                	li	s0,11
     3ea:	8876                	mv	a6,t4
     3ec:	007ef363          	bgeu	t4,t2,3f2 <vli_mult+0x2e>
     3f0:	4815                	li	a6,5
     3f2:	003e9f13          	sll	t5,t4,0x3
     3f6:	8aba                	mv	s5,a4
     3f8:	89f2                	mv	s3,t3
     3fa:	877e                	mv	a4,t6
     3fc:	8e16                	mv	t3,t0
     3fe:	186d                	add	a6,a6,-5
     400:	01e60933          	add	s2,a2,t5
     404:	4f81                	li	t6,0
     406:	4281                	li	t0,0
     408:	030ef963          	bgeu	t4,a6,43a <vli_mult+0x76>
     40c:	9f2a                	add	t5,t5,a0
     40e:	015f2023          	sw	s5,0(t5)
     412:	013f2223          	sw	s3,4(t5)
     416:	0e85                	add	t4,t4,1
     418:	fc8e99e3          	bne	t4,s0,3ea <vli_mult+0x26>
     41c:	5432                	lw	s0,44(sp)
     41e:	cd38                	sw	a4,88(a0)
     420:	05c52e23          	sw	t3,92(a0)
     424:	54a2                	lw	s1,40(sp)
     426:	5912                	lw	s2,36(sp)
     428:	5982                	lw	s3,32(sp)
     42a:	4a72                	lw	s4,28(sp)
     42c:	4ae2                	lw	s5,24(sp)
     42e:	4b52                	lw	s6,20(sp)
     430:	4bc2                	lw	s7,16(sp)
     432:	4c32                	lw	s8,12(sp)
     434:	4ca2                	lw	s9,8(sp)
     436:	6145                	add	sp,sp,48
     438:	8082                	ret
     43a:	fc9809e3          	beq	a6,s1,40c <vli_mult+0x48>
     43e:	00381793          	sll	a5,a6,0x3
     442:	00f586b3          	add	a3,a1,a5
     446:	40f907b3          	sub	a5,s2,a5
     44a:	0006ab03          	lw	s6,0(a3)
     44e:	0047a303          	lw	t1,4(a5)
     452:	42d4                	lw	a3,4(a3)
     454:	0007ab83          	lw	s7,0(a5)
     458:	026b0c33          	mul	s8,s6,t1
     45c:	03768cb3          	mul	s9,a3,s7
     460:	037b37b3          	mulhu	a5,s6,s7
     464:	037b08b3          	mul	a7,s6,s7
     468:	026b3b33          	mulhu	s6,s6,t1
     46c:	0376bbb3          	mulhu	s7,a3,s7
     470:	02668a33          	mul	s4,a3,t1
     474:	9bda                	add	s7,s7,s6
     476:	0266b333          	mulhu	t1,a3,t1
     47a:	018c86b3          	add	a3,s9,s8
     47e:	0196bcb3          	sltu	s9,a3,s9
     482:	96be                	add	a3,a3,a5
     484:	9cde                	add	s9,s9,s7
     486:	00f6b7b3          	sltu	a5,a3,a5
     48a:	97e6                	add	a5,a5,s9
     48c:	0167e663          	bltu	a5,s6,498 <vli_mult+0xd4>
     490:	00fb1563          	bne	s6,a5,49a <vli_mult+0xd6>
     494:	0186f363          	bgeu	a3,s8,49a <vli_mult+0xd6>
     498:	0305                	add	t1,t1,1
     49a:	9a3e                	add	s4,s4,a5
     49c:	00fa37b3          	sltu	a5,s4,a5
     4a0:	979a                	add	a5,a5,t1
     4a2:	01588333          	add	t1,a7,s5
     4a6:	96ce                	add	a3,a3,s3
     4a8:	011338b3          	sltu	a7,t1,a7
     4ac:	98b6                	add	a7,a7,a3
     4ae:	4685                	li	a3,1
     4b0:	0138e763          	bltu	a7,s3,4be <vli_mult+0xfa>
     4b4:	01199463          	bne	s3,a7,4bc <vli_mult+0xf8>
     4b8:	01536363          	bltu	t1,s5,4be <vli_mult+0xfa>
     4bc:	4681                	li	a3,0
     4be:	00e689b3          	add	s3,a3,a4
     4c2:	00d9b6b3          	sltu	a3,s3,a3
     4c6:	96f2                	add	a3,a3,t3
     4c8:	01498733          	add	a4,s3,s4
     4cc:	96be                	add	a3,a3,a5
     4ce:	013739b3          	sltu	s3,a4,s3
     4d2:	00d98e33          	add	t3,s3,a3
     4d6:	4685                	li	a3,1
     4d8:	00fe6763          	bltu	t3,a5,4e6 <vli_mult+0x122>
     4dc:	01c79463          	bne	a5,t3,4e4 <vli_mult+0x120>
     4e0:	01476363          	bltu	a4,s4,4e6 <vli_mult+0x122>
     4e4:	4681                	li	a3,0
     4e6:	00df87b3          	add	a5,t6,a3
     4ea:	01f7b6b3          	sltu	a3,a5,t6
     4ee:	92b6                	add	t0,t0,a3
     4f0:	8fbe                	mv	t6,a5
     4f2:	0805                	add	a6,a6,1
     4f4:	8a9a                	mv	s5,t1
     4f6:	89c6                	mv	s3,a7
     4f8:	bf01                	j	408 <vli_mult+0x44>

000004fa <vli_modAdd>:
     4fa:	1141                	add	sp,sp,-16
     4fc:	c422                	sw	s0,8(sp)
     4fe:	c226                	sw	s1,4(sp)
     500:	c606                	sw	ra,12(sp)
     502:	842a                	mv	s0,a0
     504:	84b6                	mv	s1,a3
     506:	33cd                	jal	2e8 <vli_add>
     508:	8d4d                	or	a0,a0,a1
     50a:	e511                	bnez	a0,516 <vli_modAdd+0x1c>
     50c:	85a6                	mv	a1,s1
     50e:	8522                	mv	a0,s0
     510:	3395                	jal	274 <vli_cmp>
     512:	00054a63          	bltz	a0,526 <vli_modAdd+0x2c>
     516:	85a2                	mv	a1,s0
     518:	8522                	mv	a0,s0
     51a:	4422                	lw	s0,8(sp)
     51c:	40b2                	lw	ra,12(sp)
     51e:	8626                	mv	a2,s1
     520:	4492                	lw	s1,4(sp)
     522:	0141                	add	sp,sp,16
     524:	b535                	j	350 <vli_sub>
     526:	40b2                	lw	ra,12(sp)
     528:	4422                	lw	s0,8(sp)
     52a:	4492                	lw	s1,4(sp)
     52c:	0141                	add	sp,sp,16
     52e:	8082                	ret

00000530 <vli_mmod_fast>:
     530:	7171                	add	sp,sp,-176
     532:	d522                	sw	s0,168(sp)
     534:	d14a                	sw	s2,160(sp)
     536:	cf4e                	sw	s3,156(sp)
     538:	cd52                	sw	s4,152(sp)
     53a:	d706                	sw	ra,172(sp)
     53c:	d326                	sw	s1,164(sp)
     53e:	cb56                	sw	s5,148(sp)
     540:	c95a                	sw	s6,144(sp)
     542:	89aa                	mv	s3,a0
     544:	842e                	mv	s0,a1
     546:	03058913          	add	s2,a1,48
     54a:	06058a13          	add	s4,a1,96
     54e:	854a                	mv	a0,s2
     550:	3995                	jal	1c4 <vli_isZero>
     552:	c50d                	beqz	a0,57c <vli_mmod_fast+0x4c>
     554:	500104b7          	lui	s1,0x50010
     558:	0c048593          	add	a1,s1,192 # 500100c0 <curve_p>
     55c:	8522                	mv	a0,s0
     55e:	3b19                	jal	274 <vli_cmp>
     560:	10a04d63          	bgtz	a0,67a <vli_mmod_fast+0x14a>
     564:	85a2                	mv	a1,s0
     566:	542a                	lw	s0,168(sp)
     568:	50ba                	lw	ra,172(sp)
     56a:	549a                	lw	s1,164(sp)
     56c:	590a                	lw	s2,160(sp)
     56e:	4a6a                	lw	s4,152(sp)
     570:	4ada                	lw	s5,148(sp)
     572:	4b4a                	lw	s6,144(sp)
     574:	854e                	mv	a0,s3
     576:	49fa                	lw	s3,156(sp)
     578:	614d                	add	sp,sp,176
     57a:	b9d1                	j	24e <vli_set>
     57c:	1808                	add	a0,sp,48
     57e:	3935                	jal	1ba <vli_clear>
     580:	1088                	add	a0,sp,96
     582:	3925                	jal	1ba <vli_clear>
     584:	85ca                	mv	a1,s2
     586:	1808                	add	a0,sp,48
     588:	31d9                	jal	24e <vli_set>
     58a:	87ca                	mv	a5,s2
     58c:	870a                	mv	a4,sp
     58e:	8aa2                	mv	s5,s0
     590:	4481                	li	s1,0
     592:	4394                	lw	a3,0(a5)
     594:	c304                	sw	s1,0(a4)
     596:	c354                	sw	a3,4(a4)
     598:	43c4                	lw	s1,4(a5)
     59a:	07a1                	add	a5,a5,8
     59c:	0721                	add	a4,a4,8
     59e:	ff479ae3          	bne	a5,s4,592 <vli_mmod_fast+0x62>
     5a2:	182c                	add	a1,sp,56
     5a4:	860a                	mv	a2,sp
     5a6:	852e                	mv	a0,a1
     5a8:	3381                	jal	2e8 <vli_add>
     5aa:	009507b3          	add	a5,a0,s1
     5ae:	00a7b533          	sltu	a0,a5,a0
     5b2:	952e                	add	a0,a0,a1
     5b4:	008c                	add	a1,sp,64
     5b6:	d6aa                	sw	a0,108(sp)
     5b8:	864a                	mv	a2,s2
     5ba:	852e                	mv	a0,a1
     5bc:	d4be                	sw	a5,104(sp)
     5be:	332d                	jal	2e8 <vli_add>
     5c0:	daae                	sw	a1,116(sp)
     5c2:	180c                	add	a1,sp,48
     5c4:	d8aa                	sw	a0,112(sp)
     5c6:	860a                	mv	a2,sp
     5c8:	852e                	mv	a0,a1
     5ca:	3359                	jal	350 <vli_sub>
     5cc:	5706                	lw	a4,96(sp)
     5ce:	409704b3          	sub	s1,a4,s1
     5d2:	009737b3          	sltu	a5,a4,s1
     5d6:	5696                	lw	a3,100(sp)
     5d8:	40f687b3          	sub	a5,a3,a5
     5dc:	40a48533          	sub	a0,s1,a0
     5e0:	00a4b4b3          	sltu	s1,s1,a0
     5e4:	40b785b3          	sub	a1,a5,a1
     5e8:	8d85                	sub	a1,a1,s1
     5ea:	00b6e663          	bltu	a3,a1,5f6 <vli_mmod_fast+0xc6>
     5ee:	02d59563          	bne	a1,a3,618 <vli_mmod_fast+0xe8>
     5f2:	02a77363          	bgeu	a4,a0,618 <vli_mmod_fast+0xe8>
     5f6:	181c                	add	a5,sp,48
     5f8:	567d                	li	a2,-1
     5fa:	5f94                	lw	a3,56(a5)
     5fc:	5fd8                	lw	a4,60(a5)
     5fe:	fff68813          	add	a6,a3,-1
     602:	0016b693          	seqz	a3,a3
     606:	8f15                	sub	a4,a4,a3
     608:	0307ac23          	sw	a6,56(a5)
     60c:	dfd8                	sw	a4,60(a5)
     60e:	07a1                	add	a5,a5,8
     610:	00c81463          	bne	a6,a2,618 <vli_mmod_fast+0xe8>
     614:	fec703e3          	beq	a4,a2,5fa <vli_mmod_fast+0xca>
     618:	d0aa                	sw	a0,96(sp)
     61a:	854a                	mv	a0,s2
     61c:	d2ae                	sw	a1,100(sp)
     61e:	3e71                	jal	1ba <vli_clear>
     620:	180c                	add	a1,sp,48
     622:	04840313          	add	t1,s0,72
     626:	4701                	li	a4,0
     628:	4681                	li	a3,0
     62a:	000aa803          	lw	a6,0(s5)
     62e:	419c                	lw	a5,0(a1)
     630:	97c2                	add	a5,a5,a6
     632:	004aa883          	lw	a7,4(s5)
     636:	41c8                	lw	a0,4(a1)
     638:	0107b633          	sltu	a2,a5,a6
     63c:	9546                	add	a0,a0,a7
     63e:	962a                	add	a2,a2,a0
     640:	00e78533          	add	a0,a5,a4
     644:	00f537b3          	sltu	a5,a0,a5
     648:	9636                	add	a2,a2,a3
     64a:	97b2                	add	a5,a5,a2
     64c:	00a81463          	bne	a6,a0,654 <vli_mmod_fast+0x124>
     650:	00f88c63          	beq	a7,a5,668 <vli_mmod_fast+0x138>
     654:	4705                	li	a4,1
     656:	4681                	li	a3,0
     658:	0117e863          	bltu	a5,a7,668 <vli_mmod_fast+0x138>
     65c:	00f89463          	bne	a7,a5,664 <vli_mmod_fast+0x134>
     660:	01056463          	bltu	a0,a6,668 <vli_mmod_fast+0x138>
     664:	4701                	li	a4,0
     666:	4681                	li	a3,0
     668:	00aaa023          	sw	a0,0(s5)
     66c:	00faa223          	sw	a5,4(s5)
     670:	0aa1                	add	s5,s5,8
     672:	05a1                	add	a1,a1,8
     674:	fb531be3          	bne	t1,s5,62a <vli_mmod_fast+0xfa>
     678:	bdd9                	j	54e <vli_mmod_fast+0x1e>
     67a:	0c048613          	add	a2,s1,192
     67e:	85a2                	mv	a1,s0
     680:	8522                	mv	a0,s0
     682:	31f9                	jal	350 <vli_sub>
     684:	bdd1                	j	558 <vli_mmod_fast+0x28>

00000686 <vli_modMult_fast>:
     686:	7159                	add	sp,sp,-112
     688:	d4a2                	sw	s0,104(sp)
     68a:	842a                	mv	s0,a0
     68c:	850a                	mv	a0,sp
     68e:	d686                	sw	ra,108(sp)
     690:	3b15                	jal	3c4 <vli_mult>
     692:	858a                	mv	a1,sp
     694:	8522                	mv	a0,s0
     696:	3d69                	jal	530 <vli_mmod_fast>
     698:	50b6                	lw	ra,108(sp)
     69a:	5426                	lw	s0,104(sp)
     69c:	6165                	add	sp,sp,112
     69e:	8082                	ret

000006a0 <EccPoint_isZero>:
     6a0:	1141                	add	sp,sp,-16
     6a2:	c422                	sw	s0,8(sp)
     6a4:	c606                	sw	ra,12(sp)
     6a6:	842a                	mv	s0,a0
     6a8:	3e31                	jal	1c4 <vli_isZero>
     6aa:	c511                	beqz	a0,6b6 <EccPoint_isZero+0x16>
     6ac:	03040513          	add	a0,s0,48
     6b0:	3e11                	jal	1c4 <vli_isZero>
     6b2:	00a03533          	snez	a0,a0
     6b6:	40b2                	lw	ra,12(sp)
     6b8:	4422                	lw	s0,8(sp)
     6ba:	0141                	add	sp,sp,16
     6bc:	8082                	ret

000006be <ecc_bytes2native>:
     6be:	02858793          	add	a5,a1,40
     6c2:	0007c703          	lbu	a4,0(a5)
     6c6:	0017c683          	lbu	a3,1(a5)
     6ca:	0027c603          	lbu	a2,2(a5)
     6ce:	06c2                	sll	a3,a3,0x10
     6d0:	0762                	sll	a4,a4,0x18
     6d2:	8f55                	or	a4,a4,a3
     6d4:	0622                	sll	a2,a2,0x8
     6d6:	8f51                	or	a4,a4,a2
     6d8:	0047c603          	lbu	a2,4(a5)
     6dc:	0077c683          	lbu	a3,7(a5)
     6e0:	0662                	sll	a2,a2,0x18
     6e2:	8ed1                	or	a3,a3,a2
     6e4:	0057c603          	lbu	a2,5(a5)
     6e8:	0642                	sll	a2,a2,0x10
     6ea:	8ed1                	or	a3,a3,a2
     6ec:	0067c603          	lbu	a2,6(a5)
     6f0:	0037c883          	lbu	a7,3(a5)
     6f4:	0622                	sll	a2,a2,0x8
     6f6:	8ed1                	or	a3,a3,a2
     6f8:	01176733          	or	a4,a4,a7
     6fc:	883e                	mv	a6,a5
     6fe:	c114                	sw	a3,0(a0)
     700:	c158                	sw	a4,4(a0)
     702:	17e1                	add	a5,a5,-8
     704:	0521                	add	a0,a0,8
     706:	fb059ee3          	bne	a1,a6,6c2 <ecc_bytes2native+0x4>
     70a:	8082                	ret

0000070c <vli_modInv>:
     70c:	7151                	add	sp,sp,-240
     70e:	d1ca                	sw	s2,224(sp)
     710:	892a                	mv	s2,a0
     712:	852e                	mv	a0,a1
     714:	d5a2                	sw	s0,232(sp)
     716:	c62e                	sw	a1,12(sp)
     718:	d786                	sw	ra,236(sp)
     71a:	d3a6                	sw	s1,228(sp)
     71c:	cfce                	sw	s3,220(sp)
     71e:	cdd2                	sw	s4,216(sp)
     720:	8432                	mv	s0,a2
     722:	344d                	jal	1c4 <vli_isZero>
     724:	45b2                	lw	a1,12(sp)
     726:	c911                	beqz	a0,73a <vli_modInv+0x2e>
     728:	542e                	lw	s0,232(sp)
     72a:	50be                	lw	ra,236(sp)
     72c:	549e                	lw	s1,228(sp)
     72e:	49fe                	lw	s3,220(sp)
     730:	4a6e                	lw	s4,216(sp)
     732:	854a                	mv	a0,s2
     734:	590e                	lw	s2,224(sp)
     736:	616d                	add	sp,sp,240
     738:	b449                	j	1ba <vli_clear>
     73a:	0808                	add	a0,sp,16
     73c:	3e09                	jal	24e <vli_set>
     73e:	85a2                	mv	a1,s0
     740:	0088                	add	a0,sp,64
     742:	3631                	jal	24e <vli_set>
     744:	1888                	add	a0,sp,112
     746:	3c95                	jal	1ba <vli_clear>
     748:	4705                	li	a4,1
     74a:	4781                	li	a5,0
     74c:	1108                	add	a0,sp,160
     74e:	d8ba                	sw	a4,112(sp)
     750:	dabe                	sw	a5,116(sp)
     752:	800009b7          	lui	s3,0x80000
     756:	3495                	jal	1ba <vli_clear>
     758:	008c                	add	a1,sp,64
     75a:	0808                	add	a0,sp,16
     75c:	3e21                	jal	274 <vli_cmp>
     75e:	ed01                	bnez	a0,776 <vli_modInv+0x6a>
     760:	188c                	add	a1,sp,112
     762:	854a                	mv	a0,s2
     764:	34ed                	jal	24e <vli_set>
     766:	50be                	lw	ra,236(sp)
     768:	542e                	lw	s0,232(sp)
     76a:	549e                	lw	s1,228(sp)
     76c:	590e                	lw	s2,224(sp)
     76e:	49fe                	lw	s3,220(sp)
     770:	4a6e                	lw	s4,216(sp)
     772:	616d                	add	sp,sp,240
     774:	8082                	ret
     776:	47c2                	lw	a5,16(sp)
     778:	8b85                	and	a5,a5,1
     77a:	e79d                	bnez	a5,7a8 <vli_modInv+0x9c>
     77c:	0808                	add	a0,sp,16
     77e:	3e25                	jal	2b6 <vli_rshift1>
     780:	54c6                	lw	s1,112(sp)
     782:	8885                	and	s1,s1,1
     784:	4a01                	li	s4,0
     786:	c499                	beqz	s1,794 <vli_modInv+0x88>
     788:	188c                	add	a1,sp,112
     78a:	8622                	mv	a2,s0
     78c:	852e                	mv	a0,a1
     78e:	3ea9                	jal	2e8 <vli_add>
     790:	84aa                	mv	s1,a0
     792:	8a2e                	mv	s4,a1
     794:	1888                	add	a0,sp,112
     796:	0144e4b3          	or	s1,s1,s4
     79a:	3e31                	jal	2b6 <vli_rshift1>
     79c:	dcd5                	beqz	s1,758 <vli_modInv+0x4c>
     79e:	47fa                	lw	a5,156(sp)
     7a0:	0137e7b3          	or	a5,a5,s3
     7a4:	cf3e                	sw	a5,156(sp)
     7a6:	bf4d                	j	758 <vli_modInv+0x4c>
     7a8:	4786                	lw	a5,64(sp)
     7aa:	8b85                	and	a5,a5,1
     7ac:	eb85                	bnez	a5,7dc <mrac+0x1c>
     7ae:	0088                	add	a0,sp,64
     7b0:	3619                	jal	2b6 <vli_rshift1>
     7b2:	548a                	lw	s1,160(sp)
     7b4:	8885                	and	s1,s1,1
     7b6:	4a01                	li	s4,0
     7b8:	c499                	beqz	s1,7c6 <mrac+0x6>
     7ba:	110c                	add	a1,sp,160
     7bc:	8622                	mv	a2,s0
     7be:	852e                	mv	a0,a1
     7c0:	3625                	jal	2e8 <vli_add>
     7c2:	84aa                	mv	s1,a0
     7c4:	8a2e                	mv	s4,a1
     7c6:	1108                	add	a0,sp,160
     7c8:	0144e4b3          	or	s1,s1,s4
     7cc:	34ed                	jal	2b6 <vli_rshift1>
     7ce:	d4c9                	beqz	s1,758 <vli_modInv+0x4c>
     7d0:	47be                	lw	a5,204(sp)
     7d2:	80000737          	lui	a4,0x80000
     7d6:	8fd9                	or	a5,a5,a4
     7d8:	c7be                	sw	a5,204(sp)
     7da:	bfbd                	j	758 <vli_modInv+0x4c>
     7dc:	02a05663          	blez	a0,808 <mfdc+0xf>
     7e0:	080c                	add	a1,sp,16
     7e2:	0090                	add	a2,sp,64
     7e4:	852e                	mv	a0,a1
     7e6:	36ad                	jal	350 <vli_sub>
     7e8:	0808                	add	a0,sp,16
     7ea:	34f1                	jal	2b6 <vli_rshift1>
     7ec:	110c                	add	a1,sp,160
     7ee:	1888                	add	a0,sp,112
     7f0:	3451                	jal	274 <vli_cmp>
     7f2:	00055663          	bgez	a0,7fe <mfdc+0x5>
     7f6:	188c                	add	a1,sp,112
     7f8:	8622                	mv	a2,s0
     7fa:	852e                	mv	a0,a1
     7fc:	34f5                	jal	2e8 <vli_add>
     7fe:	188c                	add	a1,sp,112
     800:	1110                	add	a2,sp,160
     802:	852e                	mv	a0,a1
     804:	36b1                	jal	350 <vli_sub>
     806:	bfad                	j	780 <vli_modInv+0x74>
     808:	008c                	add	a1,sp,64
     80a:	0810                	add	a2,sp,16
     80c:	852e                	mv	a0,a1
     80e:	3689                	jal	350 <vli_sub>
     810:	0088                	add	a0,sp,64
     812:	3455                	jal	2b6 <vli_rshift1>
     814:	188c                	add	a1,sp,112
     816:	1108                	add	a0,sp,160
     818:	3cb1                	jal	274 <vli_cmp>
     81a:	00055663          	bgez	a0,826 <mfdc+0x2d>
     81e:	110c                	add	a1,sp,160
     820:	8622                	mv	a2,s0
     822:	852e                	mv	a0,a1
     824:	34d1                	jal	2e8 <vli_add>
     826:	110c                	add	a1,sp,160
     828:	1890                	add	a2,sp,112
     82a:	852e                	mv	a0,a1
     82c:	3615                	jal	350 <vli_sub>
     82e:	b751                	j	7b2 <vli_modInv+0xa6>

00000830 <vli_modSub.constprop.0>:
     830:	1141                	add	sp,sp,-16
     832:	c422                	sw	s0,8(sp)
     834:	c606                	sw	ra,12(sp)
     836:	842a                	mv	s0,a0
     838:	3e21                	jal	350 <vli_sub>
     83a:	8d4d                	or	a0,a0,a1
     83c:	c919                	beqz	a0,852 <vli_modSub.constprop.0+0x22>
     83e:	50010637          	lui	a2,0x50010
     842:	85a2                	mv	a1,s0
     844:	8522                	mv	a0,s0
     846:	4422                	lw	s0,8(sp)
     848:	40b2                	lw	ra,12(sp)
     84a:	0c060613          	add	a2,a2,192 # 500100c0 <curve_p>
     84e:	0141                	add	sp,sp,16
     850:	bc61                	j	2e8 <vli_add>
     852:	40b2                	lw	ra,12(sp)
     854:	4422                	lw	s0,8(sp)
     856:	0141                	add	sp,sp,16
     858:	8082                	ret

0000085a <vli_modSquare_fast>:
     85a:	7175                	add	sp,sp,-144
     85c:	c522                	sw	s0,136(sp)
     85e:	c326                	sw	s1,132(sp)
     860:	c706                	sw	ra,140(sp)
     862:	c14a                	sw	s2,128(sp)
     864:	dece                	sw	s3,124(sp)
     866:	dcd2                	sw	s4,120(sp)
     868:	dad6                	sw	s5,116(sp)
     86a:	d8da                	sw	s6,112(sp)
     86c:	d6de                	sw	s7,108(sp)
     86e:	8f8a                	mv	t6,sp
     870:	4881                	li	a7,0
     872:	4e81                	li	t4,0
     874:	4681                	li	a3,0
     876:	4801                	li	a6,0
     878:	4301                	li	t1,0
     87a:	4415                	li	s0,5
     87c:	44ad                	li	s1,11
     87e:	879a                	mv	a5,t1
     880:	00837363          	bgeu	t1,s0,886 <vli_modSquare_fast+0x2c>
     884:	4795                	li	a5,5
     886:	00530e13          	add	t3,t1,5
     88a:	82b6                	mv	t0,a3
     88c:	83c2                	mv	t2,a6
     88e:	86c6                	mv	a3,a7
     890:	8876                	mv	a6,t4
     892:	ffb78f13          	add	t5,a5,-5
     896:	40fe0e33          	sub	t3,t3,a5
     89a:	4881                	li	a7,0
     89c:	4e81                	li	t4,0
     89e:	03e37963          	bgeu	t1,t5,8d0 <vli_modSquare_fast+0x76>
     8a2:	005fa023          	sw	t0,0(t6)
     8a6:	007fa223          	sw	t2,4(t6)
     8aa:	0305                	add	t1,t1,1
     8ac:	0fa1                	add	t6,t6,8
     8ae:	fc9318e3          	bne	t1,s1,87e <vli_modSquare_fast+0x24>
     8b2:	858a                	mv	a1,sp
     8b4:	ccb6                	sw	a3,88(sp)
     8b6:	cec2                	sw	a6,92(sp)
     8b8:	39a5                	jal	530 <vli_mmod_fast>
     8ba:	40ba                	lw	ra,140(sp)
     8bc:	442a                	lw	s0,136(sp)
     8be:	449a                	lw	s1,132(sp)
     8c0:	490a                	lw	s2,128(sp)
     8c2:	59f6                	lw	s3,124(sp)
     8c4:	5a66                	lw	s4,120(sp)
     8c6:	5ad6                	lw	s5,116(sp)
     8c8:	5b46                	lw	s6,112(sp)
     8ca:	5bb6                	lw	s7,108(sp)
     8cc:	6149                	add	sp,sp,144
     8ce:	8082                	ret
     8d0:	fdee69e3          	bltu	t3,t5,8a2 <vli_modSquare_fast+0x48>
     8d4:	003f1793          	sll	a5,t5,0x3
     8d8:	97ae                	add	a5,a5,a1
     8da:	43d8                	lw	a4,4(a5)
     8dc:	0007aa83          	lw	s5,0(a5)
     8e0:	003e1793          	sll	a5,t3,0x3
     8e4:	97ae                	add	a5,a5,a1
     8e6:	0047a983          	lw	s3,4(a5)
     8ea:	4390                	lw	a2,0(a5)
     8ec:	033a8b33          	mul	s6,s5,s3
     8f0:	02c70bb3          	mul	s7,a4,a2
     8f4:	02cab7b3          	mulhu	a5,s5,a2
     8f8:	02ca8a33          	mul	s4,s5,a2
     8fc:	033abab3          	mulhu	s5,s5,s3
     900:	02c73633          	mulhu	a2,a4,a2
     904:	03370933          	mul	s2,a4,s3
     908:	9656                	add	a2,a2,s5
     90a:	033739b3          	mulhu	s3,a4,s3
     90e:	016b8733          	add	a4,s7,s6
     912:	01773bb3          	sltu	s7,a4,s7
     916:	973e                	add	a4,a4,a5
     918:	9bb2                	add	s7,s7,a2
     91a:	00f737b3          	sltu	a5,a4,a5
     91e:	97de                	add	a5,a5,s7
     920:	0157e663          	bltu	a5,s5,92c <vli_modSquare_fast+0xd2>
     924:	00fa9563          	bne	s5,a5,92e <vli_modSquare_fast+0xd4>
     928:	01677363          	bgeu	a4,s6,92e <vli_modSquare_fast+0xd4>
     92c:	0985                	add	s3,s3,1 # 80000001 <_tbs_der_store_end+0x2ffe0fe1>
     92e:	01278633          	add	a2,a5,s2
     932:	00f637b3          	sltu	a5,a2,a5
     936:	97ce                	add	a5,a5,s3
     938:	03cf7963          	bgeu	t5,t3,96a <vli_modSquare_fast+0x110>
     93c:	01f7d913          	srl	s2,a5,0x1f
     940:	9946                	add	s2,s2,a7
     942:	011939b3          	sltu	s3,s2,a7
     946:	0786                	sll	a5,a5,0x1
     948:	88ca                	mv	a7,s2
     94a:	01f65913          	srl	s2,a2,0x1f
     94e:	9ece                	add	t4,t4,s3
     950:	0606                	sll	a2,a2,0x1
     952:	01f75993          	srl	s3,a4,0x1f
     956:	00f967b3          	or	a5,s2,a5
     95a:	0706                	sll	a4,a4,0x1
     95c:	01fa5913          	srl	s2,s4,0x1f
     960:	01366633          	or	a2,a2,s3
     964:	00e96733          	or	a4,s2,a4
     968:	0a06                	sll	s4,s4,0x1
     96a:	9a16                	add	s4,s4,t0
     96c:	005a3933          	sltu	s2,s4,t0
     970:	971e                	add	a4,a4,t2
     972:	974a                	add	a4,a4,s2
     974:	00c68933          	add	s2,a3,a2
     978:	00d936b3          	sltu	a3,s2,a3
     97c:	983e                	add	a6,a6,a5
     97e:	9836                	add	a6,a6,a3
     980:	4685                	li	a3,1
     982:	00776763          	bltu	a4,t2,990 <vli_modSquare_fast+0x136>
     986:	00e39463          	bne	t2,a4,98e <vli_modSquare_fast+0x134>
     98a:	005a6363          	bltu	s4,t0,990 <vli_modSquare_fast+0x136>
     98e:	4681                	li	a3,0
     990:	96ca                	add	a3,a3,s2
     992:	0126b933          	sltu	s2,a3,s2
     996:	984a                	add	a6,a6,s2
     998:	4285                	li	t0,1
     99a:	00f86763          	bltu	a6,a5,9a8 <vli_modSquare_fast+0x14e>
     99e:	01079463          	bne	a5,a6,9a6 <vli_modSquare_fast+0x14c>
     9a2:	00c6e363          	bltu	a3,a2,9a8 <vli_modSquare_fast+0x14e>
     9a6:	4281                	li	t0,0
     9a8:	005887b3          	add	a5,a7,t0
     9ac:	0117b633          	sltu	a2,a5,a7
     9b0:	9eb2                	add	t4,t4,a2
     9b2:	88be                	mv	a7,a5
     9b4:	0f05                	add	t5,t5,1
     9b6:	1e7d                	add	t3,t3,-1
     9b8:	82d2                	mv	t0,s4
     9ba:	83ba                	mv	t2,a4
     9bc:	b5cd                	j	89e <vli_modSquare_fast+0x44>

000009be <EccPoint_double_jacobian>:
     9be:	7119                	add	sp,sp,-128
     9c0:	dca2                	sw	s0,120(sp)
     9c2:	842a                	mv	s0,a0
     9c4:	8532                	mv	a0,a2
     9c6:	daa6                	sw	s1,116(sp)
     9c8:	d8ca                	sw	s2,112(sp)
     9ca:	de86                	sw	ra,124(sp)
     9cc:	d6ce                	sw	s3,108(sp)
     9ce:	892e                	mv	s2,a1
     9d0:	84b2                	mv	s1,a2
     9d2:	ff2ff0ef          	jal	1c4 <vli_isZero>
     9d6:	0c051a63          	bnez	a0,aaa <EccPoint_double_jacobian+0xec>
     9da:	85ca                	mv	a1,s2
     9dc:	850a                	mv	a0,sp
     9de:	3db5                	jal	85a <vli_modSquare_fast>
     9e0:	860a                	mv	a2,sp
     9e2:	85a2                	mv	a1,s0
     9e4:	1808                	add	a0,sp,48
     9e6:	3145                	jal	686 <vli_modMult_fast>
     9e8:	858a                	mv	a1,sp
     9ea:	850a                	mv	a0,sp
     9ec:	35bd                	jal	85a <vli_modSquare_fast>
     9ee:	8626                	mv	a2,s1
     9f0:	85ca                	mv	a1,s2
     9f2:	854a                	mv	a0,s2
     9f4:	3949                	jal	686 <vli_modMult_fast>
     9f6:	85a6                	mv	a1,s1
     9f8:	8526                	mv	a0,s1
     9fa:	3585                	jal	85a <vli_modSquare_fast>
     9fc:	500109b7          	lui	s3,0x50010
     a00:	0c098693          	add	a3,s3,192 # 500100c0 <curve_p>
     a04:	8626                	mv	a2,s1
     a06:	85a2                	mv	a1,s0
     a08:	8522                	mv	a0,s0
     a0a:	3cc5                	jal	4fa <vli_modAdd>
     a0c:	0c098693          	add	a3,s3,192
     a10:	8626                	mv	a2,s1
     a12:	85a6                	mv	a1,s1
     a14:	8526                	mv	a0,s1
     a16:	34d5                	jal	4fa <vli_modAdd>
     a18:	8626                	mv	a2,s1
     a1a:	85a2                	mv	a1,s0
     a1c:	8526                	mv	a0,s1
     a1e:	3d09                	jal	830 <vli_modSub.constprop.0>
     a20:	8626                	mv	a2,s1
     a22:	85a2                	mv	a1,s0
     a24:	8522                	mv	a0,s0
     a26:	3185                	jal	686 <vli_modMult_fast>
     a28:	0c098693          	add	a3,s3,192
     a2c:	8622                	mv	a2,s0
     a2e:	85a2                	mv	a1,s0
     a30:	8526                	mv	a0,s1
     a32:	34e1                	jal	4fa <vli_modAdd>
     a34:	0c098693          	add	a3,s3,192
     a38:	8626                	mv	a2,s1
     a3a:	85a2                	mv	a1,s0
     a3c:	8522                	mv	a0,s0
     a3e:	3c75                	jal	4fa <vli_modAdd>
     a40:	401c                	lw	a5,0(s0)
     a42:	8b85                	and	a5,a5,1
     a44:	cbb5                	beqz	a5,ab8 <EccPoint_double_jacobian+0xfa>
     a46:	0c098613          	add	a2,s3,192
     a4a:	85a2                	mv	a1,s0
     a4c:	8522                	mv	a0,s0
     a4e:	89bff0ef          	jal	2e8 <vli_add>
     a52:	89aa                	mv	s3,a0
     a54:	8522                	mv	a0,s0
     a56:	861ff0ef          	jal	2b6 <vli_rshift1>
     a5a:	545c                	lw	a5,44(s0)
     a5c:	09fe                	sll	s3,s3,0x1f
     a5e:	0137e7b3          	or	a5,a5,s3
     a62:	d45c                	sw	a5,44(s0)
     a64:	85a2                	mv	a1,s0
     a66:	8526                	mv	a0,s1
     a68:	3bcd                	jal	85a <vli_modSquare_fast>
     a6a:	1810                	add	a2,sp,48
     a6c:	85a6                	mv	a1,s1
     a6e:	8526                	mv	a0,s1
     a70:	33c1                	jal	830 <vli_modSub.constprop.0>
     a72:	1810                	add	a2,sp,48
     a74:	85a6                	mv	a1,s1
     a76:	8526                	mv	a0,s1
     a78:	3b65                	jal	830 <vli_modSub.constprop.0>
     a7a:	180c                	add	a1,sp,48
     a7c:	852e                	mv	a0,a1
     a7e:	8626                	mv	a2,s1
     a80:	3b45                	jal	830 <vli_modSub.constprop.0>
     a82:	1810                	add	a2,sp,48
     a84:	85a2                	mv	a1,s0
     a86:	8522                	mv	a0,s0
     a88:	3efd                	jal	686 <vli_modMult_fast>
     a8a:	860a                	mv	a2,sp
     a8c:	85a2                	mv	a1,s0
     a8e:	850a                	mv	a0,sp
     a90:	3345                	jal	830 <vli_modSub.constprop.0>
     a92:	85a6                	mv	a1,s1
     a94:	8522                	mv	a0,s0
     a96:	fb8ff0ef          	jal	24e <vli_set>
     a9a:	85ca                	mv	a1,s2
     a9c:	8526                	mv	a0,s1
     a9e:	fb0ff0ef          	jal	24e <vli_set>
     aa2:	858a                	mv	a1,sp
     aa4:	854a                	mv	a0,s2
     aa6:	fa8ff0ef          	jal	24e <vli_set>
     aaa:	50f6                	lw	ra,124(sp)
     aac:	5466                	lw	s0,120(sp)
     aae:	54d6                	lw	s1,116(sp)
     ab0:	5946                	lw	s2,112(sp)
     ab2:	59b6                	lw	s3,108(sp)
     ab4:	6109                	add	sp,sp,128
     ab6:	8082                	ret
     ab8:	8522                	mv	a0,s0
     aba:	ffcff0ef          	jal	2b6 <vli_rshift1>
     abe:	b75d                	j	a64 <EccPoint_double_jacobian+0xa6>

00000ac0 <apply_z>:
     ac0:	7139                	add	sp,sp,-64
     ac2:	da26                	sw	s1,52(sp)
     ac4:	d84a                	sw	s2,48(sp)
     ac6:	84ae                	mv	s1,a1
     ac8:	892a                	mv	s2,a0
     aca:	85b2                	mv	a1,a2
     acc:	850a                	mv	a0,sp
     ace:	de06                	sw	ra,60(sp)
     ad0:	dc22                	sw	s0,56(sp)
     ad2:	8432                	mv	s0,a2
     ad4:	3359                	jal	85a <vli_modSquare_fast>
     ad6:	860a                	mv	a2,sp
     ad8:	85ca                	mv	a1,s2
     ada:	854a                	mv	a0,s2
     adc:	366d                	jal	686 <vli_modMult_fast>
     ade:	8622                	mv	a2,s0
     ae0:	858a                	mv	a1,sp
     ae2:	850a                	mv	a0,sp
     ae4:	364d                	jal	686 <vli_modMult_fast>
     ae6:	860a                	mv	a2,sp
     ae8:	85a6                	mv	a1,s1
     aea:	8526                	mv	a0,s1
     aec:	3e69                	jal	686 <vli_modMult_fast>
     aee:	50f2                	lw	ra,60(sp)
     af0:	5462                	lw	s0,56(sp)
     af2:	54d2                	lw	s1,52(sp)
     af4:	5942                	lw	s2,48(sp)
     af6:	6121                	add	sp,sp,64
     af8:	8082                	ret

00000afa <XYcZ_add>:
     afa:	715d                	add	sp,sp,-80
     afc:	c4a2                	sw	s0,72(sp)
     afe:	8432                	mv	s0,a2
     b00:	c0ca                	sw	s2,64(sp)
     b02:	de4e                	sw	s3,60(sp)
     b04:	892a                	mv	s2,a0
     b06:	89ae                	mv	s3,a1
     b08:	862a                	mv	a2,a0
     b0a:	85a2                	mv	a1,s0
     b0c:	850a                	mv	a0,sp
     b0e:	c686                	sw	ra,76(sp)
     b10:	c2a6                	sw	s1,68(sp)
     b12:	84b6                	mv	s1,a3
     b14:	3b31                	jal	830 <vli_modSub.constprop.0>
     b16:	858a                	mv	a1,sp
     b18:	850a                	mv	a0,sp
     b1a:	3381                	jal	85a <vli_modSquare_fast>
     b1c:	860a                	mv	a2,sp
     b1e:	85ca                	mv	a1,s2
     b20:	854a                	mv	a0,s2
     b22:	3695                	jal	686 <vli_modMult_fast>
     b24:	860a                	mv	a2,sp
     b26:	85a2                	mv	a1,s0
     b28:	8522                	mv	a0,s0
     b2a:	3eb1                	jal	686 <vli_modMult_fast>
     b2c:	864e                	mv	a2,s3
     b2e:	85a6                	mv	a1,s1
     b30:	8526                	mv	a0,s1
     b32:	39fd                	jal	830 <vli_modSub.constprop.0>
     b34:	85a6                	mv	a1,s1
     b36:	850a                	mv	a0,sp
     b38:	330d                	jal	85a <vli_modSquare_fast>
     b3a:	864a                	mv	a2,s2
     b3c:	858a                	mv	a1,sp
     b3e:	850a                	mv	a0,sp
     b40:	39c5                	jal	830 <vli_modSub.constprop.0>
     b42:	8622                	mv	a2,s0
     b44:	858a                	mv	a1,sp
     b46:	850a                	mv	a0,sp
     b48:	31e5                	jal	830 <vli_modSub.constprop.0>
     b4a:	864a                	mv	a2,s2
     b4c:	85a2                	mv	a1,s0
     b4e:	8522                	mv	a0,s0
     b50:	31c5                	jal	830 <vli_modSub.constprop.0>
     b52:	8622                	mv	a2,s0
     b54:	85ce                	mv	a1,s3
     b56:	854e                	mv	a0,s3
     b58:	363d                	jal	686 <vli_modMult_fast>
     b5a:	860a                	mv	a2,sp
     b5c:	85ca                	mv	a1,s2
     b5e:	8522                	mv	a0,s0
     b60:	39c1                	jal	830 <vli_modSub.constprop.0>
     b62:	8622                	mv	a2,s0
     b64:	85a6                	mv	a1,s1
     b66:	8526                	mv	a0,s1
     b68:	3e39                	jal	686 <vli_modMult_fast>
     b6a:	864e                	mv	a2,s3
     b6c:	85a6                	mv	a1,s1
     b6e:	8526                	mv	a0,s1
     b70:	31c1                	jal	830 <vli_modSub.constprop.0>
     b72:	858a                	mv	a1,sp
     b74:	8522                	mv	a0,s0
     b76:	ed8ff0ef          	jal	24e <vli_set>
     b7a:	40b6                	lw	ra,76(sp)
     b7c:	4426                	lw	s0,72(sp)
     b7e:	4496                	lw	s1,68(sp)
     b80:	4906                	lw	s2,64(sp)
     b82:	59f2                	lw	s3,60(sp)
     b84:	6161                	add	sp,sp,80
     b86:	8082                	ret

00000b88 <XYcZ_addC>:
     b88:	7171                	add	sp,sp,-176
     b8a:	d522                	sw	s0,168(sp)
     b8c:	8432                	mv	s0,a2
     b8e:	d326                	sw	s1,164(sp)
     b90:	cf4e                	sw	s3,156(sp)
     b92:	84aa                	mv	s1,a0
     b94:	89ae                	mv	s3,a1
     b96:	862a                	mv	a2,a0
     b98:	85a2                	mv	a1,s0
     b9a:	850a                	mv	a0,sp
     b9c:	d706                	sw	ra,172(sp)
     b9e:	d14a                	sw	s2,160(sp)
     ba0:	cd52                	sw	s4,152(sp)
     ba2:	8936                	mv	s2,a3
     ba4:	3171                	jal	830 <vli_modSub.constprop.0>
     ba6:	858a                	mv	a1,sp
     ba8:	850a                	mv	a0,sp
     baa:	3945                	jal	85a <vli_modSquare_fast>
     bac:	860a                	mv	a2,sp
     bae:	85a6                	mv	a1,s1
     bb0:	8526                	mv	a0,s1
     bb2:	3cd1                	jal	686 <vli_modMult_fast>
     bb4:	860a                	mv	a2,sp
     bb6:	85a2                	mv	a1,s0
     bb8:	8522                	mv	a0,s0
     bba:	34f1                	jal	686 <vli_modMult_fast>
     bbc:	50010a37          	lui	s4,0x50010
     bc0:	0c0a0693          	add	a3,s4,192 # 500100c0 <curve_p>
     bc4:	864e                	mv	a2,s3
     bc6:	85ca                	mv	a1,s2
     bc8:	850a                	mv	a0,sp
     bca:	931ff0ef          	jal	4fa <vli_modAdd>
     bce:	864e                	mv	a2,s3
     bd0:	85ca                	mv	a1,s2
     bd2:	854a                	mv	a0,s2
     bd4:	39b1                	jal	830 <vli_modSub.constprop.0>
     bd6:	8626                	mv	a2,s1
     bd8:	85a2                	mv	a1,s0
     bda:	1808                	add	a0,sp,48
     bdc:	3991                	jal	830 <vli_modSub.constprop.0>
     bde:	1810                	add	a2,sp,48
     be0:	85ce                	mv	a1,s3
     be2:	854e                	mv	a0,s3
     be4:	344d                	jal	686 <vli_modMult_fast>
     be6:	0c0a0693          	add	a3,s4,192
     bea:	8622                	mv	a2,s0
     bec:	85a6                	mv	a1,s1
     bee:	1808                	add	a0,sp,48
     bf0:	90bff0ef          	jal	4fa <vli_modAdd>
     bf4:	85ca                	mv	a1,s2
     bf6:	8522                	mv	a0,s0
     bf8:	318d                	jal	85a <vli_modSquare_fast>
     bfa:	1810                	add	a2,sp,48
     bfc:	85a2                	mv	a1,s0
     bfe:	8522                	mv	a0,s0
     c00:	3905                	jal	830 <vli_modSub.constprop.0>
     c02:	8622                	mv	a2,s0
     c04:	85a6                	mv	a1,s1
     c06:	1088                	add	a0,sp,96
     c08:	3125                	jal	830 <vli_modSub.constprop.0>
     c0a:	1090                	add	a2,sp,96
     c0c:	85ca                	mv	a1,s2
     c0e:	854a                	mv	a0,s2
     c10:	3c9d                	jal	686 <vli_modMult_fast>
     c12:	864e                	mv	a2,s3
     c14:	85ca                	mv	a1,s2
     c16:	854a                	mv	a0,s2
     c18:	3921                	jal	830 <vli_modSub.constprop.0>
     c1a:	858a                	mv	a1,sp
     c1c:	1088                	add	a0,sp,96
     c1e:	3935                	jal	85a <vli_modSquare_fast>
     c20:	108c                	add	a1,sp,96
     c22:	1810                	add	a2,sp,48
     c24:	852e                	mv	a0,a1
     c26:	3129                	jal	830 <vli_modSub.constprop.0>
     c28:	8626                	mv	a2,s1
     c2a:	108c                	add	a1,sp,96
     c2c:	1808                	add	a0,sp,48
     c2e:	3109                	jal	830 <vli_modSub.constprop.0>
     c30:	180c                	add	a1,sp,48
     c32:	860a                	mv	a2,sp
     c34:	852e                	mv	a0,a1
     c36:	a51ff0ef          	jal	686 <vli_modMult_fast>
     c3a:	864e                	mv	a2,s3
     c3c:	180c                	add	a1,sp,48
     c3e:	854e                	mv	a0,s3
     c40:	3ec5                	jal	830 <vli_modSub.constprop.0>
     c42:	108c                	add	a1,sp,96
     c44:	8526                	mv	a0,s1
     c46:	e08ff0ef          	jal	24e <vli_set>
     c4a:	50ba                	lw	ra,172(sp)
     c4c:	542a                	lw	s0,168(sp)
     c4e:	549a                	lw	s1,164(sp)
     c50:	590a                	lw	s2,160(sp)
     c52:	49fa                	lw	s3,156(sp)
     c54:	4a6a                	lw	s4,152(sp)
     c56:	614d                	add	sp,sp,176
     c58:	8082                	ret

00000c5a <EccPoint_mult>:
     c5a:	712d                	add	sp,sp,-288
     c5c:	11312623          	sw	s3,268(sp)
     c60:	11412423          	sw	s4,264(sp)
     c64:	89aa                	mv	s3,a0
     c66:	8a2e                	mv	s4,a1
     c68:	1088                	add	a0,sp,96
     c6a:	10112e23          	sw	ra,284(sp)
     c6e:	10812c23          	sw	s0,280(sp)
     c72:	10912a23          	sw	s1,276(sp)
     c76:	8436                	mv	s0,a3
     c78:	11212823          	sw	s2,272(sp)
     c7c:	11512223          	sw	s5,260(sp)
     c80:	11612023          	sw	s6,256(sp)
     c84:	dfde                	sw	s7,252(sp)
     c86:	8b32                	mv	s6,a2
     c88:	dde2                	sw	s8,248(sp)
     c8a:	dbe6                	sw	s9,244(sp)
     c8c:	d9ea                	sw	s10,240(sp)
     c8e:	030a0a93          	add	s5,s4,48
     c92:	dbcff0ef          	jal	24e <vli_set>
     c96:	85d6                	mv	a1,s5
     c98:	0188                	add	a0,sp,192
     c9a:	db4ff0ef          	jal	24e <vli_set>
     c9e:	1804                	add	s1,sp,48
     ca0:	108c                	add	a1,sp,96
     ca2:	8526                	mv	a0,s1
     ca4:	daaff0ef          	jal	24e <vli_set>
     ca8:	09010913          	add	s2,sp,144
     cac:	018c                	add	a1,sp,192
     cae:	854a                	mv	a0,s2
     cb0:	d9eff0ef          	jal	24e <vli_set>
     cb4:	850a                	mv	a0,sp
     cb6:	d04ff0ef          	jal	1ba <vli_clear>
     cba:	4705                	li	a4,1
     cbc:	4781                	li	a5,0
     cbe:	c03a                	sw	a4,0(sp)
     cc0:	c23e                	sw	a5,4(sp)
     cc2:	c409                	beqz	s0,ccc <EccPoint_mult+0x72>
     cc4:	85a2                	mv	a1,s0
     cc6:	850a                	mv	a0,sp
     cc8:	d86ff0ef          	jal	24e <vli_set>
     ccc:	860a                	mv	a2,sp
     cce:	018c                	add	a1,sp,192
     cd0:	1088                	add	a0,sp,96
     cd2:	33fd                	jal	ac0 <apply_z>
     cd4:	860a                	mv	a2,sp
     cd6:	018c                	add	a1,sp,192
     cd8:	1088                	add	a0,sp,96
     cda:	31d5                	jal	9be <EccPoint_double_jacobian>
     cdc:	860a                	mv	a2,sp
     cde:	85ca                	mv	a1,s2
     ce0:	8526                	mv	a0,s1
     ce2:	3bf9                	jal	ac0 <apply_z>
     ce4:	855a                	mv	a0,s6
     ce6:	d24ff0ef          	jal	20a <vli_numBits>
     cea:	ffe50c93          	add	s9,a0,-2
     cee:	0b904f63          	bgtz	s9,dac <EccPoint_mult+0x152>
     cf2:	000b2403          	lw	s0,0(s6)
     cf6:	8805                	and	s0,s0,1
     cf8:	40800b33          	neg	s6,s0
     cfc:	147d                	add	s0,s0,-1
     cfe:	030b7b13          	and	s6,s6,48
     d02:	03047413          	and	s0,s0,48
     d06:	01648bb3          	add	s7,s1,s6
     d0a:	00848c33          	add	s8,s1,s0
     d0e:	9b4a                	add	s6,s6,s2
     d10:	944a                	add	s0,s0,s2
     d12:	86a2                	mv	a3,s0
     d14:	8662                	mv	a2,s8
     d16:	85da                	mv	a1,s6
     d18:	855e                	mv	a0,s7
     d1a:	35bd                	jal	b88 <XYcZ_addC>
     d1c:	8626                	mv	a2,s1
     d1e:	108c                	add	a1,sp,96
     d20:	850a                	mv	a0,sp
     d22:	3639                	jal	830 <vli_modSub.constprop.0>
     d24:	865a                	mv	a2,s6
     d26:	858a                	mv	a1,sp
     d28:	850a                	mv	a0,sp
     d2a:	95dff0ef          	jal	686 <vli_modMult_fast>
     d2e:	8652                	mv	a2,s4
     d30:	858a                	mv	a1,sp
     d32:	850a                	mv	a0,sp
     d34:	953ff0ef          	jal	686 <vli_modMult_fast>
     d38:	50010637          	lui	a2,0x50010
     d3c:	858a                	mv	a1,sp
     d3e:	850a                	mv	a0,sp
     d40:	0c060613          	add	a2,a2,192 # 500100c0 <curve_p>
     d44:	9c9ff0ef          	jal	70c <vli_modInv>
     d48:	8656                	mv	a2,s5
     d4a:	858a                	mv	a1,sp
     d4c:	850a                	mv	a0,sp
     d4e:	939ff0ef          	jal	686 <vli_modMult_fast>
     d52:	865e                	mv	a2,s7
     d54:	858a                	mv	a1,sp
     d56:	850a                	mv	a0,sp
     d58:	92fff0ef          	jal	686 <vli_modMult_fast>
     d5c:	86da                	mv	a3,s6
     d5e:	865e                	mv	a2,s7
     d60:	85a2                	mv	a1,s0
     d62:	8562                	mv	a0,s8
     d64:	3b59                	jal	afa <XYcZ_add>
     d66:	860a                	mv	a2,sp
     d68:	85ca                	mv	a1,s2
     d6a:	8526                	mv	a0,s1
     d6c:	3b91                	jal	ac0 <apply_z>
     d6e:	85a6                	mv	a1,s1
     d70:	854e                	mv	a0,s3
     d72:	cdcff0ef          	jal	24e <vli_set>
     d76:	85ca                	mv	a1,s2
     d78:	03098513          	add	a0,s3,48
     d7c:	cd2ff0ef          	jal	24e <vli_set>
     d80:	11c12083          	lw	ra,284(sp)
     d84:	11812403          	lw	s0,280(sp)
     d88:	11412483          	lw	s1,276(sp)
     d8c:	11012903          	lw	s2,272(sp)
     d90:	10c12983          	lw	s3,268(sp)
     d94:	10812a03          	lw	s4,264(sp)
     d98:	10412a83          	lw	s5,260(sp)
     d9c:	10012b03          	lw	s6,256(sp)
     da0:	5bfe                	lw	s7,252(sp)
     da2:	5c6e                	lw	s8,248(sp)
     da4:	5cde                	lw	s9,244(sp)
     da6:	5d4e                	lw	s10,240(sp)
     da8:	6115                	add	sp,sp,288
     daa:	8082                	ret
     dac:	85e6                	mv	a1,s9
     dae:	855a                	mv	a0,s6
     db0:	c2eff0ef          	jal	1de <vli_testBit>
     db4:	00b567b3          	or	a5,a0,a1
     db8:	0017b693          	seqz	a3,a5
     dbc:	40d006b3          	neg	a3,a3
     dc0:	fd06f693          	and	a3,a3,-48
     dc4:	03068693          	add	a3,a3,48
     dc8:	00d48bb3          	add	s7,s1,a3
     dcc:	00d90c33          	add	s8,s2,a3
     dd0:	00f036b3          	snez	a3,a5
     dd4:	40d006b3          	neg	a3,a3
     dd8:	fd06f693          	and	a3,a3,-48
     ddc:	03068693          	add	a3,a3,48
     de0:	00d48d33          	add	s10,s1,a3
     de4:	00d90433          	add	s0,s2,a3
     de8:	86a2                	mv	a3,s0
     dea:	866a                	mv	a2,s10
     dec:	85e2                	mv	a1,s8
     dee:	855e                	mv	a0,s7
     df0:	3b61                	jal	b88 <XYcZ_addC>
     df2:	86e2                	mv	a3,s8
     df4:	865e                	mv	a2,s7
     df6:	85a2                	mv	a1,s0
     df8:	856a                	mv	a0,s10
     dfa:	3301                	jal	afa <XYcZ_add>
     dfc:	1cfd                	add	s9,s9,-1
     dfe:	bdc5                	j	cee <EccPoint_mult+0x94>

00000e00 <vli_modMult.constprop.0>:
     e00:	716d                	add	sp,sp,-272
     e02:	d9da                	sw	s6,240(sp)
     e04:	50010b37          	lui	s6,0x50010
     e08:	dbd6                	sw	s5,244(sp)
     e0a:	8aaa                	mv	s5,a0
     e0c:	000b0513          	mv	a0,s6
     e10:	10112623          	sw	ra,268(sp)
     e14:	10812423          	sw	s0,264(sp)
     e18:	10912223          	sw	s1,260(sp)
     e1c:	c62e                	sw	a1,12(sp)
     e1e:	c032                	sw	a2,0(sp)
     e20:	11212023          	sw	s2,256(sp)
     e24:	dfce                	sw	s3,252(sp)
     e26:	ddd2                	sw	s4,248(sp)
     e28:	d7de                	sw	s7,236(sp)
     e2a:	d5e2                	sw	s8,232(sp)
     e2c:	d3e6                	sw	s9,228(sp)
     e2e:	d1ea                	sw	s10,224(sp)
     e30:	cfee                	sw	s11,220(sp)
     e32:	bd8ff0ef          	jal	20a <vli_numBits>
     e36:	4602                	lw	a2,0(sp)
     e38:	45b2                	lw	a1,12(sp)
     e3a:	84aa                	mv	s1,a0
     e3c:	0808                	add	a0,sp,16
     e3e:	d86ff0ef          	jal	3c4 <vli_mult>
     e42:	0088                	add	a0,sp,64
     e44:	bc6ff0ef          	jal	20a <vli_numBits>
     e48:	18050413          	add	s0,a0,384
     e4c:	e509                	bnez	a0,e56 <vli_modMult.constprop.0+0x56>
     e4e:	0808                	add	a0,sp,16
     e50:	bbaff0ef          	jal	20a <vli_numBits>
     e54:	842a                	mv	s0,a0
     e56:	02947963          	bgeu	s0,s1,e88 <vli_modMult.constprop.0+0x88>
     e5a:	080c                	add	a1,sp,16
     e5c:	8556                	mv	a0,s5
     e5e:	bf0ff0ef          	jal	24e <vli_set>
     e62:	10c12083          	lw	ra,268(sp)
     e66:	10812403          	lw	s0,264(sp)
     e6a:	10412483          	lw	s1,260(sp)
     e6e:	10012903          	lw	s2,256(sp)
     e72:	59fe                	lw	s3,252(sp)
     e74:	5a6e                	lw	s4,248(sp)
     e76:	5ade                	lw	s5,244(sp)
     e78:	5b4e                	lw	s6,240(sp)
     e7a:	5bbe                	lw	s7,236(sp)
     e7c:	5c2e                	lw	s8,232(sp)
     e7e:	5c9e                	lw	s9,228(sp)
     e80:	5d0e                	lw	s10,224(sp)
     e82:	4dfe                	lw	s11,220(sp)
     e84:	6151                	add	sp,sp,272
     e86:	8082                	ret
     e88:	07010b93          	add	s7,sp,112
     e8c:	855e                	mv	a0,s7
     e8e:	b2cff0ef          	jal	1ba <vli_clear>
     e92:	409404b3          	sub	s1,s0,s1
     e96:	0064da13          	srl	s4,s1,0x6
     e9a:	1108                	add	a0,sp,160
     e9c:	03f4f493          	and	s1,s1,63
     ea0:	b1aff0ef          	jal	1ba <vli_clear>
     ea4:	003a1d93          	sll	s11,s4,0x3
     ea8:	0e048463          	beqz	s1,f90 <vli_modMult.constprop.0+0x190>
     eac:	04000c93          	li	s9,64
     eb0:	0a19                	add	s4,s4,6
     eb2:	4c01                	li	s8,0
     eb4:	4801                	li	a6,0
     eb6:	4981                	li	s3,0
     eb8:	409c8cb3          	sub	s9,s9,s1
     ebc:	03000913          	li	s2,48
     ec0:	000b0793          	mv	a5,s6
     ec4:	97e2                	add	a5,a5,s8
     ec6:	c642                	sw	a6,12(sp)
     ec8:	0047a803          	lw	a6,4(a5)
     ecc:	439c                	lw	a5,0(a5)
     ece:	8626                	mv	a2,s1
     ed0:	853e                	mv	a0,a5
     ed2:	85c2                	mv	a1,a6
     ed4:	c03e                	sw	a5,0(sp)
     ed6:	c242                	sw	a6,4(sp)
     ed8:	5f6020ef          	jal	34ce <__ashldi3>
     edc:	4832                	lw	a6,12(sp)
     ede:	01bc0d33          	add	s10,s8,s11
     ee2:	01056533          	or	a0,a0,a6
     ee6:	0135e5b3          	or	a1,a1,s3
     eea:	9d5e                	add	s10,s10,s7
     eec:	00ad2023          	sw	a0,0(s10)
     ef0:	00bd2223          	sw	a1,4(s10)
     ef4:	8666                	mv	a2,s9
     ef6:	4502                	lw	a0,0(sp)
     ef8:	4592                	lw	a1,4(sp)
     efa:	5ac020ef          	jal	34a6 <__lshrdi3>
     efe:	0c21                	add	s8,s8,8
     f00:	882a                	mv	a6,a0
     f02:	89ae                	mv	s3,a1
     f04:	fb2c1ee3          	bne	s8,s2,ec0 <vli_modMult.constprop.0+0xc0>
     f08:	003a1793          	sll	a5,s4,0x3
     f0c:	97de                	add	a5,a5,s7
     f0e:	c388                	sw	a0,0(a5)
     f10:	c3cc                	sw	a1,4(a5)
     f12:	8556                	mv	a0,s5
     f14:	aa6ff0ef          	jal	1ba <vli_clear>
     f18:	4705                	li	a4,1
     f1a:	4781                	li	a5,0
     f1c:	00eaa023          	sw	a4,0(s5)
     f20:	00faa223          	sw	a5,4(s5)
     f24:	18000913          	li	s2,384
     f28:	00896963          	bltu	s2,s0,f3a <vli_modMult.constprop.0+0x13a>
     f2c:	000b0593          	mv	a1,s6
     f30:	855e                	mv	a0,s7
     f32:	b42ff0ef          	jal	274 <vli_cmp>
     f36:	f20542e3          	bltz	a0,e5a <vli_modMult.constprop.0+0x5a>
     f3a:	008c                	add	a1,sp,64
     f3c:	1108                	add	a0,sp,160
     f3e:	b36ff0ef          	jal	274 <vli_cmp>
     f42:	00054963          	bltz	a0,f54 <vli_modMult.constprop.0+0x154>
     f46:	e905                	bnez	a0,f76 <vli_modMult.constprop.0+0x176>
     f48:	080c                	add	a1,sp,16
     f4a:	855e                	mv	a0,s7
     f4c:	b28ff0ef          	jal	274 <vli_cmp>
     f50:	02a04363          	bgtz	a0,f76 <vli_modMult.constprop.0+0x176>
     f54:	080c                	add	a1,sp,16
     f56:	865e                	mv	a2,s7
     f58:	852e                	mv	a0,a1
     f5a:	bf6ff0ef          	jal	350 <vli_sub>
     f5e:	8d4d                	or	a0,a0,a1
     f60:	c511                	beqz	a0,f6c <vli_modMult.constprop.0+0x16c>
     f62:	008c                	add	a1,sp,64
     f64:	8656                	mv	a2,s5
     f66:	852e                	mv	a0,a1
     f68:	be8ff0ef          	jal	350 <vli_sub>
     f6c:	008c                	add	a1,sp,64
     f6e:	1110                	add	a2,sp,160
     f70:	852e                	mv	a0,a1
     f72:	bdeff0ef          	jal	350 <vli_sub>
     f76:	1108                	add	a0,sp,160
     f78:	548a                	lw	s1,160(sp)
     f7a:	b3cff0ef          	jal	2b6 <vli_rshift1>
     f7e:	855e                	mv	a0,s7
     f80:	b36ff0ef          	jal	2b6 <vli_rshift1>
     f84:	47fa                	lw	a5,156(sp)
     f86:	04fe                	sll	s1,s1,0x1f
     f88:	8fc5                	or	a5,a5,s1
     f8a:	cf3e                	sw	a5,156(sp)
     f8c:	147d                	add	s0,s0,-1
     f8e:	bf69                	j	f28 <vli_modMult.constprop.0+0x128>
     f90:	000b0593          	mv	a1,s6
     f94:	01bb8533          	add	a0,s7,s11
     f98:	ab6ff0ef          	jal	24e <vli_set>
     f9c:	bf9d                	j	f12 <vli_modMult.constprop.0+0x112>

00000f9e <ecc_native2bytes>:
     f9e:	02850793          	add	a5,a0,40
     fa2:	0075c703          	lbu	a4,7(a1)
     fa6:	00e78023          	sb	a4,0(a5)
     faa:	0065d703          	lhu	a4,6(a1)
     fae:	86be                	mv	a3,a5
     fb0:	17e1                	add	a5,a5,-8
     fb2:	00e784a3          	sb	a4,9(a5)
     fb6:	41d8                	lw	a4,4(a1)
     fb8:	8321                	srl	a4,a4,0x8
     fba:	00e78523          	sb	a4,10(a5)
     fbe:	41d8                	lw	a4,4(a1)
     fc0:	00e785a3          	sb	a4,11(a5)
     fc4:	0035c703          	lbu	a4,3(a1)
     fc8:	00e78623          	sb	a4,12(a5)
     fcc:	0025d703          	lhu	a4,2(a1)
     fd0:	00e786a3          	sb	a4,13(a5)
     fd4:	4198                	lw	a4,0(a1)
     fd6:	8321                	srl	a4,a4,0x8
     fd8:	00e78723          	sb	a4,14(a5)
     fdc:	4198                	lw	a4,0(a1)
     fde:	00e787a3          	sb	a4,15(a5)
     fe2:	05a1                	add	a1,a1,8
     fe4:	faa69fe3          	bne	a3,a0,fa2 <ecc_native2bytes+0x4>
     fe8:	8082                	ret

00000fea <ecc_point_decompress>:
     fea:	7171                	add	sp,sp,-176
     fec:	02800613          	li	a2,40
     ff0:	d326                	sw	s1,164(sp)
     ff2:	cf4e                	sw	s3,156(sp)
     ff4:	84aa                	mv	s1,a0
     ff6:	89ae                	mv	s3,a1
     ff8:	0028                	add	a0,sp,8
     ffa:	4581                	li	a1,0
     ffc:	d706                	sw	ra,172(sp)
     ffe:	d522                	sw	s0,168(sp)
    1000:	d14a                	sw	s2,160(sp)
    1002:	cd52                	sw	s4,152(sp)
    1004:	cb5a                	sw	s6,148(sp)
    1006:	c95e                	sw	s7,144(sp)
    1008:	60c020ef          	jal	3614 <memset>
    100c:	470d                	li	a4,3
    100e:	4781                	li	a5,0
    1010:	00198593          	add	a1,s3,1
    1014:	8526                	mv	a0,s1
    1016:	c03a                	sw	a4,0(sp)
    1018:	c23e                	sw	a5,4(sp)
    101a:	03048413          	add	s0,s1,48
    101e:	ea0ff0ef          	jal	6be <ecc_bytes2native>
    1022:	85a6                	mv	a1,s1
    1024:	8522                	mv	a0,s0
    1026:	835ff0ef          	jal	85a <vli_modSquare_fast>
    102a:	860a                	mv	a2,sp
    102c:	85a2                	mv	a1,s0
    102e:	8522                	mv	a0,s0
    1030:	801ff0ef          	jal	830 <vli_modSub.constprop.0>
    1034:	8626                	mv	a2,s1
    1036:	85a2                	mv	a1,s0
    1038:	8522                	mv	a0,s0
    103a:	e4cff0ef          	jal	686 <vli_modMult_fast>
    103e:	50010a37          	lui	s4,0x50010
    1042:	50010637          	lui	a2,0x50010
    1046:	0c0a0693          	add	a3,s4,192 # 500100c0 <curve_p>
    104a:	09060613          	add	a2,a2,144 # 50010090 <curve_b>
    104e:	85a2                	mv	a1,s0
    1050:	8522                	mv	a0,s0
    1052:	ca8ff0ef          	jal	4fa <vli_modAdd>
    1056:	02800613          	li	a2,40
    105a:	4581                	li	a1,0
    105c:	1828                	add	a0,sp,56
    105e:	5b6020ef          	jal	3614 <memset>
    1062:	4b05                	li	s6,1
    1064:	4b81                	li	s7,0
    1066:	02800613          	li	a2,40
    106a:	4581                	li	a1,0
    106c:	10a8                	add	a0,sp,104
    106e:	d85a                	sw	s6,48(sp)
    1070:	da5e                	sw	s7,52(sp)
    1072:	5a2020ef          	jal	3614 <memset>
    1076:	1810                	add	a2,sp,48
    1078:	8532                	mv	a0,a2
    107a:	0c0a0593          	add	a1,s4,192
    107e:	d0da                	sw	s6,96(sp)
    1080:	d2de                	sw	s7,100(sp)
    1082:	a66ff0ef          	jal	2e8 <vli_add>
    1086:	1808                	add	a0,sp,48
    1088:	982ff0ef          	jal	20a <vli_numBits>
    108c:	fff50913          	add	s2,a0,-1
    1090:	108c                	add	a1,sp,96
    1092:	032b6a63          	bltu	s6,s2,10c6 <ecc_point_decompress+0xdc>
    1096:	8522                	mv	a0,s0
    1098:	9b6ff0ef          	jal	24e <vli_set>
    109c:	0009c703          	lbu	a4,0(s3)
    10a0:	589c                	lw	a5,48(s1)
    10a2:	8fb9                	xor	a5,a5,a4
    10a4:	8b85                	and	a5,a5,1
    10a6:	c3a1                	beqz	a5,10e6 <ecc_point_decompress+0xfc>
    10a8:	8622                	mv	a2,s0
    10aa:	8522                	mv	a0,s0
    10ac:	542a                	lw	s0,168(sp)
    10ae:	50ba                	lw	ra,172(sp)
    10b0:	549a                	lw	s1,164(sp)
    10b2:	590a                	lw	s2,160(sp)
    10b4:	49fa                	lw	s3,156(sp)
    10b6:	4b5a                	lw	s6,148(sp)
    10b8:	4bca                	lw	s7,144(sp)
    10ba:	0c0a0593          	add	a1,s4,192
    10be:	4a6a                	lw	s4,152(sp)
    10c0:	614d                	add	sp,sp,176
    10c2:	a8eff06f          	j	350 <vli_sub>
    10c6:	852e                	mv	a0,a1
    10c8:	f92ff0ef          	jal	85a <vli_modSquare_fast>
    10cc:	85ca                	mv	a1,s2
    10ce:	1808                	add	a0,sp,48
    10d0:	90eff0ef          	jal	1de <vli_testBit>
    10d4:	8d4d                	or	a0,a0,a1
    10d6:	c511                	beqz	a0,10e2 <ecc_point_decompress+0xf8>
    10d8:	108c                	add	a1,sp,96
    10da:	8622                	mv	a2,s0
    10dc:	852e                	mv	a0,a1
    10de:	da8ff0ef          	jal	686 <vli_modMult_fast>
    10e2:	197d                	add	s2,s2,-1
    10e4:	b775                	j	1090 <ecc_point_decompress+0xa6>
    10e6:	50ba                	lw	ra,172(sp)
    10e8:	542a                	lw	s0,168(sp)
    10ea:	549a                	lw	s1,164(sp)
    10ec:	590a                	lw	s2,160(sp)
    10ee:	49fa                	lw	s3,156(sp)
    10f0:	4a6a                	lw	s4,152(sp)
    10f2:	4b5a                	lw	s6,148(sp)
    10f4:	4bca                	lw	s7,144(sp)
    10f6:	614d                	add	sp,sp,176
    10f8:	8082                	ret

000010fa <ecc_make_key>:
    10fa:	7171                	add	sp,sp,-176
    10fc:	d522                	sw	s0,168(sp)
    10fe:	d326                	sw	s1,164(sp)
    1100:	d14a                	sw	s2,160(sp)
    1102:	cf4e                	sw	s3,156(sp)
    1104:	cd52                	sw	s4,152(sp)
    1106:	cb56                	sw	s5,148(sp)
    1108:	d706                	sw	ra,172(sp)
    110a:	842a                	mv	s0,a0
    110c:	84ae                	mv	s1,a1
    110e:	4945                	li	s2,17
    1110:	500109b7          	lui	s3,0x50010
    1114:	4a05                	li	s4,1
    1116:	50010ab7          	lui	s5,0x50010
    111a:	850a                	mv	a0,sp
    111c:	84cff0ef          	jal	168 <getRandomNumber>
    1120:	cd31                	beqz	a0,117c <ecc_make_key+0x82>
    1122:	197d                	add	s2,s2,-1
    1124:	06090563          	beqz	s2,118e <ecc_make_key+0x94>
    1128:	850a                	mv	a0,sp
    112a:	89aff0ef          	jal	1c4 <vli_isZero>
    112e:	e50d                	bnez	a0,1158 <ecc_make_key+0x5e>
    1130:	858a                	mv	a1,sp
    1132:	00098513          	mv	a0,s3
    1136:	93eff0ef          	jal	274 <vli_cmp>
    113a:	01450863          	beq	a0,s4,114a <ecc_make_key+0x50>
    113e:	00098613          	mv	a2,s3
    1142:	858a                	mv	a1,sp
    1144:	850a                	mv	a0,sp
    1146:	a0aff0ef          	jal	350 <vli_sub>
    114a:	4681                	li	a3,0
    114c:	860a                	mv	a2,sp
    114e:	030a8593          	add	a1,s5,48 # 50010030 <curve_G>
    1152:	1808                	add	a0,sp,48
    1154:	b07ff0ef          	jal	c5a <EccPoint_mult>
    1158:	1808                	add	a0,sp,48
    115a:	d46ff0ef          	jal	6a0 <EccPoint_isZero>
    115e:	fd55                	bnez	a0,111a <ecc_make_key+0x20>
    1160:	858a                	mv	a1,sp
    1162:	8526                	mv	a0,s1
    1164:	3d2d                	jal	f9e <ecc_native2bytes>
    1166:	00140513          	add	a0,s0,1
    116a:	180c                	add	a1,sp,48
    116c:	3d0d                	jal	f9e <ecc_native2bytes>
    116e:	06014783          	lbu	a5,96(sp)
    1172:	8b85                	and	a5,a5,1
    1174:	0789                	add	a5,a5,2
    1176:	00f40023          	sb	a5,0(s0)
    117a:	4505                	li	a0,1
    117c:	50ba                	lw	ra,172(sp)
    117e:	542a                	lw	s0,168(sp)
    1180:	549a                	lw	s1,164(sp)
    1182:	590a                	lw	s2,160(sp)
    1184:	49fa                	lw	s3,156(sp)
    1186:	4a6a                	lw	s4,152(sp)
    1188:	4ada                	lw	s5,148(sp)
    118a:	614d                	add	sp,sp,176
    118c:	8082                	ret
    118e:	4501                	li	a0,0
    1190:	b7f5                	j	117c <ecc_make_key+0x82>

00001192 <ecdsa_sign>:
    1192:	716d                	add	sp,sp,-272
    1194:	10812423          	sw	s0,264(sp)
    1198:	10912223          	sw	s1,260(sp)
    119c:	11212023          	sw	s2,256(sp)
    11a0:	dfce                	sw	s3,252(sp)
    11a2:	ddd2                	sw	s4,248(sp)
    11a4:	dbd6                	sw	s5,244(sp)
    11a6:	d9da                	sw	s6,240(sp)
    11a8:	10112623          	sw	ra,268(sp)
    11ac:	89aa                	mv	s3,a0
    11ae:	892e                	mv	s2,a1
    11b0:	8432                	mv	s0,a2
    11b2:	4a45                	li	s4,17
    11b4:	500104b7          	lui	s1,0x50010
    11b8:	4a85                	li	s5,1
    11ba:	50010b37          	lui	s6,0x50010
    11be:	850a                	mv	a0,sp
    11c0:	fa9fe0ef          	jal	168 <getRandomNumber>
    11c4:	c54d                	beqz	a0,126e <ecdsa_sign+0xdc>
    11c6:	1a7d                	add	s4,s4,-1
    11c8:	0c0a0163          	beqz	s4,128a <ecdsa_sign+0xf8>
    11cc:	850a                	mv	a0,sp
    11ce:	ff7fe0ef          	jal	1c4 <vli_isZero>
    11d2:	e131                	bnez	a0,1216 <ecdsa_sign+0x84>
    11d4:	858a                	mv	a1,sp
    11d6:	00048513          	mv	a0,s1
    11da:	89aff0ef          	jal	274 <vli_cmp>
    11de:	01550863          	beq	a0,s5,11ee <ecdsa_sign+0x5c>
    11e2:	00048613          	mv	a2,s1
    11e6:	858a                	mv	a1,sp
    11e8:	850a                	mv	a0,sp
    11ea:	966ff0ef          	jal	350 <vli_sub>
    11ee:	030b0593          	add	a1,s6,48 # 50010030 <curve_G>
    11f2:	0908                	add	a0,sp,144
    11f4:	4681                	li	a3,0
    11f6:	860a                	mv	a2,sp
    11f8:	a63ff0ef          	jal	c5a <EccPoint_mult>
    11fc:	090c                	add	a1,sp,144
    11fe:	00048513          	mv	a0,s1
    1202:	872ff0ef          	jal	274 <vli_cmp>
    1206:	01550863          	beq	a0,s5,1216 <ecdsa_sign+0x84>
    120a:	090c                	add	a1,sp,144
    120c:	00048613          	mv	a2,s1
    1210:	852e                	mv	a0,a1
    1212:	93eff0ef          	jal	350 <vli_sub>
    1216:	0908                	add	a0,sp,144
    1218:	fadfe0ef          	jal	1c4 <vli_isZero>
    121c:	f14d                	bnez	a0,11be <ecdsa_sign+0x2c>
    121e:	090c                	add	a1,sp,144
    1220:	8522                	mv	a0,s0
    1222:	3bb5                	jal	f9e <ecc_native2bytes>
    1224:	85ce                	mv	a1,s3
    1226:	1808                	add	a0,sp,48
    1228:	c96ff0ef          	jal	6be <ecc_bytes2native>
    122c:	1810                	add	a2,sp,48
    122e:	090c                	add	a1,sp,144
    1230:	1088                	add	a0,sp,96
    1232:	36f9                	jal	e00 <vli_modMult.constprop.0>
    1234:	85ca                	mv	a1,s2
    1236:	1808                	add	a0,sp,48
    1238:	c86ff0ef          	jal	6be <ecc_bytes2native>
    123c:	1090                	add	a2,sp,96
    123e:	500104b7          	lui	s1,0x50010
    1242:	00048693          	mv	a3,s1
    1246:	8532                	mv	a0,a2
    1248:	180c                	add	a1,sp,48
    124a:	ab0ff0ef          	jal	4fa <vli_modAdd>
    124e:	00048613          	mv	a2,s1
    1252:	858a                	mv	a1,sp
    1254:	850a                	mv	a0,sp
    1256:	cb6ff0ef          	jal	70c <vli_modInv>
    125a:	108c                	add	a1,sp,96
    125c:	852e                	mv	a0,a1
    125e:	860a                	mv	a2,sp
    1260:	ba1ff0ef          	jal	e00 <vli_modMult.constprop.0>
    1264:	03040513          	add	a0,s0,48
    1268:	108c                	add	a1,sp,96
    126a:	3b15                	jal	f9e <ecc_native2bytes>
    126c:	4505                	li	a0,1
    126e:	10c12083          	lw	ra,268(sp)
    1272:	10812403          	lw	s0,264(sp)
    1276:	10412483          	lw	s1,260(sp)
    127a:	10012903          	lw	s2,256(sp)
    127e:	59fe                	lw	s3,252(sp)
    1280:	5a6e                	lw	s4,248(sp)
    1282:	5ade                	lw	s5,244(sp)
    1284:	5b4e                	lw	s6,240(sp)
    1286:	6151                	add	sp,sp,272
    1288:	8082                	ret
    128a:	4501                	li	a0,0
    128c:	b7cd                	j	126e <ecdsa_sign+0xdc>

0000128e <ecdsa_verify>:
    128e:	d3010113          	add	sp,sp,-720
    1292:	2b412c23          	sw	s4,696(sp)
    1296:	1f010a13          	add	s4,sp,496
    129a:	2b312e23          	sw	s3,700(sp)
    129e:	89ae                	mv	s3,a1
    12a0:	85aa                	mv	a1,a0
    12a2:	8552                	mv	a0,s4
    12a4:	2c112623          	sw	ra,716(sp)
    12a8:	2c812423          	sw	s0,712(sp)
    12ac:	2c912223          	sw	s1,708(sp)
    12b0:	8432                	mv	s0,a2
    12b2:	2d212023          	sw	s2,704(sp)
    12b6:	2b512a23          	sw	s5,692(sp)
    12ba:	3b05                	jal	fea <ecc_point_decompress>
    12bc:	85a2                	mv	a1,s0
    12be:	0b08                	add	a0,sp,400
    12c0:	bfeff0ef          	jal	6be <ecc_bytes2native>
    12c4:	0388                	add	a0,sp,448
    12c6:	03040593          	add	a1,s0,48
    12ca:	bf4ff0ef          	jal	6be <ecc_bytes2native>
    12ce:	0b08                	add	a0,sp,400
    12d0:	ef5fe0ef          	jal	1c4 <vli_isZero>
    12d4:	20051d63          	bnez	a0,14ee <ecdsa_verify+0x260>
    12d8:	0388                	add	a0,sp,448
    12da:	eebfe0ef          	jal	1c4 <vli_isZero>
    12de:	842a                	mv	s0,a0
    12e0:	20051763          	bnez	a0,14ee <ecdsa_verify+0x260>
    12e4:	500104b7          	lui	s1,0x50010
    12e8:	0b0c                	add	a1,sp,400
    12ea:	00048513          	mv	a0,s1
    12ee:	f87fe0ef          	jal	274 <vli_cmp>
    12f2:	4785                	li	a5,1
    12f4:	892a                	mv	s2,a0
    12f6:	14f51a63          	bne	a0,a5,144a <ecdsa_verify+0x1bc>
    12fa:	038c                	add	a1,sp,448
    12fc:	00048513          	mv	a0,s1
    1300:	f75fe0ef          	jal	274 <vli_cmp>
    1304:	15251363          	bne	a0,s2,144a <ecdsa_verify+0x1bc>
    1308:	00048613          	mv	a2,s1
    130c:	038c                	add	a1,sp,448
    130e:	1888                	add	a0,sp,112
    1310:	bfcff0ef          	jal	70c <vli_modInv>
    1314:	85ce                	mv	a1,s3
    1316:	0808                	add	a0,sp,16
    1318:	ba6ff0ef          	jal	6be <ecc_bytes2native>
    131c:	080c                	add	a1,sp,16
    131e:	852e                	mv	a0,a1
    1320:	1890                	add	a2,sp,112
    1322:	adfff0ef          	jal	e00 <vli_modMult.constprop.0>
    1326:	1890                	add	a2,sp,112
    1328:	0b0c                	add	a1,sp,400
    132a:	0088                	add	a0,sp,64
    132c:	ad5ff0ef          	jal	e00 <vli_modMult.constprop.0>
    1330:	0c80                	add	s0,sp,592
    1332:	8522                	mv	a0,s0
    1334:	85d2                	mv	a1,s4
    1336:	f19fe0ef          	jal	24e <vli_set>
    133a:	140c                	add	a1,sp,544
    133c:	0508                	add	a0,sp,640
    133e:	f11fe0ef          	jal	24e <vli_set>
    1342:	500109b7          	lui	s3,0x50010
    1346:	03098593          	add	a1,s3,48 # 50010030 <curve_G>
    134a:	0208                	add	a0,sp,256
    134c:	f03fe0ef          	jal	24e <vli_set>
    1350:	500105b7          	lui	a1,0x50010
    1354:	06058593          	add	a1,a1,96 # 50010060 <curve_G+0x30>
    1358:	1a08                	add	a0,sp,304
    135a:	ef5fe0ef          	jal	24e <vli_set>
    135e:	85a2                	mv	a1,s0
    1360:	0210                	add	a2,sp,256
    1362:	1888                	add	a0,sp,112
    1364:	cccff0ef          	jal	830 <vli_modSub.constprop.0>
    1368:	0514                	add	a3,sp,640
    136a:	8622                	mv	a2,s0
    136c:	1a0c                	add	a1,sp,304
    136e:	0208                	add	a0,sp,256
    1370:	f8aff0ef          	jal	afa <XYcZ_add>
    1374:	188c                	add	a1,sp,112
    1376:	50010937          	lui	s2,0x50010
    137a:	852e                	mv	a0,a1
    137c:	0c090613          	add	a2,s2,192 # 500100c0 <curve_p>
    1380:	b8cff0ef          	jal	70c <vli_modInv>
    1384:	8522                	mv	a0,s0
    1386:	1890                	add	a2,sp,112
    1388:	050c                	add	a1,sp,640
    138a:	f36ff0ef          	jal	ac0 <apply_z>
    138e:	03098993          	add	s3,s3,48
    1392:	0808                	add	a0,sp,16
    1394:	c622                	sw	s0,12(sp)
    1396:	c002                	sw	zero,0(sp)
    1398:	c24e                	sw	s3,4(sp)
    139a:	c452                	sw	s4,8(sp)
    139c:	e6ffe0ef          	jal	20a <vli_numBits>
    13a0:	842a                	mv	s0,a0
    13a2:	0088                	add	a0,sp,64
    13a4:	e67fe0ef          	jal	20a <vli_numBits>
    13a8:	00a47363          	bgeu	s0,a0,13ae <ecdsa_verify+0x120>
    13ac:	842a                	mv	s0,a0
    13ae:	fff40a93          	add	s5,s0,-1
    13b2:	85d6                	mv	a1,s5
    13b4:	0808                	add	a0,sp,16
    13b6:	e29fe0ef          	jal	1de <vli_testBit>
    13ba:	8a2e                	mv	s4,a1
    13bc:	89aa                	mv	s3,a0
    13be:	85d6                	mv	a1,s5
    13c0:	0088                	add	a0,sp,64
    13c2:	e1dfe0ef          	jal	1de <vli_testBit>
    13c6:	00b567b3          	or	a5,a0,a1
    13ca:	0149e9b3          	or	s3,s3,s4
    13ce:	00f037b3          	snez	a5,a5
    13d2:	013039b3          	snez	s3,s3
    13d6:	0786                	sll	a5,a5,0x1
    13d8:	0137e7b3          	or	a5,a5,s3
    13dc:	078a                	sll	a5,a5,0x2
    13de:	978a                	add	a5,a5,sp
    13e0:	0007aa03          	lw	s4,0(a5)
    13e4:	85d2                	mv	a1,s4
    13e6:	1108                	add	a0,sp,160
    13e8:	e67fe0ef          	jal	24e <vli_set>
    13ec:	030a0593          	add	a1,s4,48
    13f0:	0988                	add	a0,sp,208
    13f2:	e5dfe0ef          	jal	24e <vli_set>
    13f6:	1888                	add	a0,sp,112
    13f8:	dc3fe0ef          	jal	1ba <vli_clear>
    13fc:	4705                	li	a4,1
    13fe:	4781                	li	a5,0
    1400:	898a                	mv	s3,sp
    1402:	d8ba                	sw	a4,112(sp)
    1404:	dabe                	sw	a5,116(sp)
    1406:	1479                	add	s0,s0,-2
    1408:	06045363          	bgez	s0,146e <ecdsa_verify+0x1e0>
    140c:	188c                	add	a1,sp,112
    140e:	852e                	mv	a0,a1
    1410:	0c090613          	add	a2,s2,192
    1414:	af8ff0ef          	jal	70c <vli_modInv>
    1418:	1890                	add	a2,sp,112
    141a:	098c                	add	a1,sp,208
    141c:	1108                	add	a0,sp,160
    141e:	ea2ff0ef          	jal	ac0 <apply_z>
    1422:	110c                	add	a1,sp,160
    1424:	00048513          	mv	a0,s1
    1428:	e4dfe0ef          	jal	274 <vli_cmp>
    142c:	4785                	li	a5,1
    142e:	00f50863          	beq	a0,a5,143e <ecdsa_verify+0x1b0>
    1432:	110c                	add	a1,sp,160
    1434:	00048613          	mv	a2,s1
    1438:	852e                	mv	a0,a1
    143a:	f17fe0ef          	jal	350 <vli_sub>
    143e:	0b0c                	add	a1,sp,400
    1440:	1108                	add	a0,sp,160
    1442:	e33fe0ef          	jal	274 <vli_cmp>
    1446:	00153413          	seqz	s0,a0
    144a:	8522                	mv	a0,s0
    144c:	2cc12083          	lw	ra,716(sp)
    1450:	2c812403          	lw	s0,712(sp)
    1454:	2c412483          	lw	s1,708(sp)
    1458:	2c012903          	lw	s2,704(sp)
    145c:	2bc12983          	lw	s3,700(sp)
    1460:	2b812a03          	lw	s4,696(sp)
    1464:	2b412a83          	lw	s5,692(sp)
    1468:	2d010113          	add	sp,sp,720
    146c:	8082                	ret
    146e:	1890                	add	a2,sp,112
    1470:	098c                	add	a1,sp,208
    1472:	1108                	add	a0,sp,160
    1474:	d4aff0ef          	jal	9be <EccPoint_double_jacobian>
    1478:	85a2                	mv	a1,s0
    147a:	0808                	add	a0,sp,16
    147c:	d63fe0ef          	jal	1de <vli_testBit>
    1480:	8a2a                	mv	s4,a0
    1482:	8aae                	mv	s5,a1
    1484:	0088                	add	a0,sp,64
    1486:	85a2                	mv	a1,s0
    1488:	d57fe0ef          	jal	1de <vli_testBit>
    148c:	00b567b3          	or	a5,a0,a1
    1490:	00f037b3          	snez	a5,a5
    1494:	015a6a33          	or	s4,s4,s5
    1498:	01403a33          	snez	s4,s4
    149c:	0786                	sll	a5,a5,0x1
    149e:	0147e7b3          	or	a5,a5,s4
    14a2:	078a                	sll	a5,a5,0x2
    14a4:	97ce                	add	a5,a5,s3
    14a6:	0007aa03          	lw	s4,0(a5)
    14aa:	040a0063          	beqz	s4,14ea <ecdsa_verify+0x25c>
    14ae:	85d2                	mv	a1,s4
    14b0:	0208                	add	a0,sp,256
    14b2:	d9dfe0ef          	jal	24e <vli_set>
    14b6:	030a0593          	add	a1,s4,48
    14ba:	1a08                	add	a0,sp,304
    14bc:	d93fe0ef          	jal	24e <vli_set>
    14c0:	1890                	add	a2,sp,112
    14c2:	1a0c                	add	a1,sp,304
    14c4:	0208                	add	a0,sp,256
    14c6:	dfaff0ef          	jal	ac0 <apply_z>
    14ca:	0210                	add	a2,sp,256
    14cc:	110c                	add	a1,sp,160
    14ce:	1288                	add	a0,sp,352
    14d0:	b60ff0ef          	jal	830 <vli_modSub.constprop.0>
    14d4:	1110                	add	a2,sp,160
    14d6:	1a0c                	add	a1,sp,304
    14d8:	0208                	add	a0,sp,256
    14da:	0994                	add	a3,sp,208
    14dc:	e1eff0ef          	jal	afa <XYcZ_add>
    14e0:	188c                	add	a1,sp,112
    14e2:	1290                	add	a2,sp,352
    14e4:	852e                	mv	a0,a1
    14e6:	9a0ff0ef          	jal	686 <vli_modMult_fast>
    14ea:	147d                	add	s0,s0,-1
    14ec:	bf31                	j	1408 <ecdsa_verify+0x17a>
    14ee:	4401                	li	s0,0
    14f0:	bfa9                	j	144a <ecdsa_verify+0x1bc>

000014f2 <mailbox_send_data>:
    14f2:	7179                	add	sp,sp,-48
    14f4:	d04a                	sw	s2,32(sp)
    14f6:	892a                	mv	s2,a0
    14f8:	10000537          	lui	a0,0x10000
    14fc:	d606                	sw	ra,44(sp)
    14fe:	d226                	sw	s1,36(sp)
    1500:	d422                	sw	s0,40(sp)
    1502:	84ae                	mv	s1,a1
    1504:	ce4e                	sw	s3,28(sp)
    1506:	cc52                	sw	s4,24(sp)
    1508:	ca56                	sw	s5,20(sp)
    150a:	327000ef          	jal	2030 <soc_ifc_set_flow_status_field>
    150e:	50010537          	lui	a0,0x50010
    1512:	18050513          	add	a0,a0,384 # 50010180 <tbs_len+0x4>
    1516:	21b5                	jal	1982 <puts>
    1518:	30020737          	lui	a4,0x30020
    151c:	0761                	add	a4,a4,24 # 30020018 <_data_lma_end+0x3001bc54>
    151e:	431c                	lw	a5,0(a4)
    1520:	8b85                	and	a5,a5,1
    1522:	dff5                	beqz	a5,151e <mailbox_send_data+0x2c>
    1524:	353000ef          	jal	2076 <soc_ifc_read_mbox_cmd>
    1528:	c42a                	sw	a0,8(sp)
    152a:	c62e                	sw	a1,12(sp)
    152c:	842a                	mv	s0,a0
    152e:	85aa                	mv	a1,a0
    1530:	50010537          	lui	a0,0x50010
    1534:	18c50513          	add	a0,a0,396 # 5001018c <tbs_len+0x10>
    1538:	300209b7          	lui	s3,0x30020
    153c:	21a9                	jal	1986 <printf>
    153e:	09d1                	add	s3,s3,20 # 30020014 <_data_lma_end+0x3001bc50>
    1540:	50010a37          	lui	s4,0x50010
    1544:	4a91                	li	s5,4
    1546:	e049                	bnez	s0,15c8 <mailbox_send_data+0xd6>
    1548:	0220000f          	fence	r,r
    154c:	0220000f          	fence	r,r
    1550:	1a2b47b7          	lui	a5,0x1a2b4
    1554:	30020737          	lui	a4,0x30020
    1558:	c4d78793          	add	a5,a5,-947 # 1a2b3c4d <_data_lma_end+0x1a2af889>
    155c:	c71c                	sw	a5,8(a4)
    155e:	0220000f          	fence	r,r
    1562:	0220000f          	fence	r,r
    1566:	50010537          	lui	a0,0x50010
    156a:	c744                	sw	s1,12(a4)
    156c:	85a6                	mv	a1,s1
    156e:	1c850513          	add	a0,a0,456 # 500101c8 <tbs_len+0x4c>
    1572:	2911                	jal	1986 <printf>
    1574:	300206b7          	lui	a3,0x30020
    1578:	4781                	li	a5,0
    157a:	4811                	li	a6,4
    157c:	06c1                	add	a3,a3,16 # 30020010 <_data_lma_end+0x3001bc4c>
    157e:	0497ef63          	bltu	a5,s1,15dc <mailbox_send_data+0xea>
    1582:	50010537          	lui	a0,0x50010
    1586:	1f050513          	add	a0,a0,496 # 500101f0 <tbs_len+0x74>
    158a:	2ee5                	jal	1982 <puts>
    158c:	0220000f          	fence	r,r
    1590:	0220000f          	fence	r,r
    1594:	300207b7          	lui	a5,0x30020
    1598:	4705                	li	a4,1
    159a:	cfd8                	sw	a4,28(a5)
    159c:	4fcc                	lw	a1,28(a5)
    159e:	8199                	srl	a1,a1,0x6
    15a0:	899d                	and	a1,a1,7
    15a2:	4611                	li	a2,4
    15a4:	06c58863          	beq	a1,a2,1614 <mailbox_send_data+0x122>
    15a8:	50010537          	lui	a0,0x50010
    15ac:	20c50513          	add	a0,a0,524 # 5001020c <tbs_len+0x90>
    15b0:	2ed9                	jal	1986 <printf>
    15b2:	547d                	li	s0,-1
    15b4:	8522                	mv	a0,s0
    15b6:	50b2                	lw	ra,44(sp)
    15b8:	5422                	lw	s0,40(sp)
    15ba:	5492                	lw	s1,36(sp)
    15bc:	5902                	lw	s2,32(sp)
    15be:	49f2                	lw	s3,28(sp)
    15c0:	4a62                	lw	s4,24(sp)
    15c2:	4ad2                	lw	s5,20(sp)
    15c4:	6145                	add	sp,sp,48
    15c6:	8082                	ret
    15c8:	0009a583          	lw	a1,0(s3)
    15cc:	1b4a0513          	add	a0,s4,436 # 500101b4 <tbs_len+0x38>
    15d0:	2e5d                	jal	1986 <printf>
    15d2:	01547363          	bgeu	s0,s5,15d8 <mailbox_send_data+0xe6>
    15d6:	4411                	li	s0,4
    15d8:	1471                	add	s0,s0,-4
    15da:	b7b5                	j	1546 <mailbox_send_data+0x54>
    15dc:	40f485b3          	sub	a1,s1,a5
    15e0:	00b87363          	bgeu	a6,a1,15e6 <mailbox_send_data+0xf4>
    15e4:	4591                	li	a1,4
    15e6:	4701                	li	a4,0
    15e8:	4601                	li	a2,0
    15ea:	00f90333          	add	t1,s2,a5
    15ee:	00e30533          	add	a0,t1,a4
    15f2:	00371893          	sll	a7,a4,0x3
    15f6:	00054503          	lbu	a0,0(a0)
    15fa:	01151533          	sll	a0,a0,a7
    15fe:	0705                	add	a4,a4,1 # 30020001 <_data_lma_end+0x3001bc3d>
    1600:	8e49                	or	a2,a2,a0
    1602:	fee596e3          	bne	a1,a4,15ee <mailbox_send_data+0xfc>
    1606:	0220000f          	fence	r,r
    160a:	0220000f          	fence	r,r
    160e:	c290                	sw	a2,0(a3)
    1610:	0791                	add	a5,a5,4 # 30020004 <_data_lma_end+0x3001bc40>
    1612:	b7b5                	j	157e <mailbox_send_data+0x8c>
    1614:	50010537          	lui	a0,0x50010
    1618:	26050513          	add	a0,a0,608 # 50010260 <tbs_len+0xe4>
    161c:	269d                	jal	1982 <puts>
    161e:	bf59                	j	15b4 <mailbox_send_data+0xc2>

00001620 <whisperPutc>:
    1620:	1141                	add	sp,sp,-16
    1622:	c422                	sw	s0,8(sp)
    1624:	c606                	sw	ra,12(sp)
    1626:	47a9                	li	a5,10
    1628:	842a                	mv	s0,a0
    162a:	00f51663          	bne	a0,a5,1636 <whisperPutc+0x16>
    162e:	4535                	li	a0,13
    1630:	357000ef          	jal	2186 <uart_tx>
    1634:	8522                	mv	a0,s0
    1636:	351000ef          	jal	2186 <uart_tx>
    163a:	8522                	mv	a0,s0
    163c:	40b2                	lw	ra,12(sp)
    163e:	4422                	lw	s0,8(sp)
    1640:	0141                	add	sp,sp,16
    1642:	8082                	ret

00001644 <whisperPuts>:
    1644:	1141                	add	sp,sp,-16
    1646:	c422                	sw	s0,8(sp)
    1648:	c606                	sw	ra,12(sp)
    164a:	842a                	mv	s0,a0
    164c:	00044503          	lbu	a0,0(s0)
    1650:	e901                	bnez	a0,1660 <whisperPuts+0x1c>
    1652:	4529                	li	a0,10
    1654:	37f1                	jal	1620 <whisperPutc>
    1656:	40b2                	lw	ra,12(sp)
    1658:	4422                	lw	s0,8(sp)
    165a:	4505                	li	a0,1
    165c:	0141                	add	sp,sp,16
    165e:	8082                	ret
    1660:	0405                	add	s0,s0,1
    1662:	3f7d                	jal	1620 <whisperPutc>
    1664:	b7e5                	j	164c <whisperPuts+0x8>

00001666 <whisperPrintUnsigned>:
    1666:	7139                	add	sp,sp,-64
    1668:	da26                	sw	s1,52(sp)
    166a:	d64e                	sw	s3,44(sp)
    166c:	de06                	sw	ra,60(sp)
    166e:	dc22                	sw	s0,56(sp)
    1670:	d84a                	sw	s2,48(sp)
    1672:	84ae                	mv	s1,a1
    1674:	89b2                	mv	s3,a2
    1676:	ed15                	bnez	a0,16b2 <whisperPrintUnsigned+0x4c>
    1678:	03000793          	li	a5,48
    167c:	00f10623          	sb	a5,12(sp)
    1680:	4405                	li	s0,1
    1682:	8922                	mv	s2,s0
    1684:	04994963          	blt	s2,s1,16d6 <whisperPrintUnsigned+0x70>
    1688:	02040793          	add	a5,s0,32
    168c:	002784b3          	add	s1,a5,sp
    1690:	14ad                	add	s1,s1,-21 # 5000ffeb <_data_lma_end+0x5000bc27>
    1692:	40848933          	sub	s2,s1,s0
    1696:	0004c503          	lbu	a0,0(s1)
    169a:	14fd                	add	s1,s1,-1
    169c:	3751                	jal	1620 <whisperPutc>
    169e:	fe991ce3          	bne	s2,s1,1696 <whisperPrintUnsigned+0x30>
    16a2:	8522                	mv	a0,s0
    16a4:	50f2                	lw	ra,60(sp)
    16a6:	5462                	lw	s0,56(sp)
    16a8:	54d2                	lw	s1,52(sp)
    16aa:	5942                	lw	s2,48(sp)
    16ac:	59b2                	lw	s3,44(sp)
    16ae:	6121                	add	sp,sp,64
    16b0:	8082                	ret
    16b2:	007c                	add	a5,sp,12
    16b4:	4401                	li	s0,0
    16b6:	46a9                	li	a3,10
    16b8:	4625                	li	a2,9
    16ba:	02d57733          	remu	a4,a0,a3
    16be:	85aa                	mv	a1,a0
    16c0:	0405                	add	s0,s0,1
    16c2:	0785                	add	a5,a5,1
    16c4:	03070713          	add	a4,a4,48
    16c8:	fee78fa3          	sb	a4,-1(a5)
    16cc:	02d55533          	divu	a0,a0,a3
    16d0:	feb665e3          	bltu	a2,a1,16ba <whisperPrintUnsigned+0x54>
    16d4:	b77d                	j	1682 <whisperPrintUnsigned+0x1c>
    16d6:	854e                	mv	a0,s3
    16d8:	37a1                	jal	1620 <whisperPutc>
    16da:	0905                	add	s2,s2,1
    16dc:	b765                	j	1684 <whisperPrintUnsigned+0x1e>

000016de <whisperPrintDecimal>:
    16de:	7139                	add	sp,sp,-64
    16e0:	da26                	sw	s1,52(sp)
    16e2:	d452                	sw	s4,40(sp)
    16e4:	de06                	sw	ra,60(sp)
    16e6:	dc22                	sw	s0,56(sp)
    16e8:	d84a                	sw	s2,48(sp)
    16ea:	d64e                	sw	s3,44(sp)
    16ec:	84ae                	mv	s1,a1
    16ee:	8a32                	mv	s4,a2
    16f0:	02055c63          	bgez	a0,1728 <whisperPrintDecimal+0x4a>
    16f4:	40a00533          	neg	a0,a0
    16f8:	fff58493          	add	s1,a1,-1
    16fc:	4905                	li	s2,1
    16fe:	007c                	add	a5,sp,12
    1700:	4401                	li	s0,0
    1702:	46a9                	li	a3,10
    1704:	02d56733          	rem	a4,a0,a3
    1708:	0405                	add	s0,s0,1
    170a:	0785                	add	a5,a5,1
    170c:	02d54533          	div	a0,a0,a3
    1710:	03070713          	add	a4,a4,48
    1714:	fee78fa3          	sb	a4,-1(a5)
    1718:	f575                	bnez	a0,1704 <whisperPrintDecimal+0x26>
    171a:	00090e63          	beqz	s2,1736 <whisperPrintDecimal+0x58>
    171e:	02d00513          	li	a0,45
    1722:	265000ef          	jal	2186 <uart_tx>
    1726:	a801                	j	1736 <whisperPrintDecimal+0x58>
    1728:	e129                	bnez	a0,176a <whisperPrintDecimal+0x8c>
    172a:	03000793          	li	a5,48
    172e:	00f10623          	sb	a5,12(sp)
    1732:	4901                	li	s2,0
    1734:	4405                	li	s0,1
    1736:	89a2                	mv	s3,s0
    1738:	0299cb63          	blt	s3,s1,176e <whisperPrintDecimal+0x90>
    173c:	02040793          	add	a5,s0,32
    1740:	002784b3          	add	s1,a5,sp
    1744:	14ad                	add	s1,s1,-21
    1746:	408489b3          	sub	s3,s1,s0
    174a:	0004c503          	lbu	a0,0(s1)
    174e:	14fd                	add	s1,s1,-1
    1750:	3dc1                	jal	1620 <whisperPutc>
    1752:	fe999ce3          	bne	s3,s1,174a <whisperPrintDecimal+0x6c>
    1756:	01240533          	add	a0,s0,s2
    175a:	50f2                	lw	ra,60(sp)
    175c:	5462                	lw	s0,56(sp)
    175e:	54d2                	lw	s1,52(sp)
    1760:	5942                	lw	s2,48(sp)
    1762:	59b2                	lw	s3,44(sp)
    1764:	5a22                	lw	s4,40(sp)
    1766:	6121                	add	sp,sp,64
    1768:	8082                	ret
    176a:	4901                	li	s2,0
    176c:	bf49                	j	16fe <whisperPrintDecimal+0x20>
    176e:	8552                	mv	a0,s4
    1770:	3d45                	jal	1620 <whisperPutc>
    1772:	0985                	add	s3,s3,1
    1774:	b7d1                	j	1738 <whisperPrintDecimal+0x5a>

00001776 <whisperPrintInt>:
    1776:	47a9                	li	a5,10
    1778:	00f69563          	bne	a3,a5,1782 <whisperPrintInt+0xc>
    177c:	0ff67613          	zext.b	a2,a2
    1780:	bfb9                	j	16de <whisperPrintDecimal>
    1782:	1101                	add	sp,sp,-32
    1784:	c84a                	sw	s2,16(sp)
    1786:	ce06                	sw	ra,28(sp)
    1788:	cc22                	sw	s0,24(sp)
    178a:	ca26                	sw	s1,20(sp)
    178c:	c64e                	sw	s3,12(sp)
    178e:	c452                	sw	s4,8(sp)
    1790:	47a1                	li	a5,8
    1792:	892a                	mv	s2,a0
    1794:	02f69f63          	bne	a3,a5,17d2 <whisperPrintInt+0x5c>
    1798:	44f9                	li	s1,30
    179a:	4781                	li	a5,0
    179c:	4401                	li	s0,0
    179e:	0fd00993          	li	s3,253
    17a2:	00995533          	srl	a0,s2,s1
    17a6:	891d                	and	a0,a0,7
    17a8:	e111                	bnez	a0,17ac <whisperPrintInt+0x36>
    17aa:	c791                	beqz	a5,17b6 <whisperPrintInt+0x40>
    17ac:	03050513          	add	a0,a0,48
    17b0:	3d85                	jal	1620 <whisperPutc>
    17b2:	0405                	add	s0,s0,1
    17b4:	4785                	li	a5,1
    17b6:	14f5                	add	s1,s1,-3
    17b8:	0ff4f493          	zext.b	s1,s1
    17bc:	ff3493e3          	bne	s1,s3,17a2 <whisperPrintInt+0x2c>
    17c0:	8522                	mv	a0,s0
    17c2:	40f2                	lw	ra,28(sp)
    17c4:	4462                	lw	s0,24(sp)
    17c6:	44d2                	lw	s1,20(sp)
    17c8:	4942                	lw	s2,16(sp)
    17ca:	49b2                	lw	s3,12(sp)
    17cc:	4a22                	lw	s4,8(sp)
    17ce:	6105                	add	sp,sp,32
    17d0:	8082                	ret
    17d2:	47c1                	li	a5,16
    17d4:	547d                	li	s0,-1
    17d6:	fef695e3          	bne	a3,a5,17c0 <whisperPrintInt+0x4a>
    17da:	44f1                	li	s1,28
    17dc:	4701                	li	a4,0
    17de:	4401                	li	s0,0
    17e0:	4a25                	li	s4,9
    17e2:	0fc00993          	li	s3,252
    17e6:	009957b3          	srl	a5,s2,s1
    17ea:	8bbd                	and	a5,a5,15
    17ec:	e791                	bnez	a5,17f8 <whisperPrintInt+0x82>
    17ee:	e311                	bnez	a4,17f2 <whisperPrintInt+0x7c>
    17f0:	e899                	bnez	s1,1806 <whisperPrintInt+0x90>
    17f2:	03078513          	add	a0,a5,48
    17f6:	a029                	j	1800 <whisperPrintInt+0x8a>
    17f8:	03778513          	add	a0,a5,55
    17fc:	fefa7be3          	bgeu	s4,a5,17f2 <whisperPrintInt+0x7c>
    1800:	3505                	jal	1620 <whisperPutc>
    1802:	0405                	add	s0,s0,1
    1804:	4705                	li	a4,1
    1806:	14f1                	add	s1,s1,-4
    1808:	0ff4f493          	zext.b	s1,s1
    180c:	fd349de3          	bne	s1,s3,17e6 <whisperPrintInt+0x70>
    1810:	bf45                	j	17c0 <whisperPrintInt+0x4a>

00001812 <whisperPrintfImpl>:
    1812:	7179                	add	sp,sp,-48
    1814:	d422                	sw	s0,40(sp)
    1816:	d226                	sw	s1,36(sp)
    1818:	d04a                	sw	s2,32(sp)
    181a:	ce4e                	sw	s3,28(sp)
    181c:	cc52                	sw	s4,24(sp)
    181e:	ca56                	sw	s5,20(sp)
    1820:	c85a                	sw	s6,16(sp)
    1822:	c65e                	sw	s7,12(sp)
    1824:	c462                	sw	s8,8(sp)
    1826:	d606                	sw	ra,44(sp)
    1828:	c266                	sw	s9,4(sp)
    182a:	c06a                	sw	s10,0(sp)
    182c:	842a                	mv	s0,a0
    182e:	84ae                	mv	s1,a1
    1830:	4901                	li	s2,0
    1832:	02500993          	li	s3,37
    1836:	03000a93          	li	s5,48
    183a:	02d00b13          	li	s6,45
    183e:	02a00b93          	li	s7,42
    1842:	06f00a13          	li	s4,111
    1846:	07500c13          	li	s8,117
    184a:	00044503          	lbu	a0,0(s0)
    184e:	e105                	bnez	a0,186e <whisperPrintfImpl+0x5c>
    1850:	50b2                	lw	ra,44(sp)
    1852:	5422                	lw	s0,40(sp)
    1854:	854a                	mv	a0,s2
    1856:	5492                	lw	s1,36(sp)
    1858:	5902                	lw	s2,32(sp)
    185a:	49f2                	lw	s3,28(sp)
    185c:	4a62                	lw	s4,24(sp)
    185e:	4ad2                	lw	s5,20(sp)
    1860:	4b42                	lw	s6,16(sp)
    1862:	4bb2                	lw	s7,12(sp)
    1864:	4c22                	lw	s8,8(sp)
    1866:	4c92                	lw	s9,4(sp)
    1868:	4d02                	lw	s10,0(sp)
    186a:	6145                	add	sp,sp,48
    186c:	8082                	ret
    186e:	01350663          	beq	a0,s3,187a <whisperPrintfImpl+0x68>
    1872:	337d                	jal	1620 <whisperPutc>
    1874:	0905                	add	s2,s2,1
    1876:	0405                	add	s0,s0,1
    1878:	bfc9                	j	184a <whisperPrintfImpl+0x38>
    187a:	00144703          	lbu	a4,1(s0)
    187e:	db69                	beqz	a4,1850 <whisperPrintfImpl+0x3e>
    1880:	0405                	add	s0,s0,1
    1882:	02000793          	li	a5,32
    1886:	01371663          	bne	a4,s3,1892 <whisperPrintfImpl+0x80>
    188a:	854e                	mv	a0,s3
    188c:	0fb000ef          	jal	2186 <uart_tx>
    1890:	b7dd                	j	1876 <whisperPrintfImpl+0x64>
    1892:	863e                	mv	a2,a5
    1894:	00044783          	lbu	a5,0(s0)
    1898:	8722                	mv	a4,s0
    189a:	0405                	add	s0,s0,1
    189c:	ff578be3          	beq	a5,s5,1892 <whisperPrintfImpl+0x80>
    18a0:	01678363          	beq	a5,s6,18a6 <whisperPrintfImpl+0x94>
    18a4:	843a                	mv	s0,a4
    18a6:	00044783          	lbu	a5,0(s0)
    18aa:	03779c63          	bne	a5,s7,18e2 <whisperPrintfImpl+0xd0>
    18ae:	0405                	add	s0,s0,1
    18b0:	4581                	li	a1,0
    18b2:	00044783          	lbu	a5,0(s0)
    18b6:	0b478263          	beq	a5,s4,195a <whisperPrintfImpl+0x148>
    18ba:	04fa6d63          	bltu	s4,a5,1914 <whisperPrintfImpl+0x102>
    18be:	06300713          	li	a4,99
    18c2:	0ae78063          	beq	a5,a4,1962 <whisperPrintfImpl+0x150>
    18c6:	06400713          	li	a4,100
    18ca:	06e78c63          	beq	a5,a4,1942 <whisperPrintfImpl+0x130>
    18ce:	05800713          	li	a4,88
    18d2:	fae792e3          	bne	a5,a4,1876 <whisperPrintfImpl+0x64>
    18d6:	00448c93          	add	s9,s1,4
    18da:	46c1                	li	a3,16
    18dc:	4088                	lw	a0,0(s1)
    18de:	3d61                	jal	1776 <whisperPrintInt>
    18e0:	a0ad                	j	194a <whisperPrintfImpl+0x138>
    18e2:	fd078793          	add	a5,a5,-48
    18e6:	0ff7f793          	zext.b	a5,a5
    18ea:	4725                	li	a4,9
    18ec:	4581                	li	a1,0
    18ee:	fcf762e3          	bltu	a4,a5,18b2 <whisperPrintfImpl+0xa0>
    18f2:	4829                	li	a6,10
    18f4:	a029                	j	18fe <whisperPrintfImpl+0xec>
    18f6:	030585b3          	mul	a1,a1,a6
    18fa:	842a                	mv	s0,a0
    18fc:	95be                	add	a1,a1,a5
    18fe:	00044783          	lbu	a5,0(s0)
    1902:	fd078793          	add	a5,a5,-48
    1906:	0ff7f693          	zext.b	a3,a5
    190a:	00140513          	add	a0,s0,1
    190e:	fed774e3          	bgeu	a4,a3,18f6 <whisperPrintfImpl+0xe4>
    1912:	b745                	j	18b2 <whisperPrintfImpl+0xa0>
    1914:	03878e63          	beq	a5,s8,1950 <whisperPrintfImpl+0x13e>
    1918:	07800713          	li	a4,120
    191c:	fae78de3          	beq	a5,a4,18d6 <whisperPrintfImpl+0xc4>
    1920:	07300713          	li	a4,115
    1924:	f4e799e3          	bne	a5,a4,1876 <whisperPrintfImpl+0x64>
    1928:	00448d13          	add	s10,s1,4
    192c:	8cca                	mv	s9,s2
    192e:	4084                	lw	s1,0(s1)
    1930:	412c87b3          	sub	a5,s9,s2
    1934:	97a6                	add	a5,a5,s1
    1936:	0007c503          	lbu	a0,0(a5)
    193a:	ed05                	bnez	a0,1972 <whisperPrintfImpl+0x160>
    193c:	84ea                	mv	s1,s10
    193e:	8966                	mv	s2,s9
    1940:	bf1d                	j	1876 <whisperPrintfImpl+0x64>
    1942:	4088                	lw	a0,0(s1)
    1944:	00448c93          	add	s9,s1,4
    1948:	3b59                	jal	16de <whisperPrintDecimal>
    194a:	992a                	add	s2,s2,a0
    194c:	84e6                	mv	s1,s9
    194e:	b725                	j	1876 <whisperPrintfImpl+0x64>
    1950:	4088                	lw	a0,0(s1)
    1952:	00448c93          	add	s9,s1,4
    1956:	3b01                	jal	1666 <whisperPrintUnsigned>
    1958:	bfcd                	j	194a <whisperPrintfImpl+0x138>
    195a:	00448c93          	add	s9,s1,4
    195e:	46a1                	li	a3,8
    1960:	bfb5                	j	18dc <whisperPrintfImpl+0xca>
    1962:	0004c503          	lbu	a0,0(s1)
    1966:	00448c93          	add	s9,s1,4
    196a:	cb7ff0ef          	jal	1620 <whisperPutc>
    196e:	0905                	add	s2,s2,1
    1970:	bff1                	j	194c <whisperPrintfImpl+0x13a>
    1972:	cafff0ef          	jal	1620 <whisperPutc>
    1976:	0c85                	add	s9,s9,1
    1978:	bf65                	j	1930 <whisperPrintfImpl+0x11e>

0000197a <putchar>:
    197a:	0ff57513          	zext.b	a0,a0
    197e:	ca3ff06f          	j	1620 <whisperPutc>

00001982 <puts>:
    1982:	cc3ff06f          	j	1644 <whisperPuts>

00001986 <printf>:
    1986:	7139                	add	sp,sp,-64
    1988:	d22e                	sw	a1,36(sp)
    198a:	104c                	add	a1,sp,36
    198c:	ce06                	sw	ra,28(sp)
    198e:	d432                	sw	a2,40(sp)
    1990:	d636                	sw	a3,44(sp)
    1992:	d83a                	sw	a4,48(sp)
    1994:	da3e                	sw	a5,52(sp)
    1996:	dc42                	sw	a6,56(sp)
    1998:	de46                	sw	a7,60(sp)
    199a:	c62e                	sw	a1,12(sp)
    199c:	3d9d                	jal	1812 <whisperPrintfImpl>
    199e:	40f2                	lw	ra,28(sp)
    19a0:	6121                	add	sp,sp,64
    19a2:	8082                	ret

000019a4 <sha384_core>:
    19a4:	ff0107b7          	lui	a5,0xff010
    19a8:	d0010113          	add	sp,sp,-768
    19ac:	f0078793          	add	a5,a5,-256 # ff00ff00 <_tbs_der_store_end+0xaeff0ee0>
    19b0:	c0be                	sw	a5,64(sp)
    19b2:	00ff07b7          	lui	a5,0xff0
    19b6:	0ff78793          	add	a5,a5,255 # ff00ff <_data_lma_end+0xfebd3b>
    19ba:	2f712023          	sw	s7,736(sp)
    19be:	2e812e23          	sw	s0,764(sp)
    19c2:	2e912c23          	sw	s1,760(sp)
    19c6:	2f212a23          	sw	s2,756(sp)
    19ca:	2f312823          	sw	s3,752(sp)
    19ce:	2f412623          	sw	s4,748(sp)
    19d2:	2f512423          	sw	s5,744(sp)
    19d6:	2f612223          	sw	s6,740(sp)
    19da:	2d812e23          	sw	s8,732(sp)
    19de:	2d912c23          	sw	s9,728(sp)
    19e2:	2da12a23          	sw	s10,724(sp)
    19e6:	2db12823          	sw	s11,720(sp)
    19ea:	c4aa                	sw	a0,72(sp)
    19ec:	c6ae                	sw	a1,76(sp)
    19ee:	4b81                	li	s7,0
    19f0:	c2be                	sw	a5,68(sp)
    19f2:	47b6                	lw	a5,76(sp)
    19f4:	02fbed63          	bltu	s7,a5,1a2e <sha384_core+0x8a>
    19f8:	2fc12403          	lw	s0,764(sp)
    19fc:	2f812483          	lw	s1,760(sp)
    1a00:	2f412903          	lw	s2,756(sp)
    1a04:	2f012983          	lw	s3,752(sp)
    1a08:	2ec12a03          	lw	s4,748(sp)
    1a0c:	2e812a83          	lw	s5,744(sp)
    1a10:	2e412b03          	lw	s6,740(sp)
    1a14:	2e012b83          	lw	s7,736(sp)
    1a18:	2dc12c03          	lw	s8,732(sp)
    1a1c:	2d812c83          	lw	s9,728(sp)
    1a20:	2d412d03          	lw	s10,724(sp)
    1a24:	2d012d83          	lw	s11,720(sp)
    1a28:	30010113          	add	sp,sp,768
    1a2c:	8082                	ret
    1a2e:	47a6                	lw	a5,72(sp)
    1a30:	4581                	li	a1,0
    1a32:	01778533          	add	a0,a5,s7
    1a36:	00b507b3          	add	a5,a0,a1
    1a3a:	43d4                	lw	a3,4(a5)
    1a3c:	0007a803          	lw	a6,0(a5)
    1a40:	0106d713          	srl	a4,a3,0x10
    1a44:	01081793          	sll	a5,a6,0x10
    1a48:	8fd9                	or	a5,a5,a4
    1a4a:	7741                	lui	a4,0xffff0
    1a4c:	8f7d                	and	a4,a4,a5
    1a4e:	01085813          	srl	a6,a6,0x10
    1a52:	07c2                	sll	a5,a5,0x10
    1a54:	01076733          	or	a4,a4,a6
    1a58:	06c2                	sll	a3,a3,0x10
    1a5a:	83c1                	srl	a5,a5,0x10
    1a5c:	8fd5                	or	a5,a5,a3
    1a5e:	0186d813          	srl	a6,a3,0x18
    1a62:	00871693          	sll	a3,a4,0x8
    1a66:	4406                	lw	s0,64(sp)
    1a68:	01871893          	sll	a7,a4,0x18
    1a6c:	00d866b3          	or	a3,a6,a3
    1a70:	00879813          	sll	a6,a5,0x8
    1a74:	83a1                	srl	a5,a5,0x8
    1a76:	00887833          	and	a6,a6,s0
    1a7a:	8ee1                	and	a3,a3,s0
    1a7c:	00f8e7b3          	or	a5,a7,a5
    1a80:	4416                	lw	s0,68(sp)
    1a82:	8321                	srl	a4,a4,0x8
    1a84:	8fe1                	and	a5,a5,s0
    1a86:	8f61                	and	a4,a4,s0
    1a88:	05058413          	add	s0,a1,80
    1a8c:	002408b3          	add	a7,s0,sp
    1a90:	00f867b3          	or	a5,a6,a5
    1a94:	8ed9                	or	a3,a3,a4
    1a96:	00f8a023          	sw	a5,0(a7)
    1a9a:	00d8a223          	sw	a3,4(a7)
    1a9e:	05a1                	add	a1,a1,8
    1aa0:	08000793          	li	a5,128
    1aa4:	f8f599e3          	bne	a1,a5,1a36 <sha384_core+0x92>
    1aa8:	0894                	add	a3,sp,80
    1aaa:	46cc                	lw	a1,12(a3)
    1aac:	4698                	lw	a4,8(a3)
    1aae:	00175813          	srl	a6,a4,0x1
    1ab2:	01f59793          	sll	a5,a1,0x1f
    1ab6:	0015d313          	srl	t1,a1,0x1
    1aba:	0107e7b3          	or	a5,a5,a6
    1abe:	01f71813          	sll	a6,a4,0x1f
    1ac2:	00686833          	or	a6,a6,t1
    1ac6:	01859e13          	sll	t3,a1,0x18
    1aca:	00875313          	srl	t1,a4,0x8
    1ace:	006e6e33          	or	t3,t3,t1
    1ad2:	0085de93          	srl	t4,a1,0x8
    1ad6:	01871313          	sll	t1,a4,0x18
    1ada:	01d36333          	or	t1,t1,t4
    1ade:	00684833          	xor	a6,a6,t1
    1ae2:	831d                	srl	a4,a4,0x7
    1ae4:	01959313          	sll	t1,a1,0x19
    1ae8:	00e36733          	or	a4,t1,a4
    1aec:	01c7c7b3          	xor	a5,a5,t3
    1af0:	819d                	srl	a1,a1,0x7
    1af2:	8fb9                	xor	a5,a5,a4
    1af4:	00b84833          	xor	a6,a6,a1
    1af8:	4298                	lw	a4,0(a3)
    1afa:	46ac                	lw	a1,72(a3)
    1afc:	04c6ae03          	lw	t3,76(a3)
    1b00:	0046a303          	lw	t1,4(a3)
    1b04:	95ba                	add	a1,a1,a4
    1b06:	00e5b733          	sltu	a4,a1,a4
    1b0a:	9372                	add	t1,t1,t3
    1b0c:	933a                	add	t1,t1,a4
    1b0e:	95be                	add	a1,a1,a5
    1b10:	0746a883          	lw	a7,116(a3)
    1b14:	5aa8                	lw	a0,112(a3)
    1b16:	00f5b7b3          	sltu	a5,a1,a5
    1b1a:	981a                	add	a6,a6,t1
    1b1c:	01078733          	add	a4,a5,a6
    1b20:	01355813          	srl	a6,a0,0x13
    1b24:	00d89793          	sll	a5,a7,0xd
    1b28:	0138d313          	srl	t1,a7,0x13
    1b2c:	0107e7b3          	or	a5,a5,a6
    1b30:	00d51813          	sll	a6,a0,0xd
    1b34:	00686833          	or	a6,a6,t1
    1b38:	01d8de13          	srl	t3,a7,0x1d
    1b3c:	00351313          	sll	t1,a0,0x3
    1b40:	006e6e33          	or	t3,t3,t1
    1b44:	00389e93          	sll	t4,a7,0x3
    1b48:	01d55313          	srl	t1,a0,0x1d
    1b4c:	01d36333          	or	t1,t1,t4
    1b50:	00684833          	xor	a6,a6,t1
    1b54:	8119                	srl	a0,a0,0x6
    1b56:	01a89313          	sll	t1,a7,0x1a
    1b5a:	00a36533          	or	a0,t1,a0
    1b5e:	01c7c7b3          	xor	a5,a5,t3
    1b62:	8fa9                	xor	a5,a5,a0
    1b64:	0068d893          	srl	a7,a7,0x6
    1b68:	97ae                	add	a5,a5,a1
    1b6a:	01184533          	xor	a0,a6,a7
    1b6e:	00b7b5b3          	sltu	a1,a5,a1
    1b72:	972a                	add	a4,a4,a0
    1b74:	95ba                	add	a1,a1,a4
    1b76:	08068713          	add	a4,a3,128
    1b7a:	c31c                	sw	a5,0(a4)
    1b7c:	c34c                	sw	a1,4(a4)
    1b7e:	06a1                	add	a3,a3,8
    1b80:	0c9c                	add	a5,sp,592
    1b82:	f2d794e3          	bne	a5,a3,1aaa <sha384_core+0x106>
    1b86:	425c                	lw	a5,4(a2)
    1b88:	cc3e                	sw	a5,24(sp)
    1b8a:	465c                	lw	a5,12(a2)
    1b8c:	ce3e                	sw	a5,28(sp)
    1b8e:	4a5c                	lw	a5,20(a2)
    1b90:	d03e                	sw	a5,32(sp)
    1b92:	4e1c                	lw	a5,24(a2)
    1b94:	c23e                	sw	a5,4(sp)
    1b96:	4e5c                	lw	a5,28(a2)
    1b98:	d23e                	sw	a5,36(sp)
    1b9a:	521c                	lw	a5,32(a2)
    1b9c:	c43e                	sw	a5,8(sp)
    1b9e:	525c                	lw	a5,36(a2)
    1ba0:	d43e                	sw	a5,40(sp)
    1ba2:	561c                	lw	a5,40(a2)
    1ba4:	c63e                	sw	a5,12(sp)
    1ba6:	565c                	lw	a5,44(a2)
    1ba8:	d63e                	sw	a5,44(sp)
    1baa:	5a1c                	lw	a5,48(a2)
    1bac:	c83e                	sw	a5,16(sp)
    1bae:	5a5c                	lw	a5,52(a2)
    1bb0:	d83e                	sw	a5,48(sp)
    1bb2:	5e1c                	lw	a5,56(a2)
    1bb4:	ca3e                	sw	a5,20(sp)
    1bb6:	5e5c                	lw	a5,60(a2)
    1bb8:	4204                	lw	s1,0(a2)
    1bba:	4600                	lw	s0,8(a2)
    1bbc:	01062383          	lw	t2,16(a2)
    1bc0:	da3e                	sw	a5,52(sp)
    1bc2:	4352                	lw	t1,20(sp)
    1bc4:	8d3e                	mv	s10,a5
    1bc6:	4fc2                	lw	t6,16(sp)
    1bc8:	5c42                	lw	s8,48(sp)
    1bca:	42b2                	lw	t0,12(sp)
    1bcc:	4792                	lw	a5,4(sp)
    1bce:	dc3e                	sw	a5,56(sp)
    1bd0:	5792                	lw	a5,36(sp)
    1bd2:	5cb2                	lw	s9,44(sp)
    1bd4:	46a2                	lw	a3,8(sp)
    1bd6:	5522                	lw	a0,40(sp)
    1bd8:	de3e                	sw	a5,60(sp)
    1bda:	8e9e                	mv	t4,t2
    1bdc:	5982                	lw	s3,32(sp)
    1bde:	8f22                	mv	t5,s0
    1be0:	4a72                	lw	s4,28(sp)
    1be2:	85a6                	mv	a1,s1
    1be4:	48e2                	lw	a7,24(sp)
    1be6:	4a81                	li	s5,0
    1be8:	500107b7          	lui	a5,0x50010
    1bec:	38078713          	add	a4,a5,896 # 50010380 <k>
    1bf0:	050a8793          	add	a5,s5,80
    1bf4:	9756                	add	a4,a4,s5
    1bf6:	00278e33          	add	t3,a5,sp
    1bfa:	00472803          	lw	a6,4(a4) # ffff0004 <_tbs_der_store_end+0xaffd0fe4>
    1bfe:	431c                	lw	a5,0(a4)
    1c00:	000e2703          	lw	a4,0(t3)
    1c04:	973e                	add	a4,a4,a5
    1c06:	004e2e03          	lw	t3,4(t3)
    1c0a:	9872                	add	a6,a6,t3
    1c0c:	00f737b3          	sltu	a5,a4,a5
    1c10:	fff6cb13          	not	s6,a3
    1c14:	97c2                	add	a5,a5,a6
    1c16:	01fb7b33          	and	s6,s6,t6
    1c1a:	fff54913          	not	s2,a0
    1c1e:	0056f833          	and	a6,a3,t0
    1c22:	01897933          	and	s2,s2,s8
    1c26:	010b4833          	xor	a6,s6,a6
    1c2a:	01957e33          	and	t3,a0,s9
    1c2e:	01c94e33          	xor	t3,s2,t3
    1c32:	983a                	add	a6,a6,a4
    1c34:	97f2                	add	a5,a5,t3
    1c36:	00e83733          	sltu	a4,a6,a4
    1c3a:	973e                	add	a4,a4,a5
    1c3c:	01251913          	sll	s2,a0,0x12
    1c40:	00e6d793          	srl	a5,a3,0xe
    1c44:	00f96933          	or	s2,s2,a5
    1c48:	01269e13          	sll	t3,a3,0x12
    1c4c:	00e55793          	srl	a5,a0,0xe
    1c50:	00fe6e33          	or	t3,t3,a5
    1c54:	00e51b13          	sll	s6,a0,0xe
    1c58:	0126d793          	srl	a5,a3,0x12
    1c5c:	00fb6b33          	or	s6,s6,a5
    1c60:	01255d93          	srl	s11,a0,0x12
    1c64:	00e69793          	sll	a5,a3,0xe
    1c68:	01b7e7b3          	or	a5,a5,s11
    1c6c:	01694933          	xor	s2,s2,s6
    1c70:	00fe4e33          	xor	t3,t3,a5
    1c74:	01769b13          	sll	s6,a3,0x17
    1c78:	00955793          	srl	a5,a0,0x9
    1c7c:	0167e7b3          	or	a5,a5,s6
    1c80:	01751d93          	sll	s11,a0,0x17
    1c84:	0096db13          	srl	s6,a3,0x9
    1c88:	01bb6b33          	or	s6,s6,s11
    1c8c:	00f947b3          	xor	a5,s2,a5
    1c90:	016e4e33          	xor	t3,t3,s6
    1c94:	97c2                	add	a5,a5,a6
    1c96:	0107b833          	sltu	a6,a5,a6
    1c9a:	9772                	add	a4,a4,t3
    1c9c:	933e                	add	t1,t1,a5
    1c9e:	9742                	add	a4,a4,a6
    1ca0:	976a                	add	a4,a4,s10
    1ca2:	00f337b3          	sltu	a5,t1,a5
    1ca6:	97ba                	add	a5,a5,a4
    1ca8:	00489813          	sll	a6,a7,0x4
    1cac:	01c5d713          	srl	a4,a1,0x1c
    1cb0:	00e86833          	or	a6,a6,a4
    1cb4:	00459e13          	sll	t3,a1,0x4
    1cb8:	01c8d713          	srl	a4,a7,0x1c
    1cbc:	00ee6e33          	or	t3,t3,a4
    1cc0:	0028d913          	srl	s2,a7,0x2
    1cc4:	01e59713          	sll	a4,a1,0x1e
    1cc8:	00e96933          	or	s2,s2,a4
    1ccc:	01e89b13          	sll	s6,a7,0x1e
    1cd0:	0025d713          	srl	a4,a1,0x2
    1cd4:	01676733          	or	a4,a4,s6
    1cd8:	01284833          	xor	a6,a6,s2
    1cdc:	00ee4e33          	xor	t3,t3,a4
    1ce0:	0078d913          	srl	s2,a7,0x7
    1ce4:	01959713          	sll	a4,a1,0x19
    1ce8:	00e96933          	or	s2,s2,a4
    1cec:	01989b13          	sll	s6,a7,0x19
    1cf0:	0075d713          	srl	a4,a1,0x7
    1cf4:	01676733          	or	a4,a4,s6
    1cf8:	01df4d33          	xor	s10,t5,t4
    1cfc:	00ee4e33          	xor	t3,t3,a4
    1d00:	00bd7d33          	and	s10,s10,a1
    1d04:	013a4b33          	xor	s6,s4,s3
    1d08:	01df7733          	and	a4,t5,t4
    1d0c:	01284833          	xor	a6,a6,s2
    1d10:	011b7b33          	and	s6,s6,a7
    1d14:	00ed4733          	xor	a4,s10,a4
    1d18:	013a7933          	and	s2,s4,s3
    1d1c:	012b4933          	xor	s2,s6,s2
    1d20:	9742                	add	a4,a4,a6
    1d22:	9e4a                	add	t3,t3,s2
    1d24:	01073833          	sltu	a6,a4,a6
    1d28:	9872                	add	a6,a6,t3
    1d2a:	5e62                	lw	t3,56(sp)
    1d2c:	01c30933          	add	s2,t1,t3
    1d30:	971a                	add	a4,a4,t1
    1d32:	5e72                	lw	t3,60(sp)
    1d34:	00693b33          	sltu	s6,s2,t1
    1d38:	9e3e                	add	t3,t3,a5
    1d3a:	00673333          	sltu	t1,a4,t1
    1d3e:	97c2                	add	a5,a5,a6
    1d40:	0aa1                	add	s5,s5,8
    1d42:	dc76                	sw	t4,56(sp)
    1d44:	de4e                	sw	s3,60(sp)
    1d46:	28000813          	li	a6,640
    1d4a:	979a                	add	a5,a5,t1
    1d4c:	9b72                	add	s6,s6,t3
    1d4e:	837e                	mv	t1,t6
    1d50:	8d62                	mv	s10,s8
    1d52:	0b0a9063          	bne	s5,a6,1df2 <sha384_core+0x44e>
    1d56:	9726                	add	a4,a4,s1
    1d58:	4862                	lw	a6,24(sp)
    1d5a:	009734b3          	sltu	s1,a4,s1
    1d5e:	97c2                	add	a5,a5,a6
    1d60:	94be                	add	s1,s1,a5
    1d62:	95a2                	add	a1,a1,s0
    1d64:	47f2                	lw	a5,28(sp)
    1d66:	97c6                	add	a5,a5,a7
    1d68:	0085b433          	sltu	s0,a1,s0
    1d6c:	943e                	add	s0,s0,a5
    1d6e:	9f1e                	add	t5,t5,t2
    1d70:	5782                	lw	a5,32(sp)
    1d72:	97d2                	add	a5,a5,s4
    1d74:	007f33b3          	sltu	t2,t5,t2
    1d78:	93be                	add	t2,t2,a5
    1d7a:	4792                	lw	a5,4(sp)
    1d7c:	9ebe                	add	t4,t4,a5
    1d7e:	c218                	sw	a4,0(a2)
    1d80:	5712                	lw	a4,36(sp)
    1d82:	974e                	add	a4,a4,s3
    1d84:	00feb7b3          	sltu	a5,t4,a5
    1d88:	97ba                	add	a5,a5,a4
    1d8a:	ce5c                	sw	a5,28(a2)
    1d8c:	47a2                	lw	a5,8(sp)
    1d8e:	993e                	add	s2,s2,a5
    1d90:	5722                	lw	a4,40(sp)
    1d92:	975a                	add	a4,a4,s6
    1d94:	00f937b3          	sltu	a5,s2,a5
    1d98:	97ba                	add	a5,a5,a4
    1d9a:	d25c                	sw	a5,36(a2)
    1d9c:	47b2                	lw	a5,12(sp)
    1d9e:	96be                	add	a3,a3,a5
    1da0:	5732                	lw	a4,44(sp)
    1da2:	972a                	add	a4,a4,a0
    1da4:	00f6b7b3          	sltu	a5,a3,a5
    1da8:	97ba                	add	a5,a5,a4
    1daa:	d65c                	sw	a5,44(a2)
    1dac:	47c2                	lw	a5,16(sp)
    1dae:	92be                	add	t0,t0,a5
    1db0:	5742                	lw	a4,48(sp)
    1db2:	9766                	add	a4,a4,s9
    1db4:	00f2b7b3          	sltu	a5,t0,a5
    1db8:	97ba                	add	a5,a5,a4
    1dba:	da5c                	sw	a5,52(a2)
    1dbc:	47d2                	lw	a5,20(sp)
    1dbe:	9fbe                	add	t6,t6,a5
    1dc0:	5752                	lw	a4,52(sp)
    1dc2:	00ffb7b3          	sltu	a5,t6,a5
    1dc6:	9762                	add	a4,a4,s8
    1dc8:	97ba                	add	a5,a5,a4
    1dca:	c244                	sw	s1,4(a2)
    1dcc:	c60c                	sw	a1,8(a2)
    1dce:	c640                	sw	s0,12(a2)
    1dd0:	01e62823          	sw	t5,16(a2)
    1dd4:	00762a23          	sw	t2,20(a2)
    1dd8:	01d62c23          	sw	t4,24(a2)
    1ddc:	03262023          	sw	s2,32(a2)
    1de0:	d614                	sw	a3,40(a2)
    1de2:	02562823          	sw	t0,48(a2)
    1de6:	03f62c23          	sw	t6,56(a2)
    1dea:	de5c                	sw	a5,60(a2)
    1dec:	080b8b93          	add	s7,s7,128
    1df0:	b109                	j	19f2 <sha384_core+0x4e>
    1df2:	8f96                	mv	t6,t0
    1df4:	8c66                	mv	s8,s9
    1df6:	82b6                	mv	t0,a3
    1df8:	8caa                	mv	s9,a0
    1dfa:	8efa                	mv	t4,t5
    1dfc:	89d2                	mv	s3,s4
    1dfe:	8f2e                	mv	t5,a1
    1e00:	8a46                	mv	s4,a7
    1e02:	86ca                	mv	a3,s2
    1e04:	855a                	mv	a0,s6
    1e06:	85ba                	mv	a1,a4
    1e08:	88be                	mv	a7,a5
    1e0a:	bbf9                	j	1be8 <sha384_core+0x244>

00001e0c <sha384_digest>:
    1e0c:	7129                	add	sp,sp,-320
    1e0e:	12812c23          	sw	s0,312(sp)
    1e12:	01058413          	add	s0,a1,16
    1e16:	13412423          	sw	s4,296(sp)
    1e1a:	13612023          	sw	s6,288(sp)
    1e1e:	8a36                	mv	s4,a3
    1e20:	07f47b13          	and	s6,s0,127
    1e24:	08000693          	li	a3,128
    1e28:	416686b3          	sub	a3,a3,s6
    1e2c:	13312623          	sw	s3,300(sp)
    1e30:	07000993          	li	s3,112
    1e34:	00d9b9b3          	sltu	s3,s3,a3
    1e38:	12912a23          	sw	s1,308(sp)
    1e3c:	13212823          	sw	s2,304(sp)
    1e40:	11712e23          	sw	s7,284(sp)
    1e44:	099e                	sll	s3,s3,0x7
    1e46:	12112e23          	sw	ra,316(sp)
    1e4a:	13512223          	sw	s5,292(sp)
    1e4e:	11812c23          	sw	s8,280(sp)
    1e52:	8baa                	mv	s7,a0
    1e54:	84ae                	mv	s1,a1
    1e56:	8932                	mv	s2,a2
    1e58:	08098993          	add	s3,s3,128
    1e5c:	9436                	add	s0,s0,a3
    1e5e:	000a0b63          	beqz	s4,1e74 <sha384_digest+0x68>
    1e62:	50010537          	lui	a0,0x50010
    1e66:	862e                	mv	a2,a1
    1e68:	874e                	mv	a4,s3
    1e6a:	85a2                	mv	a1,s0
    1e6c:	2ac50513          	add	a0,a0,684 # 500102ac <tbs_len+0x130>
    1e70:	b17ff0ef          	jal	1986 <printf>
    1e74:	500117b7          	lui	a5,0x50011
    1e78:	b787a703          	lw	a4,-1160(a5) # 50010b78 <k+0x7f8>
    1e7c:	b7c7a783          	lw	a5,-1156(a5)
    1e80:	00f92223          	sw	a5,4(s2)
    1e84:	500117b7          	lui	a5,0x50011
    1e88:	00e92023          	sw	a4,0(s2)
    1e8c:	b807a703          	lw	a4,-1152(a5) # 50010b80 <k+0x800>
    1e90:	b847a783          	lw	a5,-1148(a5)
    1e94:	00f92623          	sw	a5,12(s2)
    1e98:	500117b7          	lui	a5,0x50011
    1e9c:	00e92423          	sw	a4,8(s2)
    1ea0:	b887a703          	lw	a4,-1144(a5) # 50010b88 <k+0x808>
    1ea4:	b8c7a783          	lw	a5,-1140(a5)
    1ea8:	00f92a23          	sw	a5,20(s2)
    1eac:	500117b7          	lui	a5,0x50011
    1eb0:	00e92823          	sw	a4,16(s2)
    1eb4:	b907a703          	lw	a4,-1136(a5) # 50010b90 <k+0x810>
    1eb8:	b947a783          	lw	a5,-1132(a5)
    1ebc:	00f92e23          	sw	a5,28(s2)
    1ec0:	500117b7          	lui	a5,0x50011
    1ec4:	00e92c23          	sw	a4,24(s2)
    1ec8:	b987a703          	lw	a4,-1128(a5) # 50010b98 <k+0x818>
    1ecc:	b9c7a783          	lw	a5,-1124(a5)
    1ed0:	02f92223          	sw	a5,36(s2)
    1ed4:	500117b7          	lui	a5,0x50011
    1ed8:	02e92023          	sw	a4,32(s2)
    1edc:	ba07a703          	lw	a4,-1120(a5) # 50010ba0 <k+0x820>
    1ee0:	ba47a783          	lw	a5,-1116(a5)
    1ee4:	02f92623          	sw	a5,44(s2)
    1ee8:	500117b7          	lui	a5,0x50011
    1eec:	02e92423          	sw	a4,40(s2)
    1ef0:	ba87a703          	lw	a4,-1112(a5) # 50010ba8 <k+0x828>
    1ef4:	bac7a783          	lw	a5,-1108(a5)
    1ef8:	02f92a23          	sw	a5,52(s2)
    1efc:	500117b7          	lui	a5,0x50011
    1f00:	02e92823          	sw	a4,48(s2)
    1f04:	41340c33          	sub	s8,s0,s3
    1f08:	bb07a703          	lw	a4,-1104(a5) # 50010bb0 <k+0x830>
    1f0c:	bb47a783          	lw	a5,-1100(a5)
    1f10:	02e92c23          	sw	a4,56(s2)
    1f14:	02f92e23          	sw	a5,60(s2)
    1f18:	864a                	mv	a2,s2
    1f1a:	85e2                	mv	a1,s8
    1f1c:	855e                	mv	a0,s7
    1f1e:	a87ff0ef          	jal	19a4 <sha384_core>
    1f22:	000a0863          	beqz	s4,1f32 <sha384_digest+0x126>
    1f26:	50010537          	lui	a0,0x50010
    1f2a:	30050513          	add	a0,a0,768 # 50010300 <tbs_len+0x184>
    1f2e:	a55ff0ef          	jal	1982 <puts>
    1f32:	40848433          	sub	s0,s1,s0
    1f36:	944e                	add	s0,s0,s3
    1f38:	01010a93          	add	s5,sp,16
    1f3c:	8622                	mv	a2,s0
    1f3e:	018b85b3          	add	a1,s7,s8
    1f42:	8556                	mv	a0,s5
    1f44:	778010ef          	jal	36bc <memcpy>
    1f48:	11040793          	add	a5,s0,272
    1f4c:	978a                	add	a5,a5,sp
    1f4e:	f8000713          	li	a4,-128
    1f52:	00140513          	add	a0,s0,1
    1f56:	41640433          	sub	s0,s0,s6
    1f5a:	f0e78023          	sb	a4,-256(a5)
    1f5e:	08840413          	add	s0,s0,136
    1f62:	4601                	li	a2,0
    1f64:	00a46663          	bltu	s0,a0,1f70 <sha384_digest+0x164>
    1f68:	08700613          	li	a2,135
    1f6c:	41660633          	sub	a2,a2,s6
    1f70:	4581                	li	a1,0
    1f72:	9556                	add	a0,a0,s5
    1f74:	6a0010ef          	jal	3614 <memset>
    1f78:	00349793          	sll	a5,s1,0x3
    1f7c:	83c1                	srl	a5,a5,0x10
    1f7e:	04ce                	sll	s1,s1,0x13
    1f80:	8cdd                	or	s1,s1,a5
    1f82:	ff010737          	lui	a4,0xff010
    1f86:	00849793          	sll	a5,s1,0x8
    1f8a:	f0070713          	add	a4,a4,-256 # ff00ff00 <_tbs_der_store_end+0xaeff0ee0>
    1f8e:	8ff9                	and	a5,a5,a4
    1f90:	00ff0737          	lui	a4,0xff0
    1f94:	80a1                	srl	s1,s1,0x8
    1f96:	0ff70713          	add	a4,a4,255 # ff00ff <_data_lma_end+0xfebd3b>
    1f9a:	8cf9                	and	s1,s1,a4
    1f9c:	4621                	li	a2,8
    1f9e:	8fc5                	or	a5,a5,s1
    1fa0:	00c105b3          	add	a1,sp,a2
    1fa4:	008a8533          	add	a0,s5,s0
    1fa8:	c402                	sw	zero,8(sp)
    1faa:	c63e                	sw	a5,12(sp)
    1fac:	710010ef          	jal	36bc <memcpy>
    1fb0:	000a0863          	beqz	s4,1fc0 <sha384_digest+0x1b4>
    1fb4:	50010537          	lui	a0,0x50010
    1fb8:	33050513          	add	a0,a0,816 # 50010330 <tbs_len+0x1b4>
    1fbc:	9c7ff0ef          	jal	1982 <puts>
    1fc0:	864a                	mv	a2,s2
    1fc2:	85ce                	mv	a1,s3
    1fc4:	8556                	mv	a0,s5
    1fc6:	9dfff0ef          	jal	19a4 <sha384_core>
    1fca:	020a0d63          	beqz	s4,2004 <sha384_digest+0x1f8>
    1fce:	13812403          	lw	s0,312(sp)
    1fd2:	50010537          	lui	a0,0x50010
    1fd6:	13c12083          	lw	ra,316(sp)
    1fda:	13412483          	lw	s1,308(sp)
    1fde:	13012903          	lw	s2,304(sp)
    1fe2:	12c12983          	lw	s3,300(sp)
    1fe6:	12812a03          	lw	s4,296(sp)
    1fea:	12412a83          	lw	s5,292(sp)
    1fee:	12012b03          	lw	s6,288(sp)
    1ff2:	11c12b83          	lw	s7,284(sp)
    1ff6:	11812c03          	lw	s8,280(sp)
    1ffa:	35050513          	add	a0,a0,848 # 50010350 <tbs_len+0x1d4>
    1ffe:	6131                	add	sp,sp,320
    2000:	983ff06f          	j	1982 <puts>
    2004:	13c12083          	lw	ra,316(sp)
    2008:	13812403          	lw	s0,312(sp)
    200c:	13412483          	lw	s1,308(sp)
    2010:	13012903          	lw	s2,304(sp)
    2014:	12c12983          	lw	s3,300(sp)
    2018:	12812a03          	lw	s4,296(sp)
    201c:	12412a83          	lw	s5,292(sp)
    2020:	12012b03          	lw	s6,288(sp)
    2024:	11c12b83          	lw	s7,284(sp)
    2028:	11812c03          	lw	s8,280(sp)
    202c:	6131                	add	sp,sp,320
    202e:	8082                	ret

00002030 <soc_ifc_set_flow_status_field>:
    2030:	1141                	add	sp,sp,-16
    2032:	c422                	sw	s0,8(sp)
    2034:	85aa                	mv	a1,a0
    2036:	842a                	mv	s0,a0
    2038:	50010537          	lui	a0,0x50010
    203c:	60050513          	add	a0,a0,1536 # 50010600 <k+0x280>
    2040:	c606                	sw	ra,12(sp)
    2042:	945ff0ef          	jal	1986 <printf>
    2046:	300307b7          	lui	a5,0x30030
    204a:	5fdc                	lw	a5,60(a5)
    204c:	00841693          	sll	a3,s0,0x8
    2050:	00f46733          	or	a4,s0,a5
    2054:	c691                	beqz	a3,2060 <soc_ifc_set_flow_status_field+0x30>
    2056:	ff000737          	lui	a4,0xff000
    205a:	8ff9                	and	a5,a5,a4
    205c:	0087e733          	or	a4,a5,s0
    2060:	0220000f          	fence	r,r
    2064:	0220000f          	fence	r,r
    2068:	300307b7          	lui	a5,0x30030
    206c:	40b2                	lw	ra,12(sp)
    206e:	4422                	lw	s0,8(sp)
    2070:	dfd8                	sw	a4,60(a5)
    2072:	0141                	add	sp,sp,16
    2074:	8082                	ret

00002076 <soc_ifc_read_mbox_cmd>:
    2076:	1141                	add	sp,sp,-16
    2078:	300207b7          	lui	a5,0x30020
    207c:	478c                	lw	a1,8(a5)
    207e:	47c8                	lw	a0,12(a5)
    2080:	0141                	add	sp,sp,16
    2082:	8082                	ret

00002084 <end_sim_if_itrng_disabled>:
    2084:	300307b7          	lui	a5,0x30030
    2088:	0e07a783          	lw	a5,224(a5) # 300300e0 <_data_lma_end+0x3002bd1c>
    208c:	8b85                	and	a5,a5,1
    208e:	e391                	bnez	a5,2092 <end_sim_if_itrng_disabled+0xe>
    2090:	a001                	j	2090 <end_sim_if_itrng_disabled+0xc>
    2092:	8082                	ret

00002094 <enable_csrng>:
    2094:	1141                	add	sp,sp,-16
    2096:	c606                	sw	ra,12(sp)
    2098:	37f5                	jal	2084 <end_sim_if_itrng_disabled>
    209a:	0220000f          	fence	r,r
    209e:	0220000f          	fence	r,r
    20a2:	009097b7          	lui	a5,0x909
    20a6:	20003737          	lui	a4,0x20003
    20aa:	09978793          	add	a5,a5,153 # 909099 <_data_lma_end+0x904cd5>
    20ae:	d35c                	sw	a5,36(a4)
    20b0:	0220000f          	fence	r,r
    20b4:	0220000f          	fence	r,r
    20b8:	87ba                	mv	a5,a4
    20ba:	4719                	li	a4,6
    20bc:	d398                	sw	a4,32(a5)
    20be:	0220000f          	fence	r,r
    20c2:	0220000f          	fence	r,r
    20c6:	200027b7          	lui	a5,0x20002
    20ca:	66600713          	li	a4,1638
    20ce:	cbd8                	sw	a4,20(a5)
    20d0:	0220000f          	fence	r,r
    20d4:	0220000f          	fence	r,r
    20d8:	873e                	mv	a4,a5
    20da:	6785                	lui	a5,0x1
    20dc:	90178793          	add	a5,a5,-1791 # 901 <vli_modSquare_fast+0xa7>
    20e0:	cf1c                	sw	a5,24(a4)
    20e2:	200037b7          	lui	a5,0x20003
    20e6:	0d078793          	add	a5,a5,208 # 200030d0 <_data_lma_end+0x1fffed0c>
    20ea:	00020737          	lui	a4,0x20
    20ee:	4394                	lw	a3,0(a5)
    20f0:	fee69fe3          	bne	a3,a4,20ee <enable_csrng+0x5a>
    20f4:	40b2                	lw	ra,12(sp)
    20f6:	0141                	add	sp,sp,16
    20f8:	8082                	ret

000020fa <generate_random_numbers>:
    20fa:	86aa                	mv	a3,a0
    20fc:	557d                	li	a0,-1
    20fe:	08d05363          	blez	a3,2184 <generate_random_numbers+0x8a>
    2102:	c1c9                	beqz	a1,2184 <generate_random_numbers+0x8a>
    2104:	0220000f          	fence	r,r
    2108:	0220000f          	fence	r,r
    210c:	6785                	lui	a5,0x1
    210e:	20002737          	lui	a4,0x20002
    2112:	078d                	add	a5,a5,3 # 1003 <ecc_point_decompress+0x19>
    2114:	cf1c                	sw	a5,24(a4)
    2116:	02070793          	add	a5,a4,32 # 20002020 <_data_lma_end+0x1fffdc5c>
    211a:	4705                	li	a4,1
    211c:	4390                	lw	a2,0(a5)
    211e:	fee61fe3          	bne	a2,a4,211c <generate_random_numbers+0x22>
    2122:	20002637          	lui	a2,0x20002
    2126:	6515                	lui	a0,0x5
    2128:	20002837          	lui	a6,0x20002
    212c:	200028b7          	lui	a7,0x20002
    2130:	4701                	li	a4,0
    2132:	0661                	add	a2,a2,24 # 20002018 <_data_lma_end+0x1fffdc54>
    2134:	90350513          	add	a0,a0,-1789 # 4903 <_data_lma_end+0x53f>
    2138:	02080813          	add	a6,a6,32 # 20002020 <_data_lma_end+0x1fffdc5c>
    213c:	4305                	li	t1,1
    213e:	02488893          	add	a7,a7,36 # 20002024 <_data_lma_end+0x1fffdc60>
    2142:	00377793          	and	a5,a4,3
    2146:	eb8d                	bnez	a5,2178 <generate_random_numbers+0x7e>
    2148:	0220000f          	fence	r,r
    214c:	0220000f          	fence	r,r
    2150:	c208                	sw	a0,0(a2)
    2152:	00082783          	lw	a5,0(a6)
    2156:	fe679ee3          	bne	a5,t1,2152 <generate_random_numbers+0x58>
    215a:	0008a783          	lw	a5,0(a7)
    215e:	0087de13          	srl	t3,a5,0x8
    2162:	00f58023          	sb	a5,0(a1)
    2166:	01c580a3          	sb	t3,1(a1)
    216a:	0107de13          	srl	t3,a5,0x10
    216e:	83e1                	srl	a5,a5,0x18
    2170:	01c58123          	sb	t3,2(a1)
    2174:	00f581a3          	sb	a5,3(a1)
    2178:	0705                	add	a4,a4,1
    217a:	0585                	add	a1,a1,1
    217c:	fce693e3          	bne	a3,a4,2142 <generate_random_numbers+0x48>
    2180:	4501                	li	a0,0
    2182:	8082                	ret
    2184:	8082                	ret

00002186 <uart_tx>:
    2186:	20001737          	lui	a4,0x20001
    218a:	0751                	add	a4,a4,20 # 20001014 <_data_lma_end+0x1fffcc50>
    218c:	431c                	lw	a5,0(a4)
    218e:	8b85                	and	a5,a5,1
    2190:	fff5                	bnez	a5,218c <uart_tx+0x6>
    2192:	0220000f          	fence	r,r
    2196:	0220000f          	fence	r,r
    219a:	200017b7          	lui	a5,0x20001
    219e:	cfc8                	sw	a0,28(a5)
    21a0:	8082                	ret

000021a2 <enable_uart>:
    21a2:	0220000f          	fence	r,r
    21a6:	0220000f          	fence	r,r
    21aa:	04b707b7          	lui	a5,0x4b70
    21ae:	20001737          	lui	a4,0x20001
    21b2:	078d                	add	a5,a5,3 # 4b70003 <_data_lma_end+0x4b6bc3f>
    21b4:	cb1c                	sw	a5,16(a4)
    21b6:	8082                	ret

000021b8 <end_sim_if_uart_disabled>:
    21b8:	300307b7          	lui	a5,0x30030
    21bc:	0e07a783          	lw	a5,224(a5) # 300300e0 <_data_lma_end+0x3002bd1c>
    21c0:	8ba1                	and	a5,a5,8
    21c2:	e391                	bnez	a5,21c6 <end_sim_if_uart_disabled+0xe>
    21c4:	a001                	j	21c4 <end_sim_if_uart_disabled+0xc>
    21c6:	8082                	ret

000021c8 <init_uart>:
    21c8:	1141                	add	sp,sp,-16
    21ca:	c606                	sw	ra,12(sp)
    21cc:	37f5                	jal	21b8 <end_sim_if_uart_disabled>
    21ce:	40b2                	lw	ra,12(sp)
    21d0:	0141                	add	sp,sp,16
    21d2:	bfc1                	j	21a2 <enable_uart>

000021d4 <asn1_write_tag>:
    21d4:	411c                	lw	a5,0(a0)
    21d6:	1141                	add	sp,sp,-16
    21d8:	c422                	sw	s0,8(sp)
    21da:	c226                	sw	s1,4(sp)
    21dc:	c606                	sw	ra,12(sp)
    21de:	84b6                	mv	s1,a3
    21e0:	00178693          	add	a3,a5,1
    21e4:	872e                	mv	a4,a1
    21e6:	c114                	sw	a3,0(a0)
    21e8:	00e78023          	sb	a4,0(a5)
    21ec:	07f00693          	li	a3,127
    21f0:	842a                	mv	s0,a0
    21f2:	85b2                	mv	a1,a2
    21f4:	0ff4f713          	zext.b	a4,s1
    21f8:	411c                	lw	a5,0(a0)
    21fa:	0296e363          	bltu	a3,s1,2220 <asn1_write_tag+0x4c>
    21fe:	00178693          	add	a3,a5,1
    2202:	c014                	sw	a3,0(s0)
    2204:	00e78023          	sb	a4,0(a5)
    2208:	8626                	mv	a2,s1
    220a:	4008                	lw	a0,0(s0)
    220c:	4b0010ef          	jal	36bc <memcpy>
    2210:	401c                	lw	a5,0(s0)
    2212:	97a6                	add	a5,a5,s1
    2214:	c01c                	sw	a5,0(s0)
    2216:	40b2                	lw	ra,12(sp)
    2218:	4422                	lw	s0,8(sp)
    221a:	4492                	lw	s1,4(sp)
    221c:	0141                	add	sp,sp,16
    221e:	8082                	ret
    2220:	00178693          	add	a3,a5,1
    2224:	c114                	sw	a3,0(a0)
    2226:	f8200693          	li	a3,-126
    222a:	00d78023          	sb	a3,0(a5)
    222e:	411c                	lw	a5,0(a0)
    2230:	00178693          	add	a3,a5,1
    2234:	c114                	sw	a3,0(a0)
    2236:	0084d693          	srl	a3,s1,0x8
    223a:	00d78023          	sb	a3,0(a5)
    223e:	411c                	lw	a5,0(a0)
    2240:	bf7d                	j	21fe <asn1_write_tag+0x2a>

00002242 <encode_dn>:
    2242:	7161                	add	sp,sp,-432
    2244:	1a912223          	sw	s1,420(sp)
    2248:	1b212023          	sw	s2,416(sp)
    224c:	19412c23          	sw	s4,408(sp)
    2250:	45500793          	li	a5,1109
    2254:	01010a13          	add	s4,sp,16
    2258:	84ae                	mv	s1,a1
    225a:	468d                	li	a3,3
    225c:	860a                	mv	a2,sp
    225e:	892a                	mv	s2,a0
    2260:	4599                	li	a1,6
    2262:	0048                	add	a0,sp,4
    2264:	1a112623          	sw	ra,428(sp)
    2268:	19312e23          	sw	s3,412(sp)
    226c:	1a812423          	sw	s0,424(sp)
    2270:	00f11023          	sh	a5,0(sp)
    2274:	00d10123          	sb	a3,2(sp)
    2278:	c252                	sw	s4,4(sp)
    227a:	3fa9                	jal	21d4 <asn1_write_tag>
    227c:	8526                	mv	a0,s1
    227e:	52a010ef          	jal	37a8 <strlen>
    2282:	86aa                	mv	a3,a0
    2284:	8626                	mv	a2,s1
    2286:	0048                	add	a0,sp,4
    2288:	45b1                	li	a1,12
    228a:	37a9                	jal	21d4 <asn1_write_tag>
    228c:	4692                	lw	a3,4(sp)
    228e:	09010993          	add	s3,sp,144
    2292:	414686b3          	sub	a3,a3,s4
    2296:	8652                	mv	a2,s4
    2298:	0028                	add	a0,sp,8
    229a:	03000593          	li	a1,48
    229e:	c44e                	sw	s3,8(sp)
    22a0:	3f15                	jal	21d4 <asn1_write_tag>
    22a2:	46a2                	lw	a3,8(sp)
    22a4:	0a04                	add	s1,sp,272
    22a6:	413686b3          	sub	a3,a3,s3
    22aa:	864e                	mv	a2,s3
    22ac:	0068                	add	a0,sp,12
    22ae:	03100593          	li	a1,49
    22b2:	c626                	sw	s1,12(sp)
    22b4:	3705                	jal	21d4 <asn1_write_tag>
    22b6:	46b2                	lw	a3,12(sp)
    22b8:	8e85                	sub	a3,a3,s1
    22ba:	8626                	mv	a2,s1
    22bc:	854a                	mv	a0,s2
    22be:	03000593          	li	a1,48
    22c2:	3f09                	jal	21d4 <asn1_write_tag>
    22c4:	1ac12083          	lw	ra,428(sp)
    22c8:	1a812403          	lw	s0,424(sp)
    22cc:	1a412483          	lw	s1,420(sp)
    22d0:	1a012903          	lw	s2,416(sp)
    22d4:	19c12983          	lw	s3,412(sp)
    22d8:	19812a03          	lw	s4,408(sp)
    22dc:	615d                	add	sp,sp,432
    22de:	8082                	ret

000022e0 <build_x509_extension.constprop.0>:
    22e0:	7171                	add	sp,sp,-176
    22e2:	d522                	sw	s0,168(sp)
    22e4:	d326                	sw	s1,164(sp)
    22e6:	d14a                	sw	s2,160(sp)
    22e8:	cf4e                	sw	s3,156(sp)
    22ea:	0804                	add	s1,sp,16
    22ec:	842a                	mv	s0,a0
    22ee:	8932                	mv	s2,a2
    22f0:	89b6                	mv	s3,a3
    22f2:	862e                	mv	a2,a1
    22f4:	0068                	add	a0,sp,12
    22f6:	468d                	li	a3,3
    22f8:	4599                	li	a1,6
    22fa:	d706                	sw	ra,172(sp)
    22fc:	c626                	sw	s1,12(sp)
    22fe:	3dd9                	jal	21d4 <asn1_write_tag>
    2300:	4685                	li	a3,1
    2302:	57fd                	li	a5,-1
    2304:	00b10613          	add	a2,sp,11
    2308:	85b6                	mv	a1,a3
    230a:	0068                	add	a0,sp,12
    230c:	00f105a3          	sb	a5,11(sp)
    2310:	35d1                	jal	21d4 <asn1_write_tag>
    2312:	86ce                	mv	a3,s3
    2314:	864a                	mv	a2,s2
    2316:	0068                	add	a0,sp,12
    2318:	4591                	li	a1,4
    231a:	3d6d                	jal	21d4 <asn1_write_tag>
    231c:	46b2                	lw	a3,12(sp)
    231e:	8e85                	sub	a3,a3,s1
    2320:	8626                	mv	a2,s1
    2322:	8522                	mv	a0,s0
    2324:	03000593          	li	a1,48
    2328:	3575                	jal	21d4 <asn1_write_tag>
    232a:	50ba                	lw	ra,172(sp)
    232c:	542a                	lw	s0,168(sp)
    232e:	549a                	lw	s1,164(sp)
    2330:	590a                	lw	s2,160(sp)
    2332:	49fa                	lw	s3,156(sp)
    2334:	614d                	add	sp,sp,176
    2336:	8082                	ret

00002338 <convert_le32_to_be_bytes>:
    2338:	4781                	li	a5,0
    233a:	00c79363          	bne	a5,a2,2340 <convert_le32_to_be_bytes+0x8>
    233e:	8082                	ret
    2340:	00279713          	sll	a4,a5,0x2
    2344:	972e                	add	a4,a4,a1
    2346:	4318                	lw	a4,0(a4)
    2348:	01875693          	srl	a3,a4,0x18
    234c:	00d50023          	sb	a3,0(a0)
    2350:	01075693          	srl	a3,a4,0x10
    2354:	00d500a3          	sb	a3,1(a0)
    2358:	00875693          	srl	a3,a4,0x8
    235c:	00d50123          	sb	a3,2(a0)
    2360:	00e501a3          	sb	a4,3(a0)
    2364:	0785                	add	a5,a5,1
    2366:	0511                	add	a0,a0,4
    2368:	bfc9                	j	233a <convert_le32_to_be_bytes+0x2>

0000236a <generate_intermediate_tbs_der>:
    236a:	34050463          	beqz	a0,26b2 <generate_intermediate_tbs_der+0x348>
    236e:	ad010113          	add	sp,sp,-1328
    2372:	52912223          	sw	s1,1316(sp)
    2376:	52112623          	sw	ra,1324(sp)
    237a:	52812423          	sw	s0,1320(sp)
    237e:	53212023          	sw	s2,1312(sp)
    2382:	51312e23          	sw	s3,1308(sp)
    2386:	51412c23          	sw	s4,1304(sp)
    238a:	51512a23          	sw	s5,1300(sp)
    238e:	51612823          	sw	s6,1296(sp)
    2392:	51712623          	sw	s7,1292(sp)
    2396:	51812423          	sw	s8,1288(sp)
    239a:	51912223          	sw	s9,1284(sp)
    239e:	51a12023          	sw	s10,1280(sp)
    23a2:	4fb12e23          	sw	s11,1276(sp)
    23a6:	84ae                	mv	s1,a1
    23a8:	58f9                	li	a7,-2
    23aa:	2c058663          	beqz	a1,2676 <generate_intermediate_tbs_der+0x30c>
    23ae:	8bb2                	mv	s7,a2
    23b0:	2c060363          	beqz	a2,2676 <generate_intermediate_tbs_der+0x30c>
    23b4:	8b36                	mv	s6,a3
    23b6:	2c068063          	beqz	a3,2676 <generate_intermediate_tbs_der+0x30c>
    23ba:	843a                	mv	s0,a4
    23bc:	2a070d63          	beqz	a4,2676 <generate_intermediate_tbs_der+0x30c>
    23c0:	89be                	mv	s3,a5
    23c2:	2a078a63          	beqz	a5,2676 <generate_intermediate_tbs_der+0x30c>
    23c6:	4398                	lw	a4,0(a5)
    23c8:	1ff00793          	li	a5,511
    23cc:	2ae7f563          	bgeu	a5,a4,2676 <generate_intermediate_tbs_der+0x30c>
    23d0:	010207b7          	lui	a5,0x1020
    23d4:	3a078793          	add	a5,a5,928 # 10203a0 <_data_lma_end+0x101bfdc>
    23d8:	500105b7          	lui	a1,0x50010
    23dc:	892a                	mv	s2,a0
    23de:	dc3e                	sw	a5,56(sp)
    23e0:	4631                	li	a2,12
    23e2:	4789                	li	a5,2
    23e4:	62858593          	add	a1,a1,1576 # 50010628 <k+0x2a8>
    23e8:	08a8                	add	a0,sp,88
    23ea:	8c42                	mv	s8,a6
    23ec:	02f10e23          	sb	a5,60(sp)
    23f0:	d022                	sw	s0,32(sp)
    23f2:	2ca010ef          	jal	36bc <memcpy>
    23f6:	500105b7          	lui	a1,0x50010
    23fa:	02400613          	li	a2,36
    23fe:	63858593          	add	a1,a1,1592 # 50010638 <k+0x2b8>
    2402:	1148                	add	a0,sp,164
    2404:	2b8010ef          	jal	36bc <memcpy>
    2408:	341207b7          	lui	a5,0x34120
    240c:	40278793          	add	a5,a5,1026 # 34120402 <_data_lma_end+0x3411c03e>
    2410:	c4be                	sw	a5,72(sp)
    2412:	500105b7          	lui	a1,0x50010
    2416:	67a1                	lui	a5,0x8
    2418:	85678793          	add	a5,a5,-1962 # 7856 <_data_lma_end+0x3492>
    241c:	461d                	li	a2,7
    241e:	66058593          	add	a1,a1,1632 # 50010660 <k+0x2e0>
    2422:	0888                	add	a0,sp,80
    2424:	04f11623          	sh	a5,76(sp)
    2428:	294010ef          	jal	36bc <memcpy>
    242c:	6789                	lui	a5,0x2
    242e:	d5578793          	add	a5,a5,-683 # 1d55 <sha384_core+0x3b1>
    2432:	473d                	li	a4,15
    2434:	00f11c23          	sh	a5,24(sp)
    2438:	00f11e23          	sh	a5,28(sp)
    243c:	4631                	li	a2,12
    243e:	47cd                	li	a5,19
    2440:	85ca                	mv	a1,s2
    2442:	01a8                	add	a0,sp,200
    2444:	00e10d23          	sb	a4,26(sp)
    2448:	00f10f23          	sb	a5,30(sp)
    244c:	35f5                	jal	2338 <convert_le32_to_be_bytes>
    244e:	85a6                	mv	a1,s1
    2450:	4631                	li	a2,12
    2452:	19a8                	add	a0,sp,248
    2454:	35d5                	jal	2338 <convert_le32_to_be_bytes>
    2456:	500114b7          	lui	s1,0x50011
    245a:	4611                	li	a2,4
    245c:	87c48593          	add	a1,s1,-1924 # 5001087c <k+0x4fc>
    2460:	01a8                	add	a0,sp,200
    2462:	094010ef          	jal	34f6 <memcmp>
    2466:	58fd                	li	a7,-1
    2468:	20050763          	beqz	a0,2676 <generate_intermediate_tbs_der+0x30c>
    246c:	4611                	li	a2,4
    246e:	87c48593          	add	a1,s1,-1924
    2472:	19a8                	add	a0,sp,248
    2474:	082010ef          	jal	34f6 <memcmp>
    2478:	58fd                	li	a7,-1
    247a:	1e050e63          	beqz	a0,2676 <generate_intermediate_tbs_der+0x30c>
    247e:	03000a13          	li	s4,48
    2482:	8652                	mv	a2,s4
    2484:	01ac                	add	a1,sp,200
    2486:	12910513          	add	a0,sp,297
    248a:	232010ef          	jal	36bc <memcpy>
    248e:	8652                	mv	a2,s4
    2490:	19ac                	add	a1,sp,248
    2492:	15910513          	add	a0,sp,345
    2496:	226010ef          	jal	36bc <memcpy>
    249a:	4791                	li	a5,4
    249c:	06100613          	li	a2,97
    24a0:	122c                	add	a1,sp,296
    24a2:	18d10513          	add	a0,sp,397
    24a6:	12f10423          	sb	a5,296(sp)
    24aa:	18010623          	sb	zero,396(sp)
    24ae:	20e010ef          	jal	36bc <memcpy>
    24b2:	000487b7          	lui	a5,0x48
    24b6:	12b78793          	add	a5,a5,299 # 4812b <_data_lma_end+0x43d67>
    24ba:	c0be                	sw	a5,64(sp)
    24bc:	02200793          	li	a5,34
    24c0:	04f10223          	sb	a5,68(sp)
    24c4:	469d                	li	a3,7
    24c6:	08610793          	add	a5,sp,134
    24ca:	0890                	add	a2,sp,80
    24cc:	4599                	li	a1,6
    24ce:	1048                	add	a0,sp,36
    24d0:	d23e                	sw	a5,36(sp)
    24d2:	09410223          	sb	s4,132(sp)
    24d6:	cffff0ef          	jal	21d4 <asn1_write_tag>
    24da:	4695                	li	a3,5
    24dc:	0090                	add	a2,sp,64
    24de:	4599                	li	a1,6
    24e0:	1048                	add	a0,sp,36
    24e2:	cf3ff0ef          	jal	21d4 <asn1_write_tag>
    24e6:	08410a93          	add	s5,sp,132
    24ea:	5912                	lw	s2,36(sp)
    24ec:	41590933          	sub	s2,s2,s5
    24f0:	ffe90793          	add	a5,s2,-2
    24f4:	08f102a3          	sb	a5,133(sp)
    24f8:	1f210793          	add	a5,sp,498
    24fc:	864a                	mv	a2,s2
    24fe:	85d6                	mv	a1,s5
    2500:	853e                	mv	a0,a5
    2502:	1f410823          	sb	s4,496(sp)
    2506:	1b6010ef          	jal	36bc <memcpy>
    250a:	012507b3          	add	a5,a0,s2
    250e:	06200693          	li	a3,98
    2512:	0370                	add	a2,sp,396
    2514:	458d                	li	a1,3
    2516:	1028                	add	a0,sp,40
    2518:	d43e                	sw	a5,40(sp)
    251a:	1f010c93          	add	s9,sp,496
    251e:	cb7ff0ef          	jal	21d4 <asn1_write_tag>
    2522:	5aa2                	lw	s5,40(sp)
    2524:	419a8ab3          	sub	s5,s5,s9
    2528:	ffea8793          	add	a5,s5,-2
    252c:	001c3d93          	seqz	s11,s8
    2530:	41b00db3          	neg	s11,s11
    2534:	1ef108a3          	sb	a5,497(sp)
    2538:	27210793          	add	a5,sp,626
    253c:	2f010913          	add	s2,sp,752
    2540:	d63e                	sw	a5,44(sp)
    2542:	003df713          	and	a4,s11,3
    2546:	10dc                	add	a5,sp,100
    2548:	07410d13          	add	s10,sp,116
    254c:	0705                	add	a4,a4,1 # 20001001 <_data_lma_end+0x1fffcc3d>
    254e:	00f92023          	sw	a5,0(s2)
    2552:	4685                	li	a3,1
    2554:	866a                	mv	a2,s10
    2556:	458d                	li	a1,3
    2558:	854a                	mv	a0,s2
    255a:	06e10a23          	sb	a4,116(sp)
    255e:	27410823          	sb	s4,624(sp)
    2562:	c73ff0ef          	jal	21d4 <asn1_write_tag>
    2566:	10dc                	add	a5,sp,100
    2568:	00092683          	lw	a3,0(s2)
    256c:	8e9d                	sub	a3,a3,a5
    256e:	863e                	mv	a2,a5
    2570:	082c                	add	a1,sp,24
    2572:	1068                	add	a0,sp,44
    2574:	d6dff0ef          	jal	22e0 <build_x509_extension.constprop.0>
    2578:	4685                	li	a3,1
    257a:	07610793          	add	a5,sp,118
    257e:	01710613          	add	a2,sp,23
    2582:	85b6                	mv	a1,a3
    2584:	01410533          	add	a0,sp,s4
    2588:	07410a23          	sb	s4,116(sp)
    258c:	d83e                	sw	a5,48(sp)
    258e:	01b10ba3          	sb	s11,23(sp)
    2592:	c43ff0ef          	jal	21d4 <asn1_write_tag>
    2596:	000c1b63          	bnez	s8,25ac <generate_intermediate_tbs_der+0x242>
    259a:	4685                	li	a3,1
    259c:	864a                	mv	a2,s2
    259e:	4589                	li	a1,2
    25a0:	01410533          	add	a0,sp,s4
    25a4:	2e010823          	sb	zero,752(sp)
    25a8:	c2dff0ef          	jal	21d4 <asn1_write_tag>
    25ac:	56c2                	lw	a3,48(sp)
    25ae:	41a686b3          	sub	a3,a3,s10
    25b2:	ffe68793          	add	a5,a3,-2
    25b6:	866a                	mv	a2,s10
    25b8:	086c                	add	a1,sp,28
    25ba:	1068                	add	a0,sp,44
    25bc:	06f10aa3          	sb	a5,117(sp)
    25c0:	d21ff0ef          	jal	22e0 <build_x509_extension.constprop.0>
    25c4:	27010a13          	add	s4,sp,624
    25c8:	56b2                	lw	a3,44(sp)
    25ca:	414686b3          	sub	a3,a3,s4
    25ce:	ffe68793          	add	a5,a3,-2
    25d2:	4615                	li	a2,5
    25d4:	182c                	add	a1,sp,56
    25d6:	8522                	mv	a0,s0
    25d8:	c636                	sw	a3,12(sp)
    25da:	26f108a3          	sb	a5,625(sp)
    25de:	0de010ef          	jal	36bc <memcpy>
    25e2:	4619                	li	a2,6
    25e4:	00ac                	add	a1,sp,72
    25e6:	00540513          	add	a0,s0,5
    25ea:	0d2010ef          	jal	36bc <memcpy>
    25ee:	4631                	li	a2,12
    25f0:	08ac                	add	a1,sp,88
    25f2:	00b40513          	add	a0,s0,11
    25f6:	0c6010ef          	jal	36bc <memcpy>
    25fa:	01740793          	add	a5,s0,23
    25fe:	85de                	mv	a1,s7
    2600:	1008                	add	a0,sp,32
    2602:	d03e                	sw	a5,32(sp)
    2604:	c3fff0ef          	jal	2242 <encode_dn>
    2608:	5782                	lw	a5,32(sp)
    260a:	02400613          	li	a2,36
    260e:	114c                	add	a1,sp,164
    2610:	853e                	mv	a0,a5
    2612:	0aa010ef          	jal	36bc <memcpy>
    2616:	02450793          	add	a5,a0,36
    261a:	85da                	mv	a1,s6
    261c:	1008                	add	a0,sp,32
    261e:	d03e                	sw	a5,32(sp)
    2620:	c23ff0ef          	jal	2242 <encode_dn>
    2624:	5782                	lw	a5,32(sp)
    2626:	8656                	mv	a2,s5
    2628:	85e6                	mv	a1,s9
    262a:	853e                	mv	a0,a5
    262c:	090010ef          	jal	36bc <memcpy>
    2630:	015507b3          	add	a5,a0,s5
    2634:	46b2                	lw	a3,12(sp)
    2636:	8652                	mv	a2,s4
    2638:	0a300593          	li	a1,163
    263c:	1008                	add	a0,sp,32
    263e:	d03e                	sw	a5,32(sp)
    2640:	b95ff0ef          	jal	21d4 <asn1_write_tag>
    2644:	5682                	lw	a3,32(sp)
    2646:	8e81                	sub	a3,a3,s0
    2648:	8622                	mv	a2,s0
    264a:	03000593          	li	a1,48
    264e:	1848                	add	a0,sp,52
    2650:	da4a                	sw	s2,52(sp)
    2652:	b83ff0ef          	jal	21d4 <asn1_write_tag>
    2656:	54d2                	lw	s1,52(sp)
    2658:	412484b3          	sub	s1,s1,s2
    265c:	0009a783          	lw	a5,0(s3)
    2660:	58f5                	li	a7,-3
    2662:	0097ea63          	bltu	a5,s1,2676 <generate_intermediate_tbs_der+0x30c>
    2666:	8626                	mv	a2,s1
    2668:	85ca                	mv	a1,s2
    266a:	8522                	mv	a0,s0
    266c:	050010ef          	jal	36bc <memcpy>
    2670:	4881                	li	a7,0
    2672:	0099a023          	sw	s1,0(s3)
    2676:	52c12083          	lw	ra,1324(sp)
    267a:	52812403          	lw	s0,1320(sp)
    267e:	52412483          	lw	s1,1316(sp)
    2682:	52012903          	lw	s2,1312(sp)
    2686:	51c12983          	lw	s3,1308(sp)
    268a:	51812a03          	lw	s4,1304(sp)
    268e:	51412a83          	lw	s5,1300(sp)
    2692:	51012b03          	lw	s6,1296(sp)
    2696:	50c12b83          	lw	s7,1292(sp)
    269a:	50812c03          	lw	s8,1288(sp)
    269e:	50412c83          	lw	s9,1284(sp)
    26a2:	50012d03          	lw	s10,1280(sp)
    26a6:	4fc12d83          	lw	s11,1276(sp)
    26aa:	8546                	mv	a0,a7
    26ac:	53010113          	add	sp,sp,1328
    26b0:	8082                	ret
    26b2:	58f9                	li	a7,-2
    26b4:	8546                	mv	a0,a7
    26b6:	8082                	ret

000026b8 <add_signature_to_cert>:
    26b8:	7105                	add	sp,sp,-480
    26ba:	1d312623          	sw	s3,460(sp)
    26be:	02010993          	add	s3,sp,32
    26c2:	1c812c23          	sw	s0,472(sp)
    26c6:	1c912a23          	sw	s1,468(sp)
    26ca:	1d212823          	sw	s2,464(sp)
    26ce:	1d412423          	sw	s4,456(sp)
    26d2:	1d512223          	sw	s5,452(sp)
    26d6:	843a                	mv	s0,a4
    26d8:	8ab6                	mv	s5,a3
    26da:	1c112e23          	sw	ra,476(sp)
    26de:	1d612023          	sw	s6,448(sp)
    26e2:	1b712e23          	sw	s7,444(sp)
    26e6:	8a2a                	mv	s4,a0
    26e8:	84ae                	mv	s1,a1
    26ea:	893e                	mv	s2,a5
    26ec:	c64e                	sw	s3,12(sp)
    26ee:	4701                	li	a4,0
    26f0:	02f00693          	li	a3,47
    26f4:	00e607b3          	add	a5,a2,a4
    26f8:	0007c783          	lbu	a5,0(a5)
    26fc:	10078863          	beqz	a5,280c <add_signature_to_cert+0x154>
    2700:	03000793          	li	a5,48
    2704:	40e786b3          	sub	a3,a5,a4
    2708:	8e15                	sub	a2,a2,a3
    270a:	03060613          	add	a2,a2,48
    270e:	4589                	li	a1,2
    2710:	0068                	add	a0,sp,12
    2712:	ac3ff0ef          	jal	21d4 <asn1_write_tag>
    2716:	4701                	li	a4,0
    2718:	02f00693          	li	a3,47
    271c:	00ea87b3          	add	a5,s5,a4
    2720:	0007c783          	lbu	a5,0(a5)
    2724:	0e078963          	beqz	a5,2816 <add_signature_to_cert+0x15e>
    2728:	03000793          	li	a5,48
    272c:	40e786b3          	sub	a3,a5,a4
    2730:	03000b93          	li	s7,48
    2734:	40db8633          	sub	a2,s7,a3
    2738:	9656                	add	a2,a2,s5
    273a:	4589                	li	a1,2
    273c:	0068                	add	a0,sp,12
    273e:	a97ff0ef          	jal	21d4 <asn1_write_tag>
    2742:	46b2                	lw	a3,12(sp)
    2744:	413686b3          	sub	a3,a3,s3
    2748:	864e                	mv	a2,s3
    274a:	0e810b13          	add	s6,sp,232
    274e:	85de                	mv	a1,s7
    2750:	0808                	add	a0,sp,16
    2752:	00440a93          	add	s5,s0,4
    2756:	c85a                	sw	s6,16(sp)
    2758:	a7dff0ef          	jal	21d4 <asn1_write_tag>
    275c:	8626                	mv	a2,s1
    275e:	85d2                	mv	a1,s4
    2760:	01740023          	sb	s7,0(s0)
    2764:	8556                	mv	a0,s5
    2766:	49c2                	lw	s3,16(sp)
    2768:	755000ef          	jal	36bc <memcpy>
    276c:	500105b7          	lui	a1,0x50010
    2770:	4631                	li	a2,12
    2772:	62858593          	add	a1,a1,1576 # 50010628 <k+0x2a8>
    2776:	0848                	add	a0,sp,20
    2778:	745000ef          	jal	36bc <memcpy>
    277c:	94d6                	add	s1,s1,s5
    277e:	4631                	li	a2,12
    2780:	084c                	add	a1,sp,20
    2782:	8526                	mv	a0,s1
    2784:	739000ef          	jal	36bc <memcpy>
    2788:	478d                	li	a5,3
    278a:	416989b3          	sub	s3,s3,s6
    278e:	00f48623          	sb	a5,12(s1)
    2792:	00198713          	add	a4,s3,1
    2796:	07f00793          	li	a5,127
    279a:	08e7e363          	bltu	a5,a4,2820 <add_signature_to_cert+0x168>
    279e:	00e48793          	add	a5,s1,14
    27a2:	00e486a3          	sb	a4,13(s1)
    27a6:	00178493          	add	s1,a5,1
    27aa:	00078023          	sb	zero,0(a5)
    27ae:	864e                	mv	a2,s3
    27b0:	8526                	mv	a0,s1
    27b2:	85da                	mv	a1,s6
    27b4:	709000ef          	jal	36bc <memcpy>
    27b8:	94ce                	add	s1,s1,s3
    27ba:	40848633          	sub	a2,s1,s0
    27be:	1671                	add	a2,a2,-4
    27c0:	07f00713          	li	a4,127
    27c4:	0ff67793          	zext.b	a5,a2
    27c8:	06c76563          	bltu	a4,a2,2832 <add_signature_to_cert+0x17a>
    27cc:	00f400a3          	sb	a5,1(s0)
    27d0:	85d6                	mv	a1,s5
    27d2:	00240513          	add	a0,s0,2
    27d6:	573000ef          	jal	3548 <memmove>
    27da:	14f9                	add	s1,s1,-2
    27dc:	8c81                	sub	s1,s1,s0
    27de:	00992023          	sw	s1,0(s2)
    27e2:	1dc12083          	lw	ra,476(sp)
    27e6:	1d812403          	lw	s0,472(sp)
    27ea:	1d412483          	lw	s1,468(sp)
    27ee:	1d012903          	lw	s2,464(sp)
    27f2:	1cc12983          	lw	s3,460(sp)
    27f6:	1c812a03          	lw	s4,456(sp)
    27fa:	1c412a83          	lw	s5,452(sp)
    27fe:	1c012b03          	lw	s6,448(sp)
    2802:	1bc12b83          	lw	s7,444(sp)
    2806:	4501                	li	a0,0
    2808:	613d                	add	sp,sp,480
    280a:	8082                	ret
    280c:	0705                	add	a4,a4,1
    280e:	eed713e3          	bne	a4,a3,26f4 <add_signature_to_cert+0x3c>
    2812:	4685                	li	a3,1
    2814:	bdd5                	j	2708 <add_signature_to_cert+0x50>
    2816:	0705                	add	a4,a4,1
    2818:	f0d712e3          	bne	a4,a3,271c <add_signature_to_cert+0x64>
    281c:	4685                	li	a3,1
    281e:	bf09                	j	2730 <add_signature_to_cert+0x78>
    2820:	f8100793          	li	a5,-127
    2824:	00f486a3          	sb	a5,13(s1)
    2828:	00e48723          	sb	a4,14(s1)
    282c:	00f48793          	add	a5,s1,15
    2830:	bf9d                	j	27a6 <add_signature_to_cert+0xee>
    2832:	0ff00713          	li	a4,255
    2836:	00c76963          	bltu	a4,a2,2848 <add_signature_to_cert+0x190>
    283a:	f8100713          	li	a4,-127
    283e:	00e400a3          	sb	a4,1(s0)
    2842:	00f40123          	sb	a5,2(s0)
    2846:	bf59                	j	27dc <add_signature_to_cert+0x124>
    2848:	f8200713          	li	a4,-126
    284c:	8221                	srl	a2,a2,0x8
    284e:	00e400a3          	sb	a4,1(s0)
    2852:	00c40123          	sb	a2,2(s0)
    2856:	00f401a3          	sb	a5,3(s0)
    285a:	b749                	j	27dc <add_signature_to_cert+0x124>

0000285c <verify_cert>:
    285c:	7155                	add	sp,sp,-208
    285e:	c786                	sw	ra,204(sp)
    2860:	c5a2                	sw	s0,200(sp)
    2862:	c3a6                	sw	s1,196(sp)
    2864:	c1ca                	sw	s2,192(sp)
    2866:	df4e                	sw	s3,188(sp)
    2868:	dd52                	sw	s4,184(sp)
    286a:	db56                	sw	s5,180(sp)
    286c:	d95a                	sw	s6,176(sp)
    286e:	d75e                	sw	s7,172(sp)
    2870:	00054703          	lbu	a4,0(a0)
    2874:	03000793          	li	a5,48
    2878:	02f70463          	beq	a4,a5,28a0 <verify_cert+0x44>
    287c:	50010537          	lui	a0,0x50010
    2880:	66850513          	add	a0,a0,1640 # 50010668 <k+0x2e8>
    2884:	8feff0ef          	jal	1982 <puts>
    2888:	4501                	li	a0,0
    288a:	40be                	lw	ra,204(sp)
    288c:	442e                	lw	s0,200(sp)
    288e:	449e                	lw	s1,196(sp)
    2890:	490e                	lw	s2,192(sp)
    2892:	59fa                	lw	s3,188(sp)
    2894:	5a6a                	lw	s4,184(sp)
    2896:	5ada                	lw	s5,180(sp)
    2898:	5b4a                	lw	s6,176(sp)
    289a:	5bba                	lw	s7,172(sp)
    289c:	6169                	add	sp,sp,208
    289e:	8082                	ret
    28a0:	84aa                	mv	s1,a0
    28a2:	0014c783          	lbu	a5,1(s1)
    28a6:	01879713          	sll	a4,a5,0x18
    28aa:	8761                	sra	a4,a4,0x18
    28ac:	842e                	mv	s0,a1
    28ae:	8932                	mv	s2,a2
    28b0:	0509                	add	a0,a0,2
    28b2:	00075563          	bgez	a4,28bc <verify_cert+0x60>
    28b6:	07f7f793          	and	a5,a5,127
    28ba:	953e                	add	a0,a0,a5
    28bc:	00054703          	lbu	a4,0(a0)
    28c0:	03000793          	li	a5,48
    28c4:	00f70763          	beq	a4,a5,28d2 <verify_cert+0x76>
    28c8:	50010537          	lui	a0,0x50010
    28cc:	67850513          	add	a0,a0,1656 # 50010678 <k+0x2f8>
    28d0:	bf55                	j	2884 <verify_cert+0x28>
    28d2:	00154583          	lbu	a1,1(a0)
    28d6:	01859793          	sll	a5,a1,0x18
    28da:	87e1                	sra	a5,a5,0x18
    28dc:	4685                	li	a3,1
    28de:	0007dd63          	bgez	a5,28f8 <verify_cert+0x9c>
    28e2:	07f5f793          	and	a5,a1,127
    28e6:	00250713          	add	a4,a0,2
    28ea:	00178693          	add	a3,a5,1
    28ee:	4581                	li	a1,0
    28f0:	567d                	li	a2,-1
    28f2:	17fd                	add	a5,a5,-1
    28f4:	04c79463          	bne	a5,a2,293c <verify_cert+0xe0>
    28f8:	95b6                	add	a1,a1,a3
    28fa:	4685                	li	a3,1
    28fc:	95b6                	add	a1,a1,a3
    28fe:	0810                	add	a2,sp,16
    2900:	d0cff0ef          	jal	1e0c <sha384_digest>
    2904:	500105b7          	lui	a1,0x50010
    2908:	62858593          	add	a1,a1,1576 # 50010628 <k+0x2a8>
    290c:	4631                	li	a2,12
    290e:	0048                	add	a0,sp,4
    2910:	5ad000ef          	jal	36bc <memcpy>
    2914:	10000793          	li	a5,256
    2918:	008489b3          	add	s3,s1,s0
    291c:	85a2                	mv	a1,s0
    291e:	00f47363          	bgeu	s0,a5,2924 <verify_cert+0xc8>
    2922:	85be                	mv	a1,a5
    2924:	f0058413          	add	s0,a1,-256
    2928:	9426                	add	s0,s0,s1
    292a:	00c40a93          	add	s5,s0,12
    292e:	0159fe63          	bgeu	s3,s5,294a <verify_cert+0xee>
    2932:	50011537          	lui	a0,0x50011
    2936:	83050513          	add	a0,a0,-2000 # 50010830 <k+0x4b0>
    293a:	b7a9                	j	2884 <verify_cert+0x28>
    293c:	05a2                	sll	a1,a1,0x8
    293e:	00074803          	lbu	a6,0(a4)
    2942:	0705                	add	a4,a4,1
    2944:	00b865b3          	or	a1,a6,a1
    2948:	b76d                	j	28f2 <verify_cert+0x96>
    294a:	4631                	li	a2,12
    294c:	004c                	add	a1,sp,4
    294e:	8522                	mv	a0,s0
    2950:	3a7000ef          	jal	34f6 <memcmp>
    2954:	8a2a                	mv	s4,a0
    2956:	24050c63          	beqz	a0,2bae <verify_cert+0x352>
    295a:	0405                	add	s0,s0,1
    295c:	b7f9                	j	292a <verify_cert+0xce>
    295e:	00d40793          	add	a5,s0,13
    2962:	0137e763          	bltu	a5,s3,2970 <verify_cert+0x114>
    2966:	50010537          	lui	a0,0x50010
    296a:	6a450513          	add	a0,a0,1700 # 500106a4 <k+0x324>
    296e:	bf19                	j	2884 <verify_cert+0x28>
    2970:	00d44583          	lbu	a1,13(s0)
    2974:	01859793          	sll	a5,a1,0x18
    2978:	87e1                	sra	a5,a5,0x18
    297a:	0207c663          	bltz	a5,29a6 <verify_cert+0x14a>
    297e:	00e40493          	add	s1,s0,14
    2982:	842e                	mv	s0,a1
    2984:	50010537          	lui	a0,0x50010
    2988:	85a2                	mv	a1,s0
    298a:	70050513          	add	a0,a0,1792 # 50010700 <k+0x380>
    298e:	ff9fe0ef          	jal	1986 <printf>
    2992:	0134f563          	bgeu	s1,s3,299c <verify_cert+0x140>
    2996:	0004c783          	lbu	a5,0(s1)
    299a:	cf8d                	beqz	a5,29d4 <verify_cert+0x178>
    299c:	50010537          	lui	a0,0x50010
    29a0:	71c50513          	add	a0,a0,1820 # 5001071c <k+0x39c>
    29a4:	b5c5                	j	2884 <verify_cert+0x28>
    29a6:	08100793          	li	a5,129
    29aa:	02f59063          	bne	a1,a5,29ca <verify_cert+0x16e>
    29ae:	00e40793          	add	a5,s0,14
    29b2:	0137e763          	bltu	a5,s3,29c0 <verify_cert+0x164>
    29b6:	50010537          	lui	a0,0x50010
    29ba:	6c450513          	add	a0,a0,1732 # 500106c4 <k+0x344>
    29be:	b5d9                	j	2884 <verify_cert+0x28>
    29c0:	00f40493          	add	s1,s0,15
    29c4:	00e44403          	lbu	s0,14(s0)
    29c8:	bf75                	j	2984 <verify_cert+0x128>
    29ca:	50010537          	lui	a0,0x50010
    29ce:	6e050513          	add	a0,a0,1760 # 500106e0 <k+0x360>
    29d2:	bd4d                	j	2884 <verify_cert+0x28>
    29d4:	9426                	add	s0,s0,s1
    29d6:	0089f763          	bgeu	s3,s0,29e4 <verify_cert+0x188>
    29da:	50010537          	lui	a0,0x50010
    29de:	74050513          	add	a0,a0,1856 # 50010740 <k+0x3c0>
    29e2:	b54d                	j	2884 <verify_cert+0x28>
    29e4:	0014c703          	lbu	a4,1(s1)
    29e8:	03000793          	li	a5,48
    29ec:	00f70763          	beq	a4,a5,29fa <verify_cert+0x19e>
    29f0:	50010537          	lui	a0,0x50010
    29f4:	76450513          	add	a0,a0,1892 # 50010764 <k+0x3e4>
    29f8:	b571                	j	2884 <verify_cert+0x28>
    29fa:	00248793          	add	a5,s1,2
    29fe:	0137e763          	bltu	a5,s3,2a0c <verify_cert+0x1b0>
    2a02:	50010537          	lui	a0,0x50010
    2a06:	77850513          	add	a0,a0,1912 # 50010778 <k+0x3f8>
    2a0a:	bdad                	j	2884 <verify_cert+0x28>
    2a0c:	0024c783          	lbu	a5,2(s1)
    2a10:	01879713          	sll	a4,a5,0x18
    2a14:	8761                	sra	a4,a4,0x18
    2a16:	00074c63          	bltz	a4,2a2e <verify_cert+0x1d2>
    2a1a:	00348713          	add	a4,s1,3
    2a1e:	97ba                	add	a5,a5,a4
    2a20:	02f9f963          	bgeu	s3,a5,2a52 <verify_cert+0x1f6>
    2a24:	50010537          	lui	a0,0x50010
    2a28:	7a050513          	add	a0,a0,1952 # 500107a0 <k+0x420>
    2a2c:	bda1                	j	2884 <verify_cert+0x28>
    2a2e:	08100713          	li	a4,129
    2a32:	00e79b63          	bne	a5,a4,2a48 <verify_cert+0x1ec>
    2a36:	00348793          	add	a5,s1,3
    2a3a:	e537f7e3          	bgeu	a5,s3,2888 <verify_cert+0x2c>
    2a3e:	00448713          	add	a4,s1,4
    2a42:	0034c783          	lbu	a5,3(s1)
    2a46:	bfe1                	j	2a1e <verify_cert+0x1c2>
    2a48:	50010537          	lui	a0,0x50010
    2a4c:	78850513          	add	a0,a0,1928 # 50010788 <k+0x408>
    2a50:	bd15                	j	2884 <verify_cert+0x28>
    2a52:	00f77763          	bgeu	a4,a5,2a60 <verify_cert+0x204>
    2a56:	00074603          	lbu	a2,0(a4)
    2a5a:	4689                	li	a3,2
    2a5c:	00d60763          	beq	a2,a3,2a6a <verify_cert+0x20e>
    2a60:	50010537          	lui	a0,0x50010
    2a64:	7b850513          	add	a0,a0,1976 # 500107b8 <k+0x438>
    2a68:	bd31                	j	2884 <verify_cert+0x28>
    2a6a:	00170693          	add	a3,a4,1
    2a6e:	e0f6fde3          	bgeu	a3,a5,2888 <verify_cert+0x2c>
    2a72:	00174483          	lbu	s1,1(a4)
    2a76:	01849693          	sll	a3,s1,0x18
    2a7a:	86e1                	sra	a3,a3,0x18
    2a7c:	00270a93          	add	s5,a4,2
    2a80:	0006de63          	bgez	a3,2a9c <verify_cert+0x240>
    2a84:	08100693          	li	a3,129
    2a88:	02d49d63          	bne	s1,a3,2ac2 <verify_cert+0x266>
    2a8c:	00270693          	add	a3,a4,2
    2a90:	def6fce3          	bgeu	a3,a5,2888 <verify_cert+0x2c>
    2a94:	00370a93          	add	s5,a4,3
    2a98:	00274483          	lbu	s1,2(a4)
    2a9c:	c891                	beqz	s1,2ab0 <verify_cert+0x254>
    2a9e:	000ac703          	lbu	a4,0(s5)
    2aa2:	e319                	bnez	a4,2aa8 <verify_cert+0x24c>
    2aa4:	0a85                	add	s5,s5,1
    2aa6:	14fd                	add	s1,s1,-1
    2aa8:	03000713          	li	a4,48
    2aac:	00976663          	bltu	a4,s1,2ab8 <verify_cert+0x25c>
    2ab0:	009a8733          	add	a4,s5,s1
    2ab4:	00e7fc63          	bgeu	a5,a4,2acc <verify_cert+0x270>
    2ab8:	50010537          	lui	a0,0x50010
    2abc:	7d050513          	add	a0,a0,2000 # 500107d0 <k+0x450>
    2ac0:	b3d1                	j	2884 <verify_cert+0x28>
    2ac2:	50010537          	lui	a0,0x50010
    2ac6:	7c450513          	add	a0,a0,1988 # 500107c4 <k+0x444>
    2aca:	bb6d                	j	2884 <verify_cert+0x28>
    2acc:	00f70763          	beq	a4,a5,2ada <verify_cert+0x27e>
    2ad0:	00074603          	lbu	a2,0(a4)
    2ad4:	4689                	li	a3,2
    2ad6:	00d60763          	beq	a2,a3,2ae4 <verify_cert+0x288>
    2ada:	50010537          	lui	a0,0x50010
    2ade:	7e450513          	add	a0,a0,2020 # 500107e4 <k+0x464>
    2ae2:	b34d                	j	2884 <verify_cert+0x28>
    2ae4:	00170693          	add	a3,a4,1
    2ae8:	daf6f0e3          	bgeu	a3,a5,2888 <verify_cert+0x2c>
    2aec:	00174403          	lbu	s0,1(a4)
    2af0:	01841693          	sll	a3,s0,0x18
    2af4:	86e1                	sra	a3,a3,0x18
    2af6:	00270993          	add	s3,a4,2
    2afa:	0006de63          	bgez	a3,2b16 <verify_cert+0x2ba>
    2afe:	08100693          	li	a3,129
    2b02:	02d41d63          	bne	s0,a3,2b3c <verify_cert+0x2e0>
    2b06:	00270693          	add	a3,a4,2
    2b0a:	d6f6ffe3          	bgeu	a3,a5,2888 <verify_cert+0x2c>
    2b0e:	00370993          	add	s3,a4,3
    2b12:	00274403          	lbu	s0,2(a4)
    2b16:	c811                	beqz	s0,2b2a <verify_cert+0x2ce>
    2b18:	0009c703          	lbu	a4,0(s3)
    2b1c:	e319                	bnez	a4,2b22 <verify_cert+0x2c6>
    2b1e:	0985                	add	s3,s3,1
    2b20:	147d                	add	s0,s0,-1
    2b22:	03000713          	li	a4,48
    2b26:	00876663          	bltu	a4,s0,2b32 <verify_cert+0x2d6>
    2b2a:	00898733          	add	a4,s3,s0
    2b2e:	00e7fc63          	bgeu	a5,a4,2b46 <verify_cert+0x2ea>
    2b32:	50010537          	lui	a0,0x50010
    2b36:	7fc50513          	add	a0,a0,2044 # 500107fc <k+0x47c>
    2b3a:	b3a9                	j	2884 <verify_cert+0x28>
    2b3c:	50010537          	lui	a0,0x50010
    2b40:	7f050513          	add	a0,a0,2032 # 500107f0 <k+0x470>
    2b44:	b381                	j	2884 <verify_cert+0x28>
    2b46:	04010b13          	add	s6,sp,64
    2b4a:	06000b93          	li	s7,96
    2b4e:	865e                	mv	a2,s7
    2b50:	4581                	li	a1,0
    2b52:	855a                	mv	a0,s6
    2b54:	2c1000ef          	jal	3614 <memset>
    2b58:	409b0533          	sub	a0,s6,s1
    2b5c:	8626                	mv	a2,s1
    2b5e:	85d6                	mv	a1,s5
    2b60:	03050513          	add	a0,a0,48
    2b64:	359000ef          	jal	36bc <memcpy>
    2b68:	408b8533          	sub	a0,s7,s0
    2b6c:	8622                	mv	a2,s0
    2b6e:	85ce                	mv	a1,s3
    2b70:	955a                	add	a0,a0,s6
    2b72:	34b000ef          	jal	36bc <memcpy>
    2b76:	50011537          	lui	a0,0x50011
    2b7a:	81050513          	add	a0,a0,-2032 # 50010810 <k+0x490>
    2b7e:	e05fe0ef          	jal	1982 <puts>
    2b82:	50011437          	lui	s0,0x50011
    2b86:	014b07b3          	add	a5,s6,s4
    2b8a:	0007c583          	lbu	a1,0(a5)
    2b8e:	82840513          	add	a0,s0,-2008 # 50010828 <k+0x4a8>
    2b92:	0a05                	add	s4,s4,1
    2b94:	df3fe0ef          	jal	1986 <printf>
    2b98:	ff7a17e3          	bne	s4,s7,2b86 <verify_cert+0x32a>
    2b9c:	4529                	li	a0,10
    2b9e:	dddfe0ef          	jal	197a <putchar>
    2ba2:	865a                	mv	a2,s6
    2ba4:	080c                	add	a1,sp,16
    2ba6:	854a                	mv	a0,s2
    2ba8:	ee6fe0ef          	jal	128e <ecdsa_verify>
    2bac:	b9f9                	j	288a <verify_cert+0x2e>
    2bae:	50011537          	lui	a0,0x50011
    2bb2:	409405b3          	sub	a1,s0,s1
    2bb6:	85c50513          	add	a0,a0,-1956 # 5001085c <k+0x4dc>
    2bba:	dcdfe0ef          	jal	1986 <printf>
    2bbe:	013af763          	bgeu	s5,s3,2bcc <verify_cert+0x370>
    2bc2:	00c44703          	lbu	a4,12(s0)
    2bc6:	478d                	li	a5,3
    2bc8:	d8f70be3          	beq	a4,a5,295e <verify_cert+0x102>
    2bcc:	50010537          	lui	a0,0x50010
    2bd0:	68450513          	add	a0,a0,1668 # 50010684 <k+0x304>
    2bd4:	b945                	j	2884 <verify_cert+0x28>

00002bd6 <generate_2nd_cert.part.0>:
    2bd6:	7129                	add	sp,sp,-320
    2bd8:	12912a23          	sw	s1,308(sp)
    2bdc:	500115b7          	lui	a1,0x50011
    2be0:	0184                	add	s1,sp,192
    2be2:	c4858593          	add	a1,a1,-952 # 50010c48 <public_key>
    2be6:	8526                	mv	a0,s1
    2be8:	12112e23          	sw	ra,316(sp)
    2bec:	12812c23          	sw	s0,312(sp)
    2bf0:	13212823          	sw	s2,304(sp)
    2bf4:	13312623          	sw	s3,300(sp)
    2bf8:	13412423          	sw	s4,296(sp)
    2bfc:	13512223          	sw	s5,292(sp)
    2c00:	13612023          	sw	s6,288(sp)
    2c04:	be6fe0ef          	jal	fea <ecc_point_decompress>
    2c08:	85a6                	mv	a1,s1
    2c0a:	850a                	mv	a0,sp
    2c0c:	b92fe0ef          	jal	f9e <ecc_native2bytes>
    2c10:	198c                	add	a1,sp,240
    2c12:	1808                	add	a0,sp,48
    2c14:	b8afe0ef          	jal	f9e <ecc_native2bytes>
    2c18:	878a                	mv	a5,sp
    2c1a:	4681                	li	a3,0
    2c1c:	1080                	add	s0,sp,96
    2c1e:	03000593          	li	a1,48
    2c22:	0007c703          	lbu	a4,0(a5)
    2c26:	0017c603          	lbu	a2,1(a5)
    2c2a:	0642                	sll	a2,a2,0x10
    2c2c:	0762                	sll	a4,a4,0x18
    2c2e:	8f51                	or	a4,a4,a2
    2c30:	0037c603          	lbu	a2,3(a5)
    2c34:	8f51                	or	a4,a4,a2
    2c36:	0027c603          	lbu	a2,2(a5)
    2c3a:	0622                	sll	a2,a2,0x8
    2c3c:	00d40533          	add	a0,s0,a3
    2c40:	8f51                	or	a4,a4,a2
    2c42:	c118                	sw	a4,0(a0)
    2c44:	0691                	add	a3,a3,4
    2c46:	0791                	add	a5,a5,4
    2c48:	fcb69de3          	bne	a3,a1,2c22 <generate_2nd_cert.part.0+0x4c>
    2c4c:	181c                	add	a5,sp,48
    2c4e:	4681                	li	a3,0
    2c50:	09010913          	add	s2,sp,144
    2c54:	03000593          	li	a1,48
    2c58:	0007c703          	lbu	a4,0(a5)
    2c5c:	0017c603          	lbu	a2,1(a5)
    2c60:	0642                	sll	a2,a2,0x10
    2c62:	0762                	sll	a4,a4,0x18
    2c64:	8f51                	or	a4,a4,a2
    2c66:	0037c603          	lbu	a2,3(a5)
    2c6a:	8f51                	or	a4,a4,a2
    2c6c:	0027c603          	lbu	a2,2(a5)
    2c70:	0622                	sll	a2,a2,0x8
    2c72:	00d90533          	add	a0,s2,a3
    2c76:	8f51                	or	a4,a4,a2
    2c78:	c118                	sw	a4,0(a0)
    2c7a:	0691                	add	a3,a3,4
    2c7c:	0791                	add	a5,a5,4
    2c7e:	fcb69de3          	bne	a3,a1,2c58 <generate_2nd_cert.part.0+0x82>
    2c82:	50011537          	lui	a0,0x50011
    2c86:	88850513          	add	a0,a0,-1912 # 50010888 <k+0x508>
    2c8a:	cf9fe0ef          	jal	1982 <puts>
    2c8e:	89a2                	mv	s3,s0
    2c90:	50011a37          	lui	s4,0x50011
    2c94:	0009a583          	lw	a1,0(s3)
    2c98:	894a0513          	add	a0,s4,-1900 # 50010894 <k+0x514>
    2c9c:	0991                	add	s3,s3,4
    2c9e:	ce9fe0ef          	jal	1986 <printf>
    2ca2:	ff3919e3          	bne	s2,s3,2c94 <generate_2nd_cert.part.0+0xbe>
    2ca6:	4529                	li	a0,10
    2ca8:	cd3fe0ef          	jal	197a <putchar>
    2cac:	50011537          	lui	a0,0x50011
    2cb0:	89c50513          	add	a0,a0,-1892 # 5001089c <k+0x51c>
    2cb4:	ccffe0ef          	jal	1982 <puts>
    2cb8:	89ca                	mv	s3,s2
    2cba:	0009a583          	lw	a1,0(s3)
    2cbe:	894a0513          	add	a0,s4,-1900
    2cc2:	0991                	add	s3,s3,4
    2cc4:	cc3fe0ef          	jal	1986 <printf>
    2cc8:	ff3499e3          	bne	s1,s3,2cba <generate_2nd_cert.part.0+0xe4>
    2ccc:	4529                	li	a0,10
    2cce:	cadfe0ef          	jal	197a <putchar>
    2cd2:	50011637          	lui	a2,0x50011
    2cd6:	500104b7          	lui	s1,0x50010
    2cda:	500129b7          	lui	s3,0x50012
    2cde:	8a860693          	add	a3,a2,-1880 # 500108a8 <k+0x528>
    2ce2:	8522                	mv	a0,s0
    2ce4:	4801                	li	a6,0
    2ce6:	17c48793          	add	a5,s1,380 # 5001017c <tbs_len>
    2cea:	c7c98713          	add	a4,s3,-900 # 50011c7c <tbs_der>
    2cee:	8a860613          	add	a2,a2,-1880
    2cf2:	85ca                	mv	a1,s2
    2cf4:	e76ff0ef          	jal	236a <generate_intermediate_tbs_der>
    2cf8:	842a                	mv	s0,a0
    2cfa:	e545                	bnez	a0,2da2 <generate_2nd_cert.part.0+0x1cc>
    2cfc:	6785                	lui	a5,0x1
    2cfe:	17c4a583          	lw	a1,380(s1)
    2d02:	80078793          	add	a5,a5,-2048 # 800 <mfdc+0x7>
    2d06:	08b7ee63          	bltu	a5,a1,2da2 <generate_2nd_cert.part.0+0x1cc>
    2d0a:	50011537          	lui	a0,0x50011
    2d0e:	8b850513          	add	a0,a0,-1864 # 500108b8 <k+0x538>
    2d12:	c75fe0ef          	jal	1986 <printf>
    2d16:	50011537          	lui	a0,0x50011
    2d1a:	8cc50513          	add	a0,a0,-1844 # 500108cc <k+0x54c>
    2d1e:	c65fe0ef          	jal	1982 <puts>
    2d22:	493d                	li	s2,15
    2d24:	50010a37          	lui	s4,0x50010
    2d28:	50011ab7          	lui	s5,0x50011
    2d2c:	50011b37          	lui	s6,0x50011
    2d30:	17c4a783          	lw	a5,380(s1)
    2d34:	04f46663          	bltu	s0,a5,2d80 <generate_2nd_cert.part.0+0x1aa>
    2d38:	4529                	li	a0,10
    2d3a:	c41fe0ef          	jal	197a <putchar>
    2d3e:	50012537          	lui	a0,0x50012
    2d42:	47c50793          	add	a5,a0,1148 # 5001247c <cert_store>
    2d46:	20078223          	sb	zero,516(a5)
    2d4a:	17c4a603          	lw	a2,380(s1)
    2d4e:	13812403          	lw	s0,312(sp)
    2d52:	20c7a023          	sw	a2,512(a5)
    2d56:	13c12083          	lw	ra,316(sp)
    2d5a:	13412483          	lw	s1,308(sp)
    2d5e:	13012903          	lw	s2,304(sp)
    2d62:	12812a03          	lw	s4,296(sp)
    2d66:	12412a83          	lw	s5,292(sp)
    2d6a:	12012b03          	lw	s6,288(sp)
    2d6e:	c7c98593          	add	a1,s3,-900
    2d72:	47c50513          	add	a0,a0,1148
    2d76:	12c12983          	lw	s3,300(sp)
    2d7a:	6131                	add	sp,sp,320
    2d7c:	1410006f          	j	36bc <memcpy>
    2d80:	c7c98793          	add	a5,s3,-900
    2d84:	97a2                	add	a5,a5,s0
    2d86:	0007c603          	lbu	a2,0(a5)
    2d8a:	634a0593          	add	a1,s4,1588 # 50010634 <k+0x2b4>
    2d8e:	00c96463          	bltu	s2,a2,2d96 <generate_2nd_cert.part.0+0x1c0>
    2d92:	884a8593          	add	a1,s5,-1916 # 50010884 <k+0x504>
    2d96:	8dcb0513          	add	a0,s6,-1828 # 500108dc <k+0x55c>
    2d9a:	bedfe0ef          	jal	1986 <printf>
    2d9e:	0405                	add	s0,s0,1
    2da0:	bf41                	j	2d30 <generate_2nd_cert.part.0+0x15a>
    2da2:	50011537          	lui	a0,0x50011
    2da6:	8e450513          	add	a0,a0,-1820 # 500108e4 <k+0x564>
    2daa:	bd9fe0ef          	jal	1982 <puts>
    2dae:	a001                	j	2dae <generate_2nd_cert.part.0+0x1d8>

00002db0 <generate_2nd_cert>:
    2db0:	500115b7          	lui	a1,0x50011
    2db4:	50011537          	lui	a0,0x50011
    2db8:	1141                	add	sp,sp,-16
    2dba:	c1858593          	add	a1,a1,-1000 # 50010c18 <private_key>
    2dbe:	c4850513          	add	a0,a0,-952 # 50010c48 <public_key>
    2dc2:	c606                	sw	ra,12(sp)
    2dc4:	b36fe0ef          	jal	10fa <ecc_make_key>
    2dc8:	e901                	bnez	a0,2dd8 <generate_2nd_cert+0x28>
    2dca:	50011537          	lui	a0,0x50011
    2dce:	90450513          	add	a0,a0,-1788 # 50010904 <k+0x584>
    2dd2:	bb1fe0ef          	jal	1982 <puts>
    2dd6:	a001                	j	2dd6 <generate_2nd_cert+0x26>
    2dd8:	40b2                	lw	ra,12(sp)
    2dda:	0141                	add	sp,sp,16
    2ddc:	dfbff06f          	j	2bd6 <generate_2nd_cert.part.0>

00002de0 <sign_1st_cert>:
    2de0:	711d                	add	sp,sp,-96
    2de2:	c2d6                	sw	s5,68(sp)
    2de4:	c0da                	sw	s6,64(sp)
    2de6:	50012ab7          	lui	s5,0x50012
    2dea:	50010b37          	lui	s6,0x50010
    2dee:	4685                	li	a3,1
    2df0:	860a                	mv	a2,sp
    2df2:	17cb2583          	lw	a1,380(s6) # 5001017c <tbs_len>
    2df6:	c7ca8513          	add	a0,s5,-900 # 50011c7c <tbs_der>
    2dfa:	ce86                	sw	ra,92(sp)
    2dfc:	cca2                	sw	s0,88(sp)
    2dfe:	caa6                	sw	s1,84(sp)
    2e00:	c8ca                	sw	s2,80(sp)
    2e02:	c6ce                	sw	s3,76(sp)
    2e04:	c4d2                	sw	s4,72(sp)
    2e06:	de5e                	sw	s7,60(sp)
    2e08:	804ff0ef          	jal	1e0c <sha384_digest>
    2e0c:	50011537          	lui	a0,0x50011
    2e10:	91c50513          	add	a0,a0,-1764 # 5001091c <k+0x59c>
    2e14:	890a                	mv	s2,sp
    2e16:	b6dfe0ef          	jal	1982 <puts>
    2e1a:	4401                	li	s0,0
    2e1c:	500119b7          	lui	s3,0x50011
    2e20:	03000493          	li	s1,48
    2e24:	008907b3          	add	a5,s2,s0
    2e28:	0007c583          	lbu	a1,0(a5)
    2e2c:	82898513          	add	a0,s3,-2008 # 50010828 <k+0x4a8>
    2e30:	0405                	add	s0,s0,1
    2e32:	b55fe0ef          	jal	1986 <printf>
    2e36:	fe9417e3          	bne	s0,s1,2e24 <sign_1st_cert+0x44>
    2e3a:	4529                	li	a0,10
    2e3c:	b3ffe0ef          	jal	197a <putchar>
    2e40:	500114b7          	lui	s1,0x50011
    2e44:	50011537          	lui	a0,0x50011
    2e48:	85ca                	mv	a1,s2
    2e4a:	bb848613          	add	a2,s1,-1096 # 50010bb8 <signature>
    2e4e:	c1850513          	add	a0,a0,-1000 # 50010c18 <private_key>
    2e52:	b40fe0ef          	jal	1192 <ecdsa_sign>
    2e56:	4785                	li	a5,1
    2e58:	85aa                	mv	a1,a0
    2e5a:	02f50363          	beq	a0,a5,2e80 <sign_1st_cert+0xa0>
    2e5e:	50011537          	lui	a0,0x50011
    2e62:	92450513          	add	a0,a0,-1756 # 50010924 <k+0x5a4>
    2e66:	b21fe0ef          	jal	1986 <printf>
    2e6a:	40f6                	lw	ra,92(sp)
    2e6c:	4466                	lw	s0,88(sp)
    2e6e:	44d6                	lw	s1,84(sp)
    2e70:	4946                	lw	s2,80(sp)
    2e72:	49b6                	lw	s3,76(sp)
    2e74:	4a26                	lw	s4,72(sp)
    2e76:	4a96                	lw	s5,68(sp)
    2e78:	4b06                	lw	s6,64(sp)
    2e7a:	5bf2                	lw	s7,60(sp)
    2e7c:	6125                	add	sp,sp,96
    2e7e:	8082                	ret
    2e80:	50011537          	lui	a0,0x50011
    2e84:	94850513          	add	a0,a0,-1720 # 50010948 <k+0x5c8>
    2e88:	afbfe0ef          	jal	1982 <puts>
    2e8c:	4a01                	li	s4,0
    2e8e:	06000b93          	li	s7,96
    2e92:	bb848793          	add	a5,s1,-1096
    2e96:	97d2                	add	a5,a5,s4
    2e98:	0007c583          	lbu	a1,0(a5)
    2e9c:	82898513          	add	a0,s3,-2008
    2ea0:	0a05                	add	s4,s4,1
    2ea2:	ae5fe0ef          	jal	1986 <printf>
    2ea6:	bb848413          	add	s0,s1,-1096
    2eaa:	ff7a14e3          	bne	s4,s7,2e92 <sign_1st_cert+0xb2>
    2eae:	4529                	li	a0,10
    2eb0:	acbfe0ef          	jal	197a <putchar>
    2eb4:	50011537          	lui	a0,0x50011
    2eb8:	95450513          	add	a0,a0,-1708 # 50010954 <k+0x5d4>
    2ebc:	ac7fe0ef          	jal	1982 <puts>
    2ec0:	4a01                	li	s4,0
    2ec2:	03000b93          	li	s7,48
    2ec6:	014407b3          	add	a5,s0,s4
    2eca:	0007c583          	lbu	a1,0(a5)
    2ece:	82898513          	add	a0,s3,-2008
    2ed2:	0a05                	add	s4,s4,1
    2ed4:	ab3fe0ef          	jal	1986 <printf>
    2ed8:	ff7a17e3          	bne	s4,s7,2ec6 <sign_1st_cert+0xe6>
    2edc:	4529                	li	a0,10
    2ede:	a9dfe0ef          	jal	197a <putchar>
    2ee2:	50011537          	lui	a0,0x50011
    2ee6:	96450513          	add	a0,a0,-1692 # 50010964 <k+0x5e4>
    2eea:	a99fe0ef          	jal	1982 <puts>
    2eee:	03040a13          	add	s4,s0,48
    2ef2:	03044583          	lbu	a1,48(s0)
    2ef6:	82898513          	add	a0,s3,-2008
    2efa:	0405                	add	s0,s0,1
    2efc:	a8bfe0ef          	jal	1986 <printf>
    2f00:	ff4419e3          	bne	s0,s4,2ef2 <sign_1st_cert+0x112>
    2f04:	4529                	li	a0,10
    2f06:	a75fe0ef          	jal	197a <putchar>
    2f0a:	50011537          	lui	a0,0x50011
    2f0e:	85ca                	mv	a1,s2
    2f10:	bb848613          	add	a2,s1,-1096
    2f14:	c4850513          	add	a0,a0,-952 # 50010c48 <public_key>
    2f18:	b76fe0ef          	jal	128e <ecdsa_verify>
    2f1c:	4785                	li	a5,1
    2f1e:	85aa                	mv	a1,a0
    2f20:	02f50d63          	beq	a0,a5,2f5a <sign_1st_cert+0x17a>
    2f24:	50011537          	lui	a0,0x50011
    2f28:	97450513          	add	a0,a0,-1676 # 50010974 <k+0x5f4>
    2f2c:	a5bfe0ef          	jal	1986 <printf>
    2f30:	500107b7          	lui	a5,0x50010
    2f34:	50011737          	lui	a4,0x50011
    2f38:	500116b7          	lui	a3,0x50011
    2f3c:	17878793          	add	a5,a5,376 # 50010178 <cert_len>
    2f40:	c7c70713          	add	a4,a4,-900 # 50010c7c <cert_der>
    2f44:	be868693          	add	a3,a3,-1048 # 50010be8 <signature+0x30>
    2f48:	bb848613          	add	a2,s1,-1096
    2f4c:	17cb2583          	lw	a1,380(s6)
    2f50:	c7ca8513          	add	a0,s5,-900
    2f54:	f64ff0ef          	jal	26b8 <add_signature_to_cert>
    2f58:	bf09                	j	2e6a <sign_1st_cert+0x8a>
    2f5a:	50011537          	lui	a0,0x50011
    2f5e:	99850513          	add	a0,a0,-1640 # 50010998 <k+0x618>
    2f62:	a21fe0ef          	jal	1982 <puts>
    2f66:	b7e9                	j	2f30 <sign_1st_cert+0x150>

00002f68 <main>:
    2f68:	715d                	add	sp,sp,-80
    2f6a:	c686                	sw	ra,76(sp)
    2f6c:	c4a2                	sw	s0,72(sp)
    2f6e:	c2a6                	sw	s1,68(sp)
    2f70:	0880                	add	s0,sp,80
    2f72:	c0ca                	sw	s2,64(sp)
    2f74:	de4e                	sw	s3,60(sp)
    2f76:	da56                	sw	s5,52(sp)
    2f78:	d85a                	sw	s6,48(sp)
    2f7a:	dc52                	sw	s4,56(sp)
    2f7c:	d65e                	sw	s7,44(sp)
    2f7e:	d462                	sw	s8,40(sp)
    2f80:	d266                	sw	s9,36(sp)
    2f82:	d06a                	sw	s10,32(sp)
    2f84:	ce6e                	sw	s11,28(sp)
    2f86:	500114b7          	lui	s1,0x50011
    2f8a:	a3eff0ef          	jal	21c8 <init_uart>
    2f8e:	906ff0ef          	jal	2094 <enable_csrng>
    2f92:	9b448513          	add	a0,s1,-1612 # 500109b4 <k+0x634>
    2f96:	9edfe0ef          	jal	1982 <puts>
    2f9a:	50011537          	lui	a0,0x50011
    2f9e:	9dc50513          	add	a0,a0,-1572 # 500109dc <k+0x65c>
    2fa2:	9e1fe0ef          	jal	1982 <puts>
    2fa6:	9b448513          	add	a0,s1,-1612
    2faa:	9d9fe0ef          	jal	1982 <puts>
    2fae:	50011637          	lui	a2,0x50011
    2fb2:	500115b7          	lui	a1,0x50011
    2fb6:	50011537          	lui	a0,0x50011
    2fba:	a0460613          	add	a2,a2,-1532 # 50010a04 <k+0x684>
    2fbe:	a1058593          	add	a1,a1,-1520 # 50010a10 <k+0x690>
    2fc2:	a1c50513          	add	a0,a0,-1508 # 50010a1c <k+0x69c>
    2fc6:	9c1fe0ef          	jal	1986 <printf>
    2fca:	de7ff0ef          	jal	2db0 <generate_2nd_cert>
    2fce:	4901                	li	s2,0
    2fd0:	500119b7          	lui	s3,0x50011
    2fd4:	4a91                	li	s5,4
    2fd6:	50011b37          	lui	s6,0x50011
    2fda:	bb3f0bb7          	lui	s7,0xbb3f0
    2fde:	50011c37          	lui	s8,0x50011
    2fe2:	0bb5                	add	s7,s7,13 # bb3f000d <_tbs_der_store_end+0x6b3d0fed>
    2fe4:	4ca9                	li	s9,10
    2fe6:	890ff0ef          	jal	2076 <soc_ifc_read_mbox_cmd>
    2fea:	faa42c23          	sw	a0,-72(s0)
    2fee:	fab42e23          	sw	a1,-68(s0)
    2ff2:	00159793          	sll	a5,a1,0x1
    2ff6:	84aa                	mv	s1,a0
    2ff8:	8a2e                	mv	s4,a1
    2ffa:	fe07d6e3          	bgez	a5,2fe6 <main+0x7e>
    2ffe:	a34c0513          	add	a0,s8,-1484 # 50010a34 <k+0x6b4>
    3002:	9a5e                	add	s4,s4,s7
    3004:	983fe0ef          	jal	1986 <printf>
    3008:	fd4cefe3          	bltu	s9,s4,2fe6 <main+0x7e>
    300c:	500117b7          	lui	a5,0x50011
    3010:	b4878793          	add	a5,a5,-1208 # 50010b48 <k+0x7c8>
    3014:	0a0a                	sll	s4,s4,0x2
    3016:	9a3e                	add	s4,s4,a5
    3018:	000a2783          	lw	a5,0(s4)
    301c:	8782                	jr	a5
    301e:	8b8a                	mv	s7,sp
    3020:	1101                	add	sp,sp,-32
    3022:	858a                	mv	a1,sp
    3024:	02000513          	li	a0,32
    3028:	8d2ff0ef          	jal	20fa <generate_random_numbers>
    302c:	8a0a                	mv	s4,sp
    302e:	84aa                	mv	s1,a0
    3030:	ed0d                	bnez	a0,306a <main+0x102>
    3032:	50011537          	lui	a0,0x50011
    3036:	a7450513          	add	a0,a0,-1420 # 50010a74 <k+0x6f4>
    303a:	949fe0ef          	jal	1982 <puts>
    303e:	50011cb7          	lui	s9,0x50011
    3042:	02000c13          	li	s8,32
    3046:	009a07b3          	add	a5,s4,s1
    304a:	0007c583          	lbu	a1,0(a5)
    304e:	a84c8513          	add	a0,s9,-1404 # 50010a84 <k+0x704>
    3052:	0485                	add	s1,s1,1
    3054:	933fe0ef          	jal	1986 <printf>
    3058:	ff8497e3          	bne	s1,s8,3046 <main+0xde>
    305c:	4529                	li	a0,10
    305e:	91dfe0ef          	jal	197a <putchar>
    3062:	85a6                	mv	a1,s1
    3064:	8552                	mv	a0,s4
    3066:	c8cfe0ef          	jal	14f2 <mailbox_send_data>
    306a:	815e                	mv	sp,s7
    306c:	b7bd                	j	2fda <main+0x72>
    306e:	500107b7          	lui	a5,0x50010
    3072:	17c7a483          	lw	s1,380(a5) # 5001017c <tbs_len>
    3076:	50012537          	lui	a0,0x50012
    307a:	8626                	mv	a2,s1
    307c:	4581                	li	a1,0
    307e:	c7c50513          	add	a0,a0,-900 # 50011c7c <tbs_der>
    3082:	2b49                	jal	3614 <memset>
    3084:	500107b7          	lui	a5,0x50010
    3088:	4581                	li	a1,0
    308a:	1787a603          	lw	a2,376(a5) # 50010178 <cert_len>
    308e:	c7c98513          	add	a0,s3,-900 # 50010c7c <cert_der>
    3092:	2349                	jal	3614 <memset>
    3094:	50012537          	lui	a0,0x50012
    3098:	85a6                	mv	a1,s1
    309a:	47c50513          	add	a0,a0,1148 # 5001247c <cert_store>
    309e:	c54fe0ef          	jal	14f2 <mailbox_send_data>
    30a2:	bf25                	j	2fda <main+0x72>
    30a4:	50010bb7          	lui	s7,0x50010
    30a8:	50012cb7          	lui	s9,0x50012
    30ac:	17cba603          	lw	a2,380(s7) # 5001017c <tbs_len>
    30b0:	4581                	li	a1,0
    30b2:	c7cc8513          	add	a0,s9,-900 # 50011c7c <tbs_der>
    30b6:	2bb9                	jal	3614 <memset>
    30b8:	50010a37          	lui	s4,0x50010
    30bc:	178a2603          	lw	a2,376(s4) # 50010178 <cert_len>
    30c0:	4581                	li	a1,0
    30c2:	c7c98513          	add	a0,s3,-900
    30c6:	23b9                	jal	3614 <memset>
    30c8:	50010537          	lui	a0,0x50010
    30cc:	85a6                	mv	a1,s1
    30ce:	18c50513          	add	a0,a0,396 # 5001018c <tbs_len+0x10>
    30d2:	8b5fe0ef          	jal	1986 <printf>
    30d6:	0c700793          	li	a5,199
    30da:	0097e963          	bltu	a5,s1,30ec <main+0x184>
    30de:	50011537          	lui	a0,0x50011
    30e2:	a8c50513          	add	a0,a0,-1396 # 50010a8c <k+0x70c>
    30e6:	89dfe0ef          	jal	1982 <puts>
    30ea:	bdc5                	j	2fda <main+0x72>
    30ec:	30020d37          	lui	s10,0x30020
    30f0:	169bae23          	sw	s1,380(s7)
    30f4:	4901                	li	s2,0
    30f6:	0d51                	add	s10,s10,20 # 30020014 <_data_lma_end+0x3001bc50>
    30f8:	50010837          	lui	a6,0x50010
    30fc:	000d2d83          	lw	s11,0(s10)
    3100:	1b480513          	add	a0,a6,436 # 500101b4 <tbs_len+0x38>
    3104:	85ee                	mv	a1,s11
    3106:	881fe0ef          	jal	1986 <printf>
    310a:	8726                	mv	a4,s1
    310c:	50010837          	lui	a6,0x50010
    3110:	009af363          	bgeu	s5,s1,3116 <main+0x1ae>
    3114:	4711                	li	a4,4
    3116:	4781                	li	a5,0
    3118:	012786b3          	add	a3,a5,s2
    311c:	c7cc8613          	add	a2,s9,-900
    3120:	96b2                	add	a3,a3,a2
    3122:	00379613          	sll	a2,a5,0x3
    3126:	00cdd633          	srl	a2,s11,a2
    312a:	00c68023          	sb	a2,0(a3)
    312e:	0785                	add	a5,a5,1
    3130:	c7cc8c13          	add	s8,s9,-900
    3134:	fef712e3          	bne	a4,a5,3118 <main+0x1b0>
    3138:	993a                	add	s2,s2,a4
    313a:	0b54f563          	bgeu	s1,s5,31e4 <main+0x27c>
    313e:	4481                	li	s1,0
    3140:	000c4703          	lbu	a4,0(s8)
    3144:	03000793          	li	a5,48
    3148:	02f71363          	bne	a4,a5,316e <main+0x206>
    314c:	001c4703          	lbu	a4,1(s8)
    3150:	08200793          	li	a5,130
    3154:	00f71d63          	bne	a4,a5,316e <main+0x206>
    3158:	002c5783          	lhu	a5,2(s8)
    315c:	0087d913          	srl	s2,a5,0x8
    3160:	07a2                	sll	a5,a5,0x8
    3162:	00f96933          	or	s2,s2,a5
    3166:	0942                	sll	s2,s2,0x10
    3168:	01095913          	srl	s2,s2,0x10
    316c:	0911                	add	s2,s2,4
    316e:	50011537          	lui	a0,0x50011
    3172:	85ca                	mv	a1,s2
    3174:	aa050513          	add	a0,a0,-1376 # 50010aa0 <k+0x720>
    3178:	172bae23          	sw	s2,380(s7)
    317c:	80bfe0ef          	jal	1986 <printf>
    3180:	4901                	li	s2,0
    3182:	17cba783          	lw	a5,380(s7)
    3186:	06f96363          	bltu	s2,a5,31ec <main+0x284>
    318a:	4529                	li	a0,10
    318c:	feefe0ef          	jal	197a <putchar>
    3190:	c51ff0ef          	jal	2de0 <sign_1st_cert>
    3194:	50011537          	lui	a0,0x50011
    3198:	178a2583          	lw	a1,376(s4)
    319c:	abc50513          	add	a0,a0,-1348 # 50010abc <k+0x73c>
    31a0:	fe6fe0ef          	jal	1986 <printf>
    31a4:	178a2783          	lw	a5,376(s4)
    31a8:	04f4ec63          	bltu	s1,a5,3200 <main+0x298>
    31ac:	4529                	li	a0,10
    31ae:	fccfe0ef          	jal	197a <putchar>
    31b2:	50011637          	lui	a2,0x50011
    31b6:	c4860613          	add	a2,a2,-952 # 50010c48 <public_key>
    31ba:	178a2583          	lw	a1,376(s4)
    31be:	c7c98513          	add	a0,s3,-900
    31c2:	e9aff0ef          	jal	285c <verify_cert>
    31c6:	4785                	li	a5,1
    31c8:	892a                	mv	s2,a0
    31ca:	04f51663          	bne	a0,a5,3216 <main+0x2ae>
    31ce:	50011537          	lui	a0,0x50011
    31d2:	ad850513          	add	a0,a0,-1320 # 50010ad8 <k+0x758>
    31d6:	facfe0ef          	jal	1982 <puts>
    31da:	178a2583          	lw	a1,376(s4)
    31de:	c7c98513          	add	a0,s3,-900
    31e2:	bd75                	j	309e <main+0x136>
    31e4:	14f1                	add	s1,s1,-4
    31e6:	f0049be3          	bnez	s1,30fc <main+0x194>
    31ea:	bf99                	j	3140 <main+0x1d8>
    31ec:	012c07b3          	add	a5,s8,s2
    31f0:	0007c583          	lbu	a1,0(a5)
    31f4:	828b0513          	add	a0,s6,-2008 # 50010828 <k+0x4a8>
    31f8:	f8efe0ef          	jal	1986 <printf>
    31fc:	0905                	add	s2,s2,1
    31fe:	b751                	j	3182 <main+0x21a>
    3200:	c7c98793          	add	a5,s3,-900
    3204:	97a6                	add	a5,a5,s1
    3206:	0007c583          	lbu	a1,0(a5)
    320a:	828b0513          	add	a0,s6,-2008
    320e:	f78fe0ef          	jal	1986 <printf>
    3212:	0485                	add	s1,s1,1
    3214:	bf41                	j	31a4 <main+0x23c>
    3216:	85aa                	mv	a1,a0
    3218:	50011537          	lui	a0,0x50011
    321c:	af050513          	add	a0,a0,-1296 # 50010af0 <k+0x770>
    3220:	f66fe0ef          	jal	1986 <printf>
    3224:	bf5d                	j	31da <main+0x272>
    3226:	50010bb7          	lui	s7,0x50010
    322a:	178ba603          	lw	a2,376(s7) # 50010178 <cert_len>
    322e:	4581                	li	a1,0
    3230:	c7c98513          	add	a0,s3,-900
    3234:	26c5                	jal	3614 <memset>
    3236:	50010537          	lui	a0,0x50010
    323a:	85a6                	mv	a1,s1
    323c:	18c50513          	add	a0,a0,396 # 5001018c <tbs_len+0x10>
    3240:	f46fe0ef          	jal	1986 <printf>
    3244:	12b00793          	li	a5,299
    3248:	e897fbe3          	bgeu	a5,s1,30de <main+0x176>
    324c:	30020cb7          	lui	s9,0x30020
    3250:	169bac23          	sw	s1,376(s7)
    3254:	4a01                	li	s4,0
    3256:	0cd1                	add	s9,s9,20 # 30020014 <_data_lma_end+0x3001bc50>
    3258:	50010db7          	lui	s11,0x50010
    325c:	000cad03          	lw	s10,0(s9)
    3260:	85ea                	mv	a1,s10
    3262:	1b4d8513          	add	a0,s11,436 # 500101b4 <tbs_len+0x38>
    3266:	f20fe0ef          	jal	1986 <printf>
    326a:	8726                	mv	a4,s1
    326c:	009af363          	bgeu	s5,s1,3272 <main+0x30a>
    3270:	4711                	li	a4,4
    3272:	4781                	li	a5,0
    3274:	014786b3          	add	a3,a5,s4
    3278:	c7c98613          	add	a2,s3,-900
    327c:	96b2                	add	a3,a3,a2
    327e:	00379613          	sll	a2,a5,0x3
    3282:	00cd5633          	srl	a2,s10,a2
    3286:	00c68023          	sb	a2,0(a3)
    328a:	0785                	add	a5,a5,1
    328c:	c7c98c13          	add	s8,s3,-900
    3290:	fef712e3          	bne	a4,a5,3274 <main+0x30c>
    3294:	9a3a                	add	s4,s4,a4
    3296:	0954f463          	bgeu	s1,s5,331e <main+0x3b6>
    329a:	4481                	li	s1,0
    329c:	000c4703          	lbu	a4,0(s8)
    32a0:	03000793          	li	a5,48
    32a4:	02f71363          	bne	a4,a5,32ca <main+0x362>
    32a8:	001c4703          	lbu	a4,1(s8)
    32ac:	08200793          	li	a5,130
    32b0:	00f71d63          	bne	a4,a5,32ca <main+0x362>
    32b4:	002c5783          	lhu	a5,2(s8)
    32b8:	0087da13          	srl	s4,a5,0x8
    32bc:	07a2                	sll	a5,a5,0x8
    32be:	00fa6a33          	or	s4,s4,a5
    32c2:	0a42                	sll	s4,s4,0x10
    32c4:	010a5a13          	srl	s4,s4,0x10
    32c8:	0a11                	add	s4,s4,4
    32ca:	50011537          	lui	a0,0x50011
    32ce:	85d2                	mv	a1,s4
    32d0:	b1450513          	add	a0,a0,-1260 # 50010b14 <k+0x794>
    32d4:	174bac23          	sw	s4,376(s7)
    32d8:	eaefe0ef          	jal	1986 <printf>
    32dc:	178ba783          	lw	a5,376(s7)
    32e0:	04f4e263          	bltu	s1,a5,3324 <main+0x3bc>
    32e4:	4529                	li	a0,10
    32e6:	e94fe0ef          	jal	197a <putchar>
    32ea:	500127b7          	lui	a5,0x50012
    32ee:	50012537          	lui	a0,0x50012
    32f2:	47c78793          	add	a5,a5,1148 # 5001247c <cert_store>
    32f6:	178ba603          	lw	a2,376(s7)
    32fa:	c7c98593          	add	a1,s3,-900
    32fe:	68450513          	add	a0,a0,1668 # 50012684 <cert_store+0x208>
    3302:	40c7a423          	sw	a2,1032(a5)
    3306:	40078623          	sb	zero,1036(a5)
    330a:	2e4d                	jal	36bc <memcpy>
    330c:	50011537          	lui	a0,0x50011
    3310:	b3050513          	add	a0,a0,-1232 # 50010b30 <k+0x7b0>
    3314:	e6efe0ef          	jal	1982 <puts>
    3318:	4585                	li	a1,1
    331a:	854a                	mv	a0,s2
    331c:	b349                	j	309e <main+0x136>
    331e:	14f1                	add	s1,s1,-4
    3320:	fc95                	bnez	s1,325c <main+0x2f4>
    3322:	bfad                	j	329c <main+0x334>
    3324:	009c07b3          	add	a5,s8,s1
    3328:	0007c583          	lbu	a1,0(a5)
    332c:	828b0513          	add	a0,s6,-2008
    3330:	e56fe0ef          	jal	1986 <printf>
    3334:	0485                	add	s1,s1,1
    3336:	b75d                	j	32dc <main+0x374>
    3338:	500124b7          	lui	s1,0x50012
    333c:	47c48793          	add	a5,s1,1148 # 5001247c <cert_store>
    3340:	50011537          	lui	a0,0x50011
    3344:	4087a583          	lw	a1,1032(a5)
    3348:	b1450513          	add	a0,a0,-1260 # 50010b14 <k+0x794>
    334c:	47c48b93          	add	s7,s1,1148
    3350:	e36fe0ef          	jal	1986 <printf>
    3354:	4a01                	li	s4,0
    3356:	47c48493          	add	s1,s1,1148
    335a:	4084a783          	lw	a5,1032(s1)
    335e:	0b85                	add	s7,s7,1
    3360:	00fa6c63          	bltu	s4,a5,3378 <main+0x410>
    3364:	4529                	li	a0,10
    3366:	e14fe0ef          	jal	197a <putchar>
    336a:	50012537          	lui	a0,0x50012
    336e:	4084a583          	lw	a1,1032(s1)
    3372:	68450513          	add	a0,a0,1668 # 50012684 <cert_store+0x208>
    3376:	b325                	j	309e <main+0x136>
    3378:	207bc583          	lbu	a1,519(s7)
    337c:	828b0513          	add	a0,s6,-2008
    3380:	e06fe0ef          	jal	1986 <printf>
    3384:	0a05                	add	s4,s4,1
    3386:	bfd1                	j	335a <main+0x3f2>
    3388:	50010a37          	lui	s4,0x50010
    338c:	178a2603          	lw	a2,376(s4) # 50010178 <cert_len>
    3390:	4581                	li	a1,0
    3392:	c7c98513          	add	a0,s3,-900
    3396:	2cbd                	jal	3614 <memset>
    3398:	50010537          	lui	a0,0x50010
    339c:	85a6                	mv	a1,s1
    339e:	18c50513          	add	a0,a0,396 # 5001018c <tbs_len+0x10>
    33a2:	de4fe0ef          	jal	1986 <printf>
    33a6:	18f00793          	li	a5,399
    33aa:	d297fae3          	bgeu	a5,s1,30de <main+0x176>
    33ae:	30020bb7          	lui	s7,0x30020
    33b2:	169a2c23          	sw	s1,376(s4)
    33b6:	4901                	li	s2,0
    33b8:	0bd1                	add	s7,s7,20 # 30020014 <_data_lma_end+0x3001bc50>
    33ba:	50010d37          	lui	s10,0x50010
    33be:	000bac03          	lw	s8,0(s7)
    33c2:	85e2                	mv	a1,s8
    33c4:	1b4d0513          	add	a0,s10,436 # 500101b4 <tbs_len+0x38>
    33c8:	dbefe0ef          	jal	1986 <printf>
    33cc:	8726                	mv	a4,s1
    33ce:	009af363          	bgeu	s5,s1,33d4 <main+0x46c>
    33d2:	4711                	li	a4,4
    33d4:	4781                	li	a5,0
    33d6:	012786b3          	add	a3,a5,s2
    33da:	c7c98613          	add	a2,s3,-900
    33de:	96b2                	add	a3,a3,a2
    33e0:	00379613          	sll	a2,a5,0x3
    33e4:	00cc5633          	srl	a2,s8,a2
    33e8:	00c68023          	sb	a2,0(a3)
    33ec:	0785                	add	a5,a5,1
    33ee:	c7c98c93          	add	s9,s3,-900
    33f2:	fef712e3          	bne	a4,a5,33d6 <main+0x46e>
    33f6:	993a                	add	s2,s2,a4
    33f8:	0554f863          	bgeu	s1,s5,3448 <main+0x4e0>
    33fc:	4481                	li	s1,0
    33fe:	50011537          	lui	a0,0x50011
    3402:	178a2583          	lw	a1,376(s4)
    3406:	abc50513          	add	a0,a0,-1348 # 50010abc <k+0x73c>
    340a:	d7cfe0ef          	jal	1986 <printf>
    340e:	178a2783          	lw	a5,376(s4)
    3412:	02f4ee63          	bltu	s1,a5,344e <main+0x4e6>
    3416:	4529                	li	a0,10
    3418:	d62fe0ef          	jal	197a <putchar>
    341c:	50011637          	lui	a2,0x50011
    3420:	c4860613          	add	a2,a2,-952 # 50010c48 <public_key>
    3424:	178a2583          	lw	a1,376(s4)
    3428:	c7c98513          	add	a0,s3,-900
    342c:	c30ff0ef          	jal	285c <verify_cert>
    3430:	4785                	li	a5,1
    3432:	892a                	mv	s2,a0
    3434:	02f51763          	bne	a0,a5,3462 <main+0x4fa>
    3438:	50011537          	lui	a0,0x50011
    343c:	ad850513          	add	a0,a0,-1320 # 50010ad8 <k+0x758>
    3440:	d42fe0ef          	jal	1982 <puts>
    3444:	4591                	li	a1,4
    3446:	bdd1                	j	331a <main+0x3b2>
    3448:	14f1                	add	s1,s1,-4
    344a:	f8b5                	bnez	s1,33be <main+0x456>
    344c:	bf4d                	j	33fe <main+0x496>
    344e:	009c87b3          	add	a5,s9,s1
    3452:	0007c583          	lbu	a1,0(a5)
    3456:	828b0513          	add	a0,s6,-2008
    345a:	d2cfe0ef          	jal	1986 <printf>
    345e:	0485                	add	s1,s1,1
    3460:	b77d                	j	340e <main+0x4a6>
    3462:	85aa                	mv	a1,a0
    3464:	50011537          	lui	a0,0x50011
    3468:	af050513          	add	a0,a0,-1296 # 50010af0 <k+0x770>
    346c:	d1afe0ef          	jal	1986 <printf>
    3470:	bfd1                	j	3444 <main+0x4dc>
	...

00003474 <early_trap_vector>:
    3474:	342022f3          	csrr	t0,mcause
    3478:	34102373          	csrr	t1,mepc
    347c:	343023f3          	csrr	t2,mtval
    3480:	30030e37          	lui	t3,0x30030
    3484:	0cce0e13          	add	t3,t3,204 # 300300cc <_data_lma_end+0x3002bd08>
    3488:	5000de97          	auipc	t4,0x5000d
    348c:	c68e8e93          	add	t4,t4,-920 # 500100f0 <trap_msg>

00003490 <trap_print_loop>:
    3490:	000e8283          	lb	t0,0(t4)
    3494:	005e0023          	sb	t0,0(t3)
    3498:	0e85                	add	t4,t4,1
    349a:	fe029be3          	bnez	t0,3490 <trap_print_loop>
    349e:	4f05                	li	t5,1
    34a0:	01ee0023          	sb	t5,0(t3)
    34a4:	bfc1                	j	3474 <early_trap_vector>

000034a6 <__lshrdi3>:
    34a6:	ca19                	beqz	a2,34bc <__lshrdi3+0x16>
    34a8:	02000793          	li	a5,32
    34ac:	8f91                	sub	a5,a5,a2
    34ae:	00f04863          	bgtz	a5,34be <__lshrdi3+0x18>
    34b2:	1601                	add	a2,a2,-32
    34b4:	00c5d533          	srl	a0,a1,a2
    34b8:	4701                	li	a4,0
    34ba:	85ba                	mv	a1,a4
    34bc:	8082                	ret
    34be:	00c5d733          	srl	a4,a1,a2
    34c2:	00c55533          	srl	a0,a0,a2
    34c6:	00f595b3          	sll	a1,a1,a5
    34ca:	8d4d                	or	a0,a0,a1
    34cc:	b7fd                	j	34ba <__lshrdi3+0x14>

000034ce <__ashldi3>:
    34ce:	ca19                	beqz	a2,34e4 <__ashldi3+0x16>
    34d0:	02000793          	li	a5,32
    34d4:	8f91                	sub	a5,a5,a2
    34d6:	00f04863          	bgtz	a5,34e6 <__ashldi3+0x18>
    34da:	1601                	add	a2,a2,-32
    34dc:	00c515b3          	sll	a1,a0,a2
    34e0:	4701                	li	a4,0
    34e2:	853a                	mv	a0,a4
    34e4:	8082                	ret
    34e6:	00c51733          	sll	a4,a0,a2
    34ea:	00c595b3          	sll	a1,a1,a2
    34ee:	00f55533          	srl	a0,a0,a5
    34f2:	8dc9                	or	a1,a1,a0
    34f4:	b7fd                	j	34e2 <__ashldi3+0x14>

000034f6 <memcmp>:
    34f6:	478d                	li	a5,3
    34f8:	02c7f363          	bgeu	a5,a2,351e <memcmp+0x28>
    34fc:	00a5e733          	or	a4,a1,a0
    3500:	8b0d                	and	a4,a4,3
    3502:	cb09                	beqz	a4,3514 <memcmp+0x1e>
    3504:	fff60693          	add	a3,a2,-1
    3508:	a831                	j	3524 <memcmp+0x2e>
    350a:	1671                	add	a2,a2,-4
    350c:	0511                	add	a0,a0,4
    350e:	0591                	add	a1,a1,4
    3510:	00c7f763          	bgeu	a5,a2,351e <memcmp+0x28>
    3514:	4114                	lw	a3,0(a0)
    3516:	4198                	lw	a4,0(a1)
    3518:	fee689e3          	beq	a3,a4,350a <memcmp+0x14>
    351c:	b7e5                	j	3504 <memcmp+0xe>
    351e:	fff60693          	add	a3,a2,-1
    3522:	c20d                	beqz	a2,3544 <memcmp+0x4e>
    3524:	0685                	add	a3,a3,1
    3526:	96aa                	add	a3,a3,a0
    3528:	a021                	j	3530 <memcmp+0x3a>
    352a:	0585                	add	a1,a1,1
    352c:	00a68c63          	beq	a3,a0,3544 <memcmp+0x4e>
    3530:	00054783          	lbu	a5,0(a0)
    3534:	0005c703          	lbu	a4,0(a1)
    3538:	0505                	add	a0,a0,1
    353a:	fee788e3          	beq	a5,a4,352a <memcmp+0x34>
    353e:	40e78533          	sub	a0,a5,a4
    3542:	8082                	ret
    3544:	4501                	li	a0,0
    3546:	8082                	ret

00003548 <memmove>:
    3548:	02a5f263          	bgeu	a1,a0,356c <memmove+0x24>
    354c:	00c58733          	add	a4,a1,a2
    3550:	00e57e63          	bgeu	a0,a4,356c <memmove+0x24>
    3554:	00c507b3          	add	a5,a0,a2
    3558:	ca1d                	beqz	a2,358e <memmove+0x46>
    355a:	17fd                	add	a5,a5,-1
    355c:	fff74683          	lbu	a3,-1(a4)
    3560:	00d78023          	sb	a3,0(a5)
    3564:	177d                	add	a4,a4,-1
    3566:	fef51ae3          	bne	a0,a5,355a <memmove+0x12>
    356a:	8082                	ret
    356c:	47bd                	li	a5,15
    356e:	02c7e163          	bltu	a5,a2,3590 <memmove+0x48>
    3572:	87aa                	mv	a5,a0
    3574:	fff60693          	add	a3,a2,-1
    3578:	ca59                	beqz	a2,360e <memmove+0xc6>
    357a:	0685                	add	a3,a3,1
    357c:	96be                	add	a3,a3,a5
    357e:	0785                	add	a5,a5,1
    3580:	0005c703          	lbu	a4,0(a1)
    3584:	fee78fa3          	sb	a4,-1(a5)
    3588:	0585                	add	a1,a1,1
    358a:	fed79ae3          	bne	a5,a3,357e <memmove+0x36>
    358e:	8082                	ret
    3590:	00b567b3          	or	a5,a0,a1
    3594:	8b8d                	and	a5,a5,3
    3596:	eba5                	bnez	a5,3606 <memmove+0xbe>
    3598:	ff060893          	add	a7,a2,-16
    359c:	ff08f893          	and	a7,a7,-16
    35a0:	08c1                	add	a7,a7,16
    35a2:	011506b3          	add	a3,a0,a7
    35a6:	872e                	mv	a4,a1
    35a8:	87aa                	mv	a5,a0
    35aa:	00072803          	lw	a6,0(a4)
    35ae:	0107a023          	sw	a6,0(a5)
    35b2:	00472803          	lw	a6,4(a4)
    35b6:	0107a223          	sw	a6,4(a5)
    35ba:	00872803          	lw	a6,8(a4)
    35be:	0107a423          	sw	a6,8(a5)
    35c2:	00c72803          	lw	a6,12(a4)
    35c6:	07c1                	add	a5,a5,16
    35c8:	ff07ae23          	sw	a6,-4(a5)
    35cc:	0741                	add	a4,a4,16
    35ce:	fcd79ee3          	bne	a5,a3,35aa <memmove+0x62>
    35d2:	00c67813          	and	a6,a2,12
    35d6:	95c6                	add	a1,a1,a7
    35d8:	00f67713          	and	a4,a2,15
    35dc:	02080a63          	beqz	a6,3610 <memmove+0xc8>
    35e0:	ffc70813          	add	a6,a4,-4
    35e4:	ffc87813          	and	a6,a6,-4
    35e8:	0811                	add	a6,a6,4 # 50010004 <curve_n+0x4>
    35ea:	010687b3          	add	a5,a3,a6
    35ee:	872e                	mv	a4,a1
    35f0:	0691                	add	a3,a3,4
    35f2:	00072883          	lw	a7,0(a4)
    35f6:	ff16ae23          	sw	a7,-4(a3)
    35fa:	0711                	add	a4,a4,4
    35fc:	fef69ae3          	bne	a3,a5,35f0 <memmove+0xa8>
    3600:	8a0d                	and	a2,a2,3
    3602:	95c2                	add	a1,a1,a6
    3604:	bf85                	j	3574 <memmove+0x2c>
    3606:	fff60693          	add	a3,a2,-1
    360a:	87aa                	mv	a5,a0
    360c:	b7bd                	j	357a <memmove+0x32>
    360e:	8082                	ret
    3610:	863a                	mv	a2,a4
    3612:	b78d                	j	3574 <memmove+0x2c>

00003614 <memset>:
    3614:	433d                	li	t1,15
    3616:	872a                	mv	a4,a0
    3618:	02c37363          	bgeu	t1,a2,363e <memset+0x2a>
    361c:	00f77793          	and	a5,a4,15
    3620:	efbd                	bnez	a5,369e <memset+0x8a>
    3622:	e5ad                	bnez	a1,368c <memset+0x78>
    3624:	ff067693          	and	a3,a2,-16
    3628:	8a3d                	and	a2,a2,15
    362a:	96ba                	add	a3,a3,a4
    362c:	c30c                	sw	a1,0(a4)
    362e:	c34c                	sw	a1,4(a4)
    3630:	c70c                	sw	a1,8(a4)
    3632:	c74c                	sw	a1,12(a4)
    3634:	0741                	add	a4,a4,16
    3636:	fed76be3          	bltu	a4,a3,362c <memset+0x18>
    363a:	e211                	bnez	a2,363e <memset+0x2a>
    363c:	8082                	ret
    363e:	40c306b3          	sub	a3,t1,a2
    3642:	068a                	sll	a3,a3,0x2
    3644:	00000297          	auipc	t0,0x0
    3648:	9696                	add	a3,a3,t0
    364a:	00a68067          	jr	10(a3)
    364e:	00b70723          	sb	a1,14(a4)
    3652:	00b706a3          	sb	a1,13(a4)
    3656:	00b70623          	sb	a1,12(a4)
    365a:	00b705a3          	sb	a1,11(a4)
    365e:	00b70523          	sb	a1,10(a4)
    3662:	00b704a3          	sb	a1,9(a4)
    3666:	00b70423          	sb	a1,8(a4)
    366a:	00b703a3          	sb	a1,7(a4)
    366e:	00b70323          	sb	a1,6(a4)
    3672:	00b702a3          	sb	a1,5(a4)
    3676:	00b70223          	sb	a1,4(a4)
    367a:	00b701a3          	sb	a1,3(a4)
    367e:	00b70123          	sb	a1,2(a4)
    3682:	00b700a3          	sb	a1,1(a4)
    3686:	00b70023          	sb	a1,0(a4)
    368a:	8082                	ret
    368c:	0ff5f593          	zext.b	a1,a1
    3690:	00859693          	sll	a3,a1,0x8
    3694:	8dd5                	or	a1,a1,a3
    3696:	01059693          	sll	a3,a1,0x10
    369a:	8dd5                	or	a1,a1,a3
    369c:	b761                	j	3624 <memset+0x10>
    369e:	00279693          	sll	a3,a5,0x2
    36a2:	00000297          	auipc	t0,0x0
    36a6:	9696                	add	a3,a3,t0
    36a8:	8286                	mv	t0,ra
    36aa:	fa8680e7          	jalr	-88(a3)
    36ae:	8096                	mv	ra,t0
    36b0:	17c1                	add	a5,a5,-16
    36b2:	8f1d                	sub	a4,a4,a5
    36b4:	963e                	add	a2,a2,a5
    36b6:	f8c374e3          	bgeu	t1,a2,363e <memset+0x2a>
    36ba:	b7a5                	j	3622 <memset+0xe>

000036bc <memcpy>:
    36bc:	00a5c7b3          	xor	a5,a1,a0
    36c0:	8b8d                	and	a5,a5,3
    36c2:	00c508b3          	add	a7,a0,a2
    36c6:	e7b1                	bnez	a5,3712 <memcpy+0x56>
    36c8:	478d                	li	a5,3
    36ca:	04c7f463          	bgeu	a5,a2,3712 <memcpy+0x56>
    36ce:	00357793          	and	a5,a0,3
    36d2:	872a                	mv	a4,a0
    36d4:	e7dd                	bnez	a5,3782 <memcpy+0xc6>
    36d6:	ffc8f613          	and	a2,a7,-4
    36da:	40e606b3          	sub	a3,a2,a4
    36de:	02000793          	li	a5,32
    36e2:	04d7c463          	blt	a5,a3,372a <memcpy+0x6e>
    36e6:	86ae                	mv	a3,a1
    36e8:	87ba                	mv	a5,a4
    36ea:	02c77163          	bgeu	a4,a2,370c <memcpy+0x50>
    36ee:	0006a803          	lw	a6,0(a3)
    36f2:	0791                	add	a5,a5,4
    36f4:	ff07ae23          	sw	a6,-4(a5)
    36f8:	0691                	add	a3,a3,4
    36fa:	fec7eae3          	bltu	a5,a2,36ee <memcpy+0x32>
    36fe:	fff60793          	add	a5,a2,-1
    3702:	8f99                	sub	a5,a5,a4
    3704:	9bf1                	and	a5,a5,-4
    3706:	0791                	add	a5,a5,4
    3708:	973e                	add	a4,a4,a5
    370a:	95be                	add	a1,a1,a5
    370c:	01176663          	bltu	a4,a7,3718 <memcpy+0x5c>
    3710:	8082                	ret
    3712:	872a                	mv	a4,a0
    3714:	ff157ee3          	bgeu	a0,a7,3710 <memcpy+0x54>
    3718:	0005c783          	lbu	a5,0(a1)
    371c:	0705                	add	a4,a4,1
    371e:	fef70fa3          	sb	a5,-1(a4)
    3722:	0585                	add	a1,a1,1
    3724:	fee89ae3          	bne	a7,a4,3718 <memcpy+0x5c>
    3728:	8082                	ret
    372a:	02470713          	add	a4,a4,36
    372e:	5194                	lw	a3,32(a1)
    3730:	0005a383          	lw	t2,0(a1)
    3734:	0045a283          	lw	t0,4(a1)
    3738:	0085af83          	lw	t6,8(a1)
    373c:	00c5af03          	lw	t5,12(a1)
    3740:	0105ae83          	lw	t4,16(a1)
    3744:	0145ae03          	lw	t3,20(a1)
    3748:	0185a303          	lw	t1,24(a1)
    374c:	01c5a803          	lw	a6,28(a1)
    3750:	fed72e23          	sw	a3,-4(a4)
    3754:	fc772e23          	sw	t2,-36(a4)
    3758:	fe572023          	sw	t0,-32(a4)
    375c:	fff72223          	sw	t6,-28(a4)
    3760:	ffe72423          	sw	t5,-24(a4)
    3764:	ffd72623          	sw	t4,-20(a4)
    3768:	ffc72823          	sw	t3,-16(a4)
    376c:	fe672a23          	sw	t1,-12(a4)
    3770:	ff072c23          	sw	a6,-8(a4)
    3774:	40e606b3          	sub	a3,a2,a4
    3778:	02458593          	add	a1,a1,36
    377c:	fad7c7e3          	blt	a5,a3,372a <memcpy+0x6e>
    3780:	b79d                	j	36e6 <memcpy+0x2a>
    3782:	0005c783          	lbu	a5,0(a1)
    3786:	0705                	add	a4,a4,1
    3788:	fef70fa3          	sb	a5,-1(a4)
    378c:	00377793          	and	a5,a4,3
    3790:	0585                	add	a1,a1,1
    3792:	d3b1                	beqz	a5,36d6 <memcpy+0x1a>
    3794:	0005c783          	lbu	a5,0(a1)
    3798:	0705                	add	a4,a4,1
    379a:	fef70fa3          	sb	a5,-1(a4)
    379e:	00377793          	and	a5,a4,3
    37a2:	0585                	add	a1,a1,1
    37a4:	fff9                	bnez	a5,3782 <memcpy+0xc6>
    37a6:	bf05                	j	36d6 <memcpy+0x1a>

000037a8 <strlen>:
    37a8:	00357793          	and	a5,a0,3
    37ac:	872a                	mv	a4,a0
    37ae:	ef9d                	bnez	a5,37ec <strlen+0x44>
    37b0:	7f7f86b7          	lui	a3,0x7f7f8
    37b4:	f7f68693          	add	a3,a3,-129 # 7f7f7f7f <_tbs_der_store_end+0x2f7d8f5f>
    37b8:	55fd                	li	a1,-1
    37ba:	4310                	lw	a2,0(a4)
    37bc:	00d677b3          	and	a5,a2,a3
    37c0:	97b6                	add	a5,a5,a3
    37c2:	8fd1                	or	a5,a5,a2
    37c4:	8fd5                	or	a5,a5,a3
    37c6:	0711                	add	a4,a4,4
    37c8:	feb789e3          	beq	a5,a1,37ba <strlen+0x12>
    37cc:	ffc74683          	lbu	a3,-4(a4)
    37d0:	40a707b3          	sub	a5,a4,a0
    37d4:	ca8d                	beqz	a3,3806 <strlen+0x5e>
    37d6:	ffd74683          	lbu	a3,-3(a4)
    37da:	c29d                	beqz	a3,3800 <strlen+0x58>
    37dc:	ffe74503          	lbu	a0,-2(a4)
    37e0:	00a03533          	snez	a0,a0
    37e4:	953e                	add	a0,a0,a5
    37e6:	1579                	add	a0,a0,-2
    37e8:	8082                	ret
    37ea:	d2f9                	beqz	a3,37b0 <strlen+0x8>
    37ec:	00074783          	lbu	a5,0(a4)
    37f0:	0705                	add	a4,a4,1
    37f2:	00377693          	and	a3,a4,3
    37f6:	fbf5                	bnez	a5,37ea <strlen+0x42>
    37f8:	8f09                	sub	a4,a4,a0
    37fa:	fff70513          	add	a0,a4,-1
    37fe:	8082                	ret
    3800:	ffd78513          	add	a0,a5,-3
    3804:	8082                	ret
    3806:	ffc78513          	add	a0,a5,-4
    380a:	8082                	ret

Disassembly of section .data:

50010000 <curve_n>:
50010000:	ccc52973          	csrrs	s2,0xccc,a0
50010004:	196a                	sll	s2,s2,0x3a
50010006:	ecec                	.insn	2, 0xecec
50010008:	a77a                	.insn	2, 0xa77a
5001000a:	48b0                	lw	a2,80(s1)
5001000c:	0db2                	sll	s11,s11,0xc
5001000e:	581a                	lw	a6,164(sp)
50010010:	2ddf f437 4d81      	.insn	6, 0x4d81f4372ddf
50010016:	ffffc763          	blt	t6,t6,5000f804 <_data_lma_end+0x5000b440>
5001001a:	ffffffff          	.insn	4, 0xffffffff
5001001e:	ffffffff          	.insn	4, 0xffffffff
50010022:	ffffffff          	.insn	4, 0xffffffff
50010026:	ffffffff          	.insn	4, 0xffffffff
5001002a:	ffffffff          	.insn	4, 0xffffffff
5001002e:	          	.insn	4, 0x0ab7ffff

50010030 <curve_G>:
50010030:	72760ab7          	lui	s5,0x72760
50010034:	5e38                	lw	a4,120(a2)
50010036:	3a54                	.insn	2, 0x3a54
50010038:	296c                	.insn	2, 0x296c
5001003a:	bf55                	j	5000ffee <_data_lma_end+0x5000bc2a>
5001003c:	f25d                	bnez	a2,5000ffe2 <_data_lma_end+0x5000bc1e>
5001003e:	5502                	lw	a0,32(sp)
50010040:	2a38                	.insn	2, 0x2a38
50010042:	8254                	.insn	2, 0x8254
50010044:	41e0                	lw	s0,68(a1)
50010046:	9b9859f7          	.insn	4, 0x9b9859f7
5001004a:	3b628ba7          	.insn	4, 0x3b628ba7
5001004e:	6e1d                	lui	t3,0x7
50010050:	ad74                	.insn	2, 0xad74
50010052:	f320                	.insn	2, 0xf320
50010054:	c71e                	sw	t2,140(sp)
50010056:	8eb1                	xor	a3,a3,a2
50010058:	be8b0537          	lui	a0,0xbe8b0
5001005c:	ca22                	sw	s0,20(sp)
5001005e:	0e5faa87          	.insn	4, 0x0e5faa87
50010062:	90ea                	add	ra,ra,s10
50010064:	1d7c                	add	a5,sp,700
50010066:	819d7a43          	.insn	4, 0x819d7a43
5001006a:	1d7e                	sll	s10,s10,0x3f
5001006c:	b1ce                	.insn	2, 0xb1ce
5001006e:	0a60                	add	s0,sp,284
50010070:	b8c0                	.insn	2, 0xb8c0
50010072:	b5f0                	.insn	2, 0xb5f0
50010074:	e9da3113          	sltiu	sp,s4,-355
50010078:	147c                	add	a5,sp,556
5001007a:	289a                	.insn	2, 0x289a
5001007c:	1dbd                	add	s11,s11,-17
5001007e:	f8f4                	.insn	2, 0xf8f4
50010080:	dc29                	beqz	s0,5000ffda <_data_lma_end+0x5000bc16>
50010082:	9292                	add	t0,t0,tp
50010084:	5d9e98bf 96262c6f 	.insn	8, 0x96262c6f5d9e98bf
5001008c:	de4a                	sw	s2,60(sp)
5001008e:	          	auipc	a2,0x2aef3

50010090 <curve_b>:
50010090:	d3ec2aef          	jal	s5,4ffd25ce <_data_lma_end+0x4ffce20a>
50010094:	c8ed                	beqz	s1,50010186 <tbs_len+0xa>
50010096:	2a85                	jal	50010206 <tbs_len+0x8a>
50010098:	d19d                	beqz	a1,5000ffbe <_data_lma_end+0x5000bbfa>
5001009a:	8a2e                	mv	s4,a1
5001009c:	398d                	jal	5000fd0e <_data_lma_end+0x5000b94a>
5001009e:	c656                	sw	s5,12(sp)
500100a0:	875a                	mv	a4,s6
500100a2:	088f5013          	.insn	4, 0x088f5013
500100a6:	0314                	add	a3,sp,384
500100a8:	4112                	lw	sp,4(sp)
500100aa:	fe81                	bnez	a3,5000ffc2 <_data_lma_end+0x5000bbfe>
500100ac:	9c6e                	add	s8,s8,s11
500100ae:	181d                	add	a6,a6,-25
500100b0:	2d19                	jal	500106c6 <k+0x346>
500100b2:	e3f8                	.insn	2, 0xe3f8
500100b4:	988e056b          	.insn	4, 0x988e056b
500100b8:	e7e4                	.insn	2, 0xe7e4
500100ba:	e23e                	.insn	2, 0xe23e
500100bc:	b3312fa7          	.insn	4, 0xb3312fa7

500100c0 <curve_p>:
500100c0:	ffffffff          	.insn	4, 0xffffffff
	...
500100cc:	ffffffff          	.insn	4, 0xffffffff
500100d0:	fffe                	.insn	2, 0xfffe
500100d2:	ffffffff          	.insn	4, 0xffffffff
500100d6:	ffffffff          	.insn	4, 0xffffffff
500100da:	ffffffff          	.insn	4, 0xffffffff
500100de:	ffffffff          	.insn	4, 0xffffffff
500100e2:	ffffffff          	.insn	4, 0xffffffff
500100e6:	ffffffff          	.insn	4, 0xffffffff
500100ea:	ffffffff          	.insn	4, 0xffffffff
500100ee:	          	.insn	4, 0x7878ffff

500100f0 <trap_msg>:
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
50010110:	7878                	.insn	2, 0x7878
50010112:	7878                	.insn	2, 0x7878
50010114:	7878                	.insn	2, 0x7878
50010116:	7878                	.insn	2, 0x7878
50010118:	200a                	.insn	2, 0x200a
5001011a:	2020                	.insn	2, 0x2020
5001011c:	5254                	lw	a3,36(a2)
5001011e:	5041                	c.li	zero,-16
50010120:	5620                	lw	s0,104(a2)
50010122:	4345                	li	t1,17
50010124:	4f54                	lw	a3,28(a4)
50010126:	2052                	.insn	2, 0x2052
50010128:	5845                	li	a6,-15
5001012a:	4345                	li	t1,17
5001012c:	5455                	li	s0,-11
5001012e:	4e49                	li	t3,18
50010130:	4b202147          	.insn	4, 0x4b202147
50010134:	4c49                	li	s8,18
50010136:	204c                	.insn	2, 0x204c
50010138:	214d4953          	.insn	4, 0x214d4953
5001013c:	2121                	jal	50010544 <k+0x1c4>
5001013e:	2020                	.insn	2, 0x2020
50010140:	0a20                	add	s0,sp,280
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
50010162:	7878                	.insn	2, 0x7878
50010164:	7878                	.insn	2, 0x7878
50010166:	7878                	.insn	2, 0x7878
50010168:	7878                	.insn	2, 0x7878
5001016a:	000a                	c.slli	zero,0x2
5001016c:	0000                	unimp
	...

50010170 <bare_rng_seed>:
50010170:	def0                	sw	a2,124(a3)
50010172:	9abc                	.insn	2, 0x9abc
50010174:	5678                	lw	a4,108(a2)
50010176:	1234                	add	a3,sp,296

50010178 <cert_len>:
50010178:	1000                	add	s0,sp,32
	...

5001017c <tbs_len>:
5001017c:	0800                	add	s0,sp,16
5001017e:	0000                	unimp
50010180:	5746                	lw	a4,112(sp)
50010182:	203a                	.insn	2, 0x203a
50010184:	74696157          	.insn	4, 0x74696157
50010188:	0000                	unimp
5001018a:	0000                	unimp
5001018c:	5746                	lw	a4,112(sp)
5001018e:	203a                	.insn	2, 0x203a
50010190:	6552                	.insn	2, 0x6552
50010192:	6461                	lui	s0,0x18
50010194:	6e69                	lui	t3,0x1a
50010196:	30252067          	.insn	4, 0x30252067
5001019a:	6438                	.insn	2, 0x6438
5001019c:	6220                	.insn	2, 0x6220
5001019e:	7479                	lui	s0,0xffffe
500101a0:	7365                	lui	t1,0xffff9
500101a2:	6620                	.insn	2, 0x6620
500101a4:	6f72                	.insn	2, 0x6f72
500101a6:	206d                	jal	50010250 <tbs_len+0xd4>
500101a8:	616d                	add	sp,sp,240
500101aa:	6c69                	lui	s8,0x1a
500101ac:	6f62                	.insn	2, 0x6f62
500101ae:	0a78                	add	a4,sp,284
500101b0:	0000                	unimp
500101b2:	0000                	unimp
500101b4:	2020                	.insn	2, 0x2020
500101b6:	6164                	.insn	2, 0x6164
500101b8:	6174                	.insn	2, 0x6174
500101ba:	3a74756f          	jal	a0,50057d60 <_tbs_der_store_end+0x38d40>
500101be:	3020                	.insn	2, 0x3020
500101c0:	2578                	.insn	2, 0x2578
500101c2:	3830                	.insn	2, 0x3830
500101c4:	0a78                	add	a4,sp,284
500101c6:	0000                	unimp
500101c8:	5746                	lw	a4,112(sp)
500101ca:	203a                	.insn	2, 0x203a
500101cc:	74697257          	.insn	4, 0x74697257
500101d0:	6e69                	lui	t3,0x1a
500101d2:	78302067          	.insn	4, 0x78302067
500101d6:	3025                	jal	5000f9fe <_data_lma_end+0x5000b63a>
500101d8:	7838                	.insn	2, 0x7838
500101da:	6220                	.insn	2, 0x6220
500101dc:	7479                	lui	s0,0xffffe
500101de:	7365                	lui	t1,0xffff9
500101e0:	7420                	.insn	2, 0x7420
500101e2:	616d206f          	j	500e27f8 <_tbs_der_store_end+0xc37d8>
500101e6:	6c69                	lui	s8,0x1a
500101e8:	6f62                	.insn	2, 0x6f62
500101ea:	0a78                	add	a4,sp,284
500101ec:	0000                	unimp
500101ee:	0000                	unimp
500101f0:	5746                	lw	a4,112(sp)
500101f2:	203a                	.insn	2, 0x203a
500101f4:	20746553          	.insn	4, 0x20746553
500101f8:	6164                	.insn	2, 0x6164
500101fa:	6174                	.insn	2, 0x6174
500101fc:	7220                	.insn	2, 0x7220
500101fe:	6165                	add	sp,sp,112
50010200:	7964                	.insn	2, 0x7964
50010202:	7320                	.insn	2, 0x7320
50010204:	6174                	.insn	2, 0x6174
50010206:	7574                	.insn	2, 0x7574
50010208:	00000073          	ecall
5001020c:	5245                	li	tp,-15
5001020e:	4f52                	lw	t5,20(sp)
50010210:	3a52                	.insn	2, 0x3a52
50010212:	6d20                	.insn	2, 0x6d20
50010214:	6961                	lui	s2,0x18
50010216:	626c                	.insn	2, 0x626c
50010218:	6920786f          	jal	a6,500178aa <STACK+0xc0a>
5001021c:	206e                	.insn	2, 0x206e
5001021e:	6e75                	lui	t3,0x1d
50010220:	7865                	lui	a6,0xffff9
50010222:	6570                	.insn	2, 0x6570
50010224:	64657463          	bgeu	a0,t1,5001086c <k+0x4ec>
50010228:	7320                	.insn	2, 0x7320
5001022a:	6174                	.insn	2, 0x6174
5001022c:	6574                	.insn	2, 0x6574
5001022e:	2820                	.insn	2, 0x2820
50010230:	3025                	jal	5000fa58 <_data_lma_end+0x5000b694>
50010232:	7838                	.insn	2, 0x7838
50010234:	2029                	jal	5001023e <tbs_len+0xc2>
50010236:	6e656877          	.insn	4, 0x6e656877
5001023a:	6520                	.insn	2, 0x6520
5001023c:	7078                	.insn	2, 0x7078
5001023e:	6365                	lui	t1,0x19
50010240:	6974                	.insn	2, 0x6974
50010242:	676e                	.insn	2, 0x676e
50010244:	4d20                	lw	s0,88(a0)
50010246:	4f42                	lw	t5,16(sp)
50010248:	5f58                	lw	a4,60(a4)
5001024a:	5845                	li	a6,-15
5001024c:	4345                	li	t1,17
5001024e:	5455                	li	s0,-11
50010250:	5f45                	li	t5,-15
50010252:	20434f53          	.insn	4, 0x20434f53
50010256:	3028                	.insn	2, 0x3028
50010258:	2578                	.insn	2, 0x2578
5001025a:	3830                	.insn	2, 0x3830
5001025c:	2978                	.insn	2, 0x2978
5001025e:	000a                	c.slli	zero,0x2
50010260:	5746                	lw	a4,112(sp)
50010262:	203a                	.insn	2, 0x203a
50010264:	614d                	add	sp,sp,176
50010266:	6c69                	lui	s8,0x1a
50010268:	6f62                	.insn	2, 0x6f62
5001026a:	2078                	.insn	2, 0x2078
5001026c:	6e69                	lui	t3,0x1a
5001026e:	6520                	.insn	2, 0x6520
50010270:	7078                	.insn	2, 0x7078
50010272:	6365                	lui	t1,0x19
50010274:	6574                	.insn	2, 0x6574
50010276:	2064                	.insn	2, 0x2064
50010278:	74617473          	csrrc	s0,0x746,2
5001027c:	2c65                	jal	50010534 <k+0x1b4>
5001027e:	4d20                	lw	s0,88(a0)
50010280:	4f42                	lw	t5,16(sp)
50010282:	5f58                	lw	a4,60(a4)
50010284:	5845                	li	a6,-15
50010286:	4345                	li	t1,17
50010288:	5455                	li	s0,-11
5001028a:	5f45                	li	t5,-15
5001028c:	2c434f53          	.insn	4, 0x2c434f53
50010290:	6520                	.insn	2, 0x6520
50010292:	646e                	.insn	2, 0x646e
50010294:	6e69                	lui	t3,0x1a
50010296:	65742067          	.insn	4, 0x65742067
5001029a:	77207473          	csrrc	s0,0x772,0
5001029e:	7469                	lui	s0,0xffffa
500102a0:	2068                	.insn	2, 0x2068
500102a2:	63637573          	csrrc	a0,0x636,6
500102a6:	7365                	lui	t1,0xffff9
500102a8:	00000073          	ecall
500102ac:	202d                	jal	500102d6 <tbs_len+0x15a>
500102ae:	3128                	.insn	2, 0x3128
500102b0:	2029342f          	.insn	4, 0x2029342f
500102b4:	207c                	.insn	2, 0x207c
500102b6:	6f74                	.insn	2, 0x6f74
500102b8:	6174                	.insn	2, 0x6174
500102ba:	5f6c                	lw	a1,124(a4)
500102bc:	656c                	.insn	2, 0x656c
500102be:	3a6e                	.insn	2, 0x3a6e
500102c0:	2520                	.insn	2, 0x2520
500102c2:	2c64                	.insn	2, 0x2c64
500102c4:	6d20                	.insn	2, 0x6d20
500102c6:	7365                	lui	t1,0xffff9
500102c8:	65676173          	csrrs	sp,hviprio1h,14
500102cc:	6c5f 6e65 203a      	.insn	6, 0x203a6e656c5f
500102d2:	6425                	lui	s0,0x9
500102d4:	202c                	.insn	2, 0x202c
500102d6:	6170                	.insn	2, 0x6170
500102d8:	6464                	.insn	2, 0x6464
500102da:	6e69                	lui	t3,0x1a
500102dc:	656c5f67          	.insn	4, 0x656c5f67
500102e0:	3a6e                	.insn	2, 0x3a6e
500102e2:	2520                	.insn	2, 0x2520
500102e4:	2c64                	.insn	2, 0x2c64
500102e6:	6620                	.insn	2, 0x6620
500102e8:	6e69                	lui	t3,0x1a
500102ea:	6c61                	lui	s8,0x18
500102ec:	625f 6f6c 6b63      	.insn	6, 0x6b636f6c625f
500102f2:	6c5f 6e65 203a      	.insn	6, 0x203a6e656c5f
500102f8:	6425                	lui	s0,0x9
500102fa:	0a20                	add	s0,sp,280
500102fc:	0000                	unimp
500102fe:	0000                	unimp
50010300:	202d                	jal	5001032a <tbs_len+0x1ae>
50010302:	3228                	.insn	2, 0x3228
50010304:	2029342f          	.insn	4, 0x2029342f
50010308:	207c                	.insn	2, 0x207c
5001030a:	33616873          	csrrs	a6,mhpmevent22,2
5001030e:	3438                	.insn	2, 0x3438
50010310:	635f 726f 2865      	.insn	6, 0x2865726f635f
50010316:	2029                	jal	50010320 <tbs_len+0x1a4>
50010318:	6e69                	lui	t3,0x1a
5001031a:	7469                	lui	s0,0xffffa
5001031c:	6169                	add	sp,sp,208
5001031e:	206c                	.insn	2, 0x206c
50010320:	6964                	.insn	2, 0x6964
50010322:	74736567          	.insn	4, 0x74736567
50010326:	6420                	.insn	2, 0x6420
50010328:	2e656e6f          	jal	t3,5006660e <_tbs_der_store_end+0x475ee>
5001032c:	0000                	unimp
5001032e:	0000                	unimp
50010330:	202d                	jal	5001035a <tbs_len+0x1de>
50010332:	3328                	.insn	2, 0x3328
50010334:	2029342f          	.insn	4, 0x2029342f
50010338:	207c                	.insn	2, 0x207c
5001033a:	33616873          	csrrs	a6,mhpmevent22,2
5001033e:	3438                	.insn	2, 0x3438
50010340:	7020                	.insn	2, 0x7020
50010342:	6461                	lui	s0,0x18
50010344:	6964                	.insn	2, 0x6964
50010346:	676e                	.insn	2, 0x676e
50010348:	6420                	.insn	2, 0x6420
5001034a:	2e656e6f          	jal	t3,50066630 <_tbs_der_store_end+0x47610>
5001034e:	0000                	unimp
50010350:	202d                	jal	5001037a <tbs_len+0x1fe>
50010352:	3428                	.insn	2, 0x3428
50010354:	2029342f          	.insn	4, 0x2029342f
50010358:	207c                	.insn	2, 0x207c
5001035a:	33616873          	csrrs	a6,mhpmevent22,2
5001035e:	3438                	.insn	2, 0x3438
50010360:	635f 726f 2865      	.insn	6, 0x2865726f635f
50010366:	2029                	jal	50010370 <tbs_len+0x1f4>
50010368:	6966                	.insn	2, 0x6966
5001036a:	616e                	.insn	2, 0x616e
5001036c:	206c                	.insn	2, 0x206c
5001036e:	6964                	.insn	2, 0x6964
50010370:	74736567          	.insn	4, 0x74736567
50010374:	6420                	.insn	2, 0x6420
50010376:	2e656e6f          	jal	t3,5006665c <_tbs_der_store_end+0x4763c>
5001037a:	0000                	unimp
5001037c:	0000                	unimp
	...

50010380 <k>:
50010380:	ae22                	.insn	2, 0xae22
50010382:	d728                	sw	a0,104(a4)
50010384:	2f98                	.insn	2, 0x2f98
50010386:	428a                	lw	t0,128(sp)
50010388:	65cd                	lui	a1,0x13
5001038a:	449123ef          	jal	t2,50022fd2 <_tbs_der_store_end+0x3fb2>
5001038e:	3b2f7137          	lui	sp,0x3b2f7
50010392:	ec4d                	bnez	s0,5001044c <k+0xcc>
50010394:	b5c0fbcf          	.insn	4, 0xb5c0fbcf
50010398:	dbbc                	sw	a5,112(a5)
5001039a:	8189                	srl	a1,a1,0x2
5001039c:	dba5                	beqz	a5,5001030c <tbs_len+0x190>
5001039e:	e9b5                	bnez	a1,50010412 <k+0x92>
500103a0:	b538                	.insn	2, 0xb538
500103a2:	f348                	.insn	2, 0xf348
500103a4:	3956c25b          	.insn	4, 0x3956c25b
500103a8:	d019                	beqz	s0,500102ae <tbs_len+0x132>
500103aa:	b605                	j	5000feca <_data_lma_end+0x5000bb06>
500103ac:	11f1                	add	gp,gp,-4
500103ae:	59f1                	li	s3,-4
500103b0:	af194f9b          	.insn	4, 0xaf194f9b
500103b4:	82a4                	.insn	2, 0x82a4
500103b6:	8118923f 5ed5da6d 	.insn	8, 0x5ed5da6d8118923f
500103be:	ab1c                	.insn	2, 0xab1c
500103c0:	0242                	sll	tp,tp,0x10
500103c2:	aa98a303          	lw	t1,-1367(a7)
500103c6:	6fbed807          	.insn	4, 0x6fbed807
500103ca:	4570                	lw	a2,76(a0)
500103cc:	5b01                	li	s6,-32
500103ce:	b28c1283          	lh	t0,-1240(s8) # 17b28 <_data_lma_end+0x13764>
500103d2:	4ee4                	lw	s1,92(a3)
500103d4:	85be                	mv	a1,a5
500103d6:	2431                	jal	500105e2 <k+0x262>
500103d8:	b4e2                	.insn	2, 0xb4e2
500103da:	7dc3d5ff          	.insn	4, 0x7dc3d5ff
500103de:	550c                	lw	a1,40(a0)
500103e0:	f27b896f          	jal	s2,4ffc9306 <_data_lma_end+0x4ffc4f42>
500103e4:	5d74                	lw	a3,124(a0)
500103e6:	72be                	.insn	2, 0x72be
500103e8:	96b1                	sra	a3,a3,0x2c
500103ea:	3b16                	.insn	2, 0x3b16
500103ec:	b1fe                	.insn	2, 0xb1fe
500103ee:	80de                	mv	ra,s7
500103f0:	1235                	add	tp,tp,-19 # ffffffed <_tbs_der_store_end+0xaffe0fcd>
500103f2:	06a725c7          	.insn	4, 0x06a725c7
500103f6:	9bdc                	.insn	2, 0x9bdc
500103f8:	2694                	.insn	2, 0x2694
500103fa:	cf69                	beqz	a4,500104d4 <k+0x154>
500103fc:	f174                	.insn	2, 0xf174
500103fe:	4ad2c19b          	.insn	4, 0x4ad2c19b
50010402:	9ef1                	.insn	2, 0x9ef1
50010404:	69c1                	lui	s3,0x10
50010406:	25e3e49b          	.insn	4, 0x25e3e49b
5001040a:	4786384f          	.insn	4, 0x4786384f
5001040e:	efbe                	.insn	2, 0xefbe
50010410:	d5b5                	beqz	a1,5001037c <tbs_len+0x200>
50010412:	8b8c                	.insn	2, 0x8b8c
50010414:	9dc6                	add	s11,s11,a7
50010416:	0fc1                	add	t6,t6,16
50010418:	9c65                	.insn	2, 0x9c65
5001041a:	77ac                	.insn	2, 0x77ac
5001041c:	a1cc                	.insn	2, 0xa1cc
5001041e:	240c                	.insn	2, 0x240c
50010420:	0275                	add	tp,tp,29 # 1d <_start+0x1d>
50010422:	2c6f592b          	.insn	4, 0x2c6f592b
50010426:	2de9                	jal	50010b00 <k+0x780>
50010428:	6ea6e483          	.insn	4, 0x6ea6e483
5001042c:	84aa                	mv	s1,a0
5001042e:	4a74                	lw	a3,84(a2)
50010430:	fbd4                	.insn	2, 0xfbd4
50010432:	bd41                	j	500102c2 <tbs_len+0x146>
50010434:	a9dc                	.insn	2, 0xa9dc
50010436:	5cb0                	lw	a2,120(s1)
50010438:	53b5                	li	t2,-19
5001043a:	8311                	srl	a4,a4,0x4
5001043c:	88da                	mv	a7,s6
5001043e:	76f9                	lui	a3,0xffffe
50010440:	ee66dfab          	.insn	4, 0xee66dfab
50010444:	5152                	lw	sp,52(sp)
50010446:	983e                	add	a6,a6,a5
50010448:	3210                	.insn	2, 0x3210
5001044a:	2db4                	.insn	2, 0x2db4
5001044c:	c66d                	beqz	a2,50010536 <k+0x1b6>
5001044e:	a831                	j	5001046a <k+0xea>
50010450:	98fb213f b00327c8 	.insn	8, 0xb00327c898fb213f
50010458:	0ee4                	add	s1,sp,860
5001045a:	7fc7beef          	jal	t4,5008bc56 <_tbs_der_store_end+0x6cc36>
5001045e:	bf59                	j	500103f4 <k+0x74>
50010460:	8fc2                	mv	t6,a6
50010462:	3da8                	.insn	2, 0x3da8
50010464:	c6e00bf3          	.insn	4, 0xc6e00bf3
50010468:	a725                	j	50010b90 <k+0x810>
5001046a:	930a                	add	t1,t1,sp
5001046c:	d5a79147          	.insn	4, 0xd5a79147
50010470:	e003826f          	jal	tp,4ff48a70 <_data_lma_end+0x4ff446ac>
50010474:	6351                	lui	t1,0x14
50010476:	06ca                	sll	a3,a3,0x12
50010478:	6e70                	.insn	2, 0x6e70
5001047a:	0a0e                	sll	s4,s4,0x3
5001047c:	14292967          	.insn	4, 0x14292967
50010480:	2ffc                	.insn	2, 0x2ffc
50010482:	46d2                	lw	a3,20(sp)
50010484:	0a85                	add	s5,s5,1 # 72760001 <_tbs_der_store_end+0x22740fe1>
50010486:	c92627b7          	lui	a5,0xc9262
5001048a:	5c26                	lw	s8,104(sp)
5001048c:	2138                	.insn	2, 0x2138
5001048e:	2aed2e1b          	.insn	4, 0x2aed2e1b
50010492:	5ac4                	lw	s1,52(a3)
50010494:	6dfc                	.insn	2, 0x6dfc
50010496:	4d2c                	lw	a1,88(a0)
50010498:	b3df 9d95 0d13      	.insn	6, 0x0d139d95b3df
5001049e:	5338                	lw	a4,96(a4)
500104a0:	63de                	.insn	2, 0x63de
500104a2:	73548baf          	.insn	4, 0x73548baf
500104a6:	650a                	.insn	2, 0x650a
500104a8:	b2a8                	.insn	2, 0xb2a8
500104aa:	0abb3c77          	.insn	4, 0x0abb3c77
500104ae:	766a                	.insn	2, 0x766a
500104b0:	aee6                	.insn	2, 0xaee6
500104b2:	47ed                	li	a5,27
500104b4:	c92e                	sw	a1,144(sp)
500104b6:	81c2                	mv	gp,a6
500104b8:	1482353b          	.insn	4, 0x1482353b
500104bc:	2c85                	jal	5001072c <k+0x3ac>
500104be:	9272                	add	tp,tp,t3
500104c0:	0364                	add	s1,sp,396
500104c2:	4cf1                	li	s9,28
500104c4:	e8a1                	bnez	s1,50010514 <k+0x194>
500104c6:	3001a2bf 664bbc42 	.insn	8, 0x664bbc423001a2bf
500104ce:	a81a                	.insn	2, 0xa81a
500104d0:	9791                	sra	a5,a5,0x24
500104d2:	d0f8                	sw	a4,100(s1)
500104d4:	8b70                	.insn	2, 0x8b70
500104d6:	be30c24b          	.insn	4, 0xbe30c24b
500104da:	0654                	add	a3,sp,772
500104dc:	c76c51a3          	.insn	4, 0xc76c51a3
500104e0:	5218                	lw	a4,32(a2)
500104e2:	e819d6ef          	jal	a3,4ffae362 <_data_lma_end+0x4ffa9f9e>
500104e6:	d192                	sw	tp,224(sp)
500104e8:	a910                	.insn	2, 0xa910
500104ea:	5565                	li	a0,-7
500104ec:	0624                	add	s1,sp,776
500104ee:	d699                	beqz	a3,500103fc <k+0x7c>
500104f0:	202a                	.insn	2, 0x202a
500104f2:	5771                	li	a4,-4
500104f4:	3585                	jal	50010354 <tbs_len+0x1d8>
500104f6:	f40e                	.insn	2, 0xf40e
500104f8:	d1b8                	sw	a4,96(a1)
500104fa:	a07032bb          	.insn	4, 0xa07032bb
500104fe:	106a                	c.slli	zero,0x3a
50010500:	d0c8                	sw	a0,36(s1)
50010502:	b8d2                	.insn	2, 0xb8d2
50010504:	c116                	sw	t0,128(sp)
50010506:	19a4                	add	s1,sp,248
50010508:	5141ab53          	.insn	4, 0x5141ab53
5001050c:	6c08                	.insn	2, 0x6c08
5001050e:	eb991e37          	lui	t3,0xeb991
50010512:	df8e                	sw	gp,252(sp)
50010514:	774c                	.insn	2, 0x774c
50010516:	2748                	.insn	2, 0x2748
50010518:	48a8                	lw	a0,80(s1)
5001051a:	bcb5e19b          	.insn	4, 0xbcb5e19b
5001051e:	34b0                	.insn	2, 0x34b0
50010520:	c5c95a63          	bge	s2,t3,5000f974 <_data_lma_end+0x5000b5b0>
50010524:	391c0cb3          	.insn	4, 0x391c0cb3
50010528:	e3418acb          	.insn	4, 0xe3418acb
5001052c:	aa4a                	.insn	2, 0xaa4a
5001052e:	4ed8                	lw	a4,28(a3)
50010530:	7763e373          	csrrs	t1,0x776,7
50010534:	5b9cca4f          	.insn	4, 0x5b9cca4f
50010538:	d6b2b8a3          	.insn	4, 0xd6b2b8a3
5001053c:	682e6ff3          	csrrs	t6,0x682,28
50010540:	b2fc                	.insn	2, 0xb2fc
50010542:	82ee5def          	jal	s11,4fff5570 <_data_lma_end+0x4fff11ac>
50010546:	2f60748f          	.insn	4, 0x2f60748f
5001054a:	636f4317          	auipc	t1,0x636f4
5001054e:	78a5                	lui	a7,0xfffe9
50010550:	ab72                	.insn	2, 0xab72
50010552:	a1f0                	.insn	2, 0xa1f0
50010554:	7814                	.insn	2, 0x7814
50010556:	84c8                	.insn	2, 0x84c8
50010558:	39ec                	.insn	2, 0x39ec
5001055a:	1a64                	add	s1,sp,316
5001055c:	0208                	add	a0,sp,256
5001055e:	1e288cc7          	.insn	4, 0x1e288cc7
50010562:	fffa2363          	.insn	4, 0xfffa2363
50010566:	90be                	add	ra,ra,a5
50010568:	bde9                	j	50010442 <k+0xc2>
5001056a:	de82                	sw	zero,124(sp)
5001056c:	a4506ceb          	.insn	4, 0xa4506ceb
50010570:	7915                	lui	s2,0xfffe5
50010572:	b2c6                	.insn	2, 0xb2c6
50010574:	bef9a3f7          	.insn	4, 0xbef9a3f7
50010578:	e372532b          	.insn	4, 0xe372532b
5001057c:	78f2                	.insn	2, 0x78f2
5001057e:	c671                	beqz	a2,5001064a <k+0x2ca>
50010580:	619c                	.insn	2, 0x619c
50010582:	ea26                	.insn	2, 0xea26
50010584:	3ece                	.insn	2, 0x3ece
50010586:	c207ca27          	.insn	4, 0xc207ca27
5001058a:	21c0                	.insn	2, 0x21c0
5001058c:	d186b8c7          	.insn	4, 0xd186b8c7
50010590:	eb1e                	.insn	2, 0xeb1e
50010592:	cde0                	sw	s0,92(a1)
50010594:	7dd6                	.insn	2, 0x7dd6
50010596:	eada                	.insn	2, 0xeada
50010598:	d178                	sw	a4,100(a0)
5001059a:	ee6e                	.insn	2, 0xee6e
5001059c:	f57d4f7f          	.insn	4, 0xf57d4f7f
500105a0:	6fba                	.insn	2, 0x6fba
500105a2:	67aa7217          	auipc	tp,0x67aa7
500105a6:	06f0                	add	a2,sp,844
500105a8:	98a6                	add	a7,a7,s1
500105aa:	a2c8                	.insn	2, 0xa2c8
500105ac:	7dc5                	lui	s11,0xffff1
500105ae:	0dae0a63          	beq	t3,s10,50010682 <k+0x302>
500105b2:	bef9                	j	50010190 <tbs_len+0x14>
500105b4:	9804                	.insn	2, 0x9804
500105b6:	471b113f 0b35131c 	.insn	8, 0x0b35131c471b113f
500105be:	1b71                	add	s6,s6,-4
500105c0:	7d84                	.insn	2, 0x7d84
500105c2:	2304                	.insn	2, 0x2304
500105c4:	77f5                	lui	a5,0xffffd
500105c6:	249328db          	.insn	4, 0x249328db
500105ca:	ab7b40c7          	.insn	4, 0xab7b40c7
500105ce:	32ca                	.insn	2, 0x32ca
500105d0:	bebc                	.insn	2, 0xbebc
500105d2:	15c9                	add	a1,a1,-14 # 12ff2 <_data_lma_end+0xec2e>
500105d4:	be0a                	.insn	2, 0xbe0a
500105d6:	3c9e                	.insn	2, 0x3c9e
500105d8:	0d4c                	add	a1,sp,660
500105da:	9c10                	.insn	2, 0x9c10
500105dc:	67c4                	.insn	2, 0x67c4
500105de:	431d                	li	t1,7
500105e0:	42b6                	lw	t0,76(sp)
500105e2:	cb3e                	sw	a5,148(sp)
500105e4:	d4be                	sw	a5,104(sp)
500105e6:	4cc5                	li	s9,17
500105e8:	7e2a                	.insn	2, 0x7e2a
500105ea:	fc65                	bnez	s0,500105e2 <k+0x262>
500105ec:	299c                	.insn	2, 0x299c
500105ee:	faec597f          	.insn	4, 0xfaec597f
500105f2:	3ad6                	.insn	2, 0x3ad6
500105f4:	5fcb6fab          	.insn	4, 0x5fcb6fab
500105f8:	4a475817          	auipc	a6,0x4a475
500105fc:	198c                	add	a1,sp,240
500105fe:	6c44                	.insn	2, 0x6c44
50010600:	5f434f53          	.insn	4, 0x5f434f53
50010604:	4649                	li	a2,18
50010606:	53203a43          	.insn	4, 0x53203a43
5001060a:	7465                	lui	s0,0xffff9
5001060c:	6620                	.insn	2, 0x6620
5001060e:	6f6c                	.insn	2, 0x6f6c
50010610:	74735f77          	.insn	4, 0x74735f77
50010614:	7461                	lui	s0,0xffff8
50010616:	7375                	lui	t1,0xffffd
50010618:	6620                	.insn	2, 0x6620
5001061a:	6569                	lui	a0,0x1a
5001061c:	646c                	.insn	2, 0x646c
5001061e:	203a                	.insn	2, 0x203a
50010620:	7830                	.insn	2, 0x7830
50010622:	3025                	jal	5000fe4a <_data_lma_end+0x5000ba86>
50010624:	7838                	.insn	2, 0x7838
50010626:	000a                	c.slli	zero,0x2
50010628:	0a30                	add	a2,sp,280
5001062a:	0806                	sll	a6,a6,0x1
5001062c:	862a                	mv	a2,a0
5001062e:	ce48                	sw	a0,28(a2)
50010630:	043d                	add	s0,s0,15 # ffff800f <_tbs_der_store_end+0xaffd8fef>
50010632:	00000303          	lb	t1,0(zero) # 0 <_start>
50010636:	0000                	unimp
50010638:	2230                	.insn	2, 0x2230
5001063a:	0f18                	add	a4,sp,912
5001063c:	3032                	.insn	2, 0x3032
5001063e:	3632                	.insn	2, 0x3632
50010640:	3130                	.insn	2, 0x3130
50010642:	3130                	.insn	2, 0x3130
50010644:	3030                	.insn	2, 0x3030
50010646:	3030                	.insn	2, 0x3030
50010648:	3030                	.insn	2, 0x3030
5001064a:	185a                	sll	a6,a6,0x36
5001064c:	3230320f          	.insn	4, 0x3230320f
50010650:	3038                	.insn	2, 0x3038
50010652:	3031                	jal	5000fe5e <_data_lma_end+0x5000ba9a>
50010654:	3031                	jal	5000fe60 <_data_lma_end+0x5000ba9c>
50010656:	3030                	.insn	2, 0x3030
50010658:	3030                	.insn	2, 0x3030
5001065a:	5a30                	lw	a2,112(a2)
5001065c:	0000                	unimp
5001065e:	0000                	unimp
50010660:	862a                	mv	a2,a0
50010662:	ce48                	sw	a0,28(a2)
50010664:	023d                	add	tp,tp,15 # b7ab75b1 <_tbs_der_store_end+0x67a98591>
50010666:	0001                	nop
50010668:	3a45                	jal	50010018 <curve_n+0x18>
5001066a:	6f20                	.insn	2, 0x6f20
5001066c:	7475                	lui	s0,0xffffd
5001066e:	7265                	lui	tp,0xffff9
50010670:	7420                	.insn	2, 0x7420
50010672:	6761                	lui	a4,0x18
50010674:	0000                	unimp
50010676:	0000                	unimp
50010678:	3a45                	jal	50010028 <curve_n+0x28>
5001067a:	7420                	.insn	2, 0x7420
5001067c:	7362                	.insn	2, 0x7362
5001067e:	7420                	.insn	2, 0x7420
50010680:	6761                	lui	a4,0x18
50010682:	0000                	unimp
50010684:	5245                	li	tp,-15
50010686:	4f52                	lw	t5,20(sp)
50010688:	3a52                	.insn	2, 0x3a52
5001068a:	4220                	lw	s0,64(a2)
5001068c:	5449                	li	s0,-14
5001068e:	5320                	lw	s0,96(a4)
50010690:	5254                	lw	a3,36(a2)
50010692:	4e49                	li	t3,18
50010694:	61742047          	.insn	4, 0x61742047
50010698:	696d2067          	.insn	4, 0x696d2067
5001069c:	6e697373          	csrrc	t1,0x6e6,18
500106a0:	00000067          	jr	zero # 0 <_start>
500106a4:	5245                	li	tp,-15
500106a6:	4f52                	lw	t5,20(sp)
500106a8:	3a52                	.insn	2, 0x3a52
500106aa:	4220                	lw	s0,64(a2)
500106ac:	5449                	li	s0,-14
500106ae:	5320                	lw	s0,96(a4)
500106b0:	5254                	lw	a3,36(a2)
500106b2:	4e49                	li	t3,18
500106b4:	656c2047          	.insn	4, 0x656c2047
500106b8:	206e                	.insn	2, 0x206e
500106ba:	696d                	lui	s2,0x1b
500106bc:	6e697373          	csrrc	t1,0x6e6,18
500106c0:	00000067          	jr	zero # 0 <_start>
500106c4:	5245                	li	tp,-15
500106c6:	4f52                	lw	t5,20(sp)
500106c8:	3a52                	.insn	2, 0x3a52
500106ca:	4220                	lw	s0,64(a2)
500106cc:	5449                	li	s0,-14
500106ce:	5320                	lw	s0,96(a4)
500106d0:	5254                	lw	a3,36(a2)
500106d2:	4e49                	li	t3,18
500106d4:	6f6c2047          	.insn	4, 0x6f6c2047
500106d8:	676e                	.insn	2, 0x676e
500106da:	6c20                	.insn	2, 0x6c20
500106dc:	6e65                	lui	t3,0x19
500106de:	0000                	unimp
500106e0:	5245                	li	tp,-15
500106e2:	4f52                	lw	t5,20(sp)
500106e4:	3a52                	.insn	2, 0x3a52
500106e6:	4220                	lw	s0,64(a2)
500106e8:	5449                	li	s0,-14
500106ea:	5320                	lw	s0,96(a4)
500106ec:	5254                	lw	a3,36(a2)
500106ee:	4e49                	li	t3,18
500106f0:	656c2047          	.insn	4, 0x656c2047
500106f4:	206e                	.insn	2, 0x206e
500106f6:	6f74                	.insn	2, 0x6f74
500106f8:	6f6c206f          	j	500d2dee <_tbs_der_store_end+0xb3dce>
500106fc:	676e                	.insn	2, 0x676e
500106fe:	0000                	unimp
50010700:	4942                	lw	s2,16(sp)
50010702:	2054                	.insn	2, 0x2054
50010704:	49525453          	.insn	4, 0x49525453
50010708:	474e                	lw	a4,208(sp)
5001070a:	6c20                	.insn	2, 0x6c20
5001070c:	6e65                	lui	t3,0x19
5001070e:	20687467          	.insn	4, 0x20687467
50010712:	203d                	jal	50010740 <k+0x3c0>
50010714:	7830                	.insn	2, 0x7830
50010716:	7825                	lui	a6,0xfffe9
50010718:	000a                	c.slli	zero,0x2
5001071a:	0000                	unimp
5001071c:	5245                	li	tp,-15
5001071e:	4f52                	lw	t5,20(sp)
50010720:	3a52                	.insn	2, 0x3a52
50010722:	4220                	lw	s0,64(a2)
50010724:	5449                	li	s0,-14
50010726:	5320                	lw	s0,96(a4)
50010728:	5254                	lw	a3,36(a2)
5001072a:	4e49                	li	t3,18
5001072c:	6e752047          	.insn	4, 0x6e752047
50010730:	7375                	lui	t1,0xffffd
50010732:	6465                	lui	s0,0x19
50010734:	6220                	.insn	2, 0x6220
50010736:	7469                	lui	s0,0xffffa
50010738:	6f6e2073          	csrs	0x6f6,t3
5001073c:	2074                	.insn	2, 0x2074
5001073e:	0030                	add	a2,sp,8
50010740:	5245                	li	tp,-15
50010742:	4f52                	lw	t5,20(sp)
50010744:	3a52                	.insn	2, 0x3a52
50010746:	4220                	lw	s0,64(a2)
50010748:	5449                	li	s0,-14
5001074a:	5320                	lw	s0,96(a4)
5001074c:	5254                	lw	a3,36(a2)
5001074e:	4e49                	li	t3,18
50010750:	6f632047          	.insn	4, 0x6f632047
50010754:	746e                	.insn	2, 0x746e
50010756:	6e65                	lui	t3,0x19
50010758:	2074                	.insn	2, 0x2074
5001075a:	7265766f          	jal	a2,50067e80 <_tbs_der_store_end+0x48e60>
5001075e:	6c66                	.insn	2, 0x6c66
50010760:	0000776f          	jal	a4,50017760 <STACK+0xac0>
50010764:	3a45                	jal	50010114 <trap_msg+0x24>
50010766:	6920                	.insn	2, 0x6920
50010768:	6e6e                	.insn	2, 0x6e6e
5001076a:	7265                	lui	tp,0xffff9
5001076c:	5320                	lw	s0,96(a4)
5001076e:	5145                	li	sp,-15
50010770:	4555                	li	a0,21
50010772:	434e                	lw	t1,208(sp)
50010774:	0045                	c.nop	17
50010776:	0000                	unimp
50010778:	3a45                	jal	50010128 <trap_msg+0x38>
5001077a:	5320                	lw	s0,96(a4)
5001077c:	5145                	li	sp,-15
5001077e:	4555                	li	a0,21
50010780:	434e                	lw	t1,208(sp)
50010782:	2045                	jal	50010822 <k+0x4a2>
50010784:	656c                	.insn	2, 0x656c
50010786:	006e                	c.slli	zero,0x1b
50010788:	3a45                	jal	50010138 <trap_msg+0x48>
5001078a:	5320                	lw	s0,96(a4)
5001078c:	5145                	li	sp,-15
5001078e:	4555                	li	a0,21
50010790:	434e                	lw	t1,208(sp)
50010792:	2045                	jal	50010832 <k+0x4b2>
50010794:	6f6c                	.insn	2, 0x6f6c
50010796:	676e                	.insn	2, 0x676e
50010798:	6c20                	.insn	2, 0x6c20
5001079a:	6e65                	lui	t3,0x19
5001079c:	0000                	unimp
5001079e:	0000                	unimp
500107a0:	3a45                	jal	50010150 <trap_msg+0x60>
500107a2:	5320                	lw	s0,96(a4)
500107a4:	5145                	li	sp,-15
500107a6:	4555                	li	a0,21
500107a8:	434e                	lw	t1,208(sp)
500107aa:	2045                	jal	5001084a <k+0x4ca>
500107ac:	7265766f          	jal	a2,50067ed2 <_tbs_der_store_end+0x48eb2>
500107b0:	6c66                	.insn	2, 0x6c66
500107b2:	0000776f          	jal	a4,500177b2 <STACK+0xb12>
500107b6:	0000                	unimp
500107b8:	3a45                	jal	50010168 <trap_msg+0x78>
500107ba:	7220                	.insn	2, 0x7220
500107bc:	7420                	.insn	2, 0x7420
500107be:	6761                	lui	a4,0x18
500107c0:	0000                	unimp
500107c2:	0000                	unimp
500107c4:	3a45                	jal	50010174 <bare_rng_seed+0x4>
500107c6:	7220                	.insn	2, 0x7220
500107c8:	6c20                	.insn	2, 0x6c20
500107ca:	6e65                	lui	t3,0x19
500107cc:	0000                	unimp
500107ce:	0000                	unimp
500107d0:	3a45                	jal	50010180 <tbs_len+0x4>
500107d2:	7220                	.insn	2, 0x7220
500107d4:	6c20                	.insn	2, 0x6c20
500107d6:	6e65                	lui	t3,0x19
500107d8:	6920                	.insn	2, 0x6920
500107da:	766e                	.insn	2, 0x766e
500107dc:	6c61                	lui	s8,0x18
500107de:	6469                	lui	s0,0x1a
500107e0:	0000                	unimp
500107e2:	0000                	unimp
500107e4:	3a45                	jal	50010194 <tbs_len+0x18>
500107e6:	7320                	.insn	2, 0x7320
500107e8:	7420                	.insn	2, 0x7420
500107ea:	6761                	lui	a4,0x18
500107ec:	0000                	unimp
500107ee:	0000                	unimp
500107f0:	3a45                	jal	500101a0 <tbs_len+0x24>
500107f2:	7320                	.insn	2, 0x7320
500107f4:	6c20                	.insn	2, 0x6c20
500107f6:	6e65                	lui	t3,0x19
500107f8:	0000                	unimp
500107fa:	0000                	unimp
500107fc:	3a45                	jal	500101ac <tbs_len+0x30>
500107fe:	7320                	.insn	2, 0x7320
50010800:	6c20                	.insn	2, 0x6c20
50010802:	6e65                	lui	t3,0x19
50010804:	6920                	.insn	2, 0x6920
50010806:	766e                	.insn	2, 0x766e
50010808:	6c61                	lui	s8,0x18
5001080a:	6469                	lui	s0,0x1a
5001080c:	0000                	unimp
5001080e:	0000                	unimp
50010810:	7845                	lui	a6,0xffff1
50010812:	7274                	.insn	2, 0x7274
50010814:	6361                	lui	t1,0x18
50010816:	6574                	.insn	2, 0x6574
50010818:	2064                	.insn	2, 0x2064
5001081a:	6e676973          	csrrs	s2,0x6e6,14
5001081e:	7461                	lui	s0,0xffff8
50010820:	7275                	lui	tp,0xffffd
50010822:	3a65                	jal	500101da <tbs_len+0x5e>
50010824:	0000                	unimp
50010826:	0000                	unimp
50010828:	3025                	jal	50010050 <curve_G+0x20>
5001082a:	7832                	.insn	2, 0x7832
5001082c:	0000                	unimp
5001082e:	0000                	unimp
50010830:	5245                	li	tp,-15
50010832:	4f52                	lw	t5,20(sp)
50010834:	3a52                	.insn	2, 0x3a52
50010836:	7320                	.insn	2, 0x7320
50010838:	6769                	lui	a4,0x1a
5001083a:	616e                	.insn	2, 0x616e
5001083c:	7574                	.insn	2, 0x7574
5001083e:	6572                	.insn	2, 0x6572
50010840:	6120                	.insn	2, 0x6120
50010842:	676c                	.insn	2, 0x676c
50010844:	7469726f          	jal	tp,500a7f8a <_tbs_der_store_end+0x88f6a>
50010848:	6d68                	.insn	2, 0x6d68
5001084a:	4f20                	lw	s0,88(a4)
5001084c:	4449                	li	s0,18
5001084e:	6e20                	.insn	2, 0x6e20
50010850:	6620746f          	jal	s0,50017eb2 <STACK+0x1212>
50010854:	646e756f          	jal	a0,500f7e9a <_tbs_der_store_end+0xd8e7a>
50010858:	0021                	c.nop	8
5001085a:	0000                	unimp
5001085c:	6f46                	.insn	2, 0x6f46
5001085e:	6e75                	lui	t3,0x1d
50010860:	2064                	.insn	2, 0x2064
50010862:	20676973          	csrrs	s2,0x206,14
50010866:	6c61                	lui	s8,0x18
50010868:	74612067          	.insn	4, 0x74612067
5001086c:	6f20                	.insn	2, 0x6f20
5001086e:	6666                	.insn	2, 0x6666
50010870:	20746573          	csrrs	a0,0x207,8
50010874:	6c25                	lui	s8,0x9
50010876:	0a64                	add	s1,sp,284
	...
50010884:	0030                	add	a2,sp,8
50010886:	0000                	unimp
50010888:	7570                	.insn	2, 0x7570
5001088a:	6b62                	.insn	2, 0x6b62
5001088c:	7965                	lui	s2,0xffff9
5001088e:	785f 003a 0000      	.insn	6, 0x003a785f
50010894:	7830                	.insn	2, 0x7830
50010896:	3025                	jal	500100be <curve_b+0x2e>
50010898:	7838                	.insn	2, 0x7838
5001089a:	0020                	add	s0,sp,8
5001089c:	7570                	.insn	2, 0x7570
5001089e:	6b62                	.insn	2, 0x6b62
500108a0:	7965                	lui	s2,0xffff9
500108a2:	795f 003a 0000      	.insn	6, 0x003a795f
500108a8:	324c                	.insn	2, 0x324c
500108aa:	545f 7572 7473      	.insn	6, 0x74737572545f
500108b0:	525f 6f6f 0074      	.insn	6, 0x00746f6f525f
500108b6:	0000                	unimp
500108b8:	74726563          	bltu	tp,t2,50011002 <cert_der+0x386>
500108bc:	6c5f 6e65 3d20      	.insn	6, 0x3d206e656c5f
500108c2:	3020                	.insn	2, 0x3020
500108c4:	2578                	.insn	2, 0x2578
500108c6:	0a78                	add	a4,sp,284
500108c8:	0000                	unimp
500108ca:	0000                	unimp
500108cc:	6e32                	.insn	2, 0x6e32
500108ce:	2064                	.insn	2, 0x2064
500108d0:	6274                	.insn	2, 0x6274
500108d2:	65642073          	csrs	hviprio1h,s0
500108d6:	3a72                	.insn	2, 0x3a72
500108d8:	0000                	unimp
500108da:	0000                	unimp
500108dc:	7325                	lui	t1,0xfffe9
500108de:	5825                	li	a6,-23
500108e0:	0000                	unimp
500108e2:	0000                	unimp
500108e4:	656e6567          	.insn	4, 0x656e6567
500108e8:	6172                	.insn	2, 0x6172
500108ea:	6574                	.insn	2, 0x6574
500108ec:	3220                	.insn	2, 0x3220
500108ee:	646e                	.insn	2, 0x646e
500108f0:	6320                	.insn	2, 0x6320
500108f2:	7265                	lui	tp,0xffff9
500108f4:	2074                	.insn	2, 0x2074
500108f6:	6564                	.insn	2, 0x6564
500108f8:	2072                	.insn	2, 0x2072
500108fa:	6166                	.insn	2, 0x6166
500108fc:	6c69                	lui	s8,0x1a
500108fe:	2164                	.insn	2, 0x2164
50010900:	0000                	unimp
50010902:	0000                	unimp
50010904:	6365                	lui	t1,0x19
50010906:	616d5f63          	bge	s10,s6,50010f24 <cert_der+0x2a8>
5001090a:	6b5f656b          	.insn	4, 0x6b5f656b
5001090e:	7965                	lui	s2,0xffff9
50010910:	6620                	.insn	2, 0x6620
50010912:	6961                	lui	s2,0x18
50010914:	656c                	.insn	2, 0x656c
50010916:	2164                	.insn	2, 0x2164
50010918:	0000                	unimp
5001091a:	0000                	unimp
5001091c:	6964                	.insn	2, 0x6964
5001091e:	74736567          	.insn	4, 0x74736567
50010922:	003a                	c.slli	zero,0xe
50010924:	4345                	li	t1,17
50010926:	5344                	lw	s1,36(a4)
50010928:	2d41                	jal	50010fb8 <cert_der+0x33c>
5001092a:	3350                	.insn	2, 0x3350
5001092c:	3438                	.insn	2, 0x3438
5001092e:	7320                	.insn	2, 0x7320
50010930:	6769                	lui	a4,0x1a
50010932:	206e                	.insn	2, 0x206e
50010934:	6166                	.insn	2, 0x6166
50010936:	6c69                	lui	s8,0x1a
50010938:	6465                	lui	s0,0x19
5001093a:	2021                	jal	50010942 <k+0x5c2>
5001093c:	6572                	.insn	2, 0x6572
5001093e:	2074                	.insn	2, 0x2074
50010940:	203d                	jal	5001096e <k+0x5ee>
50010942:	6425                	lui	s0,0x9
50010944:	000a                	c.slli	zero,0x2
50010946:	0000                	unimp
50010948:	6e676973          	csrrs	s2,0x6e6,14
5001094c:	7461                	lui	s0,0xffff8
5001094e:	7275                	lui	tp,0xffffd
50010950:	3a65                	jal	50010308 <tbs_len+0x18c>
50010952:	0000                	unimp
50010954:	5f676973          	csrrs	s2,sattri3_base,14
50010958:	5f72                	lw	t5,60(sp)
5001095a:	64726f77          	.insn	4, 0x64726f77
5001095e:	00003a73          	csrrc	s4,ustatus,zero
50010962:	0000                	unimp
50010964:	5f676973          	csrrs	s2,sattri3_base,14
50010968:	6f775f73          	csrrw	t5,0x6f7,14
5001096c:	6472                	.insn	2, 0x6472
5001096e:	00003a73          	csrrc	s4,ustatus,zero
50010972:	0000                	unimp
50010974:	4345                	li	t1,17
50010976:	5344                	lw	s1,36(a4)
50010978:	2d41                	jal	50011008 <cert_der+0x38c>
5001097a:	3350                	.insn	2, 0x3350
5001097c:	3438                	.insn	2, 0x3438
5001097e:	7620                	.insn	2, 0x7620
50010980:	7265                	lui	tp,0xffff9
50010982:	6669                	lui	a2,0x1a
50010984:	2079                	jal	50010a12 <k+0x692>
50010986:	6166                	.insn	2, 0x6166
50010988:	6c69                	lui	s8,0x1a
5001098a:	6465                	lui	s0,0x19
5001098c:	2021                	jal	50010994 <k+0x614>
5001098e:	6572                	.insn	2, 0x6572
50010990:	3d74                	.insn	2, 0x3d74
50010992:	6425                	lui	s0,0x9
50010994:	000a                	c.slli	zero,0x2
50010996:	0000                	unimp
50010998:	4345                	li	t1,17
5001099a:	5344                	lw	s1,36(a4)
5001099c:	2d41                	jal	5001102c <cert_der+0x3b0>
5001099e:	3350                	.insn	2, 0x3350
500109a0:	3438                	.insn	2, 0x3438
500109a2:	7620                	.insn	2, 0x7620
500109a4:	7265                	lui	tp,0xffff9
500109a6:	6669                	lui	a2,0x1a
500109a8:	2079                	jal	50010a36 <k+0x6b6>
500109aa:	63637573          	csrrc	a0,0x636,6
500109ae:	7365                	lui	t1,0xffff9
500109b0:	00002173          	csrr	sp,ustatus
500109b4:	2d2d                	jal	50010fee <cert_der+0x372>
500109b6:	2d2d                	jal	50010ff0 <cert_der+0x374>
500109b8:	2d2d                	jal	50010ff2 <cert_der+0x376>
500109ba:	2d2d                	jal	50010ff4 <cert_der+0x378>
500109bc:	2d2d                	jal	50010ff6 <cert_der+0x37a>
500109be:	2d2d                	jal	50010ff8 <cert_der+0x37c>
500109c0:	2d2d                	jal	50010ffa <cert_der+0x37e>
500109c2:	2d2d                	jal	50010ffc <cert_der+0x380>
500109c4:	2d2d                	jal	50010ffe <cert_der+0x382>
500109c6:	2d2d                	jal	50011000 <cert_der+0x384>
500109c8:	2d2d                	jal	50011002 <cert_der+0x386>
500109ca:	2d2d                	jal	50011004 <cert_der+0x388>
500109cc:	2d2d                	jal	50011006 <cert_der+0x38a>
500109ce:	2d2d                	jal	50011008 <cert_der+0x38c>
500109d0:	2d2d                	jal	5001100a <cert_der+0x38e>
500109d2:	2d2d                	jal	5001100c <cert_der+0x390>
500109d4:	2d2d                	jal	5001100e <cert_der+0x392>
500109d6:	2d2d                	jal	50011010 <cert_der+0x394>
500109d8:	0000                	unimp
500109da:	0000                	unimp
500109dc:	2020                	.insn	2, 0x2020
500109de:	2020                	.insn	2, 0x2020
500109e0:	2020                	.insn	2, 0x2020
500109e2:	2020                	.insn	2, 0x2020
500109e4:	2020                	.insn	2, 0x2020
500109e6:	2020                	.insn	2, 0x2020
500109e8:	696c6143          	.insn	4, 0x696c6143
500109ec:	7470                	.insn	2, 0x7470
500109ee:	6172                	.insn	2, 0x6172
500109f0:	5220                	lw	s0,96(a2)
500109f2:	2e2e4d4f          	.insn	4, 0x2e2e4d4f
500109f6:	202e                	.insn	2, 0x202e
500109f8:	2020                	.insn	2, 0x2020
500109fa:	2020                	.insn	2, 0x2020
500109fc:	2020                	.insn	2, 0x2020
500109fe:	2020                	.insn	2, 0x2020
50010a00:	0000                	unimp
50010a02:	0000                	unimp
50010a04:	3131                	jal	50010610 <k+0x290>
50010a06:	343a                	.insn	2, 0x343a
50010a08:	35313a37          	lui	s4,0x35313
50010a0c:	0000                	unimp
50010a0e:	0000                	unimp
50010a10:	754a                	.insn	2, 0x754a
50010a12:	206c                	.insn	2, 0x206c
50010a14:	3731                	jal	50010920 <k+0x5a0>
50010a16:	3220                	.insn	2, 0x3220
50010a18:	3230                	.insn	2, 0x3230
50010a1a:	0036                	c.slli	zero,0xd
50010a1c:	706d6f43          	.insn	4, 0x706d6f43
50010a20:	6c69                	lui	s8,0x1a
50010a22:	6465                	lui	s0,0x19
50010a24:	6f20                	.insn	2, 0x6f20
50010a26:	3a6e                	.insn	2, 0x3a6e
50010a28:	2520                	.insn	2, 0x2520
50010a2a:	74612073          	csrs	0x746,sp
50010a2e:	2520                	.insn	2, 0x2520
50010a30:	00000a73          	.insn	4, 0x0a73
50010a34:	6552                	.insn	2, 0x6552
50010a36:	76696563          	bltu	s2,t1,500111a0 <cert_der+0x524>
50010a3a:	6465                	lui	s0,0x19
50010a3c:	6d20                	.insn	2, 0x6d20
50010a3e:	6961                	lui	s2,0x18
50010a40:	626c                	.insn	2, 0x626c
50010a42:	6320786f          	jal	a6,50018074 <STACK+0x13d4>
50010a46:	616d6d6f          	jal	s10,500e705c <_tbs_der_store_end+0xc803c>
50010a4a:	646e                	.insn	2, 0x646e
50010a4c:	2820                	.insn	2, 0x2820
50010a4e:	7865                	lui	a6,0xffff9
50010a50:	6570                	.insn	2, 0x6570
50010a52:	6e697463          	bgeu	s2,t1,5001113a <cert_der+0x4be>
50010a56:	45522067          	.insn	4, 0x45522067
50010a5a:	20295053          	.insn	4, 0x20295053
50010a5e:	7266                	.insn	2, 0x7266
50010a60:	53206d6f          	jal	s10,50016f92 <STACK+0x2f2>
50010a64:	2021434f          	.insn	4, 0x2021434f
50010a68:	20746f47          	.insn	4, 0x20746f47
50010a6c:	7830                	.insn	2, 0x7830
50010a6e:	7825                	lui	a6,0xfffe9
50010a70:	000a                	c.slli	zero,0x2
50010a72:	0000                	unimp
50010a74:	20746547          	.insn	4, 0x20746547
50010a78:	6172                	.insn	2, 0x6172
50010a7a:	646e                	.insn	2, 0x646e
50010a7c:	3a736d6f          	jal	s10,50047622 <_tbs_der_store_end+0x28602>
50010a80:	0000                	unimp
50010a82:	0000                	unimp
50010a84:	3025                	jal	500102ac <tbs_len+0x130>
50010a86:	7832                	.insn	2, 0x7832
50010a88:	0020                	add	s0,sp,8
50010a8a:	0000                	unimp
50010a8c:	6e49                	lui	t3,0x12
50010a8e:	6176                	.insn	2, 0x6176
50010a90:	696c                	.insn	2, 0x696c
50010a92:	2064                	.insn	2, 0x2064
50010a94:	74726563          	bltu	tp,t2,500111de <cert_der+0x562>
50010a98:	6c20                	.insn	2, 0x6c20
50010a9a:	6e65                	lui	t3,0x19
50010a9c:	00687467          	.insn	4, 0x00687467
50010aa0:	7331                	lui	t1,0xfffec
50010aa2:	2074                	.insn	2, 0x2074
50010aa4:	6274                	.insn	2, 0x6274
50010aa6:	62742873          	csrrs	a6,0x627,s0
50010aaa:	656c5f73          	csrrw	t5,hviprio1h,24
50010aae:	206e                	.insn	2, 0x206e
50010ab0:	203d                	jal	50010ade <k+0x75e>
50010ab2:	7830                	.insn	2, 0x7830
50010ab4:	7825                	lui	a6,0xfffe9
50010ab6:	3a29                	jal	500103d0 <k+0x50>
50010ab8:	000a                	c.slli	zero,0x2
50010aba:	0000                	unimp
50010abc:	7331                	lui	t1,0xfffec
50010abe:	2074                	.insn	2, 0x2074
50010ac0:	74726563          	bltu	tp,t2,5001120a <cert_der+0x58e>
50010ac4:	6328                	.insn	2, 0x6328
50010ac6:	7265                	lui	tp,0xffff9
50010ac8:	5f74                	lw	a3,124(a4)
50010aca:	656c                	.insn	2, 0x656c
50010acc:	206e                	.insn	2, 0x206e
50010ace:	203d                	jal	50010afc <k+0x77c>
50010ad0:	7830                	.insn	2, 0x7830
50010ad2:	7825                	lui	a6,0xfffe9
50010ad4:	3a29                	jal	500103ee <k+0x6e>
50010ad6:	000a                	c.slli	zero,0x2
50010ad8:	7331                	lui	t1,0xfffec
50010ada:	2074                	.insn	2, 0x2074
50010adc:	74726563          	bltu	tp,t2,50011226 <cert_der+0x5aa>
50010ae0:	7620                	.insn	2, 0x7620
50010ae2:	7265                	lui	tp,0xffff9
50010ae4:	6669                	lui	a2,0x1a
50010ae6:	2079                	jal	50010b74 <k+0x7f4>
50010ae8:	63637573          	csrrc	a0,0x636,6
50010aec:	7365                	lui	t1,0xffff9
50010aee:	73310073          	.insn	4, 0x73310073
50010af2:	2074                	.insn	2, 0x2074
50010af4:	74726563          	bltu	tp,t2,5001123e <cert_der+0x5c2>
50010af8:	7620                	.insn	2, 0x7620
50010afa:	7265                	lui	tp,0xffff9
50010afc:	6669                	lui	a2,0x1a
50010afe:	2079                	jal	50010b8c <k+0x80c>
50010b00:	6166                	.insn	2, 0x6166
50010b02:	6c69                	lui	s8,0x1a
50010b04:	6465                	lui	s0,0x19
50010b06:	202c                	.insn	2, 0x202c
50010b08:	6572                	.insn	2, 0x6572
50010b0a:	2074                	.insn	2, 0x2074
50010b0c:	203d                	jal	50010b3a <k+0x7ba>
50010b0e:	6425                	lui	s0,0x9
50010b10:	000a                	c.slli	zero,0x2
50010b12:	0000                	unimp
50010b14:	6e32                	.insn	2, 0x6e32
50010b16:	2064                	.insn	2, 0x2064
50010b18:	74726563          	bltu	tp,t2,50011262 <cert_der+0x5e6>
50010b1c:	6328                	.insn	2, 0x6328
50010b1e:	7265                	lui	tp,0xffff9
50010b20:	5f74                	lw	a3,124(a4)
50010b22:	656c                	.insn	2, 0x656c
50010b24:	206e                	.insn	2, 0x206e
50010b26:	203d                	jal	50010b54 <k+0x7d4>
50010b28:	7830                	.insn	2, 0x7830
50010b2a:	7825                	lui	a6,0xfffe9
50010b2c:	3a29                	jal	50010446 <k+0xc6>
50010b2e:	000a                	c.slli	zero,0x2
50010b30:	6e32                	.insn	2, 0x6e32
50010b32:	2064                	.insn	2, 0x2064
50010b34:	74726563          	bltu	tp,t2,5001127e <cert_der+0x602>
50010b38:	7320                	.insn	2, 0x7320
50010b3a:	7661                	lui	a2,0xffff8
50010b3c:	2065                	jal	50010be4 <signature+0x2c>
50010b3e:	63637573          	csrrc	a0,0x636,6
50010b42:	7365                	lui	t1,0xffff9
50010b44:	00000073          	ecall
50010b48:	301e                	.insn	2, 0x301e
50010b4a:	0000                	unimp
50010b4c:	2fe6                	.insn	2, 0x2fe6
50010b4e:	0000                	unimp
50010b50:	2fe6                	.insn	2, 0x2fe6
50010b52:	0000                	unimp
50010b54:	2fe6                	.insn	2, 0x2fe6
50010b56:	0000                	unimp
50010b58:	2fe6                	.insn	2, 0x2fe6
50010b5a:	0000                	unimp
50010b5c:	2fe6                	.insn	2, 0x2fe6
50010b5e:	0000                	unimp
50010b60:	306e                	.insn	2, 0x306e
50010b62:	0000                	unimp
50010b64:	3226                	.insn	2, 0x3226
50010b66:	0000                	unimp
50010b68:	3338                	.insn	2, 0x3338
50010b6a:	0000                	unimp
50010b6c:	30a4                	.insn	2, 0x30a4
50010b6e:	0000                	unimp
50010b70:	3388                	.insn	2, 0x3388
50010b72:	0000                	unimp
50010b74:	0000                	unimp
50010b76:	0000                	unimp
50010b78:	9ed8                	.insn	2, 0x9ed8
50010b7a:	c105                	beqz	a0,50010b9a <k+0x81a>
50010b7c:	9d5d                	.insn	2, 0x9d5d
50010b7e:	d507cbbb          	.insn	4, 0xd507cbbb
50010b82:	367c                	.insn	2, 0x367c
50010b84:	292a                	.insn	2, 0x292a
50010b86:	629a                	.insn	2, 0x629a
50010b88:	3070dd17          	auipc	s10,0x3070d
50010b8c:	015a                	sll	sp,sp,0x16
50010b8e:	9159                	srl	a0,a0,0x36
50010b90:	5939                	li	s2,-18
50010b92:	f70e                	.insn	2, 0xf70e
50010b94:	ecd8                	.insn	2, 0xecd8
50010b96:	0b31152f          	.insn	4, 0x0b31152f
50010b9a:	ffc0                	.insn	2, 0xffc0
50010b9c:	67332667          	.insn	4, 0x67332667
50010ba0:	1511                	add	a0,a0,-28 # 19fe4 <_data_lma_end+0x15c20>
50010ba2:	6858                	.insn	2, 0x6858
50010ba4:	8eb44a87          	.insn	4, 0x8eb44a87
50010ba8:	64f98fa7          	.insn	4, 0x64f98fa7
50010bac:	2e0d                	jal	50010ede <cert_der+0x262>
50010bae:	db0c                	sw	a1,48(a4)
50010bb0:	4fa4                	lw	s1,88(a5)
50010bb2:	befa                	.insn	2, 0xbefa
50010bb4:	481d                	li	a6,7
50010bb6:	47b5                	li	a5,13

Disassembly of section .bss:

50010bb8 <signature>:
	...

50010c18 <private_key>:
	...

50010c48 <public_key>:
	...

50010c7c <cert_der>:
	...

50011c7c <tbs_der>:
	...

5001247c <cert_store>:
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
  30:	0a01                	add	s4,s4,0 # 35313000 <_data_lma_end+0x3530ec3c>
  32:	0b              	Address 0x32 is out of bounds.


Disassembly of section .debug_info:

00000000 <.debug_info>:
   0:	01b2                	sll	gp,gp,0xc
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0401                	add	s0,s0,0 # 9000 <_data_lma_end+0x4c3c>
   8:	0000                	unimp
   a:	0000                	unimp
   c:	0000b407          	.insn	4, 0xb407
  10:	1d00                	add	s0,sp,688
  12:	0000                	unimp
  14:	0000                	unimp
  16:	0026                	c.slli	zero,0x9
  18:	0000                	unimp
  1a:	34a6                	.insn	2, 0x34a6
  1c:	0000                	unimp
  1e:	0028                	add	a0,sp,8
  20:	0000                	unimp
  22:	0000                	unimp
  24:	0000                	unimp
  26:	0801                	add	a6,a6,0 # fffe9000 <_tbs_der_store_end+0xaffc9fe0>
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
  4a:	0601                	add	a2,a2,0 # ffff8000 <_tbs_der_store_end+0xaffd8fe0>
  4c:	0031                	c.nop	12
  4e:	0000                	unimp
  50:	0101                	add	sp,sp,0 # 3b2f7000 <_data_lma_end+0x3b2f2c3c>
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
  f8:	0200776f          	jal	a4,7118 <_data_lma_end+0x2d54>
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
 152:	34a6                	.insn	2, 0x34a6
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
 19a:	34be                	.insn	2, 0x34be
 19c:	0000                	unimp
 19e:	0010                	.insn	2, 0x0010
 1a0:	0000                	unimp
 1a2:	0e11                	add	t3,t3,4 # 19004 <_data_lma_end+0x14c40>
 1a4:	0000                	unimp
 1a6:	0100                	add	s0,sp,128
 1a8:	0190                	add	a2,sp,192
 1aa:	9714                	.insn	2, 0x9714
 1ac:	0000                	unimp
 1ae:	9c00                	.insn	2, 0x9c00
 1b0:	0000                	unimp
 1b2:	0000                	unimp
 1b4:	0000                	unimp
 1b6:	01b2                	sll	gp,gp,0xc
 1b8:	0000                	unimp
 1ba:	0005                	c.nop	1
 1bc:	0401                	add	s0,s0,0
 1be:	010c                	add	a1,sp,128
 1c0:	0000                	unimp
 1c2:	0000b407          	.insn	4, 0xb407
 1c6:	1d00                	add	s0,sp,688
 1c8:	0000                	unimp
 1ca:	0000                	unimp
 1cc:	0026                	c.slli	zero,0x9
 1ce:	0000                	unimp
 1d0:	34ce                	.insn	2, 0x34ce
 1d2:	0000                	unimp
 1d4:	0028                	add	a0,sp,8
 1d6:	0000                	unimp
 1d8:	00000107          	.insn	4, 0x0107
 1dc:	0801                	add	a6,a6,0
 1de:	00007607          	.insn	4, 0x7607
 1e2:	0100                	add	s0,sp,128
 1e4:	0704                	add	s1,sp,896
 1e6:	0080                	add	s0,sp,64
 1e8:	0000                	unimp
 1ea:	0408                	add	a0,sp,512
 1ec:	6905                	lui	s2,0x1
 1ee:	746e                	.insn	2, 0x746e
 1f0:	0100                	add	s0,sp,128
 1f2:	0508                	add	a0,sp,640
 1f4:	008d                	add	ra,ra,3
 1f6:	0000                	unimp
 1f8:	1001                	c.nop	-32
 1fa:	6a04                	.insn	2, 0x6a04
 1fc:	0000                	unimp
 1fe:	0100                	add	s0,sp,128
 200:	0601                	add	a2,a2,0
 202:	0031                	c.nop	12
 204:	0000                	unimp
 206:	0101                	add	sp,sp,0
 208:	2f08                	.insn	2, 0x2f08
 20a:	0000                	unimp
 20c:	0100                	add	s0,sp,128
 20e:	0502                	c.slli64	a0
 210:	0000009b          	.insn	4, 0x009b
 214:	0201                	add	tp,tp,0 # 1000 <ecc_point_decompress+0x16>
 216:	00003d07          	.insn	4, 0x3d07
 21a:	0100                	add	s0,sp,128
 21c:	0504                	add	s1,sp,640
 21e:	0092                	sll	ra,ra,0x4
 220:	0000                	unimp
 222:	0401                	add	s0,s0,0
 224:	00007b07          	.insn	4, 0x7b07
 228:	0100                	add	s0,sp,128
 22a:	0801                	add	a6,a6,0
 22c:	0038                	add	a4,sp,8
 22e:	0000                	unimp
 230:	0101                	add	sp,sp,0
 232:	8d02                	jr	s10
 234:	0001                	nop
 236:	0200                	add	s0,sp,256
 238:	0028                	add	a0,sp,8
 23a:	0000                	unimp
 23c:	0f80                	add	s0,sp,976
 23e:	0034                	add	a3,sp,8
 240:	0000                	unimp
 242:	2702                	.insn	2, 0x2702
 244:	0000                	unimp
 246:	8100                	.insn	2, 0x8100
 248:	2d16                	.insn	2, 0x2d16
 24a:	0000                	unimp
 24c:	0300                	add	s0,sp,384
 24e:	008c                	add	a1,sp,64
 250:	0000                	unimp
 252:	9302                	jalr	t1
 254:	0001                	nop
 256:	8400                	.insn	2, 0x8400
 258:	00003b0f          	.insn	4, 0x3b0f
 25c:	0100                	add	s0,sp,128
 25e:	0402                	c.slli64	s0
 260:	001e                	c.slli	zero,0x7
 262:	0000                	unimp
 264:	0401                	add	s0,s0,0
 266:	00001603          	lh	a2,0(zero) # 0 <_start>
 26a:	0100                	add	s0,sp,128
 26c:	0404                	add	s1,sp,512
 26e:	0176                	sll	sp,sp,0x1d
 270:	0000                	unimp
 272:	0801                	add	a6,a6,0
 274:	00016e03          	.insn	4, 0x00016e03
 278:	0100                	add	s0,sp,128
 27a:	0408                	add	a0,sp,512
 27c:	0000006f          	j	27c <vli_cmp+0x8>
 280:	1001                	c.nop	-32
 282:	0000a503          	lw	a0,0(ra)
 286:	0100                	add	s0,sp,128
 288:	0320                	add	s0,sp,392
 28a:	0062                	c.slli	zero,0x18
 28c:	0000                	unimp
 28e:	7c02                	.insn	2, 0x7c02
 290:	0001                	nop
 292:	a800                	.insn	2, 0xa800
 294:	340d                	jal	fffffcb6 <_tbs_der_store_end+0xaffe0c96>
 296:	0000                	unimp
 298:	0300                	add	s0,sp,384
 29a:	00d8                	add	a4,sp,68
 29c:	0000                	unimp
 29e:	0009                	c.nop	2
 2a0:	0000                	unimp
 2a2:	0800                	add	s0,sp,16
 2a4:	f102                	.insn	2, 0xf102
 2a6:	0a01                	add	s4,s4,0
 2a8:	00000113          	li	sp,0
 2ac:	6c0a                	.insn	2, 0x6c0a
 2ae:	0200776f          	jal	a4,72ce <_data_lma_end+0x2f0a>
 2b2:	01f1                	add	gp,gp,28
 2b4:	811a                	mv	sp,t1
 2b6:	0000                	unimp
 2b8:	0000                	unimp
 2ba:	0000090b          	.insn	4, 0x090b
 2be:	0200                	add	s0,sp,256
 2c0:	01f1                	add	gp,gp,28
 2c2:	811f 0000 0400      	.insn	6, 0x04000000811f
 2c8:	0c00                	add	s0,sp,528
 2ca:	0208                	add	a0,sp,256
 2cc:	01f8                	add	a4,sp,204
 2ce:	3309                	jal	ffffffd0 <_tbs_der_store_end+0xaffe0fb0>
 2d0:	0001                	nop
 2d2:	0400                	add	s0,sp,512
 2d4:	01fa0073          	.insn	4, 0x01fa0073
 2d8:	0000e813          	or	a6,ra,0
 2dc:	0400                	add	s0,sp,512
 2de:	6c6c                	.insn	2, 0x6c6c
 2e0:	fb00                	.insn	2, 0xfb00
 2e2:	0a01                	add	s4,s4,0
 2e4:	009c                	add	a5,sp,64
 2e6:	0000                	unimp
 2e8:	0d00                	add	s0,sp,656
 2ea:	0050                	add	a2,sp,4
 2ec:	0000                	unimp
 2ee:	fc02                	.insn	2, 0xfc02
 2f0:	0301                	add	t1,t1,0
 2f2:	00000113          	li	sp,0
 2f6:	00013303          	.insn	4, 0x00013303
 2fa:	0e00                	add	s0,sp,784
 2fc:	019a                	sll	gp,gp,0x6
 2fe:	0000                	unimp
 300:	9c01                	.insn	2, 0x9c01
 302:	0101                	add	sp,sp,0
 304:	009c                	add	a5,sp,64
 306:	0000                	unimp
 308:	34ce                	.insn	2, 0x34ce
 30a:	0000                	unimp
 30c:	0028                	add	a0,sp,8
 30e:	0000                	unimp
 310:	9c01                	.insn	2, 0x9c01
 312:	7505                	lui	a0,0xfffe1
 314:	1300                	add	s0,sp,416
 316:	009c                	add	a5,sp,64
 318:	0000                	unimp
 31a:	00b9                	add	ra,ra,14
 31c:	0000                	unimp
 31e:	6205                	lui	tp,0x1
 320:	2700                	.insn	2, 0x2700
 322:	00d8                	add	a4,sp,68
 324:	0000                	unimp
 326:	00fa                	sll	ra,ra,0x1e
 328:	0000                	unimp
 32a:	7506                	.insn	2, 0x7506
 32c:	0075                	c.nop	29
 32e:	01a1                	add	gp,gp,8
 330:	4011                	c.li	zero,4
 332:	0001                	nop
 334:	0f00                	add	s0,sp,912
 336:	6d62                	.insn	2, 0x6d62
 338:	0100                	add	s0,sp,128
 33a:	01a2                	sll	gp,gp,0x8
 33c:	e31a                	.insn	2, 0xe31a
 33e:	0000                	unimp
 340:	3200                	.insn	2, 0x3200
 342:	0001                	nop
 344:	0600                	add	s0,sp,768
 346:	01a30077          	.insn	4, 0x01a30077
 34a:	0001330b          	.insn	4, 0x0001330b
 34e:	1000                	add	s0,sp,32
 350:	34e6                	.insn	2, 0x34e6
 352:	0000                	unimp
 354:	0010                	.insn	2, 0x0010
 356:	0000                	unimp
 358:	0e11                	add	t3,t3,4
 35a:	0000                	unimp
 35c:	0100                	add	s0,sp,128
 35e:	01ac                	add	a1,sp,200
 360:	9714                	.insn	2, 0x9714
 362:	0000                	unimp
 364:	4900                	lw	s0,16(a0)
 366:	0001                	nop
 368:	0000                	unimp
	...

Disassembly of section .debug_abbrev:

00000000 <.debug_abbrev>:
   0:	2401                	jal	200 <vli_testBit+0x22>
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
  28:	0221                	add	tp,tp,8 # 1008 <ecc_point_decompress+0x1e>
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
  d6:	0111                	add	sp,sp,4 # b0b00ac <_data_lma_end+0xb0abce8>
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
 10c:	2401                	jal	30c <vli_add+0x24>
 10e:	0b00                	add	s0,sp,400
 110:	030b3e0b          	.insn	4, 0x030b3e0b
 114:	000e                	c.slli	zero,0x3
 116:	0200                	add	s0,sp,256
 118:	0016                	c.slli	zero,0x5
 11a:	213a0e03          	lb	t3,531(s4)
 11e:	3b02                	.insn	2, 0x3b02
 120:	490b390b          	.insn	4, 0x490b390b
 124:	03000013          	li	zero,48
 128:	0026                	c.slli	zero,0x9
 12a:	1349                	add	t1,t1,-14
 12c:	0000                	unimp
 12e:	0d04                	add	s1,sp,656
 130:	0300                	add	s0,sp,384
 132:	3a08                	.insn	2, 0x3a08
 134:	0221                	add	tp,tp,8 # 8 <_start+0x8>
 136:	0b39053b          	.insn	4, 0x0b39053b
 13a:	1349                	add	t1,t1,-14
 13c:	0000                	unimp
 13e:	0505                	add	a0,a0,1
 140:	0300                	add	s0,sp,384
 142:	3a08                	.insn	2, 0x3a08
 144:	0121                	add	sp,sp,8
 146:	039c213b          	.insn	4, 0x039c213b
 14a:	0b39                	add	s6,s6,14
 14c:	1349                	add	t1,t1,-14
 14e:	1702                	sll	a4,a4,0x20
 150:	0000                	unimp
 152:	3406                	.insn	2, 0x3406
 154:	0300                	add	s0,sp,384
 156:	3a08                	.insn	2, 0x3a08
 158:	0121                	add	sp,sp,8
 15a:	0b39053b          	.insn	4, 0x0b39053b
 15e:	1349                	add	t1,t1,-14
 160:	0000                	unimp
 162:	25011107          	.insn	4, 0x25011107
 166:	130e                	sll	t1,t1,0x23
 168:	1b1f030b          	.insn	4, 0x1b1f030b
 16c:	111f 1201 1006      	.insn	6, 0x10061201111f
 172:	08000017          	auipc	zero,0x8000
 176:	0024                	add	s1,sp,8
 178:	0b3e0b0b          	.insn	4, 0x0b3e0b0b
 17c:	00000803          	lb	a6,0(zero) # 0 <_start>
 180:	1309                	add	t1,t1,-30
 182:	0301                	add	t1,t1,0
 184:	0b0e                	sll	s6,s6,0x3
 186:	3b0b3a0b          	.insn	4, 0x3b0b3a0b
 18a:	3905                	jal	fffffdba <_tbs_der_store_end+0xaffe0d9a>
 18c:	0013010b          	.insn	4, 0x0013010b
 190:	0a00                	add	s0,sp,272
 192:	000d                	c.nop	3
 194:	0b3a0803          	lb	a6,179(s4)
 198:	0b39053b          	.insn	4, 0x0b39053b
 19c:	1349                	add	t1,t1,-14
 19e:	0b38                	add	a4,sp,408
 1a0:	0000                	unimp
 1a2:	03000d0b          	.insn	4, 0x03000d0b
 1a6:	3a0e                	.insn	2, 0x3a0e
 1a8:	39053b0b          	.insn	4, 0x39053b0b
 1ac:	3813490b          	.insn	4, 0x3813490b
 1b0:	0c00000b          	.insn	4, 0x0c00000b
 1b4:	0b0b0117          	auipc	sp,0xb0b0
 1b8:	0b3a                	sll	s6,s6,0xe
 1ba:	0b39053b          	.insn	4, 0x0b39053b
 1be:	1301                	add	t1,t1,-32
 1c0:	0000                	unimp
 1c2:	160d                	add	a2,a2,-29
 1c4:	0300                	add	s0,sp,384
 1c6:	3a0e                	.insn	2, 0x3a0e
 1c8:	39053b0b          	.insn	4, 0x39053b0b
 1cc:	0013490b          	.insn	4, 0x0013490b
 1d0:	0e00                	add	s0,sp,784
 1d2:	012e                	sll	sp,sp,0xb
 1d4:	0e03193f 053b0b3a 	.insn	8, 0x053b0b3a0e03193f
 1dc:	0b39                	add	s6,s6,14
 1de:	13491927          	.insn	4, 0x13491927
 1e2:	0111                	add	sp,sp,4 # b0b01b8 <_data_lma_end+0xb0abdf4>
 1e4:	0612                	sll	a2,a2,0x4
 1e6:	1840                	add	s0,sp,52
 1e8:	197a                	sll	s2,s2,0x3e
 1ea:	0000                	unimp
 1ec:	0300340f          	.insn	4, 0x0300340f
 1f0:	3a08                	.insn	2, 0x3a08
 1f2:	39053b0b          	.insn	4, 0x39053b0b
 1f6:	0213490b          	.insn	4, 0x0213490b
 1fa:	10000017          	auipc	zero,0x10000
 1fe:	0111010b          	.insn	4, 0x0111010b
 202:	0612                	sll	a2,a2,0x4
 204:	0000                	unimp
 206:	3411                	jal	fffffc0a <_tbs_der_store_end+0xaffe0bea>
 208:	0300                	add	s0,sp,384
 20a:	3a0e                	.insn	2, 0x3a0e
 20c:	39053b0b          	.insn	4, 0x39053b0b
 210:	0213490b          	.insn	4, 0x0213490b
 214:	00000017          	auipc	zero,0x0

Disassembly of section .debug_loclists:

00000000 <.debug_loclists>:
   0:	00a9                	add	ra,ra,10
   2:	0000                	unimp
   4:	0005                	c.nop	1
   6:	0004                	.insn	2, 0x0004
   8:	0000                	unimp
   a:	0000                	unimp
   c:	0034a607          	.insn	4, 0x0034a607
  10:	b800                	.insn	2, 0xb800
  12:	0034                	add	a3,sp,8
  14:	0600                	add	s0,sp,768
  16:	935a                	add	t1,t1,s6
  18:	5b04                	lw	s1,48(a4)
  1a:	b8070493          	add	s1,a4,-1152 # 19b80 <_data_lma_end+0x157bc>
  1e:	0034                	add	a3,sp,8
  20:	be00                	.insn	2, 0xbe00
  22:	0034                	add	a3,sp,8
  24:	0600                	add	s0,sp,768
  26:	0aa503a3          	sb	a0,167(a0)
  2a:	9f26                	add	t5,t5,s1
  2c:	0034be07          	.insn	4, 0x0034be07
  30:	c600                	sw	s0,8(a2)
  32:	0034                	add	a3,sp,8
  34:	0600                	add	s0,sp,768
  36:	935a                	add	t1,t1,s6
  38:	5b04                	lw	s1,48(a4)
  3a:	c6070493          	add	s1,a4,-928
  3e:	0034                	add	a3,sp,8
  40:	ce00                	sw	s0,24(a2)
  42:	0034                	add	a3,sp,8
  44:	0600                	add	s0,sp,768
  46:	0aa503a3          	sb	a0,167(a0)
  4a:	9f26                	add	t5,t5,s1
  4c:	0700                	add	s0,sp,896
  4e:	34a6                	.insn	2, 0x34a6
  50:	0000                	unimp
  52:	34b4                	.insn	2, 0x34b4
  54:	0000                	unimp
  56:	5c01                	li	s8,-32
  58:	0034b407          	.insn	4, 0x0034b407
  5c:	ba00                	.insn	2, 0xba00
  5e:	0034                	add	a3,sp,8
  60:	0300                	add	s0,sp,384
  62:	207c                	.insn	2, 0x207c
  64:	079f 34ba 0000      	.insn	6, 0x34ba079f
  6a:	34be                	.insn	2, 0x34be
  6c:	0000                	unimp
  6e:	a30a                	.insn	2, 0xa30a
  70:	260ca503          	lw	a0,608(s9)
  74:	2da8                	.insn	2, 0x2da8
  76:	00a8                	add	a0,sp,72
  78:	079f 34be 0000      	.insn	6, 0x34be079f
  7e:	34ce                	.insn	2, 0x34ce
  80:	0000                	unimp
  82:	5c01                	li	s8,-32
  84:	0700                	add	s0,sp,896
  86:	34ae                	.insn	2, 0x34ae
  88:	0000                	unimp
  8a:	34bc                	.insn	2, 0x34bc
  8c:	0000                	unimp
  8e:	5f01                	li	t5,-32
  90:	0034be07          	.insn	4, 0x0034be07
  94:	ce00                	sw	s0,24(a2)
  96:	0034                	add	a3,sp,8
  98:	0100                	add	s0,sp,128
  9a:	005f be07 0034      	.insn	6, 0x0034be07005f
  a0:	ca00                	sw	s0,16(a2)
  a2:	0034                	add	a3,sp,8
  a4:	0600                	add	s0,sp,768
  a6:	007f007b          	.insn	4, 0x007f007b
  aa:	9f24                	.insn	2, 0x9f24
  ac:	a900                	.insn	2, 0xa900
  ae:	0000                	unimp
  b0:	0500                	add	s0,sp,640
  b2:	0400                	add	s0,sp,512
  b4:	0000                	unimp
  b6:	0000                	unimp
  b8:	0700                	add	s0,sp,896
  ba:	34ce                	.insn	2, 0x34ce
  bc:	0000                	unimp
  be:	34e2                	.insn	2, 0x34e2
  c0:	0000                	unimp
  c2:	5a06                	lw	s4,96(sp)
  c4:	935b0493          	add	s1,s6,-1739
  c8:	0704                	add	s1,sp,896
  ca:	34e2                	.insn	2, 0x34e2
  cc:	0000                	unimp
  ce:	34e6                	.insn	2, 0x34e6
  d0:	0000                	unimp
  d2:	a306                	.insn	2, 0xa306
  d4:	260aa503          	lw	a0,608(s5)
  d8:	079f 34e6 0000      	.insn	6, 0x34e6079f
  de:	34f2                	.insn	2, 0x34f2
  e0:	0000                	unimp
  e2:	5a06                	lw	s4,96(sp)
  e4:	935b0493          	add	s1,s6,-1739
  e8:	0704                	add	s1,sp,896
  ea:	34f2                	.insn	2, 0x34f2
  ec:	0000                	unimp
  ee:	34f6                	.insn	2, 0x34f6
  f0:	0000                	unimp
  f2:	a306                	.insn	2, 0xa306
  f4:	260aa503          	lw	a0,608(s5)
  f8:	009f ce07 0034      	.insn	6, 0x0034ce07009f
  fe:	dc00                	sw	s0,56(s0)
 100:	0034                	add	a3,sp,8
 102:	0100                	add	s0,sp,128
 104:	075c                	add	a5,sp,900
 106:	34dc                	.insn	2, 0x34dc
 108:	0000                	unimp
 10a:	34e2                	.insn	2, 0x34e2
 10c:	0000                	unimp
 10e:	9f207c03          	.insn	4, 0x9f207c03
 112:	0034e207          	.insn	4, 0x0034e207
 116:	e600                	.insn	2, 0xe600
 118:	0034                	add	a3,sp,8
 11a:	0a00                	add	s0,sp,272
 11c:	0ca503a3          	sb	a0,199(a0)
 120:	a826                	.insn	2, 0xa826
 122:	a82d                	j	15c <_finish+0xd2>
 124:	9f00                	.insn	2, 0x9f00
 126:	0034e607          	.insn	4, 0x0034e607
 12a:	f600                	.insn	2, 0xf600
 12c:	0034                	add	a3,sp,8
 12e:	0100                	add	s0,sp,128
 130:	005c                	add	a5,sp,4
 132:	0034d607          	.insn	4, 0x0034d607
 136:	e400                	.insn	2, 0xe400
 138:	0034                	add	a3,sp,8
 13a:	0100                	add	s0,sp,128
 13c:	075f 34e6 0000      	.insn	6, 0x34e6075f
 142:	34f6                	.insn	2, 0x34f6
 144:	0000                	unimp
 146:	5f01                	li	t5,-32
 148:	0700                	add	s0,sp,896
 14a:	34e6                	.insn	2, 0x34e6
 14c:	0000                	unimp
 14e:	34f2                	.insn	2, 0x34f2
 150:	0000                	unimp
 152:	7a06                	.insn	2, 0x7a06
 154:	7f00                	.insn	2, 0x7f00
 156:	2500                	.insn	2, 0x2500
 158:	9f 00             	Address 0x158 is out of bounds.


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
  10:	34a6                	.insn	2, 0x34a6
  12:	0000                	unimp
  14:	0028                	add	a0,sp,8
	...
  1e:	0000                	unimp
  20:	001c                	.insn	2, 0x001c
  22:	0000                	unimp
  24:	0002                	c.slli64	zero
  26:	01b6                	sll	gp,gp,0xd
  28:	0000                	unimp
  2a:	0004                	.insn	2, 0x0004
  2c:	0000                	unimp
  2e:	0000                	unimp
  30:	34ce                	.insn	2, 0x34ce
  32:	0000                	unimp
  34:	0028                	add	a0,sp,8
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
  34:	1c01                	add	s8,s8,-32 # 19fe0 <_data_lma_end+0x15c1c>
  36:	0000                	unimp
  38:	0100                	add	s0,sp,128
  3a:	00a8                	add	a0,sp,72
  3c:	0000                	unimp
  3e:	0501                	add	a0,a0,0
  40:	0001                	nop
  42:	0205                	add	tp,tp,1 # 1 <_start+0x1>
  44:	34a6                	.insn	2, 0x34a6
  46:	0000                	unimp
  48:	01038003          	lb	zero,16(t2)
  4c:	0305                	add	t1,t1,1
  4e:	00090103          	lb	sp,0(s2) # 1000 <ecc_point_decompress+0x16>
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
  9c:	2705                	jal	7bc <vli_modInv+0xb0>
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
  d6:	2505                	jal	6f6 <ecc_bytes2native+0x38>
  d8:	0306                	sll	t1,t1,0x1
  da:	0900                	add	s0,sp,144
  dc:	0000                	unimp
  de:	0501                	add	a0,a0,0
  e0:	01030607          	.insn	4, 0x01030607
  e4:	0409                	add	s0,s0,2
  e6:	0100                	add	s0,sp,128
  e8:	2405                	jal	308 <vli_add+0x20>
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
 106:	0301                	add	t1,t1,0
 108:	0001                	nop
 10a:	0500                	add	s0,sp,640
 10c:	0400                	add	s0,sp,512
 10e:	3300                	.insn	2, 0x3300
 110:	0000                	unimp
 112:	0100                	add	s0,sp,128
 114:	0101                	add	sp,sp,0
 116:	000d0efb          	.insn	4, 0x000d0efb
 11a:	0101                	add	sp,sp,0
 11c:	0101                	add	sp,sp,0
 11e:	0000                	unimp
 120:	0100                	add	s0,sp,128
 122:	0000                	unimp
 124:	0101                	add	sp,sp,0
 126:	1f01                	add	t5,t5,-32
 128:	2602                	.insn	2, 0x2602
 12a:	0000                	unimp
 12c:	8c00                	.insn	2, 0x8c00
 12e:	0000                	unimp
 130:	0200                	add	s0,sp,256
 132:	1f01                	add	t5,t5,-32
 134:	0f02                	c.slli64	t5
 136:	00001c03          	lh	s8,0(zero) # 0 <_start>
 13a:	0100                	add	s0,sp,128
 13c:	001c                	.insn	2, 0x001c
 13e:	0000                	unimp
 140:	a801                	j	150 <_finish+0xc6>
 142:	0000                	unimp
 144:	0100                	add	s0,sp,128
 146:	0105                	add	sp,sp,1
 148:	0500                	add	s0,sp,640
 14a:	ce02                	sw	zero,28(sp)
 14c:	0034                	add	a3,sp,8
 14e:	0300                	add	s0,sp,384
 150:	039c                	add	a5,sp,448
 152:	0501                	add	a0,a0,0
 154:	09010303          	lb	t1,144(sp)
 158:	0000                	unimp
 15a:	0501                	add	a0,a0,0
 15c:	0606                	sll	a2,a2,0x1
 15e:	00090003          	lb	zero,0(s2)
 162:	0100                	add	s0,sp,128
 164:	0305                	add	t1,t1,1
 166:	0306                	sll	t1,t1,0x1
 168:	00020903          	lb	s2,0(tp) # 0 <_start>
 16c:	0301                	add	t1,t1,0
 16e:	0901                	add	s2,s2,0
 170:	0000                	unimp
 172:	0501                	add	a0,a0,0
 174:	061a                	sll	a2,a2,0x6
 176:	00090003          	lb	zero,0(s2)
 17a:	0100                	add	s0,sp,128
 17c:	0305                	add	t1,t1,1
 17e:	0306                	sll	t1,t1,0x1
 180:	0901                	add	s2,s2,0
 182:	0006                	c.slli	zero,0x1
 184:	0301                	add	t1,t1,0
 186:	0902                	c.slli64	s2
 188:	0000                	unimp
 18a:	0501                	add	a0,a0,0
 18c:	0606                	sll	a2,a2,0x1
 18e:	00090003          	lb	zero,0(s2)
 192:	0100                	add	s0,sp,128
 194:	0705                	add	a4,a4,1
 196:	0306                	sll	t1,t1,0x1
 198:	0902                	c.slli64	s2
 19a:	0004                	.insn	2, 0x0004
 19c:	0301                	add	t1,t1,0
 19e:	0901                	add	s2,s2,0
 1a0:	0000                	unimp
 1a2:	0501                	add	a0,a0,0
 1a4:	00030627          	.insn	4, 0x00030627
 1a8:	0009                	c.nop	2
 1aa:	0100                	add	s0,sp,128
 1ac:	2405                	jal	3cc <vli_mult+0x8>
 1ae:	02090003          	lb	zero,32(s2)
 1b2:	0100                	add	s0,sp,128
 1b4:	0305                	add	t1,t1,1
 1b6:	0306                	sll	t1,t1,0x1
 1b8:	090a                	sll	s2,s2,0x2
 1ba:	0006                	c.slli	zero,0x1
 1bc:	0501                	add	a0,a0,0
 1be:	0003060b          	.insn	4, 0x0003060b
 1c2:	0009                	c.nop	2
 1c4:	0100                	add	s0,sp,128
 1c6:	0105                	add	sp,sp,1
 1c8:	02090103          	lb	sp,32(s2)
 1cc:	0100                	add	s0,sp,128
 1ce:	0705                	add	a4,a4,1
 1d0:	0306                	sll	t1,t1,0x1
 1d2:	0979                	add	s2,s2,30
 1d4:	0002                	c.slli64	zero
 1d6:	0301                	add	t1,t1,0
 1d8:	0902                	c.slli64	s2
 1da:	0000                	unimp
 1dc:	0501                	add	a0,a0,0
 1de:	00030623          	sb	zero,12(t1)
 1e2:	0009                	c.nop	2
 1e4:	0100                	add	s0,sp,128
 1e6:	0705                	add	a4,a4,1
 1e8:	0306                	sll	t1,t1,0x1
 1ea:	0901                	add	s2,s2,0
 1ec:	0004                	.insn	2, 0x0004
 1ee:	0501                	add	a0,a0,0
 1f0:	0626                	sll	a2,a2,0x9
 1f2:	00090003          	lb	zero,0(s2)
 1f6:	0100                	add	s0,sp,128
 1f8:	1405                	add	s0,s0,-31
 1fa:	04097d03          	.insn	4, 0x04097d03
 1fe:	0100                	add	s0,sp,128
 200:	2c05                	jal	430 <vli_mult+0x6c>
 202:	04090303          	lb	t1,64(s2)
 206:	0100                	add	s0,sp,128
 208:	0409                	add	s0,s0,2
 20a:	0000                	unimp
 20c:	0101                	add	sp,sp,0

Disassembly of section .debug_str:

00000000 <.debug_str>:
   0:	5744                	lw	s1,44(a4)
   2:	75727473          	csrrc	s0,0x757,4
   6:	68007463          	bgeu	zero,zero,68e <vli_modMult_fast+0x8>
   a:	6769                	lui	a4,0x1a
   c:	0068                	add	a0,sp,12
   e:	72726163          	bltu	tp,t2,730 <vli_modInv+0x24>
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
  38:	72616863          	bltu	sp,t1,768 <vli_modInv+0x5c>
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
  70:	6c62756f          	jal	a0,27736 <_data_lma_end+0x23372>
  74:	0065                	c.nop	25
  76:	6f6c                	.insn	2, 0x6f6c
  78:	676e                	.insn	2, 0x676e
  7a:	6c20                	.insn	2, 0x6c20
  7c:	20676e6f          	jal	t3,76282 <_data_lma_end+0x71ebe>
  80:	6e75                	lui	t3,0x1d
  82:	6e676973          	csrrs	s2,0x6e6,14
  86:	6465                	lui	s0,0x19
  88:	6920                	.insn	2, 0x6920
  8a:	746e                	.insn	2, 0x746e
  8c:	6c00                	.insn	2, 0x6c00
  8e:	20676e6f          	jal	t3,76294 <_data_lma_end+0x71ed0>
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
  a6:	6c706d6f          	jal	s10,6f6c <_data_lma_end+0x2ba8>
  aa:	7865                	lui	a6,0xffff9
  ac:	6420                	.insn	2, 0x6420
  ae:	6c62756f          	jal	a0,27774 <_data_lma_end+0x233b0>
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
  ce:	646f6d63          	bltu	t5,t1,728 <vli_modInv+0x1c>
  d2:	6c65                	lui	s8,0x19
  d4:	6d3d                	lui	s10,0xf
  d6:	6465                	lui	s0,0x19
  d8:	6e61                	lui	t3,0x18
  da:	2079                	jal	168 <getRandomNumber>
  dc:	6d2d                	lui	s10,0xb
  de:	6261                	lui	tp,0x18
  e0:	3d69                	jal	ffffff7a <_tbs_der_store_end+0xaffe0f5a>
  e2:	6c69                	lui	s8,0x1a
  e4:	3370                	.insn	2, 0x3370
  e6:	2032                	.insn	2, 0x2032
  e8:	6d2d                	lui	s10,0xb
  ea:	646f6d63          	bltu	t5,t1,744 <vli_modInv+0x38>
  ee:	6c65                	lui	s8,0x19
  f0:	6d3d                	lui	s10,0xf
  f2:	6465                	lui	s0,0x19
  f4:	6e61                	lui	t3,0x18
  f6:	2079                	jal	184 <getRandomNumber+0x1c>
  f8:	6d2d                	lui	s10,0xb
  fa:	7574                	.insn	2, 0x7574
  fc:	656e                	.insn	2, 0x656e
  fe:	723d                	lui	tp,0xfffef
 100:	656b636f          	jal	t1,b6756 <_data_lma_end+0xb2392>
 104:	2074                	.insn	2, 0x2074
 106:	6d2d                	lui	s10,0xb
 108:	7369                	lui	t1,0xffffa
 10a:	2d61                	jal	7a2 <vli_modInv+0x96>
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
 142:	2d206363          	bltu	zero,s2,408 <vli_mult+0x44>
 146:	6e66                	.insn	2, 0x6e66
 148:	74732d6f          	jal	s10,3308e <_data_lma_end+0x2ecca>
 14c:	6361                	lui	t1,0x18
 14e:	72702d6b          	.insn	4, 0x72702d6b
 152:	6365746f          	jal	s0,57788 <_data_lma_end+0x533c4>
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
 16e:	706d6f63          	bltu	s10,t1,88c <vli_modSquare_fast+0x32>
 172:	656c                	.insn	2, 0x656c
 174:	2078                	.insn	2, 0x2078
 176:	6c66                	.insn	2, 0x6c66
 178:	0074616f          	jal	sp,4697e <_data_lma_end+0x425ba>
 17c:	66696873          	csrrs	a6,0x666,18
 180:	5f74                	lw	a3,124(a4)
 182:	6e756f63          	bltu	a0,t2,880 <vli_modSquare_fast+0x26>
 186:	5f74                	lw	a3,124(a4)
 188:	7974                	.insn	2, 0x7974
 18a:	6570                	.insn	2, 0x6570
 18c:	5f00                	lw	s0,56(a4)
 18e:	6f42                	.insn	2, 0x6f42
 190:	44006c6f          	jal	s8,65d0 <_data_lma_end+0x220c>
 194:	7449                	lui	s0,0xffff2
 196:	7079                	c.lui	zero,0xffffe
 198:	0065                	c.nop	25
 19a:	5f5f 7361 6c68      	.insn	6, 0x6c6873615f5f
 1a0:	6964                	.insn	2, 0x6964
 1a2:	33 00             	Address 0x1a2 is out of bounds.


Disassembly of section .debug_line_str:

00000000 <.debug_line_str>:
   0:	2e2e                	.insn	2, 0x2e2e
   2:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
   6:	2e2e                	.insn	2, 0x2e2e
   8:	2f2e2e2f          	.insn	4, 0x2f2e2e2f
   c:	2e2e                	.insn	2, 0x2e2e
   e:	672f2e2f          	.insn	4, 0x672f2e2f
  12:	6c2f6363          	bltu	t5,sp,6d8 <ecc_bytes2native+0x1a>
  16:	6269                	lui	tp,0x1a
  18:	2f636367          	.insn	4, 0x2f636367
  1c:	696c                	.insn	2, 0x696c
  1e:	6762                	.insn	2, 0x6762
  20:	2e326363          	bltu	tp,gp,306 <vli_add+0x1e>
  24:	682f0063          	beq	t5,sp,6a4 <EccPoint_isZero+0x4>
  28:	2f656d6f          	jal	s10,5631e <_data_lma_end+0x51f5a>
  2c:	6f68                	.insn	2, 0x6f68
  2e:	6475                	lui	s0,0x1d
  30:	68676e6f          	jal	t3,766b6 <_data_lma_end+0x722f2>
  34:	6975                	lui	s2,0x1d
  36:	7369722f          	.insn	4, 0x7369722f
  3a:	672d7663          	bgeu	s10,s2,6a6 <EccPoint_isZero+0x6>
  3e:	756e                	.insn	2, 0x756e
  40:	742d                	lui	s0,0xfffeb
  42:	636c6f6f          	jal	t5,c6678 <_data_lma_end+0xc22b4>
  46:	6168                	.insn	2, 0x6168
  48:	6e69                	lui	t3,0x1a
  4a:	6975622f          	.insn	4, 0x6975622f
  4e:	646c                	.insn	2, 0x646c
  50:	672d                	lui	a4,0xb
  52:	6e2d6363          	bltu	s10,sp,738 <vli_modInv+0x2c>
  56:	7765                	lui	a4,0xffff9
  58:	696c                	.insn	2, 0x696c
  5a:	2d62                	.insn	2, 0x2d62
  5c:	67617473          	csrrc	s0,0x676,2
  60:	3265                	jal	fffffa08 <_tbs_der_store_end+0xaffe09e8>
  62:	7369722f          	.insn	4, 0x7369722f
  66:	34367663          	bgeu	a2,gp,3b2 <vli_sub+0x62>
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
  9e:	6c2f6363          	bltu	t5,sp,764 <vli_modInv+0x58>
  a2:	6269                	lui	tp,0x1a
  a4:	00636367          	.insn	4, 0x00636367
  a8:	696c                	.insn	2, 0x696c
  aa:	6762                	.insn	2, 0x6762
  ac:	2e326363          	bltu	tp,gp,392 <vli_sub+0x42>
  b0:	0068                	add	a0,sp,12

Disassembly of section .debug_frame:

00000000 <.debug_frame>:
   0:	000c                	.insn	2, 0x000c
   2:	0000                	unimp
   4:	ffffffff          	.insn	4, 0xffffffff
   8:	7c010003          	lb	zero,1984(sp)
   c:	0d01                	add	s10,s10,0 # b000 <_data_lma_end+0x6c3c>
   e:	0002                	c.slli64	zero
  10:	000c                	.insn	2, 0x000c
  12:	0000                	unimp
  14:	0000                	unimp
  16:	0000                	unimp
  18:	34a6                	.insn	2, 0x34a6
  1a:	0000                	unimp
  1c:	0028                	add	a0,sp,8
  1e:	0000                	unimp
  20:	000c                	.insn	2, 0x000c
  22:	0000                	unimp
  24:	ffffffff          	.insn	4, 0xffffffff
  28:	7c010003          	lb	zero,1984(sp)
  2c:	0d01                	add	s10,s10,0
  2e:	0002                	c.slli64	zero
  30:	000c                	.insn	2, 0x000c
  32:	0000                	unimp
  34:	0020                	add	s0,sp,8
  36:	0000                	unimp
  38:	34ce                	.insn	2, 0x34ce
  3a:	0000                	unimp
  3c:	0028                	add	a0,sp,8
	...
