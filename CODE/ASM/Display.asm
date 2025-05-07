;-------------------------------------------------------
;=====================================
.include	Disp.asm
.include	LcdTab.asm
;=====================================
;-------------------------------------------------------
L_Display_Prog:
	JSR		L_Judge_Dis_Chime_Dot		;;ZDBS	CHMDOT		2-2
	JSR		L_Dis_AlarmFlag_Prog		;Alarm_Day_Disp		2-2
	JSR		L_Judge_Dis_Snz_Flag		;2-2
	JSR		L_Judge_Dis_Speech_Off_Flag	;2-2
	JSR		L_Dis_Week_Prog				;Week_Disp		2-2
	JSR		L_Dis_MonthDay_Prog			;Month_Disp		2-2
	JSR		L_Dis_AlarmTime_Prog		;;Alarm_Disp	2-2
	JSR		L_Dis_Temperature_Prog		;Temp_Disp		2-2
	JSR		L_Dis_TimeYear_Prog			;Year_Disp		2-0
	JMP		L_Dis_Time_Prog				;Time_Disp		2-
;============================================================
;===========================	
L_1S_Display_Prog:
	LDA		R_Time_Sec
	BEQ		L_Display_Prog
	LDA		R_Mode_Flag
	BNE		L_Display_Prog
	JSR		L_Judge_Dis_AlarmModeFlag_Prog
	JSR		L_Judge_Alarm_ONOFF_Prog
	JSR		L_Judge_Dis_Snz_Flag
	LDX		#LCD1_COL1
	JSR		F_DispSymbol
	
	LDA		R_Mode_Flag
	BNE		?Skip1
	RTS
?Skip1:	
	CMP		#1
	BEQ		?SetAlarm
	CMP		#2
	BEQ		?SetData
	JMP		L_Dis_Time_Prog

?SetAlarm:
	JMP		L_Dis_AlarmTime_Prog
?SetData:
	JSR		L_Dis_TimeYear_Prog
	JMP		L_Dis_MonthDay_Prog
	
L_Dis_Col1_Prog:
	LDX		#LCD1_COL1
	JMP		F_DispSymbol	
;===========================================================
L_Dis_TimeYear_Prog:		;Year_Disp
	xJB		Flag_NongLi,Bit_NongLi,L_Dis2_TimeYear_Prog
	; LDX		#LCD1_YEAR
	; JSR		F_DispSymbol
	LDX		#LCD1_D910
	JSR		F_DispSymbol	;20
	LDA		#(R_Time_Year-Time_Str_Addr)	
	LDX		#LCD1_D11
	JMP		L_Dis_2Digit_Prog

L_Dis2_TimeYear_Prog:
	LDX		#LCD2_D910
	JSR		F_DispSymbol	;20
	RTS
	; LDX		#LCD2_D910
	; JSR		F_DispSymbol	;20
	; LDX		#(R_Time_Year-Time_Str_Addr)	
	; LDA		#LCD_TIME_YEAR_H
	; JMP		L_Dis_2Digit_Prog
;===========================================================
L_Dis_Time_NYear_Prog:
	LDA		#$20
	STA		P_Temp+7
	JUDGE_LCD_TIME_HRH
	STX		P_Temp+4
	JSR		L_Dis_TimeHr_24
	LDA		#(R_Time_Year-Time_Str_Addr)
	JMP		L_Dis_Min_Common_Prog
	RTS
;===========================================================	
L_Dis_Time_Prog:		;Time_Disp
	xJNB	Flag_NongLi,Bit_NongLi,?CON1
	LDA		R_Mode_Flag
	CMP		#3
	BEQ		L_Dis_Time_NYear_Prog
	?CON1:
	JUDGE_LCD_COL1
	JSR		F_DispSymbol
	JSR		L_Dis_TimeMin_Prog	
L_Dis_TimeHr_Prog:
	JUDGE_LCD_TIME_HRH
	STX		P_Temp+4
	LDX		#(R_Time_Hr-Time_Str_Addr)	
	LDA		Time_Addr,X
	STA		P_Temp+7	
	BBS5	Sys_Flag_A,L_Dis_TimeHr_24
	SEC
	SED
	SBC		#$12
	CLD
	BCC		L_Dis_Hour_12AM
	STA		P_Temp+7
	; RMB3	$96		;CLR AM1
	; SMB3	$90		;DIS PM1
	JUDGE_LCD_AM1
	JSR		F_ClrpSymbol
	JUDGE_LCD_PM1
	JSR		F_DispSymbol
	JMP		L_TimeHr_0To12	;L_Dis_HourDate_Prog
L_Dis_Hour_12AM:
	; SMB3	$96		;DIS AM1
	; RMB3	$90		;CLR PM1
	JUDGE_LCD_AM1
	JSR		F_DispSymbol
	JUDGE_LCD_PM1
	JSR		F_ClrpSymbol
L_TimeHr_0To12:	
	LDA		P_Temp+7
	BNE		L_Dis_HourDate_Prog
	LDA		#$12
	STA		P_Temp+7
	BRA		L_Dis_HourDate_Prog
L_Dis_TimeHr_24:
	; RMB3	$96		;CLR AM1
	; RMB3	$90		;CLR PM1
	JUDGE_LCD_AM1
	JSR		F_ClrpSymbol
	JUDGE_LCD_PM1
	JSR		F_ClrpSymbol
L_Dis_HourDate_Prog:
	LDA		P_Temp+7
	AND		#$F0
	BNE		L_Dis_Hour_Prog
	LDA		#$A0
	ORA		P_Temp+7
	STA		P_Temp+7
L_Dis_Hour_Prog:
	LDA		P_Temp+7
	; AND		#F0H
	JSR		L_LSR4Bit_Prog	
	LDX		P_Temp+4	;#Digit5
	JSR		L_Dis_8Bit_DigitDot_Prog	
	LDA		P_Temp+7
	AND		#0FH
	LDX		P_Temp+1	;#Digit6	
	JMP		L_Dis_8Bit_DigitDot_Prog
;==============================================

