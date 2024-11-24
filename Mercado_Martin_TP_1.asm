.data

#variables creadas por mi:

numero_categorias: 	.word 0

opcion_menu_input: 	.word 0

indicador:		.asciiz "> "

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

mensaje_error_nullobj:	.asciiz "Error, no hay objetos cargados.\n\n"

mensaje_test_1: 	.asciiz "1\n\n"
mensaje_test_2: 	.asciiz "2\n\n"
mensaje_test_3: 	.asciiz "3\n\n"
mensaje_test_4: 	.asciiz "4\n\n"
mensaje_test_5: 	.asciiz "5\n\n"
mensaje_test_6: 	.asciiz "6\n\n"
mensaje_test_7: 	.asciiz "7\n\n"
mensaje_test_8: 	.asciiz "8\n\n"

mensaje_pausa: 		.asciiz "Presione enter para continuar..."

mensaje_cat_borrada:	.asciiz "Se ha eliminado la categoria: "
mensaje_objt_borrado:	.asciiz "Se ha eliminado el objeto: "
mensaje_lista_objetos:	.asciiz "Lista de los objetos cargados:\n\n"
mensaje_lista_categorias: .asciiz "Lista de las categorias cargadas:\n\n"


#variables dadas:

slist: 		.word 0		#lista enlazada simple a donde voy a mandar los bloques de memoria "liberados" para ser reutilizados

cclist: 	.word 0		#puntero a la lista de categorias (fijo)

wclist: 	.word 0		#puntero a la categoria seleccionada (se mueve por la lista)

schedv: 	.space 32	#vector que va a contener las direcciones de las funciones que se van a ejecutar

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

return: 	.asciiz "\n"

catName:	.asciiz "Ingrese el nombre de una categoria: "

selCat: 	.asciiz "Se ha seleccionado la categoria: "

idObj: 		.asciiz "Ingrese el ID del objeto a eliminar: "

objName: 	.asciiz "Ingrese el nombre de un objeto: "

success: 	.asciiz "La operación se realizo con exito\n\n"

.text

#cargo schedv con las direcciones a todas las funciones
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
	
	#validacion del dato ingresado
	
	lw $t0, opcion_menu_input
	bgt $t0, 8, dato_invalido
	blt $t0, 0, dato_invalido

	#ejecuto la funcion aparejada a la opcion elegida
	
	lw $t0, opcion_menu_input      	#cargo el indice seleccionado
	beqz $t0, fin_programa		#si la opcion seleccionada es 0 termino el programa
	subi $t0, $t0, 1		#le resto 1 al indice, ya que mis opciones van del 0 al 7, no del 1 al 8
	la $t1, schedv			#cargo la direccion de schedv
	sll $t2, $t0, 2			#multiplico por 4 bytes la opcion elegida para obtener un offset en bytes de la opcion
	add $t3, $t1, $t2		#uso el offset para sumarselo a la direccion de schedv para obtener la direccion de la funcion que se corresponde con la opcion seleccionada
	lw $t4, ($t3)			#cargo la direccion de la funcion seleccionada
	jalr $t4          	 	#salto a la función usando su dirección

	j main				#loop principal del programa

	fin_programa:
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

	addiu $sp, $sp, -4		#preservo la direccion de retorno
	sw $ra, 4($sp)	

	li $v0, 4
	la $a0, mensaje_operacion	#muestro la opcion seleccionada
	syscall

	la $a0, mensaje_test_1
	syscall

	la $a0, catName			#mensaje ingrese nombre categoria
	syscall

	jal recibir_nombre		#recibo del usuario el nombre de la categoria

	lw $t0, numero_categorias	#actualizo el numero de categorias
	addi $t0, $t0, 1
	sw $t0, numero_categorias

	move $a0, $v0			#copio a $a0 el return de la funcion recibir nombre, es decir, la direccion donde esta el string ingresado por el usuario con el nombre de la categoria
	la $a1, cclist			#seteo $a1 con la direccion a la lista circular
	la $a2, wclist			#seteo $a2 con la direccion a el nodo seleccionado de la lista
	jal insertar_nodo_doble_final
	
	lw $t0, numero_categorias

	bne $t0, 1, no_es_primer_categoria	#si es la unica categoria, entonces imprimo que es la categoria seleccionada

	lw $t0, wclist
	
	li $v0, 4
	
	la $a0, selCat
	syscall				
		
	lw $a0, 8($t0)
	syscall
	
	la $a0, return
	syscall
	
	jal pausa

	no_es_primer_categoria:

	li $v0, 4
	la $a0, success
	syscall
	
	jal pausa

	lw $ra, 4($sp)			#restauro la direccion de retorno
	addiu $sp, $sp, 4		#restauro sp

	jr $ra

