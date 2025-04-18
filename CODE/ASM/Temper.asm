;------------------------------------------------
;************************************************
; 887 Byte
;------------------------------------------------
L_Judge_Measure_Temperature_Prog:
;	LDA		R_Voice_Unit
;	BNE		L_End_Judge_Measure_Temperature_Prog
	LDA		R_Measure_Temperature
	BEQ		L_End_Judge_Measure_Temperature_Prog
	DEC		R_Measure_Temperature
	LDA		R_Measure_Temperature
	BNE		L_Judge_Measure_RT   							;Skip_Counter_Tempre_Prog		
	JMP		L_Measure_RR_Prog	
	 
L_Judge_Measure_RT:
	CMP		#3
	BNE		L_Set_Measure_Port_Low  ;L_Skip_Test_RT_Prog		
	JMP		L_Measure_RT_Prog

L_Set_Measure_Port_Low:
	LDA		P_PC_IO_Backup  
	AND		#$3F
	STA		P_PC_IO_Backup		
	STA		P_PC_IO			;����PC6~PC7Ϊ���

	LDA		P_PC_Backup	
	AND		#$3F
	STA		P_PC_Backup	 	
	STA		P_PC			;����PC6~PC7���"0"
L_End_Judge_Measure_Temperature_Prog:
	RTS
;------------------------------------------------
L_Measure_RT_Prog:
	LDA		#$0
	STA		R_RT_L
	STA		R_RT_M
	STA		R_RT_H
	RMB0	P_TMRCTRL		;�ر�TMR0������
	TMR0_CLK_F4Mdiv32	
	LDA		#$00
	STA		P_TMR0			;TMR0������ʼֵΪ0
	RMB1	P_IFR
	
	LDA		P_PC_IO_Backup
	AND		#$7F	
	ORA		#$40
	STA		P_PC_IO_Backup 		
	STA		P_PC_IO			;����PC7 CMOS�����PC6Ϊ����

	LDA		P_PC_Backup		
	ORA		#$80
	AND		#$BF	
	STA		P_PC_Backup				
	STA		P_PC			;����PC7���1��PC6������

	SMB0	P_TMRCTRL		;����TMR0������
L_Loop_Test_RT_Prog:
	BBS6	P_PC,L_Test_RT_OK
	BBR1	P_IFR,L_Loop_Test_RT_Prog
	RMB1	P_IFR	
	JSR		L_Inc_RT_Time_Prog
	LDA		R_RT_M	;#$F0	;#$A0		 ;80
	CMP		#$10	;R_RT_H
	BCS		L_RT_Low_Fail_Program
	BRA		L_Loop_Test_RT_Prog	
L_Test_RT_OK:
	RMB0	P_TMRCTRL	;�ر�TMR0������
	LDA		P_TMR0
	STA		R_RT_L
	BBR1	P_IFR,L_End_Test_RT_OK
	RMB1	P_IFR	
	JSR		L_Inc_RT_Time_Prog
L_End_Test_RT_OK:
	LDA		R_RT_M
;	ORA		R_RT_H
	BNE		L_Test_RT_Success
	LDA		R_RT_L
	CMP		#$10
	BCC		L_RT_High_Fail_Program
L_Test_RT_Success:	
	JMP		L_Set_Measure_Port_Low
	
L_RT_High_Fail_Program:
	JMP		L_RR_High_Fail_Program
	
L_RT_Low_Fail_Program:
	JMP		L_RR_Low_Fail_Program
;------------------------------------------------
L_Measure_RR_Prog:
	LDA		#$0
	STA		R_RR_L
	STA		R_RR_M
	STA		R_RR_H
	RMB0	P_TMRCTRL		;�ر�TMR0������
	TMR0_CLK_F4Mdiv32	
	LDA		#$0
	STA		P_TMR0			;TMR0������ʼֵΪ0
	RMB1	P_IFR

	LDA		P_PC_IO_Backup
	AND		#$BF	
	ORA		#$80
	STA		P_PC_IO_Backup 	
	STA		P_PC_IO			;����PC6 CMOS����� PC7Ϊ����
	
	LDA		P_PC_Backup		
	AND		#$7F
	ORA		#$40	
	STA		P_PC_Backup				
	STA		P_PC			;����PC6���1��PC7������	
	SMB0	P_TMRCTRL		;����TMR0������
L_Loop_Test_RR_Prog:
	BBS7	P_PC,L_Test_RR_OK
	BBR1	P_IFR,L_Loop_Test_RR_Prog
	RMB1	P_IFR	
	JSR		L_Inc_RR_Time_Prog
	LDA		R_RR_M	;#$F0	;#$A0		;04
	CMP		#$10
	BCS		L_RR_Low_Fail_Program
	BRA		L_Loop_Test_RR_Prog
L_Test_RR_OK:
	RMB0	P_TMRCTRL	;�ر�TMR0������
	LDA		P_TMR0
	STA		R_RR_L
	BBR1	P_IFR,L_End_Test_RR_OK
	RMB1	P_IFR	
	JSR		L_Inc_RR_Time_Prog
L_End_Test_RR_OK:
	LDA		R_RR_M
;	ORA		R_RR_H
	BNE		L_Test_RR_Success
	LDA		R_RR_L
	CMP		#$10
	BCC		L_RR_High_Fail_Program
L_Test_RR_Success:
	JSR		L_Set_Measure_Port_Low
	JSR		L_Counter_Temperature_Prog
	JSR		L_C_SwitchTo_F_Program
L_Reset_No_Temperature_Display:	
	LDA		R_Reset_Time
	BNE		L_Exit_End_Test_RR_OK
	JSR		L_Dis_Temperature_Prog
L_Exit_End_Test_RR_OK:	
	RTS
	
L_RR_High_Fail_Program:	
	JSR		L_Test_Fail_Program
	JMP		L_Temperature_High

L_RR_Low_Fail_Program:
	JSR		L_Test_Fail_Program
	JMP		L_Temperature_Low
	
L_Test_Fail_Program:
	LDA		#0H
	STA		R_Measure_Temperature
	JMP		L_Set_Measure_Port_Low
;-----------------------------------------
L_Inc_RT_Time_Prog:
	CLC
	CLD
	LDA		R_RT_M
	ADC		#1
	STA		R_RT_M
	LDA		R_RT_H
	ADC		#0
	STA		R_RT_H
	RTS
;-----------------------------------------
L_Inc_RR_Time_Prog:
	CLC
	CLD
	LDA		R_RR_M
	ADC		#1
	STA		R_RR_M
	LDA		R_RR_H
	ADC		#0
	STA		R_RR_H
	RTS	
;------------------------------------------------
;************************************************
;------------------------------------------------
L_Counter_Temperature_Prog:
	LDA		R_RT_L
	STA		P_Temp+13
	LDA		R_RT_M
	STA		P_Temp+14
	LDA		#0H		;R_RT_H	;
	STA		P_Temp+15
	LDA		R_RR_L
	STA		P_Temp+10
	LDA		R_RR_M
	STA		P_Temp+11			
	LDA		#0H 	;R_RR_H	; 
	STA		P_Temp+12
	JSR		L_Counter_T_Sbc_Prog
	LDA		P_Temp+9
	STA		P_Temp+7
	JSR		L_R0Data_LeftMove4Bit
	JSR		L_Counter_T_Sbc_Prog
	LDA		P_Temp+9
	STA		P_Temp+8
