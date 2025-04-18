;--------------------------------------------------------
;--------------------------------------------------------
;;--------------------------------------------------------
;T_PingDay:		;Day/1
;	DB 31h,28h,31h,30h,31h,30h,31h,31h,30h,31h,30h,31h
;;T_RunDay:     29h
;T_MonthWeek:		;Week/7	Run(High) Ping(Low)
;	DB 00h,33h,43h,06h,21h,54h,06h,32h,65h,10h,43h,65h
T_RunPingYearWeek:	;(2040-2050)	High(Run 1 Ping 0) Low(Week)
	;  00  01  02  03  04  05  06  07  08  09
	DB 10h,02h,03h,04h,15h,00h,01h,02h,13h,05h
	;  10  11  12  13  14  15  16  17  18  19
	DB 06h,00h,11h,03h,04h,05h,16h,01h,02h,03h
;
;T_Year20Week:		;1980-2049
;	; 1980 2000 20  40
;	DB 02h,06h,03h,00h
;;T_Year20Week:		;1960-2060
;;	; 1960 80 2000 20  40  60
;;	DB 05h,02h,06h,03h,00h,04h
;--------------------------------------------------------
;F_GetWeek:
;	SED
;	SEC
;	LDA	R_TimeYearL
;	SBC	#D_LowYear&0FFh
;	STA	R_Temp
;	LDHN	R_Temp
;	STA	R_Temp
;	LDA	R_TimeYearH
;	SBC	#(D_LowYear/100h)&0FFh
;	CLD
;
;	BEQ	?_NextYear
;	CLC
;	LDA	#10
;	ADC	R_Temp
;	STA	R_Temp
;?_NextYear
;
;	LDA	R_Temp
;	CLC
;	ROR
;	TAX
;	LDA	T_Year20Week,X
;	STA	R_Temp
;
;	LDLN	R_TimeYearL
;	STA	R_Temp+1
;	LDA	R_TimeYearL
;	AND	#$10
;	BEQ	?_NoAdd10
;	LDA	#10
;?_NoAdd10
;	CLC
;	ADC	R_Temp+1
;	TAX
;	LDA	T_RunPingYearWeek,X
;	STA	R_Temp+1
;
;	AND	#$0F
;	CLC
;	ADC	R_Temp
;	STA	R_Temp
;	CMP	#$7
;	BCC	?_Little
;	SEC
;	LDA	R_Temp
;	SBC	#$7
;	STA	R_Temp
;?_Little
;	LDHN	R_Temp+1
;	STHN	R_Temp
;
;	LDHN	R_TimeMonth
;	BEQ	?_NoBig10
;	LDA	#10
;?_NoBig10
;	STA	R_Temp+1
;	CLC
;	LDLN	R_TimeMonth
;	ADC	R_Temp+1
;	SEC
;	SBC	#$1
;	TAX
;	LDA	T_MonthWeek,X
;	STA	R_Temp+1
;
;	LDHN	R_Temp
;	BNE	?_Run
;?_Ping
;	LDLN	R_Temp+1
;	BRA	?_RP
;?_Run
;	LDHN	R_Temp+1
;?_RP
;	CLC
;	ADC	R_Temp
;	AND	#$0F
;	STA	R_Temp
;	CMP	#$7
;	BCC	?_Little_
;	SEC
;	LDA	R_Temp
;	SBC	#$7
;	STA	R_Temp
;?_Little_
;
;	LDHN	R_TimeDay
;	BEQ	?_NoBig10Day
;	TAX
;	LDA	#$0
;	STA	R_Temp+1
;?_LoopX
;	CLC
;	LDA	#10
;	ADC	R_Temp+1
;	STA	R_Temp+1
;	DEX
;	BNE	?_LoopX
;	LDA	R_Temp+1
;?_NoBig10Day
;	STA	R_Temp+1
;	CLC
;	LDLN	R_TimeDay
;	ADC	R_Temp+1
;?_LoopDay
;	SEC
;	STA	R_Temp+1
;	SBC	#$7
;	BEQ	?_NextDay
;	BCS	?_LoopDay
;?_NextDay
;	LDA	R_Temp+1
;	DEC
;	STA	R_Temp+1
;
;	CLC
;	ADC	R_Temp
;	STA	R_Temp
;?_DayLoop
;	CMP	#$7
;	BCC	?_LittleDay
;	SEC
;	LDA	R_Temp
;	SBC	#$7
;	STA	R_Temp
;	BRA	?_DayLoop
;?_LittleDay
;
;	LDA	R_Temp
;	STA	R_TimeWeek
;	RTS