nextcategory:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)			#preservo la direccion de retorno en el stack

	li $v0, 4
	la $a0, mensaje_operacion	#muestro la opcion seleccionada
	syscall

	la $a0, mensaje_test_2
	syscall

	lw $t0, wclist			#cargo la dir del nodo seleccionado

	beqz $t0, error_201		#si es null, la lista de categorias esta vacia

	lw $t0, 12($t0)			#de lo contrario accedo al siguiente nodo

	beqz $t0, error_202		#si es null entonces solo hay 1 categoria

	sw $t0, wclist			#de lo contrario hay al menos 2 categorias, cargo en $t0 la categoria siguiente
	
	li $v0, 4
	
	la $a0, selCat			#muestro el nombre de la categoria seleccionada
	syscall
	
	lw $a0, 8($t0)			
	syscall
	
	la $a0, return			
	syscall

	jal pausa
		
	lw $ra, 4($sp)			#restauro la direccion de retorno
	addiu $sp, $sp, 4		#restauro el sp

	jr $ra
	
	error_201:
	
	li $v0, 4
	la $a0, mensaje_error_201	#error no hay ninguna categoria
	syscall
			
	jal pausa
			
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	error_202:
	
	lw $t0, wclist
	
	li $v0, 4
	la $a0, mensaje_error_202	#error solo hay una categoria
	syscall
	
	la $a0, selCat			#printf se ha seleccionado la cat
	syscall
	
	lw $a0, 8($t0)			
	syscall
	
	la $a0, return		
	syscall
		
	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra

prevcategory:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)

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
	
	li $v0, 4
	
	la $a0, selCat		#se ha seleccionado la cat
	syscall
	
	lw $a0, 8($t0)		
	syscall
	
	la $a0, return		
	syscall	
		
	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra

listcategories:
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)	
	
	li $v0, 4
	la $a0, mensaje_operacion		#operacion selecionada
	syscall

	la $a0, mensaje_test_4			
	syscall

	lw $t0, cclist		#cargo el "primer" nodo de la lista en t0, que queda fijo
	lw $t1, cclist		#lo vuelvo a cargar en t1 pero se va a mover por la lista
	
	beqz $t0, error_301
	
	li $v0, 4
	la $a0, mensaje_lista_categorias	#printf Lista categorias cargadas:
	syscall
	
	loop_lista:
		
		lw $t7, wclist
		bne $t1, $t7, no_es_cat_selec
		
		la $a0, indicador	#imprimo > en la cat seleccionada
		syscall
		
		no_es_cat_selec:
		
		lw $a0, 8($t1)		#cargo el nombre de la categoria guardado en el nodo
		syscall			#printf nombre cat en el nodo actual
	
		la $a0, return		
		syscall		
	
		lw $t1, 12($t1)		#cargo en $t1 la dir del siguiente nodo
		
		beqz $t1, fin_list_categories	#si el siguiente es null, es porque solo hay 1 categoria, en cuyo caso rompo el loop
		bne $t0, $t1, loop_lista	#cuando vuelvo al nodo del que empece, rompo el loop

	fin_list_categories:

	jal pausa
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	error_301:
		
		li $v0, 4
		la $a0, mensaje_error_301
		syscall
		
		jal pausa
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		jr $ra

