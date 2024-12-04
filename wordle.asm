.data

//REGISTROS RESERVADOS por sistema
@r0, r1, r2, r7

//ARCHIVO TXT
archivo: .asciz "diccionario.txt"      @hay 100 palabras
espacioArchivo: .space 739
errorLectura: .asciz "No se pudo leer el archivo"
cantidadDeBarras: .word 0

//RANDOM
mensajeIngresarNum: .asciz "Ingresa un numero entre 1 y 99: "
mensajeErrorNum: .asciz "Numero invalido. Intente de nuevo.\n"
numeroIngresado: .asciz "   "
numeroAleatorio: .byte 0

palabraElegida: .asciz "          "

//GENERAL
bienvenido: .asciz "BIENVENIDO A WORDLE\n"
consideraciones: .asciz "Los caracteres ingresados deben estar todos en minusculas y respetar el largo informado.\n"
infoCantLetras: .asciz "La cantidad de letras es "

ingresarPalabra: .asciz "Ingrese la palabra: "
palabraUsuario: .asciz "          "
palabraFallida: .asciz "La palabra ingresada no cumple con lo avisado anteriormente.\n"
cantLetrasPalabra: .byte 1
cantLetrasPalabraInfo: .asciz " "       @guardo la cantLetrasPalabra en un string
caracterColor: .byte ' '

//GANA
ingresoNombreUsuario: .asciz "Ingresa tu nombre: "
felicidades: .asciz "¡FELICIDADES HAS GANADO!\n"
infoPuntaje: .asciz "Tu puntaje fue: "
puntaje: .asciz "  "
nombreUsuario: .asciz "..."

//PIERDE
lastima: .asciz "Que lastima... ¡Has perdido! :c\n"
visibilizacionPalabra: .asciz "La palabra era:         "

//VOLVER A JUGAR
volverJugar: .asciz "¿Desea volver a jugar?\n"
decisionVolverJugar: .asciz "S_ Si / N_ No\n"
decisionTomada: .asciz "  "
caracterInvalido: .asciz "Caracter invalido."

//archivo ranking
archivoRanking: .asciz "ranking.txt"
espacioArchivoRanking: .space 500
cantidadBarrasRanking: .byte 0
ranking: .asciz "RANKING\n"
infoJugador: .asciz "                       \n"
palabraPuntos: .asciz "puntos"

//imprimirRanking
datoDeRanking: .asciz "RANKING:"
cantidadDeEntersRanking: .byte 0
tresUltimosJugadores: .asciz "                                                                                                "

//DECORACION
lineaSeparacion: .asciz "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _"
espacio: .asciz "\n"
tabulacionCen: .asciz "          "
rojo: .asciz "\033[31m"
verde: .asciz "\033[32m"
amarillo: .asciz "\033[33m"
blanco: .asciz "\033[37m"

//LIMPIAR PANTALLA
cls:.asciz "\x1b[H\x1b[2J"
lencls=.-cls
texto:.asciz "dkfdklfjldksjkflksdl kljdkljflkdsjfklds lkjlkjlkdjflksdj \n ljkljlkjlkjlkjlkjlkjkl hkjhkjhkjh"
lentexto=.-texto
tecla: .asciz "00"


.text
@limpiar pantalla
limpiar:
        .fnstart
        mov r0,#1
        ldr r1,=cls
        ldr r2,=lencls
        mov r7,#4
        swi 0
        bx lr
        .fnend
mostrar:
        .fnstart
        mov r0,#1
        ldr r1,=texto
        ldr r2,=lentexto
        mov r7,#4
        swi 0
        bx lr
        .fnend

.global main

        @limpiar pantalla
        bl mostrar
        mov r5,#50000
ptecla: mov r0,#0
        mov r7,#3
        mov r2,#2
        ldr r1,=tecla
        swi 0


main:
        bl limpiar

