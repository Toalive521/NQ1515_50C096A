
.Kdata
;***************************************
; RAM Address
;***************************************
RamStarAddr		EQU		1800H
LCD_RamAddr		EQU		RamStarAddr
Time_Addr		EQU     RamStarAddr+Time_Str_Addr-Page0RamStarAddr
Digit1		EQU     1	
Digit2		EQU     2	
Digit3		EQU     3	
Digit4		EQU     4	
Digit5		EQU     5	
Digit6		EQU     6	
Digit7		EQU     7	
Digit8		EQU     8	
Digit9		EQU     9	
Digit10		EQU     10
Digit11		EQU     11	
Digit12		EQU     12
Digit13		EQU     13	
Digit14		EQU     14
Digit15		EQU     15	
Digit16		EQU     16	
BIT7:	EQU	7
BIT6:	EQU	6
BIT5:	EQU	5
BIT4:	EQU	4
BIT3:	EQU	3
BIT2:	EQU	2
BIT1:	EQU	1
BIT0:	EQU	0	

DATA0			EQU	0
DATA1			EQU	1
DATA2			EQU	2
DATA3			EQU	3
DATA4			EQU	4
DATA5			EQU	5
DATA6			EQU	6
DATA7			EQU	7	
;***************************************
.PAGE0
;***************************************
	ORG	0080H
Page0RamStarAddr	EQU		$	
LCDRAM				DS	6*4
;---------------------------------------------------------------------
TMP					DS	1		;98

FLAG				DS	1
Flag_NongLi		EQU		FLAG		
Bit_NongLi		EQU		0			;农历标志位	
Flag_3sDAlarm	EQU		FLAG
Bit_3sDAlarm	EQU		1			;显示3级闹钟 

Flag_KeyXing	EQU		FLAG		;按键型号标志位	
Bit_AXing		EQU		3			;A型按键标志位	
Bit_BXing		EQU		4			;B型按键标志位	
Bit_CXing		EQU		5			;C型按键标志位	

KNOB_OLD		.DS		1
KNOB_LNG		.DS		1
PA3_Now			.DS		1
PA4_Now			.DS		1
PA3_Last		.DS		1
PA4_Last		.DS		1

FLAG_2				DS	1
Flag_TimeSetK	EQU		FLAG_2			;时间设置按键标志位	
Bit_TimeSetK		EQU		0			;时间设置按键标志位	
Flag_AlarmSetK	EQU		FLAG_2			;闹钟设置按键标志位	
Bit_AlarmSetK	EQU		1			;闹钟设置按键标志位	
Flag_UpK			EQU		FLAG_2			;上按键标志位	
Bit_UpK			EQU		2			;上按键标志位	
Flag_DownK		EQU		FLAG_2			;下按键标志位	
Bit_DownK		EQU		3			;下按键标志位	
Flag_SnzK		EQU		FLAG_2			;SNZ按键标志位	
Bit_SnzK		EQU		4			;SNZ按键标志位	

FLAG_3				DS	1		;3	
FLAG_AlarmSet		EQU		FLAG_3			;闹钟设置标志位	
Bit_AlarmSet		EQU		0			;闹钟设置标志位	

FLAG_NongLiD			EQU		FLAG_3
Bit_NongLiD			EQU		1			;农历标志位

FLAG_RNOB		EQU		FLAG_3			;
BIT_RNOB		EQU		2			;

FLAG_KEYSTOP	EQU		FLAG_3
BIT_KEYSTOP		EQU		3
; Flag_KeyHold	EQU		FLAG			;按键保持标志位	
; Bit_KeyHold	EQU		4			;按键保持标志位	

Sys_Flag_A			ds	1		;0	
;bit0 = half sec flag, bit1 =1 Sec Flag ��bit2 =lcd init flag , bit3=�����־
;bit4 = key hold flag, bit5 = 12/24Сʱ��־��bit6=1/4��flag , bit7= C/F
Sys_Flag_B			ds	1		;1
;bit0=Fast flag, bit1=��Ч����־��bit2=Add1 flag, bit3=�������ֱ�־
;bit4=Alarm Arrive,bit5=16Hz, bit6=���ֱ�־, bit7=������/�رձ�־
Sys_Flag_C			ds	1		;2
;bit0=Monthday_key, ;bit1=Monthday_key����3���־;bit2=VOICE ;
;bit3=��Ƶ4M/8M��־	
;bit4=整点报时 bit5=Year_key
;bit6=FastKEY_Flag
;bit7=ZZ
Sys_Flag_D			ds	1		;2
;bit0=lcd2
;bit1=0 Alarm1on =1 OFF
;bit2=0 Alarm2on =1 OFF
;bit3=0 Alarm3on =1 OFF
;bit4=����������=1����ũ��
;bit5=Min_Day_CF_key;
;bit6=Min_Day_CF_key����3���־
;bit7=0 LCD2��ʾ���� =1 lcd2��ʾũ��

R_Int_Backup			DS	1
R_SetTime				DS	1
R_Mode_Flag				DS	1	;3
R_Voice_Unit			DS 	1   ;A
;---------------------------------------
Time_Str_Addr	EQU		$
R_Time_Sec		    	DS	1	;0
R_Time_Min		    	DS	1	;1
R_Time_Hr		    	DS	1	;2
R_Time_Day		    	DS	1	;3
R_TimeDay		EQU		R_Time_Day				
R_Time_Month	    	DS	1	;4
R_TimeMonth		EQU		R_Time_Month
R_Time_Year		    	DS	1	;5
R_TimeYearL				EQU	R_Time_Year
R_Time_Week	    		DS	1	;6

R_Alarm_Min1	   		DS	1	;7
R_Alarm_Min2	   		DS	1	;
R_Alarm_Min3	   		DS	1	;
R_Alarm_Hr1		    	DS	1	;8	
R_Alarm_Hr2		    	DS	1	;

R_Alarm_Hr3		    	DS	1	;

R_Alarm_Mode		    DS	1	;

R_Alarm_Way				DS	1	;
R_Alarm_Music			DS  1
;---------------------------------------
R_Key_Value				DS	1
R_SlideKey_Value		DS	4	;
;R_RT_L					DS	1
;R_RT_M					DS  1
;R_RT_H                 DS  1
;R_RR_L					DS	1
;R_RR_M                 DS  1
;R_RR_H                 DS  1
R_Measure_Temperature   DS  1
R_Temperature          	DS	1
R_Temperature_L         DS  1
R_Temperature_F_M		DS	1
R_Temperature_F_H	    DS  1	
;---------------------------------------  
P_Temp					DS	10
R_Temp				equ		P_Temp
R_Tmp0				EQU		P_Temp+0
R_Tmp1				EQU		P_Temp+1
R_Tmp2				EQU		P_Temp+2
R_Tmp3				EQU		P_Temp+3



lcd_tmp_mask		DS		1
lcd_tmp_bit			DS		1

R_NongLiTimeMonth		DS  1
R_NongLiTimeDay			DS  1
R_MonthBeginRun			DS  1

R_YearBeginDayM		EQU		P_Temp+5
R_YearBeginDayD		EQU		P_Temp+6
R_MonthBeginDayL	EQU		P_Temp+7
R_MonthBeginDayH	EQU		P_Temp+8
R_GongLiDayL		EQU		P_Temp+9	
R_GongLiDayH		EQU		P_Temp+10

R_ReceiveBuffer			DS  2
;---------------------------------------
R_SetDelay				DS	1	;
C_NeedSentence  		equ 1
C_SampleRate    		equ 0FBH
Num_xianzai				EQU	0CH
.INCLUDE	Sound.lib
.INCLUDE	Sound.inc
.if C_NeedSentence
.INCLUDE    SentPlay.inc
.endif
.ENDS
;***************************************
.Udata
;---------------------------------------
	ORG    1880H
R_APM	    			DS  1
R_SlideKey1_Value		DS	1	;
R_SlideKey2_Value		DS	1	;
R_RT_L					DS	1
R_RT_M					DS  1
R_RT_H                  DS  1
R_RR_L					DS	1
R_RR_M                  DS  1
R_RR_H                  DS  1	

R_Light_Time			DS	1   ;4
R_Snooze_Times			DS	1   ;5
R_SnoozeTime_Minute		DS	1   ;6
R_KeyHold_Time	    	DS	1   ;8
R_Fast_Time	    		DS	1   ;9
R_Reset_Time			DS	1   ;7
R_Strong_Time			DS	1   ;7
P_PC_IO_Backup      	DS	1	;C
P_PC_Backup       		DS	1	;D
P_PD_IO_Backup      	DS	1	;E
P_PD_Backup       		DS	1	;F

;R_NongLiTimeMonth		DS  1
;R_NongLiTimeDay			DS  1
;R_MonthBeginRun			DS  1
;
;R_YearBeginDayM			DS  1
;R_YearBeginDayD			DS  1
;R_MonthBeginDayL		DS  1
;R_MonthBeginDayH		DS  1
;R_GongLiDayL			DS  1	
;R_GongLiDayH			DS  1
;---------------------------------------
	ORG    1890H
;---------------------------------------

.ENDS

