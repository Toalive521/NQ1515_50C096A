;;lcd_table_start_here

;;--------COM------------
c0	equ	0
c1	equ	1
c2	equ	2
c3	equ	3
c4	equ	4

;;--------SEG------------
s0	equ	0

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

lcd_table1:
LCD_D1:	equ	$-lcd_table1
	db_c_s	c1,s20	;;ADEG
	db_c_s	c0,s20	;;B
	db_c_s	c0,s19	;;C

LCD_D2:	equ	$-lcd_table1
	db_c_s	c4,s19	;;A
	db_c_s	c3,s18	;;B
	db_c_s	c1,s18	;;C
	db_c_s	c0,s18	;;D
	db_c_s	c1,s19	;;E
	db_c_s	c3,s19	;;F
	db_c_s	c2,s19	;;G

LCD_D3:	equ	$-lcd_table1
	db_c_s	c4,s17	;;A
	db_c_s	c4,s16	;;B
	db_c_s	c2,s16	;;C
	db_c_s	c0,s17	;;D
	db_c_s	c1,s17	;;E
	db_c_s	c3,s17	;;F
	db_c_s	c2,s17	;;G

LCD_D4:	equ	$-lcd_table1
	db_c_s	c4,s15	;;A
	db_c_s	c3,s15	;;B
	db_c_s	c1,s15	;;C
	db_c_s	c0,s15	;;D
	db_c_s	c1,s16	;;E
	db_c_s	c3,s16	;;F
	db_c_s	c2,s15	;;G

LCD_D5:	equ	$-lcd_table1
	db_c_s	c3,s13	;;ADEG
	db_c_s	c4,s13	;;B
	db_c_s	c2,s13	;;C

LCD_D6:	equ	$-lcd_table1
	db_c_s	c4,s11	;;A
	db_c_s	c3,s10	;;B
	db_c_s	c2,s10	;;C
	db_c_s	c2,s11	;;D
	db_c_s	c2,s12	;;E
	db_c_s	c3,s12	;;F
	db_c_s	c3,s11	;;G

LCD_D7:	equ	$-lcd_table1
	db_c_s	c3,s8	;;A
	db_c_s	c3,s41	;;B
	db_c_s	c1,s41	;;C
	db_c_s	c0,s40	;;D
	db_c_s	c1,s40	;;E
	db_c_s	c3,s9	;;F
	db_c_s	c2,s8	;;G

LCD_D8:	equ	$-lcd_table1
	db_c_s	c4,s42	;;A
	db_c_s	c3,s42	;;B
	db_c_s	c1,s42	;;C
	db_c_s	c0,s42	;;D
	db_c_s	c0,s41	;;E
	db_c_s	c2,s41	;;F
	db_c_s	c2,s42	;;G

LCD_D910:	equ	$-lcd_table1
	db_c_s	c0,s22	;;9ABCDEG10ABCDEF

LCD_D11:	equ	$-lcd_table1
	db_c_s	c0,s21	;;A
	db_c_s	c1,s22	;;B
	db_c_s	c3,s22	;;C
	db_c_s	c4,s21	;;D
	db_c_s	c3,s21	;;E
	db_c_s	c1,s21	;;F
	db_c_s	c2,s21	;;G

LCD_D12:	equ	$-lcd_table1
	db_c_s	c0,s23	;;A
	db_c_s	c1,s23	;;B
	db_c_s	c3,s23	;;C
	db_c_s	c4,s23	;;D
	db_c_s	c4,s22	;;E
	db_c_s	c2,s22	;;F
	db_c_s	c2,s23	;;G

LCD_D13:	equ	$-lcd_table1
	db_c_s	c2,s24	;;BC

LCD_D14:	equ	$-lcd_table1
	db_c_s	c0,s25	;;A
	db_c_s	c1,s25	;;B
	db_c_s	c3,s25	;;C
	db_c_s	c4,s25	;;D
	db_c_s	c3,s24	;;E
	db_c_s	c1,s24	;;F
	db_c_s	c2,s25	;;G

LCD_D15:	equ	$-lcd_table1
	db_c_s	c1,s26	;;ADG
	db_c_s	c0,s26	;;B
	db_c_s	c2,s26	;;C
	db_c_s	c3,s26	;;E

LCD_D16:	equ	$-lcd_table1
	db_c_s	c0,s27	;;A
	db_c_s	c2,s28	;;B
	db_c_s	c4,s28	;;C
	db_c_s	c4,s27	;;D
	db_c_s	c3,s27	;;E
	db_c_s	c1,s27	;;F
	db_c_s	c2,s27	;;G

