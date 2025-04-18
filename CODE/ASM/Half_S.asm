;============================================================
L_4Hz_Prog:
	BBR6 	Sys_Flag_A,L_END_4Hz_Prog			;�ж�1/4���־	
	RMB6	Sys_Flag_A
	LDA		R_Reset_Time
	BNE		L_Reset_2s_Prog	
	xJNB	Flag_KeyXing,Bit_BXing,?Skip
	JSR		L_Scan_SlideKey_Prog
?Skip:	
	JSR		L_Light_Control_Prog	
	BBS0	Sys_Flag_A,L_Half_Second_Prog		;half_s
	SMB0	Sys_Flag_A							;

L_END_4Hz_Prog:
	RTS
;============================================================
L_Half_Second_Prog:							;half_s		2hz
	RMB0 	Sys_Flag_A		
	xJB		Flag_KeyXing,Bit_BXing,?SKIP
	JSR		L_AutoExitSet_Prog
	?SKIP:						;
	BBS1	Sys_Flag_A,L_1Second_Prog			;JUDGE 1s-ANOTHER 0.5S
	SMB1	Sys_Flag_A					;
	JMP		L_SysFlash_Prog						;0.5S			
;-----------------------------------------	
L_Reset_2s_Prog:
	SEC
	LDA		R_Reset_Time
	SBC		#1
	STA		R_Reset_Time
	BEQ		L_Reset_Ok
	CMP		#2
	BNE		L_END_4Hz_Prog	
	JMP		L_Give_Measure_Temperature_Value
L_Reset_Ok:
	EN_KEY_IRQ					;Reset 2s normal mode
	JSR		L_Clr_All_DisRam_Prog
	JUDGE_LCD_MD
	; LDX		#DOT_MDTW
	JSR		F_DispSymbol
	xJNB	Flag_KeyXing,Bit_BXing,?Skip
	JSR		L_Scan_SlideKey_Prog
	; BBR0	Sys_Flag_D,?Skip ;LCD1����
	; JSR		L_Judge_SlideKey3_Prog  ;lcd2 ר��
?Skip:	
	JSR		L_Display_Prog
	LDA		#2
	STA		R_Voice_Unit
	sta		R_Strong_Time
	RTS	
;-----------------------------------------
L_1Second_Prog:
	RMB1	Sys_Flag_A				;
	LDA		R_Strong_Time
	BEQ		L_Normal_1Second_Prog
	SEC
	LDA		R_Strong_Time
	SBC		#1
	STA		R_Strong_Time
	BNE		L_Normal_1Second_Prog	
	rmb0	sysclk					;WeakMode	开机2sStrong模式
L_Normal_1Second_Prog:	
	JSR		L_Update_Time_Prog
	; JSR		L_Judge_Alarm_Prog
	JSR		L_Alarm_Control_Prog	
	; JSR		L_Auto_1Min_Dis_AlarmMode_Prog	
	JSR		L_1S_Display_Prog
	JMP		L_Judge_Enter_Measure_Temperature_Prog
	; RTS
;===========================================================
L_Judge_Alarm_Prog:
	LDA		R_Mode_Flag
	BNE		L_Exit_Judge_Alarm_Prog		;设置界面不响
	LDA		R_Time_Sec
	BNE		L_Exit_Judge_Alarm_Prog
	BBS0	R_Alarm_Way,L_ALD_Alarm_Prog
	BBS1	R_Alarm_Way,L_ALW5_Alarm_Prog
	BBS2	R_Alarm_Way,L_ALW6_Alarm_Prog	;判断5 6 7天
	RTS
L_ALW5_Alarm_Prog:	
	LDA		R_Time_Week	
	CMP		#6
	Beq		L_Exit_Judge_Alarm_Prog		;Saturday no Alarm Beep
L_ALW6_Alarm_Prog:	
	LDA		R_Time_Week
	BEQ		L_Exit_Judge_Alarm_Prog		;Sunday no Alarm Beep
