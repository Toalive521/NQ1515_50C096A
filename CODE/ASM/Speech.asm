;=====================================================================
;			�������Ӳ��ų���
; 680 Byte
;=====================================================================
C_ReciverHour_XX    equ 0ffh
C_ReciverHour_X_    equ 0feh
C_ReciverHour__X    equ 0fdh
C_ReciverMinu_XX    equ 0fch
C_ReciverMinu_X_    equ 0fbh
C_ReciverMinu__X    equ 0fah
C_ReciverTemp_XX    equ 0f9h
C_ReciverTemp_X_    equ 0f8h
C_ReciverTemp__X    equ 0f7h
C_ReciverTemp_DotX  equ 0f6h
C_ReciverTempSign	equ 0f5h
C_ReciverAMP_XX		equ 0f4h
C_ReciverTemp_XXX   equ 0f3h
C_ReciverTemp_Bai   equ 0f2h
C_ReciverTempF_X_	equ	0f1h
C_ReciverTempF__X    equ 0f0h
C_ReciverTempF_DotX  equ 0efh
C_ReciverTempF_10	equ 0eeh
C_ReciverTempF__10   equ 0edh
C_ReciverHrZen   	equ 0ech
C_ReciverMinuZen_X_	equ 0eBh
C_ReciverMinuZen__X	equ 0eAh
C_ReciverZenFen		equ 0e9h
C_ReciverNum_xianzai equ 0e8h
C_AlarmRingX_Num	 equ 0e7h		

C_SpeechEnd:	    equ	0e6h
;=====================================================================
F_StartPlaySentence:		;input : sentence offset
	sta	R_SentenceStep
	xSETB	R_SoundCtrl,C_StartPlayBit  
	rts
F_PlaySentence:
	xJB		R_SoundCtrl,C_SentencePlayingBit,L_SkipSentencePlaying 
	xJNB	tmrc,DATA7,L_ContinueSentencePlaying
L_SkipSentencePlaying:
	rts
L_ContinueSentencePlaying:
	xJB	R_SoundCtrl,C_StartPlayBit,L_StartPlaying 
	rts
L_StartPlaying:
;;	ldx	R_SentenceStep
;;	cpx	#E_DingDongTimerTemp
;;	bne	L_ContinuePlaySentence
	ldx	R_SentenceStep
	lda	T_SentenceTab,x
	cmp	#C_SpeechEnd
	bne	L_ContinuePlaySentence
L_Get_FFPlaySentence:
	xCLRB	R_SoundCtrl,C_StartPlayBit 
?L_PlayExit:
	rts

L_ContinuePlaySentence:
	inc	R_SentenceStep
	lda	T_SentenceTab,x
	jsr	F_GetReciverNumberX
	   	
	cmp	#$FF
	beq	L_Get_FFPlaySentence
	   	
	sta	R_SayDataTemp1
	sta	R_SayDataTemp2
	   	
	ldx	R_SentenceStep
	inc	R_SentenceStep
	lda	T_SentenceTab,x
	sta	R_SentenceTmp
	ldx	#0ffh
L_LoopForCheckFunc:
	inx
	cpx	#E_NumberNode
	beq	L_Get_FFPlaySentence
	lda	T_NumberNode,x
	cmp	R_SentenceTmp
	bne	L_LoopForCheckFunc
	cpx	#0
	beq	F_ReturnAddr
	txa	
	sta	R_SentenceTmp
	ldx	#0
	lda	T_NumberFunc+1,x
	pha	
	lda	T_NumberFunc,x
	pha	
	lda	R_SentenceTmp
	clc	
	rol	A
	tax	
	lda	T_NumberFunc+1,x
	pha	
	lda	T_NumberFunc,x
	pha
	rts
F_ReturnAddr:    
	ldx	R_SentenceStep
	inc	R_SentenceStep
	lda	T_SentenceTab,x
	jsr	F_GetReciverNumberX
	jsr	PlaySound
	rts
;-----------------------------------
F_GetReciverNumberX:
	sta	R_SentenceTmp
	ldx	#0ffh
