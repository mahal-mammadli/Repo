#include <Wire.h> //I2C library
void setup() {
  // put your setup code here, to run once:
  pinMode(3, OUTPUT);
  pinMode(2, INPUT);
  Wire.begin(); // initialise the connection as the device master

  // Enable Serial port (so we can print results to understand whats going on)
  Serial.begin(9600);

  // Turn on EEPROM's write protect
  digitalWrite(3, HIGH);
  Serial.print("Begin morse code. Press for dot, hold 1 second for dash , hold for 2 seconds for null.\n To finish press and hold button for 3 seconds then release.\n");
  
}

void loop() {
  // put your main code here, to run repeatedly:
  const int EEPROMI2Caddress = 0x50; // HEX in BINARY it is 01010000
  int test;int j;int i=5;
  char dot='.';char dash='-';char DatByte_out=0;char space=' ';
  int MEMLOCATIONaddr;
  int val;unsigned long t_zero;
  unsigned long t_ref=millis();
  int address=0x50;
  int led=9;int brightness=255;
  pinMode(led, OUTPUT);
  
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
  x=0;j=4;
  while (x==0){
  val=digitalRead(2);
  if(val==1){
      t_ref=millis();
      while(val==1){
        delay(10);
        val=digitalRead(2);
      }
      long stoptime=millis();
      if(stoptime-t_ref<800){
        j=j+1;
        Serial.print(".");
        
        digitalWrite(3, LOW);    
        delay(10);
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr+j >> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr+j & 0xFF)); // LSB
        Wire.write(dot);
        Wire.endTransmission();
        digitalWrite(3, HIGH); 
              }
      if(stoptime-t_ref>800 && stoptime-t_ref<1500){
        j=j+1;
        Serial.print("-");
        
        digitalWrite(3, LOW);    
        delay(10);
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr+j>> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr+j & 0xFF)); // LSB
        Wire.write(dash);
        Wire.endTransmission();
        digitalWrite(3, HIGH);       
      }
      if(stoptime-t_ref>1500 && stoptime-t_ref<3000){
        j=j+1;
        Serial.print(" ");
        
        digitalWrite(3, LOW);    
        delay(10);
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr+j>> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr+j & 0xFF)); // LSB
        Wire.write(space);
        Wire.endTransmission();
        digitalWrite(3, HIGH);
      }
        
      if (stoptime-t_ref>3000){
        x=1;
        Serial.print("\nMorse code done.\n");
        Serial.print("The following code was recorded:\n");

        while(i<=j){
        delay(500);
        
        Wire.beginTransmission(EEPROMI2Caddress);
        Wire.write((int)(MEMLOCATIONaddr+i >> 8)); // MSB
        Wire.write((int)(MEMLOCATIONaddr+i & 0xFF)); // LSB
        Wire.endTransmission();
        Wire.requestFrom(EEPROMI2Caddress, 1);
        test = Wire.available();
        if (test) {
           DatByte_out = Wire.read();
         }
        Serial.print(DatByte_out);
        
        if(DatByte_out==dot){
          digitalWrite(led,HIGH);
          delay(200);
          digitalWrite(led,LOW);
        }
        if(DatByte_out==dash){
          digitalWrite(led,HIGH);
          delay(1000);
          digitalWrite(led,LOW);
        }
        if(DatByte_out==space){
          delay(1000);
        }
        i=i+1;
        }     
      }       
  }
  }
   delay(100); 
  Serial.print("\n");
}
  
    
    
   
