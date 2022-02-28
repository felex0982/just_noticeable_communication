// Inspiered by Daniel Shiffman PathFollow from - THE NATURE OF CODE
// Path Following
// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

ArrayList<Kinect> multiKinect;
ArrayList<Silhoutte> silhouttes;
ArrayList<Flock> flocks;
ArrayList<Tvertex> triangles;
ArrayList<PVector> tMs; 

PWindow win;
Kinect kinect;
// enable or disable colorDepth of Kinect
boolean colorDepth = false;
boolean ir = false;

int numDevices = 0;

//index to change the current device changes
int deviceIndex = 0;

float deg = 0;


//miniumum and maximum distance for drawing a point
int minD = 300;
int maxD = 750;
//scale factor - higher is bigger gaps between every vertexn 
int skip = 25;
//triangle size
int tSize = 35;
int minT = 50;
//number of movers
int mMax = 700;
int mMin = 30;
// Using this variable to decide whether to draw all the stuff
boolean debug = false;

boolean showvalues = true;
boolean scrollbar = true;


public void settings() {
  //size(900,900, P2D);
  fullScreen(P2D,2);
  
  //get the actual number of devices before creating them
  numDevices = Kinect.countDevices();
  println("number of Kinect v1 devices  "+numDevices);
  
  multiKinect = new ArrayList<Kinect>();
  silhouttes = new ArrayList<Silhoutte>();
  flocks = new ArrayList<Flock>();
  
 
  for (int i = 0; i < numDevices; i++){
    Kinect tmpKinect = new Kinect(this);
    tmpKinect.activateDevice(i);
    tmpKinect.initDepth();
    tmpKinect.initVideo();
    tmpKinect.enableColorDepth(colorDepth);
    multiKinect.add(tmpKinect);
    Silhoutte tmpSil = new Silhoutte();
    Flock tmpFlock = new Flock();
    color mColor = color (0);
    if(i == 0){mColor = color (30,0,0);}
    else if(i == 1){mColor = color (0,0,30);}
    for (int m = 0; m < mMin; m++) {
     tmpFlock.addMover(new Mover(mColor));
    }
    silhouttes.add(tmpSil);
    flocks.add(tmpFlock);
  }
    // Call a function to generate new Path object
  //setupScrollbars();
}

void setup() { 
  //win = new PWindow();
}

void draw() {
  background(255);
  updateFlocks();
  updateMovers();
  drawTriangles();
  drawMovers();
  //drawScrollbars();
  //if (showvalues) {
  //  fill(0);
  //  textAlign(LEFT);
  //  text("Framerate: " + round(frameRate),5,100);
  // }
}

void updateFlocks(){
  tMs = new ArrayList<PVector>();
  triangles = new ArrayList<Tvertex>();
  for(int i = 0; i < numDevices; i++){
    updateKinect(i);
    Silhoutte silhoutte = silhouttes.get(i);
    Flock flock = flocks.get(i);
    //silhoutte.run();
    flock.run(silhoutte.getAttractors());
    triangulate(flock);
  }
}

void updateMovers(){
  for(int i = 0; i < numDevices; i++){
    Silhoutte silhoutte = silhouttes.get(i);
    int attrCount = silhoutte.attractors.size();
    Flock flock = flocks.get(i);
    int movrCount = flock.movers.size();
    color mColor = color (0);
    if(i == 0){mColor = color (30,0,0);}
    else if(i == 1){mColor = color (0,0,30);}
    if(movrCount < mMax){
      if(attrCount > 2){
        flock.addMover(new Mover(mColor));
      }
    }
    if(attrCount <= 2){
      if(movrCount > mMin){
      int rmvM = movrCount-1;
      flock.removeMover(rmvM);
      }
    }
  }
}

void updateKinect(int ki) {
  
  Kinect kinectV1 = multiKinect.get(ki);
  Silhoutte silhoutte = silhouttes.get(ki);
  
  pushMatrix();
  translate(width/2, height/2);

  if(frameCount % 5 == 0){
    silhoutte.clearAttractors();
    int[] depth = kinectV1.getRawDepth();
    int cols = kinectV1.height / skip;
    int rows = kinectV1.width / skip;
    int y2 = 0;
    for(int y = 0; y < kinectV1.height; y+=skip){
      int x2 = 0;
      for (int x = 0; x < kinectV1.width; x+=skip){
        int offset = x + y * kinectV1.width;
        int d = depth[offset];
        if(d > minD && d < maxD) {
          PVector point = drawDepthPoint(x,y,d);
          PVector aPos = new PVector((point.x*(-1)), point.y);
          silhoutte.addAttractor(new Attractor(aPos));
          if(debug == true){
            drawAttractor(aPos);
          }
        }
        if(x2<rows-1){x2++;}
      }
      if(y2<cols-1){y2++;}
    }
  }
  
  if(silhoutte.getListCount() < 1){
    PVector posV = new PVector(0, 1);
    if(ki==0){
      posV.x = 0;
      posV.y = 1;
    }
    if(ki==1){
      posV.x = 0;
      posV.y = 1;
    }
    silhoutte.addAttractor(new Attractor(posV));
  }
  popMatrix();
}

void triangulate(Flock flock){
  Mover m1, m2;
  int flockSize = flock.movers.size(); 
  for (int i = 0; i < flockSize; i++){
    m1 = flock.movers.get(i);
    m1.neighboors = new ArrayList<Mover>();
    m1.neighboors.add(m1);
    for (int j = i+1; j < flockSize; j++){
      m2 = flock.movers.get(j);
      float d = PVector.dist(m1.position,m2.position);
      if (d > 0 && d < tSize){
        m1.neighboors.add(m2);
      }
    }
    if(m1.neighboors.size() > 1){
      addTriangles(m1.neighboors);
    }
  }
}

void drawTriangles(){
  pushMatrix();
  translate(width/2,height/2);
  noStroke();
  
  for(Tvertex v : triangles){
     beginShape();
     fill(v.tColor,60);
     v.display();
     endShape(CLOSE);
  }
  popMatrix();
}

void drawMovers(){
  pushMatrix();
  translate(width/2,height/2);
  stroke(50);
  strokeWeight(2);
  noFill();
  beginShape(POINTS);
  for(PVector v : tMs){
    vertex(v.x, v.y);
  }
  endShape();
  popMatrix();
}

void drawAttractor(PVector posV){
  pushMatrix();
  translate(posV.x, posV.y);
  fill(255,80,0);
  ellipse(0, 0, 5, 5);
  popMatrix();
}


void addTriangles(ArrayList<Mover> mNeighboors){
  int s = mNeighboors.size();
  if (s > 2){
    for (int i = 1; i <s-1; i++){
      for (int j = i+1; j < s; j++){
        triangles.add(new Tvertex(mNeighboors.get(0).position,mNeighboors.get(i).position,mNeighboors.get(j).position, mNeighboors.get(0).mColor));
      }
    }
  }
}

PVector drawDepthPoint(int x, int y, float depthValue){
  PVector point = new PVector();
  point.z = (depthValue);
  point.x = (x - CameraParams.cx) * point.z / CameraParams.fx;
  point.y = (y - CameraParams.cy) * point.z / CameraParams.fy;
  return point;
}

public void keyPressed() {
  if (key == 'a') {
    println("a");
  }
} //<>//
