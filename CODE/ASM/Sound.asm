;================================================
; Purpose	: Sound Function Interface define
; Edit by 	: John
; Edit data	: 2007-2-26 11:01

; 487 Byte
;================================================
; 
; Main function define:
;    F_PlaySound:
;	Purpose : Play Adpcm / pcm / mid / Mute.
;	Input   : Sound Number --> A
;	Return  : none
;    F_StopSound:
;	Purpose : Stop current sound
;	Input   : none
;	Return  : none
;    F_CheckEndSound:
;	Purpose : Check status of current sound
;	Input   : none
;	Return  : Set C flag while speech stoped,
;		  Otherwise clean C flag.
;    F_ChangeInstrument:
;	Purpose : Change MID instrument.
;	Input   : Instrument Number --> A, Channel Number --> X.
;	Return  : none
;    F_VolumnSet:
;	Purpose : Change DAC volumn, 
; 		  Volumn 8 --> 0 : High --> Low --> 0 
;   	Input   : VolumeValue --> X
; 	Return  : none
;    F_SeviceForTimer0:
;	Purpose : Timer0 interrupt service routine
;   	Input   : none
; 	Return  : none
;    F_IntMelodyService:
;	Purpose : Div interrupt Melody service routine
;   	Input   : none
; 	Return  : none
;    F_SeviceForEnvelope:
;	Purpose : Div interrupt Melody service routine
;   	Input   : none
; 	Return  : none
;================================================
; Get real address for data
;
;F_ChangeInstrument:
;.IF	C_ChangeInstrument
;.if	C_MonoChannel	
;	sta	R_InstCh1
;.else
;	cpx	#0
;	bne	L_SetInstCh2
;	STA	R_InstCh1
;	rts
;L_SetInstCh2:
;.endif
;	sta	R_InstCh2
;.ENDIF 
;	RTS
F_DownloadAddr:
        LDA     #C_SoundStart&0FFh
        CLC
        ADC     R_SoundAddr
        STA     R_SoundAddr
        LDA     #(C_SoundStart/100h)&0FFh
        ADC     R_SoundAddr+1
        STA     R_SoundAddr+1
        LDA     #C_SoundStart/10000h
        ADC     R_SoundAddr+2
        STA     R_SoundAddr+2

        LDHN    R_SoundAddr+1
        STLN    R_Temp1Sound
        LDLN    R_SoundAddr+2
        STHN    R_Temp1Sound
	
	clc
	ror	R_Temp1Sound
        clc
	ror	R_Temp1Sound
        LDA     R_Temp1Sound
;        ORA     #0F0h
;        SEC
;        SBC	#0FBH
        STA     bank

        SMB6    R_SoundAddr+1
        RMB7    R_SoundAddr+1
        RTS
;======================================
;Sound addr inc 1 for next data
;
F_SoundAddrInc1:
	PHA
	INC     R_SoundAddr
	BNE     ?99
	LDA     R_SoundAddr+1
	LDX	R_SoundAddr+1
	INX
	STX	R_SoundAddr+1
        EOR     R_SoundAddr+1
        AND     #(01h<<6h)
        BEQ     ?99
	
	INC     bank
        SMB6    R_SoundAddr+1
        RMB7    R_SoundAddr+1
?99
        PLA
UpdatePtr1:
        RTS
;===========================================
.if C_NeedSentence
F_PlaySound:
.else
PlaySound:
.endif
;	RMB1	R_TempCnt+1
;	RMB6	ID_SORT2
;	RMB7	ID_SORT2
;	CMP	#0AH
;	BNE	F_PlaySound0012
;	SMB7	ID_SORT2
;F_PlaySound0012:	
;	CMP	#Num_key25
;	BCS	F_PlaySound001
;F_PlaySound0011:
;	SMB6	ID_SORT2
;	BRA	F_PlaySound002
;F_PlaySound001:
;	CMP	#Num_xingqi
;	BCS	F_PlaySound0011
;	CMP	#Num_dingdong
;	BEQ	F_PlaySound0011
;F_PlaySound002:
;	ldx	#2
;	CMP	#Num_dingdong
;	BEQ	PlaySound2
;	CMP	#Num_key
;	BEQ	PlaySound2
;	cmp	#Num_di
;	beq	PlaySound12
;	cmp	#Num_key25
;	bEQ	PlaySound12
;;	BCS	F_PlaySound1
;;	SMB1	R_TempCnt+1
;	
;	CMP	#0
;	BNE	F_PlaySound01
;	BRA	F_PlaySound0
;F_PlaySound01:
;	CMP	#3
;	BNE	F_PlaySound011
;	BRA	F_PlaySound0
;F_PlaySound011:
;	CMP	#4
;	BNE	F_PlaySound02
;	BRA	F_PlaySound0	
;F_PlaySound02:
;	CMP	#5
;	BNE	F_PlaySound03
;	BRA	F_PlaySound0
;F_PlaySound03:	
;	CMP	#9
;	BNE	F_PlaySound04
;	BRA	F_PlaySound0
;F_PlaySound04:
;	CMP	#10
;	BNE	F_PlaySound05
;	BRA	F_PlaySound0
;F_PlaySound05:
;	CMP	#12H
;	BNE	F_PlaySound1
;F_PlaySound0:
;	SMB0	R_TempCnt+1
;F_PlaySound1:	
;	dex
;PlaySound12:
;	DEX
;PlaySound2:
;	stX	R_InstCh1
;	stX	R_InstCh2
	
        SEI
        STA     R_SoundAddr        
        LDX	#0
        STX     R_SoundAddr+1      
        STX     R_SoundAddr+2 
        
	STX	R_SoundStatus
	stX	R_MelodyStatus
             
        CLC                        
        ROL     R_SoundAddr        
        ROL     R_SoundAddr+1      
        ROL     R_SoundAddr+2      
                                   
        ADC     R_SoundAddr        
        STA     R_SoundAddr        
        LDA     #00h               
        ADC     R_SoundAddr+1      
        STA     R_SoundAddr+1      
        LDA     #00h               
        ADC     R_SoundAddr+2      
        STA     R_SoundAddr+2      

        JSR     F_DownloadAddr

        LDA     (R_SoundAddr)
        PHA
        JSR     F_SoundAddrInc1
        LDA     (R_SoundAddr)
        PHA
        JSR     F_SoundAddrInc1
        LDA     (R_SoundAddr)
        STA     R_SoundAddr+2
        PLA
        STA     R_SoundAddr+1
        PLA
        STA     R_SoundAddr
        JSR     F_DownloadAddr

	EN_TMR0_IRQ
	TMR0_CLK_F4Mdiv32
