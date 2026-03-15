TITLE main            (main.asm)

; Módulo principal. Prueba para mandar llamar a cosine-n y sine-n

INCLUDE Irvine32.inc

EXTERN PideRadianes:PROC
EXTERN ConvierteRango:PROC

PUBLIC strComa
PUBLIC strDivOut

.DATA
adios           BYTE 0dh,0ah,"ADIOS.",0

strComa         BYTE ", ",0
strDivOut       BYTE "----------------------------------------"
                BYTE "----------------------------------------",0

.CODE

; -------------------------------------------------------------------------------
main PROC
    finit                       ; inicializa el FPU

    ; Pide radianes y calcula
    ; CALL PideRadianes

    ; convierte grados
    MOV ECX, 0
    .WHILE ECX < 361
        PUSH ECX
        CALL ConvierteRango
        POP EAX
        CALL WriteInt
        CALL CrLf
        ADD ECX, 10
    .ENDW


    ; Despedida
    mov  edx, OFFSET adios
    call WriteString
    call CrLf

    EXIT
main ENDP

END main
