TITLE main            (main.asm)

; Módulo principal. Prueba para mandar llamar a cosine-n y sine-n

INCLUDE Irvine32.inc

EXTERN PideRadianes:PROC
EXTERN PideGrados:PROC
EXTERN TablaGrados:PROC


.DATA
adios           BYTE 0dh,0ah,"ADIOS.",0

PUBLIC strComa
strComa         BYTE ", ",0

PUBLIC strDivOut
strDivOut       BYTE "----------------------------------------"
                BYTE "----------------------------------------",0

.CODE

; -------------------------------------------------------------------------------
main PROC
    finit                       ; inicializa el FPU

    ; Pide radianes y calcula
    CALL PideRadianes

    ; Pide grados y calcula
    CALL PideGrados

    ; Imprime tabla
    CALL TablaGrados

    ; Despedida
    mov  edx, OFFSET adios
    call WriteString
    call CrLf

    EXIT
main ENDP

END main
