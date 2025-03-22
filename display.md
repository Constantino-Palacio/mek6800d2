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

Un circuito integrado TTL que cumple con esta funcionalidad es el 74240, un buffer/driver inversor de 8 bits. Al ser de 8 bits, sobra un inversor. Esto podría verse como un "desperdicio" de transistores, aunque no es significativo frente al ahorro en cantidad de componentes, complejidad y tamaño del circuito final. Otra alternativa podría haber sido utilizar un 7404, seis inversores en un mismo paquete. Sin embargo, al requerirse 7, el último debería armarse usando un circuito como el sugerido por Motorola, lo que complejiza el diseño en el acotado espacio del que se dispone.

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

La placa adaptadora se monta sobre el zócalo de U21 en el módulo MPU, y contiene un conector de 20 pines para el teclado. Esta misma conexión es la responsable de brindar alimentación al MPU: +5V y tierra. El adaptador posee un zócalo para un conector tipo Berg de 4 pines para brindar alimentación al MPU de forma más segura que a través de las conexiones de alimentación de U21. Esta placa se muestra en la siguiente figura:

<div align="center"><img src="https://github.com/user-attachments/assets/b2f117d8-6fd7-49af-a511-35797e052f71" style="width:30%;height:30%;text-align:center;"></img></div>

Se puede ver que el módulo adaptador se instala directamente en el zócalo reservado para el integrado MC6820, que a su vez se instala sobre el adaptador. Se puede apreciar también el cable plano que vincula el MPU con el teclado.

Respetando los planos de circuito explicados en las secciones anteriores se construyó un prototipo en una placa perforada de 9x15cm. El resultado se muestra en la siguiente figura:

<div align="center"><img src="https://github.com/user-attachments/assets/e3570199-fadc-4905-a605-2bf2cd01ad07" style="width:30%;height:30%;text-align:center;"></img></div>

### Pruebas Básicas

Para validar el diseño propuesto se conectan los componentes de la siguiente manera:
- El módulo adaptador se conecta en la posición U21 del módulo MPU, con la conexión de alimentación siguiendo la dirección del interruptor de reset. Alternativamente, se puede conectar el MC6820 al adaptador, con el pin 1 hacia la conexión de alimentación. Luego se conecta el adaptador siguiendo la orientación original de U21.
- El cable plano se conecta con el pin 1 (marcado en rojo) apuntando a la parte inferior de la placa, o bien tomando como guía el segundo círculo amarillo, o dejando la muezca del conector apuntando hacia el integrado MC6820.
- La alimentación del MPU se conecta usando un cable de alimentación similar el de una disquetera de 3.5", con el cable rojo (+5V) más cercano al extremo izquierdo del módulo, o bien con la muezca del conector hacia arriba.
- En la placa del teclado, se conecta el cable plano tal que el pin 1 apunte hacia la parte inferior del teclado, o bien siguiendo el círculo amarillo.
- La alimentación del sistema completo se conecta al teclado de igual forma que la alimentación del MPU al adaptador. Se conecta la entrada (un cable similar al de una disquetera de 3.5") siguiendo el círculo amarillo, o bien sabiendo que el cable rojo (+5V) es el más alejado del LED de encendido.

En la siguiente figura se muestra el sistema completo listo para iniciar las pruebas de funcionamiento:

Para alimentar el kit completo se utiliza una fuente ATX estándar. De acuerdo con la documentación de Motorola, una fuente que proporcione +5V/6A es más que suficiente. Al alimentar el circuito y presionar `RESET`, se observó lo siguiente:

El sistema muestra el prompt `-`, indicando que está listo para recibir comandos. Para hacer una prueba sencilla, se ingresó `E000 M`, para examinar el contenido de la posición de memoria `$E000`, el inicio de JBUG. Se ingresa `G` para pasar a la siguiente posición de memoria. Se ingresa `E` para volver al prompt.

Siguiendo el listado de programa del manual, los primeros 10 bytes almacenados a partir de esa posición son `$08 $FF $A0 $1E $08 $FF $A0 $0A $B0 $A0`. En la siguiente figura se pueden ver capturas del display que muestran claramente los valores correctos:

Notar que algunos patrones no se visualizan correctamente. Esto no es una falla en el display, pues los todos los segmentos funcionan. Se desconoce la causa de este problema, aunque se sospecha que esté relacionado con la elección de diseño de quitar los resistores de _pull-up_ relacionados a los segmentos.

### Prueba de Memoria

Con el objetivo de comprobar el correcto funcionamiento de la memoria se escribió un programa en lenguaje de máquina MC6800. El algoritmo es descrito por el siguiente diagrama de flujos:

<div align="center"><img src="https://github.com/user-attachments/assets/ae4fcadf-f04c-467e-bf97-36b8f5e9491e" style="width:30%;height:30%;text-align:center;"></img></div>

El control es devuelto a JBUG una vez realizada la prueba de memoria. Se puede consultar la dirección en la que terminó la prueba ingresando `M A026 G`. El primer byte de la dirección aparecerá en el display. Ingresar `G` para ver el segundo byte. En un kit sin fallas, las direcciones `ACTUAL` y `FIN` deberían ser iguales.

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
