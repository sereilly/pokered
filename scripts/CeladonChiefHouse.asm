CeladonChiefHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonChiefHouse_TextPointers:
	def_text_pointers
	dw_const CeladonChiefHouseChiefText,  TEXT_CELADONCHIEFHOUSE_CHIEF
	dw_const CeladonChiefHouseRocketText, TEXT_CELADONCHIEFHOUSE_ROCKET
	dw_const CeladonChiefHouseSailorText, TEXT_CELADONCHIEFHOUSE_SAILOR
	dw_const CeladonChiefHouseBellsproutPokeballText,       TEXT_CELADONCHIEFHOUSE_BELLSPROUT_POKE_BALL
	dw_const CeladonChiefHouseVulpixPokeballText,         TEXT_CELADONCHIEFHOUSE_VULPIX_POKE_BALL
	dw_const CeladonChiefHousePorygonPokeballText,        TEXT_CELADONCHIEFHOUSE_PORYGON_POKE_BALL

CeladonChiefHouseChiefText:
	text_far _CeladonChiefHouseChiefText
	text_end

CeladonChiefHouseRocketText:
	text_far _CeladonChiefHouseRocketText
	text_end

CeladonChiefHouseSailorText:
	text_far _CeladonChiefHouseSailorText
	text_end

; Starter selection
CeladonChiefHouseBellsproutPokeballText:
	text_asm
	ld a, STARTER1_CELADON
	ld b, CELADONCHIEFHOUSE_BELLSPROUT_POKE_BALL
	jr CeladonChiefHouseSelectedPokeBallScript

CeladonChiefHouseVulpixPokeballText:
	text_asm
	ld a, STARTER2_CELADON
	ld b, CELADONCHIEFHOUSE_VULPIX_POKE_BALL
	jr CeladonChiefHouseSelectedPokeBallScript

CeladonChiefHousePorygonPokeballText:
	text_asm
	ld a, STARTER3_CELADON
	ld b, CELADONCHIEFHOUSE_PORYGON_POKE_BALL
	jr CeladonChiefHouseSelectedPokeBallScript

CeladonChiefHouseSelectedPokeBallScript:
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
	cp CELADONCHIEFHOUSE_BELLSPROUT_POKE_BALL
	jr z, CeladonChiefHouseYouWantBellsproutText
	cp CELADONCHIEFHOUSE_VULPIX_POKE_BALL
	jr z, CeladonChiefHouseYouWantVulpixText
	jr CeladonChiefHouseYouWantPorygonText

CeladonChiefHouseYouWantBellsproutText:
	ld hl, .Text
	jr CeladonChiefHouseMonChoiceMenu
.Text:
	text_far _CeladonChiefHouseYouWantBellsproutText
	text_end

CeladonChiefHouseYouWantVulpixText:
	ld hl, .Text
	jr CeladonChiefHouseMonChoiceMenu
.Text:
	text_far _CeladonChiefHouseYouWantVulpixText
	text_end

CeladonChiefHouseYouWantPorygonText:
	ld hl, .Text
	jr CeladonChiefHouseMonChoiceMenu
.Text:
	text_far _CeladonChiefHouseYouWantPorygonText
	text_end

CeladonChiefHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, CeladonChiefHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CeladonChiefHouseMonEnergeticText
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

CeladonChiefHouseMonChoiceEnd:
	jp TextScriptEnd

CeladonChiefHouseMonEnergeticText:
	text_far _CeladonChiefHouseMonEnergeticText
	sound_get_key_item
	text_end