;	EN_DIV_IRQ
	
	LDA     #00h
	STA     R_SoundStatus
        
        LDA     (R_SoundAddr)
        cmp	#C_PlayAdpcm
        bne	L_InitPlayPcm
;L_InitPlayAdpcm:
	BRA	F_InitPlayAdpcm        
L_InitPlayPcm:	
;        cmp	#C_PlayPcm
;        bne	L_InitPlayMid
;        jmp	F_InitPlayPcm
L_InitPlayMid:        
        cmp	#C_PlayMid
        beq	F_InitPlayMid
        rts	
;L_InitPlayMute:        
;        ;cmp	#C_PlayMut
;        ;bne	
;        xSETB	R_SoundStatus,C_MuteCheck
;        PWM_OFF
;        SEL_VOICE
;        jmp	L_SetMuteLength
        ;rts
F_InitPlayAdpcm:
	TMR0_CLK_F4Mdiv128
	jsr	F_SoundAddrInc1
;	lda	#0ech		;(R_SoundAddr)
	
	LDA	#C_SampleRate   ;#0FCH	;
	sta	tmr0h
 	LDA	#80H
	STA	R_PnReg+1	; Init= 80H
        LDA     #00h
        STA     R_PnReg
        lda	R_CtrlRegister
        ora	#C_AdpcmNibbleFlag
        sta	R_CtrlRegister
        xSETB	R_SoundStatus,C_AdpcmCheck
	jsr	F_SoundAddrInc1
	jsr	F_SoundAddrInc1
L_PcmSameAsAdpcm:
        xJB	R_SoundStatus,C_MuteCheck,L_SkipOpenPwmON
        lda	#80h
	STA	DAC		; DAC output
        PWM_ON
        SEL_VOICE
L_SkipOpenPwmON: 
        TMR0_ON
.if C_Time1AsTemp
        DIS_TMR1_IRQ
        TMR1_OFF
.endif
        cli
	rts
;--------------------	
;F_InitPlayPcm:
;        xSETB	R_SoundStatus,C_PcmCheck
;L_SetMuteLength:
;	lda	#C_PcmSampleRate			; 6500Hz=256-4m/32/ech
;	sta	tmr0h
;	jsr	F_SoundAddrInc1
;	lda	(R_SoundAddr)
;	sta	R_PcmLength
;	jsr	F_SoundAddrInc1
;	lda	(R_SoundAddr)
;	sta	R_PcmLength+1
;	jsr	F_SoundAddrInc1
;	jmp	L_PcmSameAsAdpcm
;	;rts
;--------------------
F_InitPlayMid:
.if C_NeedMelody
	DIS_TMR0_IRQ
	DIS_TMR1_IRQ
        TMR1_OFF
        TMR0_OFF
	jsr	F_SoundAddrInc1
	xSETB	R_CtrlRegister,C_SingleChannel
	lda	(R_SoundAddr)
	bne	L_NotSigleChannel
	xCLRB	R_CtrlRegister,C_SingleChannel
	;TMR0_CLK_FSUB
L_NotSigleChannel:
        TMR1_CLK_F4Mdiv32
        lda	#0
        sta	R_BeatCnt
      .if	C_ChangeInstrument
      		;NOP
      .ELSE
	sta	R_InstCh1
	sta	R_InstCh2
      .endif
	sta	R_MelodyStatus
        ;lda	#0FFh
        sta	DAC
.if C_TempoAdjust
        	lda	#16
        	sta	R_TempoAdjust
.endif
        	lda	#9+16
        	sta	R_TempoDataIndex
	TONE_TMR0_2
        SEL_MELODY2
        
        LDA	R_InstCh1
        BEQ	JMP_MID1
        SEL_MELODY_1M
JMP_MID1:
        PWM_ON
	jsr	F_SoundAddrInc1
	lda	#4
	sta	R_TempoCnt
        xSETB	R_SoundStatus,C_MelodyCheck
        cli
.endif
	rts
;==================================================
;L_PlayMuteHereX:
;	jmp	L_PlayMuteHere
F_SeviceForTimer0:     
	xJB	R_SoundStatus,C_AdpcmCheck,L_PlayAdpcmHere
;	xJB	R_SoundStatus,C_PcmCheck,L_PlayPcmHere
;	xJB	R_SoundStatus,C_MelodyCheck,L_PlayMelodyHere
;	xJB	R_SoundStatus,C_MuteCheck,L_PlayMuteHereX
L_PlayMelodyHere:
	rts
;---------------------------------------	
L_PlayAdpcmHere:
.if C_NeedSentence
    xJNB    R_SentenceCtrl,C_SentenceSampXBit,L_DontCheckSamp
    lda     VoiceLen
    ora     VoiceLen+1
    bne     L_SkipRampDn
    jmp     L_VoiceEnd
L_SkipRampDn:
    SEC
    LDA     VoiceLen
    SBC     #01
    STA     VoiceLen
    LDA     VoiceLen+1
    SBC     #00h
    STA     VoiceLen+1
