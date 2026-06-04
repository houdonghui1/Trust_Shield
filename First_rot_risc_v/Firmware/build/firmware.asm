
build/firmware.elf：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000008000000 <_start>:
 8000000:	78028117          	auipc	sp,0x78028
 8000004:	07010113          	add	sp,sp,112 # 80028070 <_stack_end>
 8000008:	4501                	li	a0,0
 800000a:	4581                	li	a1,0
 800000c:	4081                	li	ra,0
 800000e:	00000517          	auipc	a0,0x0
 8000012:	00a50513          	add	a0,a0,10 # 8000018 <main>
 8000016:	8502                	jr	a0

0000000008000018 <main>:
 8000018:	bb010113          	add	sp,sp,-1104
 800001c:	44113423          	sd	ra,1096(sp)
 8000020:	44813023          	sd	s0,1088(sp)
 8000024:	45010413          	add	s0,sp,1104
 8000028:	fe042023          	sw	zero,-32(s0)
 800002c:	fc042c23          	sw	zero,-40(s0)
 8000030:	bd840793          	add	a5,s0,-1064
 8000034:	40000713          	li	a4,1024
 8000038:	863a                	mv	a2,a4
 800003a:	4581                	li	a1,0
 800003c:	853e                	mv	a0,a5
 800003e:	01f000ef          	jal	800085c <memset>
 8000042:	fe042623          	sw	zero,-20(s0)
 8000046:	ba043c23          	sd	zero,-1096(s0)
 800004a:	bc043023          	sd	zero,-1088(s0)
 800004e:	bc043423          	sd	zero,-1080(s0)
 8000052:	bc043823          	sd	zero,-1072(s0)
 8000056:	fe042423          	sw	zero,-24(s0)
 800005a:	640007b7          	lui	a5,0x64000
 800005e:	07a1                	add	a5,a5,8 # 64000008 <itrng_entropy_repetition_count+0x5bffe594>
 8000060:	4705                	li	a4,1
 8000062:	c398                	sw	a4,0(a5)
 8000064:	640007b7          	lui	a5,0x64000
 8000068:	07b1                	add	a5,a5,12 # 6400000c <itrng_entropy_repetition_count+0x5bffe598>
 800006a:	4705                	li	a4,1
 800006c:	c398                	sw	a4,0(a5)
 800006e:	00001517          	auipc	a0,0x1
 8000072:	72a50513          	add	a0,a0,1834 # 8001798 <default_field_entropy+0x20>
 8000076:	3a4000ef          	jal	800041a <kprintf>
 800007a:	00001517          	auipc	a0,0x1
 800007e:	74650513          	add	a0,a0,1862 # 80017c0 <default_field_entropy+0x48>
 8000082:	398000ef          	jal	800041a <kprintf>
 8000086:	00001517          	auipc	a0,0x1
 800008a:	71250513          	add	a0,a0,1810 # 8001798 <default_field_entropy+0x20>
 800008e:	38c000ef          	jal	800041a <kprintf>
 8000092:	00001617          	auipc	a2,0x1
 8000096:	75660613          	add	a2,a2,1878 # 80017e8 <default_field_entropy+0x70>
 800009a:	00001597          	auipc	a1,0x1
 800009e:	75e58593          	add	a1,a1,1886 # 80017f8 <default_field_entropy+0x80>
 80000a2:	00001517          	auipc	a0,0x1
 80000a6:	76650513          	add	a0,a0,1894 # 8001808 <default_field_entropy+0x90>
 80000aa:	370000ef          	jal	800041a <kprintf>
 80000ae:	00001517          	auipc	a0,0x1
 80000b2:	77250513          	add	a0,a0,1906 # 8001820 <default_field_entropy+0xa8>
 80000b6:	364000ef          	jal	800041a <kprintf>
 80000ba:	4781                	li	a5,0
 80000bc:	853e                	mv	a0,a5
 80000be:	44813083          	ld	ra,1096(sp)
 80000c2:	44013403          	ld	s0,1088(sp)
 80000c6:	45010113          	add	sp,sp,1104
 80000ca:	8082                	ret

00000000080000cc <kputc>:
 80000cc:	7179                	add	sp,sp,-48
 80000ce:	f406                	sd	ra,40(sp)
 80000d0:	f022                	sd	s0,32(sp)
 80000d2:	1800                	add	s0,sp,48
 80000d4:	87aa                	mv	a5,a0
 80000d6:	fcf40fa3          	sb	a5,-33(s0)
 80000da:	640007b7          	lui	a5,0x64000
 80000de:	fef43423          	sd	a5,-24(s0)
 80000e2:	fe843703          	ld	a4,-24(s0)
 80000e6:	fdf44783          	lbu	a5,-33(s0)
 80000ea:	86be                	mv	a3,a5
 80000ec:	fe843783          	ld	a5,-24(s0)
 80000f0:	40d727af          	amoor.w	a5,a3,(a4)
 80000f4:	fef42223          	sw	a5,-28(s0)
 80000f8:	fe442783          	lw	a5,-28(s0)
 80000fc:	2781                	sext.w	a5,a5
 80000fe:	fe07c2e3          	bltz	a5,80000e2 <kputc+0x16>
 8000102:	0001                	nop
 8000104:	0001                	nop
 8000106:	70a2                	ld	ra,40(sp)
 8000108:	7402                	ld	s0,32(sp)
 800010a:	6145                	add	sp,sp,48
 800010c:	8082                	ret

000000000800010e <_kputs>:
 800010e:	7179                	add	sp,sp,-48
 8000110:	f406                	sd	ra,40(sp)
 8000112:	f022                	sd	s0,32(sp)
 8000114:	1800                	add	s0,sp,48
 8000116:	fca43c23          	sd	a0,-40(s0)
 800011a:	a819                	j	8000130 <_kputs+0x22>
 800011c:	fef44783          	lbu	a5,-17(s0)
 8000120:	853e                	mv	a0,a5
 8000122:	fabff0ef          	jal	80000cc <kputc>
 8000126:	fd843783          	ld	a5,-40(s0)
 800012a:	0785                	add	a5,a5,1 # 64000001 <itrng_entropy_repetition_count+0x5bffe58d>
 800012c:	fcf43c23          	sd	a5,-40(s0)
 8000130:	fd843783          	ld	a5,-40(s0)
 8000134:	0007c783          	lbu	a5,0(a5)
 8000138:	fef407a3          	sb	a5,-17(s0)
 800013c:	fef44783          	lbu	a5,-17(s0)
 8000140:	0ff7f793          	zext.b	a5,a5
 8000144:	ffe1                	bnez	a5,800011c <_kputs+0xe>
 8000146:	0001                	nop
 8000148:	0001                	nop
 800014a:	70a2                	ld	ra,40(sp)
 800014c:	7402                	ld	s0,32(sp)
 800014e:	6145                	add	sp,sp,48
 8000150:	8082                	ret

0000000008000152 <kputs>:
 8000152:	1101                	add	sp,sp,-32
 8000154:	ec06                	sd	ra,24(sp)
 8000156:	e822                	sd	s0,16(sp)
 8000158:	1000                	add	s0,sp,32
 800015a:	fea43423          	sd	a0,-24(s0)
 800015e:	fe843503          	ld	a0,-24(s0)
 8000162:	fadff0ef          	jal	800010e <_kputs>
 8000166:	4535                	li	a0,13
 8000168:	f65ff0ef          	jal	80000cc <kputc>
 800016c:	4529                	li	a0,10
 800016e:	f5fff0ef          	jal	80000cc <kputc>
 8000172:	0001                	nop
 8000174:	60e2                	ld	ra,24(sp)
 8000176:	6442                	ld	s0,16(sp)
 8000178:	6105                	add	sp,sp,32
 800017a:	8082                	ret

000000000800017c <print_number>:
 800017c:	715d                	add	sp,sp,-80
 800017e:	e486                	sd	ra,72(sp)
 8000180:	e0a2                	sd	s0,64(sp)
 8000182:	0880                	add	s0,sp,80
 8000184:	faa43c23          	sd	a0,-72(s0)
 8000188:	87ae                	mv	a5,a1
 800018a:	8736                	mv	a4,a3
 800018c:	faf40ba3          	sb	a5,-73(s0)
 8000190:	87b2                	mv	a5,a2
 8000192:	faf42823          	sw	a5,-80(s0)
 8000196:	87ba                	mv	a5,a4
 8000198:	faf40b23          	sb	a5,-74(s0)
 800019c:	fe042623          	sw	zero,-20(s0)
 80001a0:	fb744783          	lbu	a5,-73(s0)
 80001a4:	0ff7f793          	zext.b	a5,a5
 80001a8:	cf99                	beqz	a5,80001c6 <print_number+0x4a>
 80001aa:	fb843783          	ld	a5,-72(s0)
 80001ae:	0007dc63          	bgez	a5,80001c6 <print_number+0x4a>
 80001b2:	02d00513          	li	a0,45
 80001b6:	f17ff0ef          	jal	80000cc <kputc>
 80001ba:	fb843783          	ld	a5,-72(s0)
 80001be:	40f007b3          	neg	a5,a5
 80001c2:	faf43c23          	sd	a5,-72(s0)
 80001c6:	fb843683          	ld	a3,-72(s0)
 80001ca:	00001797          	auipc	a5,0x1
 80001ce:	6b678793          	add	a5,a5,1718 # 8001880 <default_field_entropy+0x108>
 80001d2:	639c                	ld	a5,0(a5)
 80001d4:	02f6b7b3          	mulhu	a5,a3,a5
 80001d8:	0037d713          	srl	a4,a5,0x3
 80001dc:	87ba                	mv	a5,a4
 80001de:	078a                	sll	a5,a5,0x2
 80001e0:	97ba                	add	a5,a5,a4
 80001e2:	0786                	sll	a5,a5,0x1
 80001e4:	40f68733          	sub	a4,a3,a5
 80001e8:	0ff77713          	zext.b	a4,a4
 80001ec:	fec42783          	lw	a5,-20(s0)
 80001f0:	0017869b          	addw	a3,a5,1
 80001f4:	fed42623          	sw	a3,-20(s0)
 80001f8:	0307071b          	addw	a4,a4,48
 80001fc:	0ff77713          	zext.b	a4,a4
 8000200:	17c1                	add	a5,a5,-16
 8000202:	97a2                	add	a5,a5,s0
 8000204:	fce78c23          	sb	a4,-40(a5)
 8000208:	fb843703          	ld	a4,-72(s0)
 800020c:	00001797          	auipc	a5,0x1
 8000210:	67478793          	add	a5,a5,1652 # 8001880 <default_field_entropy+0x108>
 8000214:	639c                	ld	a5,0(a5)
 8000216:	02f737b3          	mulhu	a5,a4,a5
 800021a:	838d                	srl	a5,a5,0x3
 800021c:	faf43c23          	sd	a5,-72(s0)
 8000220:	fb843783          	ld	a5,-72(s0)
 8000224:	f3cd                	bnez	a5,80001c6 <print_number+0x4a>
 8000226:	a01d                	j	800024c <print_number+0xd0>
 8000228:	fb644783          	lbu	a5,-74(s0)
 800022c:	0ff7f793          	zext.b	a5,a5
 8000230:	c781                	beqz	a5,8000238 <print_number+0xbc>
 8000232:	03000793          	li	a5,48
 8000236:	a019                	j	800023c <print_number+0xc0>
 8000238:	02000793          	li	a5,32
 800023c:	853e                	mv	a0,a5
 800023e:	e8fff0ef          	jal	80000cc <kputc>
 8000242:	fb042783          	lw	a5,-80(s0)
 8000246:	37fd                	addw	a5,a5,-1
 8000248:	faf42823          	sw	a5,-80(s0)
 800024c:	fb042783          	lw	a5,-80(s0)
 8000250:	873e                	mv	a4,a5
 8000252:	fec42783          	lw	a5,-20(s0)
 8000256:	86be                	mv	a3,a5
 8000258:	0007079b          	sext.w	a5,a4
 800025c:	873e                	mv	a4,a5
 800025e:	0006879b          	sext.w	a5,a3
 8000262:	fce7c3e3          	blt	a5,a4,8000228 <print_number+0xac>
 8000266:	a839                	j	8000284 <print_number+0x108>
 8000268:	fec42783          	lw	a5,-20(s0)
 800026c:	37fd                	addw	a5,a5,-1
 800026e:	fef42623          	sw	a5,-20(s0)
 8000272:	fec42783          	lw	a5,-20(s0)
 8000276:	17c1                	add	a5,a5,-16
 8000278:	97a2                	add	a5,a5,s0
 800027a:	fd87c783          	lbu	a5,-40(a5)
 800027e:	853e                	mv	a0,a5
 8000280:	e4dff0ef          	jal	80000cc <kputc>
 8000284:	fec42783          	lw	a5,-20(s0)
 8000288:	2781                	sext.w	a5,a5
 800028a:	fcf04fe3          	bgtz	a5,8000268 <print_number+0xec>
 800028e:	0001                	nop
 8000290:	0001                	nop
 8000292:	60a6                	ld	ra,72(sp)
 8000294:	6406                	ld	s0,64(sp)
 8000296:	6161                	add	sp,sp,80
 8000298:	8082                	ret

000000000800029a <print_hex>:
 800029a:	711d                	add	sp,sp,-96
 800029c:	ec86                	sd	ra,88(sp)
 800029e:	e8a2                	sd	s0,80(sp)
 80002a0:	1080                	add	s0,sp,96
 80002a2:	faa43423          	sd	a0,-88(s0)
 80002a6:	87ae                	mv	a5,a1
 80002a8:	8736                	mv	a4,a3
 80002aa:	faf42223          	sw	a5,-92(s0)
 80002ae:	87b2                	mv	a5,a2
 80002b0:	faf401a3          	sb	a5,-93(s0)
 80002b4:	87ba                	mv	a5,a4
 80002b6:	faf40123          	sb	a5,-94(s0)
 80002ba:	fa244783          	lbu	a5,-94(s0)
 80002be:	0ff7f793          	zext.b	a5,a5
 80002c2:	c399                	beqz	a5,80002c8 <print_hex+0x2e>
 80002c4:	47c1                	li	a5,16
 80002c6:	a011                	j	80002ca <print_hex+0x30>
 80002c8:	47a1                	li	a5,8
 80002ca:	fcf42c23          	sw	a5,-40(s0)
 80002ce:	fe042623          	sw	zero,-20(s0)
 80002d2:	fe042423          	sw	zero,-24(s0)
 80002d6:	fd842783          	lw	a5,-40(s0)
 80002da:	37fd                	addw	a5,a5,-1
 80002dc:	fef42223          	sw	a5,-28(s0)
 80002e0:	a841                	j	8000370 <print_hex+0xd6>
 80002e2:	fe442783          	lw	a5,-28(s0)
 80002e6:	0027979b          	sllw	a5,a5,0x2
 80002ea:	2781                	sext.w	a5,a5
 80002ec:	873e                	mv	a4,a5
 80002ee:	fa843783          	ld	a5,-88(s0)
 80002f2:	00e7d7b3          	srl	a5,a5,a4
 80002f6:	2781                	sext.w	a5,a5
 80002f8:	8bbd                	and	a5,a5,15
 80002fa:	fcf42a23          	sw	a5,-44(s0)
 80002fe:	fd442783          	lw	a5,-44(s0)
 8000302:	2781                	sext.w	a5,a5
 8000304:	eb91                	bnez	a5,8000318 <print_hex+0x7e>
 8000306:	fec42783          	lw	a5,-20(s0)
 800030a:	2781                	sext.w	a5,a5
 800030c:	00f04663          	bgtz	a5,8000318 <print_hex+0x7e>
 8000310:	fe442783          	lw	a5,-28(s0)
 8000314:	2781                	sext.w	a5,a5
 8000316:	eba1                	bnez	a5,8000366 <print_hex+0xcc>
 8000318:	fec42783          	lw	a5,-20(s0)
 800031c:	2785                	addw	a5,a5,1
 800031e:	fef42623          	sw	a5,-20(s0)
 8000322:	fd442783          	lw	a5,-44(s0)
 8000326:	2781                	sext.w	a5,a5
 8000328:	873e                	mv	a4,a5
 800032a:	47a5                	li	a5,9
 800032c:	00e7cb63          	blt	a5,a4,8000342 <print_hex+0xa8>
 8000330:	fd442783          	lw	a5,-44(s0)
 8000334:	0ff7f793          	zext.b	a5,a5
 8000338:	0307879b          	addw	a5,a5,48
 800033c:	0ff7f793          	zext.b	a5,a5
 8000340:	a809                	j	8000352 <print_hex+0xb8>
 8000342:	fd442783          	lw	a5,-44(s0)
 8000346:	0ff7f793          	zext.b	a5,a5
 800034a:	0577879b          	addw	a5,a5,87
 800034e:	0ff7f793          	zext.b	a5,a5
 8000352:	fe842703          	lw	a4,-24(s0)
 8000356:	0017069b          	addw	a3,a4,1
 800035a:	fed42423          	sw	a3,-24(s0)
 800035e:	1741                	add	a4,a4,-16
 8000360:	9722                	add	a4,a4,s0
 8000362:	fcf70023          	sb	a5,-64(a4)
 8000366:	fe442783          	lw	a5,-28(s0)
 800036a:	37fd                	addw	a5,a5,-1
 800036c:	fef42223          	sw	a5,-28(s0)
 8000370:	fe442783          	lw	a5,-28(s0)
 8000374:	2781                	sext.w	a5,a5
 8000376:	f607d6e3          	bgez	a5,80002e2 <print_hex+0x48>
 800037a:	fa442783          	lw	a5,-92(s0)
 800037e:	873e                	mv	a4,a5
 8000380:	fec42783          	lw	a5,-20(s0)
 8000384:	86be                	mv	a3,a5
 8000386:	0007079b          	sext.w	a5,a4
 800038a:	873e                	mv	a4,a5
 800038c:	0006879b          	sext.w	a5,a3
 8000390:	04e7d163          	bge	a5,a4,80003d2 <print_hex+0x138>
 8000394:	fa442783          	lw	a5,-92(s0)
 8000398:	873e                	mv	a4,a5
 800039a:	fec42783          	lw	a5,-20(s0)
 800039e:	40f707bb          	subw	a5,a4,a5
 80003a2:	fef42023          	sw	a5,-32(s0)
 80003a6:	a831                	j	80003c2 <print_hex+0x128>
 80003a8:	fa344783          	lbu	a5,-93(s0)
 80003ac:	0ff7f793          	zext.b	a5,a5
 80003b0:	c781                	beqz	a5,80003b8 <print_hex+0x11e>
 80003b2:	03000793          	li	a5,48
 80003b6:	a019                	j	80003bc <print_hex+0x122>
 80003b8:	02000793          	li	a5,32
 80003bc:	853e                	mv	a0,a5
 80003be:	d0fff0ef          	jal	80000cc <kputc>
 80003c2:	fe042783          	lw	a5,-32(s0)
 80003c6:	fff7871b          	addw	a4,a5,-1
 80003ca:	fee42023          	sw	a4,-32(s0)
 80003ce:	fcf04de3          	bgtz	a5,80003a8 <print_hex+0x10e>
 80003d2:	fc042e23          	sw	zero,-36(s0)
 80003d6:	a839                	j	80003f4 <print_hex+0x15a>
 80003d8:	fdc42783          	lw	a5,-36(s0)
 80003dc:	17c1                	add	a5,a5,-16
 80003de:	97a2                	add	a5,a5,s0
 80003e0:	fc07c783          	lbu	a5,-64(a5)
 80003e4:	853e                	mv	a0,a5
 80003e6:	ce7ff0ef          	jal	80000cc <kputc>
 80003ea:	fdc42783          	lw	a5,-36(s0)
 80003ee:	2785                	addw	a5,a5,1
 80003f0:	fcf42e23          	sw	a5,-36(s0)
 80003f4:	fdc42783          	lw	a5,-36(s0)
 80003f8:	873e                	mv	a4,a5
 80003fa:	fec42783          	lw	a5,-20(s0)
 80003fe:	86be                	mv	a3,a5
 8000400:	0007079b          	sext.w	a5,a4
 8000404:	873e                	mv	a4,a5
 8000406:	0006879b          	sext.w	a5,a3
 800040a:	fcf747e3          	blt	a4,a5,80003d8 <print_hex+0x13e>
 800040e:	0001                	nop
 8000410:	0001                	nop
 8000412:	60e6                	ld	ra,88(sp)
 8000414:	6446                	ld	s0,80(sp)
 8000416:	6125                	add	sp,sp,96
 8000418:	8082                	ret

