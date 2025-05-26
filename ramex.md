# Expansión de memoria

Esta sección describe el diseño de una expansión de memoria RAM y ROM para el kit MEK6800D2. El objetivo es llevar la memoria total del sistema a 8.5KB de RAM e intentar aprovechar alguno o ambos zócalos de PROM del kit (U10 y U12).

## Expansión de RAM

### Teoría

El kit MEK6800D2 acepta hasta 512 bytes de RAM para el usuario disponibles en el rango `$0000 .. $01FF`, y provee además varias regiones de 8KB para ampliación, `$2000 .. $3FFF` y `$4000 .. $5FFF`. El total de memoria aceptable resulta entonces 16.5KB. Motorola permite seleccionar estos rangos opcionales usando las señales de control `2/3` y `4/5`, por lo que la incorporación de un módulo de 8KB en cada una es prácticamente trivial, siguiendo las indicaciones en [AN-0771](https://bitsavers.computerhistory.org/components/motorola/_appNotes/AN-0771_MEK6800D2_Microcomputer_Kit_System_Expansion_Techniques.pdf).

Como lo que se desea es que la región de RAM accesible al usuario sea contigua, deberá relocalizarse el banco de 8KB al rango `$0000 .. $1FFF` y reubicar la RAM interna del kit a `$2000 .. $21FF`. Muchas de las señales descritas en la nota de Motorola son usadas cuando hay más de un periférico conectado al EXORbus. Al realizar la expansión directamente en la placa del sistema, se las ignora y se utilizan las líneas de direcciones, datos y selección del banco de memoria.

En el manual del kit se recomienda remover la línea de control de la RAM del integrado U7 (pin 4) y conectar dicho terminal a VCC, tal que se pueda implementar esta ampliación a través de una tarjeta de memoria externa. Como las ampliaciones de RAM van a ser internas al kit, no se realizará esta modificación al circuito.

### Relocalizando la RAM interna

Se intenta relocalizar la RAM original del kit al rango `$2000 .. $21FF`. Para ello, se instala un header de 3 terminales en la zona de prototipado que viene en la placa del kit. Este header se conecta de la siguiente manera:

- El pin superior (más cerca del borde de la placa) se conecta a la línea `RAM`
- El pin central se conecta al la línea de selección de los integrados MC6810 del kit
- El pin inferior se conecta a la línea de control `2/3` a la salida del integrado 74155 (U11).

Al estar la línea de control `RAM` soldada directamente a los integrados de memoria, se realiza un pequeño corte en la pista para que dichos integrados sean seleccionados mediante esta entrada de configuración. Colocando un jumper entre la posición central y alguno de los extremos se puede selccionar el banco de memoria donde se va a ubicar estos 512 bytes.

Para probar el funcionamiento del circuito, se hace uso del programa de prueba de memoria, configurando el rango apropiadamente. Se verifica que la operación es correcta al visualizar que la dirección de fin y actual coinciden.

### Agregando 8KB de RAM

La adición de un banco de 8KB implica más modificaciones a la placa base. Se debe agregar un zócalo para incorporar la memoria, cablear todas las líneas de datos y direcciones necesarias, así como las líneas de selección. El integrado seleccionado es un 61C64, un módulo de RAM estática 8K x 8 bits. Las líneas de datos y direcciones se conectan a los correspondientes puntos del kit (no del EXORbus, las mismas que los otros componentes del kit, como la ROM, RAM, I/O, etc.).

La selección del circuito depende del módulo elegido. En este caso puntual, se utilizó el integrado IS61C64AH-12, con la siguiente distribución de pines:

<div align="center"><img src="https://github.com/user-attachments/assets/8153d12f-c7b3-41fe-b34c-5f9d122a425e" style="width:60%;height:60%;text-align:center;"></img></div>

Y funciona de acuerdo con la siguiente tabla de verdad:

<div align="center"><img src="https://github.com/user-attachments/assets/ecf85f64-e150-4679-a6db-1d8abeb31b8e" style="width:70%;height:70%;text-align:center;"></img></div>

Para seleccionar el integrado se realizaron las siguientes conexiones:
- CE1 se conecta a la línea de selección RAM (activa en bajo)
- CE2 se conecta a la línea DBE (activa en alto)
- OE se conecta a RAM (activa en bajo)
- WE se conecta a R/W (activa en bajo)

Se conecta además un capacitor de 100nF para desacople. El esquema de circuito final es el siguiente:

<div align="center"><img src="https://github.com/user-attachments/assets/4ecc921e-c9ae-43ac-bce6-343748e7d01b" style="width:40%;height:40%;text-align:center;"></img></div>

El kit se ve modificado de la siguiente manera:

<div align="center"><img src="https://github.com/user-attachments/assets/a484dae6-e171-4eb9-9fae-851ad3ba77f5" style="width:40%;height:40%;text-align:center;"></img></div>

Al momento de probar el funcionamiento, se coloca el jumper de selección de los 512 bytes en la posición superior, rango `$2000 .. $21FF`, y se enciende el kit. No se observa actividad alguna, aun al presionar el botón de RESET repetidamente. Al sospecharse de un conflicto de acceso al bus, se remueven los componentes asociados al EXORbus: U1, U2, U3, U4, U5 y U7. El problema se resuelve, aunque no se tiene certeza de la causa. Se cree que podría estar relacionado con el temporizado del acceso a la memoria, o contención del bus.

Como prueba definitiva, se ejecuta el programa de prueba de memoria en el rango `$0000 .. $1FFF`, y se observa que el programa se completa exitosamente. Se procede a realizar una prueba completa en la RAM. Entonces:
- Se almacena `$0000` en `$A023`
- Se almacena `$0000` en `$A025`
- Se almacena `$2200` en `$A027`

Se ejecuta desde `$A030` y se observa, usando el modo `M` de JBUG, el valor `$2200` en `$A025`. Es decir, coinciden el valor de final con el valor del puntero de dirección actual. Esto implica que la memoria funciona correctamente y que, en consecuencia, el kit ahora cuenta con 8.5KB de RAM disponible para el usuario.

<div align="center"><img src="https://github.com/user-attachments/assets/68a0606a-ad95-4c9e-8cae-5468c9a36f67" style="width:30%;height:30%;text-align:center;"></img></div>

Aunque en la imagen parezca que el display no funciona correctamente, esto se debe a las conexiones de este circuito y no al mal funcionamiento del kit. En la pantalla se puede visualizar `A04F 3F`, que corresponde con la última instrucción del programa de prueba de memoria.
