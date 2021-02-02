import oscP5.*;
import netP5.*;
import processing.sound.*;

/* NETWORK PARAMETERS */
String API_URL="https://wemakethings.pythonanywhere.com";
float TIME_RELOAD=0.5;
float reload_eta=0;
API_Client client;
NetAddress remote;
OscP5 oscP5;

/* GLOBAL VARIABLES */ 
ArrayList <Interaction> interaction=new ArrayList<Interaction>();
String[] msgs;
int counter=0;
int overpopulationLimit=200;
int msgN=0;
int msgI=0;
boolean timerIncreased = false;

/*VISUAL VARIABLES*/
ArrayList <Borg> borgs;
boolean firstBorgRemoved = false;
boolean defaultParamSent = false;
int newBorgQuantity = 3;
int transparency=5;
int borgsDistance;
float mutationProbability = 0.1;

/*TEXT VARIABLES*/ 
int codeScreenHeight = 300;
color newChildColor;
String testoInDraw = ""; //Text to show for a new child
String codeInDraw = ""; //Text executed by the live-coder
String incomingLine = "";
String codeBlock = "";

/*CHAT VARIABLES*/
String chat = "";
int chatWidth = 350;
float chatYposition = 995;
float chatUpShift = 48.45;
int chatLength = 0;

/*AUDIO VARIABLES*/
Amplitude amp;
AudioIn in;
float amplitude_value;
int bpm;


void setup(){
  size(1550, 1000);
  //fullscreen();
  frameRate(15);
 
  //NETWORK
  oscP5 = new OscP5(this,9000);
  remote = new NetAddress("127.0.0.1",6010);
  client=new API_Client(API_URL);
  msgs= client.get_msgs();
  msgN= msgs.length;
  msgI=msgN-1;  
  //println("Found ", msgN, "new messages");
  client.delete_all();
  reload_eta = TIME_RELOAD*frameRate;
  
  //VISUAL
  borgs = new ArrayList();
  
  //CodeScreen
  fill(0);
  rect(0, height-codeScreenHeight, width - chatWidth, codeScreenHeight);
  
  //ChatScreen
  rect(width-chatWidth, 0, chatWidth, height);
  
  //AUDIO
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);
  
}

void draw(){
  noStroke();
  if(counter == reload_eta){
    thread("requestData"); //Executed on a different thread in order not to stop the animation
  }
  counter++; 
  
  if(borgs.size() == 0 && firstBorgRemoved && !defaultParamSent) thread("setDefaultState");

  if(!timerIncreased && borgs.size()>180){
    println("Invio richiesta per aumento timer");
    thread("increaseTimer");
    timerIncreased = true;
  } else if(timerIncreased && borgs.size()<150){
    println("Invio richiesta per settare timer predefinito");
    thread("setDefaultTimer");
    timerIncreased = false;
  }
  
  //VISUAL
  fill(25, 14, 51, transparency);
  rect(0, 0, width-chatWidth, height - codeScreenHeight);

  int borgLength = borgs.size();

  for (int i = 0; i < borgLength; i++) {  
    if (i < borgs.size()){
      Borg b = borgs.get(i);
      
      //Life decreased for overpopulation
      if(borgs.size()>overpopulationLimit){ 
        b.lifetime-=random(0,5);
      }
      
      b.update();
      
      //Life decreased for normal time flow
      if (b.lifetime<=0){
        borgs.remove(b);
        firstBorgRemoved = true;
      }
    }
  }
  
  checkCollisions();
  
  //AUDIO in for the strobe effect
  amplitude_value = map(amp.analyze(), 0, 1, 0, 40);
  //fill(255, 255, 255, amplitude_value);
  //noStroke();
  stroke(255, 255, 255, amplitude_value);
  strokeWeight(amplitude_value);
  noFill();
  rect(0, 0, width-chatWidth, height - codeScreenHeight);
  //println("volume: " + amplitude_value +" valore: " + amp.analyze());
  strokeWeight(1);
  
  //Text to show after a new child is generated
  fill(0);
  noStroke();
  rect(0, height-codeScreenHeight, width - chatWidth, codeScreenHeight/2);
  fill(newChildColor);
  PFont myFont = createFont("Courier New", 25);
  textFont(myFont);
  text(testoInDraw, 10, height-codeScreenHeight + 20, width - chatWidth, codeScreenHeight/2 - 50);
  
  //Live coder executed code
  fill(0);
  noStroke();
  rect(0, height-codeScreenHeight/2 - 50, width - chatWidth, codeScreenHeight/2 + 50);
  fill(255);
  text(codeInDraw, 10, height-codeScreenHeight/2 - 50, width - chatWidth, codeScreenHeight/2 + 50);

  //User interactions shown as a sliding chat
  PFont myFontChat = createFont("Courier New", 16);
  textFont(myFontChat);
  fill(0);
  noStroke();
  rect(width-chatWidth, 0, chatWidth, height);
  fill(250);
  text(chat, width - chatWidth + 10, chatYposition, 330, chatLength);
 
  //Chat separator
  stroke(80);
  strokeWeight(2);
  line(width-chatWidth, height - codeScreenHeight + 30, width-chatWidth, height - 30);
  strokeWeight(1);
  
  println("Numero Borgs: " + borgs.size());
}


