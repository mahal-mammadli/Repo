#include <Wire.h> //I2C library
void setup() {
 // Set pin used to control write protect pin to an output PIN
  pinMode(3, OUTPUT);
  // Set pin used to monitor switch signal
  pinMode(2, INPUT);

  // Enable wire library (I2C hardware)
  Wire.begin(); // initialise the connection as the device master

  // Enable Serial port (so we can print results to understand whats going on)
  Serial.begin(9600);

  // Turn on EEPROM's write protect
  digitalWrite(3, HIGH);
  Serial.print("Begin morse code. Press for dot, hold for dash wait 3 second delay for null.\n");
 
}

void loop() {
  const int EEPROMI2Caddress = 0x50; // HEX in BINARY it is 01010000
  int test;
  char dot='.';char dash='_';
  int MEMLOCATIONaddr;
  int val;
  unsigned long t_ref=millis();
  int address=0x50;
  
  byte four = (t_ref & 0xFF);
  byte three = ((t_ref >> 8) & 0xFF);
  byte two = ((t_ref >> 16) & 0xFF);
  byte one = ((t_ref >> 24) & 0xFF);
  
  // Pick a location on the EEPROM to write to and read from 
  MEMLOCATIONaddr = 0;
  //////////////////////////////////////////////////////////
  // Write a byte to the first address of the EEPROM
  //////////////////////////////////////////////////////////
  // enable the EEPROM by setting WP pin low
  digitalWrite(3, LOW);    
  delay(10);
  // call the EEPROM
  Wire.beginTransmission(EEPROMI2Caddress);

  // send the address in the eeprom we want to write too (its 16 bits or two bytes long)
 
  Wire.write((int)(MEMLOCATIONaddr >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr & 0xFF)); // LSB

  // Write the byte we want to write to
  Wire.write(four);
  // stop the call to the eeprom
  Wire.endTransmission();

  Wire.beginTransmission(EEPROMI2Caddress);
  Wire.write((int)(MEMLOCATIONaddr+1 >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr+1 & 0xFF)); // LSB
  Wire.write(three);
  Wire.endTransmission();

  Wire.beginTransmission(EEPROMI2Caddress);
  Wire.write((int)(MEMLOCATIONaddr+2 >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr+2 & 0xFF)); // LSB
  Wire.write(two);
  Wire.endTransmission();

  Wire.beginTransmission(EEPROMI2Caddress);
  Wire.write((int)(MEMLOCATIONaddr+3 >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr+3 & 0xFF)); // LSB
  Wire.write(one);
  Wire.endTransmission();
  
  //Turn back on the EEPROM's WP by setting D3 High
  digitalWrite(3, HIGH);


  //////////////////////////////////////////////////////////
  // add a brief delay between read and write
  //////////////////////////////////////////////////////////
  delay(5);
 

  //////////////////////////////////////////////////////////
  // Read a byte to the first address of the EEPROM
  //////////////////////////////////////////////////////////
  // call the EEPROM
  Wire.beginTransmission(EEPROMI2Caddress);

  // send it the address we want to read from
  Wire.write((int)(MEMLOCATIONaddr >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr & 0xFF)); // LSB

  // hang up and let the EEPROM prepare a response
  Wire.endTransmission();

  // ask for a byte back and wait here for a response
  Wire.requestFrom(EEPROMI2Caddress, 1);
  test = Wire.available();
  if (test) {
     long four = Wire.read();
  }
  Wire.beginTransmission(EEPROMI2Caddress);
  Wire.write((int)(MEMLOCATIONaddr+1 >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr+1 & 0xFF)); // LSB
  Wire.endTransmission();
   Wire.requestFrom(EEPROMI2Caddress, 1);
  test = Wire.available();
  if (test) {
     long three = Wire.read();
  }
  Wire.beginTransmission(EEPROMI2Caddress);
  Wire.write((int)(MEMLOCATIONaddr+2 >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr+2 & 0xFF)); // LSB
  Wire.endTransmission();
   Wire.requestFrom(EEPROMI2Caddress, 1);
  test = Wire.available();
  if (test) {
     long two = Wire.read();
  }
  Wire.beginTransmission(EEPROMI2Caddress);
  Wire.write((int)(MEMLOCATIONaddr+3 >> 8)); // MSB
  Wire.write((int)(MEMLOCATIONaddr+3 & 0xFF)); // LSB
  Wire.endTransmission();
   Wire.requestFrom(EEPROMI2Caddress, 1);
  test = Wire.available();
  if (test) {
     long one = Wire.read();
  }
  long t =((four << 0) & 0xFF) + ((three << 8) & 0xFFFF) +  ((two << 16) & 0xFFFFFF) + ((one << 24) & 0xFFFFFFFF);
  //Serial.print("\nTime: ");
  //Serial.print(t);
  

  //Serial.print("\nReference time: ");
  //Serial.print(t_ref);
  int x;
  x=0;
  
  while(x==0){
    t_ref=millis();
    val=digitalRead(2);
    if(val==1){
      t_ref=millis();
      while(val==1){
        delay(10);
        val=digitalRead(2);
      }
      long stoptime=millis();
      if(stoptime-t<1000){
        Serial.print(".");
        char dot='.';
        x=1;
      }
      if(stoptime-t>1000){
        Serial.print("-");
        char dash='-';
        x=1;
      }
    }
  }
  if (x==0){
    Serial.print(" ");
    char space=' ';
  } 
}

  

