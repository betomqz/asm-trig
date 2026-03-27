TITLE main            (main.asm)

; Módulo principal. Prueba para mandar llamar a cosine-n y sine-n

INCLUDE Irvine32.inc

EXTERN PideRadianes@0:PROC
EXTERN PideGrados@0:PROC
EXTERN TablaGrados@0:PROC


.DATA
startTime       DWORD ?
tiemStr         BYTE "Milisegundos transcurridos: ",0
adios           BYTE 0dh,0ah,"Adiós.",0

PUBLIC strComa
strComa         BYTE ", ",0

PUBLIC strDivOut
strDivOut       BYTE 80 DUP("-"),0

.CODE

; -------------------------------------------------------------------------------
; main
;   Procedimiento principal. Imprime el menú y ejecuta la acción indicada.
;
; Recibe: nada
; Devuelve: nada. Escribe en la consola.
; -------------------------------------------------------------------------------
main PROC
    finit                       ; inicializa el FPU

    CALL GetMseconds
    MOV  startTime, EAX

    MOV  EAX, 0
    .WHILE EAX == 0

        ; --- Imprime el menú ---
        CALL ImprimeMenu

        ; ---- Lee entrada ---
        CALL ReadInt                ; EAX = valor leído

        ; --- Ejecuta acción seleccionada ---
        .IF EAX == 1
            CALL PideGrados@0
            MOV  EAX, 0
        .ELSEIF EAX == 2
            CALL PideRadianes@0
            MOV  EAX, 0
        .ELSEIF EAX == 3
            CALL TablaGrados@0
            MOV  EAX, 0
        .ELSE
            ; --- Rompe el loop ---
            MOV  EAX, 1
        .ENDIF
    .ENDW

    CALL GetMseconds
    SUB  EAX, startTime
    MOV  EDX, offset tiemStr
    CALL WriteString
    CALL WriteDec
    CALL CrLf

    ; Despedida
    MOV  EDX, OFFSET adios
    CALL WriteString
    CALL CrLf

    EXIT
main ENDP


; -------------------------------------------------------------------------------
; ImprimeMenu
;   Procedimiento para imprimir el menú de opciones.
;
; Recibe: nada
; Devuelve: nada. Escribe en la consola.
; -------------------------------------------------------------------------------
.DATA
strInstruct      BYTE "Ingrese el número correspondiente a la acción que desea ejecutar:",0
strOpGrados      BYTE "1: Lectura de x en grados",0
strOpRadianes    BYTE "2: Lectura de x en radianes",0
strOpTabla       BYTE "3: Generación de una tabla desde 0 a 360 grados",0
strOpExit        BYTE "4: Salir",0
strMenuHeader    BYTE 37 DUP("#"),0
strMenuWord      BYTE " MENÚ ",0
strPrompt        BYTE "input> ",0

.CODE
ImprimeMenu PROC
    ; --- Imprime el header ---
    CALL CrLf
    MOV  EDX, OFFSET strMenuHeader
    CALL WriteString
    MOV  EDX, OFFSET strMenuWord
    CALL WriteString
    MOV  EDX, OFFSET strMenuHeader
    CALL WriteString
    CALL CrLf

    ; --- Imprime las instrucciones ---
    MOV  EDX, OFFSET strInstruct
    CALL WriteString
    CALL CrLf

    ; --- Imprime las opciones ---
    MOV  EDX, OFFSET strOpGrados
    CALL WriteString
    CALL CrLf
    MOV  EDX, OFFSET strOpRadianes
    CALL WriteString
    CALL CrLf
    MOV  EDX, OFFSET strOpTabla
    CALL WriteString
    CALL CrLf
    MOV  EDX, OFFSET strOpExit
    CALL WriteString
    CALL CrLf

    ; --- Imprime prompt ---
    MOV  EDX, OFFSET strPrompt
    CALL WriteString

    RET

ImprimeMenu ENDP

END main
