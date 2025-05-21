LavenderCuboneHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

LavenderCuboneHouse_TextPointers:
	def_text_pointers
	dw_const LavenderCuboneHouseCuboneText,       TEXT_LAVENDERCUBONEHOUSE_CUBONE
	dw_const LavenderCuboneHouseBrunetteGirlText, TEXT_LAVENDERCUBONEHOUSE_BRUNETTE_GIRL
	dw_const LavenderCuboneHouseGastlyPokeballText,       TEXT_LAVENDERCUBONEHOUSE_GASTLY_POKE_BALL
	dw_const LavenderCuboneHouseCubonePokeballText,         TEXT_LAVENDERCUBONEHOUSE_CUBONE_POKE_BALL
	dw_const LavenderCuboneHouseClefairyPokeballText,        TEXT_LAVENDERCUBONEHOUSE_CLEFAIRY_POKE_BALL

LavenderCuboneHouseCuboneText:
	text_far _LavenderCuboneHouseCuboneText
	text_asm
	ld a, CUBONE
	call PlayCry
	jp TextScriptEnd

LavenderCuboneHouseBrunetteGirlText:
	text_asm
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, .rescued_mr_fuji
	ld hl, .PoorCubonesMotherText
	call PrintText
	jr .done
.rescued_mr_fuji
	ld hl, .TheGhostIsGoneText
	call PrintText
.done
	jp TextScriptEnd

.PoorCubonesMotherText:
	text_far _LavenderCuboneHouseBrunetteGirlPoorCubonesMotherText
	text_end

.TheGhostIsGoneText:
	text_far _LavenderCuboneHouseBrunetteGirlGhostIsGoneText
	text_end

; Starter selection
LavenderCuboneHouseGastlyPokeballText:
	text_asm
	ld a, STARTER1_LAVENDER
	ld b, LAVENDERCUBONEHOUSE_GASTLY_POKE_BALL
	jr LavenderCuboneHouseSelectedPokeBallScript

LavenderCuboneHouseCubonePokeballText:
	text_asm
	ld a, STARTER2_LAVENDER
	ld b, LAVENDERCUBONEHOUSE_CUBONE_POKE_BALL
	jr LavenderCuboneHouseSelectedPokeBallScript

LavenderCuboneHouseClefairyPokeballText:
	text_asm
	ld a, STARTER3_LAVENDER
	ld b, LAVENDERCUBONEHOUSE_CLEFAIRY_POKE_BALL
	jr LavenderCuboneHouseSelectedPokeBallScript

LavenderCuboneHouseSelectedPokeBallScript:
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
	cp LAVENDERCUBONEHOUSE_GASTLY_POKE_BALL
	jr z, LavenderCuboneHouseYouWantGastlyText
	cp LAVENDERCUBONEHOUSE_CUBONE_POKE_BALL
	jr z, LavenderCuboneHouseYouWantCuboneText
	jr LavenderCuboneHouseYouWantClefairyText

LavenderCuboneHouseYouWantGastlyText:
	ld hl, .Text
	jr LavenderCuboneHouseMonChoiceMenu
.Text:
	text_far _LavenderCuboneHouseYouWantGastlyText
	text_end

LavenderCuboneHouseYouWantCuboneText:
	ld hl, .Text
	jr LavenderCuboneHouseMonChoiceMenu
.Text:
	text_far _LavenderCuboneHouseYouWantCuboneText
	text_end

LavenderCuboneHouseYouWantClefairyText:
	ld hl, .Text
	jr LavenderCuboneHouseMonChoiceMenu
.Text:
	text_far _LavenderCuboneHouseYouWantClefairyText
	text_end

LavenderCuboneHouseMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, LavenderCuboneHouseMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, LavenderCuboneHouseMonEnergeticText
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

LavenderCuboneHouseMonChoiceEnd:
	jp TextScriptEnd

LavenderCuboneHouseMonEnergeticText:
	text_far _LavenderCuboneHouseMonEnergeticText
	sound_get_key_item
	text_end
