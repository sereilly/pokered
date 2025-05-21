CeruleanTradeHouse_Script:
	jp EnableAutoTextBoxDrawing

CeruleanTradeHouse_TextPointers:
	def_text_pointers
	dw_const CeruleanTradeHouseGrannyText,  TEXT_CERULEANTRADEHOUSE_GRANNY
	dw_const CeruleanTradeHouseGamblerText, TEXT_CERULEANTRADEHOUSE_GAMBLER
	dw_const CeruleanTradeHousePoliwagPokeballText,       TEXT_CERULEANTRADEHOUSE_POLIWAG_POKE_BALL
	dw_const CeruleanTradeHouseAbraPokeballText,         TEXT_CERULEANTRADEHOUSE_ABRA_POKE_BALL
	dw_const CeruleanTradeHouseMeowthPokeballText,        TEXT_CERULEANTRADEHOUSE_MEOWTH_POKE_BALL

CeruleanTradeHouseGrannyText:
	text_far _CeruleanTradeHouseGrannyText
	text_end

CeruleanTradeHouseGamblerText:
	text_asm
	ld a, TRADE_FOR_LOLA
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd

; Starter selection
CeruleanTradeHousePoliwagPokeballText:
	text_asm
	ld a, STARTER1_CERULEAN
	ld b, CERULEANTRADEHOUSE_POLIWAG_POKE_BALL
	jr CeruleanTradeHouseSelectedPokeBallScript

CeruleanTradeHouseAbraPokeballText:
	text_asm
	ld a, STARTER2_CERULEAN
	ld b, CERULEANTRADEHOUSE_ABRA_POKE_BALL
	jr CeruleanTradeHouseSelectedPokeBallScript

CeruleanTradeHouseMeowthPokeballText:
	text_asm
	ld a, STARTER3_CERULEAN
	ld b, CERULEANTRADEHOUSE_MEOWTH_POKE_BALL
	jr CeruleanTradeHouseSelectedPokeBallScript

CeruleanTradeHouseSelectedPokeBallScript:
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
	cp CERULEANTRADEHOUSE_POLIWAG_POKE_BALL
	jr z, CeruleanTradeHouseYouWantPoliwagText
	cp CERULEANTRADEHOUSE_ABRA_POKE_BALL
	jr z, CeruleanTradeHouseYouWantScytherText
	jr CeruleanTradeHouseYouWantMeowthText

CeruleanTradeHouseYouWantPoliwagText:
	ld hl, .Text
	jr CeruleanTradeHouseMonChoiceMenu
.Text:
	text_far _CeruleanTradeHouseYouWantPoliwagText
	text_end

CeruleanTradeHouseYouWantScytherText:
	ld hl, .Text
	jr CeruleanTradeHouseMonChoiceMenu
.Text:
	text_far _CeruleanTradeHouseYouWantScytherText
	text_end

CeruleanTradeHouseYouWantMeowthText:
	ld hl, .Text
	jr CeruleanTradeHouseMonChoiceMenu
.Text:
	text_far _CeruleanTradeHouseYouWantMeowthText
	text_end

CeruleanTradeHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, CeruleanTradeHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeruleanTradeHouseMonEnergeticText
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

CeruleanTradeHouseMonChoiceEnd:
	jp TextScriptEnd

CeruleanTradeHouseMonEnergeticText:
	text_far _CeruleanTradeHouseMonEnergeticText
	sound_get_key_item
	text_end