.data
	opcodeLibType1: .asciiz "syscall;nop;\n"						
	opcodeLibType2: .asciiz "add;sub;addu;subu;mul;and;or;nor;xor;slt;sgt;seq;sllv;srlv;\n"
	opcodeLibType3: .asciiz "addi;addiu;andi;ori;sll;srl;slti,sltiu;\n"			
	opcodeLibType4: .asciiz "div;mul;move;\n"						
	opcodeLibType5: .asciiz "lw;sw;lb;sb;lbu;lhu;ll;sh;\n"					
	opcodeLibType6: .asciiz "lui;li;\n"							
	opcodeLibType7: .asciiz "la;beqz;bnez;bgtz;bgez;bltz;blez;\n"				
	opcodeLibType8: .asciiz "mflo;mfhi;jr\n"						
	opcodeLibType9: .asciiz "beq;bne;\n"
	opcodeLibType10: .asciiz "j;jal;\n"
	
	syntaxInput: .space 256
	opcode: .space 10
	
	message: .asciiz "\n\nNhap ma can kiem tra: "
	messageOpcode: .asciiz "Opcode: "
	correctOpcode: .asciiz ", hop le"
	incorrectOpcode: .asciiz ", khong hop le"
	messageCorrectSyntax: .asciiz "\nCu phap hop le"
	messageIncorrectSyntax: .asciiz "\nCu phap khong hop le"
	messageMissingOperand: .asciiz "\nThieu toan hang"
	messageIncorrectOperand: .asciiz "\nToan hang khong dung"
	messageIncorrectLabel: .asciiz "\nTen nhan khong dung"
	messageIncorrectNumImediate:  .asciiz "\nSo khong dung dinh dang"
	messageIncorrectAddress: .asciiz "\nDia chi khong dung dinh dang"
	messageContinue: .asciiz "\nLua chon tiep tuc hay dung lai(y/n): "
	registerLib: .asciiz "$zero;$at;$v0;$v1;$a0;$a1;$a2;$a3;$t0;$t1;$t2;$t3;$t4;$t5;$t6;$t7;$t8;$t9;$k0;$k1;$gp;$sp;$fp;$ra;$0;$1;$2;$3;$4;$5;$6;$7;$8;$9;$10;$11;$12;$13;$14;$15;$16;$17;$18;$19;$20;$21;$22;$23;$24;$25;$26;$27;$28;$29;$30;$31;\n"
.text
	main:
# ----------------------------------------------------------------------------------------------#
#		Khai bao yeu cau nguoi dung nhap code mips can kiem tra 			     #
# -------------------------------------------------------------------------------------------- -#
	start:
		li $v0,4
		la $a0,message
		syscall
		li $v0,8
		la $a0,syntaxInput
		li $a1,256
		syscall
		move $s0, $a0
		jal clear_space
		j read_opcode
	end:
		li $v0, 10
		syscall
	clear_space:
		lb $t0, 0($s0)
		addi $s0, $s0, 1
		beq $t0,' ', clear_space	# neu ky tu chua != khoang trang thi tiep tuc lap
		addi $s0, $s0, -1		# neu ky tu != khoang trang thi tra vi tri co ky tu != khoang trang
		jr $ra
# -----------------------------------------------------------#
#		Tach opcode tu chuoi nhap vao		        #
# -----------------------------------------------------------#
	read_opcode:
		la $s1, opcode			# load opcode vao $s1
	loop_read_opcode:
		lb $t0, 0($s0)
		beq $t0,' ', check_opcode	#doc opcode tu chuoi nhap vao luu vao $s1, dung lai khi ky tu bang khoang trang
		beq $t0,'\n', check_opcode	#doc dung lai khi gap ky tu xuong dong
		sb $t0, 0($s1)
		addi $s0, $s0, 1
		addi $s1, $s1, 1
		j loop_read_opcode
