#![no_std]
#![no_main]
#![allow(dead_code)]

use core::{panic::PanicInfo, slice};

const WIDTH: usize = 640;
const HEIGHT: usize = 480;

unsafe fn draw_px(x: usize, y: usize, color: u32) {
    let fb: &mut [u32] = slice::from_raw_parts_mut(0x2000000 as *mut u32, 640 * 480);
	fb[x + WIDTH * y] = color;
}

unsafe fn draw_hline(x0: usize, x1: usize, y: usize, color: u32) {
	for x in x0..x1 {
		draw_px(x, y, color);
    }
}

unsafe fn draw_vline(x: usize, y0: usize, y1: usize, color: u32) {
	for y in y0..y1 {
		draw_px(x, y, color);
    }
}

const COLOR_WHITE: u32 = 0xffffffff;

#[no_mangle]
pub extern "C" fn main() -> () {
    unsafe {
	    draw_px(20, 20, COLOR_WHITE); // dot

	    draw_vline(100, 100, 300, COLOR_WHITE); // H
    	draw_vline(200, 100, 300, COLOR_WHITE);
	    draw_hline(100, 200, 200, COLOR_WHITE);

    	draw_hline(250, 350, 100, COLOR_WHITE); // I
	    draw_vline(300, 100, 300, COLOR_WHITE);
    	draw_hline(250, 350, 300, COLOR_WHITE);
    }
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
