.data

#TAREAS PENDIENTES:

#1) Testear mejor

#2) Arreglar comentarios

#3) Reformatear registros usados, si vale la pena, cambiar los temporales por los s donde corresponda

#4) Agregar mas mensajes de confirmacion de acciones y pausas donde correspondan, y arreglar el mensaje que se imprime con la segunda categoria que no deberia aparecer

#5) Repasar todos los requerimientos y ver que falta implementar.

#variables creadas por mi:

numero_categorias: 	.word 0

numero_animales: 	.word 0

opcion_menu_input: 	.word 0

indicador:		.asciiz "Categoria seleccionada > "

mensaje_operacion: 	.asciiz "Se ha seleccionado la operacion: "

mensaje_error_101: 	.asciiz "Error 101: opcion seleccionada incorrecta.\n\n"
mensaje_error_201: 	.asciiz "Error 201: no hay categorias cargadas.\n\n"
mensaje_error_202: 	.asciiz "Error 202: solo hay 1 categoria cargada.\n\n"
mensaje_error_301: 	.asciiz "Error 301: no hay categorias cargadas. No se pudo mostrar la lista de categorias.\n\n"
mensaje_error_401: 	.asciiz "Error 401: no hay categorias cargadas. No se pudo borrar una categoria.\n\n"
mensaje_error_501: 	.asciiz "Error 501: no hay categorias cargadas. No se pudo anexar el objeto.\n\n"
mensaje_error_601: 	.asciiz "Error 601: no hay categorias cargadas. No se pudieron listar los objetos.\n\n"
mensaje_error_602: 	.asciiz "Error 602: no hay objetos cargados. No se pudieron listar los objetos.\n\n"
mensaje_error_notfound: .asciiz "Error: objeto Not Found.\nNo se pudo borrar el objeto.\n\n"
mensaje_error_701: 	.asciiz "Error 701: no hay categorias cargadas. No se pudo borrar el objeto.\n\n"

mensaje_test_1: 	.asciiz "1\n\n"
mensaje_test_2: 	.asciiz "2\n\n"
mensaje_test_3: 	.asciiz "3\n\n"
mensaje_test_4: 	.asciiz "4\n\n"
mensaje_test_5: 	.asciiz "5\n\n"
mensaje_test_6: 	.asciiz "6\n\n"
mensaje_test_7: 	.asciiz "7\n\n"
mensaje_test_8: 	.asciiz "8\n\n"

mensaje_pausa: 		.asciiz "Presione enter para continuar..."

mensaje_lista_categorias: .asciiz "Lista de las categorias cargadas:\n\n"
mensaje_lista_objetos: .asciiz "Lista de los objetos cargados:\n\n"

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

idObj: 		.asciiz "Ingrese el ID del objeto a eliminar: "

objName: 	.asciiz "Ingrese el nombre de un objeto: "

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
		
		addiu $sp, $sp, -4
		sw $ra, 4($sp)
		
		jal pausa		
	
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		j main
		

#funciones creadas por mi:

newcaterogy:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_1
	syscall

	addiu $sp, $sp, -4
	sw $ra, 4($sp)	

	#mensaje ingrese nombre categoria
	la $a0, catName
	syscall

	jal recibir_nombre		#recibo del usuario el nombre de la categoria

	move $a0, $v0			#copio a $a0 el return de la funcion recibir nombre, es decir, la direccion donde esta el string ingresado por el usuario con el nombre de la categoria
	la $a1, cclist			#seteo $a1 con la direccion a la lista circular
	la $a2, wclist
	jal insertar_nodo_doble_final	#a0 debe contener la direccion al nombre dato a insertar, $a1 debe contener el puntero a la lista y en $a2 iria el puntero al objeto, aunque probablemente lo saque ya que esa funcion la cumpliria newobject

	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	lw $t0, numero_categorias

	bne $t0, 1, no_es_primer_categoria

	#si es la unica categoria, entonces imprimo que es la categoria seleccionada

	lw $t0, wclist
	
	li $v0, 4
	
	la $a0, selCat
	syscall
	
	lw $a0, 8($t0)
	syscall
	
	la $a0, return
	syscall

	no_es_primer_categoria:

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

	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra
	
	error_201:
	
	li $v0, 4
	la $a0, mensaje_error_201	#printf error 201 no hay ninguna categoria
	syscall
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
			
	jal pausa
			
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
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
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
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

	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra

listcategories:
	#aca hay un error, si cargo categorias y luego las borro y trato de listar una lista vacia, en vez de ir al error, explota
	li $v0, 4
	la $a0, mensaje_operacion		#printf operacion selecionada
	syscall

	la $a0, mensaje_test_4			#printf num op selec
	syscall

	lw $t0, cclist		#cargo el "primer" nodo de la lista
	lw $t1, cclist
	
	beqz $t0, error_301
	
	li $v0, 4
	la $a0, mensaje_lista_categorias	#printf Lista categorias cargadas:
	syscall
	
	loop_lista:
		#hacer un if que si es la cat seleccionada, wclist, imprima un > para mostrarla
		
		lw $t7, wclist
		bne $t1, $t7, no_es_cat_selec
		
		la $a0, indicador
		syscall
		
		no_es_cat_selec:
		
		lw $a0, 8($t1)		#cargo el nombre de la categoria guardado en el nodo
		syscall			#printf nombre cat en el nodo actual
	
		la $a0, return		
		syscall			#printf \n
	
		lw $t1, 12($t1)		#cargo en $t1 la dir del siguiente nodo
		
		beqz $t1, fin_list_categories	#si el siguiente es null, es porque solo hay 1 categoria, en cuyo caso rompo el loop
		bne $t0, $t1, loop_lista	#cuando vuelvo al nodo del que empece, rompo el loop

	fin_list_categories:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	error_301:
		
		li $v0, 4
		la $a0, mensaje_error_301
		syscall
		
		addiu $sp, $sp, -4
		sw $ra, 4($sp)	
		
		jal pausa
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		jr $ra