;--------------------------------------------------------
;********************************************************
;********************************************************
;********************************************************
;--------------------------------------------------------
F_GongLiChangeToNongLi:		;1077	Byte
	JSR	F_GetNongli
;	SED
;	LDA	R_TimeYearL
;	SEC
;	SBC	#01h
;	STA	R_NongLiTimeYearL
;	LDA	R_TimeYearH
;	SBC	#00h
;	STA	R_NongLiTimeYearH
;	CLD
	LDA	R_YearBeginDayM
	STA	R_NongLiTimeMonth
	LDA	R_YearBeginDayD
	STA	R_NongLiTimeDay

	JSR	F_GetGongliSumTotalDay
	SED
    LDA     R_GongLiDayL
    SEC
    SBC     #$1
    STA     R_GongLiDayL
    LDA     R_GongLiDayH
    SBC     #00h
    STA     R_GongLiDayH
    CLD

?_Next1_1
	LDA	#$30
	CLC
	ROR	R_MonthBeginDayL
	BCS	?_0_
	LDA	#$29
?_0_
	SED
	SEC
	SBC	R_NongLiTimeDay
	STA	R_Temp
	SEC
	SBC	R_GongLiDayL
	LDA	#$0
	SBC	R_GongLiDayH
	CLD
	BCC	?_NextMonth1_1

	SED
	CLC
	LDA	R_NongLiTimeDay
	ADC	R_GongLiDayL
	STA	R_NongLiTimeDay
	CLD
	JMP	?_NoRun
;	LDA	R_MonthBeginRun
;	CMP	R_NongLiTimeMonth
;	BEQ	?_Run	
;	JMP	?_NoRun
	
?_NextMonth1_1
	SED
	CLC
	LDA	R_Temp
	ADC	#$1
	STA	R_Temp
	SEC
	LDA	R_GongLiDayL
	SBC	R_Temp
	STA	R_GongLiDayL
	LDA	R_GongLiDayH
	SBC	#$0
	STA	R_GongLiDayH
	CLD
	LDA	#$1
	STA	R_NongLiTimeDay
	JSR	F_MonthAdd1Change

	LDX	#$0
?_Loop
	INX
	LDA	#$30
	CPX	#$8
	BCS	?_H
?_L
	CLC
	ROR	R_MonthBeginDayL
	BRA	?_HL
?_H
	CLC
	ROR	R_MonthBeginDayH
?_HL
	BCS	?_0_L
	LDA	#$29
?_0_L
	STA	R_Temp
	SED
	SEC
	LDA	R_GongLiDayL
	SBC	R_Temp
	STA	R_GongLiDayL
	LDA	R_GongLiDayH
	SBC	#$0
	STA	R_GongLiDayH
	CLD
	BCC	?_LoopEnd
	JSR	F_MonthAdd1Change
	BRA	?_Loop
?_LoopEnd
	SED
	CLC
	LDA	R_GongLiDayL
	ADC	R_Temp
	CLC
	ADC	R_NongLiTimeDay
	STA	R_NongLiTimeDay
	CLD

;	LDA	R_NongLiTimeYearH
;	CMP	R_TimeYearH
;	BNE	?_NoRun
;	LDA	R_NongLiTimeYearL
;	CMP	R_TimeYearL
;	BNE	?_NoRun
	LDA	R_MonthBeginRun
	BEQ	?_NoRun
	CMP	R_NongLiTimeMonth
	BCS	?_NoRun
;	LDA	R_NongLiTimeMonth
	SED
	SEC
	LDA	R_NongLiTimeMonth
	SBC	#$1
	STA	R_NongLiTimeMonth
	CLD
	CMP	R_MonthBeginRun
	BEQ	?_Run
?_NoRun
	LDA	#$00
	STA	R_MonthBeginRun
	BRA	?_RunEnd
?_Run
	LDA	#$FF
	STA	R_MonthBeginRun
?_RunEnd

?_End
	RTS
