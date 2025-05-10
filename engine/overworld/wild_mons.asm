LoadWildData::
    call CountBadges       ; Count the number of badges obtained
    ld e, b                 ; Store the badge count in register E
    ld hl, WildDataPointersTable ; Load the base pointer table
    ld d, 0
    add hl, de              ; Offset HL by the badge count
    ld a, [hl]      ; Load the low byte of the pointer
    inc hl          ; Increment HL to point to the next byte
    ld h, [hl]      ; Load the high byte of the pointer
    ld l, a         ; Set HL to the full pointer

    ld a, [wCurMap]

    ; get wild data for current map
    ld c, a
    ld b, 0
    add hl, bc
    add hl, bc
    ld a, [hli]
    ld h, [hl]
    ld l, a       ; hl now points to wild data for current map
    ld a, [hli]
    ld [wGrassRate], a
    and a
    jr z, .NoGrassData ; if no grass data, skip to surfing data
    push hl
    ld de, wGrassMons ; otherwise, load grass data
    ld bc, $14
    call CopyData
    pop hl
    ld bc, $14
    add hl, bc
.NoGrassData
    ld a, [hli]
    ld [wWaterRate], a
    and a
    ret z        ; if no water data, we're done
    ld de, wWaterMons  ; otherwise, load surfing data
    ld bc, $14
    jp CopyData

; Table of pointers to WildDataPointers tables
WildDataPointersTable:
    dw WildDataPointers0
    dw WildDataPointers
    dw WildDataPointers
    dw WildDataPointers
    dw WildDataPointers
    dw WildDataPointers
    dw WildDataPointers
    dw WildDataPointers
    dw WildDataPointers

INCLUDE "data/wild/grass_water.asm"