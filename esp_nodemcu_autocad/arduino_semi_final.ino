int anArray[20];  //an array capable of holding 20 entries numbered 0 to 19
int arrayindes=0;
String alram_time="/Alarm/date/19/hour/2/minute/35/name/asprine";
String current_time="/Current/date/19/hour/3/minute/39/";
char datarcv[60];

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

const int MAX_timers = 10;
int timers[MAX_timers]={100,100,100,100,100,100,100,100,100,100};
int count = 0;
int hourss_alram=1000;
int hourss_current=1000;
int previous_cur=1000;
int cst=0;
int IRSensor_1 = 0; 
int IRSensor_2 = 1;
int IRSensor_3 = 2;
int IRSensor_4 = 3;
int IRSensor_5 = 4;
int IRSensor_6 = 5;
int IRSensor_7 = 6;


int LED_1 =7;
int LED_2 =8 ; 
int LED_3 =9 ; 
//int SDA_LCD =A4 ; 
//int SCL_LCD =A5 ;
int LED_4 =10 ; 
int LED_5 =11 ;
int LED_6 =12 ; 
int LED_7 =13 ;
 
//int buzzer_0=A7;
int SensorState_1=0;
int SensorState_2=0;
int SensorState_3=0;
int SensorState_4=0;
int SensorState_5=0;
int SensorState_6=0;
int SensorState_7=0;

#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x27,16,2);  // set the LCD address to 0x3F for a 16 chars and 2 line display
 
void sortList() {
  for (int i = 0; i < count - 1; i++) {
    for (int j = 0; j < count - i - 1; j++) {
      if (timers[j] > timers[j + 1]) {
        int temp = timers[j];
        timers[j] = timers[j + 1];
        timers[j + 1] = temp;
      }
    }
  }
}
int findalram(int a) {
  int tempo[24];
  int index=0;
  int c=0;
  for (int i=a;i<24;i++){
    tempo[c]=i;
    c++;
  }
  for (int i=0;i<a;i++){
    tempo[c]=i;
    c++;
  }
 for (int i = 0; i < 24; i++) {
    Serial.print(tempo[i]);
    Serial.print(" ");
  }
  Serial.println();

int c2=sizeof(tempo) / sizeof(tempo[0]);
int c3=sizeof(timers) / sizeof(timers[0]);
 for (int i = 0; i < c2; i++) {
    for (int j=0;j<c3;j++){
    if (tempo[i]==timers[j]){
      index=j;
      return  timers[index];
    }
   }}
   return 1000;}
void printList() {
  for (int i = 0; i < count; i++) {
    Serial.print(timers[i]);
    Serial.print(" ");
  }
  Serial.println();
}
void setup() {
  lcd.init();                      // initialize the lcd 
  // Print a message to the LCD.
  lcd.backlight();

  // put your setup code here, to run once:
Serial.begin(19200);
 pinMode(IRSensor_1, INPUT); // IR Sensor pin INPUT
  pinMode(IRSensor_2, INPUT); // IR Sensor pin INPUT
 pinMode(IRSensor_3, INPUT); // IR Sensor pin INPUT
 pinMode(IRSensor_4, INPUT); // IR Sensor pin INPUT
 pinMode(IRSensor_5, INPUT); // IR Sensor pin INPUT
 pinMode(IRSensor_6, INPUT); // IR Sensor pin INPUT
 pinMode(IRSensor_7, INPUT); // IR Sensor pin INPUT

//pinMode(buzzer_0,OUTPUT);
  pinMode(LED_1, OUTPUT); // L
    pinMode(LED_2, OUTPUT); // L
  pinMode(LED_3, OUTPUT); // L
  pinMode(LED_4, OUTPUT); // L
  pinMode(LED_5, OUTPUT); // L
    pinMode(LED_6, OUTPUT); // L
  pinMode(LED_7, OUTPUT); // L


}

