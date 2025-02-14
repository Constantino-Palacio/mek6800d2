# Motorola MEK6800D2
El kit Motorola MEK6800D2 es un entorno de entrenamiento para el procesador MC6800, fabricado por Motorola alrededor de 1977. Se compone de una placa de circuito principal con los componentes del sistema y una placa secundaria con un teclado matricial, display hexadecimal y lógica de control de una unidad de cassette para almacenar datos/programas.

El módulo de CPU incluye un procesador MC6800, 1KB de ROM con el programa monitor JBUG (MCM6830), 256 bytes de RAM de uso general (ampliados a 512 bytes, MCM6810), 128 bytes de RAM exclusiva para JBUG (MCM6810), 2 módulos PIA MC6820 (uno para el teclado/display, otro para el usuario) y un módulo ACIA para control de la unidad de cassette MC6850.

Contiene además las expansiones necesarias para la conexión con un sistema EXORciser, no utilizadas en este kit en particular: buffers MC8T97 y MC8T26.

La placa del teclado presenta una matriz de 16 teclas hexadecimales (dígitos 0..F) y 8 teclas de función (P, L, N, V, M, E, R, G), junto a 6 unidades de display de 7 segmentos, para visualización de datos y direcciones. Como se mencionó anteriormente, se incluye además toda la lógica para implementar la conexión a una unidad de cassette. Esta placa se conecta a una de las PIA del módulo de CPU y a la ACIA.

## Orígenes del Kit y Estado
El kit utilizado en este proyecto proviene de la Facultad de Ingeniería - UNLP. Fue encontrado durante tareas de limpieza en un grupo de placas de circuito preparadas para su reciclaje. La placa de CPU fue el único componente hallado, por lo que la placa del teclado debió ser fabricada a partir del esquemático incluido en el manual del kit.

Para determinar el funcionamiento del kit sin teclado ni display, se optó por alimentar el kit con una fuente de PC y sintonizar una radio AM a 614kHz con el objetivo de detectar alguna señal proveniente de la placa. Al ser una frecuencia de operación relativamente baja y al no tener ninguna clase de aislamiento EM, se logró detectar una señal pulsante a dicha frecuencia, lo que sugirió que el kit funcionaba.

Como prueba de funcionamiento más detallada se conectó un display de 7 segmentos al kit y se observó actividad en la PIA, lo que permitió determinar que el sistema funcionaba y era una alternativa viable la construcción del módulo del teclado.

## Construcción del Teclado

El diseño original de Motorola para el módulo del teclado se compone de una gran cantidad de componentes distribuidos en una placa de circuito de un tamaño considerable. Al tratarse de un prototipo para comprobar el funcionamiento del sistema, se optó por simplificar el esquema de circuito tanto como fuera posible.

![image](https://github.com/user-attachments/assets/54cdae67-999a-4485-b860-28ee41272afa)

Como punto de partida se fijó el tamaño de la placa a 9x15cm, debido a que se contaba con una placa de prototipos de esas dimensiones.

La primera simplificación realizada consistió en eliminar completamente la sección del circuito encargada de la operación de la unidad de cassette, por considerarse un periférico de poca utilidad en un contexto moderno. Esto redujo el diseño esencialmente a la mitad.

Lo siguiente fue reducir el circuito del control del teclado y pantalla. Originalmente, cada segmento del display se manejaba mediante un transistor PNP (MPS2907) conectado a tres resistores: uno de 4.7k en la base, con pull-up de 10k, y otro de 68 Ohm a la salida. Este diseño, replicado para cada uno de los siete segmentos, se consideró demasiado complejo. Para simplificarlo, se observó que el módulo de 7 segmentos utilizado originalmente era de cátodo común, lo que significa que, al colocar la entrada de un segmento en nivel alto y el selector de dígito en nivel bajo, se ilumina el segmento correspondiente de ese dígito.

![image](https://github.com/user-attachments/assets/406c6c79-e567-4944-a781-c2e0905fa1b6)

En el listado de la ROM incluido en el manual de operaciones del kit, se pueden encontrar las definiciones de los caracteres que pueden mostrarse en el display (pág. A1-14). Tomando como ejemplo el '0', en hexadecimal es `0x40` (`01000000` en base 2). Observando el plano del circuito, se ve que los terminales PA0-PA6 de la PIA se conectan al circuito de control de los segmentos. Además, teniendo en cuenta que PA0 es el segmento A y PA6 el segmento G (PA7 se utiliza para otra función), se puede determinar que el patrón binario `01000000` pone en `0` todos los segmentos, salgo el G, que se coloca en `1`.

El arreglo de transistores PNP transforma este patrón a `0111111` (se ignora el bit correspondiente a PA7). Recordando que el display es de tipo cátodo común, el dígito visualizado es el correspondiente a '0'.

Como los transistores actúan como un inversor lógico en este caso, se optó por reemplazarlos por un circuito integrado SN74ALS240, un buffer inversor de 8 bits. La funcionalidad es la misma. Se puede prescindir de los resistores de pull-up y 4.7k, y se utilizan resistores de 180 Ohm para los segmentos para mayor protección del display.

![image](https://github.com/user-attachments/assets/a270863f-bf83-47ff-970e-6dba3eb1105e)

Al desconocerse el modelo de la unidad de display utilizada, se determinó la distribución de pines experimentalmente y se utilizó esta información para realizar las conexiones según el esquema anterior.

Para la selección de los dígitos y las filas del teclado, el diseño original utiliza tres integrados MC75452, cada uno compuesto por un par de puertas NAND y transistores para manejo de dispositivos. Al ser seis los dígitos del display y las filas del teclado, se optó por reemplazar estos tres integrados por un único integrado 74S04, que contiene seis inversores lógicos y sirve además como buffer para control de dispositivos sencillos como LEDs.
