; RES binaries can be "enclosed" in a bare FXF binary in order to handle relocations
; when a RES is enclosed in an FXF, it becomes a .rsf file instead of a standard .res file
; this .rsf.asm file should be assembled into a .res.fxf, then renamed to .rsf

const WIDGET_TYPE_LABEL: 0x00000002

    ; format: "RES"/"RSF" magic bytes, version, number of resource IDs
    ;         if "RES", no relocations; if "RSF", relocations applied
    data.str "RSF" data.8 0 data.8 3

    ; format: 3 character null-terminated ID, pointer to data, size
    data.strz "WIN" data.32 win data.32 40
    data.strz "MNU" data.32 mnu data.32 32 ; REMEMBER TO CHANGE THIS SIZE!!
    data.strz "WID" data.32 wid data.32 44 ; REMEMBER TO CHANGE THIS SIZE!!

; WIN resource layout (40 bytes):
;    data.fill 0, 32 - null-terminated window title
;    data.16 width   - width of this window
;    data.16 height  - height of this window, not including the title bar
;    data.16 x_pos   - X coordinate of this window (top left corner of title bar)
;    data.16 y_pos   - Y coordinate of this window (top left corner of title bar)
win:
    data.str "RES demo" data.fill 0, 24 ; 32 byte window title
    data.16 128 ; width
    data.16 128 ; height
    data.16 64  ; x_pos
    data.16 64  ; y_pos

mnu:
    data.8 1                                                    ; number of menus
    data.32 menu_items_hello_list data.32 menu_items_hello_name ; pointer to menu list, pointer to menu name
menu_items_hello_name:
    data.8 5 data.strz "Hello"; text length, text, null-terminator
menu_items_hello_list:
    data.8 1                           ; number of items
    data.8 14                          ; menu width (usually longest item + 2)
    data.8 12 data.strz "Hello World!" ; text length, text, null-terminator

wid:
    data.32 0                  ; next_ptr
    data.32 0                  ; id
    data.32 WIDGET_TYPE_LABEL  ; type
    data.32 wid_text           ; text_ptr
    data.32 0xFF000000         ; foreground_color
    data.32 0xFFFFFFFF         ; background_color
    data.16 0                  ; reserved
    data.16 0                  ; reserved
    data.16 16                 ; x_pos
    data.16 32                 ; y_pos
wid_text: data.strz "Hello World!"
