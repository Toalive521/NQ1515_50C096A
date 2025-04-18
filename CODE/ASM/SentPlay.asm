;================================================
; Purpose	: Play Sentence Interface define
; Edit by 	: John
; Edit data	: 2013-3-26 10:39

;772 Byte
;================================================
F_SpMuteProc:
        lda     VoiceLen+1
        ORA     VoiceLen
        BNE     L_DecMuteDelay
        rmb3	R_SETCNT  
        jmp     F_StopSound
L_DecMuteDelay:
        SEC
        LDA     VoiceLen
        SBC     #01
        STA     VoiceLen
        LDA     VoiceLen+1
        SBC     #00h
        STA     VoiceLen+1
        rts
;===========================================
F_SpeechMuteCh0:
        sei
        xSETB	R_SETCNT,DATA3 
        TMR0_CLK_F4Mdiv128
        LDA     #C_SampleRate
        sta     tmr0h
        SMB1	ifr ; FORCE TIME0 ISR EVENT
        EN_TMR0_IRQ
        nop
        nop
        TMR0_ON
        cli
        rts
;===========================================
F_SentenceAddrAddOne:
        lda     (R_SentenceStartAddr)
        pha
        lda     R_SentenceStartAddr
        clc
        adc     #1
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        pla
        rts
F_GetNxtTableAddr:
F_GetSelfTableAddr:
F_GetNewTableAddr:
        jsr     F_SentenceAddrAddOne
        pha
        jsr     F_SentenceAddrAddOne
        sta     R_SentenceStartAddr+1
        pla
        sta     R_SentenceStartAddr
        rts
;===========================================
L_SentencePlayNewTable:
        xSETB   R_SentenceCtrl,C_SentenceNewPlayBit
        jsr     F_SentenceAddrAddOne
        sta     R_SentenceTmp
        jsr     F_SentenceAddrAddOne
        pha
        jsr     F_SentenceAddrAddOne
        pha
        lda     R_SentenceStartAddr
        sta     R_SentenceStartAddrBake
        lda     R_SentenceStartAddr+1
        sta     R_SentenceStartAddrBake+1
        pla     
        sta     R_SentenceStartAddr+1
        pla
        sta     R_SentenceStartAddr
        jsr     F_SentenceAddrAddOne
        cmp     #C_TableNotExist
        beq     L_PlayExitNewTable
        lda     R_SentenceTmp
.if C_NeedNewT_AmPm
        cmp     #C_SentenceNewT_AmPm
        bne     L_SentenceCheckNotAmPm
        xJB     ID_TIAO,2,L_PlayExitNewTable
        xJB     R_SentenceCtrl_1,C_SentenceAjustHBit,L_PlayExitNewTable
        bra     F_SevicePlayNewT_AmPm
L_SentenceCheckNotAmPm:
        cmp     #C_SentenceAjus_AmPm
        bne     L_SentenceCheckNotAjusAmPm
        xJB     ID_TIAO,2,L_PlayExitNewTable
        xJNB    R_SentenceCtrl_1,C_SentenceAjustHBit,L_PlayExitNewTable
F_SevicePlayNewT_AmPm:
        lda     #0
        xJNB    R_SentenceCtrl_1,C_SentenceAmPmBit,L_PlayCurrentNextTable
        lda     #2
        bra     L_PlayCurrentNextTable
L_SentenceCheckNotAjusAmPm:
.endif
.if C_NeedNewT_SIGN
        CMP     #C_SentenceNewT_SIGN
        BNE     L_SentenceCheckTemperatureOrFahrenheit
        lda     #4          ;Negative
        BBS3	R_TempCnt+1,L_PlayCurrentNextTable
        ;Positive & zero
        lda     R_SentenceX10
        ora     R_SentenceX01
        beq     L_PlayCurrentNextTable
        lda     #2
        bra     L_PlayCurrentNextTable
L_SentenceCheckTemperatureOrFahrenheit:
.endif
.if C_NeedNewT_Temp
        cmp     #C_SentenceNewT_Temp
        bne     L_SentenceNewT_Temp
        lda     #0
        BBR0	ID_SORT,L_PlayCurrentNextTable
        lda     #2
        bra     L_PlayCurrentNextTable
L_SentenceNewT_Temp:
.endif
L_PlayOtherNextTable:
        lda     R_SentenceTmp
        clc
        rol     a