000000000800041a <kprintf>:
 800041a:	7175                	add	sp,sp,-144
 800041c:	e486                	sd	ra,72(sp)
 800041e:	e0a2                	sd	s0,64(sp)
 8000420:	0880                	add	s0,sp,80
 8000422:	faa43c23          	sd	a0,-72(s0)
 8000426:	e40c                	sd	a1,8(s0)
 8000428:	e810                	sd	a2,16(s0)
 800042a:	ec14                	sd	a3,24(s0)
 800042c:	f018                	sd	a4,32(s0)
 800042e:	f41c                	sd	a5,40(s0)
 8000430:	03043823          	sd	a6,48(s0)
 8000434:	03143c23          	sd	a7,56(s0)
 8000438:	fe0407a3          	sb	zero,-17(s0)
 800043c:	fe040723          	sb	zero,-18(s0)
 8000440:	fc040ba3          	sb	zero,-41(s0)
 8000444:	fe042423          	sw	zero,-24(s0)
 8000448:	fe0403a3          	sb	zero,-25(s0)
 800044c:	04040793          	add	a5,s0,64
 8000450:	faf43823          	sd	a5,-80(s0)
 8000454:	fb043783          	ld	a5,-80(s0)
 8000458:	fc878793          	add	a5,a5,-56
 800045c:	fcf43423          	sd	a5,-56(s0)
 8000460:	a2e1                	j	8000628 <kprintf+0x20e>
 8000462:	fef44783          	lbu	a5,-17(s0)
 8000466:	0ff7f793          	zext.b	a5,a5
 800046a:	18078e63          	beqz	a5,8000606 <kprintf+0x1ec>
 800046e:	fd644783          	lbu	a5,-42(s0)
 8000472:	0ff7f713          	zext.b	a4,a5
 8000476:	02f00793          	li	a5,47
 800047a:	04e7ff63          	bgeu	a5,a4,80004d8 <kprintf+0xbe>
 800047e:	fd644783          	lbu	a5,-42(s0)
 8000482:	0ff7f713          	zext.b	a4,a5
 8000486:	03900793          	li	a5,57
 800048a:	04e7e763          	bltu	a5,a4,80004d8 <kprintf+0xbe>
 800048e:	fd644783          	lbu	a5,-42(s0)
 8000492:	0ff7f713          	zext.b	a4,a5
 8000496:	03000793          	li	a5,48
 800049a:	00f71a63          	bne	a4,a5,80004ae <kprintf+0x94>
 800049e:	fe842783          	lw	a5,-24(s0)
 80004a2:	2781                	sext.w	a5,a5
 80004a4:	e789                	bnez	a5,80004ae <kprintf+0x94>
 80004a6:	4785                	li	a5,1
 80004a8:	fef403a3          	sb	a5,-25(s0)
 80004ac:	aab5                	j	8000628 <kprintf+0x20e>
 80004ae:	fe842783          	lw	a5,-24(s0)
 80004b2:	873e                	mv	a4,a5
 80004b4:	87ba                	mv	a5,a4
 80004b6:	0027979b          	sllw	a5,a5,0x2
 80004ba:	9fb9                	addw	a5,a5,a4
 80004bc:	0017979b          	sllw	a5,a5,0x1
 80004c0:	0007871b          	sext.w	a4,a5
 80004c4:	fd644783          	lbu	a5,-42(s0)
 80004c8:	2781                	sext.w	a5,a5
 80004ca:	fd07879b          	addw	a5,a5,-48
 80004ce:	2781                	sext.w	a5,a5
 80004d0:	9fb9                	addw	a5,a5,a4
 80004d2:	fef42423          	sw	a5,-24(s0)
 80004d6:	aa89                	j	8000628 <kprintf+0x20e>
 80004d8:	fd644783          	lbu	a5,-42(s0)
 80004dc:	2781                	sext.w	a5,a5
 80004de:	f9d7879b          	addw	a5,a5,-99
 80004e2:	86be                	mv	a3,a5
 80004e4:	0006879b          	sext.w	a5,a3
 80004e8:	873e                	mv	a4,a5
 80004ea:	47d5                	li	a5,21
 80004ec:	0ee7e863          	bltu	a5,a4,80005dc <kprintf+0x1c2>
 80004f0:	02069793          	sll	a5,a3,0x20
 80004f4:	9381                	srl	a5,a5,0x20
 80004f6:	00279713          	sll	a4,a5,0x2
 80004fa:	00001797          	auipc	a5,0x1
 80004fe:	32e78793          	add	a5,a5,814 # 8001828 <default_field_entropy+0xb0>
 8000502:	97ba                	add	a5,a5,a4
 8000504:	439c                	lw	a5,0(a5)
 8000506:	0007871b          	sext.w	a4,a5
 800050a:	00001797          	auipc	a5,0x1
 800050e:	31e78793          	add	a5,a5,798 # 8001828 <default_field_entropy+0xb0>
 8000512:	97ba                	add	a5,a5,a4
 8000514:	8782                	jr	a5
 8000516:	4785                	li	a5,1
 8000518:	fef40723          	sb	a5,-18(s0)
 800051c:	a231                	j	8000628 <kprintf+0x20e>
 800051e:	4785                	li	a5,1
 8000520:	fcf40ba3          	sb	a5,-41(s0)
 8000524:	a211                	j	8000628 <kprintf+0x20e>
 8000526:	fc843783          	ld	a5,-56(s0)
 800052a:	00878713          	add	a4,a5,8
 800052e:	fce43423          	sd	a4,-56(s0)
 8000532:	639c                	ld	a5,0(a5)
 8000534:	fee44683          	lbu	a3,-18(s0)
 8000538:	fe744603          	lbu	a2,-25(s0)
 800053c:	fe842703          	lw	a4,-24(s0)
 8000540:	85ba                	mv	a1,a4
 8000542:	853e                	mv	a0,a5
 8000544:	d57ff0ef          	jal	800029a <print_hex>
 8000548:	a065                	j	80005f0 <kprintf+0x1d6>
 800054a:	fee44783          	lbu	a5,-18(s0)
 800054e:	0ff7f793          	zext.b	a5,a5
 8000552:	cb99                	beqz	a5,8000568 <kprintf+0x14e>
 8000554:	fc843783          	ld	a5,-56(s0)
 8000558:	00878713          	add	a4,a5,8
 800055c:	fce43423          	sd	a4,-56(s0)
 8000560:	639c                	ld	a5,0(a5)
 8000562:	fcf43c23          	sd	a5,-40(s0)
 8000566:	a821                	j	800057e <kprintf+0x164>
 8000568:	fc843783          	ld	a5,-56(s0)
 800056c:	00878713          	add	a4,a5,8
 8000570:	fce43423          	sd	a4,-56(s0)
 8000574:	439c                	lw	a5,0(a5)
 8000576:	1782                	sll	a5,a5,0x20
 8000578:	9381                	srl	a5,a5,0x20
 800057a:	fcf43c23          	sd	a5,-40(s0)
 800057e:	fd644783          	lbu	a5,-42(s0)
 8000582:	2781                	sext.w	a5,a5
 8000584:	873e                	mv	a4,a5
 8000586:	06400793          	li	a5,100
 800058a:	40f707b3          	sub	a5,a4,a5
 800058e:	0017b793          	seqz	a5,a5
 8000592:	0ff7f793          	zext.b	a5,a5
 8000596:	fe744683          	lbu	a3,-25(s0)
 800059a:	fe842703          	lw	a4,-24(s0)
 800059e:	863a                	mv	a2,a4
 80005a0:	85be                	mv	a1,a5
 80005a2:	fd843503          	ld	a0,-40(s0)
 80005a6:	bd7ff0ef          	jal	800017c <print_number>
 80005aa:	a099                	j	80005f0 <kprintf+0x1d6>
 80005ac:	fc843783          	ld	a5,-56(s0)
 80005b0:	00878713          	add	a4,a5,8
 80005b4:	fce43423          	sd	a4,-56(s0)
 80005b8:	639c                	ld	a5,0(a5)
 80005ba:	853e                	mv	a0,a5
 80005bc:	b53ff0ef          	jal	800010e <_kputs>
 80005c0:	a805                	j	80005f0 <kprintf+0x1d6>
 80005c2:	fc843783          	ld	a5,-56(s0)
 80005c6:	00878713          	add	a4,a5,8
 80005ca:	fce43423          	sd	a4,-56(s0)
 80005ce:	439c                	lw	a5,0(a5)
 80005d0:	0ff7f793          	zext.b	a5,a5
 80005d4:	853e                	mv	a0,a5
 80005d6:	af7ff0ef          	jal	80000cc <kputc>
 80005da:	a819                	j	80005f0 <kprintf+0x1d6>
 80005dc:	02500513          	li	a0,37
 80005e0:	aedff0ef          	jal	80000cc <kputc>
 80005e4:	fd644783          	lbu	a5,-42(s0)
 80005e8:	853e                	mv	a0,a5
 80005ea:	ae3ff0ef          	jal	80000cc <kputc>
 80005ee:	0001                	nop
 80005f0:	fe0407a3          	sb	zero,-17(s0)
 80005f4:	fe040723          	sb	zero,-18(s0)
 80005f8:	fc040ba3          	sb	zero,-41(s0)
 80005fc:	fe042423          	sw	zero,-24(s0)
 8000600:	fe0403a3          	sb	zero,-25(s0)
 8000604:	a015                	j	8000628 <kprintf+0x20e>
 8000606:	fd644783          	lbu	a5,-42(s0)
 800060a:	0ff7f713          	zext.b	a4,a5
 800060e:	02500793          	li	a5,37
 8000612:	00f71663          	bne	a4,a5,800061e <kprintf+0x204>
 8000616:	4785                	li	a5,1
 8000618:	fef407a3          	sb	a5,-17(s0)
 800061c:	a031                	j	8000628 <kprintf+0x20e>
 800061e:	fd644783          	lbu	a5,-42(s0)
 8000622:	853e                	mv	a0,a5
 8000624:	aa9ff0ef          	jal	80000cc <kputc>
 8000628:	fb843783          	ld	a5,-72(s0)
 800062c:	00178713          	add	a4,a5,1
 8000630:	fae43c23          	sd	a4,-72(s0)
 8000634:	0007c783          	lbu	a5,0(a5)
 8000638:	fcf40b23          	sb	a5,-42(s0)
 800063c:	fd644783          	lbu	a5,-42(s0)
 8000640:	0ff7f793          	zext.b	a5,a5
 8000644:	e0079fe3          	bnez	a5,8000462 <kprintf+0x48>
 8000648:	0001                	nop
 800064a:	0001                	nop
 800064c:	60a6                	ld	ra,72(sp)
 800064e:	6406                	ld	s0,64(sp)
 8000650:	6149                	add	sp,sp,144
 8000652:	8082                	ret

0000000008000654 <caliptra_generic_and_fuse_read>:
 8000654:	7179                	add	sp,sp,-48
 8000656:	f406                	sd	ra,40(sp)
 8000658:	f022                	sd	s0,32(sp)
 800065a:	1800                	add	s0,sp,48
 800065c:	87aa                	mv	a5,a0
 800065e:	fcf42e23          	sw	a5,-36(s0)
 8000662:	fdc42783          	lw	a5,-36(s0)
 8000666:	873e                	mv	a4,a5
 8000668:	300307b7          	lui	a5,0x30030
 800066c:	9fb9                	addw	a5,a5,a4
 800066e:	2781                	sext.w	a5,a5
 8000670:	1782                	sll	a5,a5,0x20
 8000672:	9381                	srl	a5,a5,0x20
 8000674:	439c                	lw	a5,0(a5)
 8000676:	fef42623          	sw	a5,-20(s0)
 800067a:	fec42783          	lw	a5,-20(s0)
 800067e:	853e                	mv	a0,a5
 8000680:	70a2                	ld	ra,40(sp)
 8000682:	7402                	ld	s0,32(sp)
 8000684:	6145                	add	sp,sp,48
 8000686:	8082                	ret

0000000008000688 <caliptra_generic_and_fuse_write>:
 8000688:	1101                	add	sp,sp,-32
 800068a:	ec06                	sd	ra,24(sp)
 800068c:	e822                	sd	s0,16(sp)
 800068e:	1000                	add	s0,sp,32
 8000690:	87aa                	mv	a5,a0
 8000692:	872e                	mv	a4,a1
 8000694:	fef42623          	sw	a5,-20(s0)
 8000698:	87ba                	mv	a5,a4
 800069a:	fef42423          	sw	a5,-24(s0)
 800069e:	fec42783          	lw	a5,-20(s0)
 80006a2:	873e                	mv	a4,a5
 80006a4:	300307b7          	lui	a5,0x30030
 80006a8:	9fb9                	addw	a5,a5,a4
 80006aa:	2781                	sext.w	a5,a5
 80006ac:	1782                	sll	a5,a5,0x20
 80006ae:	9381                	srl	a5,a5,0x20
 80006b0:	873e                	mv	a4,a5
 80006b2:	fe842783          	lw	a5,-24(s0)
 80006b6:	c31c                	sw	a5,0(a4)
 80006b8:	0001                	nop
 80006ba:	60e2                	ld	ra,24(sp)
 80006bc:	6442                	ld	s0,16(sp)
 80006be:	6105                	add	sp,sp,32
 80006c0:	8082                	ret

00000000080006c2 <caliptra_fuse_array_write>:
 80006c2:	7139                	add	sp,sp,-64
 80006c4:	fc06                	sd	ra,56(sp)
 80006c6:	f822                	sd	s0,48(sp)
 80006c8:	0080                	add	s0,sp,64
 80006ca:	87aa                	mv	a5,a0
 80006cc:	fcb43823          	sd	a1,-48(s0)
 80006d0:	fcc43423          	sd	a2,-56(s0)
 80006d4:	fcf42e23          	sw	a5,-36(s0)
 80006d8:	fe042623          	sw	zero,-20(s0)
 80006dc:	a81d                	j	8000712 <caliptra_fuse_array_write+0x50>
 80006de:	fec42783          	lw	a5,-20(s0)
 80006e2:	0027979b          	sllw	a5,a5,0x2
 80006e6:	2781                	sext.w	a5,a5
 80006e8:	fdc42703          	lw	a4,-36(s0)
 80006ec:	9fb9                	addw	a5,a5,a4
 80006ee:	0007869b          	sext.w	a3,a5
 80006f2:	fec46783          	lwu	a5,-20(s0)
 80006f6:	078a                	sll	a5,a5,0x2
 80006f8:	fd043703          	ld	a4,-48(s0)
 80006fc:	97ba                	add	a5,a5,a4
 80006fe:	439c                	lw	a5,0(a5)
 8000700:	85be                	mv	a1,a5
 8000702:	8536                	mv	a0,a3
 8000704:	f85ff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 8000708:	fec42783          	lw	a5,-20(s0)
 800070c:	2785                	addw	a5,a5,1 # 30030001 <itrng_entropy_repetition_count+0x2802e58d>
 800070e:	fef42623          	sw	a5,-20(s0)
 8000712:	fec46783          	lwu	a5,-20(s0)
 8000716:	fc843703          	ld	a4,-56(s0)
 800071a:	fce7e2e3          	bltu	a5,a4,80006de <caliptra_fuse_array_write+0x1c>
 800071e:	0001                	nop
 8000720:	0001                	nop
 8000722:	70e2                	ld	ra,56(sp)
 8000724:	7442                	ld	s0,48(sp)
 8000726:	6121                	add	sp,sp,64
 8000728:	8082                	ret

