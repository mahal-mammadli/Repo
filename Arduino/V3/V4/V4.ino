#include <Wire.h>

int val;
int w = 0;
int motorPin3 = 3;
int motorPin5 = 5;
int motorPin6 = 6;
int motorPin9 =9;

void setup() {
  // Pin setup
  pinMode(motorPin3, OUTPUT);
  pinMode(motorPin5, OUTPUT);
  
  pinMode(motorPin6, OUTPUT);
  pinMode(motorPin9, OUTPUT);

  digitalWrite(motorPin3, HIGH);
  digitalWrite(motorPin5, HIGH);
  
  digitalWrite(motorPin6, HIGH);
  digitalWrite(motorPin9, HIGH);

  Serial.begin(9600);
  Serial1.begin(9600);

}

void loop() {

  // Xbee communication
  val = Serial1.read();
  if (-1 != val)
  {
    if ('a' == val) {
      // Motor start from Xbee communication
      digitalWrite(motorPin5, LOW);
      delay(100);      
    }
    digitalWrite(motorPin5,HIGH);
    
      if ('d' == val) {
      // Motor start from Xbee
      digitalWrite(motorPin3, LOW);
      delay(100);
    }
    digitalWrite(motorPin3, HIGH);

    if ('w' == val) {
      w=w+10;
      if (w > 255){
        w=255;
      }
      analogWrite(motorPin6, w);
      delay(50);
    }
        
    if ('s' == val) {
      w=w-10;
      if (w<0){
        w=0;
      }
      analogWrite(motorPin6, w);
      delay(50);
    }
        
  }

}


