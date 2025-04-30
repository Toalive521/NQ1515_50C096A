;;lcd_table_start_here

;2-TABLE:670 Byte

;;--------COM------------
c0	equ	0
c1	equ	1
c2	equ	2
c3	equ	3
c4	equ	4
;;--------SEG------------
s0	equ	0	


s4	equ	4
s5	equ	5
; s6	equ	6
; s7	equ	7
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
s43	equ	43

db_c_s:      .macro  com,seg
              db com*6+seg/8
              .endm		;1个COM 6个RAM

db_c_y:       .macro  com,seg
			db 1.shl.(seg-seg/8*8)
			.endm

lcd_table1:
lcd_byte:

LCD_TIME_HRH:	equ	$-lcd_table1	;HRH
LCD1_D1:	equ	$-lcd_table1	;hr
LCD1_D1_ADEG:	equ	$-lcd_table1
	db_c_s	c1,s33	;;ADEG
LCD1_D1_B:	equ	$-lcd_table1	
	db_c_s	c2,s33	;;B
LCD1_D1_C:	equ	$-lcd_table1	
	db_c_s	c0,s33	;;C
	
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	
	
;-------------------------------------------------------------
LCD_TIME_HRL:	equ	$-lcd_table1	;HRL
LCD1_D2:	equ	$-lcd_table1	;hrl
	db_c_s	c3,s35	;;A
	db_c_s	c2,s35	;;B
	db_c_s	c1,s35	;;C
	db_c_s	c0,s35	;;D
	db_c_s	c1,s34	;;E
	db_c_s	c3,s34	;;F
	db_c_s	c2,s34	;;G

;-------------------------------------------------------------
LCD_TIME_MINH:	equ	$-lcd_table1	;MINH
LCD1_D3:	equ	$-lcd_table1	;minh
	db_c_s	c3,s37	;;A
	db_c_s	c2,s37	;;B
	db_c_s	c1,s37	;;C
	db_c_s	c0,s37	;;D
	db_c_s	c1,s36	;;E
	db_c_s	c3,s36	;;F
	db_c_s	c2,s36	;;G
;-------------------------------------------------------------
LCD_TIME_MINL:	equ	$-lcd_table1	;MINL
LCD1_D4:	equ	$-lcd_table1	;minl
	db_c_s	c3,s39	;;A
	db_c_s	c2,s39	;;B
	db_c_s	c1,s39	;;C
	db_c_s	c0,s39	;;D
	db_c_s	c1,s38	;;E
	db_c_s	c3,s38	;;F
	db_c_s	c2,s38	;;G
;-------------------------------------------------------------
LCD_ALARM_HRH:	equ	$-lcd_table1	;ALARMH
LCD1_D5:	equ	$-lcd_table1	;alarmhrh
	db_c_s	c2,s16	;;ADEG
	db_c_s	c1,s16	;;B
	db_c_s	c3,s16	;;C
	
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	
;-------------------------------------------------------------
LCD_ALARM_HRL:	equ	$-lcd_table1	;ALARMl
LCD1_D6:	equ	$-lcd_table1	;alarmhrl
	db_c_s	c0,s14	;;A
	db_c_s	c1,s14	;;B
	db_c_s	c2,s14	;;C
	db_c_s	c3,s14	;;D
	db_c_s	c3,s15	;;E
	db_c_s	c1,s15	;;F
	db_c_s	c2,s15	;;G
;-------------------------------------------------------------
LCD_ALARM_MINH:	equ	$-lcd_table1	;ALARM
LCD1_D7:	equ	$-lcd_table1	;alarmminh
	db_c_s	c0,s12	;;A
	db_c_s	c1,s12	;;B
	db_c_s	c2,s12	;;C
	db_c_s	c3,s12	;;D
	db_c_s	c3,s13	;;E
	db_c_s	c1,s13	;;F
	db_c_s	c2,s13	;;G
;-------------------------------------------------------------
LCD_ALARM_MINL:	equ	$-lcd_table1	;ALARM
LCD1_D8:	equ	$-lcd_table1	;alarmminl
	db_c_s	c0,s4	;;A
	db_c_s	c1,s4	;;B
	db_c_s	c2,s4	;;C
	db_c_s	c3,s4	;;D
	db_c_s	c3,s5	;;E
	db_c_s	c1,s5	;;F
	db_c_s	c2,s5	;;G
;-------------------------------------------------------------
LCD_TIME_YEAR_20:	equ	$-lcd_table1	;
LCD1_D910:	equ	$-lcd_table1	;20
	db_c_s	c0,s32	;;9ABCDEG10ABCDEF
;-------------------------------------------------------------
LCD_TIME_YEAR_H:	equ	$-lcd_table1	;
LCD1_D11:	equ	$-lcd_table1	;yearh
	db_c_s	c0,s31	;;A
	db_c_s	c1,s31	;;B
	db_c_s	c2,s31	;;C
	db_c_s	c3,s31	;;D
	db_c_s	c3,s32	;;E
	db_c_s	c1,s32	;;F
	db_c_s	c2,s32	;;G