000000000800072a <caliptra_wdt_cfg_write>:
 800072a:	1101                	add	sp,sp,-32
 800072c:	ec06                	sd	ra,24(sp)
 800072e:	e822                	sd	s0,16(sp)
 8000730:	1000                	add	s0,sp,32
 8000732:	fea43423          	sd	a0,-24(s0)
 8000736:	fe843783          	ld	a5,-24(s0)
 800073a:	2781                	sext.w	a5,a5
 800073c:	85be                	mv	a1,a5
 800073e:	11000513          	li	a0,272
 8000742:	f47ff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 8000746:	fe843783          	ld	a5,-24(s0)
 800074a:	9381                	srl	a5,a5,0x20
 800074c:	2781                	sext.w	a5,a5
 800074e:	85be                	mv	a1,a5
 8000750:	11400513          	li	a0,276
 8000754:	f35ff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 8000758:	0001                	nop
 800075a:	60e2                	ld	ra,24(sp)
 800075c:	6442                	ld	s0,16(sp)
 800075e:	6105                	add	sp,sp,32
 8000760:	8082                	ret

0000000008000762 <caliptra_write_itrng_entropy_low_threshold>:
 8000762:	7179                	add	sp,sp,-48
 8000764:	f406                	sd	ra,40(sp)
 8000766:	f022                	sd	s0,32(sp)
 8000768:	1800                	add	s0,sp,48
 800076a:	87aa                	mv	a5,a0
 800076c:	fcf41f23          	sh	a5,-34(s0)
 8000770:	11800513          	li	a0,280
 8000774:	ee1ff0ef          	jal	8000654 <caliptra_generic_and_fuse_read>
 8000778:	87aa                	mv	a5,a0
 800077a:	fef42623          	sw	a5,-20(s0)
 800077e:	fec42783          	lw	a5,-20(s0)
 8000782:	873e                	mv	a4,a5
 8000784:	77c1                	lui	a5,0xffff0
 8000786:	8ff9                	and	a5,a5,a4
 8000788:	fef42623          	sw	a5,-20(s0)
 800078c:	fde45783          	lhu	a5,-34(s0)
 8000790:	2781                	sext.w	a5,a5
 8000792:	fec42703          	lw	a4,-20(s0)
 8000796:	8fd9                	or	a5,a5,a4
 8000798:	fef42623          	sw	a5,-20(s0)
 800079c:	fec42783          	lw	a5,-20(s0)
 80007a0:	85be                	mv	a1,a5
 80007a2:	11800513          	li	a0,280
 80007a6:	ee3ff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 80007aa:	0001                	nop
 80007ac:	70a2                	ld	ra,40(sp)
 80007ae:	7402                	ld	s0,32(sp)
 80007b0:	6145                	add	sp,sp,48
 80007b2:	8082                	ret

00000000080007b4 <caliptra_write_itrng_entropy_high_threshold>:
 80007b4:	7179                	add	sp,sp,-48
 80007b6:	f406                	sd	ra,40(sp)
 80007b8:	f022                	sd	s0,32(sp)
 80007ba:	1800                	add	s0,sp,48
 80007bc:	87aa                	mv	a5,a0
 80007be:	fcf41f23          	sh	a5,-34(s0)
 80007c2:	11800513          	li	a0,280
 80007c6:	e8fff0ef          	jal	8000654 <caliptra_generic_and_fuse_read>
 80007ca:	87aa                	mv	a5,a0
 80007cc:	fef42623          	sw	a5,-20(s0)
 80007d0:	fec42783          	lw	a5,-20(s0)
 80007d4:	17c2                	sll	a5,a5,0x30
 80007d6:	93c1                	srl	a5,a5,0x30
 80007d8:	fef42623          	sw	a5,-20(s0)
 80007dc:	fde45783          	lhu	a5,-34(s0)
 80007e0:	2781                	sext.w	a5,a5
 80007e2:	0107979b          	sllw	a5,a5,0x10
 80007e6:	2781                	sext.w	a5,a5
 80007e8:	fec42703          	lw	a4,-20(s0)
 80007ec:	8fd9                	or	a5,a5,a4
 80007ee:	fef42623          	sw	a5,-20(s0)
 80007f2:	fec42783          	lw	a5,-20(s0)
 80007f6:	85be                	mv	a1,a5
 80007f8:	11800513          	li	a0,280
 80007fc:	e8dff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 8000800:	0001                	nop
 8000802:	70a2                	ld	ra,40(sp)
 8000804:	7402                	ld	s0,32(sp)
 8000806:	6145                	add	sp,sp,48
 8000808:	8082                	ret

000000000800080a <caliptra_write_itrng_entropy_repetition_count>:
 800080a:	7179                	add	sp,sp,-48
 800080c:	f406                	sd	ra,40(sp)
 800080e:	f022                	sd	s0,32(sp)
 8000810:	1800                	add	s0,sp,48
 8000812:	87aa                	mv	a5,a0
 8000814:	fcf41f23          	sh	a5,-34(s0)
 8000818:	11c00513          	li	a0,284
 800081c:	e39ff0ef          	jal	8000654 <caliptra_generic_and_fuse_read>
 8000820:	87aa                	mv	a5,a0
 8000822:	fef42623          	sw	a5,-20(s0)
 8000826:	fec42783          	lw	a5,-20(s0)
 800082a:	873e                	mv	a4,a5
 800082c:	77c1                	lui	a5,0xffff0
 800082e:	8ff9                	and	a5,a5,a4
 8000830:	fef42623          	sw	a5,-20(s0)
 8000834:	fde45783          	lhu	a5,-34(s0)
 8000838:	2781                	sext.w	a5,a5
 800083a:	fec42703          	lw	a4,-20(s0)
 800083e:	8fd9                	or	a5,a5,a4
 8000840:	fef42623          	sw	a5,-20(s0)
 8000844:	fec42783          	lw	a5,-20(s0)
 8000848:	85be                	mv	a1,a5
 800084a:	11c00513          	li	a0,284
 800084e:	e3bff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 8000852:	0001                	nop
 8000854:	70a2                	ld	ra,40(sp)
 8000856:	7402                	ld	s0,32(sp)
 8000858:	6145                	add	sp,sp,48
 800085a:	8082                	ret

000000000800085c <memset>:
 800085c:	7139                	add	sp,sp,-64
 800085e:	fc06                	sd	ra,56(sp)
 8000860:	f822                	sd	s0,48(sp)
 8000862:	0080                	add	s0,sp,64
 8000864:	fca43c23          	sd	a0,-40(s0)
 8000868:	87ae                	mv	a5,a1
 800086a:	fcc43423          	sd	a2,-56(s0)
 800086e:	fcf42a23          	sw	a5,-44(s0)
 8000872:	fd843783          	ld	a5,-40(s0)
 8000876:	fef43023          	sd	a5,-32(s0)
 800087a:	fe043423          	sd	zero,-24(s0)
 800087e:	a00d                	j	80008a0 <memset+0x44>
 8000880:	fe043703          	ld	a4,-32(s0)
 8000884:	fe843783          	ld	a5,-24(s0)
 8000888:	97ba                	add	a5,a5,a4
 800088a:	fd442703          	lw	a4,-44(s0)
 800088e:	0ff77713          	zext.b	a4,a4
 8000892:	00e78023          	sb	a4,0(a5) # ffffffffffff0000 <_stack_end+0xffffffff7ffc7f90>
 8000896:	fe843783          	ld	a5,-24(s0)
 800089a:	0785                	add	a5,a5,1
 800089c:	fef43423          	sd	a5,-24(s0)
 80008a0:	fe843703          	ld	a4,-24(s0)
 80008a4:	fc843783          	ld	a5,-56(s0)
 80008a8:	fcf76ce3          	bltu	a4,a5,8000880 <memset+0x24>
 80008ac:	fd843783          	ld	a5,-40(s0)
 80008b0:	853e                	mv	a0,a5
 80008b2:	70e2                	ld	ra,56(sp)
 80008b4:	7442                	ld	s0,48(sp)
 80008b6:	6121                	add	sp,sp,64
 80008b8:	8082                	ret

00000000080008ba <memcpy>:
 80008ba:	715d                	add	sp,sp,-80
 80008bc:	e486                	sd	ra,72(sp)
 80008be:	e0a2                	sd	s0,64(sp)
 80008c0:	0880                	add	s0,sp,80
 80008c2:	fca43423          	sd	a0,-56(s0)
 80008c6:	fcb43023          	sd	a1,-64(s0)
 80008ca:	fac43c23          	sd	a2,-72(s0)
 80008ce:	fc843783          	ld	a5,-56(s0)
 80008d2:	fef43023          	sd	a5,-32(s0)
 80008d6:	fc043783          	ld	a5,-64(s0)
 80008da:	fcf43c23          	sd	a5,-40(s0)
 80008de:	fe043423          	sd	zero,-24(s0)
 80008e2:	a025                	j	800090a <memcpy+0x50>
 80008e4:	fd843703          	ld	a4,-40(s0)
 80008e8:	fe843783          	ld	a5,-24(s0)
 80008ec:	973e                	add	a4,a4,a5
 80008ee:	fe043683          	ld	a3,-32(s0)
 80008f2:	fe843783          	ld	a5,-24(s0)
 80008f6:	97b6                	add	a5,a5,a3
 80008f8:	00074703          	lbu	a4,0(a4)
 80008fc:	00e78023          	sb	a4,0(a5)
 8000900:	fe843783          	ld	a5,-24(s0)
 8000904:	0785                	add	a5,a5,1
 8000906:	fef43423          	sd	a5,-24(s0)
 800090a:	fe843703          	ld	a4,-24(s0)
 800090e:	fb843783          	ld	a5,-72(s0)
 8000912:	fcf769e3          	bltu	a4,a5,80008e4 <memcpy+0x2a>
 8000916:	fc843783          	ld	a5,-56(s0)
 800091a:	853e                	mv	a0,a5
 800091c:	60a6                	ld	ra,72(sp)
 800091e:	6406                	ld	s0,64(sp)
 8000920:	6161                	add	sp,sp,80
 8000922:	8082                	ret

0000000008000924 <__bswapsi2>:
 8000924:	1101                	add	sp,sp,-32
 8000926:	ec06                	sd	ra,24(sp)
 8000928:	e822                	sd	s0,16(sp)
 800092a:	1000                	add	s0,sp,32
 800092c:	87aa                	mv	a5,a0
 800092e:	fef42623          	sw	a5,-20(s0)
 8000932:	fec42783          	lw	a5,-20(s0)
 8000936:	0187d79b          	srlw	a5,a5,0x18
 800093a:	0007871b          	sext.w	a4,a5
 800093e:	fec42783          	lw	a5,-20(s0)
 8000942:	0087d79b          	srlw	a5,a5,0x8
 8000946:	2781                	sext.w	a5,a5
 8000948:	86be                	mv	a3,a5
 800094a:	67c1                	lui	a5,0x10
 800094c:	f0078793          	add	a5,a5,-256 # ff00 <_start-0x7ff0100>
 8000950:	8ff5                	and	a5,a5,a3
 8000952:	2781                	sext.w	a5,a5
 8000954:	8fd9                	or	a5,a5,a4
 8000956:	0007871b          	sext.w	a4,a5
 800095a:	fec42783          	lw	a5,-20(s0)
 800095e:	0087979b          	sllw	a5,a5,0x8
 8000962:	2781                	sext.w	a5,a5
 8000964:	86be                	mv	a3,a5
 8000966:	00ff07b7          	lui	a5,0xff0
 800096a:	8ff5                	and	a5,a5,a3
 800096c:	2781                	sext.w	a5,a5
 800096e:	8fd9                	or	a5,a5,a4
 8000970:	0007871b          	sext.w	a4,a5
 8000974:	fec42783          	lw	a5,-20(s0)
 8000978:	0187979b          	sllw	a5,a5,0x18
 800097c:	2781                	sext.w	a5,a5
 800097e:	8fd9                	or	a5,a5,a4
 8000980:	2781                	sext.w	a5,a5
 8000982:	853e                	mv	a0,a5
 8000984:	60e2                	ld	ra,24(sp)
 8000986:	6442                	ld	s0,16(sp)
 8000988:	6105                	add	sp,sp,32
 800098a:	8082                	ret

000000000800098c <delay_ms>:
 800098c:	1101                	add	sp,sp,-32
 800098e:	ec06                	sd	ra,24(sp)
 8000990:	e822                	sd	s0,16(sp)
 8000992:	1000                	add	s0,sp,32
 8000994:	87aa                	mv	a5,a0
 8000996:	fef42623          	sw	a5,-20(s0)
 800099a:	a031                	j	80009a6 <delay_ms+0x1a>
 800099c:	fec42783          	lw	a5,-20(s0)
 80009a0:	37fd                	addw	a5,a5,-1 # feffff <_start-0x7010001>
 80009a2:	fef42623          	sw	a5,-20(s0)
 80009a6:	fec42783          	lw	a5,-20(s0)
 80009aa:	2781                	sext.w	a5,a5
 80009ac:	fbe5                	bnez	a5,800099c <delay_ms+0x10>
 80009ae:	0001                	nop
 80009b0:	0001                	nop
 80009b2:	60e2                	ld	ra,24(sp)
 80009b4:	6442                	ld	s0,16(sp)
 80009b6:	6105                	add	sp,sp,32
 80009b8:	8082                	ret

00000000080009ba <caliptra1x_set_fuses>:
 80009ba:	7109                	add	sp,sp,-384
 80009bc:	fe86                	sd	ra,376(sp)
 80009be:	faa2                	sd	s0,368(sp)
 80009c0:	0300                	add	s0,sp,384
 80009c2:	e8a43423          	sd	a0,-376(s0)
 80009c6:	e8843783          	ld	a5,-376(s0)
 80009ca:	02078793          	add	a5,a5,32
 80009ce:	fef43423          	sd	a5,-24(s0)
 80009d2:	fe843783          	ld	a5,-24(s0)
 80009d6:	873e                	mv	a4,a5
 80009d8:	14c00793          	li	a5,332
 80009dc:	863e                	mv	a2,a5
 80009de:	4581                	li	a1,0
 80009e0:	853a                	mv	a0,a4
 80009e2:	e7bff0ef          	jal	800085c <memset>
 80009e6:	fe843783          	ld	a5,-24(s0)
 80009ea:	03000613          	li	a2,48
 80009ee:	00001597          	auipc	a1,0x1
 80009f2:	e9a58593          	add	a1,a1,-358 # 8001888 <default_uds_seed>
 80009f6:	853e                	mv	a0,a5
 80009f8:	ec3ff0ef          	jal	80008ba <memcpy>
 80009fc:	fe843783          	ld	a5,-24(s0)
 8000a00:	03078793          	add	a5,a5,48
 8000a04:	02000613          	li	a2,32
 8000a08:	00001597          	auipc	a1,0x1
 8000a0c:	eb058593          	add	a1,a1,-336 # 80018b8 <default_field_entropy>
 8000a10:	853e                	mv	a0,a5
 8000a12:	ea9ff0ef          	jal	80008ba <memcpy>
 8000a16:	fe843783          	ld	a5,-24(s0)
 8000a1a:	670d                	lui	a4,0x3
 8000a1c:	a4c70713          	add	a4,a4,-1460 # 2a4c <_start-0x7ffd5b4>
 8000a20:	14e79423          	sh	a4,328(a5)
 8000a24:	0001                	nop
 8000a26:	70f6                	ld	ra,376(sp)
 8000a28:	7456                	ld	s0,368(sp)
 8000a2a:	6119                	add	sp,sp,384
 8000a2c:	8082                	ret

0000000008000a2e <caliptra_bootfsm_go>:
 8000a2e:	1141                	add	sp,sp,-16
 8000a30:	e406                	sd	ra,8(sp)
 8000a32:	e022                	sd	s0,0(sp)
 8000a34:	0800                	add	s0,sp,16
 8000a36:	300307b7          	lui	a5,0x30030
 8000a3a:	0b878793          	add	a5,a5,184 # 300300b8 <itrng_entropy_repetition_count+0x2802e644>
 8000a3e:	4705                	li	a4,1
 8000a40:	c398                	sw	a4,0(a5)
 8000a42:	4781                	li	a5,0
 8000a44:	853e                	mv	a0,a5
 8000a46:	60a2                	ld	ra,8(sp)
 8000a48:	6402                	ld	s0,0(sp)
 8000a4a:	0141                	add	sp,sp,16
 8000a4c:	8082                	ret

0000000008000a4e <caliptra_read_status>:
 8000a4e:	1101                	add	sp,sp,-32
 8000a50:	ec06                	sd	ra,24(sp)
 8000a52:	e822                	sd	s0,16(sp)
 8000a54:	1000                	add	s0,sp,32
 8000a56:	300307b7          	lui	a5,0x30030
 8000a5a:	03c78793          	add	a5,a5,60 # 3003003c <itrng_entropy_repetition_count+0x2802e5c8>
 8000a5e:	439c                	lw	a5,0(a5)
 8000a60:	fef42623          	sw	a5,-20(s0)
 8000a64:	fec42783          	lw	a5,-20(s0)
 8000a68:	853e                	mv	a0,a5
 8000a6a:	60e2                	ld	ra,24(sp)
 8000a6c:	6442                	ld	s0,16(sp)
 8000a6e:	6105                	add	sp,sp,32
 8000a70:	8082                	ret

