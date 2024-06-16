#include <stdbool.h>

#include "../../tools/gcc/bindings.c"

// define the button widget struct
struct button_widget_s {
    struct widget_s *next;
    unsigned int id;
    unsigned int type;
    char *text;
    unsigned int foreground_color;
    unsigned int background_color;
    unsigned short width;
    unsigned short reserved;
    unsigned short x;
    unsigned short y;
} __attribute__((packed));

// define a button with the text "click me!"
struct button_widget_s button = {
    .next = 0,
    .id = 0,
    .type = WIDGET_TYPE_BUTTON,
    .text = "click me!",
    .foreground_color = 0xFF000000,
    .background_color = 0xFFFFFFFF,
    .width = 88,
    .x = 16,
    .y = 112
};

unsigned char window_struct[40];
struct return8 window_event;
bool running = true;

void main(void) {
    new_window(window_struct, "test", 256, 128, 128, 128, 0, &button);
    draw_str_to_overlay("hello world :3", 8, 24, 0xFFFFFFFF, 0xFF000000, get_window_overlay_number(window_struct));
    draw_widgets_to_window(window_struct);

    while (running) {
        window_event = get_next_window_event(window_struct);

        switch (window_event.return0) {
            // window_event.return0 = event type
            case EVENT_TYPE_MOUSE_CLICK: {
                // window_event.return1 = X coordinate of click
                // window_event.return2 = Y coordinate of click
                // check if we're attempting to drag or close the window
                if (window_event.return2 < 16) {
                    if (window_event.return1 < 8) {
                        // clicked the close box
                        destroy_window(window_struct);
                        running = false;
                    } else {
                        // we're dragging the window
                        start_dragging_window(window_struct);
                    }
                }

                // handle widget clicks
                handle_widget_click(window_struct, window_event.return1, window_event.return2);

                break;
            }

            case EVENT_TYPE_BUTTON_CLICK: {
                // window_event.return1 = ID of clicked button
                if (window_event.return1 == 0) {
                    draw_str_to_overlay("button clicked!!!", 8, 40, 0xFFFFFFFF, 0xFF000000, get_window_overlay_number(window_struct));
                }

                break;
            }
        }

        save_state_and_yield_task();
    }

    // start.asm is supposed to call end_current_task after C returns. however,
    // returning from C back into start.asm is currently broken for some reason
    // se we call end_current_task from here instead
    end_current_task();
}
