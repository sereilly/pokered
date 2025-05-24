CopycatsHouse1F_Script:
	jp EnableAutoTextBoxDrawing

CopycatsHouse1F_TextPointers:
	def_text_pointers
	dw_const CopycatsHouse1FMiddleAgedWomanText, TEXT_COPYCATSHOUSE1F_MIDDLE_AGED_WOMAN
	dw_const CopycatsHouse1FMiddleAgedManText,   TEXT_COPYCATSHOUSE1F_MIDDLE_AGED_MAN
	dw_const CopycatsHouse1FChanseyText,         TEXT_COPYCATSHOUSE1F_CHANSEY
	dw_const CopycatsHouse1FAbraPokeballText,  TEXT_COPYCATSHOUSE1F_ABRA_POKE_BALL
	dw_const CopycatsHouse1FEeveePokeballText, TEXT_COPYCATSHOUSE1F_EEVEE_POKE_BALL
	dw_const CopycatsHouse1FDittoPokeballText,   TEXT_COPYCATSHOUSE1F_DITTO_POKE_BALL

CopycatsHouse1FMiddleAgedWomanText:
	text_far _CopycatsHouse1FMiddleAgedWomanText
	text_end

CopycatsHouse1FMiddleAgedManText:
	text_far _CopycatsHouse1FMiddleAgedManText
	text_end

CopycatsHouse1FChanseyText:
	text_far _CopycatsHouse1FChanseyText
	text_asm
	ld a, CHANSEY
	call PlayCry
	jp TextScriptEnd

; Starter selection
CopycatsHouse1FAbraPokeballText:
	text_asm
	ld a, STARTER1_SAFFRON
	ld b, COPYCATSHOUSE1F_ABRA_POKE_BALL
	jr CopycatsHouse1FSelectedPokeBallScript

CopycatsHouse1FEeveePokeballText:
	text_asm
	ld a, STARTER2_SAFFRON
	ld b, COPYCATSHOUSE1F_EEVEE_POKE_BALL
	jr CopycatsHouse1FSelectedPokeBallScript

CopycatsHouse1FDittoPokeballText:
	text_asm
	ld a, STARTER3_SAFFRON
	ld b, COPYCATSHOUSE1F_DITTO_POKE_BALL
	jr CopycatsHouse1FSelectedPokeBallScript

CopycatsHouse1FSelectedPokeBallScript:
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
	cp COPYCATSHOUSE1F_ABRA_POKE_BALL
	jr z, CopycatsHouse1FYouWantAbraText
	cp COPYCATSHOUSE1F_EEVEE_POKE_BALL
	jr z, CopycatsHouse1FYouWantEeveeText
	jr CopycatsHouse1FYouWantDittoText

CopycatsHouse1FYouWantAbraText:
	ld hl, .Text
	jr CopycatsHouse1FMonChoiceMenu
.Text:
	text_far _CopycatsHouse1FYouWantAbraText
	text_end

CopycatsHouse1FYouWantEeveeText:
	ld hl, .Text
	jr CopycatsHouse1FMonChoiceMenu
.Text:
	text_far _CopycatsHouse1FYouWantEeveeText
	text_end

CopycatsHouse1FYouWantDittoText:
	ld hl, .Text
	jr CopycatsHouse1FMonChoiceMenu
.Text:
	text_far _CopycatsHouse1FYouWantDittoText
	text_end

CopycatsHouse1FMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, CopycatsHouse1FMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CopycatsHouse1FMonEnergeticText
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

	; teach abra tackle if it is the starter
	ld a, [wCurPartySpecies]
	cp ABRA
	jr nz, notabra
	ld a, PSYWAVE
	ld [wMoveNum], a
	ld [wNamedObjectIndex], a
	call GetMoveName
	call CopyToStringBuffer
	predef LearnMove
notabra:

	; fade to black and hide the other balls
	call GBFadeOutToBlack
	farcall StarterPicked
	call GBFadeInFromBlack

CopycatsHouse1FMonChoiceEnd:
	jp TextScriptEnd

CopycatsHouse1FMonEnergeticText:
	text_far _CopycatsHouse1FMonEnergeticText
	sound_get_key_item
	text_end
