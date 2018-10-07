%include "io.inc"

section .data
    %include "input.inc"

    nrcrt dd 0
    sir times 32 db 0
    len db 0 
    dw 0
    db 0

section .text
global CMAIN


printchar:
    add dl, 87
    PRINT_CHAR dl
    jmp goback

print_incorect:
    PRINT_STRING "Baza incorecta"
    NEWLINE
    mov eax,1
    leave 
    ret

clean:
    add esp, 4
    jmp nextstep
    
is_correct_base:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 8]
    cmp ebx, 1
    jle print_incorect
    cmp ebx, 16
    jg print_incorect
    leave
    xor eax, eax
    ret

divide: ;returneza catul efect lateral rest
    push ebp
    mov ebp, esp
    xor edx, edx
    
    xor ebx, ebx
    
    mov eax,[ebp + 8]
    mov ebx,[ebp + 12]
    div ebx
    mov ebx, [ebp + 16] ;adresa unde o sa fie pus restul
    mov dword [ebx], edx ;restul impartirii
    leave
    ret

change_base:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 8]
    sub esp, 4 ;rezerv 4 bytes
    
repeat:
    push esp ;dau un ponter care sa pointezze la acei 4 bytes
    ;cei 4 bytes sunt corepunzatori restuli impartirii
    
    mov ebx, edx ;deimpartit
    mov edx, [ebp + 12] ;baza
    push edx ;baza
    push ebx ;deimpartit
    
    call divide  
     
    add esp, 12
    mov ecx, [len]
    mov bl, [esp]
    mov [sir + ecx],bl
    inc byte [len]
    mov edx, eax
    cmp edx, 0
    jnz repeat
    mov ecx, [len]
print: ;este for ecx mai mare ca 0
    dec ecx
    mov dl,[sir + ecx]
    cmp dl, 9
    jg printchar
    PRINT_UDEC 1,dl
goback:
    cmp ecx, 0
    jnz print
    NEWLINE
    
    leave
    xor eax,eax
    ret

CMAIN:
    push ebp
    mov ebp, esp

nextstep:
    inc dword [nrcrt] 
    mov ecx, [nrcrt]    
    cmp ecx, [nums]
    jg exit
    mov eax,[base_array + 4*ecx -4]
    push eax  ;baza
    call is_correct_base
    cmp eax, 1
    jz clean
    mov eax, [nums_array + 4*ecx -4]
    push eax ;numar
    mov byte [len], 0 ;posibil redundant
    call change_base
    add esp, 8
    jmp nextstep
    
    
exit:
    
    leave
    xor eax, eax
    ret