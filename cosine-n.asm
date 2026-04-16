TITLE cosine-n            (cosine-n.asm)

; Calcula n términos de la expansión de Taylor para cos(x)
; Es un módulo.

INCLUDE Irvine32.inc

EXTERN SquareFloat@0:PROC

.DATA

.CODE
; -------------------------------------------------------------------------------
; CosFloat
; Calcula cos(x) usando la expansión en serie de Taylor hasta n términos.
;
; Recibe:  ST(0) = x (el ángulo en radianes)
;          [ESP+4] = n (número de términos, pasado por el stack)
; Devuelve: ST(0) = cos(x)
; No modifica registros de propósito general (salvo flags).
; -------------------------------------------------------------------------------
; Recurrencia:
;   term(0) = 1
;   term(k+1) = term(k) * (-x^2) / ((2k+1)(2k+2))
;   cos(x) = (term(0 ... n-1))
; -------------------------------------------------------------------------------
PUBLIC CosFloat
CosFloat PROC
    PUSH EAX
    PUSH ECX
    PUSH EDX

    MOV  ECX, [ESP + 16]       ; ECX = n

    ; Calcular -x^2
    ; ST(0) = x al entrar
    CALL SquareFloat@0          ; ST(0) = x^2
    FCHS                        ; ST(0) = -x^2

    ; Stack FPU: ST(0)=-x^2
    ; sum = 1, term = 1
    FLD1                        ; ST(0)=1, ST(1)=-x^2
    FLD  ST(0)                  ; ST(0)=term=1, ST(1)=sum=1, ST(2)=-x^2

    DEC  ECX
    MOV  EAX, 0                 ; k = 0

    .WHILE ECX > 0
        ; denominador: (2k+1)(2k+2)
        MOV  EDX, EAX
        SHL  EDX, 1             ; 2k
        ADD  EDX, 1             ; 2k+1
        PUSH EDX
        INC  EDX                ; 2k+2
        POP  EAX                ; EAX = 2k+1
        IMUL EAX, EDX           ; EAX = (2k+1)(2k+2)

        ; term *= (-x^2)
        FMUL ST(0), ST(2)

        ; term /= (2k+1)(2k+2)
        PUSH EAX
        FILD DWORD PTR [ESP]
        ADD  ESP, 4
        FDIVP ST(1), ST(0)      ; ST(0) = term / denom

        ; sum += term
        FADD ST(1), ST(0)

        ; recuperar k
        MOV  EAX, [ESP + 16]
        SUB  EAX, ECX           ; k = n - ECX (ya que ECX va decreciendo)

        DEC  ECX
    .ENDW

    ; ST(0)=term, ST(1)=sum, ST(2)=-x^2
    FSTP ST(0)                  ; descarta term -> ST(0)=sum, ST(1)=-x^2
    FSTP ST(1)                  ; descarta -x^2 -> ST(0)=cos(x)

    POP  EDX
    POP  ECX
    POP  EAX
    RET  4
CosFloat ENDP

END