L_DontCheckSamp:
.endif
        
    LDA	R_CtrlRegister			
	EOR	#C_AdpcmNibbleFlag
	STA	R_CtrlRegister
	AND	#C_AdpcmNibbleFlag
	BEQ	L_ProcessLowNibble	
	jsr	F_SoundAddrInc1
	LDA	R_AdpcmNewCode
	ROR	A
	ROR	A
	ROR	A			
	ROR	A
	BRA	L_ProcessNibble
L_ProcessLowNibble:
	LDA	(R_SoundAddr)
	ROR	A			
	STA	R_AdpcmNewCode
L_ProcessNibble:
	AND	#07H
	ORA	R_PnReg			
	BNE	L_SpeechNonEnded
	BCS	L_VoiceEnd
L_SpeechNonEnded:
	STA	R_PnReg			
	TAX
	LDA	T_SLOPE_TABLE,X		
	BCS	L_VSlopeDown
	ADC	R_PnReg+1		
	BRA	L_OutVExpect
L_VSlopeDown:
	EOR	#0FFH
	ADC	R_PnReg+1
L_OutVExpect:
	STA	R_PnReg+1		
	LDA	T_NEXT_STEP_TABLE,X	
	STA	R_PnReg
	
	LDA     R_PnReg+1
        CMP	#80H
        BCS     L_LargerThan80H?
        EOR     #7FH
L_LargerThan80H?:
.IF     C_VOLUME
	jsr	F_VolumnCtrl
.endif	
        STA     DAC
	rts

F_CheckEndSoundPro:
F_CheckEndSound:
	clc
.if C_NeedSentence
	xJB     R_SoundCtrl,C_SentencePlayingBit,L_SoundNotFreeX
.endif
	lda	R_SoundStatus
	beq	L_SoundNotFree
L_SoundNotFreeX:
;	xJB	ID_adh,DATA6,F_CheckEndSound1
;	LDHN	R_Volumn
;	BEQ	F_CheckEndSound1
;	BRA	F_CheckEndSound2
;F_CheckEndSound1:
;	LDA	#0
;	STA	R_SoundStatus
;	BRA	F_CheckEndSound
;F_CheckEndSound2:
	sec
L_SoundNotFree:	
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;L_PlayPcmHere:
;	LDA	(R_SoundAddr)
;	CMP	#80H
;	BCS     L_LargerThan80H?
;	EOR     #7FH
;L_LargerThan80H?:
;.IF     C_VOLUME
;	jsr	F_VolumnCtrl
;.endif	
;	sta	DAC	
;	jsr	F_SoundAddrInc1
;==================================================
;L_PlayMuteHere:	
;	lda	R_PcmLength
;	ora	R_PcmLength+1
;	bne	L_ContinuePlayPcmMute
;	jmp	L_VoiceEnd
;L_ContinuePlayPcmMute:	
;	dec	R_PcmLength
;	bne	L_ContinuePlayPcm
;	lda	R_PcmLength+1
;	beq	L_ContinuePlayPcm
;	dec	R_PcmLength+1
;L_ContinuePlayPcm:	
;	rts
;==================================================
;F_VolumnSet:
;.if	C_VOLUME
;	cpx	#C_VolumeSetSum+1
;	bcs	L_ConotDoit?
;	lda	T_VolumnTable,x
;	sta	R_Volumn
;L_ConotDoit?:
;.endif
;	rts
;--------------------------------------------------
.IF     C_VOLUME
F_VolumnCtrl:
	LDX	R_Volumn	;0Ϊ�������(1),1Ϊ�е�����(1/2),2Ϊ��С����(1/4)
	BEQ     VOICE_BIG3
VOICE_BIG1:
	clc
	roL
	PHP
	CLC
	ROR
	PLP
	ROR
	DEX
	BNE	VOICE_BIG1
;	RTS
VOICE_BIG3:
;	BBR6	ID_SORT2,VOICE_BIG4
;	LDX	#1
;	JSR	VOICE_BIG1
;	BBS7	ID_SORT2,VOICE_BIG4
;	STA	VOLM_TEMP
;	LDX	#1	
;	JSR	VOICE_BIG1
;	AND	#7FH
;	CLC
;	ADC	VOLM_TEMP
;VOICE_BIG4:
	rts
	
	
;	ldx	R_Volumn
;	clc
;	rol
;	php
;	sta	R_Volumn+1
;	lda	#0
;	clc
;	ror	R_Volumn+1		; 1/2
;	php
;	ror    	R_Volumn
;	bcs	L_NextVolume1
;	plp
;	php
;	adc	R_Volumn+1		
;L_NextVolume1:
;	plp
;	clc
;	ror	R_Volumn+1		; 1/4
;	php
;	ror	R_Volumn
;	bcs	L_NextVolume2
;	plp
;	php
;	adc	R_Volumn+1		; 1/2+1/4=3/4=6/8
;L_NextVolume2:
;	plp
;	clc	
;	ror	R_Volumn+1		; 1/8
;	php
;	ror	R_Volumn
;	bcs	L_NextVolume3
;	plp
;	php
;	adc	R_Volumn+1		; 1/2+1/4+1/8=7/8
;L_NextVolume3:
;	plp
;	php
;	ror	R_Volumn
;	bcs	L_NextVolume4
;	plp
;	php
;	adc	R_Volumn+1		; 1/2+1/4+1/8+1/8=8/8
;L_NextVolume4:
;	plp
;	plp
;	ror	
;	stx	R_Volumn
;	rts
;--------------------------------------	
;T_VolumnTable:
;	db	00001111b		; 0/8
;	db	00001011b		; 1/8
;	db	00001101b		; 2/8
;	db	00001001b		; 3/8
;	db	00001110b		; 4/8
;	db	00001010b		; 5/8
;	db	00001100b		; 6/8
;	db	00001000b		; 7/8
;	db	00000000b		; 8/8
.ENDIF
;================================================
; Melody Module
; Div Interrupt Melody sevice routine.
.if C_NeedMelody
F_IntMelodyService:
                ;/* Process Tempo */
                xJNB	R_SoundStatus,C_MelodyCheck,L_EndTempoService
		xJB	R_CtrlRegister,C_TempoEvent,L_EndTempoService
		xSETB	R_CtrlRegister,C_TempoEvent
