AXing_Port	EQU		%00011111
BXing_Port	EQU		%10111100
CXing_Port	EQU		%00111000

D_Key3S		EQU		3*32

KNOB_Forw	.EQU	%00000100   ;A
KNOB_Reve	.EQU	%00000010   ;B


CMD_Reve    .EQU    1
CMD_Forw    .EQU    2
;==================================================
L_LCD_IRQ_WorkProg:
	BBR2	Sys_Flag_A,L_END_LCD_IRQ_WorkProg
	RMB2	Sys_Flag_A
	JSR		L_Judge_Measure_Temperature_Prog
	LDA		R_Reset_Time
	BNE		L_END_LCD_IRQ_WorkProg	
	JSR		L_VoiceBeep_Control_Prog

	xJB		Flag_KeyXing,Bit_AXing,L_Scankey_AXing_prog
	xJB		Flag_KeyXing,Bit_BXing,L_Scankey_BXing_prog
	xJB		Flag_KeyXing,Bit_CXing,L_Scankey_CXing_prog			
L_END_LCD_IRQ_WorkProg:
    RTS
;============================================================
L_Scankey_AXing_prog:
	JSR		L_AScanKeyPort_Init
	JSR		L_ScanKey_Delay_Prog
	LDA		PA
	AND		#AXing_Port
	STA		P_Temp


	LDA		P_Temp
	BEQ		L_NullKey_AXing_Prog
	CMP		R_Key_Value
	BEQ		L_AXing_Key_			
	STA		R_Key_Value
	RTS
L_AXing_Key_:
	xJB		FLAG_KEYSTOP,BIT_KEYSTOP,L_Scankey_AXing_prog_End
	
	xJB		P_Temp,0,L_TimeSet_Enter
	xJB		P_Temp,1,L_AlarmSet_Enter
	xJB		P_Temp,2,L_Up_Enter
	xJB		P_Temp,3,L_Down_Enter
	xJB		P_Temp,4,L_Snz_Enter
L_Scankey_AXing_prog_End:
	RTS

L_TimeSet_Enter:
	JMP		L_TimeSet_Prog
L_AlarmSet_Enter:
	JMP		L_AlarmSet_Prog
L_Up_Enter:
	JMP		L_Up_Prog
L_Down_Enter:
	JMP		L_Down_Prog
L_Snz_Enter:
	JMP		L_Snz_Prog
;----------------------------------------------
L_NullKey_AXing_Prog:
	JSR		L_ReLease_TimeSetKey
	JSR		L_ReLease_AlarmSetKey
	JSR		L_ReLease_UpKey
	JSR		L_ReLease_DownKey
	JSR		L_ReLease_SnzKey
	JMP		L_NullKey_Prog
;============================================================
L_Scankey_CXing_prog
	JSR		L_CScanKeyPort_Init
	JSR		L_ScanKey_Delay_Prog
	LDA		PA
	AND		#CXing_Port
	STA		P_Temp
	BEQ		L_NullKey_CXing_Prog
	CMP		R_Key_Value
	BEQ		L_CXing_Key_			
	STA		R_Key_Value
	RTS

L_CXing_Key_:
	xJB		P_Temp,3,L_TimeSet_Enter
	xJB		P_Temp,4,L_Snz_Enter
	xJB		P_Temp,5,L_AlarmSet_Enter
	RTS

L_NullKey_CXing_Prog:
	; RMB4	Sys_Flag_A		
	JSR		L_ReLease_TimeSetKey
	JSR		L_ReLease_AlarmSetKey
	JSR		L_ReLease_SnzKey
	JMP		L_NullKey_Prog


;============================================================
L_Scankey_BXing_prog:
L_Scankey_prog:
	JSR		L_BScanKeyPort_Init
	JSR		L_ScanKey_Delay_Prog
	LDA		PA
	AND		#BXing_Port
	STA		P_Temp

	beq		L_NullKey_BXing_Prog
	CMP		R_Key_Value
	BEQ		L_BXing_Key_			
	STA		R_Key_Value
	RTS
L_BXing_Key_:

	xJB		P_Temp,2,L_12Hr_24Hr_Or_Year_Enter
	xJB		P_Temp,3,L_Min_Day_Adjust_Enter
	xJB		P_Temp,4,L_Hr_Or_Month_Adjust_Enter
	xJB		P_Temp,5,L_CF_Adjust_Enter
	xJB		P_Temp,7,L_Talk_Snz_Light_Enter
	rts

	; L_Reapeat_Key:	
	; 	SMB1	Sys_Flag_B	
	; 	RMB2	Sys_Flag_B	
	; L_End_Scankey_prog:	
	; 	RTS
;============================================================
L_NullKey_BXing_Prog:
	JSR		L_Judge_Choose_AlarmMusic
	JSR		L_Judge_12Switch24_Prog
	JSR		L_Judge_CF_Prog
	JSR		L_Judge_Load_Speech
L_NullKey_Prog:
	RMB4	Sys_Flag_A		;�尴�����ֱ�־
	BC		FLAG_KEYSTOP,BIT_KEYSTOP,1
	LDA		#0
	STA		R_KeyHold_Time
	STA		R_Key_Value
	RMB0	Sys_Flag_C		
	RMB1	Sys_Flag_C	
	RMB5	Sys_Flag_C		
	RMB6	Sys_Flag_C
	RMB5	Sys_Flag_D		
	RMB6	Sys_Flag_D
	RMB0	Sys_Flag_B		;��Ƶ��־	
	RMB1	Sys_Flag_B		
	RMB2	Sys_Flag_B		;add1	
	LDA		R_Voice_Unit
	BNE		L_End_Nullkey_Prog
	BBS4	Sys_Flag_B,L_End_Nullkey_Prog	;Alarm on
	LDA		R_Measure_Temperature			;�������򲻹�LCD_Int
	BNE		L_End_Nullkey_Prog
	CLR_LCD_IRQ_FLAG	
	DIS_LCD_IRQ								;��32HZ�ж�ʹ��
	CLR_KEY_IRQ_FLAG
	EN_KEY_IRQ
L_End_Nullkey_Prog:	
	RTS
;------------------------------------------------------------
L_12Hr_24Hr_Or_Year_Enter:
	JMP		L_12Hr_24Hr_Or_Year_Prog		
L_Hr_Or_Month_Adjust_Enter:
	JMP		L_Hr_Or_Month_Adjust_Prog
L_CF_Adjust_Enter:
	JMP		L_CF_Adjust_Prog
L_Talk_Snz_Light_Enter:
	JMP		L_Snz_Light_Prog
L_Min_Day_CF_Adjust_Enter:
	JMP		L_Min_Day_CF_Adjust_Prog	
L_Min_Day_Adjust_Enter:
	JMP		L_Min_Day_Adjust_Prog
;============================================================
;-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;L_12Hr_24Hr_Or_Year_Prog;;;;;;;;;;;;;;;;;;
;-----------------------------------------------------------
L_Judge_12Hr_24Hr_Or_Year_3S_Prog:
	LDA		R_Mode_Flag
	BEQ		L_Judge_Mode0_12Hr_24Hr_Or_Year_3S_Prog
	JMP		L_Judge_12Hr_24Hr_Or_Year_2S_Prog
L_Judge_Mode0_12Hr_24Hr_Or_Year_3S_Prog:	
	LDA		R_KeyHold_Time
	CMP		#96		;��������3S
	BCS		L_Judge_Chime_Prog
	JMP		L_Inc_KeyHold_Time
L_Judge_Chime_Prog:
	bbs6	Sys_Flag_C,L_End_Judge_Chime_Prog
	JSR		F_StopSoundPro		
	JSR		L_Key_BeepOn_Prog
	SMB6	Sys_Flag_C
	BBS4	Sys_Flag_C,L_Close_Chime
	SMB4	Sys_Flag_C
	jmp		L_Dis_Chime_Dot
L_Close_Chime:
	RMB4	Sys_Flag_C
	jsr		L_Clr_Chime_Dot
L_End_Judge_Chime_Prog:	
	RTS	
L_Set_KeyYear_PressFlag:
	SMB5	Sys_Flag_C	
	RTS
	
L_Judge_12Switch24_Prog:
	BBR5	Sys_Flag_C,L_End_Judge_Chime_Prog
	BBS6	Sys_Flag_C,L_End_Judge_Chime_Prog
	JMP		L_Time_12Switch24_Prog
	
	
L_12Hr_24Hr_Or_Year_Prog:
	BBS4	Sys_Flag_A,L_Judge_12Hr_24Hr_Or_Year_3S_Prog
	SMB4	Sys_Flag_A		;
	BBS4	Sys_Flag_B,L_12Hr_24Hr_Or_Year_Clr_Alarm_Prog	
	LDA		R_Snooze_Times
	BNE		L_12Hr_24Hr_Or_Year_Clr_Alarm_Prog	
	; JSR		L_Clr_Snz_Prog
	JSR		F_StopSoundPro	

	LDA		R_Mode_Flag
	BEQ		L_Set_KeyYear_PressFlag
	
	CMP		#1
	BEQ		L_Alarm_OnOrOff
	
	CMP		#2
	BNE		L_Time_12Switch24_Prog
