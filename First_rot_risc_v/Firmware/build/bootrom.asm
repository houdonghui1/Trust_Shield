
build/bootrom.elf：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000010000 <_prog_start>:
   10000:	00090137          	lui	sp,0x90
   10004:	fff1011b          	addw	sp,sp,-1 # 8ffff <dtb+0x7e09f>
   10008:	00c11113          	sll	sp,sp,0xc
   1000c:	0e0000ef          	jal	100ec <main>
   10010:	080004b7          	lui	s1,0x8000
   10014:	00048067          	jr	s1 # 8000000 <dtb+0x7fee0a0>

0000000000010018 <memcpy_fw_to_fwstore>:
   10018:	715d                	add	sp,sp,-80
   1001a:	e486                	sd	ra,72(sp)
   1001c:	e0a2                	sd	s0,64(sp)
   1001e:	0880                	add	s0,sp,80
   10020:	fca43423          	sd	a0,-56(s0)
   10024:	fcb43023          	sd	a1,-64(s0)
   10028:	87b2                	mv	a5,a2
   1002a:	faf42e23          	sw	a5,-68(s0)
   1002e:	fc843783          	ld	a5,-56(s0)
   10032:	fef43023          	sd	a5,-32(s0)
   10036:	fc043783          	ld	a5,-64(s0)
   1003a:	fcf43c23          	sd	a5,-40(s0)
   1003e:	fe042623          	sw	zero,-20(s0)
   10042:	a025                	j	1006a <memcpy_fw_to_fwstore+0x52>
   10044:	fec46783          	lwu	a5,-20(s0)
   10048:	078a                	sll	a5,a5,0x2
   1004a:	fe043703          	ld	a4,-32(s0)
   1004e:	973e                	add	a4,a4,a5
   10050:	fec46783          	lwu	a5,-20(s0)
   10054:	078a                	sll	a5,a5,0x2
   10056:	fd843683          	ld	a3,-40(s0)
   1005a:	97b6                	add	a5,a5,a3
   1005c:	4318                	lw	a4,0(a4)
   1005e:	c398                	sw	a4,0(a5)
   10060:	fec42783          	lw	a5,-20(s0)
   10064:	2785                	addw	a5,a5,1
   10066:	fef42623          	sw	a5,-20(s0)
   1006a:	fbc42783          	lw	a5,-68(s0)
   1006e:	0027d79b          	srlw	a5,a5,0x2
   10072:	2781                	sext.w	a5,a5
   10074:	fec42703          	lw	a4,-20(s0)
   10078:	2701                	sext.w	a4,a4
   1007a:	fcf765e3          	bltu	a4,a5,10044 <memcpy_fw_to_fwstore+0x2c>
   1007e:	0001                	nop
   10080:	0001                	nop
   10082:	60a6                	ld	ra,72(sp)
   10084:	6406                	ld	s0,64(sp)
   10086:	6161                	add	sp,sp,80
   10088:	8082                	ret

000000000001008a <Validate_TargetBootloader>:
   1008a:	7179                	add	sp,sp,-48
   1008c:	f406                	sd	ra,40(sp)
   1008e:	f022                	sd	s0,32(sp)
   10090:	1800                	add	s0,sp,48
   10092:	87aa                	mv	a5,a0
   10094:	fcf42e23          	sw	a5,-36(s0)
   10098:	fdc46783          	lwu	a5,-36(s0)
   1009c:	fef43423          	sd	a5,-24(s0)
   100a0:	fe843783          	ld	a5,-24(s0)
   100a4:	fef43023          	sd	a5,-32(s0)
   100a8:	fe043783          	ld	a5,-32(s0)
   100ac:	679c                	ld	a5,8(a5)
   100ae:	873e                	mv	a4,a5
   100b0:	080007b7          	lui	a5,0x8000
   100b4:	00f76a63          	bltu	a4,a5,100c8 <Validate_TargetBootloader+0x3e>
   100b8:	fe043783          	ld	a5,-32(s0)
   100bc:	679c                	ld	a5,8(a5)
   100be:	873e                	mv	a4,a5
   100c0:	090007b7          	lui	a5,0x9000
   100c4:	00f76e63          	bltu	a4,a5,100e0 <Validate_TargetBootloader+0x56>
   100c8:	fe043783          	ld	a5,-32(s0)
   100cc:	679c                	ld	a5,8(a5)
   100ce:	85be                	mv	a1,a5
   100d0:	00002517          	auipc	a0,0x2
   100d4:	b4050513          	add	a0,a0,-1216 # 11c10 <default_field_entropy+0x20>
   100d8:	5be000ef          	jal	10696 <kprintf>
   100dc:	4785                	li	a5,1
   100de:	a011                	j	100e2 <Validate_TargetBootloader+0x58>
   100e0:	4781                	li	a5,0
   100e2:	853e                	mv	a0,a5
   100e4:	70a2                	ld	ra,40(sp)
   100e6:	7402                	ld	s0,32(sp)
   100e8:	6145                	add	sp,sp,48
   100ea:	8082                	ret

00000000000100ec <main>:
   100ec:	84010113          	add	sp,sp,-1984
   100f0:	7a113c23          	sd	ra,1976(sp)
   100f4:	7a813823          	sd	s0,1968(sp)
   100f8:	7c010413          	add	s0,sp,1984
   100fc:	72f9                	lui	t0,0xffffe
   100fe:	9116                	add	sp,sp,t0
   10100:	fe042023          	sw	zero,-32(s0)
   10104:	77f9                	lui	a5,0xffffe
   10106:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10108:	97a2                	add	a5,a5,s0
   1010a:	9f078713          	add	a4,a5,-1552
   1010e:	6789                	lui	a5,0x2
   10110:	60078793          	add	a5,a5,1536 # 2600 <_prog_start-0xda00>
   10114:	863e                	mv	a2,a5
   10116:	4581                	li	a1,0
   10118:	853a                	mv	a0,a4
   1011a:	1bf000ef          	jal	10ad8 <memset>
   1011e:	640007b7          	lui	a5,0x64000
   10122:	07a1                	add	a5,a5,8 # 64000008 <_sp+0x5bfc0010>
   10124:	4705                	li	a4,1
   10126:	c398                	sw	a4,0(a5)
   10128:	640007b7          	lui	a5,0x64000
   1012c:	07b1                	add	a5,a5,12 # 6400000c <_sp+0x5bfc0014>
   1012e:	4705                	li	a4,1
   10130:	c398                	sw	a4,0(a5)
   10132:	00002517          	auipc	a0,0x2
   10136:	b1e50513          	add	a0,a0,-1250 # 11c50 <default_field_entropy+0x60>
   1013a:	55c000ef          	jal	10696 <kprintf>
   1013e:	00002517          	auipc	a0,0x2
   10142:	b3a50513          	add	a0,a0,-1222 # 11c78 <default_field_entropy+0x88>
   10146:	550000ef          	jal	10696 <kprintf>
   1014a:	00002517          	auipc	a0,0x2
   1014e:	b0650513          	add	a0,a0,-1274 # 11c50 <default_field_entropy+0x60>
   10152:	544000ef          	jal	10696 <kprintf>
   10156:	00002617          	auipc	a2,0x2
   1015a:	b4a60613          	add	a2,a2,-1206 # 11ca0 <default_field_entropy+0xb0>
   1015e:	00002597          	auipc	a1,0x2
   10162:	b5258593          	add	a1,a1,-1198 # 11cb0 <default_field_entropy+0xc0>
   10166:	00002517          	auipc	a0,0x2
   1016a:	b5a50513          	add	a0,a0,-1190 # 11cc0 <default_field_entropy+0xd0>
   1016e:	528000ef          	jal	10696 <kprintf>
   10172:	300307b7          	lui	a5,0x30030
   10176:	0bc78793          	add	a5,a5,188 # 300300bc <_sp+0x27ff00c4>
   1017a:	4721                	li	a4,8
   1017c:	c398                	sw	a4,0(a5)
   1017e:	77f9                	lui	a5,0xffffe
   10180:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10182:	97a2                	add	a5,a5,s0
   10184:	88078793          	add	a5,a5,-1920
   10188:	17000713          	li	a4,368
   1018c:	863a                	mv	a2,a4
   1018e:	4581                	li	a1,0
   10190:	853e                	mv	a0,a5
   10192:	147000ef          	jal	10ad8 <memset>
   10196:	77f9                	lui	a5,0xffffe
   10198:	88078793          	add	a5,a5,-1920 # ffffffffffffd880 <_sp+0xfffffffff7fbd888>
   1019c:	17c1                	add	a5,a5,-16
   1019e:	97a2                	add	a5,a5,s0
   101a0:	853e                	mv	a0,a5
   101a2:	295000ef          	jal	10c36 <caliptra1x_set_fuses>
   101a6:	03c00613          	li	a2,60
   101aa:	00002597          	auipc	a1,0x2
   101ae:	87658593          	add	a1,a1,-1930 # 11a20 <__func__.0>
   101b2:	00002517          	auipc	a0,0x2
   101b6:	b2650513          	add	a0,a0,-1242 # 11cd8 <default_field_entropy+0xe8>
   101ba:	4dc000ef          	jal	10696 <kprintf>
   101be:	77f9                	lui	a5,0xffffe
   101c0:	88078793          	add	a5,a5,-1920 # ffffffffffffd880 <_sp+0xfffffffff7fbd888>
   101c4:	17c1                	add	a5,a5,-16
   101c6:	97a2                	add	a5,a5,s0
   101c8:	4581                	li	a1,0
   101ca:	853e                	mv	a0,a5
   101cc:	4c3000ef          	jal	10e8e <caliptra1x_drv_init>
   101d0:	87aa                	mv	a5,a0
   101d2:	fef42623          	sw	a5,-20(s0)
   101d6:	fec42783          	lw	a5,-20(s0)
   101da:	86be                	mv	a3,a5
   101dc:	03e00613          	li	a2,62
   101e0:	00002597          	auipc	a1,0x2
   101e4:	84058593          	add	a1,a1,-1984 # 11a20 <__func__.0>
   101e8:	00002517          	auipc	a0,0x2
   101ec:	b0850513          	add	a0,a0,-1272 # 11cf0 <default_field_entropy+0x100>
   101f0:	4a6000ef          	jal	10696 <kprintf>
   101f4:	77f9                	lui	a5,0xffffe
   101f6:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   101f8:	97a2                	add	a5,a5,s0
   101fa:	1a2b4737          	lui	a4,0x1a2b4
   101fe:	c4d70713          	add	a4,a4,-947 # 1a2b3c4d <_sp+0x12273c55>
   10202:	84e7ac23          	sw	a4,-1960(a5)
   10206:	77f9                	lui	a5,0xffffe
   10208:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   1020a:	97a2                	add	a5,a5,s0
   1020c:	fe040713          	add	a4,s0,-32
   10210:	86e7b023          	sd	a4,-1952(a5)
   10214:	77f9                	lui	a5,0xffffe
   10216:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10218:	97a2                	add	a5,a5,s0
   1021a:	4711                	li	a4,4
   1021c:	86e7b423          	sd	a4,-1944(a5)
   10220:	77f9                	lui	a5,0xffffe
   10222:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10224:	97a2                	add	a5,a5,s0
   10226:	7779                	lui	a4,0xffffe
   10228:	9f070713          	add	a4,a4,-1552 # ffffffffffffd9f0 <_sp+0xfffffffff7fbd9f8>
   1022c:	1741                	add	a4,a4,-16
   1022e:	9722                	add	a4,a4,s0
   10230:	86e7b823          	sd	a4,-1936(a5)
   10234:	77f9                	lui	a5,0xffffe
   10236:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10238:	97a2                	add	a5,a5,s0
   1023a:	6709                	lui	a4,0x2
   1023c:	60070713          	add	a4,a4,1536 # 2600 <_prog_start-0xda00>
   10240:	86e7bc23          	sd	a4,-1928(a5)
   10244:	04700613          	li	a2,71
   10248:	00001597          	auipc	a1,0x1
   1024c:	7d858593          	add	a1,a1,2008 # 11a20 <__func__.0>
   10250:	00002517          	auipc	a0,0x2
   10254:	a8850513          	add	a0,a0,-1400 # 11cd8 <default_field_entropy+0xe8>
   10258:	43e000ef          	jal	10696 <kprintf>
   1025c:	4785                	li	a5,1
   1025e:	fef42623          	sw	a5,-20(s0)
   10262:	a825                	j	1029a <main+0x1ae>
   10264:	77f9                	lui	a5,0xffffe
   10266:	85878793          	add	a5,a5,-1960 # ffffffffffffd858 <_sp+0xfffffffff7fbd860>
   1026a:	17c1                	add	a5,a5,-16
   1026c:	97a2                	add	a5,a5,s0
   1026e:	4581                	li	a1,0
   10270:	853e                	mv	a0,a5
   10272:	4b2010ef          	jal	11724 <pack_and_execute_command>
   10276:	87aa                	mv	a5,a0
   10278:	fef42623          	sw	a5,-20(s0)
   1027c:	fec42783          	lw	a5,-20(s0)
   10280:	86be                	mv	a3,a5
   10282:	04b00613          	li	a2,75
   10286:	00001597          	auipc	a1,0x1
   1028a:	79a58593          	add	a1,a1,1946 # 11a20 <__func__.0>
   1028e:	00002517          	auipc	a0,0x2
   10292:	a8a50513          	add	a0,a0,-1398 # 11d18 <default_field_entropy+0x128>
   10296:	400000ef          	jal	10696 <kprintf>
   1029a:	fec42783          	lw	a5,-20(s0)
   1029e:	2781                	sext.w	a5,a5
   102a0:	f3f1                	bnez	a5,10264 <main+0x178>
   102a2:	00002517          	auipc	a0,0x2
   102a6:	a9e50513          	add	a0,a0,-1378 # 11d40 <default_field_entropy+0x150>
   102aa:	3ec000ef          	jal	10696 <kprintf>
   102ae:	fe042423          	sw	zero,-24(s0)
   102b2:	a0b1                	j	102fe <main+0x212>
   102b4:	77f9                	lui	a5,0xffffe
   102b6:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   102b8:	97a2                	add	a5,a5,s0
   102ba:	8707b703          	ld	a4,-1936(a5)
   102be:	fe846783          	lwu	a5,-24(s0)
   102c2:	97ba                	add	a5,a5,a4
   102c4:	0007c783          	lbu	a5,0(a5)
   102c8:	2781                	sext.w	a5,a5
   102ca:	85be                	mv	a1,a5
   102cc:	00002517          	auipc	a0,0x2
   102d0:	a8450513          	add	a0,a0,-1404 # 11d50 <default_field_entropy+0x160>
   102d4:	3c2000ef          	jal	10696 <kprintf>
   102d8:	fe842783          	lw	a5,-24(s0)
   102dc:	8bbd                	and	a5,a5,15
   102de:	2781                	sext.w	a5,a5
   102e0:	873e                	mv	a4,a5
   102e2:	47bd                	li	a5,15
   102e4:	00f71863          	bne	a4,a5,102f4 <main+0x208>
   102e8:	00002517          	auipc	a0,0x2
   102ec:	a7050513          	add	a0,a0,-1424 # 11d58 <default_field_entropy+0x168>
   102f0:	3a6000ef          	jal	10696 <kprintf>
   102f4:	fe842783          	lw	a5,-24(s0)
   102f8:	2785                	addw	a5,a5,1
   102fa:	fef42423          	sw	a5,-24(s0)
   102fe:	fe846703          	lwu	a4,-24(s0)
   10302:	77f9                	lui	a5,0xffffe
   10304:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10306:	97a2                	add	a5,a5,s0
   10308:	8787b783          	ld	a5,-1928(a5)
   1030c:	faf764e3          	bltu	a4,a5,102b4 <main+0x1c8>
   10310:	77f9                	lui	a5,0xffffe
   10312:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   10314:	97a2                	add	a5,a5,s0
   10316:	8707b703          	ld	a4,-1936(a5)
   1031a:	77f9                	lui	a5,0xffffe
   1031c:	17c1                	add	a5,a5,-16 # ffffffffffffdff0 <_sp+0xfffffffff7fbdff8>
   1031e:	97a2                	add	a5,a5,s0
   10320:	8787b783          	ld	a5,-1928(a5)
   10324:	2781                	sext.w	a5,a5
   10326:	863e                	mv	a2,a5
   10328:	080005b7          	lui	a1,0x8000
   1032c:	853a                	mv	a0,a4
   1032e:	cebff0ef          	jal	10018 <memcpy_fw_to_fwstore>
   10332:	4781                	li	a5,0
   10334:	853e                	mv	a0,a5
   10336:	6289                	lui	t0,0x2
   10338:	9116                	add	sp,sp,t0
   1033a:	7b813083          	ld	ra,1976(sp)
   1033e:	7b013403          	ld	s0,1968(sp)
   10342:	7c010113          	add	sp,sp,1984
   10346:	8082                	ret

0000000000010348 <kputc>:
   10348:	7179                	add	sp,sp,-48
   1034a:	f406                	sd	ra,40(sp)
   1034c:	f022                	sd	s0,32(sp)
   1034e:	1800                	add	s0,sp,48
   10350:	87aa                	mv	a5,a0
   10352:	fcf40fa3          	sb	a5,-33(s0)
   10356:	640007b7          	lui	a5,0x64000
   1035a:	fef43423          	sd	a5,-24(s0)
   1035e:	fe843703          	ld	a4,-24(s0)
   10362:	fdf44783          	lbu	a5,-33(s0)
   10366:	86be                	mv	a3,a5
   10368:	fe843783          	ld	a5,-24(s0)
   1036c:	40d727af          	amoor.w	a5,a3,(a4)
   10370:	fef42223          	sw	a5,-28(s0)
   10374:	fe442783          	lw	a5,-28(s0)
   10378:	2781                	sext.w	a5,a5
   1037a:	fe07c2e3          	bltz	a5,1035e <kputc+0x16>
   1037e:	0001                	nop
   10380:	0001                	nop
   10382:	70a2                	ld	ra,40(sp)
   10384:	7402                	ld	s0,32(sp)
   10386:	6145                	add	sp,sp,48
   10388:	8082                	ret

000000000001038a <_kputs>:
   1038a:	7179                	add	sp,sp,-48
   1038c:	f406                	sd	ra,40(sp)
   1038e:	f022                	sd	s0,32(sp)
   10390:	1800                	add	s0,sp,48
   10392:	fca43c23          	sd	a0,-40(s0)
   10396:	a819                	j	103ac <_kputs+0x22>
   10398:	fef44783          	lbu	a5,-17(s0)
   1039c:	853e                	mv	a0,a5
   1039e:	fabff0ef          	jal	10348 <kputc>
   103a2:	fd843783          	ld	a5,-40(s0)
   103a6:	0785                	add	a5,a5,1 # 64000001 <_sp+0x5bfc0009>
   103a8:	fcf43c23          	sd	a5,-40(s0)
   103ac:	fd843783          	ld	a5,-40(s0)
   103b0:	0007c783          	lbu	a5,0(a5)
   103b4:	fef407a3          	sb	a5,-17(s0)
   103b8:	fef44783          	lbu	a5,-17(s0)
   103bc:	0ff7f793          	zext.b	a5,a5
   103c0:	ffe1                	bnez	a5,10398 <_kputs+0xe>
   103c2:	0001                	nop
   103c4:	0001                	nop
   103c6:	70a2                	ld	ra,40(sp)
   103c8:	7402                	ld	s0,32(sp)
   103ca:	6145                	add	sp,sp,48
   103cc:	8082                	ret