;--------------------------------------------------------
F_MonthAdd1Change:
	LDA	R_NongLiTimeMonth
	CMP	#$12
	BCS	?_YearMonthAdd1
?_MonthAdd1
	INCD	R_NongLiTimeMonth
	BRA	?_YearMonthAdd1End
?_YearMonthAdd1
	LDA	#$1
	STA	R_NongLiTimeMonth
;	INCD	R_NongLiTimeYearL
;	BCC		?_YearMonthAdd1End
;	INCD	R_NongLiTimeYearH
?_YearMonthAdd1End

?_End
	RTS
;--------------------------------------------------------
F_GetGongliSumTotalDay:
?_PingYear
	LDHN	R_TimeMonth
	BEQ	?_NoBig10
	LDA	#10
?_NoBig10
	STA	R_Temp
	CLC
	LDLN	R_TimeMonth
	ADC	R_Temp
	SEC
	SBC	#$1
	CLC
	ROL
	TAX
	LDA	T_PingDayAdd,X
	STA	R_GongLiDayL
	INX
	LDA	T_PingDayAdd,X
	STA	R_GongLiDayH

        SED
        LDA     R_GongLiDayL
        CLC
        ADC     R_TimeDay
        STA     R_GongLiDayL
        LDA     R_GongLiDayH
        ADC     #00h
        STA     R_GongLiDayH
        CLD

	LDA	R_TimeMonth
	CMP	#$2
	BCC	?_End
	BEQ	?_End

	LDLN	R_TimeYearL
	STA	R_Temp
	LDA	R_TimeYearL
	AND	#$10
	BEQ	?_NoAdd10
	LDA	#10
?_NoAdd10
	CLC
	ADC	R_Temp
	TAX
	LDA	T_RunPingYearWeek,X
	AND	#$F0
	BEQ	?_End
?_RunYear
        SED
        LDA     R_GongLiDayL
        CLC
        ADC     #01h
        STA     R_GongLiDayL
        LDA     R_GongLiDayH
        ADC     #00h
        STA     R_GongLiDayH
        CLD
?_End
	RTS
;--------------------------------------------------------
T_PingDayAdd:		;Day/1
	DW 00h,31h,59h,90h,120h,151h,181h,212h,243h,273h,304h,334h,365h
;T_RunDayAdd:	   60h
;--------------------------------------------------------
F_GetNongli:
	JSR	F_5mul
	JSR	F_NongLiNumber
	STA	R_YearBeginDayM
	INX
	JSR	F_NongLiNumber
	STA	R_YearBeginDayD
	INX
	JSR	F_NongLiNumber
	STA	R_MonthBeginDayL
	INX
	JSR	F_NongLiNumber
	STA	R_MonthBeginDayH
	INX
	JSR	F_NongLiNumber
	STA	R_MonthBeginRun
	RTS
;--------------------------------------------------------
F_NongLiNumber:
;	LDA	R_TimeYearH
;	CMP	#$20
;	BEQ	?_Frome2000
;?_Frome1900
;	LDHN	R_TimeYearL
;	CMP	#8
;	BEQ	?_1980
;	BRA	?_1990
?_Frome2000
	LDHN	R_TimeYearL
	BEQ	?_2000
	CMP	#1
	BEQ	?_2010
	CMP	#2
	BEQ	?_2020
	CMP	#3
	BEQ	?_2030
	
	CMP	#4
	BEQ	?_2040
	CMP	#5
	BEQ	?_2050
	CMP	#6
	BEQ	?_2060	
	CMP	#7
	BEQ	?_2070
	CMP	#8
	BEQ	?_2080
	BRA	?_2090
;?_1980:
;	LDA	T_NongLiDate1980,X
;	RTS
;?_1990:
;	LDA	T_NongLiDate1990,X
;	RTS
?_2000:
	LDA	T_NongLiDate2000,X
	RTS
?_2010:
	LDA	T_NongLiDate2010,X
	RTS
?_2020:
	LDA	T_NongLiDate2020,X
	RTS
?_2030:
	LDA	T_NongLiDate2030,X
	RTS
?_2040:
	LDA	T_NongLiDate2040,X
	RTS
?_2050:
	LDA	T_NongLiDate2050,X
	RTS
?_2060:
	LDA	T_NongLiDate2060,X
	RTS