; 	JUDGE_LCD_AM1
; 	STX		P_Temp+4
; 	JUDGE_LCD_PM1
; 	STX		P_Temp+5
; 	JUDGE_LCD_TIME_HRH
; 	LDA		R_Time_Hr
; L_Dis_Hr_Common:
;     STX     P_Temp+6
;     STA     P_Temp+7
;     xJB     FLAG_24HR,BIT_24HR,L_Dis_TimeHr_24
;     SEC
; 	SED
; 	SBC		#$12
; 	CLD
; 	BCC		L_Dis_Hour_12AM
; 	STA		P_Temp+7
;     ; CLR_TIME_AM
; 	LDX		P_Temp+4
; 	JSR		F_ClrpSymbol
; 	; DIS_TIME_PM
; 	LDX		P_Temp+5
; 	JSR		F_DispSymbol
; L_Dis_Hour_12AM:
;     ; DIS_TIME_AM
; 	LDX		P_Temp+4
; 	JSR		F_DispSymbol
;     ; CLR_TIME_PM
; 	LDX		P_Temp+5
; 	JSR		F_ClrpSymbol
; L_TimeHr_0To12:	
; 	LDA		P_Temp+7
; 	BNE		L_Dis_HourDate_Prog
; 	LDA		#$12
; 	STA		P_Temp+7
; 	BRA		L_Dis_HourDate_Prog
; L_Dis_TimeHr_24:
;     ; CLR_TIME_AM
; 	LDX		P_Temp+4
; 	JSR		F_ClrpSymbol
;     ; CLR_TIME_PM
; 	LDX		P_Temp+5
; 	JSR		F_ClrpSymbol
; L_Dis_HourDate_Prog:
;     LDA		P_Temp+7
; 	AND		#$F0
; 	BNE		L_Dis_Hour_Prog
; 	LDA		#$A0
; 	ORA		P_Temp+7
; 	STA		P_Temp+7
; L_Dis_Hour_Prog:
;     LDX     P_Temp+6
;     LDA     P_Temp+7
;     JMP     L_Dis_Digit12
;---------------------------------------------
L_Dis_TimeMin_Prog:
	LDA		#(R_Time_Min-Time_Str_Addr)
L_Dis_Min_Common_Prog:
	JUDGE_LCD_TIME_MINH
	; LDX		P_Temp+15
L_Dis_2Digit_Prog:
	STX		P_Temp+4	
	STA		P_Temp+5		
	LDX		P_Temp+5
	LDA		Time_Addr,X
	; AND		#F0H
	JSR		L_LSR4Bit_Prog	
	LDX		P_Temp+4
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDX		P_Temp+5		
	LDA		Time_Addr,X
	AND		#0FH	
	LDX		P_Temp+1
	JMP		L_Dis_8Bit_DigitDot_Prog
;===========================================================
L_Dis_AlarmHr1_Prog:
	LDX		#(R_Alarm_Hr1-Time_Str_Addr)
L_Dis_AlarmHr_Common:
	LDA		Time_Addr,X
	STA		P_Temp+7	
	JUDGE_LCD_ALARM_HRH
	; LDA		#LCD1_D5
	STX		P_Temp+4
	BBS5	Sys_Flag_A,L_Dis_AlarmHr_24
	SEC
	SED
	SBC		#$12
	CLD
	BCC		L_Dis_AlarmHr_12AM
	STA		P_Temp+7

	JUDGE_LCD_AM2
	JSR		F_ClrpSymbol
	JUDGE_LCD_PM2
	JSR		F_DispSymbol	
	JMP		L_AlarmHr_0To12
L_Dis_AlarmHr_12AM:
	; SMB4	$81		;DIS AM2
	; RMB4	$87		;CLR PM2
	JUDGE_LCD_AM2
	JSR		F_DispSymbol
	JUDGE_LCD_PM2
	JSR		F_ClrpSymbol
L_AlarmHr_0To12:	
	LDA		P_Temp+7
	BEQ		?Skip	
	JMP		L_Dis_HourDate_Prog
?Skip:	
	LDA		#$12
	STA		P_Temp+7
	JMP		L_Dis_Hour_Prog		;L_Dis_HourDate_Prog
L_Dis_AlarmHr_24:
	; RMB4	$81		;CLR AM2
	; RMB4	$87		;CLR PM2
	JUDGE_LCD_AM2
	JSR		F_ClrpSymbol
	JUDGE_LCD_PM2
	JSR		F_ClrpSymbol		
	JMP		L_Dis_HourDate_Prog	
;===========================================================
L_Dis_AlarmTime_ACXing_Prog:
	JUDGE_LCD_COL2
	JSR		F_DispSymbol
	xJNB	FLAG_AlarmSet,Bit_AlarmSet,L_Dis_AlarmTime_ACXing_Normal
	JADDR	R_Mode_Flag,T_Alarm_ACXing_Disp
	RTS
T_Alarm_ACXing_Disp:
	DW		L_Dis_AlarmTime_ACXing_Normal-1		;
	DW		L_Dis_AlarmTime_ACXing_1-1		;
	DW		L_Dis_AlarmTime_ACXing_2-1		;
	DW		L_Dis_AlarmTime_ACXing_3-1		;
	DW		L_Dis_AlarmTime_ACXing_4-1		;
	DW		L_Dis_AlarmTime_ACXing_5-1		;
	DW		L_Dis_AlarmTime_ACXing_6-1		;
	DW		L_Dis_AlarmTime_ACXing_7-1		;
	DW		L_Dis_AlarmTime_ACXing_8-1		;
	DW		L_Dis_AlarmTime_ACXing_9-1		;
;--------------------------------------------------------
L_Judge_Alarm_ONOFF_Prog:
	JUDGE_LCD_ALARM1
	BBR1	Sys_Flag_D,?DISP1
	JSR		F_ClrpSymbol
	BRA		?2
	?DISP1:
	JSR		F_DispSymbol
	?2:
	JUDGE_LCD_ALARM2
	BBR2	Sys_Flag_D,?DISP2
	JSR		F_ClrpSymbol
	BRA		?3
	?DISP2:
	JSR		F_DispSymbol
	?3:
	JUDGE_LCD_ALARM3
	BBR3	Sys_Flag_D,?DISP3
	JMP		F_ClrpSymbol
	?DISP3:
	JMP		F_DispSymbol

