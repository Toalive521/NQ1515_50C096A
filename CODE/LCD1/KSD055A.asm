;;lcd_table_start_here

;;--------COM------------
c0	equ	0
c1	equ	1
c2	equ	2
c3	equ	3
c4	equ	4
;;--------SEG------------
s8	equ	8
s9	equ	9
s10	equ	10
s11	equ	11
s12	equ	12
s13	equ	13
s14	equ	14
s15	equ	15
s16	equ	16
s17	equ	17
s18	equ	18
s19	equ	19
s20	equ	20
s21	equ	21
s22	equ	22
s23	equ	23
s24	equ	24
s25	equ	25
s26	equ	26
s27	equ	27
s28	equ	28
s29	equ	29
s30	equ	30
s31	equ	31
s32	equ	32
s33	equ	33
s34	equ	34
s35	equ	35
s36	equ	36
s37	equ	37
s38	equ	38
s39	equ	39
s40	equ	40
s41	equ	41
s42	equ	42

db_c_s:      .macro  com,seg
              db com*6+seg/8
              .endm		;1个COM 6个RAM

db_c_y:       .macro  com,seg
			db 1.shl.(seg-seg/8*8)
			.endm

lcd_table1:
lcd_byte:
LCD1_D1_ADEG:	equ	$-lcd_table1
	db_c_s	c3,s18	;;ADEG
LCD1_D1_B:	equ	$-lcd_table1	
	db_c_s	c1,s17	;;B
LCD1_D1_C:	equ	$-lcd_table1	
	db_c_s	c3,s17	;;C
	
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	
	
LCD1_D2:	equ	$-lcd_table1
	db_c_s	c0,s16	;;A
	db_c_s	c1,s16	;;B
	db_c_s	c3,s16	;;C
	db_c_s	c4,s16	;;D
	db_c_s	c4,s17	;;E
	db_c_s	c2,s17	;;F
	db_c_s	c2,s16	;;G

LCD1_D3:	equ	$-lcd_table1
	db_c_s	c0,s14	;;A
	db_c_s	c1,s13	;;B
	db_c_s	c3,s13	;;C
	db_c_s	c4,s14	;;D
	db_c_s	c3,s14	;;E
	db_c_s	c1,s14	;;F
	db_c_s	c2,s14	;;G

LCD1_D4:	equ	$-lcd_table1
	db_c_s	c2,s12	;;A
	db_c_s	c3,s11	;;B
	db_c_s	c4,s11	;;C
	db_c_s	c4,s12	;;D
	db_c_s	c4,s13	;;E
	db_c_s	c2,s13	;;F
	db_c_s	c3,s12	;;G

LCD1_D5:	equ	$-lcd_table1
	db_c_s	c3,s37	;;ADEG
	db_c_s	c2,s37	;;B
	db_c_s	c4,s37	;;C
	
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	

LCD1_D6:	equ	$-lcd_table1
	db_c_s	c0,s38	;;A
	db_c_s	c1,s39	;;B
	db_c_s	c2,s38	;;C
	db_c_s	c4,s38	;;D
	db_c_s	c3,s38	;;E
	db_c_s	c1,s37	;;F
	db_c_s	c1,s38	;;G

LCD1_D7:	equ	$-lcd_table1
	db_c_s	c1,s40	;;A
	db_c_s	c1,s41	;;B
	db_c_s	c3,s40	;;C
	db_c_s	c4,s40	;;D
	db_c_s	c4,s39	;;E
	db_c_s	c2,s39	;;F
	db_c_s	c2,s40	;;G

LCD1_D8:	equ	$-lcd_table1
	db_c_s	c1,s42	;;A
	db_c_s	c2,s42	;;B
	db_c_s	c3,s42	;;C
	db_c_s	c4,s42	;;D
	db_c_s	c4,s41	;;E
	db_c_s	c2,s41	;;F
	db_c_s	c3,s41	;;G

LCD1_D910:	equ	$-lcd_table1
	db_c_s	c4,s20	;;9ABCDEG10ABCDEF

LCD1_D11:	equ	$-lcd_table1
	db_c_s	c4,s19	;;A
	db_c_s	c3,s20	;;B
	db_c_s	c1,s20	;;C
	db_c_s	c0,s19	;;D
	db_c_s	c1,s19	;;E
	db_c_s	c3,s19	;;F
	db_c_s	c2,s19	;;G

LCD1_D12:	equ	$-lcd_table1
	db_c_s	c4,s21	;;A
	db_c_s	c3,s21	;;B
	db_c_s	c1,s21	;;C
	db_c_s	c0,s21	;;D
	db_c_s	c0,s20	;;E
	db_c_s	c2,s20	;;F
	db_c_s	c2,s21	;;G

LCD1_D13:	equ	$-lcd_table1
	db_c_s	c2,s22	;;BC

LCD1_D14:	equ	$-lcd_table1
	db_c_s	c4,s23	;;A
	db_c_s	c3,s23	;;B
	db_c_s	c1,s23	;;C
	db_c_s	c0,s23	;;D
	db_c_s	c1,s22	;;E
	db_c_s	c3,s22	;;F
	db_c_s	c2,s23	;;G