L_ALD_Alarm_Prog:
	BBS1	Sys_Flag_D,L_Judge_Alarm2_Prog ;Alarm1off
	LDA		R_Time_Hr
	CMP		R_Alarm_Hr1
	BNE		L_Judge_Alarm2_Prog
	LDA		R_Time_Min
	CMP		R_Alarm_Min1
	BEQ		L_Open_Alarm1_Prog
L_Judge_Alarm2_Prog:
	BBS2	Sys_Flag_D,L_Judge_Alarm3_Prog ;Alarm2off	
	LDA		R_Time_Hr
	CMP		R_Alarm_Hr2
	BNE		L_Judge_Alarm3_Prog
	LDA		R_Time_Min
	CMP		R_Alarm_Min2
	BEQ		L_Open_Alarm2_Prog
L_Judge_Alarm3_Prog:
	BBS3	Sys_Flag_D,L_Exit_Judge_Alarm_Prog ;Alarm3off	
	LDA		R_Time_Hr
	CMP		R_Alarm_Hr3
	BNE		L_Exit_Judge_Alarm_Prog
	LDA		R_Time_Min
	CMP		R_Alarm_Min3	
	BNE		L_Exit_Judge_Alarm_Prog
	
	LDA		#2	
	STA		R_Alarm_Mode	

L_Open_Alarm_Prog:
	JSR		L_Clr_Snz_Prog	
	SMB4	Sys_Flag_B		;�������־
	;	EN_LCD_IRQ				;��32HZ�ж�ʹ��
	LDA		#11
	STA		R_Snooze_Times
L_Exit_Judge_Alarm_Prog:
	RTS
	
L_Open_Alarm1_Prog:
	LDA		#0	
	STA		R_Alarm_Mode		
	bra		L_Open_Alarm_Prog
L_Open_Alarm2_Prog:
	LDA		#1	
	STA		R_Alarm_Mode		
	bra		L_Open_Alarm_Prog	
;=========================================================	
L_Alarm_Control_Prog:
	BBR4	Sys_Flag_B,L_End_Alarm_Control_Prog		;����û��
	LDA		R_Alarm_Music
	BNE		L_Alarm_Music_Prog
	;	BBS7	tmrc,L_End_Alarm_Control_Prog
	LDA		R_Time_Sec
	CMP		#$10
	BCC		L_The_First_10_Sec
	CMP		#$20
	BCC		L_The_Seccond_10_Sec
	CMP		#$30
	BCC		L_The_Third_10_Sec
	SMB3	Sys_Flag_B		;�������ֱ�־
	EN_LCD_IRQ				;��32HZ�ж�ʹ��	
L_End_Alarm_Control_Prog:
	RTS	
L_The_First_10_Sec:
	;L_Key_Beep_Prog:
	LDA		#2
L_Beep_Times:	
	STA		R_Voice_Unit
	EN_LCD_IRQ				;��32HZ�ж�ʹ��	
	RTS
L_The_Seccond_10_Sec:
	LDA		#4
	BRA		L_Beep_Times
L_The_Third_10_Sec
L_Key_4Beep_Prog:	
	LDA		#8
	BRA		L_Beep_Times
	
L_Alarm_Music_Prog:
	; BBS7	tmrc,L_End_Alarm_Control_Prog
	xJB		R_SoundCtrl,C_SentencePlayingBit,L_End_Alarm_Control_Prog	
	lda		#D_AlarmRing
	jmp		F_StartPlaySentence		
;=========================================================		
L_Snooze_Control_Prog:		;zz_prog
	BBR4	Sys_Flag_B,L_Jump_Close_Alarm_Prog	;û������
	JSR		L_Clr_Snz_Prog
	JSR		L_Load_Speech_TimeTemp_Prog
L_Jump_Close_Alarm_Prog:	
	LDA		R_SnoozeTime_Minute	
	BEQ		L_End_Snooze_Control_Prog  ;=0����̰˯
	; DEC		R_SnoozeTime_Minute		
	; LDA		R_SnoozeTime_Minute
	SEC		
	LDA		R_SnoozeTime_Minute
	SBC		#1
	STA		R_SnoozeTime_Minute
	BNE		L_End_Snooze_Control_Prog	
	SMB4	Sys_Flag_B				;Alarm turn On
	SMB7	Sys_Flag_C				;̰˯�����־
