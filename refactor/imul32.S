.global imul32

imul32:
    addi    sp , sp , -16
    sw    s0 , 0(sp)
    sw    s1 , 4(sp)
    sw    s2 , 8(sp)
    sw    ra , 12(sp)
    mv    s0 , a0
    mv    s1 , a1
    
    mv    s2 , x0
    while_imul32:
    andi    t0 , s1 , 1
    beq    t0 , x0 , exitif
    add    s2 , s2 , s0
    exitif:
    srli    s1 , s1 , 1
    beq    s1 , x0 , done_imul32
    slli    s0 , s0 , 1
    j while_imul32
    
    done_imul32:
    mv    a0 , s2
    lw    s0 , 0(sp)
    lw    s1 , 4(sp)
    lw    s2 , 8(sp)
    lw    ra , 12(sp)
    addi    sp , sp , 16
    ret