L_LoopSearchCtrl:
	inx     
	cpx	#E_ReciverNumberCtrl
	beq	L_ReturnError
	lda	T_ReciverNumberCtrl,x
	cmp	R_SentenceTmp
	bne	L_LoopSearchCtrl
	txa
	clc
	rol	A
	tax
	lda	T_ReciverNumberFunc+1,x
	pha
	lda	T_ReciverNumberFunc,x
	pha
	rts
L_ReturnError:
	lda	R_SentenceTmp
	rts
T_ReciverNumberCtrl:
	db	C_ReciverHour_XX    ;00
	db	C_ReciverHour_X_    ;01
	db	C_ReciverHour__X    ;02
	db	C_ReciverMinu_XX    ;03
	db	C_ReciverMinu_X_    ;04
	db	C_ReciverMinu__X    ;05
	db	C_ReciverTemp_XX    ;06
	db	C_ReciverTemp_X_    ;07
	db	C_ReciverTemp__X    ;08
	db	C_ReciverTemp_DotX	;09
	db	C_ReciverTempSign	;10
	db	C_ReciverAMP_XX		;11
	db	C_ReciverTemp_XXX   ;12
	db	C_ReciverTemp_Bai   ;13
	db	C_ReciverTempF_X_	;14
	db	C_ReciverTempF__X   ;15 
	db	C_ReciverTempF_DotX ;16 
	db	C_ReciverTempF_10 	;17
	db	C_ReciverTempF__10 	;18
	db	C_ReciverHrZen		;19
	dB	C_ReciverMinuZen_X_
	dB	C_ReciverMinuZen__X	
	dB	C_ReciverZenFen
	DB	C_ReciverNum_xianzai	
	db	C_AlarmRingX_Num

E_ReciverNumberCtrl equ $-T_ReciverNumberCtrl
;------------------------------------
T_ReciverNumberFunc:
	dw	F_ReciverHour_XX-1  ;00  
	dw	F_ReciverHour_X_-1  ;01  
	dw	F_ReciverHour__X-1  ;02  
	dw	F_ReciverMinu_XX-1  ;03  
	dw	F_ReciverMinu_X_-1  ;04  
	dw	F_ReciverMinu__X-1  ;05  
	dw	F_ReciverTemp_XX-1  ;06  
	dw	F_ReciverTemp_X_-1  ;07  
	dw	F_ReciverTemp__X-1  ;08  
	dw	F_ReciverTemp_DotX-1 ;09	
	dW	F_ReciverTempSign-1	 ;10	
	dw	F_ReciverAMP_XX-1	 ;11
	dw	F_ReciverTemp_XXX-1   ;12
	dw	F_ReciverTemp_Bai-1    ;13
	dw	F_ReciverTempF_X_-1	  ;14
	dw	F_ReciverTempF__X-1   ;15 
	dw	F_ReciverTempF_DotX-1 ;16 
	dw	F_ReciverTempF_10-1   ;17
	dw	F_ReciverTempF__10-1  ;18		
	dw	F_ReciverHrZen-1	;19
	dw	F_ReciverMinuZen_X_-1
	dw	F_ReciverMinuZen__X-1	
	dw	F_ReciverZenFen-1
	DW	F_ReciverNum_xianzai-1
	dw	F_AlarmRingX_Num-1	
	
E_ReciverNumberFunc equ $-T_ReciverNumberFunc
;------------------------------------
;Write wanted data to A
;Return A value
F_ReciverAMP_XX:		;�ϣ��У��£�����
	LDA		R_APM
	TAX
	LDA		T_ReciverAMP,X
	RTS
T_ReciverAMP:
	DB		FFH
	DB		0DH
	DB		0FH	
	DB		10H
	DB		11H
	DB		0EH	
	DB		FFH	

F_ReciverHour_XX:
	lda		R_ReceiveBuffer+0
	rts
F_ReciverHour_X_:
	LDHN	R_ReceiveBuffer+0
	rts
F_ReciverHour__X:  
	LDLN	R_ReceiveBuffer+0
	rts
F_ReciverMinu_XX:  
	lda		R_ReceiveBuffer+1
	rts
F_ReciverMinu_X_:  
	LDHN	R_ReceiveBuffer+1
	rts
F_ReciverMinu__X:      
	LDLN	R_ReceiveBuffer+1
	rts
F_ReciverHrZen:
	LDA		R_ReceiveBuffer+1
	BNE		L_Get_FF
	lda		#13h			;��
	rts