?_2070:
	LDA	T_NongLiDate2070,X
	RTS
?_2080:
	LDA	T_NongLiDate2080,X
	RTS
?_2090:
	LDA	T_NongLiDate2090,X
	RTS
;--------------------------------------------------------
F_5mul:
	LDLN	R_TimeYearL
	STA	R_Temp
	LDA	#$0
	CLC
	LDX	R_Temp
?_Loop
	BEQ	?_LoopEnd
	ADC	#5
	DEX
	BRA	?_Loop
?_LoopEnd
	TAX
	RTS
;--------------------------------------------------------
T_NongLiDate:
;For example
; db 11h,14h,0a5h,16h,00h		;1980
; (11h,14h) 1980.01.01--->1979.11.14
; (0a5h,16h) Frome 1979.11month to 1980.10month NongLi
; (16h) BIT7:0 No Run,1 Run
; (00h) Run Month

T_NongLiDate1980:
	db 11h,14h,0a5h,16h,00h		;1980
	db 11h,26h,4bh,36h,00h		;1981
	db 12h,07h,4bh,9ah,04h		;1982
	db 11h,18h,97h,14h,00h		;1983
	db 11h,29h,37h,0a9h,10h		;1984
	db 11h,11h,5bh,09h,00h		;1985
	db 11h,21h,0dah,0ah,00h		;1986
	db 12h,02h,6ah,8bh,06h		;1987
	db 11h,12h,54h,1bh,00h		;1988
	db 11h,24h,A5h,3Ah,00h		;1989
T_NongLiDate1990:
	db 12h,05h,25h,9dh,05h		;1990
	db 11h,16h,4bh,1ah,00h		;1991
	db 11h,27h,9bh,34h,00h		;1992
	db 12h,09h,adh,94h,03h		;1993
	db 11h,20h,5dh,09h,00h		;1994
	db 12h,01h,adh,89h,08h		;1995
	db 11h,11h,06ah,0Dh,00h		;1996
	db 11h,22h,54h,1bh,00h		;1997
	db 12h,03h,92h,8dh,05h		;1998
	db 11h,14h,26h,1dh,00h		;1999
T_NongLiDate2000:
	db 11h,25h,4dh,1ah,00h		;2000
	db 12h,07h,56h,8ah,04h		;2001
	db 11h,18h,0aeh,14h,00h		;2002
	db 11h,29h,6dh,29h,00h		;2003
	db 12h,10h,0b5h,8ah,02h		;2004
	db 11h,21h,0aah,15h,00h		;2005
	db 12h,02h,0aah,96h,07h		;2006
	db 11h,13h,93h,0eh,00h		;2007
	db 11h,23h,26h,2dh,00h		;2008
	db 12h,06h,27h,95h,05h		;2009
T_NongLiDate2010:
	db 11h,17h,057h,0ah,00h		;2010
	db 11h,27h,0b6h,14h,00h		;2011
	db 12h,08h,5ah,95h,04h		;2012
	db 11h,20h,0d5h,0ah,00h		;2013
	db 12h,01h,55h,8bh,09h		;2014
	db 11h,11h,4ah,17h,00h		;2015
	db 11h,22h,95h,36h,00h		;2016
	db 12h,04h,95h,9ah,06h		;2017
	db 11h,15h,2bh,15h,00h		;2018
	db 11h,26h,57h,32h,00h		;2019
T_NongLiDate2020:
	db 12h,07h,5dh,8ah,04h		;2020
	db 11h,18h,5ah,15h,00h		;2021
	db 11h,29h,0d5h,2ah,00h		;2022
	db 12h,10h,65h,8bh,02h		;2023
	db 11h,20h,4ah,1bh,00h		;2024
	db 12h,02h,4ah,9dh,06h		;2025
	db 11h,13h,95h,1ch,00h		;2026
	db 11h,24h,2dh,19h,00h		;2027
	db 12h,05h,2eh,99h,05h		;2028
	db 11h,17h,0adh,12h,00h		;2029
