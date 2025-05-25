# Expansión de memoria

Esta sección describe el diseño de una expansión de memoria RAM y ROM para el kit MEK6800D2. El objetivo es llevar la memoria total del sistema a 8.5KB de RAM e intentar aprovechar alguno o ambos zócalos de PROM del kit (U10 y U12).

## Expansión de RAM

### Teoría

El kit MEK6800D2 acepta hasta 512 bytes de RAM para el usuario disponibles en el rango `$0000 .. $01FF`, y provee además varias regiones de 8KB para ampliación, `$2000 .. $3FFF` y `$4000 .. $5FFF`. El total de memoria aceptable resulta entonces 16.5KB. Motorola permite seleccionar estos rangos opcionales usando las señales de control `2/3` y `4/5`, por lo que la incorporación de un módulo de 8KB en cada una es prácticamente trivial, siguiendo el siguiente esquema, obtenido de [AN-0771](https://bitsavers.computerhistory.org/components/motorola/_appNotes/AN-0771_MEK6800D2_Microcomputer_Kit_System_Expansion_Techniques.pdf).

<div align="center"><img src="https://github.com/user-attachments/assets/e08cdecd-b68a-4678-a261-7b62abbc6670" style="width:75%;height:75%;text-align:center;"></img></div>

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

