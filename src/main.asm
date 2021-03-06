;****************************************
;*	Blank Simple Source File
;*
;****************************************
;*
;*
;****************************************

;****************************************
;*	Includes
;****************************************
	; system includes
	INCLUDE	"lib/hardware.inc"
	INCLUDE "src/constants.asm"
	
;*****************************************
;*	user data (constants)
;*****************************************


;*****************************************
;*	equates
;*****************************************


;*****************************************
;*	cartridge header
;*****************************************

	SECTION	"Org $00",HOME[$00]
RST_00:	
	jp	$100

	SECTION	"Org $08",HOME[$08]
RST_08:	
	jp	$100

	SECTION	"Org $10",HOME[$10]
RST_10:
	jp	$100

	SECTION	"Org $18",HOME[$18]
RST_18:
	jp	$100

	SECTION	"Org $20",HOME[$20]
RST_20:
	jp	$100

	SECTION	"Org $28",HOME[$28]
RST_28:
	jp	$100

	SECTION	"Org $30",HOME[$30]
RST_30:
	jp	$100

	SECTION	"Org $38",HOME[$38]
RST_38:
	jp	$100

	SECTION	"V-Blank IRQ Vector",HOME[$40]
VBL_VECT:
	
	reti
	
	SECTION	"LCD IRQ Vector",HOME[$48]
LCD_VECT:
	reti

	SECTION	"Timer IRQ Vector",HOME[$50]
TIMER_VECT:
	reti

	SECTION	"Serial IRQ Vector",HOME[$58]
SERIAL_VECT:
	reti

	SECTION	"Joypad IRQ Vector",HOME[$60]
JOYPAD_VECT:
	reti
	
	SECTION	"Start",HOME[$100]
	nop
	jp	Start

	; $0104-$0133 (Nintendo logo - do _not_ modify the logo data here or the GB will not run the program)
	DB	$CE,$ED,$66,$66,$CC,$0D,$00,$0B,$03,$73,$00,$83,$00,$0C,$00,$0D
	DB	$00,$08,$11,$1F,$88,$89,$00,$0E,$DC,$CC,$6E,$E6,$DD,$DD,$D9,$99
	DB	$BB,$BB,$67,$63,$6E,$0E,$EC,$CC,$DD,$DC,$99,$9F,$BB,$B9,$33,$3E

	; $0134-$013E (Game title - up to 11 upper case ASCII characters; pad with $00)
	DB	"Heartache",0,0
		;0123456789A

	; $013F-$0142 (Product code - 4 ASCII characters, assigned by Nintendo, just leave blank)
	DB	"    "
		;0123

	; $0143 (Color GameBoy compatibility code)
	DB	$00	; $00 - DMG 
			; $80 - DMG/GBC
			; $C0 - GBC Only cartridge

	; $0144 (High-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0145 (Low-nibble of license code - normally $00 if $014B != $33)
	DB	$00

	; $0146 (GameBoy/Super GameBoy indicator)
	DB	$00	; $00 - GameBoy

	; $0147 (Cartridge type - all Color GameBoy cartridges are at least $19)
	DB	$19	; $19 - ROM + MBC5

	; $0148 (ROM size)
	DB	$01	; $01 - 512Kbit = 64Kbyte = 4 banks

	; $0149 (RAM size)
	DB	$00	; $00 - None

	; $014A (Destination code)
	DB	$00	; $01 - All others
			; $00 - Japan

	; $014B (Licensee code - this _must_ be $33)
	DB	$33	; $33 - Check $0144/$0145 for Licensee code.

	; $014C (Mask ROM version - handled by RGBFIX)
	DB	$00

	; $014D (Complement check - handled by RGBFIX)
	DB	$00

	; $014E-$014F (Cartridge checksum - handled by RGBFIX)
	DW	$00

;*****************************************
;*	Program Start
;*****************************************

	SECTION "Program Start",HOME[$0150]
Start:
	call WriteDMACodeToHRAM
	call Init
	call InitJoypad
	call InitFireballs
	call InitBattle
	call InitFinalize
	call InitSound
	call UpdateJoypad

Loop:
	call UpdateJoypad
	call UpdateBattleState
	call Sound

	halt

	call DrawEntities

	call DMARoutineHRAM

	jp Loop

	INCLUDE "src/oam_dma.asm"
	INCLUDE "src/init.asm"
	INCLUDE "src/entity.asm"
	INCLUDE "src/background.asm"
	INCLUDE "src/player.asm"
	INCLUDE "src/fireball.asm"
	INCLUDE "src/battleState.asm"
	INCLUDE "src/joypad.asm"
	INCLUDE "src/sound.asm"
	INCLUDE "src/text.asm"

	SECTION "BANK1",ROMX,BANK[$1]
SinTable:
	INCBIN  "bin/sinTable.bin";
GraphicsBinary:
	INCBIN  "graphics/tiles.chr"
	INCBIN  "graphics/tiles2.chr"
	INCBIN  "graphics/toriel.chr"
	INCLUDE "src/soundData.asm"
	INCLUDE "strings/strings.asm"
