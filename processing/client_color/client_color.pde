import oscP5.*;
import netP5.*; 

/* PARAMETERS */
String API_URL="https://wemakethings.pythonanywhere.com";
float TIME_RELOAD=3;
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
String codeBlock;


void setup(){
  size(600, 900);
  //background(200);
  //noStroke();
 
  
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
  rect(0, height-codeScreenHeight, width, height);
}

void draw(){
  if(counter == reload_eta){
    thread("requestData"); //Executed on a different thread in order not to stop the animation
  }


  //VISUAL
  fill(25, 14, 51, 10);
  rect(0, 0, width, height - codeScreenHeight);

  for (Borg b : borgs) {
    b.update();
  }
  checkCollisions();
  
  /*for (Borg b : borgs) {
    b.draw();
  }*/
  counter++;
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
      Interaction currentInteraction=interaction.get(i);
      TidalParameter map=mapMessage(currentInteraction);
      sendosc(map.param,map.value);
      println(map.param);
      println(map.value);
      createBorgs(currentInteraction);
    }
    cont=msgs.length;
  }
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
  float center_y = random(height - codeScreenHeight);
  float r = map(inter.value, 0, 1, 1, 50);
  
  color c = color(inter.r, inter.g, inter.b);
  
  for (int i=0; i<newBorgQuantity; i++){
    float x = random(-1, 1)*random(10, r) + center_x;
    float y = random(-1, 1)*random(10, r) + center_y;
    
    borgs.add(new Borg(x, y, c));
  }
}

void oscEvent(OscMessage theOscMessage) {
  //println("message arrived");
  if (theOscMessage.checkAddrPattern("/tidalcode")) {
    println(theOscMessage.get(0));
    String incomingLine = theOscMessage.get(0).toString();
    if (incomingLine != ":{" && incomingLine != ":}"){
      codeBlock.concat("\n" + incomingLine);
    }
    
    if(incomingLine == ":}"){
        fill(0);
        rect(0, height-codeScreenHeight, width, height);
        fill(255);
        textSize(20);
        text(codeBlock, 10, 10+codeScreenHeight, width, height);
        codeBlock = "";
    }
  }
}
