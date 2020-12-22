class Borg {
  float x, y, vx, vy;
  color c;
  float lifetime;

  public Borg() {
  }
  public Borg(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.vx = random(-1, 1);
    this.vy = random(-1, 1);
    this.c = c;
    this.lifetime = random(5, 10);
  }
  void update() {
    this.vx += random(-0.01, 0.01);
    this.vy += random(-0.01, 0.01);

    this.x += this.vx;
    this.y += this.vy;
    //this.x = (this.x + width ) % width;
    //this.y = (this.y + height) % height;

    if(this.x<0 || this.x>width){
      this.vx = -this.vx;
    }
    if(this.y<0 || this.y>height-codeScreenHeight - 1){
      this.vy = -this.vy;
    }
    this.lifetime -= 0.01;
  }
  void draw() {
    //fill(255);
    //ellipse(x, y, 10, 10);
  }
}
