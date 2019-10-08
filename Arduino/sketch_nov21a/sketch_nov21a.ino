#include <Wire.h>
#include <SPI.h>



void setup() {
  int val;
int count = 0;
int motorPin4 = 4;
int motorPin5 = 5;
int motorPin6 = 6;
int motorPin7 =7;


  }


  pinMode(motorPin4, OUTPUT);
  pinMode(motorPin5, OUTPUT);
  pinMode(motorPin6, OUTPUT);
  pinMode(motorPin7, OUTPUT);

  digitalWrite(motorPin4, HIGH);
  digitalWrite(motorPin5, HIGH);
  digitalWrite(motorPin6, HIGH);
  digitalWrite(motorPin7, HIGH);

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
      delay(500);
    }
    digitalWrite(motorPin5, HIGH);

      if ('d' == val) {
      // Motor start from Xbee
      digitalWrite(motorPin4, LOW);
      delay(500);
    }
    digitalWrite(motorPin4, HIGH);

    if ('w' == val) {
      // Motor start from Xbee communication
      digitalWrite(motorPin7, LOW);
      delay(500);
    }
    digitalWrite(motorPin7, HIGH);

      if ('s' == val) {
      // Motor start from Xbee
      digitalWrite(motorPin6, LOW);
      delay(500);
    }
    digitalWrite(motorPin6, HIGH);
  }

 

}

