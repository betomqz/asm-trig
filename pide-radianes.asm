TITLE pide-radianes            (pide-radianes.asm)

; Módulo para pedir al usuario los radianes y luego evaluar las funciones
; trigonométricas.

INCLUDE Irvine32.inc

EXTERN EvalSinCos:PROC

EXTERN strComa:BYTE
EXTERN strDivOut:BYTE

.DATA
rad_x        REAL8 ?            ; valor de x leído
rad_sin      REAL8 ?            ; sin(x)
rad_cos      REAL8 ?            ; cos(x)
rad_f1       REAL8 ?            ; f1

strHeaderRad    BYTE "Radianes, sin(x), cos(x), f1",0

; TODO: remove this
num1     REAL8 1.5

.CODE
; -------------------------------------------------------------------------------
; PideRadianes
;   Pide al usuario un valor en radianes (float), calcula seno, coseno e
;   identidad pitagórica, e imprime los resultados en formato:
;       "Radianes, sin(x), cos(x), f1"
;
; Entrada:  ninguna (lee del teclado)
; Salida:   imprime en pantalla
; No modifica el stack del FPU al regresar.
; -------------------------------------------------------------------------------
PUBLIC PideRadianes
PideRadianes PROC

    ; --- ejemplo: eval (1.5)
    FLD num1
    CALL EvalSinCos

    ; --- Guarda resultados y limpia el FPU ---
    FSTP rad_f1                 ; guarda f1;   ST(0) = cos(x), ST(1) = sin(x)
    FSTP rad_cos                ; guarda cos;  ST(0) = sin(x)
    FSTP rad_sin                ; guarda sin;  FPU vacío

    ; --- Imprime encabezado ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf
    MOV EDX, OFFSET strHeaderRad
    CALL WriteString
    CALL CrLf

    ; --- Imprime: radianes, sin(x), cos(x), f1 ---
    ; Imprimir x (radianes)
    FLD num1                    ; ST(0) = x
    CALL WriteFloat
    FSTP rad_x                  ; limpia ST(0)
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir sin(x)
    FLD rad_sin                 ; ST(0) = sin(x)
    CALL WriteFloat
    FSTP rad_sin                ; limpia ST(0)
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir cos(x)
    FLD rad_cos                 ; ST(0) = cos(x)
    CALL WriteFloat
    FSTP rad_cos                ; limpia ST(0)
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir f1
    FLD rad_f1                  ; ST(0) = f1
    CALL WriteFloat
    FSTP rad_f1                 ; limpia ST(0)
    CALL CrLf

    ; --- Línea divisoria final ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf

    RET
PideRadianes ENDP

END
