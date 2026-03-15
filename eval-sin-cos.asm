TITLE eval-sin-cos            (eval-sin-cos.asm)

; Evalúa las funciones trigonométricas
; Es un módulo.

INCLUDE Irvine32.inc

EXTERN SinFloat:PROC
EXTERN CosFloat:PROC
EXTERN SquareFloat:PROC

.DATA

.CODE
; -------------------------------------------------------------------------------
; EvalSinCos
;   Evalúa seno, coseno e identidad pitagórica.
;   Recibe x (radianes) en ST(0).
;   Regresa en el stack del FPU (de tope a fondo):
;       ST(0) = f1 = sin^2(x) + cos^2(x)
;       ST(1) = cos(x)
;       ST(2) = sin(x)
;
; Entrada FPU:   ST(0) = x
; Salida  FPU:   ST(0) = f1,  ST(1) = cos(x),  ST(2) = sin(x)
; -------------------------------------------------------------------------------
PUBLIC EvalSinCos
EvalSinCos PROC

    ; --- Calcula sin(x) ---
    ; ST(0) = x
    FLD ST(0)                   ; ST(0) = x,  ST(1) = x       (duplica x)
    PUSH 10                     ; n términos de la serie de Taylor
    CALL SinFloat               ; ST(0) = sin(x),  ST(1) = x

    ; --- Calcula cos(x) ---
    FXCH ST(1)                  ; ST(0) = x,  ST(1) = sin(x)
    PUSH 10                     ; n términos de la serie de Taylor
    CALL CosFloat               ; ST(0) = cos(x),  ST(1) = sin(x)

    ; --- Calcula f1 = sin^2(x) + cos^2(x) ---
    ; Primero: sin^2(x)
    FLD ST(1)                   ; ST(0) = sin(x),  ST(1) = cos(x),  ST(2) = sin(x)
    CALL SquareFloat            ; ST(0) = sin^2(x), ST(1) = cos(x),  ST(2) = sin(x)

    ; Segundo: cos^2(x)
    FLD ST(1)                   ; ST(0) = cos(x),  ST(1) = sin^2(x), ST(2) = cos(x), ST(3) = sin(x)
    CALL SquareFloat            ; ST(0) = cos^2(x), ST(1) = sin^2(x), ST(2) = cos(x), ST(3) = sin(x)

    ; Suma: f1 = sin^2(x) + cos^2(x)
    FADD                        ; ST(0) = f1,  ST(1) = cos(x),  ST(2) = sin(x)

    RET
EvalSinCos ENDP

END
