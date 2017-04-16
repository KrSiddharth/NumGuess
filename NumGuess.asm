DIM1   EQU 30
DIM2   EQU 10

.MODEL SMALL
.CODE

Guessarr   DB  DIM1  DUP(?) 
Round   DB  DIM2  DUP(?) 
Winning   DB  DIM2  DUP(?) 


start:
   
   mov ax,3h
   int 10h

   mov dx,OFFSET WelcomeMessage
   mov ax,SEG WelcomeMessage
   mov ds,ax
   mov ah,9
   int 21h
   mov dx,OFFSET WelcomeMessage_1
   mov ax,SEG WelcomeMessage_1
   mov ds,ax
   mov ah,9
   int 21h
   

   ;LetsGuess
   mov dx,OFFSET LetsGuess
   mov ax,SEG LetsGuess
   mov ds,ax
   mov ah,9
   int 21h

startgame:

   mov ah,2ch
   int 21h
   xor ax,ax
   mov al,dl

   inc ax
   mov num,ax

   cmp ax,9h
   ja startgame
   

   ;prints the dealer no.
   mov ax,num
   add dl, '1'

   mov bl,dl

   mov si, offset Round       ;ax = offset 
   mov ax,roundno
   mov cx,ax

l2:
   add si,2
   loop l2

mov byte ptr [si], bl

add roundno,1
mov guesses,0



readguess:

   mov ax,guesses
   inc ax
   mov guesses,ax

   mov ax,tguesses
   inc ax
   mov tguesses,ax

   mov dx,OFFSET GuessPrompt
   mov ax,SEG GuessPrompt
   mov ds,ax
   mov ah,9
   int 21h

   ;get guess
   mov dx,OFFSET Guess
   mov ax,SEG Guess
   mov ds,ax
   mov ah,3fh
   mov bx,0
   mov cx,1eh
   int 21h
   mov dx,ax
   mov bp,dx

   ;$ to the end!
   mov di,OFFSET Guess
   mov ax,SEG Guess
   mov es,ax
   mov es:[di+bp-2],0124h

   xor cx,cx


checkifnum:

   mov di,OFFSET Guess
   mov ax,SEG Guess
   mov es,ax
   mov bp,cx
   mov al,es:[di+bp]

   cmp al,24h
   je  itisanumber
   cmp al,30h
   jb  itisnotanumber
   cmp al,39h
   ja  itisnotanumber

   inc cx
   jmp checkifnum

itisnotanumber:

   mov dx,OFFSET NotANumber
   mov ax,SEG NotANumber
   mov ds,ax
   mov ah,9
   int 21h
   jmp readguess

itisanumber:

   xor cx,cx
   xor ax,ax

processnum:

   mov di,OFFSET Guess
   mov dx,SEG Guess
   mov es,dx
   mov bp,cx
   mov bl,es:[di+bp]


   cmp bl,24h
   je  numprocessed

   mul ten

   cmp bl,30h
   je  num0
   cmp bl,31h
   je  num1
   cmp bl,32h
   je  num2
   cmp bl,33h
   je  num3
   cmp bl,34h
   je  num4
   cmp bl,35h
   je  num5
   cmp bl,36h
   je  num6
   cmp bl,37h
   je  num7
   cmp bl,38h
   je  num8
   cmp bl,39h
   je  num9
   jmp exit

num9:
   inc ax
num8:
   inc ax
num7:
   inc ax
num6:
   inc ax
num5:
   inc ax
num4:
   inc ax
num3:
   inc ax
num2:
   inc ax
num1:
   inc ax
num0:

   inc cx
   jmp  processnum



numprocessed:


   mov bp, offset Guessarr      ;ax = offset 
   mov cx,tguesses

l4:
   add bp,2
   loop l4



   mov si, offset Winning      ;ax = offset 

   mov cx,roundno

l3:
   add si,2
   loop l3

   mov gnum,ax

   mov ax,gnum
   mov dl,al
   add dl, '0'
   mov byte ptr [bp],dl

   mov bl,dl
   cmp ax,9
   ja  rangeerror
   cmp ax,num
   ja  damntoohigh
   jb  damntoolow
   je  hurray