L_Year_FastAdd_Prog:
	SMB2	Sys_Flag_B
	JSR		L_Judge_Key_Beep_Prog	;L_Key_Beep_Prog		
	JSR		L_Update_Time_Year_Prog
L_Update_Year_Disp_Prog:
	JSR		L_Check_LeapYear_Prog
L_End_KeyUpdate_Prog:
L_Update_YMD_Disp_Prog:
	JSR		L_Auto_Adjust_MaxDay
	JSR		L_Auto_Counter_Week
	JSR		F_GongLiChangeToNongLi
	JSR		L_Dis_Week_Prog
	JSR		L_Dis_MonthDay_Prog
	JMP		L_Dis_TimeYear_Prog		
L_End_12Hr_24Hr_Or_Year_Prog:	
	RTS
	
L_Judge_12Hr_24Hr_Or_Year_2S_Prog:
	LDA		R_Mode_Flag
	EOR		#2
	BNE		L_End_12Hr_24Hr_Or_Year_Prog
	LDA		#1
	JMP		L_SetFast_Prog
	
L_12Hr_24Hr_Or_Year_Clr_Alarm_Prog:
	JMP		L_Clr_Snz_Prog	

L_Alarm_OnOrOff:
	BBS0	R_Alarm_Mode,?Alarm2
	BBS1	R_Alarm_Mode,?Alarm3
?Alarm1:
	BBS1	Sys_Flag_D,?Alarm1On
	SMB1	Sys_Flag_D
	JSR		L_Key_Beep_Prog	
	JMP		L_Dis_AlarmTime_Prog	
?Alarm1On:
	RMB1	Sys_Flag_D
	JSR		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Dis_AlarmTime_Prog

?Alarm2:
	BBS2	Sys_Flag_D,?Alarm2On
	SMB2	Sys_Flag_D
	JSR		L_Key_Beep_Prog	
	JMP		L_Dis_AlarmTime_Prog	
?Alarm2On:
	RMB2	Sys_Flag_D
	JSR		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Dis_AlarmTime_Prog	

?Alarm3:
	BBS3	Sys_Flag_D,?Alarm3On
	SMB3	Sys_Flag_D
	JSR		L_Key_Beep_Prog	
	JMP		L_Dis_AlarmTime_Prog	
?Alarm3On:
	RMB3	Sys_Flag_D
	JSR		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Dis_AlarmTime_Prog	
;---------------------------------------
L_Time_12Switch24_Prog:
	JSR		L_Key_Beep_Prog	
	BBS5	Sys_Flag_A,L_24Hr_Flag_Prog
	SMB5	Sys_Flag_A
L_Update_Am_Pm_Prog:	
	JSR		L_Dis_Time_Prog
	JMP		L_Dis_AlarmTime_Prog		
L_24Hr_Flag_Prog:
	RMB5	Sys_Flag_A	
	JMP		L_Update_Am_Pm_Prog
;------------------------------------------------------------
;;;;;;;;;;;;;;;;;;L_Hr_Or_Month_Adjust_Prog;;;;;;;;;;;;;;;;;;
;------------------------------------------------------------
L_Judge_Hr_Or_Month_3S_Prog:
	LDA		R_Mode_Flag
	BEQ		L_Judge_Mode0_Hr_Or_Month_3S_Prog
	JMP		L_Judge_Hr_Or_Month_2S_Prog
L_Judge_Mode0_Hr_Or_Month_3S_Prog:	
	LDA		R_KeyHold_Time
	CMP		#96			;��������3S
	BCS		L_Close_Voice_Speech
	JMP		L_Inc_KeyHold_Time
	
L_Close_Voice_Speech:
	bbs1	Sys_Flag_C,L_End_Close_Voice_Speech
	JSR		F_StopSoundPro		
	JSR		L_Key_Beep_Prog
	SMB1	Sys_Flag_C
	BBR7	Sys_Flag_B,L_Close_Speech
	RMB7	Sys_Flag_B
	jmp		L_Judge_Dis_Speech_Off_Flag
L_Close_Speech:
	SMB7	Sys_Flag_B
	jsr		L_Judge_Dis_Speech_Off_Flag	
L_End_Close_Voice_Speech:	
	RTS			
;-----------------------------------------
L_Hr_Or_Month_Adjust_Prog:
	;	BBS4	Sys_Flag_A,L_Judge_Hr_Or_Month_2S_Prog
	BBS4	Sys_Flag_A,L_Judge_Hr_Or_Month_3S_Prog
	SMB4	Sys_Flag_A		;���ð������ֱ�־
	BBS4	Sys_Flag_B,L_Hr_Or_Month_Clr_Alarm_Prog	;��������������
	LDA		R_Snooze_Times
	BNE		L_Hr_Or_Month_Clr_Alarm_Prog	
	
	JSR		F_StopSoundPro	
	
	;	JSR		L_Clr_Snz_Prog
L_Hr_Or_Month_FastAdd_Prog:	
	LDA		R_Mode_Flag
	BEQ		L_Hr_Or_Month_Key	;L_Choose_AlarmMusic
	SMB2	Sys_Flag_B
	LDA		R_Mode_Flag	
	CMP		#1
	BEQ		L_AlarmTime_Hr_Up_Prog
	CMP		#2
	BEQ		L_Time_Month_Up_Prog	
L_Time_Hr_Up_Prog:
	JSR		L_Update_Time_Hr_Prog

	JSR		L_Load_Speech_Hr_Prog		
	LDA		#0
	STA		R_Time_Sec		;���ӵ������塰0��	
	jmp		L_Dis_Time_Prog

L_Hr_Or_Month_Clr_Alarm_Prog:
	JMP		L_Clr_Snz_Prog	

L_Hr_Or_Month_Key:
	SMB0	Sys_Flag_C
L_End_Hr_Or_Month_Key:	
	RTS
	
L_Judge_Choose_AlarmMusic:
	bbr0	Sys_Flag_C,L_End_Hr_Or_Month_Key	
	bbs1	Sys_Flag_C,L_End_Hr_Or_Month_Key	
L_Choose_AlarmMusic:
	LDA		R_Alarm_Music
	CMP		#6+2
	BCS		L_Alarm_Music0

	CLC
	LDA		R_Alarm_Music
	ADC		#1
	STA		R_Alarm_Music

	JSR		F_StopSoundPro		
	lda		#D_AlarmRing
	jmp		F_StartPlaySentence		
L_Alarm_Music0:
	LDA		#0
	STA		R_Alarm_Music
	JMP		L_Key_4Beep_Prog	
;-----------------------------------------		
L_AlarmTime_Hr_Up_Prog:
	BBS0	R_Alarm_Mode,L_Alarm2_Hr_Up
	BBS1	R_Alarm_Mode,L_Alarm3_Hr_Up
L_Alarm1_Hr_Up:
	BBS1	Sys_Flag_D,L_AlarmOff
	LDX		#(R_Alarm_Hr1-Time_Str_Addr)
L_AlarmTime_Hr_Up_Common:
	LDA		#$23
	JSR		L_Inc_To_Any_Count_Prog
	
	JSR		L_Load_Speech_Hr_Prog	
	
	JMP		L_Dis_AlarmTime_Prog
L_Alarm2_Hr_Up:
	BBS2	Sys_Flag_D,L_AlarmOff
	LDX		#(R_Alarm_Hr2-Time_Str_Addr)
	jmp		L_AlarmTime_Hr_Up_Common
L_Alarm3_Hr_Up:
	BBS3	Sys_Flag_D,L_AlarmOff
	LDX		#(R_Alarm_Hr3-Time_Str_Addr)
	jmp		L_AlarmTime_Hr_Up_Common

L_AlarmOff:
	RMB0	Sys_Flag_B
	RMB2	Sys_Flag_B		;add1
	RTS
;-----------------------------------------
L_Time_Month_Up_Prog:
	JSR		L_Judge_Key_Beep_Prog	;L_Key_Beep_Prog
	JSR		L_Update_Time_Month_Prog
	JMP		L_End_KeyUpdate_Prog
;=============================================================	
L_Judge_Hr_Or_Month_2S_Prog:
	LDA		#0
L_SetFast_Prog:	
	STA		P_Temp	
	LDA		R_Mode_Flag
	BEQ		L_End_KeyUp_2S	;ʱ��ģʽ���˳�
L_FastAdd_1_Prog:	
	LDA		R_KeyHold_Time
	CMP		#64				;��������2S��ſ�ʼ���
	BCC		L_Inc_KeyHold_Time
	SMB0	Sys_Flag_B		;��Ƶ��־
	LDA		R_Fast_Time
	CMP		#5			;1���Ӹ��� 6
	BCC		L_Inc_Fast_Time	
	LDA		#0
	STA		R_Fast_Time
	LDA		P_Temp
	BEQ		L_Key_L_Hr_Or_Month_FastAdd_Prog	;���
	BBS0	P_Temp,L_Key_12Hr_24Hr_Or_Year_FastAdd_Prog	
	JMP		L_Min_Day_Adjust
