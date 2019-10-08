/************************************************************************
   Purpose: To write and read back Morse code inputed by user.
            The Morse code is to be read back by both the serial terminal and an LED.
            The Morse code also decodes into alpha numeric characters and can form sentences.
   Modified 30 September 2017
   by Mahal Mammadli and Wil Travis

   Authors: Mahal Mammadli and Wil Travis
*/

#include <Wire.h> // I2C library
#include <stdio.h>
#include <string.h>

void setup() {
  // The code setup
  pinMode(3, OUTPUT);
  pinMode(2, INPUT);
  pinMode(9, OUTPUT); // Defining LED light to read back Morse code
  Wire.begin(); // Initialize the connection as the device master

  // Enable Serial port (used to justify the Morse code inputted)
  Serial.begin(9600);

  // Turn on EEPROM's write protect
  digitalWrite(3, HIGH);
  // User input instructions
  Serial.print("Begin morse code. Press for dot, hold 1 second for dash , hold for 2 seconds for null.\n To finish press and hold button for 3 seconds then release.\n");

}

void loop() {
  // Initialization of variables
  const int EEPROMI2Caddress = 0x50; // HEX in BINARY is 01010000
  unsigned long t_ref = millis();
  int test;
  int val;
  int address = 0x50;
  char dot = '.';
  char dash = '-';
  char space = ' ';
  char DatByte_out = 0;
  String alphnum = "";

  // Defining memory address, x parameter for initial while loop and j parameter to
  // ensure different memory address for each byte of data
  int MEMLOCATIONaddr = 0;
  int x = 0;
  int j = 0;

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
      if (stoptime - t_ref < 800) { // First condition to write a "Dot"
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
      
      if (stoptime - t_ref > 800 && stoptime - t_ref < 1500) {//Second condition to write a "Dash"
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
      
      if (stoptime - t_ref > 1500 && stoptime - t_ref < 3000) { // Third condition to write a "space"
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

      if (stoptime - t_ref > 3000) { // Condition to end first while loop
        x = 1; 
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
          Serial.print(DatByte_out); //Reprinting the stored Morse code to the serial terminal

          light(DatByte_out, dot, dash, space); //Calling light function to display LED
          alphnum = alphnum + DatByte_out; //Creating string of entire code inputted

        }
        string_comp(alphnum); //Sending the string to be broken down and decoded in seperate functions
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

//Funciton to create indivdual strings
String string_comp(String alphnum) {
  int k = 0;
  int m = 0;
  String morseString;

  Serial.print("\n");
  Serial.print("Decoded: ");

  for (int l = 0; l < alphnum.length(); l++) { // Loop to run through the inputted Morse code
    String morseString = ""; //Make new empty string

    while (alphnum[k] != ' ' && k <= alphnum.length()) {
      morseString = morseString + alphnum[k]; //Fill new string with characters from the inputted code until a space
      k = k + 1;
    }
    if (alphnum[k] == ' ' || k == alphnum.length() + 1) {
      decoder(morseString); //Send the new string to get decoded (Letter or Number)
      m = k + 1;
      if (alphnum[m] == ' ') //Put a space between 'Words' in a sentence
        Serial.print(" ");
    }
    k = k + 1;
  }
}

// Function to decode the Morse code to alpha numeric characters
char decoder(String morseString) {

  if (morseString == ".-") {
    Serial.print("A");
  }
  if (morseString == "-...") {
    Serial.print("B");
  }
  if (morseString == "-.-.") {
    Serial.print("C");
  }
  if (morseString == "-..") {
    Serial.print("D");
  }
  if (morseString == ".") {
    Serial.print("E");
  }
  if (morseString == "..-.") {
    Serial.print("F");
  }
  if (morseString == "--.") {
    Serial.print("G");
  }
  if (morseString == "....") {
    Serial.print("H");
  }
  if (morseString == "..") {
    Serial.print("I");
  }
  if (morseString == ".---") {
    Serial.print("J");
  }
  if (morseString == ".-.-") {
    Serial.print("K");
  }
  if (morseString == ".-..") {
    Serial.print("L");
  }
  if (morseString == "--") {
    Serial.print("M");
  }
  if (morseString == "-.") {
    Serial.print("N");
  }
  if (morseString == "---") {
    Serial.print("O");
  }
  if (morseString == ".--.") {
    Serial.print("P");
  }
  if (morseString == "--.-") {
    Serial.print("Q");
  }
  if (morseString == ".-.") {
    Serial.print("R");
  }
  if (morseString == "...") {
    Serial.print("S");
  }
  if (morseString == "-") {
    Serial.print("T");
  }
  if (morseString == "..-") {
    Serial.print("U");
  }
  if (morseString == "...-") {
    Serial.print("V");
  }
  if (morseString == ".--") {
    Serial.print("W");
  }
  if (morseString == "-..-") {
    Serial.print("X");
  }
  if (morseString == "-.--") {
    Serial.print("Y");
  }
  if (morseString == "--..") {
    Serial.print("Z");
  }
  if (morseString == ".----") {
    Serial.print("1");
  }
  if (morseString == "..---") {
    Serial.print("2");
  }
  if (morseString == "...--") {
    Serial.print("3");
  }
  if (morseString == "....-") {
    Serial.print("4");
  }
  if (morseString == ".....") {
    Serial.print("5");
  }
  if (morseString == "-....") {
    Serial.print("6");
  }
  if (morseString == "--...") {
    Serial.print("7");
  }
  if (morseString == "---..") {
    Serial.print("8");
  }
  if (morseString == "----.") {
    Serial.print("9");
  }
  if (morseString == "-----") {
    Serial.print("0");
  }
}