L_EndTempoService:
; Evp Service Here
		xJB	R_CtrlRegister,C_EvpSeveiceCh1,L_CheckPlayEvpCh1
		xSETB	R_CtrlRegister,C_EvpSeveiceCh1
	L_CheckPlayEvpCh1:	
		xJB	R_CtrlRegister,C_EvpSeveiceCh2,L_CheckPlayEvpCh2
		xSETB	R_CtrlRegister,C_EvpSeveiceCh2
	L_CheckPlayEvpCh2:	
L_ExitReadMelodyData:
		rts
.endif 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
F_StopSoundPro:
	LDA		#0
	STA		R_Voice_Unit
    xCLRB   R_SoundCtrl,C_StartPlayBit 
    xCLRB   R_SentenceCtrl,C_SentenceNewPlayBit
    xCLRB   R_SentenceCtrl,C_SentenceAsNextBit
    xCLRB   R_SoundCtrl,C_SentencePlayingBit 
F_StopSound:
;;;	BBR4	ID_Say,L_VoiceEnd      
;;;	BBR3	ID_TIAO,F_StopSoundA   
	;ALM_AN_SHOW
F_StopSoundA:
;	RMB4	ID_Say
L_VoiceEnd:
;	rmb4	R_Saycnt1
;	rmb7	ID_SORT
	
F_StopSound1:
	xCLRB	R_SETCNT,DATA3  ;Close Mute 
;;;	rmb7	ID_SORT
;	RMB1	R_TempCnt+1
	PWM_OFF
	LDA		#0
	STA     DAC
	STA     R_SoundStatus
	sta		R_MelodyStatus
	DIS_TMR0_IRQ
	TMR0_OFF
.if C_Time1AsTemp
	DIS_TMR1_IRQ
	TMR1_OFF
.endif
	
	SEL_VOICE
	
.if C_NeedSentence
    xCLRB   R_SentenceCtrl,C_SentenceSampXBit
.endif
	rts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;================================================
; Read Melody Data to A
.if C_NeedMelody
L_GetMelodyData:
		jsr	F_SoundAddrInc1
		LDA	(R_SoundAddr)
		rts
F_SeviceForPlayMelody:		
                xJNB	R_SoundStatus,C_MelodyCheck,L_ExitReadMelodyData
                lda	R_BeatCnt
                bne	L_ExitReadMelodyData
L_LoopGetMelodyData:                
		jsr	L_GetMelodyData
                STA     R_Temp1Sound
                CMP     #C0H            ;C0H -- FFH: as Instrument select
                BCS     L_InstrumentSelectCMDTmp
                CMP     #B0H            ;B0H   as Ch2 Extend-256 instrument
                BCS     L_PlayExtendSpeechCh2CMD
                CMP     #A0H            ;A0H   as Ch1 Extend-256 instrument
                BCS     L_PlayExtendSpeechCh1CMD
                CMP     #81H            ;81H -- 9F:  as All song ended
                BCS     F_StopSound	;L_AllSongEndedCMD
                CMP     #80H            ;80H         as One song ended
                BCS     F_StopSound	;L_OneSongEndedCMD
                CMP     #40H            ;40H -- 4FH: as CH1 Play Data
                                        ;50H -- 5FH: as CH2 Play Data
                                        ;60H -- 7FH: as the same as 40H -- 5FH
                                        ;
                BCS     L_PlayDataCMD
                CMP     #20H            ;20H -- 3FH: as Tempo select
                BCS     L_TempoSelectCMD
                                        ;00H -- 1FH: as OctaveSelect
                ;/* Tracker Add for Event detect */
                TAX
                AND     #00001000b      ;Check Event flag  08-0FH, 18-1FH
                BEQ     L_OctaveCommand ;
                BRA	L_LoopGetMelodyData
;---------------------
L_PlayExtendSpeechCh2CMD:
L_PlayExtendSpeechCh1CMD:
                JSR     L_GetMelodyData
                BRA	L_LoopGetMelodyData
;---------------------
L_InstrumentSelectCMDTmp:
		JMP	L_InstrumentSelectCMD
;---------------------      
L_AllSongEndedCMD:          
L_OneSongEndedCMD:
;		lda	#0
;		sta	R_MelodyStatus
;		jmp	F_StopSound
;---------------------                
L_OctaveCommand:
                TXA
                ;/* OctaveSelect */
                CMP     #10H            ;00H -- 0FH: as CH1 Octave Select
                AND     #07H
                STA     R_Temp1Sound
                BCC     L_CH1OctaveSelect
                ;/* Channel 2 octave select */
                LDA     R_Temp1Sound
                ROL     A
                ROL     A
                ROL     A
                ROL     A
                and	#01110000b
                STA     R_Temp1Sound
                LDA     R_MelodyStatus
                AND     #C_OctaveCh2
                BRA	L_CH1OctaveSelect1
;                ORA     R_Temp1Sound
;                STA     R_MelodyStatus
;                BRA     L_LoopGetMelodyData
L_CH1OctaveSelect:
                LDA     R_MelodyStatus
                AND     #C_OctaveCh1
L_CH1OctaveSelect1:
                ORA     R_Temp1Sound
                STA     R_MelodyStatus
                BRA     L_LoopGetMelodyData
L_TempoSelectCMD:        
                AND     #00011111b
                JSR     F_SetUpTempo
                BRA     L_LoopGetMelodyData  
;===============================================
; Melody play tone data seting.
;------------------------------------
F_StopCh1:
		xJB	R_CtrlRegister,C_SingleChannel,L_IsSingleChannelStopCh1
		TMR1_OFF
		xCLRB	R_MelodyStatus,C_EvpEnableCh2
		lda	DAC
		and	#0Fh
		sta	DAC
		rts