L_End_Snooze_Control_Prog:
	RTS	
;==========================================================
L_Judge_Enter_Measure_Temperature_Prog:
	BBS4	Sys_Flag_B,L_End_Judge_Enter_Measure_Temperature_Prog	;����ʱ�������¶�	
	BBS7	P_TMRCTRL,L_End_Judge_Enter_Measure_Temperature_Prog	;���������ʱ���������¶�
	LDA		R_Light_Time
	BNE		L_End_Judge_Enter_Measure_Temperature_Prog
	xJB		R_SoundCtrl,C_SentencePlayingBit,L_End_Judge_Enter_Measure_Temperature_Prog
	xJB		R_SoundCtrl,C_StartPlayBit,L_End_Judge_Enter_Measure_Temperature_Prog
	LDA		R_Time_Sec	
	; AND		#$0F
	EOR		#$30
	BNE		L_End_Judge_Enter_Measure_Temperature_Prog
L_Give_Measure_Temperature_Value:	
	LDA		#5
	STA		R_Measure_Temperature		;��30���һ����
	EN_LCD_IRQ			;��32HZ�ж�ʹ��			
L_End_Judge_Enter_Measure_Temperature_Prog:
	RTS	
;==========================================================	
L_Enter_ChimeBeep_Prog:		;整点报时	chimebeep
	BBR4	Sys_Flag_C,L_End_Enter_ChimeBeep_Prog
	LDA		R_Time_Hr
	CMP		#$07
	BCC		L_End_Enter_ChimeBeep_Prog
	LDA		R_Time_Hr
	CMP		#$22	
	BCS		L_End_Enter_ChimeBeep_Prog
	JSR		F_StopSoundPro	
	JMP		L_Load_Speech_TimeTemp_Prog	
L_End_Enter_ChimeBeep_Prog:
	RTS
;==========================================================	
L_Update_Time_Prog:	
	JSR		L_Update_Time_Sec_Prog
	BCC		L_End_Update_Time_Prog
	; JSR		L_Snooze_Control_Prog	
	JSR		L_Update_Time_Min_Prog
	BCC		L_End_Update_Time_Min_Prog	;L_Snooze_Control_Prog		;L_End_Update_Time_Prog
	; JSR		L_Snooze_Control_Prog

	JSR		L_Update_Time_Hr_Prog
	BCC		L_End_Update_Time_Hr_Prog ;L_Enter_ChimeBeep_Prog		;L_End_Update_Time_Prog
	JSR		L_Update_Time_Day_Prog
	BCC		L_End_Update_Date_Prog
	; INC		R_Time_Day
	JSR		L_Update_Time_Month_Prog
	BCC		L_End_Update_Date_Prog
	; INC		R_Time_Month
	JSR		L_Update_Time_Year_Prog
L_End_Update_Date_Prog:
	JSR		L_Auto_Counter_Week
	JSR		F_GongLiChangeToNongLi

L_End_Update_Time_Hr_Prog:
	JSR		L_Enter_ChimeBeep_Prog
L_End_Update_Time_Min_Prog:
	JSR		L_Snooze_Control_Prog
	JSR		L_Judge_Alarm_Prog
L_End_Update_Time_Prog:
	RTS
	
;----------------------------------------------------
L_Update_Time_Year_Prog:
	LDX		#(R_Time_Year-Time_Str_Addr)
	LDA		#$99
	JMP		L_Inc_To_Any_Count_Prog
L_Dec_Time_Year_Prog:
	LDX		#(R_Time_Year-Time_Str_Addr)	
	LDA		#$99

	JMP		L_Dec_To_0_Prog
	; JSR		L_Judge_MaxDay_Prog
	; ?rts:
	; 	rts