0000000008000a72 <caliptra_req_idev_csr_start>:
 8000a72:	1101                	add	sp,sp,-32
 8000a74:	ec06                	sd	ra,24(sp)
 8000a76:	e822                	sd	s0,16(sp)
 8000a78:	1000                	add	s0,sp,32
 8000a7a:	300307b7          	lui	a5,0x30030
 8000a7e:	0bc78793          	add	a5,a5,188 # 300300bc <itrng_entropy_repetition_count+0x2802e648>
 8000a82:	439c                	lw	a5,0(a5)
 8000a84:	fef42623          	sw	a5,-20(s0)
 8000a88:	300307b7          	lui	a5,0x30030
 8000a8c:	0bc78793          	add	a5,a5,188 # 300300bc <itrng_entropy_repetition_count+0x2802e648>
 8000a90:	fec42703          	lw	a4,-20(s0)
 8000a94:	00176713          	or	a4,a4,1
 8000a98:	2701                	sext.w	a4,a4
 8000a9a:	c398                	sw	a4,0(a5)
 8000a9c:	0001                	nop
 8000a9e:	60e2                	ld	ra,24(sp)
 8000aa0:	6442                	ld	s0,16(sp)
 8000aa2:	6105                	add	sp,sp,32
 8000aa4:	8082                	ret

0000000008000aa6 <caliptra_configure_itrng_entropy>:
 8000aa6:	1101                	add	sp,sp,-32
 8000aa8:	ec06                	sd	ra,24(sp)
 8000aaa:	e822                	sd	s0,16(sp)
 8000aac:	1000                	add	s0,sp,32
 8000aae:	87aa                	mv	a5,a0
 8000ab0:	86ae                	mv	a3,a1
 8000ab2:	8732                	mv	a4,a2
 8000ab4:	fef41723          	sh	a5,-18(s0)
 8000ab8:	87b6                	mv	a5,a3
 8000aba:	fef41623          	sh	a5,-20(s0)
 8000abe:	87ba                	mv	a5,a4
 8000ac0:	fef41523          	sh	a5,-22(s0)
 8000ac4:	fee45783          	lhu	a5,-18(s0)
 8000ac8:	853e                	mv	a0,a5
 8000aca:	c99ff0ef          	jal	8000762 <caliptra_write_itrng_entropy_low_threshold>
 8000ace:	fec45783          	lhu	a5,-20(s0)
 8000ad2:	853e                	mv	a0,a5
 8000ad4:	ce1ff0ef          	jal	80007b4 <caliptra_write_itrng_entropy_high_threshold>
 8000ad8:	fea45783          	lhu	a5,-22(s0)
 8000adc:	853e                	mv	a0,a5
 8000ade:	d2dff0ef          	jal	800080a <caliptra_write_itrng_entropy_repetition_count>
 8000ae2:	0001                	nop
 8000ae4:	60e2                	ld	ra,24(sp)
 8000ae6:	6442                	ld	s0,16(sp)
 8000ae8:	6105                	add	sp,sp,32
 8000aea:	8082                	ret

0000000008000aec <caliptra_set_wdt_timeout>:
 8000aec:	1101                	add	sp,sp,-32
 8000aee:	ec06                	sd	ra,24(sp)
 8000af0:	e822                	sd	s0,16(sp)
 8000af2:	1000                	add	s0,sp,32
 8000af4:	fea43423          	sd	a0,-24(s0)
 8000af8:	fe843503          	ld	a0,-24(s0)
 8000afc:	c2fff0ef          	jal	800072a <caliptra_wdt_cfg_write>
 8000b00:	0001                	nop
 8000b02:	60e2                	ld	ra,24(sp)
 8000b04:	6442                	ld	s0,16(sp)
 8000b06:	6105                	add	sp,sp,32
 8000b08:	8082                	ret

0000000008000b0a <caliptra_ready_for_fuses>:
 8000b0a:	1101                	add	sp,sp,-32
 8000b0c:	ec06                	sd	ra,24(sp)
 8000b0e:	e822                	sd	s0,16(sp)
 8000b10:	1000                	add	s0,sp,32
 8000b12:	300307b7          	lui	a5,0x30030
 8000b16:	03c78793          	add	a5,a5,60 # 3003003c <itrng_entropy_repetition_count+0x2802e5c8>
 8000b1a:	439c                	lw	a5,0(a5)
 8000b1c:	fef42623          	sw	a5,-20(s0)
 8000b20:	fec42783          	lw	a5,-20(s0)
 8000b24:	873e                	mv	a4,a5
 8000b26:	400007b7          	lui	a5,0x40000
 8000b2a:	8ff9                	and	a5,a5,a4
 8000b2c:	2781                	sext.w	a5,a5
 8000b2e:	c399                	beqz	a5,8000b34 <caliptra_ready_for_fuses+0x2a>
 8000b30:	4785                	li	a5,1
 8000b32:	a011                	j	8000b36 <caliptra_ready_for_fuses+0x2c>
 8000b34:	4781                	li	a5,0
 8000b36:	853e                	mv	a0,a5
 8000b38:	60e2                	ld	ra,24(sp)
 8000b3a:	6442                	ld	s0,16(sp)
 8000b3c:	6105                	add	sp,sp,32
 8000b3e:	8082                	ret

0000000008000b40 <caliptra_init_fuses>:
 8000b40:	1101                	add	sp,sp,-32
 8000b42:	ec06                	sd	ra,24(sp)
 8000b44:	e822                	sd	s0,16(sp)
 8000b46:	1000                	add	s0,sp,32
 8000b48:	fea43423          	sd	a0,-24(s0)
 8000b4c:	fe843783          	ld	a5,-24(s0)
 8000b50:	e781                	bnez	a5,8000b58 <caliptra_init_fuses+0x18>
 8000b52:	10000793          	li	a5,256
 8000b56:	a08d                	j	8000bb8 <caliptra_init_fuses+0x78>
 8000b58:	fe843783          	ld	a5,-24(s0)
 8000b5c:	4631                	li	a2,12
 8000b5e:	85be                	mv	a1,a5
 8000b60:	20000513          	li	a0,512
 8000b64:	b5fff0ef          	jal	80006c2 <caliptra_fuse_array_write>
 8000b68:	fe843783          	ld	a5,-24(s0)
 8000b6c:	03078793          	add	a5,a5,48 # 40000030 <itrng_entropy_repetition_count+0x37ffe5bc>
 8000b70:	4621                	li	a2,8
 8000b72:	85be                	mv	a1,a5
 8000b74:	23000513          	li	a0,560
 8000b78:	b4bff0ef          	jal	80006c2 <caliptra_fuse_array_write>
 8000b7c:	fe843783          	ld	a5,-24(s0)
 8000b80:	1487d783          	lhu	a5,328(a5)
 8000b84:	2781                	sext.w	a5,a5
 8000b86:	85be                	mv	a1,a5
 8000b88:	34800513          	li	a0,840
 8000b8c:	afdff0ef          	jal	8000688 <caliptra_generic_and_fuse_write>
 8000b90:	300307b7          	lui	a5,0x30030
 8000b94:	0b078793          	add	a5,a5,176 # 300300b0 <itrng_entropy_repetition_count+0x2802e63c>
 8000b98:	4705                	li	a4,1
 8000b9a:	c398                	sw	a4,0(a5)
 8000b9c:	f6fff0ef          	jal	8000b0a <caliptra_ready_for_fuses>
 8000ba0:	87aa                	mv	a5,a0
 8000ba2:	cb91                	beqz	a5,8000bb6 <caliptra_init_fuses+0x76>
 8000ba4:	00001517          	auipc	a0,0x1
 8000ba8:	d3450513          	add	a0,a0,-716 # 80018d8 <default_field_entropy+0x20>
 8000bac:	86fff0ef          	jal	800041a <kprintf>
 8000bb0:	20100793          	li	a5,513
 8000bb4:	a011                	j	8000bb8 <caliptra_init_fuses+0x78>
 8000bb6:	4781                	li	a5,0
 8000bb8:	853e                	mv	a0,a5
 8000bba:	60e2                	ld	ra,24(sp)
 8000bbc:	6442                	ld	s0,16(sp)
 8000bbe:	6105                	add	sp,sp,32
 8000bc0:	8082                	ret

0000000008000bc2 <caliptra_ready_for_firmware>:
 8000bc2:	1101                	add	sp,sp,-32
 8000bc4:	ec06                	sd	ra,24(sp)
 8000bc6:	e822                	sd	s0,16(sp)
 8000bc8:	1000                	add	s0,sp,32
 8000bca:	fe0407a3          	sb	zero,-17(s0)
 8000bce:	e81ff0ef          	jal	8000a4e <caliptra_read_status>
 8000bd2:	87aa                	mv	a5,a0
 8000bd4:	fef42423          	sw	a5,-24(s0)
 8000bd8:	fe842783          	lw	a5,-24(s0)
 8000bdc:	873e                	mv	a4,a5
 8000bde:	100007b7          	lui	a5,0x10000
 8000be2:	8ff9                	and	a5,a5,a4
 8000be4:	2781                	sext.w	a5,a5
 8000be6:	c789                	beqz	a5,8000bf0 <caliptra_ready_for_firmware+0x2e>
 8000be8:	4785                	li	a5,1
 8000bea:	fef407a3          	sb	a5,-17(s0)
 8000bee:	a029                	j	8000bf8 <caliptra_ready_for_firmware+0x36>
 8000bf0:	3e800513          	li	a0,1000
 8000bf4:	d99ff0ef          	jal	800098c <delay_ms>
 8000bf8:	fef44783          	lbu	a5,-17(s0)
 8000bfc:	0017c793          	xor	a5,a5,1
 8000c00:	0ff7f793          	zext.b	a5,a5
 8000c04:	f7e9                	bnez	a5,8000bce <caliptra_ready_for_firmware+0xc>
 8000c06:	4785                	li	a5,1
 8000c08:	853e                	mv	a0,a5
 8000c0a:	60e2                	ld	ra,24(sp)
 8000c0c:	6442                	ld	s0,16(sp)
 8000c0e:	6105                	add	sp,sp,32
 8000c10:	8082                	ret

0000000008000c12 <caliptra1x_drv_init>:
 8000c12:	7179                	add	sp,sp,-48
 8000c14:	f406                	sd	ra,40(sp)
 8000c16:	f022                	sd	s0,32(sp)
 8000c18:	1800                	add	s0,sp,48
 8000c1a:	fca43c23          	sd	a0,-40(s0)
 8000c1e:	87ae                	mv	a5,a1
 8000c20:	fcf40ba3          	sb	a5,-41(s0)
 8000c24:	fe042623          	sw	zero,-20(s0)
 8000c28:	fd744783          	lbu	a5,-41(s0)
 8000c2c:	0ff7f793          	zext.b	a5,a5
 8000c30:	c399                	beqz	a5,8000c36 <caliptra1x_drv_init+0x24>
 8000c32:	e41ff0ef          	jal	8000a72 <caliptra_req_idev_csr_start>
 8000c36:	4795                	li	a5,5
 8000c38:	07f6                	sll	a5,a5,0x1d
 8000c3a:	853e                	mv	a0,a5
 8000c3c:	eb1ff0ef          	jal	8000aec <caliptra_set_wdt_timeout>
 8000c40:	4705                	li	a4,1
 8000c42:	67c1                	lui	a5,0x10
 8000c44:	fff78693          	add	a3,a5,-1 # ffff <_start-0x7ff0001>
 8000c48:	67c1                	lui	a5,0x10
 8000c4a:	17fd                	add	a5,a5,-1 # ffff <_start-0x7ff0001>
 8000c4c:	863e                	mv	a2,a5
 8000c4e:	85b6                	mv	a1,a3
 8000c50:	853a                	mv	a0,a4
 8000c52:	e55ff0ef          	jal	8000aa6 <caliptra_configure_itrng_entropy>
 8000c56:	fd843783          	ld	a5,-40(s0)
 8000c5a:	02078793          	add	a5,a5,32
 8000c5e:	853e                	mv	a0,a5
 8000c60:	ee1ff0ef          	jal	8000b40 <caliptra_init_fuses>
 8000c64:	87aa                	mv	a5,a0
 8000c66:	fef42623          	sw	a5,-20(s0)
 8000c6a:	fec42783          	lw	a5,-20(s0)
 8000c6e:	2781                	sext.w	a5,a5
 8000c70:	cf89                	beqz	a5,8000c8a <caliptra1x_drv_init+0x78>
 8000c72:	fec42783          	lw	a5,-20(s0)
 8000c76:	85be                	mv	a1,a5
 8000c78:	00001517          	auipc	a0,0x1
 8000c7c:	c6850513          	add	a0,a0,-920 # 80018e0 <default_field_entropy+0x28>
 8000c80:	f9aff0ef          	jal	800041a <kprintf>
 8000c84:	fec42783          	lw	a5,-20(s0)
 8000c88:	a029                	j	8000c92 <caliptra1x_drv_init+0x80>
 8000c8a:	da5ff0ef          	jal	8000a2e <caliptra_bootfsm_go>
 8000c8e:	fec42783          	lw	a5,-20(s0)
 8000c92:	853e                	mv	a0,a5
 8000c94:	70a2                	ld	ra,40(sp)
 8000c96:	7402                	ld	s0,32(sp)
 8000c98:	6145                	add	sp,sp,48
 8000c9a:	8082                	ret

0000000008000c9c <delay_ms>:
 8000c9c:	1101                	add	sp,sp,-32
 8000c9e:	ec06                	sd	ra,24(sp)
 8000ca0:	e822                	sd	s0,16(sp)
 8000ca2:	1000                	add	s0,sp,32
 8000ca4:	87aa                	mv	a5,a0
 8000ca6:	fef42623          	sw	a5,-20(s0)
 8000caa:	a031                	j	8000cb6 <delay_ms+0x1a>
 8000cac:	fec42783          	lw	a5,-20(s0)
 8000cb0:	37fd                	addw	a5,a5,-1
 8000cb2:	fef42623          	sw	a5,-20(s0)
 8000cb6:	fec42783          	lw	a5,-20(s0)
 8000cba:	2781                	sext.w	a5,a5
 8000cbc:	fbe5                	bnez	a5,8000cac <delay_ms+0x10>
 8000cbe:	0001                	nop
 8000cc0:	0001                	nop
 8000cc2:	60e2                	ld	ra,24(sp)
 8000cc4:	6442                	ld	s0,16(sp)
 8000cc6:	6105                	add	sp,sp,32
 8000cc8:	8082                	ret

0000000008000cca <caliptra_mbox_write>:
 8000cca:	1101                	add	sp,sp,-32
 8000ccc:	ec06                	sd	ra,24(sp)
 8000cce:	e822                	sd	s0,16(sp)
 8000cd0:	1000                	add	s0,sp,32
 8000cd2:	87aa                	mv	a5,a0
 8000cd4:	872e                	mv	a4,a1
 8000cd6:	fef42623          	sw	a5,-20(s0)
 8000cda:	87ba                	mv	a5,a4
 8000cdc:	fef42423          	sw	a5,-24(s0)
 8000ce0:	fec42783          	lw	a5,-20(s0)
 8000ce4:	873e                	mv	a4,a5
 8000ce6:	300207b7          	lui	a5,0x30020
 8000cea:	9fb9                	addw	a5,a5,a4
 8000cec:	2781                	sext.w	a5,a5
 8000cee:	1782                	sll	a5,a5,0x20
 8000cf0:	9381                	srl	a5,a5,0x20
 8000cf2:	873e                	mv	a4,a5
 8000cf4:	fe842783          	lw	a5,-24(s0)
 8000cf8:	c31c                	sw	a5,0(a4)
 8000cfa:	0001                	nop
 8000cfc:	60e2                	ld	ra,24(sp)
 8000cfe:	6442                	ld	s0,16(sp)
 8000d00:	6105                	add	sp,sp,32
 8000d02:	8082                	ret

0000000008000d04 <caliptra_mbox_read>:
 8000d04:	7179                	add	sp,sp,-48
 8000d06:	f406                	sd	ra,40(sp)
 8000d08:	f022                	sd	s0,32(sp)
 8000d0a:	1800                	add	s0,sp,48
 8000d0c:	87aa                	mv	a5,a0
 8000d0e:	fcf42e23          	sw	a5,-36(s0)
 8000d12:	fdc42783          	lw	a5,-36(s0)
 8000d16:	873e                	mv	a4,a5
 8000d18:	300207b7          	lui	a5,0x30020
 8000d1c:	9fb9                	addw	a5,a5,a4
 8000d1e:	2781                	sext.w	a5,a5
 8000d20:	1782                	sll	a5,a5,0x20
 8000d22:	9381                	srl	a5,a5,0x20
 8000d24:	439c                	lw	a5,0(a5)
 8000d26:	fef42623          	sw	a5,-20(s0)
 8000d2a:	fec42783          	lw	a5,-20(s0)
 8000d2e:	853e                	mv	a0,a5
 8000d30:	70a2                	ld	ra,40(sp)
 8000d32:	7402                	ld	s0,32(sp)
 8000d34:	6145                	add	sp,sp,48
 8000d36:	8082                	ret

0000000008000d38 <caliptra_mbox_is_lock>:
 8000d38:	1141                	add	sp,sp,-16
 8000d3a:	e406                	sd	ra,8(sp)
 8000d3c:	e022                	sd	s0,0(sp)
 8000d3e:	0800                	add	s0,sp,16
 8000d40:	4501                	li	a0,0
 8000d42:	fc3ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000d46:	87aa                	mv	a5,a0
 8000d48:	8b85                	and	a5,a5,1
 8000d4a:	2781                	sext.w	a5,a5
 8000d4c:	00f037b3          	snez	a5,a5
 8000d50:	0ff7f793          	zext.b	a5,a5
 8000d54:	853e                	mv	a0,a5
 8000d56:	60a2                	ld	ra,8(sp)
 8000d58:	6402                	ld	s0,0(sp)
 8000d5a:	0141                	add	sp,sp,16
 8000d5c:	8082                	ret

0000000008000d5e <caliptra_mbox_write_cmd>:
 8000d5e:	1101                	add	sp,sp,-32
 8000d60:	ec06                	sd	ra,24(sp)
 8000d62:	e822                	sd	s0,16(sp)
 8000d64:	1000                	add	s0,sp,32
 8000d66:	87aa                	mv	a5,a0
 8000d68:	fef42623          	sw	a5,-20(s0)
 8000d6c:	fec42783          	lw	a5,-20(s0)
 8000d70:	85be                	mv	a1,a5
 8000d72:	4521                	li	a0,8
 8000d74:	f57ff0ef          	jal	8000cca <caliptra_mbox_write>
 8000d78:	0001                	nop
 8000d7a:	60e2                	ld	ra,24(sp)
 8000d7c:	6442                	ld	s0,16(sp)
 8000d7e:	6105                	add	sp,sp,32
 8000d80:	8082                	ret

