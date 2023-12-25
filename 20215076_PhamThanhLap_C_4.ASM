.data
	String: .space 256
	Message: .asciiz "Nhap vao xau ky tu: "
	Message1: .asciiz "Tu co do dai dai nhat trong xau la: "
.text
main:
	li $v0, 4
	la $a0, Message
	syscall				# Nhap vao xau
	li $v0, 8
	la $a0, String
	li $a1, 256
	syscall				# input String
	la $a1, String			# load address of String
	j LongestString			# jump LongestString
exit:
	li $v0, 10
	syscall				#eixt
LongestString:
	li $s0, 32   #space
	li $s1, 10   #\n
	li $s2, 0    #Start character
	li $s3, 0    #End character
	li $v0, 0    #count
Reset:
	addi $t2, $a1, 0		# luu vi tri bat dau tam thoi vao $t2
Check:
	lb $v1, 0($a1)			# lay chu cai tu $a1 ve luu vao $v1
	beqz $v1, PrintResult		# if c = '\0' In ket qua
	beq $v1, $s0, RisePointer	# if c = '\n' RisePointer
	beq $v1, $s1, RisePointer	# if c = ' ' RisePointer
	addi $a1, $a1, 1		# dia chi A[i] + 1
	j Check
RisePointer:
	sub $t3, $a1, $t2		# $t3 = vi tri cuoi - vi tri dau
	ble $t3, $v0, Skip		# if $t3 < count skip
	addi $v0, $t3, 0		# count = $t3
	addi $s2, $t2, 0		# Start character = gia tri dia chi luu o $t2
	addi $s3, $a1, 0		# End character = gia tri dia tri ket thuc
Skip:
	addi $a1, $a1, 1		# A[i] + 1
	j Reset				# Reset lai vi tri bat dau
PrintResult:
	li $v0, 4
	la $a0, Message1
	syscall				# in ra ket qua
Print:
	beq $s2, $s3, exit		# if dia chi bat dau = dia chi ket thuc eixt
	li $v0, 11
	lb $a0, 0($s2)
	syscall				#in ra tu dai nhat
	addi $s2, $s2, 1
	j Print
