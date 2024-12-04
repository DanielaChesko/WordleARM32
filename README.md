Para este proyecto utilice el cliente de Putty conectado a un servidor de mi universidad.
Este es el desarrollo e ideas que tuve al principio para poder empezar a desarrollarlo. 
Aviso: Las variables y nombres de las etiquetas fueron cambiando en el transcurso de las implementaciones.

PROCESO DEL PROGRAMA:

- LEER EL ARCHIVO EXTERNO
Para elegir la palabra al azar en cada partida.
Se le pide al usuario un numero del 1 al 99 para poder elegir la palabra “sorteada”
leer_palabras: Leer palabras del archivo .txt y guardarlas en una lista integrada.
sortear_palabra: Elige una palabra “sorteada” de la lista de palabras en memoria.

- INFORMAR CUANTAS LETRAS CONTIENE LA PALABRA
calcular_letras: cuenta la cantidad de letras que tiene la palabra.
calcular_letras_mostrar: avisa al usuario cuantas letras tiene la palabra.

cont = 0						

						if (letra != ASCIIDeLaBarra)
							cont ++
						if(letra == ASCIIDeLaBarra)
							break

						sysout cont
- SOLICITA AL JUGADOR UNA PALABRA
Tiene que tener la cantidad de letras avisada anteriormente!
CICLO hasta que:
        1) Adivine la palabra.
        2) Se termina la cantidad de intentos 5.
leer_palabra: Lee la palabra ingresada por el usuario.
calcular_letras_ingresadas: calcula la cantidad de letras ingresadas por el usuario.

								solicita al usuario una palabra

								if (calcular_letras == calcular_letras_ingresadas)
									if (sortear_palabra == leer_palabra)
										mostrar pantalla que ganó
									if(sortear_palabra != leer_palabra)
										if (calcular_puntos <=0)
											mostrar pantalla que perdió
										else
											verificar letras
								else:
									vuelve a solicitar al usuario una palabra

- VERIFICA LETRAS DE LA PALABRA

verificar_letras_verdes: verifica que el carácter sean iguales y estén en la misma posición.
verificar_letras_amarillas: verifica que el carácter sean iguales y no están en la posición.
verificar_letras_rojas: verifica que no sean verdes o amarillas, si termina de recorrer se pone roja.

E imprime las letras con su color específico.
informar_resultado: informa por pantalla el resultado de la palabra ingresada, mostrando las letras con el color que corresponde.

    string resultado
  
	while (calcular_puntos > 0)
		for( i = 0, i <= length.calcular_letras, i++)
			for ( a=0, i <= length.calcular_letras_ingresadas, a++)
    if(letraPalabra == letraIngresada && letraPalabraPosicion ==                     letraIngresadaPosicion)
    devolver letra verde en resultado

    if(letraPalabra == letraIngresada && letraPalabraPosicion !=                     letraIngresadaPosicion)
    devolver letra amarilla en resultado

    if(letraPalabra != letraIngresada)
    devolver letra roja en resultado
		
				sysout resultado	

- SI ADIVINA
Muestra el puntaje, pide el nombre de jugador, muestra el ranking y pregunta si quiere volver a jugar.
calcular_puntos y verificar_intentos: cantidad de letras de la palabra * intentos restantes.
pedir_nombre y guardar_ranking: solicita el nombre al usuario para luego guardarlo en el ranking.
mostrar_ranking: se abre el ranking de los últimos 3 jugadores inclusive este último (nombreJugador + puntaje + “puntos”)
volver_a_jugar: pregunta al usuario si quiere volver a jugar. (S _ SI / N _ NO)
						
						sysout ¡FELICITACIONES HAS GANADO!
		
						sysout “Tu puntaje fue”: + calcular_puntos

						sysout “Ingresa tu nombre: ” + pedir_nombre

						sysout “RANKING”
						sysout ranking.txt

						sysout ¿Desea volver a jugar?
									S _ Si
									N _ No
								volver_a_jugar

- SI PIERDE
		volver_a_jugar: pregunta al usuario si quiere volver a jugar. (S _ SI / N _ NO)

						sysout Que lástima… ¡Has perdido! :c

								sysout La palabra era + sortear_palabra
			
								sysout ¿Desea volver a jugar?
									S _ Si
									N _ No
								volver_a_jugar



PANTALLAS DEL PROGRAMA
	GENERAL:

	¡BIENVENIDO A WORDLE!
	
	La cantidad de letras de la palabra a adivinar es X

	Ingrese una palabra: marco
	marco
	…

GANA:

	
	¡FELICITACIONES HAS GANADO!

	Tu puntaje fue: X

	Ingresa tu nombre: X

	RANKING:
	nombre X puntos
	nombre X puntos
	nombre X puntos

	¿Desea volver a jugar?
	S _ Si
	N _ No


PIERDE:

	Que lástima… ¡Has perdido! :c
	
	La palabra era X
	
	¿Desea volver a jugar?
	S _ Si
	N _ No
