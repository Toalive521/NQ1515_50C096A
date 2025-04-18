;================================================
; Purpose	: Play Sentence ram define
; Edit by 	: John
; Edit data	: 2013-3-26 10:54
;================================================
;original voice table.
;Number
C_NumberX_              equ     000h
;0     00000081       00_8.ads     
;1     000003b1       12һ.ads     
;2     0000075a       13��.ads     
;3     00000a63       03_sp3.ads   
;4     00000d8f       04_n.ads     
;5     00001138       05_8.ads     
;6     000014f0       18��.ads     
;7     00001903       19��.ads     
;8     00001e52       20��.ads     
;9     00002179       09_spn.ads   
;a     0000259d       10ʰn1.ads   
;b     00002a33       14��02x.ads
C_NumberX               equ     00bh    
;special
C_SpecialX_             equ     00ch
;c     00002e04       01����~1.ads 
;d     000038d7       02�賿.ads   
;e     0000415a       06����.ads   
;f     00004841       03����.ads   
;10    00005030       04����.ads   
;11    00005773       05����.ads   
C_SpecialX              equ     011h
;unit
C_UnitX_                equ     012h
C_NodeHour              equ     012h
C_Unit_12h      equ     12h     ;12    00005fca       16��_8.ads   
C_Unit_13h      equ     13h     ;13    000062bb       11��b.ads    
C_Unit_14h      equ     14h     ;14    00006624       08��01.ads   
;12    00005fca       16��_8.ads   
;13    000062bb       11��b.ads    
;14    00006624       08��01.ads   
C_UnitX                 equ     014h
C_NodeMinute            equ     014h
;calendar
C_CalendarX_            equ     015h
C_NodeYear              equ     015h
C_NodeMonth             equ     016h
;15    00006963       24��.ads     
;16    00006e46       25��.ads     
;17    000071c3       37��_8.ads   
C_NodeDay               equ     017h
C_CalendarX             equ     017h
;temperature   
C_TemperatureX_         equ     018h
C_NodeTemperature_      equ     018h
C_NodeTemperature       equ     019h
C_Temperature_18h equ   18h     ;18    000075f6       30�¶�.ads   
C_Temperature_19h equ   19h     ;19    00007cb1       32��01.ads   
C_Temperature_1ah equ   1ah     ;1a    00007ee2       44��.ads 
C_Temperature_C equ   	1Bh
C_Temperature_F equ     1Ch    
;18    000075f6       30�¶�.ads   
;19    00007cb1       32��01.ads   
;1a    00007ee2       44��.ads   
;1b    00007cb1       ����.ads   
;1c    00007ee2       ����.ads    
C_TemperatureX          equ     01Ch
;key sound
C_KeySoundX_            equ     01Dh
C_KeySound_1bh  equ     1Dh     ;1b    000083f5       key25.stc    
C_KeySound_1ch  equ     1Eh     ;1c    00008401       05��.ads     
C_KeySound_1dh  equ     1Fh     ;1d    00008884       key7.stc     
;1d    000083f5       key25.stc    
;1e    00008401       05��.ads     
;1f    00008884       key7.stc     
C_KeySoundX             equ     01Fh
;alarm ring
C_AlarmRingX_           equ     020h
; 20   00008890       ������.ads   
; 21   0000a413       ������~1.ads 
; 22   0000ac96       di2.stc      
; 23   0000aca2       26.stc       
; 24   0000b353       22.stc       
; 25   0000b610       21.stc       
; 26   0000b95e       23.stc       
; 27   0000bd03       17.stc       
; 28   0000c016       14.stc       
C_ModeBiBi              equ     028h    
;27    0000c2ca       18.stc       
C_ModeBiBiBi            equ     029h 
C_AlarmRingX            equ     029h
;calendar
;28    0000c4ab       27����.ads   
C_NodeWeek              equ     02Ah
C_CalendarY_            equ     02Ah
C_ModeDong              equ     02Ah 
C_CalendarY             equ     02Ah
;2B    	0000cbba       11��_8.ads  
C_TemperatureY_         equ     02Bh
C_TemperatureY          equ     02Bh
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
C_StartPlay             equ     08h     
C_StartPlay_            equ     0f7h    
C_StartPlayBit          equ     3    
;--------------------------------------
C_SentenceStop          equ     0ffh
C_SentenceSamp          equ     0feh
C_SentenceMute          equ     0fdh
C_SentenceNewT          equ     0fch
C_SentenceNewT_AmPm     equ     0FFh
C_SentenceAjus_AmPm     equ     0FEH
C_SentenceNewT_SIGN     equ     0FDh
C_SentenceNewT_Temp     equ     0FCh

C_TableNotExist         equ     0
C_TableExist            equ     1

C_SelfTable             equ     0
C_New_Table             equ     1
C_Nxt_Table             equ     2

C_CheckUnitX            equ     4
C_CheckUnitX_CHIM       equ     2
C_CheckUnitXTempDot     equ     6