//--------------------------------------INGRESO NUMERO ALEATORIO------------------------------------
ingresarNumeroAleatorio:
        bl tabulacion

        mov r7, #4
        mov r0, #1
        mov r2, #33
        ldr r1, =mensajeIngresarNum
        swi 0

        mov r7, #3
        mov r0, #0
        mov r2, #4
        ldr r1, =numeroIngresado
        swi 0

convertirCadenaANum:
        ldr r1, =numeroIngresado
        mov r0, #0              @acumulador
        mov r6, #10

convertirCadena:
        ldrb r2, [r1]
        cmp r2, #0x0A
        beq finConversion

        sub r2, #'0'            @convierto a numero
        mul r0, r6              @multiplico acumulador por 10
        add r0, r2              @acumulador + numero

        add r1, #1              @incremento direccion

        b convertirCadena

finConversion:
        cmp r0, #1
        blt mensajeInvalidoNum

        cmp r0, #99
        bgt mensajeInvalidoNum

        ldr r3, =numeroAleatorio        @guardo el numero en data
        str r0, [r3]

        b inicioPrograma

mensajeInvalidoNum:
        mov r7, #4
        mov r0, #1
        mov r2, #35
        ldr r1, =mensajeErrorNum
        swi 0

        b ingresarNumeroAleatorio

inicioPrograma:
//---------------------------------------------DICCIONARIO-------------------------------------------
        //abrir archivo para lectura
        mov r7, #5      @abre el archivo
        ldr r0, =archivo        @en r0 devuelve el descriptor

        mov r1, #0      @lectura
        swi 0

        //ver si hay error de archivo
        cmp r0, #0      @para ver si esta vacio o algo raro -> da error
        blt existeError
        mov r6, r0

        b noHayError

existeError:
        mov r7, #4
        mov r0, #1
        mov r2, #26
        ldr r1, =errorLectura
        swi 0

noHayError:
        mov r7, #3      @lectura con descriptor
        ldr r1, =espacioArchivo @contenido del archivo leido
        mov r2, #738
        swi 0

dentroDeRango:
        ldr r0, =numeroAleatorio
        ldrb r0, [r0]
        mov r10, r0     @guarda random en r10

        ldr r1, =espacioArchivo @leo de nuevo la direccion de txt
        mov r11, #0

recorrerTextoHastaBarra:
        ldrb r8, [r1]

        cmp r11, r10            @r11(contador de barras) = r10(random) entonces encontro donde empieza la palabra
        beq encontroInicioPalabra

        cmp r8, #'/'
        beq hayBarra

        add r1, #1
        b recorrerTextoHastaBarra

hayBarra:
        add r11, #1     @va contando las barras hasta encontrar la barra de random
        add r1, #1
        b recorrerTextoHastaBarra

        //al encontrar la posicion de donde empieza la palabra, primero quiero calcular el largo para utilizarlo en futuros datos
encontroInicioPalabra:
        mov r11, #0     @contador del largo de la palabra
        ldr r9, =palabraElegida

calcularLargoPalabraYGuardarla:
        ldrb r8, [r1]   @cargo de nuevo la posicion en la que esta para que r8 se compare bien
        ldr r10, =palabraElegida        @veo como se va guardando la palabra completa en r10

        cmp r8, #'/'    @encontro el proximo que es cuando termina la palabra
        beq largoPalabra

guardar:
        strb r8, [r9]
        add r1, #1      @direccion de memoria de diccionario
        add r11, #1     @incremento contador de largo palabra
        add r9, #1      @incremento direccion de palabraElegida

        b calcularLargoPalabraYGuardarla

largoPalabra:
        ldr r8, =cantLetrasPalabra      @guarda el largo de la palabra en data
        str r11, [r8]

cerrarArchivo:  @cierra archivo
        mov r0, r6
        mov r7, #6
        swi 0

