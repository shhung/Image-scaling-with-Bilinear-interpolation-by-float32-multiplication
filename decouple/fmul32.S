.global fmul32

fmul32:
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
    
    li    t0 , 31
    srl    s2 , s0 , t0
    srl    s3 , s1 , t0
    li    t0 , 0x7fffff
    and    t0 , s0 , t0
    li    t1 , 0x800000
    or    s4 , t0 , t1      
        # s4 = ma
    li    t0 , 0x7fffff
    and    t0 , s1 , t0
    li    t1 , 0x800000
    or    s5 , t0 , t1      
        # s5 = mb
    li    t0 , 23
    srl    t0 , s0 ,t0
    li    t1 , 0xff
    and    s6 , t0 , t1
        # s6 = ea
    li    t0 , 23
    srl    t0 , s1 ,t0
    li    t1 , 0xff
    and    s7 , t0 , t1 
        # s7 = eb
    mv    a0 , s4
    mv    a1 , s5
    call    imul32
    mv    s8 , a0       
        # s8 = ma * mb
    li    t0 , 24
    sra    t0 , s8 , t0
    andi    s9 , t0 , 1 
        # s9 = mshift
    
    srl    s10 , s8 , s9
        # s10 = mr
    add    t0 , s6 , s7     
    li    t1 , 127
    sub    s8 , t0 , t1
    add    s11 , s8 , s9
    
    
    fmul32_exitifelse:
    xor    s9 , s2 , s3 
        # s9 = sign
    li    t0 , 31
    sll    t0 , s9 , t0
    li    t1 , 0xff
    and    t1 , s11 , t1
    li    t2 , 23
    sll    t1 , t1, t2
    li    t2 , 0x7fffff
    and    t2 , s10 , t2
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