L_End_KeyUp_2S:	
	RTS	

L_Key_L_Hr_Or_Month_FastAdd_Prog:
	jmp		L_Hr_Or_Month_FastAdd_Prog
	
L_Key_12Hr_24Hr_Or_Year_FastAdd_Prog:
	JMP		L_Year_FastAdd_Prog	
	
L_Inc_KeyHold_Time:
	;	INC		R_KeyHold_Time
	CLC
	LDA		R_KeyHold_Time
	ADC		#1
	STA		R_KeyHold_Time
	RTS	
L_Inc_Fast_Time:
	;	INC		R_Fast_Time
	CLC
	LDA		R_Fast_Time
	ADC		#1
	STA		R_Fast_Time
	RTS	
;**********************************************************
;----------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;L_CF_Adjust_Prog;;;;;;;;;;;;;;;;;;;;
;----------------------------------------------------------
L_CF_Adjust_Prog:
	BBS4	Sys_Flag_A,L_End_CF_Adjust_Prog
	SMB4	Sys_Flag_A		;���ð������ֱ�־
	BBS4	Sys_Flag_B,L_CF_Clr_Alarm_Prog	;��������������	
	LDA		R_Snooze_Times
	BNE		L_CF_Clr_Alarm_Prog	
	;	JSR		L_Clr_Snz_Prog	
	JSR		F_StopSoundPro
	JSR		L_Key_BeepOn_Prog
L_C_To_F_Prog:
	;	JSR		L_Key_Beep_Prog		
	BBS7	Sys_Flag_A,L_Temperature_TtoC
	SMB7	Sys_Flag_A
	JMP		L_Dis_Temperature_Prog
L_Temperature_TtoC:
	RMB7	Sys_Flag_A
	JMP		L_Dis_Temperature_Prog
L_End_CF_Adjust_Prog:	
	RTS
L_CF_Clr_Alarm_Prog:
	JMP		L_Clr_Snz_Prog	
;-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;L_Snz_Light_Prog;;;;;;;;;;;;;;;;;;;;
;-----------------------------------------------------------
L_Snz_Light_Prog:
	BBS4	Sys_Flag_A,L_End_Snz_Light_Prog
	SMB4	Sys_Flag_A		;���ð������ֱ�־

L_Snz_Light_ACProg:
	; LDA		#17
	; STA		R_Light_Time
	JSR		L_Open_Light_Prog
	JSR		F_StopSoundPro
	lda		R_Mode_Flag
	cmp		#1
	beq		L_Change_SetAlarmMode
	JSR		L_Load_Speech_TimeTemp_Prog	
	BBR4	Sys_Flag_B,L_End_Snz_Light_Prog	;û������
	JSR		L_Clr_Alarm_Prog	
	LDA		R_Snooze_Times
	BEQ		L_End_Snz_Light_Prog
	; DEC		R_Snooze_Times
	; LDA		R_Snooze_Times
	SEC
	LDA		R_Snooze_Times
	SBC		#1
	STA		R_Snooze_Times
	BEQ		L_End_Snz_Light_Prog
	LDA		#5
	STA		R_SnoozeTime_Minute			;5����̰˯
	; SMB4	$84		;DIS SNZ
	JSR		L_Judge_Dis_Snz_Flag
L_End_Snz_Light_Prog:	
	RTS
	
L_Change_SetAlarmMode:
	LDA		R_Alarm_Mode
	BEQ		L_SetAlarm2
	bbs0	R_Alarm_Mode,L_SetAlarm3
L_SetAlarm1:
	LDA		#0
L_SetAlarmMode:	
	STA		R_Alarm_Mode
	BBR1	Sys_Flag_D,?Skip
	JSR		L_Key_Beep_Prog	
	JMP		L_Dis_AlarmTime_Prog
?Skip:	
	JSR		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Dis_AlarmTime_Prog
L_SetAlarm2:
	LDA		#1
	; JMP		L_SetAlarmMode
	STA		R_Alarm_Mode
	BBR2	Sys_Flag_D,?Skip
	JSR		L_Key_Beep_Prog	
	JMP		L_Dis_AlarmTime_Prog
?Skip:	
	JSR		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Dis_AlarmTime_Prog
L_SetAlarm3:
	LDA		#2
	; JMP		L_SetAlarmMode
	STA		R_Alarm_Mode
	BBR3	Sys_Flag_D,?Skip
	JSR		L_Key_Beep_Prog	
	JMP		L_Dis_AlarmTime_Prog
?Skip:	
	JSR		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Dis_AlarmTime_Prog
;-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;L_Min_Day_CF_Adjust_Prog;;;;;;;;;;;;;;;;;;
;-----------------------------------------------------------
L_Min_Day_CF_Adjust_Prog:
	; BBR0	Sys_Flag_D,?LCD1
	; BBS4	Sys_Flag_A,L_Min_Day_CF_Adjust_3S_Prog
	; SMB4	Sys_Flag_A		;���ð������ֱ�־
	; BBS4	Sys_Flag_B,L_Min_Day_CF_Clr_Alarm_Prog	;��������������
	; LDA		R_Snooze_Times
	; BNE		L_Min_Day_CF_Clr_Alarm_Prog	
	; JSR		F_StopSoundPro
	; LDA		R_Mode_Flag
	; BEQ		L_Set_Key_Min_Day_CF_PressFlag
	; JMP		L_Min_Day_Adjust


	
?LCD1:
	BBS4	Sys_Flag_A,L_Min_Day_CF_Adjust_2S_Prog
	SMB4	Sys_Flag_A		;���ð������ֱ�־
	BBS4	Sys_Flag_B,L_Min_Day_CF_Clr_Alarm_Prog	;��������������
	LDA		R_Snooze_Times
	BNE		L_Min_Day_CF_Clr_Alarm_Prog	
	JSR		F_StopSoundPro
	LDA		R_Mode_Flag
	BNE		L_Min_Day_Adjust
	JSR		L_Key_Beep_Prog
	JMP		L_C_To_F_Prog

L_Min_Day_CF_Adjust_2S_Prog:
	LDA		#2
	JMP		L_SetFast_Prog
L_Min_Day_CF_Clr_Alarm_Prog:
	JMP		L_Clr_Snz_Prog

L_Min_Day_CF_Adjust_3S_Prog:
	LDA		R_Mode_Flag
	BEQ		L_Judge_Min_Day_CF_Adjust_3S_Prog
	JMP		L_Min_Day_CF_Adjust_2S_Prog
L_Judge_Min_Day_CF_Adjust_3S_Prog:
	LDA		R_KeyHold_Time
	CMP		#96			;��������3S
	BCS		F_Judge_LCD2_ChangGongliNongli
	JMP		L_Inc_KeyHold_Time
	
F_Judge_LCD2_ChangGongliNongli:
	BBR5	Sys_Flag_D,L_LCD2
	BBS6	Sys_Flag_D,L_LCD2
	JSR		F_StopSoundPro		
	JSR		L_Key_BeepOn_Prog
	SMB6	Sys_Flag_D
F_Lcd2_ChangGongliNongli	
	BBS7	Sys_Flag_D,?Gongli
	SMB7	Sys_Flag_D
	JMP		L_Dis_MonthDay_Prog
?Gongli:
	RMB7	Sys_Flag_D
	JMP		L_Dis_MonthDay_Prog
L_LCD2:	
	RTS
	
L_Set_Key_Min_Day_CF_PressFlag:
	SMB5	Sys_Flag_D	
	RTS
	
L_Judge_CF_Prog:
	BBR5	Sys_Flag_D,?RTS
	BBS6	Sys_Flag_D,?RTS
	JSR		L_Key_Beep_Prog
	JMP		L_C_To_F_Prog
?RTS:
	RTS
;-----------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;L_Min_Day_Adjust_Prog;;;;;;;;;;;;;;;;;;
;-----------------------------------------------------------
L_Min_Day_Adjust_Prog:
	BBS4	Sys_Flag_A,L_Min_Day_CF_Adjust_2S_Prog
	SMB4	Sys_Flag_A		;���ð������ֱ�־
	BBS4	Sys_Flag_B,L_Min_Day_Clr_Alarm_Prog	;��������������
	LDA		R_Snooze_Times
	BNE		L_Min_Day_Clr_Alarm_Prog		
	JSR		F_StopSoundPro
	; LDA		R_Mode_Flag
	; BEQ		L_End_Min_Day_Adjust_Prog
	LDA		R_Mode_Flag
	BNE		?SKIP
	RTS
?SKIP:
	
L_Min_Day_Adjust:
	SMB2	Sys_Flag_B
	LDA		R_Mode_Flag
	CMP		#1
	BEQ		L_AlarmTime_Min_Up_Prog
	CMP		#2
	BEQ		L_Time_Day_Up_Prog	
L_Time_Min_Up_Prog:
	JSR		L_Update_Time_Min_Prog
	
	JSR		L_Load_Speech_Min_Prog		
	
	LDA		#0
	STA		R_Time_Sec		;���ӵ������塰0��
	; JSR		L_Dis_TimeMin_Prog	
	JSR		L_Dis_Time_Prog