L_Dis_AlarmTime_ACXing_Normal:
	JSR		L_Judge_Alarm_ONOFF_Prog
	JSR		L_Judge_Dis_Alarm_Prog
	; JSR		L_Judge_Smart_Alarm_Disp

	LDA		P_Temp+6
	BEQ		?OFF
	CMP		#1
	BEQ		?DISP1
	CMP		#2
	BEQ		?DISP2
	CMP		#3
	BEQ		?DISP3
	; LDA		Sys_Flag_D
	; AND		#$07
	; BNE		?DISP
	?OFF:
	JMP		L_Dis_AlarmOff_Prog
	?DISP1:
	JMP		L_Dis_AlarmTime1_Prog
	?DISP2:
	JMP		L_Dis_AlarmTime2_Prog
	?DISP3:
	JMP		L_Dis_AlarmTime3_Prog

L_Dis_AlarmTime_ACXing_1:
	JUDGE_LCD_ALARM2
	JSR		F_ClrpSymbol	
	JUDGE_LCD_ALARM3
	JSR		F_ClrpSymbol	
L_Dis_AlarmTime_ACXing_2:
	JMP		L_Dis_AlarmTime1_Disp_Prog
L_Dis_AlarmTime_ACXing_3:
	JUDGE_LCD_COL2
	JSR		F_ClrpSymbol
	JMP		L_Dis_AlarmONOFF1_Prog
	RTS
L_Dis_AlarmTime_ACXing_4:
	JUDGE_LCD_ALARM2
	JSR		F_DispSymbol
	JUDGE_LCD_ALARM1
	JSR		F_ClrpSymbol	
	JUDGE_LCD_ALARM3
	JSR		F_ClrpSymbol
L_Dis_AlarmTime_ACXing_5:
	
	JMP		L_Dis_AlarmTime2_Prog
L_Dis_AlarmTime_ACXing_6:
	JUDGE_LCD_COL2
	JSR		F_ClrpSymbol
	JMP		L_Dis_AlarmONOFF2_Prog
	RTS
L_Dis_AlarmTime_ACXing_7:
	; LDX		#LCD1_ALARM1
	; JSR		F_ClrpSymbol	
	JUDGE_LCD_ALARM2
	JSR		F_ClrpSymbol
L_Dis_AlarmTime_ACXing_8:
	JMP		L_Dis_AlarmTime3_Prog
L_Dis_AlarmTime_ACXing_9:
	JUDGE_LCD_COL2
	JSR		F_ClrpSymbol
	JMP		L_Dis_AlarmONOFF3_Prog
	RTS
;--------------------------------------------------------
L_Dis_AlarmTime_Prog:		;Alarm_Disp
	xJB		Flag_KeyXing,Bit_BXing,?BXING
	JMP		L_Dis_AlarmTime_ACXing_Prog
	?BXING:
	JUDGE_LCD_COL2
	JSR		F_DispSymbol
	JUDGE_LCD_ALARM1
	JSR		F_ClrpSymbol	
	JUDGE_LCD_ALARM2
	JSR		F_ClrpSymbol	
	JUDGE_LCD_ALARM3
	JSR		F_ClrpSymbol	

	BBS0	R_Alarm_Mode,L_Dis_AlarmTime2_Prog
	BBS1	R_Alarm_Mode,L_Dis_AlarmTime3_Prog	
L_Dis_AlarmTime1_Prog:
	JSR		L_Dis_Alarm1Flag_Prog
	
	LDA		R_Mode_Flag
	CMP		#1
	BNE		?SKIP		
; L_Dis_AlarmMin1_ONOFF:
	BBS1	Sys_Flag_D,L_Dis_AlarmOff_Prog	;Alarm1off
	; BRA		L_Dis_AlarmOn_Prog
?SKIP	
L_Dis_AlarmTime1_Disp_Prog:
	JSR		L_Dis_AlarmHr1_Prog
L_Dis_AlarmMin1_Prog:	
	LDA		#(R_Alarm_Min1-Time_Str_Addr)
L_Dis_AlarmMin_Common:
	JUDGE_LCD_ALARM_MINH
	JMP		L_Dis_2Digit_Prog
	
L_Dis_AlarmTime2_Prog:
	JSR		L_Dis_Alarm2Flag_Prog
	
	LDA		R_Mode_Flag
	CMP		#1
	BNE		?SKIP		
; L_Dis_AlarmMin2_ONOFF:
	BBS2	Sys_Flag_D,L_Dis_AlarmOff_Prog	;Alarm2off
	; BRA		L_Dis_AlarmOn_Prog	
?SKIP	
		
	JSR		L_Dis_AlarmHr2_Prog
L_Dis_AlarmMin2_Prog:
	LDA		#(R_Alarm_Min2-Time_Str_Addr)	
	JMP		L_Dis_AlarmMin_Common
L_Dis_AlarmHr2_Prog:
	LDX		#(R_Alarm_Hr2-Time_Str_Addr)
	JMP		L_Dis_AlarmHr_Common	
	
L_Dis_AlarmTime3_Prog:
	JSR		L_Dis_Alarm3Flag_Prog
	
	LDA		R_Mode_Flag
	CMP		#1
	BNE		?SKIP	
; L_Dis_AlarmMin3_ONOFF:	
	BBS3	Sys_Flag_D,L_Dis_AlarmOff_Prog	;Alarm3off
	; BRA		L_Dis_AlarmOn_Prog
?SKIP
	JSR		L_Dis_AlarmHr3_Prog
L_Dis_AlarmMin3_Prog:
	LDA		#(R_Alarm_Min3-Time_Str_Addr)	
	JMP		L_Dis_AlarmMin_Common
L_Dis_AlarmHr3_Prog:
	LDX		#(R_Alarm_Hr3-Time_Str_Addr)
	JMP		L_Dis_AlarmHr_Common
;--------------------------------------------------------
L_Dis_AlarmONOFF1_Prog:
	BBS1	Sys_Flag_D,L_Dis_AlarmOff_Prog
	JMP		L_Dis_AlarmOn_Prog
