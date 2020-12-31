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
Menu_Choice_2_str db '2.Ping Server$'
Menu_Choice_3_str db '3.Start WiFi Server$'
Menu_Choice_4_str db '4.Exit$'
Menu_Choice_user  db 'Enter A valid key : $'
Menu_Choice_err_str  db 'Error with this choice! $'
WiFi_ssid_str db 'Enter WiFi ssid : $'
WiFi_password_str db 'Enter WiFi password : $'
Host_add_str      db 'Enter Hostname to PING :$'
Starting_Server_str  db 'Starting server...:$'

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
    MOV MainLoop, true
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

    MOV DX, OFFSET Menu_Choice_3_str
    PUSH DX
    CALL Print_String
    POP Trash

    MOV DX, OFFSET Menu_Choice_4_str
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

switch_menu_choice:


switch_menu_choice_c1:                  ;{
    CMP Menu_choice, '1'
    JNE eswitch_menu_choice_c1
    MOV DX, OFFSET WiFi_ssid_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash 
    MOV Continue,true 

    CALL TX_str_Com

    MOV Continue, true

    MOV DX, OFFSET WiFi_password_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash    

    CALL TX_str_Com

    JMP e_switch_menu_choice
eswitch_menu_choice_c1:

switch_menu_choice_c2:
    CMP Menu_choice, '2'
    JNE e_switch_menu_choice_c2
    MOV DX, OFFSET Host_add_str
    PUSH DX
    CALL Print_String
    POP Trash

    CALL TX_str_Com

    JMP e_switch_menu_choice
e_switch_menu_choice_c2:

switch_menu_choice_c3:
    CMP Menu_choice, '3'
    JNE e_switch_menu_choice_c3
    MOV DX, OFFSET Menu_Choice_3_str
    PUSH DX
    CALL Print_String
    POP Trash

e_switch_menu_choice_c3:

switch_menu_choice_c4:
    CMP Menu_choice, '4'
    JNE e_switch_menu_choice_c4
    MOV MainLoop,false
    JMP e_switch_menu_choice

e_switch_menu_choice_c4:

;DEFAULT 
e_switch_menu_choice_c_default:

    MOV DX, OFFSET Menu_Choice_err_str
    PUSH DX
    CALL Print_String_no_space
    POP Trash  

switch_menu_choice_c_default:

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