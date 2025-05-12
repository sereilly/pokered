ViridianSchoolHouse_Script:
	jp EnableAutoTextBoxDrawing

ViridianSchoolHouse_TextPointers:
	def_text_pointers
	dw_const ViridianSchoolHouseBrunetteGirlText, TEXT_VIRIDIANSCHOOLHOUSE_BRUNETTE_GIRL
	dw_const ViridianSchoolHouseCooltrainerFText, TEXT_VIRIDIANSCHOOLHOUSE_COOLTRAINER_F
	dw_const ViridianSchoolHouseCaterpiePokeBallText,       TEXT_VIRIDIANSCHOOLHOUSE_CATERPIE_POKE_BALL
	dw_const ViridianSchoolHouseNidoranMPokeBallText,         TEXT_VIRIDIANSCHOOLHOUSE_NIDORANM_POKE_BALL
	dw_const ViridianSchoolHouseMankeyPokeBallText,        TEXT_VIRIDIANSCHOOLHOUSE_MANKEY_POKE_BALL

ViridianSchoolHouseBrunetteGirlText:
	text_far _ViridianSchoolHouseBrunetteGirlText
	text_end

ViridianSchoolHouseCooltrainerFText:
	text_far _ViridianSchoolHouseCooltrainerFText
	text_end

; Starter selection
ViridianSchoolHouseCaterpiePokeBallText:
	text_asm
	ld a, STARTER1_VIRIDIAN
	ld b, VIRIDIANSCHOOLHOUSE_CATERPIE_POKE_BALL
	jr VirdianSchoolHouseSelectedPokeBallScript

ViridianSchoolHouseNidoranMPokeBallText:
	text_asm
	ld a, STARTER2_VIRIDIAN
	ld b, VIRIDIANSCHOOLHOUSE_NIDORANM_POKE_BALL
	jr VirdianSchoolHouseSelectedPokeBallScript

ViridianSchoolHouseMankeyPokeBallText:
	text_asm
	ld a, STARTER3_VIRIDIAN
	ld b, VIRIDIANSCHOOLHOUSE_MANKEY_POKE_BALL
	jr VirdianSchoolHouseSelectedPokeBallScript


VirdianSchoolHouseSelectedPokeBallScript:
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
	cp VIRIDIANSCHOOLHOUSE_CATERPIE_POKE_BALL
	jr z, ViridianSchoolHouseYouWantCaterpieText
	cp VIRIDIANSCHOOLHOUSE_NIDORANM_POKE_BALL
	jr z, ViridianSchoolHouseYouWantNidoranMText
	jr ViridianSchoolHouseYouWantMankeyText

ViridianSchoolHouseYouWantCaterpieText:
	ld hl, .Text
	jr ViridianSchoolHouseMonChoiceMenu
.Text:
	text_far _ViridianSchoolHouseYouWantCaterpieText
	text_end

ViridianSchoolHouseYouWantNidoranMText:
	ld hl, .Text
	jr ViridianSchoolHouseMonChoiceMenu
.Text:
	text_far _ViridianSchoolHouseYouWantNidoranMText
	text_end

ViridianSchoolHouseYouWantMankeyText:
	ld hl, .Text
	jr ViridianSchoolHouseMonChoiceMenu
.Text:
	text_far _ViridianSchoolHouseYouWantMankeyText
	text_end

ViridianSchoolHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, ViridianSchoolHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, ViridianSchoolHouseHouseMonEnergeticText
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

ViridianSchoolHouseMonChoiceEnd:
	jp TextScriptEnd

ViridianSchoolHouseHouseMonEnergeticText:
	text_far _PewterNidoranHouseMonEnergeticText
	sound_get_key_item
	text_end