# Prueba de Memoria

El programa descrito por el siguiente diagrama de flujos realiza una simple prueba de la memoria RAM del kit. Se dejan los punteros de inicio y final almacenados en variables para que el operador pueda cambiarlos para realizar pruebas en diferentes rangos de direcciones. En este documento se asume el puntero inicial `$0000` y el final `$0200` para realizar una prueba en los 512 bytes de RAM incluidos en el kit estándar.

<div align="center"><img src="https://github.com/user-attachments/assets/ae4fcadf-f04c-467e-bf97-36b8f5e9491e" style="width:30%;height:30%;text-align:center;"></img></div>

El programa parte del puntero inicial. Copia este valor en el registro de índice `X` y lo utiliza para acceder a la memoria. Se almacena el valor `$00` en la posición indicada por `X`. Luego procede a leer este valor y compararlo con el valor del acumulador `A`. Si el valor coincide, se repite para el patrón `$FF`. Si se produce un error, se detiene el programa y se devuelve el control a JBUG.

El control es devuelto a JBUG una vez realizada la prueba de memoria. Se puede consultar la dirección en la que terminó la prueba ingresando `M A026 G`. El primer byte de la dirección aparecerá en el display. Ingresar `G` para ver el segundo byte. En un kit sin fallas, las direcciones `ACTUAL` y `FIN` deberían ser iguales. Si el puntero de fin fuera diferente, puede utilizarse el mapa de memoria para identificar el circuito integrado donde se presenta la falla.

El programa se ingresa de a un byte utilizando `M` a partir de la dirección de memoria `$A023` (datos) y `$A030` (programa). Por ejemplo, la primera instrucción, `LDX INICIO`, se ingresa con `A024 M FE G A0 G 24 G`. El comportamiento del kit será de la siguiente manera:
- Se ingresa la dirección `$A024`, seguido del comando `M`
- El display muestra la dirección `$A024`, junto a su valor (inicialmente desconocido)
- Se ingresa el byte `$FE` (instrucción `LDX`), seguido de `G`. Esto escribe el valor `$FE` en `$A024` y pasa a la siguiente posición en la memoria
- El display muestra la dirección `$A025`, junto a su valor
- Se ingresa `$A0` (el primer byte de la dirección `INICIO`), seguido de `G`
- El display muestra la dirección `$A026`, junto a su valor
- Se ingresa `$24` (el segundo byte de `INICIO`), seguido de `G`

El programa completo se incluye a continuación, tanto en lenguaje de máquina MC6800 como en ensamblador, siguiendo la sintaxis detallada en el manual de usuario del kit.

```
                ;-----------------------------------
                ; MEK6800D2 MEMORY TEST
                ;
                ; CONSTANTINO A.PALACIO, 2025-03-08
                ;-----------------------------------
A023            ORG            $A023
                ;
                ; RAM POINTERS
                ;
A023  00 00     INICIO  FDB    $0000
A025  00 00     ACTUAL  FDB    $0000
A027  02 00     FIN     FDB    $0200
                ;
                ; MAIN PROGRAM
                ;
A030                    ORG    $A030
A030  FE A0 23  INIPGM  LDX    INICIO
A033  FF A0 25          STX    ACTUAL
                ; LOAD 1ST PATTERN,
                ;   SAVE IT TO MEMORY
A036  86 00     LOOP1   LDA A  #$00
A038  A7 00             STA A  0,X
                ; SEE IF WRITTEN CORRECTLY
A03A  A1 00             CMP A  0,X
A03C  26 11             BNE    FINPGM
                ; REPEAT FOR 2ND PATTERN
A03E  86 FF             LDA A  #$FF
A040  A7 00             STA A  0,X
A042  A1 00             CMP A  0,X
A044  26 09             BNE    FINPGM
                ; CHECK NEXT ADDRESS,
                ;   SEE IF TEST IS DONE
A046  08                INX
A047  FF A0 25          STX    ACTUAL
A04A  BC A0 27          CPX    FIN
A04D  26 E7             BNE    LOOP1
                ;
                ; RETURN TO JBUG
                ;
A04F  3F        FINPGM  SWI
                        END
```

Se podrían colocar breakpoints para visualizar el funcionamiento del programa. Sin embargo, al utilizar la RAM de JBUG para almacenar el programa, la creación de breakpoints podría sobrescribir las variables del programa y el resultado del mismo sería incorrecto. Si se quisieran eliminar todos los breakpoints antes de ingresar el programa (y así asegurar que el kit no está utilizando esta zona de memoria), se puede ingresar `V` en el prompt `-`.

## Prueba Exhaustiva
Se diseña otro algoritmo para verificar la integridad de la memoria. Utiliza código "dinámico" (self-modifying code) para ahorrar memoria. La funcionalidad es similar: se escribe un patrón en memoria, se lo vuelve a leer y, si no coincide, se detiene el programa. El algoritmo es más lento, pero verifica cada bit de cada una de las direcciones del rango dado.

Para ver el estado, validar que el contenido de `$A043` (puntero de fin) coincida con `$A033` (puntero de arranque _dinámico_).

```
                ;-----------------------------------
                ; MEK6800D2 MEMORY TEST    REV 2
                ;
                ; CONSTANTINO A.PALACIO, 2025-06-11
                ;-----------------------------------
A030            ORG            $A030
A030  86 01     PRGINI  LDA A  #$01         ; INITIAL PATTERN = $01
A032  CE 00 00          LDX    #$0000       ; START ADDRESS = $0000
A035  A7 00     CHKLOP  STA A  0,X
A037  01 00             CMP A  0,X
A039  26 0C             BNE    PRGFIN       ; RETURN ON ERROR
A03B  49                ROLA
A03C  24 F7             BCC    CHKLOP
A03E  08                INX
A03F  FF A0 33          STX    $A033        ; PRGINI + 3 (SELF-MOD)
A042  8C 22 00          CPX    #$2200       ; END ADDRESS = $2200
A045  26 E9             BNE    PRGINI
A047  3F                SWI                 ; RETURN TO JBUG
                        END
```
