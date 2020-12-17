#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>

#define MaxBuffer 99;

char buffer[99];

void setup() {
  // put your setup code here, to run once:

  Serial.begin(9600);
///9 600 N 8 1
}

void init_Wifi_Over_Serial(){
  String ssid = "";
  String password = "";
  bool succes =  false;
  int numberTrying = 0 ; 

  while(!succes){
     Serial.print("\n Enter Wifi SSID : ");
     while(ssid == ""){
       ssid = Serial.readStringUntil('\n');
     }
     Serial.print("\n" + ssid);    
 
     Serial.print("\n Enter Wifi Password : ");
     while(password == "")
     password = Serial.readStringUntil('\n');
      
     WiFi.begin(ssid, password); 
      
     Serial.print("\n Connecting")    ;
  
     while (WiFi.status() != WL_CONNECTED && numberTrying < 10)
     {
       delay(500);
       Serial.print(".");
       numberTrying++;

     }
     if(WiFi.status() == WL_CONNECTED){
       succes = true;
       Serial.print(" \n Succes connected to = " + ssid);

       Serial.print("\n Connected, IP address: ");
       Serial.println(WiFi.localIP());

     }
     else{
       Serial.print(" \n fail to connect to = " + ssid);
       numberTrying = 0;
       ssid = "";
       password = "";
     }
    
  }

  Serial.println();
  
}

void loop() {
  String choice = "";
  while(choice == ""){
     choice = Serial.readStringUntil('\n');
  }

  switch(int(choice[0])){
    case 1 :
    init_Wifi_Over_Serial();
    break;
  }



}