LCD_D17:	equ	$-lcd_table1
	db_c_s	c1,s35	;;BC
	db_c_s	c0,s35	;;G

LCD_D18:	equ	$-lcd_table1
	db_c_s	c1,s36	;;A
	db_c_s	c2,s36	;;B
	db_c_s	c4,s36	;;C
	db_c_s	c4,s35	;;D
	db_c_s	c3,s35	;;E
	db_c_s	c2,s35	;;F
	db_c_s	c3,s36	;;G

LCD_D19:	equ	$-lcd_table1
	db_c_s	c0,s37	;;A
	db_c_s	c0,s38	;;B
	db_c_s	c2,s38	;;C
	db_c_s	c4,s37	;;D
	db_c_s	c3,s37	;;E
	db_c_s	c1,s37	;;F
	db_c_s	c2,s37	;;G

LCD_D20:	equ	$-lcd_table1
	db_c_s	c0,s36	;;AEF
	db_c_s	c1,s39	;;D
	db_c_s	c0,s39	;;G

LCD_D21:	equ	$-lcd_table1
	db_c_s	c2,s39	;;A
	db_c_s	c3,s40	;;B
	db_c_s	c4,s40	;;C
	db_c_s	c4,s39	;;D
	db_c_s	c3,s38	;;E
	db_c_s	c1,s38	;;F
	db_c_s	c3,s39	;;G

LCD_P:	equ	$-lcd_table1
	db_c_s	c1,s14	;;P11
	db_c_s	c1,s13	;;P12
	db_c_s	c1,s12	;;P13
	db_c_s	c1,s11	;;P14
	db_c_s	c1,s10	;;P15
	db_c_s	c1,s9	;;P16
	db_c_s	c1,s8	;;P17
	db_c_s	c0,s14	;;P21
	db_c_s	c0,s13	;;P22
	db_c_s	c0,s12	;;P23
	db_c_s	c0,s11	;;P24
	db_c_s	c0,s10	;;P25
	db_c_s	c0,s9	;;P26
	db_c_s	c0,s8	;;P27
	db_c_s	c0,s29	;;P31P37
	db_c_s	c0,s30	;;P32
	db_c_s	c0,s31	;;P33
	db_c_s	c0,s32	;;P34
	db_c_s	c0,s33	;;P35
	db_c_s	c0,s34	;;P36
	db_c_s	c1,s29	;;P41P47
	db_c_s	c1,s30	;;P42
	db_c_s	c1,s31	;;P43
	db_c_s	c1,s32	;;P44
	db_c_s	c1,s33	;;P45
	db_c_s	c1,s34	;;P46
	db_c_s	c2,s29	;;P51P57
	db_c_s	c2,s30	;;P52
	db_c_s	c2,s31	;;P53
	db_c_s	c2,s32	;;P54
	db_c_s	c2,s33	;;P55
	db_c_s	c2,s34	;;P56
	db_c_s	c3,s29	;;P61P67
	db_c_s	c3,s30	;;P62
	db_c_s	c3,s31	;;P63
	db_c_s	c3,s32	;;P64
	db_c_s	c3,s33	;;P65
	db_c_s	c3,s34	;;P66
	db_c_s	c4,s29	;;P71P77
	db_c_s	c4,s30	;;P72
	db_c_s	c4,s31	;;P73
	db_c_s	c4,s32	;;P74
	db_c_s	c4,s33	;;P75
	db_c_s	c4,s34	;;P76

LCD_ALARM:	equ	$-lcd_table1
	db_c_s	c4,s14	;;ALA1
	db_c_s	c4,s10	;;ALA2
	db_c_s	c4,s41	;;ALA3
	db_c_s	c4,s8	;;ALA4
	db_c_s	c4,s12	;;ALA5
	db_c_s	c4,s9	;;ALA6

LCD_DOT:	equ	$-lcd_table1
	db_c_s	c2,s18	;;COL1
	db_c_s	c2,s9	;;COL2
	db_c_s	c4,s38	;;COL3

LCD_ICON:	equ	$-lcd_table1
	db_c_s	c4,s20	;;AM1
	db_c_s	c3,s20	;;PM1
	db_c_s	c2,s20	;;SN
	db_c_s	c4,s18	;;SK
	db_c_s	c0,s16	;;BZ
	db_c_s	c3,s14	;;AM2
	db_c_s	c2,s14	;;PM2
	db_c_s	c0,s24	;;GL
	db_c_s	c0,s28	;;NL
	db_c_s	c4,s24	;;YEAR
	db_c_s	c4,s26	;;DAY
	db_c_s	c3,s28	;;WEEK
;;lcd_end_here