F_ReciverMinuZen_X_:
	LDA		R_ReceiveBuffer+1
	BNE		F_ReciverMinu_X_
	BRA		L_Get_FF
F_ReciverMinuZen__X:
	LDA		R_ReceiveBuffer+1
	BNE		F_ReciverMinu__X      
	BRA		L_Get_FF
F_ReciverZenFen:
	LDA		R_ReceiveBuffer+1
	BEQ		L_Get_FF  
	lda		#14h		 ;��
	rts	
	
F_ReciverTemp_XX:
	BBS5	R_Temperature_L,L_Get_10	;10
	BBS6	R_Temperature_L,L_Get_50	;50
	lda		R_Temperature 	
	rts
L_Get_10:
	lda		#10H 	
	rts
L_Get_50:
	lda		#50H 	
	rts	

F_ReciverTempSign:
	BBS5	R_Temperature_L,L_Get_Sign
	BBS6	R_Temperature_L,L_Get_FF
	BBR7	R_Temperature_L,L_Get_FF
L_Get_Sign:	
	LDA		#1AH	;����
	RTS

F_ReciverTemp_XXX:			;1��
	BBS5	R_Temperature_L,L_Get_FF
	BBS6	R_Temperature_L,L_Continue_100
	LDA		R_Temperature_F_H
	and		#$F0
	BEQ		L_Get_FF
L_Continue_100:	
	lda		#$01
	RTS
	
F_ReciverTemp_Bai:
	BBS5	R_Temperature_L,L_Get_FF
	BBS6	R_Temperature_L,F_End_ReciverTemp_Bai
	LDA		R_Temperature_F_H
	and		#$F0
	BEQ		L_Get_FF
F_End_ReciverTemp_Bai:	
	lda		#2BH
	RTS
	
F_ReciverTempF_X_:			;ʮλ
	BBS5	R_Temperature_L,L_Continue_100	;1
	BBS6	R_Temperature_L,L_Get_2
	LDA		R_Temperature_F_H
	and		#$0F
	BNE		Lxx
	LDA		R_Temperature_F_M	
	and		#$F0
	BNE		Lxx
L_Get_FF:	
	LDA		#$FF
	RTS
Lxx:	
	LDLN	R_Temperature_F_H
	RTS
L_Get_2:
	LDA		#$02
	RTS	
	
F_ReciverTempF__X:			;��λ
	BBS5	R_Temperature_L,L_Get_4
	BBS6	R_Temperature_L,L_Get_2
	LDA		R_Temperature_F_M	
	and		#$F0
	Beq		L_Get_FF
	LDHN	R_Temperature_F_M
	RTS
L_Get_4:
	LDA		#$04
	RTS		
	
F_ReciverTempF_DotX:		;С����λ	
	BBS5	R_Temperature_L,L_Get_0	;0
	BBS6	R_Temperature_L,L_Get_0	;0
	LDLN	R_Temperature_F_M
	RTS

F_ReciverTempF_10:		;ʰ
	BBS5	R_Temperature_L,L_Get_1
	BBS6	R_Temperature_L,L_Get_1
	LDA		R_Temperature_F_H
	and		#$0F
	BEQ		L_Get_FF
L_Get_1:	
	LDA		#01
	RTS	
F_ReciverTempF__10:		;ʰ
	BBS5	R_Temperature_L,L_Get_0
	BBS6	R_Temperature_L,L_Get_0
	LDA		R_Temperature_F_H
	and		#$0F
	BEQ		L_Get_FF 
L_Get_0:	
	LDA		#00	
	RTS

F_ReciverTemp_X_:
	BBS5	R_Temperature_L,L_Get_1	;1
	BBS6	R_Temperature_L,L_Get_5	;5
	LDHN	R_Temperature
	rts	
L_Get_5:
	lda		#05H 	
	rts	
	
F_ReciverTemp__X:
	BBS5	R_Temperature_L,L_Get_0	;0
	BBS6	R_Temperature_L,L_Get_0	;0
	LDLN	R_Temperature
	rts
	
F_ReciverTemp_DotX:
	BBS5	R_Temperature_L,L_Get_0	;0
	BBS6	R_Temperature_L,L_Get_0	;0
	LDLN	R_Temperature_L
	RTS	

