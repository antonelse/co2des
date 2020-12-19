import oscP5.*;
import netP5.*; 


/* PARAMETERS */
String API_URL="https://wemakethings.pythonanywhere.com";
float TIME_RELOAD=3;
NetAddress remote;
OscP5 oscP5;

/* GLOBAL VARIABLES */ 
API_Client client;
float text_eta=0;
float reload_eta=0;
float time_index=0;
String[] msgs;
boolean VERBOSE=true;

int msgN=0;
int msgI=0;
float msgAlpha=0;
int msgStatus=0;
float c=color(255,0,0);


void setup(){
  size(640, 480);
  background(200);
  noStroke();
  println(frameRate);
  
  oscP5 = new OscP5(this,12000);
  remote = new NetAddress("127.0.0.1",1234);
  
  
  client=new API_Client(API_URL);
  msgs= client.get_msgs();
  msgN= msgs.length;
  msgI=msgN-1;
  msgStatus=-1;  
  if(VERBOSE){
    println("Found ", msgN, "new messages");
  }  
  TIME_RELOAD*=frameRate; // period to try to reaload
  if(msgN==0){reload_eta=TIME_RELOAD;}
  else{reload_eta=0;}
  colorMode(HSB);

}


void draw(){
  msgs=client.get_msgs();
  fill(250);
  rectMode(CENTER);
  frameRate(1);
  rect(width/2, height/2, width, height);
  if(msgs.length>0){
    for(int i=0;i<msgs.length;i++){
      println(msgs[i]);
        c=color(int(msgs[0]),0,0);
        fill(c);
        noStroke();
        circle(50,50,50);
        sendosc(int(msgs[0]));
    }
  }
}

void sendosc(int msgn){
  OscMessage msg = new OscMessage("/interaction");
  msg.add(msgn);
  oscP5.send(msg,remote);
}
