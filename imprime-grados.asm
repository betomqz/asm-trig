TITLE imprime-grados            (imprime-grados.asm)

; Módulo para imprimir los valores correspondientes a las funciones
; trigonométricas usando grados.

INCLUDE Irvine32.inc

.DATA
deg_rad      REAL8 ?            ; radianes (deg -> rad)
deg_sin      REAL8 ?            ; sin(x)
deg_cos      REAL8 ?            ; cos(x)
deg_f1       REAL8 ?            ; f1

strComa2         BYTE ", ",0

.CODE
; -------------------------------------------------------------------------------
; ImprimeGrados
;   Imprime los resultados en formato:
;       "Grados, radianes, sin(x), cos(x), f1"
;
; Entrada:
;   - FPU stack:
;       ST(0): f1(x)
;       ST(1): cos(x)
;       ST(2): sin(x)
;       ST(3): rads
;   - Running stack: los grados que se usaron para calcular los valores
;
; Salida:   imprime en pantalla
;
; Limpia los valores del FPU stack
; -------------------------------------------------------------------------------
PUBLIC ImprimeGrados
ImprimeGrados PROC

    PUSH EAX                    ; guarda el valor de EAX

    ; --- Guarda resultados y limpia el FPU ---
    FSTP deg_f1                 ; guarda f1;   ST(0) = cos(x), ST(1) = sin(x), ST(2) = rads
    FSTP deg_cos                ; guarda cos;  ST(0) = sin(x), ST(1) = rads
    FSTP deg_sin                ; guarda sin;  ST(0) = rads
    FSTP deg_rad                ; guarda radianes;  FPU vacío

    ; Imprimir grados
    MOV  EAX, [ESP + 8]         ; EAX = deg  (ret addr + EAX guardado)
    CALL WriteInt
    MOV EDX, OFFSET strComa2
    CALL WriteString

    ; Imprimir radianes
    FLD deg_rad                 ; ST(0) = x
    CALL WriteFloat
    FSTP deg_rad                ; limpia ST(0)
    MOV EDX, OFFSET strComa2
    CALL WriteString

    ; Imprimir sin(x)
    FLD deg_sin                 ; ST(0) = sin(x)
    CALL WriteFloat
    FSTP deg_sin                ; limpia ST(0)
    MOV EDX, OFFSET strComa2
    CALL WriteString

    ; Imprimir cos(x)
    FLD deg_cos                 ; ST(0) = cos(x)
    CALL WriteFloat
    FSTP deg_cos                ; limpia ST(0)
    MOV EDX, OFFSET strComa2
    CALL WriteString

    ; Imprimir f1
    FLD deg_f1                  ; ST(0) = f1
    CALL WriteFloat
    FSTP deg_f1                 ; limpia ST(0)
    CALL CrLf

    ; Regresa el valor original de EAX
    POP EAX

    RET 4
ImprimeGrados ENDP

END
