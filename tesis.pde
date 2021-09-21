import controlP5.*;
import processing.javafx.PGraphicsFX2D;
import codeanticode.tablet.*;
import oscP5.*;
import netP5.*;

// libraries
ControlP5 Cp5;
Tablet tablet;
OscP5 oscP5;
NetAddress myRemoteLocation;
//current traj
ArrayList<Point> points = new ArrayList<Point>();
ArrayList<OscBundle> traj = new ArrayList<OscBundle>();
// traj index
int ti;

// scene array
String [] defaultScene = {"L", "R"};
String [] defaultReverb = {"L", "R"};
ArrayList<PImage> scene = new ArrayList<PImage>();
ArrayList<PImage> sceneReverb = new ArrayList<PImage>();

//
PGraphics c;
Canvas canvas;
boolean isDrawing = false;

// modes
byte IDLE = 10;
byte DRAW = 40;
byte PLAY = 20;
// idle by default
byte mode = IDLE;
boolean displayScene = false;
//
int cOffX = 50;
int cOffY = 50;

void setup() {
  size(600, 600, P2D);
  
  // NETWORK
  // listening port 
  oscP5 = new OscP5(this, 667);  
  // sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 666);
  
  // surface.setResizable(true);
  c = createGraphics(500, 500, P2D);
  //fullScreen();
  background(255);
  tablet = new Tablet(this); //<>//
  
  canvas = new Canvas(c, cOffX, cOffY, tablet);
  canvas.setUsingTablet(false);
  canvas.drawCanvas();
  colorMode(HSB, 360, 100, 100);
  
  //frameRate(30);
  frameRate(IDLE);
  
  // load scene
  for(int i = 0; i< defaultScene.length ; i++){
    scene.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
    sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
  }
}

void draw() {  
  // background(0,0, 100);
  if (mousePressed) {
    canvas.drawPoints();
  }  
  
  if(displayScene) {
    displayScene();
  }
  
  if (mode == PLAY) {
    oscP5.send(traj.get(ti), myRemoteLocation);
    stroke(0, 90, 50);
    strokeWeight(2);
    Point p = points.get(ti);
    point(p.x+50, p.y+50);
    ti++; if (ti >= traj.size()) { ti = 0;}
  }  
}


void mousePressed() {
  isDrawing = true;
  mode = DRAW;
  frameRate(DRAW);
}

void mouseReleased() {
  frameRate(IDLE);
  isDrawing = false;
  // set END cmp to last path point
  canvas.closePath();
  canvas.renderPoints();
}

void keyPressed() {
  
// clearCanvas
  if (keyPressed && key == 'q') {
    canvas.removePoints();
    canvas.drawCanvas();
    canvas.prev = null;
  }
  if (keyPressed && key == 's') {
    canvas.saveTrajectory();
    canvas.loadTrajBundles();
    traj = canvas.traj;
    points = canvas.points;
    println("traj len: "+ traj.size());
  }
  
  if (keyPressed && key == 'p') {
    mode = PLAY;
    frameRate(PLAY);
  }
  
  if (keyPressed && key == 'd') {
     displayScene = true;
  } 
}

void keyReleased() {
   displayScene = false;
}

void displayScene() {
 // scene 
 for(int i = 0; i< defaultScene.length ; i++){
    tint(255, 10);
    image(scene.get(i), cOffX, cOffY);
    noTint();
   // sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
 }
 
 // reverb
 for(int i = 0; i< defaultScene.length ; i++){
   // scene.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
   // sceneReverb.add(loadImage("data/scenes/default/" + defaultScene[i] + ".png"));
  }
}