00000000000103ce <kputs>:
   103ce:	1101                	add	sp,sp,-32
   103d0:	ec06                	sd	ra,24(sp)
   103d2:	e822                	sd	s0,16(sp)
   103d4:	1000                	add	s0,sp,32
   103d6:	fea43423          	sd	a0,-24(s0)
   103da:	fe843503          	ld	a0,-24(s0)
   103de:	fadff0ef          	jal	1038a <_kputs>
   103e2:	4535                	li	a0,13
   103e4:	f65ff0ef          	jal	10348 <kputc>
   103e8:	4529                	li	a0,10
   103ea:	f5fff0ef          	jal	10348 <kputc>
   103ee:	0001                	nop
   103f0:	60e2                	ld	ra,24(sp)
   103f2:	6442                	ld	s0,16(sp)
   103f4:	6105                	add	sp,sp,32
   103f6:	8082                	ret

00000000000103f8 <print_number>:
   103f8:	715d                	add	sp,sp,-80
   103fa:	e486                	sd	ra,72(sp)
   103fc:	e0a2                	sd	s0,64(sp)
   103fe:	0880                	add	s0,sp,80
   10400:	faa43c23          	sd	a0,-72(s0)
   10404:	87ae                	mv	a5,a1
   10406:	8736                	mv	a4,a3
   10408:	faf40ba3          	sb	a5,-73(s0)
   1040c:	87b2                	mv	a5,a2
   1040e:	faf42823          	sw	a5,-80(s0)
   10412:	87ba                	mv	a5,a4
   10414:	faf40b23          	sb	a5,-74(s0)
   10418:	fe042623          	sw	zero,-20(s0)
   1041c:	fb744783          	lbu	a5,-73(s0)
   10420:	0ff7f793          	zext.b	a5,a5
   10424:	cf99                	beqz	a5,10442 <print_number+0x4a>
   10426:	fb843783          	ld	a5,-72(s0)
   1042a:	0007dc63          	bgez	a5,10442 <print_number+0x4a>
   1042e:	02d00513          	li	a0,45
   10432:	f17ff0ef          	jal	10348 <kputc>
   10436:	fb843783          	ld	a5,-72(s0)
   1043a:	40f007b3          	neg	a5,a5
   1043e:	faf43c23          	sd	a5,-72(s0)
   10442:	fb843683          	ld	a3,-72(s0)
   10446:	00002797          	auipc	a5,0x2
   1044a:	97278793          	add	a5,a5,-1678 # 11db8 <default_field_entropy+0x1c8>
   1044e:	639c                	ld	a5,0(a5)
   10450:	02f6b7b3          	mulhu	a5,a3,a5
   10454:	0037d713          	srl	a4,a5,0x3
   10458:	87ba                	mv	a5,a4
   1045a:	078a                	sll	a5,a5,0x2
   1045c:	97ba                	add	a5,a5,a4
   1045e:	0786                	sll	a5,a5,0x1
   10460:	40f68733          	sub	a4,a3,a5
   10464:	0ff77713          	zext.b	a4,a4
   10468:	fec42783          	lw	a5,-20(s0)
   1046c:	0017869b          	addw	a3,a5,1
   10470:	fed42623          	sw	a3,-20(s0)
   10474:	0307071b          	addw	a4,a4,48
   10478:	0ff77713          	zext.b	a4,a4
   1047c:	17c1                	add	a5,a5,-16
   1047e:	97a2                	add	a5,a5,s0
   10480:	fce78c23          	sb	a4,-40(a5)
   10484:	fb843703          	ld	a4,-72(s0)
   10488:	00002797          	auipc	a5,0x2
   1048c:	93078793          	add	a5,a5,-1744 # 11db8 <default_field_entropy+0x1c8>
   10490:	639c                	ld	a5,0(a5)
   10492:	02f737b3          	mulhu	a5,a4,a5
   10496:	838d                	srl	a5,a5,0x3
   10498:	faf43c23          	sd	a5,-72(s0)
   1049c:	fb843783          	ld	a5,-72(s0)
   104a0:	f3cd                	bnez	a5,10442 <print_number+0x4a>
   104a2:	a01d                	j	104c8 <print_number+0xd0>
   104a4:	fb644783          	lbu	a5,-74(s0)
   104a8:	0ff7f793          	zext.b	a5,a5
   104ac:	c781                	beqz	a5,104b4 <print_number+0xbc>
   104ae:	03000793          	li	a5,48
   104b2:	a019                	j	104b8 <print_number+0xc0>
   104b4:	02000793          	li	a5,32
   104b8:	853e                	mv	a0,a5
   104ba:	e8fff0ef          	jal	10348 <kputc>
   104be:	fb042783          	lw	a5,-80(s0)
   104c2:	37fd                	addw	a5,a5,-1
   104c4:	faf42823          	sw	a5,-80(s0)
   104c8:	fb042783          	lw	a5,-80(s0)
   104cc:	873e                	mv	a4,a5
   104ce:	fec42783          	lw	a5,-20(s0)
   104d2:	86be                	mv	a3,a5
   104d4:	0007079b          	sext.w	a5,a4
   104d8:	873e                	mv	a4,a5
   104da:	0006879b          	sext.w	a5,a3
   104de:	fce7c3e3          	blt	a5,a4,104a4 <print_number+0xac>
   104e2:	a839                	j	10500 <print_number+0x108>
   104e4:	fec42783          	lw	a5,-20(s0)
   104e8:	37fd                	addw	a5,a5,-1
   104ea:	fef42623          	sw	a5,-20(s0)
   104ee:	fec42783          	lw	a5,-20(s0)
   104f2:	17c1                	add	a5,a5,-16
   104f4:	97a2                	add	a5,a5,s0
   104f6:	fd87c783          	lbu	a5,-40(a5)
   104fa:	853e                	mv	a0,a5
   104fc:	e4dff0ef          	jal	10348 <kputc>
   10500:	fec42783          	lw	a5,-20(s0)
   10504:	2781                	sext.w	a5,a5
   10506:	fcf04fe3          	bgtz	a5,104e4 <print_number+0xec>
   1050a:	0001                	nop
   1050c:	0001                	nop
   1050e:	60a6                	ld	ra,72(sp)
   10510:	6406                	ld	s0,64(sp)
   10512:	6161                	add	sp,sp,80
   10514:	8082                	ret

0000000000010516 <print_hex>:
   10516:	711d                	add	sp,sp,-96
   10518:	ec86                	sd	ra,88(sp)
   1051a:	e8a2                	sd	s0,80(sp)
   1051c:	1080                	add	s0,sp,96
   1051e:	faa43423          	sd	a0,-88(s0)
   10522:	87ae                	mv	a5,a1
   10524:	8736                	mv	a4,a3
   10526:	faf42223          	sw	a5,-92(s0)
   1052a:	87b2                	mv	a5,a2
   1052c:	faf401a3          	sb	a5,-93(s0)
   10530:	87ba                	mv	a5,a4
   10532:	faf40123          	sb	a5,-94(s0)
   10536:	fa244783          	lbu	a5,-94(s0)
   1053a:	0ff7f793          	zext.b	a5,a5
   1053e:	c399                	beqz	a5,10544 <print_hex+0x2e>
   10540:	47c1                	li	a5,16
   10542:	a011                	j	10546 <print_hex+0x30>
   10544:	47a1                	li	a5,8
   10546:	fcf42c23          	sw	a5,-40(s0)
   1054a:	fe042623          	sw	zero,-20(s0)
   1054e:	fe042423          	sw	zero,-24(s0)
   10552:	fd842783          	lw	a5,-40(s0)
   10556:	37fd                	addw	a5,a5,-1
   10558:	fef42223          	sw	a5,-28(s0)
   1055c:	a841                	j	105ec <print_hex+0xd6>
   1055e:	fe442783          	lw	a5,-28(s0)
   10562:	0027979b          	sllw	a5,a5,0x2
   10566:	2781                	sext.w	a5,a5
   10568:	873e                	mv	a4,a5
   1056a:	fa843783          	ld	a5,-88(s0)
   1056e:	00e7d7b3          	srl	a5,a5,a4
   10572:	2781                	sext.w	a5,a5
   10574:	8bbd                	and	a5,a5,15
   10576:	fcf42a23          	sw	a5,-44(s0)
   1057a:	fd442783          	lw	a5,-44(s0)
   1057e:	2781                	sext.w	a5,a5
   10580:	eb91                	bnez	a5,10594 <print_hex+0x7e>
   10582:	fec42783          	lw	a5,-20(s0)
   10586:	2781                	sext.w	a5,a5
   10588:	00f04663          	bgtz	a5,10594 <print_hex+0x7e>
   1058c:	fe442783          	lw	a5,-28(s0)
   10590:	2781                	sext.w	a5,a5
   10592:	eba1                	bnez	a5,105e2 <print_hex+0xcc>
   10594:	fec42783          	lw	a5,-20(s0)
   10598:	2785                	addw	a5,a5,1
   1059a:	fef42623          	sw	a5,-20(s0)
   1059e:	fd442783          	lw	a5,-44(s0)
   105a2:	2781                	sext.w	a5,a5
   105a4:	873e                	mv	a4,a5
   105a6:	47a5                	li	a5,9
   105a8:	00e7cb63          	blt	a5,a4,105be <print_hex+0xa8>
   105ac:	fd442783          	lw	a5,-44(s0)
   105b0:	0ff7f793          	zext.b	a5,a5
   105b4:	0307879b          	addw	a5,a5,48
   105b8:	0ff7f793          	zext.b	a5,a5
   105bc:	a809                	j	105ce <print_hex+0xb8>
   105be:	fd442783          	lw	a5,-44(s0)
   105c2:	0ff7f793          	zext.b	a5,a5
   105c6:	0577879b          	addw	a5,a5,87
   105ca:	0ff7f793          	zext.b	a5,a5
   105ce:	fe842703          	lw	a4,-24(s0)
   105d2:	0017069b          	addw	a3,a4,1
   105d6:	fed42423          	sw	a3,-24(s0)
   105da:	1741                	add	a4,a4,-16
   105dc:	9722                	add	a4,a4,s0
   105de:	fcf70023          	sb	a5,-64(a4)
   105e2:	fe442783          	lw	a5,-28(s0)
   105e6:	37fd                	addw	a5,a5,-1
   105e8:	fef42223          	sw	a5,-28(s0)
   105ec:	fe442783          	lw	a5,-28(s0)
   105f0:	2781                	sext.w	a5,a5
   105f2:	f607d6e3          	bgez	a5,1055e <print_hex+0x48>
   105f6:	fa442783          	lw	a5,-92(s0)
   105fa:	873e                	mv	a4,a5
   105fc:	fec42783          	lw	a5,-20(s0)
   10600:	86be                	mv	a3,a5
   10602:	0007079b          	sext.w	a5,a4
   10606:	873e                	mv	a4,a5
   10608:	0006879b          	sext.w	a5,a3
   1060c:	04e7d163          	bge	a5,a4,1064e <print_hex+0x138>
   10610:	fa442783          	lw	a5,-92(s0)
   10614:	873e                	mv	a4,a5
   10616:	fec42783          	lw	a5,-20(s0)
   1061a:	40f707bb          	subw	a5,a4,a5
   1061e:	fef42023          	sw	a5,-32(s0)
   10622:	a831                	j	1063e <print_hex+0x128>
   10624:	fa344783          	lbu	a5,-93(s0)
   10628:	0ff7f793          	zext.b	a5,a5
   1062c:	c781                	beqz	a5,10634 <print_hex+0x11e>
   1062e:	03000793          	li	a5,48
   10632:	a019                	j	10638 <print_hex+0x122>
   10634:	02000793          	li	a5,32
   10638:	853e                	mv	a0,a5
   1063a:	d0fff0ef          	jal	10348 <kputc>
   1063e:	fe042783          	lw	a5,-32(s0)
   10642:	fff7871b          	addw	a4,a5,-1
   10646:	fee42023          	sw	a4,-32(s0)
   1064a:	fcf04de3          	bgtz	a5,10624 <print_hex+0x10e>
   1064e:	fc042e23          	sw	zero,-36(s0)
   10652:	a839                	j	10670 <print_hex+0x15a>
   10654:	fdc42783          	lw	a5,-36(s0)
   10658:	17c1                	add	a5,a5,-16
   1065a:	97a2                	add	a5,a5,s0
   1065c:	fc07c783          	lbu	a5,-64(a5)
   10660:	853e                	mv	a0,a5
   10662:	ce7ff0ef          	jal	10348 <kputc>
   10666:	fdc42783          	lw	a5,-36(s0)
   1066a:	2785                	addw	a5,a5,1
   1066c:	fcf42e23          	sw	a5,-36(s0)
   10670:	fdc42783          	lw	a5,-36(s0)
   10674:	873e                	mv	a4,a5
   10676:	fec42783          	lw	a5,-20(s0)
   1067a:	86be                	mv	a3,a5
   1067c:	0007079b          	sext.w	a5,a4
   10680:	873e                	mv	a4,a5
   10682:	0006879b          	sext.w	a5,a3
   10686:	fcf747e3          	blt	a4,a5,10654 <print_hex+0x13e>
   1068a:	0001                	nop
   1068c:	0001                	nop
   1068e:	60e6                	ld	ra,88(sp)
   10690:	6446                	ld	s0,80(sp)
   10692:	6125                	add	sp,sp,96
   10694:	8082                	ret

0000000000010696 <kprintf>:
   10696:	7175                	add	sp,sp,-144
   10698:	e486                	sd	ra,72(sp)
   1069a:	e0a2                	sd	s0,64(sp)
   1069c:	0880                	add	s0,sp,80
   1069e:	faa43c23          	sd	a0,-72(s0)
   106a2:	e40c                	sd	a1,8(s0)
   106a4:	e810                	sd	a2,16(s0)
   106a6:	ec14                	sd	a3,24(s0)
   106a8:	f018                	sd	a4,32(s0)
   106aa:	f41c                	sd	a5,40(s0)
   106ac:	03043823          	sd	a6,48(s0)
   106b0:	03143c23          	sd	a7,56(s0)
   106b4:	fe0407a3          	sb	zero,-17(s0)
   106b8:	fe040723          	sb	zero,-18(s0)
   106bc:	fc040ba3          	sb	zero,-41(s0)
   106c0:	fe042423          	sw	zero,-24(s0)
   106c4:	fe0403a3          	sb	zero,-25(s0)
   106c8:	04040793          	add	a5,s0,64
   106cc:	faf43823          	sd	a5,-80(s0)
   106d0:	fb043783          	ld	a5,-80(s0)
   106d4:	fc878793          	add	a5,a5,-56
   106d8:	fcf43423          	sd	a5,-56(s0)
   106dc:	a2e1                	j	108a4 <kprintf+0x20e>
   106de:	fef44783          	lbu	a5,-17(s0)
   106e2:	0ff7f793          	zext.b	a5,a5
   106e6:	18078e63          	beqz	a5,10882 <kprintf+0x1ec>
   106ea:	fd644783          	lbu	a5,-42(s0)
   106ee:	0ff7f713          	zext.b	a4,a5
   106f2:	02f00793          	li	a5,47
   106f6:	04e7ff63          	bgeu	a5,a4,10754 <kprintf+0xbe>
   106fa:	fd644783          	lbu	a5,-42(s0)
   106fe:	0ff7f713          	zext.b	a4,a5
   10702:	03900793          	li	a5,57
   10706:	04e7e763          	bltu	a5,a4,10754 <kprintf+0xbe>
   1070a:	fd644783          	lbu	a5,-42(s0)
   1070e:	0ff7f713          	zext.b	a4,a5
   10712:	03000793          	li	a5,48
   10716:	00f71a63          	bne	a4,a5,1072a <kprintf+0x94>
   1071a:	fe842783          	lw	a5,-24(s0)
   1071e:	2781                	sext.w	a5,a5
   10720:	e789                	bnez	a5,1072a <kprintf+0x94>
   10722:	4785                	li	a5,1
   10724:	fef403a3          	sb	a5,-25(s0)
   10728:	aab5                	j	108a4 <kprintf+0x20e>
   1072a:	fe842783          	lw	a5,-24(s0)
   1072e:	873e                	mv	a4,a5
   10730:	87ba                	mv	a5,a4
   10732:	0027979b          	sllw	a5,a5,0x2
   10736:	9fb9                	addw	a5,a5,a4
   10738:	0017979b          	sllw	a5,a5,0x1
   1073c:	0007871b          	sext.w	a4,a5
   10740:	fd644783          	lbu	a5,-42(s0)
   10744:	2781                	sext.w	a5,a5
   10746:	fd07879b          	addw	a5,a5,-48
   1074a:	2781                	sext.w	a5,a5
   1074c:	9fb9                	addw	a5,a5,a4
   1074e:	fef42423          	sw	a5,-24(s0)
   10752:	aa89                	j	108a4 <kprintf+0x20e>
   10754:	fd644783          	lbu	a5,-42(s0)
   10758:	2781                	sext.w	a5,a5
   1075a:	f9d7879b          	addw	a5,a5,-99
   1075e:	86be                	mv	a3,a5
   10760:	0006879b          	sext.w	a5,a3
   10764:	873e                	mv	a4,a5
   10766:	47d5                	li	a5,21
   10768:	0ee7e863          	bltu	a5,a4,10858 <kprintf+0x1c2>
   1076c:	02069793          	sll	a5,a3,0x20
   10770:	9381                	srl	a5,a5,0x20
   10772:	00279713          	sll	a4,a5,0x2
   10776:	00001797          	auipc	a5,0x1
   1077a:	5ea78793          	add	a5,a5,1514 # 11d60 <default_field_entropy+0x170>
   1077e:	97ba                	add	a5,a5,a4
   10780:	439c                	lw	a5,0(a5)
   10782:	0007871b          	sext.w	a4,a5
   10786:	00001797          	auipc	a5,0x1
   1078a:	5da78793          	add	a5,a5,1498 # 11d60 <default_field_entropy+0x170>
   1078e:	97ba                	add	a5,a5,a4
   10790:	8782                	jr	a5
   10792:	4785                	li	a5,1
   10794:	fef40723          	sb	a5,-18(s0)
   10798:	a231                	j	108a4 <kprintf+0x20e>
   1079a:	4785                	li	a5,1
   1079c:	fcf40ba3          	sb	a5,-41(s0)
   107a0:	a211                	j	108a4 <kprintf+0x20e>
   107a2:	fc843783          	ld	a5,-56(s0)
   107a6:	00878713          	add	a4,a5,8
   107aa:	fce43423          	sd	a4,-56(s0)
   107ae:	639c                	ld	a5,0(a5)
   107b0:	fee44683          	lbu	a3,-18(s0)
   107b4:	fe744603          	lbu	a2,-25(s0)
   107b8:	fe842703          	lw	a4,-24(s0)
   107bc:	85ba                	mv	a1,a4
   107be:	853e                	mv	a0,a5
   107c0:	d57ff0ef          	jal	10516 <print_hex>
   107c4:	a065                	j	1086c <kprintf+0x1d6>
   107c6:	fee44783          	lbu	a5,-18(s0)
   107ca:	0ff7f793          	zext.b	a5,a5
   107ce:	cb99                	beqz	a5,107e4 <kprintf+0x14e>
   107d0:	fc843783          	ld	a5,-56(s0)
   107d4:	00878713          	add	a4,a5,8
   107d8:	fce43423          	sd	a4,-56(s0)
   107dc:	639c                	ld	a5,0(a5)
   107de:	fcf43c23          	sd	a5,-40(s0)
   107e2:	a821                	j	107fa <kprintf+0x164>
   107e4:	fc843783          	ld	a5,-56(s0)
   107e8:	00878713          	add	a4,a5,8
   107ec:	fce43423          	sd	a4,-56(s0)
   107f0:	439c                	lw	a5,0(a5)
   107f2:	1782                	sll	a5,a5,0x20
   107f4:	9381                	srl	a5,a5,0x20
   107f6:	fcf43c23          	sd	a5,-40(s0)
   107fa:	fd644783          	lbu	a5,-42(s0)
   107fe:	2781                	sext.w	a5,a5
   10800:	873e                	mv	a4,a5
   10802:	06400793          	li	a5,100
   10806:	40f707b3          	sub	a5,a4,a5
   1080a:	0017b793          	seqz	a5,a5
   1080e:	0ff7f793          	zext.b	a5,a5
   10812:	fe744683          	lbu	a3,-25(s0)
   10816:	fe842703          	lw	a4,-24(s0)
   1081a:	863a                	mv	a2,a4
   1081c:	85be                	mv	a1,a5
   1081e:	fd843503          	ld	a0,-40(s0)
   10822:	bd7ff0ef          	jal	103f8 <print_number>
   10826:	a099                	j	1086c <kprintf+0x1d6>
   10828:	fc843783          	ld	a5,-56(s0)
   1082c:	00878713          	add	a4,a5,8
   10830:	fce43423          	sd	a4,-56(s0)
   10834:	639c                	ld	a5,0(a5)
   10836:	853e                	mv	a0,a5
   10838:	b53ff0ef          	jal	1038a <_kputs>
   1083c:	a805                	j	1086c <kprintf+0x1d6>
   1083e:	fc843783          	ld	a5,-56(s0)
   10842:	00878713          	add	a4,a5,8
   10846:	fce43423          	sd	a4,-56(s0)
   1084a:	439c                	lw	a5,0(a5)
   1084c:	0ff7f793          	zext.b	a5,a5
   10850:	853e                	mv	a0,a5
   10852:	af7ff0ef          	jal	10348 <kputc>
   10856:	a819                	j	1086c <kprintf+0x1d6>
   10858:	02500513          	li	a0,37
   1085c:	aedff0ef          	jal	10348 <kputc>
   10860:	fd644783          	lbu	a5,-42(s0)
   10864:	853e                	mv	a0,a5
   10866:	ae3ff0ef          	jal	10348 <kputc>
   1086a:	0001                	nop
   1086c:	fe0407a3          	sb	zero,-17(s0)
   10870:	fe040723          	sb	zero,-18(s0)
   10874:	fc040ba3          	sb	zero,-41(s0)
   10878:	fe042423          	sw	zero,-24(s0)
   1087c:	fe0403a3          	sb	zero,-25(s0)
   10880:	a015                	j	108a4 <kprintf+0x20e>
   10882:	fd644783          	lbu	a5,-42(s0)
   10886:	0ff7f713          	zext.b	a4,a5
   1088a:	02500793          	li	a5,37
   1088e:	00f71663          	bne	a4,a5,1089a <kprintf+0x204>
   10892:	4785                	li	a5,1
   10894:	fef407a3          	sb	a5,-17(s0)
   10898:	a031                	j	108a4 <kprintf+0x20e>
   1089a:	fd644783          	lbu	a5,-42(s0)
   1089e:	853e                	mv	a0,a5
   108a0:	aa9ff0ef          	jal	10348 <kputc>
   108a4:	fb843783          	ld	a5,-72(s0)
   108a8:	00178713          	add	a4,a5,1
   108ac:	fae43c23          	sd	a4,-72(s0)
   108b0:	0007c783          	lbu	a5,0(a5)
   108b4:	fcf40b23          	sb	a5,-42(s0)
   108b8:	fd644783          	lbu	a5,-42(s0)
   108bc:	0ff7f793          	zext.b	a5,a5
   108c0:	e0079fe3          	bnez	a5,106de <kprintf+0x48>
   108c4:	0001                	nop
   108c6:	0001                	nop
   108c8:	60a6                	ld	ra,72(sp)
   108ca:	6406                	ld	s0,64(sp)
   108cc:	6149                	add	sp,sp,144
   108ce:	8082                	ret