L_End_Min_Day_Adjust_Prog:
	RTS
L_Min_Day_Clr_Alarm_Prog:
	JMP		L_Clr_Snz_Prog
;-----------------------------------------		
L_AlarmTime_Min_Up_Prog:
	; LDX		#7
	BBS0	R_Alarm_Mode,L_Alarm2_Min_Up
	BBS1	R_Alarm_Mode,L_Alarm3_Min_Up
L_Alarm1_Min_Up:
	BBS1	Sys_Flag_D,L_AlarmOff1

	LDX		#(R_Alarm_Min1-Time_Str_Addr)
L_AlarmTime_Min_Up_Common:
	LDA		#$59
	JSR		L_Inc_To_Any_Count_Prog
	
	JSR		L_Load_Speech_Min_Prog		
	
	JMP		L_Dis_AlarmTime_Prog
	
L_Alarm2_Min_Up:
	BBS2	Sys_Flag_D,L_AlarmOff1
	LDX		#(R_Alarm_Min2-Time_Str_Addr)
	jmp		L_AlarmTime_Min_Up_Common
L_Alarm3_Min_Up:
	BBS3	Sys_Flag_D,L_AlarmOff1
	LDX		#(R_Alarm_Min3-Time_Str_Addr)
	jmp		L_AlarmTime_Min_Up_Common
L_AlarmOff1:
	RMB0	Sys_Flag_B   ;��Ƶ��־	
	RMB2	Sys_Flag_B		;add1	
	RTS
;-----------------------------------------
L_Time_Day_Up_Prog:
	JSR		L_Judge_Key_Beep_Prog	;L_Key_Beep_Prog
	JSR		L_Update_Time_Day_Prog
	JMP		L_End_KeyUpdate_Prog	
;============================================================
L_ScanKey_Delay_Prog:
	LDA		#$F0
	STA		P_Temp
L_Loop_ScanKey_Delay:
	INC		P_Temp
	LDA		P_Temp
	BNE		L_Loop_ScanKey_Delay
	RTS
;============================================================
;************************************************************
;============================================================
L_Scan_SlideKey_Prog:		;拨键
	bbr4	Sys_Flag_A,L_Scan_SlideKey_Prog_

	; JSR		L_Set_PC01_InputHigh_Prog
	; LDA		pa
	; LDA		pa	
	; AND		#$1C	
	JMP		L_End_Scan_SlideKey_Prog
L_Scan_SlideKey_Prog_:
	DIS_KEY_IRQ						;��PA�ж�ʹ��
	


	SMB1	PB
	IOOUT	PD,008H,0
	IOH		PD,008H,0
	
	; LDA		PA
	; ORA		#003H
	LDA		#$FF
	STA		PA
	
	
	LDA		PA
	AND		#003H
	STA		P_Temp

	RMB1	PB
	IOL		PD,008H,0

	LDA		PA
	AND		#003H
	STA		P_Temp+1

	SMB1	PB

	LDA		PA
	AND		#003H
	STA		P_Temp+2

	RMB1	PB
	IOH		PD,008H,0

	LDA		PA
	AND		#003H
	STA		P_Temp+3
	

	LDA		P_Temp
	CMP		R_SlideKey_Value
	BNE		?CON

	LDA		P_Temp+1
	CMP		R_SlideKey_Value+1
	BNE		?CON

	LDA		P_Temp+2
	CMP		R_SlideKey_Value+2
	BNE		?CON

	LDA		P_Temp+3
	CMP		R_SlideKey_Value+3
	BNE		?CON

	BRA		?_con
	; JSR		L_PC45_Output0
	?CON:
	LDA		P_Temp
	STA		R_SlideKey_Value

	LDA		P_Temp+1
	STA		R_SlideKey_Value+1

	LDA		P_Temp+2
	STA		R_SlideKey_Value+2

	LDA		P_Temp+3
	STA		R_SlideKey_Value+3
	; LDA		P_PC_IO_Backup
	; and		#11101111B
	; ora		#00100000B	
	; STA		P_PC_IO_Backup
	; STA		P_PC_IO				
	
	; LDA		P_PC_Backup
	; ORA		#00110000B
	; STA		P_PC_Backup
	; STA		P_PC			;PC4���1 PC5��������
	
	; ; JSR		L_ScanKey_Delay_Prog
	; LDA		pa
	; AND		#$1C
	; STA		P_Temp+10
	
	; JSR		L_PC45_Output0	
			
	; LDA		P_PC_IO_Backup
	; and		#11011111B
	; ora		#00010000B	
	; STA		P_PC_IO_Backup
	; STA		P_PC_IO				
	
	; LDA		P_PC_Backup
	; ORA		#00110000B
	; STA		P_PC_Backup
	; STA		P_PC			;PC5���1 PC4��������
	
	; ; JSR		L_ScanKey_Delay_Prog
	; LDA		pa
	; AND		#$1C
	; STA		P_Temp+11
	
	; JSR		L_Set_PC01_InputHigh_Prog
	; JSR		L_ScanKey_Delay_Prog
	
	; LDA		pa
	; LDA		pa	
	; AND		#$1C
	
	; bne		L_End_Scan_SlideKey_Prog		
	JSR		L_Judge_SlideKey1_Prog
	JSR		L_Judge_SlideKey2_Prog
?_con:
	CLR_KEY_IRQ_FLAG	
	EN_KEY_IRQ						;��PA�ж�ʹ��	
L_End_Scan_SlideKey_Prog:	
	RTS
;----------------------------------------------	
L_Judge_SlideKey1_Prog:
	; xJB		P_Temp,0,L_Time_Set_Mode_Prog
	LDA		R_SlideKey_Value
	AND		#$01
	BEQ		L_Time_Set_Mode_Prog
	xJB		R_SlideKey_Value+1,0,L_Time_Mode_Prog
	xJB		R_SlideKey_Value+2,0,L_Alarm_Set_Mode_Prog
	xJB		R_SlideKey_Value+3,0,L_Date_Set_Mode_Prog
	RTS		

	LDA		R_SlideKey1_Value
	CMP		P_Temp+10
	BEQ		L_End_Judge_SlideKey1_Prog
	; BBR4	Sys_Flag_B,L_SlideKey1_No_AlarmSnz_Prog	;û��������������	
 	JSR		L_Clr_Snz_Prog
;L_SlideKey1_No_AlarmSnz_Prog:	
	LDA		P_Temp+10	
	STA		R_SlideKey1_Value
	BEQ		L_Time_Mode_Prog
	CMP		#$10
	BEQ		L_Alarm_Set_Mode_Prog
	CMP		#$08
	BEQ		L_Date_Set_Mode_Prog
	CMP		#$04
	BEQ		L_Time_Set_Mode_Prog	
L_End_Judge_SlideKey1_Prog:	
	RTS
;-----------------------------------------------
L_Time_Mode_Prog:
	LDA		#0
L_ChangMode_Prog:		
	STA		R_Mode_Flag	
	; JSR		L_Auto_Dis_AlarmMode_Prog
L_Update_Display_Prog:	
	; JSR		L_Clr_All_DisRam_Prog		
	JMP		L_Display_Prog	
;-----------------------------------------------
L_Alarm_Set_Mode_Prog:
	LDA		#0
	STA		R_Alarm_Mode
	LDA		#1
	JMP		L_ChangMode_Prog
;-----------------------------------------------
L_Date_Set_Mode_Prog:
	LDA		#2
	JMP		L_ChangMode_Prog
;-----------------------------------------------
L_Time_Set_Mode_Prog:
	LDA		#3
	JMP		L_ChangMode_Prog
;===============================================		
L_Judge_SlideKey2_Prog:
	LDA		R_SlideKey_Value
	AND		#$02
	BEQ		L_Alarm_Off_Prog
	; xJB		P_Temp,1,L_Alarm_Off_Prog
	xJB		R_SlideKey_Value+1,1,L_Daily_Alarm_On_Prog
	xJB		R_SlideKey_Value+2,1,L_WorkingDay5_Alarm_On_Prog
	xJB		R_SlideKey_Value+3,1,L_WorkingDay6_Alarm_On_Prog
	RTS

	LDA		R_SlideKey2_Value
	CMP		P_Temp+11
	BEQ		L_End_Judge_SlideKey2_Prog
	; BBR4	Sys_Flag_B,L_SlideKey2_No_AlarmSnz_Prog		;û��������������	
	JSR		L_Clr_Snz_Prog
;L_SlideKey2_No_AlarmSnz_Prog	
	LDA		P_Temp+11	
	STA		R_SlideKey2_Value
	
	; CMP		#$70	


	BEQ		L_Alarm_Off_Prog	
	CMP		#$04
	BEQ		L_Daily_Alarm_On_Prog	
	CMP		#$08
	BEQ		L_WorkingDay5_Alarm_On_Prog	
	CMP		#$10
	BEQ		L_WorkingDay6_Alarm_On_Prog
L_End_Judge_SlideKey2_Prog:
	RTS	