F_ReciverNum_xianzai:
	LDA		R_Mode_Flag
	CMP		#1
	BEQ		L_Get_FF
	LDA		#Num_xianzai
	RTS
	
F_AlarmRingX_Num:
	LDA		R_Alarm_Music
	TAX
	LDA		T_AlarmRingX_Num,X
	RTS
T_AlarmRingX_Num:
	DB		FFH
	DB		C_AlarmRingX_+0
	DB		C_AlarmRingX_+1
	DB		C_AlarmRingX_+2		
	DB		C_AlarmRingX_+3	
	DB		C_AlarmRingX_+4
	DB		C_AlarmRingX_+5
	DB		C_AlarmRingX_+6
	DB		C_AlarmRingX_+7
	DB		FFH	
;------------------------------------
T_SentenceTab:
;T_DingDongTimerTemp:
D_DingDongTimeTemp_C:	.equ	$-T_SentenceTab	 
	db	0,C_Sentence_Null,C_KeySound_1ch ;C_KeySound_1bh
	db	0,C_Sentence_Null,C_ReciverNum_xianzai	 ;����ʱ��
	db	0,C_Sentence_Null,C_ReciverAMP_XX	;����������
	
	db	C_ReciverHour_XX,C_SentenceHour_XX,C_ReciverHour_X_
	db	C_ReciverHour_XX,C_SentenceHour_X,C_ReciverHour__X
	db	0,C_Sentence_Null,C_Unit_12h		;��
	
;	db	C_ReciverMinu_XX,C_SentenceMinute_XX,C_ReciverMinu_X_
;	db	C_ReciverMinu_XX,C_SentenceMinute_X,C_ReciverMinu__X      	
;	db	0,C_Sentence_Null,C_Unit_14h		;��
	db	0,C_Sentence_Null,C_ReciverHrZen	;�Ƿ���
	db	C_ReciverMinu_XX,C_SentenceMinute_XX,C_ReciverMinuZen_X_
	db	C_ReciverMinu_XX,C_SentenceMinute_X,C_ReciverMinuZen__X      	
	db	0,C_Sentence_Null,C_ReciverZenFen 		;��

	db	0,C_Sentence_Null,C_Temperature_C	;���� 	
	db	0,C_Sentence_Null,C_ReciverTempSign	;�Ƿ񸺺�
	db	C_ReciverTemp_XX,C_SentenceTemp_XX,C_ReciverTemp_X_
	db	C_ReciverTemp_XX,C_SentenceTemp_X,C_ReciverTemp__X  
	db	0,C_Sentence_Null,C_Unit_12h		;��
	db	0,C_SentenceTemp_DotX,C_ReciverTemp_DotX  ;С����λ		
	db	0,C_Sentence_Null,C_Temperature_19h	;��
	db	C_SpeechEnd
	
D_DianSpeech:	.equ	$-T_SentenceTab
	db	0,C_Sentence_Null,C_KeySound_1bh	
	db	0,C_Sentence_Null,C_ReciverAMP_XX	;����������	
	db	C_ReciverHour_XX,C_SentenceHour_XX,C_ReciverHour_X_
	db	C_ReciverHour_XX,C_SentenceHour_X,C_ReciverHour__X   	
	db	0,C_Sentence_Null,C_Unit_12h   ;��
	db	C_SpeechEnd
	
D_FenSpeech:	.equ	$-T_SentenceTab
	db	0,C_Sentence_Null,C_KeySound_1bh
	db	C_ReciverMinu_XX,C_SentenceMinute_XX,C_ReciverMinuZen_X_
	db	C_ReciverMinu_XX,C_SentenceMinute_X,C_ReciverMinuZen__X  
	db	0,C_Sentence_Null,C_Unit_14h  ;��
	db	C_SpeechEnd	
	
D_DingDongTimeTemp_F:	.equ	$-T_SentenceTab
	db	0,C_Sentence_Null,C_KeySound_1ch ;C_KeySound_1bh
	db	0,C_Sentence_Null,C_ReciverNum_xianzai	 ;����ʱ��
	db	0,C_Sentence_Null,C_ReciverAMP_XX	;���������� 	
 
	db	C_ReciverHour_XX,C_SentenceHour_XX,C_ReciverHour_X_
	db	C_ReciverHour_XX,C_SentenceHour_X,C_ReciverHour__X	
	db	0,C_Sentence_Null,C_Unit_12h   ;��
  	
