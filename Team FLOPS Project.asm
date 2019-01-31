.data
myFile: 		.asciiz "list.txt"      # filename for input
buffer: 		.space 5000		# Buffer for file read
timedisplay:		.asciiz "Your time was: "
minutes:		.asciiz " minutes "
seconds:		.asciiz " seconds.\n"
militomin:		.word	60000
milisec:		.float 1000.00
StoreTime:		.word 0
WelcomeMessage:		.asciiz	"Hello! You are playing Bulls & Cows made by Team FLOPS!\n"
Break:			.asciiz "\n"
LineBreak:		.asciiz "-------------------------------------------------------------------------------\n"
Rule:			.asciiz "Rules:\n"
Rule1:			.asciiz	"1. You will be guessing a four-letter word;\n"
Rule2:			.asciiz	"2. Base on your guess, you will receive a message with \"#a Bull and #b Cow\";\n" 
Rule3:			.asciiz	"3. The sum of a and b is the total numbers of letter you guess correctly;\n"
Rule4:			.asciiz	"4. a is the letters you guessed right and on the right position;\n"
Rule5:			.asciiz	"5. b is the letters you guessed right but with a wrong position.\n"
StartMessage:		.asciiz "Now, Let's play!\n"
PlayOrExit:		.asciiz "ENTER 1 to PLAY(keep playing) or 0 to EXIT: "
PlayOrExitInputError:	.asciiz "INVAILD! PLEASE TRY AGAIN!\n"
GameMessage:		.asciiz "Please guess a four-letter word (NO DUPLICATE, NO NUMBER, NO UPPER CASE): \n"
UserChoice:		.space 100
UserGuess: 		.space 100 
LetterOverSizeMessage:	.asciiz "YOU MUST ENTER EXACT 4 LETTERS! TRY AGAIN!\n"
InvaildLetterMessage:	.asciiz "YOU HAVE ENTERED INVAILD LETTER(s)! YOU MUST ENTER LETTERS FROM a-z! TRY AGAIN!\n"
DuplicateMessage:	.asciiz "YOU CANNOT ENTER DUPLICATE LETTERS! TRY AGAIN!\n"
ResultMessage1:		.asciiz " Bull and "
ResultMessage2:		.asciiz " Cow\n"
WinningMessage:		.asciiz "Congratulation! Your guess is correct!!!!!\n"
CorrectWord:		.asciiz "\nThe Word is: "
ExitMessage:		.asciiz "Thanks for playing!"

.text
ReadFile:
	# Open file for reading
	li   $v0, 13         	# system call for open file
	la   $a0, myFile     	# input file name
	li   $a1, 0           	# flag for reading
	li   $a2, 0           	# mode is ignored
	syscall               	# open a file 
	move $a0, $v0         	# save the file descriptor  

	# reading from file just opened
	li   $v0, 14     	# system call for reading from file
	la   $a1, buffer    	# address of buffer from which to read
	li   $a2,  1000       	# hardcoded buffer length
	syscall             	# read from file
	move $s1, $a1		#$s1 stores the address of buffer

	# close file
	li $v0, 15		# system call for closing file
	syscall

ChooseWord:
	# Choose a random word from the file.

	# Generate a random number between 0 and 100
	li $v0, 42  		# system call code to generate random int
	li $a1, 100		# $a1 is the upper bound 715
	syscall     		# Generate a random number in $a0.

	# Calculate offset for the random picked word
	addi	$t1, $zero, 5	# Put the multiplier in $t1
	mul	$a0, $a0, $t1	# Calculate the address offset for the random word
	mflo	$a0		# $a0 now contains the offset of word
	add	$a0, $a0, $s1	# $a0 now contains the address of the random word

	lb $s4, ($a0)		#setting 0th bit to s4
	lb $s5, 1($a0)		#setting 1st bit to s5
	lb $s6, 2($a0)		#setting 2nd bit to s6
	lb $s7, 3($a0)		#setting 3rd bit to s7

	jal PrintAnswer

Welcome:
	# Print welcome messages and rules.
	li $v0, 4		
	la $a0, WelcomeMessage
	syscall
	
	li $v0, 4		
	la $a0, LineBreak
	syscall
	
	li $v0, 4		
	la $a0, Rule
	syscall
	li $v0, 4		
	la $a0, Rule1
	syscall
	li $v0, 4		
	la $a0, Rule2
	syscall
	li $v0, 4		
	la $a0, Rule3
	syscall
	li $v0, 4	
	la $a0, Rule4
	syscall
	li $v0, 4		
	la $a0, Rule5
	syscall
	
	li $v0, 4	
	la $a0, LineBreak
	syscall
	li $v0, 4		
	la $a0, LineBreak
	syscall
	
	li $v0, 4		
	la $a0, StartMessage
	syscall
	
	jal timer
	sw $a0, StoreTime
	
	
