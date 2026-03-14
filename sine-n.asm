TITLE sine-n            (sine-n.asm)

; Calcula n términos de la expansión de Taylor para sin(x)
; Es un módulo.

INCLUDE Irvine32.inc

EXTERN SquareFloat:PROC

.DATA

.CODE

; -------------------------------------------------------------------------------
; SinFloat
; Calcula sin(x) usando la expansión en serie de Taylor hasta n términos.
;
; Recibe:  ST(0) = x (el ángulo en radianes)
;          [ESP+4] = n (número de términos, pasado por el stack)
; Devuelve: ST(0) = sin(x)
; El FPU stack queda limpio (solo el resultado en ST(0)).
; No modifica registros de propósito general (salvo flags).
; -------------------------------------------------------------------------------
; Usa la recurrencia:
;   term(0) = x
;   term(k+1) = term(k) * (-x^2) / ((2k+2)(2k+3))
;   sin(x) = (term(0 ... n-1))
; -------------------------------------------------------------------------------
PUBLIC SinFloat
SinFloat PROC
    ; Guardar registros
    PUSH EAX
    PUSH ECX
    PUSH EDX

    ; --- Leer n del stack (ahora en [ESP + 12 + 4] por los 3 pushes) ---
    MOV  ECX, [ESP + 16]       ; ECX = n

    ; --- Calcular -x^2 y guardarlo como constante del loop ---
    ; ST(0) = x al entrar
    FLD  ST(0)                 ; ST(0)=x, ST(1)=x
    CALL SquareFloat           ; ST(0)=x^2, ST(1)=x
    FCHS                       ; ST(0)=-x^2, ST(1)=x

    ; Stack FPU: ST(0)=-x^2, ST(1)=x
    ; Preparar: sum = x, term = x
    FLD  ST(1)                 ; ST(0)=x, ST(1)=-x^2, ST(2)=x
    FLD  ST(0)                 ; ST(0)=term=x, ST(1)=sum=x, ST(2)=-x^2, ST(3)=x

    ; Ya contamos el primer término (x), quedan n-1 iteraciones
    DEC  ECX
    MOV  EAX, 0                ; k = 0 (índice de la iteración)

    .WHILE ECX > 0
        ; term = term * (-x^2) / ((2k+2)(2k+3))
        ; Calcular denominador: (2k+2)(2k+3)
        MOV  EDX, EAX
        SHL  EDX, 1            ; EDX = 2k
        ADD  EDX, 2            ; EDX = 2k+2

        PUSH EDX
        MOV  EDX, EAX
        SHL  EDX, 1
        ADD  EDX, 3            ; EDX = 2k+3
        POP  EAX               ; EAX = 2k+2 (reutilizamos)
        IMUL EAX, EDX          ; EAX = (2k+2)(2k+3)

        ; term *= (-x^2)
        ; ST(0)=term, ST(1)=sum, ST(2)=-x^2, ST(3)=x
        FMUL ST(0), ST(2)      ; term *= -x^2

        ; term /= (2k+2)(2k+3)

        ; alt 1
        PUSH EAX

        FILD DWORD PTR [ESP]   ; ST(0)=denom, ST(1)=term, ST(2)=sum, ST(3)=-x^2, ST(4)=x
        ADD  ESP, 4
        FDIVP ST(1), ST(0)     ; term = term / denom, pop denom
        ; Ahora ST(0)=new_term, ST(1)=sum, ST(2)=-x^2, ST(3)=x

        ; sum += term
        FADD ST(1), ST(0)      ; sum += term

        ; Restaurar k para siguiente iteración
        ; k estaba en EAX pero lo sobreescribimos; recalcular
        MOV  EAX, [ESP + 16]   ; n original
        SUB  EAX, ECX          ; EAX = iteración actual (1-based después del DEC)
        ; Eso nos da k+1 para la sig. iteración, que es justo lo que necesitamos
        ; ya que al volver al .WHILE, k debe ser el nuevo índice

        DEC  ECX
    .ENDW

    ; Stack FPU: ST(0)=term, ST(1)=sum, ST(2)=-x^2, ST(3)=x
    FSTP ST(0)                 ; descarta term -> ST(0)=sum, ST(1)=-x^2, ST(2)=x
    FSTP ST(1)                 ; sum va a ST(0), descarta -x^2 -> ST(0)=sum, ST(1)=x
    FSTP ST(1)                 ; descarta x original -> ST(0)=sin(x)

    POP  EDX
    POP  ECX
    POP  EAX
    RET  4                     ; limpia n del stack
SinFloat ENDP

END