00000000000108d0 <caliptra_generic_and_fuse_read>:
   108d0:	7179                	add	sp,sp,-48
   108d2:	f406                	sd	ra,40(sp)
   108d4:	f022                	sd	s0,32(sp)
   108d6:	1800                	add	s0,sp,48
   108d8:	87aa                	mv	a5,a0
   108da:	fcf42e23          	sw	a5,-36(s0)
   108de:	fdc42783          	lw	a5,-36(s0)
   108e2:	873e                	mv	a4,a5
   108e4:	300307b7          	lui	a5,0x30030
   108e8:	9fb9                	addw	a5,a5,a4
   108ea:	2781                	sext.w	a5,a5
   108ec:	1782                	sll	a5,a5,0x20
   108ee:	9381                	srl	a5,a5,0x20
   108f0:	439c                	lw	a5,0(a5)
   108f2:	fef42623          	sw	a5,-20(s0)
   108f6:	fec42783          	lw	a5,-20(s0)
   108fa:	853e                	mv	a0,a5
   108fc:	70a2                	ld	ra,40(sp)
   108fe:	7402                	ld	s0,32(sp)
   10900:	6145                	add	sp,sp,48
   10902:	8082                	ret

0000000000010904 <caliptra_generic_and_fuse_write>:
   10904:	1101                	add	sp,sp,-32
   10906:	ec06                	sd	ra,24(sp)
   10908:	e822                	sd	s0,16(sp)
   1090a:	1000                	add	s0,sp,32
   1090c:	87aa                	mv	a5,a0
   1090e:	872e                	mv	a4,a1
   10910:	fef42623          	sw	a5,-20(s0)
   10914:	87ba                	mv	a5,a4
   10916:	fef42423          	sw	a5,-24(s0)
   1091a:	fec42783          	lw	a5,-20(s0)
   1091e:	873e                	mv	a4,a5
   10920:	300307b7          	lui	a5,0x30030
   10924:	9fb9                	addw	a5,a5,a4
   10926:	2781                	sext.w	a5,a5
   10928:	1782                	sll	a5,a5,0x20
   1092a:	9381                	srl	a5,a5,0x20
   1092c:	873e                	mv	a4,a5
   1092e:	fe842783          	lw	a5,-24(s0)
   10932:	c31c                	sw	a5,0(a4)
   10934:	0001                	nop
   10936:	60e2                	ld	ra,24(sp)
   10938:	6442                	ld	s0,16(sp)
   1093a:	6105                	add	sp,sp,32
   1093c:	8082                	ret

000000000001093e <caliptra_fuse_array_write>:
   1093e:	7139                	add	sp,sp,-64
   10940:	fc06                	sd	ra,56(sp)
   10942:	f822                	sd	s0,48(sp)
   10944:	0080                	add	s0,sp,64
   10946:	87aa                	mv	a5,a0
   10948:	fcb43823          	sd	a1,-48(s0)
   1094c:	fcc43423          	sd	a2,-56(s0)
   10950:	fcf42e23          	sw	a5,-36(s0)
   10954:	fe042623          	sw	zero,-20(s0)
   10958:	a81d                	j	1098e <caliptra_fuse_array_write+0x50>
   1095a:	fec42783          	lw	a5,-20(s0)
   1095e:	0027979b          	sllw	a5,a5,0x2
   10962:	2781                	sext.w	a5,a5
   10964:	fdc42703          	lw	a4,-36(s0)
   10968:	9fb9                	addw	a5,a5,a4
   1096a:	0007869b          	sext.w	a3,a5
   1096e:	fec46783          	lwu	a5,-20(s0)
   10972:	078a                	sll	a5,a5,0x2
   10974:	fd043703          	ld	a4,-48(s0)
   10978:	97ba                	add	a5,a5,a4
   1097a:	439c                	lw	a5,0(a5)
   1097c:	85be                	mv	a1,a5
   1097e:	8536                	mv	a0,a3
   10980:	f85ff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   10984:	fec42783          	lw	a5,-20(s0)
   10988:	2785                	addw	a5,a5,1 # 30030001 <_sp+0x27ff0009>
   1098a:	fef42623          	sw	a5,-20(s0)
   1098e:	fec46783          	lwu	a5,-20(s0)
   10992:	fc843703          	ld	a4,-56(s0)
   10996:	fce7e2e3          	bltu	a5,a4,1095a <caliptra_fuse_array_write+0x1c>
   1099a:	0001                	nop
   1099c:	0001                	nop
   1099e:	70e2                	ld	ra,56(sp)
   109a0:	7442                	ld	s0,48(sp)
   109a2:	6121                	add	sp,sp,64
   109a4:	8082                	ret

00000000000109a6 <caliptra_wdt_cfg_write>:
   109a6:	1101                	add	sp,sp,-32
   109a8:	ec06                	sd	ra,24(sp)
   109aa:	e822                	sd	s0,16(sp)
   109ac:	1000                	add	s0,sp,32
   109ae:	fea43423          	sd	a0,-24(s0)
   109b2:	fe843783          	ld	a5,-24(s0)
   109b6:	2781                	sext.w	a5,a5
   109b8:	85be                	mv	a1,a5
   109ba:	11000513          	li	a0,272
   109be:	f47ff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   109c2:	fe843783          	ld	a5,-24(s0)
   109c6:	9381                	srl	a5,a5,0x20
   109c8:	2781                	sext.w	a5,a5
   109ca:	85be                	mv	a1,a5
   109cc:	11400513          	li	a0,276
   109d0:	f35ff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   109d4:	0001                	nop
   109d6:	60e2                	ld	ra,24(sp)
   109d8:	6442                	ld	s0,16(sp)
   109da:	6105                	add	sp,sp,32
   109dc:	8082                	ret

00000000000109de <caliptra_write_itrng_entropy_low_threshold>:
   109de:	7179                	add	sp,sp,-48
   109e0:	f406                	sd	ra,40(sp)
   109e2:	f022                	sd	s0,32(sp)
   109e4:	1800                	add	s0,sp,48
   109e6:	87aa                	mv	a5,a0
   109e8:	fcf41f23          	sh	a5,-34(s0)
   109ec:	11800513          	li	a0,280
   109f0:	ee1ff0ef          	jal	108d0 <caliptra_generic_and_fuse_read>
   109f4:	87aa                	mv	a5,a0
   109f6:	fef42623          	sw	a5,-20(s0)
   109fa:	fec42783          	lw	a5,-20(s0)
   109fe:	873e                	mv	a4,a5
   10a00:	77c1                	lui	a5,0xffff0
   10a02:	8ff9                	and	a5,a5,a4
   10a04:	fef42623          	sw	a5,-20(s0)
   10a08:	fde45783          	lhu	a5,-34(s0)
   10a0c:	2781                	sext.w	a5,a5
   10a0e:	fec42703          	lw	a4,-20(s0)
   10a12:	8fd9                	or	a5,a5,a4
   10a14:	fef42623          	sw	a5,-20(s0)
   10a18:	fec42783          	lw	a5,-20(s0)
   10a1c:	85be                	mv	a1,a5
   10a1e:	11800513          	li	a0,280
   10a22:	ee3ff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   10a26:	0001                	nop
   10a28:	70a2                	ld	ra,40(sp)
   10a2a:	7402                	ld	s0,32(sp)
   10a2c:	6145                	add	sp,sp,48
   10a2e:	8082                	ret

0000000000010a30 <caliptra_write_itrng_entropy_high_threshold>:
   10a30:	7179                	add	sp,sp,-48
   10a32:	f406                	sd	ra,40(sp)
   10a34:	f022                	sd	s0,32(sp)
   10a36:	1800                	add	s0,sp,48
   10a38:	87aa                	mv	a5,a0
   10a3a:	fcf41f23          	sh	a5,-34(s0)
   10a3e:	11800513          	li	a0,280
   10a42:	e8fff0ef          	jal	108d0 <caliptra_generic_and_fuse_read>
   10a46:	87aa                	mv	a5,a0
   10a48:	fef42623          	sw	a5,-20(s0)
   10a4c:	fec42783          	lw	a5,-20(s0)
   10a50:	17c2                	sll	a5,a5,0x30
   10a52:	93c1                	srl	a5,a5,0x30
   10a54:	fef42623          	sw	a5,-20(s0)
   10a58:	fde45783          	lhu	a5,-34(s0)
   10a5c:	2781                	sext.w	a5,a5
   10a5e:	0107979b          	sllw	a5,a5,0x10
   10a62:	2781                	sext.w	a5,a5
   10a64:	fec42703          	lw	a4,-20(s0)
   10a68:	8fd9                	or	a5,a5,a4
   10a6a:	fef42623          	sw	a5,-20(s0)
   10a6e:	fec42783          	lw	a5,-20(s0)
   10a72:	85be                	mv	a1,a5
   10a74:	11800513          	li	a0,280
   10a78:	e8dff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   10a7c:	0001                	nop
   10a7e:	70a2                	ld	ra,40(sp)
   10a80:	7402                	ld	s0,32(sp)
   10a82:	6145                	add	sp,sp,48
   10a84:	8082                	ret

0000000000010a86 <caliptra_write_itrng_entropy_repetition_count>:
   10a86:	7179                	add	sp,sp,-48
   10a88:	f406                	sd	ra,40(sp)
   10a8a:	f022                	sd	s0,32(sp)
   10a8c:	1800                	add	s0,sp,48
   10a8e:	87aa                	mv	a5,a0
   10a90:	fcf41f23          	sh	a5,-34(s0)
   10a94:	11c00513          	li	a0,284
   10a98:	e39ff0ef          	jal	108d0 <caliptra_generic_and_fuse_read>
   10a9c:	87aa                	mv	a5,a0
   10a9e:	fef42623          	sw	a5,-20(s0)
   10aa2:	fec42783          	lw	a5,-20(s0)
   10aa6:	873e                	mv	a4,a5
   10aa8:	77c1                	lui	a5,0xffff0
   10aaa:	8ff9                	and	a5,a5,a4
   10aac:	fef42623          	sw	a5,-20(s0)
   10ab0:	fde45783          	lhu	a5,-34(s0)
   10ab4:	2781                	sext.w	a5,a5
   10ab6:	fec42703          	lw	a4,-20(s0)
   10aba:	8fd9                	or	a5,a5,a4
   10abc:	fef42623          	sw	a5,-20(s0)
   10ac0:	fec42783          	lw	a5,-20(s0)
   10ac4:	85be                	mv	a1,a5
   10ac6:	11c00513          	li	a0,284
   10aca:	e3bff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   10ace:	0001                	nop
   10ad0:	70a2                	ld	ra,40(sp)
   10ad2:	7402                	ld	s0,32(sp)
   10ad4:	6145                	add	sp,sp,48
   10ad6:	8082                	ret

0000000000010ad8 <memset>:
   10ad8:	7139                	add	sp,sp,-64
   10ada:	fc06                	sd	ra,56(sp)
   10adc:	f822                	sd	s0,48(sp)
   10ade:	0080                	add	s0,sp,64
   10ae0:	fca43c23          	sd	a0,-40(s0)
   10ae4:	87ae                	mv	a5,a1
   10ae6:	fcc43423          	sd	a2,-56(s0)
   10aea:	fcf42a23          	sw	a5,-44(s0)
   10aee:	fd843783          	ld	a5,-40(s0)
   10af2:	fef43023          	sd	a5,-32(s0)
   10af6:	fe043423          	sd	zero,-24(s0)
   10afa:	a00d                	j	10b1c <memset+0x44>
   10afc:	fe043703          	ld	a4,-32(s0)
   10b00:	fe843783          	ld	a5,-24(s0)
   10b04:	97ba                	add	a5,a5,a4
   10b06:	fd442703          	lw	a4,-44(s0)
   10b0a:	0ff77713          	zext.b	a4,a4
   10b0e:	00e78023          	sb	a4,0(a5) # ffffffffffff0000 <_sp+0xfffffffff7fb0008>
   10b12:	fe843783          	ld	a5,-24(s0)
   10b16:	0785                	add	a5,a5,1
   10b18:	fef43423          	sd	a5,-24(s0)
   10b1c:	fe843703          	ld	a4,-24(s0)
   10b20:	fc843783          	ld	a5,-56(s0)
   10b24:	fcf76ce3          	bltu	a4,a5,10afc <memset+0x24>
   10b28:	fd843783          	ld	a5,-40(s0)
   10b2c:	853e                	mv	a0,a5
   10b2e:	70e2                	ld	ra,56(sp)
   10b30:	7442                	ld	s0,48(sp)
   10b32:	6121                	add	sp,sp,64
   10b34:	8082                	ret

0000000000010b36 <memcpy>:
   10b36:	715d                	add	sp,sp,-80
   10b38:	e486                	sd	ra,72(sp)
   10b3a:	e0a2                	sd	s0,64(sp)
   10b3c:	0880                	add	s0,sp,80
   10b3e:	fca43423          	sd	a0,-56(s0)
   10b42:	fcb43023          	sd	a1,-64(s0)
   10b46:	fac43c23          	sd	a2,-72(s0)
   10b4a:	fc843783          	ld	a5,-56(s0)
   10b4e:	fef43023          	sd	a5,-32(s0)
   10b52:	fc043783          	ld	a5,-64(s0)
   10b56:	fcf43c23          	sd	a5,-40(s0)
   10b5a:	fe043423          	sd	zero,-24(s0)
   10b5e:	a025                	j	10b86 <memcpy+0x50>
   10b60:	fd843703          	ld	a4,-40(s0)
   10b64:	fe843783          	ld	a5,-24(s0)
   10b68:	973e                	add	a4,a4,a5
   10b6a:	fe043683          	ld	a3,-32(s0)
   10b6e:	fe843783          	ld	a5,-24(s0)
   10b72:	97b6                	add	a5,a5,a3
   10b74:	00074703          	lbu	a4,0(a4)
   10b78:	00e78023          	sb	a4,0(a5)
   10b7c:	fe843783          	ld	a5,-24(s0)
   10b80:	0785                	add	a5,a5,1
   10b82:	fef43423          	sd	a5,-24(s0)
   10b86:	fe843703          	ld	a4,-24(s0)
   10b8a:	fb843783          	ld	a5,-72(s0)
   10b8e:	fcf769e3          	bltu	a4,a5,10b60 <memcpy+0x2a>
   10b92:	fc843783          	ld	a5,-56(s0)
   10b96:	853e                	mv	a0,a5
   10b98:	60a6                	ld	ra,72(sp)
   10b9a:	6406                	ld	s0,64(sp)
   10b9c:	6161                	add	sp,sp,80
   10b9e:	8082                	ret

0000000000010ba0 <__bswapsi2>:
   10ba0:	1101                	add	sp,sp,-32
   10ba2:	ec06                	sd	ra,24(sp)
   10ba4:	e822                	sd	s0,16(sp)
   10ba6:	1000                	add	s0,sp,32
   10ba8:	87aa                	mv	a5,a0
   10baa:	fef42623          	sw	a5,-20(s0)
   10bae:	fec42783          	lw	a5,-20(s0)
   10bb2:	0187d79b          	srlw	a5,a5,0x18
   10bb6:	0007871b          	sext.w	a4,a5
   10bba:	fec42783          	lw	a5,-20(s0)
   10bbe:	0087d79b          	srlw	a5,a5,0x8
   10bc2:	2781                	sext.w	a5,a5
   10bc4:	86be                	mv	a3,a5
   10bc6:	67c1                	lui	a5,0x10
   10bc8:	f0078793          	add	a5,a5,-256 # ff00 <_prog_start-0x100>
   10bcc:	8ff5                	and	a5,a5,a3
   10bce:	2781                	sext.w	a5,a5
   10bd0:	8fd9                	or	a5,a5,a4
   10bd2:	0007871b          	sext.w	a4,a5
   10bd6:	fec42783          	lw	a5,-20(s0)
   10bda:	0087979b          	sllw	a5,a5,0x8
   10bde:	2781                	sext.w	a5,a5
   10be0:	86be                	mv	a3,a5
   10be2:	00ff07b7          	lui	a5,0xff0
   10be6:	8ff5                	and	a5,a5,a3
   10be8:	2781                	sext.w	a5,a5
   10bea:	8fd9                	or	a5,a5,a4
   10bec:	0007871b          	sext.w	a4,a5
   10bf0:	fec42783          	lw	a5,-20(s0)
   10bf4:	0187979b          	sllw	a5,a5,0x18
   10bf8:	2781                	sext.w	a5,a5
   10bfa:	8fd9                	or	a5,a5,a4
   10bfc:	2781                	sext.w	a5,a5
   10bfe:	853e                	mv	a0,a5
   10c00:	60e2                	ld	ra,24(sp)
   10c02:	6442                	ld	s0,16(sp)
   10c04:	6105                	add	sp,sp,32
   10c06:	8082                	ret