void loop() {
   if(Serial.available()) // check if the ESP module is sending a message 
  {
           Serial.println("input"); // and print them all together

      //datarcv[0]=0;
      memset(datarcv, 0, sizeof(datarcv));   

    int i=0;
    while(Serial.available())
    {
      
      delay(14);
      // The esp has data so display its output to the serial window 
            datarcv[i] = Serial.read();
            //Serial.print(datarcv);
    i++;
    }
       Serial.println("input"); // and print them all together

   Serial.println(datarcv); // and print them all together
     content=datarcv;
  }

  SensorState_1= digitalRead(IRSensor_1);
  SensorState_2 = digitalRead(IRSensor_2);
  SensorState_3 = digitalRead(IRSensor_3);
  SensorState_4 = digitalRead(IRSensor_4);
  SensorState_5 = digitalRead(IRSensor_5);
  SensorState_6 = digitalRead(IRSensor_6);
  SensorState_7 = digitalRead(IRSensor_7);

  sensors_values.concat("--");
  sensors_values.concat(SensorState_1);
  sensors_values.concat("--");
  sensors_values.concat(SensorState_2);
  sensors_values.concat("--");
  sensors_values.concat(SensorState_3);
  sensors_values.concat("--");
  sensors_values.concat(SensorState_4);
  sensors_values.concat("--");
  sensors_values.concat(SensorState_5);
  sensors_values.concat("--");
  sensors_values.concat(SensorState_6);
  sensors_values.concat("--");
  sensors_values.concat(SensorState_7);
  sensors_values.concat("--");

delay(4000);   
Serial.println(content.length());
    
 if (content.length()>0){
  Serial.println(content);
    arrayindes=0;
    for (int i=0;i<content.length();i++){
 
       if(content.substring(i,i+1)=="/"){
        anArray[arrayindes]=i;
               

        arrayindes++;}}
        Serial.println(content.substring(anArray[0]+1,anArray[1]));
  if (content.substring(anArray[0]+1,anArray[1])=="Alarm"){
          
    //   Serial.print("date is ");
      //  Serial.println(content.substring(anArray[2]+1,anArray[3]));
        //Serial.print("hour is ");
          //    Serial.println(content.substring(anArray[4]+1,anArray[5]));
            //       Serial.print("minute is ");
              //  Serial.println(content.substring(anArray[6]+1,anArray[7]));
                //Serial.print("name is");
              //Serial.println(   content.substring(anArray[8]+1,content.length()));
        date_alram=content.substring(anArray[2]+1,anArray[3]);
        hourss_alram_1=content.substring(anArray[4]+1,anArray[5]);
         hourss_alram = hourss_alram_1.toInt();

                  minutes_alram=  content.substring(anArray[6]+1,anArray[7]);    
          if (count < MAX_timers) {
          timers[count] = hourss_alram;
          Serial.println("Alaram  added successfully");
        } else {
          Serial.println("Alarm List is full");
        }
          count++;
          names=  content.substring(anArray[8]+1,content.length());  
          Serial.println("input is");  
          Serial.println(date_alram);
          Serial.println(hourss_alram);
          Serial.println(minutes_alram);
         Serial.println(names);
        }
      else if       (content.substring(anArray[0]+1,anArray[1])=="Current"){
statues="current";
                date_current=content.substring(anArray[2]+1,anArray[3]);
        hourss_current_1=content.substring(anArray[4]+1,anArray[5]);
                 hourss_current = hourss_current_1.toInt();

                  minutes_current=  content.substring(anArray[5]+1,anArray[6]);   
        }
                   Serial.println("Current has been updated");
 }  
    memset(anArray, 0, sizeof(anArray));   
    content=""  ; 
printList();
sortList();
printList();
Serial.println("List sorted successfully"); 
int index = -1; 

for (int i=0; i<10;i++){
//Serial.println("alrams");
    
//Serial.println(timers[i]);
//Serial.println("hours curent");
//Serial.println(hourss_current);
    if(hourss_current==timers[i] || cst==0){
      
      if (hourss_current==timers[i]){
              statues="Alram";
              cst=0;
              Serial.println("printing on screen case 1");
              lcd.clear();
              
              lcd.setCursor(0,0);
              lcd.print("Please take the");
              lcd.setCursor(0,1);
              lcd.print("third pill");
              //activite led
              //activiate sound buzzer
              previous_cur=hourss_current;
              Serial.println("previous cur");
              Serial.println("printing on screen case 1");
    }
      if (hourss_current!=previous_cur){
        Serial.println("1");
        if ( previous_cur!=1000 ){
                  Serial.println("2");

          for (int k=0; k<10;k++){
                    Serial.println(k);

            if(previous_cur==timers[k]){
                      Serial.println("if true");
                  
              index=k;
              break;}}
        cst=1;
        statues="current";
        for (int j = index; j< 10 - 1; j++) {
                  Serial.println(j);

          timers[j] = timers[j + 1];}
        count--;
        Serial.println("Alarm deleted successfully");
            
      }}}}
if (statues=="current"){
    Serial.println("printing on screen case 2");

    int tempes=findalram(hourss_current);
    // Serial.print(tempes);
    if (tempes==1000){
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("No Current Alarm ");
      lcd.setCursor(9,0);
    }
    else{
    lcd.clear();
    lcd.setCursor(0,0);

    lcd.print("take pill at ");
    
    lcd.setCursor(0,1);
    
    lcd.print("cabin 1,asprine");

}
}
}
 
