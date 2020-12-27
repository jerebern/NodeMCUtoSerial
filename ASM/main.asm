;
;==========================================================================================================================================================================
;		
;
;				JEREMY BERNARD 
;					
;					DEBUT
;				  2020-12-17
;					
;				  
;==========================================================================================================================================================================
         .MODEL    small          ; 
         .STACK    512            ; Taille de la pile
;==========================================================================================================================================================================

.DATA

RX_car DB ?
TX_car DB ?
Menu_choice DB ?
str_length  DW 0
Continue    DB 0;
Trash  dw 0

;String
RX_str db 99 dup(?)
TX_str db 99 dup(?)
Menu_str db 'MENU$'
Menu_GUI_str db '=========$'
Menu_Choice_1_str db '1.Configurer WiFi$'
WiFi_ssid_str db 'Enter WiFi ssid : $'
WiFi_password_str db 'Enter WiFi password : $'



.CODE

listing:
	true 		   EQU 1								;#define true 1
	false 		   EQU 0
    
    MOV AX, @DATA
	MOV DS,AX

    CALL Init_Com

    MOV  DX, OFFSET Menu_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV DX, OFFSET Menu_GUI_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV       AH, 08			
	INT       33		      ;Menu  = getchar();
	MOV       Menu_choice, AL

    MOV AL,Menu_choice
    MOV AH,0
    PUSH AX
    CALL TX_Com
    POP trash 

switch_menu_choice:
    CMP Menu_choice, '1'
    JNE e_switch_menu_choice_c1


    MOV DX, OFFSET WiFi_ssid_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash 
    MOV str_length,0  
    MOV Continue,true 
while_SSID_str:
    MOV       AH, 08			
	INT       33		            ;input  = getchar();
	MOV       TX_car, AL
    MOV       AH, 2		           ;printf("%c",input)
    MOV       DL, TX_car
    INT       33
    ;MOV SI,str_length
    ;MOV TX_str[SI],TX_car
    ;INC str_length
    
    MOV AL,TX_car
    MOV AH,0
    PUSH AX
    CALL TX_Com
    POP trash 

if_SSID_str:                        ;if(car == return)
    CMP TX_car,13
    JNE e_if_SSID_str
    MOV Continue, false

    
e_if_SSID_str:
    CMP Continue,true
    JE while_SSID_str

e_while_SSID_str:
    MOV Continue, true

    MOV DX, OFFSET WiFi_password_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash    


switch_menu_choice_c1:


e_switch_menu_choice_c1:

e_switch_menu_choice:

eop:     	
    MOV       AX, 4C00h
	INT       33


;===========================================================================================================================================================================		
;											FIN	PROGRAMME
;===========================================================================================================================================================================
;===========================================================================================================================================================================			
;											INCLUDE
;===========================================================================================================================================================================
  	INCLUDE com.asm
    INCLUDE text.asm

END listing