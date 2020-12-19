class Borg {
  float x, y, vx, vy;
  color c;

  public Borg() {
  }
  public Borg(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.vx = random(-0.1, 0.1);
    this.vy = random(-0.1, 0.1);
    this.c = c;
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
    if(this.y<0 || this.y>height){
      this.vy = -this.vy;
    }
  }
  void draw() {
    fill(255);
    //ellipse(x, y, 10, 10);
  }
}
