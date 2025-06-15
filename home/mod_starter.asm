StarterPicked::
    ; skip Pallet Town events
    ld a, TRUE
	ld [wOakWalkedToPlayer], a
    ld a, $12 ;SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a

	; Set tutorial events
    SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
    SetEvent EVENT_GOT_POKEBALLS_FROM_OAK
    SetEvent EVENT_GOT_POKEDEX
    SetEvent EVENT_OAK_APPEARED_IN_PALLET
    SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
    SetEvent EVENT_DAISY_WALKING
	SetEvent EVENT_OAK_GOT_PARCEL
	SetEvent EVENT_GOT_TOWN_MAP
	
	ld a, HS_LYING_OLD_MAN
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_OLD_MAN
	ld [wMissableObjectIndex], a
	predef ShowObject
    ld a, HS_OAKS_LAB_OAK_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_TOWN_MAP
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_PALLET_TOWN_SEEL
	ld [wMissableObjectIndex], a

	lb bc, TOWN_MAP, 1
	call GiveItem
	lb bc, POKE_BALL, 3
	call GiveItem

    ; rival setup
    ld a, HS_OAKS_LAB_RIVAL
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvent EVENT_1ST_ROUTE22_RIVAL_BATTLE
	ResetEventReuseHL EVENT_2ND_ROUTE22_RIVAL_BATTLE
	SetEventReuseHL EVENT_ROUTE22_RIVAL_WANTS_BATTLE
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $5 ;SCRIPT_PALLETTOWN_DAISY
	ld [wPalletTownCurScript], a

    ; hide all starter balls using BallTable
    ld hl, .BallTable
    ld c, 27 ; 27 starter balls in the table (3 balls × 9 locations)
.hideAllBalls
    ld a, [hli]
    ld [wMissableObjectIndex], a
    push bc
    push hl
    predef HideObject
    pop hl
    pop bc
    dec c
    jr nz, .hideAllBalls

    call SetRivalStarter
    ret


.BallTable:
	db HS_STARTER_BALL_CINNABAR_1   
	db HS_STARTER_BALL_CINNABAR_2  
	db HS_STARTER_BALL_CINNABAR_3  
	db HS_STARTER_BALL_PEWTER_1    
	db HS_STARTER_BALL_PEWTER_2    
	db HS_STARTER_BALL_PEWTER_3    
	db HS_STARTER_BALL_VIRIDIAN_1  
	db HS_STARTER_BALL_VIRIDIAN_2  
	db HS_STARTER_BALL_VIRIDIAN_3  
	db HS_STARTER_BALL_CERULEAN_1  
	db HS_STARTER_BALL_CERULEAN_2  
	db HS_STARTER_BALL_CERULEAN_3  
	db HS_STARTER_BALL_VERMILION_1 
	db HS_STARTER_BALL_VERMILION_2 
	db HS_STARTER_BALL_VERMILION_3 
	db HS_STARTER_BALL_CELADON_1  
	db HS_STARTER_BALL_CELADON_2  
	db HS_STARTER_BALL_CELADON_3  
	db HS_STARTER_BALL_FUCHSIA_1  
	db HS_STARTER_BALL_FUCHSIA_2  
	db HS_STARTER_BALL_FUCHSIA_3  
	db HS_STARTER_BALL_LAVENDER_1
	db HS_STARTER_BALL_LAVENDER_2
	db HS_STARTER_BALL_LAVENDER_3
	db HS_STARTER_BALL_SAFFRON_1
	db HS_STARTER_BALL_SAFFRON_2
	db HS_STARTER_BALL_SAFFRON_3

GetRivalTrainerNoByStarterScript::
    ld a, [wTrainerNo]
    ld c, a
	ld a, [wRivalStarter]
	ld b, a
    ld hl, .StarterTable ; look up rival trainer number
.next_trainer_no
	ld a, [hli]
	cp b
	jr z, .got_trainer_no
    inc c
	jr .next_trainer_no
.got_trainer_no
    ld a, c
	ld [wTrainerNo], a
	ret

.StarterTable:
    db STARTER1_RIVAL
    db STARTER2_RIVAL
    db STARTER3_RIVAL
	db STARTER4_RIVAL
	db STARTER5_RIVAL
	db STARTER6_RIVAL
	db STARTER7_RIVAL
	db STARTER8_RIVAL