L_Dis_AlarmONOFF2_Prog:
	BBS2	Sys_Flag_D,L_Dis_AlarmOff_Prog
	JMP		L_Dis_AlarmOn_Prog
L_Dis_AlarmONOFF3_Prog:
	BBS3	Sys_Flag_D,L_Dis_AlarmOff_Prog
	JMP		L_Dis_AlarmOn_Prog

;--------------------------------------------------------
L_Dis_AlarmOff_Prog:	
	JUDGE_LCD_COL2
	JSR		F_ClrpSymbol
	JUDGE_LCD_AM2
	JSR		F_ClrpSymbol	
	JUDGE_LCD_PM2
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM_HRH
	LDA		#D8Z_CLR
	JSR		L_Dis_8Bit_DigitDot_Prog
	JUDGE_LCD_ALARM_HRL
	LDA		#D8Z_0
	JSR		L_Dis_8Bit_DigitDot_Prog	
	JUDGE_LCD_ALARM_MINH
	LDA		#D8Z_F
	JSR		L_Dis_8Bit_DigitDot_Prog
	JUDGE_LCD_ALARM_MINL
	LDA		#D8Z_F
	JMP		L_Dis_8Bit_DigitDot_Prog	
;------------------------------------------------------------
L_Dis_AlarmOn_Prog:	
	JUDGE_LCD_COL2
	JSR		F_ClrpSymbol
	JUDGE_LCD_AM2
	JSR		F_ClrpSymbol	
	JUDGE_LCD_PM2
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM_HRH
	LDA		#D8Z_CLR
	JSR		L_Dis_8Bit_DigitDot_Prog
	JUDGE_LCD_ALARM_HRL
	LDA		#D8Z_CLR
	JSR		L_Dis_8Bit_DigitDot_Prog	
	JUDGE_LCD_ALARM_MINH
	LDA		#D8Z_0
	JSR		L_Dis_8Bit_DigitDot_Prog
	JUDGE_LCD_ALARM_MINL
	LDA		#D8Z_N
	JMP		L_Dis_8Bit_DigitDot_Prog		

	
;===========================================================
L_Disp_Nongli:
	LDX		#LCD1_RUN
	JSR		F_ClrpSymbol
	LDA		R_MonthBeginRun
	BEQ		?Skip
	LDX		#LCD2_RUN
	JSR		F_DispSymbol
?Skip:	
	LDA		R_NongLiTimeDay
	STA		P_Temp+7	
	; LDA		#LCD_TIME_DAY_H
	LDA		#LCD2_TIME_NDAY_H
	STA		P_Temp+4
	JSR		L_Dis_HourDate_Prog
	; LDX		#LCD_TIME_MONTH_L
	LDX		#LCD2_TIME_NMONTH_L
	LDA		R_NongLiTimeMonth
	AND		#$0F
	JSR		L_Dis_8Bit_DigitDot_Prog
	; LDX		#LCD_TIME_MONTH_H
	LDX		#LCD2_TIME_NMONTH_H
	LDA		R_NongLiTimeMonth
	AND		#$F0
	BEQ		?CLR1
	JMP		F_DispSymbol
?CLR1:	
	JMP		F_ClrpSymbol
	RTS
;------------------------------------------
NongLi1:	
	LDX		#LCD1_NL
	JSR		F_DispSymbol
	LDX		#LCD1_DAY2
	JSR		F_DispSymbol
	LDX		#LCD1_RUN
	JSR		F_ClrpSymbol
	LDA		R_MonthBeginRun
	BEQ		?Skip
	LDX		#LCD1_RUN
	JSR		F_DispSymbol
?Skip:	
	LDA		R_NongLiTimeDay
	STA		P_Temp+7	
	LDA		#LCD_TIME_DAY_H
	STA		P_Temp+4
	JSR		L_Dis_HourDate_Prog
	LDX		#LCD_TIME_MONTH_L
	LDA		R_NongLiTimeMonth
	AND		#$0F
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDX		#LCD_TIME_MONTH_H
	LDA		R_NongLiTimeMonth
	AND		#$F0
	BEQ		?CLR1
	JMP		F_DispSymbol
?CLR1:	
	JMP		F_ClrpSymbol	
;-----------------------------------------------------------------
L_Judge_Disp_NongLi_Prog:
	LDX		#LCD1_NL
	xJB		FLAG_NongLiD,Bit_NongLiD,?Disp
	JMP		F_ClrpSymbol
?Disp:
	JMP		F_DispSymbol
;-----------------------------------------------------------------
L_Dis_MonthDay_Prog:		;Month_Disp
	JSR		L_Judge_Disp_NongLi_Prog
	xJB		FLAG_NongLiD,Bit_NongLiD,NongLi1
	xJNB		Flag_NongLi,Bit_NongLi,?GONGLI
	JSR		L_Disp_Nongli
	?GONGLI:
	; LDX		P_Temp+11
	JUDGE_LCD_GL
	JSR		F_DispSymbol
	; LDX		P_Temp+10
	; JSR		F_DispSymbol
	LDA		R_Time_Day
	STA		P_Temp+7	
	; LDA		P_Temp+9
	JUDGE_LCD_TIME_DAY_H
	STX		P_Temp+4
	JSR		L_Dis_HourDate_Prog
	JUDGE_LCD_TIME_MONTH_L
	; LDX		P_Temp+8
	LDA		R_Time_Month
	AND		#$0F
	JSR		L_Dis_8Bit_DigitDot_Prog
	; LDX		P_Temp+10
	JUDGE_LCD_TIME_MONTH_H
	LDA		R_Time_Month
	AND		#$F0
	BEQ		?CLR
	JSR		F_DispSymbol
	RTS
	; JMP		NongLi1
?CLR:	
	JSR		F_ClrpSymbol
	RTS
;===========================================================	
L_Dis_Week_Prog:		
	LDX		R_Time_Week
	LDA		T_LCD1Week,X
	JUDGE_LCD_WEEK
	; LDX		P_Temp+11
	JMP		F_DispPro
T_LCD1Week:
	DB		$40	;Sun
	DB		$01 ;Mon
	DB		$02 ;
	DB		$04 ;
	DB		$08 ;	
	DB		$10 ;	
	DB		$20 ;Sat
	DB		$40	;Sun									
