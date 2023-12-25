.data
	arr:	.word	6,4,2,-4,-7,8,7,10,15,1,6
	arrE:	.word
.text
#initialize
#s0: head pointer of array
#s1: length
	la	$s0,arr
	la	$s1,arrE
	sub	$s1,$s1,4	# array pointer
	sub	$s1,$s1,$s0	#n
	j	i_sort
after:	li	$v0,10
	syscall

#--------------------------------------------------------
#Procedure: insertion sort
#$t0: i
#$t1: j
#$t2: temp pointer 1 (i)
#$t3: temp pointer 2 (j)
#$t4: temp 1 (i)
#$t5: temp 2 (j)
#--------------------------------------------------------
i_sort:		li	$t0,4
i_sort_ini:	bgt	$t0,$s1,i_sort_end
		add	$t2,$s0,$t0
		lw	$t4,0($t2)	
		subi	$t1,$t0,4
loop1:		add	$t3,$s0,$t1
		lw	$t5,0($t3)
		bltz	$t1,i_insert
		bgt	$t4,$t5,i_insert
		subi	$t1,$t1,4
		j	loop1		
i_sort_end:	j	after
		
#--------------------------------------------------------
#Procedure: insert
#$t6: temp i
#$t7: temp pointer
#$t8: temp value
#--------------------------------------------------------
i_insert:	add	$t6,$zero,$t0
		addi	$t1,$t1,4
loop2:		beq	$t6,$t1,i_insert_in
		add	$t7,$s0,$t6
		subi	$t6,$t6,4
		add	$t8,$s0,$t6
		lw	$t8,0($t8)
		sw	$t8,0($t7)
		j	loop2		#push, to create space for temp temp
i_insert_in:	addi	$t3,$t3,4
		sw	$t4,0($t3)
i_insert_end:	addi	$t0,$t0,4
		j	i_sort_ini