; multi-segment executable file template.

data segment
    n=20
    WELCOME_MSG DB "Welcome to the Base Converter!$"
    ACTION_MSG DB 10,13,"Choose your number base",10,13,"< 'H' - Hexa, 'B' - Binary, 'O' - Octal, 'D' - Decimal >",10,13,"$"
    ERROR_MSG_BASE DB 10,13,"Wrong input!$"  
    BYE_MSG DB 10,13,"Bye Bye :)$" 
    LONG_MSG DB 10,13,"Input is too long for that base",10,13,"< BIN - 16 | OCT - 6 | DEC - 5 | HEX - 4 >$"
    
    BADNUM_MSG DB 10,13,"Invalid characters!$"
    BADNUM DB 0
    
    INPUT_MSG DB 10,13,"Enter your number: $"
    NUMBER DB N+1, ?, N+1 DUP("$")
     
    END_MSG DB 10,13,"Would you like to start again(Y/N)? ",10,13,"$" 
    HEX_MSG DB 10,13,"Hexadecimal number = $"
    BIN_MSG DB 10,13,"Binary number = $"
    OCT_MSG DB 10,13,"Octal number = $"
    DEC_MSG DB 10,13,"Decimal number = $"
     
    HELP_STR DB 20 DUP("$") 
    HEX_VALUE DB 5 DUP("$")
    BIN_VALUE DB 17 DUP("$")
    OCT_VALUE DB 7 DUP("$")
    DEC_VALUE DB 6 DUP("$")
    
    BASE DW ? 
    ORIGINAL_BASE DB ?       
    
    VALUE DW 0 
    
    ISFIRST DB 0 
    ISNEGATIVE DB 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    
    LEA DX, WELCOME_MSG ; PRINTING WELCOME MESSAGE
    MOV AH, 9
    INT 21H
     
BEGINING:           
    LEA DX, ACTION_MSG ; ASKING FOR BASE
    MOV AH, 9
    INT 21H      
    
  
    MOV AH, 1 ; WAITING FOR INPUT
    INT 21H
    
    CMP AL, 61H  ; CHECKING IF INPUT IS LOWERCASE LOWER THAN 'a'
    JB INPUT
    
    CMP AL, 7AH  ; CHECKING IF INPUT IS LOWERCASE HIGHER THAN 'z'
    JA INPUT
    
    XOR AL, 20H  ; TURNING THE LOWERCASE TO UPPERCASE
    
INPUT:
    CMP AL, 'H'
    JZ HEXA
    
    CMP AL, 'B'
    JZ BINARY
    
    CMP AL, 'O'
    JZ OCTAL
    
    CMP AL, 'D'
    JZ DECIMAL 
    
    LEA DX, ERROR_MSG_BASE ; PRINTING WRONG INPUT MESSAGE
    MOV AH, 9
    INT 21H
    JMP BEGINING
    
HEXA:
    MOV BASE, 16
    MOV ORIGINAL_BASE, 16
    JMP GETNUMBER
    
BINARY:
    MOV BASE, 2
    MOV ORIGINAL_BASE, 2
    JMP GETNUMBER
    
OCTAL:
    MOV BASE, 8
    MOV ORIGINAL_BASE, 8  
    JMP GETNUMBER
    
DECIMAL:
    MOV BASE, 10
    MOV ORIGINAL_BASE, 10      
    
GETNUMBER:
    MOV BADNUM, 0
    MOV VALUE, 0
    CALL RESETNUMBER
    MOV ISFIRST, 0
    LEA DX, INPUT_MSG  ; ASKING FOR A NUMBER
    MOV AH, 9
    INT 21H
    
    MOV DX, OFFSET NUMBER
    MOV AH, 0AH
    INT 21H   
    
    CALL CALCVALUE
    CMP BADNUM, 0
    JNZ GETNUMBER
    
    CMP ORIGINAL_BASE, 2
    JNZ TESTOCT
       
    LEA DX, OCT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, OCT_VALUE
    MOV AH, 9
    INT 21H 
  
    LEA DX, DEC_MSG
    MOV AH, 9
    INT 21H
    LEA DX, DEC_VALUE
    MOV AH, 9
    INT 21H
      
    LEA DX, HEX_MSG
    MOV AH, 9
    INT 21H
    LEA DX, HEX_VALUE
    MOV AH, 9
    INT 21H 

    
    JMP FINISH

