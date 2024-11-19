.data

#podria incorporar un "presione enter para continuar"

#variables creadas por mi:

numero_categorias: .word 0

numero_animales: .word 0

opcion_menu_input: .word 0

mensaje_operacion: 	.asciiz "Se ha seleccionado la operacion: "

mensaje_error_101: 	.asciiz "Error 101: opcion seleccionada incorrecta.\n\n"
mensaje_error_201: 	.asciiz "Error 201: no hay categorias cargadas.\n\n"
mensaje_error_202: 	.asciiz "Error 202: solo hay 1 categoria cargada.\n\n"
mensaje_error_301: 	.asciiz "Error 301: no hay categorias cargadas\nNo se pudo mostrar la lista de categorias.\n\n"
mensaje_error_401: 	.asciiz "Error 401: no hay categorias cargadas.\nNo se pudo borrar una categoria.\n\n"
mensaje_error_501: 	.asciiz "Error 501: no hay categorias cargadas.\nNo se pudo anexar el objeto.\n\n"
mensaje_error_601: 	.asciiz "Error 601: no hay categorias cargadas\nNo se pudieron listar los objetos.\n\n"
mensaje_error_602: 	.asciiz "Error 602: no hay objetos cargados.\nNo se pudieron listar los objetos.\n\n"
mensaje_error_notfound: .asciiz "Error: objeto Not Found.\nNo se pudo borrar el objeto.\n\n"
mensaje_error_701: 	.asciiz "Error 701: no hay categorias cargadas.\nNo se pudo borrar el objeto.\n\n"

mensaje_test_1: .asciiz "1\n\n"
mensaje_test_2: .asciiz "2\n\n"
mensaje_test_3: .asciiz "3\n\n"
mensaje_test_4: .asciiz "4\n\n"
mensaje_test_5: .asciiz "5\n\n"
mensaje_test_6: .asciiz "6\n\n"
mensaje_test_7: .asciiz "7\n\n"
mensaje_test_8: .asciiz "8\n\n"

mensaje_pausa: .asciiz "Presione enter para continuar..."

#variables dadas:

slist: 		.word 0		#lista enlazada simple a donde voy a mandar los bloques de memoria "liberados" para ser reutilizados

cclist: 	.word 0		#puntero a la lista de categorias (fijo)

wclist: 	.word 0		#puntero a la categoria seleccionada (se mueve por la lista)

schedv: 	.space 32

menu: 		.ascii "Colecciones de objetos categorizados\n"
		.ascii "====================================\n"
		.ascii "1-Nueva categoria\n"
		.ascii "2-Siguiente categoria\n"
		.ascii "3-Categoria anterior\n"
		.ascii "4-Listar categorias\n"
		.ascii "5-Borrar categoria actual\n"
		.ascii "6-Anexar objeto a la categoria actual\n"
		.ascii "7-Listar objetos de la categoria\n"
		.ascii "8-Borrar objeto de la categoria\n"
		.ascii "0-Salir\n"
		.asciiz "Ingrese la opcion deseada: "

error: 		.asciiz "Error: "

return: 	.asciiz "\n"

catName:	.asciiz "Ingrese el nombre de una categoria: "

selCat: 	.asciiz "Se ha seleccionado la categoria: "

idObj: 		.asciiz "\nIngrese el ID del objeto a eliminar: "

objName: 	.asciiz "\nIngrese el nombre de un objeto: "

success: 	.asciiz "La operación se realizo con exito\n\n"

.text

la $t0, newcaterogy
la $t1, schedv
sw $t0, ($t1)   	

la $t0, nextcategory  	
sw $t0, 4($t1)  	

la $t0, prevcategory    
sw $t0, 8($t1)   	

la $t0, listcategories 
sw $t0, 12($t1)   	

la $t0, delcategory   
sw $t0, 16($t1)   	

la $t0, newobject      
sw $t0, 20($t1)  	

la $t0, listobjects    
sw $t0, 24($t1)   	

la $t0, delobject      
sw $t0, 28($t1)   	