L_IsSingleChannelStopCh1:
		TMR1_OFF
		TMR0_OFF
		;lda	#0
		;sta	DAC
		rts		
;------------------------------------
F_StopCh2:
		xJB	R_CtrlRegister,C_SingleChannel,L_IsSingleChannelStopCh2
		TMR0_OFF
		xCLRB	R_MelodyStatus,C_EvpEnableCh1
		lda	DAC
		and	#0f0h
		sta	DAC
L_IsSingleChannelStopCh2:		
		rts
;------------------------------------
L_PlayDataCMD:
                AND     #11011111b
                CMP     #50H            ;50H -- 5FH: as CH2 play
                BCS     L_PlayCh2Data?

                ;/* Play CH1 Data */
                AND     #00001111b
                BNE     L_NormalPlayCh1?
                JSR     F_StopCh1
                BRA     L_GetNextData
L_NormalPlayCh1?:
;		TAX
;		DEX
;		STX     R_Temp1Sound
		DEC
		STA	R_Temp1Sound
                LDA     R_MelodyStatus
                AND     #00000111b              ;Get Ch1 Octave
                TAX
                LDA     T_MultiBy12Table,X
                CLC
                ADC     R_Temp1Sound
                TAX                             ;Get frequency index
                LDA     R_InstCh1
                JSR     F_PlayToneCh1
                BRA     L_GetNextData
L_PlayCh2Data?:
                ;/* Play CH2 Data */
                AND     #00001111b
                BNE     L_NormalPlayCh2?
                JSR     F_StopCh2
                BRA     L_GetNextData
L_NormalPlayCh2?:
;                TAX
;                DEX
;                STX     R_Temp1Sound
		DEC
		STA	R_Temp1Sound
;                LDA     R_MelodyStatus
;                ROR     A
;                ROR     A
;                ROR     A
;                ROR     A
		
		LDHN	R_MelodyStatus
                AND     #00000111b
                TAX
                LDA     T_MultiBy12Table,X
                CLC
                ADC     R_Temp1Sound
                TAX                             ;Get frequency index
                LDA     R_InstCh2
                JSR     F_PlayToneCh2
L_GetNextData:
                JSR     L_GetMelodyData
                STA     R_Temp1Sound
                bbs7	R_Temp1Sound,L_SetUpDelay
                BRA     L_PlayDataCMD
L_SetUpDelay:
                AND     #01111111b
                STA     R_BeatCnt
                RTS
;-------------------------------
; input : x
F_PlayToneCh1:
		xJB	R_CtrlRegister,C_SingleChannel,L_IsSingleChannelCh1
		TMR1_OFF
		sta	R_InstCh2+1
		lda	T_ToneFreqTableCh2,x
		sta	tmr1h
		xSETB	R_MelodyStatus,C_EvpEnableCh2
		lda	#0
		sta	R_EvpCntCh2
		sta	R_EvpCntCh2+1
		TMR1_ON
		RTS
L_IsSingleChannelCh1:
		TMR1_OFF
		TMR0_OFF
		
		sta	R_InstCh2+1
		sta	R_InstCh1+1
		lda	T_ToneFreqTableCh2,x
		sta	tmr1h
		clc	
		adc	#C_SigleChannelOtherFreq
		sta	tmr0h
		xCLRB	R_MelodyStatus,C_EvpEnableCh2
		xSETB	R_MelodyStatus,C_EvpEnableCh1
		lda	#0
		sta	R_EvpCntCh2
		sta	R_EvpCntCh2+1
		sta	R_EvpCntCh1
		sta	R_EvpCntCh1+1
		
		TMR1_ON
		TMR0_ON
		rts		
;-------------------------------
; input : x
F_PlayToneCh2:
		xJB	R_CtrlRegister,C_SingleChannel,L_IsSingleChannelCh2
		TMR0_OFF
		sta	R_InstCh1+1
		lda	T_ToneFreqTableCh2,x		;T_ToneFreqTableCh1
		sta	tmr0h
		xSETB	R_MelodyStatus,C_EvpEnableCh1
		lda	#0
		sta	R_EvpCntCh1
		sta	R_EvpCntCh1+1
		TMR0_ON
	L_IsSingleChannelCh2:
		RTS
;===========================================
L_InstrumentSelectCMD:                    ;11zxyyyy
                AND     #00010000b
                BNE     L_CH2InstrumentSelectCMD

                ;/* CH1 instrument select */
                LDA     R_Temp1Sound
                AND     #00100000b
                BNE     L_SpeechInstrumentCh1

                ;/* Tone Instrument */
                LDA     R_Temp1Sound
                AND     #00001111b
                CMP     #4
                BCS     L_SpeechInstCh1_10_13
      .if	C_ChangeInstrument
      		;NOP
      .ELSE
                STA     R_InstCh1
      .endif
		JMP	L_LoopGetMelodyData
L_SpeechInstCh1_10_13:
                ADC     #0FH
                BRA     L_SetCh1Inst
L_SpeechInstrumentCh1:
                LDA     R_Temp1Sound
                AND     #00001111b
L_SetCh1Inst:
      .if	C_ChangeInstrument
      		;NOP
      .ELSE
                STA     R_InstCh1
      .endif
		JMP	L_LoopGetMelodyData

L_CH2InstrumentSelectCMD:
                ;/* CH2 instrument select */
;		LDA     R_Temp1Sound
;		AND     #00100000b
;		BNE     L_SpeechInstrumentCh2
		BBS5	R_Temp1Sound,L_SpeechInstrumentCh2
                ;/* Tone Instrument */
;		LDA     R_Temp1Sound
;		AND     #00001111b
	
		LDLN	R_Temp1Sound
                CMP     #4
                BCC     L_SetCh2Inst	;BCS     L_SpeechInstCh2_10_13
