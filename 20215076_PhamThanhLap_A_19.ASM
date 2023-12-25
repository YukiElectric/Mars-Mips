.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "
	Message1: .asciiz "So nguyen to nho nhat lon hon N la: "
	Eror: .asciiz "So nhap vao phai lon hon 0!\n"
.text
main:
	li $v0, 4
	la $a0, Message
	syscall    			#in ra thong bao nhap so
	li $v0, 5
	syscall				#input number
	move $s0, $v0			#truyen gia tri vua nhap vao N
	bltz $s0, PrintEror		#in ra loi neu so ko dung dang
	j Prime
exit:
	li $v0, 10
	syscall				#exit
Prime:
	addi $s0, $s0, 1		# N+1
	li $t0, 2			# i = 2
IsPrime:
	bge $t0, $s0, PrintResult      # if i = N in ra ket qua
	div $s0, $t0		        # chia N cho i
	mfhi $t1			# lay du luu vao $t1
	beqz $t1, Prime			# if du = 0 return Prime
	addi $t0, $t0, 1		# i++
	j IsPrime
PrintResult:
	li $v0, 4
	la $a0, Message1
	syscall				#in ra thong bao ket qua
	li $v0, 1
	addi $a0, $s0, 0
	syscall
	j exit
PrintEror:
	li $v0, 4
	la $a0, Eror
	syscall
	j main