main:
	#imprimo el menu de opciones
	li $v0, 4
	la $a0, menu
	syscall

	#recibo la opcion que elige el usuario:
	
	li $v0, 5
	syscall
	sw $v0, opcion_menu_input
	
	#imprimo \n
	li $v0, 4
	la $a0, return
	syscall
	
	#validacion del dato
	lw $t0, opcion_menu_input
	bgt $t0, 8, dato_invalido
	blt $t0, 1, dato_invalido

	#ejecuto la funcion aparejada a la opcion elegida
	lw $t0, opcion_menu_input      	#cargo el indice seleccionado
	subi $t0, $t0, 1		#le resto 1 al indice, ya que mis opciones van del 0 al 7, no del 1 al 8
	la $t1, schedv			#cargo la direccion de schedv
	sll $t2, $t0, 2			#multiplico por 4 bytes la opcion elegida para obtener un offset en bytes de la opcion
	add $t3, $t1, $t2		#uso el offset para sumarselo a la direccion de schedv para obtener la direccion de la funcion que se corresponde con la opcion seleccionada
	lw $t4, ($t3)			#cargo la direccion de la funcion seleccionada
	jalr $t4          	 	#salto a la función usando su dirección

	j main		#para testeo

	#fin programa
	li $v0, 10
	syscall

	dato_invalido:
	
		li $v0, 4
		la $a0, mensaje_error_101
		syscall
		
		move $t0, $ra		#preservo dir retorno
	
		jal pausa		
	
		move $ra, $t0		#restauro dir retorno
		
		j main
		

#funciones creadas por mi:

newcaterogy:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_1
	syscall

	move $s7, $ra			#preservo la direccion de retorno antes de saltar a otra funcion

	jal recibir_nombre_categoria	#recibo del usuario el nombre de la categoria

	move $a0, $v0			#copio a $a0 el return de la funcion recibir nombre, es decir, la direccion donde esta el string ingresado por el usuario con el nombre de la categoria
	la $a1, cclist			#seteo $a1 con la direccion a la lista circular
	jal insertar_nodo_doble_final	#a0 debe contener la direccion al nombre dato a insertar, $a1 debe contener el puntero a la lista y en $a2 iria el puntero al objeto, aunque probablemente lo saque ya que esa funcion la cumpliria newobject

	move $ra, $s7			#restauro la direccion de retorno a la llamada de esta funcion

	#printf se ha seleccionado la categoria tal

	jr $ra

nextcategory:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_2
	syscall

	lw $t0, wclist			#cargo la dir del nodo seleccionado

	beqz $t0, error_201		#si es null, la lista de categorias esta vacia

	lw $t0, 12($t0)#esto			#de lo contrario accedo al siguiente nodo

	beqz $t0, error_202		#si es null entonces solo hay 1 categoria

	sw $t0, wclist			#de lo contrario hay al menos 2 categorias, cargo en $t0 la categoria siguiente
	
	#printf categoria seleccionada: categoria actual
	
	li $v0, 4
	
	la $a0, selCat		#printf se ha seleccionado la cat
	syscall
	
	lw $a0, 8($t0)		#printf nombre cat
	syscall
	
	la $a0, return		#printf \n\n
	syscall

	move $t0, $ra		#preservo dir retorno
	
	jal pausa		
	
	move $ra, $t0		#restauro dir retorno

	jr $ra
	
	error_201:
	
	li $v0, 4
	la $a0, mensaje_error_201	#printf error 201 no hay ninguna categoria
	syscall
	
	move $t0, $ra
	
	jal pausa
	
	move $ra, $t0
	
	jr $ra
	
	error_202:
	
	lw $t0, wclist
	
	li $v0, 4
	la $a0, mensaje_error_202	#printf error 202 solo hay una categoria
	syscall
	
	la $a0, selCat		#printf se ha seleccionado la cat
	syscall
	
	lw $a0, 8($t0)		#printf nombre cat
	syscall
	
	la $a0, return		#printf \n\n
	syscall
	
	move $t0, $ra
	
	jal pausa
	
	move $ra, $t0
	
	jr $ra

