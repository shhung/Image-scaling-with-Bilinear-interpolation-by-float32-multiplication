/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/
#include <inttypes.h>
#include <stdio.h>
#include <stdint.h>

#define IN_N 2
#define OUT_N 5

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

uint32_t count_leading_zeros(uint32_t x) {
    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);

    /* count ones (population count) */
    x -= ((x >> 1) & 0x55555555);
    x = ((x >> 2) & 0x33333333) + (x & 0x33333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);

    return (32 - (x & 0x7f));
}

static inline int32_t getbit(int32_t value, int n)
{
    return (value >> n) & 1;
}
/* int32 multiply */
int32_t imul32(int32_t a, int32_t b)
{
    int32_t r = 0;
    while(1) {
        if((b & 1) != 0) {
            r = r + a;
        }
        b = b >> 1;
        if(b == 0x0) break;
        r = r >> 1;
    }
    return r;
}

/* float32 multiply */
float fmul32(float a, float b)
{
    /* TODO: Special values like NaN and INF */
    int32_t ia = *(int32_t *) &a, ib = *(int32_t *) &b;
    /* sign */
    int sa = ia >> 31;
    int sb = ib >> 31;

    /* mantissa */
    int32_t ma = (ia & 0x7FFFFF) | 0x800000;
    int32_t mb = (ib & 0x7FFFFF) | 0x800000;

    /* exponent */
    int32_t ea = ((ia >> 23) & 0xFF);
    int32_t eb = ((ib >> 23) & 0xFF);
    
    //printf("a : %x , %x , %x\n",sa,ea,ma);
    //printf("b : %x , %x , %x\n",sb,eb,mb);
    
    /* 'r' = result */
    int32_t mrtmp = imul32(ma, mb);
    //printf("%x\n",mrtmp);
    int mshift = getbit(mrtmp, 24);

    int32_t mr = mrtmp >> mshift;
    int32_t ertmp = ea + eb - 127;
    //printf("%x\n",ertmp);
    //int32_t er = mshift ? inc(ertmp) : ertmp;
    int32_t er;
    if(mshift) er = ertmp + 1;
    else er = ertmp;
    //printf("%x\n",er);
    
    int sr = sa ^ sb;
    int32_t r = (sr << 31) | ((er & 0xFF) << 23) | (mr & 0x7FFFFF);
    //printf("%x , %x ,%x\n",sr,er,mr);
    //printf("%x\n",r);
    return *(float *) &r;
}

float fadd32(float a, float b) {
    //printf("%f , %f ",a,b);
    int32_t ia = *(int32_t *)&a, ib = *(int32_t *)&b;
    int32_t temp;

    if ((ia & 0x7fffffff) < (ib & 0x7fffffff)){
        temp = ia;
        ia = ib;
        ib = temp;
    }
    //printf("%f , %f ",*(float *) &ia,*(float *) &ib);
    /* sign */
    int sa = ia >> 31;
    int sb = ib >> 31;
    
    /* mantissa */
    int32_t ma = ia & 0x7fffff | 0x800000;
    int32_t mb = ib & 0x7fffff | 0x800000;

    /* exponent */
    int32_t ea = (ia >> 23) & 0xff;
    int32_t eb = (ib >> 23) & 0xff;

    int32_t align = (ea - eb > 24) ? 24 : (ea - eb);
    //printf("align : %x\n",align);

    mb >>= align;
    if (sa | sb)  ma -= mb;
    else ma += mb;

    int32_t clz = count_leading_zeros(ma);
    int32_t shift = 0;
    if (clz <= 8) {
        shift = 8 - clz;
        ma >>= shift;
        ea += shift;
    } 
    else {
        shift = clz - 8;
        ma <<= shift;
        ea -= shift;
    }
    //printf("shift : %x\n",shift);
    //printf("clz : %x\n",clz);
    //printf("add : %x , %x , %x\n",ia,ea,ma);

    int32_t r = ia & 0x80000000 | ea << 23 | ma & 0x7fffff;
    //printf("%f\n",*(float *) &r);
    return *(float *) &r;
}

int main()
{
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

    im_5[0][0] = im_2[0][0];
    im_5[0][OUT_N-1] = im_2[0][IN_N-1];
    im_5[OUT_N-1][0] = im_2[IN_N-1][0];
    im_5[OUT_N-1][OUT_N-1] = im_2[IN_N-1][IN_N-1];
    
    for(int i=1;i<4;i++){
        im_5[0][i] = fadd32 (fmul32(im_5[0][0] , (float)(OUT_N - 1 - i) / (float)(OUT_N - 1)) , fmul32(im_5[0][OUT_N-1] , (float)(i) / (float)(OUT_N-1)));
        im_5[OUT_N-1][i] = fadd32 (fmul32(im_5[OUT_N-1][0] , (float)(OUT_N - 1 - i) /(float) (OUT_N-1)) , fmul32(im_5[OUT_N-1][OUT_N-1] , (float)(i) / (float)(OUT_N-1)));
    }
    
    for(int i=1;i<OUT_N-1;i++){
        for(int j=0;j<OUT_N;j++){
            im_5[i][j] = fadd32 (fmul32(im_5[0][j] , (float)(OUT_N - 1 - i) / (float)(OUT_N - 1)) , fmul32(im_5[OUT_N-1][j] , (float)(i) / (float)(OUT_N - 1)));
        }
    }
    
    // end of computation
    ticks t1 = getticks();
    
    for(int i=0;i<OUT_N;i++){
        for(int j=0;j<OUT_N;j++){
            printf("%f ",im_5[i][j]);
        }
        printf("\n");
    }

    printf("elapsed cycle: %" PRIu64 "\n", t1 - t0);

    return 0;
}