L_PlayCurrentNextTable:      
        clc
        adc     R_SentenceStartAddr
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        jsr     F_GetSelfTableAddr
        bra     F_SevicePlaySentence
L_PlayExitNewTable:
        lda     R_SentenceStartAddrBake
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddrBake+1
        sta     R_SentenceStartAddr+1
        xCLRB   R_SentenceCtrl,C_SentenceNewPlayBit
;===========================================
F_SevicePlaySentence:
        xJNB	R_SoundCtrl,C_SentencePlayingBit,L_SoundNotOver 
        xJB	    tmrc,DATA7,L_SoundNotOver
        xJB     R_SETCNT,DATA3,L_SoundNotOver 
        jsr     F_SentenceAddrAddOne
        cmp     #C_SentenceNewT
        bne     L_SkipSentencePlayNewTable
        jmp     L_SentencePlayNewTable
L_SkipSentencePlayNewTable:
        cmp     #C_SentenceMute
        beq     L_ExeMuteCommand
        cmp     #C_SentenceStop
        bne     L_ExeStopCommand
        xJB     R_SentenceCtrl,C_SentenceNewPlayBit,L_PlayExitNewTable
        xCLRB   R_SoundCtrl,C_SentencePlayingBit ;xwx
L_SoundNotOver:
        rts     
L_ExeStopCommand:
        sta     R_SentenceTmp
        xCLRB   R_SentenceCtrl,C_SentenceSampXBit
        lda     (R_SentenceStartAddr)
        cmp     #C_SentenceSamp
        bne     L_SkipGetSample
        jsr     F_SentenceAddrAddOne
        jsr     F_SentenceAddrAddOne
        sta     VoiceLen
        jsr     F_SentenceAddrAddOne
        sta     VoiceLen+1
        ora     VoiceLen
        beq     L_SkipGetSample
        xSETB   R_SentenceCtrl,C_SentenceSampXBit
L_SkipGetSample:
        lda     R_SentenceTmp
        jmp     F_PlaySound
;===========================================
L_ExeMuteCommand:
        jsr     F_SentenceAddrAddOne
        sta     VoiceLen
        jsr     F_SentenceAddrAddOne
        sta     VoiceLen+1
        jmp     F_SpeechMuteCh0
;===========================================
PlaySound:
		xSETB   R_SoundCtrl,C_SentencePlayingBit 
;;===========================================
        sta     R_SentenceTmp
        ldx     #0ffh
L_LoopCheckWhichNode:
        inx
        cpx     #C_NodeValueXLen
        bne     L_NodeValueX_OverFlow
        jmp     L_NodeValueXOverFlow
L_NodeValueX_OverFlow:
        lda     T_NodeValueX,x
        cmp     R_SentenceTmp
        bcc     L_LoopCheckWhichNode
        cpx     #0
        bne     L_CheckNotNumber
        bra     L_CheckNumberX
L_CheckNotNumber:
        lda     R_SentenceTmp
        sec
        sbc     T_NodeValueY,x
        clc
        rol     a
        sta     R_SentenceTmp
        txa
        clc
        rol     a
        tax
L_CheckTempDot:
        lda     T_SentenceTable,x
        sta     R_SentenceStartAddr
        lda     T_SentenceTable+1,x
        sta     R_SentenceStartAddr+1
        clc
        lda     R_SentenceTmp
L_SetTableAsNext:
        adc     R_SentenceStartAddr
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        lda     (R_SentenceStartAddr)
        sta     R_SentenceNumberXXX
        lda     R_SentenceStartAddr
        clc
        adc     #1
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        lda     (R_SentenceStartAddr)
        sta     R_SentenceStartAddr+1
        lda     R_SentenceNumberXXX
        sta     R_SentenceStartAddr
        cpx     #C_CheckUnitX
        bne     L_CheckForTemperatureX
        lda     R_SentenceTmp
        cmp     #C_CheckUnitX_CHIM
        beq     L_CheckNotUnitX
        cmp     #C_CheckUnitXTempDot
        beq     L_CheckNotUnitX
        jmp     L_CheckUnitX
L_CheckForTemperatureX:
        cpx     #C_CheckTemperatureX
        bne     L_CheckNotUnitX
        lda     R_SentenceTmp
        cmp     #C_CheckTemp_Degree
        bne     L_CheckNotUnitX
        jmp     L_CheckTemperatureX
