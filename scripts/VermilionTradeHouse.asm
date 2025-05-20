VermilionTradeHouse_Script:
	jp EnableAutoTextBoxDrawing

VermilionTradeHouse_TextPointers:
	def_text_pointers
	dw_const VermilionTradeHouseLittleGirlText, TEXT_VERMILIONTRADEHOUSE_LITTLE_GIRL
		dw_const VermilionTradeHousePikachuPokeballText,       TEXT_VERMILIONTRADEHOUSE_PIKACHU_POKE_BALL
	dw_const VermilionTradeHouseMachopPokeballText,         TEXT_VERMILIONTRADEHOUSE_MACHOP_POKE_BALL
	dw_const VermilionTradeHouseDiglettPokeballText,        TEXT_VERMILIONTRADEHOUSE_DIGLETT_POKE_BALL

VermilionTradeHouseLittleGirlText:
	text_asm
	ld a, TRADE_FOR_DUX
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd

; Starter selection
VermilionTradeHousePikachuPokeballText:
	text_asm
	ld a, STARTER1_VERMILION
	ld b, VERMILIONTRADEHOUSE_PIKACHU_POKE_BALL
	jr VermilionTradeHouseSelectedPokeBallScript

VermilionTradeHouseMachopPokeballText:
	text_asm
	ld a, STARTER2_VERMILION
	ld b, VERMILIONTRADEHOUSE_MACHOP_POKE_BALL
	jr VermilionTradeHouseSelectedPokeBallScript

VermilionTradeHouseDiglettPokeballText:
	text_asm
	ld a, STARTER3_VERMILION
	ld b, VERMILIONTRADEHOUSE_DIGLETT_POKE_BALL
	jr VermilionTradeHouseSelectedPokeBallScript

VermilionTradeHouseSelectedPokeBallScript:
	ld [wCurPartySpecies], a
	ld [wPokedexNum], a
	ld a, b
	ld [wSpriteIndex], a
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	predef StarterDex
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld a, [wSpriteIndex]
	cp VERMILIONTRADEHOUSE_PIKACHU_POKE_BALL
	jr z, VermilionTradeHouseYouWantPikachuText
	cp VERMILIONTRADEHOUSE_MACHOP_POKE_BALL
	jr z, VermilionTradeHouseYouWantMachopText
	jr VermilionTradeHouseYouWantDiglettText

VermilionTradeHouseYouWantPikachuText:
	ld hl, .Text
	jr VermilionTradeHouseMonChoiceMenu
.Text:
	text_far _VermilionTradeHouseYouWantPikachuText
	text_end

VermilionTradeHouseYouWantMachopText:
	ld hl, .Text
	jr VermilionTradeHouseMonChoiceMenu
.Text:
	text_far _VermilionTradeHouseYouWantMachopText
	text_end

VermilionTradeHouseYouWantDiglettText:
	ld hl, .Text
	jr VermilionTradeHouseMonChoiceMenu
.Text:
	text_far _VermilionTradeHouseYouWantDiglettText
	text_end

VermilionTradeHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, VermilionTradeHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, VermilionTradeHouseMonEnergeticText
	call PrintText
	xor a ; PLAYER_PARTY_DATA
	ld [wMonDataLocation], a
	ld a, 5
	ld [wCurEnemyLevel], a
	ld a, [wCurPartySpecies]
	ld [wPokedexNum], a
	call AddPartyMon
	ld hl, wStatusFlags4
	set BIT_GOT_STARTER, [hl]

	; fade to black and hide the other balls
	call GBFadeOutToBlack
	farcall StarterPicked
	call GBFadeInFromBlack

VermilionTradeHouseMonChoiceEnd:
	jp TextScriptEnd

VermilionTradeHouseMonEnergeticText:
	text_far _VermilionTradeHouseMonEnergeticText
	sound_get_key_item
	text_end