;      .if	C_ChangeInstrument
;      		;NOP
;      .ELSE
;                STA     R_InstCh2
;      .endif
;		JMP	L_LoopGetMelodyData
L_SpeechInstCh2_10_13:
                ADC     #0FH
                BRA     L_SetCh2Inst
L_SpeechInstrumentCh2:
                LDA     R_Temp1Sound
                AND     #00001111b
L_SetCh2Inst:
      .if	C_ChangeInstrument
      		;NOP
      .ELSE
                STA     R_InstCh2
      .endif
		JMP	L_LoopGetMelodyData
;===========================================
; Melody Tempo Seting.                
.if C_TempoAdjust
;-------------------------------------------
; ACC-> [0..31] == {-16..15}   15 as offset 0
F_GetTempoOffset:
                LDA     R_TempoAdjust
                RTS
;-------------------------------------------
F_SetTempoUp:
                LDX     R_TempoAdjust
                INX
                CPX     #20H
                BCC     L_InRange?
                LDX     #1FH
L_InRange?:
                BRA     L_SetTempoOffset
;-------------------------------------------
F_SetTempoDown:
                LDX     R_TempoAdjust
                DEX
                cpx	#80h
                BCC     L_SetTempoOffset
                LDX     #0
L_SetTempoOffset:
                TXA
;--------------------------------------------
; ACC: <-[0..31] == {-16..15}  15 as offset 0
F_SetTempoOffset:
                LDX     R_TempoAdjust
                STA     R_TempoAdjust
                DEX
                TXA
                EOR     #FFH
                CLC
                ADC     R_TempoDataIndex
.endif
;---------------------
; Set up Tempo:                
F_SetUpTempo:
                CLC
	.if C_TempoAdjust
                ADC     R_TempoAdjust
        .else	
        	adc	#16
        .endif
                STA     R_TempoDataIndex
                tax
                LDA     T_TempoTable,X
                STA     R_TempoCnt
                RTS
;===============================================
F_SeviceForEnvelope:
                xJNB	R_SoundStatus,C_MelodyCheck,L_ExtiCheckTempo
		xJNB	R_CtrlRegister,C_TempoEvent,L_ExtiCheckTempo
		xCLRB	R_CtrlRegister,C_TempoEvent
 ;               lda     R_TempoCnt
 ;               dec
 ;               sta	R_TempoCnt
 		DEC	R_TempoCnt
                BNE     L_ExtiCheckTempo
                LDX     R_TempoDataIndex
                LDA     T_TempoTable,X
                STA     R_TempoCnt

                ;/* tempo is Coming in (1/8 beat) */
                LDA     R_BeatCnt
                BEQ     L_ExtiCheckTempo
                     
                DEC	R_BeatCnt
L_ExtiCheckTempo:
		xJNB	R_CtrlRegister,C_EvpSeveiceCh1,L_ExitPlayEvpCh1
		xCLRB	R_CtrlRegister,C_EvpSeveiceCh1
		xJNB	R_MelodyStatus,C_EvpEnableCh1,L_ExitPlayEvpCh1
		lda	R_EvpCntCh1
		bne	L_Ch1EvpGoonCh1
		jsr	F_GetToneDataCh1
		bcs	L_ExitPlayEvpCh1
	L_Ch1EvpGoonCh1:
		dec	R_EvpCntCh1
		lda	R_EvpDividerCh1+2
		clc
		adc	R_EvpDividerCh1+1
		sta	R_EvpDividerCh1+2
		lda	DAC
		sta	R_Temp1Sound
		and	#0fh
		adc	R_EvpDividerCh1
		cmp	#0fh
		bcc	L_NormalValeDacCh1
		lda	#0fh
	L_NormalValeDacCh1:		
		tax
		lda	R_Temp1Sound
		and	#0F0h
		sta	R_Temp1Sound
		txa
		ora	R_Temp1Sound
		sta	R_Temp1Sound
		xJNB	R_CtrlRegister,C_SingleChannel,L_IsNotSingleChannelCh1
		LDLN	R_Temp1Sound
		sta	R_Temp1Sound
		clc
		rol	a
		rol	a
		rol	a
		rol	a
		ora	R_Temp1Sound
	L_IsNotSingleChannelCh1:
		sta	DAC
L_ExitPlayEvpCh1:
		xJNB	R_CtrlRegister,C_EvpSeveiceCh2,L_ExitPlayEvpCh2
		xCLRB	R_CtrlRegister,C_EvpSeveiceCh2
		xJNB	R_MelodyStatus,C_EvpEnableCh2,L_ExitPlayEvpCh2
		lda	R_EvpCntCh2
		bne	L_Ch1EvpGoonCh2
		jsr	F_GetToneDataCh2
		bcs	L_ExitPlayEvpCh2
	L_Ch1EvpGoonCh2:
		dec	R_EvpCntCh2
		lda	DAC
		sta	R_Temp1Sound
;		and	#0f0h
;		clc
;		ror	a
;		ror	a
;		ror	a
;		ror	a
		LDHN	R_Temp1Sound
		tax
		lda	R_EvpDividerCh2+2
		clc
		adc	R_EvpDividerCh2+1
		sta	R_EvpDividerCh2+2
		txa
		adc	R_EvpDividerCh2
		cmp	#0fh
		bcc	L_NormalValeDacCh2
		lda	#0fh
	L_NormalValeDacCh2:		
		clc
		rol	a
		rol	a
		rol	a
		rol	a
		tax
		
;		lda	R_Temp1Sound
;		and	#0Fh
		
		LDLN	R_Temp1Sound
		sta	R_Temp1Sound
		txa
		ora	R_Temp1Sound
		sta	DAC
L_ExitPlayEvpCh2:	
		rts
