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


void setup(){
  size(600, 600);
  //background(200);
  //noStroke();
 
  
  oscP5 = new OscP5(this,12000);
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
}

void draw(){
  if(counter == reload_eta){
    thread("requestData"); //Executed on a different thread in order not to stop the animation
  }


  //VISUAL
  fill(borgs.size(), 200, 200, 1);
  rect(0, 0, width, height);

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
    if(inter.r==255) {
      map=new TidalParameter("filter",inter.value);
      return map;
    }
    else if(inter.g==255){
      map=new TidalParameter("delay",map(inter.value,0,1,0,0.6));
      return map;
    }
    else if(inter.b==255) {
      map=new TidalParameter("every",map(inter.value,0,1,0,6));
      return map;
    }
    else{
      map=new TidalParameter("pan",inter.value);
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
  for (int a = 0; a < borgs.size(); a++) {
    Borg p = borgs.get(a);
    for (int b = a+1; b < borgs.size(); b++) {
      Borg q = borgs.get(b);
      PVector pq = new PVector(q.x-p.x, q.y-p.y);
      if (pq.mag()<150 && p.c == q.c) {
        
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
  float center_y = random(height);
  float r = map(inter.value, 0, 1, 1, 50);
  
  color c = color(inter.r, inter.g, inter.b);
  
  for (int i=0; i<newBorgQuantity; i++){
    float x = random(-1, 1)*random(0, r) + center_x;
    float y = random(-1, 1)*random(0, r) + center_y;
    
    borgs.add(new Borg(x, y, c));
  }
  
  
  
}