;	ASL		P_Temp+8
;	ASL		P_Temp+8
;	ASL		P_Temp+8
;	ASL		P_Temp+8	
	CLC
	ROL		P_Temp+8
	CLC
	ROL		P_Temp+8
	CLC
	ROL		P_Temp+8
	CLC
	ROL		P_Temp+8
	JSR		L_R0Data_LeftMove4Bit
	JSR		L_Counter_T_Sbc_Prog
	LDA		P_Temp+9
	ORA		P_Temp+8
	STA		P_Temp+8
	JSR		L_R0Data_LeftMove4Bit
	JSR		L_Counter_T_Sbc_Prog
	CLC
	LDA		#$F8
	ADC		P_Temp+9
	LDA		#0
	ADC		P_Temp+8
	STA		P_Temp+8
	LDA		#0
	ADC		P_Temp+7
	STA		P_Temp+7
	LDA		#0
	STA		P_Temp+6
	LDX		#0
L_Loop_Counter_T_Step1:
	SEC
	LDA		P_Temp+8
	SBC		Table_Temperature,X
	LDA		P_Temp+7
	SBC		#0
	BCC		L_Counter_T_Step2
	SEC
	LDA		P_Temp+8
	SBC		Table_Temperature,X
	STA		P_Temp+8
	LDA		P_Temp+7
	SBC		#0
	STA		P_Temp+7
	INX
	SED
	CLC
	LDA		#1
	ADC		P_Temp+6
	STA		P_Temp+6
	CLD
	BRA		L_Loop_Counter_T_Step1
L_Counter_T_Step2:
	LDA		P_Temp+6
	BNE		L_Counter_T_Step2_1
L_Temperature_Low:
	SMB5	R_Temperature_L
	RMB6	R_Temperature_L
	JMP		L_Reset_No_Temperature_Display
	
L_Counter_T_Step2_1:
	SEC
	LDA		#$60	;#$70
	SBC		P_Temp+6
	BCS		L_Counter_T_Step2_2
L_Temperature_High:
	SMB6	R_Temperature_L
	RMB5	R_Temperature_L	
	JMP		L_Reset_No_Temperature_Display	
	
L_Counter_T_Step2_2:
	JSR		L_Counter_T_Decimals
	SED
	SEC
	LDA		P_Temp+6
	SBC		#$11			;#$10
	BCS		L_Temperature_Over_0
	LDA		#$11
	STA		P_Temp
	SED
	LDA		P_Temp+5
	BEQ		L_Measure_Small0_Temp_L
	LDA		#$10
	STA		P_Temp
	SEC
	LDA		#$10
	SBC		P_Temp+5
L_Measure_Small0_Temp_L:	
	STA		R_Temperature_L
	SEC
	LDA		P_Temp		;#$11 	;10
	SBC		P_Temp+6
	STA		R_Temperature
	CLD
	LDA		R_Temperature_L
	AND		#$0F
	ORA		#$80
	STA		R_Temperature_L
	LDA		R_Temperature
	AND		#$F0
	BEQ		L_End_Counter_Temp_Small_0
	JMP		L_Temperature_Low
L_End_Counter_Temp_Small_0:	
	RTS
	
L_Temperature_Over_0:
	STA		R_Temperature
	LDA		P_Temp+5
	AND		#$0F
	STA		R_Temperature_L
	CLD
	RTS
;------------------------------------------------
L_Counter_T_Decimals:
	LDA		#$A
	STA		P_Temp
	LDA		#0
	STA		P_Temp+1
	STA		P_Temp+2
L_Loop_Mul10:
	LDA		P_Temp
	BEQ		L_Counter_T_Decimals_1
	CLC
	LDA		P_Temp+8
	ADC		P_Temp+2
	STA		P_Temp+2
	LDA		P_Temp+7
	ADC		P_Temp+1
	STA		P_Temp+1
	DEC		P_Temp
	BRA		L_Loop_Mul10
L_Counter_T_Decimals_1:
	LDA		#0
	STA		P_Temp+5
L_Loop_Counter_T_Decimals:
	SEC
	LDA		P_Temp+2
	SBC		Table_Temperature,X
	STA		P_Temp+2
	LDA		#0
	SBC		P_Temp+1
	STA		P_Temp+1
	BCC		L_End_Counter_T_Decimals
	INC		P_Temp+5
	BRA		L_Loop_Counter_T_Decimals
