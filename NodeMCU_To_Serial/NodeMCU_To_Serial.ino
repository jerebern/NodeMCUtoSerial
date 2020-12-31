#include <ESP8266WiFi.h>
#include <ESP8266Ping.h>
#include <SoftwareSerial.h>

#define nodebug
#define MaxBuffer 99;
#define Servport 3012
#define MaxTimeOut 99999999

int DebugLed = 13;
SoftwareSerial ComputerSerial; // RX = 0, TX = 1  See REF folder thanks to https://mechatronicsblog.com/

char buffer[99];

#ifdef debug 
void Print_string_car(String &str){
    char car;
    Serial.println("String to debug : " + str);
    for(int i = 0; i<str.length(); i++){
    car = str.charAt(i);
    Serial.println("==========");
    Serial.print("\n car position : ");
    Serial.print(i,DEC);
    Serial.println();
    Serial.println(car,DEC);
    Serial.println(car,HEX);
    Serial.println(car);
    Serial.println("==========");
    }
    
}
#endif

void setup() {
  pinMode(DebugLed, OUTPUT);
  Serial.begin(9600,SERIAL_8N1);
  ComputerSerial.begin(9600,SWSERIAL_8N1,5,4);
  ComputerSerial.setTimeout(MaxTimeOut);
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
//receive string and delete /n
String RX_str(){
    String  rx_str = ComputerSerial.readStringUntil(13);
    for(int i = 0; i < rx_str.length(); i++){
      if(rx_str.charAt(i) == 13){
        rx_str.setCharAt(i,NULL);
      }
    }
  return rx_str;
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
       //ssid = ComputerSerial.readStringUntil('\n');
       ssid = RX_str();
       if(ConnectedFlashTimerLED + 100 < millis()){
        FlashState = wait_Led(DebugLed,FlashState);
        ConnectedFlashTimerLED = millis();
       }
     Serial.print("\n" + ssid);    
 
     Serial.print("\n Enter Wifi Password : ");
     while(password == ""){
       //password = ComputerSerial.readStringUntil('\n');
        password = RX_str();
     }

    Serial.print("\n" + password);   
      #ifdef debug
      Print_string_car(ssid);
      Print_string_car(password);
      #endif

     //WiFi.begin(ssid, password); 
     WiFi.begin(ssid,password); 
      
      Serial.print("\n Connecting")    ;
  
     while (WiFi.status() != WL_CONNECTED && numberTrying < 50)
     {
       if(ConnectedFlashTimerLED + 500 < millis()){
        FlashState = wait_Led(DebugLed,FlashState);
        ConnectedFlashTimerLED = millis();
        //for debug 
        Serial.print("\n try number : ");
        Serial.println(numberTrying,DEC);
        numberTrying++;
       }
      yield();
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

void Init_Serial(){
  bool Connect_Succes = false;
  char rx_Succes = NULL;
  int NextTryTimer = 0;
  char succesCar = '=';
  Serial.println("Waiting for the ASM CLIENT on Serial");
  while(!Connect_Succes){
    if(NextTryTimer + 100 < millis()){
    ComputerSerial.print(succesCar);
    rx_Succes = ComputerSerial.read();
    if(rx_Succes == '='){
      Connect_Succes = true;
    }
    else
    {
      NextTryTimer = millis();
    }
    
  }
  yield();
  }

  Serial.println("Succes!!!!!");

}

char* toChar(String str){

    char convertstr[str.length()+1];
    for(int i = 0; i < str.length(); i++){
      convertstr[i] = str.charAt(i);
    }

    return convertstr;

}

void PingTest(){
    Serial.println("Ping Test");
    String host = RX_str();

    Serial.println("Host to Ping : ");
    Serial.println(host);
    if(Ping.ping(toChar(host))){
      ComputerSerial.print('S');
      Serial.println("Succes");
    }
    else{
        ComputerSerial.print('F');
        Serial.println("Fail");

    }
  
}

void StartServer(){
  if(WiFi.isConnected()){
    WiFiServer server(Servport);
    WiFiClient client;
    String clientMSG;
    bool Connected = false;
    server.begin();

    Serial.print("Starting server listening on :");
    Serial.print(WiFi.localIP());
    Serial.print(":");
    Serial.print(server.port());
    Serial.println();

    while(server.status()){
      if(server.hasClient() && !Connected){
        client = server.available();
        client.setTimeout(MaxTimeOut);
        Connected = true;
      }
      if(server.hasClient() && Connected){
        server.println("MAX CLIENT");
        
      }
      else{
       Serial.println(client.readStringUntil('\n'));
            
      }
      yield();
    }
 

  }
  else
  {
    Serial.println("Error not connected ");
  }
  

}

void Menu(){

  Serial.print("Menu \n");
  String choice = "";
  while(choice == ""){
    choice = ComputerSerial.readStringUntil(13);
    #ifdef debug 
    Print_string_car(choice);
    #endif
  }

  switch((choice.charAt(0) - '0')){
    case 1 :
    init_Wifi_Over_Serial();
    break;
    case 2:
    PingTest();
    break;
    case 3:
    StartServer();
    break;
    default:
    Serial.print("Invalide choice ");
    break;
  } 


}

void loop() {
  //digitalWrite(DebugLed,HIGH);
  //Init_Serial();
  Menu();
  //Serialdebug();

}