0000000008000d82 <caliptra_mbox_read_execute>:
 8000d82:	1141                	add	sp,sp,-16
 8000d84:	e406                	sd	ra,8(sp)
 8000d86:	e022                	sd	s0,0(sp)
 8000d88:	0800                	add	s0,sp,16
 8000d8a:	4561                	li	a0,24
 8000d8c:	f79ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000d90:	87aa                	mv	a5,a0
 8000d92:	853e                	mv	a0,a5
 8000d94:	60a2                	ld	ra,8(sp)
 8000d96:	6402                	ld	s0,0(sp)
 8000d98:	0141                	add	sp,sp,16
 8000d9a:	8082                	ret

0000000008000d9c <caliptra_mbox_write_execute>:
 8000d9c:	1101                	add	sp,sp,-32
 8000d9e:	ec06                	sd	ra,24(sp)
 8000da0:	e822                	sd	s0,16(sp)
 8000da2:	1000                	add	s0,sp,32
 8000da4:	87aa                	mv	a5,a0
 8000da6:	fef407a3          	sb	a5,-17(s0)
 8000daa:	fef44783          	lbu	a5,-17(s0)
 8000dae:	2781                	sext.w	a5,a5
 8000db0:	85be                	mv	a1,a5
 8000db2:	4561                	li	a0,24
 8000db4:	f17ff0ef          	jal	8000cca <caliptra_mbox_write>
 8000db8:	0001                	nop
 8000dba:	60e2                	ld	ra,24(sp)
 8000dbc:	6442                	ld	s0,16(sp)
 8000dbe:	6105                	add	sp,sp,32
 8000dc0:	8082                	ret

0000000008000dc2 <caliptra_mbox_read_status>:
 8000dc2:	1141                	add	sp,sp,-16
 8000dc4:	e406                	sd	ra,8(sp)
 8000dc6:	e022                	sd	s0,0(sp)
 8000dc8:	0800                	add	s0,sp,16
 8000dca:	4571                	li	a0,28
 8000dcc:	f39ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000dd0:	87aa                	mv	a5,a0
 8000dd2:	0ff7f793          	zext.b	a5,a5
 8000dd6:	8bbd                	and	a5,a5,15
 8000dd8:	0ff7f793          	zext.b	a5,a5
 8000ddc:	853e                	mv	a0,a5
 8000dde:	60a2                	ld	ra,8(sp)
 8000de0:	6402                	ld	s0,0(sp)
 8000de2:	0141                	add	sp,sp,16
 8000de4:	8082                	ret

0000000008000de6 <caliptra_mbox_is_busy>:
 8000de6:	1141                	add	sp,sp,-16
 8000de8:	e406                	sd	ra,8(sp)
 8000dea:	e022                	sd	s0,0(sp)
 8000dec:	0800                	add	s0,sp,16
 8000dee:	fd5ff0ef          	jal	8000dc2 <caliptra_mbox_read_status>
 8000df2:	87aa                	mv	a5,a0
 8000df4:	2781                	sext.w	a5,a5
 8000df6:	0017b793          	seqz	a5,a5
 8000dfa:	0ff7f793          	zext.b	a5,a5
 8000dfe:	853e                	mv	a0,a5
 8000e00:	60a2                	ld	ra,8(sp)
 8000e02:	6402                	ld	s0,0(sp)
 8000e04:	0141                	add	sp,sp,16
 8000e06:	8082                	ret

0000000008000e08 <caliptra_mbox_read_status_fsm>:
 8000e08:	1141                	add	sp,sp,-16
 8000e0a:	e406                	sd	ra,8(sp)
 8000e0c:	e022                	sd	s0,0(sp)
 8000e0e:	0800                	add	s0,sp,16
 8000e10:	4571                	li	a0,28
 8000e12:	ef3ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000e16:	87aa                	mv	a5,a0
 8000e18:	0ff7f793          	zext.b	a5,a5
 8000e1c:	2781                	sext.w	a5,a5
 8000e1e:	4067d79b          	sraw	a5,a5,0x6
 8000e22:	2781                	sext.w	a5,a5
 8000e24:	0ff7f793          	zext.b	a5,a5
 8000e28:	8b8d                	and	a5,a5,3
 8000e2a:	0ff7f793          	zext.b	a5,a5
 8000e2e:	853e                	mv	a0,a5
 8000e30:	60a2                	ld	ra,8(sp)
 8000e32:	6402                	ld	s0,0(sp)
 8000e34:	0141                	add	sp,sp,16
 8000e36:	8082                	ret

0000000008000e38 <caliptra_mbox_read_dlen>:
 8000e38:	1141                	add	sp,sp,-16
 8000e3a:	e406                	sd	ra,8(sp)
 8000e3c:	e022                	sd	s0,0(sp)
 8000e3e:	0800                	add	s0,sp,16
 8000e40:	4531                	li	a0,12
 8000e42:	ec3ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000e46:	87aa                	mv	a5,a0
 8000e48:	853e                	mv	a0,a5
 8000e4a:	60a2                	ld	ra,8(sp)
 8000e4c:	6402                	ld	s0,0(sp)
 8000e4e:	0141                	add	sp,sp,16
 8000e50:	8082                	ret

0000000008000e52 <caliptra_mbox_write_dlen>:
 8000e52:	1101                	add	sp,sp,-32
 8000e54:	ec06                	sd	ra,24(sp)
 8000e56:	e822                	sd	s0,16(sp)
 8000e58:	1000                	add	s0,sp,32
 8000e5a:	87aa                	mv	a5,a0
 8000e5c:	fef42623          	sw	a5,-20(s0)
 8000e60:	fec42783          	lw	a5,-20(s0)
 8000e64:	85be                	mv	a1,a5
 8000e66:	4531                	li	a0,12
 8000e68:	e63ff0ef          	jal	8000cca <caliptra_mbox_write>
 8000e6c:	0001                	nop
 8000e6e:	60e2                	ld	ra,24(sp)
 8000e70:	6442                	ld	s0,16(sp)
 8000e72:	6105                	add	sp,sp,32
 8000e74:	8082                	ret

0000000008000e76 <caliptra_mailbox_write_fifo>:
 8000e76:	7139                	add	sp,sp,-64
 8000e78:	fc06                	sd	ra,56(sp)
 8000e7a:	f822                	sd	s0,48(sp)
 8000e7c:	0080                	add	s0,sp,64
 8000e7e:	fca43423          	sd	a0,-56(s0)
 8000e82:	fc843783          	ld	a5,-56(s0)
 8000e86:	e781                	bnez	a5,8000e8e <caliptra_mailbox_write_fifo+0x18>
 8000e88:	10000793          	li	a5,256
 8000e8c:	a079                	j	8000f1a <caliptra_mailbox_write_fifo+0xa4>
 8000e8e:	fc843783          	ld	a5,-56(s0)
 8000e92:	679c                	ld	a5,8(a5)
 8000e94:	e399                	bnez	a5,8000e9a <caliptra_mailbox_write_fifo+0x24>
 8000e96:	4781                	li	a5,0
 8000e98:	a049                	j	8000f1a <caliptra_mailbox_write_fifo+0xa4>
 8000e9a:	fc843783          	ld	a5,-56(s0)
 8000e9e:	639c                	ld	a5,0(a5)
 8000ea0:	e781                	bnez	a5,8000ea8 <caliptra_mailbox_write_fifo+0x32>
 8000ea2:	10000793          	li	a5,256
 8000ea6:	a895                	j	8000f1a <caliptra_mailbox_write_fifo+0xa4>
 8000ea8:	fc843783          	ld	a5,-56(s0)
 8000eac:	679c                	ld	a5,8(a5)
 8000eae:	fef42623          	sw	a5,-20(s0)
 8000eb2:	fc843783          	ld	a5,-56(s0)
 8000eb6:	639c                	ld	a5,0(a5)
 8000eb8:	fef43023          	sd	a5,-32(s0)
 8000ebc:	a00d                	j	8000ede <caliptra_mailbox_write_fifo+0x68>
 8000ebe:	fe043783          	ld	a5,-32(s0)
 8000ec2:	00478713          	add	a4,a5,4 # 30020004 <itrng_entropy_repetition_count+0x2801e590>
 8000ec6:	fee43023          	sd	a4,-32(s0)
 8000eca:	439c                	lw	a5,0(a5)
 8000ecc:	85be                	mv	a1,a5
 8000ece:	4541                	li	a0,16
 8000ed0:	dfbff0ef          	jal	8000cca <caliptra_mbox_write>
 8000ed4:	fec42783          	lw	a5,-20(s0)
 8000ed8:	37f1                	addw	a5,a5,-4
 8000eda:	fef42623          	sw	a5,-20(s0)
 8000ede:	fec42783          	lw	a5,-20(s0)
 8000ee2:	2781                	sext.w	a5,a5
 8000ee4:	873e                	mv	a4,a5
 8000ee6:	4791                	li	a5,4
 8000ee8:	fce7ebe3          	bltu	a5,a4,8000ebe <caliptra_mailbox_write_fifo+0x48>
 8000eec:	fec42783          	lw	a5,-20(s0)
 8000ef0:	2781                	sext.w	a5,a5
 8000ef2:	c39d                	beqz	a5,8000f18 <caliptra_mailbox_write_fifo+0xa2>
 8000ef4:	fc042e23          	sw	zero,-36(s0)
 8000ef8:	fec46703          	lwu	a4,-20(s0)
 8000efc:	fdc40793          	add	a5,s0,-36
 8000f00:	863a                	mv	a2,a4
 8000f02:	fe043583          	ld	a1,-32(s0)
 8000f06:	853e                	mv	a0,a5
 8000f08:	9b3ff0ef          	jal	80008ba <memcpy>
 8000f0c:	fdc42783          	lw	a5,-36(s0)
 8000f10:	85be                	mv	a1,a5
 8000f12:	4541                	li	a0,16
 8000f14:	db7ff0ef          	jal	8000cca <caliptra_mbox_write>
 8000f18:	4781                	li	a5,0
 8000f1a:	853e                	mv	a0,a5
 8000f1c:	70e2                	ld	ra,56(sp)
 8000f1e:	7442                	ld	s0,48(sp)
 8000f20:	6121                	add	sp,sp,64
 8000f22:	8082                	ret

0000000008000f24 <caliptra_mailbox_read_fifo>:
 8000f24:	715d                	add	sp,sp,-80
 8000f26:	e486                	sd	ra,72(sp)
 8000f28:	e0a2                	sd	s0,64(sp)
 8000f2a:	fc26                	sd	s1,56(sp)
 8000f2c:	0880                	add	s0,sp,80
 8000f2e:	faa43c23          	sd	a0,-72(s0)
 8000f32:	fab43823          	sd	a1,-80(s0)
 8000f36:	f03ff0ef          	jal	8000e38 <caliptra_mbox_read_dlen>
 8000f3a:	87aa                	mv	a5,a0
 8000f3c:	fcf42e23          	sw	a5,-36(s0)
 8000f40:	fb843783          	ld	a5,-72(s0)
 8000f44:	e781                	bnez	a5,8000f4c <caliptra_mailbox_read_fifo+0x28>
 8000f46:	10000793          	li	a5,256
 8000f4a:	a0d1                	j	800100e <caliptra_mailbox_read_fifo+0xea>
 8000f4c:	fb043783          	ld	a5,-80(s0)
 8000f50:	c789                	beqz	a5,8000f5a <caliptra_mailbox_read_fifo+0x36>
 8000f52:	fb043783          	ld	a5,-80(s0)
 8000f56:	0007a023          	sw	zero,0(a5)
 8000f5a:	fb843783          	ld	a5,-72(s0)
 8000f5e:	6798                	ld	a4,8(a5)
 8000f60:	fdc46783          	lwu	a5,-36(s0)
 8000f64:	00f76663          	bltu	a4,a5,8000f70 <caliptra_mailbox_read_fifo+0x4c>
 8000f68:	fb843783          	ld	a5,-72(s0)
 8000f6c:	639c                	ld	a5,0(a5)
 8000f6e:	e781                	bnez	a5,8000f76 <caliptra_mailbox_read_fifo+0x52>
 8000f70:	10000793          	li	a5,256
 8000f74:	a869                	j	800100e <caliptra_mailbox_read_fifo+0xea>
 8000f76:	fb843783          	ld	a5,-72(s0)
 8000f7a:	639c                	ld	a5,0(a5)
 8000f7c:	fcf43823          	sd	a5,-48(s0)
 8000f80:	a82d                	j	8000fba <caliptra_mailbox_read_fifo+0x96>
 8000f82:	fd043483          	ld	s1,-48(s0)
 8000f86:	00448793          	add	a5,s1,4
 8000f8a:	fcf43823          	sd	a5,-48(s0)
 8000f8e:	4551                	li	a0,20
 8000f90:	d75ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000f94:	87aa                	mv	a5,a0
 8000f96:	c09c                	sw	a5,0(s1)
 8000f98:	fdc42783          	lw	a5,-36(s0)
 8000f9c:	37f1                	addw	a5,a5,-4
 8000f9e:	fcf42e23          	sw	a5,-36(s0)
 8000fa2:	fb043783          	ld	a5,-80(s0)
 8000fa6:	cb91                	beqz	a5,8000fba <caliptra_mailbox_read_fifo+0x96>
 8000fa8:	fb043783          	ld	a5,-80(s0)
 8000fac:	439c                	lw	a5,0(a5)
 8000fae:	2791                	addw	a5,a5,4
 8000fb0:	0007871b          	sext.w	a4,a5
 8000fb4:	fb043783          	ld	a5,-80(s0)
 8000fb8:	c398                	sw	a4,0(a5)
 8000fba:	fdc42783          	lw	a5,-36(s0)
 8000fbe:	2781                	sext.w	a5,a5
 8000fc0:	873e                	mv	a4,a5
 8000fc2:	478d                	li	a5,3
 8000fc4:	fae7efe3          	bltu	a5,a4,8000f82 <caliptra_mailbox_read_fifo+0x5e>
 8000fc8:	fdc42783          	lw	a5,-36(s0)
 8000fcc:	2781                	sext.w	a5,a5
 8000fce:	cf9d                	beqz	a5,800100c <caliptra_mailbox_read_fifo+0xe8>
 8000fd0:	4551                	li	a0,20
 8000fd2:	d33ff0ef          	jal	8000d04 <caliptra_mbox_read>
 8000fd6:	87aa                	mv	a5,a0
 8000fd8:	fcf42623          	sw	a5,-52(s0)
 8000fdc:	fdc46703          	lwu	a4,-36(s0)
 8000fe0:	fcc40793          	add	a5,s0,-52
 8000fe4:	863a                	mv	a2,a4
 8000fe6:	85be                	mv	a1,a5
 8000fe8:	fd043503          	ld	a0,-48(s0)
 8000fec:	8cfff0ef          	jal	80008ba <memcpy>
 8000ff0:	fb043783          	ld	a5,-80(s0)
 8000ff4:	cf81                	beqz	a5,800100c <caliptra_mailbox_read_fifo+0xe8>
 8000ff6:	fb043783          	ld	a5,-80(s0)
 8000ffa:	439c                	lw	a5,0(a5)
 8000ffc:	fdc42703          	lw	a4,-36(s0)
 8001000:	9fb9                	addw	a5,a5,a4
 8001002:	0007871b          	sext.w	a4,a5
 8001006:	fb043783          	ld	a5,-80(s0)
 800100a:	c398                	sw	a4,0(a5)
 800100c:	4781                	li	a5,0
 800100e:	853e                	mv	a0,a5
 8001010:	60a6                	ld	ra,72(sp)
 8001012:	6406                	ld	s0,64(sp)
 8001014:	74e2                	ld	s1,56(sp)
 8001016:	6161                	add	sp,sp,80
 8001018:	8082                	ret

