; ----------------------------------------------------------------------------
; empty.asm
;
; Run from a Visual Studio Command Prompt to get the link.exe in the path
; nasm -f win32 empty.asm
; link.exe empty.obj libcmt.lib
; empty.exe
;
; ----------------------------------------------------------------------------

    global  _main

    section .text
_main:
    ret
