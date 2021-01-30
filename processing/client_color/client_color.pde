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

float mutationProbability = 0.1;

//int cont=0;
ArrayList <Interaction> interaction=new ArrayList<Interaction>();

/*VISUAL VARIABLES*/
ArrayList <Borg> borgs;
int newBorgQuantity = 3;
int borgsDistance;

int codeScreenHeight = 300;

/*TEXT VARIABLES*/ 
String codeBlock;
String incomingLine;
String codeToShow; 
color newChildColor;

/*CHAT VARIABLES*/
int chatWidth = 350;
ArrayList <String> userMessages;
boolean newMessageArrived = false;
String chat = "";
int chatLength = 0;
int chatLimit = 7;
float chatYposition = 995;
float chatUpShift = 48.45;

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
  size(1550, 1000);
  //for fullscreen
  //fullScreen();
  //background(200);
  //noStroke();
  
  frameRate(15);
 
  
  oscP5 = new OscP5(this,9000);
  remote = new NetAddress("127.0.0.1",6010);
  
  
  client=new API_Client(API_URL);
  msgs= client.get_msgs();
  msgN= msgs.length;
  msgI=msgN-1;  
  println("Found ", msgN, "new messages");
  client.delete_all();
  
  reload_eta = TIME_RELOAD*frameRate;
  /*TIME_RELOAD*=frameRate; // period to try to reaload
  if(msgN==0){reload_eta=TIME_RELOAD;}
  else{reload_eta=0;}*/
  //colorMode(HSB);

  //VISUAL
  borgs = new ArrayList();
  
  //CodeScreen
  fill(0);
  rect(0, height-codeScreenHeight, width - chatWidth, codeScreenHeight);
  
  //ChatScreen
  rect(width-chatWidth, 0, chatWidth, height);
  
  
  //initialize text variables
  codeBlock = "";
  incomingLine = "";
  codeToShow = "";
  
  //String[] fontList = PFont.list();
  //printArray(fontList);
}