void sendosc(String param, float value){
  OscMessage msg = new OscMessage("/ctrl");
  msg.add(param);
  msg.add(value);
  oscP5.send(msg,remote);
}

void setDefaultState(){
  //schermata 1
  sendosc("pan",0.5);
  sendosc("crusher",1);
  sendosc("cutoff",400);
  sendosc("randoFloat",0);
  //schermata 2
  sendosc("every",2);
  sendosc("fast",1);
  sendosc("offset",0);
  sendosc("randomInt",0);
  defaultParamSent = true;
}

float discretizeNoOdd(float val){ 
  val = floor(val);
  if(val%2 != 0) val++;
  return val;
}

float discretizeScale(float val){ 
  if(val<0.2) return 0;
  else if(val<0.4) return 0.125;
  else if(val<0.6) return 0.25;
  else if(val<0.8) return 0.5;
  else if(val<=1) return 1;
  return val;
}

TidalParameter mapMessage(Interaction inter){
    
    TidalParameter map;
    
    //Disc 1
    //yellow
    if(inter.r==245 && inter.g==203 && inter.b==54) {
      map=new TidalParameter("cutoff",map(inter.value, 0, 1, 400, 15000));
      return map;
    }//light blue
    else if(inter.r==10 && inter.g==209 && inter.b==183){
      map=new TidalParameter("pan",inter.value);
      return map;
    }//magenta
    else if(inter.r==190 && inter.g==9 && inter.b==206) {
      map=new TidalParameter("crusher",map(inter.value, 0, 1, 1, 15));
      return map;
    }//blue
    else if(inter.r==6 && inter.g==48 && inter.b==189){
      map=new TidalParameter("randomFloat",inter.value);
      return map;
    
    //Disc 2
    //yellow
    }else if(inter.r==246 && inter.g==203 && inter.b==54) {
      map=new TidalParameter("randomInt",map(inter.value, 0, 1, 0, 15));
      map.value = ceil(map.value);
      return map;
    }//light blue
    else if(inter.r==11 && inter.g==209 && inter.b==183){
      map=new TidalParameter("offset",inter.value);
      map.value = discretizeScale(map.value);
      return map;
    }//magenta
    else if(inter.r==191 && inter.g==9 && inter.b==206) {
      map=new TidalParameter("every",map(inter.value, 0, 1, 1, 6));
      map.value = ceil(map.value);
      return map;
    }else{//blue
      map=new TidalParameter("fast",map(inter.value, 0, 1, 1, 6));
      map.value = floor(map.value);
      return map;
    }    
}

void requestData(){
  counter=0;
  msgs=client.get_msgs();
  if(msgs.length>0){
    for(int i=0;i<msgs.length;i++){
      
      Interaction currentInteraction=interaction.get(i);
      
      TidalParameter map=mapMessage(currentInteraction);
      
      createBorgs(currentInteraction,map.value);

      chat = chat + " --> " + currentInteraction.username + "\n    :: _" + map.param + " " + map.value + "\n";
    }
    
    chatYposition = chatYposition - (chatUpShift * msgs.length);
    chatLength += chatUpShift * msgs.length + 20;
    println(msgs.length + " nuovi messaggi");
    
  } 
  client.delete_all();
}

void increaseTimer(){
  client.increase_timer();
}