LCD1_D15:	equ	$-lcd_table1
	db_c_s	c3,s24	;;ADG
	db_c_s	c4,s24	;;B
	db_c_s	c2,s24	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c1,s24	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	

LCD1_D16:	equ	$-lcd_table1
	db_c_s	c4,s25	;;A
	db_c_s	c2,s26	;;B
	db_c_s	c0,s26	;;C
	db_c_s	c0,s25	;;D
	db_c_s	c1,s25	;;E
	db_c_s	c3,s25	;;F
	db_c_s	c2,s25	;;G

LCD1_D17:	equ	$-lcd_table1
	db_c_s	c1,s26	;;BC

LCD1_D18:	equ	$-lcd_table1
	db_c_s	c4,s27	;;A
	db_c_s	c4,s28	;;B
	db_c_s	c2,s28	;;C
	db_c_s	c0,s27	;;D
	db_c_s	c1,s27	;;E
	db_c_s	c3,s27	;;F
	db_c_s	c2,s27	;;G

LCD1_D19:	equ	$-lcd_table1
	db_c_s	c3,s28	;;ADG
	db_c_s	c3,s29	;;B
	db_c_s	c1,s29	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c1,s28	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G		

LCD1_D20:	equ	$-lcd_table1
	db_c_s	c4,s30	;;A
	db_c_s	c3,s30	;;B
	db_c_s	c1,s30	;;C
	db_c_s	c0,s30	;;D
	db_c_s	c0,s29	;;E
	db_c_s	c2,s29	;;F
	db_c_s	c2,s30	;;G

LCD1_D21:	equ	$-lcd_table1
LCD1_D21_BC:	equ	$-lcd_table1
	db_c_s	c3,s31	;;BC
LCD1_D21_G:	equ	$-lcd_table1	
	db_c_s	c4,s31	;;G

LCD1_D22:	equ	$-lcd_table1
	db_c_s	c3,s32	;;A
	db_c_s	c2,s32	;;B
	db_c_s	c0,s32	;;C
	db_c_s	c0,s31	;;D
	db_c_s	c1,s31	;;E
	db_c_s	c2,s31	;;F
	db_c_s	c1,s32	;;G

LCD1_D23:	equ	$-lcd_table1
	db_c_s	c4,s33	;;A
	db_c_s	c4,s34	;;B
	db_c_s	c2,s34	;;C
	db_c_s	c0,s33	;;D
	db_c_s	c1,s33	;;E
	db_c_s	c3,s33	;;F
	db_c_s	c2,s33	;;G

LCD1_D24:	equ	$-lcd_table1
	db_c_s	c4,s32	;;AEF
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C		
	db_c_s	c3,s35	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F		
	db_c_s	c4,s35	;;G

LCD1_D25:	equ	$-lcd_table1
	db_c_s	c2,s35	;;A
	db_c_s	c1,s36	;;B
	db_c_s	c0,s36	;;C
	db_c_s	c0,s35	;;D
	db_c_s	c1,s34	;;E
	db_c_s	c3,s34	;;F
	db_c_s	c1,s35	;;G

LCD1_WEEK:	equ	$-lcd_table1
	db_c_s	c0,s18	;;MON
	db_c_s	c0,s17	;;TUE
	db_c_s	c0,s15	;;WED
	db_c_s	c1,s15	;;THU
	db_c_s	c0,s13	;;FRI
	db_c_s	c0,s12	;;SAT
	db_c_s	c1,s12	;;SUN

LCD1_ALARM:	equ	$-lcd_table1
LCD1_ALARM1:	equ	$-lcd_table1
	db_c_s	c0,s11	;;ALA1
LCD1_ALARM2:	equ	$-lcd_table1	
	db_c_s	c0,s39	;;ALA2
LCD1_ALARM3:	equ	$-lcd_table1	
	db_c_s	c0,s42	;;ALA3
LCD1_ALARM4:	equ	$-lcd_table1	
	db_c_s	c0,s41	;;ALA4
LCD1_ALARM5:	equ	$-lcd_table1	
	db_c_s	c0,s37	;;ALA5
LCD1_ALARM6:	equ	$-lcd_table1	
	db_c_s	c0,s40	;;ALA6

LCD1_DOT:	equ	$-lcd_table1
LCD1_COL1:	equ	$-lcd_table1
	db_c_s	c3,s15	;;COL1
LCD1_COL2:	equ	$-lcd_table1
	db_c_s	c3,s39	;;COL2
LCD1_COL3:	equ	$-lcd_table1
	db_c_s	c0,s34	;;COL3

LCD1_ICON:	equ	$-lcd_table1
LCD1_AM1:	equ	$-lcd_table1
	db_c_s	c1,s18	;;AM1
LCD1_PM1:	equ	$-lcd_table1
	db_c_s	c2,s18	;;PM1
LCD1_SNZ:	equ	$-lcd_table1
	db_c_s	c4,s18	;;SN
LCD1_CHM:	equ	$-lcd_table1	
	db_c_s	c2,s15	;;SK
LCD1_BZ:	equ	$-lcd_table1	
	db_c_s	c4,s15	;;BZ
