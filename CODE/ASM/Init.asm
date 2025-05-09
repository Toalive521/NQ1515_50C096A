L_Init_SystemRamChange_Prog:
	LDA		#$03	
	STA		pbtype		;PB0 PB1 OUTPUT-CMOS

	LDA		#$FF
	STA		PA			;PA_PULL-LOW
	LDA		#10111111B
	STA		pawake		;PA2345 Is Wakeup	

	IOIN	PD,00FH,0
	IOH		PD,00FH,0

	LDA		PD
	AND		#00FH
	STA		P_Temp

	IOOUT	PD,00FH,0

	JSR		L_Judge_Longli_Prog
	JSR		L_Judge_KeyXing_Prog

	RTS
L_Judge_Longli_Prog:
	xJB		P_Temp,1,_NongLi
	xJB		P_Temp,0,_3sDAlarm
	; BRA		_NoNongLi
	_NoNongLi:
	BC		Flag_NongLi,Bit_NongLi,1
	; IOL		PD,004H,0
	RTS
	_NongLi:
	BS		Flag_NongLi,Bit_NongLi,1
	IOH		PD,002H,0
	RTS
	_3sDAlarm:
	BS		Flag_3sDAlarm,Bit_3sDAlarm,1

	LDA		lcdcom
	AND		#$F0
	ORA		#$05
	STA		lcdcom

	lda		#4
	sta		frame

	IOH		PD,001H,0
	RTS


L_Judge_KeyXing_Prog:
	LDA		P_Temp
	; BEQ		_AXing
	xJB		P_Temp,2,_BXing
	xJB		P_Temp,3,_AXing
	_CXing:
	BS		Flag_KeyXing,Bit_CXing,1
	; IOH		PD,002H,0
	; IOL		PD,001H,0
	RTS
	_AXing:
	BS		Flag_KeyXing,Bit_AXing,1
	IOH		PD,008H,0
	RTS
	_BXing:
	BS		Flag_KeyXing,Bit_BXing,1
	; IOL		PD,002H,0
	IOH		PD,004H,0
	RTS
;------------------------------------------------------
L_Init_SystemRam_Prog:

	INC		R_Time_Day
	INC		R_Time_Month

	LDA		#$25
	STA		R_Time_Year
	LDA		#$FF
	STA		R_SlideKey1_Value
	STA		R_SlideKey2_Value
	
	LDA		#4
	STA		R_Reset_Time
	LDA		#$06
	STA		R_Alarm_Hr1
	LDA		#$12
	STA		R_Alarm_Hr2
	LDA		#$20
	STA		R_Alarm_Hr3		
	JSR		L_Auto_Counter_Week
	JSR		F_GongLiChangeToNongLi

	JSR		ENCODER_INIT

	LDA		#$00
	STA		R_Alarm_Way
	RTS
;------------------------------------------------------
;------------------------------------------------------
L_Clear_128Ram:
	LDA     #$00
	LDX     #0
L_Loop_Clear_128Ram:
	STA     $80,X
	INX
	CPX     #$80
	BCC     L_Loop_Clear_128Ram
	RTS

L_Clear_1880_RAM:
	LDA     #$00
	LDX     #0
L_Loop_Clear_1880_Ram:
	STA     $1880,X
	INX
	CPX     #$0F
	BCC     L_Loop_Clear_1880_Ram
	RTS
;------------------------------------------------------
L_BandKey_Prog:
	LDA		#$ff		
	sta		PA
	NOP
	NOP
	NOP
	RMB0	Sys_Flag_D ;lcd1
	BBR1	PA,?Exit
	SMB0	Sys_Flag_D ;lcd2
	LDA		#$FD
	STA		PA		   ;PA1����
?Exit	
	rts	
	