SetRivalStarter::
    ld a, [wPlayerStarter] ; load our chosen pokemon
    ld b, a
    ld hl, .RivalStarterTable ; look up rival starter
.next_starter
	ld a, [hli]
	cp b
	jr z, .got_starter
	inc hl
	jr .next_starter
.got_starter
	ld a, [hl]
	ld [wRivalStarter], a ; store rival starter
	ret

.RivalStarterTable:
; starter the rival picked, rival trainer number
	db STARTER1, STARTER2_RIVAL      ; Charmander -> Squirtle (water beats fire)
	db STARTER2, STARTER3_RIVAL      ; Squirtle -> Bulbasaur (grass beats water)
	db STARTER3, STARTER1_RIVAL      ; Bulbasaur -> Charmander (fire beats grass)
	
	db STARTER1_PEWTER, STARTER2_RIVAL    ; Geodude -> Squirtle (water beats rock)
	db STARTER2_PEWTER, STARTER3_RIVAL    ; Nidoran F -> Bulbasaur (poison is strong against grass)
	db STARTER3_PEWTER, STARTER1_RIVAL    ; Oddish -> Charmander (fire beats grass)
	
	db STARTER1_VIRIDIAN, STARTER6_RIVAL  ; Caterpie -> Geodude (bug is weak to rock)
	db STARTER2_VIRIDIAN, STARTER5_RIVAL  ; Nidoran M -> Abra (psychic is strong against poison)
	db STARTER3_VIRIDIAN, STARTER1_RIVAL  ; Mankey -> Charmander (fighting is weak to fire)
	
	db STARTER1_CERULEAN, STARTER4_RIVAL  ; Poliwag -> Pikachu (electric beats water)
	db STARTER2_CERULEAN, STARTER1_RIVAL  ; Scyther -> Charmander (bug is weak to fire)
	db STARTER3_CERULEAN, STARTER2_RIVAL  ; Meowth -> Squirtle (normal is neutral, but water is good matchup)
	
	db STARTER1_VERMILION, STARTER7_RIVAL ; Pikachu -> Machop (fighting is neutral to electric)
	db STARTER2_VERMILION, STARTER3_RIVAL ; Machop -> Bulbasaur (fighting is neutral to grass)
	db STARTER3_VERMILION, STARTER8_RIVAL ; Diglett -> Nidoran F (ground is strong against poison)
	
	db STARTER1_CELADON, STARTER1_RIVAL   ; Bellsprout -> Charmander (fire beats grass/poison)
	db STARTER2_CELADON, STARTER6_RIVAL   ; Vulpix -> Geodude (rock beats fire)
	db STARTER3_CELADON, STARTER7_RIVAL   ; Porygon -> Machop (fighting beats normal)
	
	db STARTER1_FUCHSIA, STARTER5_RIVAL   ; Koffing -> Abra (psychic beats poison)
	db STARTER2_FUCHSIA, STARTER4_RIVAL   ; Doduo -> Pikachu (electric beats flying)
	db STARTER3_FUCHSIA, STARTER3_RIVAL   ; Slowpoke -> Bulbasaur (grass beats water/psychic)
	
	db STARTER1_SAFFRON, STARTER8_RIVAL   ; Abra -> Nidoran F (poison resists psychic)
	db STARTER2_SAFFRON, STARTER5_RIVAL   ; Eevee -> Abra (psychic beats most)
	db STARTER3_SAFFRON, STARTER2_RIVAL   ; Ditto -> Squirtle (water is strong against transformed normal)
	
	db STARTER1_CINNABAR, STARTER8_RIVAL  ; Dratini -> NidoranF (dragon is neutral to poison)
	db STARTER2_CINNABAR, STARTER6_RIVAL  ; Ponyta -> Geodude (rock beats fire)
	db STARTER3_CINNABAR, STARTER4_RIVAL  ; Krabby -> Pikachu (electric beats water)

	db STARTER1_LAVENDER, STARTER2_RIVAL  ; Gastly -> Bulbasaur (grass is strong against ghost)
	db STARTER2_LAVENDER, STARTER7_RIVAL  ; Cubone -> Machop (fighting is strong against ground)
	db STARTER3_LAVENDER, STARTER6_RIVAL  ; Clefairy -> Geodude (normal is weak to rock)