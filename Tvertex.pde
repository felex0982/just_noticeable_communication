class Tvertex{
  PVector position1;
  PVector position2;
  PVector position3;
  color tColor;
  
  Tvertex(PVector p1, PVector p2, PVector p3){
    position1 = p1;
    position2 = p2;
    position3 = p3;
    tColor = color (0);
  }
  
  Tvertex(PVector p1, PVector p2, PVector p3, color c1){
    position1 = p1;
    position2 = p2;
    position3 = p3;
    tColor = c1;
  }
  
  public void display(){
    vertex(position1.x,position1.y);
    vertex(position2.x,position2.y);
    vertex(position3.x,position3.y);
  }
  
}