; ----------------------------------------------------------------------------
; calc.asm - show how to perform +-*/ 
;
; Please note that in order for the macro to be able to expand at each call
; you need to define a label for each section. If you don't you get this error:
;    calc.asm:44: error: symbol `.str' redefined
;
; nasm -f win32 calc.asm
; gcc calc.obj -o calc.exe
; calc.exe
;
; ----------------------------------------------------------------------------

    extern  _printf
    
%macro	print 1			; a simple print macro
        section .data
.str	db	%1,0		
        section .text
        ; push onto stack backwards 
        push	dword [res]     ; push res to stack
        push	dword .str      ; the users string
        push    dword fmt       ; address of format string
        call    _printf         ; Call function
        add     esp,12          ; pop stack: 3 pushes á 4 bytes
%endmacro

%macro	printfloat 1			; a simple print macro
        section .data
.str	db	%1,0		
        section .text
        ; push onto stack backwards 
        push	dword [resf+4]  ; push res to stack
        push	dword [resf]    ; push res to stack
        push	dword .str      ; the users string
        push    dword fmtf       ; address of format string
        call    _printf         ; Call function
        add     esp,16          ; pop stack: 4 pushes á 4 bytes
%endmacro
    
        section .data
x:      dd      4
y:      dd      2
fmt:    db "%s%d",10,0	; format string for printf
fmtf:    db "%s%e",10,0	; format string for printf

a:      dq      3.333333333
b:      dq      4.444444444


        section .bss
res:    resd    1
resf:	resq	1
		
        section .text

    global  _main

_main:

; ----------------------------------------------------------------------------
; Integer aritmetics
; ----------------------------------------------------------------------------

print_x:
        mov     eax,[x]
        mov     [res],eax       ; print always use [res]
        print   "x= "

print_y:
        mov     eax,[y]
        mov     [res],eax       ; print always use [res]
        print   "y= "

print_aplusb:
        mov     eax,[x]         ; eax = [x]
        add     eax,[y]         ; eax += [y]
        mov     [res],eax       ; print always use [res]
        print   "x+y= "

print_aminusb:
        mov     eax,[x]         ; eax = [x]
        sub     eax,[y]         ; eax -= [y]
        mov     [res],eax       ; print always use [res]
        print   "x-y= "

print_amultb:
        mov     eax,[x]         ; eax = [x]
        imul    eax,[y]         ; eax *= [y]
        mov     [res],eax       ; print always use [res]
        print   "x*y= "

print_adivb:
        mov     eax,[x]         ; eax = [x]
        mov	edx,0		; load upper half of dividend with zero
        idiv    dword [y]       ; eax *= [y]
        mov     [res],eax       ; print always use [res]
        print   "x/y= "

; ----------------------------------------------------------------------------
; Floating point aritmetics
; ----------------------------------------------------------------------------

print_a:
	fld	qword [a]	; store into c (pop flt pt stack)
        fstp    qword [resf]
        printfloat   "a= "

print_b:
	fld	qword [b]	; store into c (pop flt pt stack)
        fstp    qword [resf]
        printfloat   "b= "

print_addfloat:
	fld	qword [a] 	; load a (pushed on flt pt stack, st0)
	fadd	qword [b]	; floating add b (to st0)
	fstp	qword [resf]	; store into c (pop flt pt stack)
	printfloat "a+b="		; invoke the print macro

print_subfloat:
	fld	qword [a] 	; load a (pushed on flt pt stack, st0)
	fsub	qword [b]	; floating add b (to st0)
	fstp	qword [resf]	; store into c (pop flt pt stack)
	printfloat "a-b="		; invoke the print macro

print_mulfloat:
	fld	qword [a] 	; load a (pushed on flt pt stack, st0)
	fmul	qword [b]	; floating add b (to st0)
	fstp	qword [resf]	; store into c (pop flt pt stack)
	printfloat "a*b="		; invoke the print macro

print_divfloat:
	fld	qword [a] 	; load a (pushed on flt pt stack, st0)
	fdiv	qword [b]	; floating add b (to st0)
	fstp	qword [resf]	; store into c (pop flt pt stack)
	printfloat "a/b="		; invoke the print macro
	
            
        mov     eax,0           ; exit code, 0=normal
        ret
