;===========================================================================================================================================================================			
;										Analyse RXCOM
;
;									VOIR UTLISATIONASCII.TXT					
;===========================================================================================================================================================================		 

Analyse_RxCom                          PROC NEAR					;Analyse_RxCom(RxNonValide,RX,continuer,MessageVictoire,MessagePerdu)	{

	
						RXPos			  EQU	   <WORD PTR[BP-2]>
						rxcar			  EQU	   <WORD PTR[BP+4]>	
						Valide			  EQU 	   <WORD PTR[BP+6]>
						ArretPartie		  EQU 	   <WORD PTR[BP+8]>
						MSG1		  	  EQU 	   <WORD PTR[BP+10]>
						MSG2			  EQU 	   <WORD PTR[BP+12]>
						Flag1			  EQU	   <WORD PTR[BP+14]>
						
			 PUSH BP
			 MOV BP,SP
			 PUSH AX
			 
			 
switch_rxCom1:										;switch(rxcar){

switch_rxCom1_c_100	:								;case(100){ 100 = Connecter
			CMP rxcar,100
			JNE eswitch_rxCom1_c_100
			
			MOV Valide,0							;Valide = false 
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_100:								;}	

switch_rxCom1_c_101	:								;case(101){ 101 = Client Ready
			CMP rxcar,101
			JNE eswitch_rxCom1_c_101
			
			MOV Valide,0							;Valide = false
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_101:								;}

switch_rxCom1_c_102	:								;case(102){ 102 = A ton tour -> Repond Case suite a un espace
			CMP rxcar,102
			JNE eswitch_rxCom1_c_102
		
			MOV Valide,0							;Valide = false
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_102:								;}	

switch_rxCom1_c_103	:								;case(103){ 103 = Missile Lance -> Attend un 0 ~ 99 pour savoir quel case
			CMP rxcar,103
			JNE eswitch_rxCom1_c_103
			
			MOV Valide,0							;Valide = false
			
			PUSH RxPos
			CALL Receive_Com						;rxPos = Receive_Com();
			POP RxPos
			
			PUSH RxPos
			CALL PlaceAttack						;PlaceAttack(RxPos)
			POP  RxPos
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_103:								;}	

switch_rxCom1_c_104	:								;case(104){				;104 = Perdu	 -> Affiche un ptit message
			CMP rxcar,104
			JNE eswitch_rxCom1_c_104
		
			PUSH MSG1	
			CALL Ecrire_Chaine						;Ecrire_Chaine("VOUS AVEZ PERDU")
			POP MSG1
			MOV ArretPartie,0						;ArretPartie = false
			MOV Valide, 0							;Valide = false
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_104:								;}

switch_rxCom1_c_105	:								;case(105){			;105 = Gagner -> Affiche un ptit message
			CMP rxcar,105
			JNE eswitch_rxCom1_c_105
			
			PUSH MSG2
			CALL Ecrire_Chaine						;Ecrire_Chaine("VOUS AVEZ PERDU")
			POP MSG2
			MOV ArretPartie,0						; ArretPartie = false
			MOV Valide, 0							; Valide = false
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_105:								;}

switch_rxCom1_c_106	:								;case(106){		;106 = Continu de placer un ptit bateaux
			CMP rxcar,106
			JNE eswitch_rxCom1_c_106
			
			MOV flag1,1								; flag1 = true
			
			MOV Valide,0							;Valide = false
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_106:								;}	

switch_rxCom1_c_107	:								;case(107){		;107 = Arrete de placer des ptit bateaux 
			CMP rxcar,107
			JNE eswitch_rxCom1_c_107
			
			MOV Valide,0							;Valide = false
			
			JMP eswitch_rxCom1						;break
eswitch_rxCom1_c_107:								;}	


eswitch_rxCom1:										;}

			 POP AX	
			 MOV SP,BP
			 POP BP
			 RET										;return
	
Analyse_RxCom                           ENDP 		;}	

;===========================================================================================================================================================================			
;									 FIN Analyse RXCOM 
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
;										Send COM
;===========================================================================================================================================================================
Send_Com                          PROC NEAR					;void Send_Com(cartoSend)	{

	
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
	
Send_Com                           	ENDP 		;}	


;===========================================================================================================================================================================			
;										Fin Send COM
;===========================================================================================================================================================================



;===========================================================================================================================================================================			
;										RECEIVE COM
;===========================================================================================================================================================================
receive_Com                          PROC NEAR					;void receive_Com(&cartoReceive)	{

	
					CarToReceive			  EQU	   <WORD PTR[BP+4]>		
			
			 PUSH BP
			 MOV BP,SP
			 PUSH AX
			 
			MOV dx,0			 

			MOV AH,02h						;rx(cartoReceive)
			INT 14H		
			MOV AH,0						;Eviter de se ramasser avec de la Junk comme CAR
			MOV CarToReceive,AX
			

			 POP AX	
			 MOV SP,BP
			 POP BP
			 RET										;return
	
receive_Com                           	ENDP 		;}	


;===========================================================================================================================================================================			
;										Fin RECEIVE COM
;===========================================================================================================================================================================
