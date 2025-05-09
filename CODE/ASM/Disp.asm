; 253 Byte
;----------------------------------------------------------
R_LcdDisplayBuffer:		equ	$1800
D_LcdRam		equ		6*6
;C_MiDigit	equ		0
;----------------------------------------------------------
T_LcdFontTab:
D8Z_0:	EQU	$-T_LcdFontTab
         db    $3f  ;  0   0  1   1  1   1   1  1    as 0    0
         db    $06  ;  0   0  0   0  0   1   1  0    as 1    1
         db    $5b  ;  0   1  0   1  1   0   1  1    as 2    2
         db    $4f  ;  0   1  0   0  1   1   1  1    as 3    3
         db    $66  ;  0   1  1   0  0   1   1  0    as 4    4
         db    $6d  ;  0   1  1   0  1   1   0  1    as 5    5
         db    $7d  ;  0   1  1   1  1   1   0  1    as 6    6
         db    $07  ;  0   0  0   0  0   1   1  1    as 7    7 ;$27(ע���7Ϊ����)
         db    $7f  ;  0   1  1   1  1   1   1  1    as 8    8
         db    $6f  ;  0   1  1   0  1   1   1  1    as 9    9
D8Z_CLR:	EQU	$-T_LcdFontTab
         db    $00                 ;       ��                         as , , 10
D8Z_g:	EQU	$-T_LcdFontTab
         db    $40  ;  0   1  0   0  0   0   0  0    as ,-, B		 
D8Z_H:	EQU	$-T_LcdFontTab
         db    $76  ;  0   1  1   1  0   1   1  0    as ,H, C
D8Z_i:	EQU	$-T_LcdFontTab
		 db    $10  ;  0   0  1   1  1   0   0  0    as ,i, D
D8Z_L:	EQU	$-T_LcdFontTab
		 db    $38  ;  0   0  1   1  1   0   0  0    as ,L, E
D8Z_o:	EQU	$-T_LcdFontTab
		 db    $5C  ;  0   0  1   1  1   0   0  0    as ,o, F			 
D8Z_N:	EQU	$-T_LcdFontTab
         db    $37  ;  0   1  0   1  0   0   0  1    as ,r, 12
; D8Z_r:	EQU	$-T_LcdFontTab
;          db    $50  ;  0   1  0   1  0   0   0  0    as ,r, 12
D8Z_C:	EQU	$-T_LcdFontTab
         db    $39  ;  0   0  1   1  1   0   0  1    as ,C, 13
D8Z_F:	EQU	$-T_LcdFontTab
		 db    $71  ;  0   1  1   1  0   0   0  1    as ,F, 15		 
;D8Z_i:	EQU	$-T_LcdFontTab
;		 db    $10  ;  0   0  1   1  1   0   0  0    as ,F, 16		 
;----------------------------------------------------------
;--------------------------------------------------------------------------
; subroutine: turn_on_segment
; function  : turn one segment on
; input     : lcd_tmp_mask = which byte
;             lcd_tmp_bit = which bit in current byte  ( e.g. bit 2 -- 00000100 )
; return    : none
;-------------------------------------------------------------------------
turn_on_segment:
                ldx     lcd_tmp_mask
                lda     R_LcdDisplayBuffer,x       ;turn on the segment
                ora     lcd_tmp_bit
                sta     R_LcdDisplayBuffer,x
                rts
;---------------------------------------------------------------------------
; subroutine: turn_off_segment
; function  : turn one segment off
; input     : lcd_tmp_mask = which byte
;             lcd_tmp_bit = which bit in current byte  ( e.g. bit 2 -- 00000100 )
; return    : none
;-------------------------------------------------------------------------
turn_off_segment:
                ldx     lcd_tmp_mask
                lda     R_LcdDisplayBuffer,x
                ora     lcd_tmp_bit
                eor     lcd_tmp_bit
                sta     R_LcdDisplayBuffer,x
                rts
;-------------------------------------------------------------------------
L_ClrAllLcd:
L_Clr_All_DisRam_Prog:
F_ClearScreen:
		lda	#0
L_LcdScreen:	
		ldx	#0
?L_ClearLoop:
		sta	R_LcdDisplayBuffer,x
		inx
		cpx	#(D_LcdRam+1)
		bcc	?L_ClearLoop
		rts
;-------------------------------------------------------------------------
L_Dis_All_DisRam_Prog:
L_DisAllLcd:
F_FullScreen:
		lda	#$FF
		jmp	L_LcdScreen