;-------------------------------------------------------------
LCD_TIME_YEAR_L:	equ	$-lcd_table1	;ALARM
LCD1_D12:	equ	$-lcd_table1	;yearl
	db_c_s	c0,s29	;;A
	db_c_s	c1,s29	;;B
	db_c_s	c2,s29	;;C
	db_c_s	c3,s29	;;D
	db_c_s	c3,s30	;;E
	db_c_s	c1,s30	;;F
	db_c_s	c2,s30	;;G
;-------------------------------------------------------------
LCD_TIME_MONTH_H:	equ	$-lcd_table1	;ALARM
LCD1_D13:	equ	$-lcd_table1	;monthh
	db_c_s	c0,s28	;;BC
;-------------------------------------------------------------
LCD_TIME_MONTH_L:	equ	$-lcd_table1
LCD1_D14:	equ	$-lcd_table1	;monthl
	db_c_s	c0,s27	;;A
	db_c_s	c1,s27	;;B
	db_c_s	c2,s27	;;C
	db_c_s	c3,s27	;;D
	db_c_s	c3,s28	;;E
	db_c_s	c1,s28	;;F
	db_c_s	c2,s28	;;G

;-------------------------------------------------------------
LCD_TIME_DAY_H:	equ	$-lcd_table1
LCD1_D15:	equ	$-lcd_table1	;dayh
	db_c_s	c2,s26	;;ADG
	db_c_s	c1,s26	;;B
	db_c_s	c3,s26	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s26	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	
;-------------------------------------------------------------
LCD_TIME_DAY_L:	equ	$-lcd_table1	
LCD1_D16:	equ	$-lcd_table1	;dayl
	db_c_s	c0,s24	;;A
	db_c_s	c1,s24	;;B
	db_c_s	c2,s24	;;C
	db_c_s	c3,s24	;;D
	db_c_s	c3,s25	;;E
	db_c_s	c1,s25	;;F
	db_c_s	c2,s25	;;G

LCD1_D17:	equ	$-lcd_table1	;null-nongmh
	db_c_s	c0,s0	;;BC

LCD1_D18:	equ	$-lcd_table1	;null-nongmh
	db_c_s	c0,s0	;;A
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G

LCD1_D19:	equ	$-lcd_table1	;null-nongdh
	db_c_s	c0,s0	;;ADG
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G		

LCD1_D20:	equ	$-lcd_table1	;null-nongl
	db_c_s	c0,s0	;;A
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G
;-------------------------------------------------------------
LCD_TEMP_HHBC:	equ	$-lcd_table1	
LCD1_D21:	equ	$-lcd_table1
LCD1_D21_BC:	equ	$-lcd_table1	;temphh
	db_c_s	c0,s23	;;BC
LCD1_D21_G:	equ	$-lcd_table1	;null-temp-	
	db_c_s	c0,s0	;;G

;-------------------------------------------------------------
LCD_TEMPH:	equ	$-lcd_table1	
LCD1_D22:	equ	$-lcd_table1	;temph
	db_c_s	c0,s22	;;A
	db_c_s	c1,s22	;;B
	db_c_s	c2,s22	;;C
	db_c_s	c3,s22	;;D
	db_c_s	c3,s23	;;E
	db_c_s	c1,s23	;;F
	db_c_s	c2,s23	;;G
;-------------------------------------------------------------
LCD_TEMPL:	equ	$-lcd_table1
LCD1_D23:	equ	$-lcd_table1	;templ
	db_c_s	c0,s20	;;A
	db_c_s	c1,s20	;;B
	db_c_s	c2,s20	;;C
	db_c_s	c3,s20	;;D
	db_c_s	c3,s21	;;E
	db_c_s	c1,s21	;;F
	db_c_s	c2,s21	;;G
;-------------------------------------------------------------
LCD_TEMP_CF:	equ	$-lcd_table1
LCD1_D24:	equ	$-lcd_table1	;temp-cf
	db_c_s	c0,s25	;;AEF
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C		
DOT_TEMP_C:	equ	$-lcd_table1	;DOT_C
	db_c_s	c0,s19	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F	
DOT_TEMP_F:	equ	$-lcd_table1	;DOT_F	
	db_c_s	c0,s21	;;G
;-------------------------------------------------------------
LCD_TEMPD:	equ	$-lcd_table1
LCD1_D25:	equ	$-lcd_table1	;tempd
	db_c_s	c0,s18	;;A
	db_c_s	c1,s18	;;B
	db_c_s	c2,s18	;;C
	db_c_s	c3,s18	;;D
	db_c_s	c3,s19	;;E
	db_c_s	c1,s19	;;F
	db_c_s	c2,s19	;;G

LCD1_WEEK:	equ	$-lcd_table1	;week
	db_c_s	c3,s41	;;MON
	db_c_s	c2,s41	;;TUE
	db_c_s	c1,s41	;;WED
	db_c_s	c3,s40	;;THU
	db_c_s	c2,s40	;;FRI
	db_c_s	c1,s40	;;SAT
	db_c_s	c0,s40	;;SUN

LCD1_ALARM:	equ	$-lcd_table1
LCD1_ALARM1:	equ	$-lcd_table1	;alarm1
	db_c_s	c3,s17	;;ALA1
