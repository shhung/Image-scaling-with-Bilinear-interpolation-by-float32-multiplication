# 文件名: add_numbers.s

.data
    .align 4
    NUM1:   .word   0x1
    NUM2:   .word   0x3


# 函數定義，函數名稱以.global開頭，後接C函數名
.global add_numbers

# 函數開始
add_numbers:

    lw a1, 0(a0)
    addi a1, a1, 3
    sw a1, 0(a0)

    lw a1, 4(a0)
    addi a1, a1, 3
    sw a1, 4(a0)

    lw a1, 8(a0)
    addi a1, a1, 3
    sw a1, 8(a0)

    # 函數代碼結束

    # 返回結果，a0寄存器中存有返回值
    ret
