
#include <Wire.h> //I2C library

void setup()
{
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
  
}

void loop()
{ 
  // Address of theEEPROM (constant until we rewire the EEPROM)
  const int EEPROMI2Caddress = 0x50; // HEX in BINARY it is 01010000
  int test;int test2;
  char dot='.';char dash='_';
  char DatByte_out;char DatByte_out2;
  int MEMLOCATIONaddr;
  int val;
  unsigned long t_ref=millis();
  int address=0x50;

  
    val=digitalRead(2);
    Serial.print("Time: ");
    Serial.println(t_ref);
    Serial.println(val);
  
  if (val==1){
      while (val==1){
      val=digitalRead(2);
      
    }    
  }

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
  return ((four << 0) & 0xFF) + ((three << 8) & 0xFFFF) +
  ((two << 16) & 0xFFFFFF) + ((one << 24) & 0xFFFFFFFF);
  
  //////////////////////////////////////////////////////////
  // Print a summary of what we have done here
  //////////////////////////////////////////////////////////
  Serial.print("Wrote '" );
  Serial.print(t_ref);
  Serial.print("' to address '0x");
  Serial.print(MEMLOCATIONaddr, HEX);
  Serial.print("' of an I2C EEPROM with an address of '0x");
  Serial.print(EEPROMI2Caddress, HEX);
  Serial.print("' Read back '");
  Serial.print(DatByte_out);
  Serial.println("'");

     
  //////////////////////////////////////////////////////////
  // 1 second delay to avoid always writing to EEPROM
  //////////////////////////////////////////////////////////
  delay(1000);

}