LCD1_ALARM2:	equ	$-lcd_table1	;alarm2
	db_c_s	c2,s17	;;ALA2
LCD1_ALARM3:	equ	$-lcd_table1	;alarm3
	db_c_s	c1,s17	;;ALA3
LCD1_ALARM4:	equ	$-lcd_table1	;每天	
	db_c_s	c0,s43	;;ALA4
LCD1_ALARM5:	equ	$-lcd_table1	;单休
	db_c_s	c0,s17	;;ALA5
LCD1_ALARM6:	equ	$-lcd_table1	;双休
	db_c_s	c0,s5	;;ALA6

LCD1_DOT:	equ	$-lcd_table1
LCD1_COL1:	equ	$-lcd_table1	;timecol
	db_c_s	c0,s36	;;COL1
LCD1_COL2:	equ	$-lcd_table1	;alarmcol
	db_c_s	c0,s13	;;COL2
LCD1_COL3:	equ	$-lcd_table1
	db_c_s	c0,s0	;;COL3

LCD1_ICON:	equ	$-lcd_table1
LCD1_AM1:	equ	$-lcd_table1	;hram
	db_c_s	c3,s33	;;AM1
LCD1_PM1:	equ	$-lcd_table1	;hrpm
	db_c_s	c0,s34	;;PM1
LCD1_SNZ:	equ	$-lcd_table1	;zz
	db_c_s	c3,s42	;;SN
LCD1_CHM:	equ	$-lcd_table1	
	db_c_s	c0,s38	;;SK
LCD1_BZ:	equ	$-lcd_table1	;zheng-bz	
	db_c_s	c0,s41	;;BZ
LCD1_PM2:	equ	$-lcd_table1	;alarm-pm
	db_c_s	c0,s15	;;AM2
LCD1_AM2:	equ	$-lcd_table1	;alarm-am
	db_c_s	c0,s16	;;PM2
LCD1_YEAR:	equ	$-lcd_table1	;year	
	db_c_s	c0,s32	;;YEAR
LCD1_GL:	equ	$-lcd_table1	
	db_c_s	c4,s0	;;GL	
LCD1_NL:	equ	$-lcd_table1	;农历
	db_c_s	c0,s30	;;NL
LCD1_DAY1:	equ	$-lcd_table1	
	db_c_s	c0,s0	;;DAY1
LCD1_DAY2:	equ	$-lcd_table1	
	db_c_s	c0,s0	;;DAY2
LCD1_RUN:	equ	$-lcd_table1	;闰
	db_c_s	c2,s42	;;RUN	
DOT_MDTW	equ	$-lcd_table1	;杂
	db_c_s	c0,s25	;;
	
;;lcd1_end_here

lcd_bit:
;LCD1_D1_ADEG:	equ	$-lcd_table1
	db_c_y	c1,s33	;;ADEG
	
	db_c_y	c2,s33	;;B
	
	db_c_y	c0,s33	;;C
	
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	
	
;LCD1_D2:	equ	$-lcd_table1
	db_c_y	c3,s35	;;A
	db_c_y	c2,s35	;;B
	db_c_y	c1,s35	;;C
	db_c_y	c0,s35	;;D
	db_c_y	c1,s34	;;E
	db_c_y	c3,s34	;;F
	db_c_y	c2,s34	;;G

;LCD1_D3:	equ	$-lcd_table1
	db_c_y	c3,s37	;;A
	db_c_y	c2,s37	;;B
	db_c_y	c1,s37	;;C
	db_c_y	c0,s37	;;D
	db_c_y	c1,s36	;;E
	db_c_y	c3,s36	;;F
	db_c_y	c2,s36	;;G

;LCD1_D4:	equ	$-lcd_table1
	db_c_y	c3,s39	;;A
	db_c_y	c2,s39	;;B
	db_c_y	c1,s39	;;C
	db_c_y	c0,s39	;;D
	db_c_y	c1,s38	;;E
	db_c_y	c3,s38	;;F
	db_c_y	c2,s38	;;G

;LCD1_D5:	equ	$-lcd_table1
	db_c_y	c2,s16	;;ADEG
	db_c_y	c1,s16	;;B
	db_c_y	c3,s16	;;C
	
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD1_D6:	equ	$-lcd_table1
	db_c_y	c0,s14	;;A
	db_c_y	c1,s14	;;B
	db_c_y	c2,s14	;;C
	db_c_y	c3,s14	;;D
	db_c_y	c3,s15	;;E
	db_c_y	c1,s15	;;F
	db_c_y	c2,s15	;;G

;LCD1_D7:	equ	$-lcd_table1
	db_c_y	c0,s12	;;A
	db_c_y	c1,s12	;;B
	db_c_y	c2,s12	;;C
	db_c_y	c3,s12	;;D
	db_c_y	c3,s13	;;E
	db_c_y	c1,s13	;;F
	db_c_y	c2,s13	;;G

