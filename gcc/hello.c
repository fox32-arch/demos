typedef unsigned int uint32_t;

#define WIDTH 640
#define HEIGHT 480

static volatile uint32_t *const fb = (uint32_t *)0x2000000;

static void draw_px(int x, int y, uint32_t color) {
	fb[x + WIDTH * y] = color;
}

static void draw_hline(int x0, int x1, int y, uint32_t color) {
	for (int x = x0; x <= x1; x++)
		draw_px(x, y, color);
}

static void draw_vline(int x, int y0, int y1, uint32_t color) {
	for (int y = y0; y <= y1; y++)
		draw_px(x, y, color);
}

#define COLOR_WHITE 0xffffffff

int main(void) {
	draw_px(20, 20, COLOR_WHITE); // dot

	draw_vline(100, 100, 300, COLOR_WHITE); // H
	draw_vline(200, 100, 300, COLOR_WHITE);
	draw_hline(100, 200, 200, COLOR_WHITE);

	draw_hline(250, 350, 100, COLOR_WHITE); // I
	draw_vline(300, 100, 300, COLOR_WHITE);
	draw_hline(250, 350, 300, COLOR_WHITE);

	return 0;
}
