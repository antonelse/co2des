import oscP5.*;
import netP5.*; 

/* PARAMETERS */
String API_URL="https://wemakethings.pythonanywhere.com";
float TIME_RELOAD=1;
NetAddress remote;
OscP5 oscP5;

/* GLOBAL VARIABLES */ 
API_Client client;
float reload_eta=0;
String[] msgs;

int counter=0;

int msgN=0;
int msgI=0;

int cont=0;
ArrayList <Interaction> interaction=new ArrayList<Interaction>();

/*VISUAL VARIABLES*/
ArrayList <Borg> borgs;
int newBorgQuantity = 10;
int borgsDistance;

int codeScreenHeight = 300;

/*TEXT VARIABLES*/ //NOT WORKING
String codeBlock;
String incomingLine;
String codeToShow; 

Interaction globalCurrentInteraction;

boolean firstBorgRemoved = false;
boolean defaultParamSent = false;

String testoInDraw = ""; 
String oldTestoInDraw = "";
String codeInDraw = "";
String oldCodeInDraw = "";

//TEST BORG
//boolean creation = false;
//Interaction currentInteraction;


void setup(){
  size(1200, 1080);
  //for fullscreen
  //fullScreen();
  //background(200);
  //noStroke();
  
  frameRate(25);
 
  
  oscP5 = new OscP5(this,9000);
  remote = new NetAddress("127.0.0.1",6010);
  
  
  client=new API_Client(API_URL);
  msgs= client.get_msgs();
  msgN= msgs.length;
  msgI=msgN-1;  
  println("Found ", msgN, "new messages");

  
  reload_eta = TIME_RELOAD*frameRate;
  /*TIME_RELOAD*=frameRate; // period to try to reaload
  if(msgN==0){reload_eta=TIME_RELOAD;}
  else{reload_eta=0;}*/
  //colorMode(HSB);

  //VISUAL
  borgs = new ArrayList();
  
  fill(0);
  rect(0, height-codeScreenHeight, width, codeScreenHeight);
  
  //initialize text variables
  codeBlock = "";
  incomingLine = "";
  codeToShow = "";
}

void draw(){
  noStroke();
  if(counter == reload_eta){
    thread("requestData"); //Executed on a different thread in order not to stop the animation
  }
  
  if(borgs.size() == 0 && firstBorgRemoved && !defaultParamSent) thread("setDefaultState");


  //VISUAL
  fill(25, 14, 51, 10);
  rect(0, 0, width, height - codeScreenHeight);

  int borgLength = borgs.size();

  for (int i = 0; i < borgLength; i++) {
    if (i < borgs.size()){

      Borg b = borgs.get(i);
      b.update();
      if (b.lifetime<=0){
        borgs.remove(b);
        firstBorgRemoved = true;
      }
    }
  }
  checkCollisions();
  
  //TEST BORG
  /*
  if(creation){
    createBorgs(currentInteraction);
    creation = false;
  }
  */
  
  /*for (Borg b : borgs) {
    b.draw();
  }*/
  counter++;
  
  //PROVA TEXT IN DRAW 
  if (oldTestoInDraw != testoInDraw){
    fill(0);
    noStroke();
    rect(0, height-codeScreenHeight, width, codeScreenHeight/2);
    oldTestoInDraw = testoInDraw;
  }
   
  fill(255);
  PFont myFont = createFont("CourierNewPSMT", 25);
  textFont(myFont);
  text(testoInDraw, 10, height-codeScreenHeight + 30, width-10, codeScreenHeight/2);
  
  
  //PROVA CODE IN DRAW
  if (oldCodeInDraw != codeInDraw){
    fill(0);
    noStroke();
    rect(0, height-codeScreenHeight/2 - 30, width, codeScreenHeight/2);
    oldCodeInDraw = codeInDraw;
  }
  //AFXylem 
  fill(255);
  text(codeInDraw, 10, height-codeScreenHeight/2 - 30, width-10, codeScreenHeight/2);
  
}




void sendosc(String param, float value){
  OscMessage msg = new OscMessage("/ctrl");
  msg.add(param);
  msg.add(value);
  oscP5.send(msg,remote);
}

TidalParameter mapMessage(Interaction inter){
    TidalParameter map;
    if(inter.r==245 && inter.g==203 && inter.b==54) {
      map=new TidalParameter("slow",map(inter.value, 0, 1, 2, 6));
      return map;
    }
    else if(inter.r==10 && inter.g==209 && inter.b==183){
      map=new TidalParameter("crusher",map(inter.value, 0 ,1 , 1, 15));
      return map;
    }
    else if(inter.r==190 && inter.g==9 && inter.b==206) {
      map=new TidalParameter("cutoff",map(inter.value, 0, 1, 400, 15000));
      return map;
    }
    else{
      map=new TidalParameter("offset",inter.value);
      return map;
    }
}