TESTOCT:
    CMP ORIGINAL_BASE, 8
    JNZ TESTDEC
    
    LEA DX, BIN_MSG
    MOV AH, 9
    INT 21H
    LEA DX, BIN_VALUE
    MOV AH, 9
    INT 21H 
   
    LEA DX, DEC_MSG
    MOV AH, 9
    INT 21H
    LEA DX, DEC_VALUE
    MOV AH, 9
    INT 21H
    
    LEA DX, HEX_MSG
    MOV AH, 9
    INT 21H
    LEA DX, HEX_VALUE
    MOV AH, 9
    INT 21H 
    
    JMP FINISH

TESTDEC:
    CMP ORIGINAL_BASE, 10
    JNZ TESTHEX
    
    LEA DX, BIN_MSG
    MOV AH, 9
    INT 21H
    LEA DX, BIN_VALUE
    MOV AH, 9
    INT 21H 
    
    LEA DX, OCT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, OCT_VALUE
    MOV AH, 9
    INT 21H 
    
    LEA DX, HEX_MSG
    MOV AH, 9
    INT 21H
    LEA DX, HEX_VALUE
    MOV AH, 9
    INT 21H 
    JMP FINISH
    
TESTHEX:

    LEA DX, BIN_MSG
    MOV AH, 9
    INT 21H
    LEA DX, BIN_VALUE
    MOV AH, 9
    INT 21H 
    
    LEA DX, OCT_MSG
    MOV AH, 9
    INT 21H
    LEA DX, OCT_VALUE
    MOV AH, 9
    INT 21H 
    
    LEA DX, DEC_MSG
    MOV AH, 9
    INT 21H
    LEA DX, DEC_VALUE
    MOV AH, 9
    INT 21H 
    
FINISH:
    LEA DX, END_MSG ; PRINTING ENDING MESSAGE, ASKING IF YOU WANT TO ENTER ANOTHER NUMBER
    MOV AH, 9
    INT 21H
    
    MOV AH, 1 ; WAITING FOR INPUT
    INT 21H
    
    CMP AL, 'a' ; CHECKING IF INPUT IS LOWERCASE LOWER THAN 'a'
    JB CONT
    
    CMP AL, 'z' ; CHECKING IF INPUT IS LOWERCASE HIGHER THAN 'z'
    JA CONT
    
    XOR AL, 20H ; TURNING THE LOWERCASE TO UPPERCASE

CONT:
    CMP AL, 'Y'
    JNZ NEXTCHECK
    MOV VALUE, 0
    MOV ISFIRST, 0 
    JMP BEGINING
    
NEXTCHECK:
    CMP AL, 'N'
    JNZ WRONGINPUT
    JMP EXIT
    
WRONGINPUT:
    LEA DX, ERROR_MSG_BASE ; ERROR MESSAGE IF INPUT ISN'T Y OR N
    MOV AH, 9
    INT 21H
    JMP FINISH  ; GOING BACK TO ASKING WHETHER YOU WANT TO TRY AGAIN OR NO
    
EXIT:   
    
    LEA DX, BYE_MSG
    MOV AH, 9
    INT 21H
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

CALCVALUE PROC
    CALL CHECKLENGTH
    MOV AX, 0                       
    MOV AL, NUMBER[1]          
    DEC AX               
    MOV DI, AX           
    ADD DI, 2            
CHECKPOINT:  
    SUB NUMBER[DI], 30H    
    CALL VERIFY
    CMP BADNUM, 0
    JNZ FAIL          