void setDefaultTimer(){
  client.set_default_timer();
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
  float x_child = (parent1.pos.x + parent2.pos.x)/2;
  float y_child = (parent1.pos.y + parent2.pos.y)/2;
  color color_child = parent1.c;
  String username_child = parent1.username + " § " + parent2.username;
  float value_child = (parent1.value + parent2.value)/2;
  float mappedValue=(parent1.mappedValue + parent2.mappedValue)/2;
  
  newChildColor = color_child; //set the text color
  
  //Mutation Process
  if(random(1)<mutationProbability){
    value_child = random(1);
    Interaction tempInteraction=new Interaction("userfake",int(red(color_child)),int(green(color_child)),int(blue(color_child)),value_child);
    mappedValue=mapMessage(tempInteraction).value;
    println("MutazioneGENETICA");
  }
  
  Borg child = new Borg(x_child, y_child, color_child, username_child, value_child,mappedValue);
  
  println("Nuovo figlio Generato. ** "+username_child+" **, value: "+ value_child);
  stroke(color_child);
  strokeWeight(6);
  circle(x_child, y_child, parent1.pos.sub(parent2.pos).mag()/2);
  strokeWeight(1);
  
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

  int size = borgs.size();

  if(size<=100) borgsDistance = 150;
  else if(size<=overpopulationLimit) borgsDistance = 100;
  else borgsDistance = 75;

  for (int a = 0; a < size; a++) {
    Borg p = borgs.get(a);
    for (int b = a+1; b < size; b++) {
      Borg q = borgs.get(b);
      PVector pq = new PVector(q.pos.x-p.pos.x, q.pos.y-p.pos.y);
      
      if (pq.mag()<=borgsDistance && p.c == q.c) {
        
        stroke(p.c);
        
        if(red(p.c)==245||red(p.c)==10||red(p.c)==190||red(p.c)==6){
          line(p.pos.x, p.pos.y, q.pos.x, q.pos.y);
        }else{
          if(p.mappedValue == q.mappedValue){
            int numSides=computeNumSides(p.mappedValue,q.mappedValue);
            polygon(p.pos, q.pos,p.pos.dist(q.pos)/2,numSides);
          }
        }
        
        if(canBeParent(p,q) && pq.mag()<=borgsDistance && pq.mag()>=borgsDistance-2 && borgs.size()<overpopulationLimit) generateChild(p,q);
      }
    }
  }
}

int computeNumSides(float valueP, float valueQ){
  int finalValue=ceil((valueP+valueQ)/2);
  if(finalValue<3) finalValue=3;
  return finalValue;
}

void polygon(PVector p, PVector q, float radius, int npoints) {
  float x = (p.x+q.x)/2;
  float y = (p.y+q.y)/2;
  PVector position = new PVector(x, y);
  float angle = TWO_PI / npoints;
  float angleShift = PVector.angleBetween(p, q);
  angleShift += map(position.mag(), 0, pow(pow(width-chatWidth, 2) + pow(height - codeScreenHeight, 2), 1/2), 0, PI/1000);
  beginShape();
  for (float a = angleShift; a < angleShift+TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
  
}

void createBorgs(Interaction inter, float mappedValue){
  float center_x = random(width - chatWidth - 50);
  float center_y = random(height - codeScreenHeight - 50);
  float r = map(inter.value, 0, 1, 1, 50);
  
  color c = color(inter.r, inter.g, inter.b);
  
  if(inter.r==245||inter.r==10||inter.r==190||inter.r==6) newBorgQuantity=3;
  else newBorgQuantity=2; 

  for (int i=0; i<newBorgQuantity; i++){
    float x = random(-1, 1)*random(10, r) + center_x;
    float y = random(-1, 1)*random(10, r) + center_y;
    
    borgs.add(new Borg(x, y, c, inter.username, inter.value, mappedValue));
    defaultParamSent = false;
  }
}

void oscEvent(OscMessage theOscMessage) {
  println("message arrived");
  if (theOscMessage.checkAddrPattern("/tidalcode")) {
    println(theOscMessage.get(0));
    incomingLine = (String)theOscMessage.get(0).stringValue();
    
    if (!theOscMessage.get(0).stringValue().equals(":{") && !theOscMessage.get(0).stringValue().equals(":}") && !theOscMessage.get(0).stringValue().equals("")){
      
      if(incomingLine.contains("setcps")){    
        String [] cps_segments = split(incomingLine, "(");
        String [] cps_values = split(cps_segments[1], "/");
        bpm = int(cps_values[0]);
        transparency = int(map(bpm, 80, 180, 5, 20));
      }
      
      codeBlock = codeBlock + " " + incomingLine;
      //println(codeBlock);
    }
    
    if(theOscMessage.get(0).stringValue().equals(":}")){
      codeInDraw = codeBlock.replaceAll("\t", " ");
      codeBlock = "";
    }
  }
}
