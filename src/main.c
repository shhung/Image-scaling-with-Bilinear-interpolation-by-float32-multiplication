#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>

extern void ImgScale(float (*im_2)[2], float (*im_5)[5]);

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
    float im_2[2][2] = {{0.95478,0.64721},
                        {0.823257,0.22245}};

    float im_5[5][5] = {
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0},
        {0,0,0,0,0}
    };

    // begin of computation
    ticks t0 = getticks();

    ImgScale(im_2, im_5);

    // end of computation
    ticks t1 = getticks();

    for(int i = 0; i < 5; i++){
        for(int j = 0; j < 5; j++){
            printf("%f ", im_5[i][j]);
        }
        printf("\n");
    }

    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);
    
    return 0;
}