;----------------------------------------------------
L_Update_Time_Month_Prog:
	LDX		#(R_Time_Month-Time_Str_Addr)
	LDA		#$12
	JMP		L_Inc_To_Any_Count_Prog_To_1
L_Dec_Time_Month_Prog:
	LDX		#(R_Time_Month-Time_Str_Addr)
	LDA		#$12
	JSR		L_Dec_To_1_Prog

	JSR		L_Check_MaxDay_Prog
	STA		P_Temp+5
	CMP		R_Time_Day
	BCS		L_Dec_Time_Month_Prog_RTS
	LDA		P_Temp+5
	STA		R_Time_Day
L_Dec_Time_Month_Prog_RTS:
	RTS
;----------------------------------------------------
L_Update_Time_Day_Prog:
	JSR		L_Check_MaxDay_Prog
	LDX		#(R_Time_Day-Time_Str_Addr)	
	JMP		L_Inc_To_Any_Count_Prog_To_1
L_Dec_Time_Day_Prog:
	JSR		L_Check_MaxDay_Prog
	LDX		#(R_Time_Day-Time_Str_Addr)
	JMP		L_Dec_To_1_Prog
	; RTS
;-------------------------------------------------
L_Check_MaxDay_Prog:
	LDA		R_Time_Month
	JSR		L_DToHx_Prog
	TAX	
	DEX			;
	BBS3	Sys_Flag_A,L_Check_LeapYear_MaxDay
	LDA		T_NonLeapYear_Month,X	
	RTS
L_Check_LeapYear_MaxDay:
	LDA		T_LeapYear_Month,X
	RTS	
;----------------------------------------------------
L_Update_Time_Hr_Prog:
	LDX		#(R_Time_Hr-Time_Str_Addr)	
	LDA		#$23
	JMP		L_Inc_To_Any_Count_Prog
L_Dec_Time_Hr_Prog:
	LDX		#(R_Time_Hr-Time_Str_Addr)
	LDA		#$23
	JMP		L_Dec_To_0_Prog
	; RTS
;----------------------------------------------------
L_Update_Time_Min_Prog:
	LDX		#(R_Time_Min-Time_Str_Addr)
	JMP		L_Inc_To_60_Prog
L_Dec_Time_Min_Prog:
	LDX		#(R_Time_Min-Time_Str_Addr)
	JMP		L_Dec_To_60_Prog
	; RTS
;----------------------------------------------------		
L_Update_Time_Sec_Prog:
	LDX 	#(R_Time_Sec-Time_Str_Addr)
L_Inc_To_60_Prog:
	LDA		#$59	
L_Inc_To_Any_Count_Prog:
	; CMP		Time_Addr,X
	SEC
	SBC		Time_Addr,X
	BEQ		L_Inc_Over_Prog
L_Inc_RamX_Prog:
	CLC
	SED
	LDA		Time_Addr,X
	ADC		#1
	STA		Time_Addr,X
	CLD
	RTS
L_Inc_Over_Prog:
	LDA		#0
L_Inc_Sta_Ram_Prog
	STA		Time_Addr,X
	RTS


L_Inc_Over_Prog_To_1:
	LDA		#1
	BRA		L_Inc_Sta_Ram_Prog
L_Inc_To_Any_Count_Prog_To_1:
	SEC
	SBC		Time_Addr,X
	BEQ		L_Inc_Over_Prog_To_1
	; BCC		L_Inc_Over_Prog_To_1
	BRA		L_Inc_RamX_Prog




;----------------------------------------------------
L_Dec_To_60_Prog:
	LDA		#$59
L_Dec_To_0_Prog:
	STA		P_Temp
	LDA		#0
	BRA		L_Dec_To_Anycount_Prog
L_Dec_To_1_Prog:
	STA		P_Temp
	LDA		#1
L_Dec_To_Anycount_Prog:
	SEC
	SBC		Time_Addr,X

	BEQ		L_Dec_Over_Prog
	
	SEC
	SED
	LDA		Time_Addr,X
	SBC		#1
	STA		Time_Addr,X
	CLD
	RTS
