TITLE square-float            (square-float.asm)

; Calcula el cuadrado de un float.
; Es un módulo.

INCLUDE Irvine32.inc

.DATA

.CODE
; -------------------------------------------------------------------------------
; SquareFloat
; Calcula el cuadrado del valor en ST(0).
; Recibe:  ST(0) = número a elevar al cuadrado
; Devuelve: ST(0) = número al cuadrado
; No modifica registros de propósito general.
; -------------------------------------------------------------------------------
PUBLIC SquareFloat
SquareFloat PROC
    FLD  ST(0)                  ; duplica ST(0) -> ST(0)=num, ST(1)=num
    FMUL                        ; ST(0) = num * num
    RET
SquareFloat ENDP

END