;------------------------------------------------
L_Alarm_Off_Prog:
	lda		#0
L_Chang_Alarm_Way:	
	sta		R_Alarm_Way
	JMP		L_Dis_AlarmFlag_Prog
;------------------------------------------------
L_Daily_Alarm_On_Prog:
	lda		#1
	JMP		L_Chang_Alarm_Way
;------------------------------------------------
L_WorkingDay5_Alarm_On_Prog:
	lda		#2
	JMP		L_Chang_Alarm_Way
;------------------------------------------------
L_WorkingDay6_Alarm_On_Prog:
	lda		#4
	JMP		L_Chang_Alarm_Way
;========================================================
L_Judge_SlideKey3_Prog:
	LDA		#$FD	;LCD2,PA1����
	STA		PA
	JSR		L_ScanKey_Delay_Prog
	BBR0	PA,?Gongli
?Longli:
	LDA		#$FC	;PA0,PA1����
	STA		PA
	BBS4	Sys_Flag_D,?RTS
	SMB4	Sys_Flag_D
	SMB7	Sys_Flag_D ;��ʾũ��
	JMP		L_Dis_MonthDay_Prog
	
?Gongli:
	LDA		#$FD
	STA		PA		   ;PA1����
	BBR4	Sys_Flag_D,?RTS
	RMB4	Sys_Flag_D
	RMB7	Sys_Flag_D ;��ʾ����
	JMP		L_Dis_MonthDay_Prog
?RTS:
	RTS
;----------------------------------
L_Set_PC01_InputHigh_Prog:
	LDA		P_PC_Backup
	ORA		#$30
	STA		P_PC_Backup
	STA		P_PC			;PC4,PC5 Pull-low
	; LDA		P_PC_IO_Backup	
	; AND		#$FC	
	; STA		P_PC_IO_Backup
	; STA		P_PC_IO			;PC0,PC1 ���1
	NOP
	NOP
	LDA		P_PC_IO_Backup
	ORA		#$30
	STA		P_PC_IO_Backup
	STA		P_PC_IO			;PC4,PC5 ���ó����
	RTS		
;========================================================	
L_Auto_Adjust_MaxDay:
	JSR		L_Check_MaxDay_Prog
	; STA		P_Temp	
	SEC		
	SBC		R_Time_Day
	BCS		L_End_Auto_Adjust_MaxDay
	; LDA		P_Temp
	LDA		#1
	STA		R_Time_Day
L_End_Auto_Adjust_MaxDay:
	RTS
;=======================================================
L_VoiceBeep_Control_Prog:
	BBS0	Sys_Flag_B,L_End_VoiceBeep_Control_Prog	

	BBR5	Sys_Flag_B,L_Set_SysFlagB_Bit5	
	RMB5	Sys_Flag_B	
	BBS3	Sys_Flag_B,L_Control_AlarmForever_Beep
	LDA		R_Voice_Unit
	BEQ		L_End_VoiceBeep_Control_Prog	
	DEC		R_Voice_Unit
	BBS0	R_Voice_Unit,L_Open_Beep_Prog	
L_Close_Beep_Prog:	
	LDA		#$00  	
	STA		DAC
	; LDA		#0
	; STA		tmr0	
	; RMB0	tmrc			;Close TMR0������	
	PWM_OFF
	RMB6	Sys_Flag_B		;Clear ���ֱ�־
L_End_VoiceBeep_Control_Prog:	
	RTS		
L_Open_Beep_Prog:
	TONE_2KHZ_3_4DUTY

	; LDA		#$04			;	
	; STA		divc		 	; ��������Ƶ��ԴΪtmr0/2
	; LDA		#223			;#240_4K
	; STA		tmr0
	
	LDA		#$FF   
	STA		DAC	
	LDA		#$00			;#$20
	STA		DAC_CTL
	PWM_ON
	; SMB0	tmrc	;OPEN TMR0������	
	SMB6	Sys_Flag_B		;�������ֱ�־
	RTS	
L_Set_SysFlagB_Bit5:	
	SMB5	Sys_Flag_B		;32HZ��64HZ��־
	RTS
L_Control_AlarmForever_Beep:
	BBS6	Sys_Flag_B,L_Close_Beep_Prog
	JMP		L_Open_Beep_Prog

;L_Clr_Chime_Flag:
	; RMB1	Sys_Flag_C
	; RTS

L_Judge_Key_Beep_Prog:
	BBS7	Sys_Flag_B,L_Exit_Key_Beep_Prog
L_Key_Beep_Prog:
	LDA		R_Mode_Flag
	beq		L_Key_BeepOn_Prog
	BBS7	Sys_Flag_B,L_Exit_Key_Beep_Prog	
L_Key_BeepOn_Prog:	
	lda		#2
	sta		R_Voice_Unit
L_Exit_Key_Beep_Prog:	
	rts
;=======================================================
L_Light_Control_Prog:
	LDA		R_Light_Time
	BEQ		L_Exit_Light_Control_Prog
	; DEC		R_Light_Time
	; LDA		R_Light_Time
	SEC
	LDA		R_Light_Time
	SBC		#1
	STA		R_Light_Time	
	BNE		L_Exit_Light_Control_Prog
L_Close_Light_Prog:
	RMB0	pb
L_Exit_Light_Control_Prog:
	RTS	
L_Open_Light_Prog:
	LDA		#33
	STA		R_Light_Time
	SMB0	pbtype	;PB0 CMOS OUTPUT
	SMB0	pb		;PB0 �����1��
	RTS	
;=======================================================
L_Clr_Snz_Prog:
	LDA		#0
	STA		R_Snooze_Times
	STA		R_SnoozeTime_Minute
	jsr		L_Clr_Snz_Flag
	JSR		F_StopSoundPro		
L_Clr_Alarm_Prog:
	JSR		L_Close_Beep_Prog
	RMB4	Sys_Flag_B		;������
	RMB7	Sys_Flag_C		;��̰˯�����־	
	RMB3	Sys_Flag_B		;��������ֱ�־
L_End_Clr_Snz_Prog:
	JMP		L_Judge_Dis_AlarmModeFlag_Prog	
;=======================================================	
L_Hr_Deal_Prog:
	BBS5	Sys_Flag_A,L_End_Hr_Deal_Prog
	LDA		R_ReceiveBuffer
	SEC
	SED
	SBC		#$12
	CLD
	BCC		L_Small_12
	BEQ		L_noon_12	
	STA		R_ReceiveBuffer
	CMP		#6	
	BCS		L_Night
	lda		#4
L_xx:	
	sta		R_APM
	RTS
L_End_Hr_Deal_Prog:	
	LDA		#0
	bra		L_xx
	
L_Small_12:
	LDA		R_ReceiveBuffer	
	BEQ		L_Begin
	cmp		#6
	bcc		L_Begin1
	lda		#2
	bra		L_xx	
L_noon_12:
	lda		#$12
	sta		R_ReceiveBuffer	
	lda		#3
	bra		L_xx
L_Night:
	lda		#5
	bra		L_xx

L_Begin:
	lda		#$12
	sta		R_ReceiveBuffer
L_Begin1:	
	LDA		#1	
	bra		L_xx	
;=======================================================
L_Load_Speech_TimeTemp_Prog:
	BBS7	Sys_Flag_B,L_End_Load_Speech_Prog
	LDX		#(R_Time_Hr-Time_Str_Addr)
L_Load_Speech_TimeTemp_Common:	
	LDA		Time_Addr,X
	sta		R_ReceiveBuffer	
	DEX
	LDA		Time_Addr,X	
	sta		R_ReceiveBuffer+1	
	jsr		L_Hr_Deal_Prog	
	lda		#D_DingDongTimeTemp_F
	bbs7	Sys_Flag_A,L_Start
	lda		#D_DingDongTimeTemp_C
L_Start:		
	JMP		F_StartPlaySentence	
;===================================	
L_Load_Speech_AlarmTemp_Prog:
	BBS7	Sys_Flag_B,L_End_Load_Speech_Prog
	BBS0	R_Alarm_Mode,L_Load_Speech_Alarm2
	BBS1	R_Alarm_Mode,L_Load_Speech_Alarm3
L_Load_Speech_Alarm1:
	BBS1	Sys_Flag_D,L_End_Load_Speech_Prog
	LDX		#(R_Alarm_Hr1-Time_Str_Addr)	
	BRA		L_Load_Speech_TimeTemp_Common
L_Load_Speech_Alarm2:
	BBS2	Sys_Flag_D,L_End_Load_Speech_Prog
	LDX		#(R_Alarm_Hr2-Time_Str_Addr)	
	BRA		L_Load_Speech_TimeTemp_Common
L_Load_Speech_Alarm3:
	BBS3	Sys_Flag_D,L_End_Load_Speech_Prog
	LDX		#(R_Alarm_Hr3-Time_Str_Addr)	
	BRA		L_Load_Speech_TimeTemp_Common
;===================================
L_Load_Speech_Hr_Prog:
	BBS7	Sys_Flag_B,L_End_Load_Speech_Prog
	BBS0	Sys_Flag_B,L_End_Load_Speech_Prog
	sta		R_ReceiveBuffer
	JSR		L_Hr_Deal_Prog
	lda		#D_DianSpeech	
	JMP		F_StartPlaySentence	
	
