#include <Wire.h>
#include <SPI.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BMP280.h>

#define BMP_SCK 13
#define BMP_MISO 12
#define BMP_MOSI 11
#define BMP_CS 10

Adafruit_BMP280 bmp; // I2C
//Adafruit_BMP280 bmp(BMP_CS); // hardware SPI
//Adafruit_BMP280 bmp(BMP_CS, BMP_MOSI, BMP_MISO,  BMP_SCK);


int val;
int count = 0;
int motorPin4 = 4;
int motorPin5 = 5;
int motorPin6 = 6;
int motorPin7 =7;

void setup() {
  Serial.begin(19200);
  Serial.println(F("BMP280 test"));

  if (!bmp.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring!"));
    while (1);
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

  // bmp280 Sensor
  Serial.print(F("Temperature = "));
  Serial.print(bmp.readTemperature());
  Serial.println(" *C");

  Serial.print(F("Pressure = "));
  Serial.print(bmp.readPressure());
  Serial.println(" Pa");

  Serial.print(F("Approx altitude = "));
  Serial.print(bmp.readAltitude(1013.25)); // this should be adjusted to your local forcase
  Serial.println(" m");

  Serial.println();
  delay(1000);

  // Motor Control
  if (Serial.available())
  {
    char start = Serial.read();
    if (start == 's') {
      digitalWrite(motorPin5, LOW);
      delay(500);
    }
    digitalWrite(motorPin5, HIGH);
  }

}