;===========================================================	
L_Dis_Temperature_Prog:		;Temp_Disp
	JUDGE_DOT_TEMP_CF
	JSR		F_DispSymbol
	JUDGE_LCD_TEMP_HHBC
	; LDX		P_Temp+15		;Clear ����5G
	JSR		F_ClrpSymbol
	; LDX		#LCD1_D21_G			;Clear Digit5_bc
	; JSR		F_ClrpSymbol
	BBS5	R_Temperature_L,L_Dis_Temperature_Lo
	BBS6	R_Temperature_L,L_Dis_Temperature_Hi
L_Dis_Positive_Temperature_Prog:	
	BBR7	Sys_Flag_A,?DISC
	JMP		L_Dis_Temperature_F
	?DISC:
	JSR		L_Dis_C		;DIS C
	JUDGE_LCD_TEMPD
	LDA		R_Temperature_L
	AND		#$0F
	JSR		L_Dis_8Bit_DigitDot_Prog
	JUDGE_LCD_TEMPL
	LDA		R_Temperature
	STA		P_Temp+6
	AND		#$0F
	JSR		L_Dis_8Bit_DigitDot_Prog	
	LDA		P_Temp+6
	AND		#$F0
	STA		P_Temp+6
	BEQ		L_Clear_R_Temperature_High4Bit
	BBR7	R_Temperature_L,L_LSR_R_Temperature_High4Bit
	;负值
	; LDX		#LCD1_D21_G		
	; JSR		F_DispSymbol		;Display ���� 	Digit5:G
L_LSR_R_Temperature_High4Bit:	
	LDA		P_Temp+6
	JSR		L_LSR4Bit_Prog
L_Dis_R_Temperature_High4Bit:	
	JUDGE_LCD_TEMPH
	JMP		L_Dis_8Bit_DigitDot_Prog		
L_Clear_R_Temperature_High4Bit:
	BBS7	R_Temperature_L,L_Dis_SignNegative_Digit6
	LDA		#D8Z_CLR
	BRA		L_Dis_R_Temperature_High4Bit
L_Dis_SignNegative_Digit6:
	LDA		#D8Z_g
	BRA		L_Dis_R_Temperature_High4Bit
;------------------------------------
L_Dis_Temperature_Lo:
	LDA		#D8Z_L
	JUDGE_LCD_TEMPH
	JSR		L_Dis_8Bit_DigitDot_Prog	
	LDA		#D8Z_o	
	JUDGE_LCD_TEMPL	
	JSR		L_Dis_8Bit_DigitDot_Prog	
	JMP		L_Common

L_Dis_Temperature_Hi:
	LDA		#D8Z_H
	JUDGE_LCD_TEMPH
	JSR		L_Dis_8Bit_DigitDot_Prog	
	LDA		#D8Z_i	
	JUDGE_LCD_TEMPL
	JSR		L_Dis_8Bit_DigitDot_Prog	
L_Common:
	; LDX		#LCD1_COL3		;clr DOT
	; JSR		F_ClrpSymbol	
	JUDGE_LCD_TEMPD
	LDA		#D8Z_CLR
	JSR		L_Dis_8Bit_DigitDot_Prog	
	BBS7	Sys_Flag_A,L_Dis_F

L_Dis_C:	
	JUDGE_DOT_TEMP_F
	JSR		F_ClrpSymbol
	JUDGE_DOT_TEMP_C
	JMP		F_DispSymbol

	; LDX		#LCD1_D24
	; LDA		#D8Z_C
	; JMP		L_Dis_8Bit_DigitDot_Prog	;DIS C
L_Dis_F:	
	JUDGE_DOT_TEMP_C
	JSR		F_ClrpSymbol
	JUDGE_DOT_TEMP_F
	JMP		F_DispSymbol

	; LDX		#LCD1_D24
	; LDA		#D8Z_F
	; Jmp		L_Dis_8Bit_DigitDot_Prog	;DIS F
;------------------------------------		
L_Dis_Temperature_F:
	JSR		L_Dis_F			;DIS F
	JUDGE_LCD_TEMPL
	LDA		R_Temperature_F_M
	JSR		L_LSR4Bit_Prog
	JSR		L_Dis_8Bit_DigitDot_Prog	;��ʾ ��λ	
	JUDGE_LCD_TEMPD
	LDA		R_Temperature_F_M	
	AND		#$0F
	JSR		L_Dis_8Bit_DigitDot_Prog	;��ʾ С����λ
	LDA		R_Temperature_F_H
	AND		#$F0
	BEQ		L_No_Hibit
	JUDGE_LCD_TEMP_HHBC		
	JSR		F_DispSymbol				;DIS Digit5_bc
L_No_Hibit:		
	JUDGE_LCD_TEMPH
	LDA		R_Temperature_F_H
	AND		#$0F
	JMP		L_Dis_8Bit_DigitDot_Prog	;��ʾ��λ
;==================================================
;===========================================================
L_Dis_AlarmFlag_Prog:		;Alarm_Day_Disp
	LDA		R_Alarm_Way
	BEQ		L_Clr_All_AlarmFlag
	BBS0	R_Alarm_Way,L_Dis_AlarmFlag_ALD
	BBS1	R_Alarm_Way,L_Dis_AlarmFlag_ALW5
L_Dis_AlarmFlag_ALW6:		;Disp_6Day
	JUDGE_LCD_ALARM4
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM5
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM6
	JMP		F_DispSymbol
L_Clr_All_AlarmFlag:
	JUDGE_LCD_ALARM4
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM5
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM6
	JMP		F_ClrpSymbol
L_Dis_AlarmFlag_ALD:		;Disp_7Day
	JUDGE_LCD_ALARM4
	JSR		F_DispSymbol
	JUDGE_LCD_ALARM5
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM6
	JMP		F_ClrpSymbol
L_Dis_AlarmFlag_ALW5:		;Disp_6Day
	JUDGE_LCD_ALARM4
	JSR		F_ClrpSymbol
	JUDGE_LCD_ALARM5
	JSR		F_DispSymbol
	JUDGE_LCD_ALARM6
	JMP		F_ClrpSymbol