0000000000010c08 <delay_ms>:
   10c08:	1101                	add	sp,sp,-32
   10c0a:	ec06                	sd	ra,24(sp)
   10c0c:	e822                	sd	s0,16(sp)
   10c0e:	1000                	add	s0,sp,32
   10c10:	87aa                	mv	a5,a0
   10c12:	fef42623          	sw	a5,-20(s0)
   10c16:	a031                	j	10c22 <delay_ms+0x1a>
   10c18:	fec42783          	lw	a5,-20(s0)
   10c1c:	37fd                	addw	a5,a5,-1 # feffff <dtb+0xfde09f>
   10c1e:	fef42623          	sw	a5,-20(s0)
   10c22:	fec42783          	lw	a5,-20(s0)
   10c26:	2781                	sext.w	a5,a5
   10c28:	fbe5                	bnez	a5,10c18 <delay_ms+0x10>
   10c2a:	0001                	nop
   10c2c:	0001                	nop
   10c2e:	60e2                	ld	ra,24(sp)
   10c30:	6442                	ld	s0,16(sp)
   10c32:	6105                	add	sp,sp,32
   10c34:	8082                	ret

0000000000010c36 <caliptra1x_set_fuses>:
   10c36:	7109                	add	sp,sp,-384
   10c38:	fe86                	sd	ra,376(sp)
   10c3a:	faa2                	sd	s0,368(sp)
   10c3c:	0300                	add	s0,sp,384
   10c3e:	e8a43423          	sd	a0,-376(s0)
   10c42:	e8843783          	ld	a5,-376(s0)
   10c46:	02078793          	add	a5,a5,32
   10c4a:	fef43423          	sd	a5,-24(s0)
   10c4e:	fe843783          	ld	a5,-24(s0)
   10c52:	873e                	mv	a4,a5
   10c54:	14c00793          	li	a5,332
   10c58:	863e                	mv	a2,a5
   10c5a:	4581                	li	a1,0
   10c5c:	853a                	mv	a0,a4
   10c5e:	e7bff0ef          	jal	10ad8 <memset>
   10c62:	fe843783          	ld	a5,-24(s0)
   10c66:	03000613          	li	a2,48
   10c6a:	00001597          	auipc	a1,0x1
   10c6e:	15658593          	add	a1,a1,342 # 11dc0 <default_uds_seed>
   10c72:	853e                	mv	a0,a5
   10c74:	ec3ff0ef          	jal	10b36 <memcpy>
   10c78:	fe843783          	ld	a5,-24(s0)
   10c7c:	03078793          	add	a5,a5,48
   10c80:	02000613          	li	a2,32
   10c84:	00001597          	auipc	a1,0x1
   10c88:	16c58593          	add	a1,a1,364 # 11df0 <default_field_entropy>
   10c8c:	853e                	mv	a0,a5
   10c8e:	ea9ff0ef          	jal	10b36 <memcpy>
   10c92:	fe843783          	ld	a5,-24(s0)
   10c96:	670d                	lui	a4,0x3
   10c98:	a4c70713          	add	a4,a4,-1460 # 2a4c <_prog_start-0xd5b4>
   10c9c:	14e79423          	sh	a4,328(a5)
   10ca0:	0001                	nop
   10ca2:	70f6                	ld	ra,376(sp)
   10ca4:	7456                	ld	s0,368(sp)
   10ca6:	6119                	add	sp,sp,384
   10ca8:	8082                	ret

0000000000010caa <caliptra_bootfsm_go>:
   10caa:	1141                	add	sp,sp,-16
   10cac:	e406                	sd	ra,8(sp)
   10cae:	e022                	sd	s0,0(sp)
   10cb0:	0800                	add	s0,sp,16
   10cb2:	300307b7          	lui	a5,0x30030
   10cb6:	0b878793          	add	a5,a5,184 # 300300b8 <_sp+0x27ff00c0>
   10cba:	4705                	li	a4,1
   10cbc:	c398                	sw	a4,0(a5)
   10cbe:	4781                	li	a5,0
   10cc0:	853e                	mv	a0,a5
   10cc2:	60a2                	ld	ra,8(sp)
   10cc4:	6402                	ld	s0,0(sp)
   10cc6:	0141                	add	sp,sp,16
   10cc8:	8082                	ret

0000000000010cca <caliptra_read_status>:
   10cca:	1101                	add	sp,sp,-32
   10ccc:	ec06                	sd	ra,24(sp)
   10cce:	e822                	sd	s0,16(sp)
   10cd0:	1000                	add	s0,sp,32
   10cd2:	300307b7          	lui	a5,0x30030
   10cd6:	03c78793          	add	a5,a5,60 # 3003003c <_sp+0x27ff0044>
   10cda:	439c                	lw	a5,0(a5)
   10cdc:	fef42623          	sw	a5,-20(s0)
   10ce0:	fec42783          	lw	a5,-20(s0)
   10ce4:	853e                	mv	a0,a5
   10ce6:	60e2                	ld	ra,24(sp)
   10ce8:	6442                	ld	s0,16(sp)
   10cea:	6105                	add	sp,sp,32
   10cec:	8082                	ret

0000000000010cee <caliptra_req_idev_csr_start>:
   10cee:	1101                	add	sp,sp,-32
   10cf0:	ec06                	sd	ra,24(sp)
   10cf2:	e822                	sd	s0,16(sp)
   10cf4:	1000                	add	s0,sp,32
   10cf6:	300307b7          	lui	a5,0x30030
   10cfa:	0bc78793          	add	a5,a5,188 # 300300bc <_sp+0x27ff00c4>
   10cfe:	439c                	lw	a5,0(a5)
   10d00:	fef42623          	sw	a5,-20(s0)
   10d04:	300307b7          	lui	a5,0x30030
   10d08:	0bc78793          	add	a5,a5,188 # 300300bc <_sp+0x27ff00c4>
   10d0c:	fec42703          	lw	a4,-20(s0)
   10d10:	00176713          	or	a4,a4,1
   10d14:	2701                	sext.w	a4,a4
   10d16:	c398                	sw	a4,0(a5)
   10d18:	0001                	nop
   10d1a:	60e2                	ld	ra,24(sp)
   10d1c:	6442                	ld	s0,16(sp)
   10d1e:	6105                	add	sp,sp,32
   10d20:	8082                	ret

0000000000010d22 <caliptra_configure_itrng_entropy>:
   10d22:	1101                	add	sp,sp,-32
   10d24:	ec06                	sd	ra,24(sp)
   10d26:	e822                	sd	s0,16(sp)
   10d28:	1000                	add	s0,sp,32
   10d2a:	87aa                	mv	a5,a0
   10d2c:	86ae                	mv	a3,a1
   10d2e:	8732                	mv	a4,a2
   10d30:	fef41723          	sh	a5,-18(s0)
   10d34:	87b6                	mv	a5,a3
   10d36:	fef41623          	sh	a5,-20(s0)
   10d3a:	87ba                	mv	a5,a4
   10d3c:	fef41523          	sh	a5,-22(s0)
   10d40:	fee45783          	lhu	a5,-18(s0)
   10d44:	853e                	mv	a0,a5
   10d46:	c99ff0ef          	jal	109de <caliptra_write_itrng_entropy_low_threshold>
   10d4a:	fec45783          	lhu	a5,-20(s0)
   10d4e:	853e                	mv	a0,a5
   10d50:	ce1ff0ef          	jal	10a30 <caliptra_write_itrng_entropy_high_threshold>
   10d54:	fea45783          	lhu	a5,-22(s0)
   10d58:	853e                	mv	a0,a5
   10d5a:	d2dff0ef          	jal	10a86 <caliptra_write_itrng_entropy_repetition_count>
   10d5e:	0001                	nop
   10d60:	60e2                	ld	ra,24(sp)
   10d62:	6442                	ld	s0,16(sp)
   10d64:	6105                	add	sp,sp,32
   10d66:	8082                	ret

0000000000010d68 <caliptra_set_wdt_timeout>:
   10d68:	1101                	add	sp,sp,-32
   10d6a:	ec06                	sd	ra,24(sp)
   10d6c:	e822                	sd	s0,16(sp)
   10d6e:	1000                	add	s0,sp,32
   10d70:	fea43423          	sd	a0,-24(s0)
   10d74:	fe843503          	ld	a0,-24(s0)
   10d78:	c2fff0ef          	jal	109a6 <caliptra_wdt_cfg_write>
   10d7c:	0001                	nop
   10d7e:	60e2                	ld	ra,24(sp)
   10d80:	6442                	ld	s0,16(sp)
   10d82:	6105                	add	sp,sp,32
   10d84:	8082                	ret

0000000000010d86 <caliptra_ready_for_fuses>:
   10d86:	1101                	add	sp,sp,-32
   10d88:	ec06                	sd	ra,24(sp)
   10d8a:	e822                	sd	s0,16(sp)
   10d8c:	1000                	add	s0,sp,32
   10d8e:	300307b7          	lui	a5,0x30030
   10d92:	03c78793          	add	a5,a5,60 # 3003003c <_sp+0x27ff0044>
   10d96:	439c                	lw	a5,0(a5)
   10d98:	fef42623          	sw	a5,-20(s0)
   10d9c:	fec42783          	lw	a5,-20(s0)
   10da0:	873e                	mv	a4,a5
   10da2:	400007b7          	lui	a5,0x40000
   10da6:	8ff9                	and	a5,a5,a4
   10da8:	2781                	sext.w	a5,a5
   10daa:	c399                	beqz	a5,10db0 <caliptra_ready_for_fuses+0x2a>
   10dac:	4785                	li	a5,1
   10dae:	a011                	j	10db2 <caliptra_ready_for_fuses+0x2c>
   10db0:	4781                	li	a5,0
   10db2:	853e                	mv	a0,a5
   10db4:	60e2                	ld	ra,24(sp)
   10db6:	6442                	ld	s0,16(sp)
   10db8:	6105                	add	sp,sp,32
   10dba:	8082                	ret

0000000000010dbc <caliptra_init_fuses>:
   10dbc:	1101                	add	sp,sp,-32
   10dbe:	ec06                	sd	ra,24(sp)
   10dc0:	e822                	sd	s0,16(sp)
   10dc2:	1000                	add	s0,sp,32
   10dc4:	fea43423          	sd	a0,-24(s0)
   10dc8:	fe843783          	ld	a5,-24(s0)
   10dcc:	e781                	bnez	a5,10dd4 <caliptra_init_fuses+0x18>
   10dce:	10000793          	li	a5,256
   10dd2:	a08d                	j	10e34 <caliptra_init_fuses+0x78>
   10dd4:	fe843783          	ld	a5,-24(s0)
   10dd8:	4631                	li	a2,12
   10dda:	85be                	mv	a1,a5
   10ddc:	20000513          	li	a0,512
   10de0:	b5fff0ef          	jal	1093e <caliptra_fuse_array_write>
   10de4:	fe843783          	ld	a5,-24(s0)
   10de8:	03078793          	add	a5,a5,48 # 40000030 <_sp+0x37fc0038>
   10dec:	4621                	li	a2,8
   10dee:	85be                	mv	a1,a5
   10df0:	23000513          	li	a0,560
   10df4:	b4bff0ef          	jal	1093e <caliptra_fuse_array_write>
   10df8:	fe843783          	ld	a5,-24(s0)
   10dfc:	1487d783          	lhu	a5,328(a5)
   10e00:	2781                	sext.w	a5,a5
   10e02:	85be                	mv	a1,a5
   10e04:	34800513          	li	a0,840
   10e08:	afdff0ef          	jal	10904 <caliptra_generic_and_fuse_write>
   10e0c:	300307b7          	lui	a5,0x30030
   10e10:	0b078793          	add	a5,a5,176 # 300300b0 <_sp+0x27ff00b8>
   10e14:	4705                	li	a4,1
   10e16:	c398                	sw	a4,0(a5)
   10e18:	f6fff0ef          	jal	10d86 <caliptra_ready_for_fuses>
   10e1c:	87aa                	mv	a5,a0
   10e1e:	cb91                	beqz	a5,10e32 <caliptra_init_fuses+0x76>
   10e20:	00001517          	auipc	a0,0x1
   10e24:	ff050513          	add	a0,a0,-16 # 11e10 <default_field_entropy+0x20>
   10e28:	86fff0ef          	jal	10696 <kprintf>
   10e2c:	20100793          	li	a5,513
   10e30:	a011                	j	10e34 <caliptra_init_fuses+0x78>
   10e32:	4781                	li	a5,0
   10e34:	853e                	mv	a0,a5
   10e36:	60e2                	ld	ra,24(sp)
   10e38:	6442                	ld	s0,16(sp)
   10e3a:	6105                	add	sp,sp,32
   10e3c:	8082                	ret

0000000000010e3e <caliptra_ready_for_firmware>:
   10e3e:	1101                	add	sp,sp,-32
   10e40:	ec06                	sd	ra,24(sp)
   10e42:	e822                	sd	s0,16(sp)
   10e44:	1000                	add	s0,sp,32
   10e46:	fe0407a3          	sb	zero,-17(s0)
   10e4a:	e81ff0ef          	jal	10cca <caliptra_read_status>
   10e4e:	87aa                	mv	a5,a0
   10e50:	fef42423          	sw	a5,-24(s0)
   10e54:	fe842783          	lw	a5,-24(s0)
   10e58:	873e                	mv	a4,a5
   10e5a:	100007b7          	lui	a5,0x10000
   10e5e:	8ff9                	and	a5,a5,a4
   10e60:	2781                	sext.w	a5,a5
   10e62:	c789                	beqz	a5,10e6c <caliptra_ready_for_firmware+0x2e>
   10e64:	4785                	li	a5,1
   10e66:	fef407a3          	sb	a5,-17(s0)
   10e6a:	a029                	j	10e74 <caliptra_ready_for_firmware+0x36>
   10e6c:	3e800513          	li	a0,1000
   10e70:	d99ff0ef          	jal	10c08 <delay_ms>
   10e74:	fef44783          	lbu	a5,-17(s0)
   10e78:	0017c793          	xor	a5,a5,1
   10e7c:	0ff7f793          	zext.b	a5,a5
   10e80:	f7e9                	bnez	a5,10e4a <caliptra_ready_for_firmware+0xc>
   10e82:	4785                	li	a5,1
   10e84:	853e                	mv	a0,a5
   10e86:	60e2                	ld	ra,24(sp)
   10e88:	6442                	ld	s0,16(sp)
   10e8a:	6105                	add	sp,sp,32
   10e8c:	8082                	ret

0000000000010e8e <caliptra1x_drv_init>:
   10e8e:	7179                	add	sp,sp,-48
   10e90:	f406                	sd	ra,40(sp)
   10e92:	f022                	sd	s0,32(sp)
   10e94:	1800                	add	s0,sp,48
   10e96:	fca43c23          	sd	a0,-40(s0)
   10e9a:	87ae                	mv	a5,a1
   10e9c:	fcf40ba3          	sb	a5,-41(s0)
   10ea0:	fe042623          	sw	zero,-20(s0)
   10ea4:	fd744783          	lbu	a5,-41(s0)
   10ea8:	0ff7f793          	zext.b	a5,a5
   10eac:	c399                	beqz	a5,10eb2 <caliptra1x_drv_init+0x24>
   10eae:	e41ff0ef          	jal	10cee <caliptra_req_idev_csr_start>
   10eb2:	4795                	li	a5,5
   10eb4:	07f6                	sll	a5,a5,0x1d
   10eb6:	853e                	mv	a0,a5
   10eb8:	eb1ff0ef          	jal	10d68 <caliptra_set_wdt_timeout>
   10ebc:	4705                	li	a4,1
   10ebe:	67c1                	lui	a5,0x10
   10ec0:	fff78693          	add	a3,a5,-1 # ffff <_prog_start-0x1>
   10ec4:	67c1                	lui	a5,0x10
   10ec6:	17fd                	add	a5,a5,-1 # ffff <_prog_start-0x1>
   10ec8:	863e                	mv	a2,a5
   10eca:	85b6                	mv	a1,a3
   10ecc:	853a                	mv	a0,a4
   10ece:	e55ff0ef          	jal	10d22 <caliptra_configure_itrng_entropy>
   10ed2:	fd843783          	ld	a5,-40(s0)
   10ed6:	02078793          	add	a5,a5,32
   10eda:	853e                	mv	a0,a5
   10edc:	ee1ff0ef          	jal	10dbc <caliptra_init_fuses>
   10ee0:	87aa                	mv	a5,a0
   10ee2:	fef42623          	sw	a5,-20(s0)
   10ee6:	fec42783          	lw	a5,-20(s0)
   10eea:	2781                	sext.w	a5,a5
   10eec:	cf89                	beqz	a5,10f06 <caliptra1x_drv_init+0x78>
   10eee:	fec42783          	lw	a5,-20(s0)
   10ef2:	85be                	mv	a1,a5
   10ef4:	00001517          	auipc	a0,0x1
   10ef8:	f2450513          	add	a0,a0,-220 # 11e18 <default_field_entropy+0x28>
   10efc:	f9aff0ef          	jal	10696 <kprintf>
   10f00:	fec42783          	lw	a5,-20(s0)
   10f04:	a029                	j	10f0e <caliptra1x_drv_init+0x80>
   10f06:	da5ff0ef          	jal	10caa <caliptra_bootfsm_go>
   10f0a:	fec42783          	lw	a5,-20(s0)
   10f0e:	853e                	mv	a0,a5
   10f10:	70a2                	ld	ra,40(sp)
   10f12:	7402                	ld	s0,32(sp)
   10f14:	6145                	add	sp,sp,48
   10f16:	8082                	ret

0000000000010f18 <delay_ms>:
   10f18:	1101                	add	sp,sp,-32
   10f1a:	ec06                	sd	ra,24(sp)
   10f1c:	e822                	sd	s0,16(sp)
   10f1e:	1000                	add	s0,sp,32
   10f20:	87aa                	mv	a5,a0
   10f22:	fef42623          	sw	a5,-20(s0)
   10f26:	a031                	j	10f32 <delay_ms+0x1a>
   10f28:	fec42783          	lw	a5,-20(s0)
   10f2c:	37fd                	addw	a5,a5,-1
   10f2e:	fef42623          	sw	a5,-20(s0)
   10f32:	fec42783          	lw	a5,-20(s0)
   10f36:	2781                	sext.w	a5,a5
   10f38:	fbe5                	bnez	a5,10f28 <delay_ms+0x10>
   10f3a:	0001                	nop
   10f3c:	0001                	nop
   10f3e:	60e2                	ld	ra,24(sp)
   10f40:	6442                	ld	s0,16(sp)
   10f42:	6105                	add	sp,sp,32
   10f44:	8082                	ret