L_Load_Speech_Min_Prog:
	BBS7	Sys_Flag_B,L_End_Load_Speech_Prog	
	BBS0	Sys_Flag_B,L_End_Load_Speech_Prog
	sta		R_ReceiveBuffer+1	
	lda		#D_FenSpeech	
	jmp		F_StartPlaySentence
L_End_Load_Speech_Prog:
	RTS
;===================================	
L_Judge_Load_Speech:
	BBR0	Sys_Flag_B,L_End_Judge_Load_Speech
	BBR0	R_Mode_Flag,L_End_Judge_Load_Speech
	BBS1	R_Mode_Flag,L_Load_Speech_TimeTemp_Prog	
	JMP		L_Load_Speech_AlarmTemp_Prog
L_End_Judge_Load_Speech:	
	RTS
;===================================
F_SoundCtrlEntry:
	BBR2	Sys_Flag_C,F_End_SoundCtrlEntry		;VOICE
	RMB2	Sys_Flag_C
	LDA		R_Measure_Temperature				;
	Bne		F_End_SoundCtrlEntry				;���¶�ʱ��Ч
	BBS4	Sys_Flag_B,F_End_SoundCtrlEntry		;ALARM_ARRIVE
;	BBS7	tmrc,F_End_SoundCtrlEntry	
	xJB		R_SoundCtrl,C_StartPlayBit,F_End_SoundCtrlEntry
	JSR		L_Open_Light_Prog
	lda		R_Mode_Flag
	cmp		#1
	beq		L_Load_Speech_AlarmTemp_Prog
	JMP		L_Load_Speech_TimeTemp_Prog
F_End_SoundCtrlEntry:
	RTS
;===================================
L_PC45_Output0:
	LDA		P_PC_IO_Backup	
	AND		#$CF	
	STA		P_PC_IO_Backup
	STA		P_PC_IO			;PC4,PC5 ���
	
	LDA		P_PC_Backup
	AND		#$CF
	STA		P_PC			;PC4,PC5 0
	STA		P_PC_Backup	
	RTS
;===================================
L_AScanKeyPort_Init:
	LDA		#$BF
	STA		PA
	RTS
;===================================
L_BScanKeyPort_Init:
	LDA		#$BF
	STA		PA
	RTS
;===================================
L_CScanKeyPort_Init:
	LDA		#$BF
	STA		PA
	RTS
;===================================





;===================================
;BXing_Key
;===================================
L_Change_Alarm_567:
	LDA		R_Alarm_Way
	BEQ		?AlarmWay_1


	CLC
	ROL		R_Alarm_Way
	BBR3	R_Alarm_Way,?SKIP
	LDA		#0
	STA		R_Alarm_Way
	?SKIP:
	JMP		L_Dis_AlarmFlag_Prog
	; LDA		R_Alarm_Way

	?AlarmWay_1:
	SMB0	R_Alarm_Way		;AlarmWay_1
	JMP		L_Dis_AlarmFlag_Prog
	RTS
;===================================
;AXING_PROG
;===================================
L_Judge_TimeSet_3S_Prog:
	; xJNB	Flag_TimeSetK,Bit_TimeSetK,L_End_Judge_TimeSet_3S_Prog
	LDA		R_KeyHold_Time
	CMP     #D_Key3S
    BCS     L_Star_TimeSet_Enter3S
    ; INC     R_KeyHold_Time
	JSR		L_Inc_KeyHold_Time
L_End_Judge_TimeSet_3S_Prog:
	RTS
L_TimeSet_Prog:		;hold-key timeset
	BBS4	Sys_Flag_A,L_Judge_TimeSet_3S_Prog	
	SMB4	Sys_Flag_A		;
	SMBx	Flag_TimeSetK,Bit_TimeSetK		
	; BBS4	Sys_Flag_B,L_12Hr_24Hr_Or_Year_Clr_Alarm_Prog	
	RTS
L_Star_TimeSet_Enter3S:			;long-key timeset
	RMBx	Flag_TimeSetK,Bit_TimeSetK		
	LDA		R_Mode_Flag
	BNE		?END

	LDA		#1
	STA		R_Mode_Flag
	BC		FLAG_AlarmSet,Bit_AlarmSet,1
	; INC		R_Mode_Flag
	JSR		L_Init_SetTime_Prog
	
	?END:
	RTS
L_ReLease_TimeSetKey:		;short-key timeset
	xJNB	Flag_TimeSetK,Bit_TimeSetK,L_End_ReLease_TimeSetKey	
	RMBx	Flag_TimeSetK,Bit_TimeSetK		
	
	LDA		R_Mode_Flag
	BEQ		?NORMAL
	xJB		FLAG_AlarmSet,Bit_AlarmSet,L_End_ReLease_TimeSetKey

	JSR		L_Init_SetTime_Prog

	lda		#5-1
	CMP		R_Mode_Flag
    BCC     L_ModeKeyRease_Reset0
	CLC
	LDA		R_Mode_Flag
	ADC		#1
	STA		R_Mode_Flag
	JMP		L_Display_Prog
	RTS
	?NORMAL:
	;切换5 6 7
	JMP		L_Change_Alarm_567
	RTS

L_End_ReLease_TimeSetKey:
	RTS
L_ModeKeyRease_Reset0:
	LDA     #$0
    STA     R_Mode_Flag
	BC		FLAG_AlarmSet,Bit_AlarmSet,1
    ; RMB0    Sys_Flag_B
    ; JSR     L_Judge_Dis_Alarm_Prog
    JMP     L_Display_Prog
;===================================
L_Judge_AlarmSet_3S_Prog:
	; xJNB	Flag_AlarmSetK,Bit_AlarmSetK,L_End_Judge_AlarmSet_3S_Prog	
	LDA		R_KeyHold_Time
	CMP     #D_Key3S
	BCS     L_Star_AlarmSet_Enter3S	
	; INC     R_KeyHold_Time	
	JSR		L_Inc_KeyHold_Time
L_End_Judge_AlarmSet_3S_Prog:	
	RTS	

L_AlarmSet_Prog:			;hold-key alarmset
	BBS4	Sys_Flag_A,L_Judge_AlarmSet_3S_Prog	
	SMB4	Sys_Flag_A		;
	SMBx	Flag_AlarmSetK,Bit_AlarmSetK		
    RTS

L_Star_AlarmSet_Enter3S:		;long-key alarmset
	RMBx	Flag_AlarmSetK,Bit_AlarmSetK		


	LDA		R_Mode_Flag
	BNE		?END
	LDA		#1
	STA		R_Mode_Flag
	BS		FLAG_AlarmSet,Bit_AlarmSet,1

	JSR		L_Init_SetTime_Prog
	
	; INC		R_Mode_Flag
	JMP		L_Dis_AlarmTime_Prog
	?END:

	RTS
L_ReLease_AlarmSetKey:		;short-key alarmset
	xJNB	Flag_AlarmSetK,Bit_AlarmSetK,L_End_ReLease_AlarmSetKey	
	RMBx	Flag_AlarmSetK,Bit_AlarmSetK	

	LDA		R_Mode_Flag
	BEQ		?NORMAL
	xJNB		FLAG_AlarmSet,Bit_AlarmSet,L_End_ReLease_AlarmSetKey
	
	JSR		L_Init_SetTime_Prog

	lda		#9-1
	CMP		R_Mode_Flag
    BCC     L_ModeKeyRease_Reset0
	CLC
	LDA		R_Mode_Flag
	ADC		#1
	STA		R_Mode_Flag
	JMP		L_Dis_AlarmTime_Prog
	?NORMAL:
	JSR		F_StopSoundPro	
	JMP		L_Choose_AlarmMusic	
L_End_ReLease_AlarmSetKey:		
	RTS	
;===================================
L_Judge_Up_3S_Prog:
	; xJNB	Flag_UpK,Bit_UpK,L_End_Judge_Up_3S_Prog	
	LDA		R_KeyHold_Time	
	CMP     #D_Key3S		;3S	
	BCS     L_Star_Up_Enter3S		;3S	
	; INC		R_KeyHold_Time		;3S	
	JSR		L_Inc_KeyHold_Time
L_End_Judge_Up_3S_Prog:		;3S	
	RTS		;3S	

L_Up_Prog:
    BBS4	Sys_Flag_A,L_Judge_Up_3S_Prog	
	SMB4	Sys_Flag_A		;
	SMBx	Flag_UpK,Bit_UpK		

    RTS
L_Star_Up_Enter3S:		;	long-key up		;3S	
	RMBx	Flag_UpK,Bit_UpK			;3S

	LDA		R_Mode_Flag		;
	BEQ		?NORMAL		;

	LDA		R_Fast_Time
	CMP		#$5
	BCS		?FAST
	JMP		L_Inc_Fast_Time
	?FAST:
	LDA		#0
	STA		R_Fast_Time
	SMB6	Sys_Flag_D
	BRA		L_UpKey_Fast_Prog
	?NORMAL:
	;GONGLI NONGLI CHANGE
	BX		FLAG_NongLiD,Bit_NongLiD,1
	JSR		L_Dis_MonthDay_Prog
	BS		FLAG_KEYSTOP,BIT_KEYSTOP,1
	JMP		L_Judge_Disp_NongLi_Prog

	
	RTS
