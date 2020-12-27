#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>

#define MaxBuffer 99;
int DebugLed = 13;
SoftwareSerial ComputerSerial; // RX = 0, TX = 1  See REF folder thanks to https://mechatronicsblog.com/

char buffer[99];

void setup() {
  pinMode(DebugLed, OUTPUT);
  Serial.begin(9600,SERIAL_8N1);
  ComputerSerial.begin(9600,SWSERIAL_8N1,5,4);
  ComputerSerial.println("Hello");
//    while (!Serial && !ComputerSerial);
///9 600 N 8 1
    
}

bool wait_Led(int led ,bool state){
  if(state){
    digitalWrite(led, LOW);
  }
  else{
    digitalWrite(led,HIGH);
  }  
  return !state;
}

void init_Wifi_Over_Serial(){
  String ssid = "";
  String password = "";
  bool succes =  false;
  int numberTrying = 0 ; 
  int ConnectedFlashTimerLED = 0;
  bool FlashState = false;

  while(!succes){
     Serial.print("\n Enter Wifi SSID : ");
     while(ssid == ""){
       ssid = ComputerSerial.readStringUntil('\n');
       if(ConnectedFlashTimerLED + 100 < millis()){
        FlashState = wait_Led(DebugLed,FlashState);
        ConnectedFlashTimerLED = millis();
       }
     }
     Serial.print("\n" + ssid);    
 
     Serial.print("\n Enter Wifi Password : ");
     while(password == ""){
       password = ComputerSerial.readStringUntil('\n');

       if(ConnectedFlashTimerLED + 100 < millis()){
        FlashState = wait_Led(DebugLed,FlashState);
        ConnectedFlashTimerLED = millis();
       }
       

       
     }
      
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
    digitalWrite(DebugLed,HIGH);

  Serial.println();
  
}
void Serialdebug(){

  char Debug = ComputerSerial.read();
  if(Debug != 255){
    Serial.println("==========");
    Serial.println(Debug,DEC);
    Serial.println(Debug,HEX);
    Serial.println(Debug);
    Serial.println("==========");

  }


}
void Menu(){

  Serial.print("Menu \n");
  ComputerSerial.print("Menu \n");


  String choice = "";
  while(choice == ""){
    choice = ComputerSerial.readStringUntil('\n');

  }

  Serial.print("Choice = " + choice + "\n");
  Serial.println(choice.length(), DEC);
  Serial.print("\n");


  switch((choice.charAt(0) - '0')){
    case 1 :
    Serial.print("CASE 1 \n");
    init_Wifi_Over_Serial();
    break;
  } 


}

void loop() {
  //digitalWrite(DebugLed,HIGH);
  Menu();
  //Serialdebug();

}
