
float swt = 1.4285715;
float arwt = 0.3809524;
float maxspeed = 3.5;
float maxforce = 0.06;

//swt: 1.4285715 arwt: 0.3809524 maxspeed: 5.0 maxforce: 0.05952381
class Mover{

PVector position;
PVector velocity;
PVector acceleration;
float mass;
int size;
color mColor;
ArrayList<Mover> neighboors;
Attractor record;


Mover() {
  mass=1;
  size=5;
  position = new PVector(int(random(width*-0.5,width/2)),int(random(height*-0.5,height/2)));
  velocity = new PVector(maxspeed,0);
  acceleration = new PVector(0,0);
  mColor = 0;
}

Mover(color c) {
  mass=1;
  size=15;
  position = new PVector(int(random(width*-0.5,width/2)),int(random(height*-0.5,height/2)));
  velocity = new PVector(0,0);
  acceleration = new PVector(0,0);
  mColor = c;
}

public void run(ArrayList<Mover> movers,ArrayList<Attractor> attractors){
  flock(movers,attractors);
  update();
  //display();
  exportPos();
}

void flock(ArrayList<Mover> movers,ArrayList<Attractor> attractors){
  PVector sep = separate(movers);
  PVector arr = arrive(attractors);
  
  sep.mult(swt);
  arr.mult(arwt);
  
  applyForce(sep);
  applyForce(arr);
}

void applyForce(PVector force){
  PVector f = PVector.div(force,mass);
  acceleration.add(f);
}
  

void update(){
  velocity.add(acceleration);
  position.add(velocity);
  velocity.limit(maxspeed);
  acceleration.mult(0);
}

void display(){
  pushMatrix();
  translate(width/2, height/2);
  fill(mColor);
  noStroke();
  ellipse(position.x,position.y,3,3);
  popMatrix();
}

void exportPos(){
  tMs.add(new PVector(position.x,position.y));
}

PVector seek(PVector target){
  PVector desired = PVector.sub(target, position);
  desired.setMag(maxspeed);
  PVector steer = PVector.sub(desired,velocity);
  steer.limit(maxforce);
  return steer;
}

PVector findDirection(ArrayList<Attractor> attractors){
    float record = position.dist(attractors.get(0).position);
    PVector direction = attractors.get(0).position;
    for(int t = 0; t < attractors.size(); t++){
      float tempRecord = position.dist(attractors.get(t).position);
      if(tempRecord < record){
        record = tempRecord;
        direction = attractors.get(t).position;
      }
    }
  return direction;
}

PVector arrive(ArrayList<Attractor> attractors){
  
  PVector target = findDirection(attractors);
  PVector desired = PVector.sub(target,position);
  float d = desired.mag();
  
  if(d < 100){
    float m = map(d,0,100,0,maxspeed);
    desired.setMag(m);
  } else{
    desired.setMag(maxspeed);
  }
  // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
}

PVector separate (ArrayList<Mover> movers) {
    float desiredseparation = 25.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Mover other : movers) {
      float d = PVector.dist(position,other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position,other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

}