comienzaPrograma:
//-----------------------------------------------INICIO-------------------------------------------
        bl saltoDeLinea

        @barra de separacion
        bl tabulacion           @imprime tabulacion (centrado)
        bl tabulacion
        bl separacion
        bl saltoDeLinea
        bl saltoDeLinea

        bl tabulacion           @imprime tabulacion (centrado)
        bl tabulacion           @imprime tabulacion (centrado)
        bl tabulacion           @imprime tabulacion (centrado)
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #19
        ldr r1, =bienvenido     @imprimo frase de bienvenida
        swi 0

        bl saltoDeLinea

        //CONSIDERACIONES (solo ingreso de minusculas y que ingrese la cantidad informada
        bl saltoDeLinea
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #89
        ldr r1, =consideraciones
        swi 0

        bl saltoDeLinea

        //REEMPLAZO LA X POR LA CANTIDAD DE LETRAS
        ldr r3, =cantLetrasPalabra
        ldrb r3, [r3]                   @largo de la palabra
        add r6, r3, #'0'                @sumo el r3 '0' ya que es un valor numero y no puedo concatenarlo en la etiqueta infoCantLetras porqu$

        ldr r8, =cantLetrasPalabraInfo  @guardo el numero en un asciz para luego imprimirlo
        strb r6, [r8]

        ldr r4, =infoCantLetras

imprimirInfoCantLetras:
        bl tabulacion

        mov r7, #4
        mov r0, #1
        mov r2, #25
        ldr r1, =infoCantLetras
        swi 0

        mov r7, #4
        mov r0, #1
        mov r2, #1
        ldr r1, =cantLetrasPalabraInfo
        swi 0

        bl saltoDeLinea

//-------------------------------------------CICLO DE INGRESO USUARIO--------------------------------------------------

//INICIALIZACIONES
datosBase:
        ldr r3, =cantLetrasPalabra
        ldrb r3, [r3]   @largo de palabraElegida
        mov r4, #5      @vida usuario

pedirPalabra:
        cmp r5, r3      @pregunta si tiene la palabra verde
        beq pantallaGano

        mov r5, #0      @contador letras verdes

        cmp r4, #0      @pregunta si tiene vidas
        beq pantallaPerdio

        bl saltoDeLinea

        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #20
        ldr r1, =ingresarPalabra    @imprime frase
        swi 0

        mov r7, #3
        mov r0, #0
        mov r2, #10      @cantidad maxima de una posible palabra
        ldr r1, =palabraUsuario         @tomar palabra por teclado
        swi 0

//COMPRUEBA QUE TODAS LAS LETRAS SEAN MINUSCULAS Y QUE SEA DEL LARGO PALABRAELEGIDA
inicializacionConsideraciones:
        ldr r6, =palabraUsuario
        mov r7, #0      @cantidad letras de palabraUsuario
        b comprobarConsideraciones

comprobarConsideraciones:
        ldrb r8, [r6]     @palabraUsuario

        cmp r8, #0x0A
        beq terminoDeRecorrer

        cmp r8, #'a'    @comprueba que sea menor a 97 = a, si eso pasa informa error y tiene que$
        blt ingresoFallido

        cmp r8, #'z'    @comprueba que sea menor a 122 = z, si eso pasa informa error y tiene qu$
        bgt ingresoFallido

        add r6, #1     @incrementa direccion de memoria para seguir recorriendo e incrementa cant de letras de usuario
        add r7, #1

        b comprobarConsideraciones

terminoDeRecorrer:
        cmp r3, r7      @compara el largo de palabraElegida y palabraUsuario
        beq resetXIngreso

        b ingresoFallido

ingresoFallido:
        bl saltoDeLinea

        bl tabulacion           @imprime tabulacion (centrado)
        mov r7, #4
        mov r0, #1
        mov r2, #61
        ldr r1, =palabraFallida @imprime mensaje de error y vuelve a la etiqueta de pedir de nuevo la palabra
        swi 0

        bl saltoDeLinea
        // VER SI HAY QUE RESETEAR A PALABRAUSUARIO = "........" NUEVAMENTE
        b pedirPalabra

