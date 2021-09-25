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
PFont font;
color green = color(59, 170, 85); // font color
boolean firstClicked = true;


// modes
byte IDLE = 5;
byte DRAW = 40;
byte PLAY = 10;
// idle by default
byte mode = IDLE;
boolean displayScene = false;
//
int cOffX = 50;
int cOffY = 50;


void setup() {
  size(780, 600, P2D);
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 0);
  font = loadFont("CourierNewPSMT-48.vlw");
  textFont(font, 12);
  // NETWORK
  // listening port 
  oscP5 = new OscP5(this, 667);  
  // sending port
  myRemoteLocation = new NetAddress("127.0.0.1", 666);
  
  // surface.setResizable(true);
  c = createGraphics(500, 500, P2D);
  tablet = new Tablet(this);   //<>// //<>//
  canvas = new Canvas(c, cOffX, cOffY, tablet);
  canvas.setUsingTablet(false);
  canvas.drawCanvas();
  frameRate(IDLE);    
}

void draw() {  
  background(0, 0, 0);
  if (mousePressed && mode != PLAY) {
    canvas.drawPoints(firstClicked);
    firstClicked = false;
  } else {
    canvas.drawCanvas();
  }
    
  if (mode == PLAY && traj.size() > 0) {
    oscP5.send(traj.get(ti), myRemoteLocation);
    stroke(green);
    strokeWeight(8);
    Point p = points.get(ti);
    point(p.x+50, p.y+50);
    ti++; if (ti >= traj.size()) { ti = 0;}
  }
  //println(brightness(get(mouseX, mouseY)));
  fill(green);
  text("TRAJ POINTS: "+canvas.points.size(), 50, height -30);
}


void mousePressed() {
  
  if(mode != PLAY) {
    firstClicked = true;
    mode = DRAW;
    frameRate(DRAW);
  }  
}

void mouseMoved() {
  firstClicked = false;
}

void mouseReleased() {
  if(mode != PLAY) {
    frameRate(IDLE);
    firstClicked = false;
    // set END cmp to last path point
    canvas.closePath();
    canvas.renderPoints();
  }
}

void keyPressed() {  
// clearCanvas
  if (keyPressed && key == 'q') {
    canvas.removePoints();
    canvas.drawCanvas();
    canvas.prev = null;
    mode = IDLE;
  }
  if (keyPressed && key == 's') {
    canvas.saveTrajectory();
    canvas.loadTrajBundles();
    traj = canvas.traj;
    points = canvas.points;
    //println("traj len: "+ traj.size());
  }
  
  if (keyPressed && key == 'p') {
    mode = PLAY;
    frameRate(mode);
  }
  
  if (keyPressed && key == 'o') {
    mode = IDLE;
    frameRate(mode);
  }
  
  if (keyPressed && key == 'd') {
     displayScene = true;
  } 
}

void keyReleased() {
   displayScene = false;
}