0000000000010f46 <caliptra_mbox_write>:
   10f46:	1101                	add	sp,sp,-32
   10f48:	ec06                	sd	ra,24(sp)
   10f4a:	e822                	sd	s0,16(sp)
   10f4c:	1000                	add	s0,sp,32
   10f4e:	87aa                	mv	a5,a0
   10f50:	872e                	mv	a4,a1
   10f52:	fef42623          	sw	a5,-20(s0)
   10f56:	87ba                	mv	a5,a4
   10f58:	fef42423          	sw	a5,-24(s0)
   10f5c:	fec42783          	lw	a5,-20(s0)
   10f60:	873e                	mv	a4,a5
   10f62:	300207b7          	lui	a5,0x30020
   10f66:	9fb9                	addw	a5,a5,a4
   10f68:	2781                	sext.w	a5,a5
   10f6a:	1782                	sll	a5,a5,0x20
   10f6c:	9381                	srl	a5,a5,0x20
   10f6e:	873e                	mv	a4,a5
   10f70:	fe842783          	lw	a5,-24(s0)
   10f74:	c31c                	sw	a5,0(a4)
   10f76:	0001                	nop
   10f78:	60e2                	ld	ra,24(sp)
   10f7a:	6442                	ld	s0,16(sp)
   10f7c:	6105                	add	sp,sp,32
   10f7e:	8082                	ret

0000000000010f80 <caliptra_mbox_read>:
   10f80:	7179                	add	sp,sp,-48
   10f82:	f406                	sd	ra,40(sp)
   10f84:	f022                	sd	s0,32(sp)
   10f86:	1800                	add	s0,sp,48
   10f88:	87aa                	mv	a5,a0
   10f8a:	fcf42e23          	sw	a5,-36(s0)
   10f8e:	fdc42783          	lw	a5,-36(s0)
   10f92:	873e                	mv	a4,a5
   10f94:	300207b7          	lui	a5,0x30020
   10f98:	9fb9                	addw	a5,a5,a4
   10f9a:	2781                	sext.w	a5,a5
   10f9c:	1782                	sll	a5,a5,0x20
   10f9e:	9381                	srl	a5,a5,0x20
   10fa0:	439c                	lw	a5,0(a5)
   10fa2:	fef42623          	sw	a5,-20(s0)
   10fa6:	fec42783          	lw	a5,-20(s0)
   10faa:	853e                	mv	a0,a5
   10fac:	70a2                	ld	ra,40(sp)
   10fae:	7402                	ld	s0,32(sp)
   10fb0:	6145                	add	sp,sp,48
   10fb2:	8082                	ret

0000000000010fb4 <caliptra_mbox_is_lock>:
   10fb4:	1141                	add	sp,sp,-16
   10fb6:	e406                	sd	ra,8(sp)
   10fb8:	e022                	sd	s0,0(sp)
   10fba:	0800                	add	s0,sp,16
   10fbc:	4501                	li	a0,0
   10fbe:	fc3ff0ef          	jal	10f80 <caliptra_mbox_read>
   10fc2:	87aa                	mv	a5,a0
   10fc4:	8b85                	and	a5,a5,1
   10fc6:	2781                	sext.w	a5,a5
   10fc8:	00f037b3          	snez	a5,a5
   10fcc:	0ff7f793          	zext.b	a5,a5
   10fd0:	853e                	mv	a0,a5
   10fd2:	60a2                	ld	ra,8(sp)
   10fd4:	6402                	ld	s0,0(sp)
   10fd6:	0141                	add	sp,sp,16
   10fd8:	8082                	ret

0000000000010fda <caliptra_mbox_write_cmd>:
   10fda:	1101                	add	sp,sp,-32
   10fdc:	ec06                	sd	ra,24(sp)
   10fde:	e822                	sd	s0,16(sp)
   10fe0:	1000                	add	s0,sp,32
   10fe2:	87aa                	mv	a5,a0
   10fe4:	fef42623          	sw	a5,-20(s0)
   10fe8:	fec42783          	lw	a5,-20(s0)
   10fec:	85be                	mv	a1,a5
   10fee:	4521                	li	a0,8
   10ff0:	f57ff0ef          	jal	10f46 <caliptra_mbox_write>
   10ff4:	0001                	nop
   10ff6:	60e2                	ld	ra,24(sp)
   10ff8:	6442                	ld	s0,16(sp)
   10ffa:	6105                	add	sp,sp,32
   10ffc:	8082                	ret

0000000000010ffe <caliptra_mbox_read_execute>:
   10ffe:	1141                	add	sp,sp,-16
   11000:	e406                	sd	ra,8(sp)
   11002:	e022                	sd	s0,0(sp)
   11004:	0800                	add	s0,sp,16
   11006:	4561                	li	a0,24
   11008:	f79ff0ef          	jal	10f80 <caliptra_mbox_read>
   1100c:	87aa                	mv	a5,a0
   1100e:	853e                	mv	a0,a5
   11010:	60a2                	ld	ra,8(sp)
   11012:	6402                	ld	s0,0(sp)
   11014:	0141                	add	sp,sp,16
   11016:	8082                	ret

0000000000011018 <caliptra_mbox_write_execute>:
   11018:	1101                	add	sp,sp,-32
   1101a:	ec06                	sd	ra,24(sp)
   1101c:	e822                	sd	s0,16(sp)
   1101e:	1000                	add	s0,sp,32
   11020:	87aa                	mv	a5,a0
   11022:	fef407a3          	sb	a5,-17(s0)
   11026:	fef44783          	lbu	a5,-17(s0)
   1102a:	2781                	sext.w	a5,a5
   1102c:	85be                	mv	a1,a5
   1102e:	4561                	li	a0,24
   11030:	f17ff0ef          	jal	10f46 <caliptra_mbox_write>
   11034:	0001                	nop
   11036:	60e2                	ld	ra,24(sp)
   11038:	6442                	ld	s0,16(sp)
   1103a:	6105                	add	sp,sp,32
   1103c:	8082                	ret

000000000001103e <caliptra_mbox_read_status>:
   1103e:	1141                	add	sp,sp,-16
   11040:	e406                	sd	ra,8(sp)
   11042:	e022                	sd	s0,0(sp)
   11044:	0800                	add	s0,sp,16
   11046:	4571                	li	a0,28
   11048:	f39ff0ef          	jal	10f80 <caliptra_mbox_read>
   1104c:	87aa                	mv	a5,a0
   1104e:	0ff7f793          	zext.b	a5,a5
   11052:	8bbd                	and	a5,a5,15
   11054:	0ff7f793          	zext.b	a5,a5
   11058:	853e                	mv	a0,a5
   1105a:	60a2                	ld	ra,8(sp)
   1105c:	6402                	ld	s0,0(sp)
   1105e:	0141                	add	sp,sp,16
   11060:	8082                	ret

0000000000011062 <caliptra_mbox_is_busy>:
   11062:	1141                	add	sp,sp,-16
   11064:	e406                	sd	ra,8(sp)
   11066:	e022                	sd	s0,0(sp)
   11068:	0800                	add	s0,sp,16
   1106a:	fd5ff0ef          	jal	1103e <caliptra_mbox_read_status>
   1106e:	87aa                	mv	a5,a0
   11070:	2781                	sext.w	a5,a5
   11072:	0017b793          	seqz	a5,a5
   11076:	0ff7f793          	zext.b	a5,a5
   1107a:	853e                	mv	a0,a5
   1107c:	60a2                	ld	ra,8(sp)
   1107e:	6402                	ld	s0,0(sp)
   11080:	0141                	add	sp,sp,16
   11082:	8082                	ret

0000000000011084 <caliptra_mbox_read_status_fsm>:
   11084:	1141                	add	sp,sp,-16
   11086:	e406                	sd	ra,8(sp)
   11088:	e022                	sd	s0,0(sp)
   1108a:	0800                	add	s0,sp,16
   1108c:	4571                	li	a0,28
   1108e:	ef3ff0ef          	jal	10f80 <caliptra_mbox_read>
   11092:	87aa                	mv	a5,a0
   11094:	0ff7f793          	zext.b	a5,a5
   11098:	2781                	sext.w	a5,a5
   1109a:	4067d79b          	sraw	a5,a5,0x6
   1109e:	2781                	sext.w	a5,a5
   110a0:	0ff7f793          	zext.b	a5,a5
   110a4:	8b8d                	and	a5,a5,3
   110a6:	0ff7f793          	zext.b	a5,a5
   110aa:	853e                	mv	a0,a5
   110ac:	60a2                	ld	ra,8(sp)
   110ae:	6402                	ld	s0,0(sp)
   110b0:	0141                	add	sp,sp,16
   110b2:	8082                	ret

00000000000110b4 <caliptra_mbox_read_dlen>:
   110b4:	1141                	add	sp,sp,-16
   110b6:	e406                	sd	ra,8(sp)
   110b8:	e022                	sd	s0,0(sp)
   110ba:	0800                	add	s0,sp,16
   110bc:	4531                	li	a0,12
   110be:	ec3ff0ef          	jal	10f80 <caliptra_mbox_read>
   110c2:	87aa                	mv	a5,a0
   110c4:	853e                	mv	a0,a5
   110c6:	60a2                	ld	ra,8(sp)
   110c8:	6402                	ld	s0,0(sp)
   110ca:	0141                	add	sp,sp,16
   110cc:	8082                	ret

00000000000110ce <caliptra_mbox_write_dlen>:
   110ce:	1101                	add	sp,sp,-32
   110d0:	ec06                	sd	ra,24(sp)
   110d2:	e822                	sd	s0,16(sp)
   110d4:	1000                	add	s0,sp,32
   110d6:	87aa                	mv	a5,a0
   110d8:	fef42623          	sw	a5,-20(s0)
   110dc:	fec42783          	lw	a5,-20(s0)
   110e0:	85be                	mv	a1,a5
   110e2:	4531                	li	a0,12
   110e4:	e63ff0ef          	jal	10f46 <caliptra_mbox_write>
   110e8:	0001                	nop
   110ea:	60e2                	ld	ra,24(sp)
   110ec:	6442                	ld	s0,16(sp)
   110ee:	6105                	add	sp,sp,32
   110f0:	8082                	ret

00000000000110f2 <caliptra_mailbox_write_fifo>:
   110f2:	7139                	add	sp,sp,-64
   110f4:	fc06                	sd	ra,56(sp)
   110f6:	f822                	sd	s0,48(sp)
   110f8:	0080                	add	s0,sp,64
   110fa:	fca43423          	sd	a0,-56(s0)
   110fe:	fc843783          	ld	a5,-56(s0)
   11102:	e781                	bnez	a5,1110a <caliptra_mailbox_write_fifo+0x18>
   11104:	10000793          	li	a5,256
   11108:	a079                	j	11196 <caliptra_mailbox_write_fifo+0xa4>
   1110a:	fc843783          	ld	a5,-56(s0)
   1110e:	679c                	ld	a5,8(a5)
   11110:	e399                	bnez	a5,11116 <caliptra_mailbox_write_fifo+0x24>
   11112:	4781                	li	a5,0
   11114:	a049                	j	11196 <caliptra_mailbox_write_fifo+0xa4>
   11116:	fc843783          	ld	a5,-56(s0)
   1111a:	639c                	ld	a5,0(a5)
   1111c:	e781                	bnez	a5,11124 <caliptra_mailbox_write_fifo+0x32>
   1111e:	10000793          	li	a5,256
   11122:	a895                	j	11196 <caliptra_mailbox_write_fifo+0xa4>
   11124:	fc843783          	ld	a5,-56(s0)
   11128:	679c                	ld	a5,8(a5)
   1112a:	fef42623          	sw	a5,-20(s0)
   1112e:	fc843783          	ld	a5,-56(s0)
   11132:	639c                	ld	a5,0(a5)
   11134:	fef43023          	sd	a5,-32(s0)
   11138:	a00d                	j	1115a <caliptra_mailbox_write_fifo+0x68>
   1113a:	fe043783          	ld	a5,-32(s0)
   1113e:	00478713          	add	a4,a5,4 # 30020004 <_sp+0x27fe000c>
   11142:	fee43023          	sd	a4,-32(s0)
   11146:	439c                	lw	a5,0(a5)
   11148:	85be                	mv	a1,a5
   1114a:	4541                	li	a0,16
   1114c:	dfbff0ef          	jal	10f46 <caliptra_mbox_write>
   11150:	fec42783          	lw	a5,-20(s0)
   11154:	37f1                	addw	a5,a5,-4
   11156:	fef42623          	sw	a5,-20(s0)
   1115a:	fec42783          	lw	a5,-20(s0)
   1115e:	2781                	sext.w	a5,a5
   11160:	873e                	mv	a4,a5
   11162:	4791                	li	a5,4
   11164:	fce7ebe3          	bltu	a5,a4,1113a <caliptra_mailbox_write_fifo+0x48>
   11168:	fec42783          	lw	a5,-20(s0)
   1116c:	2781                	sext.w	a5,a5
   1116e:	c39d                	beqz	a5,11194 <caliptra_mailbox_write_fifo+0xa2>
   11170:	fc042e23          	sw	zero,-36(s0)
   11174:	fec46703          	lwu	a4,-20(s0)
   11178:	fdc40793          	add	a5,s0,-36
   1117c:	863a                	mv	a2,a4
   1117e:	fe043583          	ld	a1,-32(s0)
   11182:	853e                	mv	a0,a5
   11184:	9b3ff0ef          	jal	10b36 <memcpy>
   11188:	fdc42783          	lw	a5,-36(s0)
   1118c:	85be                	mv	a1,a5
   1118e:	4541                	li	a0,16
   11190:	db7ff0ef          	jal	10f46 <caliptra_mbox_write>
   11194:	4781                	li	a5,0
   11196:	853e                	mv	a0,a5
   11198:	70e2                	ld	ra,56(sp)
   1119a:	7442                	ld	s0,48(sp)
   1119c:	6121                	add	sp,sp,64
   1119e:	8082                	ret

00000000000111a0 <caliptra_mailbox_read_fifo>:
   111a0:	715d                	add	sp,sp,-80
   111a2:	e486                	sd	ra,72(sp)
   111a4:	e0a2                	sd	s0,64(sp)
   111a6:	fc26                	sd	s1,56(sp)
   111a8:	0880                	add	s0,sp,80
   111aa:	faa43c23          	sd	a0,-72(s0)
   111ae:	fab43823          	sd	a1,-80(s0)
   111b2:	f03ff0ef          	jal	110b4 <caliptra_mbox_read_dlen>
   111b6:	87aa                	mv	a5,a0
   111b8:	fcf42e23          	sw	a5,-36(s0)
   111bc:	fb843783          	ld	a5,-72(s0)
   111c0:	e781                	bnez	a5,111c8 <caliptra_mailbox_read_fifo+0x28>
   111c2:	10000793          	li	a5,256
   111c6:	a0d1                	j	1128a <caliptra_mailbox_read_fifo+0xea>
   111c8:	fb043783          	ld	a5,-80(s0)
   111cc:	c789                	beqz	a5,111d6 <caliptra_mailbox_read_fifo+0x36>
   111ce:	fb043783          	ld	a5,-80(s0)
   111d2:	0007a023          	sw	zero,0(a5)
   111d6:	fb843783          	ld	a5,-72(s0)
   111da:	6798                	ld	a4,8(a5)
   111dc:	fdc46783          	lwu	a5,-36(s0)
   111e0:	00f76663          	bltu	a4,a5,111ec <caliptra_mailbox_read_fifo+0x4c>
   111e4:	fb843783          	ld	a5,-72(s0)
   111e8:	639c                	ld	a5,0(a5)
   111ea:	e781                	bnez	a5,111f2 <caliptra_mailbox_read_fifo+0x52>
   111ec:	10000793          	li	a5,256
   111f0:	a869                	j	1128a <caliptra_mailbox_read_fifo+0xea>
   111f2:	fb843783          	ld	a5,-72(s0)
   111f6:	639c                	ld	a5,0(a5)
   111f8:	fcf43823          	sd	a5,-48(s0)
   111fc:	a82d                	j	11236 <caliptra_mailbox_read_fifo+0x96>
   111fe:	fd043483          	ld	s1,-48(s0)
   11202:	00448793          	add	a5,s1,4
   11206:	fcf43823          	sd	a5,-48(s0)
   1120a:	4551                	li	a0,20
   1120c:	d75ff0ef          	jal	10f80 <caliptra_mbox_read>
   11210:	87aa                	mv	a5,a0
   11212:	c09c                	sw	a5,0(s1)
   11214:	fdc42783          	lw	a5,-36(s0)
   11218:	37f1                	addw	a5,a5,-4
   1121a:	fcf42e23          	sw	a5,-36(s0)
   1121e:	fb043783          	ld	a5,-80(s0)
   11222:	cb91                	beqz	a5,11236 <caliptra_mailbox_read_fifo+0x96>
   11224:	fb043783          	ld	a5,-80(s0)
   11228:	439c                	lw	a5,0(a5)
   1122a:	2791                	addw	a5,a5,4
   1122c:	0007871b          	sext.w	a4,a5
   11230:	fb043783          	ld	a5,-80(s0)
   11234:	c398                	sw	a4,0(a5)
   11236:	fdc42783          	lw	a5,-36(s0)
   1123a:	2781                	sext.w	a5,a5
   1123c:	873e                	mv	a4,a5
   1123e:	478d                	li	a5,3
   11240:	fae7efe3          	bltu	a5,a4,111fe <caliptra_mailbox_read_fifo+0x5e>
   11244:	fdc42783          	lw	a5,-36(s0)
   11248:	2781                	sext.w	a5,a5
   1124a:	cf9d                	beqz	a5,11288 <caliptra_mailbox_read_fifo+0xe8>
   1124c:	4551                	li	a0,20
   1124e:	d33ff0ef          	jal	10f80 <caliptra_mbox_read>
   11252:	87aa                	mv	a5,a0
   11254:	fcf42623          	sw	a5,-52(s0)
   11258:	fdc46703          	lwu	a4,-36(s0)
   1125c:	fcc40793          	add	a5,s0,-52
   11260:	863a                	mv	a2,a4
   11262:	85be                	mv	a1,a5
   11264:	fd043503          	ld	a0,-48(s0)
   11268:	8cfff0ef          	jal	10b36 <memcpy>
   1126c:	fb043783          	ld	a5,-80(s0)
   11270:	cf81                	beqz	a5,11288 <caliptra_mailbox_read_fifo+0xe8>
   11272:	fb043783          	ld	a5,-80(s0)
   11276:	439c                	lw	a5,0(a5)
   11278:	fdc42703          	lw	a4,-36(s0)
   1127c:	9fb9                	addw	a5,a5,a4
   1127e:	0007871b          	sext.w	a4,a5
   11282:	fb043783          	ld	a5,-80(s0)
   11286:	c398                	sw	a4,0(a5)
   11288:	4781                	li	a5,0
   1128a:	853e                	mv	a0,a5
   1128c:	60a6                	ld	ra,72(sp)
   1128e:	6406                	ld	s0,64(sp)
   11290:	74e2                	ld	s1,56(sp)
   11292:	6161                	add	sp,sp,80
   11294:	8082                	ret