T_NongLiDate2030:
	db 11h,28h,6bh,15h,00h		;2030
	db 12h,08h,0ach,95h,03h		;2031
	db 11h,19h,0a5h,0dh,00h		;2032
	db 12h,01h,0a5h,8eh,07h		;2033  ;备注 有的是润7月，有的算法是闰11月
	db 11h,11h,4ah,8dh,00h		;2034
	db 11h,22h,96h,2ch,00h		;2035
	db 12h,04h,97h,94h,06h		;2036
	db 11h,16h,2fh,09h,00h		;2037
	db 11h,26h,0aeh,12h,00h		;2038
	db 12h,07h,0b6h,8ah,05h		;2039
T_NongLiDate2040:
	db 11h,17h,0b4h,16h,00h		;2040
	db 11h,29h,0a9h,2dh,00h		;2041
	db 12h,10h,0a5h,96h,02h		;2042
	db 11h,21h,4bh,36h,00h		;2043
	db 12h,02h,4bh,9ah,07h		;2044
	db 11h,14h,97h,14h,00h		;2045
	db 11h,25h,57h,29h,00h		;2046
	db 12h,06h,5bh,89h,05h		;2047
	db 11h,16h,0dah,12h,00h		;2048
	db 11h,28h,0d5h,16h,00h		;2049
	
T_NongLiDate2050:
	db 12h,08h,52h,9Bh,03h		;2050
	db 11h,19h,25h,1Bh,00h		;2051
	db 11h,30h,4Bh,BAh,08h		;2052
	db 11h,12h,4Bh,1Ah,00h		;2053
	db 11h,23h,9Bh,34h,00h		;2054
	db 12h,04h,ADh,94h,06h		;2055
	db 11h,15h,5Dh,09h,00h		;2056
	db 11h,26h,5Ah,15h,00h		;2057
	db 12h,07h,AAh,8Dh,04h		;2058
	db 11h,17h,54h,1Dh,00h		;2059
T_NongLiDate2060:
	db 11h,28h,25h,1Dh,00h		;2060
	db 12h,10h,26h,9Dh,03h		;2061
	db 11h,21h,4Dh,1Ah,00h		;2062
	db 12h,02h,56h,8Ah,07h		;2063
	db 11h,13h,AEh,14h,00h		;2064
	db 11h,25h,6Dh,29h,00h		;2065
	db 12h,06h,B5h,8Ah,05h		;2066
	db 11h,16h,AAh,15h,00h		;2067
	db 11h,27h,95h,2Dh,00h		;2068
	db 12h,09h,95h,8Eh,04h		;2069	
T_NongLiDate2070:
	db 11h,19h,2Ah,2Dh,00h		;2070
	db 12h,01h,2Bh,95h,08h		;2071
	db 11h,12h,57h,0Ah,00h		;2072
	db 11h,23h,B6h,14h,00h		;2073
	db 12h,04h,5Ah,95h,06h		;2074
	db 11h,15h,D5h,0Ah,00h		;2075
	db 11h,25h,AAh,16h,00h		;2076
	db 12h,07h,4Ah,97h,04h		;2077
	db 11h,18h,95h,16h,00h		;2078
	db 11h,29h,2Bh,35h,00h		;2079
T_NongLiDate2080:
	db 12h,10h,2Bh,99h,03h		;2080
	db 11h,22h,5Bh,32h,00h		;2081
	db 12h,03h,9Dh,92h,07h		;2082
	db 11h,14h,5Bh,15h,00h		;2083
	db 11h,24h,D5h,2Ah,00h		;2084
	db 12h,06h,65h,8Bh,05h		;2085
	db 11h,16h,4Ah,1Bh,00h		;2086
	db 11h,27h,95h,3Ah,00h		;2087
	db 12h,08h,95h,9Ch,04h		;2088
	db 11h,20h,2Dh,1Ah,00h		;2089
T_NongLiDate2090:
	db 12h,01h,2Eh,99h,08h		;2090
	db 11h,12h,ADh,12h,00h		;2091
	db 11h,23h,6Dh,15h,00h		;2092
	db 12h,04h,ACh,95h,06h		;2093
	db 11h,15h,A9h,0Dh,00h		;2094
	db 11h,25h,4Ah,1Dh,00h		;2095
	db 12h,06h,4Ah,8Eh,04h		;2096
	db 11h,18h,16h,0Dh,00h		;2097
	db 11h,29h,2Eh,2Ah,00h		;2098
	db 12h,11h,37h,89h,02h		;2099	
;--------------------------------------------------------
;--------------------------------------------------------
;--------------------------------------------------------