LCD1_AM2:	equ	$-lcd_table1	
	db_c_s	c1,s11	;;AM2
LCD1_PM2:	equ	$-lcd_table1	
	db_c_s	c2,s11	;;PM2
LCD1_YEAR:	equ	$-lcd_table1	
	db_c_s	c0,s22	;;YEAR
LCD1_GL:	equ	$-lcd_table1	
	db_c_s	c4,s22	;;GL
LCD1_NL:	equ	$-lcd_table1	
	db_c_s	c3,s26	;;NL
LCD1_DAY1:	equ	$-lcd_table1	
	db_c_s	c0,s24	;;DAY1
LCD1_DAY2:	equ	$-lcd_table1	
	db_c_s	c0,s28	;;DAY2
;;lcd1_end_here

lcd_bit:
;LCD1_D1_ADEG:	equ	$-lcd_table1
	db_c_y	c3,s18	;;ADEG
;LCD1_D1_B:	equ	$-lcd_table1	
	db_c_y	c1,s17	;;B
;LCD1_D1_C:	equ	$-lcd_table1	
	db_c_y	c3,s17	;;C
	
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	
	
;LCD1_D2:	equ	$-lcd_table1
	db_c_y	c0,s16	;;A
	db_c_y	c1,s16	;;B
	db_c_y	c3,s16	;;C
	db_c_y	c4,s16	;;D
	db_c_y	c4,s17	;;E
	db_c_y	c2,s17	;;F
	db_c_y	c2,s16	;;G

;LCD1_D3:	equ	$-lcd_table1
	db_c_y	c0,s14	;;A
	db_c_y	c1,s13	;;B
	db_c_y	c3,s13	;;C
	db_c_y	c4,s14	;;D
	db_c_y	c3,s14	;;E
	db_c_y	c1,s14	;;F
	db_c_y	c2,s14	;;G

;LCD1_D4:	equ	$-lcd_table1
	db_c_y	c2,s12	;;A
	db_c_y	c3,s11	;;B
	db_c_y	c4,s11	;;C
	db_c_y	c4,s12	;;D
	db_c_y	c4,s13	;;E
	db_c_y	c2,s13	;;F
	db_c_y	c3,s12	;;G

;LCD1_D5:	equ	$-lcd_table1
	db_c_y	c3,s37	;;ADEG
	db_c_y	c2,s37	;;B
	db_c_y	c4,s37	;;C
	
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD1_D6:	equ	$-lcd_table1
	db_c_y	c0,s38	;;A
	db_c_y	c1,s39	;;B
	db_c_y	c2,s38	;;C
	db_c_y	c4,s38	;;D
	db_c_y	c3,s38	;;E
	db_c_y	c1,s37	;;F
	db_c_y	c1,s38	;;G

;LCD1_D7:	equ	$-lcd_table1
	db_c_y	c1,s40	;;A
	db_c_y	c1,s41	;;B
	db_c_y	c3,s40	;;C
	db_c_y	c4,s40	;;D
	db_c_y	c4,s39	;;E
	db_c_y	c2,s39	;;F
	db_c_y	c2,s40	;;G

;LCD1_D8:	equ	$-lcd_table1
	db_c_y	c1,s42	;;A
	db_c_y	c2,s42	;;B
	db_c_y	c3,s42	;;C
	db_c_y	c4,s42	;;D
	db_c_y	c4,s41	;;E
	db_c_y	c2,s41	;;F
	db_c_y	c3,s41	;;G

;LCD1_D910:	equ	$-lcd_table1
	db_c_y	c4,s20	;;9ABCDEG10ABCDEF

;LCD1_D11:	equ	$-lcd_table1
	db_c_y	c4,s19	;;A
	db_c_y	c3,s20	;;B
	db_c_y	c1,s20	;;C
	db_c_y	c0,s19	;;D
	db_c_y	c1,s19	;;E
	db_c_y	c3,s19	;;F
	db_c_y	c2,s19	;;G

;LCD1_D12:	equ	$-lcd_table1
	db_c_y	c4,s21	;;A
	db_c_y	c3,s21	;;B
	db_c_y	c1,s21	;;C
	db_c_y	c0,s21	;;D
	db_c_y	c0,s20	;;E
	db_c_y	c2,s20	;;F
	db_c_y	c2,s21	;;G

;LCD1_D13:	equ	$-lcd_table1
	db_c_y	c2,s22	;;BC

;LCD1_D14:	equ	$-lcd_table1
	db_c_y	c4,s23	;;A
	db_c_y	c3,s23	;;B
	db_c_y	c1,s23	;;C
	db_c_y	c0,s23	;;D
	db_c_y	c1,s22	;;E
	db_c_y	c3,s22	;;F
	db_c_y	c2,s23	;;G

;LCD1_D15:	equ	$-lcd_table1
	db_c_y	c3,s24	;;ADG
	db_c_y	c4,s24	;;B
	db_c_y	c2,s24	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c1,s24	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD1_D16:	equ	$-lcd_table1
	db_c_y	c4,s25	;;A
	db_c_y	c2,s26	;;B
	db_c_y	c0,s26	;;C
	db_c_y	c0,s25	;;D
	db_c_y	c1,s25	;;E
	db_c_y	c3,s25	;;F
	db_c_y	c2,s25	;;G

