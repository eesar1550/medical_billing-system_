Title medical billing system
new_line macro cr,lf      
    mov ah,2              ; Set function for displaying a character
    mov dl,cr             ; Move the newline character into DL
    int 21h               ; Call interrupt to print newline
    mov dl,13             ; Move carriage return into DL
    int 21h               ; Call interrupt to print carriage return
endm
.model small
.stack 100h
.data
input_password db "Please Enter your password:$"          ; Message for password input
password db "eesarasad$"      ; Stored password
invalid_password db 10,13,"Invalid password"  ; Message for invalid password
 ;Welcome message 
a1 db 10,13, '$'
a2 db 10,13, '       ***************************************$'
a3 db 10,13, '     **                  Welcome              **$'
a4 db 10,13, '******                     To                  ******$'
a5 db 10,13, '     **            E.A Medical Complex        **$'
a6 db 10,13, '       ***************************************$'
a7 db 10,13, '$', 10,13              
msg1 db 10,13,10,13,"Choose an option of your choice$"               ; Menu prompt
msg2 db 10,13,10,13,"Which medicine did costumer buy.$"              ; Purchase prompt   
msg_med db 10,13,"Press 1 to input the medicines sold.$"             ; Option 1 for buying medicines
med_sold db 10,13,"Press 2 to check inventory.$"                 ; Option 2 for inventory check
input_again db 10,13,"Press one of the given keys.$"             ; Prompt to retry input
wrong_input db 10,13,"Wrong input$"                              ; Message for wrong input
exit_prog db 10,13,"press 4 to exit$"                            ; Option to exit the program
opt1 db 10,13, "1-Panadol-50rs$"                                 ; Medicine option 
opt2 db 10,13, "2-Paracetamol-90rs$"                             ; Medicine option 
opt3 db 10,13, "3-Aspirin-60rs$"                                 ; Medicine option 
opt4 db 10,13, "4-Brufin-100rs$"                                 ; Medicine option 
opt5 db 10,13, "5-Arenac-80rs$"                                  ; Medicine option 
new_line 10,13      ; Macro for newline
msg_panadol db 10,13,"How many panadol did the customer buy:$"         ; Prompt for Panadol
msg_paracetamol db 10,13,"How many paracetamol did the customer buy:$" ; Prompt for Paracetamol
msg_aspirin db 10,13,"How many aspirin did the customer buy:$"         ; Prompt for Aspirin
msg_brufin db 10,13,"How many brufin did the customer buy:$"           ; Prompt for Brufin
msg_arenac db 10,13,"How many arenac did the customer buy:$"           ; Prompt for Arenac
total_msg dw "TOTAL EARNED: $"        ; Display earned amount
price_panadol dw '50'                 ;Price of the medicine
price_paracetamol dw '90'             ;Price of the medicine
price_aspirin dw '60'                 ;Price of the medicine
price_brufin dw '100'                 ;Price of the medicine
price_arenac dw '80'                  ;Price of the medicine
amount_earned db 10,13,"Amount earned:$"
amount dw 0
amount_print db 10,13,"Press 3 to view the amount earned: $" ; Prompt to view earnings
panadol_sold db 0                                            ; Counter for Panadols sold
paracetamol_sold db 0                                        ; Counter for Paracetamols sold
aspirin_sold db 0                                            ; Counter for Aspirins sold
brufin_sold db 0                                             ; Counter for Brufins sold
arenac_sold db 0                                             ; Counter for Arenacs sold
panadol_print db 10,13,"Panadols sold:$"                     ; Display Panadols sold
paracetamol_print db 10,13,"Paracetamols sold:$"             ; Display Paracetamols sold
aspirin_print db 10,13,"Aspirins sold:$"                     ; Display Aspirins sold
brufin_print db 10,13,"Brufins sold:$"                       ; Display Brufins sold
arenac_print db 10,13,"arenacs sold:$"                       ; Display Arenacs sold

