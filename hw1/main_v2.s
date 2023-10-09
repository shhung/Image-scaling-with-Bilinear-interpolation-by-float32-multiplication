.data
    .align 4
    endline:    .string "\n"
    IN_N:     .word    0x00000002
    OUT_N:    .word    0x00000005
    interpolation:    .word    0x3E800000 , 0x3F000000 , 0x3F400000
    im_2:     .word    0x3F746C76 , 0x3F25AF8E , 0x3F52C0F9 , 0x3E63C9EF
    im_5:    .word    0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0 , 0x0
.text
    
start:
    j    main
    
count_leading_zeros:    
    #li    a0 , 1
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
    
#getbit:  
    #li    a0 , 0x00000011
    #li    a1 , 1
    #addi    sp , sp , -12
    #sw    s0 , 0(sp)
    #sw    s1 , 4(sp)
    #sw    ra , 8(sp)
    #mv    s0 , a0
    #mv    s1 , a1
    
    #sra    t0 , s0 , s1
    #andi    a0 , t0 , 1
    
    #lw    s0 , 0(sp)
    #lw    s1 , 4(sp)
    #lw    ra , 8(sp)
    #addi    sp , sp , 12
    #ret
    
imul32:
    #li    a0 , 0x00000011
    #li    a1 , 0x00000011
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
    srli    s2 , s2 , 1
    j while_imul32
    
    done_imul32:
    mv    a0 , s2
    lw    s0 , 0(sp)
    lw    s1 , 4(sp)
    lw    s2 , 8(sp)
    lw    ra , 12(sp)
    addi    sp , sp , 16
    ret
    
fmul32:
    #li    a0 , 0x3F746c76
    #li    a1 , 0x3f400000
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
    li    t0 , 0x7fffff
    and    t0 , s1 , t0
    li    t1 , 0x800000
    or    s5 , t0 , t1
    li    t0 , 23
    srl    t0 , s0 ,t0
    li    t1 , 0xff
    and    s6 , t0 , t1
    li    t0 , 23
    srl    t0 , s1 ,t0
    li    t1 , 0xff
    and    s7 , t0 , t1
    
    mv    a0 , s4
    mv    a1 , s5
    call    imul32
    mv    s8 , a0
    #call    getbit
    li    t0 , 24
    sra    t0 , s8 , t0
    andi    s9 , t0 , 1
    
    
    srl    s10 , s8 , s9
    add    t0 , s6 , s7
    li    t1 , 127
    sub    s8 , t0 , t1
    beq    x0 , s9 , no_inc_ertmp
    addi    s11 , s8 , 1
    j fmul32_exitifelse
    no_inc_ertmp:
    mv    s11 , s8
    
    
    fmul32_exitifelse:
    xor    s9 , s2 , s3
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
    
fadd32:
    #li    a0 , 0x5d7ad83c
    #li    a1 , 0x5d76ab35
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
    
print_image:
    addi    sp , sp , -12
    sw    s0 , 0(sp)
    sw    s1 , 4(sp)
    sw    s2 , 8(sp)
    li    s0 , 0
    li    s1 , 0
    li    s2 , 5
    p_outer_loop:
    bge    s0, s2, p_done  # 
    li    s1, 0      # j = 0
    p_inner_loop:
    bge    s1, s2, p_inner_done
    
    lw    a0, 0(a1)
    li    a7,  2
    ecall    #print number
    li    a0,  32
    li    a7,  11
    ecall    #print space
    
    addi    a1, a1, 4
    addi    s1, s1, 1 # j = j + 1
    j    p_inner_loop
    p_inner_done:
    la      a0, endline    #printf("\n")
    li      a7, 4
    ecall
    addi s0, s0, 1  # i = i + 1
    j   p_outer_loop  
    p_done:
    lw    s0 , 0(sp)
    lw    s1 , 4(sp)
    lw    s2 , 8(sp)
    addi    sp , sp ,12
    ret

main:
    la    a0 , IN_N
    lw    s4 , 0(a0)
    lw    s5 , 4(a0)
    la    a0 , im_2
    lw    t0 , 0(a0)
    lw    t1 , 4(a0)
    lw    t2 , 8(a0)
    lw    t3 , 12(a0)
    
    la    s6 , im_5 # t4 = address of im_5[0,0]
    sw    t0 , 0(s6)
    sw    t1 , 16(s6)
    sw    t2 , 80(s6)
    sw    t3 , 96(s6)
    
    li    s0 , 1 # i = 1
    li    s1 , 4 # i < 4
    first_loop:
    lw    a0 , 0(s6)
    la    t5 , interpolation
    li    t1 , 3
    sub    t1 , t1 , s0
    slli    t1 , t1 , 2
    add    t1 , t5 , t1
    lw    a1 , 0(t1)
    call    fmul32
    mv    s11 , a0 # t2 = fmul(1)
    lw    a0 , 16(s6)
    la    t5 , interpolation
    addi    t1 , s0 , -1
    slli    t1 , t1 , 2
    add    t1 , t5 , t1
    lw    a1 , 0(t1)
    call    fmul32
    mv    a1 , s11 # a1 = fmul(1)
    call    fadd32
    slli    t1 , s0 , 2 # i*4
    add    t1 , t1 , s6 # im_5 + i*4
    sw    a0 , 0(t1)   
    
    #second stage
    lw    a0 , 80(s6)
    la    t5 , interpolation
    li    t1 , 3
    sub    t1 , t1 , s0
    slli    t1 , t1 , 2
    add    t1 , t5 , t1
    lw    a1 , 0(t1)
    call    fmul32
    mv    s11 , a0 # t2 = fmul(3)
    lw    a0 , 96(s6)
    la    t5 , interpolation
    addi    t1 , s0 , -1
    slli    t1 , t1 , 2
    add    t1 , t5 , t1
    lw    a1 , 0(t1)
    call    fmul32
    mv    a1 , s11 # t6 = fmul(4)
    call    fadd32
    slli    t1 , s0 , 2 # i*4
    add    t1 , t1 , s6 # im_5 + i*4
    sw    a0 , 80(t1)
    addi    s0 , s0 , 1
    blt    s0 , s1 , first_loop
    
    li    s0 , 1
    li    s2 , 4
    li    s3 , 5
    second_outloop:
    li    s1 , 0
    second_inloop:
    slli    t0 , s1 , 2
    add    t0 , t0 , s6
    lw    a0 , 0(t0) #load im_5[0][j]
    la    t5 , interpolation
    li    t1 , 3
    sub    t1 , t1 , s0
    slli    t1 , t1 , 2
    add    t1 , t5 , t1
    lw    a1 , 0(t1)
    call    fmul32
    mv    s11 , a0 # t2 = fmul(1)
    slli    t0 , s1 , 2
    add    t0 , t0 , s6
    lw    a0 , 80(t0) #load im_5[0][j]
    la    t5 , interpolation
    addi    t1 , s0 , -1
    slli    t1 , t1 , 2
    add    t1 , t5 , t1
    lw    a1 , 0(t1)
    call    fmul32
    mv    a1 , s11
     # a1 = fmul(1)
    call    fadd32
    slli    t1 , s0 , 2
    add    t1 , t1 , s0
    add    t1 , t1 , s1
    slli    t1 , t1 , 2
    add    t1 , t1 , s6
    sw    a0 , 0(t1)
    addi    s1 , s1 , 1
    blt    s1 , s3 , second_inloop
    addi    s0 , s0 , 1
    blt    s0 , s2 , second_outloop
    
    la    a1 , im_5
    call    print_image
    
    li       a7,  10           # return 0
    ecall