;LCD1_D17:	equ	$-lcd_table1
	db_c_y	c1,s26	;;BC

;LCD1_D18:	equ	$-lcd_table1
	db_c_y	c4,s27	;;A
	db_c_y	c4,s28	;;B
	db_c_y	c2,s28	;;C
	db_c_y	c0,s27	;;D
	db_c_y	c1,s27	;;E
	db_c_y	c3,s27	;;F
	db_c_y	c2,s27	;;G

;LCD1_D19:	equ	$-lcd_table1
	db_c_y	c3,s28	;;ADG
	db_c_y	c3,s29	;;B
	db_c_y	c1,s29	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c1,s28	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G		

;LCD1_D20:	equ	$-lcd_table1
	db_c_y	c4,s30	;;A
	db_c_y	c3,s30	;;B
	db_c_y	c1,s30	;;C
	db_c_y	c0,s30	;;D
	db_c_y	c0,s29	;;E
	db_c_y	c2,s29	;;F
	db_c_y	c2,s30	;;G

;LCD1_D21:	equ	$-lcd_table1
;LCD1_D21_BC:	equ	$-lcd_table1
	db_c_y	c3,s31	;;BC
;LCD1_D21_G:	equ	$-lcd_table1	
	db_c_y	c4,s31	;;G

;LCD1_D22:	equ	$-lcd_table1
	db_c_y	c3,s32	;;A
	db_c_y	c2,s32	;;B
	db_c_y	c0,s32	;;C
	db_c_y	c0,s31	;;D
	db_c_y	c1,s31	;;E
	db_c_y	c2,s31	;;F
	db_c_y	c1,s32	;;G

;LCD1_D23:	equ	$-lcd_table1
	db_c_y	c4,s33	;;A
	db_c_y	c4,s34	;;B
	db_c_y	c2,s34	;;C
	db_c_y	c0,s33	;;D
	db_c_y	c1,s33	;;E
	db_c_y	c3,s33	;;F
	db_c_y	c2,s33	;;G

;LCD1_D24:	equ	$-lcd_table1
	db_c_y	c4,s32	;;AEF
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C		
	db_c_y	c3,s35	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F		
	db_c_y	c4,s35	;;G

;LCD1_D25:	equ	$-lcd_table1
	db_c_y	c2,s35	;;A
	db_c_y	c1,s36	;;B
	db_c_y	c0,s36	;;C
	db_c_y	c0,s35	;;D
	db_c_y	c1,s34	;;E
	db_c_y	c3,s34	;;F
	db_c_y	c1,s35	;;G

;LCD1_WEEK:	equ	$-lcd_table1
	db_c_y	c0,s18	;;MON
	db_c_y	c0,s17	;;TUE
	db_c_y	c0,s15	;;WED
	db_c_y	c1,s15	;;THU
	db_c_y	c0,s13	;;FRI
	db_c_y	c0,s12	;;SAT
	db_c_y	c1,s12	;;SUN

;LCD_ALARM:	equ	$-lcd_table1
	db_c_y	c0,s11	;;ALA1
	db_c_y	c0,s39	;;ALA2
	db_c_y	c0,s42	;;ALA3
	db_c_y	c0,s41	;;ALA4
	db_c_y	c0,s37	;;ALA5
	db_c_y	c0,s40	;;ALA6

;LCD_DOT:	equ	$-lcd_table1
	db_c_y	c3,s15	;;COL1
	db_c_y	c3,s39	;;COL2
	db_c_y	c0,s34	;;COL3

;LCD_ICON:	equ	$-lcd_table1
	db_c_y	c1,s18	;;AM1
	db_c_y	c2,s18	;;PM1
	db_c_y	c4,s18	;;SN
	db_c_y	c2,s15	;;SK
	db_c_y	c4,s15	;;BZ
	db_c_y	c1,s11	;;AM2
	db_c_y	c2,s11	;;PM2
	db_c_y	c0,s22	;;YEAR
	db_c_y	c4,s22	;;GL
	db_c_y	c3,s26	;;NL
	db_c_y	c0,s24	;;DAY1
	db_c_y	c0,s28	;;DAY2
;;lcd1_end_here
;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD2_table1:
Lcd2_byte
LCD2_D1:	equ	$-LCD2_table1
	db_c_s	c1,s20	;;ADEG
	db_c_s	c0,s20	;;B
	db_c_s	c0,s19	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	

LCD2_D2:	equ	$-LCD2_table1
	db_c_s	c4,s19	;;A
	db_c_s	c3,s18	;;B
	db_c_s	c1,s18	;;C
	db_c_s	c0,s18	;;D
	db_c_s	c1,s19	;;E
	db_c_s	c3,s19	;;F
	db_c_s	c2,s19	;;G

