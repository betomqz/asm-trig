TITLE tabla-grados            (tabla-grados.asm)

; Módulo para imprimir una tabla con los resultados desde 0 a 360 grados.

INCLUDE Irvine32.inc

EXTERN EvalGrados:PROC
EXTERN ImprimeGrados:PROC

EXTERN strDivOut:BYTE
EXTERN strHeaderDeg:BYTE

.DATA

.CODE
; -------------------------------------------------------------------------------
; TablaGrados
;   Pide al usuario un valor en grados (float), calcula seno, coseno e
;   identidad pitagórica, e imprime los resultados en formato:
;       "Grados, radianes, sin(x), cos(x), f1"
;
; Entrada:  ninguna (lee del teclado)
; Salida:   imprime en pantalla
; No modifica el stack del FPU al regresar.
; -------------------------------------------------------------------------------
PUBLIC TablaGrados
TablaGrados PROC

    PUSH ECX

    ; --- Imprime encabezado ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf
    MOV EDX, OFFSET strHeaderDeg
    CALL WriteString
    CALL CrLf

    MOV ECX, 0
    .WHILE ECX < 361

        ; --- Evalúa funciones trigonométricas ---
        PUSH ECX
        CALL EvalGrados

        ; --- Manda a imprimir los valores almacenados en el FPU stack ---
        PUSH ECX
        CALL ImprimeGrados

        ; --- Incrementa en saltos de 10 ---
        ADD ECX, 10
    .ENDW

    ; --- Línea divisoria final ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf

    POP ECX
    RET
TablaGrados ENDP

END