L_ReLease_UpKey:		;	short-key up		
	xJNB	Flag_UpK,Bit_UpK,L_End_ReLease_UpKey		
	RMBx	Flag_UpK,Bit_UpK			
	LDA		R_Mode_Flag
	BEQ		UpKey_NORMAL
L_UpKey_Fast_Prog:
	JSR		L_Init_SetTime_Prog

	xJB		FLAG_AlarmSet,Bit_AlarmSet,UpKey_Alarm_Set
	LDA		R_Mode_Flag		;
	CMP		#1
	BEQ		L_Up_Time_Hr_Prog		;时
	CMP		#2		;分	
	BEQ		L_Up_Time_Min_Prog		;分	
	CMP		#3		;YEAR
	BEQ		L_Up_Time_Year_Prog		;YEAR	
	CMP		#4		;MONTH	
	BEQ		L_Up_Time_Month_Prog		;MONTH	
	CMP		#5		;DAY	
	BEQ		L_Up_Time_Day_Prog		;DAY	
	RTS		;
	UpKey_Alarm_Set:
	JADDR	R_Mode_Flag,T_UpKey_Alarm_Set


	; LDA		R_Mode_Flag		;
	; CMP		#1		;时	
	; BEQ		L_Up_Alarm1_Hr_Prog		;时	
	; CMP		#2		;分	
	; BEQ		L_Up_Alarm1_Min_Prog		;分	
	; ; CMP		#3		;ON\OFF
	; ; BEQ		L_Change_Alarm1_OnOff_Prog		;ON\OFF	
	; CMP		#4		;时
	; BEQ		L_Up_Alarm2_Hr_Prog		;时
	; CMP		#5		;分
	; BEQ		L_Up_Alarm2_Min_Prog		;分

	; ; CMP		#6		;ON\OFF
	; ; BEQ		L_Change_Alarm2_OnOff_Prog		;ON\OFF	
	; CMP		#7		;时
	; BEQ		L_Up_Alarm3_Hr_Prog		;时
	; CMP		#8		;分
	; BEQ		L_Up_Alarm3_Min_Prog		;分

	; RTS		;
	UpKey_NORMAL:	
	;C/F	 CHANGE
	BX		Sys_Flag_A,7,1
	JMP		L_Dis_Temperature_Prog
L_End_ReLease_UpKey:		
	RTS	

T_UpKey_Alarm_Set:
	DW		L_End_ReLease_UpKey-1		;
	DW		L_Up_Alarm1_Hr_Prog-1		;
	DW		L_Up_Alarm1_Min_Prog-1		;
	DW	L_Change_Alarm1_OnOff_Prog-1		;
	DW		L_Up_Alarm2_Hr_Prog-1		;
	DW		L_Up_Alarm2_Min_Prog-1		;
	DW	L_Change_Alarm2_OnOff_Prog-1
	DW		L_Up_Alarm3_Hr_Prog-1		;
	DW		L_Up_Alarm3_Min_Prog-1		;
	DW	L_Change_Alarm3_OnOff_Prog-1
;-----------------------------------------------
L_Up_Time_Hr_Prog:
	JSR		L_Update_Time_Hr_Prog
	JSR		L_Load_Speech_Hr_Prog	
	JMP		L_Dis_Time_Prog
L_Up_Time_Min_Prog:		;分
	JSR		L_Update_Time_Min_Prog		;分	
	JSR		L_Load_Speech_Min_Prog
	LDA		#0
	STA		R_Time_Sec
	JMP		L_Dis_Time_Prog

L_Up_Time_Year_Prog:		;YEAR	
	JSR		L_Update_Time_Year_Prog		;YEAR	
	JMP		L_Update_Year_Disp_Prog

L_Up_Time_Month_Prog:		;MONTH
	JSR		L_Update_Time_Month_Prog		;MONTH	
	JMP		L_Update_YMD_Disp_Prog

L_Up_Time_Day_Prog:
	JSR		L_Update_Time_Day_Prog		;DAY
	JMP		L_Update_YMD_Disp_Prog
L_Up_Alarm1_Hr_Prog:		;时	
	LDX		#(R_Alarm_Hr1-Time_Str_Addr)
	LDA		#$23
	JSR		L_Inc_To_Any_Count_Prog

	JSR		L_Load_Speech_Hr_Prog	
	JMP		L_Dis_AlarmTime_Prog
L_Up_Alarm1_Min_Prog:		;分	
	LDX		#(R_Alarm_Min1-Time_Str_Addr)
	JSR		L_Inc_To_60_Prog

	JSR		L_Load_Speech_Min_Prog
	JMP		L_Dis_AlarmTime_Prog

L_Up_Alarm2_Hr_Prog:		;时	
	LDX		#(R_Alarm_Hr2-Time_Str_Addr)
	LDA		#$23
	JSR		L_Inc_To_Any_Count_Prog

	JSR		L_Load_Speech_Hr_Prog	
	JMP		L_Dis_AlarmTime_Prog
L_Up_Alarm2_Min_Prog:		;分	
	LDX		#(R_Alarm_Min2-Time_Str_Addr)
	JSR		L_Inc_To_60_Prog

	JSR		L_Load_Speech_Min_Prog
	JMP		L_Dis_AlarmTime_Prog

L_Up_Alarm3_Hr_Prog:		;时	
	LDX		#(R_Alarm_Hr3-Time_Str_Addr)
	LDA		#$23
	JSR		L_Inc_To_Any_Count_Prog

	JSR		L_Load_Speech_Hr_Prog	
	JMP		L_Dis_AlarmTime_Prog
L_Up_Alarm3_Min_Prog:		;分	
	LDX		#(R_Alarm_Min3-Time_Str_Addr)
	JSR		L_Inc_To_60_Prog

	JSR		L_Load_Speech_Min_Prog
	JMP		L_Dis_AlarmTime_Prog
L_Change_Alarm1_OnOff_Prog:
	BX		Sys_Flag_D,1,1
	JMP		L_Dis_AlarmTime_Prog
L_Change_Alarm2_OnOff_Prog:
	BX		Sys_Flag_D,2,1
	JMP		L_Dis_AlarmTime_Prog
L_Change_Alarm3_OnOff_Prog:
	BX		Sys_Flag_D,3,1
	JMP		L_Dis_AlarmTime_Prog
;===================================
L_Judge_Down_3S_Prog:
	; xJNB	Flag_DownK,Bit_DownK,L_End_Judge_Down_3S_Prog	
	LDA		R_KeyHold_Time	
	CMP     #D_Key3S		;3S	
	BCS     L_Star_Down_Enter3S		;3S	
	; INC		R_KeyHold_Time		;3S	
	JSR		L_Inc_KeyHold_Time	
L_End_Judge_Down_3S_Prog:		;3S	
	RTS		;3S	

L_Down_Prog:
	BBS4	Sys_Flag_A,L_Judge_Down_3S_Prog	
	SMB4	Sys_Flag_A		;
	SMBx	Flag_DownK,Bit_DownK		
    RTS
L_Star_Down_Enter3S:		;	long-key down		;3S	
	RMBx	Flag_DownK,Bit_DownK			;3S	
	LDA		R_Mode_Flag		;
	BEQ		?NORMAL		;
	;FAST DOWN

	LDA		R_Fast_Time
	CMP		#$5
	BCS		?FAST
	JMP		L_Inc_Fast_Time
	?FAST:
	LDA		#0
	STA		R_Fast_Time
	
	SMB6	Sys_Flag_D

	BRA		L_DownKey_Fast_Prog

	?NORMAL:		;
	BS		FLAG_KEYSTOP,BIT_KEYSTOP,1
	JSR		L_Judge_Chime_Prog	;开关闭整点报时
	RTS		
L_ReLease_DownKey:		;	short-key down		
	xJNB	Flag_DownK,Bit_DownK,L_End_ReLease_DownKey		
	RMBx	Flag_DownK,Bit_DownK			
	LDA		R_Mode_Flag
	BEQ		DownKey_NORMAL
L_DownKey_Fast_Prog:
	JSR		L_Init_SetTime_Prog

	xJB		FLAG_AlarmSet,Bit_AlarmSet,DownKey_Alarm_Set
	LDA		R_Mode_Flag		;
	CMP		#1
	BEQ		L_Down_Time_Hr_Prog		;时
	CMP		#2		;分	
	BEQ		L_Down_Time_Min_Prog		;分	
	CMP		#3		;YEAR
	BEQ		L_Down_Time_Year_Prog		;YEAR	
	CMP		#4		;MONTH	
	BEQ		L_Down_Time_Month_Prog		;MONTH	
	CMP		#5		;DAY	
	BEQ		L_Down_Time_Day_Prog		;DAY	
	RTS		;
	DownKey_Alarm_Set:
	JADDR	R_Mode_Flag,T_DownKey_Alarm_Set

	; LDA		R_Mode_Flag		;
	; CMP		#1		;时
	; BEQ		L_Down_Alarm1_Hr_Prog		;时	
	; CMP		#2		;分	
	; BEQ		L_Down_Alarm1_Min_Prog		;分	
	; ; CMP		#3		;ON\OFF
	; ; BEQ		L_Down_Alarm1_OnOff_Prog		;ON\OFF	

	; RTS		;
	DownKey_NORMAL:	
	JSR		L_Time_12Switch24_Prog	
