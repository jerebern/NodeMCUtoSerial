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
MainLoop DB 0
ret_Succes DW 0;

;String
RX_str db 99 dup(?)
TX_str db 99 dup(?)
Connexion_Wait_str db 'Waiting for the Arduino on COM1$'
Connexion_Succes_str db 'Connect Succes$'
Menu_str db 'MENU$'
Menu_GUI_str db '==============$'
Menu_Choice_1_str db '1.Configurer WiFi$'
Menu_Choice_2_str db '2.Exit$'
Menu_Choice_user  db 'Enter A valid key : $'
WiFi_ssid_str db 'Enter WiFi ssid : $'
WiFi_password_str db 'Enter WiFi password : $'
Host_add_str      db 'Enter Hostname to PING :$'


.CODE

listing:
	true 		   EQU 1								;#define true 1
	false 		   EQU 0                                ;#define false 0
    
    MOV AX, @DATA
	MOV DS,AX

    CALL Init_Com
    
 ;todo
 ;   MOV  DX, OFFSET Connexion_Wait_str
 ;  PUSH DX
 ;   CALL Print_String
 ;  POP Trash
  ;  PUSH ret_Succes
  ;  CALL AttenteConnexion
  ;   POP ret_Succes
;if_retSucces:        
;    CMP ret_Succes,true
;    JNE e_if_retSucces
;    MOV MainLoop,true   
;e_if_retSucces:

while_main_loop:

    MOV  DX, OFFSET Menu_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV DX, OFFSET Menu_GUI_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV DX, OFFSET Menu_Choice_1_str
    PUSH DX
    CALL Print_String
    POP Trash
    
    MOV DX, OFFSET Menu_Choice_2_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV DX, OFFSET Menu_GUI_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV DX, OFFSET Menu_Choice_user
    PUSH DX
    CALL Print_String_no_space
    POP Trash

    MOV AH, 08			
	INT 33		      ;Menu  = getchar();
	MOV Menu_choice, AL

	MOV TX_car, AL
    MOV AH, 2		           ;printf("%c",input)
    MOV DL, Menu_choice
    INT 33
    

if_Menu_valide_choice:
    CMP Menu_choice,'1'
    JNE e_if_Menu_valide_choice

    MOV AL,Menu_choice
    MOV AH,0
    PUSH AX
    CALL TX_Com
    POP trash 

    MOV AL,13
    MOV AH,0
    PUSH AX
    CALL TX_Com
    POP trash 

e_if_Menu_valide_choice:

switch_menu_choice:
    CMP Menu_choice, '1'
    JE switch_menu_choice_c1
    JMP e_switch_menu_choice_c1

switch_menu_choice_c1:                  ;{
    MOV DX, OFFSET WiFi_ssid_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash 
    MOV Continue,true 

    CALL TX_str_Com
;while_SSID_str:
;    MOV AH, 08			
;	INT 33		            ;input  = getchar();
;	MOV TX_car, AL
;    MOV AH, 2		           ;printf("%c",input)
;    MOV DL, TX_car
;    INT 33
;    
;    MOV AL,TX_car
;    MOV AH,0
;    PUSH AX
;    CALL TX_Com
;    POP trash 
;
;if_SSID_str:                        ;if(car == return)
;    CMP TX_car,13
;    JNE e_if_SSID_str
;    MOV Continue, false
;    
;e_if_SSID_str:
;    CMP Continue,true
;    JE while_SSID_str
;
;e_while_SSID_str:
    MOV Continue, true

    MOV DX, OFFSET WiFi_password_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash    

    CALL TX_str_Com
;while_PASS_str:
;    MOV  AH, 08			
;	INT  33		            ;input  = getchar();
;	MOV  TX_car, AL
;    MOV  AH, 2		           ;printf("%c",input)
;    MOV  DL, TX_car
;    INT  33
;    
;    MOV AL,TX_car
;    MOV AH,0
;    PUSH AX
;    CALL TX_Com
;    POP trash 
;
;if_PASS_str:                        ;if(car == return)
;    CMP TX_car,13
;    JNE e_if_PASS_str
;    MOV Continue, false
;
;    
;e_if_PASS_str:
;    CMP Continue,true
;    JE while_PASS_str
;
;e_while_PASS_str:
 
e_switch_menu_choice_c1:

switch_menu_choice_c2:
    MOV DX, OFFSET Menu_Choice_user
    PUSH DX
    CALL Print_String_no_space
    POP Trash

eswitch_menu_choice_c2:
switch_menu_choice_c3:
    MOV MainLoop,false

e_switch_menu_choice_c3:

e_switch_menu_choice:

CMP MainLoop,false
JE ewhile_main_loop
JMP while_main_loop

ewhile_main_loop:

eop:     	
    MOV       AX, 4C00h
	INT       33


;===========================================================================================================================================================================			
;											INCLUDE
;===========================================================================================================================================================================
  	INCLUDE com.asm
    INCLUDE text.asm

END listing