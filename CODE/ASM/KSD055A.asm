;278 Byte

.CHIP           W65C02S
.INCLIST        ON
.MACLIST        ON
;***************************************
CODE_BEG        EQU   C002h	 ;
;***************************************
;Project Name:  KSD055A
;CPU            50C096A
;Start  Date:   2017-07-11
;Finish Date:
;***************************************
PROG	SECTION OFFSET  CODE_BEG
;***************************************
;***************************************
;----------------------------------
;file include				
;----------------------------------
.include	50C096A.h
.include	RAM.INC
.include	macro1.mac
.include	Macro2.mac
.include	50C096A.mac
;-----------------------------------
STACK_BOT		EQU		BFH
;***********************************
	.PROG
V_RESET:
	NOP
	NOP
	NOP
	SEI
	LDX		#STACK_BOT
	TXS

	LDA		#11010011B	;#$07
	STA		sysclk	;Strong
	
	lda		#$C3
	sta		lcdcom	 ;C TYPE,4com,
	LDA		#$1F	;#$4F
	STA		pcseg	;PD_PD,PC6-PC7,S4-S5,C TYPE
	lda		#$FF 
	sta		lcdctrl  ;LCD LV4 ,1/3bias,VLCD=4.5V
	lda		#7
	sta		frame	;32k/16/4/(1+7)=64Hz
	
	
	JSR		L_Clear_128Ram
	
	JSR		L_Clear_1880_RAM

	LDA		#$0
	STA		tmrc
	sta		tmr0
	sta		tmr1	
	STA		divc
	STA		ier
	STA		ifr
	STA		DAC
	STA		DAC_CTL
	STA		pb
	sta		pc
	sta		pcdir
	sta		MF	

		
	
	JSR		L_Init_SystemRamChange_Prog
	JSR		L_Init_SystemRam_Prog
	JSR		L_Dis_All_DisRam_Prog
	SMB4	tmrc	;��LCD	
	InitSound
	tmr1_250ms
	tmr1_on
	LDX	#2
hehe1:
	bbr2	ifr,hehe1
	rmb2	ifr
	DEX
	BNE		hehe1
	tmr1_off
	TMR0_CLK_F4Mdiv32
	DIV_1KHZ		
	jsr     KFosc
	tmr1_250ms
	tmr1_on		
	smb2	ier		;����TMR1
	
	JSR		L_BandKey_Prog
	
	CLI
;***********************************************************************
;***********************************************************************
MainLoop:
	JSR		F_SoundCtrlEntry	;
	JSR		L_LCD_IRQ_WorkProg	;
	JSR		Judge_Knob_Prog
	JSR		L_4Hz_Prog			;
	jsr     F_SevicePlaySentence	;	
    jsr		F_PlaySentence	;
	xJB		FLAG_RNOB,BIT_RNOB,MainLoop
	xJB		R_SoundCtrl,C_StartPlayBit,MainLoop
	BBS7	tmrc,MainLoop
    bbs3	R_SETCNT,MainLoop 
	xJB		R_SoundCtrl,C_SentencePlayingBit,MainLoop
	rmb5	sysclk		;fosc/2	
	nop
	nop
	STA		halt
	bbs3	Sys_Flag_C,L_Loop1
	rmb4	sysclk		;fosc/1
L_Loop1:	
	NOP
	NOP	
	BRA		MainLoop

Judge_Knob_Prog:
	xJNB	Flag_KeyXing,Bit_CXing,Judge_Knob_Prog_RTS
	; LDA		R_Beep_Time
	; BNE		Judge_Knob_Prog_RTS
	JSR		ENCODER_SCAN
	JSR		L_Knob_Function
Judge_Knob_Prog_RTS:
	RTS		
;***********************************************************************
;***********************************************************************
V_IRQ:
	PHA
	TXA
	PHA	
	LDA		ier
	AND		ifr
	STA		R_Int_Backup
	BBS2	R_Int_Backup,L_Timer1_IRQ_Prog
	BBS1	R_Int_Backup,L_Timer0_IRQ_Prog
	BBS0	R_Int_Backup,L_Div_IRQ_Prog
	BBS4	R_Int_Backup,L_PA_IRQ_Prog
	BBS6	R_Int_Backup,L_LCD_IRQ_Prog
L_Div_IRQ_Prog:
	RMB0	ifr			;���DIV�жϱ�־
	BRA		L_End_IRQ_Prog
	
L_Timer0_IRQ_Prog:
	RMB1	ifr			;���Timer0�жϱ�־
	bbs3	R_SETCNT,isr_tmr01
	jsr		F_SeviceForTimer0
isr_tmr02:
    rmb1	ifr	
	BRA		L_End_IRQ_Prog

isr_tmr01:
	jsr		F_SpMuteProc
	BRA		isr_tmr02
	
L_Timer1_IRQ_Prog:
	RMB2	ifr			;���Timer1�жϱ�־
	SMB6	Sys_Flag_A		;����1/4s Flag	
	BRA		L_End_IRQ_Prog
	
L_PA_IRQ_Prog:
	RMB4	ifr			;���PA�жϱ�־
	bbR5    pa,L_No_Sound
	SMB2	Sys_Flag_C	;������
L_No_Sound:
	EN_LCD_IRQ			;��32HZ�ж�ʹ��
	DIS_KEY_IRQ	
L_No_Open_lcd_irq:
	BRA		L_End_IRQ_Prog
	
L_LCD_IRQ_Prog:
	RMB6	ifr				;���LCD�жϱ�־
	SMB2	Sys_Flag_A		;����LCD init flag
L_End_IRQ_Prog:
	BBS2	ifr,L_Timer1_IRQ_Prog
	PLA
	TAX	
	PLA
	RTI
;***********************************************************************
.INCLUDE	ScanKey.asm
.INCLUDE	Half_S.asm
.INCLUDE	Temper.asm
.INCLUDE	Init.asm
.INCLUDE	Display.asm

.include	Sound.asm
.include	Speech.asm
.include	SentPlay.asm
.include	MF096.asm
.include	TIME.asm

;--------------------------------------------------------	
;***********************************************************************
	.ORG	0FFF8H	
	DB		81H ;PA7ΪAC,AUTO_DETECT
	DB		04H	;LVR Enable
;***********************************************************************
	.ORG	0FFFCH
	DW		V_RESET
	DW		V_IRQ
	
	.ENDS
	.END
	
	