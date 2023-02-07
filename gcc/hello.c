#include "../../tools/gcc/bindings.c"

int main(void) {
    draw_str_to_background("hello world!!!", 16, 16, 0xFFFFFFFF, 0xFF000000);
    draw_decimal_to_background(random_range(1, 7), 16, 32, 0xFFFFFFFF, 0xFF000000);
    return 0;
}