000000000800101a <caliptra_check_status_get_response>:
 800101a:	7179                	add	sp,sp,-48
 800101c:	f406                	sd	ra,40(sp)
 800101e:	f022                	sd	s0,32(sp)
 8001020:	1800                	add	s0,sp,48
 8001022:	fca43c23          	sd	a0,-40(s0)
 8001026:	fcb43823          	sd	a1,-48(s0)
 800102a:	fd043783          	ld	a5,-48(s0)
 800102e:	e781                	bnez	a5,8001036 <caliptra_check_status_get_response+0x1c>
 8001030:	10100793          	li	a5,257
 8001034:	a8e5                	j	800112c <caliptra_check_status_get_response+0x112>
 8001036:	0b100613          	li	a2,177
 800103a:	00001597          	auipc	a1,0x1
 800103e:	92e58593          	add	a1,a1,-1746 # 8001968 <__func__.5>
 8001042:	00001517          	auipc	a0,0x1
 8001046:	90e50513          	add	a0,a0,-1778 # 8001950 <default_field_entropy+0x20>
 800104a:	bd0ff0ef          	jal	800041a <kprintf>
 800104e:	d75ff0ef          	jal	8000dc2 <caliptra_mbox_read_status>
 8001052:	87aa                	mv	a5,a0
 8001054:	fef407a3          	sb	a5,-17(s0)
 8001058:	0b400613          	li	a2,180
 800105c:	00001597          	auipc	a1,0x1
 8001060:	90c58593          	add	a1,a1,-1780 # 8001968 <__func__.5>
 8001064:	00001517          	auipc	a0,0x1
 8001068:	8ec50513          	add	a0,a0,-1812 # 8001950 <default_field_entropy+0x20>
 800106c:	baeff0ef          	jal	800041a <kprintf>
 8001070:	fef44783          	lbu	a5,-17(s0)
 8001074:	0ff7f713          	zext.b	a4,a5
 8001078:	478d                	li	a5,3
 800107a:	00f71863          	bne	a4,a5,800108a <caliptra_check_status_get_response+0x70>
 800107e:	4501                	li	a0,0
 8001080:	d1dff0ef          	jal	8000d9c <caliptra_mbox_write_execute>
 8001084:	30300793          	li	a5,771
 8001088:	a055                	j	800112c <caliptra_check_status_get_response+0x112>
 800108a:	fef44783          	lbu	a5,-17(s0)
 800108e:	0ff7f713          	zext.b	a4,a5
 8001092:	4789                	li	a5,2
 8001094:	00f71763          	bne	a4,a5,80010a2 <caliptra_check_status_get_response+0x88>
 8001098:	4501                	li	a0,0
 800109a:	d03ff0ef          	jal	8000d9c <caliptra_mbox_write_execute>
 800109e:	4781                	li	a5,0
 80010a0:	a071                	j	800112c <caliptra_check_status_get_response+0x112>
 80010a2:	fef44783          	lbu	a5,-17(s0)
 80010a6:	0ff7f793          	zext.b	a5,a5
 80010aa:	e781                	bnez	a5,80010b2 <caliptra_check_status_get_response+0x98>
 80010ac:	30400793          	li	a5,772
 80010b0:	a8b5                	j	800112c <caliptra_check_status_get_response+0x112>
 80010b2:	0c300613          	li	a2,195
 80010b6:	00001597          	auipc	a1,0x1
 80010ba:	8b258593          	add	a1,a1,-1870 # 8001968 <__func__.5>
 80010be:	00001517          	auipc	a0,0x1
 80010c2:	89250513          	add	a0,a0,-1902 # 8001950 <default_field_entropy+0x20>
 80010c6:	b54ff0ef          	jal	800041a <kprintf>
 80010ca:	fd043583          	ld	a1,-48(s0)
 80010ce:	fd843503          	ld	a0,-40(s0)
 80010d2:	e53ff0ef          	jal	8000f24 <caliptra_mailbox_read_fifo>
 80010d6:	87aa                	mv	a5,a0
 80010d8:	fef42423          	sw	a5,-24(s0)
 80010dc:	0c600613          	li	a2,198
 80010e0:	00001597          	auipc	a1,0x1
 80010e4:	88858593          	add	a1,a1,-1912 # 8001968 <__func__.5>
 80010e8:	00001517          	auipc	a0,0x1
 80010ec:	86850513          	add	a0,a0,-1944 # 8001950 <default_field_entropy+0x20>
 80010f0:	b2aff0ef          	jal	800041a <kprintf>
 80010f4:	4501                	li	a0,0
 80010f6:	ca7ff0ef          	jal	8000d9c <caliptra_mbox_write_execute>
 80010fa:	0c900613          	li	a2,201
 80010fe:	00001597          	auipc	a1,0x1
 8001102:	86a58593          	add	a1,a1,-1942 # 8001968 <__func__.5>
 8001106:	00001517          	auipc	a0,0x1
 800110a:	84a50513          	add	a0,a0,-1974 # 8001950 <default_field_entropy+0x20>
 800110e:	b0cff0ef          	jal	800041a <kprintf>
 8001112:	3e800513          	li	a0,1000
 8001116:	b87ff0ef          	jal	8000c9c <delay_ms>
 800111a:	cefff0ef          	jal	8000e08 <caliptra_mbox_read_status_fsm>
 800111e:	87aa                	mv	a5,a0
 8001120:	c781                	beqz	a5,8001128 <caliptra_check_status_get_response+0x10e>
 8001122:	30500793          	li	a5,773
 8001126:	a019                	j	800112c <caliptra_check_status_get_response+0x112>
 8001128:	fe842783          	lw	a5,-24(s0)
 800112c:	853e                	mv	a0,a5
 800112e:	70a2                	ld	ra,40(sp)
 8001130:	7402                	ld	s0,32(sp)
 8001132:	6145                	add	sp,sp,48
 8001134:	8082                	ret

0000000008001136 <calculate_caliptra_checksum>:
 8001136:	7179                	add	sp,sp,-48
 8001138:	f406                	sd	ra,40(sp)
 800113a:	f022                	sd	s0,32(sp)
 800113c:	1800                	add	s0,sp,48
 800113e:	87aa                	mv	a5,a0
 8001140:	fcb43823          	sd	a1,-48(s0)
 8001144:	8732                	mv	a4,a2
 8001146:	fcf42e23          	sw	a5,-36(s0)
 800114a:	87ba                	mv	a5,a4
 800114c:	fcf42c23          	sw	a5,-40(s0)
 8001150:	fe042423          	sw	zero,-24(s0)
 8001154:	fd043783          	ld	a5,-48(s0)
 8001158:	e799                	bnez	a5,8001166 <calculate_caliptra_checksum+0x30>
 800115a:	fd842783          	lw	a5,-40(s0)
 800115e:	2781                	sext.w	a5,a5
 8001160:	c399                	beqz	a5,8001166 <calculate_caliptra_checksum+0x30>
 8001162:	4781                	li	a5,0
 8001164:	a061                	j	80011ec <calculate_caliptra_checksum+0xb6>
 8001166:	fe042623          	sw	zero,-20(s0)
 800116a:	a01d                	j	8001190 <calculate_caliptra_checksum+0x5a>
 800116c:	fec46783          	lwu	a5,-20(s0)
 8001170:	fdc40713          	add	a4,s0,-36
 8001174:	97ba                	add	a5,a5,a4
 8001176:	0007c783          	lbu	a5,0(a5)
 800117a:	2781                	sext.w	a5,a5
 800117c:	fe842703          	lw	a4,-24(s0)
 8001180:	9fb9                	addw	a5,a5,a4
 8001182:	fef42423          	sw	a5,-24(s0)
 8001186:	fec42783          	lw	a5,-20(s0)
 800118a:	2785                	addw	a5,a5,1
 800118c:	fef42623          	sw	a5,-20(s0)
 8001190:	fec42783          	lw	a5,-20(s0)
 8001194:	2781                	sext.w	a5,a5
 8001196:	873e                	mv	a4,a5
 8001198:	478d                	li	a5,3
 800119a:	fce7f9e3          	bgeu	a5,a4,800116c <calculate_caliptra_checksum+0x36>
 800119e:	fe042623          	sw	zero,-20(s0)
 80011a2:	a01d                	j	80011c8 <calculate_caliptra_checksum+0x92>
 80011a4:	fec46783          	lwu	a5,-20(s0)
 80011a8:	fd043703          	ld	a4,-48(s0)
 80011ac:	97ba                	add	a5,a5,a4
 80011ae:	0007c783          	lbu	a5,0(a5)
 80011b2:	2781                	sext.w	a5,a5
 80011b4:	fe842703          	lw	a4,-24(s0)
 80011b8:	9fb9                	addw	a5,a5,a4
 80011ba:	fef42423          	sw	a5,-24(s0)
 80011be:	fec42783          	lw	a5,-20(s0)
 80011c2:	2785                	addw	a5,a5,1
 80011c4:	fef42623          	sw	a5,-20(s0)
 80011c8:	fec42783          	lw	a5,-20(s0)
 80011cc:	873e                	mv	a4,a5
 80011ce:	fd842783          	lw	a5,-40(s0)
 80011d2:	86be                	mv	a3,a5
 80011d4:	0007079b          	sext.w	a5,a4
 80011d8:	873e                	mv	a4,a5
 80011da:	0006879b          	sext.w	a5,a3
 80011de:	fcf763e3          	bltu	a4,a5,80011a4 <calculate_caliptra_checksum+0x6e>
 80011e2:	fe842783          	lw	a5,-24(s0)
 80011e6:	40f007bb          	negw	a5,a5
 80011ea:	2781                	sext.w	a5,a5
 80011ec:	853e                	mv	a0,a5
 80011ee:	70a2                	ld	ra,40(sp)
 80011f0:	7402                	ld	s0,32(sp)
 80011f2:	6145                	add	sp,sp,48
 80011f4:	8082                	ret

00000000080011f6 <caliptra_mailbox_send_start>:
 80011f6:	1101                	add	sp,sp,-32
 80011f8:	ec06                	sd	ra,24(sp)
 80011fa:	e822                	sd	s0,16(sp)
 80011fc:	1000                	add	s0,sp,32
 80011fe:	87aa                	mv	a5,a0
 8001200:	872e                	mv	a4,a1
 8001202:	fef42623          	sw	a5,-20(s0)
 8001206:	87ba                	mv	a5,a4
 8001208:	fef42423          	sw	a5,-24(s0)
 800120c:	fe842783          	lw	a5,-24(s0)
 8001210:	2781                	sext.w	a5,a5
 8001212:	873e                	mv	a4,a5
 8001214:	000207b7          	lui	a5,0x20
 8001218:	00e7f563          	bgeu	a5,a4,8001222 <caliptra_mailbox_send_start+0x2c>
 800121c:	10000793          	li	a5,256
 8001220:	a059                	j	80012a6 <caliptra_mailbox_send_start+0xb0>
 8001222:	12400613          	li	a2,292
 8001226:	00000597          	auipc	a1,0x0
 800122a:	76a58593          	add	a1,a1,1898 # 8001990 <__func__.4>
 800122e:	00000517          	auipc	a0,0x0
 8001232:	72250513          	add	a0,a0,1826 # 8001950 <default_field_entropy+0x20>
 8001236:	9e4ff0ef          	jal	800041a <kprintf>
 800123a:	affff0ef          	jal	8000d38 <caliptra_mbox_is_lock>
 800123e:	87aa                	mv	a5,a0
 8001240:	c781                	beqz	a5,8001248 <caliptra_mailbox_send_start+0x52>
 8001242:	30000793          	li	a5,768
 8001246:	a085                	j	80012a6 <caliptra_mailbox_send_start+0xb0>
 8001248:	12a00613          	li	a2,298
 800124c:	00000597          	auipc	a1,0x0
 8001250:	74458593          	add	a1,a1,1860 # 8001990 <__func__.4>
 8001254:	00000517          	auipc	a0,0x0
 8001258:	6fc50513          	add	a0,a0,1788 # 8001950 <default_field_entropy+0x20>
 800125c:	9beff0ef          	jal	800041a <kprintf>
 8001260:	fec42783          	lw	a5,-20(s0)
 8001264:	853e                	mv	a0,a5
 8001266:	af9ff0ef          	jal	8000d5e <caliptra_mbox_write_cmd>
 800126a:	12d00613          	li	a2,301
 800126e:	00000597          	auipc	a1,0x0
 8001272:	72258593          	add	a1,a1,1826 # 8001990 <__func__.4>
 8001276:	00000517          	auipc	a0,0x0
 800127a:	6da50513          	add	a0,a0,1754 # 8001950 <default_field_entropy+0x20>
 800127e:	99cff0ef          	jal	800041a <kprintf>
 8001282:	fe842783          	lw	a5,-24(s0)
 8001286:	853e                	mv	a0,a5
 8001288:	bcbff0ef          	jal	8000e52 <caliptra_mbox_write_dlen>
 800128c:	13000613          	li	a2,304
 8001290:	00000597          	auipc	a1,0x0
 8001294:	70058593          	add	a1,a1,1792 # 8001990 <__func__.4>
 8001298:	00000517          	auipc	a0,0x0
 800129c:	6b850513          	add	a0,a0,1720 # 8001950 <default_field_entropy+0x20>
 80012a0:	97aff0ef          	jal	800041a <kprintf>
 80012a4:	4781                	li	a5,0
 80012a6:	853e                	mv	a0,a5
 80012a8:	60e2                	ld	ra,24(sp)
 80012aa:	6442                	ld	s0,16(sp)
 80012ac:	6105                	add	sp,sp,32
 80012ae:	8082                	ret

00000000080012b0 <caliptra_mailbox_send_data>:
 80012b0:	1101                	add	sp,sp,-32
 80012b2:	ec06                	sd	ra,24(sp)
 80012b4:	e822                	sd	s0,16(sp)
 80012b6:	1000                	add	s0,sp,32
 80012b8:	fea43423          	sd	a0,-24(s0)
 80012bc:	fe843503          	ld	a0,-24(s0)
 80012c0:	bb7ff0ef          	jal	8000e76 <caliptra_mailbox_write_fifo>
 80012c4:	87aa                	mv	a5,a0
 80012c6:	853e                	mv	a0,a5
 80012c8:	60e2                	ld	ra,24(sp)
 80012ca:	6442                	ld	s0,16(sp)
 80012cc:	6105                	add	sp,sp,32
 80012ce:	8082                	ret

00000000080012d0 <caliptra_mailbox_send_complete>:
 80012d0:	7179                	add	sp,sp,-48
 80012d2:	f406                	sd	ra,40(sp)
 80012d4:	f022                	sd	s0,32(sp)
 80012d6:	1800                	add	s0,sp,48
 80012d8:	fca43c23          	sd	a0,-40(s0)
 80012dc:	87ae                	mv	a5,a1
 80012de:	fcf40ba3          	sb	a5,-41(s0)
 80012e2:	15200613          	li	a2,338
 80012e6:	00000597          	auipc	a1,0x0
 80012ea:	6ca58593          	add	a1,a1,1738 # 80019b0 <__func__.3>
 80012ee:	00000517          	auipc	a0,0x0
 80012f2:	66250513          	add	a0,a0,1634 # 8001950 <default_field_entropy+0x20>
 80012f6:	924ff0ef          	jal	800041a <kprintf>
 80012fa:	fd843783          	ld	a5,-40(s0)
 80012fe:	cb85                	beqz	a5,800132e <caliptra_mailbox_send_complete+0x5e>
 8001300:	7801f797          	auipc	a5,0x7801f
 8001304:	d6078793          	add	a5,a5,-672 # 80020060 <g_caliptra_mbox_pending_rx_buffer>
 8001308:	fd843703          	ld	a4,-40(s0)
 800130c:	6314                	ld	a3,0(a4)
 800130e:	e394                	sd	a3,0(a5)
 8001310:	6718                	ld	a4,8(a4)
 8001312:	e798                	sd	a4,8(a5)
 8001314:	15600613          	li	a2,342
 8001318:	00000597          	auipc	a1,0x0
 800131c:	69858593          	add	a1,a1,1688 # 80019b0 <__func__.3>
 8001320:	00000517          	auipc	a0,0x0
 8001324:	63050513          	add	a0,a0,1584 # 8001950 <default_field_entropy+0x20>
 8001328:	8f2ff0ef          	jal	800041a <kprintf>
 800132c:	a80d                	j	800135e <caliptra_mailbox_send_complete+0x8e>
 800132e:	7801f797          	auipc	a5,0x7801f
 8001332:	d3278793          	add	a5,a5,-718 # 80020060 <g_caliptra_mbox_pending_rx_buffer>
 8001336:	0007b023          	sd	zero,0(a5)
 800133a:	7801f797          	auipc	a5,0x7801f
 800133e:	d2678793          	add	a5,a5,-730 # 80020060 <g_caliptra_mbox_pending_rx_buffer>
 8001342:	0007b423          	sd	zero,8(a5)
 8001346:	15900613          	li	a2,345
 800134a:	00000597          	auipc	a1,0x0
 800134e:	66658593          	add	a1,a1,1638 # 80019b0 <__func__.3>
 8001352:	00000517          	auipc	a0,0x0
 8001356:	5fe50513          	add	a0,a0,1534 # 8001950 <default_field_entropy+0x20>
 800135a:	8c0ff0ef          	jal	800041a <kprintf>
 800135e:	15c00613          	li	a2,348
 8001362:	00000597          	auipc	a1,0x0
 8001366:	64e58593          	add	a1,a1,1614 # 80019b0 <__func__.3>
 800136a:	00000517          	auipc	a0,0x0
 800136e:	5e650513          	add	a0,a0,1510 # 8001950 <default_field_entropy+0x20>
 8001372:	8a8ff0ef          	jal	800041a <kprintf>
 8001376:	4505                	li	a0,1
 8001378:	a25ff0ef          	jal	8000d9c <caliptra_mbox_write_execute>
 800137c:	fd744783          	lbu	a5,-41(s0)
 8001380:	0ff7f793          	zext.b	a5,a5
 8001384:	cf99                	beqz	a5,80013a2 <caliptra_mailbox_send_complete+0xd2>
 8001386:	16000613          	li	a2,352
 800138a:	00000597          	auipc	a1,0x0
 800138e:	62658593          	add	a1,a1,1574 # 80019b0 <__func__.3>
 8001392:	00000517          	auipc	a0,0x0
 8001396:	5be50513          	add	a0,a0,1470 # 8001950 <default_field_entropy+0x20>
 800139a:	880ff0ef          	jal	800041a <kprintf>
 800139e:	4781                	li	a5,0
 80013a0:	a881                	j	80013f0 <caliptra_mailbox_send_complete+0x120>
 80013a2:	16400613          	li	a2,356
 80013a6:	00000597          	auipc	a1,0x0
 80013aa:	60a58593          	add	a1,a1,1546 # 80019b0 <__func__.3>
 80013ae:	00000517          	auipc	a0,0x0
 80013b2:	5a250513          	add	a0,a0,1442 # 8001950 <default_field_entropy+0x20>
 80013b6:	864ff0ef          	jal	800041a <kprintf>
 80013ba:	a021                	j	80013c2 <caliptra_mailbox_send_complete+0xf2>
 80013bc:	4529                	li	a0,10
 80013be:	8dfff0ef          	jal	8000c9c <delay_ms>
 80013c2:	1de000ef          	jal	80015a0 <caliptra_test_for_completion>
 80013c6:	87aa                	mv	a5,a0
 80013c8:	0017c793          	xor	a5,a5,1
 80013cc:	0ff7f793          	zext.b	a5,a5
 80013d0:	f7f5                	bnez	a5,80013bc <caliptra_mailbox_send_complete+0xec>
 80013d2:	16800613          	li	a2,360
 80013d6:	00000597          	auipc	a1,0x0
 80013da:	5da58593          	add	a1,a1,1498 # 80019b0 <__func__.3>
 80013de:	00000517          	auipc	a0,0x0
 80013e2:	57250513          	add	a0,a0,1394 # 8001950 <default_field_entropy+0x20>
 80013e6:	834ff0ef          	jal	800041a <kprintf>
 80013ea:	1e8000ef          	jal	80015d2 <caliptra_complete>
 80013ee:	87aa                	mv	a5,a0
 80013f0:	853e                	mv	a0,a5
 80013f2:	70a2                	ld	ra,40(sp)
 80013f4:	7402                	ld	s0,32(sp)
 80013f6:	6145                	add	sp,sp,48
 80013f8:	8082                	ret