;-------------------------------------------------------------------------
L_Dis_8Bit_DigitDot_Prog:
F_DispChar:		;Xcc -> ofs, Acc -> data(��������ʾ����)
F_DispDigit:
		stx	R_Tmp1
		tax
		lda	T_LcdFontTab,x
		ldx	R_Tmp1
F_DispPro:		;Xcc -> ofs, Acc -> data(ֱ�Ӹ�����ʾ����)
		sta	R_Tmp0
		stx	R_Tmp1
		lda	#7
		sta	R_Tmp2
?L_DispLoop:
		ldx	R_Tmp1
		jsr	F_GetComSeg	
		ror	R_Tmp0
		bcs	?L_DispIt
?L_ClearIt:
		jsr	turn_off_segment
		jmp	?L_Next
?L_DispIt:
		jsr	turn_on_segment
?L_Next:
		inc	R_Tmp1
		dec	R_Tmp2
		bne	?L_DispLoop
		rts
		
F_GetComSeg:
		; BBS0	Sys_Flag_D,?LCD2
		xJB	Flag_NongLi,Bit_NongLi,?LCD2
		xJB Flag_3sDAlarm,Bit_3sDAlarm,?LCD3
		lda	lcd_byte,x
		sta	lcd_tmp_mask
		lda	lcd_bit,x
		sta	lcd_tmp_bit
		rts	
?LCD2:
		lda	Lcd2_byte,x
		sta	lcd_tmp_mask
		lda	Lcd2_bit,x
		sta	lcd_tmp_bit
		rts		
?LCD3:
		lda	Lcd3_byte,x
		sta	lcd_tmp_mask
		lda	Lcd3_bit,x
		sta	lcd_tmp_bit
		rts	
;-------------------------------------------------------------------------
F_DispSymbol:		;input Xcc -> ofs
		jsr	F_GetComSeg	
		jmp	turn_on_segment
;-------------------------------------------------------------------------
F_ClrpSymbol:		;input Xcc -> ofs
		jsr	F_GetComSeg
		jmp	turn_off_segment
;-------------------------------------------------------------------------
;.if	C_MiDigit
L_Dis_16Bit_DigitDot_Prog:
F_DispMiZiChar:		;Xcc -> ofs, Acc -> data�����������ֹ���ʾ���ݣ�
		stx	R_Tmp2
		tax
		lda	T_LcdMiZiFontTab1,x
		sta	R_Tmp0	;��8��
		lda	T_LcdMiZiFontTab2,x
		sta	R_Tmp1	;��6��
		lda	#14		;14��
		sta	R_Tmp3
?L_DispLoop:
		ldx	R_Tmp2
		jsr	F_GetComSeg
		ror	R_Tmp1
		ror	R_Tmp0
		bcs	?L_DispIt
?L_ClearIt:
		jsr	turn_off_segment
		jmp	?L_Next
?L_DispIt:
		jsr	turn_on_segment
?L_Next:
		inc	R_Tmp2
		dec	R_Tmp3
		bne	?L_DispLoop
		rts

T_LcdMiZiFontTab1:
				;  g2  g1 f   e  d   c   b  a
    db    $3F   ;  0   0  1   1  1   1   1  1    as 0    0
    db    $06   ;  0   0  0   0  0   1   1  0    as 1    1
    db    $DB   ;  1   1  0   1  1   0   1  1    as 2    2
    db    $CF   ;  1   1  0   0  1   1   1  1    as 3    3
    db    $E6   ;  1   1  1   0  0   1   1  0    as 4    4
    db    $ED   ;  1   1  1   0  1   1   0  1    as 5    5
    db    $FD   ;  1   1  1   1  1   1   0  1    as 6    6
    db    $07   ;  0   0  0   0  0   1   1  1    as 7    7 ;$27(ע���7Ϊ����)
    db    $FF   ;  1   1  1   1  1   1   1  1    as 8    8
    db    $EF   ;  1   1  1   0  1   1   1  1    as 9    9
MZ_CLR: EQU $-T_LcdMiZiFontTab1
    db    $00   ;
MZ_E: EQU $-T_LcdMiZiFontTab1	
    db    $F9   ;  1   1  1   1  1   0   0  1    as E    11
MZ_N: EQU $-T_LcdMiZiFontTab1
    db    $36   ;  0   0  1   1  0   1   1  0    as N    12
MZ_G: EQU $-T_LcdMiZiFontTab1
    db    $BD   ;  1   0  1   1  1   1   0  1    as G    13
MZ_M: EQU $-T_LcdMiZiFontTab1
    db    $36   ;  0   0  1   1  0   1   1  0    as M    14
MZ_O: EQU $-T_LcdMiZiFontTab1
    db    $3F   ;  0   0  1   1  1   1   1  1    as O    15
