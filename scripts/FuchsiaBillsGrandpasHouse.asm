FuchsiaBillsGrandpasHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

FuchsiaBillsGrandpasHouse_TextPointers:
	def_text_pointers
	dw_const FuchsiaBillsGrandpasHouseMiddleAgedWomanText, TEXT_FUCHSIABILLSGRANDPASHOUSE_MIDDLE_AGED_WOMAN
	dw_const FuchsiaBillsGrandpasHouseBillsGrandpaText,    TEXT_FUCHSIABILLSGRANDPASHOUSE_BILLS_GRANDPA
	dw_const FuchsiaBillsGrandpasHouseYoungsterText,       TEXT_FUCHSIABILLSGRANDPASHOUSE_YOUNGSTER
	dw_const FuchsiaBillsGrandpasHouseKoffingPokeballText,       TEXT_FUCHSIABILLSGRANDPASHOUSE_KOFFING_POKE_BALL
	dw_const FuchsiaBillsGrandpasHouseDoduoPokeballText,         TEXT_FUCHSIABILLSGRANDPASHOUSE_DODUO_POKE_BALL
	dw_const FuchsiaBillsGrandpasHouseSlowpokePokeballText,        TEXT_FUCHSIABILLSGRANDPASHOUSE_SLOWPOKE_POKE_BALL

FuchsiaBillsGrandpasHouseMiddleAgedWomanText:
	text_far _FuchsiaBillsGrandpasHouseMiddleAgedWomanText
	text_end

FuchsiaBillsGrandpasHouseBillsGrandpaText:
	text_far _FuchsiaBillsGrandpasHouseBillsGrandpaText
	text_end

FuchsiaBillsGrandpasHouseYoungsterText:
	text_far _FuchsiaBillsGrandpasHouseYoungsterText
	text_end

; Starter selection
FuchsiaBillsGrandpasHouseKoffingPokeballText:
	text_asm
	ld a, STARTER1_FUCHSIA
	ld b, FUCHSIABILLSGRANDPASHOUSE_KOFFING_POKE_BALL
	jr FuchsiaBillsGrandpasHouseSelectedPokeBallScript

FuchsiaBillsGrandpasHouseDoduoPokeballText:
	text_asm
	ld a, STARTER2_FUCHSIA
	ld b, FUCHSIABILLSGRANDPASHOUSE_DODUO_POKE_BALL
	jr FuchsiaBillsGrandpasHouseSelectedPokeBallScript

FuchsiaBillsGrandpasHouseSlowpokePokeballText:
	text_asm
	ld a, STARTER3_FUCHSIA
	ld b, FUCHSIABILLSGRANDPASHOUSE_SLOWPOKE_POKE_BALL
	jr FuchsiaBillsGrandpasHouseSelectedPokeBallScript

FuchsiaBillsGrandpasHouseSelectedPokeBallScript:
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
	cp FUCHSIABILLSGRANDPASHOUSE_KOFFING_POKE_BALL
	jr z, FuchsiaBillsGrandpasHouseYouWantKoffingText
	cp FUCHSIABILLSGRANDPASHOUSE_DODUO_POKE_BALL
	jr z, FuchsiaBillsGrandpasHouseYouWantDoduoText
	jr FuchsiaBillsGrandpasHouseYouWantSlowpokeText

FuchsiaBillsGrandpasHouseYouWantKoffingText:
	ld hl, .Text
	jr FuchsiaBillsGrandpasHouseMonChoiceMenu
.Text:
	text_far _FuchsiaBillsGrandpasHouseYouWantKoffingText
	text_end

FuchsiaBillsGrandpasHouseYouWantDoduoText:
	ld hl, .Text
	jr FuchsiaBillsGrandpasHouseMonChoiceMenu
.Text:
	text_far _FuchsiaBillsGrandpasHouseYouWantDoduoText
	text_end

FuchsiaBillsGrandpasHouseYouWantSlowpokeText:
	ld hl, .Text
	jr FuchsiaBillsGrandpasHouseMonChoiceMenu
.Text:
	text_far _FuchsiaBillsGrandpasHouseYouWantSlowpokeText
	text_end

FuchsiaBillsGrandpasHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, FuchsiaBillsGrandpasHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, FuchsiaBillsGrandpasHouseMonEnergeticText
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

FuchsiaBillsGrandpasHouseMonChoiceEnd:
	jp TextScriptEnd

FuchsiaBillsGrandpasHouseMonEnergeticText:
	text_far _FuchsiaBillsGrandpasHouseMonEnergeticText
	sound_get_key_item
	text_end