0000000000011296 <caliptra_check_status_get_response>:
   11296:	7179                	add	sp,sp,-48
   11298:	f406                	sd	ra,40(sp)
   1129a:	f022                	sd	s0,32(sp)
   1129c:	1800                	add	s0,sp,48
   1129e:	fca43c23          	sd	a0,-40(s0)
   112a2:	fcb43823          	sd	a1,-48(s0)
   112a6:	fd043783          	ld	a5,-48(s0)
   112aa:	e781                	bnez	a5,112b2 <caliptra_check_status_get_response+0x1c>
   112ac:	10100793          	li	a5,257
   112b0:	a8e5                	j	113a8 <caliptra_check_status_get_response+0x112>
   112b2:	0b100613          	li	a2,177
   112b6:	00001597          	auipc	a1,0x1
   112ba:	bea58593          	add	a1,a1,-1046 # 11ea0 <__func__.5>
   112be:	00001517          	auipc	a0,0x1
   112c2:	bca50513          	add	a0,a0,-1078 # 11e88 <default_field_entropy+0x20>
   112c6:	bd0ff0ef          	jal	10696 <kprintf>
   112ca:	d75ff0ef          	jal	1103e <caliptra_mbox_read_status>
   112ce:	87aa                	mv	a5,a0
   112d0:	fef407a3          	sb	a5,-17(s0)
   112d4:	0b400613          	li	a2,180
   112d8:	00001597          	auipc	a1,0x1
   112dc:	bc858593          	add	a1,a1,-1080 # 11ea0 <__func__.5>
   112e0:	00001517          	auipc	a0,0x1
   112e4:	ba850513          	add	a0,a0,-1112 # 11e88 <default_field_entropy+0x20>
   112e8:	baeff0ef          	jal	10696 <kprintf>
   112ec:	fef44783          	lbu	a5,-17(s0)
   112f0:	0ff7f713          	zext.b	a4,a5
   112f4:	478d                	li	a5,3
   112f6:	00f71863          	bne	a4,a5,11306 <caliptra_check_status_get_response+0x70>
   112fa:	4501                	li	a0,0
   112fc:	d1dff0ef          	jal	11018 <caliptra_mbox_write_execute>
   11300:	30300793          	li	a5,771
   11304:	a055                	j	113a8 <caliptra_check_status_get_response+0x112>
   11306:	fef44783          	lbu	a5,-17(s0)
   1130a:	0ff7f713          	zext.b	a4,a5
   1130e:	4789                	li	a5,2
   11310:	00f71763          	bne	a4,a5,1131e <caliptra_check_status_get_response+0x88>
   11314:	4501                	li	a0,0
   11316:	d03ff0ef          	jal	11018 <caliptra_mbox_write_execute>
   1131a:	4781                	li	a5,0
   1131c:	a071                	j	113a8 <caliptra_check_status_get_response+0x112>
   1131e:	fef44783          	lbu	a5,-17(s0)
   11322:	0ff7f793          	zext.b	a5,a5
   11326:	e781                	bnez	a5,1132e <caliptra_check_status_get_response+0x98>
   11328:	30400793          	li	a5,772
   1132c:	a8b5                	j	113a8 <caliptra_check_status_get_response+0x112>
   1132e:	0c300613          	li	a2,195
   11332:	00001597          	auipc	a1,0x1
   11336:	b6e58593          	add	a1,a1,-1170 # 11ea0 <__func__.5>
   1133a:	00001517          	auipc	a0,0x1
   1133e:	b4e50513          	add	a0,a0,-1202 # 11e88 <default_field_entropy+0x20>
   11342:	b54ff0ef          	jal	10696 <kprintf>
   11346:	fd043583          	ld	a1,-48(s0)
   1134a:	fd843503          	ld	a0,-40(s0)
   1134e:	e53ff0ef          	jal	111a0 <caliptra_mailbox_read_fifo>
   11352:	87aa                	mv	a5,a0
   11354:	fef42423          	sw	a5,-24(s0)
   11358:	0c600613          	li	a2,198
   1135c:	00001597          	auipc	a1,0x1
   11360:	b4458593          	add	a1,a1,-1212 # 11ea0 <__func__.5>
   11364:	00001517          	auipc	a0,0x1
   11368:	b2450513          	add	a0,a0,-1244 # 11e88 <default_field_entropy+0x20>
   1136c:	b2aff0ef          	jal	10696 <kprintf>
   11370:	4501                	li	a0,0
   11372:	ca7ff0ef          	jal	11018 <caliptra_mbox_write_execute>
   11376:	0c900613          	li	a2,201
   1137a:	00001597          	auipc	a1,0x1
   1137e:	b2658593          	add	a1,a1,-1242 # 11ea0 <__func__.5>
   11382:	00001517          	auipc	a0,0x1
   11386:	b0650513          	add	a0,a0,-1274 # 11e88 <default_field_entropy+0x20>
   1138a:	b0cff0ef          	jal	10696 <kprintf>
   1138e:	3e800513          	li	a0,1000
   11392:	b87ff0ef          	jal	10f18 <delay_ms>
   11396:	cefff0ef          	jal	11084 <caliptra_mbox_read_status_fsm>
   1139a:	87aa                	mv	a5,a0
   1139c:	c781                	beqz	a5,113a4 <caliptra_check_status_get_response+0x10e>
   1139e:	30500793          	li	a5,773
   113a2:	a019                	j	113a8 <caliptra_check_status_get_response+0x112>
   113a4:	fe842783          	lw	a5,-24(s0)
   113a8:	853e                	mv	a0,a5
   113aa:	70a2                	ld	ra,40(sp)
   113ac:	7402                	ld	s0,32(sp)
   113ae:	6145                	add	sp,sp,48
   113b0:	8082                	ret

00000000000113b2 <calculate_caliptra_checksum>:
   113b2:	7179                	add	sp,sp,-48
   113b4:	f406                	sd	ra,40(sp)
   113b6:	f022                	sd	s0,32(sp)
   113b8:	1800                	add	s0,sp,48
   113ba:	87aa                	mv	a5,a0
   113bc:	fcb43823          	sd	a1,-48(s0)
   113c0:	8732                	mv	a4,a2
   113c2:	fcf42e23          	sw	a5,-36(s0)
   113c6:	87ba                	mv	a5,a4
   113c8:	fcf42c23          	sw	a5,-40(s0)
   113cc:	fe042423          	sw	zero,-24(s0)
   113d0:	fd043783          	ld	a5,-48(s0)
   113d4:	e799                	bnez	a5,113e2 <calculate_caliptra_checksum+0x30>
   113d6:	fd842783          	lw	a5,-40(s0)
   113da:	2781                	sext.w	a5,a5
   113dc:	c399                	beqz	a5,113e2 <calculate_caliptra_checksum+0x30>
   113de:	4781                	li	a5,0
   113e0:	a061                	j	11468 <calculate_caliptra_checksum+0xb6>
   113e2:	fe042623          	sw	zero,-20(s0)
   113e6:	a01d                	j	1140c <calculate_caliptra_checksum+0x5a>
   113e8:	fec46783          	lwu	a5,-20(s0)
   113ec:	fdc40713          	add	a4,s0,-36
   113f0:	97ba                	add	a5,a5,a4
   113f2:	0007c783          	lbu	a5,0(a5)
   113f6:	2781                	sext.w	a5,a5
   113f8:	fe842703          	lw	a4,-24(s0)
   113fc:	9fb9                	addw	a5,a5,a4
   113fe:	fef42423          	sw	a5,-24(s0)
   11402:	fec42783          	lw	a5,-20(s0)
   11406:	2785                	addw	a5,a5,1
   11408:	fef42623          	sw	a5,-20(s0)
   1140c:	fec42783          	lw	a5,-20(s0)
   11410:	2781                	sext.w	a5,a5
   11412:	873e                	mv	a4,a5
   11414:	478d                	li	a5,3
   11416:	fce7f9e3          	bgeu	a5,a4,113e8 <calculate_caliptra_checksum+0x36>
   1141a:	fe042623          	sw	zero,-20(s0)
   1141e:	a01d                	j	11444 <calculate_caliptra_checksum+0x92>
   11420:	fec46783          	lwu	a5,-20(s0)
   11424:	fd043703          	ld	a4,-48(s0)
   11428:	97ba                	add	a5,a5,a4
   1142a:	0007c783          	lbu	a5,0(a5)
   1142e:	2781                	sext.w	a5,a5
   11430:	fe842703          	lw	a4,-24(s0)
   11434:	9fb9                	addw	a5,a5,a4
   11436:	fef42423          	sw	a5,-24(s0)
   1143a:	fec42783          	lw	a5,-20(s0)
   1143e:	2785                	addw	a5,a5,1
   11440:	fef42623          	sw	a5,-20(s0)
   11444:	fec42783          	lw	a5,-20(s0)
   11448:	873e                	mv	a4,a5
   1144a:	fd842783          	lw	a5,-40(s0)
   1144e:	86be                	mv	a3,a5
   11450:	0007079b          	sext.w	a5,a4
   11454:	873e                	mv	a4,a5
   11456:	0006879b          	sext.w	a5,a3
   1145a:	fcf763e3          	bltu	a4,a5,11420 <calculate_caliptra_checksum+0x6e>
   1145e:	fe842783          	lw	a5,-24(s0)
   11462:	40f007bb          	negw	a5,a5
   11466:	2781                	sext.w	a5,a5
   11468:	853e                	mv	a0,a5
   1146a:	70a2                	ld	ra,40(sp)
   1146c:	7402                	ld	s0,32(sp)
   1146e:	6145                	add	sp,sp,48
   11470:	8082                	ret

0000000000011472 <caliptra_mailbox_send_start>:
   11472:	1101                	add	sp,sp,-32
   11474:	ec06                	sd	ra,24(sp)
   11476:	e822                	sd	s0,16(sp)
   11478:	1000                	add	s0,sp,32
   1147a:	87aa                	mv	a5,a0
   1147c:	872e                	mv	a4,a1
   1147e:	fef42623          	sw	a5,-20(s0)
   11482:	87ba                	mv	a5,a4
   11484:	fef42423          	sw	a5,-24(s0)
   11488:	fe842783          	lw	a5,-24(s0)
   1148c:	2781                	sext.w	a5,a5
   1148e:	873e                	mv	a4,a5
   11490:	000207b7          	lui	a5,0x20
   11494:	00e7f563          	bgeu	a5,a4,1149e <caliptra_mailbox_send_start+0x2c>
   11498:	10000793          	li	a5,256
   1149c:	a059                	j	11522 <caliptra_mailbox_send_start+0xb0>
   1149e:	12400613          	li	a2,292
   114a2:	00001597          	auipc	a1,0x1
   114a6:	a2658593          	add	a1,a1,-1498 # 11ec8 <__func__.4>
   114aa:	00001517          	auipc	a0,0x1
   114ae:	9de50513          	add	a0,a0,-1570 # 11e88 <default_field_entropy+0x20>
   114b2:	9e4ff0ef          	jal	10696 <kprintf>
   114b6:	affff0ef          	jal	10fb4 <caliptra_mbox_is_lock>
   114ba:	87aa                	mv	a5,a0
   114bc:	c781                	beqz	a5,114c4 <caliptra_mailbox_send_start+0x52>
   114be:	30000793          	li	a5,768
   114c2:	a085                	j	11522 <caliptra_mailbox_send_start+0xb0>
   114c4:	12a00613          	li	a2,298
   114c8:	00001597          	auipc	a1,0x1
   114cc:	a0058593          	add	a1,a1,-1536 # 11ec8 <__func__.4>
   114d0:	00001517          	auipc	a0,0x1
   114d4:	9b850513          	add	a0,a0,-1608 # 11e88 <default_field_entropy+0x20>
   114d8:	9beff0ef          	jal	10696 <kprintf>
   114dc:	fec42783          	lw	a5,-20(s0)
   114e0:	853e                	mv	a0,a5
   114e2:	af9ff0ef          	jal	10fda <caliptra_mbox_write_cmd>
   114e6:	12d00613          	li	a2,301
   114ea:	00001597          	auipc	a1,0x1
   114ee:	9de58593          	add	a1,a1,-1570 # 11ec8 <__func__.4>
   114f2:	00001517          	auipc	a0,0x1
   114f6:	99650513          	add	a0,a0,-1642 # 11e88 <default_field_entropy+0x20>
   114fa:	99cff0ef          	jal	10696 <kprintf>
   114fe:	fe842783          	lw	a5,-24(s0)
   11502:	853e                	mv	a0,a5
   11504:	bcbff0ef          	jal	110ce <caliptra_mbox_write_dlen>
   11508:	13000613          	li	a2,304
   1150c:	00001597          	auipc	a1,0x1
   11510:	9bc58593          	add	a1,a1,-1604 # 11ec8 <__func__.4>
   11514:	00001517          	auipc	a0,0x1
   11518:	97450513          	add	a0,a0,-1676 # 11e88 <default_field_entropy+0x20>
   1151c:	97aff0ef          	jal	10696 <kprintf>
   11520:	4781                	li	a5,0
   11522:	853e                	mv	a0,a5
   11524:	60e2                	ld	ra,24(sp)
   11526:	6442                	ld	s0,16(sp)
   11528:	6105                	add	sp,sp,32
   1152a:	8082                	ret

000000000001152c <caliptra_mailbox_send_data>:
   1152c:	1101                	add	sp,sp,-32
   1152e:	ec06                	sd	ra,24(sp)
   11530:	e822                	sd	s0,16(sp)
   11532:	1000                	add	s0,sp,32
   11534:	fea43423          	sd	a0,-24(s0)
   11538:	fe843503          	ld	a0,-24(s0)
   1153c:	bb7ff0ef          	jal	110f2 <caliptra_mailbox_write_fifo>
   11540:	87aa                	mv	a5,a0
   11542:	853e                	mv	a0,a5
   11544:	60e2                	ld	ra,24(sp)
   11546:	6442                	ld	s0,16(sp)
   11548:	6105                	add	sp,sp,32
   1154a:	8082                	ret

000000000001154c <caliptra_mailbox_send_complete>:
   1154c:	7179                	add	sp,sp,-48
   1154e:	f406                	sd	ra,40(sp)
   11550:	f022                	sd	s0,32(sp)
   11552:	1800                	add	s0,sp,48
   11554:	fca43c23          	sd	a0,-40(s0)
   11558:	87ae                	mv	a5,a1
   1155a:	fcf40ba3          	sb	a5,-41(s0)
   1155e:	15200613          	li	a2,338
   11562:	00001597          	auipc	a1,0x1
   11566:	98658593          	add	a1,a1,-1658 # 11ee8 <__func__.3>
   1156a:	00001517          	auipc	a0,0x1
   1156e:	91e50513          	add	a0,a0,-1762 # 11e88 <default_field_entropy+0x20>
   11572:	924ff0ef          	jal	10696 <kprintf>
   11576:	fd843783          	ld	a5,-40(s0)
   1157a:	cb85                	beqz	a5,115aa <caliptra_mailbox_send_complete+0x5e>
   1157c:	0800f797          	auipc	a5,0x800f
   11580:	a8478793          	add	a5,a5,-1404 # 8020000 <g_caliptra_mbox_pending_rx_buffer>
   11584:	fd843703          	ld	a4,-40(s0)
   11588:	6314                	ld	a3,0(a4)
   1158a:	e394                	sd	a3,0(a5)
   1158c:	6718                	ld	a4,8(a4)
   1158e:	e798                	sd	a4,8(a5)
   11590:	15600613          	li	a2,342
   11594:	00001597          	auipc	a1,0x1
   11598:	95458593          	add	a1,a1,-1708 # 11ee8 <__func__.3>
   1159c:	00001517          	auipc	a0,0x1
   115a0:	8ec50513          	add	a0,a0,-1812 # 11e88 <default_field_entropy+0x20>
   115a4:	8f2ff0ef          	jal	10696 <kprintf>
   115a8:	a80d                	j	115da <caliptra_mailbox_send_complete+0x8e>
   115aa:	0800f797          	auipc	a5,0x800f
   115ae:	a5678793          	add	a5,a5,-1450 # 8020000 <g_caliptra_mbox_pending_rx_buffer>
   115b2:	0007b023          	sd	zero,0(a5)
   115b6:	0800f797          	auipc	a5,0x800f
   115ba:	a4a78793          	add	a5,a5,-1462 # 8020000 <g_caliptra_mbox_pending_rx_buffer>
   115be:	0007b423          	sd	zero,8(a5)
   115c2:	15900613          	li	a2,345
   115c6:	00001597          	auipc	a1,0x1
   115ca:	92258593          	add	a1,a1,-1758 # 11ee8 <__func__.3>
   115ce:	00001517          	auipc	a0,0x1
   115d2:	8ba50513          	add	a0,a0,-1862 # 11e88 <default_field_entropy+0x20>
   115d6:	8c0ff0ef          	jal	10696 <kprintf>
   115da:	15c00613          	li	a2,348
   115de:	00001597          	auipc	a1,0x1
   115e2:	90a58593          	add	a1,a1,-1782 # 11ee8 <__func__.3>
   115e6:	00001517          	auipc	a0,0x1
   115ea:	8a250513          	add	a0,a0,-1886 # 11e88 <default_field_entropy+0x20>
   115ee:	8a8ff0ef          	jal	10696 <kprintf>
   115f2:	4505                	li	a0,1
   115f4:	a25ff0ef          	jal	11018 <caliptra_mbox_write_execute>
   115f8:	fd744783          	lbu	a5,-41(s0)
   115fc:	0ff7f793          	zext.b	a5,a5
   11600:	cf99                	beqz	a5,1161e <caliptra_mailbox_send_complete+0xd2>
   11602:	16000613          	li	a2,352
   11606:	00001597          	auipc	a1,0x1
   1160a:	8e258593          	add	a1,a1,-1822 # 11ee8 <__func__.3>
   1160e:	00001517          	auipc	a0,0x1
   11612:	87a50513          	add	a0,a0,-1926 # 11e88 <default_field_entropy+0x20>
   11616:	880ff0ef          	jal	10696 <kprintf>
   1161a:	4781                	li	a5,0
   1161c:	a881                	j	1166c <caliptra_mailbox_send_complete+0x120>
   1161e:	16400613          	li	a2,356
   11622:	00001597          	auipc	a1,0x1
   11626:	8c658593          	add	a1,a1,-1850 # 11ee8 <__func__.3>
   1162a:	00001517          	auipc	a0,0x1
   1162e:	85e50513          	add	a0,a0,-1954 # 11e88 <default_field_entropy+0x20>
   11632:	864ff0ef          	jal	10696 <kprintf>
   11636:	a021                	j	1163e <caliptra_mailbox_send_complete+0xf2>
   11638:	4529                	li	a0,10
   1163a:	8dfff0ef          	jal	10f18 <delay_ms>
   1163e:	1de000ef          	jal	1181c <caliptra_test_for_completion>
   11642:	87aa                	mv	a5,a0
   11644:	0017c793          	xor	a5,a5,1
   11648:	0ff7f793          	zext.b	a5,a5
   1164c:	f7f5                	bnez	a5,11638 <caliptra_mailbox_send_complete+0xec>
   1164e:	16800613          	li	a2,360
   11652:	00001597          	auipc	a1,0x1
   11656:	89658593          	add	a1,a1,-1898 # 11ee8 <__func__.3>
   1165a:	00001517          	auipc	a0,0x1
   1165e:	82e50513          	add	a0,a0,-2002 # 11e88 <default_field_entropy+0x20>
   11662:	834ff0ef          	jal	10696 <kprintf>
   11666:	1e8000ef          	jal	1184e <caliptra_complete>
   1166a:	87aa                	mv	a5,a0
   1166c:	853e                	mv	a0,a5
   1166e:	70a2                	ld	ra,40(sp)
   11670:	7402                	ld	s0,32(sp)
   11672:	6145                	add	sp,sp,48
   11674:	8082                	ret