;********************************************
;------------------------------------------		
;L_Judge_Dis_Al_Flag:
;	BBR0	Sys_Flag_B,L_Clr_Al_Flag
;	SMB0	$8A		;DIS Al
;	RTS
;L_Clr_Al_Flag:
;	RMB0	$8A		;Clr Al	
;	RTS	
;------------------------------------------	
L_Judge_Dis_Snz_Flag:
	JUDGE_LCD_SNZ
	bbs7	Sys_Flag_C,L_Dis_Snz_Flag
	LDA		R_SnoozeTime_Minute
	BEQ		L_Clr_Snz_Flag
L_Dis_Snz_Flag:	
	JMP		F_DispSymbol
L_Clr_Snz_Flag:
	; LDX		P_Temp+11
	JMP		F_ClrpSymbol
;------------------------------------------
L_Judge_Dis_Speech_Off_Flag:
	JUDGE_LCD_BZ
	bbs7	Sys_Flag_B,L_Dis_Speech_Off_Flag
L_Clr_Speech_Off_Flag:	
	; LDX		P_Temp+11
	JMP		F_ClrpSymbol
	
L_Dis_Speech_Off_Flag:
	; LDX		P_Temp+11
	JMP		F_DispSymbol
;==============================================
L_Judge_Dis_Chime_Dot:
	JUDGE_LCD_CHM
	bbs4	Sys_Flag_C,L_Dis_Chime_Dot
L_Clr_Chime_Dot:
	JMP		F_ClrpSymbol

L_Dis_Chime_Dot:
	JMP		F_DispSymbol
;===========================================================
;===========================================================
;Flash Prog
;===========================================================
L_Clr_Col1_Prog:
	; LDX		#LCD1_COL1
	JUDGE_LCD_COL1
	JMP		F_ClrpSymbol
;----------------------------------
L_SysFlash_Prog:
	JSR		L_Judge_Flash_SnzFlag_Prog
	JSR		L_Judge_Flash_AlarmFlag_Prog
	LDA		R_Mode_Flag
	BNE		L_Judge_SysFlash_For_Xing_Prog
	JSR		L_Clr_Col1_Prog
L_Judge_SysFlash_For_Xing_Prog:
	xJB		FLAG_AlarmSet,Bit_AlarmSet,?SKIP
	JSR		L_Clr_Col1_Prog
	?SKIP:	
	xJB		Flag_KeyXing,Bit_AXing,L_Judge_SysFlash_AXing_Prog
	xJB		Flag_KeyXing,Bit_BXing,L_Judge_SysFlash_BXing_Prog
	xJB		Flag_KeyXing,Bit_CXing,L_Judge_SysFlash_CXing_Prog
	RTS
;-------------------------------------------------------------
L_Judge_SysFlash_AXing_Prog:
L_Judge_SysFlash_CXing_Prog:
	BBS6	Sys_Flag_D,L_Judge_SysFlash_Ending
	xJB		FLAG_AlarmSet,Bit_AlarmSet,L_SysFlash_Alarm_Prog
	; LDA		R_Mode_Flag
	JADDR	R_Mode_Flag,T_Flash_AXing_TimeSet
L_Judge_SysFlash_Ending:
	RTS
T_Flash_AXing_TimeSet:	
	DW		L_Judge_SysFlash_Ending-1		;L_Flash_Time_Init_Prog-1
	DW		L_Flash_12Dight-1		;L_Flash_Time_Hr_Prog-1
	DW		L_Flash_34Dight-1		;L_Flash_Time_Min_Prog-1
	DW		L_Flash_Year-1		;L_Flash_Time_Year-1
	DW		L_Flash_Month-1		;L_Flash_Time_Month_Prog-1
	DW		L_Flash_Day-1		;L_Flash_Time_Week-1

;------------------------------------------------------------
L_SysFlash_Alarm_Prog:
	JADDR	R_Mode_Flag,T_Flash_AXing_AlarmSet
	RTS
T_Flash_AXing_AlarmSet:	
	DW		L_Judge_SysFlash_Ending-1		;
	DW		L_Flash_Alarm_Hr-1		;
	DW		L_Flash_Alarm_Min-1		;
	DW	L_Flash_Alarm_ONOFF-1		;
	DW		L_Flash_Alarm_Hr-1		;
	DW		L_Flash_Alarm_Min-1		;
	DW	L_Flash_Alarm_ONOFF-1
	DW		L_Flash_Alarm_Hr-1		;
	DW		L_Flash_Alarm_Min-1		;
	DW	L_Flash_Alarm_ONOFF-1
;------------------------------------------------------------
L_Judge_SysFlash_BXing_Prog:
L_Judge_SysFlash_Prog:
	LDA		R_Mode_Flag	
	BEQ		L_End_SysFlash_BXing_Prog
	CMP		#3
	BEQ		?TimeSet
	CMP		#1
	BEQ		L_Clr_Alarm_Digit_Prog
	JMP		L_Clr_Year_Month_Day_Digit_Prog
?TimeSet:	
	BBS2	Sys_Flag_B,L_End_SysFlash_BXing_Prog
L_Clr_Digit1_2_3_4_Prog:
	JUDGE_LCD_TIME_HRH
	; LDX		#LCD1_D1
	JSR		L_Clr_Next_to_2Digit
	JUDGE_LCD_TIME_MINH
	; LDX		#LCD1_D3	
L_Clr_Next_to_2Digit:
	LDA		#$0A
	JSR		L_Dis_8Bit_DigitDot_Prog
	LDX		P_Temp+1
	LDA		#$0A
	JMP		L_Dis_8Bit_DigitDot_Prog
L_End_SysFlash_BXing_Prog:
	RTS
;-----------------------------------------	
L_Clr_Year_Month_Day_Digit_Prog:
	JSR		L_Clr_Col1_Prog
	BBS2	Sys_Flag_B,L_End_SysFlash_BXing_Prog
	; LDX		#LCD1_D910
	; JSR		F_ClrpSymbol
	JUDGE_LCD_TIME_YEAR_H
	; LDX		#LCD1_D11
	JSR		L_Clr_Next_to_2Digit	
	JUDGE_LCD_TIME_MONTH_H
	; LDX		#LCD1_D13
	JSR		F_ClrpSymbol
	JUDGE_LCD_TIME_MONTH_L
	; LDX		#LCD1_D14
	LDA		#$0A
	JSR		L_Dis_8Bit_DigitDot_Prog
	JUDGE_LCD_TIME_DAY_H
	; LDX		#LCD1_D15
	JMP		L_Clr_Next_to_2Digit		
