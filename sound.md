## Haciendo Ruido

En su especificación base, el kit MEK6800D2 no tiene ningún periférico o hardware dedicado a generar sonidos de ninguna clase. Se podría, en principio, conectar un amplificador simple y un zumbador a uno de los pines del puerto GPIO en la dirección 0x8020 y generar la frecuencia deseada alternando el valor de ese puerto acordemente. Sin embargo, una forma más interesante de generar sonido y que no requiere ninguna modificación de hardware es utilizar la interferencia generada por el propio kit.

Esta forma de generar sonido se basa en el mismo principio que la utilizada en equipos como la PDP-1 o la PDP-8, entre otros. La idea es que el bus del sistema, al conmutar de una forma específica, produce señales de radio, que pueden ser capturadas con una radio AM cercana. Para probar esto, basta con colocar una radio cerca del kit y operarlo normalmente. Con la radio sintonizada a 525kHz, cualquier interacción con el kit (carga de datos de memoria, breakpoints, ejecución normal de programa) genera un tono diferente en la radio. Entonces, cabe preguntarse cómo sería posible que esos tonos se correspondan con las notas de una canción.

Para seguir explorando este fenómeno se escribe un programa que realiza instrucciones "aleatorias" sobre todo el espacio de direcciones. Toma un dato de la memoria, opera sobre él, lo vuelca en el display y avanza a la siguiente dirección.
```
                              NAM    DIS1
                      ****************************************************
                      * MEK6800D2 RANDOM NOISE ON AM RADIO AND DISPLAY
                      * TUNE RADIO CLOSE TO 525 KHZ
                      *
                      * CONSTANTINO A.PALACIO, 2026-08-03
                      *
                      * SYNTAX IS SAME AS JBUG LISTING ON MEK6800D2 MANUAL
                      * PAGE A1-1
                      ****************************************************
1030                          ORG    $1030
                      *
                      **LET'S USE MEMORY CONTENTS AS A BASE FOR OUR NOISE
                      *
1030 CE 00 00                 LDX    #$0000
                      *
                      **PERFORM SOME OPERATIONS ON A
                      **EXPLORE DIFFERENT KINDS OF OPERATIONS
                      *
1033 07               HERE    TPA
1034 44                       LSRA
1035 A8 00                    EORA   0,X
1037 B7 80 22                 STAA   $8022   DISPLAY DIGIT SELECT
103A 43                       COMA
103B B7 80 20                 STAA   $8020   DISPLAY SEGMENT SELECT
103E 49                       ROLA
103F 16                       TAB
1040 07                       TPA
1041 10                       SBA
1042 53                       COMB
                      *
                      **GENERATE SOME DELAY, THIS AFFECTS THE
                      **FREQUENCY OF THE NOISE HEARD ON THE RADIO
                      *
1043 48               DELY    ASLA
1044 26 FD            DEY2    BNE    DELY
1046 54                       LSRB
1047 26 FB                    BNE    DEY2
                      *
                      **ADVANCE TO THE NEXT MEMORY LOCATION
                      *
1049 08                       INX
104A 20 E7                    BRA    HERE
                              END
```