BEGIN:
    CMP ISFIRST, 0
    JNZ POWER
    MOV AL, NUMBER[DI]  
    ADD VALUE, AX        
    INC ISFIRST
    MOV BX, 1          
 POWER:                   
    DEC DI
    CMP NUMBER[1], 1
    JZ BUILD                
    SUB NUMBER[DI], 30H  
    CALL VERIFY
    CMP ISNEGATIVE, 1
    JZ NEGATIVE
    CMP BADNUM, 0
    JNZ FAIL          
    MOV CX, BX                                                   
    MOV AX, 0                                                    
    MOV AL, NUMBER[DI]
    MOV DX, 0   
  POWERLOOP:
    MUL BASE           
    LOOP POWERLOOP
    ADD VALUE, AX
    ADD VALUE, DX 
    INC BX
    CMP DI, 2
    JNZ POWER
    JMP BUILD
 NEGATIVE:
    NEG VALUE
 BUILD:
    CALL CLEARVALUES
    MOV BASE, 8
    CALL BUILDOCTAL 
    MOV BASE, 16
    CALL BUILDHEXA
    MOV BASE, 10
    CALL BUILDDECIMAL
    CALL BUILDBINARY
FAIL:
    RET
ENDS

BUILDBINARY PROC
    MOV AX, VALUE
    MOV CX, 16
    MOV BX, 0
 SHLOOP:  
    SHL AX, 1   
    ADC BIN_VALUE[BX], 12D
    INC BX
    LOOP SHLOOP
    RET 
    
ENDS
 
CLEARVALUES PROC
    MOV CX, 16
    MOV DI, 0
 CLEARLOOP:
    MOV BIN_VALUE[DI], '$'
    INC DI
    LOOP CLEARLOOP
    
    MOV CX, 16
    MOV DI, 0
 CLEARLOOP1:
    MOV BIN_VALUE[DI], '$'
    INC DI
    LOOP CLEARLOOP1
    
    MOV CX, 6
    MOV DI, 0
 CLEARLOOP2:
    MOV OCT_VALUE[DI], '$'
    INC DI
    LOOP CLEARLOOP2
     
    MOV CX, 5
    MOV DI, 0
 CLEARLOOP3:
    MOV DEC_VALUE[DI], '$'
    INC DI
    LOOP CLEARLOOP3
    
    MOV CX, 4
    MOV DI, 0
 CLEARLOOP4:
    MOV HEX_VALUE[DI], '$'
    INC DI
    LOOP CLEARLOOP4     
    RET
ENDS 

BUILDOCTAL PROC
    MOV DI, 0
    MOV AX, VALUE
OCTLOOP:
    MOV DX, 0
    DIV BASE
    ADD DL, 30H
    MOV HELP_STR[DI], DL
    INC DI
    CMP AX, 0
    JNZ OCTLOOP
    MOV DI, 0
    MOV BX, 0
 COUNT:
    CMP HELP_STR[BX], '$'
    JZ NEXT_OCT
    INC BX
    JMP COUNT
 NEXT_OCT:
    MOV DI, 0
    MOV CX, BX
    DEC BX
 SWAPPING:
    MOV AX, 0
    MOV AL, HELP_STR[DI]
    XCHG AL, OCT_VALUE[BX]
    DEC BX
    INC DI
    LOOP SWAPPING
    CALL RESET_HELP_STR
    RET
ENDS 

BUILDHEXA PROC
    MOV DI, 0
    MOV AX, VALUE
HEXLOOP:
    MOV DX, 0
    DIV BASE
    ADD DL, 30H
    MOV HELP_STR[DI], DL
    INC DI
    CMP AX, 0
    JNZ HEXLOOP
    MOV DI, 0
    MOV BX, 0
 COUNT1:
    CMP HELP_STR[BX], '$'
    JZ NEXT_HEX
    INC BX
    JMP COUNT1
 NEXT_HEX:
    MOV DI, 0
    MOV CX, BX
    DEC BX
 SWAPPING2:
    MOV AX, 0
    MOV AL, HELP_STR[DI]
    XCHG AL, HEX_VALUE[BX]
    CMP HEX_VALUE[BX], 39H
    JA ADDINGSEVEN 
CONTHEXA:
    DEC BX
    INC DI
    LOOP SWAPPING2
    CALL RESET_HELP_STR
    RET
    
ADDINGSEVEN:
    ADD HEX_VALUE[BX], 7H
    JMP CONTHEXA
ENDS

BUILDDECIMAL PROC
    MOV DI, 0
    MOV AX, VALUE