L_End_ReLease_DownKey:		
	RTS	
T_DownKey_Alarm_Set:
	DW		L_End_ReLease_DownKey-1		;
	DW		L_Down_Alarm1_Hr_Prog-1		;
	DW		L_Down_Alarm1_Min_Prog-1		;
	DW	L_Change_Alarm1_OnOff_Prog-1		;
	DW		L_Down_Alarm2_Hr_Prog-1		;
	DW		L_Down_Alarm2_Min_Prog-1		;
	DW	L_Change_Alarm2_OnOff_Prog-1
	DW		L_Down_Alarm3_Hr_Prog-1		;
	DW		L_Down_Alarm3_Min_Prog-1		;
	DW	L_Change_Alarm3_OnOff_Prog-1
	
;------------------------------------------------

L_Down_Time_Hr_Prog:
	JSR		L_Dec_Time_Hr_Prog
	JSR		L_Load_Speech_Hr_Prog
	JMP		L_Dis_Time_Prog

L_Down_Time_Min_Prog:		;分
	JSR		L_Dec_Time_Min_Prog		;分	
	JSR		L_Load_Speech_Min_Prog
	LDA		#0
	STA		R_Time_Sec

	JMP		L_Dis_Time_Prog

L_Down_Time_Year_Prog:		;YEAR	
	JSR		L_Dec_Time_Year_Prog		;YEAR
	JMP		L_Update_Year_Disp_Prog

L_Down_Time_Month_Prog:		;MONTH	
	JSR		L_Dec_Time_Month_Prog		;MONTH	
	JMP		L_Update_YMD_Disp_Prog

L_Down_Time_Day_Prog:		;DAY	
	JSR		L_Dec_Time_Day_Prog		;DAY
	JMP		L_Update_YMD_Disp_Prog

L_Down_Alarm1_Hr_Prog:		;时	
	LDX		#(R_Alarm_Hr1-Time_Str_Addr)
	LDA		#$23
	JSR		L_Dec_To_0_Prog
	JSR		L_Load_Speech_Hr_Prog
	JMP		L_Dis_AlarmTime_Prog
L_Down_Alarm1_Min_Prog:		;分	
	LDX		#(R_Alarm_Min1-Time_Str_Addr)
	JSR		L_Dec_To_60_Prog
	JSR		L_Load_Speech_Min_Prog
	JMP		L_Dis_AlarmTime_Prog

L_Down_Alarm2_Hr_Prog:		;时	
	LDX		#(R_Alarm_Hr2-Time_Str_Addr)
	LDA		#$23
	JSR		L_Dec_To_0_Prog
	JSR		L_Load_Speech_Hr_Prog
	JMP		L_Dis_AlarmTime_Prog
L_Down_Alarm2_Min_Prog:		;分	
	LDX		#(R_Alarm_Min2-Time_Str_Addr)
	JSR		L_Dec_To_60_Prog
	JSR		L_Load_Speech_Min_Prog
	JMP		L_Dis_AlarmTime_Prog

L_Down_Alarm3_Hr_Prog:		;时	
	LDX		#(R_Alarm_Hr3-Time_Str_Addr)
	LDA		#$23
	JSR		L_Dec_To_0_Prog
	JSR		L_Load_Speech_Hr_Prog
	JMP		L_Dis_AlarmTime_Prog
L_Down_Alarm3_Min_Prog:		;分	
	LDX		#(R_Alarm_Min3-Time_Str_Addr)
	JSR		L_Dec_To_60_Prog
	JSR		L_Load_Speech_Min_Prog
	JMP		L_Dis_AlarmTime_Prog
;===================================
L_Judge_Snz_3S_Prog:
	; xJNB	Flag_SnzK,Bit_SnzK,L_End_Judge_Snz_3S_Prog	
	LDA		R_KeyHold_Time	
	CMP     #D_Key3S		;3S	
	BCS     L_Star_Snz_Enter3S		;3S	
	; INC		R_KeyHold_Time		;3S	
	JSR		L_Inc_KeyHold_Time	
L_End_Judge_Snz_3S_Prog:		;3S	
	RTS		;3S	
L_Snz_Prog:
	BBS4	Sys_Flag_A,L_Judge_Snz_3S_Prog	
	SMB4	Sys_Flag_A		;
	SMBx	Flag_SnzK,Bit_SnzK		

    RTS
L_Star_Snz_Enter3S:		;	long-key snz		;3S	
	RMBx	Flag_SnzK,Bit_SnzK			;3S	
	RTS		

L_ReLease_SnzKey:		;	short-key snz		
	xJNB	Flag_SnzK,Bit_SnzK,L_End_ReLease_SnzKey		
	RMBx	Flag_SnzK,Bit_SnzK		
	JSR		L_Snz_Light_ACProg
L_End_ReLease_SnzKey:		
	RTS	

;===================================
;CXing_Knob
;===================================
;=======================================================
;encoder
ENCODER_SCAN:
	LDA		PA
	AND		#KNOB_Forw + KNOB_Reve
	ORA		PA3_Last
	ORA		PA4_Last
	BEQ		KNOB_END

	; LDA		KNOB_NOT_TIME
	; BEQ		ENCODER_SCAN_CON_1
	; LDA		#08H
	; STA		KNOB_NOT_TIME
	; ENCODER_SCAN_CON_1:
	LDA		PA
	AND		#KNOB_Forw
	STA		PA3_Now

	LDA		PA
	AND		#KNOB_Reve
	STA		PA4_Now	


	LDA		PA3_Now
	CMP		PA3_Last				;PA3
	BEQ		ENCODER_SCAN_End		;��PA3���ϴ�ֵ��ͬ���򷵻�OLDKNOB

	LDA		PA3_Now
	AND		#KNOB_Forw
	BNE		ENCODER_SCAN_Con
	
	LDA		PA4_Now
	CMP		PA4_Last
	BEQ		KNOB_END
	LDA		PA4_Now
	BNE		GET_KNOB_Forw
	BRA		GET_KNOB_Reve			;

GET_KNOB_Forw:
	; JSR		KNOB_STA_AC		;����˴�PA3��PA4��ֵ
	JSR		ENCODER_INIT
	LDA		#CMD_Forw
	RTS
GET_KNOB_Reve:
	; JSR		KNOB_STA_AC		;����˴�PA3��PA4��ֵ
	JSR		ENCODER_INIT
	LDA		#CMD_Reve
	RTS	
ENCODER_SCAN_Con:
	JSR		KNOB_STA_AC		;����˴�PA3��PA4��ֵ
	LDA		#040H
	RTS
ENCODER_SCAN_End:
	; JSR		KNOB_STA_AC		;����˴�PA3��PA4��ֵ
	LDA		#040H
	RTS
KNOB_END:
	LDA		#0FFH
	RTS

ENCODER_INIT:
	BC		FLAG_RNOB,BIT_RNOB,1
	LDA		#0
	STA		PA3_Now
	STA		PA3_Last
	STA		PA4_Last
	STA		PA4_Now
	STA		KNOB_LNG
	STA		KNOB_OLD
	RTS
KNOB_STA_AC:
	LDA		PA3_Now
	STA		PA3_Last
	LDA		PA4_Now
	STA		PA4_Last				;����˴�PA3��PA4��ֵ
	RTS

;-----------------------------------------	
;--------------------------------------
L_Knob_Function:
	STA		P_Temp
	CMP		#0FFH
	BEQ		ENCODER_INIT

	BS		FLAG_RNOB,BIT_RNOB,1
	
	LDA		P_Temp
	CMP		#040H
	BEQ		L_Knob_Function_End
	CMP		#CMD_Forw
	BEQ		L_Knob_Function_Forw
	CMP		#CMD_Reve
	BEQ		L_Knob_Function_Reve
L_Knob_Function_End:
	RTS

L_Knob_Function_Forw:
	LDA		R_Mode_Flag
	BEQ		L_Knob_Function_Forw_End
	; xJB		FLAG_AlarmSet,Bit_AlarmSet,?Alarm	

	JMP		L_DownKey_Fast_Prog
	; ?Alarm:
L_Knob_Function_Forw_End:
	RTS
;--------------------------------
L_Knob_Function_Reve:
	LDA		R_Mode_Flag
	BEQ		L_Knob_Function_Reve_End
	; xJB		FLAG_AlarmSet,Bit_AlarmSet,?Alarm
	JMP		L_UpKey_Fast_Prog
L_Knob_Function_Reve_End:
	RTS
;===================================
;===================================