delcategory:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_5
	syscall

	lw $s0, wclist			#cargo la dir del nodo seleccionado
	lw $t3, numero_categorias
	
	beqz $s0, error_401		#si wclist es nulo, entonces no hay categorias cargadas
	
	lw $t1, 4($s0)			#cargo en t1 la direccion del primer objeto de la lista enlazada doble de objetos
	
	beqz $t1, object_null		#veo si es null
	
	move $t4, $t1
	
	loop_delet_obj:			#si la lista de objetos no es null, la recorro y libero cada nodo
	
		lw $a0, 8($t4)			#cargo en a0 el nombre del nodo
	
		jal sfree			#free nombre del nodo
	
		lw $s1, 12($t4)			#cargo en s1 el siguiente nodo
	
		move $a0, $t4			#cargo en a0 el nodo a eliminar
		
		jal sfree			#free nodo
		
		move $t4, $s1			#cargo en t4 el siguiente nodo
		
		beqz $t4, fin_delet_obj		#si el siguiente nodo es null, termino
		beq $t1, $t4, fin_delet_obj	#si el siguiente nodo es donde empece, termino
		
		j loop_delet_obj
		
	fin_delet_obj:
	
	object_null:
	
	#imprimo categoria eliminada: nombre
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	sw $v0, 8($sp)
	
	li $v0, 4
	la $a0, mensaje_cat_borrada
	syscall

	lw $a0, 8($s0)			#cargo el nombre de la categoria a eliminar
	syscall
	
	la $a0, return
	syscall
	
	jal pausa
	
	lw $a0, 4($sp)
	lw $v0, 8($sp)
	addiu $sp, $sp, 8
	#fin impresion
	
	lw $t1, 8($s0)			#cargo en t1 el nombre de la categoria
	
	beqz $t1, cat_null		#si el nombre de la categoria es null, no lo libero
	
	move $a0, $t1
		
	jal sfree			#si cat no es null, libero el nodo
	
	cat_null:
	
	lw $s0, wclist			#cargo en s0 el nodo seleccionado

	lw $t1, 12($s0)			#cargo en t1 el siguiente nodo al seleccionado
	
	bnez $t1, no_es_unico_nodo	#si es null, hay solo 1 nodo
		
	move $a0, $s0			#muevo el nodo seleccionado a a0 para liberarlo
		
	jal sfree			#libero el nodo
	
	sw $0, wclist			#como borre el unico nodo, cclist y wclist son null
	sw $0, cclist			#como borre el unico nodo, cclist y wclist son null
	
	lw $s0, numero_categorias
	
	addi $s0, $s0, -1		#actualizo el numero de categorias
	
	sw $s0, numero_categorias

	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra
						
	no_es_unico_nodo:	
	
	lw $t3, numero_categorias
	
	bgt $t3, 2, hay_mas_de_2_categorias
	
	lw $t2, cclist
	
	bne $s0, $t2, no_borro_primer_nodo
	
	sw $t1, cclist		#como borro el primer nodo de clist actualizo el puntero que ahora apunta al siguiente del nodo eliminado
	sw $t1, wclist		#actualizo el nodo seleccionado como el siguiente nodo al eliminado
	
	sw $0, ($t1)		#anterior es null porque solo queda 1 categoria
	sw $0, 12($t1)		#siguiente es null porque solo queda 1 categoria
	
	move $a0, $s0
		
	jal sfree		#libero el nodo
	
	lw $s0, numero_categorias
	
	addi $s0, $s0, -1		#actualizo numero categorias
	
	sw $s0, numero_categorias
	
	li $v0, 4
	la $a0, selCat
	syscall
		
	lw $t0, wclist
	lw $a0, 8($t0)	
	syscall

	la $a0, return
	syscall		
	
	jal pausa				
													
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	no_borro_primer_nodo:	#no actualizo el puntero cclist
	
	move $a0, $s0
		
	jal sfree		#libero el nodo
	
	sw $t1, wclist
	
	sw $0, ($t1)		#anterior es null porque solo queda 1 categoria
	sw $0, 12($t1)		#siguiente es null porque solo queda 1 categoria
	
	lw $s0, numero_categorias
	
	addi $s0, $s0, -1
	
	sw $s0, numero_categorias
	
	li $v0, 4
	la $a0, selCat
	syscall
		
	lw $t0, wclist
	lw $a0, 8($t0)	
	syscall

	la $a0, return
	syscall
	
	jal pausa				
													
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	hay_mas_de_2_categorias:		#en t1 tengo 12($t0), la direccion del siguiente nodo
						#en t0 tengo wclist
	lw $t2, cclist
	
	bne $t2, $s0, no_elimino_primer_nodo	#branch si cclist es distinto a wclist, y si son iguales entonces la cabecera de la lista la reasigno

	sw $t1, cclist				#reasigno el primer nodo de la lista al siguiente
	
	no_elimino_primer_nodo:
	
	sw $t1, wclist				#reasigno wclist
		
						#en $s0 tengo el nodo a eliminar, 
						#en $t1 tengo el nuevo primer nodo
	lw $t2, ($s0)				#cargo en t2 el anterior del nodo a eliminar
		
	sw $t2, ($t1)				#el anterior del nuevo primer nodo debe ser igual al anterior del viejo primer nodo	
	
	sw $t1, 12($t2)				#guardo en el siguiente del anterior del viejo primer nodo al nuevo primer nodo
						#el siguiente del anterior del anterior primer nodo debe ser el nuevo primer nodo
		
	move $a0, $s0	
	
	jal sfree				#libero el nodo
		
	sw $0, ($s0)
		
	lw $t2, numero_categorias
	addi $t2, $t2, -1			#actualizo numero categorias
	sw $t2, numero_categorias
		
	li $v0, 4
	la $a0, selCat	
	syscall
		
	lw $t0, wclist
	lw $a0, 8($t0)				#imprimo la categoria seleccionada
	syscall

	la $a0, return
	syscall
	
	jal pausa				
		
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
		
	jr $ra
	
	error_401:
	
		li $v0, 4
		la $a0, mensaje_error_401
		syscall	
		
		jal pausa
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		jr $ra
	

