#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
// 宣告組合語言函數
extern int imul32(int a, int b);
extern int count_leading_zeros(int n);
extern float fadd32(float a, float b);
extern float fmul32(float a, float b);

typedef union {
    float f_num;
    int i_num;
} FloatIntUnion;

typedef uint64_t ticks;
static inline ticks getticks(void)
{
    uint64_t result;
    uint32_t l, h, h2;
    asm volatile(
        "rdcycleh %0\n"
        "rdcycle %1\n"
        "rdcycleh %2\n"
        "sub %0, %0, %2\n"
        "seqz %0, %0\n"
        "sub %0, zero, %0\n"
        "and %1, %1, %0\n"
        : "=r"(h), "=r"(l), "=r"(h2));
    result = (((uint64_t) h) << 32) | ((uint64_t) l);
    return result;
}

int main() {

    ticks t0, t1;

    ticks cycle_min, cycle_max, cycle_tmp;
    cycle_max = 0;
    cycle_min = INT64_MAX;

// test clz
    int n = 5;
    // printf("%d: %d\n", n, __builtin_clz(n));
    // printf("clz: %d\n", count_leading_zeros(n));
    t0 = getticks();
    int tmp = count_leading_zeros(n);
    t1 = getticks();
    printf("clz     \t");
    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);

// test imul32
    int a = 233;
    int b = 143;
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
    t0 = getticks();
    tmp = imul32(a, b);
    t1 = getticks();
    printf("imul32  \t");
    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);

    float ftmp;
// test fadd32
    float f1 = 3.556;
    float f2 = 16.600029;
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
    t0 = getticks();
    tmp = fadd32(f1, f2);
    t1 = getticks();
    printf("fadd32  \t");
    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);

// test fmul32
    f1 = 23324.54;
    f2 = 444444.333;
    // printf("built-in\t%f * %f = %f\n", f1, f2, f1 * f2);
    // printf("asm     \t%f * %f = %f\n", f1, f2, fmul32(f1, f2));
    // for (float i = 0; i < 100; i += 0.5) {
    //     for (float j = 100; j < 200; j += 1.4) {
    //         float ans = i + j;
    //         float test = fadd32(i, j);
    //         if (fabs(ans - test) > 0.1) {
    //             printf("wrong!! \t %f, %f\n", i, j);
    //         }
    //     }
    // }
    t0 = getticks();
    ftmp = fmul32(f1, f2);
    t1 = getticks();
    printf("fmul32  \t");
    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);    

    return 0;
}