0000000000011676 <caliptra_mailbox_execute>:
   11676:	7139                	add	sp,sp,-64
   11678:	fc06                	sd	ra,56(sp)
   1167a:	f822                	sd	s0,48(sp)
   1167c:	0080                	add	s0,sp,64
   1167e:	87aa                	mv	a5,a0
   11680:	fcb43823          	sd	a1,-48(s0)
   11684:	fcc43423          	sd	a2,-56(s0)
   11688:	8736                	mv	a4,a3
   1168a:	fcf42e23          	sw	a5,-36(s0)
   1168e:	87ba                	mv	a5,a4
   11690:	fcf40da3          	sb	a5,-37(s0)
   11694:	fd043783          	ld	a5,-48(s0)
   11698:	679c                	ld	a5,8(a5)
   1169a:	0007871b          	sext.w	a4,a5
   1169e:	fdc42783          	lw	a5,-36(s0)
   116a2:	85ba                	mv	a1,a4
   116a4:	853e                	mv	a0,a5
   116a6:	dcdff0ef          	jal	11472 <caliptra_mailbox_send_start>
   116aa:	87aa                	mv	a5,a0
   116ac:	fef42623          	sw	a5,-20(s0)
   116b0:	fec42783          	lw	a5,-20(s0)
   116b4:	2781                	sext.w	a5,a5
   116b6:	c781                	beqz	a5,116be <caliptra_mailbox_execute+0x48>
   116b8:	fec42783          	lw	a5,-20(s0)
   116bc:	a8b9                	j	1171a <caliptra_mailbox_execute+0xa4>
   116be:	17e00613          	li	a2,382
   116c2:	00001597          	auipc	a1,0x1
   116c6:	84658593          	add	a1,a1,-1978 # 11f08 <__func__.2>
   116ca:	00000517          	auipc	a0,0x0
   116ce:	7be50513          	add	a0,a0,1982 # 11e88 <default_field_entropy+0x20>
   116d2:	fc5fe0ef          	jal	10696 <kprintf>
   116d6:	fd043503          	ld	a0,-48(s0)
   116da:	e53ff0ef          	jal	1152c <caliptra_mailbox_send_data>
   116de:	87aa                	mv	a5,a0
   116e0:	fef42623          	sw	a5,-20(s0)
   116e4:	fec42783          	lw	a5,-20(s0)
   116e8:	2781                	sext.w	a5,a5
   116ea:	c781                	beqz	a5,116f2 <caliptra_mailbox_execute+0x7c>
   116ec:	fec42783          	lw	a5,-20(s0)
   116f0:	a02d                	j	1171a <caliptra_mailbox_execute+0xa4>
   116f2:	18400613          	li	a2,388
   116f6:	00001597          	auipc	a1,0x1
   116fa:	81258593          	add	a1,a1,-2030 # 11f08 <__func__.2>
   116fe:	00000517          	auipc	a0,0x0
   11702:	78a50513          	add	a0,a0,1930 # 11e88 <default_field_entropy+0x20>
   11706:	f91fe0ef          	jal	10696 <kprintf>
   1170a:	fdb44783          	lbu	a5,-37(s0)
   1170e:	85be                	mv	a1,a5
   11710:	fc843503          	ld	a0,-56(s0)
   11714:	e39ff0ef          	jal	1154c <caliptra_mailbox_send_complete>
   11718:	87aa                	mv	a5,a0
   1171a:	853e                	mv	a0,a5
   1171c:	70e2                	ld	ra,56(sp)
   1171e:	7442                	ld	s0,48(sp)
   11720:	6121                	add	sp,sp,64
   11722:	8082                	ret

0000000000011724 <pack_and_execute_command>:
   11724:	715d                	add	sp,sp,-80
   11726:	e486                	sd	ra,72(sp)
   11728:	e0a2                	sd	s0,64(sp)
   1172a:	fc26                	sd	s1,56(sp)
   1172c:	0880                	add	s0,sp,80
   1172e:	faa43c23          	sd	a0,-72(s0)
   11732:	87ae                	mv	a5,a1
   11734:	faf40ba3          	sb	a5,-73(s0)
   11738:	fb843783          	ld	a5,-72(s0)
   1173c:	e781                	bnez	a5,11744 <pack_and_execute_command+0x20>
   1173e:	10000793          	li	a5,256
   11742:	a0f9                	j	11810 <pack_and_execute_command+0xec>
   11744:	19900613          	li	a2,409
   11748:	00000597          	auipc	a1,0x0
   1174c:	7e058593          	add	a1,a1,2016 # 11f28 <__func__.1>
   11750:	00000517          	auipc	a0,0x0
   11754:	73850513          	add	a0,a0,1848 # 11e88 <default_field_entropy+0x20>
   11758:	f3ffe0ef          	jal	10696 <kprintf>
   1175c:	fb843783          	ld	a5,-72(s0)
   11760:	679c                	ld	a5,8(a5)
   11762:	c789                	beqz	a5,1176c <pack_and_execute_command+0x48>
   11764:	fb843783          	ld	a5,-72(s0)
   11768:	6f9c                	ld	a5,24(a5)
   1176a:	e781                	bnez	a5,11772 <pack_and_execute_command+0x4e>
   1176c:	10000793          	li	a5,256
   11770:	a045                	j	11810 <pack_and_execute_command+0xec>
   11772:	1a100613          	li	a2,417
   11776:	00000597          	auipc	a1,0x0
   1177a:	7b258593          	add	a1,a1,1970 # 11f28 <__func__.1>
   1177e:	00000517          	auipc	a0,0x0
   11782:	70a50513          	add	a0,a0,1802 # 11e88 <default_field_entropy+0x20>
   11786:	f11fe0ef          	jal	10696 <kprintf>
   1178a:	fb843783          	ld	a5,-72(s0)
   1178e:	679c                	ld	a5,8(a5)
   11790:	fcf43823          	sd	a5,-48(s0)
   11794:	fb843783          	ld	a5,-72(s0)
   11798:	6b9c                	ld	a5,16(a5)
   1179a:	fcf43c23          	sd	a5,-40(s0)
   1179e:	fb843783          	ld	a5,-72(s0)
   117a2:	6f9c                	ld	a5,24(a5)
   117a4:	fcf43023          	sd	a5,-64(s0)
   117a8:	fb843783          	ld	a5,-72(s0)
   117ac:	739c                	ld	a5,32(a5)
   117ae:	fcf43423          	sd	a5,-56(s0)
   117b2:	1ab00613          	li	a2,427
   117b6:	00000597          	auipc	a1,0x0
   117ba:	77258593          	add	a1,a1,1906 # 11f28 <__func__.1>
   117be:	00000517          	auipc	a0,0x0
   117c2:	6ca50513          	add	a0,a0,1738 # 11e88 <default_field_entropy+0x20>
   117c6:	ed1fe0ef          	jal	10696 <kprintf>
   117ca:	fd043783          	ld	a5,-48(s0)
   117ce:	0007a023          	sw	zero,0(a5)
   117d2:	fb843783          	ld	a5,-72(s0)
   117d6:	439c                	lw	a5,0(a5)
   117d8:	fd043703          	ld	a4,-48(s0)
   117dc:	fd843683          	ld	a3,-40(s0)
   117e0:	2681                	sext.w	a3,a3
   117e2:	fd043483          	ld	s1,-48(s0)
   117e6:	8636                	mv	a2,a3
   117e8:	85ba                	mv	a1,a4
   117ea:	853e                	mv	a0,a5
   117ec:	bc7ff0ef          	jal	113b2 <calculate_caliptra_checksum>
   117f0:	87aa                	mv	a5,a0
   117f2:	c09c                	sw	a5,0(s1)
   117f4:	fb843783          	ld	a5,-72(s0)
   117f8:	439c                	lw	a5,0(a5)
   117fa:	fb744683          	lbu	a3,-73(s0)
   117fe:	fc040613          	add	a2,s0,-64
   11802:	fd040713          	add	a4,s0,-48
   11806:	85ba                	mv	a1,a4
   11808:	853e                	mv	a0,a5
   1180a:	e6dff0ef          	jal	11676 <caliptra_mailbox_execute>
   1180e:	87aa                	mv	a5,a0
   11810:	853e                	mv	a0,a5
   11812:	60a6                	ld	ra,72(sp)
   11814:	6406                	ld	s0,64(sp)
   11816:	74e2                	ld	s1,56(sp)
   11818:	6161                	add	sp,sp,80
   1181a:	8082                	ret

000000000001181c <caliptra_test_for_completion>:
   1181c:	1141                	add	sp,sp,-16
   1181e:	e406                	sd	ra,8(sp)
   11820:	e022                	sd	s0,0(sp)
   11822:	0800                	add	s0,sp,16
   11824:	83fff0ef          	jal	11062 <caliptra_mbox_is_busy>
   11828:	87aa                	mv	a5,a0
   1182a:	2781                	sext.w	a5,a5
   1182c:	00f037b3          	snez	a5,a5
   11830:	0ff7f793          	zext.b	a5,a5
   11834:	0017c793          	xor	a5,a5,1
   11838:	0ff7f793          	zext.b	a5,a5
   1183c:	2781                	sext.w	a5,a5
   1183e:	8b85                	and	a5,a5,1
   11840:	0ff7f793          	zext.b	a5,a5
   11844:	853e                	mv	a0,a5
   11846:	60a2                	ld	ra,8(sp)
   11848:	6402                	ld	s0,0(sp)
   1184a:	0141                	add	sp,sp,16
   1184c:	8082                	ret

000000000001184e <caliptra_complete>:
   1184e:	7139                	add	sp,sp,-64
   11850:	fc06                	sd	ra,56(sp)
   11852:	f822                	sd	s0,48(sp)
   11854:	0080                	add	s0,sp,64
   11856:	1c900613          	li	a2,457
   1185a:	00000597          	auipc	a1,0x0
   1185e:	6ee58593          	add	a1,a1,1774 # 11f48 <__func__.0>
   11862:	00000517          	auipc	a0,0x0
   11866:	62650513          	add	a0,a0,1574 # 11e88 <default_field_entropy+0x20>
   1186a:	e2dfe0ef          	jal	10696 <kprintf>
   1186e:	f90ff0ef          	jal	10ffe <caliptra_mbox_read_execute>
   11872:	87aa                	mv	a5,a0
   11874:	e781                	bnez	a5,1187c <caliptra_complete+0x2e>
   11876:	30100793          	li	a5,769
   1187a:	a8fd                	j	11978 <caliptra_complete+0x12a>
   1187c:	1ce00613          	li	a2,462
   11880:	00000597          	auipc	a1,0x0
   11884:	6c858593          	add	a1,a1,1736 # 11f48 <__func__.0>
   11888:	00000517          	auipc	a0,0x0
   1188c:	60050513          	add	a0,a0,1536 # 11e88 <default_field_entropy+0x20>
   11890:	e07fe0ef          	jal	10696 <kprintf>
   11894:	f89ff0ef          	jal	1181c <caliptra_test_for_completion>
   11898:	87aa                	mv	a5,a0
   1189a:	0017c793          	xor	a5,a5,1
   1189e:	0ff7f793          	zext.b	a5,a5
   118a2:	c781                	beqz	a5,118aa <caliptra_complete+0x5c>
   118a4:	30000793          	li	a5,768
   118a8:	a8c1                	j	11978 <caliptra_complete+0x12a>
   118aa:	1d300613          	li	a2,467
   118ae:	00000597          	auipc	a1,0x0
   118b2:	69a58593          	add	a1,a1,1690 # 11f48 <__func__.0>
   118b6:	00000517          	auipc	a0,0x0
   118ba:	5d250513          	add	a0,a0,1490 # 11e88 <default_field_entropy+0x20>
   118be:	dd9fe0ef          	jal	10696 <kprintf>
   118c2:	0800e797          	auipc	a5,0x800e
   118c6:	73e78793          	add	a5,a5,1854 # 8020000 <g_caliptra_mbox_pending_rx_buffer>
   118ca:	6398                	ld	a4,0(a5)
   118cc:	fce43c23          	sd	a4,-40(s0)
   118d0:	679c                	ld	a5,8(a5)
   118d2:	fef43023          	sd	a5,-32(s0)
   118d6:	0800e797          	auipc	a5,0x800e
   118da:	72a78793          	add	a5,a5,1834 # 8020000 <g_caliptra_mbox_pending_rx_buffer>
   118de:	0007b023          	sd	zero,0(a5)
   118e2:	0800e797          	auipc	a5,0x800e
   118e6:	71e78793          	add	a5,a5,1822 # 8020000 <g_caliptra_mbox_pending_rx_buffer>
   118ea:	0007b423          	sd	zero,8(a5)
   118ee:	1d900613          	li	a2,473
   118f2:	00000597          	auipc	a1,0x0
   118f6:	65658593          	add	a1,a1,1622 # 11f48 <__func__.0>
   118fa:	00000517          	auipc	a0,0x0
   118fe:	58e50513          	add	a0,a0,1422 # 11e88 <default_field_entropy+0x20>
   11902:	d95fe0ef          	jal	10696 <kprintf>
   11906:	fc042223          	sw	zero,-60(s0)
   1190a:	fc440713          	add	a4,s0,-60
   1190e:	fd840793          	add	a5,s0,-40
   11912:	85ba                	mv	a1,a4
   11914:	853e                	mv	a0,a5
   11916:	981ff0ef          	jal	11296 <caliptra_check_status_get_response>
   1191a:	87aa                	mv	a5,a0
   1191c:	fef42623          	sw	a5,-20(s0)
   11920:	1dd00613          	li	a2,477
   11924:	00000597          	auipc	a1,0x0
   11928:	62458593          	add	a1,a1,1572 # 11f48 <__func__.0>
   1192c:	00000517          	auipc	a0,0x0
   11930:	55c50513          	add	a0,a0,1372 # 11e88 <default_field_entropy+0x20>
   11934:	d63fe0ef          	jal	10696 <kprintf>
   11938:	fec42783          	lw	a5,-20(s0)
   1193c:	2781                	sext.w	a5,a5
   1193e:	c781                	beqz	a5,11946 <caliptra_complete+0xf8>
   11940:	fec42783          	lw	a5,-20(s0)
   11944:	a815                	j	11978 <caliptra_complete+0x12a>
   11946:	1e200613          	li	a2,482
   1194a:	00000597          	auipc	a1,0x0
   1194e:	5fe58593          	add	a1,a1,1534 # 11f48 <__func__.0>
   11952:	00000517          	auipc	a0,0x0
   11956:	53650513          	add	a0,a0,1334 # 11e88 <default_field_entropy+0x20>
   1195a:	d3dfe0ef          	jal	10696 <kprintf>
   1195e:	1e700613          	li	a2,487
   11962:	00000597          	auipc	a1,0x0
   11966:	5e658593          	add	a1,a1,1510 # 11f48 <__func__.0>
   1196a:	00000517          	auipc	a0,0x0
   1196e:	51e50513          	add	a0,a0,1310 # 11e88 <default_field_entropy+0x20>
   11972:	d25fe0ef          	jal	10696 <kprintf>
   11976:	4781                	li	a5,0
   11978:	853e                	mv	a0,a5
   1197a:	70e2                	ld	ra,56(sp)
   1197c:	7442                	ld	s0,48(sp)
   1197e:	6121                	add	sp,sp,64
   11980:	8082                	ret

0000000000011982 <caliptra_upload_fw>:
   11982:	1101                	add	sp,sp,-32
   11984:	ec06                	sd	ra,24(sp)
   11986:	e822                	sd	s0,16(sp)
   11988:	1000                	add	s0,sp,32
   1198a:	fea43423          	sd	a0,-24(s0)
   1198e:	87ae                	mv	a5,a1
   11990:	fef403a3          	sb	a5,-25(s0)
   11994:	fe843783          	ld	a5,-24(s0)
   11998:	e781                	bnez	a5,119a0 <caliptra_upload_fw+0x1e>
   1199a:	10000793          	li	a5,256
   1199e:	a831                	j	119ba <caliptra_upload_fw+0x38>
   119a0:	fe744783          	lbu	a5,-25(s0)
   119a4:	86be                	mv	a3,a5
   119a6:	4601                	li	a2,0
   119a8:	fe843583          	ld	a1,-24(s0)
   119ac:	465757b7          	lui	a5,0x46575
   119b0:	c4478513          	add	a0,a5,-956 # 46574c44 <_sp+0x3e534c4c>
   119b4:	cc3ff0ef          	jal	11676 <caliptra_mailbox_execute>
   119b8:	87aa                	mv	a5,a0
   119ba:	853e                	mv	a0,a5
   119bc:	60e2                	ld	ra,24(sp)
   119be:	6442                	ld	s0,16(sp)
   119c0:	6105                	add	sp,sp,32
   119c2:	8082                	ret
	...

Disassembly of section .srodata:

0000000000011a08 <uart>:
   11a08:	0000                	unimp
   11a0a:	6400                	ld	s0,8(s0)
   11a0c:	0000                	unimp
	...

0000000000011a10 <wdt_timeout>:
   11a10:	0000                	unimp
   11a12:	a000                	.insn	2, 0xa000
   11a14:	0000                	unimp
	...

0000000000011a18 <itrng_entropy_low_threshold>:
   11a18:	0001                	nop

0000000000011a1a <itrng_entropy_high_threshold>:
   11a1a:	          	.insn	4, 0xffffffff

0000000000011a1c <itrng_entropy_repetition_count>:
   11a1c:	0000ffff          	.insn	4, 0xffff

0000000000011a20 <__func__.0>:
   11a20:	616d                	add	sp,sp,240
   11a22:	6e69                	lui	t3,0x1a
   11a24:	0000                	unimp
	...

0000000000011a28 <uart>:
   11a28:	0000                	unimp
   11a2a:	6400                	ld	s0,8(s0)
   11a2c:	0000                	unimp
	...

0000000000011a30 <uart>:
   11a30:	0000                	unimp
   11a32:	6400                	ld	s0,8(s0)
   11a34:	0000                	unimp
	...

0000000000011a38 <wdt_timeout>:
   11a38:	0000                	unimp
   11a3a:	a000                	.insn	2, 0xa000
   11a3c:	0000                	unimp
	...

0000000000011a40 <itrng_entropy_low_threshold>:
   11a40:	0001                	nop

0000000000011a42 <itrng_entropy_high_threshold>:
   11a42:	          	.insn	4, 0xffffffff

0000000000011a44 <itrng_entropy_repetition_count>:
   11a44:	0000ffff          	.insn	4, 0xffff

0000000000011a48 <uart>:
   11a48:	0000                	unimp
   11a4a:	6400                	ld	s0,8(s0)
   11a4c:	0000                	unimp
	...

0000000000011a50 <wdt_timeout>:
   11a50:	0000                	unimp
   11a52:	a000                	.insn	2, 0xa000
   11a54:	0000                	unimp
	...

0000000000011a58 <itrng_entropy_low_threshold>:
   11a58:	0001                	nop

0000000000011a5a <itrng_entropy_high_threshold>:
   11a5a:	          	.insn	4, 0xffffffff

0000000000011a5c <itrng_entropy_repetition_count>:
   11a5c:	ff ff   	Address 0x11a5c is out of bounds.

   11a60:	 

Disassembly of section .hash:

0000000000011a60 <opk_hash>:
	...

0000000000011a90 <vpk_hash>:
	...

Disassembly of section .rodata:

0000000000011bc0 <default_uds_seed>:
   11bc0:	00010203          	lb	tp,0(sp)
   11bc4:	04050607          	.insn	4, 0x04050607
   11bc8:	08090a0b          	.insn	4, 0x08090a0b
   11bcc:	0c0d0e0f          	.insn	4, 0x0c0d0e0f
   11bd0:	10111213          	.insn	4, 0x10111213
   11bd4:	14151617          	auipc	a2,0x14151
   11bd8:	18191a1b          	.insn	4, 0x18191a1b
   11bdc:	1e1f 1c1d 2223      	.insn	6, 0x22231c1d1e1f
   11be2:	2021                	.insn	2, 0x2021
   11be4:	24252627          	.insn	4, 0x24252627
   11be8:	28292a2b          	.insn	4, 0x28292a2b
   11bec:	2c2d2e2f          	.insn	4, 0x2c2d2e2f