.code                                    ; Start of the code segment
main proc                                ; Main procedure 
    mov ax,@data                         ; Initialize data segment 
    mov ds,ax                            ; Load DS with the address of data segment
    ; Prompt user to enter password
    mov dx,offset input_password
    mov ah,9
    int 21h
    new_line 10,13                       ; Print newline and carriage return
    mov bx,offset password               ; Load password address into BX
    mov cx,9                             ; password length is 9 words
    
    l1: ; Loop to validate password character by character
    mov ah,7                             ; Input character without echo
    int 21h                              
    mov ah,2                             ; Echo '*' for input characters
    cmp al,[bx]                          ; Compare input with stored password
    jne incorrect                        ; Jump to error if characters mismatch
    mov dl,'*'                           ; Output an asterisk for the character
    int 21h
    inc bx                               ; Move to the next character of the password
    loop l1                              ; Repeat for all characters
    
    start:
    new_line 10,13
    call menu                            ; Display the menu options
    
    new_line 10,13
    
    mov ah,1                             ; Take single-character input
    int 21h                              ; Read user input
    
    cmp al,'1'                           ; Check if input is '1'
    je menu2                             ; If yes, go to menu2 for medicines
    cmp al,'2'                           ; Check if input is '2'
    je medicines_stats                   ; If yes, display medicine stats
    cmp al,'3'                           ; Check if input is '3'
    je show_amount                       ; If yes, display amount earned
    cmp al,'4'                           ; Check if input is '4'
    je exit                              ; If yes, exit the program
    ; Handle invalid input
    mov dx,offset wrong_input
    mov ah,9
    int 21h
    mov dx,offset input_again
    mov ah,9
    int 21h
    jmp start                           ; Return to the start to retry input
    
    panadol:
    
    mov dx,offset msg_panadol           ; Display message for Panadol
    mov ah,9
    int 21h
    
    new_line 10,13
    
    mov ah,1                            ; Get input from the user for quantity of Panadol sold(only one character)
    int 21h
    sub al,48                           ; Convert ASCII input to numeric value
    add panadol_sold,al                 ; Update the total count of Panadol sold
    add al,48                           ; Convert back to ASCII for processing
    and al,0fh                          ; Mask the input and price values
    and price_panadol,0fh
    mul price_panadol                   ; Calculate total price for Panadol (price x quantity)
    aam                                 ; Adjust AX for proper BCD formatting
    or ax, 3030h                        ; Convert result to ASCII
    ; Add the computed amount to the total earned
    add amount,ax
    mov cx,ax                           ; Save the result in CX for display
    new_line 10,13
    ; Display the total price for this transaction
    mov dx,offset total_msg
    mov ah,9
    int 21h
    mov dl,ch                           ; Display high byte
    mov ah,2
    int 21h 
    mov dl,cl                           ; Display low byte
    int 21h
    mov dl,'0'
    int 21h
    ; Jump back to the main loop
    jmp start
    ; same instructions as in panadol
    paracetamol:
    
    mov dx,offset msg_paracetamol
    mov ah,9
    int 21h
    
    new_line 10,13
    
    mov ah,1
    int 21h
     mov ah,0
    sub al,48
    add paracetamol_sold,al 
    add al,48
    and al,0fh
    and price_paracetamol,0fh
    mul price_paracetamol
    aam
    or ax, 3030h
    
    add amount,ax
    mov cx,ax
    new_line 10,13
    mov dx,offset total_msg
    mov ah,9
    int 21h
    mov dl,ch
    mov ah,2
    int 21h 
    mov dl,cl
    int 21h
    mov dl,'0'
    int 21h
    
    jmp start
    ; same instructions as in panadol
    aspirin:
    
    mov dx,offset msg_aspirin
    mov ah,9
    int 21h
    
    new_line 10,13
    
    mov ah,1
    int 21h
     mov ah,0
    sub al,48
    add aspirin_sold,al 
    add al,48
    and al,0fh
    and price_aspirin,0fh
    mul price_aspirin
    aam
    or ax, 3030h
    
    add amount,ax
    mov cx,ax
    new_line 10,13
    mov dx,offset total_msg
    mov ah,9
    int 21h
    mov dl,ch
    mov ah,2
    int 21h 
    mov dl,cl
    int 21h
    mov dl,'0'
    int 21h
    
    jmp start
    
    brufin:
    ; same instructions as in panadol
    mov dx,offset msg_brufin
    mov ah,9
    int 21h
    
    new_line 10,13
    
    mov ah,1
    int 21h
     mov ah,0
    sub al,48
    add brufin_sold,al 
    add al,48
    and al,0fh
    and price_brufin,0fh
    mul price_brufin
    aam
    or ax, 3030h
    
    add amount,ax
    mov cx,ax
    new_line 10,13
    mov dx,offset total_msg
    mov ah,9
    int 21h
    mov dl,cl
    mov ah,2
    int 21h 
    mov dl,ch
    int 21h
    mov dl,'0'
    int 21h
    
    jmp start
    
    arenac:
    ; same instructions as in panadol
    mov dx,offset msg_arenac
    mov ah,9
    int 21h
    
    new_line 10,13
    
    mov ah,1
    int 21h
    mov ah,0
    sub al,48
    add arenac_sold,al 
    add al,48
    and al,0fh
    and price_arenac,0fh
    mul price_arenac
    aam
    or ax, 3030h
    
    add amount,ax
    mov cx,ax
    new_line 10,13
    mov dx,offset total_msg
    mov ah,9
    int 21h
    mov dl,ch
    mov ah,2
    int 21h 
    mov dl,cl
    int 21h
    mov dl,'0'
    int 21h
    
    jmp start
    
    show_amount:
    ; Display the total amount earned so far
    mov dx,offset amount_earned            ; Display "Total Amount Earned:"
    mov ah,9
    int 21h      
    
    mov cx,amount                          ; Load total amount earned

    mov dl,ch                              ; Display high byte of the amount
    mov ah,2
    int 21h                                ; Display low byte of the amount
    mov dl,cl
    int 21h
    mov dl,'0'                             ; Add padding '0'
    int 21h
    ; Jump back to main loop
    jmp start
    
    incorrect:
    ; Handle incorrect password scenario
    mov dx, offset invalid_password       ; Display "Invalid Password" message
    mov ah,9
    int 21h
    jmp exit                              ; Terminate program
    ; Exit the program
    exit:
    mov ah,4ch
    int 21h
    ; End of main procedure