L_Dec_Over_Prog:
	CLC
	LDA		P_Temp
	STA		Time_Addr,X	
L_End_Dec_To_60_Prog:
	RTS
;-------------------------------------------------
L_Auto_Counter_Week:
	JSR		L_Check_LeapYear_Prog
	LDA		R_Time_Month
	JSR		L_DToHx_Prog
	TAX	
	LDA		T_Month_Week,X
	STA		P_Temp+1
	BBR3	Sys_Flag_A,L_Counter_Week_2
	; LSR		P_Temp+1
	; LSR		P_Temp+1
	; LSR		P_Temp+1
	; LSR		P_Temp+1
	clc
	ror		P_Temp+1
	clc
	ror		P_Temp+1
	clc
	ror		P_Temp+1
	clc
	ror		P_Temp+1	
L_Counter_Week_2:
	LDA		#$0F
	AND		P_Temp+1
	STA		P_Temp+1
	LDA		#$7
	AND		P_Temp
	SED
	CLC
	ADC		P_Temp+1
	ADC		R_Time_Day
	STA		P_Temp
L_Loop_WeekSub_7:
	SEC
	LDA		P_Temp
	SBC		#7
	BCC		L_End_Counter_Week
	STA		P_Temp
	BRA		L_Loop_WeekSub_7
L_End_Counter_Week:
	CLD
	LDA		P_Temp		;����ÿ���¶��Ǵ�1����
	BEQ		L_SetWeek_Sat
	DEC		P_Temp
	BRA		L_Exit_Counter_Week
L_SetWeek_Sat:
	LDA		#6
	STA		P_Temp
L_Exit_Counter_Week:
	LDA		P_Temp
	STA		R_Time_Week
	RTS
;-------------------------------------------------
L_Check_LeapYear_Prog:
	LDA		R_Time_Year
	JSR		L_DToHx_Prog
	STA		P_Temp
	; LSR		P_Temp
	clc
	ror		P_Temp
	LDX		P_Temp
	LDA		T_LeapYear_Week,X
	STA		P_Temp
	BBR0	R_Time_Year,L_Counter_LeapYear
	; LSR		P_Temp
	; LSR		P_Temp
	; LSR		P_Temp
	; LSR		P_Temp	
	clc
	ror		P_Temp
	clc
	ror		P_Temp
	clc
	ror		P_Temp
	clc
	ror		P_Temp	
L_Counter_LeapYear:
	LDA		#$08
	AND		P_Temp
	STA		P_Temp+1
	LDA		#$F7
	AND		Sys_Flag_A
	ORA		P_Temp+1
	STA		Sys_Flag_A	; ���������־
	RTS
;-------------------------------------------------
L_DToHx_Prog:		;ʮ����תʮ�����Ƴ���
	STA		P_Temp+6
	AND		#$F0
	STA		P_Temp+7
	LDA		#$0F
	AND		P_Temp+6
	STA		P_Temp+6
L_Loop_DToHx_Prog:
	LDA		P_Temp+7
	BEQ		L_End_DToHx_Prog
	SEC
	SBC		#$10
	STA		P_Temp+7
	CLC
	LDA		#$0A
	ADC		P_Temp+6
	STA		P_Temp+6
	BRA		L_Loop_DToHx_Prog
L_End_DToHx_Prog:
	LDA		P_Temp+6
	RTS