prevcategory:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_3
	syscall

	lw $t0, wclist			#cargo la dir del nodo seleccionado

	beqz $t0, error_201		#si es null, la lista de categorias esta vacia

	lw $t0, ($t0)#esto		#de lo contrario accedo al nodo anterior

	beqz $t0, error_202		#si es null entonces solo hay 1 categoria

	sw $t0, wclist			#de lo contrario hay al menos 2 categorias, cargo en $t0 la categoria anterior
	
	#printf categoria seleccionada: categoria actual
	
	li $v0, 4
	
	la $a0, selCat		#printf se ha seleccionado la cat
	syscall
	
	lw $a0, 8($t0)		#printf nombre cat
	syscall
	
	la $a0, return		#printf \n\n
	syscall

	move $t0, $ra		#preservo dir retorno
	
	jal pausa		
	
	move $ra, $t0		#restauro dir retorno

	jr $ra

listcategories:

li $v0, 4
la $a0, mensaje_operacion
syscall

la $a0, mensaje_test_4
syscall

jr $ra

delcategory:

li $v0, 4
la $a0, mensaje_operacion
syscall

la $a0, mensaje_test_5
syscall

jr $ra

newobject:

li $v0, 4
la $a0, mensaje_operacion
syscall

la $a0, mensaje_test_6
syscall

jr $ra

listobjects:

li $v0, 4
la $a0, mensaje_operacion
syscall

la $a0, mensaje_test_7
syscall

jr $ra

delobject:

li $v0, 4
la $a0, mensaje_operacion
syscall

la $a0, mensaje_test_8
syscall

jr $ra

insertar_nodo_doble_final: #a0 debe contener la direccion al nombre dato a insertar, $a1 debe contener el puntero a la lista y en $a2 iria el puntero al objeto, aunque probablemente lo saque ya que esa funcion la cumpliria newobject
		
	move $s6, $ra			#preservo la direccion de retorno antes de saltar a otra funcion
	move $s5, $a0			#preservo el valor de $a0 que es un argumento de la funcion y puede ser modificado por smalloc
	
	jal smalloc			#retorna en $v0 la direccion de memoria del bloque de 16 bytes asignado
	
	move $ra, $s6			#restauro la direccion de retorno a la llamada de esta funcion
	move $a0, $s5			#restauro el valor de $a0
		
	sw $a0, 8($v0)			#guardo el nombre de la categoria en la tercera word del bloque de memoria asignado
	lw $t1, ($a1)	#revisar	#cargo en $t1 la direccion al primer nodo de la lista
	
	beq $t1, $0, primer_nodo	#si la direccion es 0, es decir, null, es el primer nodo esto funciona como un if(nodo == null)
	
	lw $t2, 12($t1)			#tengo que ver si el primer nodo apunta a null
	
	beq $t2, $0, segundo_nodo	#beq si el siguiente nodo es null, entonces voy a segundo nodo
	
	lw $t3, ($t1)			#cargo dir_nodo_viejo.anterior en $s5
	
	sw $v0, 12($t3)			#siguiente del ultimo nodo anterior es nuevo nodo
	 
	sw $0, 4($v0)#lo seteo a null, luego se llenara con un objeto o no#posiblemente se borre, ya que esta funcion la cumpliria newobject			#guardo en la segunda word el puntero a lista enlazada de animal o un puntero a null si estoy creando una instancia de un animal
	
	sw $t3, ($v0)			#guardo el ultimo nodo anterior como anterior del nuevo nodo
	
	sw $t1, 12($v0)			#guardo como siguiente de nuevo nodo al primer nodo
	
	sw $v0, ($t1)			#guardo como anterior del primer nodo al nuevo ultimo nodo
	
	#test imprimo la palabra contenida en en nodo como dato, en la direccion 8($v0)
	move $t7, $v0
	li $v0, 4
	lw $a0, 8($t7)
	syscall
	move $v0, $t7
	#borrar test luego
	
	jr $ra				#regreso a instruccion luego de jal en main	
										
	primer_nodo:

		sw $0, ($v0)		#guardo 0 representando NULL como nodo anterior en la primera word
		sw $0, 4($v0)#lo seteo a null, luego se llenara con un objeto o no#posiblemente se borre		#guardo en la segunda word el puntero a lista enlazada de animal o un puntero a null si estoy creando una instancia de un animal
		sw $0, 12($v0)		#guardo 0 representando NULL como nodo siguiente en la cuarta word
		sw $v0, ($a1)#revisar	#guardo la nueva direccion de la lista enlazada que apunta al primer nodo
		
		sw $v0, wclist		#seteo la categoria seleccionada al primer nodo
		
		#test imprimo la palabra contenida en en nodo como dato, en la direccion 8($v0)
		move $t7, $v0
		li $v0, 4
		lw $a0, 8($t7)
		syscall
		move $v0, $t7
		#borrar test luego
		
		jr $ra			#regreso a instruccion luego de jal en main

	segundo_nodo:
		
		sw $t1, ($v0)		#guardo la direccion del primer nodo como nodo anterior en la primera word
		sw $0, 4($v0)#lo seteo a null, luego se llenara con un objeto o no#posiblemente se borre		#guardo en la segunda word el puntero a lista enlazada de animal o un puntero a null si estoy creando una instancia de un animal
		sw $t1, 12($v0)		#guardo la direccion del primer nodo como nodo siguiente en la cuarta word
		
		sw $v0, ($t1)
		sw $v0, 12($t1)
		
		#test imprimo la palabra contenida en en nodo como dato, en la direccion 8($v0)
		move $t7, $v0
		li $v0, 4
		lw $a0, 8($t7)
		syscall
		move $v0, $t7
		#borrar test luego
		
		jr $ra			#regreso a instruccion luego de jal en main

	