LCD2_D3:	equ	$-LCD2_table1
	db_c_s	c4,s17	;;A
	db_c_s	c4,s16	;;B
	db_c_s	c2,s16	;;C
	db_c_s	c0,s17	;;D
	db_c_s	c1,s17	;;E
	db_c_s	c3,s17	;;F
	db_c_s	c2,s17	;;G

LCD2_D4:	equ	$-LCD2_table1
	db_c_s	c4,s15	;;A
	db_c_s	c3,s15	;;B
	db_c_s	c1,s15	;;C
	db_c_s	c0,s15	;;D
	db_c_s	c1,s16	;;E
	db_c_s	c3,s16	;;F
	db_c_s	c2,s15	;;G

LCD2_D5:	equ	$-LCD2_table1
	db_c_s	c3,s13	;;ADEG
	db_c_s	c4,s13	;;B
	db_c_s	c2,s13	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	

LCD2_D6:	equ	$-LCD2_table1
	db_c_s	c4,s11	;;A
	db_c_s	c3,s10	;;B
	db_c_s	c2,s10	;;C
	db_c_s	c2,s11	;;D
	db_c_s	c2,s12	;;E
	db_c_s	c3,s12	;;F
	db_c_s	c3,s11	;;G

LCD2_D7:	equ	$-LCD2_table1
	db_c_s	c3,s8	;;A
	db_c_s	c3,s41	;;B
	db_c_s	c1,s41	;;C
	db_c_s	c0,s40	;;D
	db_c_s	c1,s40	;;E
	db_c_s	c3,s9	;;F
	db_c_s	c2,s8	;;G

LCD2_D8:	equ	$-LCD2_table1
	db_c_s	c4,s42	;;A
	db_c_s	c3,s42	;;B
	db_c_s	c1,s42	;;C
	db_c_s	c0,s42	;;D
	db_c_s	c0,s41	;;E
	db_c_s	c2,s41	;;F
	db_c_s	c2,s42	;;G

LCD2_D910:	equ	$-LCD2_table1
	db_c_s	c0,s22	;;9ABCDEG10ABCDEF

LCD2_D11:	equ	$-LCD2_table1
	db_c_s	c0,s21	;;A
	db_c_s	c1,s22	;;B
	db_c_s	c3,s22	;;C
	db_c_s	c4,s21	;;D
	db_c_s	c3,s21	;;E
	db_c_s	c1,s21	;;F
	db_c_s	c2,s21	;;G

LCD2_D12:	equ	$-LCD2_table1
	db_c_s	c0,s23	;;A
	db_c_s	c1,s23	;;B
	db_c_s	c3,s23	;;C
	db_c_s	c4,s23	;;D
	db_c_s	c4,s22	;;E
	db_c_s	c2,s22	;;F
	db_c_s	c2,s23	;;G

LCD2_D13:	equ	$-LCD2_table1
	db_c_s	c2,s24	;;BC

LCD2_D14:	equ	$-LCD2_table1
	db_c_s	c0,s25	;;A
	db_c_s	c1,s25	;;B
	db_c_s	c3,s25	;;C
	db_c_s	c4,s25	;;D
	db_c_s	c3,s24	;;E
	db_c_s	c1,s24	;;F
	db_c_s	c2,s25	;;G

LCD2_D15:	equ	$-LCD2_table1
	db_c_s	c1,s26	;;ADG
	db_c_s	c0,s26	;;B
	db_c_s	c2,s26	;;C
	db_c_s	c0,s0	;;D	
	db_c_s	c3,s26	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G		

LCD2_D16:	equ	$-LCD2_table1
	db_c_s	c0,s27	;;A
	db_c_s	c2,s28	;;B
	db_c_s	c4,s28	;;C
	db_c_s	c4,s27	;;D
	db_c_s	c3,s27	;;E
	db_c_s	c1,s27	;;F
	db_c_s	c2,s27	;;G

LCD2_D17:	equ	$-LCD2_table1
LCD2_D21:	equ	$-LCD2_table1
LCD2_D21_BC:	equ	$-LCD2_table1
	db_c_s	c1,s35	;;BC
LCD2_D21_G:	equ	$-LCD2_table1
	db_c_s	c0,s35	;;G

LCD2_D18:	equ	$-LCD2_table1
LCD2_D22:	equ	$-LCD2_table1
	db_c_s	c1,s36	;;A
	db_c_s	c2,s36	;;B
	db_c_s	c4,s36	;;C
	db_c_s	c4,s35	;;D
	db_c_s	c3,s35	;;E
	db_c_s	c2,s35	;;F
	db_c_s	c3,s36	;;G

LCD2_D19:	equ	$-LCD2_table1
LCD2_D23:	equ	$-LCD2_table1
	db_c_s	c0,s37	;;A
	db_c_s	c0,s38	;;B
	db_c_s	c2,s38	;;C
	db_c_s	c4,s37	;;D
	db_c_s	c3,s37	;;E
	db_c_s	c1,s37	;;F
	db_c_s	c2,s37	;;G

LCD2_D20:	equ	$-LCD2_table1
LCD2_D24:	equ	$-LCD2_table1
	db_c_s	c0,s36	;;AEF
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C	
	db_c_s	c1,s39	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F		
	db_c_s	c0,s39	;;G