00000000080013fa <caliptra_mailbox_execute>:
 80013fa:	7139                	add	sp,sp,-64
 80013fc:	fc06                	sd	ra,56(sp)
 80013fe:	f822                	sd	s0,48(sp)
 8001400:	0080                	add	s0,sp,64
 8001402:	87aa                	mv	a5,a0
 8001404:	fcb43823          	sd	a1,-48(s0)
 8001408:	fcc43423          	sd	a2,-56(s0)
 800140c:	8736                	mv	a4,a3
 800140e:	fcf42e23          	sw	a5,-36(s0)
 8001412:	87ba                	mv	a5,a4
 8001414:	fcf40da3          	sb	a5,-37(s0)
 8001418:	fd043783          	ld	a5,-48(s0)
 800141c:	679c                	ld	a5,8(a5)
 800141e:	0007871b          	sext.w	a4,a5
 8001422:	fdc42783          	lw	a5,-36(s0)
 8001426:	85ba                	mv	a1,a4
 8001428:	853e                	mv	a0,a5
 800142a:	dcdff0ef          	jal	80011f6 <caliptra_mailbox_send_start>
 800142e:	87aa                	mv	a5,a0
 8001430:	fef42623          	sw	a5,-20(s0)
 8001434:	fec42783          	lw	a5,-20(s0)
 8001438:	2781                	sext.w	a5,a5
 800143a:	c781                	beqz	a5,8001442 <caliptra_mailbox_execute+0x48>
 800143c:	fec42783          	lw	a5,-20(s0)
 8001440:	a8b9                	j	800149e <caliptra_mailbox_execute+0xa4>
 8001442:	17e00613          	li	a2,382
 8001446:	00000597          	auipc	a1,0x0
 800144a:	58a58593          	add	a1,a1,1418 # 80019d0 <__func__.2>
 800144e:	00000517          	auipc	a0,0x0
 8001452:	50250513          	add	a0,a0,1282 # 8001950 <default_field_entropy+0x20>
 8001456:	fc5fe0ef          	jal	800041a <kprintf>
 800145a:	fd043503          	ld	a0,-48(s0)
 800145e:	e53ff0ef          	jal	80012b0 <caliptra_mailbox_send_data>
 8001462:	87aa                	mv	a5,a0
 8001464:	fef42623          	sw	a5,-20(s0)
 8001468:	fec42783          	lw	a5,-20(s0)
 800146c:	2781                	sext.w	a5,a5
 800146e:	c781                	beqz	a5,8001476 <caliptra_mailbox_execute+0x7c>
 8001470:	fec42783          	lw	a5,-20(s0)
 8001474:	a02d                	j	800149e <caliptra_mailbox_execute+0xa4>
 8001476:	18400613          	li	a2,388
 800147a:	00000597          	auipc	a1,0x0
 800147e:	55658593          	add	a1,a1,1366 # 80019d0 <__func__.2>
 8001482:	00000517          	auipc	a0,0x0
 8001486:	4ce50513          	add	a0,a0,1230 # 8001950 <default_field_entropy+0x20>
 800148a:	f91fe0ef          	jal	800041a <kprintf>
 800148e:	fdb44783          	lbu	a5,-37(s0)
 8001492:	85be                	mv	a1,a5
 8001494:	fc843503          	ld	a0,-56(s0)
 8001498:	e39ff0ef          	jal	80012d0 <caliptra_mailbox_send_complete>
 800149c:	87aa                	mv	a5,a0
 800149e:	853e                	mv	a0,a5
 80014a0:	70e2                	ld	ra,56(sp)
 80014a2:	7442                	ld	s0,48(sp)
 80014a4:	6121                	add	sp,sp,64
 80014a6:	8082                	ret

00000000080014a8 <pack_and_execute_command>:
 80014a8:	715d                	add	sp,sp,-80
 80014aa:	e486                	sd	ra,72(sp)
 80014ac:	e0a2                	sd	s0,64(sp)
 80014ae:	fc26                	sd	s1,56(sp)
 80014b0:	0880                	add	s0,sp,80
 80014b2:	faa43c23          	sd	a0,-72(s0)
 80014b6:	87ae                	mv	a5,a1
 80014b8:	faf40ba3          	sb	a5,-73(s0)
 80014bc:	fb843783          	ld	a5,-72(s0)
 80014c0:	e781                	bnez	a5,80014c8 <pack_and_execute_command+0x20>
 80014c2:	10000793          	li	a5,256
 80014c6:	a0f9                	j	8001594 <pack_and_execute_command+0xec>
 80014c8:	19900613          	li	a2,409
 80014cc:	00000597          	auipc	a1,0x0
 80014d0:	52458593          	add	a1,a1,1316 # 80019f0 <__func__.1>
 80014d4:	00000517          	auipc	a0,0x0
 80014d8:	47c50513          	add	a0,a0,1148 # 8001950 <default_field_entropy+0x20>
 80014dc:	f3ffe0ef          	jal	800041a <kprintf>
 80014e0:	fb843783          	ld	a5,-72(s0)
 80014e4:	679c                	ld	a5,8(a5)
 80014e6:	c789                	beqz	a5,80014f0 <pack_and_execute_command+0x48>
 80014e8:	fb843783          	ld	a5,-72(s0)
 80014ec:	6f9c                	ld	a5,24(a5)
 80014ee:	e781                	bnez	a5,80014f6 <pack_and_execute_command+0x4e>
 80014f0:	10000793          	li	a5,256
 80014f4:	a045                	j	8001594 <pack_and_execute_command+0xec>
 80014f6:	1a100613          	li	a2,417
 80014fa:	00000597          	auipc	a1,0x0
 80014fe:	4f658593          	add	a1,a1,1270 # 80019f0 <__func__.1>
 8001502:	00000517          	auipc	a0,0x0
 8001506:	44e50513          	add	a0,a0,1102 # 8001950 <default_field_entropy+0x20>
 800150a:	f11fe0ef          	jal	800041a <kprintf>
 800150e:	fb843783          	ld	a5,-72(s0)
 8001512:	679c                	ld	a5,8(a5)
 8001514:	fcf43823          	sd	a5,-48(s0)
 8001518:	fb843783          	ld	a5,-72(s0)
 800151c:	6b9c                	ld	a5,16(a5)
 800151e:	fcf43c23          	sd	a5,-40(s0)
 8001522:	fb843783          	ld	a5,-72(s0)
 8001526:	6f9c                	ld	a5,24(a5)
 8001528:	fcf43023          	sd	a5,-64(s0)
 800152c:	fb843783          	ld	a5,-72(s0)
 8001530:	739c                	ld	a5,32(a5)
 8001532:	fcf43423          	sd	a5,-56(s0)
 8001536:	1ab00613          	li	a2,427
 800153a:	00000597          	auipc	a1,0x0
 800153e:	4b658593          	add	a1,a1,1206 # 80019f0 <__func__.1>
 8001542:	00000517          	auipc	a0,0x0
 8001546:	40e50513          	add	a0,a0,1038 # 8001950 <default_field_entropy+0x20>
 800154a:	ed1fe0ef          	jal	800041a <kprintf>
 800154e:	fd043783          	ld	a5,-48(s0)
 8001552:	0007a023          	sw	zero,0(a5)
 8001556:	fb843783          	ld	a5,-72(s0)
 800155a:	439c                	lw	a5,0(a5)
 800155c:	fd043703          	ld	a4,-48(s0)
 8001560:	fd843683          	ld	a3,-40(s0)
 8001564:	2681                	sext.w	a3,a3
 8001566:	fd043483          	ld	s1,-48(s0)
 800156a:	8636                	mv	a2,a3
 800156c:	85ba                	mv	a1,a4
 800156e:	853e                	mv	a0,a5
 8001570:	bc7ff0ef          	jal	8001136 <calculate_caliptra_checksum>
 8001574:	87aa                	mv	a5,a0
 8001576:	c09c                	sw	a5,0(s1)
 8001578:	fb843783          	ld	a5,-72(s0)
 800157c:	439c                	lw	a5,0(a5)
 800157e:	fb744683          	lbu	a3,-73(s0)
 8001582:	fc040613          	add	a2,s0,-64
 8001586:	fd040713          	add	a4,s0,-48
 800158a:	85ba                	mv	a1,a4
 800158c:	853e                	mv	a0,a5
 800158e:	e6dff0ef          	jal	80013fa <caliptra_mailbox_execute>
 8001592:	87aa                	mv	a5,a0
 8001594:	853e                	mv	a0,a5
 8001596:	60a6                	ld	ra,72(sp)
 8001598:	6406                	ld	s0,64(sp)
 800159a:	74e2                	ld	s1,56(sp)
 800159c:	6161                	add	sp,sp,80
 800159e:	8082                	ret

00000000080015a0 <caliptra_test_for_completion>:
 80015a0:	1141                	add	sp,sp,-16
 80015a2:	e406                	sd	ra,8(sp)
 80015a4:	e022                	sd	s0,0(sp)
 80015a6:	0800                	add	s0,sp,16
 80015a8:	83fff0ef          	jal	8000de6 <caliptra_mbox_is_busy>
 80015ac:	87aa                	mv	a5,a0
 80015ae:	2781                	sext.w	a5,a5
 80015b0:	00f037b3          	snez	a5,a5
 80015b4:	0ff7f793          	zext.b	a5,a5
 80015b8:	0017c793          	xor	a5,a5,1
 80015bc:	0ff7f793          	zext.b	a5,a5
 80015c0:	2781                	sext.w	a5,a5
 80015c2:	8b85                	and	a5,a5,1
 80015c4:	0ff7f793          	zext.b	a5,a5
 80015c8:	853e                	mv	a0,a5
 80015ca:	60a2                	ld	ra,8(sp)
 80015cc:	6402                	ld	s0,0(sp)
 80015ce:	0141                	add	sp,sp,16
 80015d0:	8082                	ret

00000000080015d2 <caliptra_complete>:
 80015d2:	7139                	add	sp,sp,-64
 80015d4:	fc06                	sd	ra,56(sp)
 80015d6:	f822                	sd	s0,48(sp)
 80015d8:	0080                	add	s0,sp,64
 80015da:	1c900613          	li	a2,457
 80015de:	00000597          	auipc	a1,0x0
 80015e2:	43258593          	add	a1,a1,1074 # 8001a10 <__func__.0>
 80015e6:	00000517          	auipc	a0,0x0
 80015ea:	36a50513          	add	a0,a0,874 # 8001950 <default_field_entropy+0x20>
 80015ee:	e2dfe0ef          	jal	800041a <kprintf>
 80015f2:	f90ff0ef          	jal	8000d82 <caliptra_mbox_read_execute>
 80015f6:	87aa                	mv	a5,a0
 80015f8:	e781                	bnez	a5,8001600 <caliptra_complete+0x2e>
 80015fa:	30100793          	li	a5,769
 80015fe:	a8fd                	j	80016fc <caliptra_complete+0x12a>
 8001600:	1ce00613          	li	a2,462
 8001604:	00000597          	auipc	a1,0x0
 8001608:	40c58593          	add	a1,a1,1036 # 8001a10 <__func__.0>
 800160c:	00000517          	auipc	a0,0x0
 8001610:	34450513          	add	a0,a0,836 # 8001950 <default_field_entropy+0x20>
 8001614:	e07fe0ef          	jal	800041a <kprintf>
 8001618:	f89ff0ef          	jal	80015a0 <caliptra_test_for_completion>
 800161c:	87aa                	mv	a5,a0
 800161e:	0017c793          	xor	a5,a5,1
 8001622:	0ff7f793          	zext.b	a5,a5
 8001626:	c781                	beqz	a5,800162e <caliptra_complete+0x5c>
 8001628:	30000793          	li	a5,768
 800162c:	a8c1                	j	80016fc <caliptra_complete+0x12a>
 800162e:	1d300613          	li	a2,467
 8001632:	00000597          	auipc	a1,0x0
 8001636:	3de58593          	add	a1,a1,990 # 8001a10 <__func__.0>
 800163a:	00000517          	auipc	a0,0x0
 800163e:	31650513          	add	a0,a0,790 # 8001950 <default_field_entropy+0x20>
 8001642:	dd9fe0ef          	jal	800041a <kprintf>
 8001646:	7801f797          	auipc	a5,0x7801f
 800164a:	a1a78793          	add	a5,a5,-1510 # 80020060 <g_caliptra_mbox_pending_rx_buffer>
 800164e:	6398                	ld	a4,0(a5)
 8001650:	fce43c23          	sd	a4,-40(s0)
 8001654:	679c                	ld	a5,8(a5)
 8001656:	fef43023          	sd	a5,-32(s0)
 800165a:	7801f797          	auipc	a5,0x7801f
 800165e:	a0678793          	add	a5,a5,-1530 # 80020060 <g_caliptra_mbox_pending_rx_buffer>
 8001662:	0007b023          	sd	zero,0(a5)
 8001666:	7801f797          	auipc	a5,0x7801f
 800166a:	9fa78793          	add	a5,a5,-1542 # 80020060 <g_caliptra_mbox_pending_rx_buffer>
 800166e:	0007b423          	sd	zero,8(a5)
 8001672:	1d900613          	li	a2,473
 8001676:	00000597          	auipc	a1,0x0
 800167a:	39a58593          	add	a1,a1,922 # 8001a10 <__func__.0>
 800167e:	00000517          	auipc	a0,0x0
 8001682:	2d250513          	add	a0,a0,722 # 8001950 <default_field_entropy+0x20>
 8001686:	d95fe0ef          	jal	800041a <kprintf>
 800168a:	fc042223          	sw	zero,-60(s0)
 800168e:	fc440713          	add	a4,s0,-60
 8001692:	fd840793          	add	a5,s0,-40
 8001696:	85ba                	mv	a1,a4
 8001698:	853e                	mv	a0,a5
 800169a:	981ff0ef          	jal	800101a <caliptra_check_status_get_response>
 800169e:	87aa                	mv	a5,a0
 80016a0:	fef42623          	sw	a5,-20(s0)
 80016a4:	1dd00613          	li	a2,477
 80016a8:	00000597          	auipc	a1,0x0
 80016ac:	36858593          	add	a1,a1,872 # 8001a10 <__func__.0>
 80016b0:	00000517          	auipc	a0,0x0
 80016b4:	2a050513          	add	a0,a0,672 # 8001950 <default_field_entropy+0x20>
 80016b8:	d63fe0ef          	jal	800041a <kprintf>
 80016bc:	fec42783          	lw	a5,-20(s0)
 80016c0:	2781                	sext.w	a5,a5
 80016c2:	c781                	beqz	a5,80016ca <caliptra_complete+0xf8>
 80016c4:	fec42783          	lw	a5,-20(s0)
 80016c8:	a815                	j	80016fc <caliptra_complete+0x12a>
 80016ca:	1e200613          	li	a2,482
 80016ce:	00000597          	auipc	a1,0x0
 80016d2:	34258593          	add	a1,a1,834 # 8001a10 <__func__.0>
 80016d6:	00000517          	auipc	a0,0x0
 80016da:	27a50513          	add	a0,a0,634 # 8001950 <default_field_entropy+0x20>
 80016de:	d3dfe0ef          	jal	800041a <kprintf>
 80016e2:	1e700613          	li	a2,487
 80016e6:	00000597          	auipc	a1,0x0
 80016ea:	32a58593          	add	a1,a1,810 # 8001a10 <__func__.0>
 80016ee:	00000517          	auipc	a0,0x0
 80016f2:	26250513          	add	a0,a0,610 # 8001950 <default_field_entropy+0x20>
 80016f6:	d25fe0ef          	jal	800041a <kprintf>
 80016fa:	4781                	li	a5,0
 80016fc:	853e                	mv	a0,a5
 80016fe:	70e2                	ld	ra,56(sp)
 8001700:	7442                	ld	s0,48(sp)
 8001702:	6121                	add	sp,sp,64
 8001704:	8082                	ret

0000000008001706 <caliptra_upload_fw>:
 8001706:	1101                	add	sp,sp,-32
 8001708:	ec06                	sd	ra,24(sp)
 800170a:	e822                	sd	s0,16(sp)
 800170c:	1000                	add	s0,sp,32
 800170e:	fea43423          	sd	a0,-24(s0)
 8001712:	87ae                	mv	a5,a1
 8001714:	fef403a3          	sb	a5,-25(s0)
 8001718:	fe843783          	ld	a5,-24(s0)
 800171c:	e781                	bnez	a5,8001724 <caliptra_upload_fw+0x1e>
 800171e:	10000793          	li	a5,256
 8001722:	a831                	j	800173e <caliptra_upload_fw+0x38>
 8001724:	fe744783          	lbu	a5,-25(s0)
 8001728:	86be                	mv	a3,a5
 800172a:	4601                	li	a2,0
 800172c:	fe843583          	ld	a1,-24(s0)
 8001730:	465757b7          	lui	a5,0x46575
 8001734:	c4478513          	add	a0,a5,-956 # 46574c44 <itrng_entropy_repetition_count+0x3e5731d0>
 8001738:	cc3ff0ef          	jal	80013fa <caliptra_mailbox_execute>
 800173c:	87aa                	mv	a5,a0
 800173e:	853e                	mv	a0,a5
 8001740:	60e2                	ld	ra,24(sp)
 8001742:	6442                	ld	s0,16(sp)
 8001744:	6105                	add	sp,sp,32
 8001746:	8082                	ret