delcategory:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_5
	syscall

	lw $s0, wclist			#cargo la dir del nodo seleccionado
	lw $t3, numero_categorias
	
	#if $t0 == NULL entonces error 401, no hay categorias cargadas
	beqz $s0, error_401		#si el nodo es nulo, entonces no hay categorias cargadas
	
	#if 4($t0) not null, entonces free 4($t0), esto es una lista enlazada doble circular, asique hay que recorrer toda la lista y liberar cada nodo, podria hacerlo de manera recursiva con un llamado a esta misma funcion, en caso de que sea posible, o un llamado a delobject que se define despues
	
	lw $t1, 4($s0)
	
	beqz $t1, object_null
	
	move $t4, $t1
	
	loop_delet_obj:
	
		addiu $sp, $sp, -4
		sw $ra, 4($sp)
	
		lw $a0, 8($t4)	#free nodo.nombre
	
		jal sfree
	
		lw $s1, 12($t4)
	
		move $a0, $t4		#free nodo
		
		jal sfree
	
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		move $t4, $s1
		
		beqz $t4, fin_delet_obj
		beq $t1, $t4, fin_delet_obj
		
		
		
		j loop_delet_obj
		
	fin_delet_obj:
		
	
	#ESTO FALTA
	
	#tengo que recorrer toda la lista doble enlazada object y liberar cada nodo
	
	object_null:
	
	li $t1, 0
	
	sw $t1, 4($s0)		#lo seteo a 0 para que no haya ningun dato basura
	
	#if 8($t0) not null entonces free 8($t0), esto es un nodo que contiene el nombre de la categoria cargado
	
	lw $t1, 8($s0)
	
	beqz $t1, cat_null
	
	#si cat no es null, libero el nodo
	
	move $a0, $t1
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal sfree	#libero el nodo
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	cat_null:
	
		lw $s0, wclist
	
		li $t1, 0
	
		sw $t1, 8($s0)		#lo seteo a 0 para que no haya ningun dato basura
	
		#if 12($t0) == null entonces free $t0, es el unico nodo que hay, se actualizan cclist y wclist en null
	
		lw $t1, 12($s0)
	
		bnez $t1, no_es_unico_nodo
		
		#ACA CONTINUAR TESTEO PASO A PASO -----------------
		
		#aca adentro, $t0 es el unico nodo, debe quedar vacio
			#si es el unico nodo entonces solamente free($t0) y setear ($t0), 12($t0), cclist y wclist a null,
	
		
		move $a0, $s0
		
		addiu $sp, $sp, -4
		sw $ra, 4($sp)	
		
		jal sfree	#libero el nodo
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
	
		li $t1, 0
	
		lw $s0, wclist
		sw $t1, ($s0)		#seteo a null el puntero al anterior
		#sw $t1, 12($t0)#no lo puedo setear a 0 porque ya se guardo la direccion del siguiente nodo en slist		#seteo a null el puntero al siguiente

		sw $0, wclist
		sw $0, cclist	#como borre el unico nodo, cclist y wclist son null
	
		lw $s0, numero_categorias
	
		addi $s0, $s0, -1
	
		sw $s0, numero_categorias

		jr $ra
					
	no_es_unico_nodo:	#hasta aca esta todo "chequeado" 
	
	lw $t3, numero_categorias
	
	bgt $t3, 2, hay_mas_de_2_categorias
	
	#aca tengo que chequear si solo hay 2 nodos, en cuyo caso asigno null a anterior y a siguiente del unico nodo que queda
	
	#en t0 tengo el nodo a borrar, wclist
	
	#en t1 tengo el siguiente nodo al que borro
	
	#if wclist == cclist entonces estoy borrando el primer nodo y debo asignar cclist al siguiente
	
	lw $t2, cclist
	
	bne $s0, $t2, no_borro_primer_nodo
	
	#borro el primer nodo de clist	
	sw $t1, cclist		#actualizo el puntero que ahora apunta al otro nodo
	sw $t1, wclist
	
	sw $0, ($t1)		#anterior es null
	sw $0, 12($t1)		#siguiente es null
	
	
	move $a0, $s0
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal sfree	#libero el nodo
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	no_borro_primer_nodo:
	
	#de lo contrario, no actualizo el puntero cclist
	
	#asigno null al anterior y al siguiente
	
	
	move $a0, $s0
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
		
	jal sfree	#libero el nodo
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	sw $t1, wclist
	
	sw $0, ($t1)
	sw $0, 12($t1)
	
	jr $ra
	
	hay_mas_de_2_categorias:
	
	#en t1 tengo 12($t0), la direccion del siguiente nodo
	#en t0 tengo wclist
	
		lw $t2, cclist
	#if cclist == wclist quiere decir que estoy eliminando el primer nodo, entonces actualizo cclist = 12($t0)
		bne $t2, $s0, no_elimino_primer_nodo	#branch si cclist es distinto a wclist, y si son iguales entonces la cabecera de la lista la reasigno

		sw $t1, cclist		#reasigno el primer nodo de la lista al siguiente
	
	no_elimino_primer_nodo:
	
		sw $t1, wclist
		
		#en $t0 tengo el nodo a eliminar, en $t1 tengo el nuevo primer nodo
		
		lw $t2, ($s0)
		
		sw $t2, ($t1)		#el anterior del nuevo primer nodo debe ser igual al anterior del viejo primer nodo	
	
		#lw $t2, ($t0) #repetido?		#cargo en t2 el anterior del viejo primer nodo
	
		sw $t1, 12($t2)		#guardo en el siguiente del anterior del viejo primer nodo al nuevo primer nodo
					#el siguiente del anterior del anterior primer nodo debe ser el nuevo primer nodo
		
		move $a0, $s0
		
		addiu $sp, $sp, -4
		sw $ra, 4($sp)	
		
		jal sfree	#libero el nodo
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		sw $0, ($s0)

	#restar 1 a numero_categorias
		
		lw $t2, numero_categorias
		addi $t2, $t2, -1
		sw $t2, numero_categorias
		
		#imprimir que categoria esta seleccionada ahora
		
		jr $ra
	
	error_401:
	
		li $v0, 4
		la $a0, mensaje_error_401
		syscall
		
		addiu $sp, $sp, -4
		sw $ra, 4($sp)	
		
		jal pausa
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		jr $ra
	

