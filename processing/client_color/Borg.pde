class Borg {
  float x, y, vx, vy;
  PVector pos, vel;
  color c;
  float lifetime;
  String username;
  float value;

  public Borg() {
  }
  public Borg(float x, float y, color c, String username, float value) {
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
  }
  void update() {
    //this.vel.x += random(-0.01, 0.01);
    //this.vel.y += random(-0.01, 0.01);

    this.pos.x += this.vel.x;
    this.pos.y += this.vel.y;
    //this.x = (this.x + width ) % width;
    //this.y = (this.y + height) % height;

    if(this.pos.x<0 || this.pos.x>width-chatWidth - 1){
      this.vel.x = -this.vel.x;
    }
    if(this.pos.y<0 || this.pos.y>height-codeScreenHeight - 1){
      this.vel.y = -this.vel.y;
    }
    this.lifetime -= 0.01;
  }
  void draw() {
    //fill(255);
    //ellipse(x, y, 10, 10);
  }
}
