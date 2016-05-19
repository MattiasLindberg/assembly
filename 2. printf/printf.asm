; ----------------------------------------------------------------------------
; printf.asm - show how to print something
;
; Run from a Visual Studio Command Prompt to get the link.exe in the path
; nasm -f win32 printf.asm
; gcc printf.obj -o printf.exe
; printf.exe
;
; ----------------------------------------------------------------------------

    global  _main
    extern  _printf
    
    section .text
_main:
    push    message
    call    _printf
    add     esp, 4
    ret
    
message:
    db  'printf rules', 10, 0