Loop:	# Let user to choose to either play(keep playing) or exit.
	li $v0, 4		# print
	la $a0, PlayOrExit
	syscall
	

	li $v0, 8		# Get the user's input as a string
	la $a0, UserChoice
	li $a1, 100
	move $s0, $a0		# store UserChoice in $s0
	syscall
	
	lbu $t1, 0($s0)       	# load unsigned char from array into t1
	addi $t1, $t1, -48 	# converts t1's ascii value to dec value
	
	addi $t0, $0, 1

	beq $t1, $0, Giveup	# if the input is 0, then exit
	beq $t1, $t0, Input	# if the input is 1, countine
	
	li $v0, 4		# else, print the invaild message
	la $a0, PlayOrExitInputError
	syscall
	
	j Loop
	
Input:	# Let user start to guess.	
	li $v0, 4		# print, tell the user to start guessing
	la $a0, GameMessage
	syscall
	
	li $v0, 8		# read input string
	la $a0, UserGuess	# load byte space into address
    	li $a1, 100		# allot the byte space for string
    	move $s0, $a0		# store input string in $s0
    	syscall
    	
 	add $t0, $0, $0		# $t0 will be a counter, start from 0
	j CheckSizeLoop
	
CheckSizeLoop:
	# First user input check, check the user input's size.
	lb $t1, 0($s0)       	# load unsigned char from array into t1
	beqz $t1, CheckSize
	addi $s0, $s0, 1     	# increment array address
	addi $t0, $t0, 1	# counter = counter + 1
	
	j CheckSizeLoop
	
CheckSize:
	# If the user input is oversize, print warning message and start over.
	bne $t0, 5, LetterOverSize
	
	add $t0, $0, $0		# reset the counter $t0, start from 0 again
	addi $s0, $s0, -5     	# reset the array address
	
	j CheckLetterLoop

LetterOverSize:
	li $v0, 4		# print
	la $a0, LetterOverSizeMessage
	syscall
	
	j Loop

CheckLetterLoop:
	# Second user input check, check if the letters are vaild.
	lb $t1, 0($s0)       	# load unsigned char from array into t1
	beq $t0, 4, CheckDuplicate1	
	
	# check if the user enters vaild letters from a-z
	addi $t2, $0, 97
	blt $t1, $t2, InvaildLetter
	addi $t2, $0, 122
	bgt $t1, $t2, InvaildLetter
	
	addi $s0, $s0, 1     	# increment array address
	addi $t0, $t0, 1	# counter = counter + 1
	j CheckLetterLoop
	
InvaildLetter:
	# If the user input is invaild, print warning message and start over.
	li $v0, 4		
	la $a0, InvaildLetterMessage
	syscall
	
	j Loop
	
CheckDuplicate1:
	# Third user input check, check if there is any duplicate letter in the user input.
	la $t0, UserGuess
	
	lb $t1, 0($t0)		# load the frist letter to $t1
	addi $t0, $t0, 1
	lb $t2, 0($t0)		# load the second letter to $t2
	addi $t0, $t0, 1
	lb $t3, 0($t0)		# load the third letter to $t3
	addi $t0, $t0, 1
	lb $t4, 0($t0)		# load the fourth letter to $t4
	
	# Compare every letter
	beq $t1, $t2, Duplicate
	beq $t1, $t3, Duplicate
	beq $t1, $t4, Duplicate
	beq $t2, $t3, Duplicate
	beq $t2, $t4, Duplicate
	beq $t3, $t4, Duplicate
	
	j CompareLetter	
	
Duplicate:
	# If there are duplicate messages, print warining message and start over.
	li $v0, 4		# print
	la $a0, DuplicateMessage
	syscall	
		
	j Loop
	
CompareLetter:
	add $s2, $zero, $zero	# s2 is used for counting bull
	add $s3, $zero, $zero	# s3 is used for counting cow

	beq $t1, $s4, Bull1
	beq $t1, $s5, Cow1
	beq $t1, $s6, Cow1
	beq $t1, $s7, Cow1
	j CompareSecondLetter

Bull1:
	addi $s2, $s2, 1
	j CompareSecondLetter
Cow1:
	addi $s3, $s3, 1
	j CompareSecondLetter

CompareSecondLetter:
	beq $t2, $s5, Bull2
	beq $t2, $s4, Cow2
	beq $t2, $s6, Cow2
	beq $t2, $s7, Cow2
	j CompareThirdLetter
Bull2:
	addi $s2, $s2, 1
	j CompareThirdLetter
Cow2:
	addi $s3, $s3, 1
	j CompareThirdLetter

CompareThirdLetter:	
	beq $t3, $s6, Bull3
	beq $t3, $s4, Cow3
	beq $t3, $s5, Cow3
	beq $t3, $s7, Cow3
	j CompareFourthLetter
