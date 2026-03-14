TITLE main            (main.asm)

; Módulo principal. Prueba para mandar llamar a cosine-n

INCLUDE Irvine32.inc

EXTERN CosFloat:PROC

.DATA
strRes          BYTE "cos(x) es: ",0
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
    mov  edx, OFFSET strRes
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
