.data
	A:	.word

.text
		j	input
main:		la	$s0,A
		move	$s1,$a1
		mul	$s1,$s1,4
		add	$s1,$s0,$s1
		subi	$s1,$s1,4
		j	sort
after_sort:	li	$v0,10
		syscall
end_main:
sort:		beq	$s0,$s1,done
		j 	max
after_max:	lw	$t0,0($s1)
		sw	$t0,0($v0)
		sw	$v1,0($s1)
		addi	$s1,$s1,-4
		j	printt
done:		j	after_sort
max:		addi	$v0,$s0,0
		lw	$v1,0($v0)
		addi	$t0,$s0,0
loop:		beq	$t0,$s1,ret
		addi	$t0,$t0,4
		lw	$t1,0($t0)
		slt	$t2,$t1,$v1
		bne	$t2,$zero,loop
		addi	$v0,$t0,0
		addi	$v1,$t1,0
		j	loop
ret:		j	after_max
printt:		la	$s6,A
		move	$s7,$a1
		mul	$s7,$s7,4
		li	$t7,0
loop2:		beq	$t7,$s7,end_print
		add	$t8,$s6,$t7
		lw	$a0,0($t8)
		li	$v0,1
		syscall
		li	$a0,32
		li	$v0,11
		syscall
		addi	$t7,$t7,4
		j	loop2
end_print:	li	$a0,10
		li	$v0,11
		syscall
		j	sort
input:		li	$v0,5
		syscall
		move	$a1,$v0
		li	$t3,0
		la	$s2,A
loop3:		beq	$t3,$a1,input_e
		mul	$t4,$t3,4
		add	$s3,$s2,$t4
		li	$v0,5
		syscall
		sw	$v0,($s3)
		addi	$t3,$t3,1
		j	loop3
input_e:	j	main
