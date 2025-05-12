StarterPicked::
    ; skip Pallet Town events
    ld a, TRUE
	ld [wOakWalkedToPlayer], a
    ld a, $12 ;SCRIPT_OAKSLAB_NOOP
	ld [wOaksLabCurScript], a
    SetEvent EVENT_FOLLOWED_OAK_INTO_LAB
    SetEvent EVENT_GOT_POKEBALLS_FROM_OAK
    SetEvent EVENT_GOT_POKEDEX
    SetEvent EVENT_OAK_APPEARED_IN_PALLET
    SetEvent EVENT_PALLET_AFTER_GETTING_POKEBALLS_2
    SetEvent EVENT_DAISY_WALKING

    ld a, HS_OAKS_LAB_OAK_1
	ld [wMissableObjectIndex], a
	predef ShowObject

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

    ; hide the starter balls
    ld a, HS_STARTER_BALL_PEWTER_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_STARTER_BALL_PEWTER_2
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_STARTER_BALL_PEWTER_3
	ld [wMissableObjectIndex], a
	predef HideObject
    ld a, HS_STARTER_BALL_VIRIDIAN_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_STARTER_BALL_VIRIDIAN_2
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_STARTER_BALL_VIRIDIAN_3
	ld [wMissableObjectIndex], a
	predef HideObject

    call SetRivalStarter
    ret


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
    db STARTER2_RIVAL
    db STARTER3_RIVAL
    db STARTER1_RIVAL
    ; TODO: add the other starters


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
	db STARTER1, STARTER2_RIVAL
	db STARTER2, STARTER3_RIVAL
	db STARTER3, STARTER1_RIVAL
    db STARTER1_PEWTER, STARTER2_RIVAL
    db STARTER2_PEWTER, STARTER3_RIVAL
    db STARTER3_PEWTER, STARTER1_RIVAL
    db STARTER1_VIRIDIAN, STARTER2_RIVAL
    db STARTER2_VIRIDIAN, STARTER3_RIVAL
    db STARTER3_VIRIDIAN, STARTER1_RIVAL