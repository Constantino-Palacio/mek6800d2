# Expansión de memoria

Esta sección describe el diseño de una expansión de memoria RAM y ROM para el kit MEK6800D2. El objetivo es llevar la memoria total del sistema a 16.5KB de RAM y permitir al usuario agregar hasta tres módulos de ROM seleccionables al arrancar el sistema.

## Expansión de RAM

### Teoría

El kit MEK6800D2 acepta hasta 512 bytes de RAM para el usuario disponibles en el rango `$0000 .. $01FF`, y provee además varias regiones de 8KB para ampliación, `$2000 .. $3FFF` y `$4000 .. $5FFF`. El total de memoria aceptable resulta entonces 16.5KB. Motorola permite seleccionar estos rangos opcionales usando las señales de control `2/3` y `4/5`, por lo que la incorporación de un módulo de 8KB en cada una es prácticamente trivial, siguiendo el siguiente esquema, obtenido de [AN-0771](https://bitsavers.computerhistory.org/components/motorola/_appNotes/AN-0771_MEK6800D2_Microcomputer_Kit_System_Expansion_Techniques.pdf).

<div align="center"><img src="https://github.com/user-attachments/assets/5eb5e34d-4f3f-41ab-85aa-9bc25d1f95bf" style="width:75%;height:75%;text-align:center;"></img></div>

Como lo que se desea es que la región de RAM accesible al usuario sea contigua, deberá relocalizarse uno de los bancos de 8KB al rango `$0000 .. $1FFF` y reubicar la RAM interna del kit a la parte más alta de la RAM, `$4000 .. $41FF`. Muchas de las señales descritas en la nota de Motorola son usadas cuando hay más de un periférico conectado al EXORbus. Al realizar la expansión directamente en la placa del sistema, se las ignora y se utilizan las líneas de direcciones, datos y selección del banco de memoria.

En el manual del kit se recomienda remover la línea de control de la RAM del integrado U7 (pin 4) y conectar dicho terminal a VCC, tal que se pueda implementar esta ampliación a través de una tarjeta de memoria externa. Como las ampliaciones de RAM van a ser internas al kit, no se realizará esta modificación al circuito.

### Exploración

Como prueba de funcionamiento de los principios descritos por Motorola en la documentación, se propone agregar un módulo de 8KB de RAM estática en el rango de direcciones `$2000 .. $3FFF` sin modificar la ubicación de la RAM incluida en el kit. Se utilizará un integrado IS61C64AH fabricado por *Integrated Silicon Solutions* (8Kx8 SRAM).

Siguiendo el conexionado descrito en AN-0771:
<div align="center"><img src="https://github.com/user-attachments/assets/ea8f3f5a-2784-47e4-af13-acae0b5d73d9" style="width:35%;height:35%;text-align:center;"></img></div>

Se agrega este circuito a la placa desarrollada en la segunda versión de la [interfaz de teclado](./display.md), y las conexiones correspondientes a la placa del sistema usando zócalos de wire-wrap.

Se monta la placa de expansión sobre el kit y se aplican +5V de alimentación. Se reinicia el kit y se ingresa el programa de [prueba de memoria](./memtest.md) usando el teclado hexadecimal, colocando el puntero de arranque en `$2000` y el final en `$3FFF`. Se ejecuta el programa y se verifica la correcta operación del sistema.
