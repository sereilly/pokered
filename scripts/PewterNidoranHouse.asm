PewterNidoranHouse_Script:
	jp EnableAutoTextBoxDrawing

PewterNidoranHouse_TextPointers:
	def_text_pointers
	dw_const PewterNidoranHouseNidoranText,       TEXT_PEWTERNIDORANHOUSE_NIDORAN
	dw_const PewterNidoranHouseLittleBoyText,     TEXT_PEWTERNIDORANHOUSE_LITTLE_BOY
	dw_const PewterNidoranHouseMiddleAgedManText, TEXT_PEWTERNIDORANHOUSE_MIDDLE_AGED_MAN
	dw_const PewterNidoranHouseGeodudePokeballText,       TEXT_PEWTERNIDORANHOUSE_GEODUDE_POKE_BALL
	dw_const PewterNidoranHouseNidoranFPokeballText,         TEXT_PEWTERNIDORANHOUSE_NIDORANF_POKE_BALL
	dw_const PewterNidoranHouseOddishPokeballText,        TEXT_PEWTERNIDORANHOUSE_ODDISH_POKE_BALL

PewterNidoranHouseNidoranText:
	text_far _PewterNidoranHouseNidoranText
	text_asm
	ld a, NIDORAN_M
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PewterNidoranHouseLittleBoyText:
	text_far _PewterNidoranHouseLittleBoyText
	text_end

PewterNidoranHouseMiddleAgedManText:
	text_far _PewterNidoranHouseMiddleAgedManText
	text_end

; Starter selection
PewterNidoranHouseGeodudePokeballText:
	text_asm
	ld a, STARTER1_PEWTER
	ld b, PEWTERNIDORANHOUSE_GEODUDE_POKE_BALL
	jr PewterNidoranHouseSelectedPokeBallScript

PewterNidoranHouseNidoranFPokeballText:
	text_asm
	ld a, STARTER2_PEWTER
	ld b, PEWTERNIDORANHOUSE_NIDORANF_POKE_BALL
	jr PewterNidoranHouseSelectedPokeBallScript

PewterNidoranHouseOddishPokeballText:
	text_asm
	ld a, STARTER3_PEWTER
	ld b, PEWTERNIDORANHOUSE_ODDISH_POKE_BALL
	jr PewterNidoranHouseSelectedPokeBallScript

PewterNidoranHouseSelectedPokeBallScript:
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
	cp PEWTERNIDORANHOUSE_GEODUDE_POKE_BALL
	jr z, PewterNidoranHouseYouWantGeodudeText
	cp PEWTERNIDORANHOUSE_NIDORANF_POKE_BALL
	jr z, PewterNidoranHouseYouWantNidoranFText
	jr PewterNidoranHouseYouWantOddishText

PewterNidoranHouseYouWantGeodudeText:
	ld hl, .Text
	jr PewterNidoranHouseMonChoiceMenu
.Text:
	text_far _PewterNidoranHouseYouWantGeodudeText
	text_end

PewterNidoranHouseYouWantNidoranFText:
	ld hl, .Text
	jr PewterNidoranHouseMonChoiceMenu
.Text:
	text_far _PewterNidoranHouseYouWantNidoranFText
	text_end

PewterNidoranHouseYouWantOddishText:
	ld hl, .Text
	jr PewterNidoranHouseMonChoiceMenu
.Text:
	text_far _PewterNidoranHouseYouWantOddishText
	text_end

PewterNidoranHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, PewterNidoranHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, PewterNidoranHouseMonEnergeticText
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

PewterNidoranHouseMonChoiceEnd:
	jp TextScriptEnd

PewterNidoranHouseMonEnergeticText:
	text_far _PewterNidoranHouseMonEnergeticText
	sound_get_key_item
	text_end
