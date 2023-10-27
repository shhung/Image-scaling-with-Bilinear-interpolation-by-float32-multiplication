.global count_leading_zeros

count_leading_zeros:
    addi    sp , sp , -8
    sw    s0 , 0(sp)
    sw    ra , 4(sp)
    mv    s0 , a0 # s0 = x

    srli    t0 , s0 , 1
    or    s0 , s0 ,t0
    srli    t0 , s0 , 2
    or    s0 , s0 ,t0
    srli    t0 , s0 , 4
    or    s0 , s0 ,t0
    srli    t0 , s0 , 8
    or    s0 , s0 ,t0
    srli    t0 , s0 , 16
    or    s0 , s0 ,t0
    srli    t0 , s0 , 1
    li    t1 , 0x55555555
    and    t0 , t0 , t1
    sub    s0 , s0 , t0
    li    t1 , 0x33333333
    and    t2 , s0 , t1
    srli    t0 , s0 , 2
    li    t1 , 0x33333333
    and    t0 , t0 , t1
    add    s0 , t0 , t2
    srli    t0 , s0 , 4
    add    t0 , t0 , s0
    li    t1 , 0x0f0f0f0f
    and    s0 , t0 , t1
    srli    t0 , s0 , 8
    add    s0 , s0 , t0
    srli    t0 , s0 , 16
    add    s0 , s0 , t0
    li    t0 , 32
    andi    t1 , s0 , 0x7f
    sub    a0 , t0 , t1
    
    lw    s0 , 0(sp)
    lw    ra , 4(sp)
    addi    sp , sp , 8
    ret