L_CheckNotUnitX:
L_GetSentenceNumberXStartAddr:
        xCLRB   R_SentenceCtrl,C_SentenceNewPlayBit
        xCLRB   R_SentenceCtrl,C_SentenceAsNextBit
        jsr     F_StopSound
        jsr     F_SevicePlaySentence
        rts
;===========================================
L_CheckTableAsNext:
        lda     R_SentenceStartAddrBake
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddrBake+1
        sta     R_SentenceStartAddr+1
        xCLRB   R_SentenceCtrl,C_SentenceAsNextBit
        lda     R_SentenceX01       ;R_SentenceTmp
        clc
        rol     a
        jmp     L_SetTableAsNext
;===========================================
L_CheckNumberX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Number
        sta     R_SentenceNumberXXX
        bne     L_CheckNumberXXX
L_NodeValueXOverFlow:
L_SentenceNumberXXXOverflow:
L_TableNotExist:
L_CheckTableForNext:
        xCLRB   R_SoundCtrl,C_SentencePlayingBit 
        jsr     F_StopSound
        rts
L_CheckNumberXXX:
        ldx     #0ffh
L_GetSentenceNumberXXX:
        inx
        cpx     #C_SentenceNumberXXXLen
        beq     L_SentenceNumberXXXOverflow
        lda     T_SentenceNumberXXX,x
        cmp     R_SentenceNumberXXX
        bne     L_GetSentenceNumberXXX
        txa
        clc
        rol     a
        tax
        lda     T_TableForNumberX,x
        sta     R_SentenceStartAddr
        lda     T_TableForNumberX+1,x
        sta     R_SentenceStartAddr+1
        jsr     F_SentenceAddrAddOne
        cmp     #C_TableNotExist
        beq     L_TableNotExist
        
;        lda     R_SentenceTmp
;        cmp     #0ah        ;ʮ
;        bne     L_CheckNextNumberXXX
;        lda     #1
;L_CheckNextNumberXXX:
;        cmp     #0bh
;        bne     L_CheckNextNumberXXX1
;        lda     #2
;L_CheckNextNumberXXX1:
;        sta     R_SentenceTmp

        xJB     R_SentenceCtrl,C_SentenceAsNextBit,L_CheckTableAsNext
        
        clc
        lda     R_SentenceTmp
        rol     a
        adc     R_SentenceTmp
        adc     R_SentenceStartAddr
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        lda     R_SentenceX10
        sta     R_SentenceTmp
L_CheckUnitY:
        jsr     F_SentenceAddrAddOne
        cmp     #C_SelfTable
        beq     L_SelfTable
        cmp     #C_New_Table
        beq     L_New_Table 
        bra     L_Nxt_Table
L_SelfTable:
        jsr     F_GetSelfTableAddr
        jmp     L_GetSentenceNumberXStartAddr
L_New_Table:
        jsr     F_GetNewTableAddr
        lda     R_SentenceTmp
        clc
        rol     a
        adc     R_SentenceStartAddr
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        jsr     F_GetNxtTableAddr
        
        jmp     L_GetSentenceNumberXStartAddr
L_Nxt_Table
        jsr     F_GetNxtTableAddr
        xSETB   R_SentenceCtrl,C_SentenceAsNextBit
        lda     R_SentenceStartAddr
        sta     R_SentenceStartAddrBake
        lda     R_SentenceStartAddr+1
        sta     R_SentenceStartAddrBake+1
        jmp     L_CheckTableForNext
;===========================================
L_CheckUnitX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Number
        cmp     #C_SentenceTemp_X
        bne     L_ContinueCheckUnitX
        lda     #C_CheckUnitXTempDot
        sta     R_SentenceTmp
        jmp     L_CheckTempDot
L_ContinueCheckUnitX:
L_CheckTemperatureX:

        lda     R_SentenceX10
        sta     R_SentenceTmp
        lda     R_SentenceX01
        sta     R_SentenceNumberXXX
        
        
        lda     R_SentenceCtrl
        and     #C_Sentence_Number
        cmp     #C_SentenceHour_X
        bne     L_CheckNextX
	    jsr     F_CheckMinuteDecade
L_CheckNextX:

