.page0
.org 	00H
pa	EQU	01H	;port a data reg.PA[1111 1111]
PA	EQU	01H
pawake	EQU	02H	;WakeUp Mask Reg.0:None 1:Wake
PAWAKE	EQU	02H
padir	EQU	04H	;PortA Direction Reg.0:Output 1:Input
PADIR	EQU	04H
pb	EQU	05H	;portB Data Reg.PB[***111**]
PB	EQU	05H
pbtype	EQU	06H	;Pb Output type Reg.0:No-MOS 1:C-MOS
PBTYPE	EQU	06H
pc	EQU	07H	;PortC data Reg.PC[7:0]
PC	EQU	07H 
P_PC EQU pc
pcdir	EQU	08H	;PC direction reg.0:output 1:input
PCDIR	EQU	08H
P_PC_IO EQU	pcdir
pcseg	EQU	09H	;PCD/SEG select reg.[**11 11**] 0:pc0,pc[3:1],pc[5:4] 1:seg0,seg[3:1],seg[5:4]
PCSEG	EQU	09H
PD		EQU	0AH
P_PD    EQU PD
PDDIR	EQU 0BH
P_PD_IO EQU	PDDIR
padf0	EQU	0CH	;
PADF0	EQU	0CH	;	
padf1	EQU	0DH	;
PADF1	EQU 0DH
ier	EQU	0EH	;Interrupt enable reg.
IER	EQU	0EH		
ifr	EQU	0FH	;interrupt request flag reg.
IFR	EQU	0FH
P_IFR EQU ifr	
P_IER EQU ier	
tmr0h	EQU	10H	;
TMR0	EQU	10H
TMR0H	EQU	10H	
tmr0	EQU	tmr0h	;
P_TMR0	EQU	tmr0h
TMR1	EQU	11H
tmr0l	EQU	11H	;
tmr1h	EQU	12H	;
tmr1	EQU	tmr1h	;
;tmr1l	EQU	13H	;
P_TMR1	EQU	 tmr1
;*******************LCD Driver************************
tmrc	EQU	16H	;timer control reg.
TMRC	EQU	16H
P_TMRCTRL EQU tmrc
tmrclk	EQU	17H	;timer control reg
TMCLK	EQU	17H
P_TMRCLK EQU tmrclk
divc	EQU	18H	;divider control reg
DIVC	EQU 18h
lcdctrl	EQU	19H	;lcd control reg
LCDCTRL	EQU	19H
lcdcom	EQU	1AH	;lcd com select
LCDCOM	EQU	1AH	
LCDSA	EQU	1BH
wdtc	EQU	1CH	;watchdog control reg.
WDTC	EQU wdtc
sysclk	EQU	1DH	;system clock select reg
SYSCLK	EQU	1DH
halt	EQU	1EH	;cpu halt control reg
HALT	EQU	1EH
DAC		EQU	1FH	;AUD data register
AUD0	EQU	1FH
DAC_CTL	EQU	20H	;AUD control register
AUDCR	EQU	20H
frame	EQU	21H	;lcd clock source reg.
FRAME	EQU	21H
;VOL		EQU	22H
bank	EQU	23H	;bank register
BANK	EQU	23H
AUD1	EQU	25H
PE		EQU	2AH
PEDIR	EQU	2BH
mf		equ	2fh
MF		EQU	2Fh
LVC		EQU	3DH

;SPCR	EQU	3DH
;SPSR	EQU	3EH
;SPDR	EQU	3FH


fKeyDeb     EQU     0

P_SYSCLK	EQU		sysclk
.ends