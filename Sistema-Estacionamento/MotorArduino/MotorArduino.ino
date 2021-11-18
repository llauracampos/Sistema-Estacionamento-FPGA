#include <Servo.h>

Servo myservo, myservo1;  
int pos = 0;    
int motor1 = 13;
int motor2 = 12;
int valor1 = 0;
int valor2 = 0;

void setup() {
  
  myservo.attach(9);
  myservo1.attach(10); 
  pinMode(motor1, INPUT);
  pinMode(motor2, INPUT);
  
}

void loop() {

  valor1 = digitalRead(motor1);
  valor2 = digitalRead(motor2);
  
  if(valor1 == 1){
    for (pos = 0; pos <= 90; pos += 1) { 
                                        
      myservo.write(pos);              
      delay(45);                      
    }
  
    delay(1000);
    
    for (pos = 90; pos >= 0; pos -= 1) { 
      myservo.write(pos);              
      delay(45);                       
    }

  }

  if(valor2 == 1){

    for (pos = 90; pos >= 0; pos -= 1) { 
      myservo1.write(pos);              
      delay(45);                       
    }

     delay(1000);
     
    for (pos = 0; pos <= 90; pos += 1) { 
      // in steps of 1 degree
      myservo1.write(pos);              
      delay(45);                    
    }
  
    
    
    
  }


  
}
