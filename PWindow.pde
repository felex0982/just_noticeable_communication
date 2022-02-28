class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(900, 900, P2D);
  }

  void setup() {
    background(150);
  }

  void draw() {
    background(255);
    drawTriangles();
  }
}