LCD2_D21:	equ	$-LCD2_table1
LCD2_D25:	equ	$-LCD2_table1
	db_c_s	c2,s39	;;A
	db_c_s	c3,s40	;;B
	db_c_s	c4,s40	;;C
	db_c_s	c4,s39	;;D
	db_c_s	c3,s38	;;E
	db_c_s	c1,s38	;;F
	db_c_s	c3,s39	;;G

LCD2_P:	equ	$-LCD2_table1
LCD2_WEEK1:	equ	$-LCD2_table1
	db_c_s	c1,s14	;;P11
	db_c_s	c1,s13	;;P12
	db_c_s	c1,s12	;;P13
	db_c_s	c1,s11	;;P14
	db_c_s	c1,s10	;;P15
	db_c_s	c1,s9	;;P16
	db_c_s	c1,s8	;;P17
LCD2_WEEK2:	equ	$-LCD2_table1	
	db_c_s	c0,s14	;;P21
	db_c_s	c0,s13	;;P22
	db_c_s	c0,s12	;;P23
	db_c_s	c0,s11	;;P24
	db_c_s	c0,s10	;;P25
	db_c_s	c0,s9	;;P26
	db_c_s	c0,s8	;;P27
LCD2_WEEK3:	equ	$-LCD2_table1	
	db_c_s	c0,s29	;;P31P37
	db_c_s	c0,s30	;;P32
	db_c_s	c0,s31	;;P33
	db_c_s	c0,s32	;;P34
	db_c_s	c0,s33	;;P35
	db_c_s	c0,s34	;;P36
	db_c_s	c0,s0	;;P37	
LCD2_WEEK4:	equ	$-LCD2_table1	
	db_c_s	c1,s29	;;P41P47
	db_c_s	c1,s30	;;P42
	db_c_s	c1,s31	;;P43
	db_c_s	c1,s32	;;P44
	db_c_s	c1,s33	;;P45
	db_c_s	c1,s34	;;P46
	db_c_s	c0,s0	;;P47	
LCD2_WEEK5:	equ	$-LCD2_table1	
	db_c_s	c2,s29	;;P51P57
	db_c_s	c2,s30	;;P52
	db_c_s	c2,s31	;;P53
	db_c_s	c2,s32	;;P54
	db_c_s	c2,s33	;;P55
	db_c_s	c2,s34	;;P56
	db_c_s	c0,s0	;;P57	
LCD2_WEEK6:	equ	$-LCD2_table1	
	db_c_s	c3,s29	;;P61P67
	db_c_s	c3,s30	;;P62
	db_c_s	c3,s31	;;P63
	db_c_s	c3,s32	;;P64
	db_c_s	c3,s33	;;P65
	db_c_s	c3,s34	;;P66
	db_c_s	c0,s0	;;P67	
LCD2_WEEK7:	equ	$-LCD2_table1
	db_c_s	c4,s29	;;P71P77
	db_c_s	c4,s30	;;P72
	db_c_s	c4,s31	;;P73
	db_c_s	c4,s32	;;P74
	db_c_s	c4,s33	;;P75
	db_c_s	c4,s34	;;P76
	db_c_s	c0,s0	;;P77

LCD2_ALARM:	equ	$-LCD2_table1
LCD2_ALARM1:	equ	$-LCD2_table1
	db_c_s	c4,s14	;;ALA1
LCD2_ALARM2:	equ	$-LCD2_table1
	db_c_s	c4,s10	;;ALA2
LCD2_ALARM3:	equ	$-LCD2_table1
	db_c_s	c4,s41	;;ALA3
LCD2_ALARM4:	equ	$-LCD2_table1
	db_c_s	c4,s8	;;ALA4
LCD2_ALARM5:	equ	$-LCD2_table1
	db_c_s	c4,s12	;;ALA5
LCD2_ALARM6:	equ	$-LCD2_table1
	db_c_s	c4,s9	;;ALA6

LCD2_DOT:	equ	$-LCD2_table1
LCD2_COL1:	equ	$-LCD2_table1
	db_c_s	c2,s18	;;COL1
LCD2_COL2:	equ	$-LCD2_table1
	db_c_s	c2,s9	;;COL2
LCD2_COL3:	equ	$-LCD2_table1
	db_c_s	c4,s38	;;COL3

LCD2_ICON:	equ	$-LCD2_table1
LCD2_AM1:	equ	$-LCD2_table1
	db_c_s	c4,s20	;;AM1
LCD2_PM1:	equ	$-LCD2_table1
	db_c_s	c3,s20	;;PM1
LCD2_SNZ:	equ	$-LCD2_table1
	db_c_s	c2,s20	;;SN
LCD2_CHM:	equ	$-LCD2_table1
	db_c_s	c4,s18	;;SK
LCD2_BZ:	equ	$-LCD2_table1
	db_c_s	c0,s16	;;BZ
LCD2_AM2:	equ	$-LCD2_table1
	db_c_s	c3,s14	;;AM2
LCD2_PM2:	equ	$-LCD2_table1
	db_c_s	c2,s14	;;PM2
LCD2_GL:	equ	$-LCD2_table1
	db_c_s	c0,s24	;;GL