#fin insertar_nodo_doble_final


recibir_nombre_categoria:
	
	move $s6, $ra			#preservo $ra
	
	jal smalloc			#recivo en $v0 la direccion a un bloque de 16 bytes para escribir la palabra
		
	move $ra, $s6			#restauro $ra
	move $t7, $v0			#preservo la direccion obtenida de smalloc
	
	#mensaje ingrese nombre categoria
	li $v0, 4
	la $a0, catName
	syscall
	
	li $v0, 8			#codigo para que syscall lea un string
	li $a1, 16			#max char de lectura
	move $a0, $t7			#cargo en $a0 la direccion donde se va a escribir el string que ingrese el usuario
	syscall
	
	li $v0, 4
	la $a0, return
	syscall
	
	#aumento en 1 el numero de categorias
		
	lw $t0, numero_categorias
		
	addi $t0, $t0, 1
		
	sw $t0, numero_categorias
	
	#test imprimo la palabra contenida en $t7
	li $v0, 4
	move $a0, $t7
	syscall
	#borrar test luego
	
	move $v0, $t7	#pongo la direccion en $v0, el retorno de la funcion
	jr $ra		#retorno a siguiente instruccion donde se llamo esta funcion
	
#fin recibir_nombre_categoria:

pausa:
	li $v0, 4
	la $a0, mensaje_pausa
	syscall
	
	li $v0, 12
	syscall
	
	li $v0, 4
	la $a0, return
	syscall
	
	jr $ra
	

#funciones dadas:
smalloc:	#devuelve en $v0 la direccion de la memoria asignada
	lw $t0, slist	#carga el valor guardado en slist, que seria una direccion a un nodo de 16 bytes guardado en ella
	beqz $t0, sbrk	#si es null, quiere decir que la lista esta vacia, en cuyo caso reservo memoria
	move $v0, $t0	#si no es null, entonces muevo esa direccion de memoria a $v0 que seria el return de la funcion
	lw $t0, 12($t0)	#avanzo al siguiente nodo de la lista enlazada simple, es decir, cuando ingrese un nodo a la lista tengo que asegurarme de apuntar al siguiente nodo en la ultima "palabra" del nodo
	sw $t0, slist	#guardo la direccion del nuevo primer nodo de la lista para ser usado en la proxima llamada
	jr $ra

	sbrk:
		li $a0, 16 	# node size fixed 4 words
		li $v0, 9
		syscall 	# return node address in v0
		jr $ra

sfree: #debe contener en $a0 la direccion del nodo que se va a "liberar"
	lw $t0, slist		#cargo el valor guardado en slist, es decir, la direccion del primer nodo de la lista
	sw $t0, 12($a0)		#pongo la direccion del anterior primer nodo de la lista en la ultima palabra del nodo a liberar, es decir, estoy insertando al frente de la lista el nodo que se libera
	sw $a0, slist 		#actualizo la direccion de la lista para que apunte al nuevo primer nodo
	jr $ra