;-------------------------------------------------
T_LeapYear_Week:
	DB		1EH   ;2001,2000 ;E="1110"����2000��1��1����������(110),������(1)
	DB		32H   ;2003,2002
	DB		6CH   ;2005,2004
	DB		10H   ;2007,2006
	DB		4AH   ;2009,2008
	DB		65H   ;2011,2010
	DB		28H   ;2013,2012
	DB		43H   ;2015,2014
	DB		0DH   ;2017,2016
	DB		21H   ;2019,2018
	DB		5BH   ;2021,2020
	DB		06H   ;2023,2022
	DB		39H   ;2025,2024
	DB		54H   ;2027,2026
	DB		1EH   ;2029,2028
	DB		32H   ;2031,2030
	DB		6CH   ;2033,2032
	DB		10H   ;2035,2034
	DB		4AH   ;2037,2036
	DB		65H   ;2039,2038
	DB		28H   ;2041,2040
	DB		43H   ;2043,2042
	DB		0DH   ;2045,2044
	DB		21H   ;2047,2046
	DB		5BH   ;2049,2048
	DB		06H   ;2051,2050
	DB		39H   ;2053,2052
	DB		54H   ;2055,2054
	DB		1EH   ;2057,2056
	DB		32H   ;2059,2058
	DB		6CH   ;2061,2060
	DB		10H   ;2063,2062
	DB		4AH   ;2065,2064
	DB		65H   ;2067,2066
	DB		28H   ;2069,2068
	DB		43H   ;2071,2070
	DB		0DH   ;2073,2072
	DB		21H   ;2075,2074
	DB		5BH   ;2077,2076
	DB		06H   ;2079,2078
	DB		39H   ;2081,2080
	DB		54H   ;2083,2082
	DB		1EH   ;2085,2084
	DB		32H   ;2087,2086
	DB		6CH   ;2089,2088
	DB		10H   ;2091,2090
	DB		4AH   ;2093,2092
	DB		65H   ;2095,2094
	DB		28H   ;2097,2096
	DB		43H   ;2099,2098
;-----------------------------------------------
T_Month_Week:
	DB		00H   	
	DB		00H   ;JANUARY		��1��1�տ�ʼ������1��Ϊ0
	DB		33H   ;FABRUARY 	��4BitΪ�����꣬��4BitΪ����
	DB		43H   ;MARCH
	DB		76H   ;APRIL
	DB		21H   ;MAY
	DB		54H   ;JUNE
	DB		76H   ;JULY
	DB		32H   ;AUGUST
	DB		65H   ;SEPTEMBER
	DB		10H   ;OCTOBER
	DB		43H   ;NOVEMBER
	DB		65H   ;DECEMBER  
;-----------------------------------------------
T_LeapYear_Month:
	DB		31H		;1
	DB		29H		;2
	DB		31H		;3
	DB		30H		;4
	DB		31H		;5
	DB		30H		;6
	DB		31H		;7
	DB		31H		;8
	DB		30H		;9
	DB		31H		;10
	DB		30H		;11
	DB		31H		;12
;-----------------------------------------------
T_NonLeapYear_Month:
	DB		31H		;1
	DB		28H		;2
	DB		31H		;3
	DB		30H		;4
	DB		31H		;5
	DB		30H		;6
	DB		31H		;7
	DB		31H		;8
	DB		30H		;9
	DB		31H		;10
	DB		30H		;11
	DB		31H		;12	         
;-----------------------------------------------
L_AutoExitSet_Prog:
	LDA		R_SetTime
	BEQ		L_Exit_AutoExitSet_Prog
	DEC		R_SetTime
	LDA		R_SetTime
	BNE		L_Exit_AutoExitSet_Prog	
	LDA		#0
	STA		R_Mode_Flag
	BC		FLAG_AlarmSet,Bit_AlarmSet,1
	; LDA		R_Mode_Flag
	; BEQ		L_End_AutoExitSet_Prog
	; STZ		R_SetFlag
	; LDA		R_Mode_Flag
	; BEQ		L_Exit_AutoExitSet_Prog

L_End_AutoExitSet_Prog:	
	; STZ		R_Mode_Flag		;�Զ�����ʱ��ģʽ
	JMP		L_Display_Prog
L_Init_SetTime_Prog:
	LDA		R_Mode_Flag
	BEQ		L_Exit_AutoExitSet_Prog
	LDA		#60
	STA		R_SetTime
L_Exit_AutoExitSet_Prog:
	RTS	
;=======================================================


;-------------------------------------------------------
; L_Auto_1Min_Dis_AlarmMode_Prog:		;SMART_ALARM_DISP
; 	lda		R_Time_Sec
; 	bne		L_End_Auto_Dis_AlarmMode_Prog

