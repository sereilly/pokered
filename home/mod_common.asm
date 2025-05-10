CountBadges::
    ld a, [wObtainedBadges] ; Load the badge bitmask
    ld   b, 0          ; Clear B (bit counter)
.count_loop:
    sla  a             ; Shift A left, MSB goes into carry
    jr   nc, .no_carry
    inc  b             ; If carry was set, increment B
.no_carry:
    cp 0 ; compare A with 0 to check if all bits are processed
    jr   nz, .count_loop
    ret

BadgeIncrement::
    ldh a, [hJoyPressed]
    bit BIT_SELECT, a
    jr z, .no_increment ; Check if SELECT is pressed
    call CountBadges
    ld a, b
    inc a                       ; Increment badge count
    cp 9                        ; Check if badges > 8
    jr c, .storeBadges          ; If badges <= 8, store the value
    xor a                       ; If badges > 8, reset to 0
.storeBadges:
    ; Store the new badge count in wObtainedBadges by converting it to a bitmask
    ; We'll create a mask where the first 'a' bits are set to 1
    ld b, a          ; Badge count in B
    ld a, 0          ; Start with zero
    ; Skip if no badges
    ld c, b
    ld b, 0
    inc c
    dec c
    jr z, .skip_bitmask
.bitmask_loop:
    ; Set the next bit
    scf              ; Set carry flag
    rla              ; Rotate left, bringing carry into bit 0
    dec c            ; One less bit to set
    jr nz, .bitmask_loop
.skip_bitmask:
    ld [wObtainedBadges], a     ; Store the new badge count
    ld a, SFX_PURCHASE          ; Choose a sound effect
    call PlaySound              ; Play the sound
.no_increment:
    ret