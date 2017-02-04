//
//  main.m
//  simdsample
//
//  Created by pebble8888 on 2017/02/02.
//  Copyright © 2017 pebble8888. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#include "StopWatch.h"

static inline float dot_sse_not_aligned(const float *a, const float *b, unsigned int len)
{
    __m128 sum = _mm_setzero_ps();
    int i;
    for (i = 0; i < len; i += 8) {
        sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(a+i), _mm_loadu_ps(b+i)));
        sum = _mm_add_ps(sum, _mm_mul_ps(_mm_loadu_ps(a+i+4), _mm_loadu_ps(b+i+4)));
    }
    __attribute__((aligned(16))) float t[4] = {0};
    _mm_store_ps(t, sum);
    return t[0] + t[1] + t[2] + t[3];
}

static inline float dot_avx_not_aligned(const float *a, const float *b, unsigned len)
{
    __m256 sum = _mm256_setzero_ps();
    int i;
    for(i = 0; i < len; i += 8) {
        sum = _mm256_add_ps(sum, _mm256_mul_ps(_mm256_loadu_ps(a+i), _mm256_loadu_ps(b+i)));
    }
    __attribute__((aligned(32))) float t[8] = {0};
    _mm256_store_ps(t, sum);
    return t[0] + t[1] + t[2] + t[3] + t[4] + t[5] + t[6] + t[7];
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        const uint32_t N = 4096;
        float* a = new float[N];
        float* b = new float[N];
        float d = 0;
        
        StopWatch sw;
        
        for (uint32_t j = 0; j < 3; ++j){
            sw.start();
            for (uint32_t k = 0; k < 4096; ++k){
#if 0
                vDSP_dotpr(a, 1, b, 1, &d, N); // not aligned 1300 us
#elif 0
                d = dot_avx_not_aligned(a, b, N); // not aligned 2600 us
#elif 1
                d = dot_sse_not_aligned(a, b, N); // not aligned 4700 us
#endif
            }
            sw.stop();
            
            printf("%s\n", sw.description().c_str());
        }
        
        printf("%f", d);
        
        delete [] a;
        delete [] b;
    }
    
    getchar();
    return 0;
}
