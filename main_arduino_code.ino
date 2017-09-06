
#include <Servo.h> 
 
Servo larm;  // create servo objects to control a servo 
//Servo lelbow;
Servo lhip;
Servo rarm;
//Servo relbow;
Servo rhip;
int l1,l2,l3,r1,r2,r3;
char w;
void setup() 
{ 
  Serial.begin(9600);
  
  larm.attach(5);   
  //lelbow.attach(5);
  lhip.attach(6); 
  rarm.attach(9);
  //relbow.attach(10);
  rhip.attach(10);
  larm.write(0);
  //lelbow.write(0);
  lhip.write(0);
  rarm.write(0);
  //relbow.write(0);
  rhip.write(0);
} 
 
void loop() 
{  
  
  if(Serial.available()>=4)
  {
    l1=Serial.read();
    l2=Serial.read();
    //l3=Serial.read();
    r1=Serial.read();
    r2=Serial.read();
    //r3=Serial.read();
    Serial.flush();
    l1 = map(l1,48,57, 0,5);
    l2 = map(l2,48,57, 0,5);
    //l3 = map(l3,48,57, 0,5);
    r1 = map(r1,48,57, 0,5);
    r2 = map(r2,48,57, 0,5);
    //r3 = map(r3,48,57, 0,5);
    l1=l1*10;
    l2=l2*10;
    //l3=l3*10;
    r1=r1*10;
    r2=r2*10;
    //r3=r3*10;
    Serial.println(l1);
    Serial.println(l2);
    //Serial.println(l3);
    Serial.println(r1);
    Serial.println(r2);
    //Serial.println(r3);
    Serial.flush();
   //Serial.println(z); 
  larm.write(l1);                  // sets the servo position according to the scaled value 
  //lelbow.write(l2);
  lhip.write(l2);
  rarm.write(r1);
  //relbow.write(r2);
  rhip.write(r2);
  delay(15);            // waits for the servo to get there 
  }
  Serial.flush();
} 