void requestData(){
  counter=0;
  msgs=client.get_msgs();
  if(msgs.length>cont){
    for(int i=cont;i<msgs.length;i++){
      println(msgs[i]);
      println(interaction.get(i).r);
      println(interaction.get(i).g);
      println(interaction.get(i).b);
     
      //TEST BORG
      //currentInteraction=interaction.get(i);
      Interaction currentInteraction=interaction.get(i);
      globalCurrentInteraction=interaction.get(i);
      
      TidalParameter map=mapMessage(currentInteraction);
      sendosc(map.param,map.value);
      println(map.param);
      println(map.value);
      
      //TEST BORG
      createBorgs(currentInteraction);
      //creation = true;
      //showText(currentInteraction.username);
      testoInDraw = currentInteraction.username + " ::  _" + map.param + " " + map.value;
    
    }
    cont=msgs.length;
  }
  //println(globalCurrentInteraction.username);
  //println(globalCurrentInteraction.username instanceof String);
}


/*
void showText(String textToShow){
  fill(255);
  textSize(60);
  
  println(textToShow);
  text(textToShow, 10, height-codeScreenHeight + 30, width-10, codeScreenHeight);
}
*/


//DEFAULT PARAM RESET
void setDefaultState(){
  sendosc("slow",2);
  sendosc("crusher",1);
  sendosc("cutoff",400);
  sendosc("offset",0);
  defaultParamSent = true;
}

void checkCollisions() {
  //ArrayList <Borg> toDie = new ArrayList();
  //ArrayList <Borg> toCreate = new ArrayList();
  int size = borgs.size();
  for (int a = 0; a < size; a++) {
    Borg p = borgs.get(a);
    for (int b = a+1; b < size; b++) {
      Borg q = borgs.get(b);
      PVector pq = new PVector(q.x-p.x, q.y-p.y);
      
      if(size<=100) borgsDistance = 150;
      else if(size<=300) borgsDistance = 100;
      else borgsDistance = 75;
      
      if (pq.mag()<borgsDistance && p.c == q.c) {
        
        stroke(p.c);
        //println("Line color: " + c);
        line(p.x, p.y, q.x, q.y);

        /*float sim = p.vx * q.vx + p.vy * q.vy;

        if (sim>1) {
          //toCreate.add(new Borg((p.x+q.y)/2.0, (p.y+q.y)/2.0));
        }
        if (sim<-0.5) {
          toDie.add(p);
        }*/
      }
    }
  }
  //borgs.removeAll(toDie);
  //borgs.addAll(toCreate);
}


void createBorgs(Interaction inter){
  float center_x = random(width);
  float center_y = random(height - codeScreenHeight - 50);
  float r = map(inter.value, 0, 1, 1, 50);
  
  color c = color(inter.r, inter.g, inter.b);
  
  for (int i=0; i<newBorgQuantity; i++){
    float x = random(-1, 1)*random(10, r) + center_x;
    float y = random(-1, 1)*random(10, r) + center_y;
    
    borgs.add(new Borg(x, y, c));
    defaultParamSent = false;
  }
}

void oscEvent(OscMessage theOscMessage) {
  println("message arrived");
  if (theOscMessage.checkAddrPattern("/tidalcode")) {
    println(theOscMessage.get(0));
    //incomingLine = (String)theOscMessage.get(0).stringValue();
    
    println(incomingLine);
    if (!theOscMessage.get(0).stringValue().equals(":{") && !theOscMessage.get(0).stringValue().equals(":}") && !theOscMessage.get(0).stringValue().equals("")){
      //println("prima");
      codeBlock = codeBlock + "\n" + incomingLine;
      //codeBlock.concat("\n" + incomingLine);
      //println("dopo");
      
      //fill(0);
      //rect(0, height-codeScreenHeight, width, codeScreenHeight);
      //fill(255);
      //textSize(20);
      //text(theOscMessage.get(0).stringValue(), 10, height-codeScreenHeight, width-10, codeScreenHeight);
      
      
      codeInDraw = theOscMessage.get(0).stringValue();
    }
    
   

    
    /*
    if(incomingLine.equals(":}")){
        println("SONO ENTRATO");
        fill(0);
        rect(0, height-codeScreenHeight, width, codeScreenHeight);
        fill(255);
        textSize(20);
        //text(codeBlock, 10, height-codeScreenHeight, width, height);
        codeBlock = "";
    }
    */
    
   }
}