;-----------------------------------------
L_Clr_Alarm_Digit_Prog:
	JSR		L_Clr_Col1_Prog
	BBS2	Sys_Flag_B,L_End_SysFlash_BXing_Prog
	JUDGE_LCD_ALARM_HRH
	; LDX		#LCD1_D5
	JSR		L_Clr_Next_to_2Digit
	JUDGE_LCD_ALARM_MINH
	; LDX		#LCD1_D7
	JMP		L_Clr_Next_to_2Digit	
;===========================================================	
L_Flash_12Dight:
	; LDX		#LCD1_D1
	JUDGE_LCD_TIME_HRH
	JMP		L_Clr_Next_to_2Digit
L_Flash_34Dight:	
	JUDGE_LCD_TIME_MINH
	; LDX		#LCD1_D3
	JMP		L_Clr_Next_to_2Digit
L_Flash_Year:
	xJB		Flag_NongLi,Bit_NongLi,L_NongLi_Year_Flash
	JUDGE_LCD_TIME_YEAR_H
	; LDX		#LCD_TIME_YEAR_H
	JMP		L_Clr_Next_to_2Digit
	; LDX		#LCD_TIME_YEAR_20
	; JMP		F_ClrpSymbol
L_NongLi_Year_Flash:
	JSR		L_Flash_12Dight
	JMP		L_Flash_34Dight

L_Flash_Month:
	JUDGE_LCD_TIME_MONTH_H
	; LDX		#LCD_TIME_MONTH_H
	JSR		F_ClrpSymbol
	JUDGE_LCD_TIME_MONTH_L
	; LDX		#LCD_TIME_MONTH_L
	JMP		L_Clr_Digit
L_Flash_Day:
	JUDGE_LCD_TIME_DAY_H
	; LDX		#LCD_TIME_DAY_H
	JMP		L_Clr_Next_to_2Digit
L_Flash_Alarm_Hr:
	JUDGE_LCD_ALARM_HRH
	; LDX		#LCD_ALARM_HRH
	JMP		L_Clr_Next_to_2Digit
L_Flash_Alarm_Min:
	JUDGE_LCD_ALARM_MINH
	; LDX		#LCD_ALARM_MINH
	JMP		L_Clr_Next_to_2Digit
L_Flash_Alarm_ONOFF:
	JUDGE_LCD_ALARM_HRH
	; LDX		#LCD_ALARM_MINH
	JSR		L_Clr_Next_to_2Digit
	JUDGE_LCD_ALARM_MINH
	; LDX		#LCD_ALARM_HRH
	JMP		L_Clr_Next_to_2Digit
;------------------------------------------------------------
; L_Clr_Next_to_2Digit:
; 	LDA		#$00
; 	JSR		F_DispPro
; 	LDX		P_Temp+1
L_Clr_Digit:	
	LDA		#$00
	JMP		F_DispPro

;============================================================
L_Judge_Flash_SnzFlag_Prog:
	LDA		R_SnoozeTime_Minute
	BEQ		L_End_Judge_Flash_SnzFlag_Prog
	JUDGE_LCD_SNZ
	JMP		L_Clr_Snz_Flag
L_End_Judge_Flash_SnzFlag_Prog:	
	RTS
	
L_Judge_Flash_AlarmFlag_Prog:
	BBR4	Sys_Flag_B,L_End_Judge_Flash_AlarmFlag_Prog
	
	LDA		R_Alarm_Mode
	BEQ		?FLASH1
	CMP		#1
	BEQ		?FLASH2
	?FLASH3:
	JUDGE_LCD_ALARM3
	; LDX		#LCD1_ALARM3
	; JSR		F_ClrpSymbol
	JMP		F_ClrpSymbol


	?FLASH1:
	JUDGE_LCD_ALARM1
	; LDX		#LCD1_ALARM1
	; JSR		F_ClrpSymbol
	JMP		F_ClrpSymbol
	

	?FLASH2:	
	JUDGE_LCD_ALARM2
	; LDX		#LCD1_ALARM2
	; JSR		F_ClrpSymbol
	JMP		F_ClrpSymbol
	
L_End_Judge_Flash_AlarmFlag_Prog:	
	RTS
	
L_Judge_Dis_AlarmModeFlag_Prog:
	xJNB	Flag_KeyXing,Bit_BXing,L_Judge_Dis_AlarmModeFlag_Prog_END

	BBS0	R_Alarm_Mode,L_Dis_Alarm2Flag_Prog
	BBS1	R_Alarm_Mode,L_Dis_Alarm3Flag_Prog
L_Judge_Dis_AlarmModeFlag_Prog_END:
	RTS
L_Dis_Alarm1Flag_Prog:	
	; LDX		#LCD1_ALARM1
	JUDGE_LCD_ALARM1
	JMP		F_DispSymbol
	
L_Dis_Alarm2Flag_Prog:
	; LDX		#LCD1_ALARM2
	JUDGE_LCD_ALARM2
	JMP		F_DispSymbol
	
L_Dis_Alarm3Flag_Prog:
	JUDGE_LCD_ALARM3
	; LDX		#LCD1_ALARM3
	JMP		F_DispSymbol
;===========================================================

;=======================================================
L_Judge_Dis_Alarm_Prog:			;聪明钟
	; LDA		R_Mode_Flag
	; CMP		#C_AlarmMode
	; LJZ		L_Judge_Dis_Alarm_End_Prog
	; JSR		L_Clr_Alarm_All_Prog
	; JSR		L_Dis_Dot_Ala_Prog
	LDA		#$0
	STA		P_Temp+6
	STA		P_Temp+7
	STA		P_Temp+8
	STA		P_Temp+9
	STA		P_Temp+10

	LDA		R_Alarm_Way
	BEQ		?JUDGE1
	BBS0	R_Alarm_Way,?JUDGE1
	BBS1	R_Alarm_Way,?JUDGE5
	BBS2	R_Alarm_Way,?JUDGE6
	RTS
	?JUDGE5:
	LDA		R_Time_Week
	CMP		#$6
	BEQ		?RTS
	?JUDGE6:
	LDA		R_Time_Week
	BEQ		?RTS