;LCD1_D8:	equ	$-lcd_table1
	db_c_y	c0,s4	;;A
	db_c_y	c1,s4	;;B
	db_c_y	c2,s4	;;C
	db_c_y	c3,s4	;;D
	db_c_y	c3,s5	;;E
	db_c_y	c1,s5	;;F
	db_c_y	c2,s5	;;G

;LCD1_D910:	equ	$-lcd_table1
	db_c_y	c0,s32	;;9ABCDEG10ABCDEF

;LCD1_D11:	equ	$-lcd_table1
	db_c_y	c0,s31	;;A
	db_c_y	c1,s31	;;B
	db_c_y	c2,s31	;;C
	db_c_y	c3,s31	;;D
	db_c_y	c3,s32	;;E
	db_c_y	c1,s32	;;F
	db_c_y	c2,s32	;;G

;LCD1_D12:	equ	$-lcd_table1
	db_c_y	c0,s29	;;A
	db_c_y	c1,s29	;;B
	db_c_y	c2,s29	;;C
	db_c_y	c3,s29	;;D
	db_c_y	c3,s30	;;E
	db_c_y	c1,s30	;;F
	db_c_y	c2,s30	;;G

;LCD1_D13:	equ	$-lcd_table1
	db_c_y	c0,s28	;;BC

;LCD1_D14:	equ	$-lcd_table1
	db_c_y	c0,s27	;;A
	db_c_y	c1,s27	;;B
	db_c_y	c2,s27	;;C
	db_c_y	c3,s27	;;D
	db_c_y	c3,s28	;;E
	db_c_y	c1,s28	;;F
	db_c_y	c2,s28	;;G

;LCD1_D15:	equ	$-lcd_table1
	db_c_y	c2,s26	;;ADG
	db_c_y	c1,s26	;;B
	db_c_y	c3,s26	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s26	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD1_D16:	equ	$-lcd_table1
	db_c_y	c0,s24	;;A
	db_c_y	c1,s24	;;B
	db_c_y	c2,s24	;;C
	db_c_y	c3,s24	;;D
	db_c_y	c3,s25	;;E
	db_c_y	c1,s25	;;F
	db_c_y	c2,s25	;;G

;LCD1_D17:	equ	$-lcd_table1
	db_c_y	c0,s0	;;BC

;LCD1_D18:	equ	$-lcd_table1
	db_c_y	c0,s0	;;A
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G

;LCD1_D19:	equ	$-lcd_table1
	db_c_y	c0,s0	;;ADG
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G		

;LCD1_D20:	equ	$-lcd_table1
	db_c_y	c0,s0	;;A
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G

;LCD1_D21:	equ	$-lcd_table1
;LCD1_D21_BC:	equ	$-lcd_table1
	db_c_y	c0,s23	;;BC
;LCD1_D21_G:	equ	$-lcd_table1	
	db_c_y	c0,s0	;;G

;LCD1_D22:	equ	$-lcd_table1
	db_c_y	c0,s22	;;A
	db_c_y	c1,s22	;;B
	db_c_y	c2,s22	;;C
	db_c_y	c3,s22	;;D
	db_c_y	c3,s23	;;E
	db_c_y	c1,s23	;;F
	db_c_y	c2,s23	;;G

;LCD1_D23:	equ	$-lcd_table1
	db_c_y	c0,s20	;;A
	db_c_y	c1,s20	;;B
	db_c_y	c2,s20	;;C
	db_c_y	c3,s20	;;D
	db_c_y	c3,s21	;;E
	db_c_y	c1,s21	;;F
	db_c_y	c2,s21	;;G

;LCD1_D24:	equ	$-lcd_table1
	db_c_y	c0,s25	;;AEF
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C		
	db_c_y	c0,s19	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F		
	db_c_y	c0,s21	;;G

;LCD1_D25:	equ	$-lcd_table1
	db_c_y	c0,s18	;;A
	db_c_y	c1,s18	;;B
	db_c_y	c2,s18	;;C
	db_c_y	c3,s18	;;D
	db_c_y	c3,s19	;;E
	db_c_y	c1,s19	;;F
	db_c_y	c2,s19	;;G

;LCD1_WEEK:	equ	$-lcd_table1
	db_c_y	c3,s41	;;MON
	db_c_y	c2,s41	;;TUE
	db_c_y	c1,s41	;;WED
	db_c_y	c3,s40	;;THU
	db_c_y	c2,s40	;;FRI
	db_c_y	c1,s40	;;SAT
	db_c_y	c0,s40	;;SUN

;LCD_ALARM:	equ	$-lcd_table1
	db_c_y	c3,s17	;;ALA1
	db_c_y	c2,s17	;;ALA2
	db_c_y	c1,s17	;;ALA3
	db_c_y	c0,s43	;;ALA4
	db_c_y	c0,s17	;;ALA5
	db_c_y	c0,s5	;;ALA6

;LCD_DOT:	equ	$-lcd_table1
	db_c_y	c0,s36	;;COL1
	db_c_y	c0,s13	;;COL2
	db_c_y	c0,s0	;;COL3