newobject:

	addiu $sp, $sp, -4
	sw $ra, 4($sp)

	lw $t0, wclist			
	beqz $t0, error_nullcat		#si wclist es null, error

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_6
	syscall
	
	la $a0, objName
	syscall
	
	jal recibir_nombre		#devuelve en $v0 la direccion de memoria que apunta al nombre ingresado por el usuario
	
	move $a0, $v0			#en a0 queda la direccion al nombre del nodo
	
	lw $t0, wclist			
	la $a1, 4($t0)			#en $a1 debe estar el puntero a la lista, es decir, 4(wclist)
	li $a2, 0			#como estoy insertando un objeto, no necesito actualizar wclist, asique va seteado en 0
	
	jal insertar_nodo_doble_final	#requiere en $a0 la direccion al nombre del nodo, en $a1 la direccion del puntero a la lista y en a2 iria la direccion de wclist o 0 en caso de objetos
	lw $t0, wclist	
	lw $a0, 4($t0)			#cargo en a0 la direccion del primer nodo de la lista de objetos
	
	jal actualizar_ids		#requiere en a0 la direccion del primer nodo de la lista de objetos
	
	li $v0, 4
	la $a0, success
	syscall
	
	jal pausa
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra
	
	error_nullcat:
	
	li $v0, 4
	la $a0, mensaje_error_501
	syscall
		
	jal pausa		
	
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
	lw $t0, 4($t0)			#cargo en t0 el primer nodo de la lista de objetos
	beqz $t0, no_hay_objetos
	move $t1, $t0
	
	li $v0, 4
	la $a0, mensaje_lista_objetos
	syscall
	
	loop_list_obj:			#recorro la lista de objetos y los imprimo
	
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

	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	
	jal pausa
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra
	
	no_hay_categorias:
	
	li $v0, 4
	la $a0, mensaje_error_601
	syscall
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	
	jal pausa
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	no_hay_objetos:
	
	li $v0, 4
	la $a0, mensaje_error_602
	syscall
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	
	jal pausa
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra

