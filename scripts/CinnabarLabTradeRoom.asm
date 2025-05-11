CinnabarLabTradeRoom_Script:
	jp EnableAutoTextBoxDrawing

CinnabarLabTradeRoom_TextPointers:
	def_text_pointers
	dw_const CinnabarLabTradeRoomSuperNerdText, TEXT_CINNABARLABTRADEROOM_SUPER_NERD
	dw_const CinnabarLabTradeRoomGrampsText,    TEXT_CINNABARLABTRADEROOM_GRAMPS
	dw_const CinnabarLabTradeRoomBeautyText,    TEXT_CINNABARLABTRADEROOM_BEAUTY
	dw_const CinnabarLabCharmanderPokeBallText,     TEXT_CINNABARLABTRADEROOM_CHARMANDER_POKE_BALL
	dw_const CinnabarLabSquirtlePokeBallText,       TEXT_CINNABARLABTRADEROOM_SQUIRTLE_POKE_BALL
	dw_const CinnabarLabBulbasaurPokeBallText,      TEXT_CINNABARLABTRADEROOM_BULBASAUR_POKE_BALL

CinnabarLabTradeRoomSuperNerdText:
	text_far _CinnabarLabTradeRoomSuperNerdText
	text_end

CinnabarLabTradeRoomGrampsText:
	text_asm
	ld a, TRADE_FOR_DORIS
	ld [wWhichTrade], a
	jr CinnabarLabTradeRoomDoTrade

CinnabarLabTradeRoomBeautyText:
	text_asm
	ld a, TRADE_FOR_CRINKLES
	ld [wWhichTrade], a
CinnabarLabTradeRoomDoTrade:
	predef DoInGameTradeDialogue
	jp TextScriptEnd



CinnabarLabCharmanderPokeBallText:
	text_asm
	ld a, STARTER2_CINNABAR
	ld [wRivalStarterTemp], a
	ld a, CINNABARLABTRADEROOM_SQUIRTLE_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER1_CINNABAR
	ld b, CINNABARLABTRADEROOM_CHARMANDER_POKE_BALL
	jr CinnabarLabSelectedPokeBallScript

CinnabarLabSquirtlePokeBallText:
	text_asm
	ld a, STARTER3_CINNABAR
	ld [wRivalStarterTemp], a
	ld a, CINNABARLABTRADEROOM_BULBASAUR_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER2_CINNABAR
	ld b, CINNABARLABTRADEROOM_SQUIRTLE_POKE_BALL
	jr CinnabarLabSelectedPokeBallScript

CinnabarLabBulbasaurPokeBallText:
	text_asm
	ld a, STARTER1_CINNABAR
	ld [wRivalStarterTemp], a
	ld a, CINNABARLABTRADEROOM_CHARMANDER_POKE_BALL
	ld [wRivalStarterBallSpriteIndex], a
	ld a, STARTER3_CINNABAR
	ld b, CINNABARLABTRADEROOM_BULBASAUR_POKE_BALL

CinnabarLabSelectedPokeBallScript:
	ld [wCurPartySpecies], a
	ld [wPokedexNum], a
	ld a, b
	ld [wSpriteIndex], a
	CheckEvent EVENT_GOT_STARTER
	jp nz, CinnabarLabLastMonScript
	;CheckEventReuseA EVENT_OAK_ASKED_TO_CHOOSE_MON
	;jr nz, CinnabarLabShowPokeBallPokemonScript
	jr CinnabarLabShowPokeBallPokemonScript ; skipping event check
	ld hl, CinnabarLabThoseArePokeBallsText
	call PrintText
	jp TextScriptEnd

CinnabarLabThoseArePokeBallsText:
	text_far _OaksLabThoseArePokeBallsText
	text_end

CinnabarLabShowPokeBallPokemonScript:
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld a, OAKSLAB_RIVAL
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_RIGHT
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	predef StarterDex
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call ReloadMapData
	ld c, 10
	call DelayFrames
	ld a, [wSpriteIndex]
	cp CINNABARLABTRADEROOM_CHARMANDER_POKE_BALL
	jr z, CinnabarLabYouWantCharmanderText
	cp CINNABARLABTRADEROOM_SQUIRTLE_POKE_BALL
	jr z, CinnabarLabYouWantSquirtleText
	jr CinnabarLabYouWantBulbasaurText

CinnabarLabYouWantCharmanderText:
	ld hl, .Text
	jr CinnabarLabMonChoiceMenu
.Text:
	text_far _CinnabarLabTradeRoomYouWantSeelText
	text_end

CinnabarLabYouWantSquirtleText:
	ld hl, .Text
	jr CinnabarLabMonChoiceMenu
.Text:
	text_far _CinnabarLabTradeRoomYouWantCaterpieText
	text_end

CinnabarLabYouWantBulbasaurText:
	ld hl, .Text
	jr CinnabarLabMonChoiceMenu
.Text:
	text_far _CinnabarLabTradeRoomYouWantPorygonText
	text_end

CinnabarLabMonChoiceMenu:
	call PrintText
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	call YesNoChoice ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, CinnabarLabMonChoiceEnd
	ld a, [wCurPartySpecies]
	ld [wPlayerStarter], a
	ld [wNamedObjectIndex], a
	call GetMonName
	ld a, [wSpriteIndex]
	cp CINNABARLABTRADEROOM_CHARMANDER_POKE_BALL
	jr nz, .not_charmander
	ld a, HS_STARTER_BALL_CINNABAR_1
	jr .continue
.not_charmander
	cp CINNABARLABTRADEROOM_SQUIRTLE_POKE_BALL
	jr nz, .not_squirtle
	ld a, HS_STARTER_BALL_CINNABAR_2
	jr .continue
.not_squirtle
	ld a, HS_STARTER_BALL_CINNABAR_3
.continue
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CinnabarLabMonEnergeticText
	call PrintText
	ld hl, CinnabarLabReceivedMonText
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
	ld a, HS_STARTER_BALL_CINNABAR_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_STARTER_BALL_CINNABAR_2
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_STARTER_BALL_CINNABAR_3
	ld [wMissableObjectIndex], a
	predef HideObject
	call GBFadeInFromBlack

CinnabarLabMonChoiceEnd:
	jp TextScriptEnd

CinnabarLabMonEnergeticText:
	text_far _CinnabarLabTradeRoomMonEnergeticText
	text_end

CinnabarLabReceivedMonText:
	text_far _OaksLabReceivedMonText
	sound_get_key_item
	text_end

CinnabarLabLastMonScript:
	ld a, OAKSLAB_OAK1
	ldh [hSpriteIndex], a
	ld a, SPRITESTATEDATA1_FACINGDIRECTION
	ldh [hSpriteDataOffset], a
	call GetPointerWithinSpriteStateData1
	ld [hl], SPRITE_FACING_DOWN
	ld hl, OaksLabLastMonText
	call PrintText
	jp TextScriptEnd

CinnabarLabLastMonText:
	text_far _OaksLabLastMonText
	text_end