void draw(){
  noStroke();
  if(counter == reload_eta){
    thread("requestData"); //Executed on a different thread in order not to stop the animation
  }
  
  if(borgs.size() == 0 && firstBorgRemoved && !defaultParamSent) thread("setDefaultState");


  //VISUAL
  fill(25, 14, 51, 10);
  rect(0, 0, width-chatWidth, height - codeScreenHeight);

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
    rect(0, height-codeScreenHeight, width - chatWidth, codeScreenHeight/2);
    oldTestoInDraw = testoInDraw;
  }
   
  
  
  
  fill(newChildColor);
  PFont myFont = createFont("Courier New", 25);
  textFont(myFont);
  text(testoInDraw, 10, height-codeScreenHeight + 20, width - chatWidth, codeScreenHeight/2 - 50);
  
  
  if (oldCodeInDraw != codeInDraw){
    fill(0);
    noStroke();
    rect(0, height-codeScreenHeight/2 - 50, width - chatWidth, codeScreenHeight/2 + 50);
    oldCodeInDraw = codeInDraw;
  }
  //AFXylem 
  fill(255);
  text(codeInDraw, 10, height-codeScreenHeight/2 - 50, width - chatWidth, codeScreenHeight/2 + 50);

  PFont myFontChat = createFont("Courier New", 16);
  textFont(myFontChat);

  if(newMessageArrived){
    fill(0);
    noStroke();
    rect(width-chatWidth, 0, chatWidth, height);
    
    fill(250);
    text(chat, width - chatWidth + 10, chatYposition, 330, chatLength);
    newMessageArrived = false;
    //chat = "";
  }
  
  stroke(80);
  strokeWeight(2);
  line(width-chatWidth, height - codeScreenHeight + 30, width-chatWidth, height - 30);
  
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
  client.delete_all();
  if(msgs.length>0){
    newMessageArrived = true;
    for(int i=0;i<msgs.length;i++){
      
      //println(msgs[i]);
      //println(interaction.get(i).r);
      //println(interaction.get(i).g);
      //println(interaction.get(i).b);
     
      //TEST BORG
      //currentInteraction=interaction.get(i);
      Interaction currentInteraction=interaction.get(i);
      globalCurrentInteraction=interaction.get(i);
      
      TidalParameter map=mapMessage(currentInteraction);
      //sendosc(map.param,map.value);
      //println(map.param);
      //println(map.value);
      
      //TEST BORG
      createBorgs(currentInteraction);
      //creation = true;
      //showText(currentInteraction.username);
      
      chat = chat + " --> " + currentInteraction.username + "\n    :: _" + map.param + " " + map.value + "\n";

      
      //userMessages.add(" --> " + currentInteraction.username + "\n    :: _" + map.param + " " + map.value + "\n");
      //println("Nuovo messaggio aggiunto! Dimensione: " + userMessages.size()); 
      
    }
    //cont=msgs.length;
    chatYposition = chatYposition - (chatUpShift * msgs.length);
    chatLength += chatUpShift * msgs.length + 20;
    println(msgs.length + " nuovi messaggi");
    println("Posizione y chat: " + chatYposition);
    //println ("Current chat: " + chat);
    
    
    /*
    if(userMessages.size() < chatLimit){
      chatYposition = chatYposition - (chatUpShift * msgs.length);
        for(int i=0; i<userMessages.size(); i++){
          chat += userMessages.get(i); 
          println("dentro l'if");
          println ("Current chat: " + chat);
        } 
    } else {
      chatYposition = height - codeScreenHeight + 20;
        for(int j = userMessages.size() - chatLimit; j<userMessages.size(); j++){
          chat += userMessages.get(j);
          println("dentro l'else");
          println ("Current chat: " + chat);
        }
    }
    */
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

boolean canBeParent(Borg parent1, Borg parent2){
  if (!parent1.username.equals(parent2.username) && !parent1.username.contains(parent2.username) && !parent2.username.contains(parent1.username)){
  float diff = - abs(parent1.value - parent2.value);
  float prob = map(diff, -1, 0, 0, 0.01);
    if (random(1)<prob) return true;
  }
  return false;
}

void generateChild(Borg parent1, Borg parent2){
  float x_child = (parent1.x + parent2.x)/2;
  float y_child = (parent1.y + parent2.y)/2;
  color color_child = parent1.c;
  String username_child = parent1.username + " ~ " + parent2.username;
  float value_child = (parent1.value + parent2.value)/2;
  
  newChildColor = color_child; //set the text color
  
  //Mutation Process
  if(random(1)<mutationProbability){
    value_child = random(1);
    println("MutazioneGENETICA");
  }
  
  Borg child = new Borg(x_child, y_child, color_child, username_child, value_child);
  
  println("Nuovo figlio Generato. ** "+username_child+" **, value: "+ value_child);
  stroke(color_child);
  circle(x_child, y_child, 25);
  
  borgs.add(child);
  
  //color getter, right shift & bit mask
  int child_red = color_child >> 16 & 0xFF;
  int child_green = color_child >> 8 & 0xFF;
  int child_blue = color_child & 0xFF; // same as >> 0
  
  Interaction currentInteraction = new Interaction(username_child, child_red, child_green, child_blue, value_child);
  
  TidalParameter map=mapMessage(currentInteraction);
  sendosc(map.param,map.value);
  println("messaggio OSC inviato" + map.value);
  testoInDraw = currentInteraction.username + " ::  _" + map.param + " " + map.value;
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
      
      if (pq.mag()<=borgsDistance && p.c == q.c) {
        
        stroke(p.c);
        //println("Line color: " + c);
        line(p.x, p.y, q.x, q.y);
        
        if(canBeParent(p,q) && pq.mag()<=borgsDistance && pq.mag()>=borgsDistance-2) generateChild(p,q);
        
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
  float center_x = random(width - chatWidth - 50);
  float center_y = random(height - codeScreenHeight - 50);
  float r = map(inter.value, 0, 1, 1, 50);
  
  color c = color(inter.r, inter.g, inter.b);
  
  for (int i=0; i<newBorgQuantity; i++){
    float x = random(-1, 1)*random(10, r) + center_x;
    float y = random(-1, 1)*random(10, r) + center_y;
    
    borgs.add(new Borg(x, y, c, inter.username, inter.value));
    defaultParamSent = false;
  }
}

void oscEvent(OscMessage theOscMessage) {
  println("message arrived");
  if (theOscMessage.checkAddrPattern("/tidalcode")) {
    println(theOscMessage.get(0));
    incomingLine = (String)theOscMessage.get(0).stringValue();
    
    //println(incomingLine);
    if (!theOscMessage.get(0).stringValue().equals(":{") && !theOscMessage.get(0).stringValue().equals(":}") && !theOscMessage.get(0).stringValue().equals("")){
      //println("prima");
      codeBlock = codeBlock + " " + incomingLine;
      //codeBlock.concat("\n" + incomingLine); //not working
      println(codeBlock);
      
      //fill(0);
      //rect(0, height-codeScreenHeight, width, codeScreenHeight);
      //fill(255);
      //textSize(20);
      //text(theOscMessage.get(0).stringValue(), 10, height-codeScreenHeight, width-10, codeScreenHeight);
      
      //codeInDraw = theOscMessage.get(0).stringValue(); //"works"
        
    }
    
     if(theOscMessage.get(0).stringValue().equals(":}")){
       codeInDraw = codeBlock.replaceAll("\t", " ");
       codeBlock = "";
     
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