LCD2_NL:	equ	$-LCD2_table1
	db_c_s	c0,s28	;;NL
LCD2_YEAR:	equ	$-LCD2_table1
	db_c_s	c4,s24	;;YEAR
LCD2_DAY:	equ	$-LCD2_table1
	db_c_s	c4,s26	;;DAY
LCD2_WEEK:	equ	$-LCD2_table1
	db_c_s	c3,s28	;;WEEK
;;LCD2_end_here
;;;;;;;;;;;;;;;
Lcd2_bit
;LCD2_D1:	equ	$-LCD2_table1
	db_c_y	c1,s20	;;ADEG
	db_c_y	c0,s20	;;B
	db_c_y	c0,s19	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD2_D2:	equ	$-LCD2_table1
	db_c_y	c4,s19	;;A
	db_c_y	c3,s18	;;B
	db_c_y	c1,s18	;;C
	db_c_y	c0,s18	;;D
	db_c_y	c1,s19	;;E
	db_c_y	c3,s19	;;F
	db_c_y	c2,s19	;;G

;LCD2_D3:	equ	$-LCD2_table1
	db_c_y	c4,s17	;;A
	db_c_y	c4,s16	;;B
	db_c_y	c2,s16	;;C
	db_c_y	c0,s17	;;D
	db_c_y	c1,s17	;;E
	db_c_y	c3,s17	;;F
	db_c_y	c2,s17	;;G

;LCD2_D4:	equ	$-LCD2_table1
	db_c_y	c4,s15	;;A
	db_c_y	c3,s15	;;B
	db_c_y	c1,s15	;;C
	db_c_y	c0,s15	;;D
	db_c_y	c1,s16	;;E
	db_c_y	c3,s16	;;F
	db_c_y	c2,s15	;;G

;LCD2_D5:	equ	$-LCD2_table1
	db_c_y	c3,s13	;;ADEG
	db_c_y	c4,s13	;;B
	db_c_y	c2,s13	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD2_D6:	equ	$-LCD2_table1
	db_c_y	c4,s11	;;A
	db_c_y	c3,s10	;;B
	db_c_y	c2,s10	;;C
	db_c_y	c2,s11	;;D
	db_c_y	c2,s12	;;E
	db_c_y	c3,s12	;;F
	db_c_y	c3,s11	;;G

;LCD2_D7:	equ	$-LCD2_table1
	db_c_y	c3,s8	;;A
	db_c_y	c3,s41	;;B
	db_c_y	c1,s41	;;C
	db_c_y	c0,s40	;;D
	db_c_y	c1,s40	;;E
	db_c_y	c3,s9	;;F
	db_c_y	c2,s8	;;G

;LCD2_D8:	equ	$-LCD2_table1
	db_c_y	c4,s42	;;A
	db_c_y	c3,s42	;;B
	db_c_y	c1,s42	;;C
	db_c_y	c0,s42	;;D
	db_c_y	c0,s41	;;E
	db_c_y	c2,s41	;;F
	db_c_y	c2,s42	;;G

;LCD2_D910:	equ	$-LCD2_table1
	db_c_y	c0,s22	;;9ABCDEG10ABCDEF

;LCD2_D11:	equ	$-LCD2_table1
	db_c_y	c0,s21	;;A
	db_c_y	c1,s22	;;B
	db_c_y	c3,s22	;;C
	db_c_y	c4,s21	;;D
	db_c_y	c3,s21	;;E
	db_c_y	c1,s21	;;F
	db_c_y	c2,s21	;;G

;LCD2_D12:	equ	$-LCD2_table1
	db_c_y	c0,s23	;;A
	db_c_y	c1,s23	;;B
	db_c_y	c3,s23	;;C
	db_c_y	c4,s23	;;D
	db_c_y	c4,s22	;;E
	db_c_y	c2,s22	;;F
	db_c_y	c2,s23	;;G

;LCD2_D13:	equ	$-LCD2_table1
	db_c_y	c2,s24	;;BC

;LCD2_D14:	equ	$-LCD2_table1
	db_c_y	c0,s25	;;A
	db_c_y	c1,s25	;;B
	db_c_y	c3,s25	;;C
	db_c_y	c4,s25	;;D
	db_c_y	c3,s24	;;E
	db_c_y	c1,s24	;;F
	db_c_y	c2,s25	;;G

;LCD2_D15:	equ	$-LCD2_table1
	db_c_y	c1,s26	;;ADG
	db_c_y	c0,s26	;;B
	db_c_y	c2,s26	;;C
	db_c_y	c0,s0	;;D	
	db_c_y	c3,s26	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G		

;LCD2_D16:	equ	$-LCD2_table1
	db_c_y	c0,s27	;;A
	db_c_y	c2,s28	;;B
	db_c_y	c4,s28	;;C
	db_c_y	c4,s27	;;D
	db_c_y	c3,s27	;;E
	db_c_y	c1,s27	;;F
	db_c_y	c2,s27	;;G

;LCD2_D17:	equ	$-LCD2_table1
;LCD2_D21:	equ	$-LCD2_table1
	db_c_y	c1,s35	;;BC
	db_c_y	c0,s35	;;G