//RESETS Y VALIDACIONES
resetXIngreso:
        ldr r6, =palabraUsuario
        mov r9, #0

        bl tabulacion           @imprime tabulacion (centrado)

resetXCiclo:
        ldr r10, =palabraElegida
        mov r12, #0

validacionesDeCaract:
        ldrb r8, [r6]       @palabraUsario
        ldrb r11, [r10]     @palabraElegida

        cmp r3, r9      @pregunta si llego al final de palabraUsuario -> termino de comprobar todos los caracteres
        beq finRecorridoPalabra

        b consultarCaracter

siguienteCaract:
        ldr r7, =caracterColor
        strb r8, [r7]

        bl imprimirCaracter

        add r6, #1      @incremento direccion palabraUsuario
        add r9, #1      @incremento contador palabraUsuario

        b resetXCiclo

siguienteCaractMenor:
        add r10, #1     @incrementa direccion palabraElegida
        add r12, #1     @incrementa contador palabraElegida

        b validacionesDeCaract

consultarCaracter:
        cmp r8, r11     @compara ambos caracteres
        beq sonIguales

        cmp r3, r12
        beq esRoja      @si llego al final de palabraElegida la letra no esta

        add r10, #1     @incrementa direccion de palabraElegida
        add r12, #1     @incrementa contador palabraElegida

        b validacionesDeCaract

sonIguales:
        cmp r9, r12     @compara si son iguales las posiciones con el contador de cada una
        beq esVerde

        b esAmarilla    @si son el mismo caracter pero diferente posicion

//COLORES
esVerde:
        ldr r1, =verde
        mov r2, #6
        mov r0, #1
        mov r7, #4
        swi 0

        add r5, #1      @incrementa 1 en palabraVerde (si este contador es igual al largo, gana)

        b siguienteCaract

esAmarilla:
        ldr r1, =amarillo
        mov r2, #6
        mov r0, #1
        mov r7, #4
        swi 0

        cmp r12, r9
        blt siguienteCaractMenor

        b siguienteCaract

esRoja:
        ldr r1, =rojo
        mov r2, #6
        mov r0, #1
        mov r7, #4
        swi 0

        beq siguienteCaract

//UNA VEZ TERMINADO DE RECORRER VUELVE A PEDIR PALABRA
imprimirCaracter:
        mov r7, #4
        mov r0, #1
        mov r2, #1
        ldr r1, =caracterColor
        swi 0

        bx lr

finRecorridoPalabra:
        sub r4, #1      @le resta 1 al contador de la vida (5 inicial)

        ldr r1, =blanco
        mov r2, #6
        mov r0, #1
        mov r7, #4
        swi 0

        b pedirPalabra

//-------------------------------------------GANO-----------------------------------------------

pantallaGano:

        @barra de separacion
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)
        bl tabulacion           @imprime tabulacion (centrado)
        bl separacion

        mov r5, #0              @empieza a calcular el puntaje
        add r4, #1
        mul r5, r3, r4          @en r5 guardo el puntaje = largoPalabra + vida restante

        mov r6, #0

        ldr r8, =puntaje

        bl saltoDeLinea
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #25
        ldr r1, =felicidades
        swi 0

        ldr r1, =blanco
        mov r2, #6
        mov r0, #1
        mov r7, #4
        swi 0

        bl saltoDeLinea
        bl tabulacion

        mov r7, #4
        mov r0, #1
        mov r2, #16
        ldr r1, =infoPuntaje
        swi 0

dividir:
        cmp r5, #10
        blt resto

        sub r5, #10
        add r6, #1

        b dividir