C_CheckTemperatureX     equ     8
C_CheckTemp_Degree      equ     2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
R_SentenceCtrl          DS      1
C_Sentence_Number       equ     01Fh
C_Sentence_Null_N       equ     0E0h
C_Sentence_Null         equ     00h 
C_SentenceYear_XX       equ     01h
C_SentenceYear_X        equ     02h
C_SentenceMonth_XX      equ     03h
C_SentenceMonth_X       equ     04h
C_SentenceDay_XX        equ     05h
C_SentenceDay_X         equ     06h
C_SentenceHour_XX       equ     07h
C_SentenceHour_X        equ     08h
C_SentenceMinute_XX     equ     09h
C_SentenceMinute_X      equ     0ah
C_SentenceTemp_XX       equ     0bh
C_SentenceTemp_X        equ     0ch
C_SentenceTemp_DotX     equ     0dh
C_SentenceWeek_X        equ     0eh
C_SentenceTemp_XXX      equ     0fh
C_SentenceTemp_XX_1     equ     10h
C_SentenceTemp_X_1      equ     11h
;--------------------------------------
C_SentenceAsNext        equ     020h
C_SentenceAsNext_N      equ     0DFh
C_SentenceAsNextBit     equ     5
;--------------------------------------
C_SentenceSampX         equ     040h
C_SentenceSampX_N       equ     0BFh
C_SentenceSampXBit      equ     6
;--------------------------------------
C_SentenceNewPlay       equ     080h
C_SentenceNewPlay_N     equ     07Fh
C_SentenceNewPlayBit    equ     7
;--------------------------------------
R_SentenceNumberXXX     DS      1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
R_SentenceStartAddr     DS      2
R_SentenceStartAddrBake DS      2
R_SentenceX10           DS      1
R_SentenceX01           DS      1
R_SentenceTmp           DS      1
;--------------------------------------
R_SentenceCtrl_1        DS      1
;--------------------------------------
C_SentenceAjustH        equ     001h
C_SentenceAjustH_N      equ     0feh
C_SentenceAjustHBit     equ     0
;--------------------------------------
C_SentenceAmPm          equ     002h
C_SentenceAmPm_N        equ     0fdh
C_SentenceAmPmBit       equ     1
;--------------------------------------
C_SentenceAmlEL         equ     004h
C_SentenceAmlEL_N       equ     0fbh
C_SentenceAmlELBit      equ     2
;--------------------------------------
C_SentenceCloseEL       equ     008h
C_SentenceCloseEL_N     equ     0f7h
C_SentenceCloseELBit    equ     3
;--------------------------------------
C_SentenceDelayEL       equ     010h
C_SentenceDelayEL_N     equ     0efh
C_SentenceDelayELBit    equ     4
;--------------------------------------
.if C_60ANot2Com
C_Sentence2Com          equ     020h
C_Sentence2Com_N        equ     0dfh
C_Sentence2ComBit       equ     5
.endif
;--------------------------------------
C_SentenceDelay1M       equ     040h
C_SentenceDelay1M_N     equ     0bfh
C_SentenceDelay1MBit    equ     6
;--------------------------------------
C_SentenceYearBit       equ     080h
C_SentenceYearBit_N     equ     07fh
C_SentenceYearBitBit    equ     7
;--------------------------------------
R_SentenceStep          ds      1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
S_sp00  equ 00h 
S_sp01  equ 01h 
S_sp02  equ 02h 
S_sp03  equ 03h 
S_sp04  equ 04h 
S_sp05  equ 05h 
S_sp06  equ 06h 
S_sp07  equ 07h 
S_sp08  equ 08h 
S_sp09  equ 09h 
S_sp10  equ 0ah 
S_sp11  equ 0bh 
S_sp12  equ 0ch 
S_sp13  equ 0dh 
S_sp14  equ 0eh 
S_A01   equ 0fh 
S_sp16  equ 10h
S_sp17  equ 11h
S_sp18  equ 12h
S_sp19  equ 13h
S_sp20  equ 14h
S_sp21  equ 15h
S_sp22  equ 16h
S_sp23  equ 17h
S_sp24  equ 18h
S_sp25  equ 19h
S_sp26  equ 1ah
S_sp27  equ 1bh
S_sp28  equ 1ch
S_sp29  equ 1dh
S_sp30  equ 1eh
S_sp31  equ 1fh
S_sp32  equ 20h
S_s01   equ 21h
S_s02   equ 22h
S_s03   equ 23h
S_s04   equ 24h
S_s05   equ 25h
S_s06   equ 26h
S_s07   equ 27h
S_s08   equ 28h
S_s09   equ 29h
S_s10   equ 2ah
S_s11   equ 2bh 
S_A02   equ 2ch
S_Vdi   equ 2dh
S_VdiY  equ S_sp10  ;S_sp11
S_sp33  equ 2eh
S_sp34  equ 2fh
S_Hundred equ 30h
S_C		equ 31h	
S_F		equ 32h
S_sp05_ equ S_sp34
S_sp09_ equ S_sp33

S_Bird	equ	33H
S_Bugu	equ	34H
;=========================
M_Num   equ 250
M_5X    equ 290
M_5X_10 equ 050
M_5XX   equ 480
;=========================
Test_Five   equ 0
