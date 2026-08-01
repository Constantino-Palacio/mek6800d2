# Expansión de memoria

## Teoría

El kit MEK6800D2 acepta hasta 512 bytes de RAM para el usuario disponibles en el rango $0000 .. $01FF, y provee además varias regiones de 8KB para ampliación, $2000 .. $3FFF y $4000 .. $5FFF. El total de memoria aceptable resulta entonces 16.5KB. Motorola permite seleccionar estos rangos opcionales usando las señales de control 2/3 y 4/5, por lo que la incorporación de un módulo de 8KB en cada una es prácticamente trivial, siguiendo las indicaciones en [AN-0771](https://bitsavers.computerhistory.org/components/motorola/_appNotes/AN-0771_MEK6800D2_Microcomputer_Kit_System_Expansion_Techniques.pdf).

Como lo que se desea es que la región de RAM accesible al usuario sea contigua, deberá relocalizarse el banco de 8KB al rango $0000 .. $1FFF y reubicar la RAM interna del kit a $2000 .. $21FF. Muchas de las señales descritas en la nota de Motorola son usadas cuando hay más de un periférico conectado al EXORbus. Al realizar la expansión directamente en la placa del sistema, se las ignora y se utilizan las líneas de direcciones, datos y selección del banco de memoria directamente del bus del sistema, no de los buffers y transceptores del EXORbus.

En el manual del kit se recomienda remover la línea de control de la RAM del integrado U7 (pin 4) y conectar dicho terminal a VCC, tal que se pueda implementar esta ampliación a través de una tarjeta de memoria externa. Como las ampliaciones de RAM van a ser internas al kit, no se realizará esta modificación al circuito.

## Relocalizando la RAM interna

Se intenta relocalizar la RAM original del kit al rango $2000 .. $21FF. Para ello, se instala un header de 3 terminales en la zona de prototipado que viene en la placa del kit. Este header se conecta de la siguiente manera:

- El pin superior (más cerca del borde de la placa) se conecta a la línea /RAM
- El pin central se conecta al la línea de selección de los integrados MC6810 del kit
- El pin inferior se conecta a la línea de control 2/3 a la salida del integrado 74155 (U11).

Al estar la línea de control RAM soldada directamente a los integrados de memoria, se realiza un pequeño corte en la pista para que dichos integrados sean seleccionados mediante esta entrada de configuración. Colocando un jumper entre la posición central y alguno de los extremos se puede selccionar el banco de memoria donde se va a ubicar estos 512 bytes.

Para probar el funcionamiento del circuito, se hace uso del programa de prueba de memoria, configurando el rango apropiadamente. Se verifica que la operación es correcta al visualizar que la dirección de fin y actual coinciden.

## Agregando 8KB de RAM

La adición de un banco de 8KB implica más modificaciones a la placa base. Se debe agregar un zócalo para incorporar la memoria, cablear todas las líneas de datos y direcciones necesarias, así como las líneas de selección. El integrado seleccionado es un 61C64, un módulo de RAM estática 8K x 8 bits. Las líneas de datos y direcciones se conectan a los correspondientes puntos del kit (no del EXORbus, las mismas que los otros componentes del kit, como la ROM, RAM, I/O, etc.).

La selección del circuito depende del módulo elegido. En este caso puntual, se utilizó el integrado IS61C64AH-12, con la siguiente distribución de pines:

<div align="center"><img src="https://github.com/user-attachments/assets/8153d12f-c7b3-41fe-b34c-5f9d122a425e" style="width:60%;height:60%;text-align:center;"></img></div>

Y funciona de acuerdo con la siguiente tabla de verdad:

<div align="center"><img src="https://github.com/user-attachments/assets/ecf85f64-e150-4679-a6db-1d8abeb31b8e" style="width:70%;height:70%;text-align:center;"></img></div>

Para seleccionar el integrado se realizaron las siguientes conexiones:
- /CE1 se conecta a la línea de selección /RAM (activa en bajo)
- CE2 se conecta a la línea DBE (activa en alto)
- /OE se conecta a /RAM (activa en bajo)
- /WE se conecta a R/W (activa en bajo)

Se conecta además un capacitor de 100nF para desacople. El esquema de circuito final es el siguiente:

<div align="center"><img src="https://github.com/user-attachments/assets/10a27cc2-55aa-49dc-9ef5-e7b78fbc75d2" style="width:45%;height:45%;text-align:center;"></img></div>

El kit se ve modificado de la siguiente manera:

<div align="center"><img src="https://github.com/user-attachments/assets/a484dae6-e171-4eb9-9fae-851ad3ba77f5" style="width:40%;height:40%;text-align:center;"></img></div>

## Aún más RAM

Se puede seguir agregando memoria siguiendo este mismo principio. El máximo alcanzable es 16.5KB: dos bancos de 8KB y los 512 bytes del kit original. El rango de la memoria sería entonces $0000 .. $41FF.

Otra alternativa para agregar aún más RAM podría ser removiendo los 512 bytes de RAM y los 128 bytes de STACK (en total, 5 circuitos MC6810) y reemplazarlos con un único integrado de 32KB y lógica adicional para permitir acceder a los rangos $0000, $2000, $4000 y $A000. En principio parece una complicación adicional para agregar memoria, pero se está simplificando considerablemente el circuito original de Motorola al usar memorias más modernas.

Podría verse como innecesario decodificar el rango $A000 .. $C000 en un integrado adicional, cuando podría agregarse aún más memoria en $6000. Sin embargo, siguiendo el mapa de memoria del kit, este banco se reserva para memorias tipo EPROM, y se desea mantener esta nomenclatura para ampliaciones futuras. Entonces. Quedarían las siguientes opciones:
- Ubicar la RAM en $8000 (reservado para E/S)
- Ubicar la RAM en $A000 (RAM interna al kit, donde va la pila, etc.)
- Ubicar la RAM en $C000 (reservado para EPROM, banco PROM0)

Al no poder ubicarse en $8000 por coincidir con los periféricos, y no poder estar en $E000 por colisionar con la ROM de JBUG, el único lugar disponible es el bloque $A000. Entonces, el circuito quedaría de la siguiente manera:

<div align="center"><img src="https://github.com/user-attachments/assets/9b862530-8fc0-4a92-a9e2-16710f5122a5" style="width:50%;height:50%;text-align:center;"></img></div>

Para seleccionar el chip se combinan las señales de decodificación RAM, 2/3, 4/5 y STACK, provenientes de U11 (74155). Un valor '0' en cualquiera de ellas activaría este integrado, entonces se utiliza una compuerta NAND de 4 entradas, un circuito integrado tipo 7420 (doble NAND de 4 entradas). Las compuertas OR permiten relocalizar el rango superior de memoria dentro del integrado ($6000 .. $8000) para que sea accesible desde $A000 .. $C000. La compuerta NAND restante proviene de U9 en la placa del kit (MC7400), y se utiliza como inversor, de forma similar a la ampliación de 8.5KB.