resto:
        add r6, #'0'
        str r6, [r8]

        add r8, #1

        add r5, #'0'
        str r5, [r8]

        mov r7, #4
        mov r0, #1
        mov r2, #2
        ldr r1, =puntaje
        swi 0

        bl saltoDeLinea
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #19
        ldr r1, =ingresoNombreUsuario
        swi 0

        mov r7, #3
        mov r0, #0
        mov r2, #4
        ldr r1, =nombreUsuario
        swi 0

        bl saltoDeLinea
//------------------------------------------RANKING---------------------------------------------
        ldr r3, =infoJugador    @donde vamos a ir concatenando nombre + puntaje + frasePuntos
        add r3, #10
        ldr r4, =nombreUsuario

recorreNombre:
        ldrb r5, [r4]
        cmp r5, #0x0A           @hasta que detecte el enter
        beq agregarPuntos

        strb r5, [r3]
        add r3, #1
        add r4, #1

        b recorreNombre

agregarPuntos:
        add r3, #1
        ldr r4, =puntaje
        mov r6, #0              @contador para la longitud de puntaje

recorrePuntaje:
        ldrb r5, [r4]
        cmp r6, #2
        beq frasePuntos

        strb r5, [r3]
        add r3, #1
        add r4, #1
        add r6, #1

        b recorrePuntaje

frasePuntos:
        add r3, #1
        ldr r4, =palabraPuntos
        mov r6, #0

recorrePuntos:
        ldrb r5, [r4]
        cmp r6, #6
        beq listoFraseJugador

        strb r5, [r3]
        add r3, #1
        add r4, #1
        add r6, #1

        b recorrePuntos

listoFraseJugador:
        bl saltoDeLinea

        b abroArchivoRanking

//-------------------------------------ESCRITURA DE RANKING-----------------------------------------------

abroArchivoRanking:
        mov r7, #5              @abrimos
        ldr r0, =archivoRanking

        mov r1, #2
        mov r2, #438
        swi 0

        cmp r0, #0
        blt existeErrorRanking

        mov r6, r0
        b guardaInfoJugador

existeErrorRanking:
        mov r7, #4
        mov r0, #1
        mov r2, #26
        ldr r1, =errorLectura
        swi 0


guardaInfoJugador:
        mov r7, #19             @nos posicionamos al principio del txt
        mov r0, r6
        mov r1, #0              @seek set (al princpio)
        mov r2, #2
        swi 0

        mov r0, r6              @modificamos info del jugador
        mov r7, #4
        ldr r1, =infoJugador
        mov r2, #24
        swi 0

        mov r0, r6              @cerramos
        mov r7, #6
        swi 0

//-----------------------------POR PANTALLA EL RANKING (ultimos 3)---------------------------------

        mov r7, #5                      @abrimos nuevamente el archivo pero para lectura
        ldr r0, =archivoRanking
        mov r1, #0
        mov r2, #0
        swi 0

        mov r7, #3
        ldr r1, =espacioArchivoRanking
        mov r2, #500
        swi 0


        mov r10, #0             @contador Enters
contarEntersRanking1:
        ldrb r8, [r1]

        cmp r8, #0      @pregunta si termino el txt
        beq guardarCantEntersRanking

        cmp r8, #'\n'
        beq sumarEntersRanking

        add r1, #1
        b contarEntersRanking1

sumarEntersRanking:

        add r10, #1     @itera contador de Enters e incrementa el recorrido
        add r1, #1
        b contarEntersRanking1

guardarCantEntersRanking:

        sub r10, #3     @resto las ultimas 3 barras  del final
        ldr r11, =cantidadDeEntersRanking      @traigo la direcc donde quiero guardar el dato de las Enters

        strb r10, [r11]

        mov r10, #0     @contador de Enters
        ldrb r11, [r11] @trae el dato de cuantas Enters hay que recorrer
        ldr r1, =espacioArchivoRanking