;LCD2_D18:	equ	$-LCD2_table1
;LCD2_D22:	equ	$-LCD2_table1
	db_c_y	c1,s36	;;A
	db_c_y	c2,s36	;;B
	db_c_y	c4,s36	;;C
	db_c_y	c4,s35	;;D
	db_c_y	c3,s35	;;E
	db_c_y	c2,s35	;;F
	db_c_y	c3,s36	;;G

;LCD2_D19:	equ	$-LCD2_table1
;LCD2_D23:	equ	$-LCD2_table1
	db_c_y	c0,s37	;;A
	db_c_y	c0,s38	;;B
	db_c_y	c2,s38	;;C
	db_c_y	c4,s37	;;D
	db_c_y	c3,s37	;;E
	db_c_y	c1,s37	;;F
	db_c_y	c2,s37	;;G

;LCD2_D20:	equ	$-LCD2_table1
;LCD2_D24:	equ	$-LCD2_table1
	db_c_y	c0,s36	;;AEF
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C	
	db_c_y	c1,s39	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F		
	db_c_y	c0,s39	;;G

;LCD2_D21:	equ	$-LCD2_table1
;LCD2_D25:	equ	$-LCD2_table1
	db_c_y	c2,s39	;;A
	db_c_y	c3,s40	;;B
	db_c_y	c4,s40	;;C
	db_c_y	c4,s39	;;D
	db_c_y	c3,s38	;;E
	db_c_y	c1,s38	;;F
	db_c_y	c3,s39	;;G

;LCD2_P:	equ	$-LCD2_table1
	db_c_y	c1,s14	;;P11
	db_c_y	c1,s13	;;P12
	db_c_y	c1,s12	;;P13
	db_c_y	c1,s11	;;P14
	db_c_y	c1,s10	;;P15
	db_c_y	c1,s9	;;P16
	db_c_y	c1,s8	;;P17
	
	db_c_y	c0,s14	;;P21
	db_c_y	c0,s13	;;P22
	db_c_y	c0,s12	;;P23
	db_c_y	c0,s11	;;P24
	db_c_y	c0,s10	;;P25
	db_c_y	c0,s9	;;P26
	db_c_y	c0,s8	;;P27
	
	db_c_y	c0,s29	;;P31P37
	db_c_y	c0,s30	;;P32
	db_c_y	c0,s31	;;P33
	db_c_y	c0,s32	;;P34
	db_c_y	c0,s33	;;P35
	db_c_y	c0,s34	;;P36
	db_c_y	c0,s0	;;P37	
	
	db_c_y	c1,s29	;;P41P47
	db_c_y	c1,s30	;;P42
	db_c_y	c1,s31	;;P43
	db_c_y	c1,s32	;;P44
	db_c_y	c1,s33	;;P45
	db_c_y	c1,s34	;;P46
	db_c_y	c0,s0	;;P47	
	
	db_c_y	c2,s29	;;P51P57
	db_c_y	c2,s30	;;P52
	db_c_y	c2,s31	;;P53
	db_c_y	c2,s32	;;P54
	db_c_y	c2,s33	;;P55
	db_c_y	c2,s34	;;P56
	db_c_y	c0,s0	;;P57
	
	db_c_y	c3,s29	;;P61P67
	db_c_y	c3,s30	;;P62
	db_c_y	c3,s31	;;P63
	db_c_y	c3,s32	;;P64
	db_c_y	c3,s33	;;P65
	db_c_y	c3,s34	;;P66
	db_c_y	c0,s0	;;P67
	
	db_c_y	c4,s29	;;P71P77
	db_c_y	c4,s30	;;P72
	db_c_y	c4,s31	;;P73
	db_c_y	c4,s32	;;P74
	db_c_y	c4,s33	;;P75
	db_c_y	c4,s34	;;P76
	db_c_y	c0,s0	;;P77

;LCD2_ALARM:	equ	$-LCD2_table1
	db_c_y	c4,s14	;;ALA1
	db_c_y	c4,s10	;;ALA2
	db_c_y	c4,s41	;;ALA3
	db_c_y	c4,s8	;;ALA4
	db_c_y	c4,s12	;;ALA5
	db_c_y	c4,s9	;;ALA6

;LCD2_DOT:	equ	$-LCD2_table1
	db_c_y	c2,s18	;;COL1
	db_c_y	c2,s9	;;COL2
	db_c_y	c4,s38	;;COL3

;LCD2_ICON:	equ	$-LCD2_table1
	db_c_y	c4,s20	;;AM1
	db_c_y	c3,s20	;;PM1
	db_c_y	c2,s20	;;SN
	db_c_y	c4,s18	;;SK
	db_c_y	c0,s16	;;BZ
	db_c_y	c3,s14	;;AM2
	db_c_y	c2,s14	;;PM2
	db_c_y	c0,s24	;;GL
	db_c_y	c0,s28	;;NL
	db_c_y	c4,s24	;;YEAR
	db_c_y	c4,s26	;;DAY
	db_c_y	c3,s28	;;WEEK
;;LCD2_end_here