;LCD_ICON:	equ	$-lcd_table1
	db_c_y	c3,s33	;;AM1
	db_c_y	c0,s34	;;PM1
	db_c_y	c3,s42	;;SN
	db_c_y	c0,s38	;;SK
	db_c_y	c0,s41	;;BZ
	db_c_y	c0,s15	;;AM2
	db_c_y	c0,s16	;;PM2
	db_c_y	c0,s0	;;YEAR
	db_c_y	c4,s0	;;GL
	db_c_y	c0,s30	;;NL
	db_c_y	c0,s0	;;DAY1
	db_c_y	c0,s0	;;DAY2
	db_c_y	c2,s42	;;RUN	
	db_c_y	c0,s25	;;RUN	
;;lcd1_end_here
;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD2_table1:
Lcd2_byte
LCD2_TIME_HRH:	equ	$-LCD2_table1	;HRH
LCD2_D1:	equ	$-LCD2_table1
	db_c_s	c1,s34	;;ADEG
	db_c_s	c2,s34	;;B
	db_c_s	c0,s34	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	
LCD2_TIME_HRL:	equ	$-LCD2_table1	;HRL
LCD2_D2:	equ	$-LCD2_table1
	db_c_s	c3,s36	;;A
	db_c_s	c2,s36	;;B
	db_c_s	c1,s36	;;C
	db_c_s	c0,s36	;;D
	db_c_s	c1,s35	;;E
	db_c_s	c3,s35	;;F
	db_c_s	c2,s35	;;G
LCD2_TIME_MINH:	equ	$-LCD2_table1	;MINH
LCD2_D3:	equ	$-LCD2_table1
	db_c_s	c3,s38	;;A
	db_c_s	c2,s38	;;B
	db_c_s	c1,s38	;;C
	db_c_s	c0,s38	;;D
	db_c_s	c1,s37	;;E
	db_c_s	c3,s37	;;F
	db_c_s	c2,s37	;;G
LCD2_TIME_MINL:	equ	$-LCD2_table1	;MINL
LCD2_D4:	equ	$-LCD2_table1
	db_c_s	c3,s40	;;A
	db_c_s	c2,s40	;;B
	db_c_s	c1,s40	;;C
	db_c_s	c0,s40	;;D
	db_c_s	c1,s39	;;E
	db_c_s	c3,s39	;;F
	db_c_s	c2,s39	;;G
LCD2_ALARM_HRH:	equ	$-LCD2_table1	;ALARMHH
LCD2_D5:	equ	$-LCD2_table1
	db_c_s	c2,s16	;;ADEG
	db_c_s	c1,s16	;;B
	db_c_s	c3,s16	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G	
LCD2_ALARM_HRL:	equ	$-LCD2_table1	;ALARMHL
LCD2_D6:	equ	$-LCD2_table1
	db_c_s	c0,s14	;;A
	db_c_s	c1,s14	;;B
	db_c_s	c2,s14	;;C
	db_c_s	c3,s14	;;D
	db_c_s	c3,s15	;;E
	db_c_s	c1,s15	;;F
	db_c_s	c2,s15	;;G
LCD2_ALARM_MINH:	equ	$-LCD2_table1	;ALARM_MINH
LCD2_D7:	equ	$-LCD2_table1
	db_c_s	c0,s12	;;A
	db_c_s	c1,s12	;;B
	db_c_s	c2,s12	;;C
	db_c_s	c3,s12	;;D
	db_c_s	c3,s13	;;E
	db_c_s	c1,s13	;;F
	db_c_s	c2,s13	;;G
LCD2_ALARM_MINL:	equ	$-LCD2_table1	;ALARM_MINH
LCD2_D8:	equ	$-LCD2_table1
	db_c_s	c0,s4	;;A
	db_c_s	c1,s4	;;B
	db_c_s	c2,s4	;;C
	db_c_s	c3,s4	;;D
	db_c_s	c3,s5	;;E
	db_c_s	c1,s5	;;F
	db_c_s	c2,s5	;;G

LCD2_D910:	equ	$-LCD2_table1
	db_c_s	c0,s0	;;9ABCDEG10ABCDEF
LCD2_TIME_YEAR_H:	equ	$-lcd_table1	;
LCD2_D11:	equ	$-LCD2_table1
	db_c_s	c0,s0	;;A
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G
LCD2_TIME_YEAR_L:	equ	$-lcd_table1	;
LCD2_D12:	equ	$-LCD2_table1
	db_c_s	c0,s0	;;A
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C
	db_c_s	c0,s0	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G

LCD2_TIME_MONTH_H:	equ	$-LCD2_table1	;MONTHH
LCD2_D13:	equ	$-LCD2_table1
	db_c_s	c0,s33	;;BC


LCD2_TIME_MONTH_L:	equ	$-LCD2_table1	;MONTHL
LCD2_D14:	equ	$-LCD2_table1
	db_c_s	c0,s32	;;A
	db_c_s	c1,s32	;;B
	db_c_s	c2,s32	;;C
	db_c_s	c3,s32	;;D
	db_c_s	c3,s33	;;E
	db_c_s	c1,s33	;;F
	db_c_s	c2,s33	;;G