; 	BBS4	Sys_Flag_B,L_End_Auto_Dis_AlarmMode_Prog	;������
; 	LDA		R_SnoozeTime_Minute
; 	BNE		L_End_Auto_Dis_AlarmMode_Prog  				;=0����̰˯

; L_Auto_Dis_AlarmMode_Prog:	
; 	LDA		R_Mode_Flag
; 	cmp		#1
; 	BNE		F_Skip
; L_End_Auto_Dis_AlarmMode_Prog:		
; 	RTS
; F_Skip:	
; 	LDA		Sys_Flag_D
; 	AND		#$0E
; 	BEQ		?AllAlarmOn
; 	CMP		#$0C
; 	BEQ		L_Alarm1_Mode
; 	CMP		#$0A
; 	BEQ		L_Alarm2_Mode
; 	CMP		#$06
; 	BEQ		L_Alarm3_Mode
; 	JMP		L_2AlarmOn		;ON/OFF
; ?AllAlarmOn:	
; 	JSR		L_Gain_Alarm1_Value
; 	LDA		P_Temp+5	
; 	STA		P_Temp+1
; 	LDA		P_Temp+6	
; 	STA		P_Temp+2
; 	JSR		L_Gain_Alarm2_Value
; 	LDA		P_Temp+5	
; 	STA		P_Temp+3
; 	LDA		P_Temp+6	
; 	STA		P_Temp+4
; 	JSR		L_Gain_Alarm3_Value
; L_Alarm1_Sub_Alarm2:
; 	sec
; 	lda		P_Temp+2
; 	sbc		P_Temp+4
; 	beq		L_Compare_A1_Sub_A2_Min
; 	bcc		L_Alarm1_Sub_Alarm3		;L_Alarm2_Sub_Alarm3
; 	jmp		L_Alarm2_Sub_Alarm3		;L_Alarm1_Sub_Alarm3
; L_Compare_A1_Sub_A2_Min:	
; 	sec
; 	lda		P_Temp+1
; 	sbc		P_Temp+3
; 	beq		L_Alarm1_Sub_Alarm3
; 	bcs		L_Alarm2_Sub_Alarm3
; L_Alarm1_Sub_Alarm3:
; 	sec
; 	lda		P_Temp+2
; 	sbc		P_Temp+6
; 	beq		L_Compare_A1_Sub_A3_Min	
; 	bcc		L_Alarm1_Mode	;L_Alarm3_Mode
; 	jmp		L_Alarm3_Mode	;L_Alarm1_Mode	
; L_Compare_A1_Sub_A3_Min:
; 	sec
; 	lda		P_Temp+1
; 	sbc		P_Temp+5
; 	beq		L_Alarm1_Mode	;L_Alarm3_Mode
; 	bcc		L_Alarm1_Mode
; 	jmp		L_Alarm3_Mode	;L_Alarm1_Mode		

; L_Alarm2_Sub_Alarm3:
; 	sec
; 	lda		P_Temp+4
; 	sbc		P_Temp+6
; 	beq		L_Compare_A2_Sub_A3_Min	
; 	bcc		L_Alarm2_Mode	;L_Alarm3_Mode
; 	jmp		L_Alarm3_Mode	;L_Alarm2_Mode
; L_Compare_A2_Sub_A3_Min:
; 	sec
; 	lda		P_Temp+3
; 	sbc		P_Temp+5
; 	beq		L_Alarm2_Mode
; 	bcc		L_Alarm2_Mode
; 	jmp		L_Alarm3_Mode	
	
; L_Alarm1_Mode:
; 	LDA		#0
; L_Enter_AlarmMode:	
; 	STA		R_Alarm_Mode
; 	RTS
	
; L_Alarm2_Mode:
; 	LDA		#1
; 	jmp		L_Enter_AlarmMode		
; L_Alarm3_Mode:
; 	LDA		#2
; 	jmp		L_Enter_AlarmMode

