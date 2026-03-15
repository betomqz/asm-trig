TITLE pide-grados            (pide-grados.asm)

; Módulo para pedir al usuario los grados y luego evaluar las funciones
; trigonométricas.

INCLUDE Irvine32.inc

EXTERN EvalGrados:PROC
EXTERN ImprimeGrados:PROC

EXTERN strDivOut:BYTE

.DATA
deg_val      DWORD ?            ; valor de grados a usar

strHeaderDeg BYTE "Grados, radianes, sin(x), cos(x), f1",0
strIngDeg    BYTE "Ingrese los grados: ",0

.CODE
; -------------------------------------------------------------------------------
; PideGrados
;   Pide al usuario un valor en grados (float), calcula seno, coseno e
;   identidad pitagórica, e imprime los resultados en formato:
;       "Grados, radianes, sin(x), cos(x), f1"
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

    ; --- Imprime encabezado ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf
    MOV EDX, OFFSET strHeaderDeg
    CALL WriteString
    CALL CrLf

    ; --- Evalúa funciones trigonométricas ---
    PUSH deg_val
    CALL EvalGrados

    ; --- Manda a imprimir los valores almacenados en el FPU stack ---
    PUSH deg_val
    CALL ImprimeGrados

    ; --- Línea divisoria final ---
    MOV EDX, OFFSET strDivOut
    CALL WriteString
    CALL CrLf

    RET
PideGrados ENDP

END
