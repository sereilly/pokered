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
    ret