newobject:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_6
	syscall
	
	la $a0, objName
	syscall

	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	
	jal recibir_nombre		#devuelve en $v0 la direccion de memoria que apunta al nombre ingresado por el usuario
	
	move $a0, $v0
	
	lw $t0, wclist			#en $a1 debe estar el puntero a la lista, es decir, 4(wclist)
	la $a1, 4($t0)
	li $a2, 0
	
	jal insertar_nodo_doble_final	#requiere en $a0 la direccion al nombre del nodo, y en $a1 la direccion del puntero a la lista
	
	lw $t0, wclist	
	lw $a0, 4($t0)
	
	jal actualizar_ids
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra

listobjects:

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_7
	syscall

	lw $t0, wclist
	beqz $t0, no_hay_categorias
	lw $t0, 4($t0)	#accedo a la lista de objetos
	beqz $t0, no_hay_objetos
	move $t1, $t0
	
	li $v0, 4
	la $a0, mensaje_lista_objetos
	syscall
	
	loop_list_obj:
	
		li $v0, 4
		lw $a0, 8($t1)
		syscall
		
		la $a0, return
		syscall
		
		lw $t1, 12($t1)
		beqz $t1, finloop_list_obj
		beq $t0, $t1, finloop_list_obj
		j loop_list_obj
	
	finloop_list_obj:

	jr $ra
	
	no_hay_categorias:
	
	li $v0, 4
	la $a0, mensaje_error_601
	syscall
	
	jr $ra
	
	no_hay_objetos:
	
	li $v0, 4
	la $a0, mensaje_error_602
	syscall
	
	jr $ra

delobject:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_8
	syscall

	la $a0, idObj
	syscall
	
	li $v0, 5
	syscall
	
	move $a1, $v0
	
	li $v0, 4
	la $a0, return
	syscall

	#hacer funcion borrar nodo
	
	lw $t0, wclist
	
	beqz $t0, error_701
	
	la $a0, 4($t0)
	
	#en $a0 va direccion a donde esta guardado puntero a lista
	#en $a1 va ID a eliminar
	jal borrar_nodo_obj
	#recordar llamar a actualizar ids

	#en a0 debe estar la dir al primer nodo
	lw $t0, wclist
	lw $a0, 4($t0)
	
	jal actualizar_ids

	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra
	
	error_701:
	
	li $v0, 4
	la $a0, mensaje_error_701
	syscall
	
	jr $ra

insertar_nodo_doble_final: #a0 debe contener la direccion al nombre dato a insertar, $a1 debe contener el puntero a la lista y en $a2 iria el puntero al objeto, aunque probablemente lo saque ya que esa funcion la cumpliria newobject
			
	addiu $sp, $sp, -4
	sw $ra, 4($sp)			#preservo la direccion de retorno antes de saltar a otra funcion
				
	move $s5, $a0			#preservo el valor de $a0 que es un argumento de la funcion y puede ser modificado por smalloc
	
	jal smalloc			#retorna en $v0 la direccion de memoria del bloque de 16 bytes asignado
				
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

	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra				#regreso a instruccion luego de jal en main	
										
	primer_nodo:
		
		sw $0, ($v0)		#guardo 0 representando NULL como nodo anterior en la primera word
		sw $0, 4($v0)#lo seteo a null, luego se llenara con un objeto o no#posiblemente se borre		#guardo en la segunda word el puntero a lista enlazada de animal o un puntero a null si estoy creando una instancia de un animal
		sw $0, 12($v0)		#guardo 0 representando NULL como nodo siguiente en la cuarta word
		sw $v0, ($a1)#revisar	#guardo la nueva direccion de la lista enlazada que apunta al primer nodo
		
		#deberia imprimir "categoria seleccionada: nombre_cat" al crear el primer nodo
		#aca para evidenciar esto
		
		beqz $a2, no_wclist
		
		sw $v0, ($a2)	#chequear si anda bien		#seteo la categoria seleccionada al primer nodo
		
		no_wclist:
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
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
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
			
		jr $ra			#regreso a instruccion luego de jal en main

	
#fin insertar_nodo_doble_final


