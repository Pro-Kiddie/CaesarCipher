; Assembler = x86 (NASM)

; ROT 13 is a special case of the Caesar cipher, developed in acient Rome. It is a simple letter
; substitution cipher that replaces a letter with the letter 13 letters after it in the alphabet.

%include "io.inc" 

; Section to store variables
section .data
KEY: db 14; constant KEY value
string_msg: db "Enter a string (Max=64 characters): ", 0h ; Followed by the string terminator
string_in: times 65 db 0h; max = 64 char, last ch = string terminator
string_out: times 65 db 0h; Use to store encrypted text, max = 64 char, last ch = string terminator

; Start of program
global _main
section .text

_main:
    mov ebp, esp; for correct debugging
    PRINT_STRING string_msg; prompt user for string to be encrypted
    GET_STRING string_in, 65; store input in variable string_in

    xor eax, eax; to make eax value 0
    xor ebx, ebx; to make ebx value 0
    xor ecx, ecx; to make ecx value 0
    
_forLoop: ; loop through every character of the string_in
    mov al, byte[string_in + ebx]; Move char into al
    cmp al, 0h; CHECK CONDITION; 
    je _result; CONDITION FALSE BREAK LOOP
    
    ;check if it is alphabet, if not alphabet put in output and skip the iteration    
    ;if alphabet, (al > 64 && al < 91)  || (al > 96 && al < 123) ( 64 < al < 91 OR 96 < al < 123 ) Other values are non-alphabet 
    _upperCase:    
        cmp al, 64 
        jng _dontEncrypt; a1 < 64, not alphabet, don't encrypt
        cmp al, 91
        jnl _lowerCase; al => 91, check if it is lowercase
        jmp _encryptUpper; 64 < al < 91, char is uppercase, encrypt

    _lowerCase:    
        cmp al, 96; al here must be be greater than 91  
        jng _dontEncrypt; 91 <= al <= 96, dont encrypt
        cmp al, 123
        jnl _dontEncrypt; al >= 123, dont encrypt
        

    _encryptLower:
        sub al, 97; 97 = 'a'
        cmp al, [KEY]; check if char < KEY
        jnge _lowerCharLessThanKEY
        add al, [KEY]; Encrypt
        mov cl, 26
        xor ah, ah; must clear ah value to 0 before division as ax(ah+al) value will read read as dividend; might have garbage in ah
        div cl; %26 as char greater or equal to KEY 
        mov al, ah; move the reminder into eax
        add al, 97; convert the value back to lowercase
        mov byte[string_out + ebx], al ; store the encrypted lowercase in result
        jmp _forLoopInc ; go to end of for loop for this iteration

    _encryptUpper:
        sub al, 65; 65 = 'A'
        cmp al, [KEY]; check if char < KEY
        jnge _upperCharLessThanKEY
        add al, [KEY]; Encrypt
        mov cl, 26
        xor ah, ah; must clear ah value to 0 before division as ax(ah+al) value will read read as dividend; might have garbage in ah
        div cl; %26 as char greater or equal to KEY 
        mov al, ah; move the reminder into eax
        add al, 65; convert the value back to uppercase
        mov byte[string_out + ebx], al; store the encrypted uppercase in result
        jmp _forLoopInc ; go to end of for loop for this iteration

    _upperCharLessThanKEY:
        add al, [KEY];encrypt straight away as alphabet before 'N'
        add al, 65; convert value back to uppercase
        mov byte[string_out + ebx], al; store in string_out
        jmp _forLoopInc; go to end of for loop for this iteration
    
    _lowerCharLessThanKEY:
        add al, [KEY];encrypt ;encrypt straight away as alphabet before 'n'
        add al, 97; convert value back to lowercase
        mov byte[string_out + ebx], al; store in string_out
        jmp _forLoopInc; go to end of for loop for this iteration
    
    _dontEncrypt:
        mov byte[string_out + ebx], al; char is non-alphabet, store straight into result 
                                        
_forLoopInc:    
    inc ebx; increase the counter by 1
    jmp _forLoop ; jump back to begining of the for loop         
                                      
_result:
    PRINT_STRING string_out; display the output.

_end:
xor eax, eax
ret