LCD2_TIME_DAY_H:	equ	$-LCD2_table1		;DAYH
LCD2_D15:	equ	$-LCD2_table1
	db_c_s	c2,s31	;;ADG
	db_c_s	c1,s31	;;B
	db_c_s	c3,s31	;;C
	db_c_s	c0,s0	;;D	
	db_c_s	c0,s31	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G		
LCD2_TIME_DAY_L:	equ	$-LCD2_table1		;DAYL
LCD2_D16:	equ	$-LCD2_table1
	db_c_s	c0,s29	;;A
	db_c_s	c1,s29	;;B
	db_c_s	c2,s29	;;C
	db_c_s	c3,s29	;;D
	db_c_s	c3,s30	;;E
	db_c_s	c1,s30	;;F
	db_c_s	c2,s30	;;G

LCD2_TEMP_HHBC:	equ	$-LCD2_table1	;TEMPHH
LCD2_D21:	equ	$-LCD2_table1
LCD2_D21_BC:	equ	$-LCD2_table1
	db_c_s	c0,s23	;;BC
LCD2_D21_G:	equ	$-LCD2_table1
	db_c_s	c0,s0	;;G

LCD2_TEMPH:	equ	$-LCD2_table1		;TEMPH
LCD2_D22:	equ	$-LCD2_table1
	db_c_s	c0,s22	;;A
	db_c_s	c1,s22	;;B
	db_c_s	c2,s22	;;C
	db_c_s	c3,s22	;;D
	db_c_s	c3,s23	;;E
	db_c_s	c1,s23	;;F
	db_c_s	c2,s23	;;G

LCD2_TEMPL:	equ	$-LCD2_table1	;TEMPL
;LCD2_D19:	equ	$-LCD2_table1
LCD2_D23:	equ	$-LCD2_table1
	db_c_s	c0,s20	;;A
	db_c_s	c1,s20	;;B
	db_c_s	c2,s20	;;C
	db_c_s	c3,s20	;;D
	db_c_s	c3,s21	;;E
	db_c_s	c1,s21	;;F
	db_c_s	c2,s21	;;G

LCD2_TEMP_CF:	equ	$-LCD2_table1
;LCD2_D20:	equ	$-LCD2_table1
LCD2_D24:	equ	$-LCD2_table1
	db_c_s	c0,s25	;;AEF
	db_c_s	c0,s0	;;B
	db_c_s	c0,s0	;;C	
DOT2_TEMP_C:	equ	$-LCD2_table1	;DOT_C
	db_c_s	c0,s21	;;D
	db_c_s	c0,s0	;;E
	db_c_s	c0,s0	;;F		
DOT2_TEMP_F:	equ	$-LCD2_table1	;DOT_F
	db_c_s	c0,s19	;;G


LCD2_TEMPD:	equ	$-LCD2_table1	;TEMPD
;LCD2_D21:	equ	$-LCD2_table1
LCD2_D25:	equ	$-LCD2_table1
	db_c_s	c0,s18	;;A
	db_c_s	c1,s18	;;B
	db_c_s	c2,s18	;;C
	db_c_s	c3,s18	;;D
	db_c_s	c3,s19	;;E
	db_c_s	c1,s19	;;F
	db_c_s	c2,s19	;;G


LCD2_TIME_NMONTH_H:	equ	$-LCD2_table1	;MONTHH
LCD2_D26:	equ	$-LCD2_table1
	db_c_s	c0,s28	;;BC

LCD2_TIME_NMONTH_L:	equ	$-LCD2_table1	;MONTHL
LCD2_D27:	equ	$-LCD2_table1
	db_c_s	c0,s27	;;A
	db_c_s	c1,s27	;;B
	db_c_s	c2,s27	;;C
	db_c_s	c3,s27	;;D
	db_c_s	c3,s28	;;E
	db_c_s	c1,s28	;;F
	db_c_s	c2,s28	;;G

LCD2_TIME_NDAY_H:	equ	$-LCD2_table1	;DAYH
LCD2_D28:	equ	$-LCD2_table1
	db_c_s	c2,s26	;;ADG
	db_c_s	c1,s26	;;B
	db_c_s	c3,s26	;;C
	db_c_s	c0,s0	;;D	
	db_c_s	c0,s26	;;E
	db_c_s	c0,s0	;;F
	db_c_s	c0,s0	;;G		
LCD2_TIME_NDAY_L:	equ	$-LCD2_table1	;DAYL
LCD2_D29:	equ	$-LCD2_table1
	db_c_s	c0,s24	;;A
	db_c_s	c1,s24	;;B
	db_c_s	c2,s24	;;C
	db_c_s	c3,s24	;;D
	db_c_s	c3,s25	;;E
	db_c_s	c1,s25	;;F
	db_c_s	c2,s25	;;G


LCD2_WEEK:	equ	$-LCD2_table1	;week
	db_c_s	c3,s42	;;MON
	db_c_s	c2,s42	;;TUE
	db_c_s	c1,s42	;;WED
	db_c_s	c3,s41	;;THU
	db_c_s	c2,s41	;;FRI
	db_c_s	c1,s41	;;SAT
	db_c_s	c0,s41	;;SUN

