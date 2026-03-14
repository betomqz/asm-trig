TITLE main            (main.asm)

; Módulo principal. Prueba para mandar llamar a cosine-n y sine-n

INCLUDE Irvine32.inc

EXTERN CosFloat:PROC
EXTERN SinFloat:PROC

.DATA
strResCos       BYTE "cos(x) es: ",0
strResSin       BYTE "sin(x) es: ",0
adios           BYTE 0dh,0ah,"ADIOS.",0

num1     REAL8 1.5

.CODE

; -------------------------------------------------------------------------------
main PROC
    finit                       ; inicializa el FPU

    ; --- ejemplo: cos(1.5) \approx 0.070737 ---
    FLD  num1                   ; ST(0) = 1.5
    PUSH 10                     ; 10 términos de Taylor
    CALL CosFloat

    ; Imprime el resultado
    mov  edx, OFFSET strResCos
    call WriteString
    call WriteFloat
    call CrLf

    ; --- ejemplo: sin(1.5) \approx 0.997495 ---
    FLD  num1                   ; ST(0) = 1.5
    PUSH 10                     ; 10 términos de Taylor
    CALL SinFloat

    ; Imprime el resultado
    mov  edx, OFFSET strResSin
    call WriteString
    call WriteFloat
    call CrLf

    ; Despedida
    mov  edx, OFFSET adios
    call WriteString
    call CrLf

    EXIT
main ENDP

END main