MZ_T: EQU $-T_LcdMiZiFontTab1
    db    $01   ;  0   0  0   0  0   0   0  1    as T    16
MZ_U: EQU $-T_LcdMiZiFontTab1
    db    $3E   ;  0   0  1   1  1   1   1  0    as U    17
MZ_W: EQU $-T_LcdMiZiFontTab1
    db    $36   ;  0   0  1   1  0   1   1  0    as W    18
MZ_D: EQU $-T_LcdMiZiFontTab1
    db    $0F   ;  0   0  0   0  1   1   1  1    as D    19
MZ_H: EQU $-T_LcdMiZiFontTab1
    db    $F6   ;  1   1  1   1  0   1   1  0    as H    20
MZ_F: EQU $-T_LcdMiZiFontTab1
    db    $F1   ;  1   1  1   1  0   0   0  1    as F    21
MZ_R: EQU $-T_LcdMiZiFontTab1
    db    $F3   ;  1   1  1   1  0   0   1  1    as R    22
MZ_I: EQU $-T_LcdMiZiFontTab1
    db    $09   ;  0   0  0   0  1   0   0  1    as I    23
MZ_S: EQU $-T_LcdMiZiFontTab1
    db    $ED   ;  1   1  1   0  1   1   0  1    as S    24
MZ_A: EQU $-T_LcdMiZiFontTab1
    db    $F7   ;  1   1  1   1  0   1   1  1    as A    25
MZ_L: EQU $-T_LcdMiZiFontTab1
    db    $38   ;  0   0  1   1  1   0   0  0    as L    26
MZ_J: EQU $-T_LcdMiZiFontTab1
    db    $0E   ;  0   0  0   0  1   1   1  0    as J    27
MZ_V: EQU $-T_LcdMiZiFontTab1
    db    $30   ;  0   0  1   1  0   0   0  0    as V    28
MZ_B: EQU $-T_LcdMiZiFontTab1
    db    $8F   ;  1   0  0   0  1   1   1  1    as B    29
MZ_Z: EQU $-T_LcdMiZiFontTab1
    db    $09   ;  0   0  0   0  1   0   0  1    as Z    30
MZ_P: EQU $-T_LcdMiZiFontTab1
    db    $F3   ;  1   1  1   1  0   0   1  1    as P    31
    db    $F3   ;  1   1  1   1  0   0   1  1    as P    32	

T_LcdMiZiFontTab2:
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	
	db    $00	;  0   0  m   l  k   j   i  h
    db    $00   ;  0   0  0   0  0   0   0  0    as E    11
    db    $12   ;  0   0  0   1  0   0   1  0    as N    12
    db    $00   ;  0   0  0   0  0   0   0  0    as G    13
    db    $22   ;  0   0  1   0  0   0   1  0    as M    14
    db    $00   ;  0   0  0   0  0   0   0  0    as O    15
    db    $09   ;  0   0  0   0  1   0   0  1    as T    16
    db    $00   ;  0   0  0   0  0   0   0  0    as U    17
    db    $14   ;  0   0  0   1  0   1   0  0    as W    18
    db    $09   ;  0   0  0   0  1   0   0  1    as D    19
    db    $00   ;  0   0  0   0  0   0   0  0    as H    20
    db    $00   ;  0   0  0   0  0   0   0  0    as F    21
    db    $10   ;  0   0  0   1  0   0   0  0    as R    22
    db    $09   ;  0   0  0   0  1   0   0  1    as I    23
    db    $00   ;  0   0  0   0  0   0   0  0    as S    24
    db    $00   ;  0   0  0   0  0   0   0  0    as A    25
    db    $00   ;  0   0  0   0  0   0   0  0    as L    26
    db    $00   ;  0   0  0   0  0   0   0  0    as J    27
    db    $24   ;  0   0  1   0  0   1   0  0    as V    28
    db    $09   ;  0   0  0   0  1   0   0  1    as B    29
    db    $24   ;  0   0  1   0  0   1   0  0    as Z    30
    db    $00   ;  0   0  0   0  0   0   0  0    as P    31
    db    $00   ;  0   0  0   0  0   0   0  0    as P    32
;.else	
;---------------------------------------------
L_ROR4Bit_Prog:
L_LSR4Bit_Prog:
	CLC
	ROR	A
	ROR	A		
	ROR	A
	ROR	A
	AND	#$0F	
	RTS
;---------------------------------------------
F_Div10:
	LDX		#$ff
	SEC
?div_10_loop:
	SBC		#10
	INX
	BCS		?div_10_loop
	ADC		#10
	RTS
;---------------------------------------------