;        cmp     #C_SentenceMinute_X
;        bne     L_CheckNextX1
;	     jsr     F_CheckMinuteDecade
;	     jsr     F_CheckTempXX
;L_CheckNextX1:

        jsr     F_SentenceAddrAddOne
        cmp     #C_TableNotExist
        beq     L_TableNotExistX
        
        clc
        lda     R_SentenceNumberXXX
        rol     a
        adc     R_SentenceNumberXXX
        adc     R_SentenceStartAddr
        sta     R_SentenceStartAddr
        lda     R_SentenceStartAddr+1
        adc     #0
        sta     R_SentenceStartAddr+1
        jmp     L_CheckUnitY
L_TableNotExistX:
        jmp     L_TableNotExist
;===========================================
F_CheckYearXX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceYear_XX
        sta     R_SentenceCtrl
        rts
F_CheckYearX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceYear_X
        sta     R_SentenceCtrl
        rts
F_CheckMonthXX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceMonth_XX
        sta     R_SentenceCtrl
        rts
F_CheckMonthX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceMonth_X
        sta     R_SentenceCtrl
        rts
F_CheckDayXX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceDay_XX
        sta     R_SentenceCtrl
        rts
F_CheckDayX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceDay_X
        sta     R_SentenceCtrl
        rts
F_CheckAfterDataDecade:
        lda     R_SentenceCtrl
        and     #C_Sentence_Number
        cmp     #C_SentenceMonth_XX
        beq     L_DataAfterDecade
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceDay_X
        sta     R_SentenceCtrl
        rts
L_DataAfterDecade:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceMonth_X
        sta     R_SentenceCtrl
        rts
F_CheckWeekX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceWeek_X
        sta     R_SentenceCtrl
        rts
F_ChechHourDecade:
        jsr     F_SetSentenceX10_01
        ;LDHN    R_SayDataTemp1
        ;beq     L_HourNoDecade
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceHour_XX
        sta     R_SentenceCtrl
;        jmp     L_HourDecade
;L_HourNoDecade:
;        sta     R_SentenceX10
;        lda     R_SentenceCtrl
;        and     #C_Sentence_Null_N
;        ora     #C_SentenceHour_X
;        sta     R_SentenceCtrl
;L_HourDecade:     
        rts
F_CheckMinuteDecade:
        LDHN    R_SayDataTemp2
        STA     R_SentenceX10
        LDLN    R_SayDataTemp2
        STA     R_SentenceX01
L_CheckMinuteDecade:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceMinute_XX
        sta     R_SentenceCtrl
        rts
F_CheckAfterDecade:
        lda     R_SentenceCtrl
        and     #C_Sentence_Number
        cmp     #C_SentenceHour_XX
        beq     L_HourAfterDecade
        cmp     #C_SentenceTemp_XX
        beq     L_TempAfterDecade
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceMinute_X
        sta     R_SentenceCtrl
        rts
L_HourAfterDecade:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceHour_X
        sta     R_SentenceCtrl
        rts
L_TempAfterDecade:
;        LDA     #0
;        STA     R_SentenceX10
;        LDHN    R_SayDataTemp2
;       ;STA     R_SentenceX10
;       ;LDLN    R_SayDataTemp2
;        STA     R_SentenceX01
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceTemp_X
        sta     R_SentenceCtrl
        rts
F_CheckTemp_XXX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceTemp_XXX
        sta     R_SentenceCtrl
        rts
F_CheckTempXX_1:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceTemp_XX_1
        sta     R_SentenceCtrl
        Bra     F_SetSentenceX10_01
F_CheckTempXX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceTemp_XX
        sta     R_SentenceCtrl
F_SetSentenceX10_01:
        LDHN    R_SayDataTemp1
        STA     R_SentenceX10
        LDLN    R_SayDataTemp1
        STA     R_SentenceX01
        rts
F_CheckDotX:
        lda     R_SentenceCtrl
        and     #C_Sentence_Null_N
        ora     #C_SentenceTemp_DotX
        sta     R_SentenceCtrl
        rts
		
;F_SentenceTemp_X_1:	;XWX
;        lda     R_SentenceCtrl
;        and     #C_Sentence_Null_N
;       ora     #C_SentenceTemp_X_1
;       sta     R_SentenceCtrl
;       rts
;===========================================

.INCLUDE    SentPlay.tbl