damntoohigh:

   mov dx,OFFSET TooHigh
   mov ax,SEG TooHigh
   mov ds,ax
   mov ah,9
   int 21h
   cmp guesses,3
   jnb lost
   jmp readguess

damntoolow:

   mov dx,OFFSET TooLow
   mov ax,SEG TooLow
   mov ds,ax
   mov ah,9
   int 21h
   cmp guesses,3
   jnb lost
   jmp readguess

rangeerror:

   mov dx,OFFSET OutOfRange
   mov ax,SEG OutOfRange
   mov ds,ax
   mov ah,9
   int 21h
   cmp guesses,3
   jnb lost
   jmp readguess

lost:
   
   mov bl, '0'
   mov byte ptr [si],bl

   mov dx,OFFSET LostMon
   mov ax,SEG LostMon
   mov ds,ax
   mov ah,9
   int 21h
   jmp wanttoplay

hurray:
   
   cmp guesses,1
   je vict1
   cmp guesses,2
   je vict2
   cmp guesses,3
   je vict3


vict1:

   add bp,2
   mov byte ptr [bp],'-'
   add bp,2
   mov byte ptr [bp],'-'

   add tguesses,2

   mov bl, '2'
   mov byte ptr [si],bl
   

   mov dx,OFFSET Victory1
   mov ax,SEG Victory1
   mov ds,ax
   mov ah,9
   int 21h
   jmp wanttoplay

vict2:
   
   add bp,2
   mov byte ptr [bp],'-'

   add tguesses,1

   mov bl, '1'
   mov byte ptr [si],bl

   mov dx,OFFSET Victory2
   mov ax,SEG Victory2
   mov ds,ax
   mov ah,9
   int 21h
   jmp wanttoplay

vict3:

   mov bl, '5'
   mov byte ptr [si],bl

   mov dx,OFFSET Victory3
   mov ax,SEG Victory3
   mov ds,ax
   mov ah,9
   int 21h
   jmp wanttoplay


wanttoplay:
   cmp roundno,10
   je summaryH
   mov dx,OFFSET PlayAgain
   mov ax,SEG PlayAgain
   mov ds,ax
   mov ah,9h
   int 21h

   mov ah,00h
   int 16h
   mov bl,al

   mov ax,3h
   int 10h

   cmp bl,"y"
   je  pagain
   cmp bl,"Y"
   je  pagain

   cmp bl,"n"
   je  summaryH
   cmp bl,"N"
   je  summaryH

exit:
   
   mov dx,OFFSET ThankYou
   mov ax,SEG ThankYou
   mov ds,ax
   mov ah,9h
   int 21h

   mov ax,4c00h
   int 21h

pagain:
   jmp StartGame

summaryH:

   mov dx,OFFSET Summary
   mov ax,SEG Summary
   mov ds,ax
   mov ah,9h
   int 21h

   mov dx,OFFSET TableH
   mov ax,SEG TableH
   mov ds,ax
   mov ah,9h
   int 21h

   MOV BL,01H
   mov ax,roundno
   mov cx, ax
   lea si,Round
   lea di,Winning
   lea bp,GuessArr
   add di,2
   ;mov ax,SEG Round
   ;redundant mov bl, arr[si]
l1:
   mov dx,OFFSET AddSpace
   mov ax,SEG AddSpace
   mov ds,ax
   mov ah,9h
   int 21h
   
   MOV DH,00H
   MOV DL,BL
   ADD DL,'0'
   MOV AH,02H
   INT 21H
   INC BL

   mov dx,OFFSET AddSpace
   mov ax,SEG AddSpace
   mov ds,ax
   mov ah,9h
   int 21h

   mov dl, [si]
   ;add dl, '0'
   mov ah, 2 
   int 21h
   add si,2



   jmp addlSpace2

backloop2:

   mov dl, [bp]
   ;add dl, '0'
   mov ah, 2 
   int 21h
   add bp,2

   jmp addlSpace1


backloop1:

   mov dl, [bp]
   ;add dl, '0'
   mov ah, 2 
   int 21h
   add bp,2

   jmp addlSpace3

backloop3:

   mov dl, [bp]
   ;add dl, '0'
   mov ah, 2 
   int 21h
   add bp,2


   jmp addlSpace4