main endp
    
    menu proc 
        ;wellcome message
        mov ah,9
        lea dx,a1
        int 21h
        lea dx,a2
        int 21h
        lea dx,a3
        int 21h
        lea dx,a4
        int 21h
        lea dx,a5
        int 21h
        lea dx,a6
        int 21h
        lea dx,a7
        int 21h
        
    
        mov dx,offset msg1     ; Prompt to choose an option
        mov ah,9
        int 21h
        
        mov dx,offset msg_med  ; Display option 1: Buy medicines
        mov ah,9
        int 21h
        
        mov dx,offset med_sold ; Display option 2: Check inventory
        mov ah,9
        int 21h
        
        mov dx,offset amount_print ; Display option 3: View amount earned
        mov ah,9
        int 21h
        
        mov dx,offset exit_prog    ; Display option 4: Exit
        mov ah,9
        int 21h
        
        ret                        ; Return to caller
        menu endp
    
    menu2 proc
        ; Procedure for buying medicines
        mov dx,offset msg2         ; Prompt for purchase
        mov ah,9
        int 21h
        
        mov dx,offset opt1         ; Display medicine options
        mov ah,9
        int 21h
        
        mov dx,offset opt2
        mov ah,9
        int 21h
        
        mov dx,offset opt3
        mov ah,9
        int 21h
        
        mov dx,offset opt4
        mov ah,9
        int 21h
        
        mov dx,offset opt5
        mov ah,9
        int 21h
        
        new_line 10,13
        
        mov ah,1                 ; Take input for medicine selection
        int 21h
        
        cmp al,'1'               ; Check input against each option
        je panadol               ; if equal jump to the function of panadol
        
        cmp al,'2'               ; Check input against each option
        je paracetamol           ; if equal jump to the function of paracetamol
        
        cmp al,'3'               ; Check input against each option
        je aspirin               ; if equal jump to the function of aspirin
        
        cmp al,'4'               ; same as above
        je brufin
        
        cmp al,'5'               ; same as above
        je arenac
        
        ret
        
        menu2 endp
medicines_stats proc
    ; Display total Panadol sold
    mov dx, offset panadol_print   ; Load message for Panadol stats (e.g., "Panadol Sold: ")
    mov ah, 9
    int 21h
    mov al, panadol_sold           ; Load the count of Panadol sold
    add al, 48                     ; Convert the count to ASCII
    mov dl, al                     ; Move the ASCII value to DL for output
    mov ah, 2                      ; Set function to display a single character
    int 21h                        ; Print the Panadol count

    ; same as above
    mov dx, offset paracetamol_print
    mov ah, 9
    int 21h
    mov al, paracetamol_sold
    add al, 48 
    mov dl, al
    mov ah, 2
    int 21h

    ; same as above
    mov dx, offset aspirin_print
    mov ah, 9
    int 21h
    mov al, aspirin_sold
    add al, 48  
    mov dl, al
    mov ah, 2
    int 21h

     ; same as above
    mov dx, offset brufin_print
    mov ah, 9
    int 21h
    mov al, brufin_sold
    add al, 48  
    mov dl, al
    mov ah, 2
    int 21h
    
    ; same as above
    mov dx, offset arenac_print
    mov ah,9
    int 21h
    mov al,arenac_sold
    add al,48
    mov dl,al
    mov ah,2
    int 21h
    
    ; Jump back to the start of the program
    jmp start

medicines_stats endp

end main