;------------------------------------
; Input : Instrument Number --> X, Instrument Step --> A
; Output: A --> Duration, X --> TargerValue	
F_GetToneTableData:
		pha
		txa
		CLC
		ROL	A
		TAX
		LDA	T_InstrumentTable,X
		sta	R_Temp1Sound
		lda	T_InstrumentTable+1,X
		sta	R_Temp1Sound+1
		pla
		clc
		adc	R_Temp1Sound
		sta	R_Temp1Sound
		lda	R_Temp1Sound+1
		adc	#0
		sta	R_Temp1Sound+1
		lda	(R_Temp1Sound)
		pha
		lda	R_Temp1Sound
		clc
		adc	#1
		sta	R_Temp1Sound
		lda	R_Temp1Sound+1
		adc	#0
		sta	R_Temp1Sound+1
		lda	(R_Temp1Sound)
		tax
		pla
		rts	
;------------------------------------		
F_GetToneDataCh1:		
		ldx	R_InstCh1+1
		lda	R_EvpCntCh1+1
; Input : Instrument Number --> X, Instrument Step --> A
; Output: A --> Duration, X --> TargerValue
		jsr	F_GetToneTableData
		bne	L_ContinueGetToneDataCh1
		xCLRB	R_MelodyStatus,C_EvpEnableCh1
		sec
		rts
	L_ContinueGetToneDataCh1:		
		sta	R_EvpCntCh1
		stx	R_EvpDividerCh1
	.if C_VOLUME
		txa
		jsr	F_VolumnCtrl
		sta	R_EvpDividerCh1
	.endif
		lda	R_EvpCntCh1+1
		clc
		adc	#2
		sta	R_EvpCntCh1+1
		lda	DAC
		and	#0fh
		sta	R_Temp1Sound
		lda	R_EvpDividerCh1
		sec
		sbc	R_Temp1Sound
		sta	R_EvpDividerCh1
		clc
		xJNB	R_EvpDividerCh1,7,L_NotInverse
		eor	#0ffh
		adc	#1
		sta	R_EvpDividerCh1
		sec
	L_NotInverse:	
		php	
		lda	#0
		sta	R_EvpDividerCh1+2
		sta	R_EvpDividerCh1+1
		ldx	#17
		clc
	L_LoopDivCh1:
		rol	R_EvpDividerCh1+1
		rol	R_EvpDividerCh1
		rol	a
		bcs	L_CheckCh1V
		cmp	R_EvpCntCh1
		bcc	L_NextSubCh1
	L_CheckCh1V:		
		sbc	R_EvpCntCh1
		sec
	L_NextSubCh1:
		dex
		bne	L_LoopDivCh1	
		plp
		bcc	L_NotNegative
                SEC
                LDA     #00H
                SBC     R_EvpDividerCh1+1
                STA     R_EvpDividerCh1+1
                LDA     #00H
                SBC     R_EvpDividerCh1
                STA     R_EvpDividerCh1
        L_NotNegative:		
        	clc
		rts
;------------------------------------		
F_GetToneDataCh2:
		ldx	R_InstCh2+1
		lda	R_EvpCntCh2+1
; Input : Instrument Number --> X, Instrument Step --> A
; Output: A --> Duration, X --> TargerValue
		jsr	F_GetToneTableData
		bne	L_ContinueGetToneDataCh2
		xCLRB	R_MelodyStatus,C_EvpEnableCh2
		sec
		rts
	L_ContinueGetToneDataCh2:		
		sta	R_EvpCntCh2
		stx	R_EvpDividerCh2
	.if C_VOLUME
		txa
		jsr	F_VolumnCtrl
		sta	R_EvpDividerCh2
	.endif
		lda	R_EvpCntCh2+1
		clc
		adc	#2
		sta	R_EvpCntCh2+1
		lda	DAC
		sta	R_Temp1Sound
		LDHN	R_Temp1Sound
		STA	R_Temp1Sound
;		and	#0f0h
;		clc
;		ror	a
;		ror	a
;		ror	a
;		ror	a
;		sta	R_Temp1Sound
		lda	R_EvpDividerCh2
		sec
		sbc	R_Temp1Sound
		sta	R_EvpDividerCh2
		clc
		xJNB	R_EvpDividerCh2,7,L_NotInverse2
		eor	#0ffh
		adc	#1
		sta	R_EvpDividerCh2
		sec
	L_NotInverse2:	
		php	
		lda	#0
		sta	R_EvpDividerCh2+2
		sta	R_EvpDividerCh2+1
		ldx	#17
		clc
	L_LoopDivCh2:
		rol	R_EvpDividerCh2+1
		rol	R_EvpDividerCh2
		rol	a
		bcs	L_CheckCh2V
		cmp	R_EvpCntCh2
		bcc	L_NextSubCh2
	L_CheckCh2V:	
		sbc	R_EvpCntCh2
		sec
	L_NextSubCh2:
		dex
		bne	L_LoopDivCh2	
		plp
		bcc	L_NotNegative2
                SEC
                LDA     #00H
                SBC     R_EvpDividerCh2+1
                STA     R_EvpDividerCh2+1
                LDA     #00H
                SBC     R_EvpDividerCh2
                STA     R_EvpDividerCh2
        L_NotNegative2:		
        	clc
		rts
.endif
;==================================================
; Table for adpcm decode. 
T_SLOPE_TABLE:
	DB	000,001,002,003,004,005,007,009;
	DB	001,002,003,004,005,007,009,013;
	DB	002,003,005,008,012,017,023,030;
	DB	003,006,011,018,027,038,051,066;
	DB	004,009,014,024,034,044,064,084;
	DB	005,011,017,029,041,053,077,101;
	DB	006,013,020,034,048,062,090,118;
	DB	007,015,023,039,055,071,103,125;