Bull3:
	addi $s2, $s2, 1
	j CompareFourthLetter
Cow3:
	addi $s3, $s3, 1
	j CompareFourthLetter

CompareFourthLetter:	
	beq $t4, $s7, Bull4
	beq $t4, $s4, Cow4
	beq $t4, $s5, Cow4
	beq $t4, $s6, Cow4
	j Final
Bull4:
	addi $s2, $s2, 1
	j Final
Cow4:
	addi $s3, $s3, 1
	j Final

Final:
	addi $t7, $zero, 4
	# If the user's guess is correct
	beq $s2, $t7, Win
	
	# If the user's guess is incorrect
	li $v0, 1
	move $a0, $s2
	syscall
	li $v0, 4		
	la $a0, ResultMessage1
	syscall
	li $v0, 1
	move $a0, $s3
	syscall
	li $v0, 4		
	la $a0, ResultMessage2
	syscall	
	
	j Loop
	
Win:
	# After the user correctly guesses the word.
	li $v0, 4		
	la $a0, LineBreak
	syscall
	
	li $v0, 4		
	la $a0, WinningMessage
	syscall
	
	jal Righttone
	jal timer
	lw $t9, StoreTime
	sub $t9, $a0, $t9
	jal showtime
	j Exit

Giveup:
	# When the user chooses to give up.
	jal Wrongtone
	jal PrintAnswer

Exit:
	li $v0, 4		
	la $a0, LineBreak
	syscall
	li $v0, 4		
	la $a0, LineBreak
	syscall
	
	li $v0, 4		
	la $a0, ExitMessage
	syscall
	
	li $v0, 10
	syscall

PrintAnswer:
	# Print the random 4-letter word
	li $v0, 4		
	la $a0, CorrectWord
	syscall
	
	li $v0, 11
	move $a0, $s4
	syscall

	li $v0, 11
	move $a0, $s5
	syscall

	li $v0, 11
	move $a0, $s6
	syscall
	
	li $v0, 11
	move $a0, $s7
	syscall
	
	li $v0, 4		
	la $a0, Break
	syscall
	jr $ra
	
timer:
	li	$v0, 30		# syscall number for time
	syscall			# System time is stored in $a0, as in milisecond
	jr	$ra

showtime:
	lw	$t1, militomin		#load the divisor 60000 into $t1
	div	$t9, $t1		#divide milisecond by 60000
	mfhi	$t2			#$t2 contains the remainder (miliseconds)
	mflo	$t3			#$t3 contains the quotient (minutes)
	mtc1	$t2, $f1		#move the seconds to coproc 1 to convert milisec to sec
	cvt.s.w	$f1, $f1		#convert the moved word into single precision float
	lwc1	$f2, milisec		#load the divisor 1000 into $f2
	div.s	$f0, $f1, $f2		#divide the milisecond by 1000 to convert it into sec, store in $f0
	mov.s	$f12, $f0		#move the calculated seconds into $f12 for printing float

	la	$a0, timedisplay	#load the timedisplay message into $a0
	li	$v0, 4			#system call code for printing strinng
	syscall				#print the timedisplay message
	move	$a0, $t3		#load the minutes number into $a0
	li	$v0, 1			#system call code for printing integer
	syscall				#print the minutes to the screen
	la	$a0, minutes		#load the minute string into $a0
	li	$v0, 4			#system call code for printing string
	syscall				#print the minute string to the screen
	li	$v0, 2			#system call code for printing float point number
	syscall				#print the second number to the screen
	la	$a0, seconds		#load the seconds string to $a0
	li	$v0, 4			#system call number for printing string
	syscall				#print the seconds string to the screen
	jr	$ra

Righttone:
	# Play a sound when the user's guess is correct.
	li	$a0, 83			#$a0 stores the pitch of the tone
	li	$a1, 250		#$a1 stores the length of the tone
	li	$a2, 112		#$a2 stores the instrument of the tone
	li	$a3, 100		#$a3 stores the volumn of the tone
	li	$v0, 33			#system call code for MIDI out synchronous
	syscall				#play the first half of the tone
	li	$a0, 79			#$a0 stores the pitch of the tone
	li	$a1, 250		#$a1 stores the length of the tone
	li	$a2, 112		#$a2 stores the insrument of the tone
	li	$a3, 100		#$a3 stores the volumn of the tone
	li	$v0, 33			#system call code for MIDI out synchronous
	syscall				#play the second half of the tone
	jr	$ra

Wrongtone:
	# Play a sound when the user's guess is incorrect.
	li	$a0, 50			#$a0 stores the pitch of the tone
	li	$a1, 1000		#$a1 stores the length of the tone
	li	$a2, 16			#$a2 stores the insrument of the tone
	li	$a3, 127		#$a3 stores the volumn of the tone
	li	$v0, 31			#system call code for MIDI out
	syscall				#play the tone
	jr	$ra