LCD2_ALARM:	equ	$-LCD2_table1
LCD2_ALARM1:	equ	$-LCD2_table1
	db_c_s	c3,s17	;;ALA1
LCD2_ALARM2:	equ	$-LCD2_table1
	db_c_s	c2,s17	;;ALA2
LCD2_ALARM3:	equ	$-LCD2_table1
	db_c_s	c1,s17	;;ALA3
LCD2_ALARM4:	equ	$-LCD2_table1
	db_c_s	c0,s43	;;每天
LCD2_ALARM5:	equ	$-LCD2_table1
	db_c_s	c0,s5	;;单休
LCD2_ALARM6:	equ	$-LCD2_table1
	db_c_s	c0,s17	;;双休

LCD2_DOT:	equ	$-LCD2_table1
LCD2_COL1:	equ	$-LCD2_table1
	db_c_s	c0,s37	;;COL1
LCD2_COL2:	equ	$-LCD2_table1
	db_c_s	c0,s13	;;COL2
; LCD2_COL3:	equ	$-LCD2_table1
; 	db_c_s	c4,s38	;;COL3

; LCD2_ICON:	equ	$-LCD2_table1
LCD2_AM1:	equ	$-LCD2_table1
	db_c_s	c3,s34	;;TIME_AM1
LCD2_PM1:	equ	$-LCD2_table1
	db_c_s	c0,s35	;;TIME_PM1
LCD2_SNZ:	equ	$-LCD2_table1
	db_c_s	c3,s43	;;ZZ
LCD2_CHM:	equ	$-LCD2_table1
	db_c_s	c0,s39	;;SK
LCD2_BZ:	equ	$-LCD2_table1
	db_c_s	c0,s42	;;BZ
LCD2_AM2:	equ	$-LCD2_table1
	db_c_s	c0,s16	;;ALARM_AM2
LCD2_PM2:	equ	$-LCD2_table1
	db_c_s	c0,s15	;;ALARM_PM2
LCD2_GL:	equ	$-LCD2_table1
	db_c_s	c1,s43	;;GL
LCD2_MD:	equ	$-LCD2_table1
	db_c_s	c0,s30	;;MD	
LCD2_RUN:	equ	$-LCD2_table1
	db_c_s	c2,s43	;;RUN	
; ;;LCD2_end_here
; ;;;;;;;;;;;;;;;
Lcd2_bit:
;LCD2_D1:	equ	$-LCD2_table1
	db_c_y	c1,s34	;;ADEG
	db_c_y	c2,s34	;;B
	db_c_y	c0,s34	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD2_D2:	equ	$-LCD2_table1
	db_c_y	c3,s36	;;A
	db_c_y	c2,s36	;;B
	db_c_y	c1,s36	;;C
	db_c_y	c0,s36	;;D
	db_c_y	c1,s35	;;E
	db_c_y	c3,s35	;;F
	db_c_y	c2,s35	;;G

;LCD2_D3:	equ	$-LCD2_table1
	db_c_y	c3,s38	;;A
	db_c_y	c2,s38	;;B
	db_c_y	c1,s38	;;C
	db_c_y	c0,s38	;;D
	db_c_y	c1,s37	;;E
	db_c_y	c3,s37	;;F
	db_c_y	c2,s37	;;G

;LCD2_D4:	equ	$-LCD2_table1
	db_c_y	c3,s40	;;A
	db_c_y	c2,s40	;;B
	db_c_y	c1,s40	;;C
	db_c_y	c0,s40	;;D
	db_c_y	c1,s39	;;E
	db_c_y	c3,s39	;;F
	db_c_y	c2,s39	;;G

;LCD2_D5:	equ	$-LCD2_table1
	db_c_y	c2,s16	;;ADEG
	db_c_y	c1,s16	;;B
	db_c_y	c3,s16	;;C
	db_c_y	c0,s0	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G	

;LCD2_D6:	equ	$-LCD2_table1
	db_c_y	c0,s14	;;A
	db_c_y	c1,s14	;;B
	db_c_y	c2,s14	;;C
	db_c_y	c3,s14	;;D
	db_c_y	c3,s15	;;E
	db_c_y	c1,s15	;;F
	db_c_y	c2,s15	;;G

;LCD2_D7:	equ	$-LCD2_table1
	db_c_y	c0,s12	;;A
	db_c_y	c1,s12	;;B
	db_c_y	c2,s12	;;C
	db_c_y	c3,s12	;;D
	db_c_y	c3,s13	;;E
	db_c_y	c1,s13	;;F
	db_c_y	c2,s13	;;G

;LCD2_D8:	equ	$-LCD2_table1
	db_c_y	c0,s4	;;A
	db_c_y	c1,s4	;;B
	db_c_y	c2,s4	;;C
	db_c_y	c3,s4	;;D
	db_c_y	c3,s5	;;E
	db_c_y	c1,s5	;;F
	db_c_y	c2,s5	;;G

;LCD2_D910:	equ	$-LCD2_table1
	db_c_y	c0,s0	;;9ABCDEG10ABCDEF

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
	db_c_y	c0,s33	;;BC

