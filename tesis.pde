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

//


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
  
  canvas = new Canvas(c, 50, 50, tablet);
  canvas.setUsingTablet(false);
  canvas.drawCanvas();
  colorMode(HSB, 360, 100, 100);
  
  //frameRate(30);
  frameRate(IDLE);
}

void draw() {  
  // background(0,0, 100);
  if (mousePressed) {
    canvas.drawPoints();
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
}
