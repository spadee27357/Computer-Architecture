#include <stdio.h>
#include <stdint.h>

uint16_t count_leading_zeros(uint64_t x) {
    if (x == 0) return 64;

    x |= (x >> 1);
    x |= (x >> 2);
    x |= (x >> 4);
    x |= (x >> 8);
    x |= (x >> 16);
    x |= (x >> 32);

    x -= ((x >> 1) & 0x5555555555555555);
    x = ((x >> 2) & 0x3333333333333333) + (x & 0x3333333333333333);
    x = ((x >> 4) + x) & 0x0f0f0f0f0f0f0f0f;
    x += (x >> 8);
    x += (x >> 16);
    x += (x >> 32);

    return 64 - x;
}

void determine_size(uint64_t num) {
    uint16_t zeros = count_leading_zeros(num);
    if (zeros == 64) {
        printf("The number is 0.\n");
        return;
    }

    uint16_t bit_position = 64 - zeros;
    printf("The number is roughly between 2^%d and 2^%d.\n", bit_position - 1, bit_position);
}

int main() {
    uint64_t num;
    printf("Enter a number: ");
    scanf("%llu", &num);

    determine_size(num);
    return 0;
}