;LCD2_D14:	equ	$-LCD2_table1
	db_c_y	c0,s32	;;A
	db_c_y	c1,s32	;;B
	db_c_y	c2,s32	;;C
	db_c_y	c3,s32	;;D
	db_c_y	c3,s33	;;E
	db_c_y	c1,s33	;;F
	db_c_y	c2,s33	;;G

;LCD2_D15:	equ	$-LCD2_table1
	db_c_y	c2,s31	;;ADG
	db_c_y	c1,s31	;;B
	db_c_y	c3,s31	;;C
	db_c_y	c0,s0	;;D	
	db_c_y	c0,s31	;;E
	db_c_y	c0,s0	;;F
	db_c_y	c0,s0	;;G		

;LCD2_D16:	equ	$-LCD2_table1
	db_c_y	c0,s29	;;A
	db_c_y	c1,s29	;;B
	db_c_y	c2,s29	;;C
	db_c_y	c3,s29	;;D
	db_c_y	c3,s30	;;E
	db_c_y	c1,s30	;;F
	db_c_y	c2,s30	;;G

;LCD2_D17:	equ	$-LCD2_table1
;LCD2_D21:	equ	$-LCD2_table1
	db_c_s	c0,s23	;;BC
	db_c_y	c0,s0	;;G

;LCD2_D22:	equ	$-LCD2_table1
	db_c_y	c0,s22	;;A
	db_c_y	c1,s22	;;B
	db_c_y	c2,s22	;;C
	db_c_y	c3,s22	;;D
	db_c_y	c3,s23	;;E
	db_c_y	c1,s23	;;F
	db_c_y	c2,s23	;;G

;LCD2_D23:	equ	$-LCD2_table1
	db_c_y	c0,s20	;;A
	db_c_y	c1,s20	;;B
	db_c_y	c2,s20	;;C
	db_c_y	c3,s20	;;D
	db_c_y	c3,s21	;;E
	db_c_y	c1,s21	;;F
	db_c_y	c2,s21	;;G

;LCD2_D24:	equ	$-LCD2_table1
	db_c_y	c0,s25	;;AEF
	db_c_y	c0,s0	;;B
	db_c_y	c0,s0	;;C	
	db_c_y	c0,s21	;;D
	db_c_y	c0,s0	;;E
	db_c_y	c0,s0	;;F		
	db_c_y	c0,s19	;;G

;LCD2_D25:	equ	$-LCD2_table1
	db_c_y	c0,s18	;;
	db_c_y	c1,s18	;;
	db_c_y	c2,s18	;;
	db_c_y	c3,s18	;;
	db_c_y	c3,s19	;;
	db_c_y	c1,s19	;;
	db_c_y	c2,s19	;;

;LCD2_D26:	equ	$-LCD2_table1
	db_c_y	c0,s28	;;BC


;LCD2_D27:	equ	$-LCD2_table1
	db_c_y	c0,s27	;;
	db_c_y	c1,s27	;;
	db_c_y	c2,s27	;;
	db_c_y	c3,s27	;;
	db_c_y	c3,s28	;;
	db_c_y	c1,s28	;;
	db_c_y	c2,s28	;;
;LCD2_D28:	equ	$-LCD2_table1
	db_c_y	c2,s26	;;
	db_c_y	c1,s26	;;
	db_c_y	c3,s26	;;
	db_c_y	c0,s0	;;
	db_c_y	c0,s26	;;
	db_c_y	c0,s0	;;
	db_c_y	c0,s0	;;
;LCD2_D29:	equ	$-LCD2_table1
	db_c_y	c0,s24	;;
	db_c_y	c1,s24	;;
	db_c_y	c2,s24	;;
	db_c_y	c3,s24	;;
	db_c_y	c3,s25	;;
	db_c_y	c1,s25	;;
	db_c_y	c2,s25	;;
; LCD1_WEEK:	equ	$-lcd_table1	;week
	db_c_y	c3,s42	;;MON
	db_c_y	c2,s42	;;TUE
	db_c_y	c1,s42	;;WED
	db_c_y	c3,s41	;;THU
	db_c_y	c2,s41	;;FRI
	db_c_y	c1,s41	;;SAT
	db_c_y	c0,s41	;;SUN


	db_c_y	c3,s17	;;ALA1
	db_c_y	c2,s17	;;ALA2
	db_c_y	c1,s17	;;ALA3
	db_c_y	c0,s43	;;每天
	db_c_y	c0,s5	;;单休
	db_c_y	c0,s17	;;双休
	db_c_y	c0,s37	;;COL1
	db_c_y	c0,s13	;;COL2

; 	db_c_s	c4,s38	;;COL3

	db_c_y	c3,s34	;;TIME_AM1
	db_c_y	c0,s35	;;TIME_PM1
	db_c_y	c3,s43	;;ZZ
	db_c_y	c0,s39	;;SK
	db_c_y	c0,s42	;;BZ
	db_c_y	c0,s16	;;ALARM_AM2
	db_c_y	c0,s15	;;ALARM_PM2
	db_c_y	c1,s43	;;GL
	db_c_y	c0,s30	;;MD	
	db_c_y	c2,s43	;;RUN	
; ;;LCD2_end_here



