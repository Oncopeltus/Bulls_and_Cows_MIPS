# Bulls_and_Cows_MIPS
The program Bulls & Cows is a word-guessing game written in MIPS assembly language. This game randomly chooses a word from a list of 100 words. The word is a real four-letter word that has no duplicate letter and all lower case. The user needs to guess what the word is. Based on the user’s guess, the result will be shown as “#a Bulls and #b Cows”, indicating the numbers of letters on the right position and on the wrong position, respectively. If the user guesses the word correctly (4 bulls), the game will end and show the total time spent, whereas if the user chooses to give up, the game will end and display the correct word.
## System Requirement

This game is written in MIPS assembly language and needs MARS (MIPS Assembler and Runtime Simulator, Missouri State University) to run. For the installation and instruction on how to run MARS, please refer to the official website:
http://courses.missouristate.edu/KenVollmar/mars/

## Files Directory
- ListGenerator.jar		-- The generator to make a new list of words
- library.txt				  -- The library that contains hundreds of 4-letter words
- list.txt					  -- The current word list that is used by the game
- Bulls_and_Cows.asm  -- The game program

## Play the game

1.	In each guess, the player needs to first input either 1 to play, or 0 to give up.
2.	
- If the player chooses to play, follow the prompt message to input a 4-letter word, then press Enter. 
Warning: the input word has to contain exactly 4 non-repeated lower case letters. Violations of these rules will not count as valid input, and will generate prompt messages asking the player to correct the invalid input.

- If the player chooses to give up, the game will end and the correct answer will be given to the player.
3.	Upon a valid input of a 4-letter word, the Run I/O box will then display the result as “x Bulls and y Cows”. "Bull" means letters in the right positions, while “Cow” means letters in the wrong position. 
a)	The player wins the game if there are four “Bulls”, and the game ends.
b)	If there are less than 4 “Bulls”, a new round will begin, player will be prompted to repeat from Step 1 of “Play the game”.
4.	The game ends either by winning or giving up. To restart a game, please start from Step 2 of “Starting Up”.

## Bonus features

1.	Upon winning, the player will be rewarded with a winning tone, and the time spent will be shown.
2.	If the player gives up, the failure tone will sound.
3.	File “list.txt” contains the current word list that is used by the game. The player can change the list by running “ListGenerator.jar” under the same directory.