# -----------------------------------------------------------------------------------------------------------------------#
#		Kiem tra xem opcode nhap vao co ton tai trong thu vien opcode va loai opcode la gi			       #
# -----------------------------------------------------------------------------------------------------------------------#
	check_opcode:
		la $a1, opcodeLibType1		#luu thu vien cac opcode vao thanh ghi $a1
		addi $v1, $zero, 1		#luu opcode type vao $v1 neu opcode dung thi se su dung $v1 de kiem tra
		jal check_type_opcode
		la $a1, opcodeLibType2
		addi $v1, $zero, 2
		jal check_type_opcode
		la $a1, opcodeLibType3
		addi $v1, $zero, 3
		jal check_type_opcode
		la $a1, opcodeLibType4
		addi $v1, $zero, 4
		jal check_type_opcode
		la $a1, opcodeLibType5
		addi $v1, $zero, 5
		jal check_type_opcode
		la $a1, opcodeLibType6
		addi $v1, $zero, 6
		jal check_type_opcode
		la $a1, opcodeLibType7
		addi $v1, $zero, 7
		jal check_type_opcode
		la $a1, opcodeLibType8
		addi $v1, $zero, 8
		jal check_type_opcode
		la $a1, opcodeLibType9
		addi $v1, $zero, 9
		jal check_type_opcode
		la $a1, opcodeLibType10
		addi $v1, $zero, 10
		jal check_type_opcode
		j print_incorrect_opcode	# neu sau khi check qua 10 loai opcode ma khong co thi in ra opcode khong ton tai
	check_type_opcode:
		la $s1, opcode
	loop_check_type_code:
		lb $t1, 0($a1)
		beq $t1,';', check_opcode_done	#neu opcode trong thu vien bang ky tu ; la ky tu ngan cach giua cac opcode thi thuc hien ham
		lb $t0, 0($s1)
		bne $t0, $t1, next_opcode	#neu ky tu trong thu vien khac ky tu opcode thi nhay sang opocde tiep theo
		addi $s1, $s1, 1
		addi $a1, $a1, 1
		j loop_check_type_code
	check_opcode_done:
		lb $t0, 0($s1)
		beq $t0,'\0', opcode_done	#neu opocde bang ket thuc chuoi thi in ra thong bao opcode hop le
		beq $t0,' ', opcode_done	#neu opcode ky tu tiep theo bang dau cach thi in ra thong bao opcode hop le
	next_opcode:
		addi $a1, $a1, 1
		lb $t1, 0($a1)
		beq $t1,';',reset		#Tim ky tu ; trong thu vien de lay ra opcode tiep theo
		j next_opcode
	reset:
		addi $a1, $a1, 1		
		lb $t1, 0($a1)
		bne $t1,'\n',check_type_opcode	 #neu khong ton tai trong thu vien loai nay thi nhay sang thu vien khac de kiem tra
		jr $ra
# ------------------------------------------------------------------#
#		In ra thong bao opcode hop le			       #
# ------------------------------------------------------------------#
	opcode_done:
		li $v0, 4
		la $a0, messageOpcode
		syscall
		la $a0, opcode
		syscall
		la $a0, correctOpcode
		syscall
		j type_opcode_select
# -------------------------------------------------------------------------#
#		In ra thong bao opcode khong hop le			      #
# -------------------------------------------------------------------------#
	print_incorrect_opcode:
		li $v0, 4
		la $a0, messageOpcode
		syscall
		la $a0, opcode
		syscall
		la $a0, incorrectOpcode
		syscall
		j incorrect_syntax
# ------------------------------------------------------------------#
#		Kiem tra opcode_type bang bao nhieu		       #
# ------------------------------------------------------------------#
	type_opcode_select:
		beq $v1,1, opcode_type1
		beq $v1,2, opcode_type2
		beq $v1,3, opcode_type3
		beq $v1,4, opcode_type4
		beq $v1,5, opcode_type5
		beq $v1,6, opcode_type6
		beq $v1,7, opcode_type7
		beq $v1,8, opcode_type8
		beq $v1,9, opcode_type9
		beq $v1,10, opcode_type10
# ----------------------------------------------------------#
#		Opcode type 1: syscall			       #
# ----------------------------------------------------------#
	opcode_type1:
		jal clear_space		#xoa toan bo khoang trang sau opcode de xem gia tri la gi
		lb $t0, 0($s0)
		beq $t0,'\0', correct_syntax  	#neu sau opcode la ket thuc chuoi thi in ra dung cu phap
		j incorrect_syntax
# -----------------------------------------------------------------#
#		Opcode type 2: add $t1, $t1, $t2		      #
# -----------------------------------------------------------------#
	opcode_type2:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 co ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		jal check_register	#kiem tra thanh ghi 2 co ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		jal check_register	#kiem tra thanh ghi 3 co ton tai
		jal clear_space
		jal check_end
		j correct_syntax
# -------------------------------------------------------------------------#
#		Opcode type 3: addi $t1, $t1, 5			       #
# -------------------------------------------------------------------------#
	opcode_type3:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		jal check_register	#kiem tra thanh ghi 2 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		j check_num_imediate	#kiem tra so theo khuon dang lenh I
# -------------------------------------------------------------------#
#		Opcode type 4: mul $t1, $t2			        #
# ------------------------------------------------------------------#
	opcode_type4:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		jal check_register	#kiem tra thanh ghi 2 ton tai
		jal clear_space
		jal check_end		#kiem tra xem cau lenh ket thuc dung hay khong
		j correct_syntax