0000000000011bf0 <default_field_entropy>:
   11bf0:	80818283          	lb	t0,-2040(gp)
   11bf4:	84858687          	.insn	4, 0x84858687
   11bf8:	88898a8b          	.insn	4, 0x88898a8b
   11bfc:	8c8d8e8f          	.insn	4, 0x8c8d8e8f
   11c00:	90919293          	.insn	4, 0x90919293
   11c04:	94959697          	auipc	a3,0x94959
   11c08:	98999a9b          	.insn	4, 0x98999a9b
   11c0c:	9e9f 9c9d 6e49      	.insn	6, 0x6e499c9d9e9f
   11c12:	6176                	ld	sp,344(sp)
   11c14:	696c                	ld	a1,208(a0)
   11c16:	2064                	.insn	2, 0x2064
   11c18:	6572                	ld	a0,280(sp)
   11c1a:	20746573          	csrrs	a0,0x207,8
   11c1e:	6576                	ld	a0,344(sp)
   11c20:	726f7463          	bgeu	t5,t1,12348 <dtb+0x3e8>
   11c24:	203a                	.insn	2, 0x203a
   11c26:	7830                	ld	a2,112(s0)
   11c28:	3025                	.insn	2, 0x3025
   11c2a:	7838                	ld	a4,112(s0)
   11c2c:	2820                	.insn	2, 0x2820
   11c2e:	7865                	lui	a6,0xffff9
   11c30:	6570                	ld	a2,200(a0)
   11c32:	64657463          	bgeu	a0,t1,1227a <dtb+0x31a>
   11c36:	3020                	.insn	2, 0x3020
   11c38:	3878                	.insn	2, 0x3878
   11c3a:	3030                	.insn	2, 0x3030
   11c3c:	3030                	.insn	2, 0x3030
   11c3e:	3030                	.insn	2, 0x3030
   11c40:	302d                	.insn	2, 0x302d
   11c42:	3878                	.insn	2, 0x3878
   11c44:	4646                	lw	a2,80(sp)
   11c46:	4646                	lw	a2,80(sp)
   11c48:	4646                	lw	a2,80(sp)
   11c4a:	0a29                	add	s4,s4,10
   11c4c:	0000                	unimp
   11c4e:	0000                	unimp
   11c50:	2d2d                	addw	s10,s10,11
   11c52:	2d2d                	addw	s10,s10,11
   11c54:	2d2d                	addw	s10,s10,11
   11c56:	2d2d                	addw	s10,s10,11
   11c58:	2d2d                	addw	s10,s10,11
   11c5a:	2d2d                	addw	s10,s10,11
   11c5c:	2d2d                	addw	s10,s10,11
   11c5e:	2d2d                	addw	s10,s10,11
   11c60:	2d2d                	addw	s10,s10,11
   11c62:	2d2d                	addw	s10,s10,11
   11c64:	2d2d                	addw	s10,s10,11
   11c66:	2d2d                	addw	s10,s10,11
   11c68:	2d2d                	addw	s10,s10,11
   11c6a:	2d2d                	addw	s10,s10,11
   11c6c:	2d2d                	addw	s10,s10,11
   11c6e:	2d2d                	addw	s10,s10,11
   11c70:	2d2d                	addw	s10,s10,11
   11c72:	2d2d                	addw	s10,s10,11
   11c74:	000a                	c.slli	zero,0x2
   11c76:	0000                	unimp
   11c78:	2020                	.insn	2, 0x2020
   11c7a:	2020                	.insn	2, 0x2020
   11c7c:	2020                	.insn	2, 0x2020
   11c7e:	2020                	.insn	2, 0x2020
   11c80:	2020                	.insn	2, 0x2020
   11c82:	2020                	.insn	2, 0x2020
   11c84:	2020                	.insn	2, 0x2020
   11c86:	5320                	lw	s0,96(a4)
   11c88:	5220434f          	.insn	4, 0x5220434f
   11c8c:	2e2e4d4f          	.insn	4, 0x2e2e4d4f
   11c90:	202e                	.insn	2, 0x202e
   11c92:	2020                	.insn	2, 0x2020
   11c94:	2020                	.insn	2, 0x2020
   11c96:	2020                	.insn	2, 0x2020
   11c98:	2020                	.insn	2, 0x2020
   11c9a:	2020                	.insn	2, 0x2020
   11c9c:	000a                	c.slli	zero,0x2
   11c9e:	0000                	unimp
   11ca0:	3431                	addw	s0,s0,-20
   11ca2:	303a                	.insn	2, 0x303a
   11ca4:	32333a37          	lui	s4,0x32333
	...
   11cb0:	6f4e                	ld	t5,208(sp)
   11cb2:	2076                	.insn	2, 0x2076
   11cb4:	3520                	.insn	2, 0x3520
   11cb6:	3220                	.insn	2, 0x3220
   11cb8:	3230                	.insn	2, 0x3230
   11cba:	0035                	c.nop	13
   11cbc:	0000                	unimp
   11cbe:	0000                	unimp
   11cc0:	706d6f43          	.insn	4, 0x706d6f43
   11cc4:	6c69                	lui	s8,0x1a
   11cc6:	6465                	lui	s0,0x19
   11cc8:	6f20                	ld	s0,88(a4)
   11cca:	3a6e                	.insn	2, 0x3a6e
   11ccc:	2520                	.insn	2, 0x2520
   11cce:	74612073          	csrs	0x746,sp
   11cd2:	2520                	.insn	2, 0x2520
   11cd4:	00000a73          	.insn	4, 0x0a73
   11cd8:	7566                	ld	a0,120(sp)
   11cda:	636e                	ld	t1,216(sp)
   11cdc:	203a                	.insn	2, 0x203a
   11cde:	7325                	lui	t1,0xfffe9
   11ce0:	202c                	.insn	2, 0x202c
   11ce2:	696c                	ld	a1,208(a0)
   11ce4:	656e                	ld	a0,216(sp)
   11ce6:	203a                	.insn	2, 0x203a
   11ce8:	6425                	lui	s0,0x9
   11cea:	0d20                	add	s0,sp,664
   11cec:	000a                	c.slli	zero,0x2
   11cee:	0000                	unimp
   11cf0:	7566                	ld	a0,120(sp)
   11cf2:	636e                	ld	t1,216(sp)
   11cf4:	203a                	.insn	2, 0x203a
   11cf6:	7325                	lui	t1,0xfffe9
   11cf8:	202c                	.insn	2, 0x202c
   11cfa:	696c                	ld	a1,208(a0)
   11cfc:	656e                	ld	a0,216(sp)
   11cfe:	203a                	.insn	2, 0x203a
   11d00:	6425                	lui	s0,0x9
   11d02:	202c                	.insn	2, 0x202c
   11d04:	74617473          	csrrc	s0,0x746,2
   11d08:	7375                	lui	t1,0xffffd
   11d0a:	3d20                	.insn	2, 0x3d20
   11d0c:	2520                	.insn	2, 0x2520
   11d0e:	0a78                	add	a4,sp,284
	...
   11d18:	7566                	ld	a0,120(sp)
   11d1a:	636e                	ld	t1,216(sp)
   11d1c:	203a                	.insn	2, 0x203a
   11d1e:	7325                	lui	t1,0xfffe9
   11d20:	202c                	.insn	2, 0x202c
   11d22:	696c                	ld	a1,208(a0)
   11d24:	656e                	ld	a0,216(sp)
   11d26:	203a                	.insn	2, 0x203a
   11d28:	6425                	lui	s0,0x9
   11d2a:	202c                	.insn	2, 0x202c
   11d2c:	74617473          	csrrc	s0,0x746,2
   11d30:	7375                	lui	t1,0xffffd
   11d32:	3d20                	.insn	2, 0x3d20
   11d34:	3020                	.insn	2, 0x3020
   11d36:	2578                	.insn	2, 0x2578
   11d38:	0a78                	add	a4,sp,284
   11d3a:	0000                	unimp
   11d3c:	0000                	unimp
   11d3e:	0000                	unimp
   11d40:	20636f73          	csrrs	t5,0x206,6
   11d44:	6966                	ld	s2,88(sp)
   11d46:	6d72                	ld	s10,280(sp)
   11d48:	65726177          	.insn	4, 0x65726177
   11d4c:	0a3a                	sll	s4,s4,0xe
   11d4e:	0000                	unimp
   11d50:	7830                	ld	a2,112(s0)
   11d52:	3025                	.insn	2, 0x3025
   11d54:	7832                	ld	a6,296(sp)
   11d56:	0020                	add	s0,sp,8
   11d58:	000a                	c.slli	zero,0x2
   11d5a:	0000                	unimp
   11d5c:	0000                	unimp
   11d5e:	0000                	unimp
   11d60:	eade                	sd	s7,336(sp)
   11d62:	ea66ffff          	.insn	4, 0xea66ffff
   11d66:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d6a:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d6e:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d72:	ea3affff          	.insn	4, 0xea3affff
   11d76:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d7a:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d7e:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d82:	ea32ffff          	.insn	4, 0xea32ffff
   11d86:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d8a:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d8e:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d92:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d96:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d9a:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11d9e:	eac8ffff          	.insn	4, 0xeac8ffff
   11da2:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11da6:	ea66ffff          	.insn	4, 0xea66ffff
   11daa:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11dae:	eaf8ffff          	.insn	4, 0xeaf8ffff
   11db2:	ea42ffff          	.insn	4, 0xea42ffff
   11db6:	cccdffff          	.insn	4, 0xcccdffff
   11dba:	cccc                	sw	a1,28(s1)
   11dbc:	cccc                	sw	a1,28(s1)
   11dbe:	cccc                	sw	a1,28(s1)

0000000000011dc0 <default_uds_seed>:
   11dc0:	00010203          	lb	tp,0(sp)
   11dc4:	04050607          	.insn	4, 0x04050607
   11dc8:	08090a0b          	.insn	4, 0x08090a0b
   11dcc:	0c0d0e0f          	.insn	4, 0x0c0d0e0f
   11dd0:	10111213          	.insn	4, 0x10111213
   11dd4:	14151617          	auipc	a2,0x14151
   11dd8:	18191a1b          	.insn	4, 0x18191a1b
   11ddc:	1e1f 1c1d 2223      	.insn	6, 0x22231c1d1e1f
   11de2:	2021                	.insn	2, 0x2021
   11de4:	24252627          	.insn	4, 0x24252627
   11de8:	28292a2b          	.insn	4, 0x28292a2b
   11dec:	2c2d2e2f          	.insn	4, 0x2c2d2e2f

0000000000011df0 <default_field_entropy>:
   11df0:	80818283          	lb	t0,-2040(gp)
   11df4:	84858687          	.insn	4, 0x84858687
   11df8:	88898a8b          	.insn	4, 0x88898a8b
   11dfc:	8c8d8e8f          	.insn	4, 0x8c8d8e8f
   11e00:	90919293          	.insn	4, 0x90919293
   11e04:	94959697          	auipc	a3,0x94959
   11e08:	98999a9b          	.insn	4, 0x98999a9b
   11e0c:	9e9f 9c9d 0a32      	.insn	6, 0x0a329c9d9e9f
   11e12:	0000                	unimp
   11e14:	0000                	unimp
   11e16:	0000                	unimp
   11e18:	6146                	ld	sp,80(sp)
   11e1a:	6c69                	lui	s8,0x1a
   11e1c:	6465                	lui	s0,0x19
   11e1e:	7420                	ld	s0,104(s0)
   11e20:	6e69206f          	j	a4506 <dtb+0x925a6>
   11e24:	7469                	lui	s0,0xffffa
   11e26:	6620                	ld	s0,72(a2)
   11e28:	7375                	lui	t1,0xffffd
   11e2a:	7365                	lui	t1,0xffff9
   11e2c:	203a                	.insn	2, 0x203a
   11e2e:	6425                	lui	s0,0x9
   11e30:	000a                	c.slli	zero,0x2
   11e32:	0000                	unimp
   11e34:	0000                	unimp
	...

0000000000011e38 <default_uds_seed>:
   11e38:	00010203          	lb	tp,0(sp)
   11e3c:	04050607          	.insn	4, 0x04050607
   11e40:	08090a0b          	.insn	4, 0x08090a0b
   11e44:	0c0d0e0f          	.insn	4, 0x0c0d0e0f
   11e48:	10111213          	.insn	4, 0x10111213
   11e4c:	14151617          	auipc	a2,0x14151
   11e50:	18191a1b          	.insn	4, 0x18191a1b
   11e54:	1e1f 1c1d 2223      	.insn	6, 0x22231c1d1e1f
   11e5a:	2021                	.insn	2, 0x2021
   11e5c:	24252627          	.insn	4, 0x24252627
   11e60:	28292a2b          	.insn	4, 0x28292a2b
   11e64:	2c2d2e2f          	.insn	4, 0x2c2d2e2f

0000000000011e68 <default_field_entropy>:
   11e68:	80818283          	lb	t0,-2040(gp)
   11e6c:	84858687          	.insn	4, 0x84858687
   11e70:	88898a8b          	.insn	4, 0x88898a8b
   11e74:	8c8d8e8f          	.insn	4, 0x8c8d8e8f
   11e78:	90919293          	.insn	4, 0x90919293
   11e7c:	94959697          	auipc	a3,0x94959
   11e80:	98999a9b          	.insn	4, 0x98999a9b
   11e84:	9e9f 9c9d 7566      	.insn	6, 0x75669c9d9e9f
   11e8a:	636e                	ld	t1,216(sp)
   11e8c:	203a                	.insn	2, 0x203a
   11e8e:	7325                	lui	t1,0xfffe9
   11e90:	202c                	.insn	2, 0x202c
   11e92:	696c                	ld	a1,208(a0)
   11e94:	656e                	ld	a0,216(sp)
   11e96:	203a                	.insn	2, 0x203a
   11e98:	6425                	lui	s0,0x9
   11e9a:	0d20                	add	s0,sp,664
   11e9c:	000a                	c.slli	zero,0x2
	...

0000000000011ea0 <__func__.5>:
   11ea0:	696c6163          	bltu	s8,s6,12522 <dtb+0x5c2>
   11ea4:	7470                	ld	a2,232(s0)
   11ea6:	6172                	ld	sp,280(sp)
   11ea8:	635f 6568 6b63      	.insn	6, 0x6b636568635f
   11eae:	735f 6174 7574      	.insn	6, 0x75746174735f
   11eb4:	65675f73          	csrrw	t5,hviprio1h,14
   11eb8:	5f74                	lw	a3,124(a4)
   11eba:	6572                	ld	a0,280(sp)
   11ebc:	6e6f7073          	csrc	0x6e6,30
   11ec0:	00006573          	csrrs	a0,0x0,0
   11ec4:	0000                	unimp
	...

0000000000011ec8 <__func__.4>:
   11ec8:	696c6163          	bltu	s8,s6,1254a <dtb+0x5ea>
   11ecc:	7470                	ld	a2,232(s0)
   11ece:	6172                	ld	sp,280(sp)
   11ed0:	6d5f 6961 626c      	.insn	6, 0x626c69616d5f
   11ed6:	735f786f          	jal	a6,109e0a <dtb+0xf7eaa>
   11eda:	6e65                	lui	t3,0x19
   11edc:	5f64                	lw	s1,124(a4)
   11ede:	72617473          	csrrc	s0,mhpmevent6h,2
   11ee2:	0074                	add	a3,sp,12
   11ee4:	0000                	unimp
	...

0000000000011ee8 <__func__.3>:
   11ee8:	696c6163          	bltu	s8,s6,1256a <dtb+0x60a>
   11eec:	7470                	ld	a2,232(s0)
   11eee:	6172                	ld	sp,280(sp)
   11ef0:	6d5f 6961 626c      	.insn	6, 0x626c69616d5f
   11ef6:	735f786f          	jal	a6,109e2a <dtb+0xf7eca>
   11efa:	6e65                	lui	t3,0x19
   11efc:	5f64                	lw	s1,124(a4)
   11efe:	706d6f63          	bltu	s10,t1,1261c <dtb+0x6bc>
   11f02:	656c                	ld	a1,200(a0)
   11f04:	6574                	ld	a3,200(a0)
	...

0000000000011f08 <__func__.2>:
   11f08:	696c6163          	bltu	s8,s6,1258a <dtb+0x62a>
   11f0c:	7470                	ld	a2,232(s0)
   11f0e:	6172                	ld	sp,280(sp)
   11f10:	6d5f 6961 626c      	.insn	6, 0x626c69616d5f
   11f16:	655f786f          	jal	a6,109d6a <dtb+0xf7e0a>
   11f1a:	6578                	ld	a4,200(a0)
   11f1c:	65747563          	bgeu	s0,s7,12566 <dtb+0x606>
	...

0000000000011f28 <__func__.1>:
   11f28:	6170                	ld	a2,192(a0)
   11f2a:	615f6b63          	bltu	t5,s5,12540 <dtb+0x5e0>
   11f2e:	646e                	ld	s0,216(sp)
   11f30:	655f 6578 7563      	.insn	6, 0x75636578655f
   11f36:	6574                	ld	a3,200(a0)
   11f38:	635f 6d6f 616d      	.insn	6, 0x616d6d6f635f
   11f3e:	646e                	ld	s0,216(sp)
	...

0000000000011f48 <__func__.0>:
   11f48:	696c6163          	bltu	s8,s6,125ca <dtb+0x66a>
   11f4c:	7470                	ld	a2,232(s0)
   11f4e:	6172                	ld	sp,280(sp)
   11f50:	635f 6d6f 6c70      	.insn	6, 0x6c706d6f635f
   11f56:	7465                	lui	s0,0xffff9
   11f58:	0065                	c.nop	25
   11f5a:	0000                	unimp
   11f5c:	0000                	unimp
	...

Disassembly of section .bss:

0000000008020000 <g_caliptra_mbox_pending_rx_buffer>:
	...

Disassembly of section .riscv.attributes:

0000000000000000 <.riscv.attributes>:
   0:	3341                	addw	t1,t1,-16 # fffffffffffe8ff0 <_sp+0xfffffffff7fa8ff8>
   2:	0000                	unimp
   4:	7200                	ld	s0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <_prog_start-0xffec>
   c:	0029                	c.nop	10
   e:	0000                	unimp
  10:	1004                	add	s1,sp,32
  12:	7205                	lui	tp,0xfffe1
  14:	3676                	.insn	2, 0x3676
  16:	6934                	ld	a3,80(a0)
  18:	7032                	.insn	2, 0x7032
  1a:	5f30                	lw	a2,120(a4)
  1c:	326d                	addw	tp,tp,-5 # fffffffffffe0ffb <_sp+0xfffffffff7fa1003>
  1e:	3070                	.insn	2, 0x3070
  20:	615f 7032 5f30      	.insn	6, 0x5f307032615f
  26:	30703263          	.insn	4, 0x30703263
  2a:	7a5f 6d6d 6c75      	.insn	6, 0x6c756d6d7a5f
  30:	7031                	c.lui	zero,0xfffec
  32:	0030                	add	a2,sp,8

Disassembly of section .comment:

0000000000000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	2029                	.insn	2, 0x2029
   8:	3331                	addw	t1,t1,-20 # ffffffffffff9fec <_sp+0xfffffffff7fb9ff4>
   a:	312e                	.insn	2, 0x312e
   c:	312e                	.insn	2, 0x312e
   e:	3220                	.insn	2, 0x3220
  10:	3230                	.insn	2, 0x3230
  12:	31373033          	.insn	4, 0x31373033
  16:	33 00             	Address 0x16 is out of bounds.