L_End_Counter_T_Decimals:
	RTS
;------------------------------------------------
L_R0Data_LeftMove4Bit:
	LDA		#4
	STA		P_Temp
L_Loop_LeftMove4Bit:
	LDA		P_Temp
	BEQ		L_End_R0Data_LeftMove4Bit
;	ASL		P_Temp+10
	CLC
	ROL		P_Temp+10
	ROL		P_Temp+11
	ROL		P_Temp+12
	DEC		P_Temp
	BRA		L_Loop_LeftMove4Bit
L_End_R0Data_LeftMove4Bit:
	RTS
;------------------------------------------------
L_Counter_T_Sbc_Prog:
	LDA		#0
	STA		P_Temp+9
L_Loop_Counter_T_Sbc:
	SEC
	LDA		P_Temp+10
	SBC		P_Temp+13
	LDA		P_Temp+11
	SBC		P_Temp+14
	LDA		P_Temp+12
	SBC		P_Temp+15
	BCC		L_End_Counter_T_Sbc_Prog
	SEC
	LDA		P_Temp+10
	SBC		P_Temp+13
	STA		P_Temp+10
	LDA		P_Temp+11
	SBC		P_Temp+14
	STA		P_Temp+11
	LDA		P_Temp+12
	SBC		P_Temp+15
	STA		P_Temp+12
	INC		P_Temp+9
	BRA		L_Loop_Counter_T_Sbc	
L_End_Counter_T_Sbc_Prog:
	RTS
;-----------------------------------------------
Table_Temperature:
;DB		122		;-10
;DB		5		;-9
;DB		6		;-8
;DB		6		;-7
;DB		6		;-6
;DB		6		;-5
;DB		6		;-4
;DB		7		;-3
;DB		7		;-2
;DB		8		;-1
;DB		8		;0
;DB		8		;1
;DB		9		;2
;DB		8		;3
;DB		10		;4
;DB		9		;5
;DB		11		;6
;DB		10		;7
;DB		11		;8
;DB		12		;9
;DB		12		;10
;DB		12		;11
;DB		13		;12
;DB		13		;13
;DB		14		;14
;DB		15		;15
;DB		15		;16
;DB		16		;17
;DB		16		;18
;DB		17		;19
;DB		18		;20
;DB		19		;21
;DB		19		;22
;DB		19		;23
;DB		21		;24
;DB		21		;25
;DB		22		;26
;DB		23		;27
;DB		24		;28
;DB		25		;29
;DB		25		;30
;DB		27		;31
;DB		27		;32
;DB		28		;33
;DB		30		;34
;DB		30		;35
;DB		31		;36
;DB		33		;37
;DB		33		;38
;DB		35		;39
;DB		36		;40
;DB		37		;41
;DB		38		;42
;DB		39		;43
;DB		41		;44
;DB		42		;45
;DB		43		;46
;DB		45		;47
;DB		46		;48
;DB		47		;49
;DB		49		;50
;DB		50		;51
;DB		52		;52
;DB		53		;53
;DB		55		;54
;DB		56		;55
;DB		58		;56
;DB		60		;57
;DB		61		;58
;DB		63		;59
;DB		65		;60
;DB		255		;-
;DB		255		;-
;DB		255		;-	
;======================10K�����======================	
	DB		60		;-10
	DB		3		;-9
	DB		3		;-8
	DB		3		;-7
	DB		3		;-6
	DB		3		;-5
	DB		4		;-4
	DB		3		;-3
	DB		4		;-2
	DB		4		;-1
	DB		4		;0
	DB		4		;1
	DB		4		;2
	DB		5		;3
	DB		4		;4
	DB		5		;5
	DB		5		;6
	DB		5		;7
	DB		5		;8
	DB		6		;9
	DB		6		;10
	DB		5		;11
	DB		7		;12
	DB		6		;13
	DB		6		;14
	DB		7		;15
	DB		7		;16
	DB		7		;17
	DB		8		;18
	DB		8		;19
	DB		8		;20
	DB		8		;21
	DB		9		;22
	DB		8		;23
	DB		10		;24
	DB		9		;25
	DB		10		;26
	DB		10		;27
	DB		10		;28
	DB		11		;29
	DB		11		;30
	DB		11		;31
	DB		12		;32
	DB		12		;33
	DB		13		;34
	DB		13		;35
	DB		13		;36
	DB		14		;37
	DB		14		;38
	DB		14		;39
	DB		15		;40
	DB		16		;41
	DB		15		;42
	DB		17		;43
	DB		17		;44
	DB		17		;45
	DB		18		;46
	DB		18		;47
	DB		19		;48
	DB		19		;49
	DB		20		;50
	DB		21		;51
	DB		21		;52
	DB		21		;53
	DB		23		;54
	DB		23		;55
	DB		23		;56
	DB		24		;57
	DB		25		;58
	DB		25		;59
	DB		27		;60
	DB		255		;-
	DB		255		;-
	DB		255		;-	
