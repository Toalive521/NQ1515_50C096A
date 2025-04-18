;=====================================================================================
;		Miscellaneous Function For 50C096A
;  135 Byte
;=====================================================================================
D_4MD2Div32:	.equ	4000000/2/32/1024;4400000/2/32/1024
D_8MD2Div32:	.equ	8000000/2/32/1024

D_PlayFreq:	.equ	4000000/32/1024 ;4400000/32/1024
;=====================================================================================
MCLK_CALIB:
		TMR0_OFF
		rmb0	IFR
?L_WaitLoop:
		bbr0	IFR,?L_WaitLoop
		rmb0	IFR
?L_WaitLoop1:
		bbr0	IFR,?L_WaitLoop1
		rmb0	IFR
		lda	#0
		sta	TMR0H
		TMR0_ON
?L_WaitLoop2:
		bbr0	IFR,?L_WaitLoop2
		rmb0	IFR
		nop
		nop
		TMR0_OFF
?L_WaitLoop3:
		bbr0	IFR,?L_WaitLoop3
		rmb0	IFR
		nop
		nop
		lda	TMR0H
		rts
;=====================================================================================
MCLK_DATA:
	db	00H,10H,20H,30H,40H,50H,60H,70H
	db	80H,90H,A0H,B0H,C0H,D0H,E0H,F0H
D_MFClkLen:	.equ	$-MCLK_DATA
;=====================================================================================
KFosc:
F_DetectMainOSC:
		ldx	#01010111b
		stx	SYSCLK		;Fsub=32khz,Fsys=Fosc/2,Fcpu=Fsys,;F4M=Fsys/2,FextXR=32768
		nop
		nop
		smb6	DIVC
		TMR0_CLK_F4Mdiv32
		jsr	MCLK_CALIB
		cmp	#(D_4MD2Div32+D_8MD2Div32)/2
		bcs	?_8MHz
		ldx	#00000111b
		stx	SYSCLK		;Fsub=32khz,Fsys=Fosc/1,Fcpu=Fsys,;F4M=Fsys/1,FextXR=32768
;		xCLRB	R_KeyOscFlag,D_MainOsc
;		xSETB	R_KeyOscFlag,D_MainSubOsc
		RMB3   Sys_Flag_C	;主频是4M标志
		bra	?L_Exit
?_8MHz:
		ldx	#01010111b
		stx	SYSCLK		;Fsub=32khz,Fsys=Fosc/2,Fcpu=Fsys,;F4M=Fsys/2,FextXR=32768

;		xSETB	R_KeyOscFlag,D_MainOsc
;		xSETB	R_KeyOscFlag,D_MainSubOsc
		SMB3   Sys_Flag_C	;主频是8M标志
		
		lda	#$FF
		sta	R_Temp
	
		ldx	#0
		stx	R_Temp+1
?L_SearchLoop:
		lda	MCLK_DATA,X
		sta	MF
		jsr	MCLK_CALIB
		sec
		sbc	#D_PlayFreq
		bcs	?L_Cmp
		eor	#$FF
		adc	#1
?L_Cmp:
		cmp	R_Temp
		bcs	?L_Next
		sta	R_Temp
		stx	R_Temp+1
?L_Next:
		inx
		cpx	#D_MFClkLen
		bcc	?L_SearchLoop
	
		ldx	R_Temp+1
		lda	MCLK_DATA,X
		sta	MF
?L_Exit:
		rmb6	DIVC
		rts
;=====================================================================================
