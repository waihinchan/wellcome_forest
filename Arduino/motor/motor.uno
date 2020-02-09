#include <AceRoutine.h>//mutil task lib
#define SPEEDPIN 10
#define IN1 9
#define IN2 8
int speed;
bool finish = false;//make sure always only one task running.
bool Finish = true;
bool somestate = false;//unity control the state switch
void forward(){
  analogWrite(SPEEDPIN,speed);
  digitalWrite(IN1,LOW);
  digitalWrite(IN2,HIGH);
  }

void backward(){
  analogWrite(SPEEDPIN,speed);
  digitalWrite(IN2,LOW);
  digitalWrite(IN1,HIGH);
  }
void brake(){
  analogWrite(SPEEDPIN,0);
  }
////////////////////////////////////
COROUTINE(keepupanddown){

  COROUTINE_LOOP() {
if(!somestate&&Finish){
  speed = 50;
  COROUTINE_DELAY_SECONDS(1);
  finish = false;
  forward();
  COROUTINE_DELAY_SECONDS(1);
  brake();
  COROUTINE_DELAY_SECONDS(1);
  backward();
  COROUTINE_DELAY_SECONDS(1);
  brake();
  COROUTINE_DELAY_SECONDS(1);
  forward();
  COROUTINE_DELAY_SECONDS(1);
  brake();
  finish = true;
}
else{COROUTINE_YIELD();}
}
} 


COROUTINE(downquickly){
COROUTINE_LOOP() {
 if(somestate&&finish){
  speed = 100;
  COROUTINE_DELAY_SECONDS(1);
  Finish = false;
  forward();
  COROUTINE_DELAY_SECONDS(1);
  brake();
  COROUTINE_DELAY_SECONDS(1);
  backward();
  COROUTINE_DELAY_SECONDS(1);
  brake();
  COROUTINE_DELAY_SECONDS(1);
  forward();
  COROUTINE_DELAY_SECONDS(1);
  brake();
  Finish = true;
}

else{COROUTINE_YIELD();}
}

}  

void setup() {

  Serial.begin(9600);
 pinMode(10,OUTPUT);
 pinMode(9,OUTPUT);
 pinMode(8,OUTPUT);
 pinMode(7,INPUT);

}

void loop() {
  Serial.println(digitalRead(7));
  if(digitalRead(7)){somestate = false;}
  else(somestate = true);
keepupanddown.runCoroutine();
downquickly.runCoroutine();
  

}