Disassembly of section .rodata:

0000000008001748 <default_uds_seed>:
 8001748:	00010203          	lb	tp,0(sp)
 800174c:	04050607          	.insn	4, 0x04050607
 8001750:	08090a0b          	.insn	4, 0x08090a0b
 8001754:	0c0d0e0f          	.insn	4, 0x0c0d0e0f
 8001758:	10111213          	.insn	4, 0x10111213
 800175c:	14151617          	auipc	a2,0x14151
 8001760:	18191a1b          	.insn	4, 0x18191a1b
 8001764:	1e1f 1c1d 2223      	.insn	6, 0x22231c1d1e1f
 800176a:	2021                	.insn	2, 0x2021
 800176c:	24252627          	.insn	4, 0x24252627
 8001770:	28292a2b          	.insn	4, 0x28292a2b
 8001774:	2c2d2e2f          	.insn	4, 0x2c2d2e2f

0000000008001778 <default_field_entropy>:
 8001778:	80818283          	lb	t0,-2040(gp)
 800177c:	84858687          	.insn	4, 0x84858687
 8001780:	88898a8b          	.insn	4, 0x88898a8b
 8001784:	8c8d8e8f          	.insn	4, 0x8c8d8e8f
 8001788:	90919293          	.insn	4, 0x90919293
 800178c:	94959697          	auipc	a3,0x94959
 8001790:	98999a9b          	.insn	4, 0x98999a9b
 8001794:	9e9f 9c9d 2d2d      	.insn	6, 0x2d2d9c9d9e9f
 800179a:	2d2d                	addw	s10,s10,11
 800179c:	2d2d                	addw	s10,s10,11
 800179e:	2d2d                	addw	s10,s10,11
 80017a0:	2d2d                	addw	s10,s10,11
 80017a2:	2d2d                	addw	s10,s10,11
 80017a4:	2d2d                	addw	s10,s10,11
 80017a6:	2d2d                	addw	s10,s10,11
 80017a8:	2d2d                	addw	s10,s10,11
 80017aa:	2d2d                	addw	s10,s10,11
 80017ac:	2d2d                	addw	s10,s10,11
 80017ae:	2d2d                	addw	s10,s10,11
 80017b0:	2d2d                	addw	s10,s10,11
 80017b2:	2d2d                	addw	s10,s10,11
 80017b4:	2d2d                	addw	s10,s10,11
 80017b6:	2d2d                	addw	s10,s10,11
 80017b8:	2d2d                	addw	s10,s10,11
 80017ba:	2d2d                	addw	s10,s10,11
 80017bc:	000a                	c.slli	zero,0x2
 80017be:	0000                	unimp
 80017c0:	2020                	.insn	2, 0x2020
 80017c2:	2020                	.insn	2, 0x2020
 80017c4:	2020                	.insn	2, 0x2020
 80017c6:	2020                	.insn	2, 0x2020
 80017c8:	2020                	.insn	2, 0x2020
 80017ca:	2020                	.insn	2, 0x2020
 80017cc:	5320                	lw	s0,96(a4)
 80017ce:	6620434f          	.insn	4, 0x6620434f
 80017d2:	7269                	lui	tp,0xffffa
 80017d4:	776d                	lui	a4,0xffffb
 80017d6:	7261                	lui	tp,0xffff8
 80017d8:	2e65                	addw	t3,t3,25
 80017da:	2e2e                	.insn	2, 0x2e2e
 80017dc:	2020                	.insn	2, 0x2020
 80017de:	2020                	.insn	2, 0x2020
 80017e0:	2020                	.insn	2, 0x2020
 80017e2:	2020                	.insn	2, 0x2020
 80017e4:	000a                	c.slli	zero,0x2
 80017e6:	0000                	unimp
 80017e8:	3431                	addw	s0,s0,-20
 80017ea:	303a                	.insn	2, 0x303a
 80017ec:	33333a37          	lui	s4,0x33333
	...
 80017f8:	6f4e                	ld	t5,208(sp)
 80017fa:	2076                	.insn	2, 0x2076
 80017fc:	3520                	.insn	2, 0x3520
 80017fe:	3220                	.insn	2, 0x3220
 8001800:	3230                	.insn	2, 0x3230
 8001802:	0035                	c.nop	13
 8001804:	0000                	unimp
 8001806:	0000                	unimp
 8001808:	706d6f43          	.insn	4, 0x706d6f43
 800180c:	6c69                	lui	s8,0x1a
 800180e:	6465                	lui	s0,0x19
 8001810:	6f20                	ld	s0,88(a4)
 8001812:	3a6e                	.insn	2, 0x3a6e
 8001814:	2520                	.insn	2, 0x2520
 8001816:	74612073          	csrs	0x746,sp
 800181a:	2520                	.insn	2, 0x2520
 800181c:	00000a73          	.insn	4, 0x0a73
 8001820:	000a                	c.slli	zero,0x2
 8001822:	0000                	unimp
 8001824:	0000                	unimp
 8001826:	0000                	unimp
 8001828:	ed9a                	sd	t1,216(sp)
 800182a:	ed22ffff          	.insn	4, 0xed22ffff
 800182e:	edb4ffff          	.insn	4, 0xedb4ffff
 8001832:	edb4ffff          	.insn	4, 0xedb4ffff
 8001836:	edb4ffff          	.insn	4, 0xedb4ffff
 800183a:	ecf6ffff          	.insn	4, 0xecf6ffff
 800183e:	edb4ffff          	.insn	4, 0xedb4ffff
 8001842:	edb4ffff          	.insn	4, 0xedb4ffff
 8001846:	edb4ffff          	.insn	4, 0xedb4ffff
 800184a:	eceeffff          	.insn	4, 0xeceeffff
 800184e:	edb4ffff          	.insn	4, 0xedb4ffff
 8001852:	edb4ffff          	.insn	4, 0xedb4ffff
 8001856:	edb4ffff          	.insn	4, 0xedb4ffff
 800185a:	edb4ffff          	.insn	4, 0xedb4ffff
 800185e:	edb4ffff          	.insn	4, 0xedb4ffff
 8001862:	edb4ffff          	.insn	4, 0xedb4ffff
 8001866:	ed84ffff          	.insn	4, 0xed84ffff
 800186a:	edb4ffff          	.insn	4, 0xedb4ffff
 800186e:	ed22ffff          	.insn	4, 0xed22ffff
 8001872:	edb4ffff          	.insn	4, 0xedb4ffff
 8001876:	edb4ffff          	.insn	4, 0xedb4ffff
 800187a:	ecfeffff          	.insn	4, 0xecfeffff
 800187e:	cccdffff          	.insn	4, 0xcccdffff
 8001882:	cccc                	sw	a1,28(s1)
 8001884:	cccc                	sw	a1,28(s1)
 8001886:	cccc                	sw	a1,28(s1)

0000000008001888 <default_uds_seed>:
 8001888:	00010203          	lb	tp,0(sp)
 800188c:	04050607          	.insn	4, 0x04050607
 8001890:	08090a0b          	.insn	4, 0x08090a0b
 8001894:	0c0d0e0f          	.insn	4, 0x0c0d0e0f
 8001898:	10111213          	.insn	4, 0x10111213
 800189c:	14151617          	auipc	a2,0x14151
 80018a0:	18191a1b          	.insn	4, 0x18191a1b
 80018a4:	1e1f 1c1d 2223      	.insn	6, 0x22231c1d1e1f
 80018aa:	2021                	.insn	2, 0x2021
 80018ac:	24252627          	.insn	4, 0x24252627
 80018b0:	28292a2b          	.insn	4, 0x28292a2b
 80018b4:	2c2d2e2f          	.insn	4, 0x2c2d2e2f

00000000080018b8 <default_field_entropy>:
 80018b8:	80818283          	lb	t0,-2040(gp)
 80018bc:	84858687          	.insn	4, 0x84858687
 80018c0:	88898a8b          	.insn	4, 0x88898a8b
 80018c4:	8c8d8e8f          	.insn	4, 0x8c8d8e8f
 80018c8:	90919293          	.insn	4, 0x90919293
 80018cc:	94959697          	auipc	a3,0x94959
 80018d0:	98999a9b          	.insn	4, 0x98999a9b
 80018d4:	9e9f 9c9d 0a32      	.insn	6, 0x0a329c9d9e9f
 80018da:	0000                	unimp
 80018dc:	0000                	unimp
 80018de:	0000                	unimp
 80018e0:	6146                	ld	sp,80(sp)
 80018e2:	6c69                	lui	s8,0x1a
 80018e4:	6465                	lui	s0,0x19
 80018e6:	7420                	ld	s0,104(s0)
 80018e8:	6e69206f          	j	8093fce <itrng_entropy_repetition_count+0x9255a>
 80018ec:	7469                	lui	s0,0xffffa
 80018ee:	6620                	ld	s0,72(a2)
 80018f0:	7375                	lui	t1,0xffffd
 80018f2:	7365                	lui	t1,0xffff9
 80018f4:	203a                	.insn	2, 0x203a
 80018f6:	6425                	lui	s0,0x9
 80018f8:	000a                	c.slli	zero,0x2
 80018fa:	0000                	unimp
 80018fc:	0000                	unimp
	...

0000000008001900 <default_uds_seed>:
 8001900:	00010203          	lb	tp,0(sp)
 8001904:	04050607          	.insn	4, 0x04050607
 8001908:	08090a0b          	.insn	4, 0x08090a0b
 800190c:	0c0d0e0f          	.insn	4, 0x0c0d0e0f
 8001910:	10111213          	.insn	4, 0x10111213
 8001914:	14151617          	auipc	a2,0x14151
 8001918:	18191a1b          	.insn	4, 0x18191a1b
 800191c:	1e1f 1c1d 2223      	.insn	6, 0x22231c1d1e1f
 8001922:	2021                	.insn	2, 0x2021
 8001924:	24252627          	.insn	4, 0x24252627
 8001928:	28292a2b          	.insn	4, 0x28292a2b
 800192c:	2c2d2e2f          	.insn	4, 0x2c2d2e2f

0000000008001930 <default_field_entropy>:
 8001930:	80818283          	lb	t0,-2040(gp)
 8001934:	84858687          	.insn	4, 0x84858687
 8001938:	88898a8b          	.insn	4, 0x88898a8b
 800193c:	8c8d8e8f          	.insn	4, 0x8c8d8e8f
 8001940:	90919293          	.insn	4, 0x90919293
 8001944:	94959697          	auipc	a3,0x94959
 8001948:	98999a9b          	.insn	4, 0x98999a9b
 800194c:	9e9f 9c9d 7566      	.insn	6, 0x75669c9d9e9f
 8001952:	636e                	ld	t1,216(sp)
 8001954:	203a                	.insn	2, 0x203a
 8001956:	7325                	lui	t1,0xfffe9
 8001958:	202c                	.insn	2, 0x202c
 800195a:	696c                	ld	a1,208(a0)
 800195c:	656e                	ld	a0,216(sp)
 800195e:	203a                	.insn	2, 0x203a
 8001960:	6425                	lui	s0,0x9
 8001962:	0d20                	add	s0,sp,664
 8001964:	000a                	c.slli	zero,0x2
	...

0000000008001968 <__func__.5>:
 8001968:	696c6163          	bltu	s8,s6,8001fea <itrng_entropy_repetition_count+0x576>
 800196c:	7470                	ld	a2,232(s0)
 800196e:	6172                	ld	sp,280(sp)
 8001970:	635f 6568 6b63      	.insn	6, 0x6b636568635f
 8001976:	735f 6174 7574      	.insn	6, 0x75746174735f
 800197c:	65675f73          	csrrw	t5,hviprio1h,14
 8001980:	5f74                	lw	a3,124(a4)
 8001982:	6572                	ld	a0,280(sp)
 8001984:	6e6f7073          	csrc	0x6e6,30
 8001988:	00006573          	csrrs	a0,0x0,0
 800198c:	0000                	unimp
	...

0000000008001990 <__func__.4>:
 8001990:	696c6163          	bltu	s8,s6,8002012 <itrng_entropy_repetition_count+0x59e>
 8001994:	7470                	ld	a2,232(s0)
 8001996:	6172                	ld	sp,280(sp)
 8001998:	6d5f 6961 626c      	.insn	6, 0x626c69616d5f
 800199e:	735f786f          	jal	a6,80f98d2 <itrng_entropy_repetition_count+0xf7e5e>
 80019a2:	6e65                	lui	t3,0x19
 80019a4:	5f64                	lw	s1,124(a4)
 80019a6:	72617473          	csrrc	s0,mhpmevent6h,2
 80019aa:	0074                	add	a3,sp,12
 80019ac:	0000                	unimp
	...

00000000080019b0 <__func__.3>:
 80019b0:	696c6163          	bltu	s8,s6,8002032 <itrng_entropy_repetition_count+0x5be>
 80019b4:	7470                	ld	a2,232(s0)
 80019b6:	6172                	ld	sp,280(sp)
 80019b8:	6d5f 6961 626c      	.insn	6, 0x626c69616d5f
 80019be:	735f786f          	jal	a6,80f98f2 <itrng_entropy_repetition_count+0xf7e7e>
 80019c2:	6e65                	lui	t3,0x19
 80019c4:	5f64                	lw	s1,124(a4)
 80019c6:	706d6f63          	bltu	s10,t1,80020e4 <itrng_entropy_repetition_count+0x670>
 80019ca:	656c                	ld	a1,200(a0)
 80019cc:	6574                	ld	a3,200(a0)
	...

00000000080019d0 <__func__.2>:
 80019d0:	696c6163          	bltu	s8,s6,8002052 <itrng_entropy_repetition_count+0x5de>
 80019d4:	7470                	ld	a2,232(s0)
 80019d6:	6172                	ld	sp,280(sp)
 80019d8:	6d5f 6961 626c      	.insn	6, 0x626c69616d5f
 80019de:	655f786f          	jal	a6,80f9832 <itrng_entropy_repetition_count+0xf7dbe>
 80019e2:	6578                	ld	a4,200(a0)
 80019e4:	65747563          	bgeu	s0,s7,800202e <itrng_entropy_repetition_count+0x5ba>
	...

00000000080019f0 <__func__.1>:
 80019f0:	6170                	ld	a2,192(a0)
 80019f2:	615f6b63          	bltu	t5,s5,8002008 <itrng_entropy_repetition_count+0x594>
 80019f6:	646e                	ld	s0,216(sp)
 80019f8:	655f 6578 7563      	.insn	6, 0x75636578655f
 80019fe:	6574                	ld	a3,200(a0)
 8001a00:	635f 6d6f 616d      	.insn	6, 0x616d6d6f635f
 8001a06:	646e                	ld	s0,216(sp)
	...

0000000008001a10 <__func__.0>:
 8001a10:	696c6163          	bltu	s8,s6,8002092 <itrng_entropy_repetition_count+0x61e>
 8001a14:	7470                	ld	a2,232(s0)
 8001a16:	6172                	ld	sp,280(sp)
 8001a18:	635f 6d6f 6c70      	.insn	6, 0x6c706d6f635f
 8001a1e:	7465                	lui	s0,0xffff9
 8001a20:	0065                	c.nop	25
 8001a22:	0000                	unimp
 8001a24:	0000                	unimp
	...

0000000008001a28 <uart>:
 8001a28:	0000                	unimp
 8001a2a:	6400                	ld	s0,8(s0)
 8001a2c:	0000                	unimp
	...

0000000008001a30 <wdt_timeout>:
 8001a30:	0000                	unimp
 8001a32:	a000                	.insn	2, 0xa000
 8001a34:	0000                	unimp
	...

0000000008001a38 <itrng_entropy_low_threshold>:
 8001a38:	0001                	nop

0000000008001a3a <itrng_entropy_high_threshold>:
 8001a3a:	          	.insn	4, 0xffffffff

0000000008001a3c <itrng_entropy_repetition_count>:
 8001a3c:	0000ffff          	.insn	4, 0xffff

0000000008001a40 <uart>:
 8001a40:	0000                	unimp
 8001a42:	6400                	ld	s0,8(s0)
 8001a44:	0000                	unimp
	...

0000000008001a48 <uart>:
 8001a48:	0000                	unimp
 8001a4a:	6400                	ld	s0,8(s0)
 8001a4c:	0000                	unimp
	...

0000000008001a50 <wdt_timeout>:
 8001a50:	0000                	unimp
 8001a52:	a000                	.insn	2, 0xa000
 8001a54:	0000                	unimp
	...

0000000008001a58 <itrng_entropy_low_threshold>:
 8001a58:	0001                	nop

0000000008001a5a <itrng_entropy_high_threshold>:
 8001a5a:	          	.insn	4, 0xffffffff

0000000008001a5c <itrng_entropy_repetition_count>:
 8001a5c:	0000ffff          	.insn	4, 0xffff

0000000008001a60 <uart>:
 8001a60:	0000                	unimp
 8001a62:	6400                	ld	s0,8(s0)
 8001a64:	0000                	unimp
	...

0000000008001a68 <wdt_timeout>:
 8001a68:	0000                	unimp
 8001a6a:	a000                	.insn	2, 0xa000
 8001a6c:	0000                	unimp
	...

0000000008001a70 <itrng_entropy_low_threshold>:
 8001a70:	0001                	nop

0000000008001a72 <itrng_entropy_high_threshold>:
 8001a72:	          	.insn	4, 0xffffffff

0000000008001a74 <itrng_entropy_repetition_count>:
 8001a74:	ff ff   	Address 0x8001a74 is out of bounds.

 8001a78:	 

Disassembly of section .vpk_hash:

0000000080020000 <vpk_hash>:
	...

Disassembly of section .opk_hash:

0000000080020030 <opk_hash>:
	...

Disassembly of section .bss:

0000000080020060 <g_caliptra_mbox_pending_rx_buffer>:
	...

Disassembly of section .stack:

0000000080020070 <_stack_end>:
	...

0000000080024070 <_stack_start>:
	...
