TITLE eval-grados            (eval-grados.asm)

; Módulo para evaluar seno, coseno e identidad pitagórica a partir de
; un ángulo en grados (entero, rango [0, 360]).

INCLUDE Irvine32.inc

EXTERN ConvierteRango:PROC
EXTERN EvalSinCos:PROC

.DATA
val180  DWORD 180

.CODE
; -------------------------------------------------------------------------------
; EvalGrados
;   Evalúa seno, coseno e identidad pitagórica a partir de grados.
;   Primero simplifica los grados al rango [-90, 90] con ConvierteRango,
;   luego calcula los radianes verdaderos y simplificados, y usa los
;   simplificados para evaluar seno y coseno.
;
; Recibe:  [ESP+4] = deg (ángulo en grados, entero, 0 <= deg <= 360)
; Devuelve en el stack del FPU:
;       ST(0) = f1(x) = sin^2(x) + cos^2(x)
;       ST(1) = cos(x)
;       ST(2) = sin(x)
;       ST(3) = rad_true (radianes verdaderos, deg * pi / 180)
; No modifica registros de propósito general.
; Limpia el stack antes de regresar.
; -------------------------------------------------------------------------------
PUBLIC EvalGrados
EvalGrados PROC
    PUSH EAX

    ; --- Calcula rad_true = deg * pi / 180 ---
    MOV  EAX, [ESP + 8]         ; EAX = deg  (ret addr + EAX guardado)
    PUSH EAX
    FILD DWORD PTR [ESP]        ; ST(0) = deg (como float)
    POP  EAX
    FIDIV val180                ; ST(0) = deg / 180
    FLDPI                       ; ST(0) = pi,  ST(1) = deg/180
    FMULP ST(1), ST(0)          ; ST(0) = rad_true

    ; --- Simplifica grados ---
    PUSH EAX                    ; push deg como parámetro para ConvierteRango
    CALL ConvierteRango         ; [ESP] = deg_simp (sobreescrito)
    POP  EAX                    ; EAX = deg_simp

    ; --- Calcula rad_simp = deg_simp * pi / 180 ---
    ; ST(0) = rad_true
    PUSH EAX
    FILD DWORD PTR [ESP]        ; ST(0) = deg_simp,  ST(1) = rad_true
    POP  EAX
    FIDIV val180                ; ST(0) = deg_simp / 180
    FLDPI                       ; ST(0) = pi,  ST(1) = deg_simp/180,  ST(2) = rad_true
    FMULP ST(1), ST(0)          ; ST(0) = rad_simp,  ST(1) = rad_true

    ; --- Evalúa sin, cos, f1 usando rad_simp ---
    CALL EvalSinCos
    ; ST(0) = f1,  ST(1) = cos(x),  ST(2) = sin(x),  ST(3) = rad_true

    POP  EAX                    ; restaura EAX
    RET  4                      ; limpia el argumento que se había pasado al stack y regresa

EvalGrados ENDP

END