# ----------------------------------------------------------#
#		Opcode type 5: sb $t1, 0($t5)		       #
# ----------------------------------------------------------#
	opcode_type5:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		j check_num_address	#kiem tra dia chi dung dinh dang
# ------------------------------------------------------------------#
#		Opcode type 6: li $t1, 4			       #
# ------------------------------------------------------------------#
	opcode_type6:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		j check_num_imediate	#kiem tra gia tri theo dinh dang I
# ------------------------------------------------------------------#
#		Opcode type 7: la $t1, label			       #
# ------------------------------------------------------------------#
	opcode_type7:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		j check_label		#kiem tra label dung dang
# -----------------------------------------------------------------#
#		Opcode type 8: mflo $t1			      #
# -----------------------------------------------------------------#
	opcode_type8:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_end		#kiem tra xem cau lenh ket thuc dung dang
		j correct_syntax
# -------------------------------------------------------------------------#
#		Opcode type 9: beq $t1, $t2, label			      #
# -------------------------------------------------------------------------#
	opcode_type9:
		jal clear_space
		jal check_register	#kiem tra thanh ghi 1 ton tai
		jal clear_space
		jal check_commas
		jal clear_space
		jal check_register	#kiem tra thanh ghi 2 ton tai
		jal clear_space
		jal check_commas
		jal clear_space		#kiem tra label dung dang
		j check_label
# ------------------------------------------------------------------#
#		Opcode type 10: j label			       #
# ------------------------------------------------------------------#
	opcode_type10:
		jal clear_space		#kiem tra label dung dang
		j check_label
# -----------------------------------------------------------------#
#		In ra thong bao cu phap hop le			      #
# -----------------------------------------------------------------#
	correct_syntax:
		li $v0, 4
		la $a0, messageCorrectSyntax
		syscall
		j check_continue
# -------------------------------------------------------------------------#
#		In ra thong bao cu phap khong hop le			       #
# -------------------------------------------------------------------------#
	incorrect_syntax:
		li $v0, 4
		la $a0, messageIncorrectSyntax
		syscall
# --------------------------------------------------------------------------------#
#		In ra thong bao co muon tiep tuc chuong trinh			      #
# --------------------------------------------------------------------------------#
	check_continue:
		li $v0, 4
		la $a0, messageContinue
		syscall
		li $v0, 12
		syscall
		beq $v0,'y', reset_opcode
		beq $v0,'Y', reset_opcode
		beq $v0,'n', end
		beq $v0,'N', end
		j check_continue
# ------------------------------------------------------------------#
#		Dua gia tri opcode ve null	   		       #
# ------------------------------------------------------------------#
	reset_opcode:
		la $s1, opcode
	start_reset:
		lb $t0, 0($s1)
		beq $t0,'\0', reset_syntax_input
		sb $zero, 0($s1)
		addi $s1, $s1, 1
		j start_reset
# ---------------------------------------------------------------------------------#
#		Dua gia tri cua syntax nhap vao ve null			       #
# ---------------------------------------------------------------------------------#
	reset_syntax_input:
		la $s0, syntaxInput
	start_reset_syntax:
		lb $t0, 0($s0)
		beq $t0,'\0', start
		sb $zero, 0($s0)
		addi $s0, $s0, 1
		j start_reset_syntax
# --------------------------------------------------------------------------------------------------------#
#		Kiem tra xem thanh ghi co ton tai trong thu vien thanh ghi hay khong			       #
# --------------------------------------------------------------------------------------------------------#
	check_register:
		la $a1, registerLib
	start_check_register:
		move $a0, $s0
	loop_check_register:
		lb $t1, 0($a1)
		beq $t1,';', check_register_done
		lb $t0, 0($a0)
		beq $t1,'\n', missing_operand
		beq $t1,'\0', missing_operand
		bne $t0, $t1, next_register
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		j loop_check_register
	check_register_done:
		lb $t0, 0($a0)
		beq $t0,' ', register_done
		beq $t0,',', register_done
		beq $t0,'\n', register_done
		beq $t0,'\0', register_done
		beq $t0,')', register_done
	next_register:
		addi $a1, $a1, 1
		lb $t1, 0($a1)
		beq $t1,';', reset_check_register
		j next_register
	reset_check_register:
		addi $a1, $a1, 1
		lb $t1, 0($a1)
		bne $t1,'\n', start_check_register
		j incorrect_operand
	register_done:
		move $s0, $a0
		jr $ra
# ----------------------------------------------------------------------------------------#
#		Kiem tra dau phay giua 2 toan hang co ton tai khong			      #
# ----------------------------------------------------------------------------------------#
	check_commas:
		lb $t0, 0($s0)
		addi $s0, $s0, 1
		bne $t0,',', missing_operand
		jr $ra