backloop4:

   mov dl, [di]
   ;add dl, '0'
   mov ah, 2 
   int 21h
   add di,2

   cmp dl,'1'
   je print0

   cmp dl,'2'
   je print5


backloop:
   mov dx,OFFSET NewLine
   mov ax,SEG NewLine
   mov ds,ax
   mov ah,9h
   int 21h

   loop l1
   jmp exit

print0:
   mov dl,'0'
   mov ah, 2 
   int 21h
   jmp backloop

print5:
   mov dl,'5'
   mov ah, 2 
   int 21h
   jmp backloop

addlSpace1:
   mov dx,OFFSET AddSpace
   mov ax,SEG AddSpace
   mov ds,ax
   mov ah,9h
   int 21h
   jmp backloop1

addlSpace2:
   mov dx,OFFSET AddSpace
   mov ax,SEG AddSpace
   mov ds,ax
   mov ah,9h
   int 21h
   jmp backloop2

addlSpace3:
   mov dx,OFFSET AddSpace
   mov ax,SEG AddSpace
   mov ds,ax
   mov ah,9h
   int 21h
   jmp backloop3

addlSpace4:
   mov dx,OFFSET AddSpaceM
   mov ax,SEG AddSpaceM
   mov ds,ax
   mov ah,9h
   int 21h
   jmp backloop4



.DATA

WelcomeMessage  db  0dh,0ah," Welcome to Casino. Place your bet and win big bucks.",0dh,0ah," For five dollars, you could win back five times your bet.",0dh,0ah," First guess correct, you win 25 bucks. $"
WelcomeMessage_1  db 0dh,0ah," Second guess correct, you win 10 dollars.",0dh,0ah," Third guess correct, you win back your bet.",0dh,0ah,0dh,0ah," Ready to play? $"
EnterName       db  0dh,0ah,0dh,0ah,"Enter your name (max 15 chars): $"
Welcome         db  "Welcome $"
Exclamation     db  "!",0dh,0ah,0dh,0ah,"$"
LetsGuess       db  0dh,0ah,0dh,0ah," Guess a number between 1 and 9!",0dh,0ah,0dh,0ah,"$"
DealerNo        db  0dh,0ah,0dh,0ah,"Dealer's number is: ",0dh,0ah,0dh,0ah,"$"
GuessPrompt     db  " Guess: $"
TooHigh         db  " Your guess is too high!",0dh,0ah,0dh,0ah,"$"
TooLow          db  " Your guess is too low!",0dh,0ah,0dh,0ah,"$"
NotANumber      db  " This is not a number!",0dh,0ah,0dh,0ah,"$"
OutOfRange      db  " Out of range!",0dh,0ah,0dh,0ah,"$"
Victory1        db  " You just won twenty five dollars!",0dh,0ah,0dh,0ah,"$"
Victory2        db  " You just won ten dollars!",0dh,0ah,0dh,0ah,"$"
Victory3        db  " You won your bet back!",0dh,0ah,0dh,0ah,"$"
LostMon         db  " You lost, your bet!",0dh,0ah,0dh,0ah,"$"
OverTen         db  "Over ten guesses? Lame!",0dh,0ah,0dh,0ah,"$"
PlayAgain       db  0dh,0ah," Play again (Y/N)?$"
Summary         db  0dh,0ah," Here is Summary $"
TableH          db  0dh,0ah," Round  DN   G1    G2   G3   Winnings",0dh,0ah, "$"
AddSpace        db  "    $"
AddSpaceM       db  "       $"
TabSpace        db  "         $"
NewLine         db  0dh,0ah,"$"
ThankYou        db  0dh,0ah," Thank you for playing Number Guessing Game!",0dh,0ah,"$"

guesses         dw  0
tguesses        dw  -1
guess3        dw  0
roundno         dw  0
num             dw  0
vic5            dw  5
ptr2            dw  2
aindex		    dw  0
aindexi         dw  0
gnum            dw  0
ten             dw  10
NUMBERS         DW  3,4,5,6,7,8

PlayerName      db  "                                 "
Guess           db  "                                 "

   END   start                                                                                                      