;	db	C_ReciverMinu_XX,C_SentenceMinute_XX,C_ReciverMinu_X_
;	db	C_ReciverMinu_XX,C_SentenceMinute_X,C_ReciverMinu__X      	
;	db	0,C_Sentence_Null,C_Unit_14h	;��
	db	0,C_Sentence_Null,C_ReciverHrZen ;�Ƿ���
	db	C_ReciverMinu_XX,C_SentenceMinute_XX,C_ReciverMinuZen_X_
	db	C_ReciverMinu_XX,C_SentenceMinute_X,C_ReciverMinuZen__X      	
	db	0,C_Sentence_Null,C_ReciverZenFen 		;��
	
	db	0,C_Sentence_Null,C_Temperature_F	;����
	db	0,C_Sentence_Null,C_ReciverTemp_XXX	;�Ƿ���1	
	db	0,C_Sentence_Null,C_ReciverTemp_Bai	;�Ƿ񱨰�	
	db	0,C_SentenceTemp_DotX,C_ReciverTempF_X_	;ʰλ
	
	db	C_ReciverMinu_XX,C_SentenceMinute_XX,C_ReciverTempF_10
	db	C_ReciverMinu_XX,C_SentenceMinute_X,C_ReciverTempF__10   ;�Ƿ�10	

	db	0,C_SentenceTemp_DotX,C_ReciverTempF__X	;��λ	
	db	0,C_Sentence_Null,C_Unit_12h		;��
	db	0,C_SentenceTemp_DotX,C_ReciverTempF_DotX  ;С����λ			
	db	0,C_Sentence_Null,C_Temperature_19h	;��	
	db	C_SpeechEnd	
	
D_AlarmRing:	.equ	$-T_SentenceTab
;	db	0,C_Sentence_Null,C_AlarmRingX_	;
	db	0,C_Sentence_Null,C_AlarmRingX_Num	;
	db	C_SpeechEnd	
	
;E_DingDongTimerTemp equ $-T_DingDongTimerTemp
;-----------------------------------
T_NumberNode:
	db	C_Sentence_Null         ;00
	db	C_SentenceYear_XX       ;01
	db	C_SentenceYear_X        ;02
	db	C_SentenceMonth_XX      ;03
	db	C_SentenceMonth_X       ;04
	db	C_SentenceDay_XX        ;05
	db	C_SentenceDay_X         ;06
	db	C_SentenceHour_XX       ;07
	db	C_SentenceHour_X        ;08
	db	C_SentenceMinute_XX     ;09
	db	C_SentenceMinute_X      ;10
	db	C_SentenceTemp_XX       ;11
	db	C_SentenceTemp_X        ;12
	db	C_SentenceTemp_DotX     ;13
	db	C_SentenceWeek_X        ;14
	db	C_SentenceTemp_XXX      ;15
	db	C_SentenceTemp_XX_1     ;16
;	db	C_SentenceTemp_X_1		;17		;X
E_NumberNode        equ $-T_NumberNode
;-----------------------------------
T_NumberFunc:
	dw	F_ReturnAddr-1          ;00
	dw	F_CheckYearXX-1         ;01
	dw	F_CheckYearX-1          ;02
	dw	F_CheckMonthXX-1        ;03
	dw	F_CheckMonthX-1         ;04
	dw	F_CheckDayXX-1          ;05
	dw	F_CheckDayX-1           ;06
	dw	F_ChechHourDecade-1     ;07
	dw	F_CheckAfterDecade-1    ;08
	dw	F_CheckMinuteDecade-1   ;09
	dw	F_CheckAfterDecade-1    ;10
	dw	F_CheckTempXX-1         ;11
	dw	F_CheckAfterDecade-1    ;12
	dw	F_CheckDotX-1           ;13
	dw	F_CheckWeekX-1          ;14
	dw	F_CheckTemp_XXX-1       ;15
	dw	F_CheckTempXX_1-1       ;16
;	db	F_SentenceTemp_X_1-1	;17		;xwx
E_NumberFunc:	equ $-T_NumberFunc
;-----------------------------------
