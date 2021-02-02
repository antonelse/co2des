class Borg {
  float x, y, vx, vy;
  PVector pos, vel;
  color c;
  float lifetime;
  String username;
  float value;
  float mappedValue;

  public Borg(float x, float y, color c, String username, float value,float mappedValue) {
    this.x = x;
    this.y = y;
    this.pos = new PVector(x, y);
    this.vx = random(-1, 1);
    this.vy = random(-1, 1);
    this.vel = new PVector(vx, vy);
    this.c = c;
    this.lifetime = random(5, 10);
    this.username = username;
    this.value = value;
    this.mappedValue=mappedValue;
  }

  void update() {

    this.pos.x += this.vel.x;
    this.pos.y += this.vel.y;

    if(this.pos.x<0 || this.pos.x>width-chatWidth - 1){
      this.vel.x = -this.vel.x;
    }
    if(this.pos.y<0 || this.pos.y>height-codeScreenHeight - 1){
      this.vel.y = -this.vel.y;
    }
    
    this.lifetime -= 0.01;
  }

  void draw() {
    fill(255);
    ellipse(x, y, 10, 10);
  }
}
