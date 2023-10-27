.global fadd32

fadd32:
    addi    sp , sp , -52
    sw    s0 , 0(sp)
    sw    s1 , 4(sp)
    sw    s2 , 8(sp)
    sw    s3 , 12(sp)
    sw    s4 , 16(sp)
    sw    s5 , 20(sp)
    sw    s6 , 24(sp)
    sw    s7 , 28(sp)
    sw    s8 , 32(sp)
    sw    s9 , 36(sp)
    sw    s10 , 40(sp)
    sw    s11 , 44(sp)
    sw    ra , 48(sp)
    mv    s0 , a0
    mv    s1 , a1
    
    li    t0 , 0x7fffffff
    and    t1 , s0 , t0
    and    t2 , s1 , t0
    blt    t2 , t1 , noswap
    mv    t0 , s0
    mv    s0 , s1
    mv    s1 , t0
    noswap:
    li    t0 , 31
    srl    s2 , s0 , t0
    srl    s3 , s1 , t0
    li    t0 , 0x7fffff
    li    t1 , 0x800000
    and    t2 , s0 , t0
    or    s4 , t2 , t1
    and    t2 , s1 , t0
    or    s5 , t2 , t1
    li    t0 , 23
    li    t1 , 0xff
    srl    t2 , s0 , t0
    and    s6 , t2 , t1
    srl    t2 , s1 , t0
    and    s7 , t2 , t1
    
    sub    t0 , s6 , s7
    li    t1 , 24
    blt    t1 , t0 , setalign_1
    mv    s8 , t0
    j    setalign_exit
    setalign_1:
    mv    s8 , t1
    setalign_exit:
    
    srl    s5 , s5 ,s8
    or    t0 , s2 , s3
    bne    t0 , x0 , setma_1
    add    s4 , s4 , s5
    j    setma_exit
    setma_1:
    sub    s4 , s4 , s5
    setma_exit:
        
    mv    a0 , s4
    call    count_leading_zeros
    mv    s9 , a0
    mv    s10 , x0
    li    t0 , 8
    blt    t0 , s9 , shift_false
    li    t0 , 8
    sub    s10 , t0 , s9
    srl    s4 , s4 , s10
    add    s6 , s6 , s10
    j    shift_exit
    shift_false:
    li    t0 , 8
    sub    s10 , s9 , t0
    sll    s4 , s4 , s10
    sub    s6 , s6 , s10
    shift_exit:
    li    t0 , 0x80000000
    and    t0 , s0 , t0
    li    t1 , 23
    sll    t1 , s6 , t1
    li    t2 , 0x7fffff
    and    t2 , s4 , t2
    or    t0 , t0 , t1
    or    a0 , t0 , t2
    
    lw    s0 , 0(sp)
    lw    s1 , 4(sp)
    lw    s2 , 8(sp)
    lw    s3 , 12(sp)
    lw    s4 , 16(sp)
    lw    s5 , 20(sp)
    lw    s6 , 24(sp)
    lw    s7 , 28(sp)
    lw    s8 , 32(sp)
    lw    s9 , 36(sp)
    lw    s10 , 40(sp)
    lw    s11 , 44(sp)
    lw    ra , 48(sp)
    addi    sp , sp , 52
    ret
