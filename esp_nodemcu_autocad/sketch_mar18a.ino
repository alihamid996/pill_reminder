#include <Arduino.h>
#include <ESP8266WiFi.h> //import for wifi functionality
#include <WebSocketsServer.h> //import for websocket
#include <Wire.h>  
#define ledpin D5
#define irpin D6
#define buzzpin D5



#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x3F,16,2);  // set the LCD address to 0x3F for a 16 chars and 2 line display

const char *ssid =  "HMID";   //Wifi SSID (Name)   
const char *pass =  "0944267323HmD"; //wifi password
int taken;
String cabin;
int cabin1;
int timepassed;
String id;
String content;
String sensors_values="";
String date_current;
String minutes_current;
String date_alram;
String hourss_alram_1="1";
String hourss_current_1="1";
String minutes_alram;
String statues;
String names;
String temp;
float hourss_alram=1000.0;
int hourss_current=1000;
int previous_cur=1000;


int Sensorstate;



WebSocketsServer webSocket = WebSocketsServer(81); //websocket init with port 81

int findsensorstatues(int s){
  
 
   return digitalRead(irpin);

}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {

    String content = "";
    switch(type) {
        case WStype_DISCONNECTED:
           // Serial.println("Websocket is disconnected");
            //case when Websocket is disconnected
            break;
        case WStype_CONNECTED:{
            //wcase when websocket is connected
            //Serial.println("Websocket is connected");
            //Serial.println(webSocket.remoteIP(num).toString());
            webSocket.sendTXT(num, "connected");
            }
            break;
        case WStype_TEXT:
            content = "";
            for(int i = 0; i < length; i++) {
                content = content + (char) payload[i]; 
            }
              
          Serial.println(content);
             if (content.length()>0){
              Serial.println(content);
               Serial.println(content.substring(0,4));
              if (content.substring(0,4)=="next"){
             // Serial.println(content.substring(0,4));
                    cabin=content.substring(11,12);
              //      Serial.println("cabin "+cabin);
                    cabin1=cabin.toInt();
                    date_alram=content.substring(21,23);
                //    Serial.println("date_alram "+date_alram);
            
                    hourss_alram_1=content.substring(24,26);
                  //          Serial.println("hourss_alram_1 "+hourss_alram_1);
            
            
                      names=  content.substring(37,content.length());  
                      Serial.println("input is");  
                      Serial.println("DATE "+date_alram);
                      Serial.println("HOUR "+hourss_alram_1);
                     Serial.println("PILL NAME "+names);
                       lcd.clear();
                      lcd.setCursor(0,0);
                      lcd.print("Next Alarm");
                      
                      lcd.setCursor(10,0);
                      
                      lcd.print(date_alram+"-"+hourss_alram_1);
                      
                      lcd.setCursor(1,1);
                      lcd.print("name ");
                      lcd.print(names);
                    }
                     if (content.substring(0,5)=="alarm"){
 // Serial.println(content.substring(0,5));
        cabin=content.substring(6,7);
        Serial.println("cabin "+cabin);
        cabin1=cabin.toInt();
        date_alram=content.substring(16,18);
        Serial.println("date_alram "+date_alram);

        hourss_alram_1=content.substring(19,21);
                Serial.println("hourss_alram_1 "+hourss_alram_1);

          id=content.substring(35,37);
          Serial.println("id "+id);
          names=  content.substring(38,content.length());  

         Serial.println("PILL IS "+names);
           lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Alarm at ");
          lcd.print(cabin);
          lcd.setCursor(11,0);
                                

          lcd.print(date_alram+"-"+hourss_alram_1);
          
          lcd.setCursor(1,1);
          lcd.print("name ");
          lcd.print(names);
         Sensorstate=findsensorstatues(6);
            
          char y=Sensorstate;
           //Serial.println("sneosrstate"+y);
          if (Sensorstate==1){
            Serial.println("No pill");}
            
          while (Sensorstate==0 & timepassed<60){
            timepassed=timepassed+1;
            digitalWrite(buzzpin,1);
            digitalWrite(ledpin,1);
            Sensorstate=digitalRead(irpin );
                          Serial.println("Pill hasn't been taken");

            char y=Sensorstate;
            if (Sensorstate==1){
              Serial.println("waiting for 10 s");
              
              delay(10000);
                          Sensorstate=digitalRead(irpin );
            char y=Sensorstate;
             if (Sensorstate==1){
              timepassed=0;
              Serial.println("pill has been taken deleting alarm");
                      String tempd=names+"_"+date_alram+"_"+cabin+"_"+id+"_"+"1";
                      webSocket.broadcastTXT(tempd);    
                      Serial.println("waiting 20 second");
                      delay(20000);     
              taken=1;
              break;}
              else{Sensorstate=0;}
            }
                  
            delay(600);    
           digitalWrite(buzzpin,0);
            digitalWrite(ledpin,0);
            delay(600);
}
    content=""  ; 

if (taken==0){timepassed=0;
                      String tempd=names+"_"+date_alram+"_"+cabin+"_"+id+"_"+"0";

                        webSocket.broadcastTXT(tempd);          

}
    char taken1=taken;
    
         
          
    
  
  
  }
  
  //merging payload to single string
           
            


             //send response to mobile, if command is "poweron" then response will be "poweron:success"
             //this response can be used to track down the success of command in mobile app.
            break;
        case WStype_FRAGMENT_TEXT_START:
            break;
        case WStype_FRAGMENT_BIN_START:
            break;
        case WStype_BIN:
            hexdump(payload, length);
            break;
        default:
            break;
    }
}}

String chr2str(char* chr){ //function to convert characters to String
    String rval;
    for(int x = 0; x < strlen(chr); x++){
        rval = rval + chr[x];
    }
    return rval;
}

void setup() {
   lcd.init();                      // initialize the lcd 
  // Print a message to the LCD.
  lcd.backlight();
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("No Current Alarms ");
      lcd.setCursor(9,0);
  // put your setup code here, to run once:
Serial.begin(9600);

 pinMode(irpin, INPUT); // IR Sensor pin INPUT



pinMode(buzzpin,OUTPUT);
  pinMode(ledpin, OUTPUT); // L


 //  Serial.println("Connecting to wifi");
   
   IPAddress apIP(192, 168, 13, 1);   //Static IP for wifi gateway
   WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
   WiFi.softAP(ssid, pass); //turn on WIFI

   webSocket.begin(); //websocket Begin
   webSocket.onEvent(webSocketEvent); //set Event for websocket
  // Serial.println("Websocket is started");
}

void loop() {
    webSocket.loop(); //keep this line on loop method
  webSocket.onEvent(webSocketEvent);

    delay(1000); //delay by 2 second, DHT sesor senses data slowly with delay around 2 seconds
  
        //formulate JSON string format from characters (Converted to string using chr2str())
        //Serial.println("DHT Data read Successful");
        //webSocket.broadcastTXT("parecetmol_15/9/20:20_7_0"); //send JSON to mobile
              //  webSocket.broadcastTXT("panadol_15/9/ 18:20_4_0"); //send JSON to mobile

       //Serial.println("JSON Data read Successful");
    }
