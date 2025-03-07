# Motorola MEK6800D2
El kit Motorola MEK6800D2 es una SBC (_Single Board Computer_) basada en el procesador MC6800, fabricado por Motorola alrededor de 1977. Se compone de una placa de circuito principal con los componentes del sistema y una placa secundaria con un teclado matricial, display hexadecimal y lógica de control de una unidad de cassette para almacenar datos/programas. Es una versión mejorada del [MEK6800D1](https://www.sardis-technologies.com/pre-st29/mekd1.htm), que sólo podía ser conectada a un bus EXORciser y controlada mediante una terminal serie.

El kit usado en este proyecto no incluye la placa del teclado, por lo que el principal objetivo es construir un módulo de teclado casi funcionalmente equivalente al diseño original de Motorola, pero simplificado por razones de tamaño del circuito y costo de los componentes. Tener en cuenta que el módulo del teclado es esencial para el funcionamiento del kit, puesto que no puede realizarse ninguna operación sin dicho componente (a menos que se hagan numerosas modificaciones al circuito).

## Descripción General

El módulo principal incluye:
- MPU Motorola MC6800
- 1KB de ROM con programa monitor JBUG
- 256 bytes de RAM
- 2 módulos de E/S MC6820
- 1 módulo de comunicación serie MC6850

El módulo de teclado contiene:
- 16 teclas para entrada de direcciones/datos en formato hexadecimal
- 8 teclas de función: P, L, N, V, M, E, R, G
- 6 unidades de display de 7 segmentos
- Lógica y conexiones para almacenamiento de datos en cassette.

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

## Nuevo Módulo de Teclado/Display

El diseño original del módulo del teclado se especifica en el manual de uso del kit. A modo de prueba, se decidió utilizar una placa de prototipo de 9x15cm. A continuación se incluye una reproducción del plano esquemático del módulo suministrado por Motorola:

<div align="center"><img src="https://github.com/user-attachments/assets/02cda631-f32b-4b5f-a14f-8a907f605bf4" style="width:75%;height:75%;text-align:center;"></img></div>

La figura anterior puede dividirse en dos grandes secciones funcionales. La primera ocupa la parte superior del plano y corresponde con la interfaz del kit con el teclado y los módulos de 7 segmentos. La parte inferior del esquema corresponde a la conexión con un grabador de cassette para almacenamiento de la información.

Se optó por eliminar completamente la sección encargada de la comunicación con el grabador, reduciendo el circuito a la mitad. Analizando el circuito resultante, puede observarse que, aunque parezca que aun se tiene gran cantidad de componentes, la funcionalidad es simple y puede seguir simplificándose.

### Control de 7 segmentos

Cada uno de los segmentos es activado/desactivado por una señal lógica proveniente del puerto A del integrado U21 (MC6820) en el módulo de MPU. Por razones de protección del circuito, se utiliza un circuito sencillo basado en un transistor PNP (MPS2907) y tres resistores: uno de _pull-up_ de 10kΩ, uno de 4.7kΩ en la base, y otro de 68Ω a la salida, para protección del LED dentro del segmento. En la siguiente figura se muestra esta sección del esquemático:

<div align="center"><img src="https://github.com/user-attachments/assets/406c6c79-e567-4944-a781-c2e0905fa1b6" style="width:20%;height:20%;text-align:center;"></img></div>

Para analizar el funcionamiento de este circuito se recurre al manual de uso del kit. Al final del listado de JBUG (pág. A1-14) se incluye la definición de los patrones de 7 segmentos para cada uno de los dígitos 0..F, resumidos en la siguiente figura:

<div align="center"><img src="https://github.com/user-attachments/assets/767abb83-e3bd-4341-ba4f-3c2399e581d1" style="width:70%;height:70%;text-align:center;"></img></div>

Es fácil ver que los patrones binarios están "invertidos" frente a lo observado en el display. Esto se debe a que el módulo de teclado emplea display de tipo cátodo común, en los que se selecciona un dígito con un nivel lógico bajo en la entrada `CC` y se selecciona cada segmento colocando la entrada correspondiente en un nivel lógico alto. De esto se deduce que los circuitos de control con transistores PNP actúan como inversores lógicos.

Un circuito integrado TTL que cumple con esta funcionalidad es el 74240, un buffer/driver inversor de 8 bits. El componente particular utilizado es el SN74ALS240, fabricado por Texas Instruments.

Al ser de 8 bits, sobra un inversor. Esto podría verse como un "desperdicio" de transistores, aunque no es significativo frente al ahorro en cantidad de componentes, complejidad y tamaño del circuito final. Otra alternativa podría haber sido utilizar un 7404, seis inversores en un mismo paquete. Sin embargo, al requerirse 7, el último debería armarse usando un circuito como el sugerido por Motorola, lo que complejiza el diseño en el acotado espacio del que se dispone.

Asimismo, se cambiaron los resistores de protección de los LEDs con resistores de 180Ω, un valor recomendado para esta aplicación. Se omitieron los resistores de _pull-up_ para reducir la cantidad de componentes. El circuito resultante es como el de la siguiente figura:

<div align="center"><img src="https://github.com/user-attachments/assets/a270863f-bf83-47ff-970e-6dba3eb1105e" style="width:70%;height:70%;text-align:center;"></img></div>

Al circuito se le agregó un capacitor de desacople en la alimentación del 74240. Observar además que se emplearon módulos de display de 4 dígitos con una distribución de pines no estándar. Esto se debe a que se disponía de estos módulos al momento de la construcción de la placa. Al desconocerse las características específicas de este componente, se determinó la distribución de pines experimentalmente y se utilizó esta información para realizar las conexiones según el esquema anterior.

### Selección de dígitos/filas del teclado

Para la selección de los dígitos y las filas del teclado, el diseño original utiliza tres integrados MC75452, cada uno compuesto por un par de puertas NAND diseñadas para el manejo de dispositivos. Notar que las compuertas conectan una de las entradas a un nivel lógico alto, conectando la otra al puerto B del componente U21 del módulo MPU. Recordando la tabla de verdad de una compuerta NAND, se ve que esta configuración funciona como inversor lógico:

<div align="center"><img src="https://github.com/user-attachments/assets/05c9a0ef-90ff-431e-a25f-117a72350d42" style="width:20%;height:20%;text-align:center;"></img></div>

Al ser seis los dígitos del display y las filas del teclado, se optó por reemplazar estos tres integrados por un único integrado 7404, que contiene seis inversores lógicos y sirve además como buffer para control de dispositivos sencillos como LEDs. Para reforzar el circuito podría usarse un 7406 en lugar del 7404. Este circuito es funcionalmente equivalente, pero soporta mayor corriente en la salida.

Al igual que con el 74240, se coloca un capacitor de desacople en la alimentación del 7404. Motorola recomienda un capacitor de 0.1µF por cada 3 circuitos integrados para desacople, pero se decidió colocar uno por cada integrado, al ser sólo tres. El circuito resultante es el de la siguiente figura:

<div align="center"><img src="https://github.com/user-attachments/assets/8ef8e5e7-ff0a-4323-a7ae-90da92ab8ccf" style="width:85%;height:85%;text-align:center;"></img></div>

Notar que se han omitido las teclas `P` y `L` en el esquemático. Estas sirven para los comandos de grabación y lectura de cassette, respectivamente. Al eliminarse dicha funcionalidad, se consideró apropiado eliminar las teclas correspondientes para evitar cualquier tipo de falla en el kit que pueda producirse al intentar interactuar con un periférico inexistente.

### Selección de las columnas del teclado

Para determinar la tecla que se presionó en un instante de tiempo dado, Motorola emplea un único circuito integrado del tipo MC14539. Este es un selector dual de 4-canales, es decir, permite seleccionar 1 de 4 entradas. Es funcionalmente equivalente al 74153. Se utilizó este último por ser más fácil de obtener. Se respetó el plano original en este caso:

<div align="center"><img src="https://github.com/user-attachments/assets/b6bb7281-6ad2-4e2d-b49b-6cd74228d096" style="width:30%;height:30%;text-align:center;"></img></div>

Ver que las conexiones de entrada del integrado son las cuatro columnas del teclado `COL1`, `COL2`, `COL3` y `COL4`, y el número de columna a leer, conectado a los terminales `PB6` y `PB7` del integrado U21 de la placa MPU. A este componente también se vincula la salida `Za`, el valor lógico presente en la columna seleccionada mediante `S0` y `S1`. La salida `Za` se conecta al pin `PA7` de U21. Por este motivo es que se deja `PA7` en bajo cuando se escribe el patrón de los dígitos para el display.

### Implementación

Para implementar el teclado se decidió utilizar dos placas de circuito. La placa principal es el teclado y display, junto a la electrónica de soporte. Esta se conecta mediante un cable plano de 20 conductores a un módulo adaptador que permite conectar el teclado al MPU sin tener que utilizar el conector de borde de 50 pines propuesto por Motorola.

La placa adaptadora se monta sobre el zócalo de U21 en el módulo MPU, y contiene un conector de 20 pines para el teclado. Esta misma conexión es la responsable de brindar alimentación al MPU: +5V y tierra. El adaptador posee un zócalo para un conector tipo Berg de 4 pines para brindar alimentación al MPU de forma más segura que a través de las conexiones de alimentación de U21.