;===============================================
;R_Temperature_F_L
;R_Temperature_F_H
;-----------------------------------------------
L_C_SwitchTo_F_Program:
	LDA		R_Temperature_L
	STA		P_Temp+2
	LDA		R_Temperature
	STA		P_Temp+3
	LDA		#0
	STA		P_Temp+4
;	ASL		P_Temp+2
;	ASL		P_Temp+2
;	ASL		P_Temp+2
;	ASL		P_Temp+2
	CLC
	ROL		P_Temp+2
	CLC
	ROL		P_Temp+2
	CLC
	ROL		P_Temp+2
	CLC
	ROL		P_Temp+2
	SED
	CLC
	LDA		P_Temp+2
	ADC		P_Temp+2
	STA		P_Temp+2
	LDA		P_Temp+3
	ADC		P_Temp+3
	STA		P_Temp+3
	LDA		P_Temp+4
	ADC		P_Temp+4
	STA		P_Temp+4
	CLD
	LDA		#0
	STA		P_Temp+5
	STA		P_Temp+6
	STA		P_Temp+7
	LDA		#9
	STA		P_Temp+1
L_C_SwitchTo_F_Multiply9:
	LDA		P_Temp+1
	BEQ		L_Judge_TF_LL_Over_5
	SED
	CLC
	LDA		P_Temp+2
	ADC		P_Temp+5
	STA		P_Temp+5
	LDA		P_Temp+3
	ADC		P_Temp+6
	STA		P_Temp+6
	LDA		P_Temp+4
	ADC		P_Temp+7
	STA		P_Temp+7
	CLD
	DEC		P_Temp+1
	BRA		L_C_SwitchTo_F_Multiply9
L_Judge_TF_LL_Over_5:	
	LDA		P_Temp+5
	SBC		#$50
	BCC		L_C_SwitchTo_F_Adc32
	SED
	CLC
	LDA		#$01
	ADC		P_Temp+6
	STA		P_Temp+6
	LDA		#00
	ADC		P_Temp+7
	STA		P_Temp+7
	CLD
L_C_SwitchTo_F_Adc32:	
	BBS7	R_Temperature_L,L_C_SwitchTo_F_32Sub	;
	SED
	CLC
	LDA		#$20
	ADC		P_Temp+6
	STA		P_Temp+6
	LDA		#03
	ADC		P_Temp+7
	STA		P_Temp+7
	CLD
L_Exit_C_SwitchTo_F_Prog:
	LDA		P_Temp+6
	STA		R_Temperature_F_M
	LDA		P_Temp+7
	STA		R_Temperature_F_H
	RTS
	
L_C_SwitchTo_F_32Sub:
	SED
	SEC
	LDA		#$20
	SBC		P_Temp+6
	STA		P_Temp+6
	LDA		#$03
	SBC		P_Temp+7
	STA		P_Temp+7
	CLD
	JMP		L_Exit_C_SwitchTo_F_Prog
;-----------------------------------------------
