
;===========================================================================================================================================================================			
;										Send String
;===========================================================================================================================================================================
TX_str_com                          PROC NEAR					;void receive_Com(&cartoReceive)	{
							Str_end				  EQU	   <WORD PTR[BP-8]>
							trashCan			  EQU	   <WORD PTR[BP-4]>
							TX_input			  EQU	   <WORD PTR[BP-2]>	
			
			 PUSH BP
			 MOV BP,SP
			 PUSH AX

			MOV Str_end,0;
			 
			while_com_str:
			MOV AH, 08			
			INT 33		            ;input  = getchar();
			MOV TX_input,AX
			MOV AX,TX_input
			MOV AH, 02		           ;printf("%c",input)
			MOV DL, AL
			INT 33
			
			MOV AL,DL
			MOV AH,0
			PUSH AX
			CALL TX_Com
			POP trashCan 

			if_com_str:                        ;if(car == return)
			MOV AX,TX_input
			CMP AL,13
			JNE e_if_com_str
			MOV Str_end, 1
			
			e_if_com_str:
			CMP Str_end,1
			JNE while_com_str

			e_while_SSID_str:

			 POP AX	
			 MOV SP,BP
			 POP BP
			 RET										;return
	
TX_str_Com                           	ENDP 		;}	


;===========================================================================================================================================================================			
;										Fin RECEIVE COM
;===========================================================================================================================================================================


;===========================================================================================================================================================================			
;										Init COM
;===========================================================================================================================================================================		 
Init_Com                          PROC NEAR					;void Init_Com()	{
	
			 PUSH BP
			 MOV BP,SP
			 PUSH AX
			
			 MOV DX,0
			 MOV AH,00
			 MOV AL,10100011B					;INITIALISE le port COM1 2400-N-8-1
			 INT 14H

	
			 ;POUR TESTER SI LE COM FONCTIONE
			 
			 MOV DL,AH
			 ADD DL,'0'
			 MOV AH,2							;printf("COM PORT STATE")
			 INT 21H				 

			 MOV AH,02H
			 MOV DL,10					;printf("\n")
			 INT 21H
		
			 MOV AH,02H
			 MOV DL,13
			 INT 21h			 

			 POP AX	
			 MOV SP,BP
			 POP BP
			 RET										;return
	
Init_Com                           ENDP 		;}	


;===========================================================================================================================================================================			
;										Fin Init COM
;===========================================================================================================================================================================		

;===========================================================================================================================================================================			
;										Car Loading
;===========================================================================================================================================================================		 
AttenteConnexion                          PROC NEAR					;void AttenteConnexion()	{
							TRASHCar				  EQU	   <WORD PTR[BP-6]>
							ReceiveCar				  EQU	   <WORD PTR[BP-4]>
							Etat_Attente			  EQU	   <WORD PTR[BP-2]>	
							Succes					  EQU	   <WORD PTR[BP+4]>
			
			 PUSH BP
			 MOV BP,SP
			 PUSH AX
			 
			 MOV Etat_Attente,0
			 
			 
			 MOV AH,02H
			 MOV DL,10					;printf("\n")
			 INT 21H
		
			 MOV AH,02H
			 MOV DL,13
			 INT 21h
			 
while_Att_Con:							;while(receive_Com != 100){
			 MOV AX,ReceiveCar
			 CMP AL,3
			 JE ewhile_Att_Con

			; MOV AH,02
			 ;MOV DL,08						;printf(08) //Efface le caractere precedent
			 ;INT 21h
			; MOV CX,ReceiveCar
			 ;MOV AH,02
			 ;MOV DL,CL						;printf(08) //Efface le caractere precedent
			 ;INT 21h
			 JMP eswitch_Att_Con
switch_Att_Con:			 					;switch(Etat_Attente)

switch_c_0:
			CMP Etat_Attente,0					;case 0:
			JNE eswitch_c_0

			MOV AH,02
			MOV DL,'/'							;printf('/')
			INT 21h
			
			MOV Etat_Attente,1
			JMP eswitch_Att_Con
eswitch_c_0:

switch_c_1:
			CMP Etat_Attente,1					;case 1:
			JNE eswitch_c_1

			MOV AH,02
			MOV DL,'|'							;printf('|')
			INT 21h
			
			MOV Etat_Attente,2
			JMP eswitch_Att_Con					;break
eswitch_c_1:

switch_c_2:										;case 2:
			 CMP Etat_Attente,2
			 JNE eswitch_c_2

			 MOV AH,02
			 MOV DL,'\'							;printf('\')
			 INT 21h
			 MOV Etat_Attente,0
			 JMP eswitch_Att_Con					;break;
eswitch_c_2:			 
			 
eswitch_Att_Con:			 
			 
			 PUSH ReceiveCar
			 CALL RX_Com				;receive_Com(Receive_Com)
			 POP ReceiveCar
			 
			 JMP while_Att_Con				;}
ewhile_Att_Con:
			 MOV AH,0
			 MOV AL,127
			 PUSH AX
			 CALL TX_Com			
			 POP TRASHCar

			 MOV Succes,1
			 POP AX	
			 MOV SP,BP
			 POP BP
			 
			 RET										;return
	
AttenteConnexion                           ENDP 		;}	

;===========================================================================================================================================================================			
;									 Fin Car_Loading
;===========================================================================================================================================================================		 



;===========================================================================================================================================================================			
;										Send COM
;===========================================================================================================================================================================
TX_Com                          PROC NEAR					;void Send_Com(cartoSend)	{

	
			 CarToSend			  EQU	   <WORD PTR[BP+4]>		
			
			 PUSH BP
			 MOV BP,SP
			 PUSH AX
			 
			 MOV AX,CarToSend
			 MOV dx,0
			 MOV AH,01h						;tx(cartoSend)
			 INT 14H			 

			 POP AX	
			 MOV SP,BP
			 POP BP
			 RET										;return
	
TX_Com                           	ENDP 		;}	


;===========================================================================================================================================================================			
;										Fin Send COM
;===========================================================================================================================================================================



;===========================================================================================================================================================================			
;										RECEIVE COM
;===========================================================================================================================================================================
RX_com                          PROC NEAR					;void receive_Com(&cartoReceive)	{

	
					CarToReceive			  EQU	   <WORD PTR[BP+4]>		
			
			 PUSH BP
			 MOV BP,SP
			 PUSH AX
			 
			 MOV dx,0			 
 
			 MOV AH,02h						;rx(cartoReceive)
			 INT 14H		
		;	 MOV AH,0						;Eviter de se ramasser avec de la Junk comme CAR
			 MOV CarToReceive,AX

			 MOV AH,02
			 MOV DL,AL						;printf(08) //Efface le caractere precedent
			 INT 21h

			 POP AX	
			 MOV SP,BP
			 POP BP
			 RET										;return
	
RX_Com                           	ENDP 		;}	


;===========================================================================================================================================================================			
;										Fin RECEIVE COM
;===========================================================================================================================================================================
