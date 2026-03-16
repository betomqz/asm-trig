TITLE convierte-rango            (convierte-rango.asm)

; Módulo para convertir grados del rango [0,360] al rango [-90,90] para seno o
; [0,180] para coseno. Al convertir a radianes, estos rangos reducidos mejoran
; un poco la precisión de las funciones calculadas por la serie de Taylor.

INCLUDE Irvine32.inc

.DATA

.CODE
; -------------------------------------------------------------------------------
; ConvierteRangoSin
; Simplifica un ángulo en grados del rango [0, 360] al rango [-90, 90]. Este
; cambio permite que, al convertir a radianes, la serie de Taylor para seno
; converja con mayor precisión.
;
; Recibe: [ESP+4] = x (ángulo en grados, entero, 0 <= x <= 360)
; Devuelve: [ESP+4] = ángulo simplificado (se sobreescribe el parámetro)
; No modifica registros de propósito general.
; -------------------------------------------------------------------------------
PUBLIC ConvierteRangoSin
ConvierteRangoSin PROC
    PUSH EAX
    MOV  EAX, [ESP + 8]        ; EAX = x  (ret addr + EAX guardado)

    .IF EAX <= 180
        .IF EAX <= 90
            ; return x (ya está en su lugar)
            JMP  salirSin
        .ENDIF
        ; return 180 - x
        NEG  EAX
        ADD  EAX, 180
        MOV  [ESP + 8], EAX
        JMP  salirSin
    .ENDIF

    ; sabemos que x > 180
    SUB  EAX, 180               ; EAX = x - 180

    .IF EAX <= 90               ; 180 < x <= 270
        ; return 180 - x
        MOV  EAX, [ESP + 8]
        NEG  EAX
        ADD  EAX, 180
        MOV  [ESP + 8], EAX
        JMP  salirSin
    .ENDIF

    ; return x - 360
    MOV  EAX, [ESP + 8]
    SUB  EAX, 360
    MOV  [ESP + 8], EAX

salirSin:
    POP  EAX
    RET
ConvierteRangoSin ENDP

; -------------------------------------------------------------------------------
; ConvierteRangoCos
; Simplifica un ángulo en grados del rango [0, 360] al rango [0, 180]. Este
; cambio permite que, al convertir a radianes, la serie de Taylor para coseno
; converja con mayor precisión.
;
; Recibe: [ESP+4] = x (ángulo en grados, entero, 0 <= x <= 360)
; Devuelve: [ESP+4] = ángulo simplificado (se sobreescribe el parámetro)
; No modifica registros de propósito general.
; -------------------------------------------------------------------------------
PUBLIC ConvierteRangoCos
ConvierteRangoCos PROC
    PUSH EAX
    MOV  EAX, [ESP + 8]        ; EAX = x  (ret addr + EAX guardado)

    .IF EAX <= 180
        ; return x (ya está en su lugar)
        JMP  salirCos
    .ENDIF

    ; return 360 - x
    NEG  EAX
    ADD  EAX, 360
    MOV  [ESP + 8], EAX

salirCos:
    POP  EAX
    RET
ConvierteRangoCos ENDP

END