recibir_nombre:
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)			#preservo $ra
	
	jal smalloc			#recivo en $v0 la direccion a un bloque de 16 bytes para escribir la palabra
				
	move $t7, $v0			#preservo la direccion obtenida de smalloc
	
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
	
	move $v0, $t7	#pongo la direccion en $v0, el retorno de la funcion
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra		#retorno a siguiente instruccion donde se llamo esta funcion
	
#fin recibir_nombre_categoria:

actualizar_ids:		#recibe en $a0 la direccion al primer nodo de una lista de objetos

	beqz $a0, final_act_ids

	move $t0, $a0	
	
	li $t1, 1
	
	loopp:
	
		sw $t1, 4($t0)
		
		addi $t1, $t1, 1
		
		lw $t0, 12($t0)
		
		beqz $t0, final_act_ids
		
		beq $t0, $a0, final_act_ids
	
		j loopp
		
	final_act_ids:

	jr $ra

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
	
borrar_nodo_obj:	#recivo en $a0 la direccion del primer nodo de la lista de objetos, recibo en $a1 el ID del objeto a borrar
	
	move $s7, $a0		#cargo en s7 la direccion de donde esta guardado el puntero a la lista para poder modificarlo
	
	lw $s0, ($a0)		#cargo en s0 el puntero al primer elemento de la lista
	move $t0, $s0		#copio en t0 el puntero al primer elemento de la lista 
	
	looop:
		
		lw $t1, 4($t0)
		
		beq $t1, $a1, finlooop
		
		lw $t0, 12($t0)
		
		beqz $t0, not_found
		beq $t0, $s0, not_found
		
		#lw $t1, 4($t0)
		
		#beq $t1, 1, not_found		#si doy una vuelta completa y vuelvo a id ==1 entonces notfound
		
		j looop
	
	finlooop:
		move $s0, $t0
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)

	#tengo que liberar el nombre del nodo primero
	
	move $a0, $s0
	
	beqz $s0, nodo_esnull
	
	lw $a0, 8($s0)
	
	beqz $a0, nombre_esnull
	
	jal sfree
	
	nombre_esnull:
	
	lw $a0, 12($s0)
	
	beqz $a0, unico_nodo		#si el nodo no es null y si el siguiente es null, es porque es el unico nodo
	
	#luego tengo que cablear el anterior al nodo con el siguiente al nodo
	
	lw $t0, ($s0)		#cargo en t0 la direccion del nodo anterior al que voy a borrar
	lw $t1, 12($s0)		#cargo en t1 la direccion del nomo siguiente al que voy a borrar
	
	lw $t3 4($s0)
	
	bne $t3, 1, no_borro_primero
	
	sw $t1, ($s7)	#aca tengo que guardarlo en el primer lugar de la lista enlazada		#actualizo el puntero a la lista como el nuevo primer nodo
	
	no_borro_primero:
	
	beq $t0, $t1, solo_dos_nodos	#si el anterior y el siguiente de un nodo son iguales, es porque solo hay 2 nodos
	
	sw $t1, 12($t0)		#el siguiente del anterior es el siguiente del nodo a borrar
	sw $t0, ($t1)		#el anterior del siguiente al que borro es el anterior del nodo a borrar
	
	#luego libero el nodo
	
	move $a0, $s0
	jal sfree
	
	nodo_esnull:
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra

	unico_nodo:
	
	move $a0, $s0
	
	jal sfree
	
	sw $0, ($s7)#corregir que guarde 0 en el lugar que corresponde		#como borre el unico nodo, seteo a null
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	solo_dos_nodos:
	
	sw $0, ($t0)
	sw $0, 12($t0)
	
	move $a0, $s0
	
	jal sfree
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	not_found:
	
	li $v0, 4
	la $a0, mensaje_error_notfound
	syscall
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
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
	sw $0, ($a0)
	sw $0, 4($a0)
	sw $0, 8($a0)
	sw $0, 12($a0)
	
	lw $t0, slist		#cargo el valor guardado en slist, es decir, la direccion del primer nodo de la lista
	sw $t0, 12($a0)		#pongo la direccion del anterior primer nodo de la lista en la ultima palabra del nodo a liberar, es decir, estoy insertando al frente de la lista el nodo que se libera
	sw $a0, slist 		#actualizo la direccion de la lista para que apunte al nuevo primer nodo
	jr $ra