delobject:	#print se ha eliminado objeto tal, pausa

	addiu $sp, $sp, -4
	sw $ra, 4($sp)

	li $v0, 4
	la $a0, mensaje_operacion
	syscall

	la $a0, mensaje_test_8
	syscall

	lw $t0, wclist
	beqz $t0, error_701		#si wclist es null, error de lista vacia
	lw $t0, 4($t0)
	beqz $t0, error_nullobj		#si lista de objetos es null, error

	la $a0, idObj
	syscall
	
	li $v0, 5			#recibo del usuario el id del objeto a eliminar
	syscall
	
	move $a1, $v0			#copio el id a eliminar en a1
	
	li $v0, 4
	la $a0, return
	syscall
	
	lw $t0, wclist
	
	beqz $t0, error_701		#si la lista esta vacia, error 701
	
	la $a0, 4($t0)			#en $a0 va direccion a donde esta guardado puntero a lista de objetos
	
	jal borrar_nodo_obj		#a0 nodo objetos a eliminar, a1 id a eliminar

	lw $t0, wclist
	lw $a0, 4($t0)
	
	jal actualizar_ids		#a0 dir de lista objetos para actualizar ids

	lw $ra, 4($sp)
	addiu $sp, $sp, 4

	jr $ra
	
	error_701:
	
	li $v0, 4
	la $a0, mensaje_error_701
	syscall
	
	jal pausa
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra

insertar_nodo_doble_final: #a0 debe contener la direccion al nombre dato a insertar, $a1 debe contener el puntero a la lista y en $a2 la direccion donde esta guardado el nodo seleccionado, para poder actualizarlo  
			
	addiu $sp, $sp, -4
	sw $ra, 4($sp)			#preservo la direccion de retorno antes de saltar a otra funcion
				
	move $s5, $a0			#preservo el valor de $a0 que es un argumento de la funcion y puede ser modificado por smalloc
	
	jal smalloc			#retorna en $v0 la direccion de memoria del bloque de 16 bytes asignado
				
	move $a0, $s5			#restauro el valor de $a0

	sw $a0, 8($v0)			#guardo el nombre de la categoria en la tercera word del bloque de memoria asignado
	lw $t1, ($a1)			#cargo en $t1 la direccion al primer nodo de la lista

	beq $t1, $0, primer_nodo	#si la direccion es 0, es decir, null, es el primer nodo esto funciona como un if(nodo == null)
	
	lw $t2, 12($t1)			#tengo que ver si el primer nodo apunta a null
	
	beq $t2, $0, segundo_nodo	#beq si el siguiente nodo es null, entonces voy a segundo nodo
	
	lw $t3, ($t1)			#cargo dir_nodo_viejo.anterior en $s5
	
	sw $v0, 12($t3)			#siguiente del ultimo nodo anterior es nuevo nodo
	 
	sw $0, 4($v0)
	
	sw $t3, ($v0)			#guardo el ultimo nodo anterior como anterior del nuevo nodo
	
	sw $t1, 12($v0)			#guardo como siguiente de nuevo nodo al primer nodo
	
	sw $v0, ($t1)			#guardo como anterior del primer nodo al nuevo ultimo nodo

	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra				#regreso a instruccion luego de jal en main	
										
	primer_nodo:
		
		sw $0, ($v0)		#guardo 0 representando NULL como nodo anterior en la primera word
		sw $0, 4($v0)		#lo seteo a null, luego se llenara con un objeto o no
		sw $0, 12($v0)		#guardo 0 representando NULL como nodo siguiente en la cuarta word
		sw $v0, ($a1)		#guardo la nueva direccion de la lista enlazada que apunta al primer nodo
		
		beqz $a2, no_wclist
		
		sw $v0, ($a2)		#seteo la categoria seleccionada al primer nodo
		
		no_wclist:
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
		
		jr $ra			

	segundo_nodo:
		
		sw $t1, ($v0)		#guardo la direccion del primer nodo como nodo anterior en la primera word
		sw $0, 4($v0)		#lo seteo a null, luego se llenara con un objeto o no
		sw $t1, 12($v0)		#guardo la direccion del primer nodo como nodo siguiente en la cuarta word
		
		sw $v0, ($t1)
		sw $v0, 12($t1)
		
		lw $ra, 4($sp)
		addiu $sp, $sp, 4
			
		jr $ra		

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
	
	move $v0, $t7			#pongo la direccion en $v0, el retorno de la funcion
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra		

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
	
	li $v0, 12		#recibe un char del usuario, sirve para pausar la ejecucion del programa hasta que se aprete enter o se tipee una letra. principalmente para mejorar la visualizacion del texto para el usuario
	syscall
	
	li $v0, 4
	la $a0, return
	syscall
	
	jr $ra
	
