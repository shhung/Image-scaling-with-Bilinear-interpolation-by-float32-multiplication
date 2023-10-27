#include <stdio.h>
#include <math.h>
#include <stdint.h>
// 宣告組合語言函數
extern int imul32(int a, int b);
extern int count_leading_zeros(int n);
extern float fadd32(float a, float b);
extern float fmul32(float a, float b);

int mul32(int a, int b)
{
    int r = 0;
    while(1) {
        if((b & 1) != 0) {
            r = r + a;
        }
        b = b >> 1;
        if(b == 0x0)
            break;
        a = a << 1;
    }
    return r;
}

typedef union {
    float f;
    unsigned int i;
} FloatIntUnion;

float fmul(float a, float b) {
    FloatIntUnion ua, ub, ur;
    ua.f = a;
    ub.f = b;

    // sign
    int sign = (ua.i >> 31) ^ (ub.i >> 31);

    // exponent
    int expa = ((ua.i >> 23) & 0xFF) - 127;
    int expb = ((ub.i >> 23) & 0xFF) - 127;
    int exp = expa + expb + 127;

    // mantissa
    unsigned int man_a = (ua.i & 0x7FFFFF) | 0x800000;
    unsigned int man_b = (ub.i & 0x7FFFFF) | 0x800000;
    unsigned long long mantissa = (unsigned long long)man_a * man_b;
    
    // adjust exponent and mantissa
    if (mantissa & 0x8000000000000000) {
        exp++;
        mantissa >>= 1;
    }

    // round to nearest, ties to even
    mantissa += (1ULL << 23) >> 1;

    // overflow
    if (exp >= 255) {
        return sign ? -INFINITY : INFINITY;
    }

    ur.i = (sign << 31) | ((exp & 0xFF) << 23) | ((mantissa >> 23) & 0x7FFFFF);
    
    return ur.f;
}

int main() {

// test clz
    // int n = 5;
    // printf("%d: %d\n", n, __builtin_clz(n));
    // printf("clz: %d\n", count_leading_zeros(n));

// test imul32
    // int a = 34;
    // int b = 10;
    // for (int i = 0; i < 2000; i++) {
    //     for (int j = 0; j < 2000; j++) {
    //         int ans = i * j;
    //         int test = imul32(i, j);
    //         if (ans != test) {
    //             printf("wrong!! \t %d, %d\n", i, j);
    //         }
    //     }
    // }
    // printf("built-in\t%d * %d = %d \n", a, b, a * b);
    // printf("C       \t%d * %d = %d \n", a, b, mul32(a, b));
    // printf("Asm     \t%d * %d = %d \n", a, b, imul32(a, b));

// test fadd32
    // float f1 = 98.000000;
    // float f2 = 126.600029;
    // printf("built-in\t%f + %f = %f\n", f1, f2, f1 + f2);
    // printf("asm     \t%f + %f = %f\n", f1, f2, fadd32(f1, f2));
    // for (float i = 0; i < 100; i += 0.5) {
    //     for (float j = 100; j < 200; j += 1.4) {
    //         float ans = i + j;
    //         float test = fadd32(i, j);
    //         if (fabs(ans - test) > 0.1) {
    //             printf("wrong!! \t %f, %f\n", i, j);
    //         }
    //     }
    // }

// test fmul32
    float f1 = 32.54;
    float f2 = 10;
    printf("built-in\t%f * %f = %f\n", f1, f2, f1 * f2);
    printf("C       \t%f * %f = %f\n", f1, f2, fmul(f1, f2));
    printf("asm     \t%f * %f = %f\n", f1, f2, fmul32(f1, f2));
    // for (float i = 0; i < 100; i += 0.5) {
    //     for (float j = 100; j < 200; j += 1.4) {
    //         float ans = i + j;
    //         float test = fadd32(i, j);
    //         if (fabs(ans - test) > 0.1) {
    //             printf("wrong!! \t %f, %f\n", i, j);
    //         }
    //     }
    // }

    return 0;
}
