TITLE convierte-rango            (convierte-rango.asm)

; Módulo para convertir grados del rango 0-360 al rango -90 a 90.
; Al convertir a radianes, este rango reducido mejora la precisión
; de las funciones seno y coseno calculadas por serie de Taylor.

INCLUDE Irvine32.inc

.DATA

.CODE
; -------------------------------------------------------------------------------
; ConvierteRango
; Simplifica un ángulo en grados del rango [0, 360] al rango [-90, 90].
; Este cambio permite que, al convertir a radianes, las series de Taylor
; para seno y coseno converjan con mayor precisión.
;
; Recibe: [ESP+4] = x (ángulo en grados, entero, 0 <= x <= 360)
; Devuelve: [ESP+4] = ángulo simplificado (se sobreescribe el parámetro)
; No modifica registros de propósito general.
; -------------------------------------------------------------------------------
PUBLIC ConvierteRango
ConvierteRango PROC
    PUSH EAX
    MOV  EAX, [ESP + 8]        ; EAX = x  (ret addr + EAX guardado)

    .IF EAX <= 180
        .IF EAX <= 90
            ; return x (ya está en su lugar)
            JMP  salir
        .ENDIF
        ; return 180 - x
        NEG  EAX
        ADD  EAX, 180
        MOV  [ESP + 8], EAX
        JMP  salir
    .ENDIF

    ; sabemos que x > 180
    SUB  EAX, 180               ; EAX = x - 180

    .IF EAX <= 90               ; 180 < x <= 270
        ; return 180 - x
        MOV  EAX, [ESP + 8]
        NEG  EAX
        ADD  EAX, 180
        MOV  [ESP + 8], EAX
        JMP  salir
    .ENDIF

    ; return x - 360
    MOV  EAX, [ESP + 8]
    SUB  EAX, 360
    MOV  [ESP + 8], EAX

salir:
    POP  EAX
    RET
ConvierteRango ENDP

END
