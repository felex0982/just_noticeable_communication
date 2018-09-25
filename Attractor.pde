
class Attractor{
  float mass;
  float G;
  PVector position;
  int size;
  
  Attractor(){
    position = new PVector(int(random(0,width)),int(random(0,height)));
    mass = 20;
    G = 1;
    size = 10;
  }
  
  Attractor(PVector p){
    position = p;
    mass = 20;
    G = 1;
    size = 10;
  }
  
  public void run(){
    display();
  }

  void changePositionTo(PVector newPos){
    position = newPos;
}


  void display(){
    pushMatrix();
    translate(width/2, height/2);
    fill(255,0,0);
    ellipse(position.x, position.y,size,size);
    popMatrix();
  }

}