# -------------------------------------------------------------------------#
#		Kiem tra xem label co hop le khong			      #
# -------------------------------------------------------------------------#
	check_label:
		move $a0, $s0
		addi $t1, $zero, 0
	start_check_label:
		lb $t0, 0($a0)
		beq $t0,'\n', check_label_done
		jal check_under_score
		jal check_lower_char
		jal check_upper_char
		jal check_number_char
	after_check_char:
		addi $t1, $t1, 1
		addi $a0, $a0, 1
		j start_check_label
	check_label_done:
		bgt $t1, 32, incorrect_syntax
		beqz $t1, missing_operand
		j correct_syntax
	check_under_score:
		beq $t0,'_', after_check_char
		jr $ra
	check_lower_char:
		sge $t2, $t0, 97
		sle $t3, $t0, 122
		and $t4, $t2, $t3
		bnez $t4, after_check_char
		jr $ra
	check_upper_char:
		sge $t2, $t0, 65
		sle $t3, $t0, 90
		and $t4, $t2, $t3
		bnez $t4, after_check_char
		jr $ra
	check_number_char:
		sge $t2, $t0, 48
		sle $t3, $t0, 57
		and $t4, $t2, $t3
		beqz $t4, incorrect_label
		jr $ra
# ----------------------------------------------------------------------------------------#
#		Kiem tra so trong lenh dang I co dung hay khong			      #
# ----------------------------------------------------------------------------------------#
	check_num_imediate:
		move $t1, $zero
	num_imediate:
		lb $t0, 0($s0)
		beq $t0,'\n', num_imediate_done
		jal check_negative_num
		sge $t2, $t0, 48
		sle $t3, $t0, 57
		and $t4, $t2, $t3
		beqz $t4, incorrect_num_imediate
	continue_num_imediate:
		addi $s0, $s0, 1
		li $t1, 1
		j num_imediate
	num_imediate_done:
		beqz $t1, missing_operand
		j correct_syntax
	check_negative_num:
		beqz $t1, negative_num
	return:
		jr $ra
	negative_num:
		beq $t0,'-', continue_num_imediate
		j num_imediate
# ----------------------------------------------------------------------------------------#
#		Kiem tra xem dia chi co dung dinh dang hay khong			      #
# ----------------------------------------------------------------------------------------#
	check_num_address:
		move $t1, $zero
	num_address:
		lb $t0, 0($s0)
		beq $t0,'\n', num_address_done
		beq $t0,'(', num_address_done
		sge $t2, $t0, 48
		sle $t3, $t0, 57
		and $t4, $t2, $t3
		beqz $t4, incorrect_address
		addi $s0, $s0, 1
		li $t1, 1
		j num_address
	num_address_done:
		beqz $t1, missing_operand
		jal clear_space
		lb $t0, 0($s0)
		bne $t0,'(', incorrect_syntax
		addi $s0, $s0, 1
		jal clear_space
		jal check_register
		jal clear_space
		lb $t0, 0($s0)
		bne $t0,')', incorrect_syntax
		addi $s0, $s0, 1
		jal clear_space
		jal check_end
		j correct_syntax
# ----------------------------------------------------------------------------------------#
#		Kiem tra xem gia o cuoi cau lenh co dung hay khong			      #
# ----------------------------------------------------------------------------------------#
	check_end:
		lb $t0, 0($s0)
		bne $t0,'\n', incorrect_syntax
		jr $ra
# -------------------------------------------------------------------------#
#		In ra thong bao thieu toan hang			      #
# -------------------------------------------------------------------------#
	missing_operand:
		li $v0, 4
		la $a0, messageMissingOperand
		syscall
		j incorrect_syntax
# -------------------------------------------------------------------------#
#		In ra thong bao opcode toan hang khong co		      #
# -------------------------------------------------------------------------#
	incorrect_operand:
		li $v0, 4
		la $a0, ,messageIncorrectOperand
		syscall
		j incorrect_syntax
# -------------------------------------------------------------------------#
#		In ra thong bao label khong dung			      #
# -------------------------------------------------------------------------#
	incorrect_label:
		li $v0, 4
		la $a0, messageIncorrectLabel
		syscall
		j incorrect_syntax
# --------------------------------------------------------------------------------#
#		In ra thong bao so trong khuon dang I khong dung		      #
# --------------------------------------------------------------------------------#
	incorrect_num_imediate:
		li $v0, 4
		la $a0, messageIncorrectNumImediate
		syscall
		j incorrect_syntax
# ------------------------------------------------------------------------#
#		In ra thong bao dia chi khong dung			      #
# ------------------------------------------------------------------------#
	incorrect_address:
		li $v0, 4
		la $a0, messageIncorrectAddress
		syscall
		j incorrect_syntax