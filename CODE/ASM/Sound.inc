;================================================
; Purpose	: Voice and melody RAM define
; Edit by 	: John
; Edit data	: 2007-2-26 9:49
;================================================
;.ifndef	R_Temp1Sound		;xwx
R_Temp1Sound	ds	2		;xwx
;.endif						;xwx
C_SystemClock		EQU	4000000
C_SoundStart 		EQU     8000h
C_PcmSampleRate		equ	256-C_SystemClock/32/6500
;C_VOLUME		equ	1
C_ChangeInstrument	equ	1	;;;;;;;;;;;;
C_MonoChannel		equ	1	;;;;;;;;;;;
C_TempoAdjust		equ	0
C_VolumeSetSum		equ	8
C_DivClock		equ	1000
C_SigleChannelOtherFreq	equ	1
; Code type       : First Low nibble Last High nibble.
; Adpcm Head Code : 01 (ED 00 This two byte is adpcm sample rate.)
; pcm Head Code   : 03 (69 05 This two byte is pcm samples.)
; Mid Head Code   : 3F (00 00 This two byte not define.)
; Mute Head Code  : FF (10 00 This two byte is mute length.)
C_PlayAdpcm		equ	01h
C_PlayPcm		equ	03h
C_PlayMid		equ	3fh
C_PlayMut		equ	0FFh
;------------------------------------------------
C_ToneHighOctave	equ	C_SystemClock/32
C_ToneLowOctave		equ	32000
;------------------------------------------------
; Used for sound data addr.
R_SayDataTemp1		DS	1		;xwx
R_SayDataTemp2		DS	1		;xwx
R_SoundCtrl         ds  1		;xwx
R_SETCNT			ds  1		;xwx
;--------------------------------------
C_SentencePlaying       equ 01h 
C_SentencePlaying_N     equ 0feh
C_SentencePlayingBit    equ 0   
;--------------------------------------
C_ChmValid              equ 02h
C_ChmValid_             equ 0fDh
C_ChmInvalidBit         equ 1      
;--------------------------------------
.ifndef	R_SoundAddr
R_SoundAddr		ds	3	;3B...ok
.endif

; Current sound status

.ifndef	R_SoundStatus
R_SoundStatus		ds	1	;1B...ok
.endif

C_AdpcmCheck		equ	0
C_PcmCheck		equ	1
C_MelodyCheck		equ	2
C_MuteCheck		equ	3
; Public ctrl reg.

.ifndef	R_CtrlRegister
R_CtrlRegister		ds	1	;1B...OK
.endif

C_AdpcmNibbleFlag 	equ	01h
C_EvpSeveiceCh1		equ	1
C_EvpSeveiceCh2		equ	2
C_SingleChannel		equ	3
C_TempoEvent		equ	4
; Used for Adpcm, may be used in other

.ifndef	R_AdpcmNewCode
R_AdpcmNewCode		DS      1	;1B...OK
.endif
.ifndef	R_PnReg
R_PnReg         	DS      2	;2B...OK
.endif

; Used for pcm and mute, share with adpcm
R_PcmLength		equ	R_PnReg
; Volumn 8 --> 0 : High --> Low --> 0 
;R_Volumn		DS      1	;2B����ȥ��		;;;xwx
;------------------------------------------------
; Melody Ram define.
; High Nibble for ch2 Octave, Low Nibble for ch1.

.ifndef	R_MelodyStatus
R_MelodyStatus		ds	1	;1B...OK
.endif

C_EvpEnableCh1		equ	3
C_OctaveCh1		EQU	0F8H
C_EvpEnableCh2		equ	7
C_OctaveCh2		equ	8Fh
; Mid some ram share with adpcm
R_BeatCnt		equ	R_AdpcmNewCode
R_TempoCnt		equ	R_PnReg
R_TempoDataIndex	equ	R_PnReg+1
.if C_TempoAdjust
R_TempoAdjust		ds	1	;û�ж���1B
.endif
; Instrument number of ch1

.ifndef	R_InstCh1
R_InstCh1	      	DS      2	;2B...OK
.endif

; Instrument number of ch2

.ifndef	R_InstCh2
R_InstCh2	      	DS      2	;2B...OK
.endif

; Ch1 EVP Ram define here

.ifndef	R_EvpCntCh1
R_EvpCntCh1		ds	2	;2B...OK
.endif
.ifndef	R_EvpDividerCh1
R_EvpDividerCh1		ds	3	;3B...OK
.endif

; Ch2 EVP Ram define here
.ifndef	R_EvpCntCh2
R_EvpCntCh2		ds	2	;3B...OK
.endif
.ifndef	R_EvpDividerCh2
R_EvpDividerCh2		ds	3	;3B...OK
.endif
;================================================
InitSound	macro
;        	PB2_PWM
;       	PB3_PWM
			PWM_OFF
        	SEL_VOICE
        	lda	#0
        	sta	R_SoundStatus
        	sta	R_MelodyStatus
; Volumn 8 --> 0 : High --> Low --> 0 
;        	ldx	#8		
;        	jsr	F_VolumnSet
        	lda	#9+16
        	sta	R_TempoDataIndex
.if C_TempoAdjust
        	lda	#16
        	sta	R_TempoAdjust
.endif

;	Purpose : Change MID instrument.
;	Input   : Instrument Number --> A, Channel Number --> X.
;	Return  : none
;		lda	#0
;		ldx	#0
;		jsr	F_ChangeInstrument
;		lda	#0
;		ldx	#1
;		jsr	F_ChangeInstrument
        	endm
;================================================
; Tempo macro define
; Base on 1/8 
LoadTempo	MACRO  tempo
                DB      C_DivClock*60/(tempo)/8
                ENDM
;================================================
LoadToneFreq:  .MACRO  freq,HighOrLow
	.if	HighOrLow
                DB      256-(C_ToneHighOctave/(freq))
        .else
                DB      256-(C_ToneLowOctave/(freq))
        .endif        
                .ENDM
;================================================
LoadOctaveToneFreq:    .MACRO  Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   1059*Freq/1000,HighOrLow
        LoadToneFreq   1122*Freq/1000,HighOrLow
        LoadToneFreq   1189*Freq/1000,HighOrLow
        LoadToneFreq   1260*Freq/1000,HighOrLow
        LoadToneFreq   1335*Freq/1000,HighOrLow
        LoadToneFreq   1414*Freq/1000,HighOrLow
        LoadToneFreq   1498*Freq/1000,HighOrLow
        LoadToneFreq   1587*Freq/1000,HighOrLow
        LoadToneFreq   1682*Freq/1000,HighOrLow
        LoadToneFreq   1782*Freq/1000,HighOrLow
        LoadToneFreq   1888*Freq/1000,HighOrLow
                        .ENDM
;================================================
LoadOctaveToneFreq_:    .MACRO  Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
        LoadToneFreq   Freq,HighOrLow
                        .ENDM