#include "../../tools/gcc/bindings.c"

unsigned char window_struct[36];
struct return8 window_event;

int main(void) {
    draw_str_to_background("hello world!!!", 32, 32, 0xFFFFFFFF, 0xFF000000);
    new_window(window_struct, "test", 256, 128, 128, 128, 0, 0);
    draw_str_to_overlay("hello world :3", 8, 24, 0xFFFFFFFF, 0xFF000000, get_window_overlay_number(window_struct));

    while (1) {
        window_event = get_next_window_event(window_struct);

        switch (window_event.return0) {
            case EVENT_TYPE_MOUSE_CLICK:
                if (window_event.return2 < 16) {
                    if (window_event.return1 < 8) {
                        // clicked the close box
                        destroy_window(window_struct);
                        end_current_task();
                    } else {
                        // we're dragging the window
                        start_dragging_window(window_struct);
                    }
                }
        }

        save_state_and_yield_task();
    }
    return 0;
}
