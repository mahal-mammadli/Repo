/************************************************************************
   Purpose: For write and read back morse code inputed by user.
   modified 27 September 2017
   by Mahal Mammadli and Travis Wil

   Authors: Mahal Mammadli and Travis Wil
*/

#include <Wire.h> //I2C library
#include <stdio.h>
#include <string.h>

String stringone;

void setup() {
  // put your setup code here, to run once:
  pinMode(3, OUTPUT);
  pinMode(2, INPUT);
  Wire.begin(); // initialise the connection as the device master

  // Enable Serial port (so we can print results to understand whats going on)
  Serial.begin(9600);

  // Turn on EEPROM's write protect
  digitalWrite(3, HIGH);
  // User input instructions
  Serial.print("Begin morse code. Press for dot, hold 1 second for dash , hold for 2 seconds for null.\n To finish press and hold button for 3 seconds then release.\n");

}

void loop() {
  // put your main code here, to run repeatedly:
  const int EEPROMI2Caddress = 0x50; // HEX in BINARY it is 01010000
  unsigned long t_ref = millis();
  int test;
  int j;
  int k = 0;
  int MEMLOCATIONaddr;
  int val;
  int address = 0x50;
  int led = 9;
  int x;
  char dot = '.';
  char dash = '-';
  char space = ' ';
  char DatByte_out = 0;
  char alpnum[5];


  // Defining memory adress, x parameter for initial while loop, j parameter to
  // ensure different memory address for each byte of data
  MEMLOCATIONaddr = 0;
  x = 0;
  j = 0;

  pinMode(led, OUTPUT); //Defining LED light to read back morse code
  // Go into while loop while the switch button is not pressed by user
  while (x == 0) {
    // Read if switch is triggered
    val = digitalRead(2);
    if (val == 1) {
      // Begin timing duration of trigger
      t_ref = millis();//Record start time of trigger
      while (val == 1) {
        delay(10);
        val = digitalRead(2);
      }
      long stoptime = millis();// Record stoptime of trigger
      // Comparison of start time (t_ref) and stop time (stoptime)
      // to determine whether dot, dash or space is implied by user
      if (stoptime - t_ref < 800) {
        j = j + 1; // To ensure character is saved into different memory location
        Serial.print(".");
        // Begin writing to memory
        digitalWrite(3, LOW);
        delay(10);
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr + j >> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr + j & 0xFF)); // LSB
        Wire.write(dot);
        Wire.endTransmission();
        digitalWrite(3, HIGH);

      }
      if (stoptime - t_ref > 800 && stoptime - t_ref < 1500) {
        Serial.print("-");
        j = j + 1;
        digitalWrite(3, LOW);
        delay(10);
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr + j >> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr + j & 0xFF)); // LSB
        Wire.write(dash);
        Wire.endTransmission();
        digitalWrite(3, HIGH);

      }
      if (stoptime - t_ref > 1500 && stoptime - t_ref < 3000) {
        Serial.print(" ");
        j = j + 1;
        digitalWrite(3, LOW);
        delay(10);
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr + j >> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr + j & 0xFF)); // LSB
        Wire.write(space);
        Wire.endTransmission();
        digitalWrite(3, HIGH);

      }

      if (stoptime - t_ref > 3000) {
        x = 1; // Condition to end first while loop
        Serial.print("\nMorse code done.\n");
        Serial.print("The following code was recorded:\n");

        // Read back from memory
        for (int i = 1 ; i <= j ; i++) {
          delay(500);

          Wire.beginTransmission(EEPROMI2Caddress);
          Wire.write((int)(MEMLOCATIONaddr + i >> 8)); // MSB
          Wire.write((int)(MEMLOCATIONaddr + i & 0xFF)); // LSB
          Wire.endTransmission();
          Wire.requestFrom(EEPROMI2Caddress, 1);
          test = Wire.available();
          if (test) {
            DatByte_out = Wire.read();
          }
          Serial.print(DatByte_out);
          
          light(DatByte_out, dot, dash, space); //Calling light function to display LED
          alpnum[i-1] = {DatByte_out};      
          
        }
        num_comp(alpnum);
        Serial.print("\n");
      }
    }
  }
  delay(100);
}

//LED light execution based on characters saved
void light(char DatByte_out, char dot, char dash, char space) {

  if (DatByte_out == dot) {
    digitalWrite(9, HIGH);
    delay(200);
    digitalWrite(9, LOW);
  }
  if (DatByte_out == dash) {
    digitalWrite(9, HIGH);
    delay(1000);
    digitalWrite(9, LOW);
  }
  if (DatByte_out == space) {
    delay(1000);
  }
}

char num_comp(char alpnum[]) {

  stringone = alpnum;
  delay(10);
  Serial.print("Decipher: ");
  if (stringone == ".----") {
    Serial.print("1");
  }
  if (stringone == "..---") {
    Serial.print("2");
  }
  if (stringone == "...--") {
    Serial.print("3");
  }
  if (stringone == "....-") {
    Serial.print("4");
  }
  if (stringone == ".....") {
    Serial.print("5");
  }
  if (stringone == "-....") {
    Serial.print("6");
  }
  if (stringone == "--...") {
    Serial.print("7");
  }
  if (stringone == "---..") {
    Serial.print("8");
  }
  if (stringone == "----.") {
    Serial.print("9");
  }
  if (stringone == "-----") {
    Serial.print("0");
  }
  Serial.print("\n");
}









