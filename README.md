# Motorola MEK6800D2
El kit Motorola MEK6800D2 es una SBC (_Single Board Computer_) basada en el procesador MC6800, fabricado por Motorola alrededor de 1977. Se compone de una placa de circuito principal con los componentes del sistema y una placa secundaria con un teclado matricial, display hexadecimal y lógica de control de una unidad de cassette para almacenar datos/programas. Es una versión mejorada del [MEK6800D1](https://www.sardis-technologies.com/pre-st29/mekd1.htm), que sólo podía ser conectada a un bus EXORciser y controlada mediante una terminal serie.

El kit utilizado no incluye la placa del teclado, por lo que se [construyó](./display.md) un módulo equivalente al diseño original de Motorola, pero simplificado por razones de tamaño del circuito y costo de los componentes. Tener en cuenta que el módulo del teclado es esencial para el funcionamiento del kit, puesto que no puede realizarse ninguna operación sin dicho componente (a menos que se hagan numerosas modificaciones al circuito).

## Descripción General

El módulo principal incluye:
- MPU Motorola MC6800
- 1KB de ROM con programa monitor JBUG
- 256 bytes de RAM
- 2 módulos de E/S MC6820
- 1 módulo de comunicación serie MC6850
- Lógica para interfaz EXORciser

La siguiente imagen muestra los componentes del módulo MPU:
<div align="center"><img src="https://github.com/user-attachments/assets/bfc915bf-df68-46a2-821e-04cb14aab5c1" style="width:75%;height:75%;text-align:center;"></img></div>

El módulo de teclado original contiene:
- 16 teclas para entrada de direcciones/datos en formato hexadecimal
- 8 teclas de función: P, L, N, V, M, E, R, G
- 6 unidades de display de 7 segmentos
- Lógica y conexiones para almacenamiento de datos en cassette (omitido en la simplificación).

### Organización

El módulo MPU provee solamente las conexiones para direccionar 512 bytes de RAM (4 zócalos para memorias tipo MCM6810, 128x8 bits, en rango 0x0000-0x01FF) y 3KB de ROM (1 zócalo para ROM del sistema tipo MCM6830 a partir de la dirección 0xE000, 1Kx8 bits; dos zócalos para EPROM compatible con 2708 en 0x6000 y 0xC000, 1Kx8 bits). Para conectar más memoria debe recurrirse a un módulo de expansión conectado a la interfaz EXORciser, o realizar las modificaciones aquí propuestas.

El mapa de memoria del kit es el siguiente:

<div align="center"><img src="https://github.com/user-attachments/assets/0cb3d913-e9c2-4f32-bb50-88eda9686fca" style="width:25%;height:25%;text-align:center;"></img></div>

Ver que el bloque de memoria con base en 0x8000 se reserva para E/S mapeada en memoria. El bloque en 0xA000 es para 128 bytes adicionales de RAM, que el monitor JBUG usa para no ocupar la memoria reservada para el usuario.

## Documentación

Originalmente, Motorola enviaba el kit a los interesados junto a la documentación necesaria para su construcción y manuales de programación del MC6800. El paquete incluía las piezas necesarias para un sistema básico (descrito en la sección anterior) y los siguientes manuales:
- [MEK6800D2 Manual](http://bitsavers.informatik.uni-stuttgart.de/components/motorola/6800/MEK6800D2_Manual_2ed_1977.pdf): instrucciones de armado y operación básica del kit, incluyendo el listado en ensamblador del programa JBUG
- [M6800 Applications Manual](http://bitsavers.informatik.uni-stuttgart.de/components/motorola/6800/M6800_Microprocessor_Applications_Manual_1975.pdf): información detallada de todos los circuitos lógicos de la familia M6800, descripción de aplicaciones posibles e implementación con programas en ensamblador MC6800 y diagramas de circuito.
- [M6800 Programming Manual](http://bitsavers.informatik.uni-stuttgart.de/components/motorola/6800/Motorola_M6800_Programming_Reference_Manual_M68PRM(D)_Nov76.pdf): información acerca de la programación del procesador MC6800.

Adicionalmente se cuenta con los siguientes libros para referencia del procesador MC6800:
- American Microsystems. _AMI6800 Assembly Language Programming Manual_.
- Bishop, R. _Bases de los Microprocesadores y el 6800_. 1ed. Arbó. 1992.
- Leventhal, L.A. _Microcomputer Experimentation with the Motorola MEK6800D2_. Prentice Hall. 1981. En [bitsavers](http://bitsavers.informatik.uni-stuttgart.de/components/motorola/6800/Leventhal_-_Microcomputer_Experimentation_with_the_Motorola_MEK_6800D2_.pdf).
- Perdue, T. _Micro Maestro - A Musical Review of Motorola's MEK6800D2_. Kilobaud Nº13, 01/1978.
- Southern, R.W. _Programming the 6800 Microprocessor_. 1977. En [bitsavers](http://bitsavers.informatik.uni-stuttgart.de/components/motorola/6800/Southern_Programming_The_6800_Microprocessor_1977.pdf).

## Experimentos
- Réplica funcional del módulo de teclado/display. [Acá](./display.md).
- Programa para prueba de memoria RAM. [Acá](./memtest.md).
- Expansión de RAM a 8.5KB y 32KB. [Acá](./ramex.md).
- Conexión de circuito MC6847 para visualización en monitor. [Acá](./video.md).
