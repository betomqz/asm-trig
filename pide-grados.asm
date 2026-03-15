TITLE pide-grados            (pide-grados.asm)

; Módulo para pedir al usuario los grados y luego evaluar las funciones
; trigonométricas.

INCLUDE Irvine32.inc

EXTERN EvalGrados:PROC

EXTERN strComa:BYTE
EXTERN strDivOut:BYTE

.DATA
deg_val      DWORD ?            ; valor de grados a usar

deg_rad      REAL8 ?            ; radianes (deg -> rad)
deg_sin      REAL8 ?            ; sin(x)
deg_cos      REAL8 ?            ; cos(x)
deg_f1       REAL8 ?            ; f1

strHeaderDeg BYTE "Grados, radianes, sin(x), cos(x), f1",0
strIngDeg    BYTE "Ingrese los grados: ",0

.CODE
; -------------------------------------------------------------------------------
; PideGrados
;   Pide al usuario un valor en grados (float), calcula seno, coseno e
;   identidad pitagórica, e imprime los resultados en formato:
;       "Radianes, sin(x), cos(x), f1"
;
; Entrada:  ninguna (lee del teclado)
; Salida:   imprime en pantalla
; No modifica el stack del FPU al regresar.
; -------------------------------------------------------------------------------
PUBLIC PideGrados
PideGrados PROC

    ; --- Pide los grados al usuario ---
    MOV EDX, OFFSET strIngDeg
    CALL WriteString
    CALL ReadInt                ; EAX = valor leído

    ; --- Guarda deg ---
    MOV deg_val, EAX

    ; --- Evalúa funciones trigonométricas ---
    PUSH deg_val
    CALL EvalGrados

    ; --- Guarda resultados y limpia el FPU ---
    FSTP deg_f1                 ; guarda f1;   ST(0) = cos(x), ST(1) = sin(x), ST(2) = rads
    FSTP deg_cos                ; guarda cos;  ST(0) = sin(x), ST(1) = rads
    FSTP deg_sin                ; guarda sin;  ST(0) = rads
    FSTP deg_rad                ; guarda radianes;  FPU vacío

    ; --- Imprime encabezado ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf
    MOV EDX, OFFSET strHeaderDeg
    CALL WriteString
    CALL CrLf

    ; --- Imprime: grados, radianes, sin(x), cos(x), f1 ---
    ; Imprimir grados
    MOV EAX, deg_val
    CALL WriteInt
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir radianes
    FLD deg_rad                 ; ST(0) = x
    CALL WriteFloat
    FSTP deg_rad                ; limpia ST(0)
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir sin(x)
    FLD deg_sin                 ; ST(0) = sin(x)
    CALL WriteFloat
    FSTP deg_sin                ; limpia ST(0)
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir cos(x)
    FLD deg_cos                 ; ST(0) = cos(x)
    CALL WriteFloat
    FSTP deg_cos                ; limpia ST(0)
    MOV EDX, OFFSET strComa
    CALL WriteString

    ; Imprimir f1
    FLD deg_f1                  ; ST(0) = f1
    CALL WriteFloat
    FSTP deg_f1                 ; limpia ST(0)
    CALL CrLf

    ; --- Línea divisoria final ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf

    RET
PideGrados ENDP

END