T_NEXT_STEP_TABLE:
	DB	00H,00H,00H,00H,00H,00H,08H,08H;
	DB	00H,00H,08H,08H,08H,08H,10H,10H;
	DB	08H,08H,10H,10H,10H,10H,18H,18H;
	DB	10H,10H,10H,18H,18H,20H,20H,28H;
	DB	18H,18H,18H,20H,20H,28H,28H,30H;
	DB	20H,20H,28H,28H,28H,28H,30H,38H;
	DB	28H,28H,30H,30H,30H,30H,38H,38H;
	DB	30H,30H,38H,38H,38H,38H,38H,38H;
;===============================================
; Table for melody speed.
.if C_NeedMelody
T_TempoTable:
	LoadTempo      30      ;tempo = 30     ;used for TempoAdjust underflow
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30
        LoadTempo      30      ;tempo = 30

        LoadTempo      30      ;tempo = 30
        LoadTempo      40      ;tempo = 40
        LoadTempo      50      ;tempo = 50
        LoadTempo      60      ;tempo = 60
        LoadTempo      70      ;tempo = 70
        LoadTempo      80      ;tempo = 80
        LoadTempo      90      ;tempo = 90
        LoadTempo      100     ;tempo = 100
        LoadTempo      110     ;tempo = 110
        LoadTempo      120     ;tempo = 120
        LoadTempo      130     ;tempo = 130
        LoadTempo      140     ;tempo = 140
        LoadTempo      150     ;tempo = 150
        LoadTempo      160     ;tempo = 160
        LoadTempo      170     ;tempo = 170
        LoadTempo      180     ;tempo = 180
        LoadTempo      190     ;tempo = 190
        LoadTempo      200     ;tempo = 200
        LoadTempo      210     ;tempo = 210
        LoadTempo      220     ;tempo = 220
        LoadTempo      230     ;tempo = 230
        LoadTempo      240     ;tempo = 240
        LoadTempo      250     ;tempo = 250
        LoadTempo      260     ;tempo = 260
        LoadTempo      270     ;tempo = 270
        LoadTempo      280     ;tempo = 280
        LoadTempo      290     ;tempo = 290
        LoadTempo      300     ;tempo = 300
        LoadTempo      310     ;tempo = 310
        LoadTempo      320     ;tempo = 320
        LoadTempo      330     ;tempo = 330
        LoadTempo      340     ;tempo = 340

        LoadTempo      340     ;tempo = 340    ;used for TempoAdjust overflow
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
        LoadTempo      340     ;tempo = 340
;=====================================================
; Table for tone freq.
T_MultiBy12Table:
        DB      12*0,12*1,12*2,12*3,12*4,12*5,12*6,12*7
T_ToneFreqTableCh1:	;TMR0Ƶ��ΪFSub,��Чλ8λ
        LoadOctaveToneFreq     013081/100,0      ;index  00 -- 22	c2
        LoadOctaveToneFreq     026162/100,0      ;index  24 -- 46       c3
        LoadOctaveToneFreq     052324/100,0      ;index  48 -- 70       c4
        LoadOctaveToneFreq     104648/100,0      ;index  72 -- 94       c5
        LoadOctaveToneFreq     209296/100,0      ;index  96 -- 118      c6
        LoadOctaveToneFreq     418592/100,0      ;index 120 -- 142      c7
        ;LoadToneFreq           1000            ;index 144
T_ToneFreqTableCh2:	;TMR1Ƶ��Ϊ4.4MHz/32,��Чλ8λ
        ;LoadOctaveToneFreq     013081/100,1      ;index  00 -- 22  	c2
        ;LoadOctaveToneFreq     026162/100,1      ;index  24 -- 46  	c3
        LoadOctaveToneFreq_    052324/100,1      ;index  48 -- 70  	c4
        LoadOctaveToneFreq_    052324/100,1      ;index  48 -- 70  	c4
        LoadOctaveToneFreq     052324/100,1      ;index  48 -- 70  	c4
        LoadOctaveToneFreq     104648/100,1      ;index  72 -- 94  	c5
        LoadOctaveToneFreq     209296/100,1      ;index  96 -- 118 	c6
        LoadOctaveToneFreq     418592/100,1      ;index 120 -- 142 	c7
        LoadOctaveToneFreq_     1888*(418592/100)/1000,1      ;index  48 -- 70  	c7
        ;LoadToneFreq           1000            ;index 144
;==================================================
;==================================================
; Table for melody instrument.
; General duration = 2s = 2000ms.
T_InstrumentTable:
	dw	T_Piano
	dw	T_Xylophone
	dw	T_MusicBox
	dw  T_XylophoneLow
	dw  T_KeyTimber1
	dw	T_KeyTimber2
C_Instrument	equ	($-T_InstrumentTable)/2
T_Piano:	;Duration(1ms), TargetValue(GeneralStep = 15).
	db	5,15
	db	100,11
	db	150,05
	db	200,04
	db	200,02
	db	200,00
	db	0	; End flag
T_Xylophone:	;Duration, TargetValue
	db	100,15
	db	250,08
	db	100,03
	db	100,00
	db	0	; End flag
T_MusicBox:	;Duration, TargetValue
	db	20,15
	db	40,13
	db	80,04
	db	100,02
	db	200,01
	db	200,00
	db	0	; End flag
T_XylophoneLow:	;Duration, TargetValue
	db	100,10
	db	250,08
	db	100,03
	db	100,00
	db	0	; End flag
T_KeyTimber1:	;Duration(1ms), TargetValue(GeneralStep = 15).
T_KeyTimber2:
	db	05,15
	db	30,13
	db	20,10
	db	05,04
	db	03,00
	db	0	; End flag
	
;	db	50,15
;	db	30,13
;	db	20,04
;	db	20,00
;	db	0	; End flag
;T_KeyTimber2:	;Duration(1ms), TargetValue(GeneralStep = 15).
;	db	05,15
;	db	30,13
;	db	20,10
;	db	05,04
;	db	03,00
;	db	0	; End flag
.endif