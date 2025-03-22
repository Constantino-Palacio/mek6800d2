# Motorola MEK6800D2
El kit Motorola MEK6800D2 es una SBC (_Single Board Computer_) basada en el procesador MC6800, fabricado por Motorola alrededor de 1977. Se compone de una placa de circuito principal con los componentes del sistema y una placa secundaria con un teclado matricial, display hexadecimal y lógica de control de una unidad de cassette para almacenar datos/programas. Es una versión mejorada del [MEK6800D1](https://www.sardis-technologies.com/pre-st29/mekd1.htm), que sólo podía ser conectada a un bus EXORciser y controlada mediante una terminal serie.

El kit utilizado no incluye la placa del teclado, por lo que se [construyó](./display.md) un módulo de teclado casi funcionalmente equivalente al diseño original de Motorola, pero simplificado por razones de tamaño del circuito y costo de los componentes. Tener en cuenta que el módulo del teclado es esencial para el funcionamiento del kit, puesto que no puede realizarse ninguna operación sin dicho componente (a menos que se hagan numerosas modificaciones al circuito).

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

El módulo de teclado contiene:
- 16 teclas para entrada de direcciones/datos en formato hexadecimal
- 8 teclas de función: P, L, N, V, M, E, R, G
- 6 unidades de display de 7 segmentos
- Lógica y conexiones para almacenamiento de datos en cassette.

### Organización

El módulo MPU provee solamente las conexiones para direccionar 512 bytes de RAM y 3KB de ROM, en varios módulos. Para conectar más memoria debe recurrirse a un módulo de expansión conectado a la interfaz EXORciser. El mapa de memoria es el siguiente:

<div align="center"><img src="https://github.com/user-attachments/assets/0cb3d913-e9c2-4f32-bb50-88eda9686fca" style="width:25%;height:25%;text-align:center;"></img></div>

Ver que la RAM de la placa es la base del mapa de direcciones, mientras que todo lo referido al bus de expansión es el tope del espacio de direccionamiento. Los espacios vacantes entre las direcciones se reservan para implementar E/S mapeada en memoria.

## Documentación

Originalmente, Motorola enviaba el kit a los interesados junto a la documentación necesaria para su construcción y manuales de programación del MC6800. El paquete incluía las piezas necesarias para un sistema básico (descrito en la sección anterior) y los siguientes manuales:
- MEK6800D2 Manual: instrucciones de armado y operación básica del kit, incluyendo el listado en ensamblador del programa JBUG
- M6800 Applications Manual: información detallada de todos los circuitos lógicos de la familia M6800, descripción de aplicaciones posibles e implementación con programas en ensamblador MC6800 y diagramas de circuito.
- M6800 Programming Manual: información acerca de la programación del procesador MC6800 

Adicionalmente se cuenta con los siguientes libros para referencia del procesador MC6800:
- American Microsystems. _AMI6800 Assembly Language Programming Manual_.
- Bishop, R. _Bases de los Microprocesadores y el 6800_. 1ed. Arbó. 1992.
- Leventhal, L.A. _Microcomputer Experimentation with the Motorola MEK6800D2_. Prentice Hall. 1981.
- Perdue, T. _Micro Maestro - A Musical Review of Motorola's MEK6800D2_. Kilobaud Nº13, 01/1978.
- Southern, R.W. _Programming the 6800 Microprocessor_. 1977.

## Experimentos
- Réplica funcional del módulo de teclado/display. [Acá](./display.md).
- Conexión de circuito MC6847 para visualización en monitor. [Acá](./video.md).