?JUDGE1:
	; BBS2	R_Alarm1_Week, ?JUDGE2
?CON1:
	BBS1	Sys_Flag_D,?JUDGE2	;ALARM_OFF
	SEC
	LDA		R_Alarm_Min1
	SBC		R_Time_Min
	STA		P_Temp+7
	LDA		R_Alarm_Hr1
	SBC		R_Time_Hr
	STA		P_Temp+8

	; ORA		P_Temp+7		;判断闹钟在响铃结束后显示下一个时间
	; BNE		?CONN1
	; LDA		R_Alarm_Time
	; BNE		?CONN1
	; LDA		#$FF
	; STA		P_Temp+8
	; STA		P_Temp+7
?CONN1:
	LDA		#1
	STA		P_Temp+6

	LDA		P_Temp+7	
	STA		P_Temp+9

	LDA		P_Temp+8
	STA		P_Temp+10


?JUDGE2:
	; BBS2	R_Alarm2_Week, ?JUDGE3
?CON2:
	BBS2	Sys_Flag_D,?JUDGE3

	SEC
	LDA		R_Alarm_Min2
	SBC		R_Time_Min
	STA		P_Temp+7

	LDA		R_Alarm_Hr2
	SBC		R_Time_Hr
	STA		P_Temp+8

	; ORA		P_Temp+7		;判断闹钟在响铃结束后显示下一个时间
	; BNE		?CONN2
	; LDA		R_Alarm_Time
	; BNE		?CONN2
	; LDA		#$FF
	; STA		P_Temp+8
	; STA		P_Temp+7
?CONN2:
	LDA		P_Temp+6
	BEQ		?ALAMODE2

	
	LDA		P_Temp+8
	CMP		P_Temp+10
	BCC		?ALAMODE2
	BNE		?JUDGE3

	LDA		P_Temp+7
	CMP		P_Temp+9
	BCS		?JUDGE3	
	?ALAMODE2:
	LDA		P_Temp+8
	STA		P_Temp+10
	LDA		P_Temp+7
	STA		P_Temp+9

	LDA		#2
	STA		P_Temp+6
?JUDGE3:
	; BBS2	R_Alarm3_Week, ?RTS
?CON3:
	BBS3	Sys_Flag_D,?RTS
	LDA		P_Temp+6
	BEQ		?ALAMODE3

	SEC
	LDA		R_Alarm_Min3
	SBC		R_Time_Min
	STA		P_Temp+7
	LDA		R_Alarm_Hr3
	SBC		R_Time_Hr
	STA		P_Temp+8

	; ORA		P_Temp+7
	; BNE		?CONN3
	; LDA		R_Alarm_Time
	; BNE		?CONN3
	; LDA		#$FF
	; STA		P_Temp+8
	; STA		P_Temp+7
?CONN3:
	LDA		P_Temp+8
	CMP		P_Temp+10
	BCC		?ALAMODE3
	BNE		?RTS

	LDA		P_Temp+7
	CMP		P_Temp+9
	BCS		?RTS
	?ALAMODE3:
	LDA		#3
	STA		P_Temp+6
?RTS:
	; LDA		#0
	; STA		R_Alarm_Dif_H
	; STA		R_Alarm_Dif_L
	RTS
;===========================================================
;===========================================================
;================Judge_Disp=================================
;===========================================================
;===========================================================
;===========================================================
;============Disp_Base======================================
;===========================================================
; D_Disp_Time_Col:
; 	JUDGE_LCD_COL1
; 	JMP		F_DispSymbol
; D_Disp_Time_Am:
; 	JUDGE_LCD_AM1
; 	JMP		F_DispSymbol
; D_Disp_Time_Pm:
; 	JUDGE_LCD_PM1
; 	JMP		F_DispSymbol

; D_Disp_Alarm_Col:
; 	JUDGE_LCD_COL2
; 	JMP		F_DispSymbol
; D_Disp_Alarm_Dot1:
; 	JUDGE_LCD_ALARM1
; 	JMP		F_DispSymbol
; D_Disp_Alarm_Dot2:
; 	JUDGE_LCD_ALARM2
; 	JMP		F_DispSymbol
; D_Disp_Alarm_Dot3:
; 	JUDGE_LCD_ALARM3
; 	JMP		F_DispSymbol
; D_Disp_Alarm_7Day:
; 	JUDGE_LCD_ALARM4
; 	JMP		F_DispSymbol
; D_Disp_Alarm_6Day:
; 	JUDGE_LCD_ALARM6
; 	JMP		F_DispSymbol
; D_Disp_Alarm_5Day:
; 	JUDGE_LCD_ALARM5
; 	JMP		F_DispSymbol

; D_Disp_Dot_Snz:
; 	JUDGE_LCD_SNZ
; 	JMP		F_DispSymbol
; D_Disp_Dot_Chm:
; 	JUDGE_LCD_CHM
; 	JMP		F_DispSymbol
; D_Disp_Dot_BZ:
; 	JUDGE_LCD_BZ
; 	JMP		F_DispSymbol

; D_Disp_Alarm_Am:
; 	JUDGE_LCD_AM2
; 	JMP		F_DispSymbol

; D_Disp_Alarm_Pm:
; 	JUDGE_LCD_PM2
; 	JMP		F_DispSymbol
; D_Disp_Dot_Year:
; 	JUDGE_LCD_YEAR
; 	JMP		F_DispSymbol
; D_Disp_Dot_GL:
; 	JUDGE_LCD_GL
; 	JMP		F_DispSymbol
; D_Disp_Dot_NL:
; 	JUDGE_LCD_NL
; 	JMP		F_DispSymbol
; D_Disp_Dot_Run:
; 	JUDGE_LCD_RUN
; 	JMP		F_DispSymbol

; ;===========================================================
; Disp_Delight_12:

; 	RTS
;===========================================================




;===========================================================