; L_2AlarmOn:
; 	CMP		#$08
; 	BEQ		?Alarm12
; 	CMP		#$04
; 	BEQ		?Alarm13
; 	CMP		#$02
; 	BEQ		?Alarm23
; 	JMP		L_Alarm1_Mode
	
; ?Alarm23:
; 	JSR		L_Gain_Alarm2_Value
; 	LDA		P_Temp+5	
; 	STA		P_Temp+3
; 	LDA		P_Temp+6	
; 	STA		P_Temp+4
; 	JSR		L_Gain_Alarm3_Value
; 	JMP		L_Alarm2_Sub_Alarm3
; ?Alarm13:
; 	JSR		L_Gain_Alarm1_Value
; 	LDA		P_Temp+5	
; 	STA		P_Temp+1
; 	LDA		P_Temp+6	
; 	STA		P_Temp+2	
; 	JSR		L_Gain_Alarm3_Value	
; 	JMP		L_Alarm1_Sub_Alarm3	
; ?Alarm12:
; 	JSR		L_Gain_Alarm1_Value
; 	LDA		P_Temp+5	
; 	STA		P_Temp+1
; 	LDA		P_Temp+6	
; 	STA		P_Temp+2
; 	JSR		L_Gain_Alarm2_Value
; 	LDA		P_Temp+5	
; 	STA		P_Temp+3
; 	LDA		P_Temp+6	
; 	STA		P_Temp+4
	
; 	sec
; 	lda		P_Temp+2
; 	sbc		P_Temp+4
; 	beq		?L_Compare_A1_Sub_A2_Min
; 	bcc		L_Alarm1_Mode		
; 	jmp		L_Alarm2_Mode
; ?L_Compare_A1_Sub_A2_Min:	
; 	sec
; 	lda		P_Temp+1
; 	sbc		P_Temp+3
; 	beq		L_Alarm1_Mode
; 	bcs		L_Alarm2_Mode
; 	JMP		L_Alarm1_Mode
; ;-------------------------------------------------------
; L_Gain_Alarm1_Value:
; 	lda		R_Alarm_Min1
; 	sta		P_Temp+14	
; 	lda		R_Alarm_Hr1
; 	sta		P_Temp+15	
; 	BRA		L_Auto_Alarm_Mode_Cale	
	
; L_Gain_Alarm2_Value:
; 	lda		R_Alarm_Min2
; 	sta		P_Temp+14	
; 	lda		R_Alarm_Hr2
; 	sta		P_Temp+15	
; 	BRA		L_Auto_Alarm_Mode_Cale		
	
; L_Gain_Alarm3_Value:
; 	lda		R_Alarm_Min3
; 	sta		P_Temp+14	
; 	lda		R_Alarm_Hr3
; 	sta		P_Temp+15		
; L_Auto_Alarm_Mode_Cale:
; 	SED
; 	SEC
; 	LDA		P_Temp+14
; 	SBC		R_Time_Min
; 	BCC		L_Alarm_Hr_Dec1
; 	STA		P_Temp+5
; L_Alarm_Hr:	
; 	SEC
; 	LDA		P_Temp+15	
; 	SBC		R_Time_Hr
; 	BCC		L_Alarm_Hr_ADD24
; 	STA		P_Temp+6
; 	CLD
; 	RTS
; L_Alarm_Hr_ADD24:
; 	CLC
; 	LDA		P_Temp+15
; 	ADC		#$24
; 	SEC
; 	SBC		R_Time_Hr
; 	STA		P_Temp+6
; 	CLD
; 	RTS
; L_Alarm_Hr_Dec1:
; 	LDA		P_Temp+15
; 	BNE		L_Continue
; 	LDA		#$24
; L_Continue:	
; 	SEC	
; 	SBC		#1
; 	STA		P_Temp+15
; 	SEC
; 	LDA		#$60	
; 	SBC		R_Time_Min
; 	CLC
; 	ADC		P_Temp+14
; 	STA		P_Temp+5
; 	BRA		L_Alarm_Hr




	