borrar_nodo_obj:	#recivo en $a0 la direccion del primer nodo de la lista de objetos, recibo en $a1 el ID del objeto a borrar
	
	lw $t0, ($a0)
	
	beqz $t0, error_nullobj
	
	move $s7, $a0		#cargo en s7 la direccion de donde esta guardado el puntero a la lista para poder modificarlo
	
	lw $s0, ($a0)		#cargo en s0 el puntero al primer elemento de la lista
	move $t0, $s0		#copio en t0 el puntero al primer elemento de la lista 
	
	looop:
		
		lw $t1, 4($t0)
		
		beq $t1, $a1, finlooop
		
		lw $t0, 12($t0)
		
		beqz $t0, not_found
		beq $t0, $s0, not_found
		
		j looop
	
	finlooop:
		move $s0, $t0		#en s0 tengo la direccion al nodo a elimimnar
	
	addiu $sp, $sp, -4
	sw $ra, 4($sp)
	
	move $a0, $s0
	
	beqz $s0, nodo_esnull
	
	lw $a0, 8($s0)
	
	beqz $a0, nombre_esnull
	
	#imprimo categoria eliminada: nombre
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	sw $v0, 8($sp)
	
	li $v0, 4
	la $a0, mensaje_objt_borrado
	syscall

	lw $a0, 8($s0)			#cargo el nombre de la categoria a eliminar
	syscall
	
	la $a0, return
	syscall
	
	jal pausa
	
	lw $a0, 4($sp)
	lw $v0, 8($sp)
	addiu $sp, $sp, 8
	#fin impresion
	
	jal sfree
	
	nombre_esnull:
	
	lw $a0, 12($s0)
	
	beqz $a0, unico_nodo		#si el nodo no es null y si el siguiente es null, es porque es el unico nodo
	
	lw $t0, ($s0)		#cargo en t0 la direccion del nodo anterior al que voy a borrar
	lw $t1, 12($s0)		#cargo en t1 la direccion del nomo siguiente al que voy a borrar
	
	lw $t3 4($s0)
	
	bne $t3, 1, no_borro_primero
	
	sw $t1, ($s7)	#aca tengo que guardarlo en el primer lugar de la lista enlazada		#actualizo el puntero a la lista como el nuevo primer nodo
	
	no_borro_primero:
	
	beq $t0, $t1, solo_dos_nodos	#si el anterior y el siguiente de un nodo son iguales, es porque solo hay 2 nodos
	
	sw $t1, 12($t0)		#el siguiente del anterior es el siguiente del nodo a borrar
	sw $t0, ($t1)		#el anterior del siguiente al que borro es el anterior del nodo a borrar
	
	move $a0, $s0
	jal sfree		#libero el nodo
	
	nodo_esnull:
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra

	unico_nodo:
	
	move $a0, $s0
	
	jal sfree
	
	sw $0, ($s7)		#como borre el unico nodo, seteo a null
		
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
	
	jal pausa
	
	lw $ra, 4($sp)
	addiu $sp, $sp, 4
	
	jr $ra
	
	error_nullobj:
	
	li $v0, 4
	la $a0, mensaje_error_nullobj
	syscall
	
	jal pausa

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

