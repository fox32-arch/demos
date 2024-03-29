; audio playback demo

; use ffmpeg to convert an audio file for playback:
; ffmpeg -i input.mp3 -f s16le -ac 1 -ar 22050 audio.raw

    ; set pointer to audio data
    mov r0, audio_buffer

    ; set audio length
    mov r1, audio_buffer_end
    sub r1, audio_buffer

    ; set audio sample rate
    mov r2, 22050

    ; play on channel 0
    mov r3, 0

    ; play it! this routine is non-blocking
    call play_audio

yield_loop:
    call yield_task
    rjmp yield_loop

audio_buffer:
    #include_bin "audio.raw"

    ; add padding to ensure that the audio buffer size is at least 32KB (see fox32rom/audio.asm for details)
    data.fill 0, 32768
audio_buffer_end:

    #include "../../../fox32rom/fox32rom.def"
    #include "../../../fox32os/fox32os.def"
