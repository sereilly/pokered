CountBadges::
    ld a, [wObtainedBadges] ; Load the badge bitmask
    ld   b, 0          ; Clear B (bit counter)
.count_loop:
    sla  a             ; Shift A left, MSB goes into carry
    jr   nc, .no_carry
    inc  b             ; If carry was set, increment B
.no_carry:
    bit  0, a          ; Check if A is zero (early out)
    jr   nz, .count_loop
    ret