recorrerTextoHastaEntersRanking:

        ldrb r8, [r1]
        cmp r11, r10            @r10(contador de Enters)si es igual a r11 encontro a los ultimos 3 jugadores
        beq encontroUltimos3Jugadores

        cmp r8, #'\n'
        beq hayEntersRanking

        add r1, #1
        b recorrerTextoHastaEntersRanking

hayEntersRanking:

        add r10, #1     @va contando las Enters
        add r1, #1
        b recorrerTextoHastaEntersRanking

        //al encontrar la posicion de donde empieza el primer jugador
encontroUltimos3Jugadores:
        ldr r9, =tresUltimosJugadores           @traigo la pos de memoria donde quiero guardar los tres ultimos jugadores


guardarUltimosTresJugadores:
        ldrb r8, [r1]   @cargo de nuevo la posicion en la que esta para que r8 se compare bien

        cmp r8, #0       @llego al final del txt
        beq terminaRecorrerRanking

guardarRanking:
        strb r8, [r9]
        add r1, #1      @direccion de memoria de ranking
        add r9, #1      @incremento direccion de ulrimos tres jugadores

        b guardarUltimosTresJugadores

terminaRecorrerRanking:

        mov r0, r6              @cerramos
        mov r7, #6
        swi 0

imprimoRanking:

        bl tabulacion

        mov r7, #4
        mov r0, #1
        mov r2, #8
        ldr r1, =datoDeRanking
        swi 0

        bl saltoDeLinea

        mov r7, #4
        mov r0, #1
        mov r2, #72
        ldr r1, =tresUltimosJugadores
        swi 0

        bl saltoDeLinea

        b volverAJugar

//------------------------------------------PERDIO-----------------------------------------------

pantallaPerdio:
        bl saltoDeLinea
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)

        @barra de separacion
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)
        bl tabulacion           @imprime tabulacion (centrado)
        bl separacion
        bl saltoDeLinea
        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #32
        ldr r1, =lastima
        swi 0

        bl saltoDeLinea

        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #16
        ldr r1, =visibilizacionPalabra
        swi 0

        ldr r3, =cantLetrasPalabra
        ldrb r3, [r3]

        mov r7, #4
        mov r0, #1
        mov r2, r3
        ldr r1, =palabraElegida
        swi 0

        bl saltoDeLinea
        bl saltoDeLinea

//----------------------------------------VOLVER A JUGAR-------------------------------------------

volverAJugar:
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #24
        ldr r1, =volverJugar
        swi 0

        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #13
        ldr r1, =decisionVolverJugar
        swi 0

        bl saltoDeLinea
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #3
        mov r0, #0
        mov r2, #2
        ldr r1, =decisionTomada
        swi 0

        ldr r10, =decisionTomada
        ldrb r11, [r10]

        bl tabulacion           @imprime tabulacion (centrado)

        cmp r11, #'s'
        beq quiereVolverAJugar

        cmp r11, #'n'
        beq quiereNoVolverAJugar

        b errorDecision

errorDecision:
        bl tabulacion           @imprime tabulacion (centrado)

        mov r7, #4
        mov r0, #1
        mov r2, #18
        ldr r1, =caracterInvalido
        swi 0

        bl saltoDeLinea

        b volverAJugar

quiereNoVolverAJugar:
        b fin

quiereVolverAJugar:

        bl limpiar
        b main

//-----------------------------------------------DECORACION-------------------------------------------

saltoDeLinea:
        mov r7, #4
        mov r0, #1
        mov r2, #2
        ldr r1, =espacio
        swi 0

        bx lr

tabulacion:
        mov r7, #4
        mov r0, #1
        mov r2, #10
        ldr r1, =tabulacionCen
        swi 0

        bx lr

separacion:
        mov r7, #4
        mov r0, #1
        mov r2, #61
        ldr r1, =lineaSeparacion
        swi 0

        bx lr

//-------------------------------------------------FIN-----------------------------------------------

fin:
        mov r7, #1
        swi 0