DECLOOP:
    MOV DX, 0
    DIV BASE
    ADD DL, 30H
    MOV HELP_STR[DI], DL
    INC DI
    CMP AX, 0
    JNZ DECLOOP
    MOV DI, 0
    MOV BX, 0
 COUNT2:
    CMP HELP_STR[BX], '$'
    JZ NEXT_DEC
    INC BX
    JMP COUNT2
 NEXT_DEC:
    MOV DI, 0
    MOV CX, BX
    DEC BX
 SWAPPING3:
    MOV AX, 0
    MOV AL, HELP_STR[DI]
    XCHG AL, DEC_VALUE[BX]
    DEC BX
    INC DI
    LOOP SWAPPING3
    CALL RESET_HELP_STR
    RET
ENDS
 
 
VERIFY PROC
    CMP NUMBER[DI], 0FDH
    JNZ CONVER
    CMP DI, 2
    JNZ WRONG
    CMP NUMBER[1], 1
    JE WRONG
    MOV ISNEGATIVE, 1
    RET

CONVER: 
    CMP BASE, 2
    JNZ NOTBINARY
    CMP NUMBER[DI], 1
    JBE CHECKBINARY
    JA WRONG 
    
NOTBINARY:
    CMP BASE, 8
    JNZ NOTOCTAL
    CMP NUMBER[DI], 7
    JBE CHECKOCTAL
    JA WRONG
    
NOTOCTAL:
    CMP BASE, 10
    JNZ NOTDECIMAL
    CMP NUMBER[DI], 9
    JBE CHECKDECIMAL
    JA WRONG
    
NOTDECIMAL:
    CMP NUMBER[DI], 31H
    JB UPPERCASE
    CMP NUMBER[DI], 36H
    JA WRONG
    SUB NUMBER[DI], 20H
UPPERCASE:   
    CMP NUMBER[DI], 16H
    JA WRONG
    JBE REMOVELETTER 
    
CHECKBINARY:
    CMP BASE, 2
    JZ EXIT5
    JMP NOTBINARY
    
CHECKOCTAL:
    CMP NUMBER[DI], 0
    JB WRONG
    JMP EXIT5
    
CHECKDECIMAL:    
    CMP BASE, 10 
    JZ EXIT5
    JNZ NOTDECIMAL 
    
 REMOVELETTER:
    CMP NUMBER[DI], 11H
    JB CHECKBASE
    SUB NUMBER[DI], 7H
    JMP EXIT5 
    
 CHECKBASE:
    CMP BASE, 2
    JNZ CHECK1
    CMP NUMBER[DI], 1
    JA WRONG
    
 CHECK1:
    CMP BASE, 8
    JNZ CHECK2
    CMP NUMBER[DI], 7
    JA WRONG
    
 CHECK2:
    CMP BASE, 10
    JNZ CHECK3
    CMP NUMBER[DI], 9
    JA WRONG
    
  CHECK3:
    JMP EXIT5
        
 WRONG:
        LEA DX, BADNUM_MSG
        MOV AH, 9
        INT 21H 
        MOV BADNUM, 1
 EXIT5:
    RET
ENDS
 
CHECKLENGTH PROC
    CMP BASE, 2
    JNZ BASE1
    CMP NUMBER[1], 16
    JA TOOLONG
  BASE1:
    CMP BASE, 8
    JNZ BASE2
    CMP NUMBER[1], 6
    JA TOOLONG
  BASE2:
    CMP BASE, 10
    JNZ BASE3
    CMP NUMBER[1], 5
    JA TOOLONG
  BASE3:
    CMP BASE, 16
    JNZ BASE4
    CMP NUMBER[1], 4
    JA TOOLONG
  BASE4:
    RET
 TOOLONG:
    LEA DX, LONG_MSG
    MOV AH, 9
    INT 21H
    JMP GETNUMBER 
ENDS
 
RESET_HELP_STR PROC
    MOV DI, 0
 LOOPOINT:
    CMP HELP_STR[DI], '$'
    JZ EXIT0
    MOV HELP_STR[DI], '$'
    INC DI
    JMP LOOPOINT
  EXIT0:
    RET
ENDS
  
RESETNUMBER PROC
    MOV DI, 2
 LOOPOINT1:
    CMP NUMBER[DI], '$'
    JZ EXIT01
    MOV NUMBER[DI], '$'
    INC DI
    JMP LOOPOINT1
  EXIT01:
    RET
ENDS  
end start ; set entry point and stop the assembler.
